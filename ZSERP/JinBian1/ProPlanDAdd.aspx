<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                $("#dgProPlanD").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 500],
                    toolbar: "#dgTool",
                    columns: [
                    [
                        { field: "sBillNo", title: "点色单号", width: 80, align: "center" },
                        { field: "__aaa", title: "补单", width: 80, align: "center",
                            formatter: function (value, row, index) {
                                return "<input type='button' value='补单' onclick=doClick(" + index + ") />"
                            }
                        },
                        { field: "sOrderNo", title: "订单号", width: 80, align: "center" },
                        { field: "sCustShortName", title: "染厂", width: 80, align: "center" },
                        { field: "sCode", title: "产品编号", width: 80, align: "center" },
                        { field: "sName", title: "产品名称", width: 80, align: "center" },
                        { field: "sBscDataFabCode", title: "坯布编号", width: 100, align: "center" },
                        { field: "sBscDataFabName", title: "坯布名称", width: 80, align: "center" },
                        { field: "sColorID", title: "色号", width: 100, align: "center" },
                        { field: "sColorName", title: "颜色", width: 80, align: "center" },
                        { field: "fQty", title: "原下单重量", width: 80, align: "center" },
                        { field: "sUserName", title: "业务员", width: 60, align: "center" },
                        { field: "iRecNo", hidden: true }
                    ]
                    ],
                    onDblClickRow: function (index, row) {
                        doClick(index);
                    }
                });
            }
            if (Page.usetype != "add") {
                $("#divTab").tabs("select", 1);
            }
        })

        function bind() {
            var filters = [
                {
                    Field: "isnull(iStatus,0)",
                    ComOprt: ">",
                    Value: "3",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(sProPlanUserID,'')",
                    ComOprt: "=",
                    Value: "'" + Page.userid + "'"
                }
            ];
            var sBillNo = $("#__ExtTextBox5").val();
            if (sBillNo != "") {
                filters[filters.length - 1].linkOprt = "and";
                filters.push(
                    {
                        Field: "sBillNo",
                        ComOprt: "like",
                        Value: "'%" + sBillNo + "%'"
                    }
                    )
            }
            var sBillNo = $("#__ExtTextBox5").val();
            if (sBillNo != "") {
                filters[filters.length - 1].linkOprt = "and";
                filters.push(
                    {
                        Field: "sBillNo",
                        ComOprt: "like",
                        Value: "'%" + sBillNo + "%'"
                    }
                    )
            }
            var sCode = $("#__ExtTextBox6").val();
            if (sCode != "") {
                filters[filters.length - 1].linkOprt = "and";
                filters.push(
                    {
                        Field: "sCode",
                        ComOprt: "like",
                        Value: "'%" + sCode + "%'"
                    }
                    )
            }

            var sName = $("#__ExtTextBox7").val();
            if (sName != "") {
                filters[filters.length - 1].linkOprt = "and";
                filters.push(
                    {
                        Field: "sName",
                        ComOprt: "like",
                        Value: "'%" + sName + "%'"
                    }
                    )
            }
            var sBscDataFabCode = $("#__ExtTextBox8").val();
            if (sBscDataFabCode != "") {
                filters[filters.length - 1].linkOprt = "and";
                filters.push(
                    {
                        Field: "sBscDataFabCode",
                        ComOprt: "like",
                        Value: "'%" + sBscDataFabCode + "%'"
                    }
                    )
            }
            var sqlObj = {
                TableName: "vwProPlanMD",
                Fields: "*",
                SelectAll: "True",
                Filters: filters
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                $("#dgProPlanD").datagrid("loadData", result);
            }
            else {
                Page.MessageShow("没有数据", "没有数据");
            }
        }

        function doClick(index) {
            var theRow = $("#dgProPlanD").datagrid("getRows")[index];
            Page.setFieldValue("iProPlanDRecNo", theRow.iRecNo);
            Page.setFieldValue("fStockFabQty", theRow.fStockFabQty);
            $("#divTab").tabs("select", 1);
        }

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "fAddQty" || field == "fUseStockFabQty") {
                    var fAddQty = isNaN(parseFloat(Page.getFieldValue("fAddQty"))) ? 0 : parseFloat(Page.getFieldValue("fAddQty"));
                    var fUseStockFabQty = isNaN(parseFloat(Page.getFieldValue("fUseStockFabQty"))) ? 0 : parseFloat(Page.getFieldValue("fUseStockFabQty"));
                    Page.setFieldValue("fNeedQty", fAddQty - fUseStockFabQty);
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divTab" class="easyui-tabs" data-options="fit:true">
        <div title="原点色单" data-options="fit:true">
            <table id="dgProPlanD">
            </table>
        </div>
        <div title="补单信息" data-options="fit:true">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'center',border:false" style="overflow: hidden;">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                        <!--隐藏字段位置-->
                        <div id="dgTool">
                            <table>
                                <tr>
                                    <td>
                                        点色单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" style="width:120px;" />
                                    </td>
                                    <td>
                                        产品编号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" style="width:120px;" />
                                    </td>
                                    <td>
                                        产品名称
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" style="width:120px;" />
                                    </td>
                                    <td>
                                        坯布编号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" style="width:120px;" />
                                    </td>
                                    <td>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick="bind()">查询</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                点色单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iProPlanDRecNo" Style="width: 150px;" />
                            </td>
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true"
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
                            <td>
                                坯布编号</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" Z_FieldID="sBscDataFabCode" Z_readOnly="true" Z_NoSave="true" runat="server" />
                            </td>
                            <td>
                                坯布名称</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" Z_FieldID="sBscDataFabName" Z_readOnly="true" Z_NoSave="true" runat="server" />
                            </td>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sColorID" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                颜色
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sColorName" Z_readOnly="True"
                                    Z_NoSave="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                染厂</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sCustShortName" 
                                    Z_NoSave="True" Z_readOnly="True" />
                            </td>
                            <td>
                                原染色下单量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fQty" Z_readOnly="true" />
                            </td>
                            <td>
                                补单量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_decimalDigits="2" Z_FieldID="fAddQty"
                                    Z_FieldType="数值" />
                            </td>
                            <td>
                                坯布库存量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fStockFabQty" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                使用坯布库存量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fUseStockFabQty"  Z_decimalDigits="2" Z_FieldType="数值" />
                            </td>
                            <td>
                                需要自制或采购量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fNeedQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="321px" Z_FieldID="sRemark" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" style="width:150px;" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
                </div>
                <%--<div data-options="region:'center',border:false ">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="子表1标题">
                            <!--  子表1  -->
                            <table id="table1" tablename="bscDataBuildDLay">
                            </table>
                        </div>
                        <div data-options="fit:true" title="子表2标题">
                            <!--  子表2  -->
                            <table id="table2" tablename="bscDataBuildDUnit">
                            </table>
                        </div>
                    </div>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
