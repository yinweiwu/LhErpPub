<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script language="javascript" type="text/javascript">
     Page.Children.onLoadSuccess = function () {
         GetfSumQty();
    }
    $(function () {
        
        $("#__ExtTextBox6").combo({
            onChange: function () {
                // 根据结算类型结算单位动态改变列的title
                if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 2) {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品码数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品码数");
                    columns[11].title = "投料米数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料米数");
                } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 2) {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品米数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
                    columns[11].title = "投料码数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料码数");
                } else {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品米数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
                    columns[11].title = "投料米数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料米数");
                }
                GetfSumQty();
            }
        });

        $("#__ExtTextBox5").combo({
            onChange: function () {
                // 根据结算类型结算单位动态改变列的title
                if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 2) {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品码数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品码数");
                    columns[11].title = "投料米数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料米数");
                } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 2) {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品米数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
                    columns[11].title = "投料码数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料码数");
                } else {
                    var options = $("#ProcessOrderD").datagrid("options");
                    var columns = options.columns[0];
                    columns[9].title = "成品米数";
                    $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
                    columns[11].title = "投料米数";
                    $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料米数");
                }
                GetfSumQty();
            }
        });

        if (Page.usetype != "add") {
            $("#tabTop").tabs("select", "外加工订单");
        }
        Page.Children.toolBarBtnRemove("table1", "add");
        Page.Children.toolBarBtnRemove("table1", "delete");
        Page.Children.toolBarBtnRemove("table1", "copy");
        Page.Children.toolBarBtnRemove("table1", "export");

        var tab2 = $('#tabTop').tabs('getTab', '外加工订单');

        $("#table1").datagrid(
                {
                    nowrap: true,
                    pageSize: 10,
                    pageList: [10, 20, 30, 50],
                    rownumbers: true,
                    pagination: true,
                    fit: true,
                    border: false,
                    striped: true,
                    remoteSort: false,
                    columns: [[
                        { title: "选择框", field: 'ck', checkbox: true, width: 40, rowspan: 2 },
                        { title: "是否完成", field: "sFinish", width: 90, align: 'center', rowspan: 2 },
                        { title: "订单号", field: "sCode", width: 90, align: 'center', rowspan: 2 },
                        { title: "订单日期", field: "dDate", width: 90, align: 'center', rowspan: 2 },
                        { title: "产品编号", field: "sCode", width: 80, align: 'center', rowspan: 2 },
                        { title: "产品名称", field: "sName", width: 90, align: 'center', rowspan: 2 },
                        { title: "颜色", field: "sColorName", width: 60, align: 'center', rowspan: 2 },
                        { title: "坯布编号", field: "sFabCode", width: 90, align: 'center', rowspan: 2 },
                        { title: "坯布名称", field: "sFabName", width: 90, align: 'center', rowspan: 2 },
                        { title: "投料类型", field: "sFeedType", width: 90, align: 'center', rowspan: 2 },
                        { title: "成品", align: 'center', colspan: 2 },
                        { title: "投料", align: 'center', colspan: 2 },
                        { title: "已投", align: 'center', colspan: 2 },
                        { title: "未投", align: 'center', colspan: 2}],
                        [{ title: "重量", field: "fOrderQty", width: 80, align: 'center', rowspan: 1 },
                        { title: "米数", field: "fOrderPurQty", width: 80, align: 'center', rowspan: 1 },
                        { title: "重量", field: "fQty", width: 80, align: 'center', rowspan: 1 },
                        { title: "米数", field: "fPurQty", width: 80, align: 'center', rowspan: 1 },
                        { title: "重量", field: "fQtyFeed", width: 90, align: 'center', rowspan: 1 },
                        { title: "米数", field: "fPurQtyFeed", width: 90, align: 'center', rowspan: 1 },
                        { title: "重量", field: "fNoFeedQty", width: 90, align: 'center', rowspan: 1 },
                        { title: "米数", field: "fNoFeedPurQty", width: 90, align: 'center', rowspan: 1 },
                        { title: "未生产数量", field: "fNoProductQty", width: 90, align: 'center', hidden: true },
                        { title: "未生产米数", field: "fNoProductPurQty", width: 90, align: 'center', hidden: true },
                    ///{ title: "前道工序", field: "sLastProcessesName", width: 90, align: 'center' },
                    //{ title: "前道库存重量", field: "fLastQty", width: 80, align: 'center' },
                    //{ title: "前道库存米数", field: "fLastPurQty", width: 80, align: 'center' },
                        { field: "iBscDataProcessMRecNo", width: 90, hidden: true },
                        { field: "iSdOrderDRecNo", width: 90, hidden: true },
                        { field: "iSDOrderDProcessRecNo", width: 90, hidden: true },
                        { field: "fProductWidth", width: 90, hidden: true },
                        { field: "fProductWeight", width: 90, hidden: true }
                    ]],
                    loadFilter: function (data) {
                        return pagerFilter(data);
                    }
                });
        // 根据结算类型结算单位动态改变列的title
        if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 2) {
            var options = $("#ProcessOrderD").datagrid("options");
            var columns = options.columns[0];
            columns[9].title = "成品码数";
            $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品码数");
            columns[11].title = "投料米数";
            $(".datagrid-cell-c1-fPurQty").find("span:first").html("投料米数");
        } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 2) {
            var options = $("#ProcessOrderD").datagrid("options");
            var columns = options.columns[0];
            columns[9].title = "成品米数";
            $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
            columns[11].title = "投料码数";
            $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料码数");
        } else {
            var options = $("#ProcessOrderD").datagrid("options");
            var columns = options.columns[0];
            columns[9].title = "成品米数";
            $(".datagrid-cell-c1-fPurQty").find("span:first").html("成品米数");
            columns[11].title = "投料米数";
            $(".datagrid-cell-c1-fFeedPurQty").find("span:first").html("投料米数");
        }



        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid == "ProcessOrderD") {
                GetfSumQty();
            }
        }
        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "ProcessOrderD") {
                GetfSumQty();
            }
        }
        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "ProcessOrderD") {
                GetfSumQty();
            }
        }
    })

    function ToSearch() {
        var iBscDataProcessMRecNo1 = Page.getFieldValue('iBscDataProcessMRecNo1');
        if (iBscDataProcessMRecNo1 == "") {
            $.messager.show({
                title: '提示',
                msg: '加工工序不能为空！',
                timeout: 1000,
                showType: 'show',
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
            return false;
        }
        var dDate1 = Page.getFieldValue('dDate1') == "" ? "1990-01-01" : Page.getFieldValue('dDate1');
        var dDate2 = Page.getFieldValue('dDate2') == "" ? "2990-01-01" : Page.getFieldValue('dDate2');

        var ComeFields = "iFinish,sFinish,dDate,sOrderNo,sCode,sName,sColorID,sColorName,sFabCode,sFabName,isnull(fQty,0) as fQty,isnull(fPurQty,0) as fPurQty,";
        ComeFields += "isnull(fQtyFeed,0) as fQtyFeed,isnull(fPurQtyFeed,0) as fPurQtyFeed,isnull(fNoFeedQty,0) as fNoFeedQty,isnull(fNoFeedPurQty,0) as fNoFeedPurQty,isnull(fNoProductQty,0) as fNoProductQty,isnull(fNoProductPurQty,0) as fNoProductPurQty,sProcessesName,isnull(fOrderQty,0) as fOrderQty,isnull(fOrderPurQty,0) as fOrderPurQty,";
        ComeFields += "iFeedType,sFeedType,iBscDataProcessMRecNo,iSdOrderDRecNo,iStatus,iSDOrderDProcessRecNo,fProductWidth,fProductWeight";
        var sqlObj = {
            TableName: "vwOrderProcessMD",
            Fields: ComeFields,
            SelectAll: "True",
            Filters: [
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt: "and"
                    },
                    {
                        LeftParenthese: "(",
                        Field: "isnull(fNoFeedPurQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(fNoFeedQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        RightParenthese: ")",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iFinish,0)",
                        ComOprt: "=",
                        Value: 0,
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iBscDataProcessMRecNo,0)",
                        ComOprt: "=",
                        Value: iBscDataProcessMRecNo1,
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'"
                    }
                    ],
            Sorts: [
                {
                    SortName: "dDate",
                    SortOrder: "asc"
                }]
        };
        var result = SqlGetData(sqlObj);
        $("#table1").datagrid('loadData', result);
    }

    function pagerFilter(data) {
        if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
            data = {
                total: data.length,
                rows: data
            }
        }
        var dg = $('#table1');
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

    function passIn() {
        var getRows = $('#table1').datagrid('getChecked');
        if (getRows.length > 0) {
            var iBscDataProcessMRecNo = getRows[0].iBscDataProcessMRecNo;
            for (var i = 0; i < getRows.length; i++) {
                if (iBscDataProcessMRecNo != getRows[i].iBscDataProcessMRecNo || Page.getFieldValue("iBscDataProcessMRecNo") != '' && Page.getFieldValue("iBscDataProcessMRecNo") != getRows[i].iBscDataProcessMRecNo) {
                    alert("不能转入不同工序");
                    return fasle;
                }
            }
            Page.setFieldValue("iBscDataProcessMRecNo", iBscDataProcessMRecNo);
            Page.setFieldValue("iCalcType", 1);
            Page.setFieldValue("iCalcUnitID", 0);
            if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 2) {
                for (var i = 0; i < getRows.length; i++) {
                    getRows[i].fQty = getRows[i].fNoProductQty;
                    getRows[i].fPurQty = getRows[i].fNoProductPurQty / 0.9144;
                    getRows[i].fFeedQty = getRows[i].fNoFeedQty;
                    getRows[i].fFeedPurQty = getRows[i].fNoFeedPurQty;
                    getRows[i].iSDOrderDRecNo = getRows[i].iSdOrderDRecNo;
                    Page.tableToolbarClick("add", "ProcessOrderD", getRows[i]);
                }
            } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 2) {
                for (var i = 0; i < getRows.length; i++) {
                    getRows[i].fQty = getRows[i].fNoProductQty;
                    getRows[i].fPurQty = getRows[i].fNoProductPurQty;
                    getRows[i].fFeedQty = getRows[i].fNoFeedQty;
                    getRows[i].fFeedPurQty = getRows[i].fNoFeedPurQty / 0.9144;
                    getRows[i].iSDOrderDRecNo = getRows[i].iSdOrderDRecNo;
                    Page.tableToolbarClick("add", "ProcessOrderD", getRows[i]);
                }
            } else {
                for (var i = 0; i < getRows.length; i++) {
                    getRows[i].fQty = getRows[i].fNoProductQty;
                    getRows[i].fPurQty = getRows[i].fNoProductPurQty;
                    getRows[i].fFeedQty = getRows[i].fNoFeedQty;
                    getRows[i].fFeedPurQty = getRows[i].fNoFeedPurQty;
                    getRows[i].iSDOrderDRecNo = getRows[i].iSdOrderDRecNo;
                    Page.tableToolbarClick("add", "ProcessOrderD", getRows[i]);
                }
            }

            $("#tabTop").tabs("select", "外加工订单");

        }
        else {
        alert("未选择行");
        }
}

    function toFinish() {
        var getRows = $('#table1').datagrid('getChecked');
        if (getRows.length > 0) {
            for (var i = 0; i < getRows.length; i++) {
                var jsonobj = {
                    StoreProName: "SpFinish",
                    StoreParms: [{
                        ParmName: "@iformid",
                        Value: 3
                    },
                            {
                                ParmName: "@iRecNo",
                                Value: getRows[i].iSDOrderDProcessRecNo
                            },
                            {
                                ParmName: "@sUserID",
                                Value: "'" + Page.getFieldValue("sUserID") + "'"
                            }]
                }
                var Result = SqlStoreProce(jsonobj);
                if (Result != "1") {
                    $.messager.show({
                        title: '提示',
                        msg: Result,
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                }
                else {
                    $.messager.alert("成功", "已完成！");
                    ToSearch();
                }
            }
        } else {
            alert("未选择行");
        }
    }

    function GetfSumQty() {
        // 根据结算类型结算单位汇总数量
        if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 0) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fQty)) == true ? 0 : Number(getRows[i].fQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 1) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fPurQty)) == true ? 0 : Number(getRows[i].fPurQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else if (Page.getFieldValue("iCalcType") == 1 && Page.getFieldValue("iCalcUnitID") == 2) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fPurQty)) == true ? 0 : Number(getRows[i].fPurQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 0) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fFeedQty)) == true ? 0 : Number(getRows[i].fFeedQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 1) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fFeedPurQty)) == true ? 0 : Number(getRows[i].fFeedPurQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else if (Page.getFieldValue("iCalcType") == 2 && Page.getFieldValue("iCalcUnitID") == 2) {
            var getRows = $("#ProcessOrderD").datagrid('getRows');
            if (getRows.length > 0) {
                var fSumQty = 0;
                for (var i = 0; i < getRows.length; i++) {
                    fSumQty += isNaN(Number(getRows[i].fFeedPurQty)) == true ? 0 : Number(getRows[i].fFeedPurQty);
                }
                Page.setFieldValue("fSumQty", fSumQty);
            } else {
                Page.setFieldValue("fSumQty", 0);
            }
        } else {
            Page.setFieldValue("fSumQty", 0);
        }
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
    <div title="未完成加工订单">
    <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <div style="float: left; width: 80%;">
                            <table>
                                <tr>
                                    <td>
                                        加工工序
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBscDataProcessMRecNo1"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        日期从
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldType="日期" Z_FieldID="dDate1"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        至
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldType="日期" Z_FieldID="dDate2"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='ToSearch()'>查询</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='passIn()'>转入</a> <a href='javascript:void(0)'
                                                    class="easyui-linkbutton" data-options="iconCls:'icon-finishWork'" onclick='toFinish()'>
                                                    完成</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="table1">
                    </table>
                </div>
            </div>
    </div>
    <div title="外加工订单">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="sDeptID" />
                <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        加工单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        加工日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" Z_Required="True" />
                    </td>
                    <td>
                        加工厂家
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" Z_Required="True"  />
                    </td>
                    
                </tr>
                <tr>
                    <td>
                        加工工艺
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iBscDataProcessMRecNo" Width="200" Z_readOnly="True"/>
                    </td>
                    <td>
                        结算类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iCalcType" Width="200" />
                    </td>
                    <td>
                        结算单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iCalcUnitID" Width="200" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="334px" Z_FieldID="sRemark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        总数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fSumQty" 
                            Z_readOnly="True" Z_NoSave="True" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                </tr>
               
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="加工明细">
                    <!--  子表1  -->
                    <table id="ProcessOrderD" tablename="ProcessOrderD">
                    </table>
                </div>
                
            </div>
        </div>
    </div>
    </div>
    </div>
  
</asp:Content>
