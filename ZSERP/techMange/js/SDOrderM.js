$(function () {
    Page.Children.ShowDynColumns("SdOrderDBom", Page.key);
    Page.Children.ShowDynColumns("SDContractDProduce", Page.key);
})
$(function () {
    var sqlObj = {
        //表名或视图名
        TableName: "vwsDorderM",
        //选择的字段
        Fields: "*",
        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
        SelectAll: "True",
        //过滤条件，数组格式
        Filters: [
        {
            //左括号
            //字段名
            Field: "iRecNo",
            //比较符
            ComOprt: "=",
            //值
            Value: "'" + Page.key + "'"
        }
        ]
    }
    var data = SqlGetData(sqlObj);
    if (data.length > 0) {
        Page.setFieldValue("sOrderNo", (data[0].sOrderNo || ""));
        Page.setFieldValue("sCustShortName", (data[0].sCustShortName || ""));
        Page.setFieldValue("sSaleName", (data[0].sSaleName || ""));
        //Page.setFieldValue("sStyleNo", (data[0].sStyleNo || ""));
        Page.setFieldValue("dProduceDate", (data[0].dProduceDate || ""));
        //iSdContractMRecNo
        Page.setFieldValue("sUserName", (data[0].sUserName || ""));
        Page.setFieldValue("iSdContractMRecNo", (data[0].iSdContractMRecNo || "0"));
    }
})


$(function () {
    Page.Children.toolBarBtnAdd("SdOrderDBom", "fillsize", "填充尺码", '', function () {
        var dyncolumns = Page.Children.GetDynColumns("SdOrderDBom");
        //
        var ss = "";
        r = {};
        $(dyncolumns).each(function (j, d) {
            if (d) {
                r[d] = d;
            }
        })

        var row = $("#SdOrderDBom").datagrid("getSelected");
        if (row) {
            var rowindex = $("#SdOrderDBom").datagrid("getRowIndex", row);
            $("#SdOrderDBom").datagrid("updateRow", {
                index: rowindex, row: r
            });
        }
    })

    var queryParams = $("#SDContractDProduce").datagrid("options").queryParams;
    var linkField = $("#SDContractDProduce").attr("linkfield");
    var linkField0 = linkField.split("=")[0];
    var linkField0Value = Page.getFieldValue(linkField0);
    queryParams.key = linkField0Value;
    queryParams.filters = "ibscDataStyleMRecNo='" + Page.getFieldValue("iBscDataStyleMRecNo") + "'";

    $('#SDContractDProduce').datagrid('reload', queryParams);
        })

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "SdOrderDBom") {
                var tid = $(datagridOp.current).attr("tablename") || "";
                if (tid == "SdOrderDBom") {
                    switch (datagridOp.currentColumnName) {
                        case "iSource":
                        case "sCode":
                        case "fBaseUse":
                        case "Spec":
                            var a = {
                                sLastUserID: Page.userid,
                                dLastInputDate: Page.getNowDate() + " " + Page.getNowTime()
                            }
                            $("#" + tableid).datagrid("updateRow", {index:index,row:a})
                            break;
                    }
                }
            }
        }

Page.Children.onBeforeEdit = function (tableid, index, row) {
    if (tableid == "SdOrderDBom") {
        if (row.iCheck == 1) {
            return false;
        }
    }
}

Page.Children.onBeforeDeleteRow = function (tableid) {
    if (tableid == "SdOrderDBom") {
        var rows = $("#SdOrderDBom").datagrid("getChecked");
        var bl = false;
        $(rows).each(function (i, r) {
            if (r.iCheck == 1) {
                bl = true;
                return false;
            }
           
        })
        if (bl == true) {
            alert('存在已审核的行,不允许执行删除操作');
            return false;
        }
    }
}

