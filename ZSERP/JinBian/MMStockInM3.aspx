<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        生产单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        下单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        生产厂家
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
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        订单数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sYearMonth" Z_Required="true" />
                    </td>
                    <td id="tdInvoiceLabel">
                        坯布幅宽
                    </td>
                    <td id="tdInvoice">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        坯布克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                    </td>
                    <td>
                        是否采购
                    </td>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fTotal" />
                    </td>
                </tr>
                <tr>
                    <td>
                        产品幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        产品克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        机台型号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sYearMonth" Z_Required="true" />
                    </td>
                    <td>
                        转速
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        进纱路数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iRed" />
                    </td>
                    <td>
                        是否留开幅线
                    </td>
                    <td>
                        摆幅带创
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sYearMonth" Z_Required="true" />
                    </td>
                    <td>
                        卷起带创
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        对色光源
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBscDataPersonID" Z_FieldType="日期" />
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
