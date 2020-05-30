<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMProductCheckM.js" type="text/javascript"></script>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td>
                        染色厂
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                    </td>
                    <td>
                        投缸日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sBillNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        颜色名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                    </td>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        缸号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sBillNo" />
                    </td>
                    <td>
                        重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sBillNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        匹数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                    <td>
                        跟单员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        完成日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sBillNo" Z_FieldType="日期" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" />
                    </td>
                    <td>
                        开卡
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" />
                    </td>
                    <td>
                        退卷
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" />
                    </td>
                    <td>
                        回潮
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" />
                    </td>
                    <td>
                        水洗
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" />
                    </td>
                    <td>
                        磨毛
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox6" runat="server" />
                    </td>
                    <td>
                        预定型
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox7" runat="server" />
                    </td>
                    <td>
                        复色
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox8" runat="server" />
                    </td>
                    <td>
                        进缸
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox9" runat="server" />
                    </td>
                    <td>
                        出缸
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox10" runat="server" />
                    </td>
                    <td>
                        展福
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" />
                    </td>
                    <td>
                        风干
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox12" runat="server" />
                    </td>
                    <td>
                        拉毛
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox13" runat="server" />
                    </td>
                    <td>
                        成定
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox14" runat="server" />
                    </td>
                    <td>
                        打卷</td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox15" runat="server" />
                    </td>
                    <td>
                        发出</td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
