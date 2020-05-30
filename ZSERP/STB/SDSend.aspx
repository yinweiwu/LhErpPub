<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../../../Base/JS/approval.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                //Page.setFieldValue("sSizeGroupID", "0901");
                var sendType = getQueryString("iSendType");
                Page.setFieldValue("iType", sendType);
                //$("#txtBarcode").attr("disabled", true);
            }
            if (Page.usetype == "modify") {
                if (Page.getFieldValue("iRed") != 1) {
                    $("#txtBarcode").attr("disabled", true);
                }
            }
            if (getQueryString("iSendType") == "0") {
                //Page.Children.toolBarBtnDisabled("table1", "add");
            }

            $("#tabMc").datagrid(
                {
                    fit: true,
                    border: false,
                    fit: true,
                    border: false,
                    remoteSort: false,
                    columns: [[
                    { field: "__cb", checkbox: true, width: 40 },
                    { title: "米长", field: "fQty", width: 80 },
                    { field: "sSizeName", hidden: true }
                    ]]
                }
            );
        })

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (tableid == "table1") {
                if (datagridOp.clickColumnName == "sMcSum") {
                    $("#divMc").dialog("open");
                    var sqlObjDD = {
                        TableName: "MMStockQty",
                        Fields: "sBatchNo,fQty",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iBscDataMatRecNo",
                                ComOprt: "=",
                                Value: "'" + row.iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            { SortName: "fQty", SortOrder: "asc" }
                        ]
                    };
                    //alert(row.iBscDataMatRecNo + " " + row.iRecNo);
                    var dataDD = SqlGetData(sqlObjDD);
                    $("#tabMc").datagrid("loadData", dataDD);
                    if (dataDD.length > 0) {
                        var sqlObjSendDD = {
                            TableName: "SDSendDD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + row.iRecNo + "'"
                            }
                            ]
                        };
                        //alert(row.iRecNo);
                        var sendDD = SqlGetData(sqlObjSendDD);
                        if (sendDD.length > 0) {
                            //alert(1);
                            var mmRows = $("#tabMc").datagrid("getRows");
                            for (var i = 0; i < mmRows.length; i++) {
                                for (var j = 0; j < sendDD.length; j++) {
                                    if (sendDD[j].sSizeName == mmRows[i].sBatchNo) {
                                        $("#tabMc").datagrid("checkRow", i);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    return false;
                }
            }
        }

        //在列编辑前，只有红冲才可以编辑款号和颜色字段
        Page.Children.onBeginEdit = function (tableid, index, row) {
            //            if (getQueryString("iSendType") == "0") {
            //                if (tableid == "table1") {
            //                    if (datagridOp.currentColumnName == "sStyleNo" || datagridOp.currentColumnName == "sColorName") {
            //                        if (Page.getFieldValue("iRed") != 1) {
            //                            $.messager.alert("错误", "非红冲不可选择款号或颜色！");
            //                            $("#table1").datagrid("cancelEdit", datagridOp.currentRowIndex);
            //                            return false;
            //                        }
            //                    }
            //                }
            //            }

        };
        function selectMc() {
            var selectedRows = $("#tabMc").datagrid("getChecked");
            if (selectedRows.length > 0) {
                var saveStr = "";
                var showStr = "";
                for (var i = 0; i < selectedRows.length; i++) {
                    saveStr += selectedRows[i].sBatchNo + ":" + selectedRows[i].fQty + ",";
                    showStr += selectedRows[i].fQty + ";";
                }
                if (saveStr != "") {
                    saveStr = saveStr.substr(0, saveStr.length - 1);
                    showStr = showStr.substr(0, showStr.length - 1);
                }
                var selectedSendDRow = $("#table1").datagrid("getRows")[datagridOp.currentRowIndex];
                var iRecNo = selectedSendDRow.iRecNo;
                var jsonobj = {
                    StoreProName: "SpSaveSendDD",
                    StoreParms: [{
                        ParmName: "@iRecNo",
                        Value: iRecNo
                    },
                    {
                        ParmName: "@Str",
                        Value: saveStr,
                        Size: 8000
                    }]
                }
                var result = SqlStoreProce(jsonobj);
                if (result == "1") {
                    $("#table1").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { sMcSum: showStr } });
                    $("#divMc").dialog("close");
                }
                else {
                    Page.MessageShow("错误", result);
                }
            }
        }
        //编辑后计算动态列
        Page.Children.DynFieldAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                var fPrice = isNaN(parseFloat(row.fPrice)) ? 0 : parseFloat(row.fPrice);
                var iSumQty = isNaN(parseInt(row.iSumQty)) ? 0 : parseInt(row.iSumQty);
                var fTotal = (fPrice * iSumQty).toFixed(2);
                var updateRow = { fTotal: fTotal };
                $("#" + tableid).datagrid("updateRow", { index: index, row: updateRow });
            }
        }

        lookUp.beforeOpen = function (uniqueid) {
            if (uniqueid == "383") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    Page.MessageShow("只有红冲才可转入", "只有红冲时才可从已发货订单转入");
                    return false;
                }
            }
        }
        dataForm.beforeOpen = function (uniqueid) {
            if (uniqueid == "366") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    Page.MessageShow("只有红冲才可转入", "只有红冲时才可从发货通知单转入");
                    return false;
                }
            }
        }
        //lookup的设置数据前事件，可返回新数据，替换原数据。将尺码打横
        lookUp.beforeSetValue = function (uniqueid, data) {
            if (uniqueid == "33" || uniqueid == "217" || uniqueid == "52") {
                //33是从行中订单号的转入，217是转入按钮从订单转入，52是转入按钮从库存转入
                var dataProc = [];
                var getObject = function (iRecNoD) {
                    for (var i = 0; i < dataProc.length; i++) {
                        if (dataProc[i].iRecNoD == iRecNoD) {
                            return dataProc[i];
                        }
                    }
                    return undefined;
                }
                for (var j = 0; j < data.length; j++) {
                    var dataRow = data[j];
                    var obj = getObject(dataRow.iRecNoD)
                    if (obj == undefined) {
                        obj = {};
                        for (var o in dataRow) {
                            obj[(o)] = data[j][(o)];
                        }
                        dataProc.push(obj);
                    }
                    //不等于52表示是从订单转入，数量以未发货为准
                    if (uniqueid != "52") {
                        obj[(dataRow.sSizeName)] = dataRow.iNotOutQty;
                    }
                    else {
                        //从库存转入以未发货和客户库存小的为准
                        obj[(dataRow.sSizeName)] = parseInt(dataRow.iNotOutQty) > parseInt(dataRow.iCustQty) ? parseInt(dataRow.iCustQty) : parseInt(dataRow.iNotOutQty);
                    }
                }
                return dataProc;
            }
            if (uniqueid == "40" || undefined == "226") {
                var dataProc = [];
                var getObject = function (iBscDataStyleMRecNo, iBscDataColorRecNo, sSizeName, iSdContractMRecNo) {
                    for (var i = 0; i < dataProc.length; i++) {
                        if (dataProc[i].iBscDataStyleMRecNo == iBscDataStyleMRecNo && dataProc[i].iBscDataColorRecNo == iBscDataColorRecNo && dataProc[i].sSizeName == sSizeName && dataProc[i].iSdContractMRecNo == iSdContractMRecNo) {
                            return dataProc[i];
                        }
                    }
                    return undefined;
                }
                for (var j = 0; j < data.length; j++) {
                    var dataRow = data[j];
                    var obj = getObject(dataRow.iBscDataStyleMRecNo, dataRow.iBscDataColorRecNo, dataRow.sSizeName, dataRow.iSdContractMRecNo);
                    if (obj == undefined) {
                        obj = {};
                        obj.iBscDataStyleMRecNo = dataRow.iBscDataStyleMRecNo;
                        obj.iBscDataColorRecNo = dataRow.iBscDataColorRecNo;
                        obj.sSizeName = dataRow.sSizeName;
                        obj.iSdContractMRecNo = dataRow.iSdContractMRecNo;
                        obj.sOrderNo = data.sOrderNo;
                        obj.sStyleNo = data.sStyleNo;
                        obj.sColorName = dataRow.sColorName;
                        obj.sSizeName = dataRow.sSizeName;
                        obj.sBarCode = dataRow.sBarCode;
                        obj.iQty = dataRow.iQty;
                        dataProc.push(obj);
                    }
                    obj[(dataRow.sSizeName)] = dataRow.iQty;
                }
                return dataProc;
            }
        };
        //lookup选择数据后事件，设置动态列数据
        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "33" || uniqueid == "217" || uniqueid == "40" || undefined == "226") {
                var tableName = $("#table1").attr("tablename");
                var dynColumns = [];
                for (var i = 0; Page.Children.DynColumnsDefined.length; i++) {
                    if (Page.Children.DynColumnsDefined[i].tableName == tableName) {
                        dynColumns = Page.Children.DynColumnsDefined[i].columns;
                        break;
                    }
                }
                var key = "";
                if (dynColumns.length > 0) {
                    var key = "";
                    for (var o in dynColumns[0]) {
                        key = o;
                        break;
                    }
                }
                var rows = $('#table1').datagrid('getRows');
                var sizeQtyData = {};
                for (var i = 0; i < rows.length; i++) {
                    sizeQtyData = rows[i];
                    for (var j = 0; j < data.length; j++) {
                        var dataRow = data[j];
                        if (dataRow.iRecNoD == sizeQtyData.iSdContractDRecNo) {
                            var iSumQty = 0;
                            var total = 0;
                            for (var k = 0; k < dynColumns.length; k++) {
                                sizeQtyData[(dynColumns[k][(key)])] = dataRow[(dynColumns[k][(key)])];
                                if (dataRow[(dynColumns[k][(key)])]) {
                                    iSumQty += parseInt(dataRow[(dynColumns[k][(key)])]);
                                    if (sizeQtyData.fPrice) {
                                        total += parseInt(dataRow[(dynColumns[k][(key)])]) * sizeQtyData.fPrice;
                                    }
                                }
                            }
                            sizeQtyData.iSumQty = iSumQty == 0 ? "" : iSumQty;
                            sizeQtyData.fTotal = total == 0 ? "" : total;
                        }
                    }
                    $('#table1').datagrid('updateRow', {
                        index: i,
                        row: sizeQtyData
                    });
                }
                Page.Children.ReloadFooter("table1");
                Page.Children.ReloadDynFooter("table1");
            }
        };
        Page.afterSave = function () {
            //var jsonobj = {
            //    StoreProName: "SpSDSendRed",
            //    StoreParms: [{
            //        ParmName: "@iRecNo",
            //        Value: Page.key
            //    }]
            //}
            //var result = SqlStoreProce(jsonobj);
            //if (result != "1") {
            //    alert(result);
            //}

            //保存直接提交
            //var statusObj = approval.formStatus(Page.iformid, Page.key);
            //if ((parseInt(statusObj.iStatus) > 1 && parseInt(statusObj.iStatus) != 99) || parseInt(statusObj.iStatus) == -1) {
            //    MessageShow('错误', '单据状态：[' + statusObj.sStatusName + ']，不可提交！');
            //}
            //else {
            //    if (approval.submit(Page.iformid, Page.key) == false) {
            //        if (Page.usetype == "add") {
            //            //Page.usetype == "modify";
            //            Page.DoNotCloseWinWhenSave = true;
            //        }
            //    }
            //}
        };
        function SwitchBarcode() {
            if ($("#__ExtCheckbox22")[0].checked == false) {
                $("#txtBarcode").val("");
                $("#txtBarcode").attr("disabled", true);
                $("#spanBarcodeTip").html("");
            }
            else {
                //$("#txtBarcode").val("");
                $("#txtBarcode").attr("disabled", false);
                $("#txtBarcode").focus();
                //$("#spanBarcodeTip").html("");
            }
        }
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    //大货订单，从成品出库单明细中取iSdContractDRecNo不为空的，如果为空，则让做其他发货通知单
                    if (getQueryString("iSendType") == "0") {
                        var sqlObj = {
                            TableName: "vwMMProductOutD",
                            Fields: " top 1 iBscDataStyleMRecNo,iBscDataColorRecNo,sSizeName,fPrice,iSdContractDRecNo,sStyleNo,sColorName",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "sBarCode",
                                ComOprt: "=",
                                Value: "'" + barcode + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iStockBscDataCustomerMRecNo", //库存客户ID
                                ComOprt: "=",
                                Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "isnull(iSdContractDRecNo,0)",
                                ComOprt: "<>",
                                Value: "0"
                            }
                            ],
                            Sorts: [
                                { SortName: "dInputDate", SortOrder: "desc" }
                            ]
                        }
                        var resultData = SqlGetData(sqlObj);
                        if (resultData && resultData.length > 0) {
                            var data = resultData[0];
                            data[(resultData[0].sSizeName)] = 1;
                            Page.tableToolbarClick("add", "table1", data);
                        }
                        else {
                            var message = $("#txaBarcodeTip").val();
                            $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                            PlayVoice("条码" + barcode + "不存在");
                            //setTimeout("$('#spanBarcodeTip').html('');", 2500);
                        }
                    }
                        //其他通知单，先从成品出库单明细中取，如果没有则从vwProOrderDBarCode中取
                    else if (getQueryString("iSendType") == "1") {
                        var sqlObj = {
                            TableName: "MMProductOutD",
                            Fields: " top 1 iBscDataStyleMRecNo,iBscDataColorRecNo,sSizeName,fPrice,iSdContractDRecNo,sStyleNo,sColorName",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "sBarCode",
                                ComOprt: "=",
                                Value: "'" + barcode + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iStockBscDataCustomerMRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'"
                            }
                            ],
                            Sorts: [
                                { SortName: "dInputDate", SortOrder: "desc" }
                            ]
                        }
                        var resultData = SqlGetData(sqlObj);
                        if (resultData && resultData.length > 0) {
                            var data = resultData[0];
                            data[(resultData[0].sSizeName)] = 1;
                            Page.tableToolbarClick("add", "table1", data);
                        }
                        else {
                            var sqlObj2 = {
                                TableName: "vwProOrderDBarCode ",
                                Fields: " top 1 iBscDataStyleMRecNo,iBscDataColorRecNo,sSizeName,sStyleNo,sColorName",
                                SelectAll: "True",
                                Filters: [
                            {
                                Field: "sBarCode",
                                ComOprt: "=",
                                Value: "'" + barcode + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataCustomerRecno",
                                ComOprt: "=",
                                Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'"
                            }
                                ],
                                Sorts: [
                                { SortName: "dInputDate", SortOrder: "desc" }
                                ]
                            }
                            var resultData2 = SqlGetData(sqlObj2);
                            if (resultData2 && resultData2.length > 0) {
                                var data2 = resultData2[0];
                                data2[(resultData2[0].sSizeName)] = 1;
                                Page.tableToolbarClick("add", "table1", data2);
                            }
                            else {
                                var message = $("#txaBarcodeTip").val();
                                $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                PlayVoice("条码" + barcode + "不存在");
                            }
                        }
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }
        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }
        //        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
        //            if (tableid == "table1") {
        //                if ((datagridOp.currentColumnName == "fTotal" || datagridOp.currentColumnName == "iSumQty" || datagridOp.currentColumnName == "fPrice") && (changes.fTotal || changes.iSumQty || changes.fPrice)) {
        //                    Page.setFieldValue("fRealTotal", Page.getFieldValue("fTotal"));
        //                }
        //            }
        //        }
        function selectAdress(obj) {
            if (obj.checked == true) {
                if (obj.value == "1") {
                    Page.setFieldValue("sAddress", Page.getFieldValue("sAddress_1"));
                    Page.setFieldValue("sPerson", Page.getFieldValue("sPerson_1"));
                    Page.setFieldValue("sTel", Page.getFieldValue("sPersonTel_1"));
                } else {
                    Page.setFieldValue("sAddress", Page.getFieldValue("sAddress_2"));
                    Page.setFieldValue("sPerson", Page.getFieldValue("sPerson_2"));
                    Page.setFieldValue("sTel", Page.getFieldValue("sPersonTel_2"));
                }
            }
        }
    </script>
    <style type="text/css">
        #Text1 {
            width: 416px;
            height: 42px;
        }

        #divAddress input {
            width: 100px;
        }

        #divUp input {
            width: 100px;
        }

        #__ExtCheckbox22 {
            width: 15px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div id="divUp" data-options="region:'north',border:false" style="overflow: hidden; height: 170px;">
            <!--如果只有一个主表，这里的north要变为center-->
            <!--隐藏字段-->
            <div id="divHid" style="display: none;">
                <%--<cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="iType" />--%>
                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iStatus" Z_Value="0" />
                <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="iBillType" Z_Value="0" />

                <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sAddress_1" Z_readOnly="true" Z_NoSave="true" />

                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sPerson_1" Z_readOnly="true" Z_NoSave="true" />

                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sPersonTel_1" Z_readOnly="true" Z_NoSave="true" />

                <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sAddress_2" Z_readOnly="true" Z_NoSave="true" />

                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sPerson_2" Z_readOnly="true" Z_NoSave="true" />

                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sPersonTel_2" Z_readOnly="true" Z_NoSave="true" />

            </div>
            <table>
                <tr>
                    <td style="vertical-align: top;">
                        <table class="tabmain">
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>通知单号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                                        Z_Required="False" />
                                </td>
                                <td>通知日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                                        Z_Required="True" />
                                </td>
                                <td>发货日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期"
                                        Z_Required="True" />
                                </td>
                                <td>客户
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                        Z_Required="True" />
                                </td>
                            </tr>
                            <tr>
                                <td>业务员
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sSaleID" />
                                </td>
                                <td>客户余额
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_readOnly="True" Z_decimalDigits="2"
                                        Z_FieldID="fCustBalance" Z_NoSave="True" />
                                </td>
                                <td>发货数量
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox218" runat="server" Z_FieldID="fQty" Z_readOnly="True" Z_FieldType="数值" Z_decimalDigits="2" />
                                </td>
                                <td>金额
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox219" runat="server" Z_FieldID="fTotal" Z_readOnly="True" Z_FieldType="数值" Z_decimalDigits="2" />
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 60px;" colspan="2">
                                    <cc1:ExtCheckbox2 ID="ExtCheckbox22" runat="server" onclick="SwitchBarcode()" Z_FieldID="iRed"
                                        Style="width: 15px;" />
                                    <label for="__ExtCheckbox22">
                                        红冲</label>
                                </td>
                                <td>备注
                                </td>
                                <td colspan="5">
                                    <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Style="width: 99%;" />
                                </td>
                            </tr>
                            <tr>
                                <td>制单人
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox214" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                                </td>
                                <td>制单日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                                        Z_readOnly="True" />
                                </td>
                            </tr>

                        </table>
                    </td>
                    <td>
                        <div id="divAddress" class="easyui-panel" data-options="title:'收货信息',iconCls:'icon-businessCard'">
                            <table class="tabmain">
                                <tr>
                                    <td>物流公司
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sExpressCompany" />
                                    </td>
                                    <td>快递单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sExpressNo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>运费
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fFreight" Z_FieldType="数值" />
                                    </td>
                                    <td colspan="2">
                                        <input type="radio" onclick="selectAdress(this)" style="width: 20px;" id="inputAddr1" name="ckbAddress" value="1" /><label for="inputAddr1">收货地址1</label>
                                        <input type="radio" onclick="selectAdress(this)" style="width: 20px;" id="inputAddr2" name="ckbAddress" value="2" /><label for="inputAddr2">收货地址2</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>收货人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sPerson" />
                                    </td>
                                    <td>联系电话
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sTel" />
                                    </td>
                                </tr>
                                <%--<tr>
                                    <td>运输方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sTransType" />
                                    </td>
                                    <td>包装方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sPackageType" />
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td>收货地址
                                    </td>
                                    <td colspan="3">
                                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sAddress" Style="width: 200px;" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <!--主表部分-->

        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="发货通知单明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDSendD">
                    </table>
                </div>
            </div>
        </div>
        <div id="divMc" class="easyui-dialog" data-options="modal:true,title:'选择米长',width:200,height:350,closed:true,buttons:[{text:'确认选择',handler:selectMc},{text:'关闭',handler:function(){$('#divMc').dialog('close');}}]">
            <table id="tabMc">
            </table>
        </div>
    </div>
</asp:Content>
