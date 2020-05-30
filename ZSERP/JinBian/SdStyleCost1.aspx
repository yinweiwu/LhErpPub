<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            getLowPrice(); getfPriceRate(); //报价利润率保持不变
        }
        Page.beforeLoad = function () {
            if (Page.usetype == "add") {
                var sqlobj1 = { TableName: "SysParam",
                    Fields: "fManager,fTaxRate,fLowSrate",
                    SelectAll: "True"
                }
                var data1 = SqlGetData(sqlobj1);

                Page.setFieldValue('fManagerRate', data1[0].fManager);
                Page.setFieldValue('fTaxRate', data1[0].fTaxRate);
                Page.setFieldValue('fLowProfit', data1[0].fLowSrate);
            }
            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj2 = { TableName: "vwSDStyleCostM",
                    Fields: "sName,sBscDataFabCode,fProductWidth,fProductWeight,iBscDataFabRecNo",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                    ]

                }
                var data2 = SqlGetData(sqlobj2);

                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);
                Page.setFieldValue('fProductWidth', data2[0].fProductWidth);
                Page.setFieldValue('fProductWeight', data2[0].fProductWeight);
                Page.setFieldValue('iBscDataFabRecNo', data2[0].iBscDataFabRecNo);
            }
        }
        $(function () {
            $('#__ExtTextBox_fProCost').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            //$('#__ExtTextBox_fManagerRate').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            $('#__ExtTextBox_fTaxRate').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            $('#__ExtTextBox_fLowProfit').textbox("textbox")[0].onkeyup = function () { getLowPrice(); }
            $('#__ExtTextBox_fPriceRate').textbox("textbox")[0].onkeyup = function () { getfPrice(); }
            $('#__ExtTextBox_fPrice').textbox("textbox")[0].onkeyup = function () { getfPriceRate(); }
            $('#__ExtTextBox_fWeaveLoss').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); }
            $('#__ExtTextBox_fDyeLoss').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); }
            $('#__ExtTextBox_fDyePrice').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); }
        })

        function getLowPrice() {
            var fMatCost = Page.getFieldValue("fMatCost");
            var fOtherCost = Page.getFieldValue("fOtherCost");
            var fProCost = $('#__ExtTextBox_fProCost').textbox("textbox").val();
            //var fManagerRate = $('#__ExtTextBox_fManagerRate').textbox("textbox").val();
            var fTaxRate = $('#__ExtTextBox_fTaxRate').textbox("textbox").val();
            var fLowProfit = $('#__ExtTextBox_fLowProfit').textbox("textbox").val();
            var fWeaveLoss = $('#__ExtTextBox_fWeaveLoss').textbox("textbox").val();
            var fDyeLoss = $('#__ExtTextBox_fDyeLoss').textbox("textbox").val();
            var fDyePrice = $('#__ExtTextBox_fDyePrice').textbox("textbox").val();
            if (fMatCost != "" && fOtherCost != "" && fProCost != "" && fTaxRate != "" && fLowProfit != "" && fWeaveLoss != "" && fDyeLoss != "" && fDyePrice != "") {
                //var fLowPrice = (Number(fMatCost) + Number(fOtherCost) + Number(fProCost)) / ((100 - Number(fManagerRate) - Number(fTaxRate) - Number(fLowProfit)) / 100);
                var fLowPrice = ((Number(fMatCost) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / (1 - Number(fLowProfit) / 100);
                Page.setFieldValue("fLowPrice", fLowPrice.toFixed(2));
            }
        }

        function getfPrice() {
            var fMatCost = Page.getFieldValue("fMatCost");
            var fOtherCost = Page.getFieldValue("fOtherCost");
            var fProCost = $('#__ExtTextBox_fProCost').textbox("textbox").val();
            //var fManagerRate = $('#__ExtTextBox_fManagerRate').textbox("textbox").val();
            var fTaxRate = $('#__ExtTextBox_fTaxRate').textbox("textbox").val();
            var fPriceRate = $('#__ExtTextBox_fPriceRate').textbox("textbox").val();
            var fWeaveLoss = $('#__ExtTextBox_fWeaveLoss').textbox("textbox").val();
            var fDyeLoss = $('#__ExtTextBox_fDyeLoss').textbox("textbox").val();
            var fDyePrice = $('#__ExtTextBox_fDyePrice').textbox("textbox").val();
            if (fMatCost != "" && fOtherCost != "" && fProCost != "" && fTaxRate != "" && fPriceRate != "" && fWeaveLoss != "" && fDyeLoss != "" && fDyePrice != "") {
                //var fPrice = (Number(fMatCost) + Number(fOtherCost) + Number(fProCost)) / ((100 - Number(fManagerRate) - Number(fTaxRate) - Number(fPriceRate)) / 100);
                var fPrice = ((Number(fMatCost) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / (1 - Number(fPriceRate) / 100);
                Page.setFieldValue("fPrice", fPrice.toFixed(2));
            }
        }

        function getfPriceRate() {
            var fMatCost = Page.getFieldValue("fMatCost");
            var fOtherCost = Page.getFieldValue("fOtherCost");
            var fProCost = $('#__ExtTextBox_fProCost').textbox("textbox").val();
            //var fManagerRate = $('#__ExtTextBox_fManagerRate').textbox("textbox").val();
            var fTaxRate = $('#__ExtTextBox_fTaxRate').textbox("textbox").val();
            var fPrice = $('#__ExtTextBox_fPrice').textbox("textbox").val();
            var fWeaveLoss = $('#__ExtTextBox_fWeaveLoss').textbox("textbox").val();
            var fDyeLoss = $('#__ExtTextBox_fDyeLoss').textbox("textbox").val();
            var fDyePrice = $('#__ExtTextBox_fDyePrice').textbox("textbox").val();
            if (fMatCost != "" && fOtherCost != "" && fProCost != "" && fTaxRate != "" && fPrice != "" && fWeaveLoss != "" && fDyeLoss != "" && fDyePrice != "") {
                //var fPriceRate = 100 - ((Number(fMatCost) + Number(fOtherCost) + Number(fProCost)) / Number(fPrice)) * 100 - Number(fManagerRate) - Number(fTaxRate);
                var fPriceRate = (1 - ((Number(fMatCost) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / Number(fPrice)) * 100;
                Page.setFieldValue("fPriceRate", fPriceRate.toFixed(2));
            }
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "SdStyleCostDMat") {
                if ((datagridOp.currentColumnName == "fRealQty" && changes.fRealQty) || (datagridOp.currentColumnName == "fPrice" && changes.fPrice)) {
                    getLowPrice();
                    getfPriceRate();
                }
            }
            if (tableid == "SdStyleCostDOther") {
                if ((datagridOp.currentColumnName == "fTotal" && changes.fTotal)) {
                    getLowPrice();
                    getfPriceRate();
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain" style=" margin-left: 0px; padding-left: 10px;">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td style="width: 10%;">
                        报价单号
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td style="width: 10%;">
                        客户
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td style="width: 10%;">
                        业务员
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSaleID" Width="150px" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%;">
                        报价日期
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td align="right">
                        产品编号
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="ibscDataMatRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataFabRecNo" Z_NoSave="True"
                            Style="display: none;" />
                    </td>
                    <td align="right">
                        产品名称
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        坯布编号
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td align="right">
                        幅宽
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fProductWidth" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td align="right">
                        克重
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fProductWeight" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
            <table class="tabmain" style="margin-left: 0px; padding-left: 10px;
                border-top: solid 1px #95b8e7;">
                <tr>
                    <td style="width: 10%;">
                        物料成本
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fMatCost" Z_readOnly="True"
                            Z_decimalDigits="2" />
                    </td>
                    <td style="width: 10%;">
                        其他费用
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fOtherCost" Z_readOnly="True"
                            Z_decimalDigits="2" />
                    </td>
                    <td style="width: 10%;">
                        织费
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fProCost" runat="server" Z_FieldID="fProCost" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%;">
                        织造损耗（%）
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fWeaveLoss" runat="server" Z_FieldID="fWeaveLoss"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td style="width: 10%;">
                        染色损耗（%）
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fDyeLoss" runat="server" Z_FieldID="fDyeLoss" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td style="width: 10%;">
                        染费
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fDyePrice" runat="server" Z_FieldID="fDyePrice" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        管理费（%）
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fManagerRate" runat="server" Z_FieldID="fManagerRate"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td align="right">
                        税费（%）
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fTaxRate" runat="server" Z_FieldID="fTaxRate" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td align="right">
                        最低利润率（%）
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fLowProfit" runat="server" Z_FieldID="fLowProfit"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        最低报价
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fLowPrice" runat="server" Z_FieldID="fLowPrice" Z_readOnly="True"
                            Z_decimalDigits="2" />
                    </td>
                    <td align="right">
                        报价
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fPrice" runat="server" Z_FieldID="fPrice" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td align="right">
                        报价利润率（%）
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fPriceRate" runat="server" Z_FieldID="fPriceRate"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr style="display: none;">
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
                </tr>
            </table>
            <table class="tabmain">
                <tr>
                    <td class="style2">
                        备注
                    </td>
                    <td class="style1">
                        <textarea id="sReMark" style="border-bottom: 1px solid black; width: 839px; border-left-style: none;
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
                <div data-options="fit:true" title="物料成本">
                    <!--  子表1  -->
                    <table id="SdStyleCostDMat" tablename="SdStyleCostDMat">
                    </table>
                </div>
                <div data-options="fit:true" title="其它费用">
                    <!--  子表2  -->
                    <table id="SdStyleCostDOther" tablename="SdStyleCostDOther">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
