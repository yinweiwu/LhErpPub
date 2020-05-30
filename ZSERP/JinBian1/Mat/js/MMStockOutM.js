$(function () {
    //根据单据日期计算会计月份
    if (Page.usetype == "add") {
        var sqlObj = {
            //表名或视图名
            TableName: "bscDataPeriod",
            //选择的字段
            Fields: "sYearMonth",
            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
            SelectAll: "True",
            //过滤条件，数组格式
            Filters: [
        {
            //左括号
            //字段名
            Field: "convert(varchar(50),GETDATE(),23)",
            //比较符
            ComOprt: ">=",
            //值
            Value: "dBeginDate",
            //连接符
            LinkOprt: "and"
        },
                {
                    Field: "convert(varchar(50),GETDATE(),23)",
                    ComOprt: "<=",
                    Value: "dEndDate"
                }
        ]
        }
        var data = SqlGetData(sqlObj);

        if (data.length > 0) {

            Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
        }
    }
});

$(function () {
    //    $("#MMStockQty").datagrid({
    //        method: 'post', data: [], pagination: false, rownumbers: true, singleSelect: true,
    //        columns: [[
    //            { title: '仓位', field: 'sBerChID', width: 80 },
    //            { title: '物料编码', field: 'sCode', width: 80 },
    //            { title: '物料名称', field: 'sName', width: 80 },
    //            { title: '规格', field: 'Spec', width: 80 },
    //            { title: '数量单位', field: 'sUnitName', width: 80 },
    //            { title: '计件单位', field: 'sPurUnitName', width: 80 },
    //            { title: '供应商', field: 'sCustShortName', width: 80 },
    //            { title: '物料分类', field: 'sClassName', width: 80 },
    //            { title: '条码', field: 'sBatchNo', width: 80 },
    //            { title: '数量', field: 'fQty', width: 80 },
    //            { title: '件数', field: 'fPurQty', width: 80 },
    //            { title: '成本', field: 'fTotal', width: 80 },
    //            { title: '均价', field: 'fPrice', width: 80 }

    //        ]
    //        ], onDblClickRow: function (index, row) {
    //            var outindex = $("#MMStockOutD").data("selectRowIndex");
    //            var outrow = $("#MMStockOutD").data("selectRow");
    //            var a = {};
    //            a.ibscDataSizeRecNo = row.ibscDataSizeRecNo || '0';
    //            a.ibscDataStockDRecNo = row.iBscDataStockDRecNo || '0';
    //            a.sBerChID == row.sBerChID || "";
    //            a.ibscDataCustomerRecNo = row.ibscDataCustomerRecNo || "0";
    //            a.sStockShortName = row.sCustShortName || "";
    //            var outQty = isNaN(outrow.fQty) == false ? row.fQty : 0;
    //            var outPurQty = isNaN(outrow.fPurQty) == false ? row.fPurQty : 0;
    //            if (row.fQty > outQty) {} else {
    //                outQty = row.fQty;
    //            }
    //            if (row.fPurQty > outPurQty) {

    //            } else {
    //                outPurQty = row.fPurQty;
    //            }
    //            a.fQty = outQty || 0;
    //            a.fPurQty = outPurQty || 0;
    //            a.fTotal = a.fQty * (outrow.fPrice || 0);
    //            $("#MMStockOutD").datagrid("updateRow", { index: outindex, row: a });
    //        }
    //    })
})

//Page.Children.onDblClickRow = function (tableid, index, row) {
//    if (tableid == "MMStockOutD") {
//        var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo") || "0";
//        var ibscDataMatRecNo = row.iBscDataMatRecNo || "0";
//        var sqlObj = {
//            //表名或视图名
//            TableName: "vwMMStockQty",
//            //选择的字段
//            Fields: "*",
//            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
//            SelectAll: "True",
//            //过滤条件，数组格式
//            Filters: [
//                {
//                    //左括号
//                    //字段名
//                    Field: "iBscDataStockMRecno",
//                    //比较符
//                    ComOprt: "=",
//                    //值
//                    Value: "'" + iBscDataStockMRecNo + "'",
//                    //连接符
//                    LinkOprt: "and"
//                },
//                {
//                    Field: "iBscDataMatRecno",
//                    ComOprt: "=",
//                    Value: "'" + ibscDataMatRecNo + "'"
//                }
//                ]
//        }
//        var data = SqlGetData(sqlObj);
//        $("#MMStockQty").datagrid("load", data);
//        $("#MMStockOutD").data("selectRowIndex", index);
//        $("#MMStockOutD").data("selectRow", row);
//    }
//}

//Page.Children.onBeforeAddRow = function (tableid) {
//    if (tableid == "MMStockOutD") {
//        if (Page.getFieldValue('iRed') != '1') {
//            return false;
//        }
//    }
//}

dataForm.beforeOpen = function (uniqueid) {

    if (uniqueid == '153' || uniqueid == '135') {

        if (Page.getFieldValue('iRed') != '1') {
            alert("非红冲不可转入！");
            return false;
        }
    }
    if (uniqueid == '102') {

        if (Page.getFieldValue('iRed') == '1') {
            alert("红冲不可转入！");
            return false;
        }
    }

}

