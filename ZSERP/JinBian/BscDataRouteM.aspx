<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            
        })

        Page.beforeSave = function () {
            var rows = $("#BscDataRouteD").datagrid("getRows");
            if (Page.getFieldValue("sName") == "") {
                var ss = "";
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sProcessesName) {
                        if (ss) {
                            ss = ss + "->" + rows[i].sProcessesName;
                        } else {
                            ss = rows[i].sProcessesName;
                        }
                    }
                }
                Page.setFieldValue("sName", ss);
            }
        }
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
   <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            
            <table class="tabmain">
                <tr>
                    <td>
                        编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" Z_Required="true"/>
                    </td>
                    <td>
                        名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sName"  Z_Required="true" />
                    </td>
                   
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sRemark" width="600px"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <table id="BscDataRouteD" tablename="BscDataRouteD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
