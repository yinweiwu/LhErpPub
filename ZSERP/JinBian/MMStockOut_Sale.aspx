<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        //        var iBillType = "";
        $(function () {
            //Page.DoNotCloseWinWhenSave = true;
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

            Page.Children.toolBarBtnDisabled("MMStockOutD", "add");

            $("#tdSendD").datagrid(
            {
                //title: "发货通知单明细",
                fit: true,
                remoteSort: false,
                singleSelect: true,
                columns: [
                    [
                        { field: "__ck", checkbox: true },
                        { field: "sCode", title: "坯布编号", width: 100, align: "center" },
                        { field: "sName", title: "坯布名称", width: 100, align: "center" },
                        { field: "sOrderNo", title: "订单号", width: 100, align: "center" },
                        { field: "fSumQty", title: "通知重量", width: 80, align: "center" },
                        { field: "fPurQty", title: "通知匹数", width: 80, align: "center" },
                        { field: "fOutQty", title: "已发重量", width: 80, align: "center" },
			            { field: "sRemark", title: "备注", width: 280, align: "center" },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iSdOrderDRecNo", hidden: true },
                        { field: "sOrderUserID", hidden: true },
                        { field: "sOrderUserName", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iRecNo", hidden: true }
                    ]
                ],
                onSelect: function (index, row) {
                    Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo);
                    Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
                    Page.setFieldValue("sOrderUserID", row.sOrderUserID);
                    Page.setFieldValue("sOrderUserName", row.sOrderUserName);
                },
                toolbar: [
                    {
                        iconCls: 'icon-ok',
                        text: "标记整个发货通知单完成",
                        handler: function () {
                            var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                            if (iSDSendMRecNo != "") {
                                $.messager.confirm("您确认完成吗？", "您确认完成此发货通知单吗？完成后，将不显示此发货通知单。", function (r) {
                                    if (r) {
                                        var jsonobj = {
                                            StoreProName: "SpSDSendMFinish",
                                            StoreParms: [
                                            {
                                                ParmName: "@iformid",
                                                Value: 1
                                            },
                                            {
                                                ParmName: "@keys",
                                                Value: iSDSendMRecNo
                                            },
                                            {
                                                ParmName: "@userid",
                                                Value: Page.userid
                                            },
                                            {
                                                ParmName: "@btnid",
                                                Value: "btn"
                                            }
                                            ]
                                        }
                                        var result = SqlStoreProce(jsonobj);
                                        if (result == "1") {
                                            Page.setFieldValue("iSDSendMRecNo", "");
                                            var allRows = $("#tdSendD").datagrid("getRows");
                                            for (var i = 0; i < allRows.length; i++) {
                                                var rowIndex = $("#tdSendD").datagrid("getRowIndex", allRows[i]);
                                                $("#tdSendD").datagrid("deleteRow", rowIndex);
                                            }
                                        }
                                    }
                                });
                            }
                            else {
                                Page.MessageShow("请先选择发货通知单", "请先选择发货通知单！");
                            }
                        }

                    }
                ]

            })

            //细码单2016-09-13尹威武
            /*var options = $("#MMStockOutD").datagrid("options");
            options.columns[0].splice(6, 0,
                {
                    title: "细码单",
                    field: "__dddd",
                    formatter: function (value, row, index) {
                        if (row.iRecNo) {
                            return "<a href='javascript:void(0)' onclick='openwin(" + index + ")'>细码单</a>";
                        }
                    },
                    width: 70,
                    align: "center"
                }
                );
            $("#MMStockOutD").datagrid(options);*/


            var toolBar = [];
            if (Page.usetype != "view") {
                toolBar.push(
                    {
                        iconCls: "icon-remove",
                        text: "删除",
                        handler: function () {
                            var selectedRow = $("#tableMD").datagrid("getChecked");
                            if (selectedRow) {
                                for (var i = 0; i < selectedRow.length; i++) {
                                    var rowIndex = $("#tableMD").datagrid("getRowIndex", selectedRow[i]);
                                    $("#tableMD").datagrid("deleteRow", rowIndex);
                                }
                            }
                        }
                    }
                );
                toolBar.push(
                    {
                        iconCls: "icon-save",
                        text: "保存",
                        handler: function () {
                            var str = "";
                            var mdRows = $("#tableMD").datagrid("getRows");
                            for (var i = 0; i < mdRows.length; i++) {
                                $("#tableMD").datagrid("endEdit", i);
                                if (mdRows[i].fQty) {
                                    str += (mdRows[i].sMachineID ? mdRows[i].sMachineID : "") + "`" + mdRows[i].fQty + ",";
                                }
                            }
                            if (str.length > 0) {
                                str = str.substr(0, str.length - 1);
                            }

                            var iMainRecNo = $("#MMStockOutD").datagrid("getRows")[lastedIdex].iRecNo;

                            var jsonobj = {
                                StoreProName: "SpMMStockOutDDSave",
                                StoreParms: [{
                                    ParmName: "@iMainRecNo",
                                    Value: iMainRecNo
                                },
                                {
                                    ParmName: "@sStr",
                                    Value: str,
                                    Size: -1
                                }
                                ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result == "1") {
                                $("#divMD").window("close");
                            }
                        }
                    }
                )
            }

            $("#tableMD").datagrid(
                {
                    border: false,
                    fit: true,
                    remoteSort: false,
                    rownumbers: true,
                    singleSelect: false,
                    columns: [
                        [
                            { field: "__ckb", checkbox: true },
                            {
                                field: "sMachineID", title: "机号", width: 50, align: "center",
                                editor: {
                                    type: "textbox"
                                }
                            },
                            {
                                field: "fQty", title: "重量", width: 100, align: "center",
                                editor: {
                                    type: "numberbox",
                                    options: {
                                        precision: 2
                                    }
                                }
                            }
                        ]
                    ],
                    toolbar: toolBar,
                    onClickCell: function (index, field, value) {
                        if (Page.usetype != "view") {
                            $("#tableMD").datagrid("beginEdit", index);
                            setInput(index, field);
                        }
                    }
                }
            );

            //增加打印细码单
            //            Page.Children.toolBarBtnAdd("MMStockOutD", "print", "细码单预览", "print", function () {
            //                var selectedRows = $("#MMStockOutD").datagrid("getChecked");
            //                if (selectedRows.length > 0) {
            //                    var firstRow = selectedRows[0];
            //                    var iRecNo = firstRow.iRecNo;
            //                    var url = "/Base/PbPage.aspx?iformid=" + Page.iformid + "&otype=show&irecno=92&pb_iRecNo=" + iRecNo + "&r=" + Math.random();
            //                    $("#ifrpb").attr("src", "");
            //                    $("#ifrpb").attr("src", url);
            //                }
            //            });
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

        /*Page.Children.onBeforeAddRow = function () {
        var iRed = Page.getFieldValue("iRed");
        if (iRed != "1") {
        alert("只能红冲才能增加行！");
        return false;
        }
        var selectedRow = $("#tdSendD").datagrid("getSelected");
        if (selectedRow == undefined || selectedRow == null) {
        alert("请先选择要退货的通知单明细！");
        return false;
        }
        }

        Page.Children.onAfterAddRow = function () {
        var rows = $("#MMStockOutD").datagrid("getRows");
        var lastRow = {};
        var selectedRow = $("#tdSendD").datagrid("getSelected");
        lastRow.iSdOrderMRecNo = selectedRow.iSdOrderMRecNo;
        lastRow.iSdSendDRecNo = selectedRow.iRecNo;
        lastRow.fSalePrice = selectedRow.fPrice;
        lastRow.iBscDataMatRecNo = selectedRow.iBscDataMatRecNo;
        lastRow.sCode = selectedRow.sCode;
        lastRow.sName = selectedRow.sName;
        $("#MMStockOutD").datagrid("updateRow", { index: rows.length - 1, row: lastRow });
        }*/

        Page.beforeSave = function () {
            if (checkMonth() == false) {
                return false;
            }

            /*var detailRows = $("#MMStockOutD").datagrid("getRows");
            for (var i = 0; i < detailRows.length; i++) {
                var iMainRecNo = detailRows[i].iRecNo;
                var fPurQty = isNaN(Number(detailRows[i].fPurQty)) ? 0 : Number(detailRows[i].fPurQty);
                var sqlObj = {
                    TableName: "MMStockOutDD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + iMainRecNo + "'"
                            }
                        ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length == 0 || result.length != fPurQty) {
                    if (confirm("第" + (i + 1).toString() + "行，细码单尚未输入完整，确认要保存吗？") == false) {
                        return false;
                    }
                }
            }*/

            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var detailRows1 = $("#MMStockOutD").datagrid("getRows");
                for (var i = 0; i < detailRows1.length; i++) {
                    var updateRow = {};
                    var fQty = isNaN(Number(detailRows1[i].fQty)) ? 0 : Number(detailRows1[i].fQty);
                    var fPurQty = isNaN(Number(detailRows1[i].fPurQty)) ? 0 : Number(detailRows1[i].fPurQty);
                    var fTotal = isNaN(Number(detailRows1[i].fTotal)) ? 0 : Number(detailRows1[i].fTotal);
                    var fSaleTotal = isNaN(Number(detailRows1[i].fSaleTotal)) ? 0 : Number(detailRows1[i].fSaleTotal);
                    if (fQty > 0) {
                        updateRow.fQty = -1 * fQty;
                    }
                    if (fPurQty > 0) {
                        updateRow.fPurQty = -1 * fPurQty;
                    }
                    if (fTotal > 0) {
                        updateRow.fTotal = -1 * fTotal;
                    }
                    if (fSaleTotal > 0) {
                        updateRow.fSaleTotal = -1 * fSaleTotal;
                    }
                    $("#MMStockOutD").datagrid("updateRow", { index: i, row: updateRow });
                }
            }
        }

        lookUp.beforeOpen = function (unique) {
            if (unique == "1738") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed == "1") {
                    return true;
                }
                else {
                    alert("只有红冲才可选择坯布！");
                    return false;
                }
            }
        }

        dataForm.beforeOpen = function (uniqueid) {
            if (uniqueid == "326") {
                var sendRecNo = Page.getFieldValue("iSDSendMRecNo");
                if (sendRecNo != "") {
                    var selectedRow = $("#tdSendD").datagrid("getSelected");
                    if (selectedRow == undefined || selectedRow == null) {
                        alert("请先选择要出库的通知单明细！");
                        return false;
                    }
                }
            }
            if (uniqueid == "368") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    alert("只有红冲才可从销售出库单转入！");
                    return false;
                }
                var sendRecNo = Page.getFieldValue("iSDSendMRecNo");
                if (sendRecNo != "") {
                    var selectedRow = $("#tdSendD").datagrid("getSelected");
                    if (selectedRow == undefined || selectedRow == null) {
                        alert("请先选择要出库的通知单明细！");
                        return false;
                    }
                }
            }
        }

        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            var selectedRow = $("#tdSendD").datagrid("getSelected");
            if (selectedRow) {
                row.iSdOrderMRecNo = selectedRow.iSdOrderMRecNo;
                row.iSdSendDRecNo = selectedRow.iRecNo;
                row.fSalePrice = selectedRow.fPrice;
                row.fSaleTotal = Number(selectedRow.fPrice) * Number(row.fQty);
                return row;
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1352") {
                var sqlObj = {
                    TableName: "vwSdSendD_GMJ",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + data.iRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "abs(isnull(fSumQty,0)-isnull(fOutQty,0))",
                        ComOprt: ">",
                        Value: "0"
                    }
                    ]
                }
                var result = SqlGetData(sqlObj);
                $("#tdSendD").datagrid("loadData", result);
            }
        }

        var isModifyOrViewGetMd = false;
        var lastedIdex = undefined;

        var setInput = function (i, field) {
            var ed = $('#tableMD').datagrid('getEditor', { index: i, field: field });
            if (field == "fQty") {
                $(ed.target).numberbox("textbox").focus();
                $(ed.target).numberbox("textbox").select();
            }
            else {
                $(ed.target).textbox("textbox").focus();
                $(ed.target).textbox("textbox").select();
            }

            var edQty = $('#tableMD').datagrid('getEditor', { index: i, field: "fQty" });
            var edMachie = $('#tableMD').datagrid('getEditor', { index: i, field: "sMachineID" });
            var mdRows = $("#tableMD").datagrid("getRows");
            $($(edQty.target).numberbox("textbox")).bind("keydown", function (evt) {
                evt = (evt) ? evt : window.event;
                if (evt.keyCode == 40 || evt.keyCode == 13) {
                    if (i < mdRows.length - 1) {
                        $('#tableMD').datagrid('beginEdit', i + 1);
                        var ednext = $('#tableMD').datagrid('getEditor', { index: i + 1, field: "fQty" });
                        $(ednext.target).numberbox("textbox").focus();
                        $(ednext.target).numberbox("textbox").select();
                        setInput(i + 1, "fQty");
                    }
                    if (evt.keyCode == 13) {
                        if (evt && evt.stopPropagation) {
                            evt.stopPropagation();
                        }
                        else {
                            evt.cancelBubble = true;
                        }
                    }
                }
                else if (evt.keyCode == 38) {
                    if (i > 0) {
                        $('#tableMD').datagrid('beginEdit', i - 1);
                        var edPre = $('#tableMD').datagrid('getEditor', { index: i - 1, field: "fQty" });
                        $(edPre.target).numberbox("textbox").focus();
                        $(edPre.target).numberbox("textbox").select();
                        setInput(i - 1, "fQty");
                    }
                }
            });


            $($(edMachie.target).textbox("textbox")).bind("keydown", function (evt) {
                evt = (evt) ? evt : window.event;
                if (evt.keyCode == 40 || evt.keyCode == 13) {
                    if (i < mdRows.length - 1) {
                        $('#tableMD').datagrid('beginEdit', i + 1);
                        var ednext = $('#tableMD').datagrid('getEditor', { index: i + 1, field: "sMachineID" });
                        $(ednext.target).textbox("textbox").focus();
                        $(ednext.target).textbox("textbox").select();
                        setInput(i + 1, "sMachineID");
                    }
                    if (evt.keyCode == 13) {
                        if (evt && evt.stopPropagation) {
                            evt.stopPropagation();
                        }
                        else {
                            evt.cancelBubble = true;
                        }
                    }
                }
                else if (evt.keyCode == 38) {
                    if (i > 0) {
                        $('#tableMD').datagrid('beginEdit', i - 1);
                        var edPre = $('#tableMD').datagrid('getEditor', { index: i - 1, field: "sMachineID" });
                        $(edPre.target).textbox("textbox").focus();
                        $(edPre.target).textbox("textbox").select();
                        setInput(i - 1, "sMachineID");
                    }
                }
            });
        }

        function openwin(index) {
            lastedIdex = index;
            $("#MMStockOutD").datagrid("endEdit", index);
            $("#divMD").window("open");
            var detailRows = $("#MMStockOutD").datagrid("getRows");
            var iPs = isNaN(Number(detailRows[index].fPurQty)) ? 0 : Number(detailRows[index].fPurQty);
            if (iPs == 0) {
                alert("匹数大于0时才需输入细码单！");
                return false;
            }


            var mdRows = $("#tableMD").datagrid("getRows");
            while (mdRows.length > 0) {
                var rowIndex = $("#tableMD").datagrid("getRowIndex", mdRows[0]);
                $("#tableMD").datagrid("deleteRow", rowIndex);
            }
            for (var i = 0; i < iPs; i++) {
                var iSerial = i + 1;
                var appRow = { iSerial: iSerial, fQty: null };
                $("#tableMD").datagrid("appendRow", appRow);
                if (Page.usetype != "view") {
                    if (i == 0) {
                        $("#tableMD").datagrid("beginEdit", i);
                        setInput(i, "fQty");
                    }
                }
            }

            var sqlObj = {
                TableName: "MMStockOutDD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + detailRows[index].iRecNo + "'"
                            }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    if (i < iPs) {
                        $("#tableMD").datagrid("endEdit", i);
                        $("#tableMD").datagrid("updateRow", {
                            index: i,
                            row: {
                                sMachineID: result[i].sMachineID,
                                fQty: result[i].fQty
                            }
                        });
                        if (Page.usetype != "view") {
                            if (i == 0) {
                                $("#tableMD").datagrid("beginEdit", i);
                                setInput(i, "fQty");
                            }
                        }
                    }
                }
            }
        }

        Page.afterSave = function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                var jsonobj = {
                    StoreProName: "SpBuildBarcode",
                    StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@iType",
                        Value: 2
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }
        function barcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txbBarcode").val();
                if (barcode != "") {
                    var sqlObj = {
                        TableName: "vwProWeightRecord",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sBarcode",
                                ComOprt: "=",
                                Value: "'" + barcode + "'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
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
                        }
                        else {
                            var appRow = {
                                iSerial: allRows.length + 1,
                                sStockOrderNo: result[0].sOrderNo,
                                sReelNo: "1",
                                sCode: result[0].sBscDataFabCode,
                                sName: result[0].sBscDataFabName,
                                fProductWidth: result[0].fProductWidth,
                                fProductWeight: result[0].fProductWeight,
                                fQty: result[0].fWeight,
                                fPurQty: 1,
                                sMachineID: result[0].sMachineID,
                                sBarCode: result[0].sBarcode,
                                sReelNo: "1",
                                iBscDataMatRecNo: result[0].iBscDataMatRecNo,
                                iStockSdOrderMRecNo: result[0].iSDOrderMRecNo
                            };
                            Page.tableToolbarClick("add", "MMStockOutD", appRow);
                            $("#txbBarcode").val("");
                            $("#txbBarcode").focus();
                            PlayVoice("/sound/success.wav");
                            Page.Children.ReloadFooter("MMStockOutD");
                        }

                    } else {
                        var message = $("#teaMessage").val();
                        $("#teaMessage").val(message + "条码" + barcode + "不存在！\r\n");
                        $("#txbBarcode").val("");
                        $("#txbBarcode").focus();
                        PlayVoice("/sound/error.wav");
                        $("#teaMessage")[0].scrollTop = $("#teaMessage")[0].scrollHeight;
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table class="tabmain">
                <tr>
                    <td>出库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
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
                    <td>出库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sTypeName" Width="150px" />
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBillType" />
                    </td>
                </tr>
                <tr>
                    <td>发货通知单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iSDSendMRecNo" Width="150px" />
                    </td>
                    <td id="iBscDataCustomerRecNo3">客户
                    </td>
                    <td id="iBscDataCustomerRecNo4">
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Width="150px" />
                    </td>
                    <td>会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                    </td>
                    <td>出库单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                    </td>
                    <td style="display: none;">
                        <%--<cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox1">
                            红冲</label>--%>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSdOrderMRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sOrderUserID" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sOrderUserName" Z_NoSave="true" />
                        <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
                        <%--<cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" />--%>
                    </td>
                </tr>
                <tr>
                    <td>数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                    </td>
                    <td style="display: none;">金额
                    </td>
                    <td style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
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
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox2">
                            红冲</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="height: 130px;">
                        <table id="tdSendD">
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>请扫描条码</td>
                    <td colspan="5">
                        <input id="txbBarcode" type="text" style="width: 99%; height: 35px; font-weight: bold; font-size: 18px;" onkeydown="barcodeScan()" />
                    </td>
                    <td colspan="6">
                        <textarea id="teaMessage" style="width: 99%; height: 35px;" readonly="readonly"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <table id="MMStockOutD" tablename="MMStockOutD">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="divMD" class="easyui-window" data-options="closed:true,closable:true,title:'细码单',collapsible:false,minimizable:false,maximizable:false,modal:true,width:250,height:500">
        <table id="tableMD">
        </table>
    </div>
</asp:Content>
