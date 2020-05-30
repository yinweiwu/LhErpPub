



Page.Children.onEndEdit = function (tableid, index, row, changes) {
    if (tableid == "PurAskD") {

        if (datagridOp.currentColumnName == "fQty") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fTotal = fQty * fPrice;

            var fPerQty = isNaN(row["fPerQty"]) == true ? 0 : row["fPerQty"];
            var fPurQty = fQty * fPerQty;
            $("#PurAskD").datagrid("updateRow", { index: index, row: { fTotal: fTotal, fPurQty: fPurQty} });
        }
        if (datagridOp.currentColumnName == "fPurQty") {
            var fPurQty = isNaN(row["fPurQty"]) == true ? 0 : row["fPurQty"];
            var fPerQty = isNaN(row["fPerQty"]) == true ? 0 : row["fPerQty"];
            if (fPerQty && fPerQty != 0) {
                fQty = fPurQty / fPerQty;
                var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
                var fTotal = fPrice * fQty;
                $("#PurAskD").datagrid("updateRow", { index: index, row: { fTotal: fTotal, fQty: fQty} });
            }

        }
        if (datagridOp.currentColumnName == "fPrice") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fPrice = isNaN(row["fPrice"]) == true ? 0 : row["fPrice"];
            var fTotal = fQty * fPrice;
            $("#PurAskD").datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        }
        if (datagridOp.currentColumnName == "fTotal") {
            var fQty = isNaN(row["fQty"]) == true ? 0 : row["fQty"];
            var fTotal = isNaN(row["fTotal"]) == true ? 0 : row["fTotal"];
            if (fQty == 0) {
                fPrice = 0;
            } else {
                fPrice = fTotal / fQty;
            }
            $("#PurAskD").datagrid("updateRow", { index: index, row: { fPrice: fPrice} });
        }
    }
}