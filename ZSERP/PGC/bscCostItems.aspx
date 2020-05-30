<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
    </script>
    <style type="text/css">
        .style2
        {
            width: 287px;
        }
        .style3
        {
            width: 120px;
        }
        .style4
        {
            height: 40px;
        }
        .style5
        {
            height: 40px;
        }
        .style6
        {
            height: 45px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true" style="text-align: center;">
        <div data-options="region:'north',border:false">
            <table style="width: 100%; height: 100%; margin: 0px; padding: 0px;">
                <tr>
                    <td>
                        <!--隐藏字段-->
                        <div id="divHid" style="display: none;">
                            <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                            <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                            <%--<cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="sDeptID" />--%>
                        </div>
                        <!—如果只有一个主表，这里的north要变为center-->
                        <!--主表部分-->
                        <%--<table class="tabmain" style="margin: auto">--%>
                        <span style="font-size: 16px; width: 300px; height: 50px; line-height: 80px; display: block;">
                        </span>
                        <table border="0" style="border: 1px solid #B4CDCD; width: 93%; height: 130px;margin-left: 20px" cellpadding="0"
                            cellspacing="1">
							<tr>
                                <td class="style4">
                                    <table>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;费用编号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sCostID" style="width:260px; height:30px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="style4">
                                    <table>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;费用名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCostName" style="width:260px; height:30px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="style4">
                                    <table>
                                        <tr>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;是否年缴费&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                &nbsp;&nbsp;<cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iYearPay" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="style4">
                                    <table>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;支付对象&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iPayMan" style="width:260px; height:30px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="style5">
                                    <table>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;停用时间&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期"
                                                     style="width:260px; height:30px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="style6">
                                    <table>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sRemarks"  style="width:260px; height:30px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
