<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.DoNotCloseWinWhenSave = true;
            var center = $("#divContent").layout("panel", "center");
            $(center).panel(
            {
                content: "<iframe style='margin: 0; padding: 0' id='ifr' name='ifr' width='100%' height='100%' frameborder='0' src='FlowDesign.htm?key=" + Page.key + "'></iframe>"
            }
            )
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sUserID" />
                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dInputDate" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        唯一标识
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sIden" />
                    </td>
                    <td>
                        流程名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sName" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="300px" Z_FieldID="sRemark" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:true,split:true">
        </div>
    </div>
</asp:Content>