lookUp.IsConditionFit = function (uniqueid) {
    if (uniqueid == '1336') {
        if (Page.getFieldValue('iRed') == '1') {
            //alert("dd")
            return true;
        }
    }
    if (uniqueid == '1338') {
        if (Page.getFieldValue('iRed') != '1') {
            return true;
        }
    }
    //    if (uniqueid == "480") {
    //        if (Page.getFieldValue('iRed') == '1') {
    //            //alert("dd")
    //            return true;
    //        }
    //    }
    //    if (uniqueid == "482") {
    //        if (Page.getFieldValue('iRed') != '1') {
    //            return true;
    //        }
    //    }
}

lookUp.afterSelected = function (uniqueid, data) {
    //if (uniqueid == "393" || uniqueid == "465") {
    Page.Children.ReloadFooter("MMStockOutD");
    //}
}

Page.beforeSave = function () {
    if (Page.getFieldValue('iBerCh') == '1') {
        var rows = $("#MMStockOutD").datagrid("getRows");
        var bl = false;
        $(rows).each(function (i, r) {
            if (!r.iBscDataStockDRecNo) {
                alert("第[" + (i + 1) + "]行,仓位不能为空");
                bl = true;
                return false;
            }
        })
        if (bl == true) {
            return false;
        }
    }
    var rows = $("#MMStockOutD").datagrid("getRows");
    var iRed = Page.getFieldValue('iRed');
    var sOrders = "";
    var sStyleNo = "";
    $(rows).each(function (i, r) {
        if (iRed == '1') {
            if (r.fQty && isNaN(parseFloat(r.fQty)) == false && parseFloat(r.fQty) > 0) {
                r.fQty = (parseFloat(r.fQty) || 0) * -1;
                r.fTotal = (parseFloat(r.fTotal) || 0) * -1;

                var rowindex = $("#MMStockOutD").datagrid("getRowIndex", r);
                $("#MMStockOutD").datagrid("updateRow", {
                    index: rowindex, row: r
                });
            }
            if (r.fPurQty && isNaN(parseFloat(r.fPurQty)) == false && parseFloat(r.fPurQty) > 0) {
                r.fPurQty = (parseFloat(r.fPurQty) || 0) * -1;


                var rowindex = $("#MMStockOutD").datagrid("getRowIndex", r);
                $("#MMStockOutD").datagrid("updateRow", {
                    index: rowindex, row: r
                });
            }
        } else {
            if (r.fQty && isNaN(parseFloat(r.fQty)) == false && parseFloat(r.fQty) < 0) {
                r.fQty = (parseFloat(r.fQty) || 0) * -1;
                r.fTotal = (parseFloat(r.fTotal) || 0) * -1;

                var rowindex = $("#MMStockOutD").datagrid("getRowIndex", r);
                $("#MMStockOutD").datagrid("updateRow", {
                    index: rowindex, row: r
                });
            }
            if (r.fPurQty && isNaN(parseFloat(r.fPurQty)) == false && parseFloat(r.fPurQty) < 0) {
                r.fPurQty = (parseFloat(r.fPurQty) || 0) * -1;


                var rowindex = $("#MMStockOutD").datagrid("getRowIndex", r);
                $("#MMStockOutD").datagrid("updateRow", {
                    index: rowindex, row: r
                });
            }
        }

    })
    Page.Children.ReloadFooter('MMStockOutD');
    return true;
}

Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMStockOutD") {

        if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 : parseFloat(row["fPrice"]);
            var fSalePrice = isNaN(parseFloat(row["fSalePrice"])) == true ? 0 : parseFloat(row["fSalePrice"]);
            //var fPerQty = isNaN(parseFloat(row["fPerQty"])) == true ? 1 : parseFloat(row["fPerQty"]);
            var fTotal = fQty * (fPrice);
            //var fPurQty = fQty * fPerQty;
            var fSaleTotal = fQty * fSalePrice;
            $("#MMStockOutD").datagrid("updateRow", { index: index, row: { fTotal: fTotal, fSaleTotal: fSaleTotal} });
        }
        if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 : parseFloat(row["fPrice"]);

            var fTotal = fQty * (fPrice);


            $("#MMStockOutD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fSalePrice" && changes.fSalePrice) {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fSalePrice = isNaN(parseFloat(row["fSalePrice"])) == true ? 0 : parseFloat(row["fSalePrice"]);

            var fSaleTotal = fQty * (fSalePrice);
            $("#MMStockOutD").datagrid("updateRow", { index: index, row: { fSaleTotal: fSaleTotal} });
        }
    }
    //Page.Children.ReloadFooter("MMStockOutD");
}

