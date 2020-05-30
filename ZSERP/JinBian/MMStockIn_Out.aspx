<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                if (getQueryString("savetype") == "producefollow") {
                    $("#tabTop").tabs("select", "外加工入库单");
                    $("#tabTop").tabs('getTab', "未入库外加工单").panel('options').tab.hide();
                    Page.setFieldValue("iProcessOrderDRecNo", getQueryString("iProcessOrderDRecNo"));
                    Page.setFieldValue("iBscDataCustomerRecNo", getQueryString("iBscDataCustomerRecNo"));
                    Page.setFieldValue("iBscDataMatRecNo", getQueryString("iBscDataMatRecNo"));
                    Page.setFieldValue("iBscDataColorRecNo", getQueryString("iBscDataColorRecNo"));
                    Page.setFieldValue("fProductWidth", getQueryString("fProductWidth"));
                    Page.setFieldValue("fProductWeight", getQueryString("fProductWeight"));
                    //
                    var sqlObj = {
                        TableName: "vwProcessOrderMD",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: getQueryString("iProcessOrderDRecNo")
                    }]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        var appRow = {};
                        appRow.iSerial = 1;
                        appRow.sOrderNo = result[0].sOrderNo;
                        appRow.sCode = result[0].sCode;
                        appRow.sName = result[0].sName;
                        appRow.fProductWidth = result[0].fProductWidth;
                        appRow.fProductWeight = result[0].fProductWeight;
                        appRow.fPurQty = result[0].fPurQty;
                        appRow.fPurQtyM = result[0].fPurQtyM;
                        appRow.fQty = result[0].fQty;
                        appRow.iCalcUnitID = result[0].iCalcUnitID;
                        appRow.iCalcType = result[0].iCalcType;
                        appRow.sInUnitID = result[0].iCalcUnitID;
                        appRow.sProOutProduceBillNo = result[0].sBillNo;
                        appRow.dPlanAskDate = result[0].dDate;
                        appRow.fProcessPrice = result[0].fProcessPrice;
                        Page.tableToolbarClick("add", "table1", appRow);
                    }
                    //
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
                        { field: "__ck", width: 80, sortable: true, checkbox: true },
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                         { title: "加工厂家", field: "sCustShortName", width: 100, sortable: true },
                        { title: "坯布编号", field: "sBscDataFabCode", width: 100, sortable: true },
                        { title: "坯布名称", field: "sBscDataFabName", width: 100, sortable: true },
                        { title: "加工重量", field: "fQty", width: 80, sortable: true },
                        { title: "匹数", field: "fPurQty", width: 60, sortable: true },
                        { title: "未入库重量", field: "fNoInQty", width: 80, sortable: true },
                        { title: "单价", field: "fPrice", width: 80, sortable: true, hidden: true },
                        { field: "金额", field: "fNoInTotal", width: 80, sortable: true, hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iSDOrderDRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "fMatProductWeight", hidden: true },
                        { field: "fMatProductWeight", hidden: true }

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
                    }, '-', {
                        iconCls: 'icon-import',
                        text: "转入",
                        handler: function () {
                            passIn();
                        }
                    }
                    , '-', {
                        iconCls: 'icon-ok',
                        text: "标记完成",
                        handler: function () {
                            flagFinish();
                        }
                    }

                    ],
                    onSelect: function (index, row) {
                        lastSelectedSendMRecNo = row.iRecNo;
                    }
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            else {
                $('#tabTop').tabs('close', '未入库外加工单');
            }
            Page.Children.toolBarBtnAdd("table1", "mybtn1", "计算成本", "tool", function () {
                var getRows1 = $('#table1').datagrid('getRows');
                var getRows2 = $('#table3').datagrid('getRows');
                if (getRows1.length > 0 && getRows2.length > 0) {
                    //计算投料单价
                    var fTouPrice = 0;
                    var fToutotal = 0;
                    var fToutotalQ = 0;
                    var fToutotalM = 0;
                    var fToutotalL = 0;
                    for (var i = 0; i < getRows2.length; i++) {
                        var sUnitID = isNaN(getRows2[i].sUnitID) == true ? 0 : getRows2[i].sUnitID;
                        var fQty = isNaN(getRows2[i].fQty) == true ? 0 : getRows2[i].fQty;
                        var fPurQtyM = isNaN(getRows2[i].fPurQtyM) == true ? 0 : getRows2[i].fPurQtyM;
                        var sLetCode = isNaN(getRows2[i].sLetCode) == true ? 0 : getRows2[i].sLetCode;
                        var fPrice = isNaN(getRows2[i].fPrice) == true ? 0 : getRows2[i].fPrice;
                        fToutotalQ = fToutotalQ + fQty;
                        fToutotalM = fToutotalM + fPurQtyM;
                        fToutotalL = fToutotalL + sLetCode;
                        if (sUnitID == 0)
                            fToutotal = fToutotal + fQty * fPrice;
                        else if (sUnitID == 1)
                            fToutotal = fToutotal + fPurQtyM * fPrice;
                        else if (sUnitID == 2)
                            fToutotal = fToutotal + sLetCode * fPrice;
                    }
                    var fRealQty = 0;
                    for (var ii = 0; ii < getRows1.length; ii++) {
                        var sUnitID = isNaN(getRows1[ii].sInUnitID) == true ? 0 : getRows1[ii].sInUnitID;
                        var iCalcUnitID = isNaN(getRows1[ii].iCalcUnitID) == true ? 0 : getRows1[ii].iCalcUnitID;
                        var fQty = isNaN(getRows1[ii].fQty) == true ? 0 : getRows1[ii].fQty;
                        var fPurQtyM = isNaN(getRows1[ii].fPurQtyM) == true ? 0 : getRows1[ii].fPurQtyM;
                        var sLetCode = isNaN(getRows1[ii].sInLetCode) == true ? 0 : getRows1[ii].sInLetCode;

                        var iCalcType = isNaN(getRows1[ii].iCalcType) == true ? 0 : getRows1[ii].iCalcType;

                        var fProcessPrice = isNaN(getRows1[ii].fProcessPrice) == true ? 0 : getRows1[ii].fProcessPrice;
                        var fProcessPriceQ = 0;
                        var fProcessPriceM = 0;
                        var fProcessPriceL = 0;
                        var fRealProcessPrice = 0;
                        if (sUnitID == 0) {
                            fRealQty = fQty;
                        }
                        else if (sUnitID == 1)
                            fRealQty = fPurQtyM;
                        else if (sUnitID == 2)
                            fRealQty = sLetCode;
                        if (fRealQty == 0)
                            fTouPrice = 0;
                        else
                            fTouPrice = fToutotal / fRealQty;
                        if (iCalcType == 1) {
                            if (fQty == 0)
                                break;
                            if (sUnitID == 0) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / fQty;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / fQty;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / fQty;
                                }
                            }
                            else if (sUnitID == 1) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / fPurQtyM;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / fPurQtyM;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / fPurQtyM;
                                }
                            }
                            else if (sUnitID == 2) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / sLetCode;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / sLetCode;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / sLetCode;
                                }
                            }
                        }
                        else if (iCalcType == 2) {
                            if (fToutotal == 0)
                                break;
                            if (sUnitID == 0) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / fToutotal;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / fToutotal;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / fToutotal;
                                }
                            }
                            else if (sUnitID == 1) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / fToutotal;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / fToutotal;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / fToutotal;
                                }
                            }
                            else if (sUnitID == 2) {
                                if (iCalcUnitID == 0) {
                                    fRealProcessPrice = fProcessPrice * fQty / fToutotal;
                                }
                                else if (iCalcUnitID == 1) {
                                    fRealProcessPrice = fProcessPrice * fPurQtyM / fToutotal;
                                }
                                else if (iCalcUnitID == 2) {
                                    fRealProcessPrice = fProcessPrice * sLetCode / fToutotal;
                                }
                            }
                        }
                        var fRealPrice = fTouPrice + fRealProcessPrice;
                        $("#table1").datagrid("updateRow", { index: ii, row: { fTouPrice: fTouPrice, fRealProcessPrice: fRealProcessPrice, fRealPrice: fRealPrice} });

                    }

                    //
                }
                else {
                    alert("未选中行");
                }
            })
        })

        function search1() {
            var sqlObjOrderMD = {
                TableName: "vwProOutProduceMDFab",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                //                                        {
                //                        Field: "isnull(fNoInQty,0)",
                //                        ComOprt: ">",
                //                        Value: "0",
                //                        LinkOprt: "and"
                //                    },
                    {
                    Field: "isnull(iStatus,0)",
                    ComOprt: ">",
                    Value: "3",
                    LinkOprt: "and"
                   },
                    {
                        Field: "sFinish",
                        ComOprt: "<>",
                        Value: "'√'"
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

        function passIn() {
            var rows = $('#table2').datagrid('getChecked');
            if (rows.length > 0) {
                var iCustomerRecNo = 0;
                iCustomerRecNo = rows[0].iBscDataCustomerRecNo;
                for (var i = 1; i < rows.length; i++) {
                    if (iCustomerRecNo != rows[i].iBscDataCustomerRecNo) {
                        alert("一次只能转入同一个加工厂商的入库记录！");
                        return;
                    }
                }

                Page.setFieldValue("iBscDataCustomerRecNo", iCustomerRecNo);
                for (var i = 0; i < rows.length; i++) {
                    var appRow = {};
                    appRow.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                    appRow.fQty = rows[i].fNoInQty;
                    appRow.sOrderNo = rows[i].sOrderNo;
                    appRow.fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
                    appRow.fTotal = isNaN(parseFloat(rows[i].fNoInTotal)) ? 0 : parseFloat(rows[i].fNoInTotal);
                    appRow.fPurQty = rows[i].fPurQty;
                    appRow.iSDOrderMRecNo = rows[i].iSdOrderMRecNo;
                    appRow.sCode = rows[i].sBscDataFabCode;
                    appRow.sName = rows[i].sBscDataFabName;
                    appRow.sProOutProduceBillNo = rows[i].sBillNo;
                    appRow.iProOutProduceDRecNo = rows[i].iRecNo;
                    appRow.fProductWidth = rows[i].fMatProductWeight;
                    appRow.fProductWeight = rows[i].fMatProductWeight;
                    Page.tableToolbarClick("add", "table1", appRow);
                }
                $("#tabTop").tabs("select", 1);
            }
        }

        function flagFinish() {
            var selectRows = $("#table2").datagrid("getChecked");
            if (selectRows.length > 0) {

                $.messager.confirm("您确认标记完成吗？", "您确认标记完成吗？", function (r) {
                    if (r) {
                        for (var i = 0; i < selectRows.length; i++) {
                            var jsonobj = {
                                StoreProName: "SpProOutProduceDFinish",
                                StoreParms: [
                                    {
                                        ParmName: "@iformid",
                                        Value: 1
                                    },
                                    {
                                        ParmName: "@keys",
                                        Value: selectRows[i].iRecNo
                                    }
                                    ,
                                    {
                                        ParmName: "@userid",
                                        Value: Page.userid
                                    }
                                    ,
                                    {
                                        ParmName: "@btnid",
                                        Value: "doFabFinish"
                                    }
                                    ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                alert(result)
                            }
                            else {
                                search1();
                            }

                        }
                    }
                })
            }
        }

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

        Page.beforeSave = function () {
            if (checkMonth() == false) {
                return false;
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
                        Value: 1
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }
        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
                    var fPurQtyM = Number(row.fProductWidth) == 0 || Number(row.fProductWeight) == 0 ? 0 : Number(row.fQty) * 100 * 1000 / (Number(row.fProductWeight) * Number(row.fProductWidth));
                    $("#table1").datagrid("updateRow", { index: index, row: { fPurQtyM: fPurQtyM} });
                } else if (datagridOp.currentColumnName == "fPurQtyM" && changes.fPurQtyM) {
                    var fQty = Number(row.fPurQtyM) * Number(row.fProductWeight) * Number(row.fProductWidth) / (100 * 1000);
                    $("#table1").datagrid("updateRow", { index: index, row: { fQty: fQty} });
                } else if (datagridOp.currentColumnName == "fFeedQty" && changes.fFeedQty) {
                    var fFeedPurQtyM = Number(row.fProductWidth) == 0 || Number(row.fProductWeight) == 0 ? 0 : Number(row.fFeedQty) * 100 * 1000 / (Number(row.fProductWeight) * Number(row.fProductWidth));
                    $("#table1").datagrid("updateRow", { index: index, row: { fFeedPurQtyM: fFeedPurQtyM} });
                } else if (datagridOp.currentColumnName == "fFeedPurQtyM" && changes.fFeedPurQtyM) {
                    var fFeedQty = Number(row.fFeedPurQtyM) * Number(row.fProductWeight) * Number(row.fProductWidth) / (100 * 1000);
                    $("#table1").datagrid("updateRow", { index: index, row: { fFeedQty: fFeedQty} });
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未入库外加工单" data-options="fit:true">
            <table id="table2">
            </table>
        </div>
        <div title="外加工入库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>
                                入库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                入库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td>
                                入库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" Style="width: 140px;" />
                            </td>
                        </tr>
                        <tr>
                            <td id="iBscDataCustomerRecNo3">
                                外加工商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td id="Td1">
                                会计月份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" Style="width: 150px"
                                    Z_readOnly="True" Z_Required="True" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan='7'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="99%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                            <td style="display: none;">
                                金额
                            </td>
                            <td style="display: none;">
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
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
                        </tr>
                        <tr>
                             <td>
                                加工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iProcessOrderDRecNo" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="入库明细">
                            <table id="table1" tablename="MMStockInD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="投料明细">
                            <table id="table3" tablename="MMStockInTouD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
