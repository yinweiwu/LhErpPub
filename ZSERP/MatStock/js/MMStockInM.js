$(function () {
    //根据单据日期计算会计月份
    if (Page.usetype == "add") {
        try {
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
        } catch (ex) {
            alert(ex);
        }
    }

    Page.Children.toolBarBtnDisabled("MMStockInD", "add");
});

lookUp.IsConditionFit = function (uniqueid) {
    if (uniqueid == '673') {
        if (Page.getFieldValue('iCust') == '1') {
            return true;
        }
    }
    if (uniqueid == '675') {
        if (Page.getFieldValue('iCust') != '1') {
            return true;
        }
    }
}

dataForm.beforeOpen = function (uniqueid) {
    if (uniqueid == '90' || uniqueid == '127') {
        
        if (Page.getFieldValue('iRed') == '1') {  } else {
            return false;
        }
    }
}


Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMStockInD") {

        if (datagridOp.currentColumnName == "fQty") {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 :parseFloat( row["fQty"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 :parseFloat( row["fPrice"]);
            var fOutPrice = isNaN(parseFloat(row["fOutPrice"])) == true ? 0 :parseFloat( row["fOutPrice"]);
            var fTotal = fQty * (fPrice + fOutPrice);
            var fPerQty = isNaN(parseFloat(row["fPerQty"])) == true ? 0 : parseFloat(row["fPerQty"]);
            var fPurQty = fQty * fPerQty;
            var fOutTotal = fOutPrice * fQty;
            $("#MMStockInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal, fOutTotal: fOutTotal, fPurQty: fPurQty} });
        }
        if (datagridOp.currentColumnName == "fPurQty") {
            var fPurQty = isNaN(parseFloat(row["fPurQty"])) == true ? 0 : parseFloat(row["fPurQty"]);
            var fPerQty = isNaN(parseFloat(row["fPerQty"])) == true ? 0 : parseFloat(row["fPerQty"]);
            if (fPerQty && fPerQty != 0) {
                fQty = fPurQty / fPerQty;
                var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 : parseFloat(row["fPrice"]);
                var fOutPrice = isNaN(parseFloat(row["fOutPrice"])) == true ? 0 : parseFloat(row["fOutPrice"]);
                var fTotal = fQty * (fPrice + fOutPrice);
                var fOutTotal = fOutPrice * fQty;
                $("#MMStockInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal, fQty: fQty, fOutTotal: fOutTotal} });
            }

        }
        if (datagridOp.currentColumnName == "fPrice") {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 :parseFloat( row["fQty"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 :parseFloat( row["fPrice"]);
            var fOutPrice = isNaN(parseFloat(row["fOutPrice"])) == true ? 0 : parseFloat(row["fOutPrice"]);
            var fTotal = fQty * (fPrice + fOutPrice);
            $("#MMStockInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fTotal") {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fTotal = isNaN(parseFloat(row["fTotal"])) == true ? 0 : parseFloat(row["fTotal"]);
            var fOutPrice = isNaN(parseFloat(row["fOutPrice"])) == true ? 0 : parseFloat(row["fOutPrice"]);
            if (fQty == 0) {
                fPrice = 0;
            } else {
                fPrice = fTotal / fQty - fOutPrice;
            }
            $("#MMStockInD").datagrid("updateRow", { index: index, row: { fPrice: fPrice} });
        }
        if (datagridOp.currentColumnName == "fOutPrice") {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat( row["fQty"]);
            var fOutPrice = isNaN(parseFloat(row["fOutPrice"])) == true ? 0 :parseFloat( row["fOutPrice"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 : parseFloat(row["fPrice"]);
            
            var fTotal = fQty * (fPrice + fOutPrice);
            
            var fOutTotal = fOutPrice * fQty;
            
            $("#MMStockInD").datagrid("updateRow", { index: index, row: { fOutTotal: fOutTotal, fTotal: fTotal} });
        }
    }
}

//Page.Children.onBeforeAddRow = function (tableid) {
//    if (tableid == "MMStockInD") {
//        if (Page.getFieldValue('iCust') != '1') {
//            return false;
//        }
//    }
//}

Page.beforeSave = function () {
    if (Page.getFieldValue('iBerCh') == '1') {
        var rows = $("#MMStockInD").datagrid("getRows");
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
    var rows = $("#MMStockInD").datagrid("getRows");
    var iRed = Page.getFieldValue('iRed');
    $(rows).each(function (i, r) {
        if (iRed == '1') {
            if (r.fQty && isNaN(parseFloat(r.fQty)) == false && parseFloat(r.fQty) > 0) {
                var rr = {};
                rr.fQty = (parseFloat(r.fQty) || 0) * -1;
                rr.fTotal = (parseFloat(r.fTotal) || 0) * -1;
                rr.fOutTotal = (parseFloat(r.fOutTotal) || 0) * -1;
                var rowindex = $("#MMStockInD").datagrid("getRowIndex", r);
                 
                $("#MMStockInD").datagrid("updateRow", {
                    index: rowindex, row: rr
                });
            }

        } else {
            if (r.fQty && isNaN(parseFloat(r.fQty)) == false && parseFloat(r.fQty) < 0) {
                var rr = {};
                rr.fQty = (parseFloat(r.fQty) || 0) * -1;
                rr.fTotal = (parseFloat(r.fTotal) || 0) * -1;
                rr.fOutTotal = (parseFloat(r.fOutTotal) || 0) * -1;
                var rowindex = $("#MMStockInD").datagrid("getRowIndex", r);
                $("#MMStockInD").datagrid("updateRow", {
                    index: rowindex, row: rr
                });
            }
        }
    })
    Page.Children.ReloadFooter('MMStockInD');
      
    return true;
}

lookUp.beforeOpen = function (uniqueid) {
    if (uniqueid == '114') {
        if (Page.getFieldValue('iPurOrder') == '1') {
            return false;
        }
    }
}
lookUp.beforeSetValue = function (uniqueid, data) {

    if (uniqueid == '127') {
        $(data).each(function (i, d) {
            if (d.fQty) {
                d.fQty = d.fQty * -1;
            }
            if (d.fTotal) {
                d.fTotal = d.fTotal * -1;
            }
            if (d.fPurQty) {
                d.fPurQty = d.fPurQty * -1;
            }
        });
        return data;
    }
    if (uniqueid == "383") {
        //获取data中每一行尺码数据，并设置到data的每一行中
        $(data).each(function (i, dt) {
            var iRecNo = dt.iRecNo || 0;
            var sqlobj = {
                TableName: "vwbscdatamatdstock",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "imainRecNo",
                        ComOprt: "=",
                        Value: dt.iRecNo || 0,
                        LinkOprt: 'and'
                    },
                    {
                        Field: "ibscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue('iBscDataStockMRecNo') + "'"
                    }
                    ],
                Sorts: [

                ]
            };
            var resultSizeQty = SqlGetData(sqlobj);
            if (resultSizeQty && resultSizeQty.length > 0) {
                dt.iBscDataStockDRecNo = resultSizeQty[0].iBscDataStockDRecNo || 0;
                dt.sBerChID = resultSizeQty[0].sBerChID || '';
            }
        })
        return data;
    }
}

dataForm.beforeSetValue = function (uniqueid, data) {
    if (uniqueid == "114") {
        //获取data中每一行尺码数据，并设置到data的每一行中
        $(data).each(function (i, dt) {
            var iRecNo = dt.iRecNo || 0;
            var sqlobj = {
                TableName: "vwbscdatamatdstock",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "imainRecNo",
                        ComOprt: "=",
                        Value: dt.iRecNo || 0,
                        LinkOprt: 'and'
                    },
                    {
                        Field: "ibscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue('iBscDataStockMRecNo') + "'"
                    }
                    ],
                Sorts: [

                ]
            };
            var resultSizeQty = SqlGetData(sqlobj);
            if (resultSizeQty && resultSizeQty.length > 0) {
                dt.iBscDataStockDRecNo = resultSizeQty[0].iBscDataStockDRecNo || 0;
                dt.sBerChID = resultSizeQty[0].sBerChID || '';
            }
        })
        return data;
    }
    if (uniqueid == "88") {
        //获取data中每一行尺码数据，并设置到data的每一行中
        $(data).each(function (i, dt) {
            var iRecNo = dt.iRecNo || 0;
            var sqlobj = {
                TableName: "vwbscdatamatdstock",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "imainRecNo",
                        ComOprt: "=",
                        Value: dt.ibscDataMatRecNo || 0,
                        LinkOprt: 'and'
                    },
                    {
                        Field: "ibscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue('iBscDataStockMRecNo') + "'"
                    }
                    ],
                Sorts: [

                ]
            };
            var resultSizeQty = SqlGetData(sqlobj);
            if (resultSizeQty && resultSizeQty.length > 0) {
                dt.ibscDataStockDRecNo = resultSizeQty[0].ibscDataStockDRecNo || 0;
                dt.sBerChID = resultSizeQty[0].sBerChID || "";
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
            Value: '2'
        }, {
            ParmName: "@iMRecNo",
            Value: Page.key
        }]
    }
    var result = SqlStoreProce(jsonobj);
}



