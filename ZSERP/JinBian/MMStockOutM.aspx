<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var iBillType = "";
        $(function () {
            if (Page.usetype == "add") {
                iBillType = getQueryString("iBillType");
                Page.setFieldValue("iBillType", iBillType);
                var sqlObj = {
                    TableName: "bscDataPeriod",
                    Fields: "sYearMonth",
                    SelectAll: "True",
                    Filters: [
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: ">=",
                                Value: "dBeginDate",
                                LinkOprt: "and"
                            },
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: "<=",
                                Value: "dEndDate"
                            }]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }
            }
            $("#tdProPlanD").datagrid(
            {
                toolbar: '#dgtool',
                fit: true,
                border: false,
                remoteSort: false,
                singleSelect: true,
                columns: [
                [
                    { field: "__ck", checkbox: true },
                    { field: "sSendFinish", title: "完成否", width: 50, align: "center" },
                    { field: "sOrderNo", title: "订单号", width: 80, align: "center" },
                    { field: "sCustShortName", title: "染厂", width: 80, align: "center" },  
                    { field: "sFabCustShortName", title: "坯布厂家", width: 80, align: "center" }, 
                    { field: "sName", title: "产品名称", width: 80, align: "center" },
                    { field: "sBscDataFabCode", title: "坯布编号", width: 100, align: "center" },
                    { field: "sBscDataFabName", title: "坯布名称", width: 80, align: "center" },
                    //{ field: "sColorID", title: "色号", width: 80, align: "center" },
                    //{ field: "sColorName", title: "颜色", width: 80, align: "center" },
                    //{ field: "sUnitName", title: "单位", width: 80, align: "center" },
                    { field: "iQty", title: "下单<br />匹数", width: 40, align: "center" },
                    { field: "iOutQty", title: "已发<br />匹数", width: 40, align: "center" },
                    { field: "iNotOutQty", title: "未发<br />匹数", width: 40, align: "center" },
                    { field: "fFabQty", title: "下单重量", width: 80, align: "center" },
                    { field: "fOutQty", title: "已发重量", width: 80, align: "center" },
                    { field: "fNotOutQty", title: "未发重量", width: 80, align: "center" },
                    //{ field: "fPrice", title: "单价", width: 80, align: "center" },
                    { field: "sReMark", title: "备注", width: 80, align: "center" },
                    { field: "sBillNo", title: "加工单号", width: 130, align: "center" },
                    { field: "sSaleName", title: "业务员", width: 130, align: "center" },
                    { field: "iBscDataMatRecNo", hidden: true },
                    { field: "iBscDataFabRecNo", hidden: true },
                    { field: "iSDContractMRecNo", hidden: true },
                    { field: "sUserID", hidden: true },
                    //{ field: "sUnitID", hidden: true },
                    { field: "iRecNo", hidden: true }
                ]
                ],
                onSelect: function (index, row) {
                    Page.setFieldValue("iBscDataMatFabRecNo", row.iBscDataMatFabRecNo);
                    Page.setFieldValue("sProPlanMBillNo", row.sBillNo);
                    Page.setFieldValue("sProPlanMOrderNo", row.sOrderNo);
                    //Page.setFieldValue("iSdOrderMRecNo", row.iSDContractMRecNo);
                    //Page.setFieldValue("sOrderUserID", row.sUserID);
                    //Page.setFieldValue("sOrderUserName", row.sUserName);
                }
            });
        })

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "dDate") {
                    var dDate = Page.getFieldValue("dDate");
                    var SqlObjYearMonth = {
                        TableName: "bscDataPeriod",
                        Fields: "sYearMonth",
                        SelectAll: "True",
                        Filters: [
                {
                    Field: "dBeginDate",
                    ComOprt: "<=",
                    Value: "'" + dDate + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "dEndDate",
                    ComOprt: ">=",
                    Value: "'" + dDate + "'"
                }
                        ]
                    }
                    var resultYearMonth = SqlGetData(SqlObjYearMonth);
                    if (resultYearMonth.length > 0) {
                        Page.setFieldValue("sYearMonth", resultYearMonth[0].sYearMonth);
                    }
                    checkMonth();
                }
            }
        }

        function checkMonth() {
            var sYearMonth = Page.getFieldValue("sYearMonth");
            var stockRecNo = Page.getFieldValue("iBscDataStockMRecNo");
            var SqlObj = {
                TableName: "MMStockMonthM",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + stockRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sYearMonth",
                        ComOprt: "=",
                        Value: "'" + sYearMonth + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "'4'"
                    }
                ]
            };
            var result = SqlGetData(SqlObj);
            if (result.length > 0) {
                Page.MessageShow("仓库此月份已月结", "对不起，此仓库此月份已月结！");
                return false;
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1195") {
                doSearch();
            }
        }

        function doSearch(type) {
            var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
            if (iBscDataCustomerRecNo == "") {
                alert("请先选择染厂！");
                return;
            }

            var sqlObj = {
                TableName: "vwProPlanM",
                Fields: "sProduceCustShortName,sCustShortName,sCode,sName,sBscDataFabCode,sUserName,sUserID,sBillNo,sSaleName,sBscDataFabName,fFabQty,fOutQty,fNotOutQty,iBscDataMatRecNo,iBscDataMatFabRecNo,iSDContractMRecNo,iRecNo,sSendFinish,sOrderNo,iQty",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataCustomerRecNo",
                        ComOprt: "=",
                        Value: "'" + iBscDataCustomerRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        LeftParenthese: "(",
                        Field: "iBscDataProcessMRecNo",
                        ComOprt: "=",
                        Value: "6",
                        LinkOprt: "or"
                    },
                    {
                        Field: "iBscDataProcessMRecNo2",
                        ComOprt: "=",
                        Value: "6",
                        LinkOprt: "or"
                    },
                    {
                        Field: "iBscDataProcessMRecNo3",
                        ComOprt: "=",
                        Value: "6",
                        RightParenthese: ")",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "4"
                    }
                ]
            }
            if (type == null || type == undefined) {
                sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                sqlObj.Filters.push(
                    {
                        Field: "isnull(iSendFinish,0)",
                        ComOprt: "=",
                        Value: "0"
                    });
            }
            if (type != null && type != undefined && type != "") {
                var sProBillNo = Page.getFieldValue("sProBillNo");
                if (sProBillNo != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sBillNo",
                            ComOprt: "like",
                            Value: "'%" + sProBillNo + "%'"
                        }
                    )
                }
                var iFinish = Page.getFieldValue("iFinish");
                if (iFinish == "1") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                    {
                        Field: "isnull(iSendFinish,0)",
                        ComOprt: "=",
                        Value: "1"
                    });
                }
                else {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                    {
                        Field: "isnull(iSendFinish,0)",
                        ComOprt: "=",
                        Value: "0"
                    });
                }

                var sProOrderNo = Page.getFieldValue("sProOrderNo");
                if (sProOrderNo != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sOrderNo",
                            ComOprt: "like",
                            Value: "'%" + sProOrderNo + "%'"
                        }
                    )
                }
                var sProName = Page.getFieldValue("sProName");
                if (sProName != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sName",
                            ComOprt: "like",
                            Value: "'%" + sProName + "%'"
                        }
                    )
                }
                var sProFabCode = Page.getFieldValue("sProFabCode");
                if (sProFabCode != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sBscDataFabCode",
                            ComOprt: "like",
                            Value: "'%" + sProFabCode + "%'"
                        }
                    )
                }
                var sProFabName = Page.getFieldValue("sProFabName");
                if (sProFabName != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sBscDataFabName",
                            ComOprt: "like",
                            Value: "'%" + sProFabName + "%'"
                        }
                    )
                }
            }
            var result = SqlGetData(sqlObj);
            $("#tdProPlanD").datagrid("loadData", result);
        }
        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "332") {
                var selectedRow = $("#tdProPlanD").datagrid("getSelected");
                if (selectedRow) {
                    row.iProPlanMRecNo = selectedRow.iRecNo;
                    //row.iSdOrderMRecNo = selectedRow.iSDContractMRecNo;
                    row.sProPlanNo = selectedRow.sBillNo;
                    row.sOrderNo = selectedRow.sOrderNo;
                    return row;
                }
            }
        } 

        Page.beforeSave = function () {
            if (checkMonth() == false) {
                return false;
            }
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var allRows = $("#MMStockOutD").datagrid("getRows");
                for (var i = 0; i < allRows.length; i++) {
                    var updateRow = {};
                    var fPurQty = isNaN(Number(allRows[i].fPurQty)) ? 0 : Number(allRows[i].fPurQty);
                    var fQty = isNaN(Number(allRows[i].fQty)) ? 0 : Number(allRows[i].fQty);
                    var fTotal = isNaN(Number(allRows[i].fTotal)) ? 0 : Number(allRows[i].fTotal);
                    if (fPurQty > 0) {
                        updateRow.fPurQty = fPurQty * -1;
                    }
                    if (fQty > 0) {
                        updateRow.fQty = fQty * -1;
                    }
                    if (fTotal > 0) {
                        updateRow.fTotal = fTotal * -1;
                    }
                    $("#MMStockOutD").datagrid("updateRow", { index: i, row: updateRow });
                }
                Page.Children.ReloadFooter("MMStockOutD");
            }
        }
        function doFinish() {
            var selectedRow = $("#tdProPlanD").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("您确认吗？", "您确认标记完成/未完成吗?", function (r) {
                    if (r) {
                        var jsonobj = {
                            StoreProName: "SpProPlanMSendFinish",
                            StoreParms: [{
                                ParmName: "@iRecNo",
                                Value: selectedRow.iRecNo
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            alert(result);
                        }
                        else {
                            $("#tdProPlanD").datagrid("deleteRow", $("#tdProPlanD").datagrid("getRowIndex", selectedRow));
                        }
                    }
                })
            }
            else {
                Page.MessageShow("请选择一行！", "请选择一行！");
            }
        }

        dataForm.beforeOpen = function (uniqueid) {
            if (uniqueid == "378") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    alert("只有红冲才可以从领用出库单转入！");
                    return false;
                }
            }
        }
        dataForm.afterSelected = function (uniqueid, data) {
            if (uniqueid == "378") {
                var rows = $("#MMStockOutD").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    var fQty = isNaN(Number(rows[i].fQty)) ? 0 : Number(rows[i].fQty);
                    var fPurQty = isNaN(Number(rows[i].fPurQty)) ? 0 : Number(rows[i].fPurQty);
                    var fTotal = isNaN(Number(rows[i].fTotal)) ? 0 : Number(rows[i].fTotal);
                    $("#MMStockOutD").datagrid("updateRow", { index: i, row: { fQty: fQty * -1, fPurQty: fPurQty * -1, fTotal: fTotal * -1 } });
                }
                Page.Children.ReloadFooter("MMStockOutD");
            } 
        }
        
        function barcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txbBarcode").val();
                if (barcode != "") {
                    var allRows = $("#MMStockOutD").datagrid("getRows");
                    var theRows = allRows.filter(function (p) {
                        return p.sBarCode == barcode;
                    })
                    if (theRows.length > 0) {
                        var message = $("#teaMessage").val();
                        $("#teaMessage").val(message + "条码" + barcode + "已存在！\r\n");
                        $("#txbBarcode").val("");
                        $("#txbBarcode").focus();
                        PlayVoice("/sound/error.wav");
                        $("#teaMessage")[0].scrollTop = $("#teaMessage")[0].scrollHeight;
                        return;
                    }

                    var iRed = Page.getFieldValue("iRed");
                    var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                    var iBscDataMatFabRecNo = Page.getFieldValue("iBscDataMatFabRecNo");
                    var sProPlanMOrderNo = Page.getFieldValue("sProPlanMOrderNo");
                    if (iRed != "1") {
                        var sqlObj = {
                            TableName: "vwMMStockQty",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                    {
                                        Field: "sBarcode",
                                        ComOprt: "=",
                                        Value: "'" + barcode + "'",
                                        LinkOprt: "and"
                                    }, {
                                        Field: "iBscDataStockMRecNo",
                                        ComOprt: "=",
                                        Value: "'" + iBscDataStockMRecNo + "'",
                                        LinkOprt:"and"
                                    }, {
                                        Field: "iMatType",
                                        ComOprt: "=",
                                        Value: "1",
                                        LinkOprt: "and"
                                    }, {
                                        Field: "iBscDataMatRecNo",
                                        ComOprt: "=",
                                        Value: "'" + iBscDataMatFabRecNo + "'"
                                    },
                            ]
                        }
                        var result = SqlGetData(sqlObj);                        
                        if (result.length > 0) {
                            var selectedProPlanRow = $("#tdProPlanD").datagrid("getSelected");
                            var appRow = {
                                iSerial: allRows.length + 1,
                                sProPlanBillNo: selectedProPlanRow.sBillNo,
                                sCode: result[0].sCode,
                                sName: result[0].sName,
                                sReelNo: result[0].sReelNo,
                                fQty: result[0].fQty,
                                fPurQty: result[0].fPurQty,
                                fPrice: result[0].fPrice,
                                fTotal: result[0].fTotal,
                                sBatchNo: result[0].sBatchNo,
                                sStockOrderNo: result[0].sOrderNo,
                                sBerChID: result[0].sBerChID,
                                sStockCustShortName: result[0].sCustShortName,
                                sBarCode: result[0].sBarCode,
                                sMachineID: result[0].sMachine,
                                sStockCustShortName: result[0].sCustShortName,
                                iBscDataMatRecNo: result[0].iBscDataMatRecNo,
                                iStockSdOrderMRecNo: result[0].iSdOrderMRecNo,
                                iProPlanMRecNo: selectedProPlanRow.iRecNo,
                                iBscDataCustomerRecNo: result[0].iBscDataCustomerRecNo,
                                iBscDataStockDRecNo: result[0].iBscDataStockDRecNo,
                                sOrderNo: sProPlanMOrderNo
                            };
                            Page.tableToolbarClick("add", "MMStockOutD", appRow);
                            $("#txbBarcode").val("");
                            $("#txbBarcode").focus();
                            PlayVoice("/sound/success.wav");
                            Page.Children.ReloadFooter("MMStockOutD");
                        } else {
                            var message = $("#teaMessage").val();
                            $("#teaMessage").val(message + "条码" + barcode + "不存在！\r\n");
                            $("#txbBarcode").val("");
                            $("#txbBarcode").focus();
                            PlayVoice("/sound/error.wav");
                            $("#teaMessage")[0].scrollTop = $("#teaMessage")[0].scrollHeight;
                        }
                    } else {
                        var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                        var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                        if (iBscDataStockMRecNo == "") {
                            Page.MessageShow("请先选择仓库", "请先选择仓库");
                            return;
                        }
                        if (iBscDataCustomerRecNo == "") {
                            Page.MessageShow("请先选择染厂", "请先选择染厂");
                            return;
                        }
                        var sqlObj = {
                            TableName: "vwMMStockOutMD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "sBarcode",
                                    ComOprt: "=",
                                    Value: "'" + barcode + "'",
                                    LinkOprt: "and"
                                }, {
                                    Field: "iRecNoM",
                                    ComOprt: "<>",
                                    Value: "'" + Page.key + "'",
                                    LinkOprt: "and"
                                }, {
                                    Field: "iBscDataStockMRecNo",
                                    ComOprt: "=",
                                    Value: "'" + iBscDataStockMRecNo + "'",
                                    LinkOprt: "and"
                                }, {
                                    Field: "iBscDataCustomerRecNoM",
                                    ComOprt: "=",
                                    Value: "'" + iBscDataCustomerRecNo + "'"
                                },
                            ]
                        }
                        var result = SqlGetData(sqlObj);
                        if (result.length > 0) {
                            var appRow = result[0];
                            appRow.iSerial = allRows.length + 1;
                            delete appRow.iRecNo;
                            delete appRow.iMainRecNo;
                            Page.tableToolbarClick("add", "MMStockOutD", appRow);
                            $("#txbBarcode").val("");
                            $("#txbBarcode").focus();
                            PlayVoice("/sound/success.wav");
                            Page.Children.ReloadFooter("MMStockOutD");
                        }
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="height: 180px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',split:true,border:false" style="height: 180px; width: 680px;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatFabRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iSdOrderMRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sOrderUserID" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOrderUserName" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sProPlanMBillNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sProPlanMOrderNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>出库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                            </td>
                            <td>出库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>出库类型
                            </td>
                            <td>
                                <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sTypeName" Z_Options="染色出库" />
                            </td>
                            <td id="tdCustomer">染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Width="150px" />
                            </td>
                            <td>会计月份
                            </td>
                            <td style="margin-left: 40px">
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>出库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                            <td>重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>备注
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="98%" />
                            </td>
                            <td>制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>请扫描条码
                            </td>
                            <td colspan="3">
                                <input id="txbBarcode" type="text" style="width: 99%; height: 35px; font-weight: bold; font-size: 18px;"
                                    onkeydown="barcodeScan()" />
                            </td>
                            <td colspan="2">
                                <textarea id="teaMessage" style="width: 99%; height: 35px;" readonly="readonly"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false" style="height: 180px;">
                    <table id="tdProPlanD">
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <table id="MMStockOutD" tablename="MMStockOutD">
                    </table>
                </div>
            </div>
        </div>

        <div id="dgtool">
            <table>
                <tr>
                    <td>加工单号：<cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sProBillNo" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td>订单号：<cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldID="sProOrderNo" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td>产品名称：<cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="sProName" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td rowspan="2">
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                            onclick="doSearch(1)">查找</a>
                    </td>
                    <td rowspan="2">
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                            onclick="doFinish()">标记完成</a>
                    </td>
                </tr>
                <tr>
                    <td>坯布编号：<cc1:ExtTextBox2 ID="ExtTextBox17" Z_FieldID="sProFabCode" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                     <td>坯布名称：<cc1:ExtTextBox2 ID="ExtTextBox18" Z_FieldID="sProFabName" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iFinish" Z_NoSave="true" />
                        <label for="__ExtCheckbox2">
                            已完成</label>
                    </td>
                    
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