//在赋值全部数据前
dataForm.beforeSetValue = function (uniqueid, data) {
    if (uniqueid == "104" || uniqueid == "106" || uniqueid == "108" || uniqueid == "110" || uniqueid == "112") {//从采购需求汇总转入  的客户订单，样品单，工序外加工，物料外加工
        var aa = [];

        $(data).each(function (i, d) {
            try {
                var fNoOutQty = d.fNoOutQty || 0;


                var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo") || "0";
                var iBscDataMatRecNo = d.iBscDataMatRecNo || "0";
                var iBscDataSizeRecNo = d.iBscDataSizeRecNo || "0";
                var iSdOrderMRecNo = d.iSdOrderMRecNo || 0;
                //alert(iBscDataMatRecNo + "," + iBscDataSizeRecNo + "," + iBscDataStockMRecNo)
                var sqlObj = {
                    //表名或视图名
                    TableName: "vwMMStockQty",
                    //选择的字段
                    Fields: "*",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                {
                    //左括号
                    //字段名
                    Field: "iBscDataStockMRecNo",
                    //比较符
                    ComOprt: "=",
                    //值
                    Value: "'" + iBscDataStockMRecNo + "'",
                    LinkOprt: "and"
                }, {
                    Field: "ibscDataMatRecNo",
                    //比较符
                    ComOprt: "=",
                    //值
                    Value: "'" + iBscDataMatRecNo + "'",
                    LinkOprt: "and"
                }, {
                    Field: "isnull(ibscDataSizeRecNo,0)",
                    //比较符
                    ComOprt: "=",
                    //值
                    Value: "'" + iBscDataSizeRecNo + "'",
                    LinkOprt: "and"
                }, {
                    Field: "isnull(fQty,0)",
                    //比较符
                    ComOprt: ">=",
                    //值
                    Value: "0"
                }
                ], Sorts: [
                    {
                        SortName: "isnull(iSdOrderMRecNo,0)",
                        SortOrder: "asc"
                    }
                    ]

                }

                var data1 = SqlGetData(sqlObj);
            } catch (ex) {

            }
            if (data1.length > 0) {

                $(data1).each(function (j, d1) {

                    if (d1.iSdOrderMRecNo == 0 || d1.iSdOrderMRecNo == iSdOrderMRecNo) {

                        if (fNoOutQty > 0) {

                            var a = $.extend({}, d);
                            a.iBscDataCustomerRecNo = d1.iBscDataCustomerRecNo || '0';
                            a.ibscDataStockDRecNo = d1.iBscDataStockDRecNo || '0';
                            a.sBerChID = d1.sBerChID || "";
                            a.fPrice = d1.fPrice || 0;
                            //a.iSdOrderMRecNo = d1.iSdOrderMRecNo || 0;
                            a.iStockSdOrderMRecNo = d1.iSdOrderMRecNo || 0;
                            a.sStockOrderNo = d1.sOrderNo || "";
                            a.iBscDataCustomerRecNo = d1.iBscDataCustomerRecNo || 0;
                            a.sStockShortName = d1.sCustShortName || "";
                            var fPerQty = a.fPerQty || 0;
                            var fQty = d1.fQty || '0';

                            if (fNoOutQty > fQty) {
                                fNoOutQty = fNoOutQty - fQty;
                                a.fNoOutQty = fQty;
                                a.fTotal = fQty * fPerQty * a.fPrice;
                                a.fPurQty = fQty * fPerQty;
                            } else {
                                a.fNoOutQty = fNoOutQty;
                                a.fTotal = fNoOutQty * fPerQty * a.fPrice;
                                a.fPurQty = fNoOutQty * fPerQty;
                                fNoOutQty = 0;
                            }

                            aa.push(a);
                        }
                    }
                })
                if (fNoOutQty > 0) {

                    var a = $.extend({}, d);
                    a.iBscDataCustomerRecNo = 0;
                    a.iBscDataStockDRecNo = 0;
                    a.fNoOutQty = fNoOutQty;

                    a.sBerChID = '';
                    var fPerQty = a.fPerQty || 0;

                    a.fPurQty = fPerQty * (a.fNoOutQty || 0);

                    aa.push(a);
                }
            } else {

                var a = $.extend({}, d);
                a.iBscDataCustomerRecNo = 0;
                a.iBscDataStockDRecNo = 0;
                a.sBerChID = '';
                var fPerQty = a.fPerQty || 0;
                var fPurQty = fPerQty * (a.fNoOutQty || 0);
                a.iSdOrderMRecNo = 0;
                aa.push(a);
            }

        });

        return aa;
    }

    if (uniqueid == '112') {
        $(data).each(function (i, d) {
            var fQty = d.fNoOutQty || 0;
            var fPerQty = d.fPerQty || 0;

            d.fPurQty = fQty * fPerQty;
        })
        return data;
    }
    if (uniqueid == '135') {
        $(data).each(function (i, d) {
            if (d.fPurQty) {
                d.fPurQty = d.fPurQty * -1;
            }
            if (d.fQty) {
                d.fQty = d.fQty * -1;
            }
            if (d.fTotal) {
                d.fTotal = d.fTotal * -1;
            }
        })
        return data;
    }

}

Page.afterSave = function () {
    var jsonobj = {
        StoreProName: "SpMatOver",
        StoreParms: [{
            ParmName: "@iType",
            Value: '3'
        }, {
            ParmName: "@iMRecNo",
            Value: Page.key
        }]
    }
    var result = SqlStoreProce(jsonobj);


}
