<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <br />
                    <table align="center" style="width: 80%">
                        <tr>
                            <td>
                                通知单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>
                                产品编号/名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataMatRecNo" />
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table class="tabmain">
                        <tr>
                            <td>
                                打色类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sType" Z_disabled="False" />
                            </td>
                            <td>
                                色样规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sElements" />
                            </td>
                            <td>
                                对色光源
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sLightSources" Z_FieldType="空" />
                            </td>
                            <td>
                                测试报告
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldType="空" Z_FieldID="sTestReport" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                加工面
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sMachFace" Z_disabled="False"
                                    Z_FieldType="空" />
                            </td>
                            <td>
                                毛要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sEffectRemark" Z_FieldType="空"
                                    Z_readOnly="False" />
                            </td>
                            <td>
                                风格要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sStyleRemark" Z_readOnly="False" />
                            </td>
                            <td>
                                加工要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldType="空" Z_FieldID="sProcessRemark" />
                            </td>
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td>
                                打样品质要<br />
                                求及备注
                            </td>
                            <td colspan='7'>
                                <textarea fieldid="sRemark" style="border-bottom: 1px solid black; width: 740px;
                                    border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                                    border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                                    border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                收样日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dGetDate" Z_disabled="False"
                                    Z_FieldType="日期" />
                            </td>
                            <td>
                                寄样日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                染厂交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dWorkDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                客户确认日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldType="日期" Z_FieldID="dInputDate"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="通知明细">
                    <table id="SDSampleD" tablename="SDSampleD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
