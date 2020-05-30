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
                    <%--<td>
                        门店
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="ibscDataStockMRecNo" Z_Required="true" />
                    </td>--%>

                    <td>
                        物品积分: 1积分 = (?元)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="数值" runat="server" Z_FieldID="iSaleIntegralBase"
                              />
                    </td>
                    <td>
                        零售积分兑换: 100积分 = (?元)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldType="整数" runat="server" Z_FieldID="iMoneyBase"  />
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
    </div>
</asp:Content>