//在赋值全部数据前
lookUp.beforeSetValue = function (uniqueid, data) {
    if (uniqueid == "68") {
        //获取data中每一行尺码数据，并设置到data的每一行中
        var iRecNoStr = "";
        for (var i = 0; i < data.length; i++) {
            iRecNoStr += "'" + data[i].iRecNo + "',";
        }
        if (data.length > 0) {
            iRecNoStr = iRecNoStr.substr(0, iRecNoStr.length - 1);
        }
        iRecNoStr = "(" + iRecNoStr + ")";
        var sqlobj = {
            TableName: "bscDataStyleBomDD",
            Fields: "*",
            SelectAll: "True",
            Filters: [
                    {
                        Field: "imainrecNo",
                        ComOprt: "in",
                        Value: iRecNoStr
                    }
                    ]
            //            Sorts: [
            //                    {
            //                        SortName: "iRecNo",
            //                        SortOrder: "asc"
            //                    }
            //                ]
        };
        var resultSizeQty = SqlGetData(sqlobj);
        if (resultSizeQty && resultSizeQty.length > 0) {
            for (var i = 0; i < data.length; i++) {
                for (var j = 0; j < resultSizeQty.length; j++) {
                    if (data[i].iRecNo == resultSizeQty[j].iRecNo) {
                        data[i][(resultSizeQty[j].sSizeName)] = resultSizeQty[j].fQty;
                    }
                }
            }
        }
        return data;
    }
    if (uniqueid == "80") {
        //获取data中每一行尺码数据，并设置到data的每一行中
        var iRecNoStr = "";
        for (var i = 0; i < data.length; i++) {
            iRecNoStr += "'" + data[i].iRecNo + "',";
        }
        if (data.length > 0) {
            iRecNoStr = iRecNoStr.substr(0, iRecNoStr.length - 1);
        }
        
        iRecNoStr = "(" + iRecNoStr + ")";
        var sqlobj = {
            TableName: "SdOrderDBomD",
            Fields: "*",
            SelectAll: "True",
            Filters: [
                    {
                        Field: "imainrecNo",
                        ComOprt: "in",
                        Value: iRecNoStr
                    }
                    ]
            //            Sorts: [
            //                    {
            //                        SortName: "iRecNo",
            //                        SortOrder: "asc"
            //                    }
            //                ]
        };
        var resultSizeQty = SqlGetData(sqlobj);
        if (resultSizeQty && resultSizeQty.length > 0) {
            for (var i = 0; i < data.length; i++) {
                for (var j = 0; j < resultSizeQty.length; j++) {
                    if (data[i].iRecNo == resultSizeQty[j].iMainRecNo) {
                        data[i][(resultSizeQty[j].sSizeName)] = resultSizeQty[j].fQty;
                    }
                }
            }
        }
        return data;
    }
}
//在赋值行数据前，index是相对于data的行号，row是要赋值的行数据
lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
    if (uniqueid == "68") {
        //赋值每行数据前检测是否有重复
//        var rows = $("#table1").datagrid("getRows");
//        for (var i = 0; i < rows.length; i++) {
//            if (rows[i].iProOrderPlanDRecNo == row.iProOrderPlanDRecNo) {
//                Page.MessageShow("不可转入", "不可重复转入相同数据");
//                return false;
//            }
//        }
        //将尺码数据设置到行上
        var dynColumns = Page.Children.GetDynColumns("SdOrderDBom");
        for (var i = 0; i < dynColumns.length; i++) {
            if (data[index][(dynColumns[i])]) {
                row[(dynColumns[i])] = data[index][(dynColumns[i])];
            }
        }
        return row;
    }
    if (uniqueid == "80") {
        //赋值每行数据前检测是否有重复
        //        var rows = $("#table1").datagrid("getRows");
        //        for (var i = 0; i < rows.length; i++) {
        //            if (rows[i].iProOrderPlanDRecNo == row.iProOrderPlanDRecNo) {
        //                Page.MessageShow("不可转入", "不可重复转入相同数据");
        //                return false;
        //            }
        //        }
        //将尺码数据设置到行上
        var dynColumns = Page.Children.GetDynColumns("SdOrderDBom");
        for (var i = 0; i < dynColumns.length; i++) {
            
            if (data[index][(dynColumns[i])]) {
                row[(dynColumns[i])] = data[index][(dynColumns[i])];
                
            }
        }
        
        return row;
    }
}
//在赋值行数据后rowIndex是相对于子表的行号
lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
    //uniqueid=62表示从生产计划明细转入
    if (uniqueid == "68") {
        //合计行数量
        Page.Children.DynFieldRowSummary("SdOrderDBom", rowIndex);
    }
    if (uniqueid == "80") {
        //合计行数量
        Page.Children.DynFieldRowSummary("SdOrderDBom", rowIndex);
    }
}
//在赋值全部数据后
lookUp.afterSelected = function (uniqueid, data) {
    //uniqueid=62表示从生产计划明细转入
    if (uniqueid == "68") {
        //全部转入完成后合计页脚数据
        Page.Children.ReloadFooter("SdOrderDBom");
        Page.Children.ReloadDynFooter("SdOrderDBom");
    }
    if (uniqueid == "80") {
        //全部转入完成后合计页脚数据
        Page.Children.ReloadFooter("SdOrderDBom");
        Page.Children.ReloadDynFooter("SdOrderDBom");
    }
}

