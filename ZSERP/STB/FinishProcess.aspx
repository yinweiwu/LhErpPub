<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var sqlObjCustomers = {
            TableName: "bscDataCustomer",
            Fields: "iRecNo,sCustShortName",
            SelectAll: "True",
            Filters: [
                {
                    Field: "iCustType",
                    ComOprt: "=",
                    Value: "1",
                    LinkOprt: "and"
                },
                {
                    Field: "','+sComtypeCode+','",
                    ComOprt: "like",
                    Value: "'%,加工,%'"
                }
            ]
        }
        var customers = SqlGetData(sqlObjCustomers);
        $(function () {
            var sqlObjSerial = {
                TableName: "bscDataListD",
                Fields: "sCode,sName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID",
                        ComOprt: "=",
                        Value: "'produceSerial'"
                    }
                ]
            };
            var resultSerial = SqlGetData(sqlObjSerial);
            $("#txbMenuProcessSerial").combobox("loadData", resultSerial);

            $("#tabSDContractD").datagrid({
                fit: true,
                border: false,
                columns: [
                    [
                        { field: "__ck", width: 40, checkbox: true },
                        { field: "sOrderNo", title: "生产单号", align: "center", width: 100 },
                        { field: "sCode", title: "产品编号", align: "center", width: 80 },
                        { field: "sName", title: "产品名称", align: "center", width: 80 },
                        { field: "sFlowerCode", title: "花本型号", align: "center", width: 80 },
                        { field: "fProductWidth", title: "幅宽", align: "center", width: 50 },
                        { field: "fProductWeight", title: "克重", align: "center", width: 50 },
                        { field: "fQty", title: "需求米数", align: "center", width: 60 },
                        { field: "sSerialName", title: "工序", align: "center", width: 60 },
                        { field: "fArrangeQty", title: "已排米数", align: "center", width: 80 },
                        { field: "fNotArrangeQty", title: "未排米数", align: "center", width: 80 },
                        { field: "sArrangeFinish", title: "安排完成", align: "center", width: 60 },
                        { field: "fCanUseStockQty", title: "可用库存", align: "center", width: 80 },
                        {
                            field: "fUseStockQty", title: "使用库存", align: "center", width: 80,
                            editor: { type: "numberbox", options: { width: 80, height: 35, precision: 2 } }
                        },
                        {
                            field: "fProcessQty", title: "加工米数", align: "center", width: 80,
                            editor: { type: "numberbox", options: { width: 80, height: 35, precision: 2 } }
                        },
                        {
                            field: "iSupplierRecNo", title: "加工商", align: "center", width: 80,
                            editor: { type: "combobox", options: { valueField: "iRecNo", textField: "sCustShortName", width: 80, height: 35, data: customers } }
                        },
                        {
                            field: "fProcessPrice", title: "加工单价", align: "center", width: 80,
                            editor: { type: "numberbox", options: { width: 80, height: 35, precision: 2 } }
                        },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "sColorID", hidden: true },
                        { field: "sColorName", hidden: true },
                        //{ field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iRecNo", hidden: true },
                        { field: "iRecNoD", hidden: true },
                        { field: "sSerial", hidden: true }
                    ]
                ],
                toolbar: "#divOrderMenu",
                rownumbers: true,
                pagination: true,
                pageSize: 50,
                pageList: [50, 100, 200, 500],
                remoteSort: true,
                loadFilter: pagerFilter
            });

            $("#divAllSerial").datalist({
                title: "所有工序",
                width: 150,
                height: 140,
                checkbox: true,
                valueField: "sSerial",
                textField: "sSerialName",
                singleSelect: false,
                textFormatter: function (value, row, index) {
                    return row.sSerialName;
                }
            });
            $("#divSelectedSerial").datalist({
                title: "所选工序",
                width: 150,
                height: 140,
                checkbox: true,
                valueField: "sSerial",
                textField: "sSerialName",
                singleSelect: false,
                textFormatter: function (value, row, index) {
                    return row.sSerialName;
                },
                toolbar: [
                    {
                        iconCls: 'icon-preview',
                        text: "上移",
                        handler: function () {
                            MoveUp();
                        }
                    }, '-', {
                        iconCls: 'icon-next',
                        text: "下移",
                        handler: function () {
                            MoveDown();
                        }
                    }]
            });

            if (Page.usetype != "add") {
                $("#divTab").tabs("select", 1);

                //获取所有外加工工序
                var sqlObjAllSerial = {
                    TableName: "bscDataListD",
                    Fields: "sCode as sSerial,sName as sSerialName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sClassID",
                            ComOprt: "=",
                            Value: "'produceSerial'"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "sCode",
                            SortOrder:"asc"
                        }
                    ]
                }
                var resultAllSerial = SqlGetData(sqlObjAllSerial);
                //$("#divAllSerial").datalist("loadData", resultAllSerial);
                //获取已选择的外加工工序
                var sqlObjSelectedSerial = {
                    TableName: "vwProProcessDSerialD",
                    Fields: "distinct sSerial,sSerialName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "in",
                            Value: "(select iRecNo from ProProcessD where iMainRecNo='" + Page.key + "')"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "sSerial",
                            SortOrder: "asc"
                        }
                    ]
                }
                var resultSelectedSerial = SqlGetData(sqlObjSelectedSerial);
                $.each(resultSelectedSerial, function (index,o) {
                    $.each(resultAllSerial, function (index1, o1) {
                        if (o.sSerial == o1.sSerial) {
                            resultAllSerial.splice(index1, 1);
                            return false;
                        }
                    })
                })
                $("#divAllSerial").datalist("loadData", resultAllSerial);
                $("#divSelectedSerial").datalist("loadData", resultSelectedSerial);
            }
            $("#txbMenuProcessSerial").combobox("textbox").css("background-color", "#fff3f3");
        });
        function loadContractMD() {
            var filters = [
                {
                    Field: "iStatus",
                    ComOprt: "=",
                    Value: "4",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(dReceiveDate,'2299-12-31')",
                    ComOprt: "<>",
                    Value: "'2299-12-31'",
                    LinkOprt: "and"
                },
                {
                    Field: "iOrderType",
                    ComOprt: "=",
                    Value: "2"
                }
            ];
            var sSerialArr = $("#txbMenuProcessSerial").combobox("getValues");

            if (sSerialArr.length == 0) {
                Page.MessageShow("请先选择加工工序", "请先选择加工工序");
                return;
            }
            var sSerial = sSerialArr.join(",");
            filters[filters.length - 1].LinkOprt = "and";
            filters.push(
                {
                    Field: "sSerial",
                    ComOprt: "in",
                    Value: "(" + sSerial + ")"
                }
                );
            var sOrderNo = $("#txbMenuOrderNo").textbox("getValue");
            if (sOrderNo != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                {
                    Field: "sOrderNo",
                    ComOprt: "like",
                    Value: "'%" + sOrderNo + "%'"
                }
                );
            }

            var sCode = $("#txbMenuCode").textbox("getValue");
            if (sCode != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                {
                    Field: "sCode",
                    ComOprt: "like",
                    Value: "'%" + sCode + "%'"
                }
                );
            }
            var sFlowerCode = $("#txbMenuFlowerCode").textbox("getValue");
            if (sOrderNo != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                {
                    Field: "sFlowerCode",
                    ComOprt: "like",
                    Value: "'%" + sFlowerCode + "%'"
                }
                );
            }

            var isChecked = $("#ckbFinish")[0].checked;
            if (isChecked == false) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                {
                    Field: "isnull(iArrangeFinish,0)",
                    ComOprt: "=",
                    Value: "0"
                }
                );
            }
            var sqlObj = {
                TableName: "vwSDContractMDProcessSerialD",
                Fields: "*",
                SelectAll: "True",
                Filters: filters,
                Sorts: [
                    {
                        SortName: "sSerial",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "dReceiveDate",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabSDContractD").datagrid("loadData", result);
            var allRows = $("#tabSDContractD").datagrid("getRows");
            $.each(allRows, function (index, o) {
                $("#tabSDContractD").datagrid("beginEdit", index);
            })
        }
        function buildProcess() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                var sSeralSelect = [];
                $.each(checkedRows, function (index, o) {
                    var theRowIndex = $("#tabSDContractD").datagrid("getRowIndex", o);
                    $("#tabSDContractD").datagrid("endEdit", theRowIndex);
                    var isIn=false;
                    $.each(sSeralSelect, function (index1,o1) {
                        if (o1.sSerial == o.sSerial) {
                            isIn = true;
                            return false;
                        }
                    })
                    if (isIn == false) {
                        sSeralSelect.push({ sSerial: o.sSerial, sSerialName: o.sSerialName });
                    }
                })

                
                $("#table1").datagrid("loadData", []);
                var iBscDataCustomerRecNo = checkedRows[0].iSupplierRecNo;
                var isCustomerSame = true;

                var appendRows = [];

                $.each(checkedRows, function (index, o) {
                    if (o.iSupplierRecNo != iBscDataCustomerRecNo) {
                        isCustomerSame = false;
                    }
                });
                if (isCustomerSame == false) {
                    Page.MessageShow("只能转入同一加工商的明细", "只能转入同一加工商的明细，已自动转成第一个的加工商");
                    iBscDataCustomerRecNo = checkedRows[0].iSupplierRecNo;
                }

                var sBscDataMatRecNo = "";
                var appendRows = [];
                $.each(checkedRows, function (index, o) {
                    sBscDataMatRecNo += o.iBscDataMatRecNo + ",";
                    var isFound = false;

                    $.each(appendRows, function (index1, o1) {
                        if (o.iBscDataMatRecNo == o1.iBscDataMatRecNo && o.iRecNoD == o1.iSDContractDRecNo) {
                            isFound = true;
                            //o1.fQty = (isNaN(Number(o1.fQty)) ? 0 : Number(o1.fQty)) + ((isNaN(Number(o.fProcessQty)) ? 0 : Number(o.fProcessQty)) == 0 ? o.fNotArrangeQty : Number(o.fProcessQty));
                            //o1.fTotal = (isNaN(Number(o1.fTotal)) ? 0 : Number(o1.fTotal)) + ((isNaN(Number(o.fProcessQty)) ? 0 : Number(o.fProcessQty)) == 0 ? o.fNotArrangeQty : Number(o.fProcessQty)) * (isNaN(Number(o.fProcessPrice)) ? 0 : Number(o.fProcessPrice));
                            return false;
                        }
                    })
                    if (isFound == false) {
                        appendRows.push({
                            iSDContractDRecNo: o.iRecNoD,
                            iBscDataMatRecNo: o.iBscDataMatRecNo,
                            iBscDataColorRecNo: o.iBscDataColorRecNo,
                            sCode: o.sCode,
                            sName: o.sName,
                            sColorID: o.sColorID,
                            sColorName: o.sColorName,
                            sFlowerCode: o.sFlowerCode,
                            fProductWidth: o.fProductWidth,
                            fProductWeight: o.fProductWeight,
                            fQty: ((isNaN(Number(o.fProcessQty)) ? 0 : Number(o.fProcessQty)) == 0 ? o.fNotArrangeQty : Number(o.fProcessQty)),
                            fPrice: o.fProcessPrice,
                            fTotal: Number(o.fProcessQty) * Number(o.fProcessPrice)
                        })
                    }
                    //Page.tableToolbarClick("add", "table1", appendRow);
                });
                $.each(appendRows, function (index, o) {
                    Page.tableToolbarClick("add", "table1", o);
                })
                Page.setFieldValue("iBscDataCustomerRecNo", iBscDataCustomerRecNo);
                if (sBscDataMatRecNo != "") {
                    sBscDataMatRecNo = sBscDataMatRecNo.substr(0, sBscDataMatRecNo.length - 1);
                }
                $("#divTab").tabs("select", 1);
                $("#divSelectedSerial").datalist("loadData", sSeralSelect);
                $.each(checkedRows, function (index, o) {
                    var theRowIndex = $("#tabSDContractD").datagrid("getRowIndex", o);
                    $("#tabSDContractD").datagrid("beginEdit", theRowIndex);
                })
                $("#divAllSerial").datalist("loadData", []);
                var sqlObjSerial = {
                    TableName: "bscDataListD",
                    Fields: "sCode as sSerial,sName as sSerialName",
                    SelectAll: "True",
                    Filters: [{
                        Field: "sClassID",
                        ComOprt: "=",
                        Value: "'produceSerial'"
                    }],
                    Sorts: [
                        {
                            SortName: "sCode",
                            SortOrder: "asc"
                        }
                    ]
                }
                var resultSerial = SqlGetData(sqlObjSerial);
                var selectedSerial = $("#divSelectedSerial").datalist("getRows");
                $.each(selectedSerial, function (index, o) {
                    $.each(resultSerial, function (index1, o1) {
                        if (o.sSerial == o1.sSerial) {
                            resultSerial.splice(index1, 1);
                            return false;
                        }
                    })
                })
                $("#divAllSerial").datalist("loadData", resultSerial);
            }
            else {
                Page.MessageShow("请选择行", "请选择行");
            }
        }

        function pushSerial() {
            var checkedRows = $("#divAllSerial").datalist("getChecked");
            if (checkedRows.length > 0) {
                var selectedSerial = $("#divSelectedSerial").datalist("getRows");
                var repeatSerialName = "";
                $.each(checkedRows, function (index, o) {
                    var hasReport = false;
                    $.each(selectedSerial, function (index1, o1) {
                        if (o.sSerial == o1.sSerial) {
                            repeatSerialName += o1.sSerialName + ",";
                            hasReport = true;
                            return false;
                        }
                    })
                    if (hasReport == false) {
                        $("#divSelectedSerial").datalist("appendRow", o);
                        var rowIndex = $("#divAllSerial").datalist("getRowIndex", o);
                        $("#divAllSerial").datalist("deleteRow", rowIndex);
                    }
                })
                if (repeatSerialName != "") {
                    Page.MessageShow("有重复", repeatSerialName + "已存在");
                }
            }
            else {
                Page.MessageShow("请选择要移入的工序", "请选择要移入的工序");
            }
        }
        function popSerial() {
            var checkedRows = $("#divSelectedSerial").datalist("getChecked");
            if (checkedRows.length > 0) {
                var allSerial = $("#divAllSerial").datalist("getRows");
                var repeatSerialName = "";
                $.each(checkedRows, function (index, o) {
                    var hasReport = false;
                    $.each(allSerial, function (index1, o1) {
                        if (o.sSerial == o1.sSerial) {
                            repeatSerialName += o1.sSerialName + ",";
                            hasReport = true;
                            return false;
                        }
                    })
                    if (hasReport == false) {
                        $("#divAllSerial").datalist("appendRow", o);
                        var rowIndex = $("#divSelectedSerial").datalist("getRowIndex", o);
                        $("#divSelectedSerial").datalist("deleteRow", rowIndex);
                    }
                })
            }
            else {
                Page.MessageShow("请选择要移出的工序", "请选择要移出的工序");
            }
        }

        Page.beforeSave = function () {
            var selectedSerial = $("#divSelectedSerial").datalist("getRows");
            if (selectedSerial.length == 0) {
                Page.MessageShow("请选择外加工序", "请选择外加工工序");
                return;
            }
            var sSerial = "";
            $.each(selectedSerial, function (index, o) {
                sSerial += o.sSerial + ",";
            });
            sSerial = sSerial.substr(0, sSerial.length - 1);
            Page.setFieldValue("sSerial", sSerial);
        }

        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpProcessDSerialDBuildAfterSave",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                Page.MessageShow("生成加工工序时发生错误", result);
                Page.DoNotCloseWinWhenSave = true;
            }
        }
        
        function ComboboxShowCheckBox(row) {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField];
            }
            else {
                return row[opts.textField];
            }
        }

        function ComboboxSelect(row) {
            //console.log(row);
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                var el = opts.finder.getEl(this, row[opts.valueField]);
                el.find('input.combobox-checkbox')._propAttr('checked', true);
            }
        }
        function ComboboxUnselect(row) {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                var el = opts.finder.getEl(this, row[opts.valueField]);
                el.find('input.combobox-checkbox')._propAttr('checked', false);
            }
        }
        //上移
        function MoveUp() {
            var rows = $("#divSelectedSerial").datalist('getChecked');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#divSelectedSerial").datalist('getRowIndex', rows[i]);
                //$("#divSelectedSerial").datalist("endEdit", index);
                mysort(index, 'up', 'divSelectedSerial');
            }
        }
        //下移
        function MoveDown() {
            var rows = $("#divSelectedSerial").datalist('getChecked');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#divSelectedSerial").datalist('getRowIndex', rows[i]);
                //$("#dg").datagrid("endEdit", index);
                mysort(index, 'down', 'divSelectedSerial');
            }
        }
        function mysort(index, type, gridname) {
            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datalist('getData').rows[index];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    var todown = $('#' + gridname).datalist('getData').rows[index - 1];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    $('#' + gridname).datalist('getData').rows[index] = todown;
                    $('#' + gridname).datalist('getData').rows[index - 1] = toup;
                    $('#' + gridname).datalist('refreshRow', index);
                    $('#' + gridname).datalist('refreshRow', index - 1);
                    $('#' + gridname).datalist('checkRow', index - 1);
                    $('#' + gridname).datalist('uncheckRow', index);
                }
            }
            else if ("down" == type) {
                var rows = $('#' + gridname).datalist('getRows').length;
                if (index != rows - 1) {
                    var todown = $('#' + gridname).datalist('getData').rows[index];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    var toup = $('#' + gridname).datalist('getData').rows[index + 1];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    $('#' + gridname).datalist('getData').rows[index + 1] = todown;
                    $('#' + gridname).datalist('getData').rows[index] = toup;
                    $('#' + gridname).datalist('refreshRow', index);
                    $('#' + gridname).datalist('refreshRow', index + 1);
                    $('#' + gridname).datalist('checkRow', index + 1);
                    $('#' + gridname).datalist('uncheckRow', index);
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
    <style type="text/css">
        .ul {
            margin: 0px;
            padding: 0px;
            list-style: none;
        }

            .ul li {
            }

                .ul li a {
                    text-decoration: none;
                    font-size: 18px;
                }

        .datalist .datagrid-row {
            height: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="生产单明细" data-options="border:false">
            <table id="tabSDContractD"></table>
        </div>
        <div title="后整加工单" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden; height: 170px;">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sSerial" />
                    </div>
                    <table>
                        <tr>
                            <td>
                                <table class="tabmain">
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>加工单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                                        </td>
                                        <td>日期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                                        </td>
                                        <td>加工厂家
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>米数
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                                        </td>
                                        <td>金额
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fTotal" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                                        </td>
                                        <td>备注
                                        </td>
                                        <td>
                                            <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Style="width: 99%" Z_FieldID="sRemark" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>制单人
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                                        </td>
                                        <td>制单日期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" Z_readOnly="true" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <div id="divAllSerial"></div>
                                        </td>
                                        <td style="vertical-align:top;">
                                            <ul id="ul" class="ul">
                                                <li><a href="#" onclick="pushSerial()">></a></li>
                                                <li><a href="#" onclick="popSerial()"><</a></li>
                                            </ul>
                                        </td>
                                        <td>
                                            <div id="divSelectedSerial"></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="加工单明细">
                            <!--子表1  -->
                            <table id="table1" tablename="ProProcessD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divOrderMenu" style="display: none;">
        <table>
            <tr>
                <td>加工工序
                </td>
                <td>
                    <input id="txbMenuProcessSerial" class="easyui-combobox" data-options="multiple:true,
                        valueField:'sCode',
                        textField:'sName',formatter:ComboboxShowCheckBox,onSelect:ComboboxSelect,onUnselect:ComboboxUnselect"
                        style="width: 150px;" type="text" />
                </td>
                <td>生产单号
                </td>
                <td>
                    <input id="txbMenuOrderNo" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>产品编号
                </td>
                <td>
                    <input id="txbMenuCode" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>花本型号
                </td>
                <td>
                    <input id="txbMenuFlowerCode" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>
                    <input type="checkbox" id="ckbFinish" />
                    <label for="ckbFinish">包含已完成</label>
                </td>
                <td style="padding-left: 10px;">
                    <a class="button orange" data-options="iconCls:'icon-search'" href="#" onclick="loadContractMD()">查询</a>
                </td>
                <td style="padding-left: 10px;">
                    <a class="button orange" href="#" onclick="buildProcess()">生成</a>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

