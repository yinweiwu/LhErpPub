<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script language="javascript" type="text/javascript">
    
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        申请日期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="dDate" 
                            Z_FieldType="日期" />
                    </td>
                    <td>
                        会员
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="sCardNumber" />
                    </td>
                    <td>
                        申请积分
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="iAskIntegral" 
                            Z_FieldType="数值" />
                    </td>
                    <td>
                        申请人
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="sAskPerson" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="318px" 
                            Z_FieldID="sRemark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox7" runat="server" z_fieldid="sUserID" 
                            Z_readOnly="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox8" runat="server" z_fieldid="dInputDate" 
                            Z_FieldType="时间" Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
