<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var iBillType = "";
        var sCustShortName = "供应商";
        var sCode = "sCode";
        var sName = "sName";
        var PurPastRate = 0;
        $(function () {
            iBillType = getQueryString("iBillType");
            Page.setFieldValue("iBillType", iBillType);
            if (iBillType == "2") {
                sCode = "sBscDataFabCode";
                sName = "sBscDataFabName";
                sCustShortName = "生产厂商";
                $("#iBscDataCustomerRecNo1").html("生产厂商");
                $("#iBscDataCustomerRecNo3").html("生产厂商");
                Page.setFieldValue("iBscDataCustomerRecNo1", "736");
                var tab2 = $('#tabTop').tabs('getTab', '采购入库单');
                $('#tabTop').tabs('update', {
                    tab: tab2,
                    options: {
                        title: '生产入库单'
                    }
                });
                var tab = $('#tabTop').tabs('getTab', '未入库采购订单');
                $('#tabTop').tabs('update', {
                    tab: tab,
                    options: {
                        title: '未入库生产指令单'
                    }
                });
            }
            var sqlObjRate = {
                TableName: "bscDataListD",
                Fields: "sCode",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID",
                        ComOprt: "=",
                        Value: "'PurPastRate'"
                    }
                ]
            }
            var resultPurPastRate = SqlGetData(sqlObjRate);
            if (resultPurPastRate.length > 0) {
                PurPastRate = resultPurPastRate[0].sCode;
            }

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
            if (Page.usetype == "add" || Page.usetype == "modify") {
                var columns;
                if (iBillType == 2) {
                    columns = [[
                        { field: "iRecNo", width: 80, sortable: true, checkbox: true },
                        { title: "完成否", field: "sTheFinish", width: 40, sortable: true, align: "center" },
                        { title: "生产单号", field: "sProOrderNo", width: 110, sortable: true },
                        { title: "生产日期", field: "dProDate", width: 80, sortable: true },
                         { title: "生产厂家", field: "ManufacturerName", width: 80, sortable: true },
                        { title: "订单号", field: "sOrderNo", width: 100 },
                        { title: "订单客户", field: "sCustShortName1", width: 80 },
                        { title: "坯布编号", field: "" + sCode + "", width: 120 },
                        { title: "坯布名称", field: "" + sName + "", width: 120 },
                    //{ title: "单价", field: "fPrice", width: 80, sortable: true },
                        {title: "总重量", field: "fFabQty", width: 60, sortable: true },
                        { title: "总匹数", field: "iFabQty", width: 60, sortable: true },
                    //{ title: "总金额", field: "fTotal", width: 80, sortable: true },
                        {title: "未入库重量", field: "fFabNotInQty", width: 80, sortable: true },
                        { title: "未入库匹数", field: "iFabNotInQty", width: 80, sortable: true },
                        { title: "业务员", field: "sUserName", width: 60, sortable: true },
                    //{ title: "未入库金额", field: "fNoInTotalFab", width: 80, sortable: true },
                    //                        {title: "本次入库重量", field: "fInQty1", width: 80, sortable: true, editor: { type: "numberbox", options: { precision: 1}} },
                    //{ title: "本次入库金额", field: "fInTotal1", width: 80, sortable: true, editor: { type: "numberbox", options: { precision: 1} }, hidden: true },
                        {field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iBscDataManufacturerRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataFabRecNo", hidden: true }
                ]];
                }
                else {
                    columns = [[
                        { field: "iRecNo", width: 80, sortable: true, checkbox: true },
                        { title: "完成否", field: "sTheFinish", width: 40, sortable: true, align: "center" },
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                         { title: "供应商", field: "sCustShortName", width: 100, sortable: true },
                        { title: "订单号", field: "sOrderNo", width: 80 },
                        { title: "坯布编号", field: "" + sCode + "", width: 120 },
                        { title: "坯布名称", field: "" + sName + "", width: 120 },
                    //{ title: "单价", field: "fPrice", width: 80, sortable: true },
                        {title: "总重量", field: "fSumQtyM", width: 60, sortable: true },
                    //{ title: "总金额", field: "fSumTotalM", width: 80, sortable: true },
                        {title: "未入库重量", field: "fNoInQty", width: 60, sortable: true },
                    //{ title: "未入库金额", field: "fNoInTotal", width: 80, sortable: true },
                        {title: "业务员", field: "sSaleOrderUserName", width: 60, sortable: true },
                    //                        { title: "本次入库金额", field: "fInTotal1", width: 80, sortable: true, editor: { type: "numberbox", options: { precision: 1} }, hidden: true },
                        {field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "fPurQty", hidden: true },
                        { field: "iBscDataFabRecNo", hidden: true }
                ]];
                }


                $("#PurOrderM").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 500, 5000],
                    columns: columns,
                    toolbar: (iBillType == "2" ? "#divMenu" : [{
                        iconCls: 'icon-search',
                        text: "查询",
                        handler: function () {
                            search1();
                        }
                    }, '-', {
                        iconCls: 'icon-search',
                        text: "查询已完成",
                        handler: function () {
                            search1(1);
                        }
                    }, '-', {
                        iconCls: 'icon-import',
                        text: "转入",
                        handler: function () {
                            passIn();
                        }
                    }, '-', {
                        iconCls: 'icon-ok',
                        text: "标记完成",
                        handler: function () {
                            doFinish();
                        }
                    }
                    ]),
                    onSelect: function (index, row) {
                        lastSelectedSendMRecNo = row.iRecNo;
                    },
                    loadFilter:pagerFilter
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }

                //search1();
            }
            else {
                $('#tabTop').tabs('close', '未入库采购订单');
            }
        })

        function search1(type) {
            if (iBillType == "1") {
                var sqlObjOrderMD = {
                    TableName: "vwPurOrderMD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "isnull(fNoInQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt: "and"
                    },
                    {
                        Field: "abs(iMatTypeM)",
                        ComOprt: "=",
                        Value: "1"
                    }
                    /*,
                    {
                    Field: "iBscDataCustomerRecNo",
                    ComOprt: "=",
                    Value: iBscDataCustomerRecNo,
                    LinkOprt: "and"
                    },
                    {
                    Field: "dDate1",
                    ComOprt: ">=",
                    Value: "'" + dDate1 + "'",
                    LinkOprt: "and"
                    },
                    {
                    Field: "dDate1",
                    ComOprt: "<=",
                    Value: "'" + dDate2 + "'"
                    }*/
                    ],
                    Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "desc"
                    },
                    {
                        SortName: "sCustShortName",
                        SortOrder: "asc"
                    }
                ]
                };
                if (type == 1) {
                    sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                    sqlObjOrderMD.Filters.push(
                        {
                            Field: "sFinish",
                            ComOprt: "=",
                            Value: "'√'"
                        }
                    )
                }
                else {
                    sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                    sqlObjOrderMD.Filters.push(
                        {
                            Field: "sFinish",
                            ComOprt: "<>",
                            Value: "'√'"
                        }
                    )
                }
            }
            else if (iBillType == "2") {
                var sqlObjOrderMD = {
                    TableName: "vwSDOrderM_GMJ",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    //                    {
                    //                        Field: "isnull(fFabNotInQty,0)",
                    //                        ComOprt: ">",
                    //                        Value: "0",
                    //                        LinkOprt: "and"
                    //                    },
                    {
                    Field: "isnull(sProOrderNo,'')",
                    ComOprt: "<>",
                    Value: "''",
                    LinkOprt: "and"
                },
                //                    {
                //                        Field: "isnull(iFabFinish,0)",
                //                        ComOprt: "<>",
                //                        Value: "1",
                //                        LinkOprt: "and"
                //                    },
                    {
                    Field: "isnull(iStatus,0)",
                    ComOprt: ">",
                    Value: "3"
                    /*,
                    LinkOprt: "and"*/
                }
                /*,
                {
                Field: "iBscDataManufacturerRecNo",
                ComOprt: "=",
                Value: iBscDataCustomerRecNo,
                LinkOprt: "and"
                },
                {
                Field: "dDate1",
                ComOprt: ">=",
                Value: "'" + dDate1 + "'",
                LinkOprt: "and"
                },
                {
                Field: "dDate1",
                ComOprt: "<=",
                Value: "'" + dDate2 + "'"
                }*/
                    ],
                Sorts: [
                    {
                        SortName: "dProDate",
                        SortOrder: "desc"
                    }, {
                        SortName: "ManufacturerName",
                        SortOrder: "desc"
                    }
                ]
            };

            var sOrderNo = $("#__txbSearchOrderNo").textbox("getValue");
            var sOrderCustomer = $("#__txbSearchOrderCustomer").textbox("getValue");
            var sCode = $("#__txbSearchCode").textbox("getValue");
            var sSaleName = $("#__txbSearchSaleName").textbox("getValue");
            if (sOrderNo != null && sOrderNo != undefined && sOrderNo != "") {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "sOrderNo",
                            ComOprt: "like",
                            Value: "'" + sOrderNo + "%'"
                        }
                    )
            }
            if (sOrderCustomer != null && sOrderCustomer != undefined && sOrderCustomer != "") {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "sCustShortName1",
                            ComOprt: "like",
                            Value: "'" + sOrderCustomer + "%'"
                        }
                    )
            }
            if (sCode != null && sCode != undefined && sCode != "") {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "sBscDataFabCode",
                            ComOprt: "like",
                            Value: "'" + sCode + "%'"
                        }
                    )
            }
            if (sSaleName != null && sSaleName != undefined && sSaleName != "") {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "sUserName",
                            ComOprt: "like",
                            Value: "'" + sSaleName + "%'"
                        }
                    )
            }

            if (type == 1) {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "isnull(iFabFinish,0)",
                            ComOprt: "=",
                            Value: "1"
                        }
                    )
            }
            else {
                sqlObjOrderMD.Filters[sqlObjOrderMD.Filters.length - 1].LinkOprt = "and";
                sqlObjOrderMD.Filters.push(
                        {
                            Field: "isnull(iFabFinish,0)",
                            ComOprt: "=",
                            Value: "0"
                        }
                    )
            }
        }

        var resultSendMD = SqlGetData(sqlObjOrderMD);
        $("#PurOrderM").datagrid("loadData", resultSendMD);
        //            var rows = $("#PurOrderM").datagrid("getRows");
        //            for (var i = 0; i < rows.length; i++) {
        //                $("#PurOrderM").datagrid("beginEdit", i);
        //            }
    }

    function passIn() {
        var PurOrderM = $('#PurOrderM').datagrid('getChecked');
        if (PurOrderM.length > 0) {
            var iCustomerRecNo = 0;
            if (iBillType == 1) {
                iCustomerRecNo = PurOrderM[0].iBscDataCustomerRecNo;
                for (var i = 1; i < PurOrderM.length; i++) {
                    if (iCustomerRecNo != PurOrderM[i].iBscDataCustomerRecNo) {
                        alert("一次只能转入同一个供应商的入库记录！");
                        return;
                    }
                }
            }
            else {
                iCustomerRecNo = PurOrderM[0].iBscDataManufacturerRecNo;
                for (var i = 1; i < PurOrderM.length; i++) {
                    if (iCustomerRecNo != PurOrderM[i].iBscDataManufacturerRecNo) {
                        alert("一次只能转入同一个生产厂家的入库记录！");
                        return;
                    }
                }
            }
            Page.setFieldValue("iBscDataCustomerRecNo", iCustomerRecNo);
            //var rows = $("#PurOrderM").datagrid("getRows");
            for (var i = 0; i < PurOrderM.length; i++) {
                var appRow = {};
                appRow.sOrderNo = PurOrderM[i].sOrderNo;
                appRow.fPrice = isNaN(parseFloat(PurOrderM[i].fPrice)) ? 0 : parseFloat(PurOrderM[i].fPrice);
                if (iBillType == "1") {
                    appRow.iSDOrderMRecNo = PurOrderM[i].iSdOrderMRecNo;
                    appRow.iBscDataMatRecNo = PurOrderM[i].iBscDataMatRecNo;
                    appRow.fQty = isNaN(parseFloat(PurOrderM[i].fNoInQty)) ? 0 : parseFloat(PurOrderM[i].fNoInQty);
                    appRow.fTotal = isNaN(parseFloat(PurOrderM[i].fNoInTotal)) ? 0 : parseFloat(PurOrderM[i].fNoInTotal);
                    appRow.fPurQty = isNaN(parseFloat(PurOrderM[i].fPurQty)) ? 0 : parseFloat(PurOrderM[i].fPurQty);
                    appRow.iPurOrderDRecNo = PurOrderM[i].iRecNo;
                    appRow.sCode = PurOrderM[i].sCode;
                    appRow.sName = PurOrderM[i].sName;
                    appRow.sSaleOrderUserName = PurOrderM[i].sSaleOrderUserName;
                }
                else {
                    appRow.iSDOrderMRecNo = PurOrderM[i].iRecNo;
                    appRow.iBscDataMatRecNo = PurOrderM[i].iBscDataFabRecNo;
                    appRow.fQty = isNaN(parseFloat(PurOrderM[i].fFabNotInQty)) ? 0 : parseFloat(PurOrderM[i].fFabNotInQty);
                    //appRow.iSDOrderMRecNo = PurOrderM[i].iMainRecNo;
                    appRow.sCode = PurOrderM[i].sBscDataFabCode;
                    appRow.sName = PurOrderM[i].sBscDataFabName;
                    //appRow.iBscDataMatRecNo = PurOrderM[i].iBscDataFabRecNo;
                }
                Page.tableToolbarClick("add", "MMStockInD", appRow);
                if (iBillType == "1") {
                    $("#tabTop").tabs("select", "采购入库单");
                }
                else if (iBillType == "2") {
                    $("#tabTop").tabs("select", "生产入库单");
                }
            }
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
        var iRed = Page.getFieldValue("iRed");
        if (iRed == "1") {
            var allRows = $("#MMStockInD").datagrid("getRows");
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
                $("#MMStockInD").datagrid("updateRow", { index: i, row: updateRow });
            }
        }
    }

    function doFinish() {
        var iRecNoStr = "";
        var selectRows = $("#PurOrderM").datagrid("getChecked");
        if (selectRows.length > 0) {
            if ($.messager.confirm("确认标识完成吗？", "您确认标识选择的行为完成/未完成吗？", function (r) {
                if (r) {

                    for (var i = 0; i < selectRows.length; i++) {
                        iRecNoStr += selectRows[i].iRecNo + ",";
                    }
                    if (iRecNoStr != "") {
                        iRecNoStr = iRecNoStr.substr(0, iRecNoStr.length - 1);
                    }
                    var jsonobj = {};
                    if (getQueryString("iBillType") == "2") {
                        jsonobj = {
                            StoreProName: "SpSdOrderMFabFinish",
                            StoreParms: [{
                                ParmName: "@iRecNoStr",
                                Value: iRecNoStr
                            }
                            ]
                        }
                    }
                    else {
                        jsonobj = {
                            StoreProName: "SpPurOrderDFabFinish",
                            StoreParms: [{
                                ParmName: "@iRecNoStr",
                                Value: iRecNoStr
                            }
                            ]
                        }
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result != "1") {
                        alert(result);
                    }
                    else {
                        search1();
                    }
                }
            }));

        }
    }

    dataForm.beforeOpen = function () {
        var iRed = Page.getFieldValue("iRed");
        if (iRed != "1") {
            alert("只有红冲才可从采购入库单转入！");
            return false;
        }
    }
    dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
        if (uniqueid == "376") {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var fPurQty = isNaN(Number(row.fPurQty)) ? 0 : Number(row.fPurQty);
                var fQty = isNaN(Number(row.fQty)) ? 0 : Number(row.fQty);
                var fTotal = isNaN(Number(row.fTotal)) ? 0 : Number(row.fTotal);
                row.fPurQty = fPurQty > 0 ? fPurQty * -1 : fPurQty;
                row.fQty = fQty > 0 ? fQty * -1 : fQty;
                row.fTotal = fTotal > 0 ? fTotal * -1 : fTotal;
                return row;
            }
        }
    }

    function pagerFilter(data) {
        if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
            data = {
                total: data.length,
                rows: data
            }
        }
        var dg = $(this);
        var opts = dg.datagrid('options');
        var pager = dg.datagrid('getPager');
        pager.pagination({
            onSelectPage: function (pageNum, pageSize) {
                opts.pageNumber = pageNum;
                opts.pageSize = pageSize;
                pager.pagination('refresh', {
                    pageNumber: pageNum,
                    pageSize: pageSize
                });
                dg.datagrid('loadData', data);
            }
        });
        if (!data.originalRows) {
            data.originalRows = (data.rows);
        }
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        data.rows = (data.originalRows.slice(start, end));
        return data;
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未入库采购订单" data-options="fit:true">
            <table id="PurOrderM">
            </table>
        </div>
        <div title="采购入库单">
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
                                供应商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td id="Td1">
                                会计月份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" Width="150px"
                                    Z_readOnly="True" Z_Required="True" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                            <td style="display: none">
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sYearMonth" />
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
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="入库明细">
                            <table id="MMStockInD" tablename="MMStockInD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divMenu">
        <table>
            <tr>
                <td>
                    订单号
                </td>
                <td>
                    <input id="__txbSearchOrderNo" class="easyui-textbox" style="width:100px;" type="text" />
                </td>
                <td>
                    订单客户
                </td>
                <td>
                    <input id="__txbSearchOrderCustomer" class="easyui-textbox" style="width:100px;" type="text" />
                </td>
                <td>
                    坯布编号
                </td>
                <td>
                    <input id="__txbSearchCode" class="easyui-textbox" style="width:100px;" type="text" />
                </td>
                <td>
                    业务员
                </td>
                <td>
                    <input id="__txbSearchSaleName" class="easyui-textbox" style="width:100px;" type="text" />
                </td>
                <td>
                    <a id="btnSearch" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                        onclick="search1()">查询</a> <a id="btnSearchFinish" href="#" class="easyui-linkbutton"
                            data-options="iconCls:'icon-search'" onclick="search1(1)">查询已完成</a> <a id="btnImport"
                                href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import'" onclick="passIn()">
                                转入</a> <a id="btnFinish" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                                    onclick="doFinish()">标记完成</a>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
