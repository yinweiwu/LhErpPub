<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        Page.beforeSave = function () {
            if (Page.getFieldValue('iBerCh') == 1) {
                Page.setFieldValue('iDbCheck', 1);
                $.messager.show({
                    title: "提示",
                    msg: "如果是仓位管理，则需调拨确认",
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
            }
        }
        var aaa = 1;
        function aa() {
            if (aaa == 1) {
                $.messager.show({
                    title: "提示",
                    msg: "如果是采购订单入库，则必须有采购订单才可入库",
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                aaa = 0;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <table class="tabmain" style="margin: auto;">
                <tr>
                    <td>
                        仓库编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sStockID" Z_Required="True"
                            Z_RequiredTip="仓库编号不能为空" />
                    </td>
                    <td>
                        仓库名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sStockName" Z_Required="True"
                            Z_RequiredTip="仓库名称不能为空" />
                    </td>
                    <td>
                        仓库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sMatClass" Z_Required="True"
                            Z_RequiredTip="仓库类型不能为空" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox6" runat="server" Z_FieldID="iShop" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox6">
                            是否门店</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iCost" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox2">
                            是否参与物料计划</label>
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iDbCheck" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox4">
                            是否调拨确认</label>
                    </td>
                    <td onclick="aa()">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" Z_FieldID="iPurOrder" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox5">
                            是否需采购订单入库</label>
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iSale" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox1">
                            是否可零售</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iBerCh" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox3">
                            是否仓位管理</label>
                    </td>
                    <td>
                        所属部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sDeptID" Z_Required="True"
                            Z_RequiredTip="所属部门不能为空" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        地址
                    </td>
                    <td colspan="2">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="99%" 
                            Z_FieldID="sAddress" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="仓位">
                    <table id="table1" tablename="BscDataStockD">
                    </table>
                </div>
                <div data-options="fit:true" title="用户权限">
                    <table id="table3" tablename="BscDataStockDUser">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
