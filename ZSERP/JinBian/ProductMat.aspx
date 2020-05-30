<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        window._bused = false;
        $(function () {
            if (getQueryString("iFace") == "1") {
                $("#tdFace").hide();                
            }
            //if (getQueryString("iUnitLength") != "1") {
            //    $("#tdPer").hide();
            //}
            if (getQueryString("iformid") == "555784") {
                $(".tdDk").hide();
                $("#spanCode").html("吊卡");
            }
            var jsonobj = {
                StoreProName: "SpbscDataMatDeleteCheck",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                window._bused = false;
            }
            var iBscDataFabRecNo = Page.getFieldValue('iBscDataFabRecNo');
            var sqlobj = {
                TableName: "bscDataMat",
                Fields: "sName",
                SelectAll: "True",
                Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + iBscDataFabRecNo + "'" }]
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                Page.setFieldValue('sName1', data[0].sName);
            }

            if (getQueryString("iBillType") == "2") {
                //$(".span").html("样品");
                //$(".hide").hide();
                //$("#__ExtTextBox1").removeClass("txbrequired");
                //$("#__ExtTextBox1").addClass("txbreadonly");
            }

            $("#__ExtTextBox12").textbox({
                onChange: function (newValue, oldValue) {
                    fnJiSuanfMeterLength();
                }
            })
            $("#__ExtTextBox23").textbox({
                onChange: function (newValue, oldValue) {
                    fnJiSuanfMeterLength();
                }
            })

            if (window._bused == true) {
                Page.setFieldDisabled("sCode")
                Page.setFieldDisabled("sName")
                Page.setFieldDisabled("sEngName")
                Page.setFieldDisabled("sClassID")
                Page.setFieldDisabled("bMergeMat")
                Page.setFieldDisabled("iBscDataFabRecNo")
                Page.setFieldDisabled("fProductWidth")
                Page.setFieldDisabled("fProductWeight")
                Page.setFieldDisabled("sMatUse")

                Page.setFieldDisabled("sSampleBillNo")

            }
            Page.Children.toolBarBtnDisabled("table4", "add")
            //Page.Children.toolBarBtnDisabled("table4", "delete")

            Page.Children.toolBarBtnAdd("table4", "addgongyi", "增加工艺", "", function () {
                window.open('/Base/FormList.aspx?MenuTitle=%u82B1%u578B%u4FE1%u606F&MenuID=440&FormID=5005', '', 'width=1000,height=600');
            })

            Page.Children.toolBarBtnAdd("BscDataMatDColor", "zhuandiao", "转吊卡", "", function () {
                var rows = $("#BscDataMatDColor").datagrid("getChecked");
                for (var i = 0; i < rows.length; i++) {
                    var jsonobj = {
                        StoreProName: "spBscDataMatDColorChangeAdd",
                        StoreParms: [
                        {
                            ParmName: "@iRecNo",
                            Value: rows[i].iRecNo
                        }

                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result == "1") {
                        var index = $("#BscDataMatDColor").datagrid("getRowIndex", rows[i]);
                        $("#BscDataMatDColor").datagrid("updateRow", {
                            index: index,
                            row: {
                                iOrderAdd: 0
                            }
                        })
                    }

                }

            })
            if (getQueryString("iFace") == "1") {
                //$("#divChildrenTab").tabs("disableTab", "面布");
                //$("#divChildrenTab").tabs("disableTab", "底布");
                $("#table2").remove();
                $("#table3").remove();
                $("#divChildrenTab").tabs("close", "面布");
                $("#divChildrenTab").tabs("close", "底布");
            }
        })

        fnJiSuanfMeterLength = function () {
            var fProductWidth = Page.getFieldValue("fProductWidth");
            var fProductWeight = Page.getFieldValue("fProductWeight");

            fProductWidth = isNaN(Number(fProductWidth)) == true ? 0 : Number(fProductWidth);
            fProductWeight = isNaN(Number(fProductWeight)) == true ? 0 : Number(fProductWeight);
            if ((fProductWidth / 100) * (fProductWeight / 1000) != 0) {
                Page.setFieldValue("fMeterLength", (1 / ((fProductWidth / 100) * (fProductWeight / 1000))).toFixed(2));
            } else {
                Page.setFieldValue("fMeterLength", "0");
            }
        }

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (window._bused == true) {
                if (tableid == "table4" || tableid == "table2" || tableid == "table3") {

                    return false;
                }
            }
        }
        Page.beforeSave = function () {
            //获取分类，编号自动产生时分类不能为空
            var sClassID = Page.getFieldValue("sClassID");
            if (sClassID == "") {
                Page.MessageShow("分类不能为空！", "分类不能为空！");
                return false;
            }
            var sqlObjClass = {
                TableName: "BscDataClass",
                Fields: "1", SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
                    }, {
                        Field: "len(sClassID)", ComOprt: ">", Value: sClassID.length, LinkOprt: "and"
                    }, {
                        Field: "sType", ComOprt: "=", Value: "'mat'"
                    }
                ]
            }
            var resultClass = SqlGetData(sqlObjClass);
            if (resultClass.length > 0) {
                Page.MessageShow("分类必须要是末级分类", "分类必须要是末级分类");
                return false;
            }
            if (getQueryString("iBillType") != "2") {
                var pre = getQueryString("iFace") == "1" ? "M" : "F";
                if (Page.usetype == "add") {
                    if (getQueryString("iCodeAuto") == "1") {
                        var sCode = "";
                        var resultMaxCode = SqlGetData(
                            {
                                TableName: "BscDataMat", Fields: "max(right(sCode,len(sCode)-1)) as sMaxCode", SelectAll: "True",
                                Filters: [
                                    {
                                        Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
                                    }, {
                                        Field: "iMatType", ComOprt: "=", Value: 2
                                    }
                                ]
                            });
                        if (resultMaxCode.length > 0) {
                            var sMaxCode = resultMaxCode[0].sMaxCode;
                            if (sMaxCode) {
                                var lsh = sMaxCode.substr(sMaxCode.length - 4, 4);
                                var maxid = parseInt(lsh, 10);
                                maxid = maxid + 1;
                                var length = maxid.toString().length;
                                for (var i = 0; i < 4 - length; i++) {
                                    maxid = "0" + maxid.toString();
                                }
                                sCode = pre + sClassID + maxid;
                            }
                            else {
                                sCode = pre + sClassID + "0001";
                            }
                        } else {
                            sCode = pre + sClassID + "0001";
                        }
                        Page.setFieldValue("sCode", sCode);
                    }                    
                }
                //if (Page.usetype == "modify") {
                //    var sCode = Page.getFieldValue("sCode");
                //    var theCodeClassID = sCode.substr(1, sClassID.length);
                //    if (theCodeClassID != sClassID) {
                //        var resultMaxCode = SqlGetData(
                //        {
                //            TableName: "BscDataMat", Fields: "max(right(sCode,len(sCode)-1)) as sMaxCode", SelectAll: "True",
                //            Filters: [
                //                {
                //                    Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
                //                }, {
                //                    Field: "iMatType", ComOprt: "=", Value: 2
                //                }
                //            ]
                //        });
                //        if (resultMaxCode.length > 0) {
                //            var sMaxCode = resultMaxCode[0].sMaxCode;
                //            if (sMaxCode) {
                //                var lsh = sMaxCode.substr(sMaxCode.length - 4, 4);
                //                var maxid = parseInt(lsh, 10);
                //                maxid = maxid + 1;
                //                var length = maxid.toString().length;
                //                for (var i = 0; i < 4 - length; i++) {
                //                    maxid = "0" + maxid.toString();
                //                }
                //                sCode = pre + sClassID + maxid;
                //            }
                //            else {
                //                sCode = pre + sClassID + "0001";
                //            }
                //        } else {
                //            sCode = pre + sClassID + "0001";
                //        }
                //        Page.setFieldValue("sCode", sCode);
                //    }
                //}
            }

            var rows = $("#BscDataMatDColor").datagrid("getRows").filter(function (p) {
                return p.iOrderAdd != 1;
            });
            var bl = false;
            for (var i = 0; i < rows.length; i++) {
                for (var j = 0; j < rows.length; j++) {
                    if (rows[i].iRecNo != rows[j].iRecNo) {
                        if (rows[i].iBscDataColorRecNo == rows[j].iBscDataColorRecNo) {
                            Page.MessageShow("错误提示", "同一产品的颜色不能重复");
                            bl = true;
                            return false;
                        }
                        if (rows[i].sSerial == rows[j].sSerial) {
                            Page.MessageShow("错误提示", "同一产品的颜色序列号不能重复");
                            bl = true;
                            return false;
                        }
                    }
                }
            }
            for (var i = 0; i < rows.length; i++) {
                var sSerial = rows[i].sSerial ? rows[i].sSerial : "";
                var sqlObj = {
                    TableName: "BscDataMatDColor",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "isnull(sSerial,'')='" + sSerial + "' and iMainRecNo in (select iRecNo from bscDataMat where iRecNo<>'" + Page.key + "' and  isnull(sCraneCardNo,'')='" + Page.getFieldValue("sCraneCardNo") + "')",
                            ComOprt: "",
                            Value: "",
                            LinkOprt: "and"
                        }, {
                            Field: "isnull(iOrderAdd,0)",
                            ComOprt: "=",
                            Value: "0"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    Page.MessageShow("错误提示", "同一吊卡号的序列号[" + sSerial + "]不能重复");
                    bl = true;
                    return false;
                }
            }
            fnJiSuanfMeterLength();
            $("#table3").attr("tablename", "bscDataMatDWaste")
            if (getQueryString("iBillType") == "2") {
                if (Page.usetype == "add" && Page.getFieldValue("sCode") == "") {
                    var sCode = "";
                    var sqlObj = {
                        TableName: "BscDataMat",
                        Fields: "max(sCode) as sCode",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sCode",
                                ComOprt: "like",
                                Value: "'KF%'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        if (result[0].sCode != null && result[0].sCode != undefined && result[0].sCode != "") {
                            var maxidStr = result[0].sCode.substr(2, 6);
                            var maxid = parseFloat(maxidStr);
                            maxid = maxid + 1;
                            var length = maxid.toString().length;
                            for (var i = 0; i < 6 - length; i++) {
                                maxid = "0" + maxid.toString();
                            }
                            sCode = "KF" + maxid;
                        }
                        else {
                            sCode = "KF000001";
                        }
                    }
                    else {
                        sCode = "KF000001";
                    }
                    Page.setFieldValue("sCode", sCode);
                }

                var iBscDataFabRecNo = Page.getFieldValue("iBscDataFabRecNo");
                if (iBscDataFabRecNo == "") {
                    Page.MessageShow("开发样坯布编号不能为空", "开发样坯布编号不能为空");
                    return false;
                }
            }
            var sCode = Page.getFieldValue("sCode");
            var sqlObj1 = {
                TableName: "BscDataMat",
                Fields: "iRecNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode", ComOprt: "=", Value: "'" + sCode + "'", LinkOprt: "and"
                    }, {
                        Field: "iRecNo", ComOprt: "<>", Value: "'" + Page.key + "'"
                    }
                ]
            }
            var result1 = SqlGetData(sqlObj1);
            if (result1.length > 0) {
                Page.MessageShow("成品编号不能重复", "成品编号不能重复");
                return false;
            }
            if (Page.getFieldValue("sName") == '') {
                var sname = "";
                if (Page.getFieldValue("bMergeMat") == "1") {
                    var rows = $("#table2").datagrid("getRows");
                    if (rows.length > 0) {
                        sname = rows[0].sName || "";
                    }
                } else {
                    sname = Page.getFieldValue("sName1");
                    var rows = $("#table4").datagrid("getRows");
                    $(rows).each(function () {
                        sname = sname + (this.sProcessesName || "");
                    })
                }
                Page.setFieldValue("sName", sname);
            }
            if (getQueryString("iFace") != "1") {
                var mianrows = $("#table2").datagrid("getRows");
                var dirows = $("#table3").datagrid("getRows");

                if (Page.getFieldValue("bMergeMat") == "1") {

                    if (mianrows.length == 0) {
                        Page.MessageShow("当前产品为复合布，面布信息必须存在", "当前产品为复合布，面布信息必须存在");
                        return false;
                    }

                    if (dirows.length == 0) {
                        Page.MessageShow("当前产品为复合布，底布信息必须存在", "当前产品为复合布，底布信息必须存在");
                        return false;
                    }
                }

                if (mianrows.length > 0 || dirows.length > 0) {
                    if (Page.getFieldValue("bMergeMat") == "1") { } else {
                        Page.MessageShow("底布、面布信息必须存在时，当前产品必须标记为复合布", "底布、面布信息必须存在时，当前产品必须标记为复合布");
                        return false;
                    }
                }
            }
            
            if (getQueryString("iRouteMust") == "1") {
                var rows = $("#table4").datagrid("getRows");
                if (rows.length == 0) {
                    Page.MessageShow("工序不能为空", "工序不能为空");
                    return false;
                }


                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].iRequired == 1) {
                        if (!rows[i].iBscDataFlowerRecNo) {
                            Page.MessageShow("工序第[" + (i + 1) + "]行，工艺必填", "工序第[" + (i + 1) + "]行，工艺必填");
                            return false;
                        }
                    }
                }
            }
            if (getQueryString("iformid") == "555784") {
                Page.setFieldValue("sCraneCardNo", Page.getFieldValue("sCode"));
            }
            

            //var sProcessInfo = getsProcessInfo2();
            //Page.setFieldValue("sProcessInfo", sProcessInfo);

            //var sIdenInfo = getsIdenInfo();
            //Page.setFieldValue("sIdenInfo", sIdenInfo);

            //Page.setFieldValue("sProcessRoute", getsProcessInfo());
            //Page.setFieldValue("sProcessTech", getsProcessInfo3())

            //var sqlObj = {
            //    TableName: "BscDataMat",
            //    Fields: "iRecNo",
            //    SelectAll: "True",
            //    Filters: [
            //        {
            //            Field: "iMatType=2 and isnull(sClassID,'') like '0903%' and isnull(sClassID,'') not like '090302%' and iRecNo<>'" + Page.key + "' and isnull(sIdenInfo,'')='" + sIdenInfo + "'",
            //            ComOprt: "",
            //            Value: ""
            //        }
            //    ]
            //}
            //var result = SqlGetData(sqlObj);
            //if (result.length > 0) {
            //    Page.MessageShow("当前产品已经存在", "当前产品已经存在");
            //    return false;
            //}
        }

        function getsProcessInfo3() {
            var ss = "";
            var rows = $("#table4").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].sFlowerType) {
                    if (ss == "") {
                        ss = (rows[i].sFlowerType ? (rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType) : "");
                    } else {
                        ss = ss + ";" + (rows[i].sFlowerType ? (rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType) : "");
                    }
                }
            }
            return ss;
        }

        function getsProcessInfo2() {
            var ss = "";
            var rows = $("#table4").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].sFlowerType) {
                    if (ss == "") {
                        ss = (rows[i].sProcessesName ? rows[i].sProcessesName : "") + (rows[i].sFlowerType ? ("(" + rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType + ")") : "");
                    } else {
                        ss = ss + ";" + (rows[i].sProcessesName ? rows[i].sProcessesName : "") + (rows[i].sFlowerType ? ("(" + rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType + ")") : "");
                    }
                }
            }
            return ss;
        }

        function getsProcessInfo() {
            var ss = "";
            var rows = $("#table4").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                if (ss == "") {
                    ss = (rows[i].sProcessesName ? rows[i].sProcessesName : "") + (rows[i].sFlowerType ? ("(" + rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType + ")") : "");
                } else {
                    ss = ss + "->" + (rows[i].sProcessesName ? rows[i].sProcessesName : "") + (rows[i].sFlowerType ? ("(" + rows[i].sFlowerTypeID + "-" + rows[i].sFlowerType + ")") : "");
                }
            }
            return ss;
        }

        getsIdenInfo = function () {
            var ss = "";

            var sProcessInfo = getsProcessInfo();

            ss = Page.getFieldValue("sClassID");
            ss = ss.substring(ss.length - 2);
            ss = ss + Page.getFieldValue("fProductWidth").toString() + Page.getFieldValue("fProductWeight").toString() + Page.getFieldValue("iBscDataFabRecNo").toString();
            ss = ss + sProcessInfo;
            if (getQueryString("iFace") != "1") {
                var rows = $("#table2").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    ss = ss + (rows[i].iBscDataMatRecNo ? rows[i].iBscDataMatRecNo : "").toString();
                }
                var rows = $("#table3").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    ss = ss + (rows[i].iBscDataMatRecNo ? rows[i].iBscDataMatRecNo : "").toString();
                }
            }            
            return ss;
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "2344" || uniqueid == "2412" || uniqueid == "2529") {
                var deleteKey = $("#table4").attr("deleteKey");
                if (deleteKey == undefined || deleteKey == null) {
                    deleteKey = "";
                }
                var rows = $("#table4").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    deleteKey += rows[i].iRecNo + ",";
                }
                $("#table4").attr("deleteKey", deleteKey);
                $("#table4").datagrid("loadData", []);
                //for (var i = 0; i < rows.length; i++) {
                //    var theRowIndex = $("#table4").datagrid("getRowIndex", rows[i]);
                //    $("#table4").datagrid("deleteRow", theRowIndex);
                //}
                var iBscDataRouteRecNo = Page.getFieldValue("iBscDataRouteRecNo");
                if (iBscDataRouteRecNo != "") {
                    var sqlObj = {
                        TableName: "vwBscDataRouteD",
                        Fields: "iSerial,iBscDataProcessMRecNo iBscDataProcessesMRecNo,sProcessesName,sFeedType,fLoss,iProduceType,iRequired,iFeedType,iComNotUse",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo='" + iBscDataRouteRecNo + "'",
                                ComOprt: "",
                                Value: ""
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    for (var j = 0; j < result.length; j++) {
                        Page.tableToolbarClick("add", "table4", result[j]);
                    }
                }
                //}
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <br />
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox9" Z_FieldID="sProcessInfo" runat="server" />

                <cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sIdenInfo" runat="server" />

                <cc1:ExtTextBox2 ID="ExtTextBox15" Z_FieldID="sProcessTech" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="sProcessRoute" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="2" />
            </div>
            <table class="tabmain">
                <tr>
                    <td class="tdDk">吊卡号
                    </td>
                    <td class="tdDk">
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sCraneCardNo" Z_disabled="False" />
                    </td>
                    <td>工艺路线
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="iBscDataRouteRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <span id="spanCode" class="span">产品</span>编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>
                        <span class="span">产品</span>名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sName" />
                    </td>
                    <td>英文名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sEngName" />
                    </td>
                    <td width="50px">类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" />
                    </td>

                </tr>
                <tr>
                    <td>坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataFabRecNo" />
                    </td>
                    <td>坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sName1" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>

                    <%-- <td>坯布幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fFabWidth" Z_NoSave="True" Z_readOnly="True"  />
                    </td>
                    <td>坯布克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fFabWeight" Z_NoSave="True" Z_readOnly="True"  />
                    </td>--%>

                    <td>样本号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sSampleBillNo" Z_disabled="False" />
                    </td>
                    <td id="tdface">
                        <label>
                            复合布<cc1:ExtCheckbox2 runat="server" Z_FieldID="bMergeMat" />
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>成品幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fProductWidth" Z_disabled="False" />
                    </td>
                    <td>成品克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fProductWeight" Z_disabled="False" />
                    </td>
                    <td>米长
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fMeterLength" Z_FieldType="数值" Z_decimalDigits="2" Z_disabled="true" />
                    </td>
                    <td class="tdPer">成品匹长
                    </td>
                    <td class="tdPer">
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fPerQty" Z_FieldType="数值" />
                    </td>
                    
                </tr>
                <tr>
                    <td>坯布幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fFabWidth" Z_readOnly="true" Z_disabled="False" />
                    </td>
                    <td>坯布克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fFabWeight" Z_readOnly="true" Z_disabled="False" />
                    </td>
                    <td class="tdPer">坯布匹长
                    </td>
                    <td class="tdPer">
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="fOneWeight" Z_FieldType="数值" />
                    </td>
                    <td>成 份
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sMatUse" Z_readOnly="true"
                            Z_NoSave="true" runat="server" Style="width: 99%;" />
                    </td>                    
                </tr>
                <tr>
                    <td>备 注
                    </td>
                    <td>
                        <textarea name="sRemark" fieldid="sRemark" style="width: 99%;"></textarea>
                    </td>
                    <td>停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                    </td>
                    <td>录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" Z_FieldType="时间" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="divChildrenTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="后处理工序">
                    <table id="table4" tablename="bscDataMatDProcesses">
                    </table>
                </div>
                <div data-options="fit:true" title="颜色">
                    <!--  子表1  -->
                    <table id="BscDataMatDColor" tablename="BscDataMatDColor">
                    </table>
                </div>
                <div id="divFace" data-options="fit:true" title="面布">
                    <!--  子表1  -->
                    <table id="table2" tablename="bscDataMatDWaste">
                    </table>
                </div>
                <div id="divBottom" data-options="fit:true" title="底布">
                    <!--  子表1  -->
                    <table id="table3" tablename="bscDataMatDWaste2">
                    </table>
                </div>
                <div data-options="fit:true" title="机台参数">
                    <!--  子表1  -->
                    <table id="table5" tablename="bscDataMatDMachineParam">
                    </table>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
