<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        

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
                        备注类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sClassID" Z_Required="true" />
                    </td>
                     
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        备注内容
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sContent" Z_Required="true" Width="98%" />
                    </td>
                     
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea5" runat="server" Z_FieldID="sRemark"  Width="98%"/>
                    </td>
                     
                </tr>
                 
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sUserID"  Z_readOnly="true"/>
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dInputDate"    Z_readOnly="true"/>
                    </td>

                </tr>
            </table>
        </div>
    </div>
</asp:Content>
