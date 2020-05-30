Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "PurOrderD") {

        if (datagridOp.currentColumnName == "fQty") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fTotal = fQty * fPrice;
            $("#PurOrderD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fPrice") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fTotal = fQty * fPrice;
            $("#PurOrderD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fTotal") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fTotal = isNaN(row["fTotal"]) == true ? 0 : row["fTotal"];
            if (fQty == 0) {
                fPrice = 0;
            } else {
                fPrice = fTotal / fQty;
            }
            $("#PurOrderD").datagrid("updateRow", { index: index, row: { fPrice: fPrice} });
        }
    }
}

$(function () {
    Page.Children.toolBarBtnAdd("PurOrderD", "sunhao", "损耗", "", function () {
        var rows = $("#PurOrderD").datagrid("getChecked");
        
        if (rows.length > 0) {
            
            try {
                var sqlObj = {
                    //表名或视图名
                    TableName: "PurOrderD",
                    //选择的字段
                    Fields: "iRecNo",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            //字段名
                            Field: "iRecNo",
                            //比较符
                            ComOprt: "=",
                            //值
                            Value: rows[0].iRecNo
                        }
                        ],
                    Sorts: [

                        ]
                }
                 
                var data = SqlGetData(sqlObj);
                var susertype = "";
                if (data.length > 0) {
                    susertype = "modify"
                } else {
                    susertype = "add";
                }
            } catch (ex) { 
                
            }
             
            window.open("/zserp/outside/TFrmProOutMatD.aspx?iformid=1030&usetype=" + susertype + "&key=" + rows[0].iRecNo, "", 'height=200, width=400, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no')
        }
    });
})

