var pageMobile =
{
    //表单的打开类型：add增加，modify修改，view或空浏览
    usetype: getQueryString("usetype") == null ? "view" : getQueryString("usetype"),
    //表单formid
    iformid: getQueryString("iFormID"),
    //表单对应主表tablename
    tablename: getQueryString("tableName"),
    //主键标识
    serialTablename: getQueryString("tableName"),
    //表单主键字段
    fieldkey: getQueryString("fieldKey"),
    //表单主键值
    key: undefined,
    //表单主表
    mainTableName: getQueryString("mainTableName"),
    //表单主表主键字段,只对isDetail=1有效
    mainFieldKey: getQueryString("mainFieldKey"),
    //表单主表主键值,只对isDetail=1有效
    mainKey: getQueryString("mainKey"),
    //当前用户id
    userid: undefined,
    //当前用户名
    username: undefined,
    //当前用户部门号
    deptid: undefined,
    //是否明细
    isDetail: getQueryString("isDetail") == "1" ? "1" : 0,
    //formid
    htmlFormID: getQueryString("isDetail") == "1" ? "form2" : "form1",
    //表单数量
    pageData: undefined,
    //获取tablename下一个iRecNo
    getChildID: function (tablename) {
        var jsonobj = {
            StoreProName: "SpGetIden",
            StoreParms: [{
                ParmName: "@sTableName",
                Value: tablename
            }]
        }
        var result = SqlStoreProce(jsonobj);
        if (result && result.length > 0 && result != "-1") {
            return result;
        }
        else {
            return "-1";
        }
    },
    buttonRight: undefined,
    isInited: false,
    beforeInit: undefined,
    mainData: undefined,
    init: function () {
        //获取表单信息
        if (pageMobile.isDetail == "0") {
            var sqlObjBill = {
                TableName: "bscDataBill",
                Fields: "sSerialTableName",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + pageMobile.iformid + "'"
                }
            ]
            }
            var resultBill = SqlGetData(sqlObjBill);
            if (resultBill.length > 0) {
                pageMobile.serialTablename = resultBill[0].sSerialTableName;
            }
        }
        else {
            var sqlObjBill = {
                TableName: "bscChildTables",
                Fields: "sSerialTableName",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + pageMobile.iformid + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "sTableName",
                    ComOprt: "=",
                    Value: "'" + getQueryString("tableName") + "'"
                }
            ]
            }
            var resultBill = SqlGetData(sqlObjBill);
            if (resultBill.length > 0) {
                pageMobile.serialTablename = resultBill[0].sSerialTableName;
            }
        }
        //如果是子表，则先获取主表的数据
        if (pageMobile.isDetail == "1") {
            var sqlObjMain = {
                TableName: pageMobile.mainTableName,
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: pageMobile.mainFieldKey,
                    ComOprt: "=",
                    Value: "'" + pageMobile.mainKey + "'"
                }
            ]
            }
            var resultMain = SqlGetData(sqlObjMain);
            if (resultMain.length > 0) {
                $("#form1").form("load", resultMain[0]);
                pageMobile.mainData = resultMain[0];
            }
            $("#form1").hide();
        }
        else {
            $("#form2").hide();
        }
        //先获取主键值，用户名等
        $.ajax(
            {
                url: "/ashx/LoginHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { otype: "getcurtuserid" },
                success: function (resText) {
                    pageMobile.userid = resText;
                },
                error: function (resText) {

                }
            }
        )
        var sqlObjPerson = {
            TableName: "bscDataPerson",
            Fields: "sName,sClassID",
            SelectAll: "True",
            Filters: [
                {
                    Field: "sCode",
                    ComOprt: "=",
                    Value: "'" + pageMobile.userid + "'"
                }
            ]
        }
        var resultPerson = SqlGetData(sqlObjPerson);
        if (resultPerson.length > 0) {
            pageMobile.username = resultPerson[0].sName;
            pageMobile.deptid = resultPerson[0].sClassID;
        }
        //初始化lookup
        //先获取lookup定义
        var formLookUpTableName = pageMobile.isDetail == "1" ? "bscChildTablesDLookUp" : "bscMainTableLookUp";
        var sqlObjLookUp = {
            TableName: formLookUpTableName,
            Fields: "*",
            SelectAll: "True",
            Sorts: [
                {
                    SortName: "iSerial",
                    SortOrder: "asc"
                }
            ]
        }
        var filters = [];
        if (pageMobile.isDetail == "1") {
            filters.push(
                {
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: "(select iRecNo from bscChildTables where iFormid='" + pageMobile.iformid + "' and sTableName='" + pageMobile.tablename + "')",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iDisabled,0)",
                    ComOprt: "=",
                    Value: "0"
                }
            );
        }
        else {
            filters.push(
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + pageMobile.iformid + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iDisabled,0)",
                    ComOprt: "=",
                    Value: "0"
                }
            );
        }
        sqlObjLookUp.Filters = filters;
        var resultLookUp = SqlGetData(sqlObjLookUp);
        if (resultLookUp.length > 0) {
            var lookupD = [];
            for (var i = 0; i < resultLookUp.length; i++) {
                var fieldid = resultLookUp[i].sFieldName;
                var isIn = false;
                var curtLookUp = undefined;
                for (var j = 0; j < lookupD.length; j++) {
                    if (lookupD[j].fieldid == fieldid) {
                        isIn = true;
                        curtLookUp = lookupD[j];
                        break;
                    }
                }
                var matchFieldStr = resultLookUp[i].sMatchFields;
                var mathcFeildArr = matchFieldStr == "" ? [] : matchFieldStr.split(',');
                var editMatchFieldStr = resultLookUp[i].sEditMatchFields;
                var editMatchField = editMatchFieldStr == "" ? [] : editMatchFieldStr.split(',');
                var lookupObj = {
                    uniqueid: resultLookUp[i].iRecNo,
                    lookUpName: pageMobile.isDetail == "1" ? resultLookUp[i].sLookUpName : resultLookUp[i].sIden,
                    lookUpFilters: resultLookUp[i].sFixFilters,
                    matchFields: mathcFeildArr,
                    modifyOrViewMatchFields: editMatchField,
                    textField: resultLookUp[i].sDisplayField,
                    valueField: resultLookUp[i].sReturnField
                }

                if (isIn == false) {
                    lookupD.push({
                        fieldid: fieldid,
                        lookUpOptions: [lookupObj]
                    })
                }
                else {
                    curtLookUp.lookUpOptions.push(lookupObj);
                }
            }
            if (lookupD.length > 0) {
                for (var i = 0; i < lookupD.length; i++) {
                    var fieldid = lookupD[i].fieldid;
                    var input = $("input[name='" + fieldid + "']");
                    var lookupOStr = JSON2.stringify(lookupD[i].lookUpOptions);
                    $(input).attr("lookUpOptions", lookupOStr);
                }
            }
        }
        //lookup控件初始化
        lookUpMobile.init();
        //初始化控件
        //先获取默认值和必填项
        var defaultValueObj = [];
        var requeridObj = [];
        if (pageMobile.isDetail == "0") {
            //默认值
            var sqlObjDefault = {
                TableName: "bscMainTableDefault",
                Fields: "sFieldName,sDefaultValue",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + pageMobile.iformid + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iDisabled,0)",
                        ComOprt: "=",
                        Value: "0"
                    }
                ]
            }
            var resultDefault = SqlGetData(sqlObjDefault);
            if (resultDefault.length > 0) {
                defaultValueObj = resultDefault;
            }
            //必填项
            var sqlObjReq = {
                TableName: "bscMainTableRequired",
                Fields: "sFieldName,sRequiredTip",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + pageMobile.iformid + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iDisabled,0)",
                        ComOprt: "=",
                        Value: "0"
                    }
                ]
            }
            var resultReq = SqlGetData(sqlObjReq);
            if (resultReq.length > 0) {
                requeridObj = resultReq;
            }
        }
        else {
            //默认值
            var sqlObjDefault = {
                TableName: "bscChildTablesDColumns",
                Fields: "sFieldName,sDefaultValue",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "(select iRecNo from bscChildTables where iFormID='" + pageMobile.iformid + "' and sTableName='" + pageMobile.tablename + "')",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(sDefaultValue,'')",
                        ComOprt: "<>",
                        Value: "''"
                    }
                ]
            }
            var resultDefault = SqlGetData(sqlObjDefault);
            if (resultDefault.length > 0) {
                defaultValueObj = resultDefault;
            }
            //必填项
            var sqlObjReq = {
                TableName: "bscChildTablesDColumns",
                Fields: "sFieldName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "(select iRecNo from bscChildTables where iFormID='" + pageMobile.iformid + "' and sTableName='" + pageMobile.tablename + "')",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iRequired,0)",
                        ComOprt: "=",
                        Value: "1"
                    }
                ]
            }
            var resultReq = SqlGetData(sqlObjReq);
            if (resultReq.length > 0) {
                requeridObj = resultReq;
            }
        }

        var inputs = $("#" + pageMobile.htmlFormID + " input[name]");
        for (var i = 0; i < inputs.length; i++) {
            var type = $(inputs[i]).attr("type");
            var disabled = $(inputs[i]).attr("disabled");
            var fieldid = $(inputs[i]).attr("name");
            var fieldType = $(inputs[i]).attr("fieldType");
            var decimalNum = $(inputs[i]).attr("decimalNum") == undefined || $(inputs[i]).attr("decimalNum") == "" || $(inputs[i]).attr("decimalNum") == null ? 2 : $(inputs[i]).attr("decimalNum");
            var isReadonly = $(inputs[i]).attr("isReadonly") != undefined && $(inputs[i]).attr("isReadonly").toLowerCase() == "true" ? true : false;
            var defaultVal = $(inputs[i]).attr("defaultVal");
            var isRequied = $(inputs[i]).attr("isRequied") != undefined && $(inputs[i]).attr("isRequied").toLowerCase() == "true" ? true : false;
            //后台有没有设置默认值
            for (var j = 0; j < defaultValueObj.length; j++) {
                if (defaultValueObj[j].sFieldName == fieldid) {
                    var defaultO = defaultValueObj[j].sDefaultValue;
                    switch (defaultO) {
                        case "UserID": defaultVal = pageMobile.userid; break;
                        case "UserName": defaultVal = pageMobile.username; break;
                        case "CurrentDate": defaultVal = getNowDate(); break;
                        case "CurrentDateTime": defaultVal = getNowDate() + " " + getNowTime(); break;
                        case "Departid": defaultVal = pageMobile.deptid; break;
                        case "NewGUID": defaultVal = NewGuid(); break;
                        default: defaultVal = defaultO; break;
                    }
                    break;
                }
            }
            //后台有没有设置必填项
            for (var j = 0; j < requeridObj.length; j++) {
                if (requeridObj[j].sFieldName == fieldid) {
                    isRequied = true;
                }
            }

            if (type.toLowerCase() == "text") {
                switch (fieldType) {
                    case undefined:
                    case "字符":
                        {
                            $(inputs[i]).textbox(
                            {
                                value: defaultVal,
                                readonly: isReadonly,
                                required: isRequied,
                                onChange: function (newValue, oldValue) {
                                    if (pageMobile.Formula) {
                                        var aaa = this;
                                        pageMobile.Formula(fieldid, newValue, oldValue);
                                    }
                                }
                            });
                            if (isReadonly == true || disabled == "disabled") {
                                $(inputs[i]).textbox("textbox").addClass("txbreadonly");
                            }
                        } break;
                    case "整数":
                    case "数据":
                        {
                            decimalNum = fieldType == "整数" ? 0 : decimalNum;
                            $(inputs[i]).numberbox(
                            {
                                value: defaultVal,
                                readonly: isReadonly,
                                required: isRequied,
                                precision: decimalNum,
                                onChange: function (newValue, oldValue) {
                                    if (pageMobile.Formula) {
                                        var field = $("#" + this.id).attr("numberboxname");
                                        pageMobile.Formula(field, newValue, oldValue);
                                    }
                                }
                            });
                            if (isReadonly == true || disabled == "disabled") {
                                $(inputs[i]).numberbox("textbox").addClass("txbreadonly");
                            }
                        } break;
                    case "日期":
                        {
                            $(inputs[i]).datebox(
                            {
                                value: defaultVal,
                                readonly: isReadonly,
                                required: isRequied,
                                onSelect: function (date) {
                                    if (pageMobile.Formula) {
                                        pageMobile.Formula(fieldid, date);
                                    }
                                }
                            });
                            if (isReadonly == true || disabled == "disabled") {
                                $(inputs[i]).datebox("textbox").addClass("txbreadonly");
                            }
                        } break;
                    case "时间":
                        {
                            $(inputs[i]).datetimebox(
                            {
                                value: defaultVal,
                                readonly: isReadonly,
                                required: isRequied,
                                onSelect: function (date) {
                                    if (pageMobile.Formula) {
                                        pageMobile.Formula(fieldid, date);
                                    }
                                }
                            });
                            if (isReadonly == true || disabled == "disabled") {
                                $(inputs[i]).datetimebox("textbox").addClass("txbreadonly");
                            }
                        } break;
                    case "逻辑":
                        {
                            $(inputs[i]).switchbutton(
                            {
                                checked: (defaultVal == "1" ? true : false),
                                readonly: isReadonly,
                                onChange: function (checked) {
                                    if (pageMobile.Formula) {
                                        pageMobile.Formula(fieldid, checked);
                                    }
                                }
                            });
                        } break;
                    case "备注":
                        {
                            $(inputs[i]).textbox(
                            {
                                value: defaultVal,
                                multiline: true,
                                readonly: isReadonly,
                                required: isRequied,
                                onChange: function (newValue, oldValue) {
                                    if (pageMobile.Formula) {
                                        pageMobile.Formula(fieldid, newValue, oldValue);
                                    }
                                }
                            });
                            if (isReadonly == true || disabled == "disabled") {
                                $(inputs[i]).textbox("textbox").addClass("txbreadonly");
                            }
                        } break;

                }
                if (isRequied == true) {
                    var li = $(inputs[i]).parent().parent();
                    $(li).css("color", "red");
                }
            }
            else if (type.toLowerCase() == "hidden") {
                //hidden一般是lookup
                var hasLookUp = $(inputs[i]).attr("hasLookUp");
                if (hasLookUp) {
                    if (hasLookUp.toLowerCase() == "true") {
                        //默认值
                        if (pageMobile.usetype == "add") {
                            if (defaultVal != "" && defaultVal != null && defaultVal != undefined) {
                                var targetid1 = $(inputs[i]).attr("id").substr(0, $(inputs[i]).attr("id").indexOf("_"));
                                var lookupObj1 = lookUpMobile.getLookUpObjByTargetID(targetid1);
                                var filter1 = lookupObj1.valueField + "='" + defaultVal + "'";
                                $.ajax(
                                {
                                    url: "/Mobile/Handler/MobileHandler.ashx",
                                    async: false,
                                    cache: false,
                                    type: "post",
                                    data: { otype: "GetLookUpData", lookUpName: lookupObj1.lookUpName, rows: 0, PageSize: 1, filters: filter1 },
                                    success: function (resText) {
                                        var resObj = JSON2.parse(resText);
                                        if (resObj.success == true) {
                                            var dataMatch = resObj.tables[0];
                                            lookUpMobile.setValue(dataMatch[0], targetid1);
                                        }
                                        //                                        else {
                                        //                                            $.messager.alert("获取lookup数据时出错", resObj.message);
                                        //                                        }
                                    },
                                    error: function (resText) {
                                        //$.messager.alert("获取lookup数据时出错", resObj.message);
                                    }
                                }
                                )
                            }
                        }
                        //必填项
                        if (isRequied == true) {
                            $(inputs[i]).attr("isRequired", "true");
                            $(inputs[i]).prev().css("color", "red");
                        }
                    }
                }
                else {
                    //默认值
                    if (pageMobile.usetype == "add") {
                        if (defaultVal != "" && defaultVal != null && defaultVal != undefined) {
                            $(inputs[i]).val(defaultVal);
                        }
                    }
                }
            }
        }

        //获取用户权限
        if (pageMobile.isDetail != "1") {
            $.ajax(
                {
                    url: "/Mobile/Handler/MobileHandler.ashx",
                    async: false,
                    cache: false,
                    type: "post",
                    data: { otype: "GetFormButton", iMenuID: getQueryString("iMenuID") },
                    success: function (resText) {
                        var resObj = JSON2.parse(resText);
                        if (resObj.success == true) {
                            var BtnData = resObj.tables[0];
                            pageMobile.buttonRight = BtnData;
                            //隐藏按钮
                            var hasAdd = false;
                            var hasSubmit = false;
                            var hasModify = false;
                            var hasDelete = false;
                            for (var i = 0; i < BtnData.length; i++) {
                                if (BtnData[i].sRightName == "fadd") {
                                    hasAdd = true;
                                }
                                if (BtnData[i].sRightName == "fmodify") {
                                    hasModify = true;
                                }
                                if (BtnData[i].sRightName == "fdelete") {
                                    hasDelete = true;
                                }
                                if (BtnData[i].sRightName == "submit") {
                                    hasSubmit = true;
                                }
                            }
                            if (hasAdd == false) {
                                $("#btnAdd").hide();
                            }
                            if (hasModify == false) {
                                $("#btnSaveAndContine").hide();
                                $("#btnSave").hide();
                            }
                            if (hasDelete == false) {
                                $("#btnDelete").hide();
                            }
                            if (hasSubmit == false) {
                                $("#btnSubmit").hide();
                            }
                        }
                        else {
                            showMessage("获取按钮时错误", resObj.message);
                        }
                    },
                    error: function (resText) {
                        showMessage("获取按钮时错误", resText.responseText);
                    }
                }
            );
        }
        else {
            $("#btnDetail").hide();
            $("#btnSubmit").hide();
        }


        if (pageMobile.usetype == "add") {
            $("#btnSubmit").hide();
            $("#btnDetail").hide();
            var id = pageMobile.getChildID(pageMobile.serialTablename);
            if (id != "-1") {
                pageMobile.key = id;
            }
            else {
                $.messager.alert("获取主键时发生错误", "获取表单主键时出错误！");
            }
            //如果是子表，则取出自增的列
            if (pageMobile.isDetail == "1") {
                //默认值
                var sqlObjAutoAdd = {
                    TableName: "bscChildTablesDColumns",
                    Fields: "sFieldName",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "(select iRecNo from bscChildTables where iFormID='" + pageMobile.iformid + "' and sTableName='" + pageMobile.tablename + "')",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iAutoAdd,0)",
                        ComOprt: "=",
                        Value: "1"
                    }
                ]
                }
                var resultAutoAdd = SqlGetData(sqlObjAutoAdd);
                if (resultAutoAdd.length > 0) {
                    var fieldAutoAdd = resultAutoAdd[0].sFieldName;
                    var sqlObjAA = {
                        TableName: pageMobile.tablename,
                        Fields: "count(*) as c",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: getQueryString("linkField"),
                                ComOprt: "=",
                                Value: "'" + pageMobile.mainKey + "'"
                            }
                        ]
                    }
                    var resultAA = SqlGetData(sqlObjAA);
                    if (resultAA.length > 0) {
                        var iNext = parseInt(resultAA[0].c) + 1;
                        var adata = {};
                        adata[(fieldAutoAdd)] = iNext;
                        $("#" + pageMobile.htmlFormID).form("load", adata);
                    }
                }
            }
        }
        else if (pageMobile.usetype == "modify" || pageMobile.usetype == "view") {
            pageMobile.key = getQueryString("key");
            //如果是修改且是主表的话，隐藏保存并继续按钮
            if (pageMobile.usetype == "modify" && pageMobile.isDetail == "0") {
                $("#btnSaveAndContine").hide();
            }
            var sqlObjData = {
                TableName: pageMobile.tablename,
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: pageMobile.fieldkey,
                        ComOprt: "=",
                        Value: pageMobile.key
                    }
                ]
            }
            var result = SqlGetData(sqlObjData);
            if (result.length > 0) {
                pageMobile.pageData = result[0];
                $("#" + pageMobile.htmlFormID).form("load", pageMobile.pageData);
                var inputChecks = $("#" + pageMobile.htmlFormID + " input[fieldType='逻辑']");
                for (var i = 0; i < inputChecks.length; i++) {
                    var fieldid = $(inputChecks[i]).attr("switchbuttonname");
                    if (pageMobile.pageData[(fieldid)] && pageMobile.pageData[(fieldid)] == "1") {
                        $("#" + inputChecks[i].id).switchbutton("check");
                    }
                    else {
                        $("#" + inputChecks[i].id).switchbutton("uncheck");
                    }
                }

            }
            if (pageMobile.usetype == "view") {
                disableForm(pageMobile.htmlFormID, true);
                $("#btnDelete").hide();
                $("#btnSubmit").hide();
                $("#btnSaveAndContine").hide();
                $("#btnSave").hide();
            }
            lookUpMobile.load();
        }

        if (getQueryString("hasChild") == "0") {
            $("#btnDetail").hide();
        }
    },
    beforeSave: undefined,
    doNotBackWhenSave: false,
    //不自动编号
    DoNotAutoSerial: undefined,
    //type=0表示保存，=1表示保存并继续
    save: function (type) {
        if (pageMobile.beforeSave) {
            if (pageMobile.beforeSave() == false) {
                return false;
            }
        }
        if (pageMobile.DoNotAutoSerial != true && pageMobile.isDetail != "1" && pageMobile.usetype == "add") {
            //有设置单据编号的生成编号
            var sqlObj = {
                TableName: "bscDataBill",
                Fields: "sFieldName,sDateType",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: pageMobile.iformid
                }]
            }
            var table = SqlGetData(sqlObj);
            if (table && table.length > 0 && table[0].sFieldName != null && table[0].sFieldName.length > 0 && table[0].sDateType != null && table[0].sDateType != undefined && table[0].sDateType != '' && table[0].sDateType.length > 0) {
                var sfiledname = table[0].sFieldName;
                var sDataType = table[0].sDateType;

                var sqlStoreObj = {
                    StoreProName: "Yww_FormBillNoBulid",
                    StoreParms: [{
                        ParmName: "@formid",
                        Value: pageMobile.iformid
                    }
                    ]
                };
                //var result = SqlExecStore("Yww_FormBillNoBulid", getQueryString("iformid"), false);
                var result = SqlStoreProce(sqlStoreObj);
                if (result.length > 0) {
                    var serdata = {};
                    serdata[(sfiledname)] = result;
                    $("#" + pageMobile.htmlFormID).form("load", serdata);
                }
            }
        }


        var isvaidate = $("#" + pageMobile.htmlFormID).form("validate");
        if (isvaidate != true) {
            return false;
        }
        var inputRequired = $("#" + pageMobile.htmlFormID + " input[isRequired]");
        for (var i = 0; i < inputRequired.length; i++) {
            var isreq = $(inputRequired[i]).attr("isRequired");
            if (isreq == "true") {
                var value = $(inputRequired[i]).val();
                if (value == undefined || value == null || value == "") {
                    showMessage("存在必填为空", "存在必填为空");
                    return false;
                }
            }
        }

        var mainData = $("#" + pageMobile.htmlFormID).serializeObject();
        if (pageMobile.isDetail == "1") {
            mainData[(getQueryString("linkField"))] = pageMobile.mainKey;
        }

        var inputChecks = $("#" + pageMobile.htmlFormID + " input[switchbuttonname]");
        for (var i = 0; i < inputChecks.length; i++) {
            var fieldid = $(inputChecks[i]).attr("switchbuttonname");
            if (mainData[(fieldid)] && mainData[(fieldid)] == "on") {
                mainData[(fieldid)] = "1";
            }
        }
        var querystr = {};
        var tablename = pageMobile.tablename;
        var fieldkeys = pageMobile.fieldkey;
        var fieldkeyvalue = pageMobile.key;
        if (pageMobile.usetype == "add") {
            querystr = {
                TableName: tablename,
                Operatortype: "add",
                Data: mainData,
                FieldKeys: fieldkeys,
                FieldKeysValues: fieldkeyvalue
            };
        }
        if (pageMobile.usetype == "modify") {
            querystr = {
                TableName: tablename,
                Operatortype: "update",
                Data: mainData,
                FieldKeys: fieldkeys,
                FieldKeysValues: pageMobile.key,
                FilterFields: fieldkeys,
                FilterComOprts: "=",
                FilterValues: pageMobile.key
            };
        }
        var result = "";
        $.ajax({
            url: "/Base/Handler/DataOperatorNew.ashx",
            type: "POST",
            data: { mainquery: JSON2.stringify(querystr), children: JSON2.stringify([]) },
            cache: false,
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (data) {
                $.messager.alert("出错", data.responseText);
            }
        });

        var eindex = result.indexOf("error:");
        if (eindex > -1) {
            $.messager.alert("保存时出错", result);
        }
        else {
            showMessage("保存成功", "保存成功！");
            pageMobile.usetype = "modify";
            var theUrl = window.location.href;
            theUrl = theUrl.replace("usetype=add", "usetype=modify");


            if (pageMobile.buttonRight) {
                for (var i = 0; i < pageMobile.buttonRight.length; i++) {
                    if (pageMobile.buttonRight[i].sRightName == "submit") {
                        $("#btnSubmit").show();
                        break;
                    }
                }
            }
            if (pageMobile.afterSave) {
                pageMobile.afterSave();
            }
            if (type == 1) {
                var thisUrl = window.location.href;
                var lastKey = getQueryString("lastKey");
                if (lastKey == null) {
                    thisUrl += "&lastKey=" + pageMobile.key;
                }
                else {
                    thisUrl = thisUrl.replace("lastKey=" + lastKey, "lastKey=" + pageMobile.key);
                }
                window.location.href = thisUrl;
            }
            else {
                if (getQueryString("hasChild") != "1") {
                    $.mobile.back();
                }
            }
            if (getQueryString("hasChild") == "1" && pageMobile.isDetail != "1") {
                if (type == 0) {
                    $("#btnDetail").show();
                    window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=1&mainKey=" + pageMobile.key + "&random=" + Math.random();
                }
            }
            if (pageMobile.isDetail == "1") {
                if (type == 0) {
                    window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=1&mainKey=" + pageMobile.mainKey + "&random=" + Math.random();
                }
            }
        }
    },
    removef: function () {
        $.messager.confirm("确认吗？", "您确认删除吗？", function (r) {
            var storeObj = {
                StoreProName: "SpDeleteOrModify",
                StoreParms: [
                    { ParmName: "@iformid", Value: pageMobile.iformid },
                    { ParmName: "@tablename", Value: pageMobile.tablename },
                    { ParmName: "@fieldkey", Value: pageMobile.fieldkey },
                    { ParmName: "@keys", Value: pageMobile.key },
                    { ParmName: "@userid", Value: pageMobile.userid },
                    { ParmName: "@itype", Value: 1 }
                 ]
            }
            var result = SqlStoreProce(storeObj)
            if (result != '1') {
                showMessage('错误', result);
                return false;
            }
            else {
                if (pageMobile.afterRemove) {
                    pageMobile.afterRemove();
                }
                if (pageMobile.isDetail != "1") {
                    window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=0&random=" + Math.random();
                }
                else {
                    window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=1&mainKey=" + pageMobile.mainKey + "&random=" + Math.random();
                }
            }
        })
    },
    afterSave: undefined,
    afterRemove: undefined,
    submit: function () {
        $.messager.confirm("确认提交吗？", "您确认提交吗？", function (r) {
            if (r) {
                var status = approval.formStatus(pageMobile.iformid, pageMobile.key);
                if (status) {
                    if (status.iStatus == 99) {
                        for (var i = 0; i < pageMobile.buttonRight.length; i++) {
                            if (pageMobile.buttonRight[i].sRightName == "submit") {
                                if (pageMobile.buttonRight[i].sStoredProce != "") {
                                    var sqlObj = {
                                        StoreProName: pageMobile.buttonRight[i].sStoredProce,
                                        StoreParms: [
                                    {
                                        ParmName: "@iformid",
                                        Value: pageMobile.iformid
                                    },
                                    {
                                        ParmName: "@keys",
                                        Value: pageMobile.key
                                    },
                                    {
                                        ParmName: "@userid",
                                        Value: pageMobile.userid
                                    },
                                    {
                                        ParmName: "@btnid",
                                        Value: "submit"
                                    }
                                    ]
                                    };
                                    var result = SqlStoreProce(sqlObj);
                                    if (result == "1") {
                                    }
                                    else {
                                        showMessage("错误", result);
                                        return false;
                                    }
                                }
                                else {
                                    if (pageMobile.buttonRight[i].sJsCode != "") {
                                        var jscode = pageMobile.buttonRight[i].sJsCode.replace(/<%userid%>/g, pageMobile.userid).replace(/<%selectedkey%>/g, pageMobile.key);
                                        eval("(" + jscode + ")");
                                    }
                                }
                            }
                        }
                    }
                    else {
                        if (parseInt(status.iStatus) > 1) {
                            showMessage("不可提交", "单据已提交未审批，不可提交");
                        }
                        else {
                            var result = approval.submit(pageMobile.iformid, pageMobile.key);
                            if (result == true) {
                                showMessage("成功", "提交成功！");
                            }
                        }
                    }
                }
            }
        })

    },
    showDetail: function () {
        window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=1&mainKey=" + pageMobile.key + "&random=" + Math.random();
    },
    IconCls: function (icon) {
        var iconCls = "";
        switch (icon) {
            case "add": iconCls = "icon-add"; break;
            case "edit": iconCls = "icon-edit"; break;
            case "remove": iconCls = "icon-remove"; break;
            case "copy": iconCls = "icon-copy"; break;
            case "save": iconCls = "icon-save"; break;
            case "ok": iconCls = "icon-ok"; break;
            case "cut": iconCls = "icon-cut"; break;
            case "reload": iconCls = "icon-reload"; break;
            case "search": iconCls = "icon-search"; break;
            case "print": iconCls = "icon-print"; break;
            case "preview": iconCls = "icon-preview"; break;
            case "next": iconCls = "icon-next"; break;
            case "barcode": iconCls = "icon-barcode"; break;
            case "export": iconCls = "icon-export"; break;
            default: iconCls = "icon-default"; break;
        }
        return iconCls
    },
    toolBarBtnAdd: function (id, text, icon, fun) {
        var iconCls = "icon-default";
        if (icon) {
            iconCls = pageMobile.IconCls(icon);
        }
        var newBtn = $("<a id='" + id + "' class='easyui-linkbutton' data-options='iconCls:&#39" + iconCls + "&#39,plain:true'>" + text + "</a>");
        $(newBtn).bind("click", fun);
        $("#toolbar").prepend(newBtn);
        $.parser.parse('#toolbar');
    },
    Formula: undefined,
    getFieldValue: function (field) {
        var formData = $("#" + pageMobile.htmlFormID).serializeObject();
        var switchBt = $("#" + pageMobile.htmlFormID + " input[switchbuttonname='" + field + "']");
        if (switchBt.length > 0) {
            if (formData[(field)] == "on") {
                return "1";
            }
        }
        return formData[(field)];
    },
    setFieldValue: function (field, value) {
        var setData = {};
        setData[(field)] = value;
        var switchBt = $("#" + pageMobile.htmlFormID + " input[switchbuttonname='" + field + "']");
        if (switchBt.length > 0) {
            if (value == "1") {
                setData[(field)] = "on";
            }
        }
        $("#" + pageMobile.htmlFormID).form("load", setData);
        var theInput = $("#" + pageMobile.htmlFormID + " input[name='" + field + "'][hasLookUp=true]");
        if (theInput.length > 0) {
            var htmlID = $(theInput).attr("id").substr(0, $(theInput).attr("id").indexOf("_"));

            var lookupObj1 = lookUpMobile.getLookUpObjByTargetID(htmlID);
            var filter1 = lookupObj1.valueField + "='" + value + "'";
            $.ajax(
            {
                url: "/Mobile/Handler/MobileHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { otype: "GetLookUpData", lookUpName: lookupObj1.lookUpName, rows: 0, PageSize: 1, filters: filter1 },
                success: function (resText) {
                    var resObj = JSON2.parse(resText);
                    if (resObj.success == true) {
                        var dataMatch = resObj.tables[0];
                        lookUpMobile.setValue(dataMatch[0], htmlID);
                    }
                },
                error: function (resText) {
                    //$.messager.alert("获取lookup数据时出错", resObj.message);
                }
            }
            );
            //lookUpMobile.setValue(setData, htmlID);
        }
    },
    back: function () {
        if (pageMobile.isDetail == "1") {
            $("#form1").form("load", pageMobile.mainData);
        }
    },
    backToList: function () {
        if (pageMobile.isDetail != "1") {
            window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=0&random=" + Math.random();
        }
        else {
            window.location.href = "/Mobile/datalist.htm?iMenuID=" + getQueryString("iMenuID") + "&iFormID=" + pageMobile.iformid + "&isDetail=1&mainKey=" + pageMobile.mainKey + "&random=" + Math.random();
        }
    }
}
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

