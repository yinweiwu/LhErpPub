<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var fPriceSum = 0;
        var fSalePriceSum = 0;
        var IntegralAmount = 0; //可用积分金额
        var fStoredMoneyAmount = 0; //可用储值金额
        var isChecked = false;
        var iCommonBarCode = 0; //默认是0
        var ibscMemberRecNo = ""; //会员主键
        var iIntegralSum = 0; //会员总积分
        var fStoredMoneySum = 0; //会员总储值额
        var fScoreMoneySum = 0; //会员总积分额
        var iIntegral1 = 0;
        var A = ""; //参数A
        var sCardType = ""; //会员卡类型
        var Addbarcode = false;
        var isSaved = false;
        $(function () {
            Page.DoNotCloseWinWhenSave = true;
            var isSale = false;
            $('#txtBarcode').focus();
            $('#win').window('close');
            //$('#win1').window('close');
            if (Page.usetype == "add") {
                var sqlObj = {
                    TableName: "bscDataPeriod",
                    Fields: "sYearMonth",
                    SelectAll: "True",
                    Filters: [
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: ">=",
                                Value: "dBeginDate",
                                LinkOprt: "and"
                            },
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: "<=",
                                Value: "dEndDate"
                            }]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }

                var sqlObjStock = {
                    TableName: "vwBscDataStockDUser",
                    Fields: "top 1 iMainRecNo",
                    SelectAll: "True",
                    Filters: [
                            {
                                Field: "isnull(iShopping,0)",
                                ComOprt: "=",
                                Value: "1",
                                LinkOprt: "and"
                            },
                            {
                                Field: "isnull(iBill,0)",
                                ComOprt: "=",
                                Value: "1",
                                LinkOprt: "and"
                            },
                            {
                                Field: "sCode",
                                ComOprt: "=",
                                Value: "'" + Page.userid + "'"
                            }]
                }
                var dataStock = SqlGetData(sqlObjStock);
                if (dataStock.length > 0) {
                    Page.setFieldValue("iBscDataStockMRecNo", dataStock[0].iMainRecNo.toString());
                }

                //                setTimeout(function () {
                //                    Page.setFieldValue("sSaleID", Page.userid);
                //                }, 2000);
            }
            else {
                document.getElementById("txtBarcode").readOnly = true;
                $("#gowin").hide();
            }

            var sqlObj2 = { TableName: "SysParam",
                Fields: "isnull(iCommonBarCode,0) as iCommonBarCode",
                SelectAll: "True"
            };
            var data2 = SqlGetData(sqlObj2);
            if (data2.length > 0) {
                iCommonBarCode = data2[0].iCommonBarCode;
            }

            $("#__save").hide();
            $("#__saveAndContinue").hide();
            if (iCommonBarCode == "1") { }
            else {
                Page.Children.toolBarBtnDisabled("table1", "add");
            }
            Page.Children.toolBarBtnDisabled("table1", "copy");

            if (getQueryString("GZFS") == "1") {
                $("#trgzfs").show();
            }

            //            var sqlobj = { TableName: "vwBscDataStockDUser",
            //                Fields: "iShopping,iBill",
            //                SelectAll: "True",
            //                Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
            //            };
            //            var data = SqlGetData(sqlobj);
            //            if (data.length > 0) {
            //                for (var i = 0; i < data.length; i++) {
            //                    if (data[i].iShopping == "1" && data[i].iBill == "1") {
            //                        isSale = true;
            //                    }
            //                }
            //            }
            //            if (isSale == true) {
            //                Page.setFieldValue('sSaleID', Page.userid);
            //            }

            $('#__ExtTextBox12').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox25').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox28').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox26').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox29').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox19').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
            $('#__ExtTextBox16').textbox("textbox")[0].onkeyup = function () { getLeftTotal(); }
        });

        dataForm.beforeOpen = function (uniqueid, data) {
            if (uniqueid == "181") {
                var Red = Page.getFieldValue('iRed');
                if (Red == "1") {
                    $.messager.show({
                        title: '错误',
                        msg: '退货不能从库存转入！',
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    return false;
                }
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();

                if (barcode.length == 13) {
                    $("#__ExtCheckbox21")[0].checked = true;
                    isChecked = true;
                    var sqlObj3 = { TableName: "MMProductOutM",
                        Fields: "top 1 *",
                        SelectAll: "True",
                        Filters: [{ Field: "sBillNo", ComOprt: "=", Value: "'" + barcode + "'"}],
                        Sorts: [{
                            SortName: "dInputDate",
                            SortOrder: "desc"
                        }]
                    };
                    var data3 = SqlGetData(sqlObj3);
                    if (data3.length > 0) {
                        Page.setFieldValue("sCardNumber", data3[0].sCardNumber);
                        Page.setFieldValue("sSaleID", data3[0].sSaleID);
                        Page.setFieldValue("iBscDataStockMRecNo", data3[0].iBscDataStockMRecNo);
                        var RecNo = data3[0].iRecNo;
                        var sqlObj = { TableName: "vwMMProductOutD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [{ Field: "iMainRecNo", ComOprt: "=", Value: "'" + RecNo + "'"}]
                        };
                        var data = SqlGetData(sqlObj);
                        if (data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].iQty = data[i].iQty * (-1);
                                data[i].fTotal = data[i].fTotal * (-1);
                                delete data[i].iMainRecNo;
                                Page.tableToolbarClick("add", "table1", data[i]);
                            }

                        }
                        else {
                            var message = $("#txaBarcodeTip").val();
                            $("#txaBarcodeTip").val(message + "流水号" + barcode + "不存在\n");
                            PlayVoice("流水号" + barcode + "不存在");
                        }
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "流水号" + barcode + "不存在\n");
                        PlayVoice("流水号" + barcode + "不存在");
                    }
                }
                else {
                    if ($("#__ExtCheckbox21")[0].checked == false) {
                        if (barcode != "") {
                            var sqlObj = { TableName: "vwMMProductStockQty1",
                                Fields: "*",
                                SelectAll: "True",
                                Filters: [{ LeftParenthese: "(", Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", RightParenthese: ")", LinkOprt: "and" },
                                    { Field: "iQty", ComOprt: ">", Value: "0"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                var iBscDataStockMRecNo = Page.getFieldValue('iBscDataStockMRecNo');
                                //获取吊牌价
                                data[0].fSalePrice = GetSalePriceD(data[0], iBscDataStockMRecNo);
                                //var addRow = data;
                                var addRow = [{
                                    sBarCode: data[0].sBarCode,
                                    sOrderNo: data[0].sOrderNo,
                                    sStyleNo: data[0].sStyleNo,
                                    sColorName: data[0].sColorName,
                                    sSizeName: data[0].sSizeName,
                                    fSalePrice: data[0].fSalePrice,
                                    fDisCount: data[0].fDisCount,
                                    fPrice: data[0].fPrice,
                                    iQty: 1,
                                    fTotal: data[0].fTotal,
                                    iBscDataColorRecNo: data[0].iBscDataColorRecNo,
                                    iBscDataStyleMRecNo: data[0].iBscDataStyleMRecNo,
                                    iSdContractMRecNo: data[0].iSdContractMRecNo
                                }];

                                var aaa = getSDPromotionD(data[0].iBscDataStyleMRecNo, data[0].sClassID);
                                if (aaa.fPrice == null) {
                                    if (aaa.fDisCount == null) {
                                        aaa.fDisCount = 10;
                                    }
                                    addRow[0].fDisCount = aaa.fDisCount;
                                    GetNewPrice(addRow);
                                }
                                else {
                                    addRow[0].fPrice = aaa.fPrice;
                                    if (isNaN(parseFloat(addRow[0].fSalePrice)) == false) {
                                        var fDisCount = addRow[0].fPrice / parseFloat(addRow[0].fSalePrice) * 10;
                                        addRow[0].fDisCount = fDisCount;
                                    }
                                }
                                addRow[0].fTotal = addRow[0].fPrice * 1;
                                Page.tableToolbarClick("add", "table1", addRow[0]);
                            }
                            else {
                                var message = $("#txaBarcodeTip").val();
                                $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                PlayVoice("条码" + barcode + "不存在");
                            }
                        }
                    }
                    else {
                        isChecked = true;
                        if (barcode != "") {
                            var sqlObj = { TableName: "vwMMProductOutMD",
                                Fields: "top 1 *",
                                SelectAll: "True",
                                Filters: [
                                    {
                                        Field: "sBarCode",
                                        ComOprt: "=",
                                        Value: "'" + barcode + "'",
                                        LinkOprt: "and"
                                    },
                                    {
                                        Field: "iBscDataStockMRecNo",
                                        ComOprt: "=",
                                        Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'"
                                    }
                                ],
                                Sorts: [{
                                    SortName: "dInputDate",
                                    SortOrder: "desc"
                                }]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                delete data[0].iMainRecNo;
                                data[0].iQty = -1;
                                data[0].fTotal = data[0].fPrice * (-1);
                                Page.tableToolbarClick("add", "table1", data[0]);
                            }
                            else {
                                if (iCommonBarCode == "0") {
                                    var sqlObj = { TableName: "ProOrderDBarCode",
                                        Fields: "*",
                                        SelectAll: "True",
                                        Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                                    };
                                    var data = SqlGetData(sqlObj);
                                    if (data.length > 0) {
                                        var sqlObj1 = { TableName: "vwSdContractDProduce",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + data[0].iSdContractDProduceRecNo + "'"}]
                                        };
                                        var data1 = SqlGetData(sqlObj1);
                                        if (data1.length > 0) {
                                            var iBscDataStockMRecNo = Page.getFieldValue('iBscDataStockMRecNo');
                                            data1[0].iBscDataStyleMRecNo = data1[0].ibscDataStyleMRecNo;
                                            data1[0].fSalePrice = GetSalePriceD(data1[0], iBscDataStockMRecNo); //获取吊牌价
                                            data1[0].iQty = -1;
                                            data1[0].fTotal = data1[0].fPrice * (-1);
                                            Page.tableToolbarClick("add", "table1", data1[0]);
                                        }
                                    }
                                    else {
                                        var message = $("#txaBarcodeTip").val();
                                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                        PlayVoice("条码" + barcode + "不存在");
                                    }
                                }
                                else if (iCommonBarCode == "1") {
                                    var sqlObj1 = { TableName: "vwBscBarCode",
                                        Fields: "*",
                                        SelectAll: "True",
                                        Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                                    };
                                    var data1 = SqlGetData(sqlObj1);
                                    if (data1.length > 0) {
                                        data1[0].iQty = -1;
                                        Page.tableToolbarClick("add", "table1", data1[0]);
                                    }
                                    else {
                                        var message = $("#txaBarcodeTip").val();
                                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                        PlayVoice("条码" + barcode + "不存在");
                                    }
                                }
                            }
                        }
                    }
                }
                var rows = $("#table1").datagrid("getRows");
                if (rows.length > 0) {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        fPriceSum += (rows[i].fPrice == null ? 0 : rows[i].fPrice) * rows[i].iQty;
                        fSalePriceSum += (rows[i].fSalePrice == null ? 0 : rows[i].fSalePrice) * rows[i].iQty;
                    }
                    Page.setFieldValue("fPriceSum", fPriceSum);
                    Page.setFieldValue("fSalePriceSum", fSalePriceSum);
                }
                else {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    Page.setFieldValue("iQty", 0);
                    Page.setFieldValue("fTotal", 0);
                    Page.setFieldValue("fRealTotal", 0);
                }

                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                if (datagridOp.currentColumnName == "fDisCount" && changes.fDisCount) {
                    var fDisCount = row.fDisCount;
                    var fPrice = row.fPrice;
                    if (fDisCount == "" || fDisCount == "0") {

                    }
                    else {
                        row.fPrice = row.fSalePrice * row.fDisCount * 0.1;
                        var iQty = isNaN(parseInt(row.iQty)) ? 0 : parseInt(row.iQty);
                        if (iQty != 0) {
                            row.fTotal = row.fPrice * iQty;
                        }
                        else {
                            row.fTotal = null;
                        }
                    }
                }
                if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
                    var fPrice = row.fPrice;
                    var fDisCount = row.fDisCount;
                    if (fPrice == "" || fPrice == "0" || fPrice == undefined || fPrice == null) {
                        row.fTotal = null;
                        row.fDisCount = null;
                    }
                    else {
                        //                        if (row.fPrice == 0 || row.fPrice == null || row.fPrice == undefined || row.fPrice == "") { }
                        //                        else {
                        //                            row.fDisCount = (row.fPrice / row.fSalePrice) * 10;
                        //                            row.fTotal = row.fPrice;
                        //                        }
                        var iQty = isNaN(parseInt(row.iQty)) ? 0 : parseInt(row.iQty);
                        if (iQty != 0) {
                            row.fTotal = row.fPrice * iQty;
                        }
                        else {
                            row.fTotal = null;
                        }

                        var fSalePrice = isNaN(parseFloat(row.fSalePrice)) ? 0 : parseFloat(row.fSalePrice);
                        if (fSalePrice != 0) {
                            row.fDisCount = (row.fPrice / row.fSalePrice) * 10;
                        }
                        else {
                            row.fDisCount = null;
                        }
                    }
                }
                //                if (datagridOp.currentColumnName == "sStyleNo" && changes.sStyleNo) {
                //                    var StyleNo = row.sStyleNo;
                //                    if (StyleNo != "") {
                //                        if ($("#__ExtCheckbox21")[0].checked == false) {
                //                            var sqlObj = { TableName: "vwMMProductStockQty1",
                //                                Fields: "*",
                //                                SelectAll: "True",
                //                                Filters: [{ LeftParenthese: "(", Field: "sStyleNo", ComOprt: "=", Value: "'" + StyleNo + "'", RightParenthese: ")", LinkOprt: "and" },
                //                                    { Field: "iQty", ComOprt: ">", Value: "0"}]
                //                            };
                //                            var data = SqlGetData(sqlObj);
                //                            if (data.length > 0) {
                //                                var iBscDataStockMRecNo = Page.getFieldValue('iBscDataStockMRecNo');
                //                                GetSalePriceD(data[0], iBscDataStockMRecNo); //获取吊牌价
                //                                row.fSalePrice = data[0].fSalePrice;
                //                                row.sBarCode = data[0].sBarCode;
                //                                row.sOrderNo = data[0].sOrderNo;
                //                                row.sColorName = data[0].sColorName;
                //                                row.sSizeName = data[0].sSizeName;
                //                                row.iQty = data[0].iQty;
                //                                row.iBscDataColorRecNo = data[0].iBscDataColorRecNo;
                //                                row.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo;
                //                                row.iSdContractMRecNo = data[0].iSdContractMRecNo;
                //                            }
                //                            else {
                //                                $.messager.show({
                //                                    title: '提示',
                //                                    msg: '数据不存在！',
                //                                    timeout: 1000,
                //                                    showType: 'show',
                //                                    style: {
                //                                        right: '',
                //                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                //                                        bottom: ''
                //                                    }
                //                                });
                //                            }
                //                        }
                //                        else {
                //                            var sqlObj1 = { TableName: "vwBscBarCode",
                //                                Fields: "top 1 *",
                //                                SelectAll: "True",
                //                                Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                //                            };
                //                            var data = SqlGetData(sqlObj1);
                //                            if (data.length > 0) {
                //                                data[0].iQty = data[0].iQty * (-1);
                //                                row.fSalePrice = data[0].fSalePrice;
                //                                row.sBarCode = data[0].sBarCode;
                //                                row.sOrderNo = data[0].sOrderNo;
                //                                row.sColorName = data[0].sColorName;
                //                                row.sSizeName = data[0].sSizeName;
                //                                row.iQty = data[0].iQty;
                //                                row.iBscDataColorRecNo = data[0].iBscDataColorRecNo;
                //                                row.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo;
                //                                row.iSdContractMRecNo = data[0].iSdContractMRecNo;
                //                            }
                //                            else {
                //                                $.messager.show({
                //                                    title: '提示',
                //                                    msg: '数据不存在！',
                //                                    timeout: 1000,
                //                                    showType: 'show',
                //                                    style: {
                //                                        right: '',
                //                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                //                                        bottom: ''
                //                                    }
                //                                });
                //                            }
                //                        }
                //                    }
                //                }
            }
            var rows = $("#table1").datagrid("getRows");
            if (rows.length > 0) {
                fPriceSum = 0;
                fSalePriceSum = 0;
                for (var i = 0; i < rows.length; i++) {
                    fPriceSum += (rows[i].fPrice == null ? 0 : rows[i].fPrice) * rows[i].iQty;
                    fSalePriceSum += (rows[i].fSalePrice == null ? 0 : rows[i].fSalePrice) * rows[i].iQty;
                }
                Page.setFieldValue("fPriceSum", fPriceSum);
                Page.setFieldValue("fSalePriceSum", fSalePriceSum);
            }
            else {
                fPriceSum = 0;
                fSalePriceSum = 0;
                Page.setFieldValue("iQty", 0);
                Page.setFieldValue("fTotal", 0);
                Page.setFieldValue("fRealTotal", 0);
            }
        }

        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "table1") {
                var row = $("#table1").datagrid("getRows");
                if (row.length > 0) {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    for (var i = 0; i < row.length; i++) {
                        fPriceSum += (row[i].fPrice == null ? 0 : row[i].fPrice) * row[i].iQty;
                        fSalePriceSum += (row[i].fSalePrice == null ? 0 : row[i].fSalePrice) * row[i].iQty;
                    }
                    Page.setFieldValue("fPriceSum", fPriceSum);
                    Page.setFieldValue("fSalePriceSum", fSalePriceSum);
                }
                else {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    Page.setFieldValue("iQty", 0);
                    Page.setFieldValue("fTotal", 0);
                    Page.setFieldValue("fRealTotal", 0);
                }
            }
        }

        lookUp.IsConditionFit = function (uniqueid) {
            if (uniqueid == "497") {
                if (Page.getFieldValue("iRed") != "1") {
                    return true;
                }
            }
            if (uniqueid == "499") {
                if (Page.getFieldValue("iRed") == "1") {
                    return true;
                }
            }
        }

        lookUp.beforeOpen = function (uniqueid) {
            if (uniqueid == "497") {
                if (Addbarcode == true) {
                    return false;
                }
            }
        }

        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid = "table1") {
                var barcode = $("#txtBarcode").val();
                if (barcode == "") {
                    Addbarcode = false;
                }
                else {
                    Addbarcode = true;
                }
            }
        }

        lookUp.beforeSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            if (uniqueid == "497" || uniqueid == "499") {
                var iRed = Page.getFieldValue("iRed") == "1" ? -1 : 1;
                row.iQty = 1 * iRed;
                row.fSalePrice = GetSalePriceD(row, Page.getFieldValue("iBscDataStockMRecNo"));
                var aaa = getSDPromotionD(row.iBscDataStyleMRecNo, row.sClassID);
                if (aaa.fPrice == null) {
                    if (aaa.fDisCount == null) {
                        aaa.fDisCount = 10;
                    }
                    row.fDisCount = aaa.fDisCount;
                    GetNewPrice([row]);
                    row.fTotal = row.fPrice * row.iQty;
                }
                else {
                    row.fPrice = aaa.fPrice;
                    if (isNaN(parseFloat(row.fSalePrice)) == false) {
                        var fDisCount = row.fPrice / parseFloat(row.fSalePrice) * 10;
                        row.fDisCount = fDisCount;
                    }
                }
                return row;
            }
        }


        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "497" || uniqueid == "499") {
                var rows = $("#table1").datagrid("getRows");
                if (rows.length > 0) {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        fPriceSum += (rows[i].fPrice == null ? 0 : rows[i].fPrice) * rows[i].iQty;
                        fSalePriceSum += (rows[i].fSalePrice == null ? 0 : rows[i].fSalePrice) * rows[i].iQty;
                    }
                    Page.setFieldValue("fPriceSum", fPriceSum);
                    Page.setFieldValue("fSalePriceSum", fSalePriceSum);
                }
                Page.Children.ReloadFooter("table1");
            }
        }

        Page.Formula = function (field) {
            if (field == "fPriceSum") {
                if (fPriceSum > 0 && fSalePriceSum > 0) {
                    Page.setFieldValue("fRealTotal", fSalePriceSum - fPriceSum);
                }
                else if (fPriceSum < 0 && fSalePriceSum < 0) {
                    Page.setFieldValue("fRealTotal", fSalePriceSum - fPriceSum);
                }
                else if (fSalePriceSum == 0 || fSalePriceSum == "" || fSalePriceSum == null || fSalePriceSum == undefined) {
                    Page.setFieldValue("fRealTotal", 0);
                }
            }
            if (field == "fSalePriceSum") {
                if (fPriceSum > 0 && fSalePriceSum > 0) {
                    Page.setFieldValue("fRealTotal", fSalePriceSum - fPriceSum);
                }
                else if (fPriceSum < 0 && fSalePriceSum < 0) {
                    Page.setFieldValue("fRealTotal", fSalePriceSum - fPriceSum);
                }
                else if (fSalePriceSum == 0 || fSalePriceSum == "" || fSalePriceSum == null || fSalePriceSum == undefined) {
                    Page.setFieldValue("fRealTotal", 0);
                }
            }
        }

        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "181") {
                //var iRed = Page.getFieldValue("iRed") == "1" ? -1 : 1;
                row.iQty = 1;
                row.fSalePrice = GetSalePriceD(row, Page.getFieldValue("iBscDataStockMRecNo"));
                var aaa = getSDPromotionD(row.iBscDataStyleMRecNo, row.sClassID);
                if (aaa.fPrice == null) {
                    if (aaa.fDisCount == null) {
                        aaa.fDisCount = 10;
                    }
                    row.fDisCount = aaa.fDisCount;
                    GetNewPrice([row]);
                    row.fTotal = row.fPrice * row.iQty;
                }
                else {
                    row.fPrice = aaa.fPrice;
                    if (isNaN(parseFloat(row.fSalePrice)) == false) {
                        var fDisCount = row.fPrice / parseFloat(row.fSalePrice) * 10;
                        row.fDisCount = fDisCount;
                    }
                }

                var rows = $("#table1").datagrid("getRows");
                if (rows.length > 0) {
                    for (var i = 0; i < rows.length; i++) {
                        if (rows[i].sBarCode == row.sBarCode) {
                            $.messager.show({
                                title: '错误',
                                msg: '不可转入相同数据！',
                                timeout: 1000,
                                showType: 'show',
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                            return false;
                        }
                    }
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        fPriceSum += (rows[i].fPrice == null ? 0 : rows[i].fPrice) * rows[i].iQty;
                        fSalePriceSum += (rows[i].fSalePrice == null ? 0 : rows[i].fSalePrice) * rows[i].iQty;
                    }
                    Page.setFieldValue("fPriceSum", fPriceSum);
                    Page.setFieldValue("fSalePriceSum", fSalePriceSum);
                }
                else {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    Page.setFieldValue("iQty", 0);
                    Page.setFieldValue("fTotal", 0);
                    Page.setFieldValue("fRealTotal", 0);
                }
                return row;
            }
        }

        dataForm.afterSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "181") {
                var rows = $("#table1").datagrid("getRows");
                if (rows.length > 0) {
                    fPriceSum = 0;
                    fSalePriceSum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        fPriceSum += (rows[i].fPrice == null ? 0 : rows[i].fPrice) * rows[i].iQty;
                        fSalePriceSum += (rows[i].fSalePrice == null ? 0 : rows[i].fSalePrice) * rows[i].iQty;
                    }
                    Page.setFieldValue("fPriceSum", fPriceSum);
                    Page.setFieldValue("fSalePriceSum", fSalePriceSum);
                }
            }
        }

        function KeyDown1() {
            if (event.keyCode == 119) {
                $('#win').window('close');
                $('#txtBarcode').focus();
            }
            if (event.keyCode == 13) {
                event.keyCode = 9;
            }
        }
        //获取吊牌价
        function GetSalePriceD(data, iBscDataStockMRecNo) {
            var fSalePrice = undefined;
            var sqlObj = {
                TableName: "BscDataStyleM",
                Fields: "iShop,iPriceType,fSalePrice",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + data.iBscDataStyleMRecNo + "'"
                    }
                ]
            }
            var StyleData = SqlGetData(sqlObj);
            if (StyleData.length > 0) {
                if (StyleData[0].iShop != "1" && StyleData[0].iPriceType == "0") {
                    fSalePrice = StyleData[0].fSalePrice;
                }
                else {
                    var sqlDetailObj = {
                        TableName: "vwbscDataStyleMDPrice",
                        Fields: "ibscDataStockMRecNo,ibscDataColorRecNo,sSizeName,fSalePrice,iShop,iPriceType",
                        SelectAll: "True",
                        Filters: [{
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "'" + data.iBscDataStyleMRecNo + "'"
                        }]
                    };
                    var StylePriceData = SqlGetData(sqlDetailObj);
                    if (StylePriceData.length > 0) {
                        if (StyleData[0].iShop != "1" && StyleData[0].iPriceType != "0") {
                            if (StyleData.iPriceType == "1") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataColorRecNo == data.iBscDataColorRecNo) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                            else if (StyleData.iPriceType == "2") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].sSizeName == data.sSizeName) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                            else if (StyleData.iPriceType == "3") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataColorRecNo == data.iBscDataColorRecNo && StylePriceData[j].sSizeName == data.sSizeName) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                        }
                        else {
                            if (StyleData.iPriceType == "0") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataStockMRecNo == iBscDataStockMRecNo) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                            else if (StyleData.iPriceType == "1") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataStockMRecNo == iBscDataStockMRecNo && StylePriceData[j].ibscDataColorRecNo == data.iBscDataColorRecNo) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                            else if (StyleData.iPriceType == "2") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataStockMRecNo == iBscDataStockMRecNo && StylePriceData[j].sSizeName == data.sSizeName) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                            else if (StyleData.iPriceType == "3") {
                                for (var j = 0; j < StylePriceData.length; j++) {
                                    if (StylePriceData[j].ibscDataStockMRecNo == iBscDataStockMRecNo && StylePriceData[j].ibscDataColorRecNo == data.iBscDataColorRecNo && StylePriceData[j].sSizeName == data.sSizeName) {
                                        fSalePrice = StylePriceData[j].fSalePrice;
                                        break;
                                    }
                                }
                            }
                        }
                    }

                }
                fSalePrice = fSalePrice ? fSalePrice : StyleData[0].fSalePrice;
            }
            return fSalePrice;
        }

        //获取折扣、折扣位数和单价
        function getSDPromotionD(iBscDataStyleMRecNo, sClassID) {
            var result = {
                fDisCount: null,
                iDig: null,
                fPrice: null
            }
            //sqlObj3根据类别获取促销价
            var sqlObj3 = { TableName: "vwSDPromotionD1",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'", LinkOprt: "and" },
                                    { Field: "GETDATE()", ComOprt: ">=", Value: "dBeginDate", LinkOprt: "and" },
                                    { Field: "GETDATE()", ComOprt: "<=", Value: "dEndDate"}],
                Sorts: [{
                    SortName: "dBeginDate",
                    SortOrder: "desc"
                }]
            };
            var data3 = SqlGetData(sqlObj3);
            //sqlObj4根据款号获取促销价
            var sqlObj4 = { TableName: "vwSDPromotionD1",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "iBscDataStyleMRecNo", ComOprt: "=", Value: "'" + iBscDataStyleMRecNo + "'", LinkOprt: "and" },
                                    { Field: "GETDATE()", ComOprt: ">=", Value: "dBeginDate", LinkOprt: "and" },
                                    { Field: "GETDATE()", ComOprt: "<=", Value: "dEndDate"}],
                Sorts: [{
                    SortName: "dBeginDate",
                    SortOrder: "desc"
                }]
            };
            var data4 = SqlGetData(sqlObj4);
            //获取促销单新价格以及折扣
            if (data3.length == 0 && data4.length == 0) {
                //从会员卡获取折扣
                var CardNumber = Page.getFieldValue("sCardNumber");
                if (CardNumber != "") {
                    var sqlObj5 = { TableName: "vwbscMemberShip",
                        Fields: "iRecNo,fDiscount",
                        SelectAll: "True",
                        Filters: [{ Field: "sCardNumber", ComOprt: "=", Value: "'" + CardNumber + "'"}]
                    };
                    var data5 = SqlGetData(sqlObj5);
                    if (data5.length > 0) {
                        result.fDisCount = data5[0].fDiscount;
                        //return data5[0].fDiscount;
                    }
                }
            }
            else if (data3.length > 0 && data4.length == 0) {
                result.fDisCount = data3[0].fDisCount;
                result.iDig = data3[0].iDig;
                //result.fPrice = data3[0].fPrice;
            }
            else if (data3.length == 0 && data4.length > 0) {
                result.fDisCount = data4[0].fDisCount;
                result.fPrice = data4[0].fPrice;
                result.iDig = data4[0].iDig;
            }
            else {
                if (data3[0].iRecNo == data4[0].iRecNo) {
                    //return data3[0].fDisCount;
                    result.fDisCount = data3[0].fDisCount;
                    result.iDig = data3[0].iDig;
                }
                else {
                    if (data3[0].dBeginDate > data4[0].dBeginDate) {
                        //return data3[0].fDisCount;
                        result.fDisCount = data3[0].fDisCount;
                        result.iDig = data3[0].iDig;
                    }
                    else {
                        //return data4[0].fDisCount;
                        result.fDisCount = data4[0].fDisCount;
                        result.fPrice = data4[0].fPrice;
                        result.iDig = data4[0].iDig;
                    }
                }
            }
            return result;
        }

        //        //获取款号折扣
        //        function getDiscount(iBscDataStyleMRecNo, sClassID) {
        //            //从会员卡获取折扣
        //            var CardNumber = Page.getFieldValue("sCardNumber");
        //            if (CardNumber != "") {
        //                var sqlObj5 = { TableName: "vwbscMemberShip",
        //                    Fields: "iRecNo,fDiscount",
        //                    SelectAll: "True",
        //                    Filters: [{ Field: "sCardNumber", ComOprt: "=", Value: "'" + CardNumber + "'"}]
        //                };
        //                var data5 = SqlGetData(sqlObj5);
        //                if (data5.length > 0) {
        //                    return data5[0].fDiscount;
        //                }
        //            }
        //        }

        //获取新价格
        function GetNewPrice(addRow) {
            addRow[0].Price = addRow[0].fSalePrice * (addRow[0].fDisCount / 10);
            addRow[0].iDig = isNaN(parseInt(addRow[0].iDig)) ? 3 : addRow[0].iDig;
            if (addRow[0].iDig == 1) {
                addRow[0].fPrice = addRow[0].Price.toFixed(2);
            }
            if (addRow[0].iDig == 2) {
                addRow[0].fPrice = addRow[0].Price.toFixed(1);
            }
            if (addRow[0].iDig == 3) {
                addRow[0].fPrice = Math.round(addRow[0].Price);
            }
            if (addRow[0].iDig == 4) {
                addRow[0].fPrice = Math.round((addRow[0].Price / 10)) * 10;
            }
            if (addRow[0].iDig == 5) {
                addRow[0].fPrice = Math.round((addRow[0].Price / 100)) * 100;
            }
        }
        
        var needPrint = true;
        //notNeed=1则不用打印，否则要打印
        function Save(notNeed) {
            needPrint = notNeed = "1" ? false : true;
            Page.toolBarClick({ id: "__save" });
        }

        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }

        if (Page.usetype == "add") {
            document.onkeyup = function () {
                if (event.keyCode == 120) {
                    gowin();
                }
                else if (event.keyCode == 119) {
                    $('#win').window('close');
                    $('#txtBarcode').focus();
                }
            }
        }

        function gowin() {
            if ($("#__ExtCheckbox21")[0].checked == false) {
                $('#amount').text("销售金额");
            }
            else {
                $('#amount').text("退货金额");
            }
            var WriteMoney = Page.getFieldValue("fTotal");
            if ($("#__ExtCheckbox21")[0].checked == true) {
                WriteMoney = WriteMoney * (-1);
            }
            Page.setFieldValue("amount", WriteMoney);

            Page.setFieldValue("fCashMoney", "");
            Page.setFieldValue("fScoreMoney", "");
            Page.setFieldValue("fCardScore", "");
            Page.setFieldValue("fRemitMoney", "");
            Page.setFieldValue("fCardMoney", "");

            Page.setFieldValue("fWriteMoney", "");
            Page.setFieldValue("fToken", "");
            //Page.setFieldValue("fCardMoney", "");

            var bscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
            var CardNumber = Page.getFieldValue("sCardNumber");
            if (CardNumber != "") {
                //获取会员积分\储值
                var sqlObj = { TableName: "bscMemberShip",
                    Fields: "isnull(iIntegral,0) as iIntegral,isnull(fStoredMoney,0) as fStoredMoney",
                    SelectAll: "True",
                    Filters: [{ LeftParenthese: "(", Field: "sCardNumber", ComOprt: "=", Value: "'" + CardNumber + "'", RightParenthese: ")"}]
                };
                var data = SqlGetData(sqlObj);

                var sqlObj2 = { TableName: "bscMemberShipOption",
                    Fields: "iMoneyBase,iSaleIntegralBase",
                    SelectAll: "True"
                    //Filters: [{ Field: "ibscDataStockMRecNo", ComOprt: "=", Value: "'" + bscDataStockMRecNo + "'"}]
                };
                var data2 = SqlGetData(sqlObj2);

                if (data.length > 0) {
                    var iIntegral = isNaN(parseInt(data[0].iIntegral)) ? 0 : parseInt(data[0].iIntegral);
                    Page.setFieldValue("iIntegral", iIntegral + "（剩余积分）");
                    fStoredMoneyAmount = isNaN(parseFloat(data[0].fStoredMoney)) ? 0 : parseFloat(data[0].fStoredMoney);
                    Page.setFieldValue("fStoredMoney", data[0].fStoredMoney + "（剩余储值金额）");
                    if (data2.length > 0) {
                        //获得积分
                        if (isNaN(parseInt(data2[0].iSaleIntegralBase)) == false) {
                            var iSalesIntegral = WriteMoney / parseInt(data2[0].iSaleIntegralBase);
                            Page.setFieldValue("iSalesIntegral", iSalesIntegral.toFixed(0));
                        }
                        //                        //积分兑换金额
                        //                        if (iIntegral = 0) {
                        //                            A = 1;
                        //                        }
                        //                        else {
                        //                            A = data2[0].iMoneyBase / 100;
                        //                        }
                        A = data2[0].iMoneyBase;
                        if (isNaN(parseInt(A)) == false) {
                            IntegralAmount = (data[0].iIntegral / 100) * parseInt(A);
                            Page.setFieldValue("iCurIntegral", IntegralAmount + "（可用积分金额）");
                        }
                        else {
                            Page.setFieldValue("iCurIntegral", "请先设置积分兑换比例");
                        }
                    }
                    else {
                        Page.setFieldValue("iCurIntegral", "请先设置积分兑换比例");
                    }
                }
                else {
                    Page.setFieldValue("iCurIntegral", 0 + "（可用积分金额）");
                    Page.setFieldValue("iIntegral", 0 + "（剩余积分）");
                    Page.setFieldValue("fStoredMoney", 0 + "（剩余储值金额）");
                }
            }
            else {
                Page.setFieldValue("iCurIntegral", 0 + "（可用积分金额）");
                Page.setFieldValue("fStoredMoney", 0 + "（剩余储值金额）");
                Page.setFieldValue("iIntegral", 0 + "（剩余积分）");
            }
            $('#win').window('open');
            $('#__ExtTextBox25').textbox("textbox").focus();
        }

        //计算找零
        function getLeftTotal() {
            var iRed = Page.getFieldValue("iRed") == "1" ? -1 : 1;
            var fScoreMoney = $('#__ExtTextBox12').textbox("textbox").val()*iRed; //积分金额
            if (fScoreMoney > IntegralAmount && fScoreMoney != "") {
                $.messager.show({
                    title: '错误',
                    msg: '积分金额不能大于可使用积分金额！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }

            var fCardScore = $('#__ExtTextBox16').textbox("textbox").val() * iRed;
            fCardScore = isNaN(parseFloat(fCardScore)) ? 0 : parseFloat(fCardScore) * iRed;
            if (fCardScore > fStoredMoneyAmount && fCardScore != "") {
                $.messager.show({
                    title: '错误',
                    msg: '储值金额不能大于可使用储值金额！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
            var fCashMoney = $('#__ExtTextBox25').textbox("textbox").val(); //现金
            var amount = Page.getFieldValue("amount");
            var fCardMoney = $('#__ExtTextBox26').textbox("textbox").val(); //刷卡
            var fRemitMoney = $('#__ExtTextBox28').textbox("textbox").val(); //转账
            var fWriteMoney = $('#__ExtTextBox29').textbox("textbox").val(); //签单金额
            var fToken = $('#__ExtTextBox19').textbox("textbox").val(); //代金券
            var fCardScore = $('#__ExtTextBox16').textbox("textbox").val(); //储值金
            Page.setFieldValue("fLeftTotal", Number(fScoreMoney) + Number(fCashMoney) + Number(fCardMoney) + Number(fRemitMoney) + Number(fWriteMoney) + Number(fToken) + Number(fCardScore) - Number(amount));
        }

        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed") == "1" ? -1 : 1;
            var fScoreMoney = Page.getFieldValue("fScoreMoney");
            var fLeftTotal = Page.getFieldValue("fLeftTotal");
            var fCardScore = Page.getFieldValue("fCardScore");
            fScoreMoney = isNaN(parseFloat(fScoreMoney)) ? 0 : parseFloat(fScoreMoney) * iRed;
            fLeftTotal = isNaN(parseFloat(fLeftTotal)) ? 0 : parseFloat(fLeftTotal) * iRed;
            fCardScore = isNaN(parseFloat(fCardScore)) ? 0 : parseFloat(fCardScore) * iRed;
            if (fScoreMoney > IntegralAmount && fScoreMoney != "") {
                Page.MessageShow("金额超出", "积分金额不能大于可使用积分金额！");
                return false;
            }
            else if (fCardScore > fStoredMoneyAmount && fCardScore != "") {
                Page.MessageShow("金额超出", "储值金额不能大于可使用储值金额！");
                return false;
            }
            else if (fLeftTotal < 0) {
                Page.MessageShow("错误", "支付金额不足！");
                return false;
            }


            var iBscDataStockMRecNo = Page.getFieldValue('iBscDataStockMRecNo');
            //3位门店+2位年+2位月+2位日+4位流水号
            var sqlStoreObj = {
                StoreProName: "SpSaleSerialNo",
                StoreParms: [{
                    ParmName: "@iBscDataStockMRecNo",
                    Value: iBscDataStockMRecNo
                }]
            }

            var storeResult = SqlStoreProce(sqlStoreObj);
            if (storeResult) {
                Page.setFieldValue('sBillNo', storeResult); //设置流水号
            }
            else {
                Page.MessageShow("出错", "获取流水号时发生错误！");
                return false;
            }
            if ($("#__ExtCheckbox21")[0].checked == true) {
                var fScoreMoney = Page.getFieldValue("fScoreMoney") * (-1);
                var fCashMoney = Page.getFieldValue("fCashMoney") * (-1);
                var fCardMoney = Page.getFieldValue("fCardMoney") * (-1);
                var fWriteMoney = Page.getFieldValue("fWriteMoney") * (-1);
                var fRemitMoney = Page.getFieldValue("fRemitMoney") * (-1);
                var fLeftTotal = Page.getFieldValue("fLeftTotal") * (-1);
                var iSalesIntegral = Page.getFieldValue("iSalesIntegral") * (-1);
                var fCardScore = Page.getFieldValue("fCardScore") * (-1);
                Page.setFieldValue("fScoreMoney", fScoreMoney);
                Page.setFieldValue("fCashMoney", fCashMoney);
                Page.setFieldValue("fCardMoney", fCardMoney);
                Page.setFieldValue("fWriteMoney", fWriteMoney);
                Page.setFieldValue("fRemitMoney", fRemitMoney);
                Page.setFieldValue("fLeftTotal", fLeftTotal);
                Page.setFieldValue("iSalesIntegral", iSalesIntegral);
                Page.setFieldValue("fCardScore", fCardScore);

                //优惠金额
                var fRealTotal = Page.getFieldValue("fRealTotal") * (-1);
                Page.setFieldValue("fRealTotal", fRealTotal);
            }
            var fScoreMoney = Page.getFieldValue("fScoreMoney");
            if (isNaN(parseInt(fScoreMoney)) == false && isNaN(parseInt(A)) == false) {
                Page.setFieldValue("fUseScore", parseInt(fScoreMoney) * 100 / parseInt(A));
            }
        }

        Page.afterSave = function () {
            submitAndPrint();
        }

        function submitAndPrint() {
            var btnid = "submit";
            //            if ($("#__ExtCheckbox21")[0].checked == true) {
            //                btnid = "submitcancel";
            //            }
            var jsonobj1 = {
                StoreProName: "SpSaleSubmit",
                StoreParms: [{
                    ParmName: "@iformid",
                    Value: 36236
                }, {
                    ParmName: "@keys",
                    Value: Page.key
                }, {
                    ParmName: "@userid",
                    Value: Page.userid
                }, {
                    ParmName: "@btnid",
                    Value: btnid
                }]
            }
            var Result1 = SqlStoreProce(jsonobj1);
            if (Result1 != "1") {
                alert("提交时发生错误: " + Result1);
                //Page.usetype = "add";
                //isSaved = true;
            }
            else {
                if (needPrint == true) {
                    document.getElementById("print").src = "/Base/PbPage.aspx?otype=print&iformid=36236&irecno=19&key=" + Page.key + "";
                    setTimeout(function () {
                        var reload = document.getElementById("reload");
                        var pagehref = window.location.href;
                        reload.href = pagehref + "&random=" + Math.random();
                        reload.click();
                    }, 2000);
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden;">
                    <div style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox32" Z_FieldID="fUseScore" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>
                                流水号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                            </td>
                            <td>
                                会员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sCardNumber" />
                            </td>
                            <td>
                                门店
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                            </td>
                            <td>
                                导购员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sSaleID" Z_readOnly="False" />
                            </td>
                            <td rowspan="2" width="90px">
                            </td>
                            <td rowspan="2">
                                <a id="gowin" href="javascript:void(0)" class="easyui-linkbutton" onclick="gowin()">
                                    <span style="font-family: 方正姚体; font-size: large; color: #FF0000;">按F9结算</span></a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8">
                                <table>
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRed" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox21">
                                                是否退货</label>
                                        </td>
                                        <td>
                                            <strong>请扫入条码</strong>
                                        </td>
                                        <td colspan="3">
                                            <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 400px;
                                                height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                                        </td>
                                        <td colspan="2">
                                            <textarea id="txaBarcodeTip" style="height: 40px; width: 310px;" readonly="readonly"
                                                class="txb"></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <div class="easyui-tabs" data-options="fit:true">
                        <div data-options="fit:true" title="成品出库明细">
                            <table id="table1" tablename="MMProductOutD">
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'south',border:false" style="height: 60px">
                    <br />
                    <table width="75%">
                        <tr>
                            <td style="font-family: 微软雅黑; font-size: 20px">
                                总数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iQty" Z_FieldType="数值" />
                            </td>
                            <td style="font-family: 微软雅黑; font-size: 20px">
                                销售金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fTotal" Z_FieldType="数值" />
                            </td>
                            <td style="font-family: 微软雅黑; font-size: 20px">
                                优惠金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fRealTotal" Z_FieldType="数值" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                单据类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iType" Z_Value="1" />
                            </td>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Z_Value="0" />
                            </td>
                            <td>
                                出库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dDate" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iSDSendMRecNo" Z_Value="0" />
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sYearMonth" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                            </td>
                            <td>
                                录入时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                单价和
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldType="数值" Z_NoSave="True"
                                    Z_FieldID="fPriceSum" />
                            </td>
                            <td>
                                零售价和
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldType="数值" Z_NoSave="True"
                                    Z_FieldID="fSalePriceSum" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="win" class="easyui-window" title="订单提交" style="width: 600px; height: 400px"
            data-options="modal:true,collapsible:false,minimizable:false,maximizable:false"
            onkeydown="KeyDown1()">
            <table align="center">
                <tr>
                    <br />
                    <td style="font-family: 宋体; font-size: 35px" colspan="2">
                        <span id="amount">销售金额</span>
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldType="数值" Z_NoSave="True"
                            Z_FieldID="amount" Width="280px" Z_readOnly="True" Height="50px" Font-Size="30px" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="2">
                        积 分 金 额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fScoreMoney" Z_FieldType="数值"
                            Width="150px" Z_decimalDigits="2" />
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iCurIntegral" Z_FieldType="数值"
                            Width="150px" Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="2">
                        销 售 积 分
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="iSalesIntegral" Z_FieldType="数值"
                            Width="150px" Z_readOnly="True" />
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iIntegral" Z_FieldType="数值"
                            Width="150px" Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="2">
                        储 值 金 额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fCardScore" Z_FieldType="数值"
                            Width="150px" Z_decimalDigits="2" />
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fStoredMoney" Z_FieldType="数值"
                            Width="150px" Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        现 金
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="fCashMoney" Z_FieldType="数值"
                            Width="100px" />
                    </td>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        转 账
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fRemitMoney" Z_FieldType="数值"
                            Width="100px" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        刷 卡
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="fCardMoney" Z_FieldType="数值"
                            Width="100px" />
                    </td>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        刷卡机
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBank" Width="96px" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        签单金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fWriteMoney" Z_FieldType="数值"
                            Width="100px" />
                    </td>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        签单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sWriteName" Width="96px" />
                    </td>
                </tr>
                <tr>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        代价券
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fToken" Z_FieldType="数值"
                            Width="100px" />
                    </td>
                    <td style="font-family: 微软雅黑; font-size: medium;">
                        找 零
                    </td>
                    <td>
                        <a href="javascript:void(0)" onclick="getLeftTotal()">
                            <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fLeftTotal" Z_FieldType="数值"
                                Width="100px" Z_readOnly="True" />
                        </a>
                    </td>
                </tr>
                <tr align="center">
                    <td colspan="4">
                        <br />
                        <br />
                        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 170px; height: 50px"
                            onclick="Save()"><span style="font-size: 12px">打印并提交</span></a>
                    </td>
                </tr>
                <tr id="trgzfs" style="display:none; text-align:center;">
                    <td colspan="4">
                        <br />
                        <br />
                        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 170px; height: 50px"
                            onclick="Save('1')"><span style="font-size: 12px">提交不打印</span></a>
                    </td>
                </tr>
            </table>
        </div>
        <div id="win1" style="display: none;">
            <iframe src="" id="print"></iframe>
        </div>
    </div>
</asp:Content>
