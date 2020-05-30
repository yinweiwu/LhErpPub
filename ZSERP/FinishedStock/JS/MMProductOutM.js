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

    if (Page.usetype == "add") {
        Page.setFieldValue("iType", getQueryString("iType"));
    }

    Page.Children.toolBarBtnDisabled("MMProductOutD", "add");
    Page.Children.toolBarBtnDisabled("MMProductOutD", "copy");
    Page.Children.toolBarBtnDisabled("MMProductOutD", "export");

})

$(function () {
    //刷条码
    $($("#__ExtTextBox14")).bind({
        "keydown": function (event) {

            switch (event.keyCode) {
                case 13:

                    var sBarCode = Page.getFieldValue("sBarCode");
                    Page.setFieldValue("sBarCode", "");
                    if (sBarCode) { } else {
                        event.preventDefault();
                        return;
                    }
                    var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo") || "";
                    var sBerChID = $("#__ExtTextBox9").textbox("getText");
                    var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                    var iSDSendMRecNo = Page.getFieldValue("iSDSendMRecNo");
                    //红冲时,
                    if (Page.getFieldValue("iRed") == 0) {
                        if (!iBscDataStockMRecNo) {
                            $("#sbarcoderemark").html("非红冲时,仓库不能为空\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        }
                        var jsonobj = {
                            StoreProName: "SpMMProductOutMBarCode",
                            StoreParms: [{
                                ParmName: "@sBarCode",
                                Value: sBarCode
                            }, {
                                ParmName: "@iBscDataStockMRecNo",
                                Value: iBscDataStockMRecNo
                            }, {
                                ParmName: "@iSDSendMRecNo",
                                Value: iSDSendMRecNo
                            }]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result && result.length > 0 && result != "-1") {
                            var row = result[0];
                            var a = {};
                            a.iRecNo = Page.getChildID("MMProductOutD");
                            a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductOutD").datagrid("getRows").length + 1;

                            a.iBscDataStockDRecNo = row.iBscDataStockDRecNo;
                            a.sBerChID = row.sBerChID;
                            a.iSdContractMRecNo = row.iSdContractMRecNo || 0;
                            a.sOrderNo = row.sOrderNo || "";
                            a.iBscDataCustomerRecNo = row.iBscDataCustomerRecNo || 0;
                            a.sCustShortName = row.sCustShortName || "";
                            a.iBscDataStyleMRecNo = row.iBscDataStyleMRecNo || 0;
                            a.sStyleNo = row.sStyleNo || "";
                            a.iBscDataColorRecNo = row.iBscDataColorRecNo || 0;
                            a.sColorName = row.sColorName || "";
                            a.sSizeName = row.sSizeName || "";
                            a.iQty = row.iQty || 0;
                            a.iSdSendDRecNo = row.iSdSendDRecNo || 0;
                            a.fPrice = row.fPrice || 0;
                            a.fTotal = row.fTotal || 0;
                            //价格未提取
                            $("#MMProductOutD").datagrid("appendRow", a);
                        }
                        else {
                            $("#sbarcoderemark").html(sBarCode + "条码不存在\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        }


                    }

                    if (Page.getFieldValue("iRed") == 1) {
                        var jsonobj = {
                            StoreProName: "SpMMProductOutMBarCodeRed",
                            StoreParms: [{
                                ParmName: "@sBarCode",
                                Value: sBarCode
                            }, {
                                ParmName: "@iBscDataStockMRecNo",
                                Value: iBscDataStockMRecNo
                            }, {
                                ParmName: "@iSDSendMRecNo",
                                Value: iSDSendMRecNo
                            }]
                        }
                        var result = SqlStoreProce(jsonobj,true);
                        if (result && result.length > 0 && result != "-1") {
                            var row = result[0];
                            var a = {};
                            a.iRecNo = Page.getChildID("MMProductOutD");
                            a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductOutD").datagrid("getRows").length + 1;

                            a.iBscDataStockDRecNo = row.iBscDataStockDRecNo || iBscDataStockDRecNo;
                            a.sBerChID = row.sBerChID || sBerChID;
                            a.iSdContractMRecNo = row.iSdContractMRecNo || 0;
                            a.sOrderNo = row.sOrderNo || "";
                            a.iBscDataCustomerRecNo = row.iBscDataCustomerRecNo || 0;
                            a.sCustShortName = row.sCustShortName || "";
                            a.iBscDataStyleMRecNo = row.iBscDataStyleMRecNo || 0;
                            a.sStyleNo = row.sStyleNo || "";
                            a.iBscDataColorRecNo = row.iBscDataColorRecNo || 0;
                            a.sColorName = row.sColorName || "";
                            a.sSizeName = row.sSizeName || "";
                            a.iQty = row.iQty || 0;
                            a.iSdSendDRecNo = row.iSdSendDRecNo || 0;
                            a.fPrice = row.fPrice || 0;
                            a.fTotal = row.fTotal || 0;
                            //价格未提取
                            $("#MMProductOutD").datagrid("appendRow", a);
                        }
                        else {
                            
                            //vwproorderbarCode 获取
                            var sqlObj = {
                                //表名或视图名
                                TableName: "vwProOrderDBarCode",
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
                                                Field: "isnull(iStatus,0)",
                                                ComOprt: "=",
                                                Value: "0"
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
                            a.iRecNo = Page.getChildID("MMProductOutD");
                            a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductOutD").datagrid("getRows").length + 1;
                            if (iBscDataStockDRecNo) {
                                a.iBscDataStockDRecNo = iBscDataStockDRecNo;
                                a.sBerChID = $("#__ExtTextBox9").textbox("getText");
                            }
                            a.iSdContractMRecNo = data[0].iSdContractMRecNo || 0;
                            a.sOrderNo = data[0].sOrderNo || "";
                            a.iBscDataCustomerRecNo = data[0].iBscDataCustomerRecno || 0;
                            a.sCustShortName = data[0].sCustShortName || "";
                            a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                            a.sStyleNo = data[0].sStyleNo || "";
                            a.iBscDataColorRecNo = data[0].iBscDataColorRecNo || 0;
                            a.sColorName = data[0].sColorName || "";
                            a.sSizeName = data[0].sSizeName || "";
                            a.iQty = data[0].iQty || 0;
                            //价格未提取
                            $("#MMProductOutD").datagrid("appendRow", a);
                             
                            
                        }
                    }
                    event.preventDefault();
                    break;
            }
        }
    })
})

//lookUp.IsConditionFit = function (uniqueid) {
//    if (uniqueid == "234" || uniqueid == "238") {
//        if (Page.getFieldValue('iSDSendMRecNo')) {
//            return true;
//        }
//    }
//    if (uniqueid == "232" || uniqueid == "236") {
//        if (!Page.getFieldValue('iSDSendMRecNo')) {
//            return true;
//        }
//    }
//}