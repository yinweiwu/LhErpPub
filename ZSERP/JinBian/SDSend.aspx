﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1 {
            width: 843px;
        }

        .style2 {
            width: 72px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        //        Page.Children.onEndEdit = function (tableid, index, row, changes) {
        //            if (tableid == "SDSendD") {
        //                if ((datagridOp.currentColumnName == "fPrice" || datagridOp.currentColumnName == "fSumQty" || datagridOp.currentColumnName == "fTotal" || datagridOp.currentColumnName == "fSmallVatCost" || datagridOp.currentColumnName == "fSampleCost")) {
        //                    var rows = $("#SDSendD").datagrid("getRows");
        //                    var total = 0;
        //                    for (var i = 0; i < rows.length; i++) {
        //                        var fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
        //                        var fSumQty = isNaN(parseFloat(rows[i].fSumQty)) ? 0 : parseFloat(rows[i].fSumQty);
        //                        var fSmallVatCost = isNaN(parseFloat(rows[i].fSmallVatCost)) ? 0 : parseFloat(rows[i].fSmallVatCost);
        //                        var fSampleCost = isNaN(parseFloat(rows[i].fSampleCost)) ? 0 : parseFloat(rows[i].fSampleCost);
        //                        total = total + fPrice * fSumQty + fSampleCost + fSmallVatCost;
        //                    }
        //                    Page.setFieldValue("fTotal", total);
        //                }
        //            }
        //        }
        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var rows = $("#SDSendD").datagrid("getRows");
                if (Number(rows[0].fSumQty) > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        var theRow = rows[i];
                        theRow.fSumQty = -1 * Number(rows[i].fSumQty);
                        theRow.fPurQty = -1 * (isNaN(Number(rows[i].fPurQty)) ? 0 : Number(rows[i].fPurQty));
                        theRow.fTotal = -1 * Number(rows[i].fTotal);
                        $("#SDSendD").datagrid("updateRow", { index: i, row: theRow });
                    }
                    Page.Children.ReloadFooter("SDSendD");
                }
            }

            var rows = $("#SDSendD").datagrid("getRows");

            for (var i = 0; i < rows.length; i++) {
                var price = rows[i].fPrice;
                var price1 = rows[i].fOrderPrice;
                if (Page.getFieldValue("iSample") != "1") {
                    if (price != price1) {
                        var sOrderNo = rows[i].sOrderNo == undefined || rows[i].sOrderNo == null || rows[i].sOrderNo == "" ? "" : rows[i].sOrderNo;
                        if (sOrderNo != "") {
                            alert("订单单价不等，请修改");
                            return false;
                        }
                    }
                }
            }
        }
        lookUp.beforeOpen = function (uniqueid) {
            var istui = Page.getFieldValue("iRed");
            if (uniqueid == '352') {
                if (istui == '0') {
                    alert("退货通知方可点击！");
                    return false;
                }
            }
        }
        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (datagridOp.clickColumnName == "fPrice") {
                if (Page.getFieldValue("iSample") != "1") {
                    alert("只有样品发货才能修改单价！");
                    return false;
                }
            }
        }
        dataForm.beforeOpen = function (uniqueid) {
            if (uniqueid == "366") {
                var istui = Page.getFieldValue("iRed");
                if (istui == '0') {
                    alert("退货通知方可点击！");
                    return false;
                }
            }
        }
        dataForm.afterSelected = function (uniqueid) {
            if (uniqueid == "366") {
                var allRows = $("#SDSendD").datagrid("getRows");
                for (var i = 0; i < allRows.length; i++) {
                    var fSumQty = isNaN(parseFloat(allRows[i].fSumQty)) ? 0 : parseFloat(allRows[i].fSumQty);
                    var fPurQty = isNaN(parseFloat(allRows[i].fPurQty)) ? 0 : parseFloat(allRows[i].fPurQty);
                    var iQty = isNaN(parseInt(allRows[i].iQty)) ? 0 : parseInt(allRows[i].iQty);
                    var fTotal = isNaN(parseInt(allRows[i].fTotal)) ? 0 : parseInt(allRows[i].fTotal);
                    $("#SDSendD").datagrid("updateRow", { index: i, row: { fSumQty: -1 * fSumQty, fPurQty: -1 * fPurQty, iQty: -1 * iQty, fTotal: -1 * fTotal } });
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBillType" />
            </div>
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>通知单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>通知日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>计划出库日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期" />
                    </td>
                    <td>客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td rowspan="4">
                        <div class="easyui-panel" data-options="title:'运输物流',width:350" style="text-align:center;">
                            <table style="margin:auto;">
                                <tr>
                                    <td>运输方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sTransType" style="width:100px;" />
                                    </td>
                                    <td>包装方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPackageType" style="width:100px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>收货人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sPerson" style="width:100px;" />
                                    </td>
                                    <td>联系方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sTel" style="width:100px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>收货地址
                                    </td>
                                    <td colspan="3">
                                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" style="width:99%" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sSaleID" />
                    </td>
                    <td>数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="True" />
                    </td>
                    <td>金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="True" />
                    </td>
                    <td colspan="1">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iRed" runat="server" />
                        <label for="__ExtCheckbox1">
                            是否退货通知</label>
                    </td>
                    <td colspan="1">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iSample" runat="server" />
                        <label for="__ExtCheckbox2">
                            是否样品发货</label>
                    </td>
                </tr>
                <tr>
                    <td>信用额度
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fLowTotal" Z_readOnly="True"
                            Width="120px" Z_NoSave="True" />
                    </td>
                    <td>客户余额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fShouldReceTotal" Z_readOnly="True"
                            Width="120px" Z_NoSave="True" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" />
                    </td>
                </tr>
                <tr>
                    <td>备注</td>
                    <td colspan="5">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" Style="width: 99%;" Z_FieldID="sReMark" runat="server" />
                    </td>
                    <td>发货仓库</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                </tr>

            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="通知明细">
                    <!--  子表1  -->
                    <table id="SDSendD" tablename="SDSendD">
                    </table>
                </div>
                <%-- <div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
