<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="JS/MMProductOutM.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script type="text/javascript">

        $(function () {
            Page.Children.toolBarBtnEnabled("MMProductOutD", "export");
            Page.Children.toolBarBtnEnabled("MMProductOutD", "add");
            Page.Children.toolBarBtnAdd("MMProductOutD", "updateStockD", "仓位匹配", "tool", function () {
                var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                var rows = $("#MMProductOutD").datagrid("getRows");
                $(rows).each(function (i, r) {
                    var sStyleID = r.iBscDataStyleMRecNo;
                    var ColorID = r.iBscDataColorRecNo;
                    if (sStyleID) {
                        var sqlObj = {
                            TableName: "vwMMProductStockQty",
                            Fields: "iBscDataStockDRecNo,sBerchID",
                            SelectAll: "True",
                            Filters: [{
                                Field: "isnull(iBscDataStockMRecNo,0)",
                                ComOprt: "=",
                                Value: "'" + iBscDataStockMRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataStyleMRecNo",
                                ComOprt: "=",
                                Value: sStyleID,
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataColorRecNo",
                                ComOprt: "=",
                                Value: ColorID
                            }
                            ]
                        }
                        var result = SqlGetData(sqlObj);
                        //alert(result.length)
                        if (result.length > 0) {
                            var rr = {};
                            rr.iBscDataStockDRecNo = result[0].iBscDataStockDRecNo;
                            rr.sBerchID = result[0].sBerchID;
                            var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                            $("#MMProductOutD").datagrid("updateRow", {
                                index: rowindex, row: rr
                            });
                        }

                    }
                })
            });
            Page.Children.toolBarBtnAdd("MMProductOutD", "updateStockD", "客户修改为盈德利", "tool", function () {
                var rows = $("#MMProductOutD").datagrid("getRows");
                $(rows).each(function (i, r) {

                    var rr = {};
                    rr.sCustShortName = "盈德利";
                    rr.iStockBscDataCustomerMRecNo = 162;
                    var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                    $("#MMProductOutD").datagrid("updateRow", {
                        index: rowindex, row: rr
                    });


                })
            });
            Page.Children.toolBarBtnAdd("MMProductOutD", "updateStockD", "价格更新", "tool", function () {
                var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                var rows = $("#MMProductOutD").datagrid("getRows");
                //alert(rows.length)
                if (iSDSendMRecNo) {
                    $(rows).each(function (i, r) {
                        var sStyleID = r.iBscDataStyleMRecNo;
                        //alert(sStyleID)
                        if (sStyleID) {
                            var sqlObj = {
                                TableName: "SDSendD",
                                Fields: "fPrice",
                                SelectAll: "True",
                                Filters: [{
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: "'" + iSDSendMRecNo + "'",
                                    LinkOprt: "and"
                                },
                            {
                                Field: "iBscDataStyleMRecNo",
                                ComOprt: "=",
                                Value: sStyleID
                            }
                                ]
                            }
                            var result = SqlGetData(sqlObj);
                            if (result.length > 0) {
                                var rr = {};
                                rr.fPrice = result[0].fPrice;
                                rr.fTotal = (parseFloat(r.iQty) || 0) * rr.fPrice;
                                var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                                $("#MMProductOutD").datagrid("updateRow", {
                                    index: rowindex, row: rr
                                });
                            }

                        }
                    })
                    Page.Children.ReloadFooter('MMProductOutD');
                }
                else {
                    $(rows).each(function (i, r) {
                        var sStyleID = r.iBscDataStyleMRecNo;
                        //alert(sStyleID)
                        if (sStyleID) {
                            var sqlObj = {
                                TableName: "BscDataStyleM",
                                Fields: "fSalePrice",
                                SelectAll: "True",
                                Filters: [
                                    {
                                        Field: "iRecNo",
                                        ComOprt: "=",
                                        Value: sStyleID
                                    }
                                ]
                            }
                            var result = SqlGetData(sqlObj);
                            if (result.length > 0) {
                                var rr = {};
                                rr.fPrice = result[0].fSalePrice;
                                rr.fTotal = (parseFloat(r.iQty) || 0) * rr.fPrice;
                                var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                                $("#MMProductOutD").datagrid("updateRow", {
                                    index: rowindex, row: rr
                                });
                            }

                        }
                    })
                    Page.Children.ReloadFooter('MMProductOutD');
                }
            });
            Page.Children.toolBarBtnAdd("MMProductOutD", "updateStockD", "显示差异", "tool", function () {
                $("#divDiff").dialog("open");
            });

            Page.Children.onAfterEdit = function (tableid, index, row, changes) {
                if (tableid == "MMProductOutD") {
                    // alert(datagridOp.currentColumnName.indexOf("S"));
                    if (datagridOp.currentColumnName.indexOf("S") > -1 || datagridOp.currentColumnName.indexOf("M") > -1 || datagridOp.currentColumnName.indexOf("L") > -1 || datagridOp.currentColumnName.indexOf("F") > -1) {
                        var iQty = isNaN(parseInt(row.iQty)) ? 0 : row.iQty;
                        var fPrice = isNaN(parseInt(row.fPrice)) ? 0 : row.fPrice;
                        var fTotal = iQty * fPrice;
                        var updateData = {
                            fTotal: fTotal
                        };
                        $("#MMProductOutD").datagrid("updateRow", { index: index, row: updateData });
                        Page.Children.ReloadFooter("MMProductOutD");
                    }
                }
            }

            $("#tabDiff").datagrid({
                fit: true,
                columns: [
                    [
                        { title: "款号", field: "sStyleNo", width: 80, align: "center" },
                        { title: "颜色", field: "sColorName", width: 60, align: "center" },
                        { title: "尺码", field: "sSizeName", width: 40, align: "center" },
                        { title: "发货数量", field: "iQty", width: 80, align: "center" },
                        { title: "通知单数量", field: "iSendNotOutQty", width: 80, align: "center" },
                        {
                            title: "差异数", field: "iDiffQty", width: 80, align: "center", styler: function (value, row, index) {
                                return 'color:red;';
                            }

                        },
                        { title: "通知单号", field: "sBillNo", width: 110, align: "center" }
                    ]
                ],
                singleSelect: true,
                showFooter: true
            })

            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlObj = {
                    TableName: "vwMMProductOutDDiffD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "in",
                            Value: "(select iRecNo from MMProductOutD where iMainRecNo='" + Page.key + "')"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "sBillNo",
                            SortOrder: "desc"
                        },
                        {
                            SortName: "sStyleNo",
                            SortOrder: "asc"
                        },
                        {
                            SortName: "sColorName",
                            SortOrder: "asc"
                        },
                        {
                            SortName: "sSizeName",
                            SortOrder: "asc"
                        }
                    ]
                }
                var resultDiff = SqlGetData(sqlObj);
                if (resultDiff.length > 0) {
                    $("#tabDiff").datagrid("loadData", resultDiff);
                    var iDiffQtySum = 0;
                    var iSendNotOutQtySum = 0;
                    var iQtySum = 0;
                    $.each(resultDiff, function (index, o) {
                        iDiffQtySum += Number(o.iDiffQty);
                        iSendNotOutQtySum += isNaN(Number(o.iSendNotOutQty)) ? 0 : Number(o.iSendNotOutQty);
                        iQtySum += Number(o.iQty);
                    })
                    $("#tabDiff").datagrid("reloadFooter", [{ sStyleNo: "合计", iDiffQty: iDiffQtySum, iSendNotOutQty: iSendNotOutQtySum, iQty: iQtySum}]);
                    $("#divDiff").dialog("open");
                }
            }
        });
        Page.beforeSave = function () {
            var rows = $("#MMProductOutD").datagrid("getRows");
            var iRed = Page.getFieldValue('iRed');
            var fTotalAll = 0;
            $(rows).each(function (i, r) {
                var NewiQty = (parseFloat(r.iQty) || 0);
                var NewfPrice = (parseFloat(r.fPrice) || 0);
                var NewfTotal = NewiQty * NewfPrice;
                var rr = {};
                rr.fTotal = NewfTotal;
                fTotalAll = fTotalAll + NewfTotal;
                var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                $("#MMProductOutD").datagrid("updateRow", {
                    index: rowindex, row: rr
                });

            })
            Page.setFieldValue("fTotal", fTotalAll);
            //alert(iRed)
            $(rows).each(function (i, r) {
                if (iRed == '1') {
                    if (r.iQty && isNaN(parseFloat(r.iQty)) == false && parseFloat(r.iQty) > 0) {
                        var rr = {};
                        rr.iQty = (parseFloat(r.iQty) || 0) * -1;
                        rr.fTotal = (parseFloat(r.fTotal) || 0) * -1;
                        rr.S = (parseFloat(r.S) || 0) * -1;
                        rr.M = (parseFloat(r.M) || 0) * -1;
                        rr.L = (parseFloat(r.L) || 0) * -1;
                        rr.XL = (parseFloat(r.XL) || 0) * -1;
                        rr["2XL"] = (parseFloat(r["2XL"]) || 0) * -1;
                        rr["3XL"] = (parseFloat(r["3XL"]) || 0) * -1;
                        rr["4XL"] = (parseFloat(r["4XL"]) || 0) * -1;
                        rr.F = (parseFloat(r.F) || 0) * -1;
                        var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                        $("#MMProductOutD").datagrid("updateRow", {
                            index: rowindex, row: rr
                        });
                    }

                } else {
                    if (r.iQty && isNaN(parseFloat(r.iQty)) == false && parseFloat(r.iQty) < 0) {
                        var rr = {};
                        rr.iQty = (parseFloat(r.iQty) || 0) * -1;
                        rr.fTotal = (parseFloat(r.fTotal) || 0) * -1;
                        rr.S = (parseFloat(r.S) || 0) * -1;
                        rr.M = (parseFloat(r.M) || 0) * -1;
                        rr.L = (parseFloat(r.L) || 0) * -1;
                        rr.XL = (parseFloat(r.XL) || 0) * -1;
                        rr["2XL"] = (parseFloat(r["2XL"]) || 0) * -1;
                        rr["3XL"] = (parseFloat(r["3XL"]) || 0) * -1;
                        rr["4XL"] = (parseFloat(r["4XL"]) || 0) * -1;
                        rr.F = (parseFloat(r.F) || 0) * -1;
                        var rowindex = $("#MMProductOutD").datagrid("getRowIndex", r);

                        $("#MMProductOutD").datagrid("updateRow", {
                            index: rowindex, row: rr
                        });
                    }
                }
            })
            Page.Children.ReloadFooter('MMProductOutD');
            isSaving = true;
        }
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var sBarCode = $("#txtBarcode").val();
                $("#txtBarcode").val("");
                if (sBarCode) { } else {
                    event.preventDefault();
                    return;
                }
                var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo") || "";
                var sBerChID = $("#__ExtTextBox9").textbox("getText");
                var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                //非红冲时,

                if (true) {//if (Page.getFieldValue("iRed") != "1") {
                    if (!iBscDataStockMRecNo) {
                        $("#sbarcoderemark").html("非红冲时,仓库不能为空\n" + $("#sbarcoderemark").html());
                        event.preventDefault();
                        return;
                    }
                    var sqlObj = {
                        //表名或视图名
                        TableName: "vwMMProductStockQty",
                        //选择的字段
                        Fields: "*",
                        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                        SelectAll: "True",
                        //过滤条件，数组格式
                        Filters: [
                            {
                                Field: "sBarCodeComm",
                                ComOprt: "=",
                                Value: "'" + sBarCode + "'",
                                LinkOprt: "and"
                            }/*, {
                                Field: "isnull(iQty,0)",
                                ComOprt: ">",
                                Value: "0",
                                LinkOprt: "and"
                            }*/,
                            {
                                Field: "isnull(iBscDataStockMRecNo,0)",
                                ComOprt: "=",
                                Value: "'" + iBscDataStockMRecNo + "'",
                                LinkOprt: "and"
                            }, {
                                Field: "isnull(iBscDataCustomerRecNo,0)",
                                ComOprt: "=",
                                Value: "'" + 162 + "'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length == 0) {
                        $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                        //PlayVoiceTTS(sBarCode + "条码不存在");
                        PlayVoice("/Sound/条码不存在.mp3");
                        event.preventDefault();
                        return;
                    }
                    //                    var jsonobj = {
                    //                        StoreProName: "SpMMProductOutMBarCode",
                    //                        StoreParms: [{
                    //                            ParmName: "@sBarCode",
                    //                            Value: sBarCode
                    //                        }, {
                    //                            ParmName: "@iBscDataStockMRecNo",
                    //                            Value: iBscDataStockMRecNo
                    //                        }, {
                    //                            ParmName: "@iSDSendMRecNo",
                    //                            Value: iSDSendMRecNo
                    //                        }]
                    //                    }
                    //                    var result = SqlStoreProce(jsonobj, true);
                    //if (result && result.length > 0 && result != "-1") {
                    var theIndex = -1;
                    var allRows = $("#MMProductOutD").datagrid("getRows");
                    for (var i = 0; i < allRows.length; i++) {
                        if (allRows[i].iBscDataStockDRecNo == result[0].iBscDataStockDRecNo &&
                        allRows[i].iBscDataStyleMRecNo == result[0].iBscDataStyleMRecNo &&
                        allRows[i].iBscDataColorRecNo == result[0].iBscDataColorRecNo) {
                            theIndex = i;
                            break;
                        }
                    }
                    if (theIndex == -1) {
                        if (Page.getFieldValue("iBscDataStockMRecNo") == "164") {
                            $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                            PlayVoice("/Sound/条码不存在.mp3");
                        }
                        else {
                            var row = result[0];
                            var a = {};
                            //a.iRecNo = Page.getChildID("MMProductOutD");
                            //a.sBarCode = sBarCode;
                            a.iBscDataStockDRecNo = row.iBscDataStockDRecNo;
                            a.sBerchID = row.sBerChID;
                            a.iSdContractMRecNo = row.iSdContractMRecNo || 0;
                            a.sOrderNo = row.sOrderNo || "";
                            a.iStockBscDataCustomerMRecNo = row.iBscDataCustomerRecNo || 0;
                            a.sCustShortName = row.sCustShortName || "";
                            a.iBscDataStyleMRecNo = row.iBscDataStyleMRecNo || 0;
                            a.sStyleNo = row.sStyleNo || "";
                            a.iBscDataColorRecNo = row.iBscDataColorRecNo || 0;
                            a.sColorName = row.sColorName || "";
                            //a.sSizeName = row.sSizeName || "";
                            a[(result[0].sSizeName)] = 1;
                            a.iSdSendDRecNo = row.iSdSendDRecNo || 0;
                            a.fPrice = row.fPrice || 0;
                            a.fTotal = row.fTotal || 0;
                            Page.tableToolbarClick("add", "MMProductOutD", a);
                            Page.Children.DynFieldRowSummary("MMProductOutD", allRows.length - 1);
                            $("#sbarcoderemark").html(sBarCode + "条码扫码成功\n" + $("#sbarcoderemark").html());
                            PlayVoice("/Sound/成功.mp3");
                        }
                    }
                    else {
                        var a = {};
                        var oQty = isNaN(Number(allRows[theIndex][(result[0].sSizeName)])) ? 0 : Number(allRows[theIndex][(result[0].sSizeName)]);
                        a[(result[0].sSizeName)] = oQty + 1;
                        $("#MMProductOutD").datagrid("updateRow", { index: theIndex, row: a });
                        Page.Children.DynFieldRowSummary("MMProductOutD", theIndex);
                        $("#sbarcoderemark").html(sBarCode + "条码扫码成功\n" + $("#sbarcoderemark").html());
                        PlayVoice("/Sound/成功.mp3");
                    }

                    Page.Children.ReloadFooter("MMProductOutD");
                    Page.Children.ReloadDynFooter("MMProductOutD");
                    event.preventDefault();
                    return;
                }
                else {
                    //先从之前的出库记录中找
                    var sqlObj = {
                        //表名或视图名
                        TableName: "vwMMProductOutMDD",
                        //选择的字段
                        Fields: "*",
                        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                        SelectAll: "True",
                        //过滤条件，数组格式
                        Filters: [
                            {
                                Field: "sBarCodeComm",
                                ComOprt: "=",
                                Value: "'" + sBarCode + "'",
                                LinkOprt: "and"
                            }/*, {
                                Field: "isnull(iQty,0)",
                                ComOprt: ">",
                                Value: "0",
                                LinkOprt: "and"
                            }*/,
                            {
                                Field: "isnull(iBscDataStockMRecNo,0)",
                                ComOprt: "=",
                                Value: "'" + iBscDataStockMRecNo + "'",
                                LinkOprt: "and"
                            }, {
                                Field: "isnull(iBscDataCustomerRecNo,0)",
                                ComOprt: "=",
                                Value: "'" + iBscDataCustomerRecNo + "'",
                                LinkOprt: "and"
                            }, {
                                Field: "iRecNoM",
                                ComOprt: "<>",
                                Value: "'" + Page.key + "'",
                                LinkOprt: "and"
                            }
                            , {
                                Field: "iStatus",
                                ComOprt: ">",
                                Value: "3"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "dInputDate",
                                SortOrder: "desc"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length == 0) {
                        //找不到，则从条码表中找
                        var sqlObj = {
                            //表名或视图名
                            TableName: "vwBscBarCode",
                            //选择的字段
                            Fields: "*",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: [
                                            {
                                                Field: "sBarCode",
                                                ComOprt: "=",
                                                Value: "'" + sBarCode + "'"
                                            }
                            ]
                        }
                        var data = SqlGetData(sqlObj);
                        if (data.length == 0) {
                            $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                            PlayVoice("/Sound/条码不存在.mp3");
                            event.preventDefault();
                            return;
                        }
                        var theIndex = -1;
                        var allRows = $("#MMProductOutD").datagrid("getRows");
                        for (var i = 0; i < allRows.length; i++) {
                            if (allRows[i].iBscDataStyleMRecNo == data[0].iBscDataStyleMRecNo && allRows[i].iBscDataColorRecNo == data[0].ibscDataColorRecNo /*&& allRows[i].sSizeName == data[0].sSizeName*/) {
                                theIndex = i;
                                break;
                            }
                        }
                        if (theIndex == -1) {
                            var a = {};
                            //a.iRecNo = Page.getChildID("MMProductInD");
                            //a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductOutD").datagrid("getRows").length + 1;
                            if (iBscDataStockDRecNo) {
                                a.iBscDataStockDRecNo = iBscDataStockDRecNo;
                                a.sBerchID = Page.getFieldText("iBscDataStockDRecNo");
                            }
                            a.iStockBscDataCustomerMRecNo = iBscDataCustomerRecNo;
                            a.sCustShortName = Page.getFieldText("iBscDataCustomerRecNo");
                            a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                            a.sStyleNo = data[0].sStyleNo || "";
                            a.iBscDataColorRecNo = data[0].ibscDataColorRecNo || 0;
                            a.sColorName = data[0].sColorName || "";
                            a[(data[0].sSizeName)] = -1;
                            //a.sSizeName = data[0].sSizeName || "";
                            //a.iQty = 1;
                            Page.tableToolbarClick("add", "MMProductOutD", a);
                            //$("#MMProductInD").datagrid("appendRow", a);
                            Page.Children.DynFieldRowSummary("MMProductOutD", allRows.length - 1);
                        }
                        else {
                            var a = {};
                            var oQty = isNaN(Number(allRows[theIndex][(data[0].sSizeName)])) ? 0 : Number(allRows[theIndex][(data[0].sSizeName)]);
                            a[(data[0].sSizeName)] = -1 * (Math.abs(oQty) + 1);
                            $("#MMProductOutD").datagrid("updateRow", { index: theIndex, row: a });
                            Page.Children.DynFieldRowSummary("MMProductOutD", theIndex);
                        }
                    }
                    else {
                        var theIndex = -1;
                        var allRows = $("#MMProductOutD").datagrid("getRows");
                        for (var i = 0; i < allRows.length; i++) {
                            if (allRows[i].iBscDataStyleMRecNo == result[0].iBscDataStyleMRecNo && allRows[i].iBscDataColorRecNo == result[0].ibscDataColorRecNo) {
                                theIndex = i;
                                break;
                            }
                        }
                        if (theIndex == -1) {
                            alert(Page.getFieldValue("iBscDataStockMRecNo"))
                            if (Page.getFieldValue("iBscDataStockMRecNo") == "164") {
                                $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                                PlayVoice("/Sound/条码不存在.mp3");
                            }
                            else {
                                var a = {};
                                a.iBscDataStockDRecNo = result[0].iBscDataStockDRecNo;
                                a.sBerchID = result[0].sBerChID;
                                a.iSdContractMRecNo = result[0].iSdContractMRecNo || 0;
                                a.sOrderNo = result[0].sOrderNo || "";
                                a.iStockBscDataCustomerMRecNo = result[0].iStockBscDataCustomerMRecNo || 0;
                                a.sCustShortName = result[0].sCustShortName || "";
                                a.iBscDataStyleMRecNo = result[0].iBscDataStyleMRecNo || 0;
                                a.sStyleNo = result[0].sStyleNo || "";
                                a.iBscDataColorRecNo = result[0].iBscDataColorRecNo || 0;
                                a.sColorName = result[0].sColorName || "";
                                //a.sSizeName = row.sSizeName || "";
                                a[(result[0].sSizeName)] = -1;
                                a.iSdSendDRecNo = result[0].iSdSendDRecNo || 0;
                                a.fPrice = result[0].fPrice || 0;
                                a.fTotal = result[0].fTotal || 0;
                                Page.tableToolbarClick("add", "MMProductOutD", a);
                                Page.Children.DynFieldRowSummary("MMProductOutD", allRows.length - 1);
                            }
                        }
                        else {

                            var a = {};
                            var oQty = isNaN(Number(allRows[theIndex][(result[0].sSizeName)])) ? 0 : Number(allRows[theIndex][(result[0].sSizeName)]);
                            a[(result[0].sSizeName)] = oQty + 1;
                            $("#MMProductOutD").datagrid("updateRow", { index: theIndex, row: a });
                            Page.Children.DynFieldRowSummary("MMProductOutD", theIndex);

                            $("#sbarcoderemark").html(sBarCode + "条码扫码成功\n" + $("#sbarcoderemark").html());
                            PlayVoice("/Sound/成功.mp3");
                            Page.Children.ReloadFooter("MMProductOutD");
                            Page.Children.ReloadDynFooter("MMProductOutD");
                            event.preventDefault();

                        }
                    }
                }
                PlayVoice("/Sound/成功.mp3");
                var editIndex = $('#MMProductOutD').datagrid('getRows').length - 1;
                $("#MMProductOutD").datagrid("scrollTo", editIndex);

                event.preventDefault();
            }
        }

        dataForm.beforeOpen = function (uniqueid) {
            if (uniqueid == "56" || uniqueid == "213") {
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                if (iBscDataCustomerRecNo == "") {
                    alert("请先选择客户！");
                    return false;
                }
                var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                if (iBscDataStockMRecNo == "") {
                    alert("请先选择仓库！");
                    return false;
                }
            }
            if (uniqueid == "213") {
                var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                if (iSDSendMRecNo == "") {
                    alert("请先选择通知单！");
                    return false;
                }
            }
            if (uniqueid == "217") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    alert("只有红冲才可从已发货通知单转入！");
                    return false;
                }
                var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                if (iSDSendMRecNo == "") {
                    alert("请先选择通知单！");
                    return false;
                }
            }
        }

        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
            if (uniqueid == "56") {
                // if (iBscDataStockMRecNo != "164") {
                var dynColumns = Page.Children.GetDynColumns("MMProductOutD");
                for (var i = 0; i < dynColumns.length; i++) {
                    if (data[index][(dynColumns[i])]) {
                        row[(dynColumns[i])] = data[index][(dynColumns[i])];
                    }
                }
                //}
                //var sBerChID = Page.getFieldText("iBscDataStockDRecNo");
                //var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
                //row.sBerchID = sBerChID;
                //row.iBscDataStockDRecNo = iBscDataStockDRecNo;
                return row;
            }
            if (uniqueid == "213" || uniqueid == "217") {
                var allRows = $("#MMProductOutD").datagrid("getRows");

                //                for (var i = 0; i < allRows.length; i++) {
                //                    if (row.iRecNo == allRows[i].iSdSendDRecNo && row.iBscDataStyleMRecNo == allRows[i].iBscDataStyleMRecNo && row.iBscDataColorRecNo == allRows[i].iBscDataColorRecNo) {
                //                        alert("同一个通知单明细，相同款号颜色不能重复转入");
                //                        return false;
                //                    }
                //                }
                // if (iBscDataStockMRecNo != "164") {
                var dynColumns = Page.Children.GetDynColumns("MMProductOutD");
                for (var i = 0; i < dynColumns.length; i++) {
                    if (data[index][(dynColumns[i])]) {
                        row[(dynColumns[i])] = data[index][(dynColumns[i])];
                    }
                }
                // }
                //var sBerChID = Page.getFieldText("iBscDataStockDRecNo");
                //var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
                // row.sBerchID = sBerChID;
                //row.iBscDataStockDRecNo = iBscDataStockDRecNo;
                //alert(allRows.length);
                return row;

            }
        }

        dataForm.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            if (uniqueid == "56" || uniqueid == "213" || uniqueid == "217") {
		        //alert(2)
                Page.Children.DynFieldRowSummary("MMProductOutD", rowIndex);

                var fPrice = isNaN(Number(row.fPrice)) ? 0 : Number(row.fPrice);
                var dynColumns = Page.Children.GetDynColumns("MMProductOutD");
                var iSumQty = 0;
                for (var i = 0; i < dynColumns.length; i++) {
                    if (row[(dynColumns[i])]) {
                        iSumQty += (isNaN(Number(row[(dynColumns[i])])) ? 0 : Number(row[(dynColumns[i])]));
                    }
                }
                //var fTotal = iSumQty * fPrice;
                //$("#MMProductOutD").datagrid("updateRow", { index: rowIndex, row: { fTotal: fTotal } });
            }
        }
        dataForm.afterSelected = function (uniqueid, data) {
            if (uniqueid == "56" || uniqueid == "213" || uniqueid == "217") {
                Page.Children.ReloadFooter("MMProductOutD");
                Page.Children.ReloadDynFooter("MMProductOutD");
            }
        }

        var isSaving = false;
        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpMMProductOutSaveBuildDiff",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj, true);
            if (result.length > 0) {
                Page.DoNotCloseWinWhenSave = true;
                $("#tabDiff").datagrid("loadData", result);
                var iDiffQtySum = 0;
                var iSendNotOutQtySum = 0;
                var iQtySum = 0;
                $.each(result, function (index, o) {
                    iDiffQtySum += Number(o.iDiffQty);
                    iSendNotOutQtySum += isNaN(Number(o.iSendNotOutQty)) ? 0 : Number(o.iSendNotOutQty);
                    iQtySum += Number(o.iQty);
                })
                $("#tabDiff").datagrid("reloadFooter", [{ sStyleNo: "合计", iDiffQty: iDiffQtySum, iSendNotOutQty: iSendNotOutQtySum, iQty: iQtySum}]);
                $("#divDiff").dialog("open");
            }

        }
        var buttons = [
            {
                text: "我知道了",
                handler: function () {
                    if (isSaving == true) {
                        window.parent.CloseBillWindow();
                    }
                    $("#divDiff").dialog("close");
                }
            },
            {
                text: "取消",
                handler: function () {
                    $("#divDiff").dialog("close");
                }
            }
        ]
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden; height: 230px;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>出库单号<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>出库日期<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="日期" runat="server" Z_FieldID="dDate"
                            Z_Required="true" />
                    </td>
                    <td>成品仓库<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Z_Required="true" />
                    </td>
                    <td>出库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTypeName" />
                    </td>
                    <td rowspan="4">
                        <div id="divAddress" class="easyui-panel" data-options="title:'收货信息',iconCls:'icon-businessCard'">
                            <table class="tabmain">
                                <tr>
                                    <td>收货地址
                                    </td>
                                    <td colspan="3">
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sReceiveAddress" Style="width: 98%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>地址名
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sReceiveAddressName" Style="width: 98%;" />
                                    </td>
                                    <td>收货人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sReceivePerson" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>联系电话
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sReceiveTel" />
                                    </td>
                                    <td>业务员
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sSaleID" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>运输方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sReceiveTransType" />
                                    </td>
                                    <td>包装方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sReceivePackageType" />
                                    </td>
                                </tr>

                            </table>
                        </div>
                    </td>
                </tr>
                </td> </tr>
                <tr>
                    <td colspan="8">
                        <fieldset>
                            <table>
                                <tr>
                                    <td>通知单号<%--<em style="color: Red">*</em>--%>
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iSDSendMRecNo" />
                                    </td>
                                    <td>
                                        <span id="sp_gys">客 户</span>
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                            Z_Required="true" />
                                    </td>
                                    <%--<td>
                                        业务员
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sSaleID" />
                                    </td>--%>
                                    <td>经办人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sPersonName" />
                                    </td>
                                    <td colspan="2">出货红冲<cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                        代销发货<cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iRep" />
                                        <div style="display: none">
                                            仓位管理<cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iBerCh" Z_NoSave="true" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>

                                    <%--<td>
                                       发货调出客户
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iInBscDataCustomerRecNo"
                                            Z_Required="true" />
                                    </td>  --%>
                                    <td>会计月份
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sYearMonth" Z_disabled="true"
                                            Z_Required="true" />
                                    </td>
                                    <td>尺码组
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sSizeGroupID" />
                                    </td>
                                    <td>备注
                                    </td>
                                    <td colspan="3">
                                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Style="width: 96%;" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td>数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iQty" Z_disabled="true" />
                    </td>
                    <td>总金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fTotal" Z_disabled="true" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iType" Z_Value="0" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
            <hr />
            <table>
                <tr>
                    <td>条码
                    </td>
                    <td>
                        <%--<cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sBarCode" Z_NoSave="true"/>--%>
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 160px; height: 40px; font-size: 20px; font-weight: bold;"
                            class="txb" />
                    </td>
                    <td colspan="2">
                        <textarea id="sbarcoderemark"></textarea>
                    </td>
                    <td>仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
                    </td>
                    <td>物流公司
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sExpressCompany" />
                    </td>
                    <td>运单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sExpressNo" />
                    </td>
                    <td>送达日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dArriveDate" Z_FieldType="日期" />
                    </td>
                    <td>送达时间段
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sArriveTime" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <!--  子表1  -->
                    <table id="MMProductOutD" tablename="MMProductOutD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <table id="table2" tablename="bscDataBuildDUnit">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
    <div id="divDiff" class="easyui-dialog" title="发货差异" style="width: 600px; height: 400px;"
        data-options="modal:false,collapsible:false,minimizable:false,maximizable:false,closed:true,buttons:buttons">
        <table id="tabDiff">
        </table>
    </div>
</asp:Content>
