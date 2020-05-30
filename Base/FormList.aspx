<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
//protected void Page_Load(object sender, EventArgs e)
//{
//    Page.Response.Buffer = false;
//    Page.Response.Cache.SetNoStore();
//}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>表单列表</title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=4" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css?r=4" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/approval.js" type="text/javascript"></script>
    <script src="JS2/lookUp.js" type="text/javascript"></script>
    <script src="JS/datagridExtend.js" type="text/javascript"></script>
    <script src="JS2/datagridOp.js" type="text/javascript"></script>
    <%--<script src="/Base/Lodop/LodopFuncs.js?r=1" type="text/javascript"></script>--%>
    <%--<script src="/Base/JS2/hxLodop.js?r=3" type="text/javascript"></script>--%>
    <script src="/Base/JS2/Form.js?r=2"></script>
    <script language="javascript" type="text/javascript">
        //var canModify = false;
        var PK = "";
        var tablename = "";
        var formTitle = "";
        var childTablename = "";
        var imageFieldArr = [];
        var isQuery = false;
        var isStore = false;
        var QueryFilters = "1=1";
        var isEditting = false;
        var isModify = false;
        var hasGroupFields = false;
        var personalGroupFields = [];
        var dynConditionData = [];
        var dynField = "";
        var dynColumns = [];
        var dynColumnIndex = undefined;
        var dynConditionGUID = undefined;
        var dynConditionValue = undefined;
        var isMultiColumn = false;
        var originalDataGridColumns;
        var ChartInfo = { isShow: false, type: [], data: undefined };
        //var isTreeList = undefined;
        var TreeListInfo = { isTreeList: false, idField: undefined, treeField: undefined, Fields: undefined };
        var searchCount = 0;
        var MergeFields = [];
        var userid = undefined;
        var assQueryArr = [];
        var hideColumns = { main: [], child: [] };
        var sGroupFieldsClass = "";
        var isAcrossQuery = undefined;
        var originalDataGridData = undefined;
        var originalDataGridFrozenColumns;
        var isAcrossSummry = undefined;
        var pbReportArr = undefined;
        var summaryFields = [];
        var tdTxbHeight = 30;
        var conditionRowCount;
        var conditionCount;
        var rowGroupCount;
        $.ajax({
            url: "/ashx/LoginHandler.ashx",
            type: "get",
            async: false,
            cache: false,
            data: { otype: "getcurtuserid" },
            success: function (data) {
                userid = data;
            },
            error: function () {

            }
        });
        //var conditionRowCount = 0;
        $.extend($.fn.form.methods, {
            getData: function (jq, params) {
                var formArray = jq.serializeArray();
                var oRet = {};
                for (var i in formArray) {
                    if (typeof (oRet[formArray[i].name]) == 'undefined') {
                        if (params) {
                            oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                        }
                        else {
                            oRet[formArray[i].name] = formArray[i].value;
                        }
                    }
                    else {
                        if (params) {
                            oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                        }
                        else {
                            oRet[formArray[i].name] += "," + formArray[i].value;
                        }
                    }
                }
                return oRet;
            }
        });

        /*  只返回目标节点的第一级子节点，具体的用法和getChildren方法是一样的 */
        $.extend($.fn.tree.methods, {
            getLeafChildren: function (jq, params) {
                var nodes = [];
                $(params).next().children().children("div.tree-node").each(function () {
                    nodes.push($(jq[0]).tree('getNode', this));
                });
                return nodes;
            }
        });
        $(function () {
            $("#divlogin").window("close");
            $("#panel").hide();
            $.messager.progress({ title: "正在加载..." });
            var multi = getQueryString("multi");
            var filters = getQueryString("filters");
            var fixFilters = getQueryString("fixFilters");
            if (fixFilters != null) {
                filters = filters == null ? fixFilters : filters + " and (" + fixFilters + ")";
            }
            var nofixFilters = getQueryString("nofixFilters");
            if (nofixFilters != null) {
                filters = filters == null ? nofixFilters : filters + " and (" + nofixFilters + ")";
            }

            var popup = getQueryString("popup");
            var returnFn = getQueryString("returnFn");
            var FormID = getQueryString("FormID");
            var MenuID = getQueryString("MenuID");
            var isTopImport = getQueryString("isTopImport") == null ? "" : getQueryString("isTopImport");
            //var filters = getQueryString(filters);
            if (filters == null || filters == "") {
                filters = "1=1";
            }
            $.ajax(
                {
                    contentType: "application/x-www-form-urlencoded; charset=utf-8",
                    url: "/Base/Handler/FormListHandler.ashx",
                    data: { otype: "FormListInit", multi: multi, filters: filters, popup: popup, FormID: FormID, MenuID: MenuID, returnFn: returnFn, isTopImport: isTopImport },
                    async: true,
                    cache: false,
                    success: function (data, status) {
                        try {
                            var resultObj = JSON2.parse(data);
                            if (resultObj.success == true) {
                                //var now = new Date().getTime();
                                //eval(resultObj.message);
                                new Function(resultObj.message)();
                                if (conditionCount > 0 && rowGroupCount > 0) {
                                    $($('#panel').layout('panel', 'north')).panel('resize', { height: conditionRowCount * 25 + 30 + 30 });
                                }
                                else if (conditionCount > 0) {
                                    if (conditionRowCount == 1) {
                                        $($('#panel').layout('panel', 'north')).panel('resize', { height: 70 });
                                    }
                                    else {
                                        $($('#panel').layout('panel', 'north')).panel('resize', { height: conditionRowCount * 25 + 30 });
                                    }
                                }
                                var tableCon = document.getElementById("tabConditions");
                                var allTr = tableCon.rows;
                                var displayStr = isAcrossQuery != true ? "style='display:none;'" : "";
                                if (allTr.length > 0) {
                                    var btnSearch = $("<td rowspan=2 style='vertical-align:top;'><a href='javascript:void(0)' onclick='FormList.BtnSearch()' class='button orange'>查询</a>&nbsp;&nbsp;<a id='abtnTS' " + displayStr + " href='javascript:void(0)' onclick='FormList.ShowCross()' class='button orange'>透视表</a></td>");
                                    $(allTr[0]).append(btnSearch);
                                }
                                else {
                                    var btnSearch = $("<tr><td rowspan=2 style='vertical-align:top;'><a href='javascript:void(0)' onclick='FormList.BtnSearch()' class='button orange'>查询</a>&nbsp;&nbsp;<a id='abtnTS' " + displayStr + " href='javascript:void(0)' onclick='FormList.ShowCross()' class='button orange'>透视表</a></td></tr>");
                                    $(tableCon).append(btnSearch);
                                }
                                if (assQueryArr.length > 0) {
                                    if (allTr.length == 0) {
                                        $(tableCon).append("<tr></tr>");
                                    }
                                    allTr = tableCon.rows;
                                    var assQueryBtn = "";
                                    for (var i = 0; i < assQueryArr.length; i++) {
                                        assQueryBtn += "<a href='javascript:void(0)' class='assQueryBtn' onclick=parent.turntoTab(\"" + assQueryArr[i].iMenuID + "\",\"" + assQueryArr[i].iAssFormID + "\",\"" + assQueryArr[i].sMenuName + "\",\"\",\"" + assQueryArr[i].sFilePath + "\",\"\")>" + assQueryArr[i].sMenuName + "</a>&nbsp;&nbsp;";
                                    }
                                    assQueryBtn = "<td style='font-size:12px;'>&nbsp;&nbsp;&nbsp;&nbsp;更多查询>&nbsp;&nbsp;" + assQueryBtn + "</td>";
                                    $(allTr[0]).append(assQueryBtn);
                                }
                                //var now1 = new Date().getTime();
                                //alert("时间为：" + (now1 - now) + "<br/>");
                                lookUp.initFrame();
                                lookUp.initHead();
                                if (isModify) {
                                    lookUp.initBody();
                                }
                                if (hasGroupFields == true) {
                                    var ckbGroupFields = $(".cbkGroupField");
                                    for (var i = 0; i < ckbGroupFields.length; i++) {
                                        if ($.inArray($(ckbGroupFields[i]).attr("fieldidg"), personalGroupFields) > -1) {
                                            ckbGroupFields[i].checked = true;
                                        }
                                    }
                                }
                                if (ChartInfo.isShow == true) {
                                    loadJS("/JS/fusioncharts/fusioncharts.js");
                                    var roundLoad = setInterval(function () {
                                        if (FusionCharts) {
                                            loadJS("/JS/fusioncharts/themes/fusioncharts.theme.fint.js");
                                            clearInterval(roundLoad);
                                        }
                                    }, 1000);
                                    if ($.inArray("line", ChartInfo.type) == -1) {
                                        $("#divChartTabs").tabs("close", "曲线图");
                                        $("#divChartTabsZoomIn").tabs("close", "曲线图");
                                    }
                                    if ($.inArray("column", ChartInfo.type) == -1) {
                                        $("#divChartTabs").tabs("close", "柱状图");
                                        $("#divChartTabsZoomIn").tabs("close", "柱状图");
                                    }
                                    if ($.inArray("pie", ChartInfo.type) == -1) {
                                        $("#divChartTabs").tabs("close", "饼状图");
                                        $("#divChartTabsZoomIn").tabs("close", "饼状图");
                                    }
                                }
                                if (getQueryString("isAss") == "1") {
                                    FormList.Refresh(getQueryString("filters"));
                                }
                                if (popup == "1" && isQuery == true) {
                                    FormList.Refresh(getQueryString("filters"));
                                    searchCount++;
                                }

                                var inputs = $("input[plugin]");
                                for (var i = 0; i < inputs.length; i++) {
                                    var etype = $(inputs[i]).attr("plugin");
                                    var textbox = undefined;
                                    if (etype == "textbox") {
                                        textbox = $(inputs[i]).textbox("textbox");
                                    }
                                    if (etype == "combobox") {
                                        textbox = $(inputs[i]).combobox("textbox");
                                    }
                                    if (etype == "datebox") {
                                        textbox = $(inputs[i]).datebox("textbox");
                                    }
                                    if (etype == "datetimebox") {
                                        textbox = $(inputs[i]).datetimebox("textbox");
                                    }
                                    if (etype == "numberspinner") {
                                        textbox = $(inputs[i]).numberspinner("textbox");
                                    }
                                    $(textbox).bind("keydown", function (event) {
                                        if (event.keyCode == 13) {
                                            FormList.BtnSearch();
                                        }
                                    });
                                }
                                lookUp.load();

                            }
                            else {
                                MessageShow("", resultObj.message);
                                $("#panel").layout("remove", "north");
                                $("#panel").layout("remove", "west");
                                $("#panel").layout("remove", "center");
                            }
                        }
                        catch (e) {
                            MessageShow("解析时发生错误", e.message);
                        }
                        $.messager.progress("close");
                        $("#panel").show();

                    },
                    error: function (data) {
                        MessageShow("错误", "访问服务器时发生错误");
                        $.messager.progress("close");
                        $("#panel").show();
                    }
                }
            );

            GetUpdateLog();
        });

        var FormList = {
            IsPrintShow: false,
            BtnSave: function () {
                if (datagridOp.currentRowIndex != undefined) {
                    $("#dg").datagrid("endEdit", datagridOp.currentRowIndex);
                }
                if (FormList.BeforeSave) {
                    if (FormList.BeforeSave() == false) {
                        return false;
                    }
                }
                var rows = $("#dg").datagrid("getRows");
                //只发送可编辑的数据到后台
                var columns = $("#dg").datagrid('getColumnFields', true).concat($("#dg").datagrid('getColumnFields'));
                for (var i = 0; i < columns.length; i++) {
                    var columnOption = $("#dg").datagrid("getColumnOption", columns[i]);
                    if (columnOption.editor == undefined && columnOption.field != PK) {
                        for (var j = 0; j < rows.length; j++) {
                            delete rows[j][(columns[i])];
                        }
                    }
                }
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    data: { otype: "FormListSave", rowsData: JSON2.stringify(rows), formid: getQueryString("FormID") },
                    cache: false,
                    async: false,
                    type: "POST",
                    success: function (data) {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            MessageShow("保存成功", "保存成功！");
                            $('.easyui-linkbutton').each(function (i) {
                                if ($('.easyui-linkbutton')[i].id != 'btnEdit' && $('.easyui-linkbutton')[i].id != 'btnSave') {
                                    $($('.easyui-linkbutton')[i]).linkbutton('enable');
                                }
                            })
                            $('#btnEdit').linkbutton({ text: '修改' });
                            isEditting = false;
                            FormList.BtnRefresh();
                        }
                        else {
                            MessageShow("失败", resultObj.message);
                        }
                    },
                    error: function (data) {
                        MessageShow("保存时错误", "保存时发生错误");
                    }
                });
            },
            BtnAdd: undefined,
            BtnEdit: undefined,
            BtnCopy: undefined,
            BtnRemove: undefined,
            BtnQuery: undefined,
            BtnRefresh: undefined,
            BtnPrint: undefined,
            BtnSubmit: undefined,
            BtnSubmitCancel: undefined,
            BtnExport: undefined,
            BtnExit: function () {
                try {
                    if (getQueryString("fullScreen") == "1") {
                        top.closeFullScreenWindow();
                    }
                    else {
                        top.closeTab();
                    }
                }
                catch (e) {
                    window.close();
                }
            },
            BtnSearch: function () {
                if (isAcrossQuery == true) {
                    $("#dg").datagrid({
                        columns: originalDataGridColumns,
                        frozenColumns: originalDataGridFrozenColumns
                    });
                }
                //$.messager.progress({ title: "正在拼命加载..." });
                var filters = "1=1";
                if (isStore == true) {
                    filters = "";
                }
                if ($("#form1").form("validate") != true) {
                    return false;
                }
                var formData = $("#form1").form("getData", true);
                for (var key in formData) {
                    if (formData[key] != undefined && formData[key] != "") {
                        var fieldid = key.substr(0, key.indexOf('`'));
                        var element = $("[FieldID=\"" + fieldid + "\"]");
                        $(element).each(function (index, ele) {
                            if ($(ele).attr("fname") == key) {
                                var plugin = $(ele).attr("plugin");
                                var lookupOption = $(ele).attr("lookupOptions");
                                var value = "";
                                switch (plugin) {
                                    case "textbox": {
                                        value = $(ele).textbox("getValue");
                                        if (lookupOption) {
                                            value = $("#" + ele.id + "_val").val();
                                        }
                                    } break;
                                    case "combobox": value = $(ele).combobox("getValues").join(","); break;
                                    case "combotree": value = $(ele).combotree("getValues").join(","); break;
                                    case "datebox": value = $(ele).datebox("getValue"); break;
                                    case "datetimebox": value = $(ele).datetimebox("getValue"); break;
                                    case "numberspinner": value = $(ele).numberspinner("getValue"); break;
                                }
                                if (element[0].type == "checkbox") {
                                    value = element[0].checked == true ? 1 : 0;
                                }
                                var conditionID = $(ele).attr("conditionID");
                                //                                if (conditionID == undefined) {
                                var comOprt = $(ele).attr("ComOprt");
                                if (comOprt == undefined) {
                                    comOprt = "=";
                                }
                                var isMulti = $(ele).attr("isMulti");
                                if (isMulti != "true") {
                                    if (isStore != true) {
                                        if (fieldid.indexOf("{value}") > -1) {
                                            while (fieldid.indexOf("{value}") > -1) {
                                                fieldid = fieldid.replace("{value}", value);
                                            }
                                            filters += " and " + fieldid;
                                        }
                                        else {
                                            if (comOprt.toLowerCase() == "%like%" || comOprt.toLowerCase() == "like") {
                                                filters += " and " + fieldid + " like " + "'%" + value + "%'";
                                            }
                                            else if (comOprt.toLowerCase() == "like%") {
                                                filters += " and " + fieldid + " like " + "'" + value + "%'";
                                            }
                                            else if (comOprt.toLowerCase() == "%like") {
                                                filters += " and " + fieldid + " like " + "'%" + value + "'";
                                            }
                                            else {
                                                filters += " and " + fieldid + " " + comOprt + " " + "'" + value + "'";
                                            }
                                        }
                                    }
                                    else {
                                        filters += fieldid + "=" + value + "$";
                                    }
                                }
                                else {
                                    var valueEx = "";
                                    var valueArr = value.split(',');
                                    for (var i = 0; i < valueArr.length; i++) {
                                        valueEx += "'" + valueArr[i] + "',";
                                    }
                                    if (valueEx.length > 0) {
                                        valueEx = valueEx.substr(0, valueEx.length - 1);
                                    }
                                    if (isStore != true) {
                                        if (fieldid.indexOf("{value}") > -1) {
                                            while (fieldid.indexOf("{value}") > -1) {
                                                fieldid = fieldid.replace("{value}", value);
                                            }
                                            filters += " and " + fieldid;
                                        }
                                        else {
                                            filters += " and " + fieldid + " " + comOprt + " " + "(" + valueEx + ")";
                                        }
                                    }
                                    else {
                                        filters += fieldid + "=" + valueEx.replace(/'/g, "''") + "$";
                                    }
                                }

                                //                                }
                            }
                        })

                    }
                }
                if (isStore == true && filters.length > 0) {
                    filters = filters.substr(0, filters.length - 1);
                }
                //filters = filters.replace(/%/g, "%25");
                FormList.Refresh(filters);
                searchCount++;
            },
            BtnSelect: function () {
                var selectedRows;
                if (getQueryString("multi") == "1") {
                    selectedRows = $("#dg").datagrid("getChecked");
                }
                else {
                    selectedRows = $("#dg").datagrid("getSelections");
                }
                if (selectedRows.length > 0) {
                    if (window.opener) {
                        var fnStr = FormList.ReturnFn + "(" + JSON2.stringify(selectedRows) + ")"
                        eval(fnStr);
                        if (getQueryString("multi") == "1") {
                            $("#dg").datagrid("uncheckAll");
                        }
                        else {
                            window.close();
                        }
                    } else if (window.parent) {
                        var dataFormID = getQueryString("dataFormID");
                        window.parent.dataForm.currentID = dataFormID;
                        var fnStr = "window.parent." + getQueryString("returnFn") + "(" + JSON2.stringify(selectedRows) + ")";
                        var isError = eval(fnStr);
                        if (isError == false) {
                            return;
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
                        eval("window.parent.dataForm.tabSwitch('" + tabid + "','" + tabWhich + "')");
                        if (getQueryString("multi") == "1") {
                            $("#dg").datagrid("uncheckAll");
                        }
                    }
                    //选择完后去掉复选框


                }
                else {
                    MessageShow("未选择数据", "亲，您未选择任务数据！");
                }
            },
            BtnSelectAll: function () {
                if ($.messager.confirm("确认转入所有数据？", "确认转入所有数据吗，可能会花费转长时间？", function (r) {
                    if (r) {
                        var selectedRows = $("#dg").datagrid('getData').originalRows ? $("#dg").datagrid('getData').originalRows : $("#dg").datagrid('getData').rows;;
                        if (selectedRows.length > 0) {
                            if (window.opener) {
                                var fnStr = FormList.ReturnFn + "(" + JSON2.stringify(selectedRows) + ")"
                                eval(fnStr);
                            }
                            else if (window.parent) {
                                var dataFormID = getQueryString("dataFormID");
                                var tabid = getQueryString("tabid");
                                var tabWhich = getQueryString("tabWhich");
                                window.parent.dataForm.currentID = dataFormID;
                                var fnStr = "window.parent." + getQueryString("returnFn") + "(" + JSON2.stringify(selectedRows) + ")";
                                var isError = eval(fnStr);
                                if (isError == false) {
                                    return;
                                }
                                eval("window.parent.dataForm.tabSwitch('" + tabid + "','" + tabWhich + "')");
                                $("#dg").datagrid("loadData", []);
                            }
                        }
                    }
                }
                ));
            },
            BtnImport: function () {
                $("#ifrImport").attr("src", "/Base/FileUpload/ImportExcel2.aspx?&iFormID=" + getQueryString("FormID") + "&r=" + Math.random);
                $("#divImport").dialog("open");
            },
            ReturnFn: undefined,
            GetSelectedKeys: function () {
                var keys = "";
                var selectedRows = $("#dg").datagrid("getSelections");
                for (var i = 0; i < selectedRows.length; i++) {
                    keys += selectedRows[i][PK] + ",";
                }
                if (keys.length > 0) {
                    keys = keys.substr(0, keys.length - 1);
                }
                return keys;
            },
            GetFormListQueryData: function (filters, treefilters) {
                if (filters == undefined || filters == "") {
                    filters = "1=1";
                }
                if (treefilters == undefined || treefilters == "") {
                    treefilters = "1=1";
                }
                var resultData;
                var groupFields = "";
                if (hasGroupFields == true) {
                    var ckbGroupFields = $(".cbkGroupField");
                    for (var i = 0; i < ckbGroupFields.length; i++) {
                        if (ckbGroupFields[i].checked == true) {
                            groupFields += $(ckbGroupFields[i]).attr("fieldidg") + ",";
                        }
                    }
                }
                if (groupFields != "") {
                    groupFields = groupFields.substr(0, groupFields.length - 1);
                }
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    data: { otype: "GetFormListData", isChild: "0", iformid: getQueryString("FormID"), iMenuID: getQueryString("MenuID"), filters: filters, treefilters: treefilters, groupFields: groupFields, isQuery: 1, conditionGUID: dynConditionGUID, conditionValue: dynConditionValue, dynCndnValue: dynConditionValue },
                    async: false,
                    cache: false,
                    success: function (data, status) {
                        try {
                            resultObj = JSON2.parse(data);
                            if (resultObj.success == true) {
                                //resultData = JSON2.parse(resultObj.message);
                                resultData = resultObj.tables[0];
                                if (ChartInfo.isShow == true) {
                                    ChartInfo.data = resultObj.tables.length > 1 ? resultObj.tables[1] : undefined;
                                }
                            }
                            else {
                                MessageShow("错误", resultObj.message);
                            }
                        }
                        catch (e) {
                            MessageShow("发生错误", e.message);
                        }

                    },
                    error: function () {
                        MessageShow("错误", "访问服务器时发生错误");
                    }
                });
                if (resultData) {
                    return resultData;
                }
            },
            GetImage: function (iformid, tablename, irecno, imageid, index) {
                $.ajax({
                    url: "/Base/imageUpload/imagesShow.aspx",
                    data: { otype: "getListImageN", iformid: iformid, tablename: tablename, irecno: irecno, imageid: imageid, index: index },
                    async: true,
                    cache: false,
                    success: function (data) {
                        result = data;
                        if (data != "") {
                            var img = $(data);
                            var source = $(img).attr("source");
                            imageFieldArr.push(source);
                            $("#" + source).append(img);
                            $("#" + source).tooltip(
                                {
                                    content: function () {
                                        var t = $(this);
                                        var img = $(t).children("img")[0];
                                        var src = $(img).attr("src");
                                        var alt = $(img).attr("alt");
                                        return $("<div><img src='" + src + "' alt='" + alt + "' style='width:250px; height:250px;'></div>");
                                    },
                                    /*showEvent: 'click',*/
                                    onShow: function () {
                                        var t = $(this);
                                        t.tooltip("tip").unbind().bind("mouseenter",
                                            function () { t.tooltip("show"); }).bind("mouseleave",
                                                function () {
                                                    t.tooltip("hide");
                                                });
                                    }
                                });

                        }
                    },
                    error: function (data) {
                        MessageShow("获取图片时发生错误", data);
                    }
                });
            },
            ExecProcedure: function (procedureName, iformid, keys, userid, btnid) {
                var sqlObj = {
                    StoreProName: procedureName,
                    StoreParms: [
                        {
                            ParmName: "@iformid",
                            Value: iformid
                        },
                        {
                            ParmName: "@keys",
                            Value: keys
                        },
                        {
                            ParmName: "@userid",
                            Value: userid
                        },
                        {
                            ParmName: "@btnid",
                            Value: btnid
                        }
                    ]
                };
                var result = SqlStoreProce(sqlObj);
                if (result == "1") {
                    //FormList.refresh();
                    return true;
                }
                else {
                    MessageShow("错误", result);
                    return false;
                }
            },
            Refresh: function (filters) {
                if ((filters == undefined || filters == "") && isStore != true) {
                    filters = "1=1";
                }
                var fixFilters = getQueryString("fixFilters");
                var nofixFilters = getQueryString("nofixFilters");
                if (getQueryString("popup") == "1") {
                    if (isStore != true) {
                        if (searchCount == 0) {
                            if (fixFilters != null) {
                                filters += " and " + fixFilters;
                            }
                            if (nofixFilters) {
                                filters += " and " + nofixFilters;
                            }
                        }
                        else {
                            if (fixFilters != null) {
                                filters += " and " + fixFilters;
                            }
                        }
                    }
                    else {
                        if (searchCount == 0) {
                            if (fixFilters != null) {
                                filters += "$" + fixFilters;
                            }
                            if (nofixFilters) {
                                filters += "$" + nofixFilters;
                            }
                        }
                        else {
                            if (fixFilters != null) {
                                filters += "$" + fixFilters;
                            }
                        }
                    }
                }
                if (isQuery == true && TreeListInfo.isTreeList != true) {
                    //                    if (fixFilters != null) {
                    //                        filters += " and " + fixFilters;
                    //                    }
                    $.messager.progress({ title: "查询中,请稍后", msg: "正在玩命的加载中，请稍后..." });
                    setTimeout(function () {
                        var data = FormList.GetFormListQueryData(filters);
                        originalDataGridData = data;
                        QueryFilters = filters;
                        if (hasGroupFields == true) {
                            var ckbGroupFields = $(".cbkGroupField");
                            for (var i = 0; i < ckbGroupFields.length; i++) {
                                if (ckbGroupFields[i].checked == false) {
                                    $("#dg").datagrid("hideColumn", $(ckbGroupFields[i]).attr("fieldidg"));
                                }
                                else {
                                    var theField = $(ckbGroupFields[i]).attr("fieldidg");
                                    if ($.inArray(theField, hideColumns.main) == -1) {
                                        $("#dg").datagrid("showColumn", $(ckbGroupFields[i]).attr("fieldidg"));
                                    }
                                }
                            }
                        }
                        $("#dg").datagrid("loadData", data);
                        $.messager.progress("close");
                    }, 500);
                }
                else {
                    if (TreeListInfo.isTreeList == true) {
                        var queryParam = $("#dg").treegrid("options").queryParams;
                        queryParam.filters = filters;
                        if (queryParam.treefilters) {
                            queryParam.treefilters = "1=1";
                        }
                        $("#dg").treegrid("load", queryParam);
                    }
                    else {
                        var queryParam = $("#dg").datagrid("options").queryParams;
                        queryParam.filters = filters;
                        if (queryParam.treefilters) {
                            queryParam.treefilters = "1=1";
                        }
                        $("#dg").datagrid("load", queryParam);
                    }
                    $.messager.progress("close");
                }
                if (ChartInfo.isShow == true) {
                    FormList.GetChart();
                }

            },
            OpenWindow: function (url, iWidth, iHeight, title) {
                var islogin = FormList.IsLogin();
                if (islogin) {
                    /*iWidth = iWidth.indexOf("px") > -1 ? iWidth.substr(0, iWidth.length - 2) : iWidth;
                    iHeight = iHeight.indexOf("px") > -1 ? iHeight.substr(0, iHeight.length - 2) : iHeight;
                    var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
                    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
                    var win = window.open(url, "", "width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
                    */
                    $("#divFormBill").show();
                    try {
                        window.parent.formOpen(getQueryString("MenuID"));
                    }
                    catch (e) {

                    }
                    if (iWidth == "-1" || iHeight == "-1") {
                        $("#divFormBill").window({
                            //top: 10,
                            //left:10,
                            //                            openAnimation: 'show',
                            //                            openDuration:500,
                            title: title,
                            noheader: true,
                            border: false,
                            maximizable: true,
                            minimizable: false,
                            collapsible: false,
                            closable: true,
                            //closed: true,
                            zIndex: 9999999,
                            modal: true,
                            maximized: true,
                            width: 1000,
                            height: 600,
                            content: "<iframe id='ifrBill' width='100%' height='100%' src=\"" + url + "\" frameborder='0'></iframe>"
                        });
                        setTimeout("$('#divFormBill').window('maximize');", 1000);
                    }
                    else {
                        $("#divFormBill").window({
                            //top: 10,
                            //left: 10,
                            //                            openAnimation: 'show',
                            //                            openDuration: 500,
                            title: title,
                            noheader: true,
                            border: false,
                            maximizable: true,
                            minimizable: false,
                            collapsible: false,
                            closable: true,
                            //closed: true,
                            zIndex: 9999999,
                            modal: true,
                            width: iWidth,
                            height: iHeight,
                            content: "<iframe id='ifrBill' width='100%' height='100%' src=\"" + url + "\" frameborder='0'></iframe>"
                        });
                        setTimeout("$('#divFormBill').window('resize',{width:" + iWidth + ",height:" + iHeight + "});", 1000);
                    }
                }
            },
            IsLogin: function () {
                var islogin = false;
                $.ajax({
                    url: "/ashx/LoginHandler.ashx",
                    data: { otype: "islogin", r: Math.random() },
                    async: false,
                    cache: false,
                    success: function (data) {
                        if (data != "1") {
                            $("#divlogin").window("open");
                            islogin = false;
                        }
                        else {
                            islogin = true;
                        }
                    },
                    error: function () {
                        islogin = false;
                    }
                });
                return islogin;
            },
            ReLogin: function () {
                var userid = document.getElementById("txbReLoginUserID").value;
                var psd = document.getElementById("txbReLoginPsd").value;
                if (userid.length == 0) {
                    MessageShow("不能为空", "用户名不能为空！");
                    return false;
                }
                $.ajax(
                    {
                        url: "/ashx/LoginHandler.ashx",
                        async: false,
                        success: function (data) {
                            if (data.indexOf("warn") > -1 || data.indexOf("error") > -1) {
                                MessageShow("错误", data);
                                return false;
                            }
                            else {
                                $("#divlogin").window("close");
                            }
                        }
                    });
            },
            AddPrintRow: function (pbname, irecno, reportType, iDataSourceFromList) {
                var tab = document.getElementById("tabPrint");
                var tr = $("<tr></tr>");
                $(tab).append(tr);
                $(tr).append("<td>" + pbname + "</td>");
                $(tr).append("<td style='width:60px;'><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'print','" + reportType + "'," + iDataSourceFromList + ")>直接打印</a></td>");
                $(tr).append("<td style='width:30px;'><a href='#' style='width:50px;' onclick=FormList.PrintClick(this," + irecno + ",'show','" + reportType + "'," + iDataSourceFromList + ")>预览</a></td>");
                if (userid.toLowerCase() == "master") {
                    $(tr).append("<td style='width:30px;'><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'design','" + reportType + "'," + iDataSourceFromList + ")>设计</a></td>");
                }
            },
            PrintClick: function (obj, irecno, otype, reportType, iDataSourceFromList, sParm, sLinkField) {
                var selectedkey = FormList.GetSelectedKeys();
                if (selectedkey.length == 0) {
                    MessageShow('未选择数据', '未选择任务行！');
                    obj.href = "#";
                    obj.target = "";
                    return;
                }
                else {
                    if (reportType != "stimulsoftreport") {
                        var fileName = "";
                        if (iDataSourceFromList == "1") {
                            $.messager.progress({ title: "正在准备打印数据，请稍等..." });
                            var data = $("#dg").datagrid("getData");
                            var url = '/Base/Handler/DataGridToJson.ashx'; //如果为asp注意修改后缀
                            $.ajax({
                                url: url,
                                data: { data: JSON2.stringify(data.rows), title: getQueryString('FormID'), pbRecNo: irecno },
                                type: 'POST',
                                dataType: 'text',
                                async: false,
                                success: function (fn) {
                                    //filters = filters == "" ? "" : "&" + filters;
                                    //var fileName = fn;
                                    if (fn && fn != "") {
                                        fileName = fn.substr(0, fn.lastIndexOf("."));
                                    }
                                    $.messager.progress("close");
                                },
                                error: function (xhr) {
                                    alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                                    $.messager.progress("close");
                                }
                            });
                        }

                        obj.target = "ifrpb";
                        var urlParams = "";
                        var conditionParams = {};
                        var formData = $("#form1").form("getData", true);
                        for (var key in formData) {
                            var fieldid = key.substr(0, key.indexOf('`'));
                            var element;
                            try {
                                element = $("[FieldID='" + fieldid + "']");
                            }
                            catch (e) { }
                            $(element).each(function (index, ele) {
                                if ($(ele).attr("fname") == key) {
                                    var plugin = $(ele).attr("plugin");
                                    var lookupOption = $(ele).attr("lookupOptions");
                                    var value = "";
                                    switch (plugin) {
                                        case "textbox": {
                                            value = $(ele).textbox("getValue");
                                            if (lookupOption) {
                                                value = $("#" + ele.id + "_val").val();
                                            }
                                        } break;
                                        case "combobox": value = $(ele).combobox("getValue"); break;
                                        case "combotree": value = $(ele).combotree("getValue"); break;
                                        case "datebox": value = $(ele).datebox("getValue"); break;
                                        case "datetimebox": value = $(ele).datetimebox("getValue"); break;
                                        case "numberspinner": value = $(ele).numberspinner("getValue"); break;
                                    }
                                    if (element[0].type == "checkbox") {
                                        value = element[0].checked == true ? 1 : 0;
                                    }
                                    var conditionID = $(ele).attr("conditionID");
                                    if (conditionID == undefined) {
                                        urlParams += "pb_" + key + "=" + encodeURI(value) + "&";
                                        conditionParams["pb_" + key] = value;
                                    }
                                }
                            })
                        }
                        if (urlParams.length > 0) {
                            urlParams = urlParams.substr(0, urlParams.length - 1);
                        }
                        var filters = getQueryString("filters");
                        var fixFilters = getQueryString("fixFilters");
                        if (fixFilters != null) {
                            filters = filters == null ? fixFilters : filters + " and (" + fixFilters + ")";
                        }
                        var nofixFilters = getQueryString("nofixFilters");
                        if (nofixFilters != null) {
                            filters = filters == null ? nofixFilters : filters + " and (" + nofixFilters + ")";
                        }
                        filters = filters == null ? "" : "filters=" + filters;
                        //obj.href = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys() + "&" + urlParams + "&" + filters + "";&printer=HP%20LaserJet%20Professional%20M1213nf%20MFP   &printer=FX%20DocuPrint%20CP105%20b
                        var url = "";
                        var urlKeys = "";
                        if (sParm == undefined || sParm == null) {
                            urlKeys = FormList.GetSelectedKeys();
                        }
                        else {
                            var selectedRows = $("#dg").datagrid("getSelections");
                            for (var i = 0; i < selectedRows.length; i++) {
                                urlKeys += selectedRows[i][sParm] + ",";
                            }
                            if (urlKeys.length > 0) {
                                urlKeys = urlKeys.substr(0, urlKeys.length - 1);
                            }
                        }
                        if (reportType == "fastreport") {
                            url = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + urlKeys + "&" + urlParams + "&FormListFileName=" + fileName + "&" + filters;
                            obj.href = url;
                        }
                        else if (reportType == "lodop") {
                            //$.messager.progress({ title: "正在准备打印数据", msg: "正在准备打印数据..." });
                            //isPrintLoading = true;
                            var iFormIDLink, iRecNoLink;
                            if (sLinkField) {
                                iRecNoLink = sLinkField.split(',')[0];
                                iFormIDLink = sLinkField.split(',')[1];
                            }

                            var title = $(obj).parent().parent().children("td:first-child").html();
                            if (otype == "design") {
                                //var linkParam = iFormIDLink ? "&iFormIDLink=" + iFormIDLink + "&iRecNoLink=" + iRecNoLink : "";
                                if (iFormIDLink) {
                                    MessageShow("使用其他表单打印报表只能到源报表上设计", "使用其他表单打印报表只能到源报表上设计");
                                    return;
                                }
                                url = "/Base/PbLodop.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + urlKeys + "&" + urlParams + "&FormListFileName=" + fileName + "&" + filters + "&title=" + escape(title) + "";
                                window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                            }
                            else {
                                //url = "/Base/PbLodopViewAndPrint.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys() + "&" + urlParams + "&FormListFileName=" + fileName + "&" + filters + "&title=" + escape(title) + "&returnFn=ClosePrintLoad";
                                //window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                                //obj.href = url;
                                if (otype == "show") {
                                    hxLodop.preview(getQueryString("FormID"), urlKeys, irecno, filters, conditionParams, fileName, 1, iFormIDLink, iRecNoLink);
                                }
                                if (otype == "print") {
                                    hxLodop.print(getQueryString("FormID"), urlKeys, irecno, filters, conditionParams, fileName, 1, iFormIDLink, iRecNoLink);
                                }
                            }
                        }
                    }
                    else {
                        var formData = $("#form1").form("getData", true);
                        var urlParams = {};
                        for (var key in formData) {
                            var fieldid = key.substr(0, key.indexOf('`'));
                            var element;
                            try {
                                element = $("[FieldID='" + fieldid + "']");
                            }
                            catch (e) { }
                            $(element).each(function (index, ele) {
                                if ($(ele).attr("fname") == key) {
                                    var plugin = $(ele).attr("plugin");
                                    var lookupOption = $(ele).attr("lookupOptions");
                                    var value = "";
                                    switch (plugin) {
                                        case "textbox": {
                                            value = $(ele).textbox("getValue");
                                            if (lookupOption) {
                                                value = $("#" + ele.id + "_val").val();
                                            }
                                        } break;
                                        case "combobox": value = $(ele).combobox("getValue"); break;
                                        case "combotree": value = $(ele).combotree("getValue"); break;
                                        case "datebox": value = $(ele).datebox("getValue"); break;
                                        case "datetimebox": value = $(ele).datetimebox("getValue"); break;
                                        case "numberspinner": value = $(ele).numberspinner("getValue"); break;
                                    }
                                    if (element[0].type == "checkbox") {
                                        value = element[0].checked == true ? 1 : 0;
                                    }
                                    var conditionID = $(ele).attr("conditionID");
                                    if (conditionID == undefined) {
                                        urlParams[("pb_" + key)] = value;
                                    }
                                }
                            })
                        }
                        var filters = getQueryString("filters");
                        var fixFilters = getQueryString("fixFilters");
                        if (fixFilters != null) {
                            filters = filters == null ? fixFilters : filters + " and (" + fixFilters + ")";
                        }
                        var nofixFilters = getQueryString("nofixFilters");
                        if (nofixFilters != null) {
                            filters = filters == null ? nofixFilters : filters + " and (" + nofixFilters + ")";
                        }
                        //                        showViewer参数:
                        //                        isNewWindow：是否在新页面中显示
                        //                        reportRecNo：报表主键
                        //                        reportFormID:报表表单号
                        //                        billRecNo:表单主键
                        //                        conditions:查询条件
                        //                        filters:过滤条件
                        //                        dataSourceExtra:额外的数据源,json格式或json字符串，数据结构:{data1:[{}],data2:[]}
                        //                        divContent:目录div的ID

                        if (otype == "show") {
                            hxStimulsoftReport.showViewer(true, irecno, getQueryString("FormID"), FormList.GetSelectedKeys(), urlParams, filters, $("#dg").datagrid("getRows"));
                        }
                        else if (otype == "design") {
                            hxStimulsoftReport.showDesinger(true, irecno, getQueryString("FormID"), FormList.GetSelectedKeys(), urlParams, filters, $("#dg").datagrid("getRows"));
                        }
                        else {
                            hxStimulsoftReport.print(irecno, getQueryString("FormID"), FormList.GetSelectedKeys(), urlParams, filters);
                        }
                    }
                    $("#btnPrint").tooltip("hide");
                    //}
                }
            },
            //            Export: function () {
            //                var filterstr = "1=1";
            //                if (isQuery != true) {
            //                    var options = $("#dg").datagrid("options");
            //                    if (options.queryParams.filters) {
            //                        filterstr += " and " + options.queryParams.filters;
            //                    }
            //                }
            //                else {
            //                    filterstr = QueryFilters;
            //                }
            //                var url = "/Base/ExcelExport.aspx?formid=" + getQueryString("FormID") + "&filterstr=" + encodeURI(encodeURI(filterstr)) + "&hasDynColumn=" + (isModify == true ? 1 : 0) + "&dynValue=" + dynConditionValue + "&random=" + Math.random();
            //                window.open(url, "", "height=100, width=400, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
            //            },
            AddAssociatedRow: function (id, formid, aname, parmvalue, filepath, icon) {
                var tab = document.getElementById("tabAssociated");
                var tr = $("<tr></tr>");
                $(tab).append(tr);
                $(tr).append("<td><a href='#'; onclick=FormList.AssociatedClick(\"" + id + "\",\"" + formid + "\",\"" + aname + "\",\"" + encodeURIComponent(parmvalue) + "\",\"" + filepath + "\",\"" + icon + "\")>" + aname + "</a></td>");
            },
            AssociatedClick: function (id, formid, name, parmvalue, filepath, icon) {
                var selectedRow = $("#dg").datagrid("getSelections");
                parmvalue = decodeURIComponent(parmvalue);
                parmvalue = parmvalue == "" ? "1=1" : parmvalue;
                while (parmvalue.indexOf("{") > -1) {
                    if (selectedRow.length > 0) {
                        var indexs = parmvalue.indexOf("{");
                        var indexe = parmvalue.indexOf("}");
                        var fieldname = parmvalue.substr(indexs + 1, indexe - indexs - 1);
                        var fieldvalue = selectedRow[0][fieldname];
                        if (fieldvalue == undefined || fieldvalue == null) {
                            MessageShow("不存在的参数", "对不起，不存在参数：{" + fieldname + "}");
                            return false;
                        }
                    }
                    else {
                        MessageShow("请选择数据", "亲，请选择一条数据");
                        return false;
                    }
                    parmvalue = parmvalue.replace("{" + fieldname + "}", selectedRow[0][fieldname]);
                }
                parent.turntoTab(id, formid, name, parmvalue, filepath, icon, true);
            },
            ShowFj: function (iformid, tablename, obj) {
                var irecno = obj.id;
                $("#divFj").css("display", "");
                $("#ifrFj").attr("src", "/Base/FileUpload/FileUpload.aspx?usetype=view&iformid=" + iformid + "&tablename=" + tablename + "&irecno=" + irecno + "&fileType=acc&random=" + Math.random());
                $("#divFj").window(
                    {
                        width: 600,
                        height: 300,
                        minimizable: false,
                        maximizable: false,
                        collapsible: false,
                        modal: true,
                        top: 100,
                        title: "附件列表"
                    });
            },
            BeforeSave: undefined,
            BeforeEdit: undefined,
            DynCdnSelect: function (newValue) {
                var rowspan = 1;
                if (isMultiColumn == true) {
                    rowspan = 2;
                }
                var options = $("#dg").datagrid("options");
                options.columns = DeepCopy(originalDataGridColumns);
                options.frozenColumns = DeepCopy(originalDataGridFrozenColumns);
                //options.columns = originalDataGridColumns.concat();
                var queryParm = options.queryParams;
                var conditionGUID = $("#" + this.id).attr("conditionID");
                //queryParm.dynCndnValue = record[(dynField)];
                queryParm.dynCndnValue = newValue;
                queryParm.conditionGUID = conditionGUID;
                options.queryParams = queryParm;
                //dynColumns = [];
                var hasError = false;
                $.ajax(
                    {
                        url: "/Base/Handler/FormListHandler.ashx",
                        data: { otype: "GetDynColumns", formid: getQueryString("FormID"), conditionGUID: $("#" + this.id).attr("conditionID"), conditionValue: newValue },
                        async: false,
                        cache: false,
                        type: "POST",
                        success: function (data) {
                            var resultObj = JSON2.parse(data);
                            if (resultObj.success == true) {
                                for (var i = 0; i < dynColumns.length; i++) {
                                    for (var o in dynColumns[0]) {
                                        fieldColumn = o;
                                        break;
                                    }
                                    for (var j = 0; j < options.columns[0].length; j++) {
                                        if (options.columns[0][j].field == dynColumns[i][(fieldColumn)]) {
                                            options.columns[0].splice(j, 1);
                                            j--;
                                            break;
                                        }
                                    }
                                }
                                //从汇总列中删除，并记录合计类型
                                var sumType = "";
                                for (var i = 0; i < dynColumns.length; i++) {
                                    for (var j = 0; j < summaryFields.length; j++) {
                                        if (dynColumns[i][(fieldColumn)] == summaryFields[j].Field) {
                                            sumType = summaryFields[j].Type;
                                            summaryFields.splice(j, 1);
                                            break;
                                        }
                                    }
                                }
                                dynColumns = resultObj.tables[0];
                                for (var o in dynColumns[0]) {
                                    fieldColumn = o;
                                    break;
                                }
                                for (var i = 0; i < dynColumns.length; i++) {
                                    summaryFields.push({ Type: sumType, Field: dynColumns[i][(fieldColumn)], iDigit: 0 });
                                }
                            }
                            else {
                                MessageShow(resultObj.message, resultObj.message);
                                return;
                            }
                        },
                        error: function () {
                            MessageShow("获取动态列失败", "获取动态列失败");
                            hasError = true;
                            return;
                        }
                    }
                );
                if (hasError == false) {
                    $("#dg").datagrid("loadData", []);
                    if (dynColumns.length > 0) {
                        var fieldColumn = "";
                        for (var o in dynColumns[0]) {
                            fieldColumn = o;
                            break;
                        }

                        if (dynColumnIndex == undefined) {
                            for (var i = 0; i < dynColumns.length; i++) {
                                if (options.columns.length > 0) {
                                    options.columns[0].push({
                                        field: dynColumns[i][(fieldColumn)],
                                        title: dynColumns[i][(fieldColumn)],
                                        width: 50,
                                        align: 'center',
                                        halign: 'center',
                                        rowspan: rowspan
                                    });
                                }
                            }
                        }
                        else {
                            //var dynColumnNews = [];
                            for (var i = dynColumns.length - 1; i >= 0; i--) {
                                var columnNew = {
                                    field: dynColumns[i][(fieldColumn)],
                                    title: dynColumns[i][(fieldColumn)],
                                    width: 50,
                                    align: 'center',
                                    halign: 'center',
                                    rowspan: rowspan
                                }
                                options.columns[0].splice(dynColumnIndex, 0, columnNew);
                                //dynColumnNews.push(columnNew);
                            }
                        }
                        originalDataGridColumns = DeepCopy(options.columns);
                        $("#dg").datagrid(options);
                        if (isQuery == true) {
                            dynConditionGUID = conditionGUID;
                            dynConditionValue = newValue;
                            //FormList.BtnSearch();
                        }
                    }
                    else {
                        MessageShow("没有对应的动态列！", "没有对应的动态列！");
                    }
                }
            },
            CalcFootData: function (data, field, otype, iDigit) {
                var result = 0;
                if (iDigit == undefined || iDigit == null) {
                    iDigit = 2;
                }
                switch (otype) {
                    case "sum":
                        {
                            for (var i = 0; i < data.length; i++) {
                                result += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                            }
                            result = result.toFixed(parseInt(iDigit));
                        } break;
                    case "avg":
                        {
                            var total = 0;
                            for (var i = 0; i < data.length; i++) {
                                total += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                            }
                            result = total / data.length;
                            result = result.toFixed(parseInt(iDigit));
                        } break;
                    case "count": result = data.length; break;
                    case "max":
                        {
                            if (data.length == 0) {
                                result = 0;
                            }
                            else {
                                result = isNaN(parseFloat(data[0][(field)])) ? 0 : parseFloat(data[0][(field)]);
                            }
                            for (var i = 0; i < data.length; i++) {
                                var value = isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                                if (result < value) {
                                    result = value;
                                }
                            }
                        } break;
                    case "min":
                        {
                            if (data.length == 0) {
                                result = 0;
                            }
                            else {
                                result = isNaN(parseFloat(data[0][(field)])) ? 0 : parseFloat(data[0][(field)]);
                            }
                            for (var i = 0; i < data.length; i++) {
                                var value = isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                                if (result > value) {
                                    result = value;
                                }
                            }
                        } break;
                }
                return result;
            },
            GetFootData: function (objArr) {
                var allData = [];
                var data = $('#dg').datagrid('getData').originalRows ? $('#dg').datagrid('getData').originalRows : $('#dg').datagrid('getData').rows;
                //1、求和
                var sumData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "sum") {
                        if (sumData == undefined) {
                            sumData = {};
                        }
                        sumData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "sum", objArr[i].iDigit);
                    }
                }
                if (sumData != undefined) {
                    sumData.__isFoot = true;
                    sumData.__type = "sum";
                    allData.push(sumData);

                }
                //2、求平均值
                var avgData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "avg") {
                        if (avgData == undefined) {
                            avgData = {};
                        }
                        avgData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "avg", objArr[i].iDigit);
                    }
                }
                if (avgData != undefined) {
                    avgData.__isFoot = true;
                    sumData.__type = "avg";
                    allData.push(avgData);
                }
                //3、求个数
                var countData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "count") {
                        if (countData == undefined) {
                            countData = {};
                        }
                        countData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "count");
                    }
                }
                if (countData != undefined) {
                    countData.__isFoot = true;
                    sumData.__type = "count";
                    allData.push(countData);
                }
                //4、求最大值
                var maxData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "max") {
                        if (maxData == undefined) {
                            maxData = {};
                        }
                        maxData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "max");
                    }
                }
                if (maxData != undefined) {
                    maxData.__isFoot = true;
                    sumData.__type = "max";
                    allData.push(maxData);
                }
                //5、求最小值
                var minData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "min") {
                        if (minData == undefined) {
                            minData = {};
                        }
                        minData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "min");
                    }
                }
                if (minData != undefined) {
                    minData.__isFoot = true;
                    sumData.__type = "min";
                    allData.push(minData);
                }
                if (allData.length > 0) {

                }
                return allData;
            },
            NeedSelectedKey: undefined,
            SelectRow: function (key) {
                var rows = $("#dg").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i][(PK)] == key) {
                        $("#dg").datagrid("selectRow", i);
                        break;
                    }
                }
            },
            isChartRendering: false,
            GetChart: function (obj) {
                if (FormList.isChartRendering == true) {
                    return;
                }
                FormList.isChartRendering = true;
                if ($.inArray("line", ChartInfo.type) > -1 || $.inArray("column", ChartInfo.type) > -1) {
                    var radios = $("input[name='chartRadio']");
                    for (var i = 0; i < radios.length; i++) {
                        if (radios[i].checked == true) {
                            ChartInfo.selectedY = radios[i].id;
                            var selectedTitle = $("label[for='" + radios[i].id + "']").html();
                            ChartInfo.selectedYTitle = selectedTitle;
                            break;
                        }
                    }
                }
                else {
                    ChartInfo.selectedY = ChartInfo.Y;
                    ChartInfo.selectedYTitle = ChartInfo.YTitle;
                }
                var chartType = "";
                for (var i = 0; i < ChartInfo.type.length; i++) {
                    chartType += ChartInfo.type[i] + ",";
                }
                if (chartType.length > 0) {
                    chartType = chartType.substr(0, chartType.length - 1);
                }
                var isZoomIn = obj ? obj.id[obj.id.length - 1] == "1" ? "1" : "0" : "0";
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    type: "post",
                    async: true,
                    cache: false,
                    data: { otype: "FormListChart", formid: getQueryString("FormID"), data: JSON2.stringify(ChartInfo.data), X: ChartInfo.X, XTitle: ChartInfo.XTitle, Y: ChartInfo.selectedY, YTitle: ChartInfo.selectedYTitle, type: chartType, S: ChartInfo.S, STitle: ChartInfo.STitle, isZoomIn: isZoomIn },
                    success: function (data) {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            new Function(resultObj.message)();
                        }
                        else {
                            MessageShow("生成图表失败", resultObj.message);
                        }
                        FormList.isChartRendering = false;
                    },
                    error: function (data) {
                        FormList.isChartRendering = false;
                    }
                });
            },
            parseLookupField: function (str) {
                var formData = $("#form1").form("getData", true);
                for (var o in formData) {
                    var fieldid = o.substr(0, o.indexOf("`"));
                    formData[(fieldid)] = formData[(o)];
                }
                while (str.indexOf("{") > -1) {
                    var start = str.indexOf("{");
                    var end = str.indexOf("}");
                    if (end > -1) {
                        var field = str.substr(start + 1, end - start - 1);

                        str = str.replace("{" + field + "}", formData[(field)]);
                    }
                    else {
                        break;
                    }
                }
                return str;
            },
            Export: function () {//导出Excel文件
                var doExport = function (data) {
                    //getExcelXML有一个JSON对象的配置，配置项看了下只有title配置，为excel文档的标题
                    //var data = $('#dg').datagrid('getExcelXml', { title: 'Sheet1' }); //获取datagrid数据对应的excel需要的xml格式的内容
                    //用ajax发动到动态页动态写入xls文件中
                    var url = '/Base/Handler/DataGridToExcel.ashx'; //如果为asp注意修改后缀
                    $.ajax({
                        url: url, data: { data: data, title: getQueryString('MenuTitle') }, type: 'POST', dataType: 'text',
                        success: function (fn) {
                            //alert('导出excel成功！');
                            //window.location = fn; //执行下载操作
                            $("#ifrpb").attr("src", fn);
                            SysOpreateAddLog("导出", getQueryString("FormID"), "", getQueryString('MenuTitle'));
                            $.messager.progress("close");
                        },
                        error: function (xhr) {
                            alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                            $.messager.progress("close");
                        }
                    });
                    return false;
                }
                $.messager.progress({ title: "正在准备导出数据，请稍等..." });
                var data;
                if (isQuery == false) {
                    //var tabEx = $("#dg1");
                    /*if (tabEx.length == 0) {
                        $("body").append("<div id='divEx' style='display:none;' ><table id='dg1'></table></div>");
                    }*/
                    var options = $("#dg").datagrid("options");
                    var optionsNew = deepClone(options);
                    optionsNew.pageSize = 100000;
                    optionsNew.pageList = [100000, 200000, 300000];
                    optionsNew.fit = false;
                    optionsNew.toolbar = null;
                    //var oldFn = options.onLoadSuccess;
                    optionsNew.onLoadSuccess = function (data) {
                        FormList.GetFormFootData('dg1', false);
                        data1 = $('#dg1').datagrid('getExcelXml', { title: 'Sheet1' });
                        doExport(data1);
                    }
                    $("#dg1").datagrid(optionsNew);
                    //alert($("#dg").datagrid("options").pageSize);
                }
                else {
                    data = $('#dg').datagrid('getExcelXml', { title: 'Sheet1' }); //获取datagrid数据对应的excel需要的xml格式的内容
                    doExport(data);
                }

                //                }
            },
            //获取今天日期：格式2015-01-01
            getNowDate: function () {
                var nowdate = new Date();
                var year = nowdate.getFullYear();
                var month = nowdate.getMonth();
                var date = nowdate.getDate();
                var monthstr = (month + 1).toString();
                var datestr = date.toString();
                if (month < 9) {
                    monthstr = '0' + (month + 1).toString();
                }
                if (date < 10) {
                    datestr = '0' + date.toString();
                }
                return year.toString() + "-" + monthstr + "-" + datestr;
            },
            //获取当前时时
            getNowTime: function () {
                var nowdate = new Date();
                var hour = nowdate.getHours();      //获取当前小时数(0-23)
                var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
                var second = nowdate.getSeconds();
                return hour + ":" + minute + ":" + second;
            },
            //放大
            ZoomIn: function () {
                $("#divChartZoomIn").window("open");
                var chartType = "";
                for (var i = 0; i < ChartInfo.type.length; i++) {
                    chartType += ChartInfo.type[i] + ",";
                }
                if (chartType.length > 0) {
                    chartType = chartType.substr(0, chartType.length - 1);
                }
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    type: "post",
                    async: true,
                    cache: false,
                    data: { otype: "FormListChart", formid: getQueryString("FormID"), data: JSON2.stringify(ChartInfo.data), XTitle: ChartInfo.XTitle, Y: ChartInfo.selectedY, YTitle: ChartInfo.selectedYTitle, type: chartType, STitle: ChartInfo.STitle, isZoomIn: 1 },
                    success: function (data) {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            new Function(resultObj.message)();
                        }
                        else {
                            MessageShow("生成图表失败", resultObj.message);
                        }
                        //FormList.isChartRendering = false;
                    },
                    error: function (data) {
                        //FormList.isChartRendering = false;
                    }
                });
            },
            groupFieldCheck: function (obj) {
                if (sGroupFieldsClass != "") {
                    var isFound = false;
                    var theField = $(obj).attr("fieldidg");
                    var classFields = sGroupFieldsClass.split(";");
                    for (var i = 0; i < classFields.length; i++) {
                        var theClass = classFields[i];
                        var theClassArr = theClass.split(",");
                        for (var j = 0; j < theClassArr.length; j++) {
                            if (theField == theClassArr[j]) {
                                isFound = true;
                                for (var k = 0; k < theClassArr.length; k++) {
                                    if (theField != theClassArr[k]) {
                                        $("[fieldidg='" + theClassArr[k] + "']").prop("checked", obj.checked);
                                    }
                                }
                                break;
                            }
                        }
                        if (isFound == true) {
                            break;
                        }
                    }
                }
            },
            loadAcrossField: function (sFixFields, sDefaultFixFields, sTransverseField) {
                var fields = $("#dg").datagrid('getColumnFields', true).concat($("#dg").datagrid('getColumnFields'));
                var fieldArr = [];
                var columns = $("#dg").datagrid("options").columns;
                var columnFields = [];
                if (columns.length == 1) {
                    columnFields = columns[0];
                }
                else {
                    columnFields = columns[1];
                }
                $.each(fields, function (index, o) {
                    var theField = {};
                    for (var i = 0; i < columnFields.length; i++) {
                        if (columnFields[i].field == o && columnFields[i].hidden != true) {
                            theField.text = columnFields[i].title;
                        }
                    }
                    theField.value = o;
                    fieldArr.push(theField);
                })

                var FixFieldsArr = [];
                if (sFixFields && sFixFields != "") {
                    var sFixFieldsStrArr = sFixFields.split(",");
                    $.each(sFixFieldsStrArr, function (index, o) {
                        $.each(fieldArr, function (index1, o1) {
                            if (o == o1.value) {
                                FixFieldsArr.push(o1);
                                return false;
                            }
                        })
                    })
                }
                $.each(FixFieldsArr, function (index, o) {
                    var checkedStr = "";
                    if (("," + sDefaultFixFields + ",").indexOf("," + o.value + ",") > -1) {
                        checkedStr = "checked='checked'";
                    }
                    var tr = $("<tr><td><input id='fixField" + index + "' name='fixField' type='checkbox' " + checkedStr + " value='" + o.value + "'/><label for='fixField" + index + "'>" + o.text + "</label></td></tr>");
                    $("#tabFixFields").append(tr);
                })


                var TransverseFieldArr = [];
                if (sTransverseField && sTransverseField != "") {
                    var sTransverseFieldArr = sTransverseField.split(",");
                    $.each(sTransverseFieldArr, function (index, o) {
                        $.each(fieldArr, function (index1, o1) {
                            if (o == o1.value) {
                                TransverseFieldArr.push(o1);
                                return false;
                            }
                        })
                    })
                }
                $.each(TransverseFieldArr, function (index, o) {
                    var checkedStr = index == 0 ? "checked='checked'" : "";
                    var tr = $("<tr><td><input id='transverseField" + index + "' type='radio' " + checkedStr + " name='transverseField' value='" + o.value + "'/><label for='transverseField" + index + "'>" + o.text + "</label></td></tr>");
                    $("#tabCrossFields").append(tr);
                })

                var valueFieldArr = [];
                $.each(columnFields, function (index, o) {
                    if (o.datatype == "number") {
                        var fieldRow = { value: o.field, text: o.title }
                        valueFieldArr.push(fieldRow);
                    }
                })
                $.each(valueFieldArr, function (index, o) {
                    var tr = $("<tr><td><input id='valueField" + index + "' name='valueField' type='checkbox' checked='checked' value='" + o.value + "'/><label for='valueField" + index + "'>" + o.text + "</label></td><td><select id='selValueField" + index + "' name='selValueField'><option value='sum'>合计</option><option value='avg'>平均值</option><option value='max'>最大值</option><option value='min'>最小值</option><option value='count'>个数</option></select></td></tr>");
                    $("#tabValueField").append(tr);
                })
            },
            BtnSummary: function () {
                //var fixFields = $("#txbAcrossQueryFixedField").combobox("getValues");
                //var rowField = $("#txbAcrossQueryRowField").combobox("getValue");
                //var valueFields = $("#txbAcrossQueryValueField").combobox("getValues");
                var fixFields = [];
                var fixFieldElements = $("input[name='fixField']");
                $.each(fixFieldElements, function (index, o) {
                    if (o.checked == true) {
                        fixFields.push(o.value);
                    }
                });
                var rowField = "";
                var rowFieldElement = $("input[name='transverseField']");
                $.each(rowFieldElement, function (index, o) {
                    if (o.checked == true) {
                        rowField = o.value;
                        return false;
                    }
                });
                var valueFields = [];
                var valueFieldElement = $("input[name='valueField']");
                $.each(valueFieldElement, function (index, o) {
                    if (o.checked == true) {
                        valueFields.push(o.value);
                    }
                });

                if (fixFields.length == 0) {
                    MessageShow("固定列不能为空", "固定列不能为空");
                    return;
                }
                if (rowField == "" || rowField == null || rowField == undefined) {
                    MessageShow("横排列不能为空", "横排列不能为空");
                    return;
                }
                if (valueFields.length == 0) {
                    MessageShow("值列不能为空", "值列不能为空");
                    return;
                }
                if ($.inArray(rowField, fixFields) > -1) {
                    MessageShow("固定列不能包含横排列", "固定列不能包含横排列");
                    return;
                }
                //if (fixFields == valueFields) {
                //    MessageShow("固定列不能和值列相同", "固定列不能和值列相同");
                //    return;
                //}
                //if (rowField == valueFields) {
                //    MessageShow("横排列不能和值列相同", "横排列不能和值列相同");
                //    return;
                //}
                if ($.inArray(rowField, valueFields) > -1) {
                    MessageShow("值列不能包含横排列", "值列不能包含横排列");
                    return;
                }
                var canContinue = true;
                $.each(fixFields, function (index, o) {
                    if ($.inArray(o, valueFields) > -1) {
                        MessageShow("值列不能包含固定列", "值列不能包含固定列");
                        canContinue = false;
                    }
                })
                var canContinue1 = true;
                if (canContinue) {
                    $.each(valueFields, function (index, o) {
                        if ($.inArray(o, fixFields) > -1) {
                            MessageShow("固定列不能包含值列", "固定列不能包含值列");
                            canContinue1 = false;
                        }
                    })
                }
                else {
                    return;
                }
                if (canContinue1 == false) {
                    return;
                }


                var allData = undefined;
                //if (originalDataGridData == undefined) {
                //    var dgData = $("#dg").datagrid("getData");
                //    originalDataGridData = DeepCopy(dgData.rows);
                //}
                if (originalDataGridData && originalDataGridData.length > 0) {
                    allData = DeepCopy(originalDataGridData);
                }
                else {
                    MessageShow("数据源不存在", "数据源不存在，请先查询数据再统计");
                    return;
                }

                //获取原始列属性
                var getOriginalColumn = function (field) {
                    var theOriginalColumn = undefined;
                    if (originalDataGridColumns.length == 1) {
                        for (var i = 0; i < originalDataGridColumns[0].length; i++) {
                            if (field == originalDataGridColumns[0][i].field) {
                                theOriginalColumn = originalDataGridColumns[0][i];
                                break;
                            }
                        }
                    }
                    else {
                        for (var i = 0; i < originalDataGridColumns.length; i++) {
                            for (var j = 0; j < originalDataGridColumns[i].length; j++) {
                                if (originalDataGridColumns[i][j].hasOwnProperty("field")) {
                                    if (field == originalDataGridColumns[i][j].field) {
                                        theOriginalColumn = originalDataGridColumns[i][j];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (theOriginalColumn == undefined) {
                        if (originalDataGridFrozenColumns.length == 1) {
                            for (var i = 0; i < originalDataGridFrozenColumns[0].length; i++) {
                                if (field == originalDataGridFrozenColumns[0][i].field) {
                                    theOriginalColumn = originalDataGridFrozenColumns[0][i];
                                    break;
                                }
                            }
                        }
                        else {
                            for (var i = 0; i < originalDataGridFrozenColumns.length; i++) {
                                for (var j = 0; j < originalDataGridFrozenColumns[i].length; j++) {
                                    if (originalDataGridFrozenColumns[i][j].hasOwnProperty("field")) {
                                        if (field == originalDataGridFrozenColumns[i][j].field) {
                                            theOriginalColumn = originalDataGridFrozenColumns[i][j];
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return theOriginalColumn;
                }


                //根据固定列组织新表数据源
                var newData = [];
                //横排列值
                var rowFieldColumnNameArr = [];

                for (var i = 0; i < allData.length; i++) {
                    //横排列值
                    var rowFieldValue = allData[i][(rowField)];
                    var exists = false;
                    for (var j = 0; j < rowFieldColumnNameArr.length; j++) {
                        if (rowFieldColumnNameArr[j].value == rowFieldValue) {
                            exists = true;
                        }
                    }
                    if (exists == false) {
                        var rowFieldName = "rowField" + rowFieldColumnNameArr.length.toString();
                        rowFieldColumnNameArr.push({ key: rowFieldName, value: rowFieldValue });

                    }


                    var is_exist = false;
                    var row = {};
                    for (var j = 0; j < newData.length; j++) {
                        var isEqu = true;
                        for (var k = 0; k < fixFields.length; k++) {
                            //row[(fixFields[k])] = allData[i][(fixFields[k])];
                            if (allData[i][(fixFields[k])] != newData[j][(fixFields[k])]) {
                                isEqu = false;
                            }
                        }
                        if (isEqu == true) {
                            is_exist = true;
                        }
                    }
                    if (is_exist)
                        continue;//跳过
                    else {
                        for (var k = 0; k < fixFields.length; k++) {
                            row[(fixFields[k])] = allData[i][(fixFields[k])];
                        }

                    }
                    newData.push(row); //添加


                }

                var firstColumn = [];
                var twiceColumn = [];
                for (var i = 0; i < fixFields.length; i++) {
                    //var fixFieldDisplay = $("#txbAcrossQueryFixedField").combobox("getText");
                    //var fixFieldDisplayArr = fixFieldDisplay.split(",");
                    var theOriginalColumn = getOriginalColumn(fixFields[i]);

                    var theNewColumn = deepClone(theOriginalColumn);
                    if (valueFields.length > 1) {
                        theNewColumn.rowspan = 2;
                    }
                    firstColumn.push(theNewColumn);
                }
                //非固定列的列名
                for (var i = 0; i < rowFieldColumnNameArr.length; i++) {
                    //如果多个值列
                    if (valueFields.length > 1) {
                        //先插入第一行的列
                        firstColumn.push({ title: rowFieldColumnNameArr[i].value, colspan: valueFields.length, align: "center" });
                        //再插入第二行的列
                        //第一个要去找原列的选项
                        if (i == 0) {
                            for (var j = 0; j < valueFields.length; j++) {
                                var theOriginalColumn = getOriginalColumn(valueFields[j]);
                                var theNewColumn = deepClone(theOriginalColumn);
                                theNewColumn.rowspan = 1;
                                theNewColumn.colspan = 1;
                                theNewColumn.field = theNewColumn.field + "_" + rowFieldColumnNameArr[i].key;
                                twiceColumn.push(theNewColumn);

                                for (var k = 0; k < summaryFields.length; k++) {
                                    if (summaryFields[k].Field == valueFields[j]) {
                                        var isExistsS = false;
                                        for (var l = 0; l < summaryFields.length; l++) {
                                            if (summaryFields[l].Field == theNewColumn.field) {
                                                isExistsS = true;
                                                break;
                                            }
                                        }
                                        if (isExistsS == false) {
                                            summaryFields.push({ Type: summaryFields[k].Type, Field: theNewColumn.field, iDigit: summaryFields[k].iDigit });
                                        }

                                    }
                                }

                            }
                        }
                        else {//复制即可
                            for (var j = 0; j < valueFields.length; j++) {
                                var theNewColumn = deepClone(twiceColumn[j]);
                                theNewColumn.rowspan = 1;
                                theNewColumn.colspan = 1;
                                var fieldo = theNewColumn.field.substr(0, theNewColumn.field.indexOf("_"));
                                theNewColumn.field = fieldo + "_" + rowFieldColumnNameArr[i].key;
                                twiceColumn.push(theNewColumn);

                                for (var k = 0; k < summaryFields.length; k++) {
                                    if (summaryFields[k].Field == valueFields[j]) {
                                        var isExistsS = false;
                                        for (var l = 0; l < summaryFields.length; l++) {
                                            if (summaryFields[l].Field == fieldo + "_" + rowFieldColumnNameArr[i].key) {
                                                isExistsS = true;
                                                break;
                                            }
                                        }
                                        if (isExistsS == false) {
                                            summaryFields.push({ Type: summaryFields[k].Type, Field: fieldo + "_" + rowFieldColumnNameArr[i].key, iDigit: summaryFields[k].iDigit });
                                        }

                                    }
                                }
                            }
                        }
                    }
                    else {
                        var theOriginalColumn = getOriginalColumn(valueFields[0]);
                        var theNewColumn = deepClone(theOriginalColumn);
                        theNewColumn.rowspan = 1;
                        theNewColumn.colspan = 1;
                        theNewColumn.field = theNewColumn.field + "_" + rowFieldColumnNameArr[i].key;
                        theNewColumn.title = rowFieldColumnNameArr[i].value;
                        firstColumn.push(theNewColumn);
                        for (var k = 0; k < summaryFields.length; k++) {
                            if (summaryFields[k].Field == valueFields[0]) {
                                var isExistsS = false;
                                for (var l = 0; l < summaryFields.length; l++) {
                                    if (summaryFields[l].Field == theNewColumn.field + "_" + rowFieldColumnNameArr[i].key) {
                                        isExistsS = true;
                                        break;
                                    }
                                }
                                if (isExistsS == false) {
                                    summaryFields.push({ Type: summaryFields[k].Type, Field: theNewColumn.field + "_" + rowFieldColumnNameArr[i].key, iDigit: summaryFields[k].iDigit });
                                }
                            }
                        }
                    }
                }
                var options = $("#dg").datagrid("options");
                if (valueFields.length > 1) {
                    options.columns = [firstColumn, twiceColumn];
                }
                else {
                    options.columns = [firstColumn];
                }
                $("#dg").datagrid(options);

                //var newData1 = [];
                //var isMerge = $("#ckbAcrossQuerySum")[0].checked;

                var isMerge = true;
                if (isMerge) {
                    for (var i = 0; i < newData.length; i++) {
                        for (var j = 0; j < rowFieldColumnNameArr.length; j++) {
                            //var theKey = "";
                            for (var k = 0; k < valueFields.length; k++) {
                                var selSummaryType = $("select[name='selValueField']")[k];
                                var summaryType = selSummaryType.value;
                                var theKey = valueFields[k];
                                theKey += "_" + rowFieldColumnNameArr[j].key;
                                //满足条件的行数
                                var theValueRowCount = 0;
                                for (var l = 0; l < allData.length; l++) {
                                    var isFixFieldEq = true;
                                    for (var m = 0; m < fixFields.length; m++) {
                                        if (newData[i][(fixFields[m])] != allData[l][(fixFields[m])]) {
                                            isFixFieldEq = false;
                                            break;
                                        }
                                    }
                                    if (isFixFieldEq == true) {
                                        if (allData[l][(rowField)] == rowFieldColumnNameArr[j].value) {
                                            //累加方式
                                            theValueRowCount++;
                                            var theValue = isNaN(allData[l][(valueFields[k])]) ? allData[l][(valueFields[k])] : parseFloat(allData[l][(valueFields[k])]);
                                            if (summaryType == "sum" || summaryType == "avg") {
                                                if (newData[i].hasOwnProperty(theKey)) {
                                                    newData[i][(theKey)] += theValue;
                                                }
                                                else {
                                                    newData[i][(theKey)] = theValue;
                                                }
                                            }
                                            else if (summaryType == "max" || summaryType == "min") {
                                                if (newData[i].hasOwnProperty(theKey)) {
                                                    if (summaryType == "max") {
                                                        newData[i][(theKey)] = newData[i][(theKey)] < theValue ? theValue : newData[i][(theKey)];
                                                    }
                                                    else {
                                                        newData[i][(theKey)] = newData[i][(theKey)] > theValue ? theValue : newData[i][(theKey)];
                                                    }
                                                }
                                                else {
                                                    newData[i][(theKey)] = theValue;
                                                }
                                            }
                                        }
                                    }
                                }
                                if (summaryType == "avg") {
                                    newData[i][(theKey)] = newData[i][(theKey)] / theValueRowCount;
                                }
                                if (summaryType == "count") {
                                    newData[i][(theKey)] = theValueRowCount;
                                }
                            }
                        }
                    }
                }
                else {
                    var newDataFinal = [];
                    for (var i = 0; i < newData.length; i++) {
                        var theDataArr = [];//先把这个固定行的所有原始行取出来放到一个数组里
                        //for (var j = 0; j < rowFieldColumnNameArr.length; j++) {
                        for (var k = 0; k < allData.length; k++) {
                            var isEq = true;
                            for (var l = 0; l < fixFields.length; l++) {
                                if (newData[i][(fixFields[l])] != allData[k][(fixFields[l])]) {
                                    isEq = false;
                                    break;
                                }
                            }
                            if (isEq == true) {
                                var theDataEl = {};
                                for (var l = 0; l < valueFields.length; l++) {
                                    theDataEl[(valueFields[l])] = allData[k][(valueFields[l])];
                                }
                                theDataEl[(rowField)] = allData[k][rowField];
                                theDataArr.push(theDataEl);
                            }
                        }
                        //}
                        //这个固定列的原始行，遍历，赋值一个移出数组一个;遇到有重复属性，不执行任务逻辑，直接跳到下一行
                        while (theDataArr.length > 0) {
                            var theNewDataFinalEl = {};
                            for (var k = 0; k < fixFields.length; k++) {
                                theNewDataFinalEl[(fixFields[k])] = newData[i][(fixFields[k])];
                            }
                            for (var k = 0; k < theDataArr.length; k++) {
                                var isExists = false;
                                var rowFieldValue = theDataArr[k][rowField];
                                var rowFieldName = "";
                                for (var l = 0; l < rowFieldColumnNameArr.length; l++) {
                                    if (rowFieldColumnNameArr[l].value == rowFieldValue) {
                                        rowFieldName = rowFieldColumnNameArr[l].key;
                                        break;
                                    }
                                }
                                //for (var l = 0; l < rowFieldColumnNameArr.length; l++) {
                                for (var m = 0; m < valueFields.length; m++) {
                                    var keyFull = valueFields[m] + "_" + rowFieldName;
                                    if (theNewDataFinalEl.hasOwnProperty(keyFull)) {
                                        isExists = true;
                                        break;
                                    }
                                    else {
                                        theNewDataFinalEl[(keyFull)] = theDataArr[k][valueFields[m]];
                                    }
                                }
                                if (isExists == false) {
                                    theDataArr.splice(k, 1);
                                    k--;
                                }
                            }
                            newDataFinal.push(theNewDataFinalEl);
                        }
                    }
                    newData = newDataFinal;
                }
                isAcrossSummry = true;
                //$("#dg").datagrid("loadData", "[]");

                $("#dg").datagrid("loadData", newData);

            },
            BuildPrintList: function () {
                if (pbReportArr.length > 0) {
                    var sGroupArr = [];
                    var hasNoGroup = false;
                    $.each(pbReportArr, function (index, o) {
                        if (o.sGroup == null) {
                            hasNoGroup = true;
                        }
                        if ($.inArray((o.sGroup == null ? "" : o.sGroup), sGroupArr) == -1) {
                            sGroupArr.push((o.sGroup == null ? "" : o.sGroup));
                        }
                    });
                    sGroupArr.sort();
                    $.each(sGroupArr, function (index, o) {
                        //if (o == null || o == "") {
                        $("#divPrintAcc").accordion("add", {
                            title: o,
                            collapsed: (o == "" ? false : true),
                            collapsible: (o == "" ? false : true),
                            selected: (hasNoGroup == true ? (index == 1 ? true : false) : (index == 0 ? true : false)),
                            content: '<table id="tabPrint' + index + '" class="tabprint"></table>'
                        });
                        $.each(pbReportArr, function (index1, o1) {
                            if ((o1.sGroup == null ? "" : o1.sGroup) == o) {
                                FormList.AddAccPrintRow("tabPrint" + index, o1.sPbName, o1.iRecNo, o1.sReportType, o1.iDataSourceFromList, o1.sParms, o1.sLinkField);
                            }
                        });
                        //}
                    })

                }
            },
            AddAccPrintRow: function (tableid, pbname, irecno, reportType, iDataSourceFromList, sParam, sLinkField) {
                sParam = sParam ? "'" + sParam + "'" : null;
                var tab = document.getElementById(tableid);
                var tr = $("<tr></tr>");
                $(tab).append(tr);
                $(tr).append("<td>" + pbname + "</td>");
                $(tr).append("<td style='width:60px;'><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'print','" + reportType + "'," + iDataSourceFromList + "," + sParam + ",'" + sLinkField + "')>直接打印</a></td>");
                $(tr).append("<td style='width:30px;'><a href='#' style='width:50px;' onclick=FormList.PrintClick(this," + irecno + ",'show','" + reportType + "'," + iDataSourceFromList + "," + sParam + ",'" + sLinkField + "')>预览</a></td>");
                if (userid.toLowerCase() == "master") {
                    $(tr).append("<td style='width:30px;'><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'design','" + reportType + "'," + iDataSourceFromList + "," + sParam + ",'" + sLinkField + "')>设计</a></td>");
                }
            },
            GetFormFootData: function (tableid, isAsync) {
                var options = $("#" + tableid).datagrid("options");
                var queryParams = options.queryParams;
                var filters = queryParams.filters;
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    type: "post",
                    async: isAsync,
                    cache: false,
                    data: { otype: "FormListSummary", iFormID: getQueryString("FormID"), filters: filters },
                    success: function (data) {
                        $("#" + tableid).datagrid("reloadFooter", data);
                    },
                    error: function (data) {

                    },
                    dataType: "json"
                });
            },
            collapseTreeLevel: function (level) {
                var rootNodes = $("#tree").tree("getRoots");
                if (level == 0) {
                    $("#tree").tree("collapseAll");
                }
                else {
                    level--;
                    $.each(rootNodes, function (index, o) {
                        var cnodes = $("#tree").tree("getLeafChildren", o.target);
                        FormList.getTreeCollapseNodes(cnodes, level);
                    });
                }
            },
            getTreeCollapseNodes: function (nodes, level) {
                $.each(nodes, function (index, o) {
                    if (level > 0) {
                        var cnodes = $("#tree").tree("getLeafChildren", o.target);
                        //level--;
                        FormList.getTreeCollapseNodes(cnodes, level - 1);
                    }
                    else {
                        $("#tree").tree("collapse", o.target);
                    }
                });
            },
            ShowCross: function () {
                if (originalDataGridData && originalDataGridData.length > 0) {
                    //allData = DeepCopy(originalDataGridData);
                }
                else {
                    MessageShow("数据源不存在", "数据源不存在，请先查询数据再进行透视");
                    return;
                }
                if (isCrossWindowOpen == false) {
                    $("#divCross").window("open");
                    isCrossWindowOpen = true;
                }
                else {
                    $("#divCross").window("close");
                    isCrossWindowOpen = false;
                }

            },
            AddLog: function (oType) {
                var selectKeys = $("#dg").datagrid("getSelections");
                for (var i = 0; i < selectKeys.length; i++) {
                    SysOpreateAddLog(oType, getQueryString("FormID"), selectKeys[i], getQueryString('MenuTitle'));
                }
            },
            ReloadTheRow: function (key, isAdd) {
                $.ajax({
                    url: "/Base/Handler/FormListHandler.ashx",
                    type: "post",
                    async: false,
                    cache: false,
                    data: { otype: "GetTheFormListData", iformid: getQueryString("FormID"), iMenuID: getQueryString("MenuID"), key: key },
                    success: function (data) {
                        if (data.success == true) {
                            if (data.tables[0].length > 0) {
                                if (isAdd) {
                                    $("#dg").datagrid("insertRow", {
                                        index: 0,
                                        row: data.tables[0][0]
                                    })
                                    $("#dg").datagrid("unselectAll");
                                    $("#dg").datagrid("selectRow", 0);
                                }
                                else {
                                    var index = -1;
                                    var dataRows = $("#dg").datagrid("getRows");
                                    for (var i = 0; i < dataRows.length; i++) {
                                        if (dataRows[i][(PK)] == key) {
                                            index = i;
                                            break;
                                        }
                                    }
                                    $("#dg").datagrid("updateRow", {
                                        index: index,
                                        row: data.tables[0][0]
                                    });
                                    $("#dg").datagrid("unselectAll");
                                    $("#dg").datagrid("selectRow", index);
                                }
                            }
                        }
                    },
                    error: function (data) {
                    },
                    dataType: "json"
                });
            },
            DeleteTheRow: function (key) {
                var keyArr = key.split(",");
                for (var i = 0; i < keyArr.length; i++) {
                    var allRows = $("#dg").datagrid("getRows");
                    for (var j = 0; j < allRows.length; j++) {
                        if (allRows[j][PK] == keyArr[i]) {
                            $("#dg").datagrid("deleteRow", j);
                            break;
                        }
                    }
                }
            },
            openColumnDefined: function () {
                var divColumnDefined = $("#divColumnDefined");
                var columnsData = undefined;
                var iBscDataQueryMRecNo;
                $.ajax({
                    url: "/Base/Handler/sysHandler.ashx",
                    type: "get",
                    async: false,
                    cache: false,
                    data: { otype: "getFormListColumnsDefine", iformid: getQueryString("FormID") },
                    success: function (result) {
                        if (result.success == true) {
                            columnsData = result.tables[0];
                        }
                    },
                    error: function () {

                    }, dataType: "json"
                });
                if (divColumnDefined.length == 0) {
                    var divCD = $("<div id='divColumnDefined'><form id='formColumnSet'><input id='TableName' value='bscDataQueryM' type='hidden' />" +
                        "<input id='FieldKey' value='iRecNo' type='hidden' />" +
                        "<input type='hidden' id='FieldKeyValue' value='" + columnsData[0]["iMainRecNo"] + "' /></form>" +
                        "<table id='tabColumnDefined' tablename='BscDataQueryD' linkfield='iRecNo=iMainRecNo' fieldkey='GUID' isson='true'></table></div>");
                    $("body").append(divCD);
                    $("#divColumnDefined").dialog({
                        title: "列定义设置",
                        width: 750,
                        height: 500,
                        modal: true,
                    });
                    $("#tabColumnDefined").datagrid({
                        fit: true,
                        border: false,
                        columns: [[
                            { field: "__cb", width: 40, checkbox: true },
                            {
                                field: "isChild", title: "明细<br />字段", align: "center", width: 40, formatter: function (value, row, index) {
                                    if (row.isChild == "1") {
                                        return "√";
                                    }
                                }, styler: function () {
                                    return "background-color:#ffffaa";
                                }
                            },
                            { field: "iShowOrder", title: "列序", align: "center", width: 40, editor: { type: "numberspinner", options: { height: tdTxbHeight } } },
                            { field: "sFieldsdisplayName", title: "列名", align: "left", width: 100, editor: { type: "textbox", options: { height: tdTxbHeight } } },
                            {
                                field: "sFieldsType", title: "类型", align: "center", width: 70, editor: {
                                    type: "combobox", options: {
                                        height: tdTxbHeight,
                                        data: [{ i: "string", t: "字符" }, { i: "number", t: "数据" }, { i: "date", t: "日期" },
                                        { i: "datetime", t: "时间" }, { i: "imageUrl", t: "图片" }, { i: "附件", t: "附件" }],
                                        valueField: "i", textField: "t"
                                    }
                                }, formatter: function (value, row, index) {
                                    if (row.sFieldsType == "string") {
                                        return "字符";
                                    }
                                    if (row.sFieldsType == "number") {
                                        return "数据";
                                    }
                                    if (row.sFieldsType == "date") {
                                        return "日期";
                                    }
                                    if (row.sFieldsType == "datetime") {
                                        return "时间";
                                    }
                                    if (row.sFieldsType == "imageUrl") {
                                        return "图片";
                                    }
                                }
                            },
                            { field: "iWidth", title: "宽度", align: "center", width: 60, editor: { type: "numberbox", options: { height: tdTxbHeight, precision: 0 } } },
                            {
                                field: "sAlign", title: "对齐<br />方式", align: "center", width: 60, editor: {
                                    type: "combobox",
                                    options: {
                                        height: tdTxbHeight, data: [{ i: "center", t: "居中" }, { i: "left", t: "左对齐" }, { i: "right", t: "右对齐" }],
                                        valueField: "i", textField: "t", panelHeight: 80
                                    }
                                }, formatter: function (value, row, index) {
                                    if (row.sAlign == "center") {
                                        return "居中";
                                    }
                                    if (row.sAlign == "left") {
                                        return "左对齐";
                                    }
                                    if (row.sAlign == "right") {
                                        return "右对齐";
                                    }
                                }
                            },
                            {
                                field: "sSummary", title: "合计<br />类型", width: 70, align: "center", editor: {
                                    type: "combobox",
                                    options: {
                                        height: tdTxbHeight,
                                        data: [
                                            { i: "sum", t: "合计" }, { i: "max", t: "最大值" }, { i: "min", t: "最小值" },
                                            { i: "count", t: "个数" }, { i: "avg", t: "平均数" }
                                        ],
                                        valueField: "i", textField: "t", panelHeight: 200
                                    }
                                }, formatter: function (value, row, index) {
                                    if (row.sSummary == "sum") {
                                        return "合计";
                                    }
                                    if (row.sSummary == "max") {
                                        return "最大值";
                                    }
                                    if (row.sSummary == "min") {
                                        return "最小值";
                                    }
                                    if (row.sSummary == "count") {
                                        return "个数";
                                    }
                                    if (row.sSummary == "avg") {
                                        return "平均数";
                                    }
                                }
                            },
                            {
                                field: "iSummryDigit", title: "合计<br />小数位", align: "center", width: 60, editor: {
                                    type: "numberspinner", options: { height: tdTxbHeight }
                                }
                            },
                            {
                                field: "iSort", title: "排序", align: "center", width: 60, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                                formatter: function (value, row, index) {
                                    if (row.iSort == "1") {
                                        return "√";
                                    }
                                }
                            },
                            {
                                field: "iHide", title: "隐藏", align: "center", width: 40, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                                formatter: function (value, row, index) {
                                    if (row.iHide == "1") {
                                        return "√";
                                    }
                                }
                            },
                        ]],
                        data: columnsData,
                        remoteSort: false,
                        onClickRow: function (index, row) { currentEditRowIndex = index; },
                        onClickCell: function (index, row) { currentEditRowIndex = index; datagridOp.cellClick("tabColumnDefined", index, row); },
                        onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tabColumnDefined", index, row); },
                        onBeginEdit: function (index, row) { datagridOp.beginEditor("tabColumnDefined", index, row); },
                        onEndEdit: function (index, row, changes) { datagridOp.endEditor("tabColumnDefined", index, row, changes); },
                        onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("tabColumnDefined", index, row, changes); },
                        toolbar: [{
                            iconCls: 'icon-preview',
                            text: "上移",
                            handler: function () {
                                MoveUp("tabColumnDefined");
                            }
                        }, '-', {
                            iconCls: 'icon-next',
                            text: "下移",
                            handler: function () {
                                MoveDown("tabColumnDefined");
                            }
                        }, '-',
                        {
                            iconCls: 'icon-save',
                            text: "保存",
                            handler: function () {
                                if (currentEditRowIndex != undefined) {
                                    $("#tabColumnDefined").datagrid("endEdit", currentEditRowIndex);
                                }
                                var rows = $("#tabColumnDefined").datagrid("getRows");
                                var iRecNo = $("#FieldKeyValue").val();
                                if (iRecNo != "") {
                                    var iRecNoResult = Form.__update(iRecNo, "/Base/Handler/DataOperatorNew.ashx?otype=1", "formColumnSet");
                                    if (iRecNoResult.indexOf("error:") > -1) {
                                        MessageShow("失败", iRecNoResult);
                                    }
                                    else {
                                        MessageShow("成功", "保存成功");
                                        //$("#divColumnDefined").dialog("close");
                                    }
                                }
                            }
                        }, '-',
                        {
                            iconCls: 'icon-undo',
                            text: "关闭",
                            handler: function () {
                                $("#divColumnDefined").dialog("close");
                            }
                        }
                        ]
                    })
                } else {
                    $("#tabColumnDefined").datagrid("loadData", columnsData);
                }
                $("#divColumnDefined").dialog("open");
            },
            BtnHelp: function () {
                var sqlObj = {
                    TableName: "bscDataBill",
                    Fields: "sHelpInfo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iFormID",
                            ComOprt: "=",
                            Value: getQueryString("FormID")
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    var height = window.screen.availHeight - 30 - 100 - 50;
                    $("#divHelp").show();
                    $("#divHelp").window({
                        title: "帮助",
                        collapsible: false,
                        minimizable: false,
                        maximizable: false,
                        closable: true,
                        modal: false,
                        content: result[0].sHelpInfo,
                        cache: false,
                        inline: false,
                        width: '60%',
                        height: height
                    });
                }
            }
        };
        var currentEditRowIndex = undefined;
        var isCrossWindowOpen = false;
        function getAllQueryString() {
            var q = location.search.substr(1);
            var qs = q.split('&');
            var argStr = '';
            if (qs) {
                for (var i = 0; i < qs.length; i++) {
                    argStr += qs[i].substring(0, qs[i].indexOf('=')) + '=' + qs[i].substring(qs[i].indexOf('=') + 1) + '&';
                }
            }
            return argStr;
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
        function MessageShow(title, message) {
            var iheight = (message.length / 20) * 20;
            iheight = iheight < 100 ? 100 : iheight;
            $.messager.show({
                showSpeed: 100,
                title: title,
                height: iheight,
                msg: message,
                showType: 'slide',
                timeout: 2000,
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
        }
        function GridRefresh() {
            if (isQuery == false) {
                $("#dg").datagrid("reload");
            }
            else {
                FormList.BtnSearch();
            }
        }

        var onImportExcelSuccess = undefined;

        function setImportFinishInfo(message) {
            $("#pImportFinishInfo").html(message);
        }

        function showImportFinishInfo() {
            $("#divImportFinishInfo").dialog("open");
        }

        function hideImport() {
            $("#divImport").dialog("close");
        }
        function CloseBillWindow() {
            try {
                for (var i = 0; i < window.parent.openMenuID.length; i++) {
                    if (window.parent.openMenuID[i] == getQueryString("MenuID")) {
                        window.parent.openMenuID.splice(i, 1);
                        break;
                    }
                }
            } catch (e) {

            }

            $("#divFormBill").window("close");
        }
        function DeepCopy(obj) {
            var out = [], i = 0, len = obj.length;
            for (; i < len; i++) {
                if (obj[i] instanceof Array) {
                    out[i] = DeepCopy(obj[i]);
                }
                else out[i] = obj[i];
            }
            return out;
        }

        function getType(obj) {
            //tostring会返回对应不同的标签的构造函数
            var toString = Object.prototype.toString;
            var map = {
                '[object Boolean]': 'boolean',
                '[object Number]': 'number',
                '[object String]': 'string',
                '[object Function]': 'function',
                '[object Array]': 'array',
                '[object Date]': 'date',
                '[object RegExp]': 'regExp',
                '[object Undefined]': 'undefined',
                '[object Null]': 'null',
                '[object Object]': 'object'
            };
            if (obj instanceof Element) {
                return 'element';
            }
            return map[toString.call(obj)];
        }

        function deepClone(data) {
            var type = getType(data);
            var obj;
            if (type === 'array') {
                obj = [];
            } else if (type === 'object') {
                obj = {};
            } else {
                //不再具有下一层次
                return data;
            }
            if (type === 'array') {
                for (var i = 0, len = data.length; i < len; i++) {
                    obj.push(deepClone(data[i]));
                }
            } else if (type === 'object') {
                for (var key in data) {
                    obj[key] = deepClone(data[key]);
                }
            }
            return obj;
        }

        function MyEnCode(str) {
            //str = str.replace(/\+/g, "%2B").replace(/ /g, "%20").replace(/\//g, "%2F").replace(/\?/g, "%3F").replace(/%/g, "%25").replace(/#/g, "%23").replace(/&/g, "%26").replace(/=/g, "%3D").replace(/\'/g, "%27");
            str = str.replace(/%/g, "%25");
            return str;
        }
        function pagerFilter(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    dg.datagrid('loadData', data);
                }
            });
            if (!data.originalRows) {
                data.originalRows = (data.rows);
            }
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }
        function loadJS(path) {
            if (!path || path.length === 0) {
                throw new Error('argument "path" is required !');
            }
            var head = document.getElementsByTagName('head')[0];
            var script = document.createElement('script');
            script.src = path;
            script.type = 'text/javascript';
            head.appendChild(script);
        }
        function loadCSS(path) {
            if (!path || path.length === 0) {
                throw new Error('argument "path" is required !');
            }
            var head = document.getElementsByTagName('head')[0];
            var link = document.createElement('link');
            link.href = path;
            link.rel = 'stylesheet';
            head.appendChild(link);
        }

        //if (myBrowser() != "IE") {
        //    loadCSS("/Base/js/StimulsoftReport2016.2/css/stimulsoft.viewer.office2013.whiteblue.css");
        //    loadCSS("/Base/js/StimulsoftReport2016.2/css/stimulsoft.designer.office2013.whiteblue.css");
        //    loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.reports.js");
        //    //            loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.viewer.js");
        //    //            loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.designer.js");
        //    setTimeout(function () { loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.viewer.js"); }, 2000);
        //    setTimeout(function () { loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.designer.js"); }, 2000);
        //    setTimeout(function () { loadJS("/Base/JS2/StimulsoftReport.js?r=" + Math.random()); }, 3000);

        //}
        function printClose() {
            $("#btnPrint").tooltip("hide");
        }
        function printClose1() {
            $("#btnAssociate").tooltip("hide");
        }
        function myBrowser() {
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            var isOpera = userAgent.indexOf("Opera") > -1;
            if (isOpera) {
                return "Opera"
            }; //判断是否Opera浏览器
            if (userAgent.indexOf("Firefox") > -1) {
                return "FF";
            } //判断是否Firefox浏览器
            if (userAgent.indexOf("Chrome") > -1) {
                return "Chrome";
            }
            if (userAgent.indexOf("Safari") > -1) {
                return "Safari";
            } //判断是否Safari浏览器
            if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
                return "IE";
            }; //判断是否IE浏览器
        }

        function getByteLeng(str) {
            if (str) {
                var realLength = 0;
                for (var i = 0; i < str.length; i++) {
                    charCode = str.charCodeAt(i);
                    if (charCode >= 0 && charCode <= 128)
                        realLength += 1;
                    else
                        realLength += 2;
                }
                return realLength;
            } else {
                return 0;
            }
        }
        function getTooltip(value) {
            var content = "<a href=\"#\" style=\"text-decoration:none;\" title=\"" + (value == null || value == undefined ? "" : value) + "\" class=\"easyui-tooltip\">" + (value == null || value == undefined ? "" : value) + "</a>";
            return content;
        }

        Number.prototype.toFixed = function (d) {
            var s = this + "";
            if (!d) d = 0;
            if (s.indexOf(".") == -1) s += ".";
            s += new Array(d + 1).join("0");
            if (new RegExp("^(-|\\+)?(\\d+(\\.\\d{0," + (d + 1) + "})?)\\d*$").test(s)) {
                var s = "0" + RegExp.$2, pm = RegExp.$1, a = RegExp.$3.length, b = true;
                if (a == d + 2) {
                    a = s.match(/\d/g);
                    if (parseInt(a[a.length - 1]) > 4) {
                        for (var i = a.length - 2; i >= 0; i--) {
                            a[i] = parseInt(a[i]) + 1;
                            if (a[i] == 10) {
                                a[i] = 0;
                                b = i != 1;
                            } else break;
                        }
                    }
                    s = a.join("").replace(new RegExp("(\\d+)(\\d{" + d + "})\\d$"), "$1.$2");

                } if (b) s = s.substr(1);
                return (pm + s).replace(/\.$/, "");
            } return this + "";
        };
        Array.prototype.distinct = function () {
            return this.reduce(function (new_array, old_array_value) {
                if (new_array.indexOf(old_array_value) == -1) new_array.push(old_array_value);
                return new_array; //最终返回的是 prev value 也就是recorder
            }, []);
        }
        function showBigImage() {
            $(".btnImageShow").tooltip(
                {
                    content: function () {
                        var t = $(this);
                        var img = $(t).children("img")[0];
                        var src = $(img).attr("src");
                        var alt = $(img).attr("alt");
                        return $("<div><img src='" + src.replace("&isThum=1", "&isThum=0") + "' alt='" + alt + "' style='width:250px; height:250px;'></div>");
                    },
                    /*showEvent: 'click',*/
                    onShow: function () {
                        var t = $(this);
                        t.tooltip("tip").unbind().bind("mouseenter",
                            function () { t.tooltip("show"); }).bind("mouseleave",
                                function () {
                                    t.tooltip("hide");
                                });
                    }
                });
        }
        function MoveUp(tableid) {
            var rows = $("#" + tableid).datagrid('getChecked');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#" + tableid).datagrid('getRowIndex', rows[i]);
                $("#" + tableid).datagrid("endEdit", index);
                mysort(index, 'up', tableid);
            }
        }
        //下移
        function MoveDown(tableid) {
            var rows = $("#" + tableid).datagrid('getChecked');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#" + tableid).datagrid('getRowIndex', rows[i]);
                $("#" + tableid).datagrid("endEdit", index);
                mysort(index, 'down', tableid);
            }
        }
        function mysort(index, type, gridname) {
            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datagrid('getData').rows[index];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    $('#' + gridname).datagrid('getData').rows[index] = todown;
                    $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index - 1);
                    $('#' + gridname).datagrid('checkRow', index - 1);
                    $('#' + gridname).datagrid('uncheckRow', index);
                }
            }
            else if ("down" == type) {
                var rows = $('#' + gridname).datagrid('getRows').length;
                if (index != rows - 1) {
                    var todown = $('#' + gridname).datagrid('getData').rows[index];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
                    $('#' + gridname).datagrid('getData').rows[index] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index + 1);
                    $('#' + gridname).datagrid('checkRow', index + 1);
                    $('#' + gridname).datagrid('uncheckRow', index);
                }
            }
        }
        document.onkeydown = function () {
            if (isEditting) {
                var doFoucus = function (ed) {
                    if (ed) {
                        if (ed.type == "textbox") {
                            $(ed.target).textbox("textbox").focus();
                            $(ed.target).textbox("textbox").select();
                        }
                        else if (ed.type == "numberbox") {
                            $(ed.target).numberbox("textbox").focus();
                            $(ed.target).numberbox("textbox").select();
                        }
                        else if (ed.type == "combobox") {
                            $(ed.target).combobox("textbox").focus();
                            $(ed.target).combobox("textbox").select();
                        }
                        else if (ed.type == "combotree") {
                            $(ed.target).combotree("textbox").focus();
                            $(ed.target).combotree("textbox").select();
                        }
                        else if (ed.type == "numberspinner") {
                            $(ed.target).numberspinner("textbox").focus();
                            $(ed.target).numberspinner("textbox").select();
                        }
                        else if (ed.type == "datebox") {
                            $(ed.target).datebox("textbox").focus();
                            $(ed.target).datebox("textbox").select();
                        }
                        else if (ed.type == "datetimebox") {
                            $(ed.target).datetimebox("textbox").focus();
                            $(ed.target).datetimebox("textbox").select();
                        }
                        else {
                            $(ed.target).focus();
                            $(ed.target).select();
                        }
                        if (ed.target[0].tagName.toLowerCase() == "textarea") {
                            datagridOp.isEidtorTextarea = true;
                        }
                        else {
                            datagridOp.isEidtorTextarea = undefined;
                        }
                    }
                }


                //下
                if (event.keyCode == 40) {
                    if (datagridOp.currentIsEdit == true) {
                        if (typeof (lookUp) != "undefined") {
                            if (lookUp.isPopupOpen == false) {
                                var rowCount = $("#" + datagridOp.current.id).datagrid("getRows").length;
                                if (rowCount - 1 == datagridOp.currentRowIndex) {
                                    Page.tableToolbarClick("add", datagridOp.current.id, {});
                                    var rowCount1 = $("#" + datagridOp.current.id).datagrid("getRows").length;
                                    if (rowCount1 <= rowCount) {
                                        return false;
                                    }
                                }
                                var curtIndex = datagridOp.currentRowIndex;
                                datagridOp.lookUpNotOpen = true;
                                $("#" + datagridOp.current.id).datagrid("endEdit", curtIndex);
                                datagridOp.lookUpNotOpen = undefined;
                                $("#" + datagridOp.current.id).datagrid("editCell", { index: curtIndex + 1, field: datagridOp.currentColumnName });
                                var ed = $("#" + datagridOp.current.id).datagrid('getEditor', { index: curtIndex + 1, field: datagridOp.currentColumnName });
                                //bindMouseup(ed);
                                doFoucus(ed);
                                //datagridOp.currentColumnName = r.field;
                                //datagridOp.currentColumnIndex = r.index;
                                datagridOp.currentRowIndex = curtIndex + 1;
                                event.preventDefault();
                            }
                        }
                    }
                }
                //上
                if (event.keyCode == 38) {
                    if (datagridOp.currentIsEdit == true) {
                        if (typeof (lookUp) != "undefined") {
                            if (lookUp.isPopupOpen == false) {
                                if (datagridOp.currentRowIndex != 0) {
                                    //var rowCount = $("#" + datagridOp.current.id).datagrid("getRows").length;
                                    var curtIndex = datagridOp.currentRowIndex;
                                    datagridOp.lookUpNotOpen = true;
                                    $("#" + datagridOp.current.id).datagrid("endEdit", curtIndex);
                                    datagridOp.lookUpNotOpen = undefined;
                                    $("#" + datagridOp.current.id).datagrid("editCell", { index: curtIndex - 1, field: datagridOp.currentColumnName });

                                    var ed = $("#" + datagridOp.current.id).datagrid('getEditor', { index: curtIndex - 1, field: datagridOp.currentColumnName });
                                    doFoucus(ed);
                                    datagridOp.currentRowIndex = curtIndex - 1;
                                    event.preventDefault();
                                }
                            }
                        }
                    }
                }
                //左
                if (event.keyCode == 37) {
                    if (datagridOp.currentIsEdit == true) {
                        if (datagridOp.currentColumnIndex > 0) {
                            if (typeof (lookUp) != "undefined") {
                                if (lookUp.isPopupOpen == false) {
                                    //event = event ? event : window.event;
                                    var obj = event.srcElement ? event.srcElement : event.target;
                                    var cursortPosition = getCursortPosition(obj);
                                    if (cursortPosition == 0) {
                                        datagridOp.gotoPreviousEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex);
                                        event.preventDefault();
                                    }

                                }
                            }
                        }

                    }
                }
                //右
                if (event.keyCode == 39) {
                    if (datagridOp.currentIsEdit == true) {
                        //if (datagridOp.currentColumnIndex > 0) {
                        if (typeof (lookUp) != "undefined") {
                            if (lookUp.isPopupOpen == false) {
                                //event = event ? event : window.event;
                                var obj = event.srcElement ? event.srcElement : event.target;
                                var cursortPosition = getCursortPosition(obj);
                                if (cursortPosition == obj.value.length) {
                                    datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex);
                                    event.preventDefault();
                                }

                            }
                        }
                        //}

                    }
                }
            }

        }

        function GetUpdateLog() {
            var sqlObj = {
                StoreProName: "spGetUpdateLog",
                StoreParms: [
                    {
                        ParmName: "@iformid",
                        Value: getQueryString("FormID")
                    },
                    {
                        ParmName: "@userid",
                        Value: userid
                    }
                ]
            };
            SqlStoreProce(sqlObj, true, true, true, function (responseText) {
                try {
                    var resultObj = JSON2.parse(responseText);
                    if (resultObj.success == true) {
                        var result = resultObj.tables[0];
                        if (result.length > 0) {
                            var content = "";
                            var iRecNos = "";
                            for (var i = 0; i < result.length; i++) {
                                content += result[i].sContent;
                                iRecNos += "," + result[i].iRecNo;
                            }
                            var height = window.screen.availHeight - 30 - 100 - 50;
                            $('#divUpdateLog').dialog({
                                iconCls: 'icon-job',
                                buttons: [
                                    {
                                        text: '确认',
                                        iconCls: 'icon-ok',
                                        handler: function () {
                                            if ($.messager.confirm("确认更新内容？", "确认后的内容不再显示！", function (r) {
                                                if (r) {
                                                    var result = SqlStoreProce({
                                                        StoreProName: "spUpdateLogConfirm",
                                                        StoreParms: [
                                                            {
                                                                ParmName: "@iRecNos",
                                                                Value: iRecNos.substr(1)
                                                            },
                                                            {
                                                                ParmName: "@sUserID",
                                                                Value: userid
                                                            }
                                                        ]
                                                    });
                                                    if (result == "1") {
                                                        $.messager.alert("成功", "确认成功！", 'info', function () {
                                                            $('#divUpdateLog').window('close');
                                                        });
                                                    }
                                                    else {
                                                        $.messager.alert("错误", result);
                                                    }
                                                }
                                            }));
                                        }
                                    }, {
                                        text: '取消',
                                        iconCls: 'icon-cancel',
                                        handler: function () {
                                            $('#divUpdateLog').window('close');
                                        }
                                    }]
                            });
                            $("#divUpdateLog").show();
                            $("#divUpdateLog").window({
                                title: "更新日志（确认后不再显示）",
                                collapsible: false,
                                minimizable: false,
                                maximizable: true,
                                closable: true,
                                modal: false,
                                content: content,
                                cache: false,
                                inline: false,
                                width: '60%',
                                height: height,
                                top: 10,
                                left: '20%'
                            });
                        }
                    }
                    else {
                        alert(resultObj.message);
                    }
                    $.messager.progress('close');
                    //var allRows = $("#table1").datagrid("getData");
                    //alert(allRows.length);
                }
                catch (e) {
                    alert(e.message);
                    $.messager.progress('close');
                }
            });
        }
    </script>
    <style type="text/css">
        body {
            font-family: 'Microsoft YaHei';
        }

        .atooltip {
            text-decoration: none;
        }

        .tabprint {
            width: 100%;
        }

            .tabprint tr td {
                height: 25px;
                /*padding: 3px;*/
                font-weight: bold;
            }

        .datagridRowStyle {
            height: 30px;
            font-size: 14px;
            font-family: Verdana;
            background-color: Red;
        }

        .datagrid-header-row, .pagination {
            height: 30px;
            font-weight: bold;
        }

        .datagrid-row {
            height: 35px;
        }

        .datagrid-footer div {
            font-size: 14px;
            font-weight: bold;
            color: red;
        }

        .txbRight {
            border: none;
            border-bottom: 1px solid #95B8E7;
            height: 22px;
            width: 120px;
        }

        .btn-separator {
            height: 30px;
            border-left: 1px solid #a0a0a0;
            border-right: 1px solid #a0a0a0;
            margin: 1px 20px;
            display: inline;
        }

        .tree-node {
            /*height: 18px;*/
            height: 22px;
            padding-top: 4px;
            vertical-align: middle;
            white-space: nowrap;
            cursor: pointer;
            border-bottom: 1px solid #cccccc;
        }

        .button {
            display: inline-block;
            outline: none;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            /*font: 14px/100% 'Microsoft yahei' ,Arial, Helvetica, sans-serif;*/
            font-size: 14px;
            padding: .5em 2em .50em;
            text-shadow: 0 1px 1px rgba(0,0,0,.3);
            -webkit-border-radius: .5em;
            -moz-border-radius: .5em;
            border-radius: .5em;
            -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            -moz-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            box-shadow: 0 1px 2px rgba(0,0,0,.2);
            font-weight: bold;
        }

            .button:hover {
                text-decoration: none;
            }

            .button:active {
                position: relative;
                top: 1px;
            }

        /* orange */
        .orange {
            /*color: #fef4e9;*/
            color: #ffffff;
            border: solid 1px #da7c0c;
            background: #f78d1d;
            background: -webkit-gradient(linear, left top, left bottom, from(#faa51a), to(#f47a20));
            background: -moz-linear-gradient(top, #faa51a, #f47a20);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#faa51a', endColorstr='#f47a20');
        }

            .orange:hover {
                background: #f47c20;
                background: -webkit-gradient(linear, left top, left bottom, from(#f88e11), to(#f06015));
                background: -moz-linear-gradient(top, #f88e11, #f06015);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f88e11', endColorstr='#f06015');
            }

            .orange:active {
                /*color: #fcd3a5;*/
                color: #ffffff;
                background: -webkit-gradient(linear, left top, left bottom, from(#f47a20), to(#faa51a));
                background: -moz-linear-gradient(top, #f47a20, #faa51a);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f47a20', endColorstr='#faa51a');
            }

        .button:active {
            /*text-decoration: none;*/
            color: red;
        }

        .assQueryBtn {
            font-size: 12px;
            color: red;
        }

            .assQueryBtn:hover {
                /*text-decoration: none;*/
                color: red;
            }

        .ulTS {
            margin: 0px;
            padding: 0px;
        }

            .ulTS li {
                list-style: none;
            }

        .tabAcross {
            border-collapse: collapse;
        }

            .tabAcross tr th {
                height: 25px;
                border: solid 1px #e0e0e0;
                border-top: none;
                border-left: none;
                text-align: center;
            }

            .tabAcross tr td {
                height: 25px;
                border: solid 1px #e0e0e0;
                border-top: none;
                border-left: none;
                vertical-align: top;
                /*text-align:center;*/
            }

        .tabTs tr td {
            border: none;
        }

        .tdInput {
            padding-right: 20px;
        }
    </style>
</head>
<body id="panel" class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',split:false,border:false" style="padding-left: 5px; padding-top: 3px; height: 70px"
        id="divNorth">
        <div id="divConditionsImage" style="vertical-align: middle;">
            <img alt="" src="JS/easyui/themes/icons/search.png" />查询条件
                <hr style="margin-bottom: 3px; margin-top: 0px;" />
        </div>
        <div id="divConditions">
            <form id="form1" method="post">
                <table id="tabConditions" style="margin-left: 35px;">
                </table>
            </form>
        </div>
    </div>
    <div data-options="region:'west'" style="width: 200px;" id="divWest" style="padding: 5px;">
        <div>
            <ul id="tree">
            </ul>
        </div>
    </div>
    <div data-options="region:'center',border:true" id="divCenter" style="padding: 5px;">
        <div id="toolbar" style="padding: 3px;" cellspacing="5">
        </div>
        <table id="dg">
        </table>
    </div>
    <div id="divEast" data-options="region:'east',border:true,split:true,width:500">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north',border:false" style="height: 30px;">
                <table id="tableChartYAxis" class="tableChartYAxis">
                    <tr id="trChartYAxis" class="trChartYAxis">
                    </tr>
                </table>
            </div>
            <div data-options="region:'center',border:false,iconCls:'icon-chart'">
                <div class="easyui-tabs" data-options="fit:true,border:false,tools:[{iconCls:'icon-zoomin',handler:FormList.ZoomIn}]"
                    id="divChartTabs">
                    <div title="曲线图" id="divLine">
                    </div>
                    <div title="柱状图" id="divColumn">
                    </div>
                    <div title="饼状图" id="divPie">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divlogin" style="width: 250px; text-align: center; display: none;" class="easyui-window"
        data-options="title:'重新登录',minimizable:false,maximizable:false,modal:true,closed:true">
        <table style="margin: auto;">
            <tr>
                <td style="text-align: left; height: 30px;">用户名：
                </td>
                <td>
                    <input id="txbReLoginUserID" type="text" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: left; height: 30px;">密码：
                </td>
                <td>
                    <input id="txbReLoginPsd" type="password" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 40px">
                    <input id="Button1" type="button" value="确定" onclick="FormList.ReLogin()" style="width: 50px; height: 25px;" />
                </td>
            </tr>
        </table>
    </div>
    <div id="divPb" style="display: none;">
        <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
    </div>
    <div id="divPrint" style="width: 350px; height: 300px;">
        <div id="divPrintAcc" class="easyui-accordion" data-options="border:false,fit:true" style="display: none;">
            <%--<table id="tabPrint" class="tabprint">
                </table>--%>
        </div>
    </div>
    <div id="divAssociated" style="padding: 5px;">
        <table id="tabAssociated" class="tabprint">
        </table>
    </div>
    <div id="divFj" style="display: none; margin: 0px; padding: 0px;">
        <iframe id="ifrFj" width="100%" height="98%" frameborder="0"></iframe>
    </div>
    <div id="divFormBill" style="display: none;">
    </div>
    <div id="divPushConfirm" class="easyui-dialog" data-options="closed:true">
    </div>
    <div id="divlookUp" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: true, cache: false,
     maximizable: true,resizable: true,onBeforeOpen:lookUp.onBeforeOpen,onBeforeClose:lookUp.onBeforeClose,onBeforeDestroy:lookUp.onBeforeDestroy">
        <iframe style='margin: 0; padding: 0' id='ifrlookup' name='ifrlookup' width='100%'
            height='99.5%' frameborder='0'></iframe>
    </div>
    <div id="divImport" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="top:100,width:500,height:250,closed:true,title: '导入数据',modal: true, cache: false">
        <iframe style='margin: 0; padding: 0' id='ifrImport' name='ifrImport' width='100%'
            height='99%' frameborder='0'></iframe>
    </div>
    <div id="divImportFinishInfo" class="easyui-dialog" style="padding: 10px; margin: 0px;"
        data-options="width:400,height:220,closed:true,title: '导入信息',modal: true, cache: false">
        <p id="pImportFinishInfo">
        </p>
    </div>


    <%--<div id="panel" class="easyui-layout" data-options="fit:true,border:true">
        
    </div>--%>
    <div id="divChartZoomIn" class="easyui-window" data-options="iconCls:'icon-chart',modal:true,closable:true,closed:true,resizable:false,maximized:true,title:'数据分析',minimizable:false,maximizable:false,collapsible:false">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north',border:false" style="height: 30px;">
                <table id="table1" class="tableChartYAxis">
                    <tr id="trChartYAxisZoomIn" class="trChartYAxis">
                    </tr>
                </table>
            </div>
            <div data-options="region:'center',border:false,iconCls:'icon-chart'">
                <div class="easyui-tabs" data-options="fit:true,border:false" id="divChartTabsZoomIn">
                    <div title="曲线图" id="divLine1">
                    </div>
                    <div title="柱状图" id="divColumn1">
                    </div>
                    <div title="饼状图" id="divPie1">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divExport" style="display: none;">
        <table id="dg1" class="easyui-datagrid"></table>
    </div>
    <div id="divCross" class="easyui-window" data-options="iconCls:'icon-chart',width:700,height:250,top:80,left:690,closable:true,closed:true,resizable:false,title:'透视表',minimizable:false,maximizable:false,collapsible:false,onBeforeClose:function(){ isCrossWindowOpen=false; }">
        <div style="float: left; width: 360px; height: 210px; overflow: hidden;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'center',border:false">
                    <table class="tabAcross">
                        <tr>
                            <th style="width: 100px;">固定列
                            </th>
                            <th style="width: 100px;">横向列
                            </th>
                            <th style="width: 150px;">值列
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <table id="tabFixFields" class="tabTs"></table>
                            </td>
                            <td>
                                <table id="tabCrossFields" class="tabTs"></table>
                            </td>
                            <td>
                                <table id="tabValueField" class="tabTs">
                                </table>
                                <%--<ul id="ulValueFields" class="ulTS"></ul>--%>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'south',border:false" style="height: 45px; text-align: center;">
                    <table class="tabTs" style="margin: auto;">
                        <tr>
                            <td>
                                <a class="button orange" onclick="FormList.BtnSummary()">确定</a>
                            </td>
                            <td>
                                <a class="button orange" onclick="$('#divCross').window('close')">取消</a>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="float: right; width: 325px; height: 210px; background-image: url(../images/tsImage.png); background-repeat: no-repeat; overflow: hidden;">
        </div>
    </div>
    <div id="divHelp" style="display: none;">
    </div>
    <div id="divUpdateLog" style="display: none;">
    </div>
    <%--<script type="text/javascript">
        window.onload = function () {
            var lodop = getLodop(null,null,true);

        };
    </script>--%>
</body>
</html>
