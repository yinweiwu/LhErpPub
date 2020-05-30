<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>表单列表</title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/approval.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS2/lookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS2/datagridOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
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
        var dynColumns = undefined;
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
            //var filters = getQueryString(filters);
            if (filters == null || filters == "") {
                filters = "1=1";
            }
            $.ajax(
            {
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                url: "/Base/Handler/FormListHandler.ashx",
                data: { otype: "FormListInit", multi: multi, filters: filters, popup: popup, FormID: FormID, MenuID: MenuID, returnFn: returnFn },
                async: true,
                cache: false,
                success: function (data, status) {
                    try {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            //var now = new Date().getTime();
                            //eval(resultObj.message);
                            new Function(resultObj.message)();
                            var tableCon = document.getElementById("tabConditions");
                            var allTr = tableCon.rows;
                            if (allTr.length > 0) {
                                var btnSearch = $("<td rowspan=2 style='vertical-align:top;'><a href='javascript:void(0)' onclick='FormList.BtnSearch()' class='button orange'>查询</a></td>");
                                $(allTr[0]).append(btnSearch);
                            }
                            else {
                                var btnSearch = $("<tr><td rowspan=2 style='vertical-align:top;'><a href='javascript:void(0)' onclick='FormList.BtnSearch()' class='button orange'>查询</a></td></tr>");
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
                                assQueryBtn = "<td style='font-size:14px;font-weight:bold;'>&nbsp;&nbsp;&nbsp;&nbsp;更多查询>&nbsp;&nbsp;" + assQueryBtn + "</td>";
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
                                    case "textbox": value = $(ele).textbox("getValue"); break;
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
                    }
                    //选择完后去掉复选框

                    if (getQueryString("multi") == "1") {
                        $("#dg").datagrid("uncheckAll");
                    }
                    else {
                        window.close();
                    }
                }
                else {
                    MessageShow("未选择数据", "亲，您未选择任务数据！");
                }

            },
            BtnSelectAll: function () {
                if ($.messager.confirm("确认转入所有数据？", "确认转入所有数据吗，可能会花费转长时间？", function (r) {
                    if (r) {
                        var selectedRows = $("#dg").datagrid("getData").rows;
                        if (selectedRows.length > 0) {
                            if (window.opener) {
                                var fnStr = FormList.ReturnFn + "(" + JSON2.stringify(selectedRows) + ")"
                                eval(fnStr);
                            }
                        }
                        window.close();
                    }
                }));
            },
            BtnImport: function () {
                $("#ifrImport").attr("src", "/Base/FileUpload/ImportExcel.aspx?&iFormID=" + getQueryString("FormID") + "&r=" + Math.random);
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
            GetImage: function (iformid, tablename, irecno, imageid,index) {
                $.ajax({
                    url: "/Base/imageUpload/imagesShow.aspx",
                    data: { otype: "getListImageN", iformid: iformid, tablename: tablename, irecno: irecno, imageid: imageid,index:index },
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
                    MessageShow("错误", result.replace(/&lt;/g, "<").replace(/&gt;/g, ">"));
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
                    var data = FormList.GetFormListQueryData(filters);
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
                $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'print','" + reportType + "'," + iDataSourceFromList + ")>直接打印</a></td>");
                $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'show','" + reportType + "'," + iDataSourceFromList + ")>预览</a></td>");
                if (userid.toLowerCase() == "master") {
                    $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'design','" + reportType + "'," + iDataSourceFromList + ")>设计</a></td>");
                }
            },
            PrintClick: function (obj, irecno, otype, reportType, iDataSourceFromList) {
                var selectedkey = FormList.GetSelectedKeys();
                if (selectedkey.length == 0) {
                    MessageShow('未选择数据', '未选择任务行！');
                    obj.href = "#";
                    obj.target = "";
                    return;
                }
                else {
                    /*if (selectedkey.indexOf(',') > -1) {
                    MessageShow("一次只能打印一条", "一次只能打印一条记录！");
                    obj.href = "#";
                    obj.target = "";
                    return;
                    }
                    else {*/
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
                                    //                                var url = "/Base/PbPageNew.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys() + "&" + urlParams + "&FormListFileName=" + fileName + filters;
                                    //                                if (otype != "print") {
                                    //                                    window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                                    //                                }
                                    //                                else {
                                    //                                    obj.href = url;
                                    //                                }                                    
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
                                        case "textbox": value = $(ele).textbox("getValue"); break;
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
                        var url = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys() + "&" + urlParams + "&FormListFileName=" + fileName + "&" + filters;
                        //alert(url);
                        obj.href = url;


                    }
                    else {
                        //                        $.messager.progress({ title: "正在准备打印数据，请稍等..." });
                        //                        var data = $("#dg").datagrid("getData");
                        //                        var url = '/Base/Handler/DataGridToJson.ashx'; //如果为asp注意修改后缀
                        //                        $.ajax({
                        //                            url: url,
                        //                            data: { data: JSON2.stringify(data.rows), title: getQueryString('FormID'), pbRecNo: irecno },
                        //                            type: 'POST',
                        //                            dataType: 'text',
                        //                            async: false,
                        //                            success: function (fn) {
                        //                                filters = filters == "" ? "" : "&" + filters;
                        //                                var fileName = fn;
                        //                                if (fileName && fileName != "") {
                        //                                    fileName = fileName.substr(0, fileName.lastIndexOf("."));
                        //                                }
                        //                                var url = "/Base/PbPageNew.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys() + "&" + urlParams + "&FormListFileName=" + fileName + filters;
                        //                                if (otype != "print") {
                        //                                    window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                        //                                }
                        //                                else {
                        //                                    obj.href = url;
                        //                                }
                        //                                $.messager.progress("close");
                        //                            },
                        //                            error: function (xhr) {
                        //                                alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                        //                                $.messager.progress("close");
                        //                            }
                        //                        });
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
                                        case "textbox": value = $(ele).textbox("getValue"); break;
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
                $("#ifrFj").attr("src", "/Base/FileUpload/FileUpload.aspx?usetype=view&iformid=" + iformid + "&tablename=" + tablename + "&irecno=" + irecno + "&random=" + Math.random());
                $("#divFj").window(
                    {
                        width: 400,
                        height: 250,
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
                //options.columns = originalDataGridColumns.concat();
                var queryParm = options.queryParams;
                var conditionGUID = $("#" + this.id).attr("conditionID");
                //queryParm.dynCndnValue = record[(dynField)];
                queryParm.dynCndnValue = newValue;
                queryParm.conditionGUID = conditionGUID;
                options.queryParams = queryParm;
                dynColumns = [];
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
                            dynColumns = resultObj.tables[0];
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
                        $("#dg").datagrid(options);
                        if (isQuery == true) {
                            dynConditionGUID = conditionGUID;
                            dynConditionValue = newValue;
                            FormList.BtnSearch();
                        }
                    }
                    else {
                        MessageShow("没有对应的动态列！", "没有对应的动态列！");
                    }
                }
            },
            CalcFootData: function (data, field, otype) {
                var result = 0;
                switch (otype) {
                    case "sum":
                        {
                            for (var i = 0; i < data.length; i++) {
                                result += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                            }
                            result = result.toFixed(3);
                        } break;
                    case "avg":
                        {
                            var total = 0;
                            for (var i = 0; i < data.length; i++) {
                                total += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                            }
                            result = total / data.length;
                            result = result.toFixed(3);
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
                        sumData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "sum");
                    }
                }
                if (sumData != undefined) {
                    sumData.__isFoot = true;
                    allData.push(sumData);

                }
                //2、求平均值
                var avgData = undefined;
                for (var i = 0; i < objArr.length; i++) {
                    if (objArr[i].Type == "avg") {
                        if (avgData == undefined) {
                            avgData = {};
                        }
                        avgData[(objArr[i].Field)] = FormList.CalcFootData(data, objArr[i].Field, "avg");
                    }
                }
                if (avgData != undefined) {
                    avgData.__isFoot = true;
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
                    allData.push(minData);
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
                $.messager.progress({ title: "正在准备导出数据，请稍等..." });
                //getExcelXML有一个JSON对象的配置，配置项看了下只有title配置，为excel文档的标题
                var data = $('#dg').datagrid('getExcelXml', { title: 'Sheet1' }); //获取datagrid数据对应的excel需要的xml格式的内容
                //用ajax发动到动态页动态写入xls文件中
                var url = '/Base/Handler/DataGridToExcel.ashx'; //如果为asp注意修改后缀
                $.ajax({ url: url, data: { data: data, title: getQueryString('MenuTitle') }, type: 'POST', dataType: 'text',
                    success: function (fn) {
                        //alert('导出excel成功！');
                        //window.location = fn; //执行下载操作
                        $("#ifrpb").attr("src", fn);
                        $.messager.progress("close");
                    },
                    error: function (xhr) {
                        alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                        $.messager.progress("close");
                    }
                });
                return false;
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
            }
        };
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

        if (myBrowser() != "IE") {
            loadCSS("/Base/js/StimulsoftReport2017.1.4/Libs/JS/css/stimulsoft.viewer.office2013.whiteblue.css");
            loadCSS("/Base/js/StimulsoftReport2017.1.4/Libs/JS/css/stimulsoft.designer.office2013.whiteblue.css");
            loadJS("/Base/js/StimulsoftReport2017.1.4/Libs/JS/Scripts/stimulsoft.reports.js");
            setTimeout(function () { loadJS("/Base/js/StimulsoftReport2017.1.4/Libs/JS/Scripts/stimulsoft.viewer.js"); }, 2000);
            setTimeout(function () { loadJS("/Base/js/StimulsoftReport2017.1.4/Libs/JS/Scripts/stimulsoft.designer.js"); }, 2000);
            setTimeout(function () { loadJS("/Base/JS2/StimulsoftReport1.js?r=" + Math.random()); }, 3000);

        }
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
            var content = "<a href=\"#\" style=\"text-decoration:none;\" title=\"" + value + "\" class=\"easyui-tooltip\">" + value + "</a>";
            return content;
        }
    </script>
    <style type="text/css">
        .atooltip
        {
            text-decoration: none;
        }
        body
        {
            font-family: Verdana;
        }
        .tabprint
        {
        }
        .tabprint tr td
        {
            height: 25px;
            padding: 5px;
            font-weight: bold;
        }
        .datagridRowStyle
        {
            height: 30px;
            font-size: 14px;
            font-family: Verdana;
            background-color: Red;
        }
        .datagrid-row
        {
            height: 32px;
            font-family: Verdana;
        }
        .txbRight
        {
            border: none;
            border-bottom: 1px solid #95B8E7;
            height: 22px;
            width: 120px;
        }
        .btn-separator
        {
            height: 30px;
            border-left: 1px solid #a0a0a0;
            border-right: 1px solid #a0a0a0;
            margin: 1px 2px;
            display: inline;
        }
        .tree-node
        {
            /*height: 18px;*/
            height: 22px;
            padding-top: 4px;
            vertical-align: middle;
            white-space: nowrap;
            cursor: pointer;
            border-bottom: 1px solid #cccccc;
        }
        
        .button
        {
            display: inline-block;
            outline: none;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            /*font: 14px/100% 'Microsoft yahei' ,Arial, Helvetica, sans-serif;*/
            font-size:14px;
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
        .button:hover
        {
            text-decoration: none;
        }
        .button:active
        {
            position: relative;
            top: 1px;
        }
        
        /* orange */
        .orange
        {
            /*color: #fef4e9;*/
            color: #ffffff;
            border: solid 1px #da7c0c;
            background: #f78d1d;
            background: -webkit-gradient(linear, left top, left bottom, from(#faa51a), to(#f47a20));
            background: -moz-linear-gradient(top,  #faa51a,  #f47a20);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#faa51a', endColorstr='#f47a20');
        }
        .orange:hover
        {
            background: #f47c20;
            background: -webkit-gradient(linear, left top, left bottom, from(#f88e11), to(#f06015));
            background: -moz-linear-gradient(top,  #f88e11,  #f06015);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f88e11', endColorstr='#f06015');
        }
        .orange:active
        {
            /*color: #fcd3a5;*/
            color: #ffffff;
            background: -webkit-gradient(linear, left top, left bottom, from(#f47a20), to(#faa51a));
            background: -moz-linear-gradient(top,  #f47a20,  #faa51a);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f47a20', endColorstr='#faa51a');
        }
        
        .assQueryBtn
        {
            font-size: 14px;
            color: red;
        }
        .assQueryBtn:hover
        {
            /*text-decoration: none;*/
            color: red;
        }
        .button:active
        {
            /*text-decoration: none;*/
            color: red;
        }
    </style>
</head>
<body id="content" class="easyui-layout" data-options="border:false">
    <div id="panel" class="easyui-layout" data-options="fit:true,border:true">
        <div data-options="region:'north',split:false,border:false" style="padding-left: 5px;
            padding-top: 3px; height: 70px" id="divNorth">
            <div style="vertical-align: middle">
                <img alt="" src="JS/easyui/themes/icons/search.png" />查询条件
                <hr />
            </div>
            <div style="float: left;">
                <form id="form1" method="post">
                <table id="tabConditions" style="margin-left: 35px;">
                </table>
                </form>
            </div>
            <div id="divSearch">
                <%--<a href="javascript:void(0)" onclick="FormList.BtnSearch()" class="easyui-linkbutton"
                    data-options="iconCls:'icon-search'">查询</a>--%>
                <%--<a href="javascript:void(0)" onclick="FormList.BtnSearch()" class="button orange">查询</a>--%>
            </div>
        </div>
        <div data-options="region:'west'" style="width: 200px;" id="divWest" style="padding: 5px;">
            <div>
                <ul id="tree">
                </ul>
            </div>
        </div>
        <div data-options="region:'center',border:true" id="divCenter" style="padding: 5px;">
            <div id="toolbar" style="padding: 3px;">
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
        <div id="divlogin" style="width: 250px; text-align: center;" class="easyui-window"
            data-options="title:'重新登录',minimizable:false,maximizable:false,modal:true" style="display: none;">
            <table style="margin: auto;">
                <tr>
                    <td style="text-align: left; height: 30px;">
                        用户名：
                    </td>
                    <td>
                        <input id="txbReLoginUserID" type="text" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: left; height: 30px;">
                        密码：
                    </td>
                    <td>
                        <input id="txbReLoginPsd" type="password" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="height: 40px">
                        <input id="Button1" type="button" value="确定" onclick="FormList.ReLogin()" style="width: 50px;
                            height: 25px;" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="divPb" style="display: none;">
            <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
        </div>
        <div id="divPrint">
            <div style="padding: 3px; height: 300px; overflow: auto; width: 103%;">
                <table id="tabPrint" class="tabprint">
                </table>
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
        <div id="divPushConfirm" style="display: none;">
        </div>
        <div id="divlookUp" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: true, cache: false,
     maximizable: true,resizable: true,onBeforeOpen:lookUp.onBeforeOpen,onBeforeClose:lookUp.onBeforeClose,onBeforeDestroy:lookUp.onBeforeDestroy">
            <iframe style='margin: 0; padding: 0' id='ifrlookup' name='ifrlookup' width='100%'
                height='99.5%' frameborder='0'></iframe>
        </div>
        <div id="divImport" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="width:400,height:200,closed:true,title: '导入数据',modal: true, cache: false">
            <iframe style='margin: 0; padding: 0' id='ifrImport' name='ifrImport' width='100%'
                height='99%' frameborder='0'></iframe>
        </div>
        <div id="divImportFinishInfo" class="easyui-dialog" style="padding: 10px; margin: 0px;"
            data-options="width:400,height:220,closed:true,title: '导入信息',modal: true, cache: false">
            <p id="pImportFinishInfo">
            </p>
        </div>
    </div>
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
</body>
</html>
