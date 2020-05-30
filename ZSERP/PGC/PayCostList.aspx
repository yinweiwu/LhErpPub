<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
    </script>
    <style type="text/css">
        .style1
        {
            width: 100px;
            text-align:left;
        }
        .style2
        {
            width: 287px;
        }
        .style3
        {
            height: 40px;
            padding:10px;
        }
        .style4
        {
            width: 88px;
            height: 40px;
        }
        .style5
        {
            width: 287px;
            height: 40px;
        }
        .style6
        {
            height: 40px;
        }
        .style7
        {
            width: 100px;
            height: 40px;
            text-align:left;
        }
        .style8
        {
            width: 100px;
            text-align:left;
        }
        .style9
        {
            height: 45px;
        }
        .style10
        {
            height: 48px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true" style="text-align: left;">
        <div data-options="region:'north',border:false">
            <table style="width: 100%; height: 100%; margin: 0px; padding: 0px;">
                <tr>
                    <td>
                        <!--隐藏字段-->
                        <div id="divHid" style="display: none;">
                            <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                            <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                            <cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="sDeptID" />
                            <cc1:ExtHidden2 ID="ExtHidden4" runat="server" Z_FieldID="iStatus" Z_Value="0" />
                            <cc1:ExtHidden2 ID="ExtHidden5" runat="server" Z_FieldID="iType" Z_Value="0" />
                            <cc1:ExtHidden2 ID="ExtHidden6" runat="server" Z_FieldID="sShopID" />
                            <cc1:ExtHidden2 ID="ExtHidden7" runat="server" Z_FieldID="sOperatorName" />
                            <cc1:ExtHidden2 ID="ExtHidden8" runat="server" Z_FieldID="sOperatorTel" />
                            <cc1:ExtHidden2 ID="ExtHidden9" runat="server" Z_FieldID="sOperatorCard" />
                        </div>
                        <!—如果只有一个主表，这里的north要变为center-->
                        <!--主表部分-->
                        <%-- <table class="tabmain" style="margin: auto">--%>
                        <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block;
                            margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第一步：</span>商铺信息导入
                        </span>
                        <table border="0" style="border: 1px solid #B4CDCD; width: 93%; margin-left: 50px"
                            cellpadding="0" cellspacing="1">
                            <tr>
                                <td class="style3">
                                    <table>
                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;缴费单号
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sBillNo" Width="260px"
                                                    Height="30px" Z_disabled="True" />
                                            </td>
                                            <td class="style8">
                                                商铺号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iBscShopRecNo" Width="260px"
                                                    Height="30px" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所有者&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sManagerName" Width="260px"
                                                    Height="30px" Z_disabled="True" />
                                            </td>
                                            <td class="style8">
                                                身份证号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sCard" Width="260px"
                                                    Height="30px" Z_disabled="True" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sTel" Width="260px"
                                                    Height="30px" Z_disabled="True" />
                                            </td>
                                            <td>
                                                单据类型&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Width="260px" Height="30px" Z_disabled="True"
                                                    Z_Value="年租金费用" />
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>
                            
                        </table>
                        <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block;
                            margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第二步：</span>商铺费用填写
                        </span>
                        <table border="0" style="border: 1px solid #B4CDCD; width: 93%; margin-left: 50px"
                            cellpadding="0" cellspacing="1">
                            <tr>
                                <td class="style3">
                                    <table>
                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年份
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iYear" Width="260px"
                                                    Height="30px" />
                                            </td>
                                            <td class="style8">
                                                截止日期
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="enddate" Width="260px"
                                                    Height="30px" Z_FieldType="日期" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;费用项目
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBscCostItemsRecNo" Width="260px"
                                                    Height="30px" />
                                            </td>
                                            <td class="style8">
                                                金额
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fTotal" Width="260px"
                                                    Height="30px" Z_FieldType="数值" Z_decimalDigits="2" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style8">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sRemark" Width="621px"
                                                    Height="30px" />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;开始月份
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBeginMonth" />
                                            </td>
                                            <td>
                                                截止月份
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sEndMonth" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <%-- </table>--%>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
