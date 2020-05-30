<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center'" style="overflow: hidden;">
            <div>
                <img src="../BaseData/images/xssk.png" width="30px" style="padding: 5px 0 0 5px;" />
                <div style="padding: 0 0 0 45px; margin: -16px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 40px; margin: -24px auto">
                    <span style="font-family: 黑体; font-size: 15px">销售收款</span>
                </div>
                <br />
                <br />
                <br />
            </div>
            <table class="tabmain" style="height: 300px">
                <tr>
                    <td>
                        单据号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        收款日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="ibscDataPersonID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        收款类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sConnectonType" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        来源
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sSource" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="fTotal" Z_FieldType="数值"
                            Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="sYearMonth" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="80%" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
