<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            $("#tbGridNotFinish").datagrid(
                {
                    fit: true,
                    border: false,
                    pageNumber: 1,
                    pageSize: 50,
                    pageList: [50, 100, 500, 1000],
                    remoteSort: false,
                    loadFilter: pagerFilter,
                    columns: [
                        [
                        { title: "订单号", field: "sOrderNo", width: 110, align: "center" },
                        { title: "接收", field: "__aa", formatter: function (value, row, index) {
                            return "<input type='button' onclick='doReceive(" + index + ")' value='接收' />";
                        }, width: 60, algin: "center"
                        },
                        { title: "客户简称", field: "sCustShortName", width: 80, align: "center" },
                        { title: "签订日期", field: "dDate1", width: 80, align: "center" },
                        { title: "成品编号", field: "sCode", width: 80, align: "center" },
                        { title: "成品名称", field: "sName", width: 80, align: "center" },
                        { title: "卷号生成规则", field: "sReelNoBuildName", width: 80, align: "center" },
                        { title: "前缀", field: "sReelNoPre", width: 60, align: "center" },
                        { title: "流水规则", field: "sReelNoFlag", width: 60, align: "center" },
                        { title: "色号", field: "sColorID", width: 80, align: "center" },
                        { title: "颜色", field: "sColorName", width: 80, align: "center" },
                        { title: "幅宽", field: "fProductWidth", width: 60, align: "center" },
                        { title: "克重", field: "fProductWeight", width: 60, align: "center" },
                        { title: "米长", field: "fSumQty", width: 60, align: "center" },
                        { title: "已接收缸数", field: "iVatReceiveCount", width: 80, align: "center" },
                        { title: "已接收缸号", field: "sReceiveVatNo", width: 300, align: "center" },
                        { field: "iRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true }
                        ]
                    ],
                    singleSelect: true,
                    toolbar: [
                        {
                            iconCls: "icon-search",
                            text: "查询",
                            handler: function () {
                                search(0);
                            }
                        },
                        {
                            iconCls: "icon-ok",
                            text: "接收完成",
                            handler: function () {
                                flagFinish(1);
                            }
                        }
                    ]
                }
            );

            $("#tbGridFinish").datagrid(
                {
                    fit: true,
                    border: false,
                    pageNumber: 1,
                    pageSize: 50,
                    pageList: [50, 100, 500, 1000],
                    remoteSort: false,
                    loadFilter: pagerFilter,
                    columns: [
                        [
                        { title: "订单号", field: "sOrderNo", width: 80, align: "center" },
                        { title: "客户简称", field: "sCustShortName", width: 80, align: "center" },
                        { title: "签订日期", field: "dDate1", width: 80, align: "center" },
                        { title: "成品编号", field: "sCode", width: 80, align: "center" },
                        { title: "成品名称", field: "sName", width: 80, align: "center" },
                        { title: "卷号生成规则", field: "sReelNoBuildName", width: 80, align: "center" },
                        { title: "前缀", field: "sReelNoPre", width: 60, align: "center" },
                        { title: "流水规则", field: "sReelNoFlag", width: 60, align: "center" },
                        { title: "色号", field: "sColorID", width: 80, align: "center" },
                        { title: "颜色", field: "sColorName", width: 80, align: "center" },
                        { title: "幅宽", field: "fProductWidth", width: 60, align: "center" },
                        { title: "克重", field: "fProductWeight", width: 60, align: "center" },
                        { title: "米长", field: "fQty", width: 60, align: "center" },
                        { title: "已接收缸数", field: "iVatReceiveCount", width: 80, align: "center" },
                        { title: "已接收缸号", field: "sReceiveVatNo", width: 300, align: "center" },
                        { field: "iRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true }
                        ]
                    ],
                    singleSelect: true,
                    toolbar: [
                        {
                            iconCls: "icon-search",
                            text: "刷新",
                            handler: function () {
                                search(1);
                            }
                        },
                        {
                            iconCls: "icon-ok",
                            text: "标记未接收完成",
                            handler: function () {
                                flagFinish(0);
                            }
                        }
                    ]
                }
            );
            if (Page.usetype != "add") {
                $("#divTab").tabs("select", 1);
                var sqlObj = {
                    TableName: "vwSDOrderMD",
                    Fields: "sOrderNo,sCustShortName,dDate1,sCode,sName,sReelNoBuildName,sReelNoPre,sReelNoFlag,sColorID,sColorName,fProductWidth,fProductWeight,fSumQty,iRecNo,iSDOrderMRecNo",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.key + "'"
                    }
                    ]
                };
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    $("#form1").form("load", result[0]);
                }

            }
            else {
                Page.usetype = "modify";
            }
        })

        //type=0表示未完成，1表示完成
        function search(type) {
            var sqlObj = {
                TableName: "vwSDOrderMD",
                Fields: "sOrderNo,sCustShortName,dDate1,sCode,sName,sReelNoBuildName,sReelNoPre,sReelNoFlag,sColorID,sColorName,fProductWidth,fProductWeight,fSumQty,iRecNo,iSDOrderMRecNo,iVatReceiveCount,sReceiveVatNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(iVatReceiveFinish,0)",
                        ComOprt: "=",
                        Value: type
                    }
                ],
                Sorts: [
                    {
                        SortName: "dDate1",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "dInputDate",
                        SortOrder: "asc"
                    }
                ]
            };
            var result = SqlGetData(sqlObj);
            if (type == 0) {
                $("#tbGridNotFinish").datagrid("loadData", result);
            } else {
                $("#tbGridFinish").datagrid("loadData", result);
            }
        }
        var notFinishLoad = false;
        function tabSelect(title, index) {
            if (index == 2) {
                if (notFinishLoad == false) {
                    search(1);
                    notFinishLoad = true;
                }
            }
        }
        function flagFinish(type) {
            var iRecNo = 0;
            var message = "";
            if (type == 0) {
                var selectedRow = $("#tbGridFinish").datagrid("getSelected");
                if (selectedRow) {
                    iRecNo = selectedRow.iRecNo;
                    message = "确认标记选择行为未完成吗？";
                }
            }
            else {
                var selectedRow = $("#tbGridNotFinish").datagrid("getSelected");
                if (selectedRow) {
                    iRecNo = selectedRow.iRecNo;
                    message = "确认标记选择行为完成吗？";
                }
            }
            if (iRecNo != 0) {

                $.messager.confirm("确定吗？", message, function (r) {
                    if (r) {
                        var jsonobj = {
                            StoreProName: "SpSDOrderDVatReceiveFinish",
                            StoreParms: [
                            {
                                ParmName: "@iRecNo",
                                Value: iRecNo
                            },
                            {
                                ParmName: "@iType",
                                Value: type
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                        else {
                            if (type == 0) {
                                search(1);
                            }
                            else {
                                search(0);
                            }
                        }
                    }
                })
                
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
        function doReceive(index) {
            var allRows = $("#tbGridNotFinish").datagrid("getRows");
            if (allRows.length > 0) {
                $("#form1").form("load", allRows[index]);
                Page.setFieldValue("sReelNoBulidName", allRows[index].sReelNoBulidName);
                Page.key = allRows[index].iRecNo;
                var sqlObj = {
                    TableName: "SDOrderDD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field:"iMainRecNo",
                            ComOprt:"=",
                            Value:"'"+Page.key+"'"
                        }
                    ]
                    }
                    var result = SqlGetData(sqlObj);
                    $("#table1").datagrid("loadData", result);

                $("#divTab").tabs("select", 1);
            }
        }
        Page.beforeSave = function () {
            var str = ",";
            var allRows = $("#tbGridFinish").datagrid("getRows");
            for (var i = 0; i < allRows.length; i++) {
                if (str.indexOf("," + allRows[i].sVatNo + ",") > -1) {
                    alert("检测到有重复缸号！");
                    return false;
                }
                str += allRows[i].sVatNo + ',';
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false,onSelect:tabSelect">
            <div title="未接收完成缸号订单明细">
                <table id="tbGridNotFinish">
                </table>
            </div>
            <div title="接收明细">
                <div id="div1" class="easyui-layout" data-options="fit:true,border:false">
                    <div data-options="region:'north',border:false" style="overflow: hidden;">
                        <!—如果只有一个主表，这里的north要变为center-->
                        <div id="divHiden" style="display: none;">
                            <!--隐藏字段位置-->
                        </div>
                        <!--主表部分-->
                        <table class="tabmain">
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    订单号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    客户
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sCustShortName" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    产品编号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sCode" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    产品名称
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sName" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                            </tr>
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    色号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sColorID" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    颜色
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sColorName" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    幅宽
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fProductWidth" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    克重
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fProductWeight" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                            </tr>
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    米长
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fSumQty" Z_readOnly="true"
                                         Z_NoSave="true" />
                                </td>
                                <td>
                                    卷号生成规格
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReelNoBuildName" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    前缀
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sReelNoPre" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                                <td>
                                    卷号规则
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReelNoFlag" Z_readOnly="true"
                                        Z_NoSave="true" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div data-options="region:'center',border:false ">
                        <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                        <div class="easyui-tabs" data-options="fit:true,border:false">
                            <div data-options="fit:true" title="缸号明细">
                                <!--  子表1  -->
                                <table id="table1" tablename="SDOrderDD">
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div title="接收完成缸号订单明细">
                <table id="tbGridFinish">
                </table>
            </div>
        </div>
    </div>
</asp:Content>