$(function () {
    Page.Children.toolBarBtnDisabled("SDContractDProduce", "add");
    Page.Children.toolBarBtnDisabled("SDContractDProduce", "delete");
    Page.Children.toolBarBtnDisabled("SmOrderMatNeedM", "add");
    Page.Children.toolBarBtnDisabled("SmOrderMatNeedM", "delete");
})



Page.beforeSave = function () {
    $("#SDContractDProduce").remove();
    $("#SmOrderMatNeedM").remove();
    var rows = $("#SdOrderDBom").datagrid("getRows");
    var err = "";
    $(rows).each(function (i, r) {
        if (!r.sLastUserID) {
            r.sLastUserID = Page.userid;
            r.dLastInputDate = Page.getNowDate() + " " + Page.getNowTime();
        }
        if (parseInt(r.iSizeType) == 2) { //分规格时
            r.iBscDataSizeRecNo = 0;
            var dyncolumns = Page.Children.GetDynColumns("SdOrderDBom");
            //
            var ss = "";
            $(dyncolumns).each(function (j, d) {
                if (d && r[d]) {
                    if (ss) {
                        ss = ss + ",'" + r[d] + "'";
                    } else {
                        ss = "'" + r[d] + "'";
                    }
                }
            })
            var iBscDataMatRecNo = r["iBscDataMatRecNo"] || "0";
            if (ss) {
                var sqlObj = {
                    //表名或视图名
                    TableName: "BscDataSize",
                    //选择的字段
                    Fields: "*",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            //左括号
                            //字段名
                            Field: "sClassID",
                            //比较符
                            ComOprt: "=",
                            //值
                            Value: "left((select sClassID from bscDataMat where iRecNo=" + iBscDataMatRecNo + "),2)",
                            //连接符
                            LinkOprt: "and"
                        },
                        {
                            Field: "Spec",
                            ComOprt: "in",
                            Value: "(" + ss + ")"
                        }
                        ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length != ss.split(',').length) {

                    err = "第[" + (i + 1) + "]行，物料编码[" + (r["sCode"] || "") + ",规格与物料大类不对应]";
                    return false;
                }
            }
            if (r.iBscDataSizeRecNo) {
                err = "第[" + (i + 1) + "]行，物料编码[" + (r["sCode"] || "") + ",分规格和规格只能选其一]";
                return false;
            }
        }

        if (parseInt(r.sSizeType) == 1) { //分单耗时
            var dyncolumns = Page.Children.GetDynColumns("bscDataStyleBomD");
            $(dyncolumns).each(function (j, d) {
                if (d) {
                    if (r[d] && isNaN(r[d])) {
                        err = "第[" + (i + 1) + "]行，物料编码[" + (r["sCode"] || "") + ",规格[" + d + "]非数字]";
                        return false;
                    }
                }
            });

        }
        if (r.iSource == 3) {
            if (!r.dCustomerDate) {
                err = "第[" + (i + 1) + "]行，来源为【客供】时，必填客供交期";
                return false;
            }
        }
    })

    if (err) {
        alert(err);
        return false;
    }
    return true;
}

Page.afterSave = function () {
    var jsonobj = {
        StoreProName: "SpOrderMatNeed",
        StoreParms: [{
            ParmName: "@iOrderType",
            Value: '0'
        }, {
            ParmName: "@iBillRecNo",
            Value: Page.getFieldValue('iSdContractMRecNo')
        }]
    }
    var result = SqlStoreProce(jsonobj);
    if (result && result.length > 0 && result != "-1") {
        return result;
    }
    else {
        return "-1";
    }

}
