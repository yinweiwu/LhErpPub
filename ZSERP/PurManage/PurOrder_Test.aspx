<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
                    <td>
                        采购单号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sBillNo" />
                    </td>
                    <td>
                        单据日期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        供应商
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        交期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="dOrderDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        总数量
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox5" runat="server" z_fieldid="fQty" Z_FieldType="数值" />
                    </td>
                    <td>
                        总金额
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox6" runat="server" z_fieldid="fTotal" Z_FieldType="数值" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" z_fieldid="sReMark" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细表">
                    <!--  子表1  -->
                    <table id="table1" tablename="PurOrderD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
