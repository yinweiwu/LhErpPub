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



})

lookUp.IsConditionFit = function (uniqueid) {
    if (uniqueid == '453' || uniqueid == '457' ) {
        var rows = $(datagridOp.current).datagrid("getRows");
        var rowindex = datagridOp.currentRowIndex;
        if (rows && rows.length > 0) {
            var row = rows[rowindex];
            if (row.sOrderNo) {
                
                return true;
            }
        }
    }
    if (uniqueid == '455' || uniqueid == '459') {
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

Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "MMProductCheckD") {

        if (datagridOp.currentColumnName == "iStockQty") {
            var iStockQty = isNaN(row["iStockQty"]) == true ? 0 : row["iStockQty"];

            var iPcQty = isNaN(row["iPcQty"]) == true ? 0 : row["iPcQty"];

            var iQty = iPcQty - iStockQty;

            $("#MMProductCheckD").datagrid("updateRow", { index: index, row: { iQty: iQty} });
        }


        if (datagridOp.currentColumnName == "iPcQty") {
            var iPcQty = isNaN(row["iPcQty"]) == true ? 0 : row["iPcQty"];
            var iStockQty = isNaN(row["iStockQty"]) == true ? 0 : row["iStockQty"];
            var iQty = iPcQty - iStockQty;

            $("#MMProductCheckD").datagrid("updateRow", { index: index, row: { iQty: iQty} });
        }
    }
}

$(function () {
    //刷条码
    $($("#__ExtTextBox17")).bind({
        "keydown": function (event) {

            switch (event.keyCode) {
                case 13:

                    var sBarCode = Page.getFieldValue("sBarCode");
                    Page.setFieldValue("sBarCode", "");
                    if (sBarCode) { } else {
                        event.preventDefault();
                        return;
                    }
                    var sqlObj = {
                        //表名或视图名
                        TableName: "vwmmproductstockQty",
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
                                                Value: "0"
                                            }
                                    ]
                    }
                    var data = SqlGetData(sqlObj);
                    if (data.length == 0) {
                        var sqlObj = {
                            //表名或视图名
                            TableName: "vwbscDataBarCode",
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

                            event.preventDefault();
                            return;
                        }
                        var a = {};
                        a.iRecNo = Page.getChildID("MMProductCheckD");
                        a.sBarCode = sBarCode;
                        a.iSerial = $("#MMProductCheckD").datagrid("getRows").length + 1;

                        a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                        a.sStyleNo = data[0].sStyleNo || "";
                        a.iBscDataColorRecNo = data[0].iBscDataColorRecNo || 0;
                        a.sColorName = data[0].sColorName || "";
                        a.sSizeName = data[0].sSizeName || "";
                        
                        $("#MMProductCheckD").datagrid("appendRow", a);
                    } else {
                        var a = {};
                        a.iRecNo = Page.getChildID("MMProductCheckD");
                        a.sBarCode = sBarCode;
                        a.iSerial = $("#MMProductCheckD").datagrid("getRows").length + 1;
                        a.iBscDataStockDRecNo = data[0].iBscDataStockDRecNo || 0;
                        a.sBerChID = data[0].sBerChID || '';
                        a.iSdContractMRecNo = data[0].iSdContractMRecNo || 0;
                        a.sOrderNo = data[0].sOrderNo || '';
                        a.iBscDataCustomerRecNo = data[0].iBscDataCustomerRecNo || 0;
                        a.sCustShortName = data[0].sCustShortName || '';
                        a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                        a.sStyleNo = data[0].sStyleNo || "";
                        a.iBscDataColorRecNo = data[0].iBscDataColorRecNo || 0;
                        a.sColorName = data[0].sColorName || "";
                        a.sSizeName = data[0].sSizeName || "";
                        a.iStockQty = data[0].iQty || 0;
                        a.iQty = (data[0].iQty || 0) * -1;
                        $("#MMProductCheckD").datagrid("appendRow", a);
                    }

                    event.preventDefault();
                    break;
            }
        }
    })

})