//功能：获取iSerial(审批序号)节点的审批人checkman，并插入表SysMessage，并设置当前表中的审批流进入下一节点（iCheckSerial)=iSerial；
//注意：此函数未判断单据状态
//如果iSerial=1表示提交，还要更新当前表中的iStauts=2(提交待审批)
//如果审批人为提交人,则先判断下是否存在下一审批序号，不存在的话，则当前单据审批完成；存在的话，先要执行审批前检测和审批执行语句，再直接转到下一节点
//iformid:FORMID表单号，fieldkey:当前单据主键号,iSerial当前审批序号，checkSqlStr从审批函数中传过来的要执行的语句
//加推送处理。推送用在分支条件不是表单域中的字段时
function ProcToNext(iformid, fieldkey, iSerial, checkSqlStr, issubmit) {
    var tablename;
    var mainkey;
    var sqlcomm = "select GUID,iSerial,sCheckName,sCheckPerson,sContion,sNextPushInform,iNoPushSerial,iPushSerial from bscDataBillD where iFormID=" + iformid + " and iSerial=" + iSerial;
    var tabcheckpro = SqlGetDataComm(sqlcomm);
    var sqlupdatestr = "";
    if (tabcheckpro.length > 0) {
        try {
            //var sqltext = "";
            for (var i = 0; i < tabcheckpro.length; i++) {
                var sqlbill = "select sTableName,sFieldKey,sShowSql,sProTitle,sAppProTitle,sBillType,sFieldKey from bscDataBill where iFormID=" + iformid; //从表单定义从获取打开SQL和流程主题
                var billdata = SqlGetDataComm(sqlbill)[0];
                var sqlbillcomm = SqlGetDataComm(sqlbill)[0].sShowSql;
                tablename = billdata.sTableName;
                mainkey = billdata.sFieldKey;

                var sqlformstr = "select " + mainkey + ",sUserId from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
                var curtformdata = SqlGetDataComm(sqlformstr)[0]; //当前提交表单的数据

                //解析流程主题
                var title = SqlGetDataComm(sqlbill)[0].sProTitle;
                var appTitle = SqlGetDataComm(sqlbill)[0].sAppProTitle;
                title = title.replace(/{userid}/g, getCurtUserID());
                appTitle = appTitle.replace(/{userid}/g, getCurtUserID());
                var protitle = "";
                var appProTitle = "";
                if (iSerial == 1 || issubmit == true) {
                    if (title.length == 0) {
                        protitle = billdata.sBillType + ":" + billdata.sFieldKey + " " + curtformdata[billdata.sFieldKey];
                    }
                    else {
                        var sqltitle = "select" + title + " as title from (" + sqlbillcomm + ") as A where " + mainkey + "='" + fieldkey + "'";
                        sqltitle = sqltitle.replace(/{userid}/g, getCurtUserID());
                        protitle = SqlGetDataComm(sqltitle)[0].title;
                        if (protitle == "") {
                            protitle = billdata.sBillType + ":" + billdata.sFieldKey + " " + curtformdata[billdata.sFieldKey];
                        }
                    }
                    if (appTitle.length == 0) {
                        appProTitle = billdata.sBillType + ":" + billdata.sFieldKey + " " + curtformdata[billdata.sFieldKey];
                    }
                    else {
                        //appProTitle = billdata.sBillType + ":" + billdata.sFieldKey + " " + curtformdata[billdata.sFieldKey];
                        var sqltitle = "select" + appTitle + " as title from (" + sqlbillcomm + ") as A where " + mainkey + "='" + fieldkey + "'";
                        sqltitle = sqltitle.replace(/{userid}/g, getCurtUserID());
                        appProTitle = SqlGetDataComm(sqltitle)[0].title;
                        if (appProTitle == "") {
                            appProTitle = billdata.sBillType + ":" + billdata.sFieldKey + " " + curtformdata[billdata.sFieldKey];
                        }
                    }
                }
                else {
                    var sqltitle1 = "select top 1 sContent from SysMessage where iformid='" + iformid + "' and iBillRecNo='" + fieldkey + "'";
                    protitle = SqlGetDataComm(sqltitle1)[0].sContent;
                }
                var checkman = ""; //处理人
                var submitter = ""; //提交人
                //获取提交人
                for (var o in curtformdata) {
                    if (o.toUpperCase() == "SUSERID") {
                        submitter = curtformdata[o];
                        break;
                    }
                }
                //获取下一审批人
                var checkperson = ProGetNextPerson(iformid, fieldkey, iSerial);
                if (checkperson==undefined||checkperson.Name.length == 0) {
                    alert("获取处理人失败！");
                    return false;
                }
                else if (checkperson.Name.length == 1) {
                    if (iSerial == 1 || issubmit == true) {
                        //checkperson = ProGetNextPerson(iformid, fieldkey, iSerial);
                        if (checkperson.Name[0] == submitter) {//如果提交人就是审批人
                            var sqlresult = ProcAgreeDeal(iformid, fieldkey, checkperson.GUID, checkSqlStr, true);
                            if (sqlresult.length > 0) {
                                if (sqlresult.split("^|^")[0] != "1") {//第一位不是"1"表示有下一审批流
                                    checkperson = ProGetNextPerson(iformid, fieldkey, sqlresult.split("^|^")[0]);
                                    var sqltext = sqlresult.split("^|^")[1];
                                    if (checkperson.Name[0] != submitter) {
                                        /*create TABLE #tmp(r varchar(1000) null) insert into #tmp exec SpSubmitAndCancel " + iformid + ",1,'" + fieldkey + "','" + getCurtUserID() + "',1 " +
                                        "if exists(select 1 from #tmp where r<>'1') begin declare @r varchar(1000) select @r=r from #tmp raiserror(@r,16,1) return end */
                                        sqltext =
                                    " BEGIN TRY BEGIN TRANSACTION " + sqltext +
                                    " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,sProGUID) values" + "(" + sqlresult.split("^|^")[0] + "," + iformid + ",'" + submitter + "','" + checkperson.Name[0] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') " +
                                    " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                                        sqlupdatestr = sqltext;
                                        //ProcToNext(iformid, fieldkey, sqlresult.split("^|^")[0], sqltext, false);
                                    }
                                    else {
                                        sqltext += " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,dDealDate,sProGUID) values" + "(" + sqlresult.split("^|^")[0] + "," + iformid + ",'" + submitter + "','" + checkperson.Name[0] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",1,0,'" + getNowDate() + " " + getNowTime() + "','" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') ";
                                        ProcToNext(iformid, fieldkey, sqlresult.split("^|^")[0], sqltext, true);
                                    }
                                }
                                else if (sqlresult.split("^|^")[0] == "1") { //第一位是"1"表示审批结束
                                    //是否有审批后发送消息
                                    var sqlcheckuser = "";
                                    var checkUserComm = "select sUserID from bscDataBillDUser where iFormID='" + iformid + "'";
                                    var checkUserData = SqlGetDataComm(checkUserComm);
                                    for (var i = 0; i < checkUserData.length; i++) {
                                        var checkperson = GetPersonByCode(iformid, fieldkey, checkUserData[i]);
                                        for (var j = 0; j < checkperson.length; j++) {
                                            sqlcheckuser += " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,iType) " +
                                            " values (-1," + iformid + ",'" + getCurtUserID() + "','" + checkperson[j] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "',2) ";
                                        }
                                    }
                                    var sqlupdatestr =
                                " BEGIN TRY BEGIN TRANSACTION " + sqlresult.substr(4, sqlresult.length - 4) + sqlcheckuser +
                                " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,dDealDate,sProGUID) values" + "(" + sqlresult.split("^|^")[0] + "," + iformid + ",'" + submitter + "','" + checkperson.Name[0] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",1,0,'" + getNowDate() + " " + getNowTime() + "','" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') " +
                                " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                                }
                            }
                            else {
                                return false;
                            }
                        }
                        else {
                            sqlupdatestr += "BEGIN TRY BEGIN TRANSACTION " + checkSqlStr +
                                    " update " + tablename + " set iCheckSerial=" + iSerial + ",iStatus=2 where " + mainkey + "=" + fieldkey + " " +
                                    "insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,sProGUID) values" + "(" + tabcheckpro[i].iSerial + "," + iformid + ",'" + submitter + "','" + checkperson.Name[0] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') " +
                                    " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                        }
                    }

                    else if (iSerial != 1 && issubmit != true) {
                        sqlupdatestr += "BEGIN TRY BEGIN TRANSACTION " + checkSqlStr +
                                    " update " + tablename + " set iCheckSerial=" + iSerial + " where " + mainkey + "=" + fieldkey + " " +
                                    "insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,sProGUID) values" + "(" + tabcheckpro[i].iSerial + "," + iformid + ",'" + submitter + "','" + checkperson.Name[0] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') " +
                                    " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                    }
                }
                else if (checkperson.Name.length > 1) {
                    for (var p = 0; p < checkperson.Name.length; p++) {
                        if (checkperson.Name[p].toUpperCase() == submitter.toUpperCase()) {
                            continue;
                        }
                        sqlupdatestr += "insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,sProGUID) values" + "(" + tabcheckpro[i].iSerial + "," + iformid + ",'" + submitter + "','" + checkperson.Name[p] + "','" + protitle + "','" + appProTitle + "'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "','" + checkperson.GUID + "') ";
                    }
                    if (iSerial == 1)//如果是提交， 同时有多个审批人，不去判断是否是就是提交人
                    {
                        sqlupdatestr = "BEGIN TRY BEGIN TRANSACTION " + checkSqlStr + " update " + tablename + " set iStatus=2,iCheckSerial=" + iSerial + " where " + mainkey + "=" + fieldkey + " " +
                                sqlupdatestr + " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                    }
                    else {
                        sqlupdatestr = "BEGIN TRY BEGIN TRANSACTION " + checkSqlStr + "  update " + tablename + " set iCheckSerial=" + iSerial + " where " + mainkey + "=" + fieldkey + ";" +
                                sqlupdatestr + " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                    }
                }
                var result = SqlExecComm(sqlupdatestr);
                if (result == "1") {
                    return true;
                }
                else {
                    alert(result);
                    return false;
                }
            }
        }
        catch (e) {
            alert(e.message);
            return false;
        }
    }
    else {
        //alert("审批")
        alert("未定义审批步1");
        return false;
    }

}
//功能：只是设置当前istatus、审批人、审批时间
function ProcAgree(SysmessRecNo, agreemess) {
    //当前单据数据
    //var tablename;
    //var mainkey;
    var fieldkey;
    var iformid;
    var sProGUID;
    //var sqlbillcomm;
    var sqlsysmess = "select iFormid,sProGUID,sContent,sAppContent,iBillRecNo,iMessageType,iType from SysMessage where iRecNo=" + SysmessRecNo + " and isnull(iRead,0)=0";
    //iMessageType=0或空表示同意操作，1为退回操作,2表示撤销操作。itype=0或空表示此节点是正常节点，为1表示退回后的节点,为2表示审批后发送消息节点。
    var sysmessdata = SqlGetDataComm(sqlsysmess);
    if (sysmessdata.length > 0) {
        iformid = sysmessdata[0].iFormid;
        sProGUID = sysmessdata[0].sProGUID;
        fieldkey = sysmessdata[0].iBillRecNo;
        var Title = sysmessdata[0].sContent;
        var appTitle = sysmessdata[0].sAppContent;
        if (sysmessdata[0].iType == "1") {
            //提交时要判断有没有定义存储过程或者JS代码
            var queryObj = {
                TableName: "View_Yww_UserRight_Unique",
                Fields: "sStoredProce,sJsCode",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + iformid + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + getCurtUserID() + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sRightName",
                        ComOprt: "=",
                        Value: "'submit'"
                    }
                ]
            };
            var execStr = "";
            var reusltData = SqlGetData(queryObj);
            if (reusltData.length > 0) {
                if (reusltData[0].sStoredProce != "") {
                    execStr += "create table #tmp(r varchar(50) null) insert into #tmp  exec " + reusltData[0].sStoredProce + " " + "'" + iformid + "','" + fieldkey + "','" + getCurtUserID() + "','submit'";
                    execStr += " if exists(select 1 from #tmp where r<>'1')begin declare @error0 nvarchar(50) select @error0=r from #tmp raiserror(@error0,16,1)  drop table #tmp return end  drop table #tmp ";
                }
                else if (reusltData[0].sJsCode != "") {
                    var jsCode = reusltData[0].sJsCode.replace(/<%userid%>/g, getCurtUserID()).replace(/<%selectedkey%>/g, fieldkey);
                    eval("(" + jsCode + ")");
                }
            }

            var updatestr = execStr + " update SysMessage set iRead=1,sCheckIdeal='" + agreemess + "',dDealDate='" + getNowDate() + " " + getNowTime() + "' where iRecNo='" + SysmessRecNo + "'";
            return ProcToNext(iformid, fieldkey, 1, updatestr, true);
            //return true;
        }
        var sqlresult = ProcAgreeDeal(iformid, fieldkey, sProGUID, "");
        if (sqlresult.length > 0) {
            if (sqlresult == "-1") {
                return "-1";
            }
            if (sqlresult.split("^|^")[0] != "1" && sqlresult.split("^|^")[0] != "0") {//第一位不是"1"或者"0"表示有下一审批流
                var sqltext = sqlresult.split("^|^")[1] +
                " update SysMessage set iRead=1,sCheckIdeal='" + agreemess + "',dDealDate='" + getNowDate() + " " + getNowTime() + "' where iRecNo=" + SysmessRecNo;
                return ProcToNext(iformid, fieldkey, sqlresult.split("^|^")[0], sqltext, false);
            }
            else if (sqlresult.split("^|^")[0] == "1") { //第一位是"1"表示审批结束
                //是否有审批后发送消息
                var sqlcheckuser = "";
                var checkUserComm = "select sUserID from bscDataBillDUser where iFormID='" + iformid + "'";
                var checkUserData = SqlGetDataComm(checkUserComm);
                for (var i = 0; i < checkUserData.length; i++) {
                    var checkperson = GetPersonByCode(iformid, fieldkey, checkUserData[i].sUserID);
                    for (var j = 0; j < checkperson.length; j++) {
                        sqlcheckuser += " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,sAppContent,iBillRecNo,iRead,iMessageType,dinputDate,iType) " +
                        " values (-1," + iformid + ",'" + getCurtUserID() + "','" + checkperson[j] + "','" + Title + "','"+appTitle+"'," + fieldkey + ",0,0,'" + getNowDate() + " " + getNowTime() + "',2) ";
                    }
                }
                var sqltext = "BEGIN TRY BEGIN TRANSACTION " + " update SysMessage set iRead=1,sCheckIdeal='" + agreemess + "',dDealDate='" + getNowDate() + " " + getNowTime() + "' where iRecNo=" + SysmessRecNo + " " +
                sqlresult.substr(4, sqlresult.length - 4) + sqlcheckuser +
                " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                var execResult = SqlExecComm(sqltext);
                if (execResult != "1") {
                    alert(execResult);
                    return false;
                }
                else {
                    return true;
                }
            }
            else if (sqlresult.split("^|^")[0] == "0")//第一位是"0"表示会签且不结束不流下一节点
            {
                var sqltext = " update SysMessage set iRead=1,sCheckIdeal='" + agreemess + "',dDealDate='" + getNowDate() + " " + getNowTime() + "' where iRecNo=" + SysmessRecNo;
                var execResult = SqlExecComm(sqltext);
                if (execResult != "1") {
                    alert(execResult);
                    return false;
                }
                else {
                    return true;
                }
            }
        }
        else {
            return false;
        }
    }
    else {
        alert("不存在此审批任务或任务已处理！");
        return false;
    }
}
//功能：处理审批同意，返回审批语句。如果返回""表示失败，返回"0"开头表示会签的不流入下一节点的，返回"1"开头的字符串表示流程审批结束，返回其他表示要到下一节点。返回语句^|^之前是的下一审批序号
function ProcAgreeDeal(iformid, fieldkey, ProGUID, sqlstr, issubmit) {
    //当前单据数据
    var tablename;
    var mainkey;
    //var fieldkey;
    var iformid;
    var sProGUID;
    var sqlbillcomm;
    var sqlbill = "select sShowSql,sTableName,sFieldKey from bscDataBill where iFormID=" + iformid; //从表单定义从获取打开SQL和流程主题
    //if (SqlGetDataComm(sqlbill).length==0)
    var billdata = SqlGetDataComm(sqlbill)[0];
    if (billdata == undefined || billdata == null) {
        alert("单据定义不存在！")
        return "";
    }
    sqlbillcomm = SqlGetDataComm(sqlbill)[0].sShowSql.replace(/{userid}/g, getCurtUserID()).replace(/{condition}/, "1=1");
    tablename = SqlGetDataComm(sqlbill)[0].sTableName;
    mainkey = SqlGetDataComm(sqlbill)[0].sFieldKey;
    //fieldkey = sysmessdata[0].iBillRecNo;

    var sqlcurtform = "select * from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
    var curtformdata = SqlGetDataComm(sqlcurtform)[0];

    //审批流信息
    var sqlcomm = "select * from bscDataBillD where GUID='" + ProGUID + "'";
    var prodata = SqlGetDataComm(sqlcomm);

    if (prodata.length > 0) {
        //1、同意前检测是否为空，不为空执行，为空跳过
        //var result_step1 = false; // 第一步结果(同意前检测)
        var sbeforeagree = prodata[0].sBeforeAgree.replace(/{userid}/, getCurtUserID());
        if (sbeforeagree.length > 0) {
            //如果同意前检测不为空，则先替换其中的{}字段
            while (sbeforeagree.indexOf("{") > -1) {
                var bindex = sbeforeagree.indexOf("{");
                var eindex = sbeforeagree.indexOf("}");
                var fieldid = sbeforeagree.substr(bindex + 1, eindex - bindex - 1);
                if (sbeforeagree.indexOf("{" + fieldid + "}") > -1) {
                    sbeforeagree = sbeforeagree.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                else {
                    alert("对不起，同意前检测中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                    return "";
                }
            }
            var beforeagree_result = SqlGetDataComm(sbeforeagree);
            if (beforeagree_result.length > 0) {
                for (var o in beforeagree_result[0]) {
                    if (beforeagree_result[0][o] == "" || beforeagree_result[0][o] == "1") {
                        break;
                    }
                    else {
                        alert(beforeagree_result[0][o] + ",同意前检测失败！");
                        return "";
                    }
                }
            }
            else {
                alert("同意前检测无返回结果，不合法！");
                return "";
            }
        }
        //解析通过执行语句
        var sactionagree = prodata[0].sActionAgree.replace(/{userid}/, getCurtUserID());
        if (sactionagree.length > 0) {
            while (sactionagree.indexOf("{") > -1) {
                var bindex = sactionagree.indexOf("{");
                var eindex = sactionagree.indexOf("}");
                var fieldid = sactionagree.substr(bindex + 1, eindex - bindex - 1);
                if (sactionagree.indexOf("{" + fieldid + "}") > -1) {
                    sactionagree = sactionagree.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                else {
                    alert("对不起，通过执行语句中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                    return "";
                }
            }
        }

        var nextiSerial;
        var checkperson;

        //是否推送，sNextPushInform字段有内容则表示需推送
        if (prodata[0].sNextPushInform != "") {
            //是否定义不推送下一节点，和推送下一节点
            if (prodata[0].iNoPushSerial == "" || prodata[0].iPushSerial == "") {
                alert("当需推送时，必须指定推送下一节点和不推送下一节点！")
                return "";
            }

            var aa = myConfirm("需要推送至[" + prodata[0].sNextPushInform + "]吗？");
            if (aa == 6) {
                //如果选择了推送，则先获取下一节点审批序号
                nextiSerial = parseInt(prodata[0].iPushSerial);
                //审批人
                checkperson = ProGetNextPerson(iformid, fieldkey, nextiSerial);
                if (checkperson.Name.length == 0) {
                    alert("获取下一审批人失败！");
                    return "";
                }
            }
            else if (aa == 7) {
                if (prodata[0].iFinish == "1") {//是否满足结束条件
                    var sqlfull = "";
                    var sqlappend = prodata[0].sFinishCondition.replace(/{userid}/, getCurtUserID());
                    if (prodata[0].sFinishCondition.length == 0) {
                        sqlappend = "1=1";
                    }
                    while (sqlappend.indexOf("{") > -1) {
                        var bindex = sqlappend.indexOf("{");
                        var eindex = sqlappend.indexOf("}");
                        var fieldid = sqlappend.substr(bindex + 1, eindex - bindex - 1);
                        //"{" + fieldid + "}"
                        if (sqlappend.indexOf("{" + fieldid + "}") > -1) {
                            sqlappend = sqlappend.replace("{" + fieldid + "}", curtformdata[fieldid]);
                        }
                        else {
                            alert("对不起，审批完成条件语句中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                            return "";
                        }
                    }
                    //sqlfull = "select 1 from(" + sqlbillcomm + ") as A where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                    //sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
                    sqlfull = "select 1 from " + tablename + " where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                    sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
                    var resultjson = SqlGetDataComm(sqlfull);
                    //满足审批完成条件，则设置单据审批完成
                    if (resultjson.length > 0) {
                        var billcmpleSql = sqlstr + " " + sactionagree + " update " + tablename + " set iStatus=4,sCheckUserID='" + getCurtUserID() + "',dCheckDate='" + getNowDate() + " " + getNowTime() + "' where " + mainkey + "=" + fieldkey;
                        return "1^|^" + billcmpleSql;
                    }
                    else {
                        nextiSerial = parseInt(prodata[0].iNoPushSerial);
                        checkperson = ProGetNextPerson(iformid, fieldkey, nextiSerial);
                        if (checkperson.Name.length == 0) {
                            alert("获取下一审批人失败！");
                            return "";
                        }
                    }
                }
                else {
                    nextiSerial = parseInt(prodata[0].iNoPushSerial);
                    checkperson = ProGetNextPerson(iformid, fieldkey, nextiSerial);
                    if (checkperson.Name.length == 0) {
                        alert("获取下一审批人失败！");
                        return "";
                    }
                }
            }
            else {
                return "-1";
            }
        }
        else {
            if (prodata[0].iFinish == "1") {//是否满足结束条件
                //如果是会签，则不会有推送人
                if (prodata[0].sCheckType == "会签") {
                    var returnSql = "if not exists(select 1 from SysMessage where iFormid=" + iformid + " and iBillRecNo=" + fieldkey + " and sProGUID='" + ProGUID + "' and isnull(iRead,0)=0 and sReceiveUserid<>'" + getCurtUserID() + "')" +
                    "begin " + sqlstr + " " + sactionagree + " update " + tablename + " set iStatus=4,sCheckUserID='" + getCurtUserID() + "',dCheckDate='" + getNowDate() + " " + getNowTime() + "' where " + mainkey + "=" + fieldkey + " end ";
                    return "1^|^" + returnSql;
                }
                else {
                    var sqlfull = "";
                    var sqlappend = prodata[0].sFinishCondition.replace(/{userid}/, getCurtUserID());
                    if (prodata[0].sFinishCondition.length == 0) {
                        sqlappend = "1=1";
                    }
                    while (sqlappend.indexOf("{") > -1) {
                        var bindex = sqlappend.indexOf("{");
                        var eindex = sqlappend.indexOf("}");
                        var fieldid = sqlappend.substr(bindex + 1, eindex - bindex - 1);
                        "{" + fieldid + "}"
                        if (sqlappend.indexOf("{" + fieldid + "}") > -1) {
                            sqlappend = sqlappend.replace("{" + fieldid + "}", curtformdata[fieldid]);
                        }
                        else {
                            alert("对不起，审批完成条件语句中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                            return "";
                        }
                    }
                    //sqlfull = "select 1 from(" + sqlbillcomm + ") as A where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                    //sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
                    sqlfull = "select 1 from " + tablename + " where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                    sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
                    var resultjson = SqlGetDataComm(sqlfull);
                    //满足审批完成条件，则设置单据审批完成
                    if (resultjson.length > 0) {
                        var billcmpleSql = sqlstr + " " + sactionagree + " update " + tablename + " set iStatus=4,sCheckUserID='" + getCurtUserID() + "',dCheckDate='" + getNowDate() + " " + getNowTime() + "' where " + mainkey + "=" + fieldkey;
                        return "1^|^" + billcmpleSql;
                    }
                    else {
                        nextiSerial = parseInt(prodata[0].iSerial) + 1;
                        checkperson = ProGetNextPerson(iformid, fieldkey, nextiSerial);
                        if (checkperson == undefined || checkperson.Name.length == 0) {
                            alert("获取下一审批人失败！");
                            return "";
                        }
                    }
                }

            }
            else {
                //如果是会签，且不结束
                if (prodata[0].sCheckType == "会签") {
                    //判断是否还有其他未审批的会签节点，没有的话，要流到下一节点，有的话，不用执行
                    var sqlpdtext = "select count(*) as r  from SysMessage where iFormid=" + iformid + " and iBillRecNo=" + fieldkey + " and sProGUID='" + ProGUID + "' and isnull(iRead,0)=0 and sReceiveUserid<>'" + getCurtUserID() + "'";
                    var sqlpddata = SqlGetDataComm(sqlpdtext);
                    if (sqlpddata.length > 0) {
                        if (sqlpddata[0].r != "0") {
                            return "0"; //返回0表示会签的审批节点且不流到下一节点
                        }
                    }
                }
                nextiSerial = parseInt(prodata[0].iSerial) + 1;
                checkperson = ProGetNextPerson(iformid, fieldkey, nextiSerial);
                if (checkperson.Name.length == 0) {
                    alert("获取下一审批人失败！");
                    return "";
                }

            }
        }
        //组织sql语句
        var istatus = issubmit == true ? "2" : "3";
        var billcmpleSql = sqlstr + " " + sactionagree + " " +
                "update " + tablename + " set iStatus=" + istatus + ",sCheckUserID='" + getCurtUserID() + "',dCheckDate='" + getNowDate() + " " + getNowTime() + "' where " + mainkey + "=" + fieldkey;
        //如果下一节审批人与当前审批人同一个，则继续向下审批
        if (checkperson.Name[0].toUpperCase() == getCurtUserID().toUpperCase()) {
            var nextCheckNodes = SqlGetDataComm("select GUID,sContion from bscDataBillD where iFormID=" + iformid + " and iSerial=" + nextiSerial);
            if (nextCheckNodes.length > 0) {
                var flag = 0;
                for (var ic = 0; ic < nextCheckNodes.length; ic++) {
                    var contion = "1=1"
                    if (nextCheckNodes[ic].sContion != "") {
                        contion = nextCheckNodes[ic].sContion;
                    }
                    var sqlcondition = "select 1 from(" + sqlbillcomm + ") as A where " + mainkey + "=" + fieldkey + " and " + contion;
                    if (SqlGetDataComm(sqlcondition).length > 0) {
                        flag = 1;
                        billcmpleSql = ProcAgreeDeal(iformid, fieldkey, nextCheckNodes[ic].GUID, billcmpleSql, issubmit);
                        break;
                    }
                }
                if (flag == 0) {
                    alert("下一节点均不满足审批条件要求！");
                    return "";
                }
                else {
                    if (billcmpleSql == "") {
                        return "";
                    }
                    else {
                        var index = billcmpleSql.lastIndexOf("^|^");
                        nextiSerial = billcmpleSql.split("^|^")[0];
                        billcmpleSql = billcmpleSql.substr(index + 3, billcmpleSql.length - index - 3);
                        return nextiSerial + "^|^" + billcmpleSql;
                    }
                }
            }
            else {
                alert("下一节点定义不存在！");
                return "";
            }
        } //否则返回审批执行语句
        else {
            return nextiSerial + "^|^" + billcmpleSql;
        }
        //}
    }
    else {
        alert("审批流定义不存在！");
        return false;
    }
}
//功能：退回
function ProcBack(SysmessRecNo, backmess) {
    //当前meessage数据
    var tablename;
    var mainkey;
    var fieldkey;
    var iformid;
    var sProGUID;
    var sqlbillcomm;
    var sqlsysmess = "select iFormid,sProGUID,iBillRecNo,iMessageType from SysMessage where iRecNo=" + SysmessRecNo + " and isnull(iRead,0)=0";
    var sysmessdata = SqlGetDataComm(sqlsysmess);
    if (sysmessdata.length > 0) {
        iformid = sysmessdata[0].iFormid;
        sProGUID = sysmessdata[0].sProGUID;
        var sqlbill = "select sShowSql,sTableName,sFieldKey from bscDataBill where iFormID=" + iformid; //从表单定义从获取打开SQL和流程主题
        var billdata = SqlGetDataComm(sqlbill)[0];
        sqlbillcomm = SqlGetDataComm(sqlbill)[0].sShowSql;
        tablename = SqlGetDataComm(sqlbill)[0].sTableName;
        mainkey = SqlGetDataComm(sqlbill)[0].sFieldKey;
        fieldkey = sysmessdata[0].iBillRecNo;
        var statusobj = ProGetTableCurtStatus(sysmessdata[0].iFormid, sysmessdata[0].iBillRecNo);
        if (statusobj.iStatus == "" || statusobj.iStatus == "0" || statusobj.iStatus == "99") {
            alert("单据状态：[" + statusobj.sStatusName + "]，不能退回！");
            return false;
        }
    }
    else {
        alert("不存在此审批任务或已被处理！");
        return false;
    }


    //当前单据数据
    var sqlcurtform = "select * from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
    var curtformdata = SqlGetDataComm(sqlcurtform)[0];

    //审批流信息
    var sqlcomm = "select sReturnContion,sBeforeReturn,sActionReturn from bscDataBillD where GUID='" + sProGUID + "'";
    var prodata = SqlGetDataComm(sqlcomm);
    if (prodata.length > 0) {
        //1、当前单据是否满足可退回条件
        var sreturncontion = prodata[0].sReturnContion.replace(/{userid}/, getCurtUserID());
        if (sreturncontion.length > 0) {

            while (sreturncontion.indexOf("{") > -1) {
                var bindex = sreturncontion.indexOf("{");
                var eindex = sreturncontion.indexOf("}");
                var fieldid = sreturncontion.substr(bindex + 1, eindex - bindex - 1);
                if (sreturncontion.indexOf("{" + fieldid + "}") > -1) {
                    sreturncontion = sreturncontion.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                else {
                    alert("对不起，可退回条件中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                    return false;
                }
            }
            var sqlfull = "";
            sqlfull = sqlbillcomm + sreturncontion;
            sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
            var resultjson = SqlGetDataComm(sqlfull);
            if (resultjson.length == 0) {//如果不满足审批完成条件，则跳转到下一步
                alert("对不起，此单据不满足退回条件！");
                return false;
            }
        }
        //2、退回前检测
        var sbeforereturn = prodata[0].sBeforeReturn.replace(/{userid}/, getCurtUserID());
        if (sbeforereturn.length > 0) {
            while (sbeforereturn.indexOf("{") > -1) {
                var bindex = sbeforereturn.indexOf("{");
                var eindex = sbeforereturn.indexOf("}");
                var fieldid = sbeforereturn.substr(bindex + 1, eindex - bindex - 1);
                if (sbeforereturn.indexOf("{" + fieldid + "}") > -1) {
                    sbeforereturn = sbeforereturn.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                else {
                    alert("对不起，退回前检测中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                    return false;
                }
            }
            var betnResult = SqlGetDataComm(sbeforereturn);
            if (betnResult.length > 0) {
                for (var o in betnResult) {
                    if (betnResult[0][o] == "" || betnResult[0][o] == "1") {
                        break;
                    }
                    else {
                        alert(betnResult[0][o] + " 退回前检测失败！");
                        return false;
                    }
                }
            }
            else {
                alert("退回前检测没有返回值，不合法！");
                return false;
            }
        }
        //退回执行语句
        var sqlreturn = prodata[0].sActionReturn.replace(/{userid}/, getCurtUserID());
        if (sqlreturn.length > 0) {
            while (sqlreturn.indexOf("{") > -1) {
                var bindex = sqlreturn.indexOf("{");
                var eindex = sqlreturn.indexOf("}");
                var fieldid = sqlreturn.substr(bindex + 1, eindex - bindex - 1);
                if (sqlreturn.indexOf("{" + fieldid + "}") > -1) {
                    sqlreturn = sqlreturn.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                else {
                    alert("对不起，退回执行语句中无法解析参数[{" + fieldid + "}]，请联系管理员！");
                    return false;
                }
            }

            var sqlset = "update " + tablename + " set iCheckSerial=NULL,sCheckUserID=NULL,dCheckDate='" + getNowDate() + " " + getNowTime() + "',iStatus=1 where " + mainkey + "=" + fieldkey + ";" +
                        "update SysMessage set iRead=1,sCheckIdeal='" + backmess + "',iMessageType=1 where iRecNo=" + SysmessRecNo +
                        "delete from SysMessage where iFormid=" + iformid + " and iBillRecNo=" + fieldkey + " and isnull(iRead,0)=0;" +
                        " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,iBillRecNo,iRead,dinputDate,sProGUID,itype) select " +
                        "1," + iformid + ",sSendUserID,sSendUserID,'[退] '+sContent,iBillRecNo,0,'" + getNowDate() + ' ' + getNowTime() + "',sProGUID,1 from SysMessage" +
                        " where iRecNo=" + SysmessRecNo + ";";
            sqlset = "BEGIN TRY BEGIN TRANSACTION " + sqlset + sqlreturn + ";" + " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
            var result = SqlExecComm(sqlset);
            if (result == "1") {
                alert("退回成功！");
                return true;
            }
            else {
                alert(result);
                return false;
            }
        }
        else {
            var sqlset = "update " + tablename + " set iCheckSerial=NULL,sCheckUserID=NULL,dCheckDate='" + getNowDate() + " " + getNowTime() + "',iStatus=1 where " + mainkey + "=" + fieldkey + ";" +
                        "update SysMessage set iRead=1,sCheckIdeal='" + backmess + "',iMessageType=1 where iRecNo=" + SysmessRecNo + ";" +
                        "delete from SysMessage where iFormid=" + iformid + " and iBillRecNo=" + fieldkey + " and isnull(iRead,0)=0;" +
                        " insert into SysMessage (iSerial,iFormid,sSendUserID,sReceiveUserid,sContent,iBillRecNo,iRead,dinputDate,sProGUID,itype) select " +
                        "1," + iformid + ",sSendUserID,sSendUserID,'[退] '+sContent,iBillRecNo,0,'" + getNowDate() + ' ' + getNowTime() + "',sProGUID,1 from SysMessage" +
                        " where iRecNo=" + SysmessRecNo + ";"
            sqlset = "BEGIN TRY BEGIN TRANSACTION " + sqlset + " " + " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
            var result = SqlExecComm(sqlset);
            if (result == "1") {
                alert("退回成功！");
                return true;
            }
            else {
                alert(result);
                return false;
            }
        }
    }
    else {
        alert("此审批流定义已不存在！");
        return false;
    }
}
//功能：撤消提交
function ProCancel(iformid, fieldkey,sql) {
    var sqlcomm = "select sTableName,sFieldKey from bscDataBill where iFormID=" + iformid;
    var formdata = SqlGetDataComm(sqlcomm);
    if (formdata.length > 0) {
        var istatusdata = SqlGetDataComm("select a.iStatus,b.sStatusName from " + formdata[0].sTableName + " as a left join bscBillstatus as b on isnull(a.iStatus,0)=b.iStatus where a." + formdata[0].sFieldKey + "=" + fieldkey);
        if (istatusdata.length > 0) {
            if (parseInt(istatusdata[0].iStatus) != 2) {
                alert("单据状态：[" + istatusdata[0].sStatusName + "],不可撤消！");
                return false;
            }
            else {
                if (confirm("确认撤消提交？") == true) {
                    var sqlupdatestr = " BEGIN TRY BEGIN TRANSACTION " + sql +
                    " create TABLE #tmp99(r varchar(1000) null) insert into #tmp99  exec SpSubmitAndCancel " + iformid + ",2,'" + fieldkey + "','" + getCurtUserID() + "',1 " +
                     "if exists(select 1 from #tmp99 where r<>'1') begin declare @r varchar(1000) select @r=r from #tmp99 drop table #tmp99 raiserror(@r,16,1) return end drop table #tmp99 " +
                "update " + formdata[0].sTableName + " set iCheckSerial=null where " + formdata[0].sFieldKey + "=" + fieldkey + " " +
                "delete from SysMessage where iFormid=" + iformid + " and iBillRecNo=" + fieldkey + " and isnull(iRead,0)=0 " +
                " COMMIT TRANSACTION END TRY BEGIN CATCH ROLLBACK TRANSACTION declare @error varchar(100) select @error=ERROR_MESSAGE() raiserror(@error,16,1) END CATCH";
                    var result = SqlExecComm(sqlupdatestr);
                    if (result == "1") {
                        return true;
                    }
                    else {
                        alert(result);
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
        }
        else {
            alert("单据不存在！");
            return false;
        }
    }
    else {
        alert("单据流程定义不存在！");
        return false;
    }
}
//功能：撤销审批
function ProCancelCheck(SysmessRecNo, checkmess) {
    try {
        //取当前审批节点信息
        var sqlcomm = "select * from SysMessage where iRecNo='" + SysmessRecNo + "' and isnull(iRead,0)=1";
        var sqldata = SqlGetDataComm(sqlcomm);
        //如果不存在
        if (sqldata.length == 0) {
            alert("对不起，任务已撤消或不存在！");
            return false;
        }
        else {
            var sqlFormcomm = "select sCheckType,sActionCancel from bscDataBillD where GUID='" + sqldata[0].sProGUID + "'";
            var sqlFormData = SqlGetDataComm(sqlFormcomm);
            if (sqlFormData.length == 0) {
                alert("对不起，此审批配置信息已被删除！");
                return false;
            }
            else {
                //如果是单人审批
                if (sqlFormData[0].sCheckType == "单人审批") {
                    //取迟于当前审批节点，的审批信息
                    var sqlLaterComm = "select isnull(a.iRead,0) as iRead from SysMessage as a,SysMessage as b where a.iFormid=b.iFormid and a.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and a.dinputDate>b.dinputDate ";
                    var sqlCheckCount = SqlGetDataComm(sqlLaterComm);
                    //如果有迟于当前节点的审批节点
                    if (sqlCheckCount.length > 0) {
                        //如果迟于当前审批节点的节点数等于1个
                        if (sqlCheckCount.length == 1) {
                            //，且已审批，则不可撤销。
                            if (sqlCheckCount[0].iRead == "1") {
                                alert("下一节点已审批，请先撤销下一节点！");
                                return false;
                            }
                            //否则，执行撤销语句，删除下一审批节点。设置表单状态
                            else {
                                var execSql = sqlFormData[0].sActionCancel;
                                var tablename = "";
                                var fieldkey = "";
                                var key = "";
                                var sqlBillComm = "select a.sTableName,a.sFieldKey,b.iBillRecNo from bscDataBill as a,SysMessage as b where a.iFormID=b.iFormid and b.iRecNo='" + SysmessRecNo + "'";
                                var sqlBillData = SqlGetDataComm(sqlBillComm);
                                if (sqlBillData.length > 0) {
                                    tablename = sqlBillData[0].sTableName;
                                    fieldkey = sqlBillData[0].sFieldKey;
                                    key = sqlBillData[0].iBillRecNo;
                                    var tableSql = "select * from " + tablename + " where " + fieldkey + "='" + key + "'";
                                    var tabledata = SqlGetDataComm(tableSql);
                                    while (execSql.indexOf("{") > 1) {
                                        var indexs = execSql.indexOf("{");
                                        var indexe = execSql.indexOf("}");
                                        var fieldname = execSql.substr(indexs + 1, indexe - indexs - 1);
                                        execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                                        var sqlexec = " begin try begin tran update SysMessage set iRead=0,sCheckIdeal='" + checkmess + "' where iRecNo='" + SysmessRecNo + "'" +
                                        "delete SysMessage from SysMessage,SysMessage as b where SysMessage.iFormid=b.iFormid and SysMessage.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and SysMessage.dinputDate>b.dinputDate " +
                                        execSql + " update " + tablename + "  set iStatus=3,sCheckUserID=NULL,dCheckDate=NULL,iCheckSerial=b.iSerial from " + tablename + ",SysMessage as b where " + tablename + "." + fieldkey + "='" + key + "' and b.iRecNo='" + SysmessRecNo + "' and " + tablename + "." + fieldkey + "=b.iBillRecNo" +
                                        " commit tran end try begin catch rollback tran end catch";
                                        var result = SqlExecComm(sqlexec);
                                        if (result != "1") {
                                            alert(result);
                                            return false;
                                        }
                                    }
                                }
                            }
                        }
                        //如果迟于当前审批节点的节点数多于1个
                        else {
                            //看看有几个iSerial
                            var sqliSerial = "select iSerial from SysMessage as a,SysMessage as b where a.iFormid=b.iFormid and a.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and a.dinputDate>b.dinputDate group by iSerial";
                            var sqliSerialData = SqlGetDataComm(sqliSerial);
                            if (sqliSerialData.length > 0) {
                                //如果多于1个
                                if (sqliSerialData.length > 1) {
                                    alert("下一节点已审批，请先撤销下一节点！");
                                    return false;
                                }
                                //如果只有一个，则于表示下一节点是会会签，
                                else {
                                    //下一节点是否存在已审批的节点
                                    var sqliRead = "select count(*) as c from SysMessage as a,SysMessage as b where a.iFormid=b.iFormid and a.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and a.dinputDate>b.dinputDate and isnull(iRead,0)=1 ";
                                    var sqliReadData = SqlGetDataComm(sqliRead);
                                    //存在
                                    if (parseInt(sqliReadData[0].c) > 0) {
                                        alert("下一节点已审批，请先撤销下一节点！");
                                        return false;
                                    }
                                    //不存在
                                    else {
                                        var execSql = sqlFormData[0].sActionCancel;
                                        var tablename = "";
                                        var fieldkey = "";
                                        var key = "";
                                        var sqlBillComm = "select a.sTableName,a.sFieldKey,b.iBillRecNo from bscDataBill as a,SysMessage as b where a.iFormID=b.iFormid and b.iRecNo='" + SysmessRecNo + "'";
                                        var sqlBillData = SqlGetDataComm(sqlBillComm);
                                        if (sqlBillData.length > 0) {
                                            tablename = sqlBillData[0].sTableName;
                                            fieldkey = sqlBillData[0].sFieldKey;
                                            key = sqlBillData[0].iBillRecNo;
                                            var tableSql = "select * from " + tablename + " where " + fieldkey + "='" + key + "'";
                                            var tabledata = SqlGetDataComm(tableSql);
                                            while (execSql.indexOf("{") > -1) {
                                                var indexs = execSql.indexOf("{");
                                                var indexe = execSql.indexOf("}");
                                                var fieldname = execSql.substr(indexs + 1, indexe - indexs - 1);
                                                execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                                            }
                                            execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                                            var sqlexec = " begin try begin tran update SysMessage set iRead=0,sCheckIdeal='" + checkmess + "' where iRecNo='" + SysmessRecNo + "'" +
                                        "delete SysMessage from SysMessage,SysMessage as b where SysMessage.iFormid=b.iFormid and SysMessage.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and SysMessage.dinputDate>b.dinputDate " +
                                        execSql + " update " + tablename + " set iStatus=3,sCheckUserID=NULL,dCheckDate=NULL,iCheckSerial=b.iSerial from " + tablename + ",SysMessage as b where " + tablename + "." + fieldkey + "='" + key + "' and b.iRecNo='" + SysmessRecNo + "' and " + tablename + "." + fieldkey + "=b.iBillRecNo" +
                                        " commit tran end try begin catch rollback tran end catch";
                                            var result = SqlExecComm(sqlexec);
                                            if (result != "1") {
                                                alert(result);
                                                return false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //如果没有迟于当前节点的审批节点，则表示审批已经结束
                    else {
                        var execSql = sqlFormData[0].sActionCancel;
                        var tablename = "";
                        var fieldkey = "";
                        var key = "";
                        var sqlBillComm = "select a.sTableName,a.sFieldKey,b.iBillRecNo from bscDataBill as a,SysMessage as b where a.iFormID=b.iFormid and b.iRecNo='" + SysmessRecNo + "'";
                        var sqlBillData = SqlGetDataComm(sqlBillComm);
                        if (sqlBillData.length > 0) {
                            tablename = sqlBillData[0].sTableName;
                            fieldkey = sqlBillData[0].sFieldKey;
                            key = sqlBillData[0].iBillRecNo;
                            var tableSql = "select * from " + tablename + " where " + fieldkey + "='" + key + "'";
                            var tabledata = SqlGetDataComm(tableSql);
                            while (execSql.indexOf("{") > -1) {
                                var indexs = execSql.indexOf("{");
                                var indexe = execSql.indexOf("}");
                                var fieldname = execSql.substr(indexs + 1, indexe - indexs - 1);
                                execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                            }
                            execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                            var sqlexec = " begin try begin tran update SysMessage set iRead=0,sCheckIdeal='" + checkmess + "' where iRecNo='" + SysmessRecNo + "'" +
                                        "delete SysMessage from SysMessage,SysMessage as b where SysMessage.iFormid=b.iFormid and SysMessage.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and SysMessage.dinputDate>b.dinputDate " +
                                        execSql + " update " + tablename + " set iStatus=3,sCheckUserID=NULL,dCheckDate=NULL,iCheckSerial=b.iSerial from " + tablename + ",SysMessage as b where " + tablename + "." + fieldkey + "='" + key + "' and b.iRecNo='" + SysmessRecNo + "' and " + tablename + "." + fieldkey + "=b.iBillRecNo" +
                                        " commit tran end try begin catch rollback tran end catch";
                            var result = SqlExecComm(sqlexec);
                            if (result != "1") {
                                alert(result);
                                return false;
                            }
                        }
                    }
                }
                //如果是会签
                else {
                    var sqliRead = "select count(*) as c from SysMessage as a,SysMessage as b where a.iFormid=b.iFormid and a.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and a.dinputDate>b.dinputDate and isnull(iRead,0)=1 ";
                    var sqliReadData = SqlGetDataComm(sqliRead);
                    if (parseInt(sqliReadData[0].c) > 0) {
                        alert("下一节点已审批，请先撤销下一节点！");
                        return false;
                    }
                    else {
                        var execSql = sqlFormData[0].sActionCancel;
                        var tablename = "";
                        var fieldkey = "";
                        var key = "";
                        var sqlBillComm = "select a.sTableName,a.sFieldKey,b.iBillRecNo from bscDataBill as a,SysMessage as b where a.iFormID=b.iFormid and b.iRecNo='" + SysmessRecNo + "'";
                        var sqlBillData = SqlGetDataComm(sqlBillComm);
                        if (sqlBillData.length > 0) {
                            tablename = sqlBillData[0].sTableName;
                            fieldkey = sqlBillData[0].sFieldKey;
                            key = sqlBillData[0].iBillRecNo;
                            var tableSql = "select * from " + tablename + " where " + fieldkey + "='" + key + "'";
                            var tabledata = SqlGetDataComm(tableSql);
                            while (execSql.indexOf("{") > -1) {
                                var indexs = execSql.indexOf("{");
                                var indexe = execSql.indexOf("}");
                                var fieldname = execSql.substr(indexs + 1, indexe - indexs - 1);
                                execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                            }
                            execSql = execSql.replace("{" + fieldname + "}", tabledata[0][fieldname]);
                            var sqlexec = " begin try begin tran update SysMessage set iRead=0,sCheckIdeal='" + checkmess + "' where iRecNo='" + SysmessRecNo + "'" +
                                        "delete SysMessage from SysMessage,SysMessage as b where SysMessage.iFormid=b.iFormid and SysMessage.iBillRecNo=b.iBillRecNo and b.iRecNo='" + SysmessRecNo + "' and SysMessage.dinputDate>b.dinputDate " +
                                        execSql + " update " + tablename + " set iStatus=3,sCheckUserID=NULL,dCheckDate=NULL,iCheckSerial=b.iSerial from " + tablename + ",SysMessage as b where " + tablename + "." + fieldkey + "='" + key + "' and b.iRecNo='" + SysmessRecNo + "' and " + tablename + "." + fieldkey + "=b.iBillRecNo" +
                                        " commit tran end try begin catch rollback tran end catch";
                            var result = SqlExecComm(sqlexec);
                            if (result != "1") {
                                alert(result);
                                return false;
                            }
                        }
                    }
                }
            }
        }
        return true;
    }
    catch (e) {
        alert(e.message);
        return false;
    }
}
//获取iSerial(审批序号)的审批人,获取第一个满意条件的节点的审批人和节点GUID
function ProGetNextPerson(iformid, fieldkey, iSerial) {
    var sqlcomm = "select sCheckType,GUID,iSerial,sCheckName,sCheckPerson,sContion from bscDataBillD where iFormID=" + iformid + " and iSerial=" + iSerial + " order by dinputDate asc";
    var tablename;
    var mainkey;
    var tabcheckpro = SqlGetDataComm(sqlcomm);
    var checkperson = { Name: [], GUID: "" };
    if (tabcheckpro.length > 0) {
        try {
            var sqlbill = "select sTableName,sFieldKey,sShowSql,sProTitle,sBillType,sFieldKey from bscDataBill where iFormID=" + iformid; //从表单定义从获取打开SQL和流程主题
            var billdata = SqlGetDataComm(sqlbill)[0];
            for (var i = 0; i < tabcheckpro.length; i++) {
                checkperson = { Name: [], GUID: tabcheckpro[i].GUID };
                var sqlbillcomm = SqlGetDataComm(sqlbill)[0].sShowSql.replace(/{userid}/, getCurtUserID());
                var sqlfull = "";
                var sqlappend = "";
                tablename = billdata.sTableName;
                mainkey = billdata.sFieldKey;
                var sqlformstr = "select * from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
                var curtformdata = SqlGetDataComm(sqlformstr)[0]; //当前提交表单的数据

                if (tabcheckpro[i].sContion.length == 0) {
                    sqlappend = "1=1";
                }
                else {
                    sqlappend = tabcheckpro[i].sContion.replace(/{userid}/, getCurtUserID());
                }
                while (sqlappend.indexOf("{") > -1) {
                    var bindex = sqlappend.indexOf("{");
                    var eindex = sqlappend.indexOf("}");
                    var fieldid = sqlappend.substr(bindex + 1, eindex - bindex - 1);
                    if (curtformdata[fieldid] == undefined || curtformdata[fieldid] == null) {
                        break;
                    }
                    sqlappend = sqlappend.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                //sqlfull = "select * from(" + sqlbillcomm + ") as A where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                sqlfull = "select 1 from " + tablename + " where " + mainkey + "=" + fieldkey + " and " + sqlappend;
                sqlfull = sqlfull.replace(/{userid}/g, getCurtUserID());
                var resultjson = SqlGetDataComm(sqlfull);
                if (resultjson.length == 0) {//如果不满足审批分支的条件
                    continue;
                }



                var checkman = ""; //处理人
                var submitter = ""; //提交人

                //获取提交人
                for (var o in curtformdata) {
                    if (o.toUpperCase() == "SUSERID") {
                        submitter = curtformdata[o];
                        break;
                    }
                }
                //解析sCheckPerson，取出对应的人
                var personrole = tabcheckpro[i].sCheckPerson; //处理人原字段
                if (personrole.length == 0) {
                    alert("未定义审批人！");
                    return 0;
                }
                var otype = personrole.split(";")[0]//类别，0部门主管、1角色、2具体人员
                var sindex;
                var svalue;
                if (parseInt(otype) < 3) {
                    sindex = personrole.split(";")[1].split(":")[0];
                    svalue = personrole.split(";")[1].split(":")[1];
                }
                else {
                    svalue = personrole.split(";")[1];
                }

                var sqltextstr = "";
                switch (otype) {
                    case "0":
                        {
                            if (sindex == "0") {//0表示选定的部门
                                var sqlgetbmzg = "select sDeptCharge from bscDataClass where sClassID='" + svalue + "' and iType='07'";
                                var tabgetbmzg = SqlGetDataComm(sqlgetbmzg);
                                if (tabgetbmzg.length > 0 && tabgetbmzg[0].sDeptCharge.length > 0) {
                                    checkperson.Name.push(tabgetbmzg[0].sDeptCharge);
                                }
                            }
                            else if (sindex == "1") {//表示表单域,形式field
                                checkman = curtformdata[svalue];
                                if (curtformdata[svalue] != undefined && curtformdata[svalue] != null && curtformdata[svalue].length > 0) {
                                    checkperson.Name.push(checkman);
                                }
                            }
                        } break;
                    case "1":
                        {
                            if (sindex == "0") {
                                var person = "";
                                if (tabcheckpro[i].sCheckType == "单人审批") {
                                    person = "select top 1 sCode from bscDataPerson where sCheckRoles like '%" + svalue + "%'";
                                }
                                else {
                                    person = "select sCode from bscDataPerson where sCheckRoles like '%" + svalue + "%'";
                                }
                                var persondata = SqlGetDataComm(person);
                                if (persondata.length > 0) {
                                    for (var p = 0; p < persondata.length; p++) {
                                        checkman = persondata[p].sCode;
                                        checkperson.Name.push(checkman);
                                    }
                                }
                            }
                        } break;
                    case "2":
                        {
                            if (sindex == "0") {
                                checkman = svalue;
                                checkperson.Name.push(checkman);
                            }
                            else if (sindex == "1") {//表示表单域,形式field
                                checkman = curtformdata[svalue];
                                if (curtformdata[svalue] != undefined && curtformdata[svalue] != null && curtformdata[svalue].length > 0) {
                                    checkperson.Name.push(checkman);
                                }
                            }
                        } break;
                    case "3":
                        {
                            var sqlold = svalue;
                            while (sqlold.indexOf("{") > -1) {
                                var bindex = svalue.indexOf("{");
                                var eindex = svalue.indexOf("}");
                                var fieldid = sqlold.substr(bindex + 1, eindex - bindex - 1);
                                if (curtformdata[fieldid] == undefined || curtformdata[fieldid] == null) {
                                    break;
                                }
                                sqlold = sqlold.replace("{" + fieldid + "}", curtformdata[fieldid]);
                            }
                            var persondata = SqlGetDataComm(sqlold);
                            if (persondata.length > 0) {
                                if (tabcheckpro[i].sCheckType == "单人审批") {
                                    for (var o in persondata[0]) {
                                        checkman = persondata[0][o];
                                        break;
                                    }
                                    if (checkman.length > 0) {
                                        checkperson.Name.push(checkman);
                                    }
                                }
                                else {
                                    for (var z = 0; z < persondata.length; z++) {
                                        for (var o in persondata[z]) {
                                            checkman = persondata[z][o];
                                            break;
                                        }
                                        if (checkman.length > 0) {
                                            checkperson.Name.push(checkman);
                                        }
                                    }
                                }
                            }
                        } break;
                }
                return checkperson;
            }
        }
        catch (e) {
            alert(e.message)
            while (checkperson.length > 0) {
                checkperson.splice(0, 1);
            }
            return checkperson;
        }
    }
    else {
        return checkperson;
    }
}
//根据代码获取审批人
function GetPersonByCode(iformid, fieldkey, code) {
    var checkperson = [];
    var sqlbill = "select sTableName,sFieldKey from bscDataBill where iFormID=" + iformid; //从表单定义从获取打开SQL和流程主题
    var billdata = SqlGetDataComm(sqlbill)[0];
    var mainkey = billdata.sFieldKey;
    var tablename = billdata.sTableName;

    var sqlformstr = "select * from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
    var curtformdata = SqlGetDataComm(sqlformstr)[0]; //当前提交表单的数据


    var otype = code.split(";")[0]//类别，0部门主管、1角色、2具体人员、3自定义
    var sindex;
    var svalue;
    if (parseInt(otype) < 3) {
        sindex = code.split(";")[1].split(":")[0];
        svalue = code.split(";")[1].split(":")[1];
    }
    else {
        svalue = code.split(";")[1];
    }

    var sqltextstr = "";
    var checkman = "";
    switch (otype) {
        case "0":
            {
                if (sindex == "0") {//0表示选定的部门
                    var sqlgetbmzg = "select sDeptCharge from bscDataClass where sClassID='" + svalue + "' and iType='07'";
                    var tabgetbmzg = SqlGetDataComm(sqlgetbmzg);
                    if (tabgetbmzg.length > 0 && tabgetbmzg[0].sDeptCharge.length > 0) {
                        checkperson.push(tabgetbmzg[0].sDeptCharge);
                    }
                }
                else if (sindex == "1") {//表示表单域,形式field
                    checkman = curtformdata[svalue];
                    if (curtformdata[svalue] != undefined && curtformdata[svalue] != null && curtformdata[svalue].length > 0) {
                        checkperson.push(checkman);
                    }
                }
            } break;
        case "1":
            {
                if (sindex == "0") {
                    var person = "select sCode from bscDataPerson where sCheckRoles like '%" + svalue + "%'";
                    var persondata = SqlGetDataComm(person);
                    if (persondata.length > 0) {
                        for (var p = 0; p < persondata.length; p++) {
                            checkman = persondata[p].sCode;
                            checkperson.push(checkman);
                        }
                    }
                }
            } break;
        case "2":
            {
                if (sindex == "0") {
                    checkman = svalue;
                    checkperson.push(checkman);
                }
                else if (sindex == "1") {//表示表单域,形式field
                    checkman = curtformdata[svalue];
                    if (curtformdata[svalue] != undefined && curtformdata[svalue] != null && curtformdata[svalue].length > 0) {
                        checkperson.push(checkman);
                    }
                }
            } break;
        case "3":
            {
                var sqlold = svalue;
                while (sqlold.indexOf("{") > -1) {
                    var bindex = svalue.indexOf("{");
                    var eindex = svalue.indexOf("}");
                    var fieldid = sqlold.substr(bindex + 1, eindex - bindex - 1);
                    if (curtformdata[fieldid] == undefined || curtformdata[fieldid] == null) {
                        break;
                    }
                    sqlold = sqlold.replace("{" + fieldid + "}", curtformdata[fieldid]);
                }
                var persondata = SqlGetDataComm(sqlold);
                if (persondata.length > 0) {
                    for (var z = 0; z < persondata.length; z++) {
                        for (var o in persondata[z]) {
                            checkman = persondata[z][o];
                            break;
                        }
                        if (checkman.length > 0) {
                            checkperson.push(checkman);
                        }
                    }
                }
            } break;
    }
    return checkperson;
}
//获取当前表单状态
function ProGetTableCurtStatus(iformid, fieldkey, otype) {
    var sqlcomm = "select sTableName,sFieldKey,isnull(iModifyNotCheck,0) as iModifyNotCheck,isnull(iDeleteNotCheck,0) as iDeleteNotCheck from bscDataBill where iFormID=" + iformid;
    var formdata = SqlGetDataComm(sqlcomm);
    if (formdata.length > 0) {
        if (otype == "modify") {
            if (formdata[0].iModifyNotCheck == "1") {
                return { iStatus: 99, sStatusName: "错误的状态" };
            }
            else {
                var istatusdata = SqlGetDataComm("select a.iStatus,b.sStatusName from " + formdata[0].sTableName + " as a left join bscBillstatus as b on isnull(a.iStatus,0)=b.iStatus where a." + formdata[0].sFieldKey + "=" + fieldkey);
                if (istatusdata.length > 0) {
                    return istatusdata[0];
                }
                else {
                    return { iStatus: 99, sStatusName: "错误的状态" };
                }
            }
        }
        else {
            var istatusdata = SqlGetDataComm("select a.iStatus,b.sStatusName from " + formdata[0].sTableName + " as a left join bscBillstatus as b on isnull(a.iStatus,0)=b.iStatus where a." + formdata[0].sFieldKey + "=" + fieldkey);
            if (istatusdata.length > 0) {
                return istatusdata[0];
            }
            else {
                return { iStatus: 99, sStatusName: "错误的状态" };
            }
        }
    }
}
function replaceSqlParm(sql, firstchar, secondchar, replacestr) {
    while (sql.indexOf(firstchar) > -1) {
        var bindex = sbeforeagree.indexOf(firstchar);
        var eindex = sbeforeagree.indexOf(secondchar);
        var fieldid = sbeforeagree.substr(bindex + firstchar.length, eindex - bindex - firstchar.length);
        sql = sql.replace(firstchar + fieldid + secondchar, replaceSqlStr);
    }
    return sql;
}
function ProAgreeFromSubmit(iformid, tablename, mainkey, fieldkey, sProGUID) {
    var sqlcurtform = "select * from " + tablename + " where " + mainkey + "='" + fieldkey + "'";
    var curtformdata = SqlGetDataComm(sqlcurtform)[0];

    //审批流信息
    var sqlcomm = "select * from bscDataBillD where GUID='" + sProGUID + "'";
    var prodata = SqlGetDataComm(sqlcomm);
    if (prodata.length > 0) {
        //1、同意前检测是否为空，不为空执行，为空跳过
        //var result_step1 = false; // 第一步结果(同意前检测)
        var sbeforeagree = prodata[0].sBeforeAgree;
        if (sbeforeagree.length > 0) {
            //如果同意前检测不为空，则先替换其中的{}字段
            while (sbeforeagree.indexOf("{") > -1) {
                var bindex = sbeforeagree.indexOf("{");
                var eindex = sbeforeagree.indexOf("}");
                var fieldid = sbeforeagree.substr(bindex + 1, eindex - bindex - 1);
                sbeforeagree = sbeforeagree.replace("{" + fieldid + "}", curtformdata[fieldid]);
            }
            var beforeagree_result = SqlGetDataComm(sbeforeagree);
            if (beforeagree_result.length > 0) {
                for (var o in beforeagree_result[0]) {
                    if (beforeagree_result[0][o] == "" || beforeagree_result[0][o] == "1") {
                        //result_step1 == true;
                        break;
                    }
                    else {
                        alert(beforeagree_result[0][o] + ",同意前检测失败！");
                        //result_step1 = false;
                        return false;
                        break;
                    }
                }
            }
            else {
                alert("同意前检测无返回结果，不合法！");
                return false;
            }
        }
        //if (result_step1 == true) {
        //var result_step2 = false; //步骤2结果(通过执行语句成功)
        var sactionagree = prodata[0].sActionAgree;
        if (sactionagree.length > 0) {
            while (sactionagree.indexOf("{") > -1) {
                var bindex = sactionagree.indexOf("{");
                var eindex = sactionagree.indexOf("}");
                var fieldid = sactionagree.substr(bindex + 1, eindex - bindex - 1);
                sactionagree = sactionagree.replace("{" + fieldid + "}", curtformdata[fieldid]);
            }
            if (SqlExecComm(sactionagree) == "1") {
                //result_step2 = true;
            }
            else {
                alert(SqlExecComm(sactionagree) + " 通过执行失败！");
                //result_step2 = false;
                return false;
            }
        }
        if (prodata[0].iFinish == "1") {
            var sqlfull = "";
            var sqlappend = "";
            if (prodata[0].sFinishCondition.length == 0) {
                sqlappend = "1=1";
            }
            while (sqlappend.indexOf("{") > -1) {
                var bindex = sqlappend.indexOf("{");
                var eindex = sqlappend.indexOf("}");
                var fieldid = sqlappend.substr(bindex + 1, eindex - bindex - 1);
                sqlappend = sqlappend.replace("{" + fieldid + "}", curtformdata[fieldid]);
            }

            if (sqlbillcomm.toUpperCase().indexOf("WHERE") > -1) {//如果有WHERE则
                sqlfull = sqlbillcomm + " and " + mainkey + "=" + fieldkey + " and " + sqlappend;
            }
            else {
                sqlfull = sqlbillcomm + " where " + mainkey + "=" + fieldkey + " and " + sqlappend;
            }
            var resultjson = SqlGetDataComm(sqlfull);
            if (resultjson.length == 0) {//如果不满足审批完成条件，则跳转到下一步
                var nre = ProcToNext(iformid, tablename, mainkey, fieldkey, 2);
                if (nre == 1) {
                    return true;
                }
            }
            else {//满足审批完成条件，则设置单据审批完成
                var billcmpleSql = "update " + tablename + " set iStatus=4 where " + mainkey + "=" + fieldkey;
                var bresult = SqlExecComm(billcmpleSql);
                if (bresult != "1") {
                    alert(bresult);
                }
                else {
                    return true;
                }
            }
        }
        else {
            var nre = ProcToNext(iformid, tablename, mainkey, fieldkey, 2);
            if (nre == 1) {
                return true;
            }
        }
    }
}
function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
    if (arr = document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}
function getCurtUserID() {
    var url = "/ashx/LoginHandler.ashx?otype=getcurtuserid";
    var parms = "";
    var async = false;
    var ispost = false;
    var result = callpostback(url, parms, async, ispost);
    return result;
}
function myConfirm(str) {
    execScript("n=msgbox('" + str + "',3,'提示')", "vbscript");
    return (n);
    //是 6   
    //否 7   
    //取消 2   
}