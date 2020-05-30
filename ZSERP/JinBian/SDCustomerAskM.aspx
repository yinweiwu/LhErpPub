<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单据编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" 
                            Z_FieldType="日期" />
                    </td>
                    <td>
                        客户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        客户名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCustShortName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Height="46px" Width="716px" Z_FieldID="sRemark" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" Z_FieldType="时间" />
                    </td>
                    
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="询价明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDCustomerAskD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
