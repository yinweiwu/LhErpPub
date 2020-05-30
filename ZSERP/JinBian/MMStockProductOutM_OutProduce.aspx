<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                if (getQueryString("savetype") == "producefollow") {
                    $("#tabTop").tabs("select", "外加工出库单");
                    $("#tabTop").tabs('getTab', "未出库外加工单").panel('options').tab.hide();
                    //Page.setFieldValue("iProcessOrderDRecNo", getQueryString("iProcessOrderDRecNo"));
                    Page.setFieldValue("iBscDataCustomerRecNo", getQueryString("iBscDataCustomerRecNo"));
                    Page.setFieldValue("iBscDataMatRecNo", getQueryString("iBscDataMatRecNo"));
                    Page.setFieldValue("iBscDataColorRecNo", getQueryString("iBscDataColorRecNo"));
                    Page.setFieldValue("fProductWidth", getQueryString("fProductWidth"));
                    Page.setFieldValue("fProductWeight", getQueryString("fProductWeight"));

                    var iBscDataCustomerRecNoTag = $("#__ExtTextBox4");
                    var iBscDataCustomerRecNoSpan = iBscDataCustomerRecNoTag.next();
                    var iBscDataCustomerRecNoInput = iBscDataCustomerRecNoSpan.find("input:first");
                    var iBscDataCustomerRecNoA1 = iBscDataCustomerRecNoSpan.find("a:first");
                    var iBscDataCustomerRecNoA2 = iBscDataCustomerRecNoSpan.find("a:last");
                    var iBscDataMatRecNoTag = $("#__ExtTextBox10");
                    var iBscDataMatRecNoSpan = iBscDataMatRecNoTag.next();
                    var iBscDataMatRecNoInput = iBscDataMatRecNoSpan.find("input:first");
                    var iBscDataMatRecNoA1 = iBscDataMatRecNoSpan.find("a:first");
                    var iBscDataMatRecNoA2 = iBscDataMatRecNoSpan.find("a:last");
                    var iBscDataColorRecNoTag = $("#__ExtTextBox10");
                    var iBscDataColorRecNoSpan = iBscDataColorRecNoTag.next();
                    var iBscDataColorRecNoInput = iBscDataColorRecNoSpan.find("input:first");
                    var iBscDataColorRecNoA1 = iBscDataColorRecNoSpan.find("a:first");
                    var iBscDataColorRecNoA2 = iBscDataColorRecNoSpan.find("a:last");
                    var fProductWidthTag = $("#__ExtTextBox21");
                    var fProductWidthSpan = fProductWidthTag.next();
                    var fProductWidthInput = fProductWidthSpan.find("input:first");
                    var fProductWeightTag = $("#__ExtTextBox22");
                    var fProductWeightSpan = fProductWeightTag.next();
                    var fProductWeightInput = fProductWeightSpan.find("input:first");
                    var iBscDataMatRecNoTag = $("#__ExtTextBox3");
                    var iBscDataMatRecNoSpan = iBscDataMatRecNoTag.next();
                    var iBscDataMatRecNoInput = iBscDataMatRecNoSpan.find("input:first");
                    var iBscDataMatRecNoA1 = iBscDataMatRecNoSpan.find("a:first");
                    var iBscDataMatRecNoA2 = iBscDataMatRecNoSpan.find("a:last");
                    //var iProcessOrderDRecNoTag = $("#__ExtTextBox18");
                    //var iProcessOrderDRecNoSpan = iProcessOrderDRecNoTag.next();
                    //var iProcessOrderDRecNoInput = iProcessOrderDRecNoSpan.find("input:first");
                    //var iProcessOrderDRecNoA1 = iProcessOrderDRecNoSpan.find("a:first");
                    //var iProcessOrderDRecNoA2 = iProcessOrderDRecNoSpan.find("a:last");
                    iBscDataCustomerRecNoTag.addClass("txbreadonly");
                    iBscDataCustomerRecNoTag.attr("data-options", "readonly:true," + iBscDataCustomerRecNoTag.attr("data-options"));
                    iBscDataCustomerRecNoSpan.removeClass("textbox-invalid");
                    iBscDataCustomerRecNoSpan.addClass("textbox-readonly");
                    iBscDataCustomerRecNoSpan.wrap("<div></div>");
                    iBscDataCustomerRecNoInput.removeClass("validatebox-invalid");
                    iBscDataCustomerRecNoInput.removeClass("textbox-prompt");
                    iBscDataCustomerRecNoInput.addClass("txbreadonly");
                    iBscDataCustomerRecNoInput.attr("readonly", "readonly");
                    iBscDataCustomerRecNoInput.removeAttr("tabindex");
                    iBscDataCustomerRecNoA1.addClass("l-btn-disabled");
                    iBscDataCustomerRecNoA2.addClass("textbox-icon-disabled");
                    iBscDataMatRecNoTag.addClass("txbreadonly");
                    iBscDataMatRecNoTag.attr("data-options", "readonly:true," + iBscDataMatRecNoTag.attr("data-options"));
                    iBscDataMatRecNoSpan.removeClass("textbox-invalid");
                    iBscDataMatRecNoSpan.addClass("textbox-readonly");
                    iBscDataMatRecNoSpan.wrap("<div></div>");
                    iBscDataMatRecNoInput.removeClass("validatebox-invalid");
                    iBscDataMatRecNoInput.removeClass("textbox-prompt");
                    iBscDataMatRecNoInput.addClass("txbreadonly");
                    iBscDataMatRecNoInput.attr("readonly", "readonly");
                    iBscDataMatRecNoInput.removeAttr("tabindex");
                    iBscDataMatRecNoA1.addClass("l-btn-disabled");
                    iBscDataMatRecNoA2.addClass("textbox-icon-disabled");
                    iBscDataColorRecNoTag.addClass("txbreadonly");
                    iBscDataColorRecNoTag.attr("data-options", "readonly:true," + iBscDataColorRecNoTag.attr("data-options"));
                    iBscDataColorRecNoSpan.removeClass("textbox-invalid");
                    iBscDataColorRecNoSpan.addClass("textbox-readonly");
                    iBscDataColorRecNoSpan.wrap("<div></div>");
                    iBscDataColorRecNoInput.removeClass("validatebox-invalid");
                    iBscDataColorRecNoInput.removeClass("textbox-prompt");
                    iBscDataColorRecNoInput.addClass("txbreadonly");
                    iBscDataColorRecNoInput.attr("readonly", "readonly");
                    iBscDataColorRecNoInput.removeAttr("tabindex");
                    iBscDataColorRecNoA1.addClass("l-btn-disabled");
                    iBscDataColorRecNoA2.addClass("textbox-icon-disabled");
                    fProductWidthTag.addClass("txbreadonly");
                    fProductWidthTag.attr("data-options", "readonly:true," + fProductWidthTag.attr("data-options"));
                    fProductWidthSpan.removeClass("textbox-invalid");
                    fProductWidthSpan.addClass("textbox-readonly");
                    fProductWidthSpan.wrap("<div></div>");
                    fProductWidthInput.removeClass("validatebox-invalid");
                    fProductWidthInput.removeClass("textbox-prompt");
                    fProductWidthInput.addClass("txbreadonly");
                    fProductWidthInput.attr("readonly", "readonly");
                    fProductWidthInput.removeAttr("tabindex");
                    fProductWeightTag.addClass("txbreadonly");
                    fProductWeightTag.attr("data-options", "readonly:true," + fProductWeightTag.attr("data-options"));
                    fProductWeightSpan.removeClass("textbox-invalid");
                    fProductWeightSpan.addClass("textbox-readonly");
                    fProductWeightSpan.wrap("<div></div>");
                    fProductWeightInput.removeClass("validatebox-invalid");
                    fProductWeightInput.removeClass("textbox-prompt");
                    fProductWeightInput.addClass("txbreadonly");
                    fProductWeightInput.attr("readonly", "readonly");
                    fProductWeightInput.removeAttr("tabindex");
                    iBscDataMatRecNoTag.addClass("txbreadonly");
                    iBscDataMatRecNoTag.attr("data-options", "readonly:true," + iBscDataMatRecNoTag.attr("data-options"));
                    iBscDataMatRecNoSpan.removeClass("textbox-invalid");
                    iBscDataMatRecNoSpan.addClass("textbox-readonly");
                    iBscDataMatRecNoSpan.wrap("<div></div>");
                    iBscDataMatRecNoInput.removeClass("validatebox-invalid");
                    iBscDataMatRecNoInput.removeClass("textbox-prompt");
                    iBscDataMatRecNoInput.addClass("txbreadonly");
                    iBscDataMatRecNoInput.attr("readonly", "readonly");
                    iBscDataMatRecNoInput.removeAttr("tabindex");
                    iBscDataMatRecNoA1.addClass("l-btn-disabled");
                    iBscDataMatRecNoA2.addClass("textbox-icon-disabled");
                    iProcessOrderDRecNoTag.addClass("txbreadonly");
                    iProcessOrderDRecNoTag.attr("data-options", "readonly:true," + iProcessOrderDRecNoTag.attr("data-options"));
                    iProcessOrderDRecNoSpan.removeClass("textbox-invalid");
                    iProcessOrderDRecNoSpan.addClass("textbox-readonly");
                    iProcessOrderDRecNoSpan.wrap("<div></div>");
                    iProcessOrderDRecNoInput.removeClass("validatebox-invalid");
                    iProcessOrderDRecNoInput.removeClass("textbox-prompt");
                    iProcessOrderDRecNoInput.addClass("txbreadonly");
                    iProcessOrderDRecNoInput.attr("readonly", "readonly");
                    iProcessOrderDRecNoInput.removeAttr("tabindex");
                    iProcessOrderDRecNoA1.addClass("l-btn-disabled");
                    iProcessOrderDRecNoA2.addClass("textbox-icon-disabled");
                }
                Page.setFieldValue("iBillType", getQueryString("iBillType"));
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
            if (Page.usetype == "add" || Page.usetype == "modify") {
                columns = [[
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "出库", field: "__btn", width: 80, formatter: function (value, row, index) {
                            return "<input type='button' onclick='passIn(" + index + ")' value='出库' ></input>";
                        }
                        },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                        { title: "加工厂家", field: "sCustShortName", width: 100, sortable: true },
                        { title: "产品编号", field: "sCode", width: 100, sortable: true },
                        { title: "产品名称", field: "sName", width: 100, sortable: true },
                        { title: "色号", field: "sColorID", width: 100, sortable: true },
                        { title: "颜色", field: "sColorName", width: 100, sortable: true },
                        { title: "加工工序", field: "sProcessesName", width: 60, sortable: true },
                        { title: "幅宽", field: "fProductWidth", width: 60, sortable: true },
                        { title: "克重", field: "fProductWeight", width: 60, sortable: true },
                        { title: "发出单位", field: "sUnitName", width: 60, sortable: true },
                        { title: "数量", field: "fQty", width: 80, sortable: true },
                        { title: "未出库数量", field: "fNoOutQty", width: 80, sortable: true },
                        { title: "已出库数量", field: "fOutQty", width: 80, sortable: true },
                //                        { title: "单价", field: "fPrice", width: 80, sortable: true, hidden: true },
                //                        { field: "金额", field: "fNoInTotal", width: 80, sortable: true, hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iSDOrderDRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iRecNo", hidden: true }

                ]];
                $("#table2").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 500, 5000],
                    columns: columns,
                    toolbar: [{
                        iconCls: 'icon-search',
                        text: "查询",
                        handler: function () {
                            search1();
                        }
                    }],
                    onSelect: function (index, row) {
                    }
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            else {
                $('#tabTop').tabs('close', '未出库外加工单');
            }
        })


        function search1() {
            var sqlObjOrderMD = {
                TableName: "vwProOutProduceMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sOutFinish",
                        ComOprt: "=",
                        Value: "'x'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt:"and"
                    },
                    {
                        Field: "isnull(iOut,0)",
                        ComOprt: "=",
                        Value: "1",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iBillType,0)",
                        ComOprt: "=",
                        Value: "2"
                    }
                    ],
                Sorts: [
                    {
                        SortName: "sCustShortName",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
            };

            var resultSendMD = SqlGetData(sqlObjOrderMD);
            $("#table2").datagrid("loadData", resultSendMD);
        }

        function passIn(index) {
            var selectedRow = $("#table2").datagrid("getRows")[index];
            Page.setFieldValue("iBscDataCustomerRecNo", selectedRow.iBscDataCustomerRecNo);
            Page.setFieldValue("iBscDataMatRecNo", selectedRow.iBscDataMatRecNo);
            Page.setFieldValue("iBscDataColorRecNo", selectedRow.iBscDataColorRecNo);
            Page.setFieldValue("fProductWidth", selectedRow.fProductWidth);
            Page.setFieldValue("fProductWeight", selectedRow.fProductWeight);
            Page.setFieldValue("iBscDataCustomerRecNo", selectedRow.iBscDataCustomerRecNo);
            Page.setFieldValue("iProOutProduceDRecNo", selectedRow.iRecNo);
            Page.setFieldValue("iSdOrderMRecNo", selectedRow.iSdOrderMRecNo);
            $("#tabTop").tabs("select", "外加工出库单");
            document.getElementById("txtBarcode").focus();
            //            var rows = $('#table2').datagrid('getChecked');
            //            if (rows.length > 0) {
            //                var iCustomerRecNo = 0;
            //                iCustomerRecNo = rows[0].iBscDataCustomerRecNo;
            //                for (var i = 1; i < rows.length; i++) {
            //                    if (iCustomerRecNo != rows[i].iBscDataCustomerRecNo) {
            //                        alert("一次只能转入同一个加工厂商的入库记录！");
            //                        return;
            //                    }
            //                }
            //                Page.setFieldValue("iBscDataCustomerRecNo", iCustomerRecNo);
            //                for (var i = 0; i < rows.length; i++) {
            //                    var appRow = {};
            //                    appRow.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
            //                    appRow.fQty = rows[i].fNoInQty;
            //                    appRow.sOrderNo = rows[i].sOrderNo;
            //                    appRow.fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
            //                    appRow.fTotal = isNaN(parseFloat(rows[i].fNoInTotal)) ? 0 : parseFloat(rows[i].fNoInTotal);
            //                    appRow.fPurQty = rows[i].fPurQty;
            //                    appRow.iSDOrderMRecNo = rows[i].iSdOrderMRecNo;
            //                    appRow.sCode = rows[i].sBscDataFabCode;
            //                    appRow.sName = rows[i].sBscDataFabName;
            //                    Page.tableToolbarClick("add", "table1", appRow);
            //                }
            //            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fQty: fQty} });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty} });
                    }
                }
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (Page.getFieldValue("iBscDataStockMRecNo") == "") {
                    Page.MessageShow("错误", "请选择仓库！");
                    return;
                }
                if (barcode != "") {
                    var rows = $("#table1").datagrid("getRows");
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == barcode) {
                                alert("条码已存在！");
                                return false;
                            }
                        }
                    }
                    var sqlObj = { TableName: "vwMMStockQty",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                        { Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", LinkOprt: "and" },
                        { Field: "fQty", ComOprt: ">", Value: "0", LinkOprt: "and" },
                        { Field: "iBscDataStockMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataMatRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataColorRecNo") + "'", LinkOprt: "and" },
                        { Field: "fProductWidth", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWidth") + "'", LinkOprt: "and" },
                        { Field: "fProductWeight", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWeight") + "'" }
                        ]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var addRow = [{
                            sBarCode: data[0].sBarCode,
                            sBatchNo: data[0].sBatchNo,
                            sReelNo: data[0].sReelNo,
                            fQty: data[0].fQty,
                            fPurQty: data[0].fPurQty,
                            sLetCode: data[0].sLetCode,
                            sCustShortName: data[0].sCustShortName,
                            iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                            iStockSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            sBerChID: data[0].sBerChID
                        }];

                        Page.tableToolbarClick("add", "table1", addRow[0]);
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                        //PlayVoice("条码" + barcode + "不存在");
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

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
                    row.fPurQty = Number(Page.getFieldValue("fProductWidth")) == 0 || Number(Page.getFieldValue("fProductWeight")) == 0 ? 0 : Number(row.fQty) * 100 * 1000 / (Number(Page.getFieldValue("fProductWeight")) * Number(Page.getFieldValue("fProductWidth")));
                    row.sLetCode = row.fPurQty / 0.9144;
                    row.fTotal = isNaN(Number(row.fPrice)) == true ? 0 : row.sUnitID == '1' ? Number(row.fPrice) * row.fPurQty : row.sUnitID == '2' ? Number(row.fPrice) * row.sLetCode : Number(row.fPrice) * row.fQty;
                } else if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty) {
                    row.fQty = Number(row.fPurQty) * Number(Page.getFieldValue("fProductWeight")) * Number(Page.getFieldValue("fProductWidth")) / (100 * 1000);
                    row.sLetCode = row.fPurQty / 0.9144;
                    row.fTotal = isNaN(Number(row.fPrice)) == true ? 0 : row.sUnitID == '1' ? Number(row.fPrice) * row.fPurQty : row.sUnitID == '2' ? Number(row.fPrice) * row.sLetCode : Number(row.fPrice) * row.fQty;
                } else if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode) {
                    row.fPurQty = row.sLetCode * 0.9144;
                    row.fQty = Number(row.fPurQty) * Number(Page.getFieldValue("fProductWeight")) * Number(Page.getFieldValue("fProductWidth")) / (100 * 1000);
                    row.fTotal = isNaN(Number(row.fPrice)) == true ? 0 : row.sUnitID == '1' ? Number(row.fPrice) * row.fPurQty : row.sUnitID == '2' ? Number(row.fPrice) * row.sLetCode : Number(row.fPrice) * row.fQty;
                } else if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
                    row.fTotal = isNaN(Number(row.fPrice)) == true ? 0 : row.sUnitID == '1' ? Number(row.fPrice) * row.fPurQty : row.sUnitID == '2' ? Number(row.fPrice) * row.sLetCode : Number(row.fPrice) * row.fQty;
                }
            }
        }
        Page.beforeSave = function () {
            alert(1);
        }
        Page.afterSave = function () {
            if (getQueryString("savetype") == "producefollow") {
                var jsonobj = {
                    StoreProName: "SpStockProductSetQty2",
                    StoreParms: [
                    {
                        ParmName: "@iformid",
                        Value: 8033
                    },
                    {
                        ParmName: "@keys",
                        Value: Page.key
                    },
                    {
                        ParmName: "@userid",
                        Value: "'" + Page.getFieldValue("sUserID") + "'"
                    },
                    {
                        ParmName: "@btnid",
                        Value: "'" + "submit" + "'"
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
                if (result.length > 0) {
                    if (result[0] == '1') {
                        alert("提交成功!");
                    } else {
                        alert(result[0]);
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未出库外加工单" data-options="fit:true">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <div style="float: left; width: 80%;">
                            <table>
                                <tr>
                                    <td>加工单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sPlanBillNo" Z_NoSave="True" />
                                    </td>
                                    <td>产品编号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sPlanCode" Z_NoSave="True" />
                                    </td>
                                    <td>加工工序
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox111" runat="server" Z_FieldID="iPlanBscDataProcessMRecNo" Z_NoSave="True" />
                                    </td>
                                    <td>是否已完成
                                    </td>
                                    <td>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" Z_FieldID="iIsPlanFinish" Z_NoSave="True" />
                                    </td>
                                    <td>
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='searchPurOrderMD()'>查询</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='passIn()'>转入</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-remove'" onclick='finish()'>完成/取消完成</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="table2">
                    </table>
                </div>
            </div>
        </div>
        <div title="外加工出库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iProOutProduceDRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iSdOrderMRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iBscDataProcessMRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>
                                出库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                出库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    style="width:150px;" />
                            </td>
                            <td id="Td2">
                                加工厂/染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                     style="width:150px;"  />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatRecNo" style="width:150px;"  />
                            </td>
                            <td>
                                产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sName" Z_readOnly="true"
                                    Z_NoSave="true" />
                            </td>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBscDataColorRecNo" style="width:150px;"  />
                            </td>
                            <td>
                                颜色
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sColorName" Z_readOnly="true"
                                    Z_NoSave="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                幅宽
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWidth" />
                            </td>
                            <td>
                                克重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fProductWeight" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan='3'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="358px" Z_FieldID="sReMark" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iCalc" Z_NoSave="True"
                                    checked="checked" />
                                <label for="__ExtCheckbox2">
                                    米数换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iCalc1" Z_NoSave="True"
                                    checked="checked" />
                                <label for="__ExtCheckbox3">
                                    码换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCalc2" Z_NoSave="True" checked="checked" />
                                <label for="__ExtCheckbox1">
                                    重量换算米数</label>
                            </td>
                        </tr>
                        <%--<tr>
                             <td>
                                加工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iProcessOrderDRecNo" />
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <strong>请扫入条码</strong>
                            </td>
                            <td colspan="3">
                                <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 300px;
                                    height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                            </td>
                            <td colspan="2">
                                <textarea id="txaBarcodeTip" style="height: 40px; width: 260px;" readonly="readonly"
                                    class="txb"></textarea>
                            </td>
                        </tr>
                        
                        <%--<tr>                            
                            
                        </tr>--%>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="出库明细">
                            <table id="table1" tablename="MMStockProductOutD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
