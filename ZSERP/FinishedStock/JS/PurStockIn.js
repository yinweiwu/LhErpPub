
lookUp.IsConditionFit = function (uniqueid) {
    try {
        if (uniqueid == '224' || uniqueid == '438' || uniqueid == '417' || uniqueid == '431' || uniqueid == '445') {
            if (getQueryString('sType') == '0') {

                return true;
            }
        }
        if (uniqueid == '368' || uniqueid == '442' || uniqueid == '421' || uniqueid == '435' || uniqueid == '449') {

            if (getQueryString('sType') == '4' || getQueryString('sType') == '5') {

                return true;
            }
        }

        if (uniqueid == '35' || uniqueid == '42' || uniqueid == '44' || uniqueid == '46' || uniqueid == '48' || uniqueid == '50') {
            if (Page.sysParms.iCommonBarCode == 0 && Page.getFieldValue('iRed') == 0) {
                return true;
            }
        }
        if (uniqueid == '277' || uniqueid == '275' || uniqueid == '269' || uniqueid == '267' || uniqueid == '264' || uniqueid == '261' || uniqueid == '259' || uniqueid == '256' || uniqueid == '253' || uniqueid == '251' || uniqueid == '116' || uniqueid == '129' || uniqueid == '133' || uniqueid == '243' || uniqueid == '245' || uniqueid == '248') {
            var rows = $(datagridOp.current).datagrid("getRows");
            var rowindex = datagridOp.currentRowIndex;
            if (rows && rows.length > 0) {
                var row = rows[rowindex];
                if (row.sOrderNo) {
                    return true;
                }
            }
        }
        if (uniqueid == '278' || uniqueid == '276' || uniqueid == '270' || uniqueid == '268' || uniqueid == '262' || uniqueid == '260' || uniqueid == '254' || uniqueid == '252' || uniqueid == '118' || uniqueid == '131' || uniqueid == '244' || uniqueid == '246') {
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
    } catch (ex) {
        alert(ex);
        return false;
    }
}

dataForm.IsConditionFit = function (uniqueid) {
    if (uniqueid == '26' || uniqueid == '41' || uniqueid == '43' || uniqueid == '45' || uniqueid == '47' || uniqueid == '49') {
        if (Page.sysParms.iCommonBarCode == 0 && Page.getFieldValue('iRed') == 1) {
            return true;
        }
    }
}



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
        Page.setFieldValue("iType", getQueryString("sType"));
    }
    switch (getQueryString("sType")) {
        case "0":
            $("#sp_gys").html("供应商");
            break;
        case "4":
            $("#sp_gys").html("客户");
            $("#div_iRed").hide();
            $("#sp_hc").hide();
            Page.setFieldValue("iRed", "1");
            break;
        case "5":
            $("#sp_gys").html("客户");
            $("#sp_hc").hide();
            $("#div_iRed").hide();
            Page.setFieldValue("iRed", "0");
            $("#sp_gys").hide();
            $("#div_gys").hide();
            break
        default:
            $("#sp_gys").hide();
            $("#div_gys").hide();
            break;
    }

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
                    if (Page.getFieldValue("iRed") == 0) {
                        //唯一码
                        if (Page.sysParms.iCommonBarCode == undefined || Page.sysParms.iCommonBarCode == 0) {

                            //唯一码非红冲时
                            if (Page.getFieldValue("iRed") == 0) {
                                //验证条码唯一
                                var bl = false;
                                $($("#MMProductInD").datagrid("getRows")).each(function (i, row) {
                                    if (row.sBarCode == sBarCode) {
                                        bl = true;
                                        return false;
                                    }
                                })
                                if (bl == true) {
                                    //alert("条码重复");
                                    $("#sbarcoderemark").html(sBarCode + "条码重复\n" + $("#sbarcoderemark").html());
                                    event.preventDefault();
                                    return;
                                }

                                if (getQueryString("sType") == "2") { //生产入库时，部门必需
                                    var sDeptID = Page.getFieldValue("sDeptID");
                                    if (!sDeptID) {
                                        alert("入库部门必选");
                                        event.preventDefault();
                                        return;
                                    }
                                    //检测prostock部门半成品库存了
                                    var sqlObj = {
                                        //表名或视图名
                                        TableName: "prostock",
                                        //选择的字段
                                        Fields: "*",
                                        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                                        SelectAll: "True",
                                        //过滤条件，数组格式
                                        Filters: [
                                    {
                                        //左括号
                                        LeftParenthese: "(",
                                        //字段名
                                        Field: "sDeptID",
                                        //比较符
                                        ComOprt: "=",
                                        //值
                                        Value: "'" + sDeptID + "'",
                                        //右括号
                                        RightParenthese: ")",
                                        //连接符
                                        LinkOprt: "and"
                                    },
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
                                        $("#sbarcoderemark").html(sBarCode + "半成品库中无库存\n" + $("#sbarcoderemark").html());

                                        event.preventDefault();
                                        return;
                                    }
                                }

                                //归还单时需要判断是否有借用单
                                if (getQueryString("sType") == "5") {
                                    var iBscDataStockMRecNo = Page.getFieldValue("iBscDataStockMRecNo") || "";
                                    if (!iBscDataStockMRecNo) {
                                        $("#sbarcoderemark").html(sBarCode + "归还单时，未设置仓库\n" + $("#sbarcoderemark").html());

                                        event.preventDefault();
                                        return;
                                    }
                                    var sqlObj = {
                                        //表名或视图名
                                        TableName: "vwMMProductInD",
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
                                                Value: "4",
                                                LinkOprt: "and"
                                            }, {
                                                Field: "isnull(iStatus,0)",
                                                ComOprt: "=",
                                                Value: "4",
                                                LinkOprt: "and"
                                            }
                                            , {
                                                Field: "isnull(iBscDataStockMRecNo,0)",
                                                ComOprt: "=",
                                                Value: "'" + iBscDataStockMRecNo + "'"
                                            }
                                    ]
                                    }
                                    var data = SqlGetData(sqlObj);
                                    if (data.length == 0) {
                                        $("#sbarcoderemark").html(sBarCode + "归还单时，未找到相应归还单\n" + $("#sbarcoderemark").html());

                                        event.preventDefault();
                                        return;
                                    }
                                }

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
                                    $("#sbarcoderemark").html(sBarCode + "条码已入库或不存在\n" + $("#sbarcoderemark").html());
                                    // alert("条码已入库或不存在");
                                    event.preventDefault();
                                    return;
                                }
                                var a = {};
                                a.iRecNo = Page.getChildID("MMProductInD");
                                a.sBarCode = sBarCode;
                                a.iSerial = $("#MMProductInD").datagrid("getRows").length + 1;
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
                                $("#MMProductInD").datagrid("appendRow", a);
                            } else {

                            }
                        } else {
                            //通用码
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
                            a.iRecNo = Page.getChildID("MMProductInD");
                            a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductInD").datagrid("getRows").length + 1;
                            if (iBscDataStockDRecNo) {
                                a.iBscDataStockDRecNo = iBscDataStockDRecNo;
                            }


                            a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                            a.sStyleNo = data[0].sStyleNo || "";
                            a.iBscDataColorRecNo = data[0].iBscDataColorRecNo || 0;
                            a.sColorName = data[0].sColorName || "";
                            a.sSizeName = data[0].sSizeName || "";
                            a.iQty = 1;
                            $("#MMProductInD").datagrid("appendRow", a);

                        }
                    } else {
                        //唯一码,红冲时
                        //验证库存是否存在
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
                            $("#sbarcoderemark").html(sBarCode + "红冲时，检测库存不存在\n" + $("#sbarcoderemark").html());
                            event.preventDefault();
                            return;
                        } else {
                            var a = {};
                            a.iRecNo = Page.getChildID("MMProductInD");
                            a.sBarCode = sBarCode;
                            a.iSerial = $("#MMProductInD").datagrid("getRows").length + 1;
                            a.iBscDataStockDRecNo = data[0].iBscDataStockDRecNo || 0;
                            a.sBerChID = data[0].sBerChID || "";
                            a.iSdContractMRecNo = data[0].iSdContractMRecNo || 0;
                            a.sOrderNo = data[0].sOrderNo || "";
                            a.sCustShortName = data[0].sCustShortName || "";
                            a.iBscDataCustomerRecNo = data[0].iBscDataCustomerRecNo || 0;
                            a.iBscDataStyleMRecNo = data[0].iBscDataStyleMRecNo || 0;
                            a.sStyleNo = data[0].sStyleNo || "";
                            a.iBscDataColorRecNo = data[0].iBscDataColorRecNo || 0;
                            a.sColorName = data[0].sColorName || "";
                            a.sSizeName = data[0].sSizeName || "";
                            a.iQty = data[0].iQty || 0;
                            $("#MMProductInD").datagrid("appendRow", a);
                        }
                    }
                    event.preventDefault();
                    break;
            }
        }
    })

})