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

lookUp.IsConditionFit = function (uniqueid) {
    if (uniqueid == '417' || uniqueid == '421') {
        var rows = $(datagridOp.current).datagrid("getRows");
        var rowindex = datagridOp.currentRowIndex;
        if (rows && rows.length > 0) {
            var row = rows[rowindex];
            if (row.sOrderNo) {
                return true;
            }
        }
    }
    if (uniqueid == '419' || uniqueid == '423') {
        var rows = $(datagridOp.current).datagrid("getRows");
        var rowindex = datagridOp.currentRowIndex;
        if (rows && rows.length > 0) {
            var row = rows[rowindex];
            if (row.sOrderNo) {

            } else {
                return true;
            }
        }
    }
}

$(function () {
    //刷条码
    $($("#__ExtTextBox18")).bind({
        "keydown": function (event) {

            switch (event.keyCode) {
                case 13:

                    var sBarCode = Page.getFieldValue("sBarCode");
                    Page.setFieldValue("sBarCode", "");
                    if (sBarCode) { } else {
                        event.preventDefault();
                        return;
                    }
                    if (Page.getFieldValue('iStatus') == '' || Page.getFieldValue('iStatus') == '0') {

                        var iBscDataStockMRecNo = Page.getFieldValue("iOutBscDataStockMRecno");


                        //vwproorderbarCode 获取
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
                                                Field: "sBarCode",
                                                ComOprt: "=",
                                                Value: "'" + sBarCode + "'",
                                                LinkOprt: "and"
                                            }, {
                                                Field: "isnull(iQty,0)",
                                                ComOprt: ">",
                                                Value: "0",
                                                LinkOprt: "and"
                                            }, {
                                                Field: "isnull(iBscDataStockMRecNo,0)",
                                                ComOprt: "=",
                                                Value: "'" + iBscDataStockMRecNo + "'"
                                            }
                                    ]
                        }
                        var data = SqlGetData(sqlObj);
                        if (data.length == 0) {
                            $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        }
                        var a = {};
                        a.iRecNo = Page.getChildID("MMProductDbD");
                        a.sBarCode = sBarCode;
                        a.iSerial = $("#MMProductDbD").datagrid("getRows").length + 1;
                        a.iOutBscDataStockDRecNo = data[0].iBscDataStockDRecNo || 0;
                        a.iSdContractMRecNo = data[0].iSdContractMRecNo || 0;
                        a.sOrderNo = data[0].sOrderNo || "";
                        a.iBscDataCustomerRecNo = data[0].ibscDataCustomerRecNo || 0;
                        a.sCustShortName = data[0].sCustShortName || "";
                        a.iBscDataStyleMRecNo = data[0].ibscDataStyleMRecNo || 0;
                        a.sStyleNo = data[0].sStyleNo || "";
                        a.iBscDataColorRecNo = data[0].ibscDataColorRecNo || 0;
                        a.sColorName = data[0].sColorName || "";
                        a.sSizeName = data[0].sSizeName || "";
                        a.iSendQty = data[0].iQty || 0;
                        a.iMcQty = (data[0].iQty || 0) * -1;
                        //价格未提取
                        $("#MMProductDbD").datagrid("appendRow", a);
                        $("#sbarcoderemark").html(sBarCode + "条码扫码成功\n" + $("#sbarcoderemark").html());
                        event.preventDefault();
                        return;
                    }
                    if (Page.getFieldValue('iStatus') == '2') {
                        var rows = $("#MMProductDbD").datagrid("getRows");
                        var rowindex = -1;
                        var iSendQty = 0;
                        $(rows).each(function (i, r) {
                            if (r.sBarCode == sBarCode) {
                                rowindex = i;
                                iSendQty = r.iSendQty || 0;
                                return false;
                            }
                        });
                        if (rowindex == -1) {
                            $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        } else {
                            $("#MMProductDbD").datagrid("updateRow", {
                                index: rowindex,
                                row: {
                                    iQty: iSendQty,
                                    iMcQty: 0
                                }
                            });
                            $("#sbarcoderemark").html(sBarCode + "条码扫码确认成功\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        }
                    }
                    break;
            }
        }
    })
})

Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMProductDbD") {

        if (datagridOp.currentColumnName == "iQty") {
            var iQty = isNaN(row["iQty"]) == true ? 0 : row["iQty"];
            var iSendQty = isNaN(row["iSendQty"]) == true ? 0 : row["iSendQty"];
            var iMcQty = iQty - iSendQty;

            $("#MMProductDbD").datagrid("updateRow", { index: index, row: { iMcQty: iMcQty} });
        }
    }
}

Page.beforeSave = function () {
    var rows = $("#MMProductDbD").datagrid("getRows");
    var fTotal = 0;
    $(rows).each(function (i, r) {
        var iSendQty = r.iSendQty || 0;
        var fPrice = r.fPrice || 0;
        fTotal = fTotal + fPrice * iSendQty;
    });
    Page.setFieldValue("fTotal", fTotal);
    return true;
}

