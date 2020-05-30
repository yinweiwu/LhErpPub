<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td id="corner1" rowspan="4">
                    </td>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        样卡单号
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
                        来往单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        产品成分
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        单价
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan='3'>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" Width="99%" />
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
                    <td id="corner2">
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
