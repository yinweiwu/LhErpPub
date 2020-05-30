<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            var aa = $("#btn_table1_add");
            aa[0].onclick = function () {
                var jsonobj = {
                    StoreProName: "GetTableLshJS",
                    StoreParms: [{
                        ParmName: "@tablename",
                        Value: "MMStockProductInD"
                    }]
                }
                var data = SqlStoreProce(jsonobj, true);
                if (data.length > 0) {
                    var rows = $('#table1').datagrid('getRows');
                    var a = {};
                    a.iRecNo = data[0].iRecNo;
                    a.iMainRecNo = Page.key;
                    a.iSerial = rows.length + 1;
                    
                    a.sUserID = Page.userid;
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
                    var hour = nowdate.getHours();      //获取当前小时数(0-23)
                    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
                    var second = nowdate.getSeconds();
                    a.dInputDate = year.toString() + "-" + monthstr + "-" + datestr + " " + hour + ":" + minute + ":" + second;

                    a.iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
                    a.sBerChID = Page.getFieldText("iBscDataStockDRecNo");
                    a.iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
                    a.sCode = Page.getFieldText("iBscDataMatRecNo");
                    a.sName = Page.getFieldValue("sName");
                    a.iBscDataColorRecNo = Page.getFieldValue("iBscDataColorRecNo");
                    a.sColorID = Page.getFieldText("iBscDataColorRecNo");
                    a.sColorName = Page.getFieldValue("sColorName");
                    a.iBscDataFlowerTypeRecNo = Page.getFieldValue("iBscDataFlowerTypeRecNo");
                    a.sFlowerType = Page.getFieldText("iBscDataFlowerTypeRecNo");
                    a.iBscDataProcessesMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
                    a.iSDContractDProcessDRecNo = Page.getFieldValue("iSDContractDProcessDRecNo");
                    a.sProcessesName = Page.getFieldText("iBscDataProcessMRecNo");
                    a.fProductWidth = Page.getFieldValue("fProductWidth");
                    a.fProductWeight = Page.getFieldValue("fProductWeight");
                    a.fPrice = Page.getFieldValue("fPrice");
                    a.sUnitID = Page.getFieldValue("sUnitID");
                    a.sUnitName = Page.getFieldText("sUnitID");
                    a.iProPlanDRecNo = Page.getFieldValue("iProPlanDRecNo");
                    a.iSdOrderMRecNo = Page.getFieldValue("iSdOrderMRecNo");
                    a.iSdOrderDRecNo = Page.getFieldValue("iSdOrderDRecNo");
                    $('#table1').datagrid('appendRow', a);
                }
            }

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
                        //alert(result[0].fProductWidth)
                        Page.setFieldValue("iBscDataMatRecNo", result[0].iBscDataMatRecNo);
                        Page.setFieldValue("sName", result[0].sName);
                        Page.setFieldValue("iBscDataColorRecNo", result[0].iBscDataColorRecNo);
                        Page.setFieldValue("sColorName", result[0].sColorName);
                        Page.setFieldValue("fProductWidth", result[0].fProductWidth);
                        Page.setFieldValue("fProductWeight", result[0].fProductWeight);
                        Page.setFieldValue("fQty", result[0].fQty);
                        Page.setFieldValue("sInUnitID", result[0].iCalcUnitID);
                        Page.setFieldValue("fProcessPrice", result[0].fProcessPrice);
                        Page.setFieldValue("iCalcUnitID", result[0].iCalcUnitID);
                        Page.setFieldValue("iCalcType", result[0].iCalcType);
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
                    { checkbox: true, field: "__cb", width: 30 },
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                        { title: "加工厂家", field: "sCustShortName", width: 100, sortable: true },
                        { title: "产品编号", field: "sCode", width: 100, sortable: true },
                        { title: "产品名称", field: "sName", width: 100, sortable: true },
                        { title: "加工工序", field: "sBscDataProcessName", width: 60, sortable: true },
                        { title: "色号", field: "sColorID", width: 100, sortable: true },
                        { title: "颜色", field: "sColorName", width: 100, sortable: true },
                        { title: "染厂颜色", field: "sColorNameChinese", width: 100, sortable: true },
                        { title: "花型", field: "sFlowerType", width: 100, sortable: true },
                        { title: "幅宽", field: "fProductWidth", width: 60, sortable: true },
                        { title: "克重", field: "fProductWeight", width: 60, sortable: true },
                        { title: "结算单位", field: "sCalcUnitName", width: 60, sortable: true },
                        { title: "数量", field: "fQty", width: 60, sortable: true },
                        { title: "已入库<br />数量", field: "fInQty", width: 60, sortable: true },
                        { title: "未入库<br />数量", field: "fNoInQty", width: 60, sortable: true },
                        { title: "重量", field: "fPurQty", width: 60, sortable: true },
                        { title: "已入库<br />重量", field: "fInWeight", width: 60, sortable: true },
                        { title: "未入库<br />重量", field: "fNotInWeight", width: 60, sortable: true },
                        { title: "匹数", field: "fPurQty", width: 50, sortable: true },
                        { title: "已入库<br />匹数", field: "iInQty", width: 50, sortable: true },
                        { title: "未入库<br />匹数", field: "iNotInQty", width: 50, sortable: true },
                        { field: "iBscDataFlowerTypeRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iSDOrderDRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iLastBscDataProcessMRecNo", hidden: true },
                        { field: "iCalcUnitID", hidden: true },
                        { field: "iProOutProduceDRecNo", hidden: true },
                        { field: "iRecNo", hidden: true },
                        { field: "iBscDataMatFabRecNo", hidden: true },
                        { field: "iSDOrderMRecNoBatch", hidden: true },
                        { field: "iSDContractDProcessDRecNo", hidden: true }
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
                    onDblClickRow: function (index, row) {
                        passIn(row);
                    },
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            else {
                $('#tabTop').tabs('close', '未入库外加工单');
            }

            Page.Children.toolBarBtnAdd("table1", "mybtn1", "计算金额", "tool", function () {
                var getRows1 = $('#table1').datagrid('getRows');
                var getRows2 = $('#table3').datagrid('getRows');
                if (getRows1.length > 0 && getRows2.length > 0) {
                    //计算投料单价
                    var fTouPrice = 0;
                    var fToutotal = 0;
                    var fQtyM = 0;
                    var fPurQtyM = 0;
                    var sLetCodeM = 0;
                    for (var i = 0; i < getRows2.length; i++) {
                        var sUnitID = isNaN(getRows2[i].sUnitID) == true ? 1 : getRows2[i].sUnitID;
                        var fQty = isNaN(getRows2[i].fQty) == true ? 0 : getRows2[i].fQty;
                        var fPurQty = isNaN(getRows2[i].fPurQty) == true ? 0 : getRows2[i].fPurQty;
                        var sLetCode = isNaN(getRows2[i].sLetCode) == true ? 0 : getRows2[i].sLetCode;
                        var fPrice = isNaN(getRows2[i].fPrice) == true ? 0 : getRows2[i].fPrice;
                        fQtyM = fQtyM + fQty;
                        fPurQtyM = fPurQtyM + fPurQty;
                        sLetCodeM = sLetCodeM + sLetCode;
                        if (sUnitID == 0)
                            fToutotal = fToutotal + fPurQty * fPrice;
                        else if (sUnitID == 1)
                            fToutotal = fToutotal + fQty * fPrice;
                        else if (sUnitID == 2)
                            fToutotal = fToutotal + sLetCode * fPrice;
                    }
                    var fRealQty = 0;
                    var fRealTotal = 0;
                    for (var ii = 0; ii < getRows1.length; ii++) {
                        var sUnitID = isNaN(getRows1[ii].sUnitID) == true ? 1 : getRows1[ii].sUnitID;
                        var fPrice = isNaN(getRows1[ii].fPrice) == true ? 0 : getRows1[ii].fPrice;
                        var fMatPrice = 0;
                        if (sUnitID == 0) {
                            if (fPurQtyM == 0) {
                                alert("投料重量为0，请检查");
                                return false;
                            }
                            fRealQty = isNaN(getRows1[ii].fPurQty) == true ? 0 : getRows1[ii].fPurQty;
                            fMatPrice = fToutotal / fPurQtyM;
                        }
                        else if (sUnitID == 1) {
                            if (fQtyM == 0) {
                                alert("投料米数为0，请检查");
                                return false;
                            }
                            fRealQty = isNaN(getRows1[ii].fQty) == true ? 0 : getRows1[ii].fQty;
                            fMatPrice = fToutotal / fQtyM;
                        }
                        else if (sUnitID == 2) {
                            if (sLetCodeM == 0) {
                                alert("投料码数为0，请检查");
                                return false;
                            }
                            fRealQty = isNaN(getRows1[ii].sLetCodeM) == true ? 0 : getRows1[ii].sLetCodeM;
                            fMatPrice = fToutotal / sLetCodeM;
                        }

                        var fRealPrice = fPrice + fMatPrice;
                        fRealTotal += fRealPrice * fRealQty;

                        var index = $("#table1").datagrid("getRowIndex", getRows1[ii]);
                        $("#table1").datagrid("updateRow", { index: index, row: { fTotal: fRealPrice * fRealQty } });
                    }
                    Page.setFieldValue("fTotal", fRealTotal);
                }
                else {
                    alert("投料或者入库明细无数据");
                }
            })

            Page.setFieldValue("iCalc", 0);
            Page.setFieldValue("iCalc1", 0);
            Page.setFieldValue("iCalc2", 0);
        })


        function searchPlanMD() {
            var dDate1 = Page.getFieldValue('dDate1').trim();
            var dDate2 = Page.getFieldValue('dDate2').trim();
            var sPlanBillNo = Page.getFieldValue('sPlanBillNo').trim();
            var iBscDataCustomerRecNo1 = isNaN(Number(Page.getFieldValue('iBscDataCustomerRecNo1'))) ? 0 : Number(Page.getFieldValue('iBscDataCustomerRecNo1'));
            var sOrderNo1 = Page.getFieldValue('sOrderNo1').trim();
            var iPlanBscDataProcessMRecNo = isNaN(Number(Page.getFieldValue('iPlanBscDataProcessMRecNo'))) ? 0 : Number(Page.getFieldValue('iPlanBscDataProcessMRecNo'));
            var iIsPlanFinish = isNaN(Number(Page.getFieldValue('iIsPlanFinish'))) ? 0 : Number(Page.getFieldValue('iIsPlanFinish'));

            if (iBscDataCustomerRecNo1 == 0) {
                alert("请选择加工商");
                return false;
            }

            if (sOrderNo1 == "") {
                alert("请输入订单号");
                return false;
            }

            if (dDate1 == "") {
                dDate1 = "1970-01-01";
            }
            if (dDate2 == "") {
                dDate2 = "2199-12-31";
            }

            var sqlObjOrderMD = {
                TableName: "vwProPlanMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(sBillNo,'')",
                        ComOprt: "like",
                        Value: "'%" + sPlanBillNo + "%'",
                        LinkOprt: "and"
                    }, {
                        Field: "case when " + iBscDataCustomerRecNo1 + " = 0 then 0 else isnull(iBscDataCustomerRecNo,0) end",
                        ComOprt: "=",
                        Value: iBscDataCustomerRecNo1,
                        LinkOprt: "and"
                    }, {
                        Field: "isnull(sOrderNo,'')",
                        ComOprt: "like",
                        Value: "'%" + sOrderNo1 + "%'",
                        LinkOprt: "and"
                    }, {
                        Field: "case when " + iPlanBscDataProcessMRecNo + " = 0 then 0 else isnull(iBscDataProcessMRecNo,0) end",
                        ComOprt: "=",
                        Value: "'" + iPlanBscDataProcessMRecNo + "'",
                        LinkOprt: "and"
                    }, {
                        Field: "isnull(iFinish,0)",
                        ComOprt: "=",
                        Value: "'" + iIsPlanFinish + "'",
                        LinkOprt: "and"
                    }, {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3"
                    }
                ],
                Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "desc"
                    }
                ]
            };

            var resultSendMD = SqlGetData(sqlObjOrderMD);
            $("#table2").datagrid("loadData", resultSendMD);
        }

        function finish() {
            var getRows = $("#table2").datagrid('getChecked');
            if (getRows.length > 0) {
                $.messager.confirm("确认吗？", "您确认完成/取消完成吗？", function (r) {
                    if (r) {
                        for (var i = 0; i < getRows.length; i++) {
                            var jsonobj = {
                                StoreProName: "SpFinish",
                                StoreParms: [{
                                    ParmName: "@iformid",
                                    Value: "ProPlanD"
                                },
                                {
                                    ParmName: "@iRecNo",
                                    Value: getRows[i].iRecNo
                                },
                                {
                                    ParmName: "@sUserID",
                                    Value: Page.userid
                                }]
                            }
                            var Result = SqlStoreProce(jsonobj);
                        }
                        searchPlanMD();
                    }
                });
            }
        }

        function passIn(row) {
            if (row) {
                var iProPlanMRecNo = Page.getFieldValue("iProPlanMRecNo");
                var iBscDataProcessMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
                iProPlanMRecNo = isNaN(Number(iProPlanMRecNo)) ? 0 : Number(iProPlanMRecNo);
                iBscDataProcessMRecNo = isNaN(Number(iBscDataProcessMRecNo)) ? 0 : Number(iBscDataProcessMRecNo);
                if (iProPlanMRecNo > 0) {
                    if (row.iMainRecNo != iProPlanMRecNo) {
                        alert("转入的加工单不一致");
                        return false;
                    } else if (row.iLastBscDataProcessMRecNo != iBscDataProcessMRecNo) {
                        alert("转入的工序不一致");
                        return false;
                    }
                }

                Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
                Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo);
                Page.setFieldValue("iBscDataColorRecNo", row.iBscDataColorRecNo);
                Page.setFieldValue("fProductWidth", row.fProductWidth);
                Page.setFieldValue("fProductWeight", row.fProductWeight);
                Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
                Page.setFieldValue("iProPlanDRecNo", row.iRecNo);
                Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
                Page.setFieldValue("iBscDataProcessMRecNo", row.iLastBscDataProcessMRecNo);
                Page.setFieldValue("iProPlanMRecNo", row.iMainRecNo);
                Page.setFieldValue("iBscDataFlowerTypeRecNo", row.iBscDataFlowerTypeRecNo);
                Page.setFieldValue("sUnitID", row.iCalcUnitID);
                Page.setFieldValue("iBscDataMatFabRecNo", row.iBscDataMatFabRecNo);
                Page.setFieldValue("sColorNameChinese", row.sColorNameChinese);
                Page.setFieldValue("iSDContractDProcessDRecNo", row.iSDContractDProcessDRecNo);
                

                var a = {};
                a.iSDOrderMRecNoBatch = row.iSDOrderMRecNoBatch;
                a.sOrderNo = row.sOrderNo;
                a.iProPlanDRecNo = row.iRecNo;
                a.iBscDataMatRecNo = row.iBscDataMatRecNo;
                a.iBscDataColorRecNo = row.iBscDataColorRecNo;
                a.fProductWeight = row.fProductWeight;
                a.fProductWidth = row.fProductWidth;
                a.iSdOrderMRecNo = row.iSdOrderMRecNo;
                a.iBscDataFlowerTypeRecNo = row.iBscDataFlowerTypeRecNo;
                a.iBscDataProcessesMRecNo = row.iBscDataProcessMRecNo;
                a.iSdOrderDRecNo = row.iSdOrderDRecNo;
                a.sColorNameChinese = row.sColorNameChinese; 
                a.iSDContractDProcessDRecNo = row.iSDContractDProcessDRecNo;
                a.sCode = row.sCode;
                a.sName = row.sName;
                a.sColorID = row.sColorID;
                a.sColorName = row.sColorName;
                a.sFlowerType = row.sFlowerType;
                a.sProcessesName = row.sProcessesName;
                a.fPrice = row.fPrice;
                a.sUnitID = row.iCalcUnitID;
                a.iQty = row.iNotInQty;
                a.fQty = row.fNotInQty;
                a.fPurQty = row.fNotInWeight;
                a.sUnitName = row.sCalcUnitName;
                Page.tableToolbarClick("add", "table1", a);

                $("#tabTop").tabs("select", "外加工入库单");
            } else {
                var rows = $("#table2").datagrid('getChecked');
                var iProPlanMRecNo = Page.getFieldValue("iProPlanMRecNo");
                var iBscDataProcessMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
                iProPlanMRecNo = isNaN(Number(iProPlanMRecNo)) ? 0 : Number(iProPlanMRecNo);
                iBscDataProcessMRecNo = isNaN(Number(iBscDataProcessMRecNo)) ? 0 : Number(iBscDataProcessMRecNo);

                if (iProPlanMRecNo > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        if (rows[i].iMainRecNo != iProPlanMRecNo) {
                            alert("转入的加工单不一致");
                            return false;
                        } else if (rows[i].iLastBscDataProcessMRecNo != iBscDataProcessMRecNo) {
                            alert("转入的工序不一致");
                            return false;
                        }
                    }
                } else {
                    for (var i = 1; i < rows.length; i++) {
                        if (rows[i - 1].iMainRecNo != rows[i].iMainRecNo) {
                            alert("转入的加工单不一致");
                            return false;
                        } else if (rows[i - 1].iLastBscDataProcessMRecNo != rows[i].iLastBscDataProcessMRecNo) {
                            alert("转入的工序不一致");
                            return false;
                        }
                    }
                }
                
                for (var i = 0; i < rows.length; i++) {
                    Page.setFieldValue("iBscDataCustomerRecNo", rows[i].iBscDataCustomerRecNo);
                    Page.setFieldValue("iBscDataMatRecNo", rows[i].iBscDataMatRecNo);
                    Page.setFieldValue("iBscDataColorRecNo", rows[i].iBscDataColorRecNo);
                    Page.setFieldValue("fProductWidth", rows[i].fProductWidth);
                    Page.setFieldValue("fProductWeight", rows[i].fProductWeight);
                    Page.setFieldValue("iBscDataCustomerRecNo", rows[i].iBscDataCustomerRecNo);
                    Page.setFieldValue("iProPlanDRecNo", rows[i].iRecNo);
                    Page.setFieldValue("iSdOrderMRecNo", rows[i].iSdOrderMRecNo);
                    Page.setFieldValue("iBscDataProcessMRecNo", rows[i].iLastBscDataProcessMRecNo);
                    Page.setFieldValue("iProPlanMRecNo", rows[i].iMainRecNo);
                    Page.setFieldValue("iBscDataFlowerTypeRecNo", rows[i].iBscDataFlowerTypeRecNo);
                    Page.setFieldValue("sUnitID", rows[i].iCalcUnitID);
                    Page.setFieldValue("iBscDataMatFabRecNo", rows[i].iBscDataMatFabRecNo);
                    Page.setFieldValue("sColorNameChinese", rows[i].sColorNameChinese);
                    Page.setFieldValue("iSDContractDProcessDRecNo", rows[i].iSDContractDProcessDRecNo);

                    var a = {};
                    a.iSDOrderMRecNoBatch = rows[i].iSDOrderMRecNoBatch;
                    a.sOrderNo = rows[i].sOrderNo;
                    a.iProPlanDRecNo = rows[i].iRecNo;
                    a.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                    a.iBscDataColorRecNo = rows[i].iBscDataColorRecNo;
                    a.fProductWeight = rows[i].fProductWeight;
                    a.fProductWidth = rows[i].fProductWidth;
                    a.iSdOrderMRecNo = rows[i].iSdOrderMRecNo;
                    a.iBscDataFlowerTypeRecNo = rows[i].iBscDataFlowerTypeRecNo;
                    a.iBscDataProcessesMRecNo = rows[i].iBscDataProcessesMRecNo;
                    a.iSdOrderDRecNo = rows[i].iSdOrderDRecNo;
                    a.sColorNameChinese = rows[i].sColorNameChinese;
                    a.iSDContractDProcessDRecNo = rows[i].iSDContractDProcessDRecNo;
                    a.sCode = rows[i].sCode;
                    a.sName = rows[i].sName;
                    a.sColorID = rows[i].sColorID;
                    a.sColorName = rows[i].sColorName;
                    a.sFlowerType = rows[i].sFlowerType;
                    a.sProcessesName = rows[i].sProcessesName;
                    a.fPrice = rows[i].fPrice;
                    a.sUnitID = rows[i].iCalcUnitID;
                    a.sUnitName = rows[i].sCalcUnitName;
                    a.iQty = rows[i].iNotInQty;
                    a.fQty = rows[i].fNotInQty;
                    a.fPurQty = rows[i].fNotInWeight;
                    Page.tableToolbarClick("add", "table1", a);
                }
                $("#tabTop").tabs("select", "外加工入库单");
            }
            Page.Children.ReloadFooter("table1");
        }

        function getStockM(iBscDataCustomerRecNo) {
            var sqlObj = {
                TableName: "BscDataStockM",
                Fields: "iRecNo", SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataCustomerRecNo", ComOprt: "=", Value: "'" + iBscDataCustomerRecNo + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length == 0) {

            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                var iCalc1 = Page.getFieldValue("iCalc1");
                if (iCalc1 == "1") {
                    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode)) * 0.9144;
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fPurQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#table1").datagrid("updateRow", { index: index, row: { fQty: fQty } });
                    }
                }
                Page.Children.ReloadFooter("table1");
                var rows = $("#table1").datagrid('getRows');
                var fQtyM = 0;
                var fPurQtyM = 0;
                var sLetCodeM = 0;
                var fTotalM = 0;
                for (var i = 0; i < rows.length; i++) {
                    fQtyM += isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                    fPurQtyM += isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                    sLetCodeM += isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode);
                    fTotalM += isNaN(parseFloat(row.fTotal)) ? 0 : parseFloat(row.fTotal);
                }
                Page.setFieldValue("fQty", fQtyM.toFixed(2));
                Page.setFieldValue("fPurQty", fPurQtyM.toFixed(2));
                Page.setFieldValue("sLetCode", sLetCodeM.toFixed(2));
                Page.setFieldValue("fTotal", fTotalM.toFixed(2));
            }
            if (tableid == "table3") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table3").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                var iCalc1 = Page.getFieldValue("iCalc1");
                if (iCalc1 == "1") {
                    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode)) * 0.9144;
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table3").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fPurQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#table3").datagrid("updateRow", { index: index, row: { fQty: fQty } });
                    }
                }
                Page.Children.ReloadFooter("table3");
            }
        }


         

        Page.afterSave = function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                var jsonobj = {
                    StoreProName: "SpBuildBatchNo",
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

            if (Page.usetype == "add" || Page.usetype == "modify") {
                //算入库单价
                var jsonobj = {
                    StoreProName: "SpCalcMMStockProductInPrice",
                    StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }

        Page.Formula = function (field) {
            if (Page.isInited) {
                if (field == "iBscDataStockMRecNo") {

                    var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo"); 
                    if (iBscDataStockMRecNo == "196") {
                        Page.setFieldValue("iCalc", 0);
                        Page.setFieldValue("iCalc1", 0);
                        Page.setFieldValue("iCalc2", 0);
                    }
                }

            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未入库外加工单" data-options="fit:true">
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
                                    <td>日期从
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dDate1" Z_NoSave="True" Z_FieldType="日期" />
                                    </td>
                                    <td>至
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="dDate2" Z_NoSave="True" Z_FieldType="日期" />
                                    </td>
                                    <td>加工单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sPlanBillNo" Z_NoSave="True" />
                                    </td>
                                    <td>加工厂商
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo1" Z_NoSave="True" />
                                    </td>

                                    <td>
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='searchPlanMD()'>查询</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='passIn()'>转入</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                    data-options="iconCls:'icon-remove'" onclick='finish()'>完成/取消完成</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>订单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sOrderNo1" Z_NoSave="True" />
                                    </td>
                                    <td>加工工序
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox233" runat="server" Z_FieldID="iPlanBscDataProcessMRecNo" Z_NoSave="True" />
                                    </td>
                                    <td>是否已完成
                                    </td>
                                    <td>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" Z_FieldID="iIsPlanFinish" Z_NoSave="True" />
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
        <div title="外加工入库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iProPlanDRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iSdOrderMRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sInputUserName" />
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iMMStockQtyOutRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iBscDataStockMRecNo_Suppy" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="iBscDataMatFabRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatRecNo" Z_NoSave="true" Z_readOnly="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sName" Z_readOnly="true" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBscDataColorRecNo" Z_NoSave="true" Z_readOnly="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sColorName" Z_readOnly="true" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iBscDataFlowerTypeRecNo" Z_readOnly="true" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWidth" Z_readOnly="true" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fProductWeight" Z_readOnly="true" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="sColorNameChinese" Z_readOnly="true" Z_NoSave="true" /> 
                        <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="iSDContractDProcessDRecNo" Z_readOnly="true" Z_NoSave="true" /> 
                         
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>入库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>入库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td id="Td2">外加工厂商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px" />
                            </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr>
                            <td>加工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iProPlanMRecNo" Z_readOnly="true" />
                            </td>
                            <td>工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataProcessMRecNo" Z_readOnly="true" />
                            </td>
                            <td>结算单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sUnitID" Z_readOnly="true"
                                    Z_NoSave="true" Style="width: 150px" />
                            </td>
                            <td colspan="2">
                                <label>
                                    <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iRed" />
                                    红冲</label>
                            </td>
                        </tr>
                        <tr>
                            <td>米数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" Z_decimalDigits="2" />
                            </td>
                            <td>重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fPurQty" Z_readOnly="True" Z_decimalDigits="2" />
                            </td>
                            <td>码数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sLetCode" Z_readOnly="True" Z_decimalDigits="2" />
                            </td>
                            <td>金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fTotal" Style="width: 150px" Z_readOnly="true" Z_decimalDigits="2" />
                            </td>
                        </tr>
                        <tr>
                            <td>备注
                            </td>
                            <td colspan='5'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="358px" Z_FieldID="sReMark" />
                            </td>
                            <td>仓位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iBscDataStockDRecNo"
                                    Z_NoSave="true" Style="width: 150px" />
                            </td>
                        </tr>
                        <tr>
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
                            <td colspan="4">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCalc" Z_NoSave="True"
                                    checked="checked" />
                                <label for="__ExtCheckbox1">
                                    米数换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iCalc1" Z_NoSave="True"
                                    checked="checked" />
                                <label for="__ExtCheckbox2">
                                    码换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iCalc2" Z_NoSave="True"
                                    checked="checked" />
                                <label for="__ExtCheckbox3">
                                    重量换算米数</label>
                            </td>
                            <%--<td>
                                入库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sInUnitID" Style="width: 150px" />
                            </td>--%>
                            <%-- <td>
                                投料单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sFeedUnitID" Style="width: 150px"/>
                            </td>--%>
                        </tr>
                        <%--<tr>
                            <td>
                                加工单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fProcessPrice"  />
                            </td>
                            <td>
                                加工单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iCalcUnitID" Style="width: 150px"/>
                            </td>
                            <td>
                                加工类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iCalcType" Style="width: 150px"/>
                            </td>                            
                        </tr>
                        <tr>
                            <td>
                                投料单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fTouPrice"  />
                            </td>
                             <td>
                                实际加工单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fRealProcessPrice"  />
                            </td>
                            <td>
                                生产单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fRealPrice"  />
                            </td>                            
                        </tr>
                        <tr>
                             <td>
                                加工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="iProcessOrderDRecNo" />
                            </td>
                        </tr>--%>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="入库明细">
                            <table id="table1" tablename="MMStockProductInD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="加工商投料明细">
                            <table id="table3" tablename="MMStockProductInDOut">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
