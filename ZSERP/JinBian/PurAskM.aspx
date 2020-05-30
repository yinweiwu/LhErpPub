<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.beforeInit = function () {
            var iMatType = getQueryString("iMatType");
            if (iMatType != "2") {
                $("#PurAskDRemark").remove();
            }
        }
        $(function () {
            if (Page.usetype == "modify") {
                $("#tabTop").tabs("select", "物料采购申请单");
            }
            var iMatType = getQueryString("iMatType");
            Page.setFieldValue('iMatType', iMatType);
            if (getQueryString("iMatType") == "1" || getQueryString("iMatType") == "2") {
                //                Page.Children.toolBarBtnDisabled("PurAskD", "add");
                //                Page.Children.toolBarBtnDisabled("PurAskD", "copy");
            }
            if (Page.usetype == "add") {
                if (iMatType == "2") {
                    var sremarkArr = [
                        {
                            iSerial: 1,
                            sRemark: "物料必须符合环保纺织物品标准及符合oeko-tex standard标准"
                        },
                        {
                            iSerial: 2,
                            sRemark: "每色每缸须提供2-3YD批色及测试，确认后方式可出货"
                        },
                        {
                            iSerial: 3,
                            sRemark: "出货前每匹布上麦头须注明合同号，匹号，缸号，规格，净重/毛重，长度等资料"
                        },
                        {
                            iSerial: 4,
                            sRemark: "请控制交货数量，允收范围±3%以内，克重按受范围±5G/M2以内"
                        },
                        {
                            iSerial: 5,
                            sRemark: "如因品质问题或时间等因素影响我司交期，由此造成的损失由贵司全额承担"
                        },
                        {
                            iSerial: 6,
                            sRemark: "布面品质，不得出现竖条/横条/拆痕/色花/污胜/破洞/等异常问题"
                        }
                        ,
                        {
                            iSerial: 7,
                            sRemark: "色牢度必须达到3-4级，测试标准，SGS测试"
                        }
                        ,
                        {
                            iSerial: 8,
                            sRemark: "风格跟时来样"
                        },
                        {
                            iSerial: 9,
                            sRemark: ""
                        },
                        {
                            iSerial: 10,
                            sRemark: ""
                        }
                    ]
                    for (var i = 0; i < sremarkArr.length; i++) {
                        Page.tableToolbarClick("add", "PurAskDRemark", sremarkArr[i]);
                    }
                }
            }
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table class="tabmain">
                <tr>
                    <td>
                        申请单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        申请日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        需求日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dNeedDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        申购员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        申请部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sDeptID" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan='5'>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="98%" Z_FieldID="sReMark" />
                    </td>
                    <td style="display: none">
                        存货类型
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iMatType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldType="数值" runat="server" Z_FieldID="fQty"
                            Z_readOnly="True" />
                    </td>
                    <%--<td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fTotal" 
                            Z_FieldType="数值" Z_readOnly="True" />
                    </td>--%>
                    <td>
                        所属单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sCompany" />
                    </td>
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
                    <table id="PurAskD" tablename="PurAskD">
                    </table>
                </div>
                <div data-options="fit:true" title="明细备注">
                    <table id="PurAskDRemark" tablename="PurAskDRemark">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