//获取今天日期：格式2015-01-01
function getNowDate() {
    var nowdate = new Date();
    var year = nowdate.getFullYear();
    var month = nowdate.getMonth();
    var date = nowdate.getDate();
    var monthstr = (month + 1).toString();
    var datestr = date.toString();
    if (month < 9) {
        monthstr = '0' + (month + 1).toString();
    }
    if (date < 10) {
        datestr = '0' + date.toString();
    }
    return year.toString() + "-" + monthstr + "-" + datestr;
}
//获取当前时时
function getNowTime() {
    var nowdate = new Date();
    var hour = nowdate.getHours();      //获取当前小时数(0-23)
    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
    var second = nowdate.getSeconds();
    return hour + ":" + minute + ":" + second;
}
function NewGuid_S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function NewGuid() {
    return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
}
function showMessage(title, message) {
    $.messager.show({
        title: title,
        msg: message,
        showType: 'slide',
        timeout: 1000,
        style: {
            right: '',
            top: document.body.scrollTop + document.documentElement.scrollTop,
            bottom: ''
        }
    });
}
function disableForm(formId, isDisabled) {

    var attr = "disable";
    if (!isDisabled) {
        attr = "enable";
    }
    $("form[id='" + formId + "'] :text").attr("disabled", isDisabled);
    $("form[id='" + formId + "'] textarea").attr("disabled", isDisabled);
    $("form[id='" + formId + "'] select").attr("disabled", isDisabled);
    $("form[id='" + formId + "'] :radio").attr("disabled", isDisabled);
    $("form[id='" + formId + "'] :checkbox").attr("disabled", isDisabled);

    //禁用jquery easyui中的下拉选（使用input生成的combox）  

    $("#" + formId + " input[class='combobox-f combo-f']").each(function () {
        if (this.id) {
            alert("input" + this.id);
            $("#" + this.id).combobox(attr);
        }
    });

    //禁用jquery easyui中的下拉选（使用select生成的combox）  
    $("#" + formId + " select[class='combobox-f combo-f']").each(function () {
        if (this.id) {
            alert(this.id);
            $("#" + this.id).combobox(attr);
        }
    });

    //禁用jquery easyui中的日期组件dataBox  
    $("#" + formId + " input[class='datebox-f combo-f']").each(function () {
        if (this.id) {
            alert(this.id)
            $("#" + this.id).datebox(attr);
        }
    });
}
$(function () {
    if (pageMobile.beforeInit) {
        if (pageMobile.beforeInit() == false) {
            return false;
        }
    }
    pageMobile.init();
    pageMobile.isInited = true;
})