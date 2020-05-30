<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>表单列配置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/SysQueryWinCnfigNewChart.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var MainFields;
        var ChildFields;
        var fieldType = [
            { type: "string" }, { type: "date" }, { type: "datetime" }, { type: "number" }, { type: "bool" }, { type: "imageData" }, { type: "imageUrl" }, { type: "附件" }
        ];
        var fieldAlign = [
            { text: "左对齐", value: "left" }, { text: "居中", value: "center" }, { text: "右对齐", value: "right" }
        ];
        $.ajax({
            url: "/Base/Handler/sysHandler.ashx",
            type: "post",
            async: false,
            cache: false,
            data: { otype: "getmainsqlfield", iformid: getQueryString("iformid") },
            success: function (data) {
                try {
                    MainFields = JSON2.parse(data);
                }
                catch (e) {
                    MainFields = [];
                }
            },
            error: function (data) {
                var error = data.responseText;
            }
        });
        $.ajax({
            url: "/Base/Handler/sysHandler.ashx",
            type: "post",
            async: false,
            cache: false,
            data: { otype: "getdetailsqlfield", iformid: getQueryString("iformid") },
            success: function (data) {
                try {
                    ChildFields = JSON2.parse(data);
                }
                catch (e) {
                    ChildFields = [];
                }
            },
            error: function (data) {
                var error = data.responseText;
            }
        });

        $(function () {
            $("#dg").datagrid({
                fit: true,
                //border: false,
                remoteSort: false,
                rownumbers: true,
                checkOnSelect: false,
                frozenColumns: [
                    [
                        { checkbox: true, field: '__ck', width: 30 },
                        { field: "iShowOrder", title: "序号", width: 40, hidden: true, editor: { type: "numberspinner" }, sortable: true, align: "center" },
                        {
                            field: "isChild", title: "明细字段", width: 60, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (value != undefined && (value == "1" || value.toLowerCase() == "true")) {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "sFieldsName", title: "字段名", width: 120, editor: {
                                type: "combobox", options: {
                                    valueField: "Name", textField: "Name", data: MainFields
                                }
                            }, sortable: true, align: "left"
                        },
                        { field: "sExpression", title: "表达式", width: 200, editor: { type: "textarea" }, sortable: true, align: "left" },
                        {
                            field: "sFieldsdisplayName", title: "显示名称", width: 100, editor: { type: "text" }, sortable: true, align: "left",
                            formatter: function (value, row, index) {
                                if (value != null && value != undefined) {
                                    return value.replace(/</g, "&lt;").replace(/>/g, "&gt;");
                                }
                            }
                        }
                    ]
                ],
                columns: [
                    [

                        {
                            field: "sFieldsType", title: "字段类型", width: 70, editor: {
                                type: "combobox", options: {
                                    valueField: "type", textField: "type", data: fieldType
                                }
                            }, sortable: true, align: "center"
                        },
                        { field: "iWidth", title: "列宽", width: 70, editor: { type: "numberspinner" }, sortable: true, align: "center" },
                        {
                            field: "sAlign", title: "对齐方式", width: 60, editor: {
                                type: "combobox", options: {
                                    valueField: "value", textField: "text", data: fieldAlign
                                }
                            }, sortable: true, align: "center", formatter: function (value, row, index) {
                                for (var i = 0; i < fieldAlign.length; i++) {
                                    if (fieldAlign[i].value == row.sAlign) {
                                        return fieldAlign[i].text;
                                    }
                                }
                            }
                        },
                         {
                             field: "iHide", title: "隐藏", width: 40, editor: { type: "checkbox", options: { on: "1", off: "" } },
                             formatter: function (value, row, index) {
                                 if (value == "1") {
                                     return "√";
                                 }
                                 return "";
                             }, sortable: true, align: "center"
                         },
                        { field: "sHideSql", title: "隐藏条件(SQL)", width: 200, editor: { type: "textarea" }, sortable: true, align: "center" },
                        {
                            field: "iEdit", title: "编辑", width: 40, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        { field: "sSummary", title: "汇总", width: 100, editor: { type: "textarea" }, sortable: true, align: "center" },
                        { field: "iSummryDigit", title: "汇总<br />小数位数", width: 50, editor: { type: "numberspinner" }, sortable: true, align: "center" },
                        {
                            field: "iSort", title: "可排序", width: 60, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "ifix", title: "固定列", width: 60, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "iTooltip", title: "显示<br />tooltip", width: 50, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "iGroup", title: "分组列", width: 60, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "iMerge", title: "合并", width: 40, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        {
                            field: "iApp", title: "App", width: 40, editor: { type: "checkbox", options: { on: "1", off: "" } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        { field: "sLinkMenuParam", title: "关联表单", width: 200, editor: { type: "textarea" }, sortable: true, align: "center" },
                        { field: "sClickScript", title: "自定义脚本", width: 200, editor: { type: "textarea" }, sortable: true, align: "center" },
                        { field: "sStyle", title: "样式", width: 200, editor: { type: "textarea" }, sortable: true, align: "center" }
                    ]
                ],
                onClickCell: f_clickRowCell,
                //                onEndEdit: f_endEdit,
                onBeginEdit: f_beginEdit,
                toolbar: [
                    {
                        iconCls: "icon-add",
                        text: "增加行",
                        handler: function () {
                            var cGUID = NewGuid();
                            var rows = $("#dg").datagrid("getRows");
                            var nextOrder = rows.length == 0 ? 1 : parseInt(rows[rows.length - 1].iShowOrder) + 1;
                            var newRow = { iShowOrder: nextOrder, GUID: cGUID, sFieldsType: "string", iApp: "1", __hxstate: "add" };
                            $("#dg").datagrid("appendRow", newRow);
                            $("#dg").datagrid("checkRow", rows.length - 1);

                        }
                    },
                    {
                        iconCls: "icon-add",
                        text: "加入全部主表字段",
                        handler: function () {
                            var rows = $("#dg").datagrid("getRows");
                            for (var i = 0; i < MainFields.length; i++) {
                                var cGUID = NewGuid();
                                var nextOrder = rows.length == 0 ? 1 : parseInt(rows[rows.length - 1].iShowOrder) + i + 1;
                                var newRow = {
                                    iShowOrder: nextOrder, GUID: cGUID, sFieldsName: MainFields[i].Name,
                                    sExpression: MainFields[i].Name, sFieldsType: "string", iApp: "1", __hxstate: "add"
                                };
                                $("#dg").datagrid("appendRow", newRow);
                                $("#dg").datagrid("checkRow", rows.length - 1);
                            }

                        }
                    },
                    {
                        iconCls: "icon-add",
                        text: "加入全部子表字段",
                        handler: function () {
                            var rows = $("#dg").datagrid("getRows");
                            for (var i = 0; i < ChildFields.length; i++) {
                                var cGUID = NewGuid();
                                var nextOrder = rows.length == 0 ? 1 : parseInt(rows[rows.length - 1].iShowOrder) + i + 1;
                                var newRow = {
                                    iShowOrder: nextOrder,
                                    GUID: cGUID, isChild: 1, sFieldsName: ChildFields[i].Name,
                                    sExpression: ChildFields[i].Name,
                                    sFieldsType: "string", iApp: "1", __hxstate: "add"
                                };
                                $("#dg").datagrid("appendRow", newRow);
                                $("#dg").datagrid("checkRow", rows.length - 1);
                            }

                        }
                    },
                    {
                        iconCls: "icon-remove",
                        text: "删除行",
                        handler: function () {
                            var selectedRows = $("#dg").datagrid("getChecked");
                            if (selectedRows.length > 0) {
                                $.messager.confirm("确认删除吗？", "确认删除选择的行吗？", function (r) {
                                    if (r) {
                                        var selectedRows = $("#dg").datagrid("getChecked");
                                        for (var i = 0; i < selectedRows.length; i++) {
                                            var index = $('#dg').datagrid('getRowIndex', selectedRows[i]);
                                            var deleteKey = $("#dg").attr("deleteKey");
                                            if (deleteKey) {
                                                deleteKey += "'" + selectedRows[i].GUID + "',";
                                                $("#dg").attr("deleteKey", deleteKey);
                                            } else {
                                                $("#dg").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                            }
                                            $("#dg").datagrid("deleteRow", index);
                                        }
                                    }
                                });

                            }
                        }
                    },
                    {
                        iconCls: "icon-preview",
                        text: "上移",
                        handler: function () {
                            MoveUp();
                        }
                    },
                    {
                        iconCls: "icon-next",
                        text: "下移",
                        handler: function () {
                            MoveDown();
                        }
                    },
                    {
                        iconCls: "icon-copy",
                        text: "从...复制",
                        handler: function () {
                            f_copy();
                        }
                    }/*,
                    {
                        iconCls: "icon-save",
                        text: "保存",
                        handler: function () {
                            f_save();
                        }
                    }*/
                ],
                onLoadSuccess: function () {
                    $('#dg').datagrid('fixRowHeight');
                }
            });

            $("#tabAppStyle").datagrid(
                {
                    fit: true,
                    //border: false,
                    remoteSort: false,
                    rownumbers: true,
                    checkOnSelect: false,
                    columns: [
                    [
                        { checkbox: true, field: '__ck', width: 30 },
                        { field: "iSerial", title: "序号", width: 40, editor: { type: "numberspinner" }, align: "center" },
                        {
                            field: "iDetail", title: "明细字段", width: 60, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (value != undefined && (value == "1" || value.toLowerCase() == "true")) {
                                    return "√";
                                }
                                return "";
                            }, sortable: true, align: "center"
                        },
                        { field: "sStyle", title: "样式代码", width: 400, editor: { type: "textarea" }, align: "center" },
                        { field: "sSummaryName", title: "汇总名称", width: 100, editor: { type: "text" }, align: "center" },
                        { field: "sSortFields", title: "排序字段", width: 100, editor: { type: "textarea" }, align: "center" },
                        { field: "sGroupFields", title: "分组字段", width: 100, editor: { type: "textarea" }, align: "center" },
                        { field: "sTableName", title: "表名", width: 100, editor: { type: "text" }, align: "center" },
                        { field: "sRemark", title: "备注", width: 200, editor: { type: "textarea" }, align: "center" }
                    ]
                    ],
                    onClickCell: f_clickRowCell1,
                    //                onEndEdit: f_endEdit,
                    onBeginEdit: f_beginEdit1,
                    toolbar: [
                    {
                        iconCls: "icon-add",
                        text: "增加行",
                        handler: function () {
                            var cGUID = NewGuid();
                            var rows = $("#tabAppStyle").datagrid("getRows");
                            var nextOrder = rows.length == 0 ? 1 : parseInt(rows[rows.length - 1].iSerial) + 1;
                            var newRow = { iSerial: nextOrder, GUID: cGUID, __hxstate: "add" };
                            $("#tabAppStyle").datagrid("appendRow", newRow);
                            //$("#tabAppStyle").datagrid("checkRow", rows.length - 1);
                        }
                    },
                    {
                        iconCls: "icon-remove",
                        text: "删除行",
                        handler: function () {
                            var selectedRows = $("#tabAppStyle").datagrid("getChecked");
                            if (selectedRows.length > 0) {
                                $.messager.confirm("确认删除吗？", "确认删除选择的行吗？", function (r) {
                                    if (r) {
                                        var selectedRows = $("#tabAppStyle").datagrid("getChecked");
                                        for (var i = 0; i < selectedRows.length; i++) {
                                            var index = $('#tabAppStyle').datagrid('getRowIndex', selectedRows[i]);
                                            var deleteKey = $("#tabAppStyle").attr("deleteKey");
                                            if (deleteKey) {
                                                deleteKey += "'" + selectedRows[i].GUID + "',";
                                                $("#tabAppStyle").attr("deleteKey", deleteKey);
                                            } else {
                                                $("#tabAppStyle").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                            }
                                            $("#tabAppStyle").datagrid("deleteRow", index);
                                        }
                                    }
                                });
                            }
                        }
                    }
                    ]
                }
                )
            PageInit();


        });
        var editIndex = undefined;
        var clickIndex = undefined;
        var clickField = undefined;
        var editField = undefined;
        function f_clickRowCell(rowIndex, field, value) {
            clickField = field;
            clickIndex = rowIndex;
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
                    if (ed.type == "combobox") {
                        $($(ed.target).combobox("textbox")).focus();
                        $($(ed.target).combobox("textbox")).select();
                    }
                    if (ed.type == "numberbox") {
                        $($(ed.target).numberbox("textbox")).focus();
                        $($(ed.target).numberbox("textbox")).select();
                    }
                    if (ed.type == "numberspinner") {
                        $($(ed.target).numberspinner("textbox")).focus();
                        $($(ed.target).numberspinner("textbox")).select();
                    }
                }
            }
            editIndex = rowIndex;
        }
        function f_beginEdit(index, row) {
            var theRow = $("#dg").datagrid("getRows")[clickIndex];
            if (clickField == "sFieldsName") {
                var editors = $("#dg").datagrid("getEditors", clickIndex);
                if (theRow.isChild == "True" || theRow.isChild == "1") {
                    for (var i = 0; i < editors.length; i++) {
                        if (editors[i].field == "sFieldsName") {
                            $(editors[i].target).combobox('loadData', ChildFields);
                            break;
                        }
                    }
                }
                else {
                    for (var i = 0; i < editors.length; i++) {
                        if (editors[i].field == "sFieldsName") {
                            $(editors[i].target).combobox('loadData', MainFields);
                            break;
                        }
                    }
                }
            }

            if (editField == "sFieldsName") {
                var theRow = $("#dg").datagrid("getRows")[editIndex];
                if (theRow.sExpression == "" || theRow.sExpression == undefined) {
                    var uRow = {};
                    uRow.sExpression = theRow.sFieldsName;
                    $("#dg").datagrid("updateRow", { index: editIndex, row: uRow });
                }
            }
            editField = clickField;
        }
        function f_endEdit(index, row, changes) {

        }

        var editIndex1 = undefined;
        var clickIndex1 = undefined;
        var clickField1 = undefined;
        var editField1 = undefined;
        function f_clickRowCell1(rowIndex, field, value) {
            clickField1 = field;
            clickIndex1 = rowIndex;
            if (editIndex1 == undefined) {
                $("#tabAppStyle").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#tabAppStyle").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#tabAppStyle").datagrid('endEdit', editIndex1);
                $('#tabAppStyle').datagrid('unselectRow', editIndex1);
                $("#tabAppStyle").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#tabAppStyle").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    //var target = ed.target;
                    $(ed.target).focus();
                    $(ed.target).select();
                    if (ed.type == "combobox") {
                        $($(ed.target).combobox("textbox")).focus();
                        $($(ed.target).combobox("textbox")).select();
                    }
                    if (ed.type == "numberbox") {
                        $($(ed.target).numberbox("textbox")).focus();
                        $($(ed.target).numberbox("textbox")).select();
                    }
                    if (ed.type == "numberspinner") {
                        $($(ed.target).numberspinner("textbox")).focus();
                        $($(ed.target).numberspinner("textbox")).select();
                    }
                }
            }
            editIndex1 = rowIndex;
        }
        function f_beginEdit1(index, row) {
            //            var theRow = $("#tabAppStyle").datagrid("getRows")[clickIndex1];
            //            if (clickField1 == "sFieldsName") {
            //                var editors = $("#tabAppStyle").datagrid("getEditors", clickIndex1);
            //                if (theRow.isChild == "True" || theRow.isChild == "1") {
            //                    for (var i = 0; i < editors.length; i++) {
            //                        if (editors[i].field == "sFieldsName") {
            //                            $(editors[i].target).combobox('loadData', ChildFields);
            //                            break;
            //                        }
            //                    }
            //                }
            //                else {
            //                    for (var i = 0; i < editors.length; i++) {
            //                        if (editors[i].field == "sFieldsName") {
            //                            $(editors[i].target).combobox('loadData', MainFields);
            //                            break;
            //                        }
            //                    }
            //                }
            //            }

            //            if (editField == "sFieldsName") {
            //                var theRow = $("#tabAppStyle").datagrid("getRows")[editIndex];
            //                if (theRow.sExpression == "" || theRow.sExpression == undefined) {
            //                    theRow.sExpression = theRow.sFieldsName;
            //                    $("#tabAppStyle").datagrid("updateRow", { index: editIndex, row: theRow });
            //                }
            //            }
            //            editField1 = clickField1;
        }
        function f_endEdit1(index, row, changes) {

        }


        function PageInit() {
            var iformid = getQueryString("iformid");
            var jsonfiltertabledata = [
            {
                "Field": "iFormID",
                "ComOprt": "=",
                "Value": "'" + iformid + "'"
            }
            ]
            var jsonobjtabledata = {
                "TableName": "bscDataQueryM",
                "Fields": "*",
                "SelectAll": "True",
                "Filters": jsonfiltertabledata
            }
            var mainData = SqlGetData(jsonobjtabledata);
            if (mainData.length > 0) {
                $("#FieldKeyValue").val(mainData[0].iRecNo);
                mainData[0].iShowChart = mainData[0].iShowChart == "1" ? "on" : "";
                mainData[0].iLineChart = mainData[0].iLineChart == "1" ? "on" : "";
                mainData[0].iColumnChart = mainData[0].iColumnChart == "1" ? "on" : "";
                mainData[0].iPieChart = mainData[0].iPieChart == "1" ? "on" : "";
                mainData[0].iRadio = mainData[0].iRadio == "1" ? "on" : "";
                mainData[0].iAppAss = mainData[0].iAppAss == "1" ? "on" : "";
                mainData[0].iShowQuickQueryBar = mainData[0].iShowQuickQueryBar == "1" ? "on" : "";
                mainData[0].iFormatNumber = mainData[0].iFormatNumber == "1" ? "on" : "";
                mainData[0].iFormatNumberScale = mainData[0].iFormatNumberScale == "1" ? "on" : "";
                mainData[0].iForceDecimals = mainData[0].iForceDecimals == "1" ? "on" : "";
                mainData[0].iAcrossQuery = mainData[0].iAcrossQuery == "1" ? "on" : "";
                mainData[0].iNewChart = mainData[0].iNewChart == "1" ? "on" : "";
                mainData[0].iChartType = mainData[0].iChartType == "1" ? "on" : "";
                mainData[0].iShowValue = mainData[0].iShowValue == "1" ? "on" : "";
                mainData[0].iLineSmooth = mainData[0].iLineSmooth == "1" ? "on" : "";
                mainData[0].iLineArea = mainData[0].iLineArea == "1" ? "on" : "";
                mainData[0].iBarStack = mainData[0].iBarStack == "1" ? "on" : "";
                mainData[0].iHideX = mainData[0].iHideX == "1" ? "on" : "";
                mainData[0].iHideY = mainData[0].iHideY == "1" ? "on" : "";
                mainData[0].iHideXGrid = mainData[0].iHideXGrid == "1" ? "on" : "";
                mainData[0].iHideYGrid = mainData[0].iHideYGrid == "1" ? "on" : "";

                $("#form1").form("load", mainData[0]);
                $("#form2").form("load", mainData[0]);
                $("#form3").form("load", mainData[0]);
                $("#form4").form("load", mainData[0]);
                $("#form5").form("load", mainData[0]);
                $("#form6").form("load", mainData[0]);
                //alert(mainData[0].sChartType);
                $("#txbChartType").combobox("setValues", mainData[0].sChartType ? mainData[0].sChartType.split(",") : []);
                var gridData = getGridData(mainData[0].iRecNo);
                var gridDataFull = { rows: gridData, total: gridData.length };
                $("#dg").datagrid("loadData", gridDataFull);

                var sqlObj1 = {
                    TableName: "bscDataQueryDAppStyle",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "'" + mainData[0].iRecNo + "'"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "iSerial",
                            SortOrder: "asc"
                        }
                    ]
                }
                var result1 = SqlGetData(sqlObj1);
                if (result1.length > 0) {
                    $("#tabAppStyle").datagrid("loadData", result1);
                }
            }
            else {
                $("#ExtTextBox9").textbox("setValue", getQueryString("iformid"));
            }
        }
        function getGridData(iRecNo) {
            var jsonchildfilter1 = [{
                "Field": "iMainRecNo",
                "ComOprt": "=",
                "Value": "'" + iRecNo + "'"
            }]
            var jsonchildsort1 = [
                    {
                        SortName: "isnull(iHide,0)",
                        SortOrder: "asc"
                    },
                    {
                        "SortName": "iShowOrder",
                        "SortOrder": "asc"
                    }

            ]
            var jsonchild1 = {
                "TableName": "bscDataQueryD",
                "Fields": "*",
                "SelectAll": "True",
                "Filters": jsonchildfilter1,
                "Sorts": jsonchildsort1
            }
            var gridData = SqlGetData(jsonchild1);
            return gridData;
        }

        //上移
        function MoveUp() {
            var rows = $("#dg").datagrid('getChecked');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#dg").datagrid('getRowIndex', rows[i]);
                $("#dg").datagrid("endEdit", index);
                mysort(index, 'up', 'dg');
            }
        }
        //下移
        function MoveDown() {
            var rows = $("#dg").datagrid('getChecked');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#dg").datagrid('getRowIndex', rows[i]);
                $("#dg").datagrid("endEdit", index);
                mysort(index, 'down', 'dg');
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

        function f_save() {
            if (editIndex != undefined) {
                $("#dg").datagrid("endEdit", editIndex);
            }

            var rows = $("#dg").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                rows[i].iShowOrder = i + 1;
                //                $("#dg").datagrid("updateRow", {
                //                    index: i,
                //                    row: rows[i]
                //                });
            }

            var iRecNo = $("#FieldKeyValue").val();
            if (iRecNo != "") {
                var sqlObj = {
                    TableName: "bscDataQueryM",
                    Fields: "1",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + iRecNo + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    var iRecNoResult = Form.__update(iRecNo, "/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (iRecNoResult.indexOf("error:") > -1) {
                        $.messager.alert("失败", iRecNoResult);
                    }
                    else {
                        $.messager.alert("成功", "保存成功");
                        $("#tabAppStyle").removeAttr("deleteKey");
                        $("#dg").removeAttr("deleteKey");
                        var data1 = $("#tabAppStyle").datagrid("getRows");
                        for (var i = 0; i < data1.length; i++) {
                            delete data1[i].__hxstate;
                        }
                        var data2 = $("#dg").datagrid("getRows");
                        for (var i = 0; i < data2.length; i++) {
                            delete data2[i].__hxstate;
                        }
                    }
                }
            }
            else {
                $("#FieldKeyValue").val(getChildID("bscDataQueryM"));
                var iRecNoResult = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (iRecNoResult.indexOf("error:") > -1) {
                    $.messager.alert("失败", iRecNoResult);
                }
                else {
                    $.messager.alert("成功", "保存成功");

                }
            }
        }

        function f_copy() {
            $.messager.prompt("请输入要复制的表单ID", "请输入要复制的formid", function (r) {
                if (r) {
                    $.ajax({
                        url: "/Base/Handler/sysHandler.ashx",
                        type: "post",
                        async: false,
                        cache: false,
                        data: { otype: "columnsDefineCopy", toformid: getQueryString("iformid"), fromformid: r },
                        success: function (data) {
                            if (resultstr == "1") {
                                $.messager.alert("成功", "复制成功");
                                PageInit();
                            }
                            else {
                                $.messager.alert("失败", data);
                            }
                        },
                        error: function (data) {
                            $.messager.alert("失败", data.responseText);
                        }
                    });
                }
            });
        }

        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }

        function NewGuid_S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function NewGuid() {
            return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
        }

        function getChildID(tablename) {
            var jsonobj = {
                StoreProName: "SpGetIden",
                StoreParms: [{
                    ParmName: "@sTableName",
                    Value: tablename
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
        var lastIndex = null;
        function tabSelect(title, index) {
            if (title == "保存") {
                f_save();
                $("#ttTop").tabs("select", lastIndex);
                return;
            }
            lastIndex = index;
        }
    </script>
    <style type="text/css">
        .textarea {
            border: solid 1px #95b8e7;
            overflow: auto;
            border-radius: 5px;
        }

        .txbreadonly {
            background-color: #ffffaa;
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }

        .txb {
            border: solid 1px #95b8e7;
            border-radius: 5px;
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false" style="font-family: Verdana;">
    <div id="ttTop" class="easyui-tabs" data-options="fit:true,border:false,tools:[{iconCls:'icon-save',handler:f_save}],onSelect:tabSelect">
        <div title="列定义">
            <div class="easyui-layout" data-options="border:false,fit:true" style="font-family: Verdana;">
                <div data-options="region:'north',border:false" style="height: 90px;">
                    <form id="form1" method="post">
                        <div style="display: none;">
                            <input type="hidden" id="TableName" value="bscDataQueryM" />
                            <!--要保存的表名-->
                            <input type="hidden" id="FieldKey" value="iRecNo" />
                            <!--表的主键字段-->
                            <input type="hidden" id="FieldKeyValue" value="" />
                        </div>
                        <table>
                            <tr>
                                <td colspan="4">FormID<cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iFormID" />
                                    &nbsp;&nbsp;
                                <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" Z_FieldID="iAcrossQuery" />
                                    <label for="ExtCheckbox11">启用二维表单（交叉查询）</label>
                                </td>
                            </tr>
                            <tr>
                                <td>固定列（逗号分隔）
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sFixFields" Style="width: 250px" />
                                </td>
                                <td>默认固定列（逗号分隔）
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sFixDefaultFields" Style="width: 200px" />
                                </td>
                            </tr>
                            <tr>
                                <td>横向列（逗号分隔）
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sTransverseField" Style="width: 250px" />
                                </td>
                            </tr>

                        </table>
                    </form>
                </div>
                <div data-options="region:'center',border:false">
                    <table id="dg" isson="true" tablename="bscDataQueryD" linkfield="iRecNo=iMainRecNo"
                        fieldkey="GUID">
                    </table>
                </div>
            </div>
        </div>
        <div title="分组项设置">
            <form id="form2">
                <table>
                    <tr>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" Z_FieldID="iRadio" />
                            <label for="ExtCheckbox5">
                                分组项单选</label>
                        </td>
                    </tr>
                    <tr>
                        <td>汇总处理字段
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sOprateFields" runat="server" Height="100px"
                                Width="350px" />
                        </td>
                    </tr>
                    <tr>
                        <td>分组项隐藏字段<br />
                            (用&quot;,&quot;隔开)
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea4" Z_FieldID="sHideGroupFields" runat="server" Height="100px"
                                Width="350px" title="多个字段用,隔开" />
                        </td>
                    </tr>
                    <tr>
                        <td>分组项成组字段<br />
                            (成组用";"隔开，<br />
                            组字段用","隔开)
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea5" Z_FieldID="sGroupFieldsClass" runat="server" Height="100px" title="(成组用';'隔开，组字段用','隔开)"
                                Width="350px" />
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div title="图表设置">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false">
                    <form id="form6">
                        <table>
                            <tr>
                                <td>图表SQL
                                </td>
                                <td colspan="3">
                                    <cc1:ExtTextArea2 ID="ExtTextArea10" title="默认与SQL语句相同" runat="server" Z_FieldID="sChartSql"
                                        Style="width: 500px; height: 50px;" />
                                </td>
                                <td colspan="2">
                                    <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iShowChart" runat="server" />
                                    <label for="ExtCheckbox1">
                                        显示图表&nbsp;&nbsp;
                                    </label>
                                    &nbsp;&nbsp;
                                <cc1:ExtCheckbox2 ID="ExtCheckbox13" Z_FieldID="iNewChart" runat="server" />
                                    <label for="ExtCheckbox13">使用新图表</label>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>

                <div data-options="region:'center',border:false">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div title="老图表">
                            <form id="form3">
                                <div>
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iLineChart" runat="server" />
                                                <label for="ExtCheckbox2">
                                                    曲线图</label>&nbsp;&nbsp;&nbsp;
                            <cc1:ExtCheckbox2 ID="ExtCheckbox3" Z_FieldID="iColumnChart" runat="server" />
                                                <label for="ExtCheckbox3">
                                                    柱状图</label>&nbsp;&nbsp;&nbsp;
                            <cc1:ExtCheckbox2 ID="ExtCheckbox4" Z_FieldID="iPieChart" runat="server" />
                                                <label for="ExtCheckbox4">
                                                    饼状图</label>
                                            </td>
                                            <td>X轴字段/项目
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox3" Z_FieldID="sXAxis" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Y轴字段/数值项
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldID="sYAxis" runat="server" Width="200px" />
                                            </td>
                                            <td>多系列字段
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="sMultiSerialField" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>图表SQL
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea2" title="默认与SQL语句相同" runat="server" Z_FieldID="sChartSql"
                                                    Style="width: 600px; height: 180px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <fieldset>
                                    <legend>数字格式化设置</legend>
                                    <table>
                                        <tr>
                                            <td>
                                                <label for="ExtCheckbox7">
                                                    显示每根柱子值</label>
                                            </td>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox7" Z_FieldID="iShowValues" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="ExtCheckbox8">
                                                    是否格式化数值<br />
                                                    (每千位用逗号分隔)</label>
                                            </td>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox8" Z_FieldID="iFormatNumber" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="ExtCheckbox9">
                                                    是否对大数值以k,M方式表示</label>
                                            </td>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox9" Z_FieldID="iFormatNumberScale" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>设置进位规则对应的单位<br />
                                                (eg:k,m,b)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox1" Z_FieldID="sNumberScaleUnit" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>设置进位的规则<br />
                                                (eg:1000,1000,1000)
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sNumberScaleValue" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数值前缀
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox11" Z_FieldID="sNumberPrefix" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数值后缀
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox12" Z_FieldID="sNumberSuffix" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>小数点后保留几位
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" Z_FieldID="iDecimals" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label for="ExtCheckbox10">
                                                    小数位不足是否强制补0</label>
                                            </td>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox10" Z_FieldID="iForceDecimals" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>y轴值保留几位小数
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox14" Z_FieldID="iYAxisValueDecimals" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </form>
                        </div>
                        <div title="新图表">
                            <form id="form5">
                                <fieldset>
                                    <legend>公共属性</legend>
                                    <table>
                                        <tr>
                                            <td>图表类型</td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbChartType" plugin="combobox" Z_FieldID="sChartType" runat="server" />

                                            </td>
                                            <td colspan="2">
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox14" Z_FieldID="iShowValue" runat="server" />
                                                <label for="ExtCheckbox14">显示数值 位置</label>
                                                <cc1:ExtTextBox2 ID="txbValuePostion" Z_FieldID="sShowPosition" runat="server" />
                                            </td>
                                            <td>显示值<br />
                                                模板格式化
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbItemLabelFormatterSimple" title="aaaa" class="easyui-tooltip" Z_FieldID="sItemLabelFormatterSimple" runat="server" />
                                            </td>
                                            <td>tooltip模板<br />
                                                格式化
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbToolTipSimle" Z_FieldID="sItemToolTipFormatterSimple" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>显示值函数格式化
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea11" Z_FieldID="sItemLabelFormatterFn" runat="server" Style="width: 99%; height: 50px;" />
                                            </td>
                                            <td>tooltip函数格式化
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="txaToolTipFn" Z_FieldID="sItemToolTipFormatterFn" runat="server" Style="width: 99%; height: 50px;" />
                                            </td>
                                        </tr>
                                        <tr>
                                        </tr>
                                        <tr>
                                            <td>X轴(项目)字段
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox31" Z_FieldID="sXAxisField" runat="server" />
                                            </td>
                                            <td>Y轴(项目值)字段
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox32" Z_FieldID="sYAxisField" runat="server" />
                                            </td>
                                            <td>多系列<br />
                                                字段
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox33" Z_FieldID="sSerialField" runat="server" />
                                            </td>
                                            <td>X轴数值<br />
                                                模板格式化
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox34" Z_FieldID="sXAxisLabelFormatterSimple" runat="server" />
                                            </td>

                                            <td>Y轴数值<br />
                                                模板格式化
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox36" Z_FieldID="sYAxisLabelFormatterSimple" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>X轴数值<br />
                                                函数格式化
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea13" Z_FieldID="sXAxisLabelFormatterFn" Style="width: 99%; height: 60px;" runat="server" />
                                            </td>
                                            <td>Y轴数值<br />
                                                函数格式化
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea14" Z_FieldID="sYAxisLabelFormatterFn" Style="width: 99%; height: 60px;" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                <fieldset>
                                    <legend>曲线、柱状图</legend>
                                    <table>
                                        <tr>
                                            <td>曲线、柱子<br />
                                                颜色
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox24" Z_FieldID="sItemColor" runat="server" />
                                            </td>
                                            <td>曲线宽度
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbLineWidth" Z_FieldID="sLineWidth" runat="server" Z_Value="2" />
                                            </td>
                                            <td>曲线端点<br />
                                                形状
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbLineItemSymbol" Z_FieldID="sLineItemSymbol" runat="server" />
                                            </td>
                                            <td>曲线端点<br />
                                                尺寸
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbLineItemSymbolSize" Z_FieldID="sLineItemSymbolSize" Z_Value="4" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>曲线端点<br />
                                                边框宽度
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbLineItemBorderWidth" Z_FieldID="sLineItemBorderWidth" Z_Value="0" runat="server" />
                                            </td>
                                            <td>曲线端点<br />
                                                边框颜色
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox29" Z_FieldID="sLineItemBorderColor" runat="server" />
                                            </td>
                                            <td>折线端点<br />
                                                边框类型
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbLineItemBorderType" Z_FieldID="sLineItemBorderType" runat="server" />
                                            </td>
                                            <td colspan="2">
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox21" Z_FieldID="iBarStack" runat="server" />
                                                <label for="ExtCheckbox21">柱状图只显示增量</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox17" Z_FieldID="iHideX" runat="server" />
                                                <label for="ExtCheckbox17">隐藏X轴</label>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox18" Z_FieldID="iHideY" runat="server" />
                                                <label for="ExtCheckbox18">隐藏Y轴</label>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox19" Z_FieldID="iHideXGrid" runat="server" />
                                                <label for="ExtCheckbox19">隐藏X轴网格</label>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox20" Z_FieldID="iHideYGrid" runat="server" />
                                                <label for="ExtCheckbox20">隐藏Y轴网格</label>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox15" Z_FieldID="iLineSmooth" runat="server" />
                                                <label for="ExtCheckbox15">平滑曲线</label>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox16" Z_FieldID="iLineArea" runat="server" />
                                                <label for="ExtCheckbox16">面积图</label>
                                            </td>
                                            <td>面积图样式
                                            </td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea12" Z_FieldID="sAreaOptions" runat="server" Style="width: 99%; height: 50px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                <fieldset>
                                    <legend>饼图、极坐标、雷达图</legend>
                                    <table>
                                        <tr>
                                            <td>南丁格尔图模式
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbPieRoseType" Z_FieldID="sPieRoseType" runat="server" />
                                            </td>
                                            <td>饼图的半径
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox38" Z_FieldID="sPieRadius" runat="server" />
                                            </td>
                                            <td>饼图中心位置
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox22" Z_FieldID="sPieCenter" runat="server" />
                                            </td>
                                            <td>雷达图形状
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="txbRadarShape" Z_FieldID="sRadarShape" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                <fieldset>
                                    <legend>自定义代码</legend>
                                    <table>
                                        <tr>
                                            <td>自定义配置代码</td>
                                            <td colspan="3">
                                                <cc1:ExtTextArea2 ID="ExtTextArea16" Z_FieldID="sCustomerEditOption" Style="width: 600px; height: 150px;" runat="server" />
                                            </td>
                                            <%--<td>自定义代码</td>
                                            <td>
                                                <cc1:ExtTextArea2 ID="ExtTextArea17" Z_FieldID="sCustomerOption" style="width:400px; height:150px;" runat="server" />
                                            </td>--%>
                                        </tr>
                                    </table>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div title="App端设置">
            <form id="form4">
                <table>
                    <tr>
                        <td>手机显示样式
                        </td>
                        <td colspan="3">
                            <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sAppStyle" Z_Options="列表1;表格;列表;自定义;普通表格;树形表格;分组表格" />
                        </td>
                    </tr>
                    <tr>
                        <td>位置1字段(左上)
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sAppField1" />
                        </td>
                        <td>位置3字段(右上)
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sAppField3" />
                        </td>
                    </tr>
                    <tr>
                        <td>位置2字段(左下)
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sAppField2" />
                        </td>
                        <td>位置4字段(右下)
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sAppField4" />
                        </td>
                    </tr>
                    <tr>
                        <td>排序字段(最多4个,<br />
                            以";"逗号隔开)
                        </td>
                        <td colspan="3">
                            <cc1:ExtTextArea2 ID="ExtTextArea3" Style="width: 300px; height: 50px;" runat="server"
                                Z_FieldID="sAppSortFields" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox6" runat="server" Z_FieldID="iAppAss" />
                            <label for="ExtCheckbox6">
                                关联到明细</label>
                        </td>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox12" runat="server" Z_FieldID="iShowQuickQueryBar" />
                            <label for="ExtCheckbox12">
                                显示快速查询工具条</label>
                        </td>
                    </tr>
                    <tr>
                        <td>快捷查询条件名1
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sAppFiltersName1" />
                        </td>
                        <td>快捷查询条件Sql1
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea6" Style="width: 300px; height: 50px;" runat="server"
                                Z_FieldID="sAppFilters1" />
                        </td>
                    </tr>
                    <tr>
                        <td>快捷查询条件名2
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sAppFiltersName2" />
                        </td>
                        <td>快捷查询条件Sql2
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea7" Style="width: 300px; height: 50px;" runat="server"
                                Z_FieldID="sAppFilters2" />
                        </td>
                    </tr>
                    <tr>
                        <td>快捷查询条件名3
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sAppFiltersName3" />
                        </td>
                        <td>快捷查询条件Sql3
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea8" Style="width: 300px; height: 50px;" runat="server"
                                Z_FieldID="sAppFilters3" />
                        </td>
                    </tr>
                    <tr>
                        <td>快捷查询条件名4
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sAppFiltersName4" />
                        </td>
                        <td>快捷查询条件Sql4
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea9" Style="width: 300px; height: 50px;" runat="server"
                                Z_FieldID="sAppFilters4" />
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div title="App列样式定义">
            <table id="tabAppStyle" isson="true" tablename="bscDataQueryDAppStyle" linkfield="iRecNo=iMainRecNo"
                fieldkey="GUID">
            </table>
        </div>
        <div title="保存" data-options="iconCls:'icon-save'">
        </div>
    </div>
</body>
</html>
