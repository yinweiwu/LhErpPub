
$(function () {
    if (Page.usetype == "add") {
        Page.setFieldValue("sUserID", Page.userid);
    }
    if (Page.usetype == "modify") {
        var sqlObj = {
            //表名或视图名
            TableName: "BscDataStyleM",
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
                            Value: "'" + (Page.getFieldValue("iBscDataStyleMRecNo") || "") + "'"
                        }
                        ]
        }
        var data = SqlGetData(sqlObj);
        if (data.length > 0) {
            Page.setFieldValue('sTyleName', data[0]["sStyleName"]);
            Page.setFieldValue('sSizeGroupID', data[0]["sSizeGroupID"])
        }
    }
})

$(function () {
    Page.Children.toolBarBtnAdd("bscDataStyleBomD", "fillsize", "填充尺码", '', function () {

        var dyncolumns = Page.Children.GetDynColumns("bscDataStyleBomD");
        
        //
        var ss = "";
        r = {};
        $(dyncolumns).each(function (j, d) {
            if (d) {
                r[d] = d;
            }
        })

        var row = $("#bscDataStyleBomD").datagrid("getSelected");
        if (row) {
            var rowindex = $("#bscDataStyleBomD").datagrid("getRowIndex", row);
            $("#bscDataStyleBomD").datagrid("updateRow", {
                index: rowindex, row: r
            });
        }
         
    })
})

Page.beforeSave = function () {

    var rows = $("#bscDataStyleBomD").datagrid("getRows");
    var err = "";
    $(rows).each(function (i, r) {

        if (parseInt(r.iSizeType) == 2) { //分规格时
            r.iBscDataSizeRecNo = 0;
            var dyncolumns = Page.Children.GetDynColumns("bscDataStyleBomD");
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

        if (r.iReadyMat == 1) {
            $("#bscDataStyleBomD").datagrid("updateRow", { index: i, row: {
                iSource: 2
            }
            });
        }
    })

    if (err) {
        alert(err);
        return false;
    }
    return true;
}