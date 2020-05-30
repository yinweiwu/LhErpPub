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
                    TableName: "vwSDContractM",
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
                    //if (result[0].iOrderType == "1") {
                    //    orderInfo += "客户合同\r\n--------------------\r\n";
                    //    isFab = false;
                    //}
                    //if (result[0].iOrderType == "2") {
                    //    orderInfo += "客户合同（坯布）\r\n--------------------\r\n";
                    //    isFab = true;
                    //}
                    //orderInfo += "客户订单\r\n--------------------\r\n";
                    //if (sType == "合同主表变更" || sType == "全部变更" || sType == "订单取消") {
                    orderInfo += "客户：【" + result[0].sCustShortName + "】\r\n";
                    orderInfo += "订单号：【" + result[0].sOrderNo + "】 " + "客户订单号：【" + result[0].sContractNo + "】\r\n";
                    orderInfo += "签单日期：【" + result[0].dDate + "】 销售单位：【" + result[0].sSaleUnitName + "】\r\n";
                    orderInfo += "订单交期：【" + result[0].dOrderDate + "】 业务员：【" + result[0].sSaleName + "】\r\n--------------------\r\n";
                    //}

                    //if (sType == "产品明细变更" || sType == "订单取消" || sType == "全部变更") {
                    var sqlObj1 = {
                        TableName: "vwSDContractD",
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
                        for (var i = 0; i < result1.length; i++) {
                            orderInfo += "产品编号：【" + result1[0].sCode + "】 产品名称：【" + result1[0].sName + "】 ";
                            orderInfo += "序列号：【" + result1[i].sSerial + "】 色号：【" + result1[i].sColorID + "】 颜色：【" + result1[i].sColorName + "】 花型编号：【" + result1[i].sFlowerTypeID + "】 花型：【" + result1[i].sFlowerType + "】 幅宽：【" + result1[i].fProductWidth + "】 克重：【" + result1[i].fProductWeight + "】 单价：【" + result1[i].fPrice + "】 数量：【" + result1[i].fQty + "】 金额：【" + result1[i].fTotal + "】\r\n";
                        }
                        //                            if (sType == "单价变更") {
                        //                                for (var i = 0; i < result1.length; i++) {
                        //                                    orderInfo += "色号：【" + result1[i].sColorID + "】 颜色：【" + result1[i].sColorName + "】 单价：【" + result1[i].fPrice + "】\r\n";
                        //                                }
                        //                            }
                        //                            else {
                        //                                orderInfo += "产品编号：【" + result[0].sCode + "】 产品名称：【" + result[0].sName + "】 坯布编号：【" + result[0].sBscDataFabCode + "】\r\n";
                        //                                orderInfo += "计量单位：【" + result[0].sUnitSaleName + "】 订单类型：【" + result[0].sOrderType + "】\r\n";
                        //                                for (var i = 0; i < result1.length; i++) {
                        //                                    orderInfo += "色号：【" + result1[i].sColorID + "】 颜色：【" + result1[i].sColorName + "】 单价：【" + result1[i].fPrice + "】 数量：【" + result1[i].fSumQty + "】 金额：【" + result1[i].fTotal + "】\r\n";
                        //                                }
                        //                            }
                    }
                    //}
                    //                    if (sType == "其他费用变更") {
                    //                        orderInfo += "其他费用\r\n--------------------\r\n";
                    //                        var sqlObj2 = {
                    //                            TableName: "SDOrderDOtherCost",
                    //                            Fields: "*",
                    //                            SelectAll: "True",
                    //                            Filters: [
                    //                                {
                    //                                    Field: "iMainRecNo",
                    //                                    ComOprt: "=",
                    //                                    Value: "'" + iSdOrderMRecNo + "'"
                    //                                }
                    //                            ],
                    //                            Sorts: [
                    //                                {
                    //                                    SortName: "iSerial",
                    //                                    SortOrder: "asc"
                    //                                }
                    //                            ]
                    //                        }
                    //                        var result2 = SqlGetData(sqlObj2);
                    //                        if (result2.length > 0) {
                    //                            for (var i = 0; i < result2.length; i++) {
                    //                                orderInfo += "费用项目：【" + result2[i].sCostName + "】 单位：【" + result2[i].sUnitName + "】 单价：【" + result2[i].fPrice + "】 数量：【" + result2[i].iQty + "】 金额：【" + result2[i].fTotal + "】\r\n";
                    //                            }
                    //                        }
                    //                    }
                }
                Page.setFieldValue("sOriOrderInfo", orderInfo);
            }
        }

        Page.beforeSave = function () {

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
                        <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sType" Z_Options=";主表信息变更;子表次要信息变更;子表重要信息变更;订单取消" />
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
                        
                    </td>
                </tr>
            </table>
            <div>
                <p style="color: Red; font-size: 14px; margin-left: 50px;">
                            变更类型说明：
                        </p>
                        <p style="color: Red; font-size: 14px; margin-left: 50px;">
                            1、变更只对客户订单主信息起作用，对生产与包装要求、批次信息无效；<br />
                            2、主表信息变更：可修改客户订单中主表的内容，不需要经过生产、计划审批；<br />
                            3、子表次要信息变更：可修改子表中的次要信息，如唛头门幅、克重、单价、客户要求、备注、客户颜色、客户品名等，这些信息不影响计划和生产；<br />
                            4、子表重要信息变更：可修改子表中的关键信息，如品名、颜色、序列号、工序、工艺、幅宽、克重、数量等，这些信息会影响计划和生产，系统根据订单所处的环节发送给相关负责人审批，都审批同意了才可变更<br />
                            5、以上变更方式复杂度逐步增加，但是下一级别变更方式包含上一级别，也就是说如果是“子表重要信息变更”，则也可以进行主表信息变更和子表次要信息变更；<br />
                            6、订单取消：将订单标记为取消状态、将无法查询此订单信息；<br />
                            7、子表重要信息变更、订单取消计划和生产同意后，相关的计划单据、生产单据自动撤销为未提交状态；<br />
                            请选择正确的变更类型！
                        </p>
            </div>
        </div>
    </div>
</asp:Content>
