<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            if (getQueryString("openFrom") == "notice") {
                var sqlObjSaleType = {
                    TableName: "bscDataListD",
                    Fields: "sCode,sName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sClassID",
                            ComOprt: "=",
                            Value: "'iSaleType'"
                        }
                    ]
                };
                var resultSaleType = SqlGetData(sqlObjSaleType);
                $("#txbMenuSaleType").combobox("loadData", resultSaleType);
                $("#txbMenuSaleType").combobox("setValue", "1");

                $("#tabSDContractD").datagrid({
                    fit: true,
                    border: false,
                    columns: [
                        [
                            { field: "__ck", width: 40, checkbox: true },
                            { field: "sOrderNo", title: "订单号", align: "center", width: 100 },
                            { field: "sCustShortName", title: "客户", align: "center", width: 100 },
                            { field: "sCode", title: "产品编号", align: "center", width: 80 },
                            { field: "sFlowerCode", title: "花本型号", align: "center", width: 80 },
                            { field: "fProductWidth", title: "幅宽", align: "center", width: 50 },
                            { field: "fProductWeight", title: "克重", align: "center", width: 50 },
                            { field: "sColour", title: "整经色号", align: "center", width: 50 },
                            { field: "sIden", title: "标识", align: "center", width: 50 },
                            { field: "fQty", title: "订单数", align: "center", width: 60 },
                            { field: "sProductDate", title: "交期", align: "center", width: 80 },
                            { field: "iBscDataMatRecNo", hidden: true },
                            { field: "iBscDataColorRecNo", hidden: true },
                            { field: "iBscDataCustomerRecNo", hidden: true },
                            { field: "iRecNo", hidden: true }
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

                if (Page.usetype != "add") {
                    $("#divTab").tabs("select", 1);
                }
                Page.Children.toolBarBtnDisabled("SDContractD", "add");
                //Page.Children.toolBarBtnDisabled("SDContractD", "delete");
                Page.Children.toolBarBtnDisabled("SDContractD", "copy");
            }
            else {
                Page.DoNotCloseWinWhenSave = true;
                $("#divTab").tabs("close", 0);
                Page.setFieldDisabled("sOrderNo");
                Page.setFieldDisabled("dDate");
                Page.setFieldDisabled("iBscDataCustomerRecNo");
                Page.setFieldDisabled("sTransTypeID");
                Page.setFieldDisabled("fQty");
                Page.setFieldDisabled("sRemark");
                $("#divOrderMenu").hide();
                $("#tdBuild").show();
                Page.Children.toolBarBtnDisabled("SDContractD", "add");
                Page.Children.toolBarBtnDisabled("SDContractD", "delete");
                Page.Children.toolBarBtnDisabled("SDContractD", "copy");


                $("#tabYarnUseSummary").datagrid({
                    fit: true,
                    border: false,
                    title: "纱量总需求量",
                    columns: [
                        [
                            { field: "sYarnCode", title: "纱线编号", width: 80, algin: "center", sortable: true },
                            { field: "sYarnName", title: "纱线名称", width: 80, algin: "center", sortable: true },
                            { field: "sTypeName", title: "类型", width: 60, algin: "center", sortable: true },
                            { field: "sYarnElements", title: "规格型号", width: 80, algin: "center", sortable: true },
                            { field: "fNeedQty", title: "需求量", width: 80, algin: "center", sortable: true }
                        ]
                    ],
                    rownumbers: true,
                    remoteSort: false
                })
                $("#tabYarnUseDetail").datagrid({
                    fit: true,
                    border: false,
                    title: "明细纱线需求量",
                    columns: [
                        [
                            { field: "iSerial", title: "明细序号", width: 60, algin: "center", sortable: true },
                            { field: "sCode", title: "产品编号", width: 80, algin: "center", sortable: true },
                            { field: "sName", title: "产品名称", width: 80, algin: "center", sortable: true },
                            { field: "sFlowerCode", title: "花本型号", width: 80, algin: "center", sortable: true },
                            //{ field: "sYarnCode", title: "纱线编号", width: 80, algin: "center", sortable: true },
                            { field: "sYarnName", title: "纱线名称", width: 80, algin: "center", sortable: true },
                            { field: "sYarnElements", title: "规格型号", width: 80, algin: "center", sortable: true },
                            { field: "sTypeName", title: "类型", width: 80, algin: "center", sortable: true },
                            {
                                field: "fNeedQty", title: "需求量", width: 80, algin: "center", sortable: true,
                                editor: { type: "numberbox", options: { precision: 1 } }
                            },
                            { field: "iRecNo",hidden:true  }
                        ]
                    ],
                    rownumbers: true,
                    remoteSort: false,
                    toolbar: [
                        {
                            iconCls: 'icon-edit',
                            text:"修改",
                            handler: function () {
                                var allYarnUseRows = $("#tabYarnUseDetail").datagrid("getRows");
                                $.each(allYarnUseRows, function (index, o) {
                                    $("#tabYarnUseDetail").datagrid("beginEdit", index);
                                })
                            }
                        }, {
                            iconCls: 'icon-ok',
                            text: "确定",
                            handler: function () {
                                var allYarnUseRows = $("#tabYarnUseDetail").datagrid("getRows");
                                $.each(allYarnUseRows, function (index, o) {
                                    $("#tabYarnUseDetail").datagrid("endEdit", index);
                                })
                                var allYarnUseRows = $("#tabYarnUseDetail").datagrid("getRows");
                                var Str = "";
                                for (var i = 0; i < allYarnUseRows.length; i++) {
                                    Str += allYarnUseRows[i].iRecNo + "`" + allYarnUseRows[i].fNeedQty + ",";
                                }
                                if (Str != "") {
                                    Str = Str.substr(0, Str.length - 1);
                                }
                                var jsonobj = {
                                    StoreProName: "SpSDContractDMatWasteDChange",
                                    StoreParms: [{
                                        ParmName: "@iRecNo",
                                        Value: Page.key
                                    }, {
                                        ParmName: "@sStr",
                                        Value: Str
                                    }
                                    ]
                                }
                                var result = SqlStoreProce(jsonobj);
                                if (result != "1") {
                                    Page.MessageShow("错误",result);
                                }
                                else {
                                    
                                }
                            }
                        }
                    ]
                })


                var options = $("#SDContractD").datagrid("options");
                delete options.url;
                var columns = options.columns;
                columns[0].splice(10, 0,
                    {
                        field: "_wjggx", title: "外加工<br />工序设置", align: "center", width: 60, rowspan: 2,
                        formatter: function (value, row, index) {
                            if (row.__isFoot != true) {
                                return "<a href='#' onclick=showSerail(" + index + ")>设置</a>";
                            }
                        }
                    });
                $("#SDContractD").datagrid(options);
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
                }
                var resultSerial = SqlGetData(sqlObjSerial);

                $("#tabSerial").datagrid({
                    fit: true,
                    border: false,
                    columns: [
                        [
                            { field: "__cb", checkbox: true, width: 40, align: "center" },
                            {
                                field: "iSerial", title: "序号", width: 40, align: "center",
                                editor: { type: "numberbox", options: { height: 35 } }
                            },
                            {
                                field: "sSerial", title: "工序", width: 80, align: "center",
                                editor: {
                                    type: "combobox",
                                    options: { valueField: "sCode", textField: "sName", height: 35, data: resultSerial }
                                }
                            },
                            {
                                field: "fQty", title: "加工数量", width: 80, align: "center",
                                editor: {
                                    type: "numberbox",
                                    options: { precision: 2, height: 35 }
                                }
                            },
                            {
                                field: "iRecNo", hidden: true
                            }
                        ]
                    ],
                    remoteSort: false,
                    toolbar: [{
                        iconCls: 'icon-add',
                        text: "增加",
                        handler: function () {
                            var iRecNo = Page.getChildID("SDContractDProcessSerialD");
                            var iSerial = $("#tabSerial").datagrid("getRows").length + 1;
                            var appendRow = { iRecNo: iRecNo, iSerial: iSerial };
                            $("#tabSerial").datagrid("appendRow", appendRow);
                            var allRow = $("#tabSerial").datagrid("getRows");
                            $("#tabSerial").datagrid("beginEdit", allRow.length - 1);
                        }
                    }, '-', {
                        iconCls: 'icon-remove',
                        text: "删除",
                        handler: function () {
                            var checkedRow = $("#tabSerial").datagrid("getChecked");
                            if (checkedRow) {
                                $.messager.confirm("确认删除吗？", "您确认删除所选择工序吗？", function (r) {
                                    if (r) {
                                        for (var i = 0; i < checkedRow.length; i++) {
                                            var rowindex = $("#tabSerial").datagrid("getRowIndex", checkedRow[i]);
                                            $("#tabSerial").datagrid("deleteRow", rowindex);
                                        }
                                    }
                                })

                            }
                        }
                    }]
                })
            }

            if (Page.usetype == "modify") {
                var sqlObj = {
                    TableName: "vwSDContractD",
                    Fields: "top 1 sIden",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.key + "'"
                    }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    Page.setFieldValue("sIden", result[0].sIden);
                }
            }
        });
        function loadContractMD(isSummary) {
            var dataFrom = $("#txbMenuDateFrom").datebox("getValue");
            var dataTo = $("#txbMenuDateTo").datebox("getValue");
            var SaleType = $("#txbMenuSaleType").combobox("getValue");
            var Customer = $("#txbMenuCustomer").textbox("getValue");
            var Filters = [
                {
                    Field: "iStatus",
                    ComOprt: "=",
                    Value: "4",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iNotice,0)",
                    ComOprt: "=",
                    Value: "0",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iStockEnough,0)",
                    ComOprt: "=",
                    Value: "0",
                    LinkOprt: "and"
                },
                {
                    LeftParenthese: "(",
                    Field: "isnull(iSupplierRecNo,0)",
                    ComOprt: "=",
                    Value: "0",
                    LinkOprt: "or"
                },
                {
                    Field: "isnull(iInner,0)",
                    ComOprt: "=",
                    Value: "1",
                    RightParenthese: ")"
                }
            ]
            if (dataFrom != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sDate",
                    ComOprt: ">=",
                    Value: "'" + dataFrom + "'"
                })
            }
            if (dataTo != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sDate",
                    ComOprt: "<=",
                    Value: "'" + dataTo + "'"
                })
            }
            if (SaleType != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "isnull(iOrderType,0)",
                    ComOprt: "=",
                    Value: "'" + SaleType + "'"
                })
            }
            if (Customer != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sCustShortName",
                    ComOprt: "like",
                    Value: "'%" + Customer + "%'"
                })
            }
            var result;
            if (isSummary != true) {
                var sqlObj = {
                    TableName: "vwSDContractMD",
                    Fields: "iRecNo,iRecNoM,iBscDataCustomerRecNo,iBscDataMatRecNo,iBscDataColorRecNo,sCode,sName,sFlowerCode,sProductDate,sCustShortName,sOrderNo,fProductWidth,fProductWeight,fQty,sIden",
                    SelectAll: "True",
                    Filters: Filters,
                    Sorts: [
                        {
                            SortName: "sCode",
                            SortOrder: "asc"
                        },
                        {
                            SortName: "sProductDate",
                            SortOrder: "asc"
                        }
                    ]
                }
                result = SqlGetData(sqlObj);
            }
            else {
                //Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: " group by ",
                    ComOprt: "",
                    Value: "sCode,sName,sFlowerCode,fProductWidth,fProductWeight"
                })

                var sqlObj = {
                    TableName: "vwSDContractMD",
                    Fields: "sCode,sName,sFlowerCode,fProductWidth,fProductWeight,sum(fQty) as fQty",
                    SelectAll: "True",
                    Filters: Filters
                }
                result = SqlGetData(sqlObj);
            }
            $("#tabSDContractD").datagrid("loadData", result);
        }
        function buildNotice() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                if (checkedRows[0].iRecNo) {
                    $("#SDContractD").datagrid("loadData", []);
                    var iBscDataCustomerRecNo = checkedRows[0].iBscDataCustomerRecNo;
                    var sIden = checkedRows[0].sIden;
                    var isCustomerSame = true;
                    var isIdenSame = true;
                    var appendRows = [];
                    //var sRecNoStr = "";
                    $.each(checkedRows, function (index, o) {
                        if (o.sIden != sIden) {
                            isIdenSame = false;
                        }
                        if (o.iBscDataCustomerRecNo != iBscDataCustomerRecNo) {
                            isCustomerSame = false;
                        }

                        var isExists = false
                        $.each(appendRows, function (index1, o1) {
                            if (o1.iBscDataMatRecNo == o.iBscDataMatRecNo && o1.iBscDataColorRecNo == o.iBscDataColorRecNo && o1.fProductWidth == o.fProductWidth && o1.fProductWeight == o.fProductWeight) {
                                isExists = true;
                                o1.fQty += isNaN(Number(o.fQty)) ? 0 : Number(o.fQty);
                                o1.sSDContractDRecNoStr += "," + o.iRecNo;
                                return false;
                            }
                        })
                        if (isExists == false) {
                            var appendRow = {
                                iBscDataMatRecNo: o.iBscDataMatRecNo,
                                iBscDataColorRecNo: o.iBscDataColorRecNo,
                                sCode: o.sCode,
                                sFlowerCode: o.sFlowerCode,
                                fProductWidth: o.fProductWidth,
                                fProductWeight: o.fProductWeight,
                                fQty: o.fQty,
                                sIden: o.sIden,
                                sSDContractDRecNoStr: o.iRecNo
                            };
                            appendRows.push(appendRow);
                        }
                    });

                    if (isIdenSame == false) {
                        Page.MessageShow("只能转入同一标识的明细", "只能转入同一标识的明细");
                        return false;
                    }
                    $.each(appendRows, function (index, o) {
                        Page.tableToolbarClick("add", "SDContractD", o);
                        var allRows = $("#SDContractD").datagrid("getRows");
                        var lastRecNo = allRows[allRows.length - 1].iRecNo;
                        var jsonobj = {
                            StoreProName: "SpSDContractDContractDBuild",
                            StoreParms: [{
                                ParmName: "@iRecNo",
                                Value: lastRecNo
                            }, {
                                ParmName: "@sSDContractDStr",
                                Value: o.sSDContractDRecNoStr
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                    })
                    Page.setFieldValue("sIden", sIden);
                    if (isCustomerSame) {
                        Page.setFieldValue("iBscDataCustomerRecNo", iBscDataCustomerRecNo);
                    }
                    else {
                        var sqlObjCustomer = {
                            TableName: "bscDataCustomer",
                            Fields: " top 1 iRecNo",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "isnull(iInner,0)",
                                    ComOprt: "=",
                                    Value: "1",
                                    LinkOprt: "and"
                                },
                                {
                                    Field: "iCustType",
                                    ComOprt: "=",
                                    Value: "0"
                                }
                            ]
                        }
                        var resultCustomer = SqlGetData(sqlObjCustomer);
                        if (resultCustomer.length > 0) {
                            Page.setFieldValue("iBscDataCustomerRecNo", resultCustomer[0].iRecNo);
                        }
                    }
                    Page.setFieldValue("sTransTypeID", $("#txbMenuSaleType").combobox("getValue"));
                    $("#divTab").tabs("select", 1);
                }
                else {
                    Page.MessageShow("汇总查询不可转入", "汇总查询不可转入");
                }
            }
            else {
                Page.MessageShow("请选择行", "请选择行");
            }
        }

        dataForm.beforeSetValue = function (uniqueid, data) {
            if (uniqueid == "378") {
                var allRows = $("#SDContractD").datagrid("getRows");
                for (var i = 0; i < data.length; i++) {
                    for (var j = 0; j < allRows.length; j++) {
                        if (data[i].iRecNo == allRows[j].iBscDataMatRecNo) {
                            alert("不可转入重复的产品:[" + allRows[j].sCode + "]");
                            return false;
                        }
                    }
                }
            }
        }
        var isSaved = false;

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "SDContractD") {
                if (changes.fWarpingPlanQty || changes.fWarpingPlanQty == 0 || changes.fWeavingPlanQty || changes.fWeavingPlanQty == 0) {
                    isSaved = false;
                }
            }
        }


        Page.afterSave = function () {
            isSaved = true;
            if (getQueryString("openFrom") == "notice") {
                var jsonobj = {
                    StoreProName: "SpSDContractMBuildSerialD",
                    StoreParms: [{
                        ParmName: "@iRecNo",
                        Value: Page.key
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }

        function calcYarn() {
            if (isSaved == false) {
                Page.MessageShow("请先保存后再核算", "请先保存后再核算");
                return;
            }

            var jsonobj = {
                StoreProName: "SpSContractMCalcYarnUse",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                Page.MessageShow("错误", result);
            } else {
                Page.MessageShow("核算成功", "核算成功");
                showYarnUse();
            }
        }

        function showYarnUse() {
            var sqlObjDetail = {
                TableName: "vwSDContractDMatWasteD",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iRecNoM",
                    ComOprt: "=",
                    Value: "'" + Page.key + "'"
                }],
                Sorts: [
                    {
                        SortName: "iSerial",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sYarnCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var resultD = SqlGetData(sqlObjDetail);
            $("#tabYarnUseDetail").datagrid("loadData", resultD);
            
            var sqlObjSummary = {
                TableName: "vwSDContractDMatWasteD",
                Fields: "sYarnCode,sYarnName,sYarnElements,sum(fNeedQty) as fNeedQty ",
                SelectAll: "True",
                Filters: [{
                    Field: "iRecNoM",
                    ComOprt: "=",
                    Value: "'" + Page.key + "'"
                },
                {
                    Field: "group by ",
                    ComOprt: "",
                    Value: "sYarnCode,sYarnName,sYarnElements,sTypeName"
                }
                ],
                Sorts: [
                    {
                        SortName: "sYarnCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var resultS = SqlGetData(sqlObjSummary);
            $("#tabYarnUseSummary").datagrid("loadData", resultS);
            $("#divYarnUse").window("open");
        }

        var selectIndex = undefined;
        function showSerail(index) {
            selectIndex = index;
            var allRows = $("#SDContractD").datagrid("getRows");
            var iRecNo = allRows[index].iRecNo;
            var sqlObj = {
                TableName: "SDContractDProcessSerialD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + iRecNo + "'"
                    }
                ],
                Sorts: [
                    {
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabSerial").datagrid("loadData", result);
            for (var i = 0; i < result.length; i++) {
                $("#tabSerial").datagrid("beginEdit", i);
            }
            $("#divSerial").dialog("open");
        }
        function confirmSerial() {
            var allRow = $("#tabSerial").datagrid("getRows");
            for (var i = 0; i < allRow.length; i++) {
                $("#tabSerial").datagrid("endEdit", i);
            }
            var allRow = $("#tabSerial").datagrid("getRows");
            var sSerialCheck = ",";
            for (var i = 0; i < allRow.length; i++) {
                if (sSerialCheck.indexOf("," + allRow[i].sSerial + ",") > -1) {
                    Page.MessageShow("工序不可重复", "工序不可重复");
                    for (var j = 0; j < allRow.length; j++) {
                        $("#tabSerial").datagrid("beginEdit", j);
                    }
                    return false;
                }
                sSerialCheck += allRow[i].sSerial + ",";
            }

            var allRowsChild = $("#SDContractD").datagrid("getRows");
            var iRecNo = allRowsChild[selectIndex].iRecNo;
            var str = "";
            for (var i = 0; i < allRow.length; i++) {
                str += allRow[i].iRecNo + "`" + allRow[i].iSerial + "`" + allRow[i].sSerial + "`" + allRow[i].fQty + ",";
            }
            if (str != "") {
                str = str.substr(0, str.length - 1);
            }
            var jsonobj = {
                StoreProName: "SpSDContractMSerialSave",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: iRecNo
                }, {
                    ParmName: "@sStr",
                    Value: str
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                Page.MessageShow("错误", result);
                for (var i = 0; i < allRow.length; i++) {
                    $("#tabSerial").datagrid("beginEdit", i);
                }
            } else {
                $("#divSerial").dialog("close");
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
    <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="订单明细" data-options="border:false">
            <table id="tabSDContractD"></table>
        </div>
        <div title="生产通知单" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden; height: 140px;">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iOrderType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dOrderDate" />
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dProduceDate" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sIden" Z_NoSave="true" />
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>生产单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true" />
                            </td>
                            <td>通知日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>销售方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTransTypeID" />
                            </td>
                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>米数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                            </td>
                            <td>备注
                            </td>
                            <td colspan="5">
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
                            <td id="tdBuild" colspan="4" style="text-align: center; display: none;">
                                <a href="#" class="button orange" onclick="calcYarn()">核算用料</a>
                                &nbsp;&nbsp
                                <a href="#" class="button orange" onclick="showYarnUse()">查看用料</a>
                            </td>
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="生产通知单明细">
                            <!--子表1  -->
                            <table id="SDContractD" tablename="SDContractD">
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
                <td>下单日期从：
                </td>
                <td>
                    <input id="txbMenuDateFrom" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>至：
                </td>
                <td>
                    <input id="txbMenuDateTo" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>销售方式：
                </td>
                <td>
                    <input id="txbMenuSaleType" class="easyui-combobox" data-options="valueField:'sCode',textField:'sName'" style="width: 100px;" type="text" />
                </td>
                <td>客户:
                </td>
                <td>
                    <input id="txbMenuCustomer" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="#" onclick="loadContractMD()">明细查询</a>
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="#" onclick="loadContractMD(true)">汇总查询</a>
                </td>
                <td style="padding-left: 10px;">
                    <a class="button orange" href="#" onclick="buildNotice()">生成通知单</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="divYarnUse" class="easyui-window" data-options="title:'纱线用量',width:700,height:550,closed:true,modal:false,minimizable:false,collapsible:false,closable:true">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north',border:false" style="height: 300px;">
                <table id="tabYarnUseDetail"></table>
            </div>
            <div data-options="region:'center',border:false">
                <table id="tabYarnUseSummary"></table>
            </div>
        </div>
    </div>
    <div id="divSerial" class="easyui-dialog" data-options="title:'工序设置',width:250,height:400,
        closed:true,modal:true,minimizable:false,collapsible:false,closable:true,
        buttons:[{text:'确定',handler:confirmSerial},{text:'取消',handler:function(){$('#divSerial').dialog('close')}}]">
        <table id="tabSerial"></table>
    </div>
</asp:Content>

