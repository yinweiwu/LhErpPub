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
            $('#__ExtTextBox_fProCost').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            //$('#__ExtTextBox_fManagerRate').textbox("textbox")[0].onkeyup = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            $('#__ExtTextBox_fTaxRate').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); } //报价利润率保持不变
            $('#__ExtTextBox_fLowProfit').textbox("textbox")[0].onchange = function () { getLowPrice(); }
            $('#__ExtTextBox_fPriceRate').textbox("textbox")[0].onchange = function () { getfPrice(); }
            $('#__ExtTextBox_fPrice').textbox("textbox")[0].onchange = function () { getfPriceRate(); }
            $('#__ExtTextBox_fWeaveLoss').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); }
            $('#__ExtTextBox_fDyeLoss').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); }
            $('#__ExtTextBox_fDyePrice').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); }
            $('#__ExtTextBox9').textbox("textbox")[0].onchange = function () { getLowPrice(); getfPriceRate(); }
            if (Page.usetype == "add") {
                var from = getQueryString("from1");
                if (from == "order") {
                    var iBscDataMatRecNo = getQueryString("iBscDataMatRecNo");
                    var iBscDataMatFabRecNo = getQueryString("iBscDataMatFabRecNo");
                    var fProductWidth = getQueryString("fProductWidth");
                    var fProductWeight = getQueryString("fProductWeight");
                    var iBscDataCustomerRecNo = getQueryString("iBscDataCustomerRecNo");

                    Page.setFieldValue("ibscDataMatRecNo", iBscDataMatRecNo);
                    Page.setFieldValue("iBscDataMatFabRecNo", iBscDataMatFabRecNo);
                    Page.setFieldValue("fProductWidth", fProductWidth);
                    Page.setFieldValue("fProductWeight", fProductWeight);
                    Page.setFieldValue("iBscDataCustomerRecNo", iBscDataCustomerRecNo);
                }
            }
            else {
                var meter = 0;
                var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                if (fProductWeight > 0 && fProductWidth > 0) {
                    meter = 1000 / fProductWeight / (fProductWidth / 100);
                }
                var fLowPrice = Number(Page.getFieldValue("fLowPrice"));
                Page.setFieldValue("fLowPriceMeter", fLowPrice / meter);
                Page.setFieldValue("fLowPriceMeterY", fLowPrice / (meter / 0.9144));
            }
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
            var fTransformCost = $('#__ExtTextBox9').textbox("textbox").val();
            if (fMatCost != "" && fOtherCost != "" && fProCost != "" && fTaxRate != "" && fLowProfit != "" && fWeaveLoss != "" && fDyeLoss != "" && fDyePrice != "" && fTransformCost != "") {
                //var fLowPrice = (Number(fMatCost) + Number(fOtherCost) + Number(fProCost)) / ((100 - Number(fManagerRate) - Number(fTaxRate) - Number(fLowProfit)) / 100);
                //var fLowPrice = (((Number(fMatCost) + Number(fTransformCost)) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / (1 - Number(fLowProfit) / 100);
                var meter = 0;
                var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                if (fProductWeight > 0 && fProductWidth > 0) {
                    meter = 1000 / fProductWeight / (fProductWidth / 100);
                }
                else {
                    //Page.MessageShow("没有幅度克重", "没有幅度克重，无法计算米价、码价");
                }

                var fLowPrice = 0;
                var sUnitID = Page.getFieldValue("sUnitID");
                if (sUnitID == "0") {
                    fLowPrice = (((Number(fMatCost) + Number(fTransformCost)) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / (1 - Number(fLowProfit) / 100);

                }
                else if (sUnitID == "1") {
                    fLowPrice = (((Number(fMatCost) + Number(fTransformCost)) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + (Number(fOtherCost) / meter)) * (1 + Number(fTaxRate) / 100) / (1 - Number(fLowProfit) / 100);

                }
                else {
                    fLowPrice = (((Number(fMatCost) + Number(fTransformCost)) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + (Number(fOtherCost) / (meter / 0.9144))) * (1 + Number(fTaxRate) / 100) / (1 - Number(fLowProfit) / 100);

                }
                Page.setFieldValue("fLowPriceMeter", fLowPrice / meter);
                Page.setFieldValue("fLowPriceMeterY", fLowPrice / (meter / 0.9144));
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
            var fTransformCost = $('#__ExtTextBox9').textbox("textbox").val();
            if (fMatCost != "" && fOtherCost != "" && fProCost != "" && fTaxRate != "" && fPrice != "" && fWeaveLoss != "" && fDyeLoss != "" && fDyePrice != "") {
                //var fPriceRate = 100 - ((Number(fMatCost) + Number(fOtherCost) + Number(fProCost)) / Number(fPrice)) * 100 - Number(fManagerRate) - Number(fTaxRate);
                var fPriceRate = (1 - (((Number(fMatCost) + Number(fTransformCost)) / (1 - Number(fWeaveLoss) / 100) + Number(fProCost)) / (1 - Number(fDyeLoss) / 100) + Number(fDyePrice) + Number(fOtherCost)) * (1 + Number(fTaxRate) / 100) / Number(fPrice)) * 100;
                Page.setFieldValue("fPriceRate", fPriceRate.toFixed(2));
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1003") {
                //SeliBscDataMatRecNo();
            }
        }

        function SeliBscDataMatRecNo() {
            //            var sqlObj = { TableName: "BscDataListD",
            //                Fields: "*",
            //                SelectAll: "True",
            //                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'machineCost'"}]
            //            };
            //            var data = SqlGetData(sqlObj);
            //            var fBscDataFabDayYieldKG = Page.getFieldValue("fBscDataFabDayYieldKG");
            //            if (data.length > 0 && fBscDataFabDayYieldKG != "" && Number(fBscDataFabDayYieldKG) != 0) {
            //                var fProCost = Number(data[0].sCode) / Number(fBscDataFabDayYieldKG);
            //                Page.setFieldValue("fProCost", fProCost.toFixed(2));
            //            }
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

        var isChanged = false;
        Page.Formula = function (field) {
            if (Page.isInited = true) {
                if (isChanged == false) {
                    isChanged = true;
                    if (field == "fProCost") {
                        Page.setFieldValue("fMachineDayCost", Number(Page.getFieldValue("fBscDataFabDayYieldKG")) * Number(Page.getFieldValue("fProCost")));
                    }
                    else if (field == "fMachineDayCost") {
                        Page.setFieldValue("fProCost", Number(Page.getFieldValue("fMachineDayCost")) / Number(Page.getFieldValue("fBscDataFabDayYieldKG")));
                    }
                    getLowPrice();
                    getfPriceRate();
                    setTimeout(function () {
                        isChanged = false;
                    }, 500);
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table class="tabmain" style="margin-left: 0px; padding-left: 10px;">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        报价单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSaleID" Width="150px" />
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        报价日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td align="right">
                        产品编号
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="ibscDataMatRecNo" />
                    </td>
                    <td align="right">
                        产品名称
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        坯布编号
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataFabRecNo" />
                    </td>
                    <td align="right">
                        幅宽
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fProductWidth" Z_decimalDigits="0"
                            Z_FieldType="数值" />
                    </td>
                    <td align="right">
                        克重
                    </td>
                    <td align="left">
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fProductWeight" Z_decimalDigits="0"
                            Z_FieldType="数值" />
                    </td>
                    <td>
                        报价单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sUnitID" runat="server" />
                    </td>
                </tr>
            </table>
            <table class="tabmain" style="margin-left: 0px; padding-left: 10px; border-top: solid 1px #95b8e7;">
                <tr>
                    <td>
                        物料成本
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fMatCost" Z_readOnly="True"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        织费
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox_fProCost" runat="server" Z_FieldID="fProCost" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        染色损耗（%）
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox_fDyeLoss" runat="server" Z_FieldID="fDyeLoss" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    
                </tr>
                <tr>
                    <td style="width: 10%; display: none;">
                        织造损耗（%）
                    </td>
                    <td style="width: 20%; display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox_fWeaveLoss" runat="server" Z_FieldID="fWeaveLoss"
                            Z_FieldType="数值" Z_decimalDigits="2" Z_Value="0" />
                    </td>
                    <td>
                        染费
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox_fDyePrice" runat="server" Z_FieldID="fDyePrice" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>                    
                    <td>
                        其他费用
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fOtherCost" Z_readOnly="True"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        物流成本
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fTransformCost" Z_FieldType="数值"
                            Z_decimalDigits="2" Z_Value="0" />
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
                        <cc1:ExtTextBox2 ID="ExtTextBox_fLowPrice" runat="server" Z_FieldID="fLowPrice" Z_FieldType="数值"
                            Z_readOnly="True" Z_decimalDigits="2" Style="width: 60px" />
                        米价<cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Style="width: 60px" Z_FieldType="数值"
                            Z_readOnly="True" Z_FieldID="fLowPriceMeter" Z_decimalDigits="2" Z_NoSave="true" />
                        码价<cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Style="width: 60px" Z_FieldType="数值"
                            Z_readOnly="True" Z_FieldID="fLowPriceMeterY" Z_decimalDigits="2" Z_NoSave="true" />
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
                <tr>
                    <td>
                        有效期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dValidity" Width="120px"
                            Z_FieldType="日期" />
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
                </tr>
            </table>
            <table class="tabmain">
                <tr>
                    <td class="style2">
                        备注
                    </td>
                    <td class="style1">
                        <textarea id="sReMark" style="border-bottom: 1px solid black; width: 802px; border-left-style: none;
                            border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                            border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                            border-top-color: inherit; border-top-width: 0px;" fieldid="sReMark"></textarea>
                    </td>
                </tr>
            </table>
            <table class="tabmain">
                <tr>
                    <td style="width: 10%;">
                        日产量
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fBscDataFabDayYieldKG"
                            Z_readOnly="True" Z_decimalDigits="2" Z_NoSave="true" Z_FieldType="数值" />
                    </td>
                    <td style="width: 10%;">
                        织费/天
                    </td>
                    <td style="width: 20%;">
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fMachineDayCost" Z_FieldType="数值"
                            Z_decimalDigits="2" />
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
