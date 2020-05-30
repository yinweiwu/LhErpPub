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
});

Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMStockCheckD") {

        if (datagridOp.currentColumnName == "fStockQty" && changes.fStockQty) {
            var fStockQty = isNaN(row["fStockQty"]) == true ? 0 : row["fStockQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fStockTotal = fQty * fPrice;
            var fPcQty = isNaN(row["fPcQty"]) == true ? 0 : row["fPcQty"];
            var fPcTotal = isNaN(row["fPcTotal"]) == true ? 0 : row["fPcTotal"];
            var fQty = fPcQty - fStockQty;
            var fTotal = fPcTotal - fStockTotal;
            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fStockTotal: fStockTotal, fQty: fQty, fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fStockPurQty" && changes.fStockPurQty) {
            var fStockPurQty = isNaN(row["fStockPurQty"]) == true ? 0 : row["fStockPurQty"];
            var fPcPurQty = isNaN(row["fPcPurQty"]) == true ? 0 : row["fPcPurQty"];
            var fPurQty = fPcPurQty - fStockPurQty;
            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty} });
        }
        if (datagridOp.currentColumnName == "fPrice" && changes.fStockQty) {
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fStockQty = isNaN(row["fStockQty"]) == true ? 0 : row["fStockQty"];
            var fStockTotal = fPrice * fStockQty;
            var fPcQty = isNaN(row["fPcQty"]) == true ? 0 : row["fPcQty"];
            var fPcTotal = fPrice * fPcQty;
            var fTotal = fPcTotal - fStockTotal;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fStockTotal: fStockTotal, fPcTotal: fPcTotal, fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPcQty" && changes.fPcQty) {
            var fPcQty = isNaN(row["fPcQty"]) == true ? 0 : row["fPcQty"];
            var fStockQty = isNaN(row["fStockQty"]) == true ? 0 : row["fStockQty"];
            var fQty = fPcQty - fStockQty;
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fPcTotal = fPcQty * fPrice;
            var fStockTotal = isNaN(row["fStockTotal"]) == true ? 0 : row["fStockTotal"];
            var fTotal = fPcTotal.toFixed(4) - fStockTotal;
            fTotal = isNaN(fTotal) == true ? 0 : fTotal;
            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fQty: fQty, fPcTotal: fPcTotal, fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPcPurQty" && changes.fPcPurQty) {
            var fPcPurQty = isNaN(row["fPcPurQty"]) == true ? 0 : row["fPcPurQty"];
            var fStockPurQty = isNaN(row["fStockPurQty"]) == true ? 0 : row["fStockPurQty"];
            var fPurQty = fPcPurQty - fStockPurQty;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty} });
        }
        if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fStockQty = isNaN(row["fStockQty"]) == true ? 0 : row["fStockQty"];
            var fPcQty = fStockQty + fQty;
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fPcTotal = fPcQty * fPrice;
            var fStockTotal = isNaN(row["fStockTotal"]) == true ? 0 : row["fStockTotal"];
            var fTotal = fPcTotal - fStockTotal;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fPcQty: fPcQty, fPcTotal: fPcTotal, fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty) {
            var fPurQty = isNaN(row["fPurQty"]) == true ? 0 : row["fPurQty"];
            var fStockPurQty = isNaN(row["fStockPurQty"]) == true ? 0 : row["fStockPurQty"];
            var fPcPurQty = fStockPurQty - fPurQty;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fPcPurQty: fPcPurQty} });
        }
        if (datagridOp.currentColumnName == "fTotal" && changes.fTotal) {
            var fTotal = isNaN(row["fTotal"]) == true ? 0 : row["fTotal"];
            var fStockTotal = isNaN(row["fStockTotal"]) == true ? 0 : row["fStockTotal"];
            var fPcTotal = fStockTotal - fTotal;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fPcTotal: fPcTotal} });
        }
        if (datagridOp.currentColumnName == "fStockTotal" && changes.fStockTotal) {
            var fStockTotal = isNaN(row["fStockTotal"]) == true ? 0 : row["fStockTotal"];
            var fPcTotal = isNaN(row["fPcTotal"]) == true ? 0 : row["fPcTotal"];
            var fTotal = fPcTotal - fStockTotal;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPcTotal" && changes.fPcTotal) {
            var fStockTotal = isNaN(row["fStockTotal"]) == true ? 0 : row["fStockTotal"];
            var fPcTotal = isNaN(row["fPcTotal"]) == true ? 0 : row["fPcTotal"];
            var fTotal = fPcTotal - fStockTotal;

            $("#MMStockCheckD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
    }
}

lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
    if (uniqueid == '121') {
        if (row.fQty) {
            row.fQty = -1 * row.fQty;
        }
        if (row.fPurQty) {
            row.fPurQty = -1 * row.fPurQty;
        }
        if (row.fTotal) {
            row.fTotal = -1 * row.fTotal;
        }
        row.fPcQty = 0;
        row.fPcPurQty = 0;
        row.fPcTotal = 0;
        return row;
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
    var stockRecNo = Page.getFieldValue("iBscDataStockMRecNo");
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