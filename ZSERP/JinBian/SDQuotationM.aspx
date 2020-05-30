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
                        报价单号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sBillNo" 
                            Z_readOnly="True" />
                    </td>
                    <td>
                        报价日期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="dDate" 
                            Z_FieldType="日期" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" 
                            z_fieldid="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        联系人
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="sPerson" />
                    </td>
                </tr>
                <tr>
                    <td>
                        起定量及起染量：</td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="690px" 
                            Z_FieldID="sStart" />
                    </td>
                </tr>
                <tr>
                    <td>
                        标准：</td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea22" runat="server" Width="690px" 
                            Z_FieldID="sStand" />
                    </td>
                </tr>
                <tr>
                    <td>
                        结算方式：</td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea23" runat="server" Width="690px" 
                            Z_FieldID="sFinishCode" />
                    </td>
                </tr>
                <tr>
                    <td>
                        目的地及费用：</td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea24" runat="server" Width="690px" 
                            Z_FieldID="sDestinationCost" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注</td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea25" runat="server" Width="690px" 
                            Z_FieldID="sRemarks" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sUserID" 
                            Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="dInputDate" 
                            Z_FieldType="时间" Z_readOnly="True" />
                    </td>
                     <td>
                        所属单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sCompany" style=" display:150px;" />
                    </td>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="报价明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDQuotationD">
                    </table>
                </div>
                
            </div>
        </div>
    </div>
</asp:Content>
