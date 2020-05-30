<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 100px;
        }
        .style2
        {
            width: 200px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var isModify = 0;
        var sModifyType = "";
        $(function () {
            if (Page.usetype == "add") {
                Page.setFieldValue("sFinishCode", "   ,乙方应于甲方交付产品后   天内付清该批货物货款，且双方交易过程中的累积欠款金额不得超过   元。");
                Page.setFieldValue("sProductAsk", "按甲方产品企业标准，");
                //Page.setFieldValue("sReceiveAddr", "");
                Page.setFieldValue("sPackType", "打卷，计公斤，米数，内套PE袋+外编织带（大或小包装）");
                Page.setFieldValue("sCheckStand", "外观质量，数量为收货三天内，内在质量为收货后七天内书面提出异议，甲方应及时配合处理，乙方一经开裁或深加工及超期视为认可，供方不承担任何责任。");
            }
            Page.DoNotAutoSerial = true;

            if (Page.usetype == "modify") {
                isModify = Page.pageData.iModifying;
                if (isModify == "1") {
                    var sqlObj1 = {
                        TableName: "SDChange",
                        Fields: "top 1 sType",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iSdOrderMRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.key + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "isnull(iStatus,0)",
                                ComOprt: ">",
                                Value: "3"
                            }
                        ],
                        Sorts: [
                        {
                            SortName: "iRecNo",
                            SortOrder: "desc"
                        }
                        ]
                    }
                    var result11 = SqlGetData(sqlObj1);
                    if (result11.length > 0) {
                        sModifyType = result11[0].sType;
                    }
                    if (sModifyType == "客户信息变更") {
                        Page.mainDisabled();
                        Page.childrenDisabled();
                        Page.setFieldEnabled("iBscDataCustomerRecNo");
                        Page.setFieldEnabled("iSubscription");
                        Page.setFieldEnabled("sMiddleCostName");
                        Page.setFieldEnabled("iMiddleCost");
                        Page.setFieldEnabled("iEndCost");
                        //                        Page.setFieldEnabled("iSubscription");
                        //                        Page.setFieldEnabled("sMiddleCostName");
                    }
                    else if (sModifyType == "单价变更") {
                        Page.mainDisabled();
                        //Page.childrenDisabled();
                        Page.Children.toolBarBtnDisabled("SDOrderD", "add");
                        Page.Children.toolBarBtnDisabled("SDOrderD", "delete");
                        Page.Children.toolBarBtnDisabled("SDOrderD", "copy");
                        Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "add");
                        Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "delete");
                        Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "copy");
                        Page.Children.toolBarBtnDisabled("SDOrderDFab", "add");
                        Page.Children.toolBarBtnDisabled("SDOrderDFab", "delete");
                        Page.Children.toolBarBtnDisabled("SDOrderDFab", "copy");
                    }
                    else {
                        Page.mainDisabled();
                        if (sModifyType == "数量变更") {
                            Page.setFieldEnabled("iBscDataMatRecNo");
                            Page.setFieldEnabled("fProductWidth");
                            Page.setFieldEnabled("fProductWeight");
                            Page.setFieldEnabled("fFabPrice");
                            Page.setFieldEnabled("sRollWeight");
                            Page.setFieldEnabled("iUnitID");
                        }
                    }
                }
            }
        })

        Page.beforeLoad = function () {
            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj2 = { TableName: "vwSDOrderM_GMJ",
                    Fields: "sName,sBscDataFabCode,fProductWidth,fProductWeight",
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
            }
            else if (Page.usetype == "add") {
                var sqlObj = { TableName: "BscDataListD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'sColorItem'"}]
                };
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var addRow = {};
                        addRow.sItemName = data[i].sName;
                        Page.tableToolbarClick("add", "SDOrderDColor", addRow);
                    }
                }
            }
        }

        Page.beforeSave = function () {
            if (Page.getFieldValue("iOrderType") != "1" && Page.getFieldValue("iOrderType") != "6" && Page.getFieldValue("sBscDataFabCode") == "") {
                Page.MessageShow("错误", "坯布编号必须存在！");
                return false;
            }
            if ((Page.getFieldValue("iOrderType") == "1" || Page.getFieldValue("iOrderType") == "6") && Page.getFieldValue("sBscDataFabCode") == "") {
                Page.setFieldValue("iBscDataMatFabRecNo", 0);
            }

            var iOrderType = Page.getFieldValue("iOrderType");
            if (iOrderType == "0") {
                var fFabPrice = Page.getFieldValue("fFabPrice");
                if (fFabPrice == "") {
                    Page.MessageShow("订单类型为坯布自制时，坯布单价不能为空", "订单类型为坯布自制时，坯布单价不能为空");
                    return false;
                }
            }

            if (Page.usetype == "add") {
                var sOrderNo = Page.getFieldValue("sOrderNo");
                if (sOrderNo == "") {
                    var jsonobj = {
                        StoreProName: "Yww_FormBillNoBulid",
                        StoreParms: [
                    {
                        ParmName: "@formid",
                        Value: 5561
                    }
                    ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    Page.setFieldValue("sOrderNo", result);
                }
            }
            calcTotal();
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "SDOrderD") {
                if (datagridOp.currentColumnName == "fSumQty" && changes.fSumQty) {
                    var iUnitID = Page.getFieldValue("iUnitID");
                    var fProductWidth = Page.getFieldValue("fProductWidth");
                    var fProductWeight = Page.getFieldValue("fProductWeight");
                    var fSumQty = row.fSumQty;
                    if (iUnitID != "" && fProductWidth != "" && fProductWeight != "" && fSumQty != "") {
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
                        $("#SDOrderD").datagrid("updateRow", { index: index, row: { fWeight: fWeight} });
                        calcTotal();
                    }
                    var fPrice = row.fPrice;
                    if (fPrice != "") {
                        //row.fTotal = Number(fSumQty) * Number(fPrice);
                        $("#SDOrderD").datagrid("updateRow", { index: index, row: { fTotal: Number(fSumQty) * Number(fPrice)} });
                        calcTotal();
                    }
                }
                if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
                    var fSumQty = row.fSumQty;
                    var fPrice = row.fPrice;
                    $("#SDOrderD").datagrid("updateRow", { index: index, row: { fTotal: Number(fSumQty) * Number(fPrice)} });
                }
            }
            if (tableid == "SDOrderDOtherCost") {
                if (datagridOp.currentColumnName == "fPrice" || datagridOp.currentColumnName == "iQty" || datagridOp.currentColumnName == "fTotal") {
                    calcTotal();
                }
            }
        }

        function calcTotal() {
            var rows = $("#SDOrderD").datagrid("getRows");
            var total = 0;
            for (var i = 0; i < rows.length; i++) {
                var fTotal = isNaN(parseFloat(rows[i].fTotal)) ? 0 : parseFloat(rows[i].fTotal);
                total += fTotal;
            }
            var rowsOther = $("#SDOrderDOtherCost").datagrid("getRows");
            var totalOther = 0;
            for (var i = 0; i < rowsOther.length; i++) {
                var ftotalother = isNaN(parseFloat(rowsOther[i].fTotal)) ? 0 : parseFloat(rowsOther[i].fTotal);
                totalOther += ftotalother;
            }
            total += totalOther;
            Page.setFieldValue("fTotal", total);
        }

        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "SDOrderD" || tableid == "SDOrderDOtherCost") {
                var rows = $("#SDOrderD").datagrid("getRows");
                var total = 0;
                for (var i = 0; i < rows.length; i++) {
                    var fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
                    var fSumQty = isNaN(parseFloat(rows[i].fSumQty)) ? 0 : parseFloat(rows[i].fSumQty);
                    var fSmallVatCost = isNaN(parseFloat(rows[i].fSmallVatCost)) ? 0 : parseFloat(rows[i].fSmallVatCost);
                    var fSampleCost = isNaN(parseFloat(rows[i].fSampleCost)) ? 0 : parseFloat(rows[i].fSampleCost);
                    total = total + fPrice * fSumQty + fSampleCost + fSmallVatCost;
                }
                var rowsOther = $("#SDOrderDOtherCost").datagrid("getRows");
                var totalOther = 0;
                for (var i = 0; i < rowsOther.length; i++) {
                    var ftotalother = isNaN(parseFloat(rowsOther[i].fTotal)) ? 0 : parseFloat(rowsOther[i].fTotal);
                    totalOther += ftotalother;
                }
                total += totalOther;
                Page.setFieldValue("fTotal", total);
            }
        }

        Page.afterLoad = function () {
            $('#__ExtTextBox_iUnitID').combobox({
                onSelect: function (rec) { SeliUnitID(); }
            });
            //            $('#__ExtTextBox_iBscDataMatRecNo').combobox({
            //                onSelect: function (rec) { SeliBscDataMatRecNo(); }
            //            });

        }

        lookUp.afterSelected = function (uniqueid, data) {
            //uniqueid=62表示从生产计划明细转入
            if (uniqueid == "1133") {
                SeliBscDataMatRecNo();
            }
        }

        function SeliBscDataMatRecNo() {
            var sqlObj = { TableName: "BscDataMatDFabAsk",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "iMainRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataMatFabRecNo") + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    var addRow = {};
                    addRow.sItemName = data[i].sItemName;
                    addRow.sAsk = data[i].sAsk;
                    Page.tableToolbarClick("add", "SDOrderDFab", addRow);
                }
            }
        }

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
                            $('#SDOrderD').datagrid('updateRow', {
                                index: i,
                                row: {fWeight:fWeight,fTotal:fTotal}
                            });
                        }
                    }

                    var totalOther = 0;
                    var rowsOther = $("#SDOrderDOtherCost").datagrid("getRows");
                    for (var i = 0; i < rowsOther.length; i++) {
                        //var iQty = isNaN(parseFloat(rowsOther[i].iQty)) ? 0 : parseFloat(rowsOther[i].iQty);
                        //var fPrice = isNaN(parseFloat(rowsOther[i].fPrice)) ? 0 : parseFloat(rowsOther[i].fPrice);
                        var ftotalother = isNaN(parseFloat(rowsOther[i].fTotal)) ? 0 : parseFloat(rowsOther[i].fTotal);
                        totalOther += ftotalother;
                    }
                    main_fTotal += totalOther;
                    Page.setFieldValue('fTotal', main_fTotal);
                    Page.Children.ReloadFooter("SDOrderD");
                }
            }
        }
        //var newwindow = undefined;
        function calc(title, index) {
            if (index == 3) {
                var iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
                var iBscDataMatFabRecNo = Page.getFieldValue("iBscDataMatFabRecNo");
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                var fProductWidth = Page.getFieldValue("fProductWidth");
                var fProductWeight = Page.getFieldValue("fProductWeight");
                var url = "SdStyleCost.aspx?iformid=5560";
                var sqlobj = {
                    TableName: "SDStyleCostM",
                    Fields: "iRecNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "ibscDataMatRecNo",
                            ComOprt: "=",
                            Value: "'" + iBscDataMatRecNo + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "iBscDataFabRecNo",
                            ComOprt: "=",
                            Value: "'" + iBscDataMatFabRecNo + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "iBscDataCustomerRecNo",
                            ComOprt: "=",
                            Value: "'" + iBscDataCustomerRecNo + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlobj);
                if (result.length > 0) {
                    var iRecNo = result[0].iRecNo;
                    url += "&usetype=modify&key=" + iRecNo + "&random=" + Math.random();
                }
                else {
                    url += "&usetype=add&from1=order&iBscDataMatRecNo=" + iBscDataMatRecNo + "&iBscDataMatFabRecNo=" + iBscDataMatFabRecNo + "&fProductWidth=" + fProductWidth + "&fProductWeight=" + fProductWeight + "&iBscDataCustomerRecNo=" + iBscDataCustomerRecNo + "&random=" + Math.random();
                }
                window.open(url, "newwindow", "height=600,width=1000,top=0,left=0,toolbar=no,menubar=no,location=no,status=no");
            }
        }

        Page.afterSave = function () {
            if (isModify == "1") {
                //判断是否是变更
                var jsonobj = {
                    StoreProName: "SpSDOrderMChangeSave",
                    StoreParms: [
                        {
                            ParmName: "@iformid",
                            Value: Page.iformid
                        },
                        {
                            ParmName: "@iRecNo",
                            Value: Page.key
                        },
                        {
                            ParmName: "@sUserID",
                            Value: Page.userid
                        }

                        ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }

        Page.Children.onBeforeAddRow = function () {
            if (isModify == true && sModifyType != "数量变更") {
                return false;
            }
        }

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (isModify == true) {
                if (sModifyType == "单价变更") {
                    if (datagridOp.clickColumnName != "fPrice") {
                        return false;
                    }
                }
                else if (sModifyType != "数量变更") {
                    return false;
                }
            }
        }

        dataForm.onBeforeOpen = function (uniqueid) {
            if (uniqueid == "212") {
                if (isModify == true && sModifyType != "数量变更") {
                    alert("非数量变更，不可从颜色档案转入！");
                    return false;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div class="easyui-tabs" data-options="fit:true">
        <div title="订单信息">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display:none;">
                        <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" runat="server" />
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" />
                            </td>
                            <td>
                                客户订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sContractNo" />
                            </td>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Z_Required="True" />
                            </td>
                            <td>
                                签订日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldType="日期" Z_FieldID="dDate"
                                    Z_Required="True" />
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
                                订单类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iOrderType" Z_Required="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                寄样类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sSampleType" Z_Required="True" />
                            </td>
                            <td>
                                订单交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期"
                                    Z_Required="True" />
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
                            <td style="display: none;">
                                部门
                            </td>
                            <td style="display: none;">
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sDeptID" />
                            </td>
                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fQty" Style="display: none;" />
                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Style="display: none;" />
                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSaleID" Style="display: none;" />
                            <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataMatFabRecNo"
                                Style="display: none;" />
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td>
                                是否备货
                            </td>
                            <td class="style2">
                                <cc1:ExtTextBox2 ID="ExtSelect21" runat="server" Z_FieldID="iprepare" />
                            </td>
                            <td class="style1">
                                备注
                            </td>
                            <td class="style1">
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
                    <div class="easyui-tabs" data-options="fit:true,border:false,onSelect:calc">
                        <div data-options="fit:true" title="订单明细">
                            <!--  子表1  -->
                            <table id="SDOrderD" tablename="SDOrderD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="其他费用">
                            <!--  子表2  -->
                            <table id="SDOrderDOtherCost" tablename="SDOrderDOtherCost">
                            </table>
                        </div>
                        <div data-options="fit:true" title="坯布要求">
                            <!--  子表2  -->
                            <table id="SDOrderDFab" tablename="SDOrderDFab">
                            </table>
                        </div>
                        <div data-options="fit:true" title="利润核算">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div title="付款要求">
            <table>
                <tr>
                    <td colspan="2">
                        结算方式：定金<cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Width="35px" Z_FieldID="iSubscription"
                            Z_FieldType="整数" />
                        %&nbsp;&nbsp;
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sMiddleCostName" Width="99px" />
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMiddleCost" Width="36px"
                            Z_FieldType="整数" />
                        %&nbsp; 尾款
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iEndCost" Width="32px"
                            Z_FieldType="整数" />
                        %
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        乙方应于甲方交付产品后<cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iDay" Width="60px" />
                        天内付清该批货款，且双方交易过程中的累积欠款金额不得超过<cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fMoney"
                            Width="80px" />
                        元<br />
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        产品质量要求
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sProductAsk" Style="width: 400px;
                            height: 50px;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        交货地点，方式
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sReceiveAddr" Style="width: 400px;
                            height: 50px;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        运输方式及到港和费用负担
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sTransType" Style="width: 400px;
                            height: 50px;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        包装标准
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea4" runat="server" Z_FieldID="sPackType" Style="width: 400px;
                            height: 50px;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        验收标准及提出异议期限
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea5" runat="server" Z_FieldID="sCheckStand" Style="width: 400px;
                            height: 50px;" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
