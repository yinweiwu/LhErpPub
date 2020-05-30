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
                    <!--这里是主表字段摆放位置-->
                    <td>
                        会员卡类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>

                    <td>
                        折扣%
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="数值" runat="server" Z_FieldID="fDiscount"
                            Z_Required="true" />
                    </td>
                    <td>
                        最低积分
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldType="整数" runat="server" Z_FieldID="iLowestScore" Z_Required="true"  />
                    </td>
                    
                </tr>
                
                
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        
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

