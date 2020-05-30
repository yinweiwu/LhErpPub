<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="JS/MMStockDbM.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">

                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        调拔单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>

                    <td>
                        调拔日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="日期" runat="server" Z_FieldID="dDate"
                            Z_Required="true" />
                    </td>
                    <td>
                        调入订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iInSdOrderMRecNo" />
                    </td>
                    
                </tr>
                <tr>
                    <td>
                        
                        调出仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iOutBscDataStockMRecNo"
                            Z_Required="true" />
                    </td>
                    <td>
                        调入仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iInBscDataStockMRecNo"
                            Z_Required="true" />
                            <div style="display: none">
                            仓位管理<cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iBerCh" Z_NoSave="true" />
                        </div>
                    </td>
                     <td>
                        调入款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sStyleNo" Z_NoSave="true" Z_disabled="true" />
                    </td>
                    <%--<td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sPerson"
                             />
                             
                    </td>--%>
                </tr>
                
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark"
                             />
                    </td>
                     <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" Z_disabled="true"
                            Z_Required="true" />
                    </td>
                </tr>
<%--                <tr>

                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iQty" Z_disabled="true" />
                    </td>
                    <td>
                        总金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fTotal" Z_disabled="true" />
                    </td>
                    
                </tr>--%>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iStatus" Z_Value="0" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
                
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调拔明细">
                    <!--  子表1  -->
                    <table id="MMStockDbD" tablename="MMStockDbD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <%--<table id="table2" tablename="bscDataBuildDUnit">
                    </table>--%>
                </div>--%>
            </div>
    </div>
</asp:Content>

