<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script language="javascript" type="text/javascript">
    $(function () {

    })

    Page.Formula = function (field) {
        if (Page.isInited == true) {
            if (field == "fPrice" || field == "fQty") {
                var fPrice = isNaN(Number(Page.getFieldValue("fPrice"))) ? 0 : Number(Page.getFieldValue("fPrice"));
                var fQty = isNaN(Number(Page.getFieldValue("fQty"))) ? 0 : Number(Page.getFieldValue("fQty"));
                Page.setFieldValue("fTotal", fPrice * fQty);
            }
        }
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false" style="padding:10px;">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                    Z_readOnly="true" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单据号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>
                        购买日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        货物名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sMatName" />
                    </td>
                    <td>
                        分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sClassID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        供应商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sSupplier" />
                    </td>
                    <td>
                        品牌
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sBrand" />
                    </td>
                    <td>
                        单价
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fPrice" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fQty" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fTotal" Z_FieldType="数值"
                            Z_decimalDigits="2" Z_readOnly="true" />
                    </td>
                    <td>
                        联系人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sContacts" />
                    </td>
                    <td>
                        联系人电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sContactsTel" />
                    </td>
                </tr>
                <tr>
                    <td>
                        地址
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sAddress" Width="352px" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sRemark" Width="343px" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
