<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div>
                <img src="images/flsx.png" width="2.5%" />
                <div style="margin: -15px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 35px; margin: -25px auto">
                    <span style="font-family: 黑体; font-size: 15px">分类属性</span>
                </div>
            </div>
            <br />
            <br />
            <table class="tabmain" style="height: 250px">
                <tr>
                    <td>
                        物料分类编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sClassID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong style="color: Red">属性名称</strong>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sPropertyName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        顺序
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iSerial" Z_FieldType="整数" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="80%" />
                    </td>
                </tr>
                <tr>
                    <td>
                        用户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="分类属性定义明细表">
                    <table id="table1" tablename="bscDataClassPropertyD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
