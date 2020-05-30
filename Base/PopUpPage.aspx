<%@ page language="C#" autoeventwireup="true" inherits="PopUpPage, App_Web_popuppage.aspx.fca1e55" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>选择数据</title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=4" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="JS/DataInterface.js"></script>
    <script src="JS/json2.js"></script>
    <script src="JS2/lookUp.js" type="text/javascript"></script>
    <script src="JS/datagridExtend.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var isMulti;
        var isEdit = 0;
        var lookupname;
        var showColumns = [];
        var searchColumns = [];
        var pageSize;
        var filters = "";
        var from;
        var theLookupObj;
        var isTopImport = getQueryString("isTopImport");
        if (isTopImport == "1") {
            var id = getQueryString("id");
            theLookupObj = window.parent.lookUp.getLookUpObjByID(id);
        }
        else {
            theLookupObj = window.parent.lookUp.getLookUpObjByCurrent();                     
        }
        isMulti = theLookupObj.isMulti;
        lookupname = theLookupObj.lookupName;
        pageSize = theLookupObj.pageSize;
        if (theLookupObj.isTableField == true) {
            filters = theLookupObj.parseChildFieldValue(decodeURI(getQueryString("value")));
        }
        else {
            filters = theLookupObj.parseMainFieldValue(decodeURI(getQueryString("value")));
        }
        from = getQueryString("from");        
        var txbHeight = "20";
        $(function () {
            //alert(filters);
            var tab = document.getElementById("tabcondition");
            var currtcol = 1;
            var colcount;
            //生成搜索条件
            if (searchColumns.length > 0) {
                //colcount = Math.floor(searchColumns.length / Math.floor((window.parent.lookUp.getLookUpObjByCurrent().width - 200) / 150));
                colcount = 3;
                for (var i = 0; i < searchColumns.length; i++) {
                    var eclass = "easyui-textbox";
                    var etype = searchColumns[i].type;
                    var lookupOptionsStr = "";
                    var lookupOptions = searchColumns[i].lookupOptions;

                    if (etype == "date") {
                        eclass = "easyui-datebox";
                    }
                    if (etype == "datetime") {
                        eclass = "easyui-datetimebox";
                    }
                    if (currtcol == 1) {
                        //var tr = tab.insertRow(tab.rows.length);
                        var tr = $("<tr></tr>");
                        $(tab).append(tr);
                        var td = $("<td style='width:60px'>" + searchColumns[i].title + "</td>");
                        $(tr).append(td);
                        //var tdcap = tr.insertCell();
                        //tdcap.style.width = "70px";
                        //tdcap.innerHTML = searchColumns[i].title;
                        //var tdvalue = tr.insertCell();
                        if (lookupOptions) {
                            lookupOptionsStr = "lookupOptions='[{" + lookupOptions + ",targetID:&quot;input " + i + currtcol + "&quot;}]'";
                        }
                        var tdvalue = $("<td><input type='text' " + lookupOptionsStr + " class='" + eclass + "' data-options='width:150,height:" + txbHeight + "' etype='" + etype + "' id='input" + i + "" + currtcol + "' FieldID='" + searchColumns[i].field + "' name='" + searchColumns[i].field + "' comOprt='" + searchColumns[i].comOprt + "'/></td>");
                        $(tr).append(tdvalue);
                        //tdvalue.innerHTML = "<input type='text' class='input' id='input" + i + "" + currtcol + "' FieldID='" + searchColumns[i].field + "' name='" + searchColumns[i].field + "'/>";
                        currtcol++;
                    }
                    else {
                        var tr = tab.rows[tab.rows.length - 1];
                        var tdcap = $("<td style='width:60px'>" + searchColumns[i].title + "</td>");
                        $(tr).append(tdcap);
                        if (lookupOptions) {
                            lookupOptionsStr = "lookupOptions='[{" + lookupOptions + ",targetID:&quot;input " + i + currtcol + "&quot;}]'";
                        }
                        var tdvalue = $("<td><input type='text' " + lookupOptionsStr + " class='" + eclass + "' data-options='width:150,height:" + txbHeight + "' etype='" + etype + "' id='input" + i + "" + currtcol + "' FieldID='" + searchColumns[i].field + "' name='" + searchColumns[i].field + "' comOprt='" + searchColumns[i].comOprt + "'/></td>");
                        $(tr).append(tdvalue);
                        if (currtcol == colcount) {
                            currtcol = 1;
                        }
                        else {
                            currtcol++;
                        }
                    }
                }
            }
            $.parser.parse("#tabcondition");
            var inputs = $("input[etype]");
            for (var i = 0; i < inputs.length; i++) {
                var etype = $(inputs[i]).attr("etype");
                var textbox = undefined;
                if (etype == "string" || etype == "number") {
                    textbox = $(inputs[i]).textbox("textbox");
                }
                if (etype == "date") {
                    textbox = $(inputs[i]).datebox("textbox");
                }
                if (etype == "datetime") {
                    textbox = $(inputs[i]).datetimebox("getValue");
                }
                $(textbox).bind("keydown", function (event) {
                    if (event.keyCode == 13) {
                        serarch();
                    }
                    stopBubble(this);
                });
            }
            lookUp.initFrame();
            lookUp.initHead();

            var textboxs = $("[lookupoptions]");
            $.each(textboxs, function (index, o) {
                var plugin = $(o).attr("plugin");
                if (plugin == undefined || plugin == null || plugin == "") {
                    $(o).textbox("textbox").bind("keydown", function (event) {
                        if (event.keyCode == 13) {
                            serarch();
                        }
                        stopBubble(this);
                    });
                }
                else if (plugin == "combobox") {
                    $(o).combobox("textbox").bind("keydown", function (event) {
                        if (event.keyCode == 13) {
                            serarch();
                        }
                        stopBubble(this);
                    });
                }
            })


            var height = theLookupObj.height ? theLookupObj.height : 400;
            height = height - 30 - 6/*- 45 - 25 * colcount*/;
            $("#DivDg").css("height", height + "px");
            //定义表格
            $("#dg").datagrid({
                columns: [showColumns],
                fit: true,
                border: false,
                pagination: true,
                singleSelect: !isMulti,
                rownumbers: true,
                checkOnSelect: true,
                pageSize: pageSize,
                pageList: [pageSize, pageSize * 2, pageSize * 5, pageSize * 10],
                url: "/Base/Handler/getDataList2.ashx",
                queryParams: { otype: "lookup", fields: theLookupObj.fields, filters: encodeURIComponent(filters), Rnd: Math.random(), pageKey: theLookupObj.pageKey, lookupname: lookupname },
                onDblClickRow: isMulti == true ? undefined : returnData,
                //onDblClickRow: returnData,
                onLoadError: function (data) {
                    alert("加载数据失败:" + data.responseText);
                },
                onClickCell: isEdit == 0 ? undefined : f_clickRowCell,
                onLoadSuccess: function (data) {
                    if (isMulti != true) {
                        if (data.rows.length > 0) {
                            $("#dg").datagrid("selectRow", 0);
                        }
                    }
                }
            });
            $($('#panel').layout('panel', 'north')).panel('resize', { height: (searchColumns / colcount) * 20 });
            //$("#panel").layout("resize");
            setTimeout(function () { $('#panel').layout('resize'); }, 500);
            if (isTopImport == "1") {
                $("#btnExit").hide();
            }
        })
        function getSelectedData() {
            var data;
            if (isMulti == true) {
                data = $("#dg").datagrid("getChecked");
                if (data.length > 0) {
                    return data;
                }
                else {
                    $.messager.alert("错误", "对不起，您没有选择任务数据！");
                    return [];
                }
            }
            else {
                data = $("#dg").datagrid("getSelected");
                return data;
            }
        }
        function returnData() {
            if (editIndex != undefined) {
                //                var allRows = $("#dg").datagrid("getRows");
                //                for (var i = 0; i < allRows.length; i++) {
                //                    $("#dg").datagrid("endEdit", i);
                //                }
                $("#dg").datagrid("endEdit", editIndex);
            }
            var data = getSelectedData();
            if (data) {
                var isError = theLookupObj.setValues(data);
                if (isError == false) {
                    return;
                }
                var selectedRows;
                if (isMulti) {
                    selectedRows = $("#dg").datagrid("getChecked");
                } else {
                    selectedRows = $("#dg").datagrid("getSelections");
                }
                while (selectedRows.length > 0) {
                    var theIndex = $("#dg").datagrid("getRowIndex", selectedRows[0]);
                    $("#dg").datagrid("deleteRow", theIndex);
                    if (getQueryString("multi") == "1") {
                        selectedRows = $("#dg").datagrid("getChecked");
                    } else {
                        selectedRows = $("#dg").datagrid("getSelections");
                    }
                }
                var tabid = getQueryString("tabid");
                var tabWhich = getQueryString("tabWhich");
                window.parent.lookUp.tabSwitch(tabid, tabWhich);
                //if (isMulti == true) {
                //    $("#dg").datagrid("uncheckAll");
                //}
            }
        }
        function serarch() {
            var apdsql = "";
            var tab = document.getElementById("tabcondition");
            var input = tab.getElementsByTagName("INPUT");
            for (var i = 0; i < input.length; i++) {
                if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null) {
                    var fieldid = input[i].attributes["FieldID"].nodeValue;
                    var comOprt = $(input[i]).attr("comOprt");
                    if (comOprt == undefined || comOprt == "") {
                        comOprt = "like";
                    }
                    var etype = $(input[i]).attr("etype");
                    var value = "";
                    if (etype == "string" || etype == "number") {
                        value = $(input[i]).textbox("getValue");
                    }
                    if (etype == "date") {
                        value = $(input[i]).datebox("getValue");
                    }
                    if (etype == "datetime") {
                        value = $(input[i]).datetimebox("getValue");
                    }
                    if (value.length > 0) {
                        switch (comOprt) {
                            case "like":
                                {
                                    if (apdsql.length > 0) {
                                        apdsql += " and " + fieldid + " like '%" + value + "%'";
                                    }
                                    else {
                                        apdsql += fieldid + " like '%" + value + "%'";
                                    }
                                } break;
                            case "=":
                                {
                                    if (apdsql.length > 0) {
                                        apdsql += " and " + fieldid + " = '" + value + "'";
                                    }
                                    else {
                                        apdsql += fieldid + " = '" + value + "'";
                                    }
                                } break;
                            case ">=":
                                {
                                    if (apdsql.length > 0) {
                                        apdsql += " and " + fieldid + " >= '" + value + "'";
                                    }
                                    else {
                                        apdsql += fieldid + " >= '" + value + "'";
                                    }
                                } break;
                            case "<=":
                                {
                                    if (apdsql.length > 0) {
                                        apdsql += " and " + fieldid + " <= '" + value + "'";
                                    }
                                    else {
                                        apdsql += fieldid + " <= '" + value + "'";
                                    }
                                } break;
                            case "in":
                                {
                                    var valueP = "";
                                    var valueArr = value.split(',');
                                    for (var j = 0; j < valueArr.length; j++) {
                                        valueP += "'" + valueArr[j] + "',";
                                    }
                                    if (valueArr.length > 0) {
                                        valueP = valueP.substr(0, valueP.length - 1);
                                    }
                                    if (apdsql.length > 0) {
                                        apdsql += " and " + fieldid + " in (" + valueP + ")";
                                    }
                                    else {
                                        apdsql += fieldid + " in (" + valueP + ")";
                                    }
                                } break;
                        }
                    }
                }
            }
            var queryParams = $("#dg").datagrid("options").queryParams;
            //apdsql = apdsql.length > 0 ? " and " + apdsql : "";
            apdsql = apdsql == "" ? "1=1" : apdsql;
            var filter;
            var fixFilter = theLookupObj.fixFilters;
            fixFilter = fixFilter == "" ? "1=1" : fixFilter;
            var fixFilter1 = theLookupObj.fixFilters1;
            if (fixFilter1 != "") {

                fixFilter += " and " + fixFilter1;
            }
            if (theLookupObj.isTableField == true && theLookupObj.isImport != true) {
                var fixFilter = window.parent.Page.parseChildField(fixFilter, window.parent.datagridOp.current.id, window.parent.datagridOp.currentRowIndex);
                filter = fixFilter == "" ? apdsql : fixFilter + " and " + apdsql;
            }
            else {

                if (window.parent.Page) {
                    fixFilter = window.parent.Page.parseMainField(fixFilter);
                }
                filter = fixFilter == "" ? apdsql : fixFilter + " and " + apdsql;
            }
            queryParams.filters = encodeURIComponent(filter.replace(/{this}/g, getQueryString("value")));
            $("#dg").datagrid("reload");
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
        function exit() {
            window.parent.lookUp.close();
        }
        var editIndex = undefined;
        function f_clickRowCell(rowIndex, field, value) {
            if (editIndex == undefined) {
                $("#dg").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#dg").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#dg").datagrid('endEdit', editIndex);
                $('#dg').datagrid('unselectRow', editIndex);
                $("#dg").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#dg").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    //var target = ed.target;
                    $(ed.target).focus();
                    $(ed.target).select();
                }
            }
            editIndex = rowIndex;
        }

        document.onkeydown = function () {
            if (event.keyCode == 13) {
                returnData();
            }
            if (event.keyCode == 38) {
                var rowsSelect = $("#dg").datagrid("getSelections");
                if (rowsSelect.length > 0) {
                    var selectedRowIndex = $("#dg").datagrid("getRowIndex", rowsSelect[0]);
                    if (selectedRowIndex != undefined && selectedRowIndex != null && selectedRowIndex > 0) {
                        $("#dg").datagrid("selectRow", selectedRowIndex - 1);
                    }
                    else {
                        $("#dg").datagrid("selectRow", 0);
                    }
                }
            }
            if (event.keyCode == 40) {
                var rowsSelect = $("#dg").datagrid("getSelections");
                if (rowsSelect.length > 0) {
                    var selectedRowIndex = $("#dg").datagrid("getRowIndex", rowsSelect[rowsSelect.length - 1]);
                    var rows = $("#dg").datagrid("getRows");
                    if (rows.length > 0) {
                        if (selectedRowIndex != undefined && selectedRowIndex != null && selectedRowIndex < rows.length - 1) {
                            $("#dg").datagrid("selectRow", selectedRowIndex + 1);
                        }
                        else {
                            $("#dg").datagrid("selectRow", 0);
                        }
                    }

                }
            }
        }

        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }
    </script>
    <style type="text/css">
        .input {
            width: 80px;
            border: none;
            border-bottom: solid 1px #aaaaaa;
            height: 20px;
        }
        .datagrid-header-row, .pagination {
            height: 30px;
            font-weight:bold;
        }

        .datagrid-row {
            height: 30px;
        }
    </style>
</head>
<body id="panel" style="font-size: 12px; padding: 0px; margin: 0px;" class="easyui-layout"
    data-options="border:false">
    <form id="form1" runat="server">
        <div id="tl" data-options="region:'north',split:true,border:false">
            <table>
                <tr>
                    <td>
                        <table id="tabcondition">
                        </table>
                    </td>
                    <td style="text-align: right; vertical-align: top;">
                        <a id="search" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                            onclick="serarch()">查询</a> <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                                onclick="returnData()">确定选择</a> <a id="btnExit" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'"
                                    onclick="exit()">退出</a>
                    </td>
                </tr>
            </table>
        </div>
        <div id="DivDg" data-options="region:'center',border:false">
            <table id="dg">
            </table>
        </div>
        <div id="divlookUp" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: true, cache: false,
     maximizable: true,resizable: true,onBeforeOpen:lookUp.onBeforeOpen,onBeforeClose:lookUp.onBeforeClose,onBeforeDestroy:lookUp.onBeforeDestroy">
            <iframe style='margin: 0; padding: 0' id='ifrlookup' name='ifrlookup' width='100%'
                height='99.5%' frameborder='0'></iframe>
        </div>
    </form>
</body>
</html>
