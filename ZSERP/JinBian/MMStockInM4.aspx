﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

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
                        申请单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        申请日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        需求日期
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
                        申请人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        申请部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
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
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <table id="MMStockInD" tablename="MMStockInD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>