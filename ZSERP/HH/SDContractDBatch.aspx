<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnRemove("table1", "add");
            Page.Children.toolBarBtnRemove("table1", "delete");
            Page.Children.toolBarBtnRemove("table1", "copy");
            Page.Children.toolBarBtnRemove("table1", "export");

            Page.Children.toolBarBtnRemove("table2", "add");
            Page.Children.toolBarBtnRemove("table2", "delete");
            Page.Children.toolBarBtnRemove("table2", "copy");
            Page.Children.toolBarBtnRemove("table2", "export");

            var iBatchNumO = Page.getFieldValue("iBatchNum");
            Page.setFieldValue("iBatchNum", 0);
            setTimeout(function () {
                Page.setFieldValue("iBatchNum", iBatchNumO);
            }, 1000);
        })

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "iBatchNum") {
                    var iBatchNum = Page.getFieldValue("iBatchNum");
                    if (iBatchNum != "0") {
                        Page.Children.ShowDynColumns("SDContractD", iBatchNum);
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" Z_FieldID="sOrderNo" Z_readOnly="true" runat="server" />
                    </td>
                    <td>合同号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sContractNo" Z_readOnly="true" />
                    </td>
                    <td>签单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_readOnly="true" Z_FieldType="日期" />
                    </td>
                    <td>客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" Z_readOnly="true" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>订单交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dOrderDate" Z_readOnly="true" Z_FieldType="日期" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" disabled="disabled" />
                        <label for="__ExtCheckbox1">是否分箱</label>
                    </td>
                    <td>分箱数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iBatchNum" Z_FieldType="整数" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',border:true,split:true" style="width: 250px">
                    <table id="table1" tablename="SDContractDBatchOrderDate">
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <table id="table2" tablename="SDContractD">
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

