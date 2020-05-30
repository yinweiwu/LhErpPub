$(function () {
    Page.Children.toolBarBtnDisabled("MMStockDbD", "add")
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
});

Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMStockDbD") {

        if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fTotal = fQty * fPrice;
            //var fPerQty = isNaN(parseFloat(row["fPerQty"])) == true ? 1 : parseFloat(row["fPerQty"]);
            //var fPurQty = fTotal * fPerQty;
            $("#MMStockDbD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fPrice = isNaN(parseFloat(row["fPrice"])) == true ? 0 : parseFloat(row["fPrice"]);

            var fTotal = fQty * (fPrice);
            $("#MMStockDbD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fTotal" && changes.fTotal) {
            var fQty = isNaN(parseFloat(row["fQty"])) == true ? 0 : parseFloat(row["fQty"]);
            var fTotal = isNaN(parseFloat(row["fTotal"])) == true ? 0 : parseFloat(row["fTotal"]);

            if (fQty == 0) {
                fPrice = 0;
            } else {
                fPrice = fTotal / fQty;
            }
            $("#MMStockDbD").datagrid("updateRow", { index: index, row: { fPrice: fPrice} });
        }
    }
}

dataForm.beforeSetValue = function (uniqueid, data) {

    if (uniqueid == "163") {
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
                        Value: dt.iBscDataMatRecNo || 0,
                        LinkOprt: 'and'
                    },
                    {
                        Field: "ibscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue('iInBscDataStockMRecNo') + "'"
                    }
                    ],
                Sorts: [

                ]
            };
            var resultSizeQty = SqlGetData(sqlobj);
            if (resultSizeQty && resultSizeQty.length > 0) {
                dt.iInbscDataStockDRecNo = resultSizeQty[0].ibscDataStockDRecNo || 0;
                dt.sInBerChID = resultSizeQty[0].sBerChID || "";
            }
        })
        return data;
    }
}


Page.Formula = function (field) {
    if (Page.isInited == true) {
        if (field == "dDate") {
            var dDate = Page.getFieldValue("dDate");
            var SqlObjYearMonth = {
                TableName: "bscDataPeriod",
                Fields: "sYearMonth",
                SelectAll: "True",
                Filters: [
                {
                    Field: "dBeginDate",
                    ComOprt: "<=",
                    Value: "'" + dDate + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "dEndDate",
                    ComOprt: ">=",
                    Value: "'" + dDate + "'"
                }
            ]
            }
            var resultYearMonth = SqlGetData(SqlObjYearMonth);
            if (resultYearMonth.length > 0) {
                Page.setFieldValue("sYearMonth", resultYearMonth[0].sYearMonth);
            }
            checkMonth();
        }
    }
}

function checkMonth() {
    var sYearMonth = Page.getFieldValue("sYearMonth");
    var stockRecNo = Page.getFieldValue("iOutBscDataStockMRecNo");
    var SqlObj = {
        TableName: "MMStockMonthM",
        Fields: "1",
        SelectAll: "True",
        Filters: [
                    {
                        Field: "iBscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + stockRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sYearMonth",
                        ComOprt: "=",
                        Value: "'" + sYearMonth + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "'4'"
                    }
                ]
    };
    var result = SqlGetData(SqlObj);
    if (result.length > 0) {
        Page.MessageShow("仓库此月份已月结", "对不起，此仓库此月份已月结！");
        return false;
    }
}


Page.beforeSave = function () {
    if (checkMonth == false) {
        return false;
    }
}


