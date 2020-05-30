<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 843px;
        }
        .style2
        {
            width: 72px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var rows = $("#SDSendD").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    var theRow = rows[i];
                    var fSumQty = isNaN(Number(rows[i].fSumQty)) ? 0 : Number(rows[i].fSumQty);
                    if (fSumQty > 0) {
                        theRow.fSumQty = -1 * (isNaN(Number(rows[i].fSumQty)) ? 0 : Number(rows[i].fSumQty));
                    }
                    var fPurQty = isNaN(Number(rows[i].fPurQty)) ? 0 : Number(rows[i].fPurQty);
                    if (fPurQty > 0) {
                        theRow.fPurQty = -1 * (isNaN(Number(rows[i].fPurQty)) ? 0 : Number(rows[i].fPurQty));
                    }
                    var fTotal = isNaN(Number(rows[i].fTotal)) ? 0 : Number(rows[i].fTotal);
                    if (fTotal > 0) {
                        theRow.fTotal = -1 * (isNaN(Number(rows[i].fTotal)) ? 0 : Number(rows[i].fTotal));
                    }
                    $("#SDSendD").datagrid("updateRow", { index: i, row: theRow });
                }
                Page.Children.ReloadFooter("SDSendD");
            }
        }
        lookUp.beforeOpen = function (uniqueid) {
            var istui = Page.getFieldValue("iRed");
            if (uniqueid == '354') {
                if (istui == '0') {
                    alert("退货通知方可点击！");
                    return false;
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
            </div>
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        通知单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        通知日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        计划出库日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        运输方式
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sTransType" />
                    </td>
                    <td>
                        包装方式
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPackageType" />
                    </td>
                    <td>
                        业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sSaleID" />
                    </td>
                    <td>
                        收货人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sPerson" />
                    </td>
                </tr>
                <tr>
                    <td>
                        联系方式
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        发货地址
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sAddress" />
                    </td>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
                    </td>
                    <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBillType" Style="display: none;" />
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Z_Required="False" Width="120px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="120px" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iRed" runat="server" />
                        <label for="__ExtCheckbox1">
                            退货通知</label>
                        &nbsp;&nbsp;
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iRep" runat="server" />
                        <label for="__ExtCheckbox2">
                            外加厂直发</label>
                    </td>
                    <td>
                        所属单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sCompany" Style="display: 150px;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        发货单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sSendCompany" Style="display: 150px;" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iSample" />
                        <label for="__ExtCheckbox3">
                            是否样品发货</label>
                    </td>
                </tr>
            </table>
            <table class="tabmain">
                <tr>
                    <td class="style2">
                        备注
                    </td>
                    <td class="style1">
                        <textarea id="sbarcoderemark" style="border-bottom: 1px solid black; width: 839px;
                            border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                            border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                            border-top-style: none; border-top-color: inherit; border-top-width: 0px;" fieldid="sReMark"></textarea>
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
