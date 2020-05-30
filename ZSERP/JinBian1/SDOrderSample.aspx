<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
        $(function () {
            if (Page.usetype == "add") {
                Page.setFieldValue("iBillType", getQueryString("iBillType"));
            }
            $('#__ExtTextBox_iUnitID').combobox({
                onSelect: function (rec) { SeliUnitID(); }
            });
        })

        function SeliUnitID() {
            var rows = $("#SDOrderD").datagrid("getRows");
            if (rows.length > 0) {
                var iUnitID = Page.getFieldValue("iUnitID");
                var fProductWidth = Page.getFieldValue("fProductWidth");
                var fProductWeight = Page.getFieldValue("fProductWeight");
                var main_fTotal = 0;
                if (iUnitID != "" && fProductWidth != "" && fProductWeight != "") {
                    for (var i = 0; i < rows.length; i++) {
                        var fSumQty = rows[i].fSumQty;
                        var fWaste = rows[i].fWaste;
                        var fUseFalg = rows[i].fUseFalg;
                        if (fSumQty != "") {
                            var fWeight = 0;
                            if (iUnitID == "1") {
                                fWeight = Number(fProductWidth) / 100 * Number(fSumQty) * Number(fProductWeight) / 1000
                            }
                            else if (iUnitID == "2") {
                                fWeight = Number(fProductWidth) / 100 * Number(fSumQty) * 0.9144 * Number(fProductWeight) / 1000
                            }
                            else if (iUnitID == "0") {
                                fWeight = Number(fSumQty);
                            }
                            rows[i].fWeight = fWeight;
                            var fPrice = rows[i].fPrice;
                            if (fPrice != "") {
                                var fTotal = Number(fSumQty) * Number(fPrice)
                                rows[i].fTotal = fTotal;
                                main_fTotal += fTotal;
                            }
                            var fRealFab = (isNaN(Number(fWeight)) ? 0 : Number(fWeight)) / (1 - (isNaN(Number(fWaste / 100)) ? 0 : Number(fWaste / 100))) - (isNaN(Number(fUseFalg)) ? 0 : Number(fUseFalg));
                            $('#SDOrderD').datagrid('updateRow', {
                                index: i,
                                row: { fWeight: fWeight, fTotal: fTotal, fRealFab: fRealFab }
                            });
                        }
                    }
                    Page.setFieldValue('fTotal', main_fTotal);
                    Page.Children.ReloadFooter("SDOrderD");
                }
            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "SDOrderD") {
                if (datagridOp.currentColumnName == "fSumQty") {
                    SeliUnitID();
                }
            }
        }

        Page.afterSave = function () {
            //(isNaN(Number(fWeight)) ? 0 : Number(fWeight)) / (1 - (isNaN(Number(fWaste / 100)) ? 0 : Number(fWaste / 100))) - (isNaN(Number(fFabStockQty)) ? 0 : Number(fFabStockQty));
        }
        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "dOrderDate") {
                    var dOrderDate = Page.getFieldValue("dOrderDate");
                    Page.setFieldValue("dProduceDate", dOrderDate);
                }
            }
        }
        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1586") {
                var allRows = $("#SDOrderD").datagrid("getRows");
                var fFabStockQty = Page.getFieldValue("fFabStockQty");
                //alert(fFabStockQty);
                for (var i = 0; i < allRows.length; i++) {
                    $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabStockQty: fFabStockQty} });
                }
            }
        }
        Page.Children.onLoadSuccess = function (tableid, data) {
            if (tableid == "SDOrderD") {
                if (Page.usetype != "add") {
                    var allRows = $("#SDOrderD").datagrid("getRows");
                    var fFabStockQty = Page.getFieldValue("fFabStockQty");
                    for (var i = 0; i < allRows.length; i++) {
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabStockQty: fFabStockQty} });
                    }
                }
            }
        }
        Page.Children.onAfterAddRow = function (tableid) {
            var allRows = $("#SDOrderD").datagrid("getRows");
            var fFabStockQty = Page.getFieldValue("fFabStockQty");
            for (var i = 0; i < allRows.length; i++) {
                $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabStockQty: fFabStockQty} });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sDeptID" />
                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fQty" Style="display: none;" />
                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iOrderType" Style="display: none;" />
                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSaleID" Style="display: none;" />
                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fFabQty" Z_FieldType="数值" />
                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataMatFabRecNo"
                    Style="display: none;" />
                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期" />
                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fFabStockQty" Z_NoSave="true" />
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        试样单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Z_Required="True" />
                    </td>
                    <td>
                        试样日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldType="日期" Z_FieldID="dDate"
                            Z_Required="True" />
                    </td>
                    <td>
                        寄样类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sSampleType" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox_iBscDataMatRecNo" runat="server" Z_FieldID="iBscDataMatRecNo"
                            Z_Required="True" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        幅宽（cm）
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                    </td>
                    <td>
                        克重（g/㎡）
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户品名
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sCustomerProductNo" />
                    </td>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox_iUnitID" runat="server" Z_FieldID="iUnitID" Z_Required="True" />
                    </td>
                    <td>
                        匹重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sRollWeight" Z_decimalDigits="0"
                            Z_FieldType="整数" />
                    </td>
                </tr>
                <tr>
                    <td>
                        总金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fTotal" Z_readOnly="True"
                            Z_Required="False" Width="120px" Z_FieldType="数值" Z_disabled="False" Z_decimalDigits="2" />
                    </td>
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
                    <td>
                        坯布单价
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" Z_FieldID="fFabPrice" runat="server" Z_decimalDigits="2"
                            Z_FieldType="数值" />
                    </td>
                </tr>
                <tr>
                    <td>
                        要求完成日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan="5">
                        <textarea id="sReMark" style="border-bottom: 1px solid black; width: 550px; border-left-style: none;
                            border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                            border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                            border-top-color: inherit; border-top-width: 0px;" fieldid="sReMark"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="SDOrderD" tablename="SDOrderD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
