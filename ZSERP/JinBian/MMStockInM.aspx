<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
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
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iBerCh" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iPurOrder" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sMatClass" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox200" runat="server" Z_FieldID="iBillType" Z_NoSave="false"
                            Style="display: none;" />
                    </td>
                    <td id="tdBscDataCustomerRecNoLabel">
                        供应商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        到货单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sYearMonth" Z_Required="true" />
                    </td>
                    <td id="tdInvoiceLabel">
                        产品名称
                    </td>
                    <td id="tdInvoice">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                    </td>
                    <td>
                        红冲
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan='3'>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" Width="99%" />
                    </td>
                </tr>
                <tr>
                    <td>
                        颜色名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" />
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
                    <td>
                        出库单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <table id="MMStockInD" tablename="MMStockInD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
