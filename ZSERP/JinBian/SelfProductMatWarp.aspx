<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        //var sumUse = 0;
        Page.Children.fit = false;
        $(function () {
            //$("textarea[readonly='readonly']").addClass("txareadonly");
            
            //            $("#table3").datagrid(
            //            {
            //                title: "组织",
            //                fit: false,
            //                height: 180,
            //                border: true,
            //                remoteSort: false,
            //                columns: [
            //                    [
            //                        { title: "", field: "iRecNo", width: 30, hidden: true },
            //                        { field: "__cb", checkbox: true, width: 30, align: "center" },
            //                        { title: "序号", field: "iSerial", width: 30, align: "center" },
            //                        {
            //                            title: "梳栉", field: "sGuideBar", width: 60, styler: function (value, row, index) {
            //                                return 'background-color:#ffffaa;';
            //                            }, align: "center"
            //                        },
            //                        { title: "组织", field: "sOrganization", width: 300, align: "center", editor: { type: "text" } },
            //                        { title: "送经量（MM/RACK）", field: "sWarpRunin", width: 80, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
            //                //                        { title: "旦数", field: "iDenier", width: 80, align: "center", editor: { type: "numberbox", options: { precision: 0}} },
            //                        { title: "偏差幅度", field: "sAmplitude", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
            ////                        { title: "穿纱", field: "sEntry", width: 60, align: "center", editor: { type: "text"} },
            //                        { title: "送经张力（G/DN）", field: "sTension", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2 } } }
            //                    ]
            //                ],
            //                onClickCell: function (index, field, value) {
            //                    endEditAll();
            //                    datagridOp.cellClick("table3", index, field, value);
            //                },
            //                onBeforeEdit: function (index, row) {
            //                    if (Page.usetype == "view") {
            //                        return false;
            //                    }
            //                    datagridOp.beforeEditor("table3", index, row);
            //                },
            //                onBeginEdit: function (index, row) {
            //                    datagridOp.beginEditor("table3", index, row);
            //                },
            //                onEndEdit: function (index, row, changes) {
            //                    if ((datagridOp.currentColumnName == "sWarpRunin" && changes.sWarpRunin) || (datagridOp.currentColumnName == "iDenier" && changes.iDenier)) {
            //                        calcUse(index);
            //                    }
            //                    datagridOp.endEditor("table3", index, row, changes);
            //                },
            //                afterEditor: function (index, row, changes) {
            //                    datagridOp.endEditor("table3", index, row, changes);
            //                }
            //            });

            $("#table1").datagrid({
                height: 180,
                border: true,
                title: "原料",
                onCheck: function (index, row) {
                    $("#table2").datagrid("checkRow", index);
                    //$("#table3").datagrid("checkRow", index);
                },
                onUncheck: function (index, row) {
                    $("#table2").datagrid("uncheckRow", index);
                    //$("#table3").datagrid("uncheckRow", index);
                },
                onCheckAll: function (index, row) {
                    $("#table2").datagrid("checkAll");
                    //$("#table3").datagrid("checkAll");
                },
                onUncheckAll: function (index, row) {
                    $("#table2").datagrid("uncheckAll");
                    //$("#table3").datagrid("uncheckAll");
                },
                onLoadSuccess: function () {
                    if (Page.usetype != "add") {
                        var allRows = $("#table1").datagrid("getRows");
                        if (allRows.length > 0) {
                            var allrows1 = [];
                            deepCopy1(allrows1, allRows);
                            var allrows2 = [];
                            deepCopy1(allrows2, allRows);
                            $("#table2").datagrid("loadData", allrows1);
                            //$("#table3").datagrid("loadData", allrows2);
                        }
                    }
                }
            });
        })

        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid == "table1") {
                var allRows = $("#table1").datagrid("getRows");
                $("#table1").datagrid("updateRow", { index: allRows.length - 1, row: { sGuideBar: "GB" + allRows.length } });
                var lastedRow = allRows[allRows.length - 1];
                var lastedRow2 = {};
                deepCopy1(lastedRow2, lastedRow);
                var lastedRow3 = {};
                deepCopy1(lastedRow3, lastedRow);
                $("#table2").datagrid("appendRow", lastedRow2);
                //$("#table3").datagrid("appendRow", lastedRow3);
            }
        }
        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "table1") {
                for (var i = 0; i < rows.length; i++) {
                    var iRecNo = rows[i].iRecNo;
                    var allRows2 = $("#table2").datagrid("getRows");
                    for (var j = 0; j < allRows2.length; j++) {
                        var iRecNo2 = allRows2[j].iRecNo;
                        if (iRecNo == iRecNo2) {
                            $("#table2").datagrid("deleteRow", j);
                        }
                    }

                    //var allRows3 = $("#table3").datagrid("getRows");
                    //for (var k = 0; k < allRows3.length; k++) {
                    //    var iRecNo3 = allRows3[k].iRecNo;
                    //    if (iRecNo == iRecNo3) {
                    //        $("#table3").datagrid("deleteRow", k);
                    //    }
                    //}
                }
                calcUse();
            }
        }
        Page.Children.onClickCell = function (tableid, index, field, value) {
            if (tableid == "table1") {
                endEditAll();
            }
        }
        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                if ((datagridOp.currentColumnName == "sGuideBar" && changes.sGuideBar)) {
                    $("#table2").datagrid("updateRow", { index: index, row: { sGuideBar: row.sGuideBar } });
                    //$("#table3").datagrid("updateRow", { index: index, row: { sGuideBar: row.sGuideBar } }); 
                }
                if (datagridOp.currentColumnName == "sName" && changes.sName != null && changes.sName != undefined) {
                    calcUse();
                }
                if ((datagridOp.currentColumnName == "sWarpRunin" && changes.sWarpRunin) || (datagridOp.currentColumnName == "iDenier" && changes.iDenier)) {
                    calcUse(index);
                }
                if ((datagridOp.currentColumnName == "fPrice")) {
                    var fSalePrice = 0;
                    var allRows1 = $("#table1").datagrid("getRows");
                    for (var i = 0; i < allRows1.length; i++) {
                        var onePrice = (isNaN(Number(allRows1[i].fSrate)) ? 0 : Number(allRows1[i].fSrate)) / 100 * (isNaN(Number(allRows1[i].fPrice)) ? 0 : Number(allRows1[i].fPrice));
                        fSalePrice += onePrice;
                    }
                    Page.setFieldValue("fSalePrice", fSalePrice);
                }

            }
        }

        function calcUse1(fUpDensity, iHead, fPanQty, sWarpRunin, iDenier, sDrawRatio) {
            return fUpDensity * 100 * iHead * fPanQty * (sWarpRunin / ((100 + sDrawRatio) / 100)) / 480 / 1000 / 9000 * iDenier;
        }
        var sumMeterWeight = 0;
        function calcUse() {
            var allrows1 = $("#table1").datagrid("getRows");
            var allrows2 = $("#table2").datagrid("getRows");
            //var allrows3 = $("#table3").datagrid("getRows");
            var fUpDensity = isNaN(parseFloat(Page.getFieldValue("fUpDensity"))) ? 0 : parseFloat(Page.getFieldValue("fUpDensity"));
            var sOutPut = isNaN(Number(Page.getFieldValue("sOutPut"))) ? 0 : Number(Page.getFieldValue("sOutPut"));
            var sum = 0;
            sumMeterWeight = 0;
            for (var i = 0; i < allrows1.length; i++) {
                var row2_i = allrows2[i];
                //var row3_i = allrows3[i];
                var row1_i = allrows1[i];
                var iHead_i = isNaN(parseFloat(row2_i.iHead)) ? 0 : parseFloat(row2_i.iHead);
                var fPanQty_i = isNaN(parseFloat(row2_i.fPanQty)) ? 0 : parseFloat(row2_i.fPanQty);

                var sWarpRunin_i = isNaN(parseFloat(row1_i.sWarpRunin)) ? 0 : parseFloat(row1_i.sWarpRunin);
                var iDenier_i = isNaN(parseFloat(row1_i.iDenier)) ? 0 : parseFloat(row1_i.iDenier);
                var sDrawRatio_i = isNaN(parseFloat(row2_i.sDrawRatio)) ? 0 : parseFloat(row2_i.sDrawRatio);
                var tmpp_i = calcUse1(fUpDensity, iHead_i, fPanQty_i, sWarpRunin_i, iDenier_i, sDrawRatio_i);
                sum += tmpp_i;

                sumMeterWeight += sWarpRunin_i * fUpDensity / 480 * iHead_i * fPanQty_i / sOutPut * iDenier_i / 0.9;
            }
            for (var index = 0; index < allrows1.length; index++) {
                var row2 = allrows2[index];
                //var row3 = allrows3[index];
                var row1 = allrows1[index];
                var iHead = isNaN(parseFloat(row2.iHead)) ? 0 : parseFloat(row2.iHead);
                var fPanQty = isNaN(parseFloat(row2.fPanQty)) ? 0 : parseFloat(row2.fPanQty);

                var sWarpRunin = isNaN(parseFloat(row1.sWarpRunin)) ? 0 : parseFloat(row1.sWarpRunin);
                var iDenier = isNaN(parseFloat(row1.iDenier)) ? 0 : parseFloat(row1.iDenier);
                var sDrawRatio = isNaN(parseFloat(row2.sDrawRatio)) ? 0 : parseFloat(row2.sDrawRatio);

                var tmpp = calcUse1(fUpDensity, iHead, fPanQty, sWarpRunin, iDenier, sDrawRatio);

                $("#table1").datagrid("updateRow", { index: index, row: { fSrate: (isNaN((tmpp / sum) * 100) ? 100 : (tmpp / sum) * 100), fWtmTmp: tmpp } });
            }
            //米重
            Page.setFieldValue("fFabWeightReal", sumMeterWeight / 100000);

            var fUpDensity = isNaN(parseFloat(Page.getFieldValue("fUpDensity"))) ? 0 : parseFloat(Page.getFieldValue("fUpDensity"));
            var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
            var fEfficiency = isNaN(parseFloat(Page.getFieldValue("fEfficiency"))) ? 1 : parseFloat(Page.getFieldValue("fEfficiency")) / 100;
            var sOutPut = isNaN(parseFloat(Page.getFieldValue("sOutPut"))) ? 0 : parseFloat(Page.getFieldValue("sOutPut"));
            var result = 0;
            if (fUpDensity == 0) {
                result = 0;
            }
            else {
                result = parseFloat(sRev * 60 * 24 / fUpDensity / 100 * fEfficiency * sOutPut).toFixed(2);
            }
            Page.setFieldValue("fDayYieldM", result);
            Page.setFieldValue("fDayYieldKG", (result / sOutPut * sum / 1000).toFixed(2));
        }
        function endEditAll() {
            var allrows = $("#table1").datagrid("getRows");
            var allrows2 = $("#table2").datagrid("getRows");
            //var allrows3 = $("#table3").datagrid("getRows");
            for (var i = 0; i < allrows.length; i++) {
                $("#table1").datagrid("endEdit", i);
            }
            for (var i = 0; i < allrows2.length; i++) {
                $("#table2").datagrid("endEdit", i);
            }
            //for (var i = 0; i < allrows3.length; i++) {
            //    $("#table3").datagrid("endEdit", i);
            //}
        }

        function mergeJsonObj(jsonbject1, jsonbject2) {
            var resultJsonObject = {};
            for (var attr in jsonbject1) {
                resultJsonObject[attr] = jsonbject1[attr];
            }
            for (var attr in jsonbject2) {
                resultJsonObject[attr] = jsonbject2[attr];
            }
            return resultJsonObject;
        }

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "fUpDensity") {
                    calcUse();
                }
                if (field == "fUpDensity" || field == "sRev" || field == "fEfficiency" || field == "sOutPut") {
                    var allRows = $("#table1").datagrid("getRows");
                    var sum = 0;
                    for (var i = 0; i < allRows.length; i++) {
                        sum += (isNaN(parseFloat(allRows[i].fWtmTmp)) ? 0 : parseFloat(allRows[i].fWtmTmp));
                    }
                    var fUpDensity = isNaN(parseFloat(Page.getFieldValue("fUpDensity"))) ? 0 : parseFloat(Page.getFieldValue("fUpDensity"));
                    var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
                    var fEfficiency = isNaN(parseFloat(Page.getFieldValue("fEfficiency"))) ? 1 : parseFloat(Page.getFieldValue("fEfficiency")) / 100;
                    var sOutPut = isNaN(parseFloat(Page.getFieldValue("sOutPut"))) ? 0 : parseFloat(Page.getFieldValue("sOutPut"));
                    var result = 0;
                    if (fUpDensity == 0) {
                        result = 0;
                    }
                    else {
                        result = parseFloat(sRev * 60 * 24 / fUpDensity / 100 * fEfficiency * sOutPut).toFixed(2);
                    }
                    Page.setFieldValue("fDayYieldM", result);
                    Page.setFieldValue("fDayYieldKG", parseFloat(result / sOutPut * sum / 1000).toFixed(2));
                    if (field == "sOutPut") {
                        Page.setFieldValue("fFabWeightReal", sumMeterWeight / 100000);
                    }
                }
                if (field == "fFabWeight") {
                    var fFabWeight = Page.getFieldValue("fFabWeight");
                    Page.setFieldValue("fMeterLength", 100 / fFabWeight);
                }
                if (field == "fFabWeightReal" || field == "fFullLength") {
                    //匹重
                    var iYarnQty = isNaN(Number(Page.getFieldValue("iYarnQty"))) ? 0 : Number(Page.getFieldValue("iYarnQty"));
                    var fFabWeightReal = isNaN(Number(Page.getFieldValue("fFabWeightReal"))) ? 0 : Number(Page.getFieldValue("fFabWeightReal"));
                    Page.setFieldValue("fOneWeight", fFabWeightReal * iYarnQty / 1000);

                    if (field == "fFullLength") {
                        Page.setFieldValue("fMeterLength", isNaN(iYarnQty / (fFabWeightReal * iYarnQty / 1000)) ? 0 : iYarnQty / (fFabWeightReal * iYarnQty / 1000));
                    }
                }
                if (field == "fOneWeight") {
                    var iYarnQty = isNaN(Number(Page.getFieldValue("iYarnQty"))) ? 0 : Number(Page.getFieldValue("iYarnQty"));
                    var fOneWeight = isNaN(Number(Page.getFieldValue("fOneWeight"))) ? 0 : Number(Page.getFieldValue("fOneWeight"));
                    Page.setFieldValue("fMeterLength", fOneWeight == "" || fOneWeight == 0 ? 0 : isNaN(iYarnQty / fOneWeight) ? 0 : iYarnQty / fOneWeight);
                }
                if (field == "iYarnQty") {
                    var iYarnQty = isNaN(Number(Page.getFieldValue("iYarnQty"))) ? 0 : Number(Page.getFieldValue("iYarnQty"));
                    var fFabWeightReal = isNaN(Number(Page.getFieldValue("fFabWeightReal"))) ? 0 : Number(Page.getFieldValue("fFabWeightReal"));
                    Page.setFieldValue("fOneWeight", fFabWeightReal * iYarnQty / 1000);
                    var fOneWeight = isNaN(Number(Page.getFieldValue("fOneWeight"))) ? 0 : Number(Page.getFieldValue("fOneWeight"));
                    Page.setFieldValue("fMeterLength", fOneWeight == "" || fOneWeight == 0 ? 0 : isNaN(iYarnQty / fOneWeight) ? 0 : iYarnQty / fOneWeight);
                }
                if (field == "fOrderQty") {
                    var row1 = $("#table1").datagrid("getRows");
                    var row2 = $("#table2").datagrid("getRows");
                    var fOrderQty = Page.getFieldValue("fOrderQty");
                    fOrderQty = isNaN(Number(fOrderQty)) ? 0 : Number(fOrderQty);
                    for (var i = 0; i < row1.length; i++) {
                        var fSrate = isNaN(Number(row1[i].fSrate)) ? 0 : Number(row1[i].fSrate);
                        var iHead = isNaN(Number(row2[i].iHead)) ? 0 : Number(row2[i].iHead);
                        var fPanQty = isNaN(Number(row2[i].fPanQty)) ? 0 : Number(row2[i].fPanQty);
                        var iDenier = isNaN(Number(row1[i].iDenier)) ? 0 : Number(row1[i].iDenier);
                        var result = fOrderQty * fSrate / 100 / iHead / fPanQty * 1000 / (iDenier / 0.9);
                        result = result.toFixed(4);
                        $("#table2").datagrid("updateRow", { index: i, row: { sLength: result } });
                    }
                }
            }
        }

        Page.beforeSave = function () {
            //获取分类，编号自动产生时分类不能为空
            var sClassID = Page.getFieldValue("sClassID");
            if (sClassID == "") {
                Page.MessageShow("分类不能为空！", "分类不能为空！");
                return false;
            }
            var sqlObjClass = {
                TableName: "BscDataClass",
                Fields: "1", SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
                    }, {
                        Field: "len(sClassID)", ComOprt: ">", Value: sClassID.length, LinkOprt: "and"
                    }, {
                        Field: "sType", ComOprt: "=", Value: "'mat'"
                    }
                ]
            }
            var resultClass = SqlGetData(sqlObjClass);
            if (resultClass.length > 0) {
                Page.MessageShow("分类必须要是末级分类", "分类必须要是末级分类");
                return false;
            }

            //检测唯一性
            var sName = Page.getFieldValue("sName");
            if (sName == "") {
                Page.MessageShow("坯布名称不能为空", "坯布名称不能为空");
                return false;
            }
            var fProductWidth = Page.getFieldValue("fProductWidth");
            if (fProductWidth == "") {
                Page.MessageShow("幅宽不能为空", "幅宽不能为空");
                return false;
            }
            var fProductWeight = Page.getFieldValue("fProductWeight");
            if (fProductWeight == "") {
                Page.MessageShow("克重不能为空", "克重不能为空");
                return false;
            }

            //计算规格组成
            //物料名成 +规格型号 +(用量比例%)；
            var matRows = $("#table1").datagrid("getRows");
            var sElementStr = "";
            for (var i = 0; i < matRows.length; i++) {
                sElementStr += matRows[i].sName + " " + matRows[i].sElements + " (" + parseFloat(matRows[i].fSrate).toFixed(2) + "%) ; "
            }
            Page.setFieldValue("sElements", sElementStr);

            var sElements = Page.getFieldValue("sElements");
            var fUpDensity = Page.getFieldValue("fUpDensity");
            var allRows1 = $("#table1").datagrid("getRows");
            var zzsjl = "";
            for (var i = 0; i < allRows1.length; i++) {
                zzsjl += allRows1[i].sOrganization + "," + allRows1[i].sWarpRunin + ";";
            }
            var Filters = [
                {
                    Field: "sName", ComOprt: "=", Value: "'" + sName + "'", LinkOprt: "and"
                }, {
                    Field: "fProductWidth", ComOprt: "=", Value: fProductWidth, LinkOprt: "and"
                }, {
                    Field: "fProductWeight", ComOprt: "=", Value: fProductWidth, LinkOprt: "and"
                }, {
                    Field: "sElements", ComOprt: "=", Value: "'" + sElements + "'", LinkOprt: "and"
                }
            ];
            if (fUpDensity != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push(
                    {
                        Field: "fUpDensity", ComOprt: "=", Value: "'" + fUpDensity + "'", LinkOprt: "and"
                    }
                )
            }
            Filters.push(
                    {
                        Field: "sElementsSJL", ComOprt: "=", Value: "'" + zzsjl + "'"
                    }
                );

            var sqlObjCheck = {
                TableName: "vwBscDataMat as a", Fields: "1", SelectAll: "True",
                Filters: Filters
            }
            var resultCheck = SqlGetData(sqlObjCheck);
            if (resultCheck.length > 0) {
                Page.MessageShow("检测到重复的坯布信息", "检测到重复的坯布信息");
                return false;
            }
            //if (Page.usetype == "add") {
            //    var sCode = "";
            //    var resultMaxCode = SqlGetData(
            //        {
            //            TableName: "BscDataMat", Fields: "max(sCode) as sMaxCode", SelectAll: "True",
            //            Filters: [
            //                {
            //                    Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
            //                }, {
            //                    Field: "abs(iMatType)", ComOprt: "=", Value: 1
            //                }
            //            ]
            //        });
            //    if (resultMaxCode.length > 0) {
            //        var sMaxCode = resultMaxCode[0].sMaxCode;
            //        if (sMaxCode) {
            //            var lsh = sMaxCode.substr(sMaxCode.length - 4, 4);
            //            var maxid = parseInt(lsh, 10);
            //            maxid = maxid + 1;
            //            var length = maxid.toString().length;
            //            for (var i = 0; i < 4 - length; i++) {
            //                maxid = "0" + maxid.toString();
            //            }
            //            sCode = sClassID + maxid;
            //        } else {
            //            sCode = sClassID + "0001";
            //        }
            //    } else {
            //        sCode = sClassID + "0001";
            //    }
            //    Page.setFieldValue("sCode", sCode);
            //}

            var sqlCheckObj = {
                TableName: "bscDataMat",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue("sCode") + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iRecNo",
                        ComOprt: "<>",
                        Value: "'" + Page.key + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlCheckObj);
            if (result.length > 0) {
                Page.MessageShow("坯布编号不能重复", "对不起，坯布编号不能重复！");
                return false;
            }

            var allrows = $("#table1").datagrid("getRows");
            var allrows2 = $("#table2").datagrid("getRows");
            //var allrows3 = $("#table3").datagrid("getRows");
            var newRows = [];
            var rows2 = [];
            var columns2 = $("#table2").datagrid("options").columns;
            for (var i = 0; i < columns2[0].length; i++) {
                rows2.push(columns2[0][i].field);
            }
            //var rows3 = [];
            //var columns3 = $("#table3").datagrid("options").columns;
            //for (var i = 0; i < columns3[0].length; i++) {
            //    rows3.push(columns3[0][i].field);
            //}


            for (var i = 0; i < allrows.length; i++) {
                var rowOne2 = allrows2[i];
                for (var o in rowOne2) {
                    if ($.inArray(o, rows2) == -1) {
                        delete rowOne2[(o)];
                    }
                }
                var newObj = mergeJsonObj(allrows[i], rowOne2);
                //var rowOne3 = allrows3[i];
                //for (var o in rowOne3) {
                //    if ($.inArray(o, rows3) == -1) {
                //        delete rowOne3[(o)];
                //    }
                //}
                //newObj = mergeJsonObj(newObj, rowOne3);
                newRows.push(newObj);
            }
            $("#table1").datagrid("loadData", newRows);
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1250") {
                calcUse();
            }
        }
    </script>
    <style type="text/css">
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="height: 50px;">
            <br />
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table align="center" style="width: 70%">
                <tr>
                    <td>坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sName" Z_Required="true" />
                    </td>
                    <td width="50px">类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="基本信息">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="1" />
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iWarp" Z_Value="2" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>客户名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>客户规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sFeature" />
                            </td>
                            <td>来样编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sSampleBillNo" />
                            </td>
                            <td>来样时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" Z_FieldType="日期" runat="server" Z_FieldID="dSampleGetDate" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan='8'>
                                <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                    <table align="center">
                                        <tr>
                                            <td>样品幅宽(cm)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fSampleWidth" Z_disabled="False" />
                                            </td>
                                            <td>坯布幅宽(cm)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="fFabWidth" Z_disabled="False" />
                                            </td>
                                            <td>成品幅宽(cm)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fProductWidth" Z_disabled="False" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>样品克重(g/㎡)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="fSampleWeight" Z_disabled="False" />
                                            </td>
                                            <td>坯布克重(g/㎡)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="fFabWeight" Z_disabled="False" />
                                            </td>
                                            <td>成品克重(g/㎡)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fProductWeight" Z_disabled="False" />
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>规格组成
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sElements" Z_readOnly="true" runat="server" Style="width: 99%" />
                            </td>
                        </tr>
                        <tr>
                            <td>机 型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sModelType" />
                            </td>
                            <td>机 号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sModelNo" />
                            </td>
                            <td>开发时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDevelopDate" Z_FieldType="日期" />
                            </td>
                            <td>出样日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dSampleOutDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>牵拉纵密
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fUpDensity" Z_FieldType="数值"
                                    Z_decimalDigits="2" />
                            </td>
                            <td>开幅数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOutPut" Z_decimalDigits="0"
                                    Z_FieldType="整数" />
                            </td>
                            <td>梳 栉
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sGuideBar" />
                            </td>
                            <td>日产量(KG)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="fDayYieldKG" Z_FieldType="数值"
                                    Z_decimalDigits="2" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>卷取纵密
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sCoilingWale" />
                            </td>
                            <td>落布米数(M)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iYarnQty" />
                            </td>
                            <td>匹重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="fOneWeight" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                            <td>日产量(M)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fDayYieldM" Z_FieldType="数值"
                                    Z_decimalDigits="2" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>机速(RPM)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sRev" Z_FieldType="数值"
                                    Z_decimalDigits="2" />
                            </td>
                            <td>效率(%)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fEfficiency" Z_FieldType="数值"
                                    Z_decimalDigits="2" />
                            </td>
                            <td>布 边
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sSelvage" />
                            </td>
                            <td>工作针数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iSumQty" Z_readOnly="True" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                        </tr>
                        <tr>
                            <td>米长
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="fMeterLength" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                            <td>米重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="fFabWeightReal" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                            <td>停用时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                            </td>
                            <td>备 注
                            </td>
                            <td>
                                <textarea name="sRemark" fieldid="sRemark" style="border-bottom: 1px solid black; width: 99%; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                            </td>
                            <td>录入时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" Z_readOnly="True" />
                            </td>
                            <td>成本价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="fSalePrice" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                            <td>订单数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="fOrderQty" Z_NoSave="true" Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                        </tr>
                    </table>
                    <table id="table1" tablename="bscDataMatDWaste">
                    </table>
                    <table id="table2">
                    </table>
                    <table id="table3">
                    </table>

                    <%--<div class="easyui-layout" data-options="fit:true,border:false">
                        <div data-options="region:'north',border:false">
                        </div>
                        <div data-options="region:'center',border:false">
                            <div class="easyui-layout" data-options="border:false" style="height: 550px;">
                                <div data-options="region:'north',title:'原料',collapsible:false,border:false" style="height: 180px">
                                </div>
                                <div data-options="region:'center',title:'整经',collapsible:false,border:false" style="height: 180px">
                                </div>
                                <div data-options="region:'south',title:'组织',collapsible:false,border:false" style="height: 180px">
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
                <div data-options="fit:true" title="坯布要求">
                    <table id="table4" tablename="BscDataMatDFabAsk">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $("#table2").datagrid(
            {
                title: "整经",
                fit: false,
                height: 180,
                border: true,
                remoteSort: false,
                columns: [
                    [
                        { title: "", field: "iRecNo", width: 30, hidden: true },
                        { field: "__cb", checkbox: true, align: "center", width: 30 },
                        { title: "序号", field: "iSerial", align: "center", width: 30 },
                        {
                            title: "梳栉", field: "sGuideBar", width: 60, align: "center", styler: function (value, row, index) {
                                return 'background-color:#ffffaa;';
                            }
                        },
                        { title: "设备型号", field: "sUnitType", width: 80, align: "center", editor: { type: "text" } },
                        { title: "线速度（M/MIN）", field: "sLineSpeed", width: 80, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
//                        { title: "整经根数", field: "sWarpNO", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 0}} },
                        { title: "整经长度", field: "sWarpCO", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
                        { title: "排纱位", field: "sModel", width: 150, align: "center", editor: { type: "textarea" } },
                        { title: "穿经比", field: "sEntry", width: 50, align: "center", editor: { type: "numberbox", options: { precision: 4 } } },
                        { title: "整经根数", field: "iHead", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 0 } } },
                        { title: "盘头数", field: "fPanQty", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 0 } } },
                        { title: "张力", field: "sStrain", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
                        { title: "牵伸比%", field: "sDrawRatio", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2 } } },
                        { title: "整经<br />万米数", field: "sLength", width: 100, align: "center", editor: { type: "numberbox", options: { precision: 4 } } }
                    ]
                ],
                onClickCell: function (index, field, value) {
                    endEditAll();
                    datagridOp.cellClick("table2", index, field, value);
                },
                onBeforeEdit: function (index, row) {
                    if (Page.usetype == "view") {
                        return false;
                    }
                    datagridOp.beforeEditor("table2", index, row);
                },
                onBeginEdit: function (index, row) {
                    datagridOp.beginEditor("table2", index, row);
                },
                onEndEdit: function (index, row, changes) {
                    if ((datagridOp.currentColumnName == "iHead" && changes.iHead) || (datagridOp.currentColumnName == "fPanQty" && changes.fPanQty) || (datagridOp.currentColumnName == "sDrawRatio" && changes.sDrawRatio)) {
                        calcUse(index);
                    }

                    if (index == 0 && ((datagridOp.currentColumnName == "iHead" && changes.iHead) || (datagridOp.currentColumnName == "fPanQty" && changes.fPanQty) || (datagridOp.currentColumnName == "sEntry" && changes.sEntry))) {
                        var sumQty = row.iHead * row.fPanQty / row.sEntry;
                        Page.setFieldValue("iSumQty", sumQty);
                    }

                    datagridOp.endEditor("table2", index, row, changes);
                },
                onAfterEdit: function (index, row, changes) {
                    datagridOp.afterEditor("table2", index, row, changes);
                }
            });
    </script>
</asp:Content>
