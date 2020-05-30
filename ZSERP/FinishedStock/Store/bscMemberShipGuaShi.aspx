<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
        <tr>
            <td colspan="8" style="text-align:center;">
                <h3>会员卡挂失</h3>
            </td>            
        </tr>
        <tr>
            <td>挂失卡号</td>
            <td>
                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" CssClass="txbbottom"  Z_Required="true" Z_FieldID="sCardNo"
                     />
            </td>
            <td>姓名</td>
            <td>
                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server"    Z_Required="true" Z_FieldID="sName"
                     />
            </td>
            <td>日期</td>
            <td>
                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate"  Z_FieldType="日期" 
                       Z_Required="true"/>
            </td>

            
        </tr>
 
        <tr>
            <td>制单人</td>
            <td>
                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" readonly="readonly" 
                    CssClass="txbbottom" Z_FieldID="sUserID" />
            </td>
            <td>制单日期</td>
            <td>
                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" readonly="readonly" 
                    CssClass="txbbottom" Z_FieldID="dInputDate" />
            </td>
 
        </tr>
    </table>
        </div>
<%--        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调拔明细">
                    <!--  子表1  -->
                    <table id="MMProductDbD" tablename="MMProductDbD">
                    </table>
                </div>
                <div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <table id="table2" tablename="bscDataBuildDUnit">
                    </table>
                </div>
            </div>--%>
    </div>
</asp:Content>

