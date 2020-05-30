<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .textarea
        {
            border: none;
            border: solid 1px #95b8e7;
            overflow: auto; /*border-radius: 5px;*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false" style="margin-top: 20px;">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sUserID" />
                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dInputDate" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        提醒内容
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" title="说明：用{count}表示数字" Z_FieldID="sTitle"
                            Style="width: 660px" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        数量Sql
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextArea2 ID="ExtTextArea2" title="说明：用select返回提醒标题中的{count}，返回的结果中，只有第一行第一列生效"
                            runat="server" Style="width: 660px; height: 80px;" Z_FieldID="sCountSql" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        目标菜单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Style="width: 144px" Z_FieldID="iMenuID" />
                    </td>
                    <td>
                        目标表单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Style="width: 144px" Z_FieldID="iFormID"
                            Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        目标表单名
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Style="width: 144px" Z_FieldID="sMenuName"
                            Z_readOnly="true" Z_NoSave="true" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        过滤条件
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextArea2 ID="ExtTextArea3" title="说明：是放在目标表单后的查询条件，如果目标表单是通用查询，则替换{condition}；如果存储过程，则替换参数值；<br />如果是表单，则是对整个主表SQL后加查询条件"
                            runat="server" Height="80px" Width="660px" Z_FieldID="sFilters" />
                        <br />
                        <span style="color: Red;"></span>
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        权限人员(SQL)
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextArea2 ID="ExtTextArea4" title="说明：Sql可返回多个人" runat="server" Height="80px"
                            Width="660px" Z_FieldID="sRightSql" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td colspan="6">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iDisabled" />
                        <label for="__ExtCheckbox1">
                            停用</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <fieldset>
                            <legend>app端</legend>
                            <table>
                                <tr>
                                    <td>
                                        提醒标题
                                    </td>
                                    <td colspan="5">
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sTitleSimple" Style="width: 300px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        关联手机报表
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sAppMenuID" />
                                    </td>
                                    <td>
                                        关联手机路径
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sAppUrl" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="图片" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </div>
        <%--<div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="权限分配">
                    <!--  子表1  -->
                    <table id="table1" tablename="SysRemindD">
                    </table>
                </div>
            </div>
        </div>--%>
    </div>
</asp:Content>
