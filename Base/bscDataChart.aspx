<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == 'add') {
                var sqlQuery = {
                    TableName: 'bscDataChartM',
                    Fields: 'max(iSerial) as m',
                    SelectAll: 'True'
                }
                var result = SqlGetData(sqlQuery);
                if (result && result.length > 0) {
                    var current = result[0].m == '' || result[0].m == null || result[0].m == undefined ? 0 : parseInt(result[0].m);
                    var next = current + 1;
                    Page.setFieldValue('iSerial', next);
                }
                else {
                    Page.setFieldValue('iSerial', 1);
                }
            }
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="height: 420px;">
            <div id="Div1" class="easyui-tabs" data-options="fit:true,border:false">
                <div title="基本定义">
                    <table class="tabmain">
                        <tr>
                            <td>
                                序号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Width="50px" Z_FieldID="iSerial"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                停用
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iDisabled" />
                            </td>
                            <td>
                                类型
                            </td>
                            <td>
                                <cc1:ExtSelect2 ID="ExtSelect21" runat="server" Z_FieldID="sType" Z_Options="柱状图;曲线图;饼状图" />
                            </td>
                            <td>
                                分组
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sGroup" Z_Required="True"
                                    Z_RequiredTip="分组不能为空" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                标题
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_Required="True" Z_RequiredTip="标题不能为空"
                                    Z_FieldID="sCaption" />
                            </td>
                            <td>
                                子标题
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sSubCaption" />
                            </td>
                            <td>
                                X轴标题
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sXTitle" />
                            </td>
                            <td>
                                Y轴标题
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sYTitle" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                宽度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sWidth" Z_FieldType="空" />
                            </td>
                            <td>
                                高度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sHeight" Z_FieldType="空" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_readOnly="True" Z_FieldID="sUserID" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_readOnly="True" Z_FieldID="dInputDate"
                                    Z_FieldType="时间" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                X轴坐标个数SQL
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Height="80px" Width="722px" Z_FieldID="sProjectSource" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                统计的条目数SQL
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Height="80px" Width="722px" Z_FieldID="sSerialSource" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                值数据源SQL<br />
                                （<br />
                                必须包含三个字段：<br />
                                第一个字段X轴坐标值,<br />
                                第二个字段为条目值,<br />
                                第三个字段为数值
                                <br />
                                ）
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Height="80px" Width="722px" Z_FieldID="sValueSql" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div title="数字格式化">
                    <table class="tabmain">
                        <tr>
                            <td>
                                <label for="__ExtCheckbox6">
                                    显示每根柱子值</label>
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox6" Z_FieldID="iShowValues" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="__ExtCheckbox4">
                                    是否格式化数值<br />
                                    (每千位用逗号分隔)</label>
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox4" Z_FieldID="iFormatNumber" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="__ExtCheckbox5">
                                    是否对大数值以k,M方式表示</label>
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                设置进位规则对应的单位<br />
                                (eg:k,m,b)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" Z_FieldID="sNumberScaleUnit" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                设置进位的规则<br />
                                (eg:1000,1000,1000)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldID="sNumberScaleValue" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数值前缀
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" Z_FieldID="sNumberPrefix" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数值后缀
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" Z_FieldID="sNumberSuffix" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                小数点后保留几位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="iDecimals" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="__ExtCheckbox3">
                                    小数位不足是否强制补0</label>
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" Z_FieldID="iForceDecimals" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                y轴值保留几位小数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" Z_FieldID="iYAxisValueDecimals" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center',border:false">
            <div id="tt" class="easyui-tabs" data-options="border:false,fit:true">
                <%--<div title="项定义" data-options="closable:false">
                    <table id="table1" tablename="bscDataChartD">
                    </table>
                </div>--%>
                <div title="权限分配" data-options="closable:false">
                    <table id="table2" tablename="bscDataChartDUser">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
