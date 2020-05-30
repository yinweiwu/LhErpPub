<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="JS/MMStockInM.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (getQueryString("sType") == "2" || getQueryString("iBillType") == "2") {
                $("#tdInvoiceLabel").hide();
                $("#tdInvoice").hide();
                $("#tdOutTotalLabel").hide();
                $("#tdOutTotal").hide();
                $("#tdBscDataCustomerRecNoLabel").html("客户");
            }
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        入库仓库
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
                        入库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sYearMonth" Z_disabled="true"
                            Z_Required="true" />
                    </td>
                    <td id="tdInvoiceLabel">
                        发票号
                    </td>
                    <td id="tdInvoice">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true" />
                    </td>
                    <td id="tdOutTotalLabel">
                        加工费
                    </td>
                    <td id="tdOutTotal">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fOutTotal" Z_disabled="true" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 runat="server" Z_FieldID="iRed" />
                        红冲
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCust" />
                        客供
                    </td>
                </tr>
                <tr>
                    <td>
                        检验单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox199" runat="server" Z_FieldID="sCheckBillNo" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" />
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
                        <%--<cc1:ExtHidden2 ID="ExtHidden1"  runat="server" Z_FieldID="iPurType" Z_Value="0"/>--%>
                    </td>
                </tr>
            </table>
            <hr />
            <table class="tabmain">
                <tr>
                    <td>
                        条码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBarCode" Z_NoSave="true"
                            Font-Bold="True" Style="border: 0px; border-bottom: 1px solid black;" Height="21px" />
                    </td>
                    <td colspan="2">
                        <textarea id="sbarcoderemark" style="border-bottom: 1px solid black; height: 21px;
                            border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                            border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                            border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                    </td>
                    <%-- <td>
                        仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
                    </td>--%>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--  子表1  -->
                    <table id="MMStockInD" tablename="MMStockInD">
                    </table>
                </div>
                <%-- <div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
