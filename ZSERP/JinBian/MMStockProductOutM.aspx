<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {

            lookUp.afterSelected = function (uniqueid, data) {
                // 正式库 if (uniqueid == "2452")
                // 测试库 if (uniqueid == "2417")
                if (uniqueid == "2452") {
                    loadSDSendMD();
                }
            }

            $("#tabSendMD").datagrid({
                fit: true,
                columns: [
                    [
                        { field: "__ck", width: "40", checkbox: true },
                        { field: "sFinish", title: "出库完成", width: 60, align: "center" },
                        { field: "sBillNo", title: "通知单号", width: 100, align: "center" },
                        { field: "sOrderNo", title: "订单号", width: 100, align: "center" },
                        //{ field: "sCustShortName", title: "客户简称", width: 80, align: "center" },
                        { field: "sCode", title: "产品型号", width: 80, align: "center" },
                        { field: "sSerial", title: "序列号", width: 80, align: "center" },
                        { field: "sColorName", title: "颜色", width: 80, align: "center" },
                        { field: "sSaleUnitName", title: "单位", width: 80, align: "center" },
                        { field: "fPrice", title: "单价", width: 80, align: "center" },
                        { field: "fSumQty", title: "要求发货数量", width: 80, align: "center" },
                        { field: "fOutQty", title: "已发货数量", width: 80, align: "center" },
                        { field: "fNoOutQty", title: "未发货数量", width: 80, align: "center" },
                        //{ field: "sSuggestReelNo", title: "建议选卷", width: 200, align: "center" },
                        { field: "fStockQty", title: "当前库存米数", width: 80, align: "center" },
                        { field: "iRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true } 
                    ]
                ],
                singleSelect: true,
                rownumbers: true,
                onClickRow: function (index, row) { 
                    Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
                    Page.setFieldValue("iSDSendDRecNo", row.iRecNo); 
                    Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo); 
                    Page.setFieldValue("iBscDataColorRecNo", row.iBscDataColorRecNo); 
                    Page.setFieldValue("fSalePrice", row.fPrice); 
                    Page.setFieldValue("sSerial", row.sSerial); 
                }, 
                toolbar: "#divMenu"
            })

            if (getQueryString("iBillType") == "3") {
                $("#sBarCodeTable").hide();
            }
            var sqlObj = {
                //表名或视图名
                TableName: "vwMMStockProductOutM",
                //选择的字段
                Fields: "sYearMonth,sContractNo",
                //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                SelectAll: "True",
                //过滤条件，数组格式
                Filters: [
                    {
                        //左括号
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                ]
            }
            var data = SqlGetData(sqlObj);

            if (data.length > 0) { 
                Page.setFieldValue("sYearMonth", data[0].sYearMonth);
            }
            Page.Children.toolBarBtnDisabled("MMStockProductOutD", "add");
        })

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "MMStockProductOutD") {
                var sUnitID = row.sUnitID;
                sUnitID = isNaN(sUnitID) ? "" : sUnitID;
                sUnitID = sUnitID == "" ? "1" : sUnitID;
                var fPrice = isNaN(Number(row.fPrice)) ? 0 : Number(row.fPrice);
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                //var iCalc1 = Page.getFieldValue("iCalc1");
                //if (iCalc1 == "1") {
                //    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                //        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                //        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                //        var fQty = (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode)) * 0.9144;
                //        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                //        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                //    }
                //}
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fPurQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fQty: fQty } });
                    }
                }


                if (sUnitID == "0") {
                    var fTotal = fPrice * (isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty));
                    $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                } else if (sUnitID == "1") {
                    var fTotal = fPrice * (isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty));
                    $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                } else {
                    var fTotal = fPrice * (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode));
                    $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                }

                Page.Children.ReloadFooter("MMStockProductOutD");
                var rows = $("#MMStockProductOutD").datagrid('getRows');
                var fQtyM = 0;
                var fPurQtyM = 0;
                var sLetCodeM = 0;
                var fTotalM = 0;
                for (var i = 0; i < rows.length; i++) {
                    fQtyM += isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                    fPurQtyM += isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                    sLetCodeM += isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode);
                    fTotalM += isNaN(parseFloat(row.fTotal)) ? 0 : parseFloat(row.fTotal);
                }
                Page.setFieldValue("fQty", fQtyM.toFixed(2));
                Page.setFieldValue("fPurQty", fPurQtyM.toFixed(2));
                Page.setFieldValue("sLetCode", sLetCodeM.toFixed(2));
                Page.setFieldValue("fTotal", fTotalM.toFixed(2));
            }
        }

        function loadSDSendMD() {
            var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
            if (iSDSendMRecNo == "") {
                Page.MessageShow("请先选择通知单", "请先选择通知单");
                return false;
            }
            var iFinish = $("#ckbFinish")[0].checked;
            var Filters = [
                {
                    Field: "iStatus",
                    ComOprt: "=",
                    Value: "4",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(fNoOutQty,0)",
                    ComOprt: "<>",
                    Value: "0",
                    LinkOprt: "and"
                },
                {
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: "'" + iSDSendMRecNo + "'"
                }
            ]
            if (iFinish != true) {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "isnull(iFinish,0)",
                    ComOprt: "=",
                    Value: "0"
                })
            }
            var sqlObj = {
                TableName: "vwSDSendMD",
                Fields: "*",
                SelectAll: "True",
                Filters: Filters,
                Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "desc"
                    },
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabSendMD").datagrid("loadData", result);
        }
        function doSendMDFinish() {
            var checkedRows = $("#tabSendMD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                $.messager.confirm("您确认标记吗?", "您确认标记所选明细出库完成/未完成吗?", function (r) {
                    if (r) {
                        var RecNoStr = checkedRows[0].iRecNo;
                        var jsonobj = {
                            StoreProName: "SpSDSendDFinish",
                            StoreParms: [{
                                ParmName: "@iformid",
                                Value: ""
                            }, {
                                ParmName: "@keys",
                                Value: RecNoStr
                            }, {
                                ParmName: "@userid",
                                Value: Page.userid
                            }, {
                                ParmName: "@btnid",
                                Value: ""
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                        else {
                            Page.MessageShow("成功", "标记成功");
                            loadSDSendMD();
                        }
                    }
                })
            }
        }


        Page.beforeSave = function () {
            var d = Page.getFieldValue("dDate");
	    var fTotalQty = 0;
            Page.setFieldValue("sYearMonth", d.substring(0, 7));
            var rows = $("#MMStockProductOutD").datagrid("getRows");
            if (rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    fTotalQty += Number(rows[i].fQty);
                }
                Page.setFieldValue("fQty", fTotalQty);
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    if (Page.getFieldValue("iBscDataStockMRecNo") == "") {
                        alert("请先选择出库仓库");
                        return false;
                    } 
                    if (Page.getFieldValue("iBscDataCustomerRecNo") == "") {
                        alert("请先选择客户");
                        return false;
                    } 
                    
                    var rows = $("#MMStockProductOutD").datagrid("getRows");
                    for (var j = 0; j < rows.length; j++) {
                        if (barcode == rows[j].sBarCode) {
                            alert("已扫描");
                            return false;
                        }
                    }
                     
                    var iSDSendDRecNo = Page.getFieldValue("iSDSendDRecNo");
                    iSDSendDRecNo = isNaN(Number(iSDSendDRecNo)) ? 0 : Number(iSDSendDRecNo);
                    
                    var iSdOrderMRecNo = Page.getFieldValue("iSdOrderMRecNo");
                    var iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
                    var iBscDataColorRecNo = Page.getFieldValue("iBscDataColorRecNo");
                    var sSerial = Page.getFieldValue("sSerial");
                    var fSalePrice = Page.getFieldValue("fSalePrice"); 
                    var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                    var filters = []; 
                    filters.push({
                        //左括号
                        LeftParenthese: "(",
                        //字段名
                        Field: "a.sBarCode",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: "'" + barcode + "'",
                        LinkOprt: "or"
                    });
                    filters.push({
                        Field: "a.sTrayCode",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: "'" + barcode + "'",
                        RightParenthese: ")", 
                        LinkOprt: "and"
                    }); 
                    filters.push({
                        Field: "d.iBscDataCustomerRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: iBscDataCustomerRecNo,
                        LinkOprt: "and"
                    }); 
                    filters.push({
                        Field: "a.iBscDataStockMRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'"
                    });

                    if (iSDSendDRecNo != 0) {
                            filters[filters.length - 1].LinkOprt = "and";
                            filters.push({
                                Field: "a.iBscDataMatRecNo",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + iBscDataMatRecNo + "'",
                                LinkOprt: "and"
                            }); 
                            filters.push({
                                Field: "a.iBscDataColorRecNo",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + iBscDataColorRecNo + "'",
                                LinkOprt: "and"
                            });  
                            filters.push({
                                Field: "isnull(a.sSerial,'')",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + sSerial + "'"
                            });
                    }

                    if (Page.getFieldValue("iRed") == 0) {
                        var sqlObj = {
                            //表名或视图名
                            TableName: "MMStockQty a inner join BscDataMat b on a.iBscDataMatRecNo=b.iRecNo inner join BscDataColor c on a.iBscDataColorRecNo=c.iRecNo left join SDContractM d on a.iSdOrderMRecNo=d.iRecNo left join SDContractD dd on d.iRecNo=dd.iMainRecNo and dd.iBscDataMatRecNo=b.iRecNo and dd.iBscDataColorRecNo=c.iRecNo and isnull(dd.iBscDataFlowerTypeRecNo,0)=isnull(a.iBscDataFlowerTypeRecNo,0) left join BscDataStockD e on a.iBscDataStockDRecNo=e.iRecNo LEFT JOIN BscDataFlowerType f ON f.iRecNo=a.iBscDataFlowerTypeRecNo left join sdorderm g on g.iRecNo=a.iSDOrderMRecNoBatch left join SDOrderDDVatNoDReelNo h on h.sBarCode=a.sBarCode",
                            //选择的字段
                            Fields: "a.*,h.sCustBarCode,f.sFlowerType,b.sName,c.sColorID,d.sContractNo,g.sOrderNo,isnull(e.sBerChID,'') as sBerChID,isnull(dd.fPrice,0) fPrice,isnull(dd.fPrice,0)*a.fQty fTotal",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: filters
                        }
                        var data = SqlGetData(sqlObj);
                        var isSame = 0;
                        if (data.length > 0) {
                            var allRows = $("#MMStockProductOutD").datagrid("getRows");
                             
                            for (var i = 0; i < data.length; i++) {
                                for (var j = 0; j < allRows.length; j++) {
                                    if (allRows[j].sBarCode == data[i].sBarCode) {
                                        isSame = 1;
                                    }
                                }
                                if (isSame == 1) {
                                    isSame = 0;
                                } else {
                                    var tempRows = $("#MMStockProductOutD").datagrid("getRows");
                                    var fQtyTotal = 0;
                                    if (tempRows.length > 0) {
                                        for (var j = 0; j < tempRows.length; j++) {
                                            fQtyTotal += Number(tempRows[j].fQty);
                                        }
                                    }
				                    var tmpLength = isNaN(Number(tempRows.length))==true?0:Number(tempRows.length);
                                    data[i].iSerial = tmpLength + 1;
                                    data[i].fSalePrice = fSalePrice;
                                    data[i].fSaleTotal = fSalePrice;
                                    data[i].iSDSendDRecNo = iSDSendDRecNo;
                                    data[i].iStockSdOrderMRecNo = data[i].iSdOrderMRecNo;
                                    data[i].iSDOrderMRecNoBatch = iSdOrderMRecNo;
                                    data[i].iStockSDOrderMRecNoBatch = data[i].iSDOrderMRecNoBatch;
                                    

                                    delete data[i].iSdOrderMRecNo;
                                     Page.tableToolbarClick("add", "MMStockProductOutD", data[i]); 
                                    $('#MMStockProductOutD').datagrid('reloadFooter', [
                                        { fQty: Number(fQtyTotal) + Number(data[i].fQty) }
                                    ]);
                                    // $("#dl").datalist("selectRow",allRows.length-1);  
                                }
                            }
                        }
                        else {
                            alert("条码不存在,若有通知单则可能通知单产品不对应");
                        }
                    } else {
                        var sqlObj = {
                            StoreProName: "SpGetOutProduct",
                            StoreParms: [
                                {
                                    ParmName: "@sBarCode",
                                    Value:  barcode
                                },
                                {
                                    ParmName: "@iSDSendDRecNo",
                                    Value:  iSDSendDRecNo 
                                } 
                            ]
                        }
                        var data = SqlStoreProce(sqlObj, true);
                        var isSame = 0;
                        if (data.length > 0) {
                            var allRows = $("#MMStockProductOutD").datagrid("getRows"); 
                            for (var i = 0; i < data.length; i++) { 
                                for (var j = 0; j < allRows.length; j++) {
                                    if (allRows[j].sBarCode == data[i].sBarCode) {
                                        isSame = 1;
                                    }
                                }
                                if (isSame == 1) {
                                    isSame = 0;
                                } else {
                                    var tempRows = $("#MMStockProductOutD").datagrid("getRows");
                                    var fQtyTotal = 0;
                                    if (tempRows.length > 0) {
                                        for (var j = 0; j < tempRows.length; j++) {
                                            fQtyTotal += Number(tempRows[j].fQty);
                                        }
                                    }
                                    var tmpLength = isNaN(Number(tempRows.length))==true?0:Number(tempRows.length);
                                    data[i].iSerial = tmpLength + 1; 
                                    data[i].iSDSendDRecNo = iSDSendDRecNo;
				                    Page.tableToolbarClick("add", "MMStockProductOutD", data[i]);
                                    //$('#MMStockProductOutD').datagrid('appendRow', data[i]);
                                    // Page.Children.ReloadFooter("MMStockProductOutD");
                                    $('#MMStockProductOutD').datagrid('reloadFooter', [
                                        { fQty: Number(fQtyTotal) + Number(data[i].fQty) }
                                    ]);
                                    // $("#dl").datalist("selectRow",allRows.length-1);
                                }
                            }
                        }
                        else {
                            alert("条码不存在");
                        }
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }
    </script>
    <style type="text/css">
        #divSdSendMD .datagrid-row {
            height: 25px;
        }

        #divSdSendMD .datagrid-header-row {
            height: 25px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden; height: 205px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',border:false" style="width: 850px;">
                    <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                
                <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="2" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iMatType" Z_Value="2" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="sReMark" Z_Value="扫码出库" runat="server" />
                <%--<cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="iSdOrderMRecNo" runat="server" />--%>
                
            </div>
                    <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        出库单号
                    </td>
                    <td>
                        <div style="display:none">
                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSDSendDRecNo" Z_readOnly="True"
                                Width="150px" Z_NoSave="True" /> 
                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iSdOrderMRecNo" Z_readOnly="True"
                                Width="150px" Z_NoSave="True" /> 
                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iBscDataMatRecNo" Z_readOnly="True"
                                Width="150px" Z_NoSave="True" /> 
                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataColorRecNo" Z_readOnly="True"
                                Width="150px" Z_NoSave="True" /> 
                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fSalePrice" Z_readOnly="True"
                                Width="150px" Z_NoSave="True" /> 
                        </div>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="150px" />
                    </td>
                    <td>
                        仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Width="150px" />
                    </td>
                    <td>
                        出库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sTypeName"
                            Width="150px" Z_Required="True"  />
                    </td>
                </tr>
                <tr>
                    <td>
                        发货通知单
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iSDSendMRecNo" Width="150px"  />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"  Width="150px" Z_Required="True" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td style="margin-left: 40px">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                            Width="150px"  />
                    </td>
                    <td>
                        出库单位
                    </td>
                    <td style="margin-left: 40px">
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sCompany" Width="150px" Z_Required="True"/>
                    </td>
                </tr> 
                <tr>
                    <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                    
                    <td>
                        出库数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="150px" />
                    </td>
                    
                </tr>
            </table>
            <table id="sBarCodeTable">
                <tr>
                    <td>
                        <strong style="font-size:xx-large">条 码</strong>
                    </td>
                    <td>
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 200px;
                                            height: 50px; font-size: 20px; font-weight: bold;background-color:pink;" class="txb" />
                    </td>
                    <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iCalc" Z_NoSave="True" />
                                <label for="__ExtCheckbox1">
                                    米数换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iCalc2" Z_NoSave="True" />
                                <label for="__ExtCheckbox2">
                                    重量换算米</label>
                    </td>
                </tr> 
            </table> 
                </div>
                <div data-options="region:'center',border:false" id="divSdSendMD">
                    <table id="tabSendMD"></table>
                </div>
            </div>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <!--  子表1  -->
                    <table id="MMStockProductOutD" tablename="MMStockProductOutD">
                    </table>
                </div>
            </div>
        </div>
        <div id="divMenu">
            <table>
                <tr>
                    <td>
                        <input id="ckbFinish" type="checkbox" />
                        <label for="ckbFinish">包含已完成</label>
                    </td>
                    <td>
                        <a id="btnSDSendMDReload" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="loadSDSendMD()">刷新</a>
                    </td>
                    <td>
                        <a id="btnSDSendMDFinish" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="doSendMDFinish()">标记完成</a>
                    </td>
                </tr>
            </table>
            </div>
    </div>
</asp:Content>