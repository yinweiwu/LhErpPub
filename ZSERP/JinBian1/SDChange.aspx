<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var isFab = false;
        $(function () {

        })
        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "sType") {
                    getOrderInfo();
                }
            }
        }

        lookUp.afterSelected = function () {
            getOrderInfo();
        }

        function getOrderInfo() {
            var sType = Page.getFieldValue("sType");
            var iSdOrderMRecNo = Page.getFieldValue("iSdOrderMRecNo");
            var orderInfo = "";
            if (sType != "" && iSdOrderMRecNo != "") {
                var sqlObj = {
                    TableName: "vwSDOrderM_GMJ",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + iSdOrderMRecNo + "'"
                    }
                ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    if (result[0].iBillType == "1") {
                        orderInfo += "成品销售订单\r\n--------------------\r\n";
                        isFab = false;
                    }
                    if (result[0].iBillType == "2") {
                        orderInfo += "坯布销售订单\r\n--------------------\r\n";
                        isFab = true;
                    }
                    if (sType == "客户信息变更") {
                        orderInfo += "客户：【" + result[0].sCustShortName + "】\r\n";
                        orderInfo += "付款方式：【" + result[0].sPayType + "】\r\n";
                    }

                    if (sType == "单价变更" || sType == "数量变更" || sType == "订单取消" || sType == "颜色变更") {
                        var sqlObj1 = {
                            TableName: "vwSDOrderD_GMJ",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + iSdOrderMRecNo + "'"
                            }
                            ]
                        }
                        var result1 = SqlGetData(sqlObj1);
                        if (result1.length > 0) {
                            if (sType == "单价变更") {
                                for (var i = 0; i < result1.length; i++) {
                                    orderInfo += "色号：【" + result1[i].sColorID + "】 颜色：【" + result1[i].sColorName + "】 单价：【" + result1[i].fPrice + "】\r\n";
                                }
                            }
                            else {
                                orderInfo += "产品编号：【" + result[0].sCode + "】 产品名称：【" + result[0].sName + "】 坯布编号：【" + result[0].sBscDataFabCode + "】\r\n";
                                orderInfo += "计量单位：【" + result[0].sUnitSaleName + "】 订单类型：【" + result[0].sOrderType + "】\r\n";
                                for (var i = 0; i < result1.length; i++) {
                                    orderInfo += "色号：【" + result1[i].sColorID + "】 颜色：【" + result1[i].sColorName + "】 单价：【" + result1[i].fPrice + "】 数量：【" + result1[i].fSumQty + "】 金额：【" + result1[i].fTotal + "】\r\n";
                                }
                            }
                        }
                    }
                    if (sType == "其他费用变更") {
                        orderInfo += "其他费用\r\n--------------------\r\n";
                        var sqlObj2 = {
                            TableName: "SDOrderDOtherCost",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: "'" + iSdOrderMRecNo + "'"
                                }
                            ],
                            Sorts: [
                                {
                                    SortName: "iSerial",
                                    SortOrder: "asc"
                                }
                            ]
                        }
                        var result2 = SqlGetData(sqlObj2);
                        if (result2.length > 0) {
                            for (var i = 0; i < result2.length; i++) {
                                orderInfo += "费用项目：【" + result2[i].sCostName + "】 单位：【" + result2[i].sUnitName + "】 单价：【" + result2[i].fPrice + "】 数量：【" + result2[i].iQty + "】 金额：【" + result2[i].fTotal + "】\r\n";
                            }
                        }
                    }
                }
                Page.setFieldValue("sOriOrderInfo", orderInfo);
            }
        }

        Page.beforeSave = function () {
            if (isFab == true) {
                var changeType = Page.getFieldValue("sType");
                if (changeType == "颜色变更") {
                    alert("坯布销售订单号不能变更颜色！");
                    return false;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain" style="margin: 10px;">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        变更单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        申请日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        变更类型
                    </td>
                    <td>
                        <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sType" Z_Options=";客户信息变更;单价变更;数量变更;颜色变更;其他费用变更;订单取消" />
                    </td>
                    <td>
                        变更订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iSdOrderMRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        原订单信息
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Height="108px" Width="686px" Z_FieldID="sOriOrderInfo"
                            Z_readOnly="true" />
                    </td>
                </tr>
                <tr>
                    <td>
                        变更原因
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Height="108px" Width="686px"
                            Z_FieldID="sChangReson" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="8">
                        <p style="color: Red; font-size: 14px; margin-left: 50px;">
                            变更类型说明：
                        </p>
                        <p style="color: Red; font-size: 14px; margin-left: 50px;">
                            1、客户信息变更：可修改订单中的客户、付款方式；<br />
                            2、单价变更：可修改订单中的单价；<br />
                            3、数量变更：可修改订单中的产品编号、单价、数量、计量单位,订单类型；<br />
                            4、颜色变更：可修改订单中的色号；<br />
                            5、其他费用变更：可修改订单中其他费用（如小缸费）;<br />
                            6、订单取消：可删除订单<br />
                            请选择正确的变更类型！
                        </p>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
