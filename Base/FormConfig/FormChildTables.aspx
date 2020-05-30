<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>子表设置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        body {
            font-family: Verdana;
            font-size: 12px;
            margin: 0px;
            padding: 0px;
        }

        .style1 {
            text-align: left;
            height: 30px;
        }

        .tabMatch {
            margin: 0px;
            padding: 0px;
            border-collapse: collapse;
        }

            .tabMatch tr td {
            }

                .tabMatch tr td input {
                    font-size: 12px;
                    width: 150px;
                }

        .txb {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var selectedRow = undefined;
        var needRefresh = false;
        var focusText = undefined;
        var mainFields = [];
        var isInited = false;
        var lastType = 0;
        $(function () {
            var iformid = getQueryString("iformid");
            $("#Text8").textbox("setValue", iformid);
            $("#divDetail").dialog({
                modal: true,
                width: 400,
                height: 500,
                top: 20,
                left: 100,
                closable: false
            });
            $("#divColumnDetail").dialog({
                modal: true,
                width: 600,
                height: 430,
                top: 20,
                left: 100,
                closable: false
            });
            $("#divLookUp").dialog({
                modal: false,
                width: 880,
                height: 500,
                top: 30,
                left: 20,
                closable: false,
                onClose: function () {
                    $("#divLookUpDetail").dialog("close");
                }
            });
            $("#divLookUpDetail").dialog({
                modal: false,
                width: 250,
                height: 500
            });
            $("#divImport").dialog({
                modal: false,
                width: 850,
                height: 500,
                top: 50,
                left: 20,
                closable: false,
                onClose: function () {
                    $("#divLookUpDetail").dialog("close");
                    $("#divForm").dialog("close");
                }
            });
            $("#divForm").dialog({
                width: 250,
                height: 500,
                modal: false
            });
            $("#divExp").dialog(
                {
                    modal: true,
                    width: 800,
                    height: 350,
                    top: 50,
                    left: 100,
                    closable: false
                }
            );
            $("#divTabs").tabs({
                onSelect: function (title, index) {
                    if (title == "lookUp定义" || title == "导入按钮设置" || title == "公式定义") {
                        if (selectedRow) {
                            //var index = $("#tableList").datagrid("getRowIndex", selectedRow);
                            //$("#tableList").datagrid("selectRow", index);
                            $("#Text17").combogrid("grid").datagrid("loadData", getLookUpName())
                        }
                    }
                    if (title == "lookUp定义") {
                        bindLookCombox('Text17', 30, 902, 250, 500);
                    }
                    if (title == "导入按钮设置") {
                        bindFormCombox('Text29', 50, 870, 250, 500);
                    }
                }
            });
            $("#divDetail").dialog("close");
            $("#divColumnDetail").dialog("close");
            $("#divLookUp").dialog("close");
            $("#divImport").dialog("close");
            $("#divExp").dialog("close");
            $("#divLookUpDetail").dialog("close");
            $("#divForm").dialog("close");
            //子表表格
            $("#tableList").datagrid({
                fit: true,
                idField: "iRecNo",
                columns: [[
                    { field: 'iSerial', title: '序号', width: 40 },
                    { field: 'sTableName', title: '表名', width: 200 },
                //                    { field: 'sTitle', title: '标题', width: 100 },
                    { field: 'sFieldKey', title: '主键', width: 100 },
                    { field: 'sSql', title: 'Sql语句', width: 550 },
                    { field: 'sLinkField', title: '对应字段', width: 150 },
                //{ field: 'sFixFields', title: '固定列数', width: 100 },
                //{ field: 'sSumFields', title: '合计字段', width: 100 },
                    { field: 'sOrder', title: '排序', width: 100 },
                    {
                        field: 'iDisabled', title: "停用", width: 50, formatter: function (value, row, index) {
                            if (value == "1") {
                                return "是";
                            }
                            else {
                                return "否";
                            }
                        }
                    }
                ]],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "新增子表",
                        handler: function () {
                            if ($("#Text8").textbox("getValue") == "") {
                                $.messager.alert("未选择表单", "请先选择一个表单！");
                                return;
                            }
                            $("#form1").form("reset");
                            $("#form1").form("load", {
                                iSerial: "0",
                                sLinkField: "iRecNo=iMainRecNo",
                                sFieldKey: "iRecNo",
                                sOrder: "iSerial asc"
                            });
                            $("#Text7").textbox("disable");
                            $("#divDetail").dialog({
                                title: '新增子表',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            if ($("#TextArea3").val().indexOf("{condition}") == -1) {
                                                $.messager.alert("错误", "SQL语句中未包含{condition}!");
                                                return;
                                            }
                                            var r = $("#form1").form("validate");
                                            if (r) {

                                                $("#form1").form("submit", {
                                                    url: "/Base/Handler/childTableConfigHandler.ashx",
                                                    onSubmit: function (param) {
                                                        param.from = "table";
                                                        param.otype = "add";
                                                        param.iFormid = $("#Text8").textbox("getValue");
                                                        $.messager.progress({
                                                            title: "正在保存，请稍候...",
                                                            text: "正在保存，请稍候..."
                                                        });
                                                    },
                                                    success: function (data) {
                                                        if (data.indexOf("error:") > -1) {
                                                            var message = data.substr(6, data.length - 6);
                                                            $.messager.alert("错误", message);
                                                            $.messager.progress('close');
                                                        }
                                                        else if (data == "1") {
                                                            $.messager.progress('close');
                                                            $("#divDetail").dialog("close");
                                                            refreshTableList();
                                                        }
                                                    }
                                                });
                                            }
                                        }
                                    },
                                    {
                                        text: "关闭",
                                        iconCls: "icon-no",
                                        handler: function () {
                                            $("#divDetail").dialog("close");
                                        }
                                    }
                                ]
                            })
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: "修改子表",
                        handler: function () {

                            editRow();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除子表",
                        handler: function () {
                            //var selectedRow = $("#tableList").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除子表'" + selectedRow.sTableName + "'吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form1").form("submit", {
                                            url: "/Base/Handler/childTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "table";
                                                param.otype = "remove";
                                                param.iRecNo = selectedRow.iRecNo;
                                                $.messager.progress({
                                                    title: "正在删除，请稍候...",
                                                    text: "正在删除，请稍候..."
                                                });
                                            },
                                            success: function (data) {
                                                if (data.indexOf("error:") > -1) {
                                                    var message = data.substr(6, data.length - 6);
                                                    $.messager.alert("错误", message);
                                                    $.messager.progress('close');
                                                }
                                                else if (data == "1") {
                                                    $.messager.progress('close');
                                                    $("#divDetail").dialog("close");
                                                    var index = $("#tableList").datagrid("getRowIndex", selectedRow);
                                                    refreshTableList();
                                                    if ($("#tableList").datagrid("getRows").length > index) {
                                                        $("#tableList").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableList").datagrid("getRows").length > 0) {
                                                        $("#tableList").datagrid("selectRow", $("#tableList").datagrid("getRows").length - 1);
                                                    }
                                                }
                                            }
                                        });
                                    }
                                })
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-import',
                        text: "生成列",
                        handler: function () {
                            if (selectedRow) {
                                var columnsRows = $("#tableColumn").datagrid("getRows");
                                if (columnsRows.length > 0) {
                                    $.messager.confirm("您确认生成？", "生成列将删除原来的列，你确认生成吗？", function (r) {
                                        if (r) {
                                            $.messager.progress({
                                                title: "正在生成，请稍候...",
                                                text: "正在生成，请稍候..."
                                            });
                                            var sSql = selectedRow.sSql;
                                            var iRecNo = selectedRow.iRecNo;
                                            var parms = "from=table&otype=bulidColumns&sSql=" + sSql + "&iRecNo=" + iRecNo + "&random=" + Math.random();
                                            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", parms, false, true);
                                            if (result == "1") {
                                                $.messager.progress('close');
                                                $.messager.alert("生成成功", "生成列成功！");
                                                refreshTableColumnList();
                                            }
                                            else {
                                                var message = result.substr(6, result.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                        }
                                    })
                                }
                                else {
                                    $.messager.progress({
                                        title: "正在生成，请稍候...",
                                        text: "正在生成，请稍候..."
                                    });
                                    var sSql = selectedRow.sSql;
                                    var iRecNo = selectedRow.iRecNo;
                                    var parms = "from=table&otype=bulidColumns&sSql=" + sSql + "&iRecNo=" + iRecNo + "&random=" + Math.random();
                                    var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", parms, false, true);
                                    if (result == "1") {
                                        $.messager.progress('close');
                                        $.messager.alert("生成成功", "生成列成功！");
                                        refreshTableColumnList();
                                    }
                                    else {
                                        var message = result.substr(6, result.length - 6);
                                        $.messager.alert("错误", message);
                                        $.messager.progress('close');
                                    }
                                }
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    editRow();
                },
                onClickRow: function (index, row) {
                    selectedRow = row;
                    $("#ifrImportExcel").attr("src", "SysExportTemplate.aspx?iFormID=" + iformid + "&isDetail=1&tableName=" + row.sTableName);
                },
                onSelect: function (index, row) {
                    selectedRow = row;
                    $("#ifrImportExcel").attr("src", "SysExportTemplate.aspx?iFormID=" + iformid + "&isDetail=1&tableName=" + row.sTableName);
                    refreshTableColumnList();
                    setTimeout("refreshTableLookUpList()", 500);
                    setTimeout("refreshTableEvent()", 1000);
                    setTimeout("refreshTableImportList()", 1000);
                    setTimeout("refreshTableExpList()", 1000);
                    setTimeout("refreshTableDynColumn()", 1000);
                    //refreshTableDynColumn
                    //setTimeout("getChilcFiels()", 1000);
                    //lookup定义表格
                    //先取到字段，必须是在列定义中
                    var sqlObj = {
                        TableName: "bscChildTablesDColumns",
                        Fields: "sFieldName,sTitle",
                        SelectAll: "True",
                        Filters: [
                                    {
                                        Field: "iMainRecNo",
                                        ComOprt: "=",
                                        Value: "'" + selectedRow.iRecNo + "'"
                                    }
                        ],
                        Sorts: [
                                    {
                                        SortName: "iSerial",
                                        SortOrder: "asc"
                                    }
                        ]
                    };
                    var fieldsData = SqlGetData(sqlObj);
                    $("#Text27").combogrid({
                        idField: "sFieldName",
                        textField: "sFieldName",
                        //sortName:"sFieldName,sTitle",
                        columns: [[
                            { field: 'sFieldName', title: '字段名', width: 100, sortable: true },
                            { field: 'sTitle', title: '显示名', width: 100, sortable: true }
                        ]],
                        data: fieldsData,
                        panelWidth: 200,
                        filter: function (q, row) {
                            if (row.sFieldName.indexOf(q) == 0) {
                                return true;
                            }
                            if (row.sTitle.indexOf(q) == 0) {
                                return true;
                            }
                        }
                    });
                    $("#form7").form("clear");
                    $("#form7").form("load", row);
                }
            });
            setTimeout("refreshTableList()", 500);
            //setTimeout("bindLookCombox('Text17',30,902,250,500)", 1000);
            //setTimeout("bindFormCombox('Text29',50,870,250,500)", 1000);

            //子表列定义表格
            $("#tableColumn").datagrid({
                fit: true,
                border: true,
                idField: "iRecNo",
                //                SortName: "iSerial",
                //                SortOrder: "asc",
                multiSort: true,
                remoteSort: false,
                columns: [[
                    { field: 'iSerial', title: '序号', width: 40, sortable: true },
                    { field: 'sFieldName', title: '字段名', width: 150 },
                    { field: 'sTitle', title: '显示名', width: 150 },
                    { field: 'sType', title: '类型', width: 50 },
                    { field: 'sDefaultValue', title: '默认值', width: 100 },
                    { field: 'fWidth', title: '宽度', width: 70 },
                    {
                        field: 'iRequired', title: '必填', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iHidden', title: '隐藏', width: 50, sortable: true,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iNoCopy', title: '不可复制', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iEdit', title: '只读', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iAutoAdd', title: '自增', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iFix', title: '固定', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iSum', title: '求和', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iAvg', title: '求平均', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iCount', title: '求行数', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iMax', title: '求最大值', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iMin', title: '求最小值', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    }
                ]],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "新增字段",
                        handler: function () {
                            //var selectedRow = $("#tableList").datagrid("getSelected");
                            if (selectedRow == undefined || selectedRow == null) {
                                $.messager.alert("未选择子表", "请先选择一个子表！");
                                return;
                            }
                            $("#form2").form("reset");
                            $("#form2").form("load", {
                                iSerial: "0",
                                fWidth: "100"
                            });
                            $("#Text9").textbox("disable");
                            $("#Text15").textbox("disable");
                            var mainFields = getMainFields();
                            $("#txtSumMainField").combobox("loadData", mainFields);
                            $("#txtAvgMainField").combobox("loadData", mainFields);
                            $("#txtCountMainField").combobox("loadData", mainFields);
                            $("#txtMaxMainField").combobox("loadData", mainFields);
                            $("#txtMinMainField").combobox("loadData", mainFields);
                            $("#divColumnDetail").dialog({
                                title: '新增字段',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addColumn(0);
                                        }
                                    },
                                    {
                                        text: "保存并继续",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addColumn(1);
                                        }
                                    },
                                    {
                                        text: "关闭",
                                        iconCls: "icon-no",
                                        handler: function () {
                                            $("#divColumnDetail").dialog("close");
                                        }
                                    }
                                ]
                            })
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: "修改字段",
                        handler: function () {
                            editColumnRow();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除字段",
                        handler: function () {
                            if (selectedRow == undefined) {
                                $.messager.alert("错误", "请先选择一个子表！");
                            }
                            var columnSelectedRow = $("#tableColumn").datagrid("getSelected");

                            if (columnSelectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form2").form("submit", {
                                            url: "/Base/Handler/childTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableColumn";
                                                param.otype = "remove";
                                                param.iRecNo = columnSelectedRow.iRecNo;
                                                $.messager.progress({
                                                    title: "正在删除，请稍候...",
                                                    text: "正在删除，请稍候..."
                                                });
                                            },
                                            success: function (data) {
                                                if (data.indexOf("error:") > -1) {
                                                    var message = data.substr(6, data.length - 6);
                                                    $.messager.alert("错误", message);
                                                    $.messager.progress('close');
                                                }
                                                else if (data == "1") {
                                                    $.messager.progress('close');
                                                    $("#divColumnDetail").dialog("close");
                                                    var index = $("#tableColumn").datagrid("getRowIndex", columnSelectedRow);
                                                    $("#tableColumn").datagrid("deleteRow", index);
                                                    //refreshTableColumnList();
                                                    //refreshTableList();
                                                    if ($("#tableColumn").datagrid("getRows").length > index) {
                                                        $("#tableColumn").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableColumn").datagrid("getRows").length > 0) {
                                                        $("#tableColumn").datagrid("selectRow", $("#tableColumn").datagrid("getRows").length - 1);
                                                    }
                                                }
                                            }
                                        });
                                    }
                                })
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-preview',
                        text: "上移",
                        handler: function () {
                            MoveUp();
                        }
                    }
                    ,
                    '-',
                    {
                        iconCls: 'icon-next',
                        text: "下移",
                        handler: function () {
                            MoveDown();
                        }
                    }
                    ,
                    '-',
                    {
                        iconCls: 'icon-save',
                        text: "保存列序",
                        handler: function () {
                            saveColumnSort();
                        }
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    editColumnRow();
                }
            });
            //子表列类型选择
            /*$("#cc").combobox({
            onSelect: function (record) {
            if (record.text == "数据") {
            $("#Text15").textbox("enable");
            }
            else {
            $("#Text15").textbox("disable");
            }
            }
            });*/
            //子表lookUp定义
            $("#tableLookUp").datagrid({
                fit: true,
                border: false,
                idField: "iRecNo",
                columns: [[
                    { field: 'iRecNo', title: '唯一号', width: 60 },
                    { field: 'iSerial', title: '序号', width: 40 },
                    { field: 'sFieldName', title: '子段', width: 100 },
                    { field: 'sLookUpName', title: 'lookUp标识符', width: 150 },
                    { field: 'sFields', title: '选择字段', width: 100 },
                    { field: 'sSearchFields', title: '查询字段', width: 100 },
                    { field: 'sMatchFields', title: '匹配字段', width: 200 },
                    { field: 'sFixFilters', title: '固定查询条件', width: 100 },
                    { field: 'sChangeFilters', title: '可变查询条件', width: 100 },
                    { field: 'fWidth', title: '宽度', width: 70 },
                    { field: 'fHeight', title: '高度', width: 70 },
                    {
                        field: 'iMulti', title: '多选', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    { field: 'iPageSize', title: '页大小', width: 70 },
                    {
                        field: 'iDisabled', title: '停用', width: 50, formatter: function (value, row, index) {
                            if (value == "1") {
                                return "是";
                            }
                            else {
                                return "否";
                            }
                        }
                    }
                ]],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "新增lookUp",
                        handler: function () {
                            //var selectedRow = $("#tableList").datagrid("getSelected");
                            if (selectedRow == undefined || selectedRow == null) {
                                $.messager.alert("未选择子表", "请先选择一个子表！");
                                return;
                            }
                            //getChildFields("tableChildFieldLookUp");
                            $("#tabLookMatchFields").html("");
                            var tr = ("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                            $("#tabLookMatchFields").append(tr);
                            $("#form3").form("reset");
                            $("#form3").form("load", {
                                iSerial: "0",
                                sFields: "*",
                                sSearchFields: "*",
                                fWidth: 900,
                                fHeight: 600,
                                iPageSize: 20,
                                iEdit: "on"
                            });
                            $("#Text26").textbox("disable");
                            $("#divLookUp").dialog({
                                title: '新增lookUp',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addLookUp(0);
                                        }
                                    },
                                    {
                                        text: "保存并继续",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addLookUp(1);
                                        }
                                    },
                                    {
                                        text: "关闭",
                                        iconCls: "icon-no",
                                        handler: function () {
                                            $("#divLookUp").dialog("close");
                                        }
                                    }
                                ]
                            });
                            //                            $("#ifrLookUp")[0].width = "300";
                            //                            $("#ifrLookUp")[0].height = "375";
                            document.getElementById("ifrLookUp").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: "修改lookUp",
                        handler: function () {
                            lastType = 0;
                            editLookUpRow(0);
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除lookUp",
                        handler: function () {
                            if (selectedRow == undefined) {
                                $.messager.alert("错误", "请先选择一个子表！");
                            }
                            var columnSelectedRow = $("#tableLookUp").datagrid("getSelected");
                            if (columnSelectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除字段吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form3").form("submit", {
                                            url: "/Base/Handler/childTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableLookUp";
                                                param.otype = "remove";
                                                param.iRecNo = columnSelectedRow.iRecNo;
                                                $.messager.progress({
                                                    title: "正在删除，请稍候...",
                                                    text: "正在删除，请稍候..."
                                                });
                                            },
                                            success: function (data) {
                                                if (data.indexOf("error:") > -1) {
                                                    var message = data.substr(6, data.length - 6);
                                                    $.messager.alert("错误", message);
                                                    $.messager.progress('close');
                                                }
                                                else if (data == "1") {
                                                    $.messager.progress('close');
                                                    $("#divLookUp").dialog("close");
                                                    var index = $("#tableLookUp").datagrid("getRowIndex", columnSelectedRow);
                                                    refreshTableLookUpList();
                                                    if ($("#tableLookUp").datagrid("getRows").length > index) {
                                                        $("#tableLookUp").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableLookUp").datagrid("getRows").length > 0) {
                                                        $("#tableLookUp").datagrid("selectRow", $("#tableLookUp").datagrid("getRows").length - 1);
                                                    }
                                                }
                                            }
                                        });
                                    }
                                })
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    },
                    "-",
                    {
                        iconCls: 'icon-copy',
                        text: "复制",
                        handler: function () {
                            lastType = 1;
                            editLookUpRow(1);
                        }
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    lastType = 0;
                    editLookUpRow(0);
                }
            });
            //子表导入按钮
            $("#tableImport").datagrid({
                fit: true,
                border: false,
                idField: "iRecNo",
                columns: [[
                    { field: 'iRecNo', title: '唯一号', width: 60 },
                    { field: 'iSerial', title: '序号', width: 40 },
                    { field: 'sType', title: '类型', width: 100 },
                    { field: 'sTitle', title: '标题', width: 100 },
                    { field: 'sIden', title: '标识符', width: 150 },
                    { field: 'sMatchFields', title: '匹配字段', width: 300 },
                    { field: 'iWidth', title: '宽度', width: 70 },
                    { field: 'iHeight', title: '高度', width: 70 },
                    {
                        field: 'iMulti', title: '多选', width: 50,
                        formatter: function (value, row, index) {
                            if (value == "1" || value == true) {
                                return "<input type='checkbox' checked='checked' disabled='disabled'></input>";
                            }
                            else {
                                return "<input type='checkbox' disabled='disabled'></input>";
                            }
                        }
                    },
                    {
                        field: 'iDisabled', title: '停用', width: 50, formatter: function (value, row, index) {
                            if (value == "1") {
                                return "是";
                            }
                            else {
                                return "否";
                            }
                        }
                    }
                ]],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "新增",
                        handler: function () {
                            //var selectedRow = $("#tableList").datagrid("getSelected");
                            if (selectedRow == undefined || selectedRow == null) {
                                $.messager.alert("未选择子表", "请先选择一个子表！");
                                return;
                            }

                            $("#tabImportMatchFields").html("");
                            var tr = ("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                            $("#tabImportMatchFields").append(tr);

                            $("#form5").form("reset");
                            $("#form5").form("load", {
                                iSerial: "0",
                                sFields: "*",
                                sSearchFields: "*",
                                iPageSize: 20,
                                iWidth: 600,
                                iHeight: 400,
                                iMulti: "on"
                            });
                            $("#Text6").textbox("disable");
                            $("#divImport").dialog({
                                title: '新增导入按钮',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addImportBtn(0);
                                        }
                                    },
                                    {
                                        text: "保存并继续",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addImportBtn(1);
                                        }
                                    },
                                    {
                                        text: "关闭",
                                        iconCls: "icon-no",
                                        handler: function () {
                                            $("#divImport").dialog("close");
                                        }
                                    }
                                ]
                            });
                            $("#ifrImport")[0].width = "300";
                            $("#ifrImport")[0].height = "375";
                            document.getElementById("ifrImport").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: "修改",
                        handler: function () {
                            lastType = 0;
                            editImportRow(0);
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除",
                        handler: function () {
                            if (selectedRow == undefined) {
                                $.messager.alert("错误", "请先选择一个子表！");
                            }
                            var columnSelectedRow = $("#tableImport").datagrid("getSelected");
                            if (columnSelectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除字段吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form5").form("submit", {
                                            url: "/Base/Handler/childTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableImport";
                                                param.otype = "remove";
                                                param.iRecNo = columnSelectedRow.iRecNo;
                                                $.messager.progress({
                                                    title: "正在删除，请稍候...",
                                                    text: "正在删除，请稍候..."
                                                });
                                            },
                                            success: function (data) {
                                                if (data.indexOf("error:") > -1) {
                                                    var message = data.substr(6, data.length - 6);
                                                    $.messager.alert("错误", message);
                                                    $.messager.progress('close');
                                                }
                                                else if (data == "1") {
                                                    $.messager.progress('close');
                                                    $("#divImport").dialog("close");
                                                    var index = $("#tableImport").datagrid("getRowIndex", columnSelectedRow);
                                                    refreshTableImportList();
                                                    if ($("#tableImport").datagrid("getRows").length > index) {
                                                        $("#tableImport").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableImport").datagrid("getRows").length > 0) {
                                                        $("#tableImport").datagrid("selectRow", $("#tableImport").datagrid("getRows").length - 1);
                                                    }
                                                }
                                            }
                                        });
                                    }
                                })
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    },
                    "-",
                    {
                        iconCls: 'icon-copy',
                        text: "复制",
                        handler: function () {
                            lastType = 1;
                            editImportRow(1);
                        }
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    lastType = 0;
                    editImportRow(0);
                }
            });

            $("#selectImport").combobox({
                panelHeight: 50,
                editable: false,
                onSelect: function (record) {
                    $("#divForm").dialog("close");
                    $("#divLookUpDetail").dialog("close");
                    if (record.text == "从表单导入") {
                        $("#spanId").html("FormID");
                        $("#lookUpOnly").hide();
                        $("#dataFormOnly").show();
                        bindFormCombox("Text29", 50, 870, 250, 500);
                    }
                    else if (record.text == "从lookUp导入") {
                        $("#spanId").html("lookUp标识符");
                        $("#lookUpOnly").show();
                        $("#dataFormOnly").hide();
                        bindLookCombox("Text29", 50, 870, 250, 500);
                    }
                }
            });

            //公式
            $("#tableExp").datagrid({
                fit: true,
                border: false,
                idField: "iRecNo",
                columns: [[
                    { field: 'iSerial', title: '序号', width: 40 },
                    { field: 'sSourceField', title: '触发字段', width: 150 },
                    { field: 'sTargetField', title: '目标字段', width: 150 },
                    { field: 'sCondition', title: '执行条件', width: 300 },
                    { field: 'sExpression', title: '公式', width: 300 },
                    {
                        field: 'iDisabled', title: '停用', width: 50, formatter: function (value, row, index) {
                            if (value == "1") {
                                return "是";
                            }
                            else {
                                return "否";
                            }
                        }
                    }
                ]],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "新增",
                        handler: function () {
                            if (selectedRow == undefined || selectedRow == null) {
                                $.messager.alert("未选择子表", "请先选择一个子表！");
                                return;
                            }

                            $("#form6").form("clear");

                            $("#textareaExp").validatebox({ required: true });

                            $("#form6").form("load", {
                                iSerial: "0"
                            });
                            $("#Text38").textbox("disable");
                            $("#divExp").dialog({
                                title: '新增公式',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addExp(0);
                                        }
                                    },
                                    {
                                        text: "保存并继续",
                                        iconCls: "icon-save",
                                        handler: function () {
                                            addExp(1);
                                        }
                                    },
                                    {
                                        text: "关闭",
                                        iconCls: "icon-no",
                                        handler: function () {
                                            $("#divExp").dialog("close");
                                        }
                                    }
                                ]
                            });
                            //getMainFields("tableMainFieldExp");
                            //getChildFields("tableChildFieldExp");
                            expBindField();
                            $("#ifrExp")[0].width = "300";
                            $("#ifrExp")[0].height = "260";
                            document.getElementById("ifrExp").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: "修改",
                        handler: function () {
                            editExpRow();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除",
                        handler: function () {
                            if (selectedRow == undefined) {
                                $.messager.alert("错误", "请先选择一个子表！");
                            }
                            var columnSelectedRow = $("#tableExp").datagrid("getSelected");
                            if (columnSelectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form6").form("submit", {
                                            url: "/Base/Handler/childTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableExp";
                                                param.otype = "remove";
                                                param.iRecNo = columnSelectedRow.iRecNo;
                                                $.messager.progress({
                                                    title: "正在删除，请稍候...",
                                                    text: "正在删除，请稍候..."
                                                });
                                            },
                                            success: function (data) {
                                                if (data.indexOf("error:") > -1) {
                                                    var message = data.substr(6, data.length - 6);
                                                    $.messager.alert("错误", message);
                                                    $.messager.progress('close');
                                                }
                                                else if (data == "1") {
                                                    $.messager.progress('close');
                                                    $("#divExp").dialog("close");
                                                    var index = $("#tableExp").datagrid("getRowIndex", columnSelectedRow);
                                                    refreshTableExpList();
                                                    if ($("#tableExp").datagrid("getRows").length > index) {
                                                        $("#tableExp").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableExp").datagrid("getRows").length > 0) {
                                                        $("#tableExp").datagrid("selectRow", $("#tableExp").datagrid("getRows").length - 1);
                                                    }
                                                }
                                            }
                                        });
                                    }
                                })
                            }
                            else {
                                $.messager.alert("错误", "未选择任务行！");
                            }
                        }
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    editExpRow();
                }
            });

            $(document).click(function (event) {
                //var a= typeof (event.target);

                if (event.target.className && event.target.className.indexOf("fieldPanel") > -1) {
                    focusText = event.target;
                }
                else {
                    focusText = undefined;
                }

            });

            $("#cc").combobox({
                onSelect: function (record) {
                    if (record.text == "图片" || record.text == "附件") {
                        var value = record.text == "图片" ? "pic" : "acc";
                        $("#Text10").textbox("setValue", value);
                    }
                    if (record.text == "数据") {
                        $("#Text15").textbox("enable");
                    }
                    else {
                        $("#Text15").textbox("disable");
                    }
                }
            });


            var defaultData = [{ text: 'UserID' }, { text: 'UserName' }, { text: 'CurrentDate' }, { text: 'CurrentDateTime' }, { text: 'Departid' }, { text: 'NewGUID' }];
            $("#Text16").combobox({
                data: defaultData,
                valueField: 'text',
                textField: 'text',
                //required: true,
                width: 150,
                editable: true
            });

            $("#Text2").combobox({
                valueField: "field",
                textField: "field",
                data: getFormIDField(iformid).rows
            });

            var sqlObjPb = {
                TableName: "pbReportData",
                Fields: "iRecNo,sPbName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + iformid + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(isChild,0)",
                        ComOprt: "=",
                        Value: "1",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iHide,0)",
                        ComOprt: "=",
                        Value: "0"
                    }
                ]
            }
            var resultPb = SqlGetData(sqlObjPb);
            $("#Text211").combobox({
                valueField: "iRecNo",
                textField: "sPbName",
                data: resultPb,
                multiple: true
            });
        });
        //子表表格刷新
        function refreshTableList() {
            var sqlObj = {
                TableName: "bscChildTables",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormid",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableList").datagrid({
                data: data
            });
            /*if (selectedRow) {
            var index = $("#tableList").datagrid("getRowIndex", selectedRow);
            $("#tableList").datagrid("selectRow", index);
            }*/
            selectedRow = undefined;
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
        //子表表格行编辑
        function editRow() {
            //var selectedRow = $("#tableList").datagrid("getSelected");
            if (selectedRow) {
                $("#form1").form("clear");
                $("#Text7").textbox("enable");
                var sqlObj = {
                    TableName: "bscChildTables",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }]
                };
                if (SqlGetData(sqlObj).length > 0) {
                    selectedRow = SqlGetData(sqlObj)[0];
                }
                else {
                    alert("发生错误！");
                    return;
                }
                selectedRow.iDisabled = selectedRow.iDisabled == "1" ? "on" : "";
                $("#form1").form("load", selectedRow);
                isInited = true;
                $("#divDetail").dialog({
                    title: '修改子表',
                    toolbar: [
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {
                                if ($("#TextArea3").val().indexOf("{condition}") == -1) {
                                    $.messager.alert("错误", "SQL语句中未包含{condition}!");
                                    return;
                                }
                                if ($("#form1").form("validate")) {
                                    $("#form1").form("submit", {
                                        url: "/Base/Handler/childTableConfigHandler.ashx",
                                        onSubmit: function (param) {
                                            param.from = "table";
                                            param.otype = "edit";
                                            param.iFormid = $("#Text8").textbox("getValue");
                                            param.iRecNo = selectedRow.iRecNo;
                                            $.messager.progress({
                                                title: "正在保存，请稍候...",
                                                text: "正在保存，请稍候..."
                                            });
                                        },
                                        success: function (data) {
                                            if (data.indexOf("error:") > -1) {
                                                var message = data.substr(6, data.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                            else if (data == "1") {
                                                $.messager.progress('close');
                                                $("#divDetail").dialog("close");
                                                needRefresh = true;
                                                refreshTableList();
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        '-',
                        {
                            text: '上一子表',
                            iconCls: 'icon-preview',
                            handler: function () {
                                previewRow("tableList", selectedRow.iRecNo, editRow);
                            }
                        },
                        '-',
                        {
                            text: '下一子表',
                            iconCls: 'icon-next',
                            handler: function () {

                                nextRow("tableList", selectedRow.iRecNo, editRow);
                            }
                        },
                        '-',
                        {
                            text: "关闭",
                            iconCls: "icon-no",
                            handler: function () {
                                $("#divDetail").dialog("close");
                                if (needRefresh) {
                                    refreshTableList();
                                    needRefresh = false;
                                }
                            }
                        }
                    ],
                    onClose: function () {
                        isInited = false;
                    }
                });
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }
        //子表列定义刷新
        function refreshTableColumnList() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bscChildTablesDColumns",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }],
                Sorts: [
                {
                    SortName: "iHidden",
                    SortOrder: "asc"
                },
                {
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableColumn").datagrid({
                data: data
            });
            $("#tableColumn").datagrid("loadData", data);
            //            //$("#tableColumn").datagrid("sort", { sortName: "iSerial", sortOrder: "asc" });
            //            $("#tableColumn").datagrid("sort", { sortName: "iHidden", sortOrder: "asc" });
            //            $("#tableColumn").datagrid("sort", { sortName: "iSerial", sortOrder: "asc" });

        }
        //子表列新增
        function addColumn(type) {
            var r = $("#form2").form("validate");
            if (r) {
                $("#Text16").combobox("setValue", $("#Text16").combobox("getText"));
                $("#form2").form("submit", {
                    url: "/Base/Handler/childTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableColumn";
                        param.otype = "add";
                        param.iMainRecNo = selectedRow.iRecNo;
                        //                        $.messager.progress({
                        //                            title: "正在保存，请稍候...",
                        //                            text: "正在保存，请稍候..."
                        //                        });
                    },
                    success: function (data) {
                        if (data.indexOf("error:") > -1) {
                            var message = data.substr(6, data.length - 6);
                            $.messager.alert("错误", message);
                            $.messager.progress('close');
                        }
                        else if (data == "1") {
                            $.messager.progress('close');
                            if (type == 0) {
                                $("#divColumnDetail").dialog("close");
                            }
                            else {
                                $("#form2").form("reset");
                                $("#form2").form("load", { iSerial: "0" });
                                document.getElementById("Checkbox1").checked = false;
                                document.getElementById("Checkbox2").checked = false;
                                document.getElementById("Checkbox3").checked = false;
                            }
                            refreshTableColumnList();
                            //refreshTableList();
                        }
                    }
                });
            }
        }
        //子表列表格行编辑
        function editColumnRow() {
            var columnSelectedRow = $("#tableColumn").datagrid("getSelected");
            if (columnSelectedRow) {
                var sqlObj = {
                    TableName: "bscChildTablesDColumns",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: columnSelectedRow.iRecNo
                        }
                    ]
                };
                if (SqlGetData(sqlObj).length > 0) {
                    columnSelectedRow = SqlGetData(sqlObj)[0];
                }
                else {
                    alert("发生错误！");
                    return;
                }
                if (columnSelectedRow.sType == "数据") {
                    $("#Text15").textbox("enable");
                }
                columnSelectedRow.iEdit = columnSelectedRow.iEdit == "1" || columnSelectedRow.iEdit == "true" ? "on" : "";
                columnSelectedRow.iHidden = columnSelectedRow.iHidden == "1" || columnSelectedRow.iHidden == "true" ? "on" : "";
                columnSelectedRow.iRequired = columnSelectedRow.iRequired == "1" || columnSelectedRow.iRequired == "true" ? "on" : "";
                columnSelectedRow.iAutoAdd = columnSelectedRow.iAutoAdd == "1" || columnSelectedRow.iAutoAdd == "true" ? "on" : "";

                columnSelectedRow.iSum = columnSelectedRow.iSum == "1" || columnSelectedRow.iSum == "true" ? "on" : "";
                columnSelectedRow.iAvg = columnSelectedRow.iAvg == "1" || columnSelectedRow.iAvg == "true" ? "on" : "";
                columnSelectedRow.iCount = columnSelectedRow.iCount == "1" || columnSelectedRow.iCount == "true" ? "on" : "";
                columnSelectedRow.iMax = columnSelectedRow.iMax == "1" || columnSelectedRow.iMax == "true" ? "on" : "";
                columnSelectedRow.iMin = columnSelectedRow.iMin == "1" || columnSelectedRow.iMin == "true" ? "on" : "";
                columnSelectedRow.iFix = columnSelectedRow.iFix == "1" || columnSelectedRow.iFix == "true" ? "on" : "";

                $("#form2").form("clear");
                $("#Text9").textbox("enable");
                $("#form2").form("load", columnSelectedRow);
                var mainFields = getMainFields();
                $("#txtSumMainField").combobox("loadData", mainFields);
                $("#txtAvgMainField").combobox("loadData", mainFields);
                $("#txtCountMainField").combobox("loadData", mainFields);
                $("#txtMaxMainField").combobox("loadData", mainFields);
                $("#txtMinMainField").combobox("loadData", mainFields);
                $("#divColumnDetail").dialog({
                    title: '修改列定义',
                    toolbar: [
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {
                                if ($("#form2").form("validate")) {
                                    $("#Text16").combobox("setValue", $("#Text16").combobox("getText"));
                                    $("#form2").form("submit", {
                                        url: "/Base/Handler/childTableConfigHandler.ashx",
                                        onSubmit: function (param) {
                                            param.from = "tableColumn";
                                            param.otype = "edit";
                                            param.iRecNo = columnSelectedRow.iRecNo;
                                            //                                            $.messager.progress({
                                            //                                                title: "正在保存，请稍候...",
                                            //                                                text: "正在保存，请稍候..."
                                            //                                            });
                                        },
                                        success: function (data) {
                                            if (data.indexOf("error:") > -1) {
                                                var message = data.substr(6, data.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                            else if (data == "1") {
                                                $.messager.progress('close');
                                                //$("#divColumnDetail").dialog("close");
                                                //$.messager.alert("成功", "保存成功！");
                                                needRefresh = true;

                                            }
                                        }
                                    });
                                }
                            }
                        },
                        '-',
                        {
                            text: '上一列',
                            iconCls: 'icon-preview',
                            handler: function () {
                                previewRow("tableColumn", columnSelectedRow.iRecNo, editColumnRow);
                            }
                        },
                        '-',
                        {
                            text: '下一列',
                            iconCls: 'icon-next',
                            handler: function () {

                                nextRow("tableColumn", columnSelectedRow.iRecNo, editColumnRow);
                            }
                        },

                        '-',
                        {
                            text: "关闭",
                            iconCls: "icon-no",
                            handler: function () {
                                $("#divColumnDetail").dialog("close");
                                if (needRefresh) {
                                    refreshTableColumnList();
                                    //refreshTableList();
                                    needRefresh = false;
                                }
                            }
                        }
                    ]
                });
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }

        //上移
        function MoveUp() {
            var rows = $("#tableColumn").datagrid('getSelections');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#tableColumn").datagrid('getRowIndex', rows[i]);
                //$("#tableColumn").datagrid("endEdit", index);
                mysort(index, 'up', 'tableColumn');
            }
        }
        //下移
        function MoveDown() {
            var rows = $("#tableColumn").datagrid('getSelections');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#tableColumn").datagrid('getRowIndex', rows[i]);
                //$("#tableColumn").datagrid("endEdit", index);
                mysort(index, 'down', 'tableColumn');
            }
        }
        function mysort(index, type, gridname) {
            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datagrid('getData').rows[index];
                    var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
                    var theSerial = toup.iSerial;
                    toup.iSerial = todown.iSerial;
                    todown.iSerial = theSerial;
                    $('#' + gridname).datagrid('getData').rows[index] = todown;
                    $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index - 1);
                    $('#' + gridname).datagrid('selectRow', index - 1);
                    $('#' + gridname).datagrid('unselectRow', index);
                }
            }
            else if ("down" == type) {
                var rows = $('#' + gridname).datagrid('getRows').length;
                if (index != rows - 1) {
                    var todown = $('#' + gridname).datagrid('getData').rows[index];
                    var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
                    var theSerial = todown.iSerial;
                    todown.iSerial = toup.iSerial;
                    toup.iSerial = theSerial;
                    $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
                    $('#' + gridname).datagrid('getData').rows[index] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index + 1);
                    $('#' + gridname).datagrid('selectRow', index + 1);
                    $('#' + gridname).datagrid('unselectRow', index);
                }
            }
        }

        function saveColumnSort() {
            var rowsO = $("#tableColumn").datagrid("getRows");
            var rows = [];
            deepCopy(rows, rowsO);
            for (var i = 0; i < rows.length; i++) {
                for (var key in rows[i]) {
                    if (key != "iRecNo" && key != "iSerial") {
                        delete rows[i][(key)];
                    }
                }
            }
            var backStr = JSON2.stringify(rows);
            $.ajax({
                url: "/Base/Handler/childTableConfigHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { from: "tableColumn", otype: "saveColumnSort", detailStr: backStr },
                success: function (data) {
                    if (data == "1") {
                        $.messager.alert("成功", "保存成功！");
                    }
                    else {
                        $.messager.alert("失败", data);
                    }
                }
            })
        }
        function deepCopy(destination, source) {
            for (var p in source) {
                if (getType(source[p]) == "array" || getType(source[p]) == "object") {
                    destination[p] = getType(source[p]) == "array" ? [] : {};
                    arguments.callee(destination[p], source[p]);
                }
                else {
                    destination[p] = source[p] == null || source[p] == undefined ? source[p] : source[p].toString();
                }
            }
        }
        function getType(o) {
            var _t;
            return ((_t = typeof (o)) == "object" ? o == null && "null" || Object.prototype.toString.call(o).slice(8, -1) : _t).toLowerCase();
        }
        //子表lookUp定义刷新
        function refreshTableLookUpList() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bscChildTablesDLookUp",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableLookUp").datagrid({
                data: data
            });
        }
        //子表列新增
        function addLookUp(type) {
            var r = $("#form3").form("validate");

            if (r) {
                $("#form3").form("submit", {
                    url: "/Base/Handler/childTableConfigHandler.ashx",
                    onSubmit: function (param) {

                        param.from = "tableLookUp";
                        param.otype = "add";
                        param.iMainRecNo = selectedRow.iRecNo;
                        param.sMatchFields = getMatchFieldsStr("tabLookMatchFields");
                        if (param.sMatchFields == false) {
                            return false;
                        }
                        param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                        $.messager.progress({
                            title: "正在保存，请稍候...",
                            text: "正在保存，请稍候..."
                        });
                    },
                    success: function (data) {
                        if (data.indexOf("error:") > -1) {
                            var message = data.substr(6, data.length - 6);
                            $.messager.alert("错误", message);
                            $.messager.progress('close');
                        }
                        else if (data == "1") {
                            $.messager.progress('close');
                            if (type == 0) {
                                $("#divLookUp").dialog("close");
                            }
                            else {
                                $("#form3").form("reset");
                                $("#form3").form("load", {
                                    iSerial: "0",
                                    sFields: "*",
                                    sSearchFields: "*",
                                    fWidth: 900,
                                    fHeight: 600,
                                    iPageSize: 20,
                                    iEdit: "on"
                                });
                                document.getElementById("Checkbox5").checked = false;
                            }
                            refreshTableLookUpList();
                        }
                    }
                });
            }
        }
        //子表lookUp编辑
        function editLookUpRow(type) {//type=0修改，1复制
            var columnSelectedRow = $("#tableLookUp").datagrid("getSelected");
            if (columnSelectedRow) {
                var sqlObj = {
                    TableName: "bscChildTablesDLookUp",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: columnSelectedRow.iRecNo
                        }
                    ]
                };
                if (SqlGetData(sqlObj).length > 0) {
                    columnSelectedRow = SqlGetData(sqlObj)[0];
                }
                else {
                    alert("发生错误！");
                    return;
                }

                columnSelectedRow.iMulti = columnSelectedRow.iMulti == "1" || columnSelectedRow.iMulti == "true" ? "on" : "";
                columnSelectedRow.iEdit = columnSelectedRow.iEdit == "1" ? "on" : "";
                columnSelectedRow.iDisabled = columnSelectedRow.iDisabled == "1" ? "on" : "";
                if (columnSelectedRow.sType == "数据") {
                    $("#Text15").textbox("enable");
                }

                $("#Text26").textbox("enable");
                $("#form3").form("clear");

                $("#form3").form("load", columnSelectedRow);
                var matchFields = columnSelectedRow.sMatchFields;
                if (matchFields && matchFields != null && matchFields != "") {
                    $($("#tabLookMatchFields").children(":last-child")).remove();
                    var matchFieldsArr = matchFields.split(",");
                    for (var i = 0; i < matchFieldsArr.length; i++) {
                        var left = matchFieldsArr[i].split("=")[0].replace(/#/g, "");
                        var right = matchFieldsArr[i].split("=")[1].replace(/#/g, "");
                        var trnew = $("<tr><td><input type='text' class='txb fieldPanel' value=" + left + " onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' value=" + right + " onkeydown=turnToTd(event) /></td></tr>");
                        $("#tabLookMatchFields").append(trnew);
                    }
                }
                else {
                    $("#tabLookMatchFields").html();
                    var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                    $("#tabLookMatchFields").append(trnew);
                }

                var datagridToolbar = [];
                datagridToolbar.push(
                {
                    text: "保存",
                    iconCls: "icon-save",
                    handler: function () {

                        if ($("#form3").form("validate")) {

                            $("#form3").form("submit", {
                                url: "/Base/Handler/childTableConfigHandler.ashx",
                                onSubmit: function (param) {
                                    param.from = "tableLookUp";
                                    param.otype = type == 0 ? "edit" : "add";
                                    param.iMainRecNo = selectedRow.iRecNo;
                                    param.iRecNo = columnSelectedRow.iRecNo;
                                    param.sMatchFields = getMatchFieldsStr("tabLookMatchFields");
                                    if (param.sMatchFields == false) {
                                        return false;
                                    }
                                    param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                                    $.messager.progress({
                                        title: "正在保存，请稍候...",
                                        text: "正在保存，请稍候..."
                                    });
                                },
                                success: function (data) {
                                    if (data.indexOf("error:") > -1) {
                                        var message = data.substr(6, data.length - 6);
                                        $.messager.alert("错误", message);
                                        $.messager.progress('close');
                                    }
                                    else if (data == "1") {
                                        $.messager.progress('close');
                                        $.messager.alert("成功", "保存成功！");
                                        needRefresh = true;
                                    }
                                }
                            });
                        }
                    }
                }
                );
                if (type == 0) {
                    datagridToolbar.push("-");
                    datagridToolbar.push(
                        {
                            text: "上一行",
                            iconCls: "icon-preview",
                            handler: function () {
                                previewRow("tableLookUp", columnSelectedRow.iRecNo, editLookUpRow);
                            }
                        }
                    );
                    datagridToolbar.push("-");
                    datagridToolbar.push(
                        {
                            text: "下一行",
                            iconCls: "icon-next",
                            handler: function () {
                                nextRow("tableLookUp", columnSelectedRow.iRecNo, editLookUpRow);
                            }
                        }
                        );
                }
                datagridToolbar.push("-");
                datagridToolbar.push(
                    {
                        text: "关闭",
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divLookUp").dialog("close");
                            if (needRefresh) {
                                refreshTableLookUpList();
                                needRefresh = false;
                            }
                        }
                    }
                 );

                $("#divLookUp").dialog({
                    title: '修改lookUp',
                    toolbar: datagridToolbar/*[
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {

                                if ($("#form3").form("validate")) {

                                    $("#form3").form("submit", {
                                        url: "/Base/Handler/childTableConfigHandler.ashx",
                                        onSubmit: function (param) {
                                            param.from = "tableLookUp";
                                            param.otype = "edit";
                                            param.iRecNo = columnSelectedRow.iRecNo;
                                            param.sMatchFields = getMatchFieldsStr("tabLookMatchFields");
                                            if (param.sMatchFields == false) {
                                                return false;
                                            }
                                            param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                                            $.messager.progress({
                                                title: "正在保存，请稍候...",
                                                text: "正在保存，请稍候..."
                                            });
                                        },
                                        success: function (data) {
                                            if (data.indexOf("error:") > -1) {
                                                var message = data.substr(6, data.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                            else if (data == "1") {
                                                $.messager.progress('close');
                                                $.messager.alert("成功", "保存成功！");
                                                needRefresh = true;
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        '-',
                        {
                            text: "上一行",
                            iconCls: "icon-preview",
                            handler: function () {
                                previewRow("tableLookUp", columnSelectedRow.iRecNo, editLookUpRow);
                            }
                        },
                        '-',
                        {
                            text: "下一行",
                            iconCls: "icon-next",
                            handler: function () {
                                nextRow("tableLookUp", columnSelectedRow.iRecNo, editLookUpRow);
                            }
                        },
                        '-',
                        {
                            text: "关闭",
                            iconCls: "icon-no",
                            handler: function () {
                                $("#divLookUp").dialog("close");
                                if (needRefresh) {
                                    refreshTableLookUpList();
                                    needRefresh = false;
                                }
                            }
                        }
                    ]*/
                });
                //getMainFields("tableMainFieldLookUp");
                //getChildFields("tableChildFieldLookUp");

                //                $("#ifrLookUp")[0].width = "300";
                //                $("#ifrLookUp")[0].height = "375";
                document.getElementById("ifrLookUp").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
                //document.getElementById("ifrLookUpChild").src = "columns.htm?show=child&iChildRecNo=" + selectedRow.iRecNo + "&height=595&random=" + Math.random();
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }
        //事件保存
        function eventSave() {
            $("#form4").form("submit", {
                url: "/Base/Handler/childTableConfigHandler.ashx",
                onSubmit: function (param) {
                    if (selectedRow) {
                        param.from = "tableEvent";
                        param.iMainRecNo = selectedRow.iRecNo;
                        $.messager.progress({
                            title: "正在保存，请稍候...",
                            text: "正在保存，请稍候..."
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个子表！");
                    }
                },
                success: function (data) {
                    if (data.indexOf("error:") > -1) {
                        var message = data.substr(6, data.length - 6);
                        $.messager.alert("错误", message);
                        $.messager.progress('close');
                    }
                    else if (data == "1") {
                        $.messager.progress('close');
                        refreshTableEvent();
                        $.messager.alert("成功", "保存成功！");
                    }
                }
            });
        }
        //打印模板保存
        function eventSavePb() {
            $("#form7").form("submit", {
                url: "/Base/Handler/childTableConfigHandler.ashx",
                onSubmit: function (param) {
                    if (selectedRow) {
                        param.from = "tablePb";
                        param.iRecNo = selectedRow.iRecNo;
                        $.messager.progress({
                            title: "正在保存，请稍候...",
                            text: "正在保存，请稍候..."
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个子表！");
                    }
                },
                success: function (data) {
                    if (data.indexOf("error:") > -1) {
                        var message = data.substr(6, data.length - 6);
                        $.messager.alert("错误", message);
                        $.messager.progress('close');
                    }
                    else if (data == "1") {
                        $.messager.progress('close');
                        //refreshTableEvent();
                        $.messager.alert("成功", "保存成功！");
                    }
                }
            });
        }
        //导入按钮新增
        function addImportBtn(type) {
            var r = $("#form5").form("validate");
            if (r) {
                $("#form5").form("submit", {
                    url: "/Base/Handler/childTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableImport";
                        param.otype = "add";
                        param.iMainRecNo = selectedRow.iRecNo;
                        param.sMatchFields = getMatchFieldsStr("tabImportMatchFields");
                        if (param.sMatchFields == false) {
                            return false;
                        }
                        param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                        $.messager.progress({
                            title: "正在保存，请稍候...",
                            text: "正在保存，请稍候..."
                        });
                    },
                    success: function (data) {
                        if (data.indexOf("error:") > -1) {
                            var message = data.substr(6, data.length - 6);
                            $.messager.alert("错误", message);
                            $.messager.progress('close');
                        }
                        else if (data == "1") {
                            $.messager.progress('close');
                            if (type == 0) {
                                $("#divImport").dialog("close");
                            }
                            else {
                                $("#form5").form("reset");
                                $("#form5").form("load",
                                {
                                    iSerial: "0",
                                    sFields: "*",
                                    sSearchFields: "*",
                                    iPageSize: 20,
                                    iWidth: 600,
                                    iHeight: 400
                                });
                            }
                            refreshTableImportList();
                        }
                    }
                });
            }
        }
        //导入按钮编辑
        function editImportRow(type) {//type=0修改，1复制
            var columnSelectedRow = $("#tableImport").datagrid("getSelected");
            if (columnSelectedRow) {
                var sqlObj = {
                    TableName: "bscChildTablesDImportBtn",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: columnSelectedRow.iRecNo
                        }
                    ]
                };
                if (SqlGetData(sqlObj).length > 0) {
                    columnSelectedRow = SqlGetData(sqlObj)[0];
                }
                else {
                    alert("发生错误！");
                    return;
                }

                columnSelectedRow.iMulti = columnSelectedRow.iMulti == "1" || columnSelectedRow.iMulti == "true" ? "on" : "";
                if (columnSelectedRow.sType == "从表单导入") {
                    $("#spanId").html("FormID");
                    $("#dataFormOnly").show();
                    $("#lookUpOnly").hide();
                    bindFormCombox("Text29", 50, 870, 250, 500);
                }
                else if (columnSelectedRow.sType == "从lookUp导入") {
                    $("#spanId").html("lookUp标识符");
                    $("#dataFormOnly").hide();
                    $("#lookUpOnly").show();
                    bindLookCombox("Text29", 50, 870, 250, 500);
                }

                $("#Text6").textbox("enable");
                $("#form5").form("clear");
                columnSelectedRow.iDisabled = columnSelectedRow.iDisabled == "1" ? "on" : "";
                $("#form5").form("load", columnSelectedRow);

                var matchFields = columnSelectedRow.sMatchFields;
                if (matchFields && matchFields != null && matchFields != "") {
                    $($("#tabImportMatchFields").children(":last-child")).remove();
                    var matchFieldsArr = matchFields.split(",");
                    for (var i = 0; i < matchFieldsArr.length; i++) {
                        var left = matchFieldsArr[i].split("=")[0].replace(/#/g, "");
                        var right = matchFieldsArr[i].split("=")[1].replace(/#/g, "");
                        var trnew = $("<tr><td><input type='text' class='txb fieldPanel' value=" + left + " onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' value=" + right + " onkeydown=turnToTd(event) /></td></tr>");
                        $("#tabImportMatchFields").append(trnew);
                    }
                }
                else {
                    $("#tabImportMatchFields").html();
                    var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                    $("#tabImportMatchFields").append(trnew);
                }

                var datagridToolbar = [];
                datagridToolbar.push(
                {
                    text: "保存",
                    iconCls: "icon-save",
                    handler: function () {
                        if ($("#form5").form("validate")) {
                            $("#form5").form("submit", {
                                url: "/Base/Handler/childTableConfigHandler.ashx",
                                onSubmit: function (param) {
                                    param.from = "tableImport";
                                    param.otype = type == 0 ? "edit" : "add";;
                                    param.iMainRecNo = selectedRow.iRecNo;
                                    param.iRecNo = columnSelectedRow.iRecNo;
                                    param.sMatchFields = getMatchFieldsStr("tabImportMatchFields");
                                    if (param.sMatchFields == false) {
                                        return false;
                                    }
                                    param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                                    $.messager.progress({
                                        title: "正在保存，请稍候...",
                                        text: "正在保存，请稍候..."
                                    });
                                },
                                success: function (data) {
                                    if (data.indexOf("error:") > -1) {
                                        var message = data.substr(6, data.length - 6);
                                        $.messager.alert("错误", message);
                                        $.messager.progress('close');
                                    }
                                    else if (data == "1") {
                                        $.messager.progress('close');
                                        $.messager.alert("成功", "保存成功！");
                                        needRefresh = true;
                                    }
                                }
                            });
                        }
                    }
                }
                );
                if (type == 0) {
                    datagridToolbar.push("-");
                    datagridToolbar.push(
                        {
                            text: "上一行",
                            iconCls: "icon-preview",
                            handler: function () {
                                previewRow("tableImport", columnSelectedRow.iRecNo, editImportRow);
                            }
                        }
                    );
                    datagridToolbar.push("-");
                    datagridToolbar.push(
                        {
                            text: "下一行",
                            iconCls: "icon-next",
                            handler: function () {
                                nextRow("tableImport", columnSelectedRow.iRecNo, editImportRow);
                            }
                        }
                        );
                }
                datagridToolbar.push("-");
                datagridToolbar.push(
                    {
                        text: "关闭",
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divImport").dialog("close");
                            if (needRefresh) {
                                refreshTableImportList();
                                needRefresh = false;
                            }
                        }
                    }
                 );


                $("#divImport").dialog({
                    title: '修改',
                    toolbar: datagridToolbar /*[
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {
                                if ($("#form5").form("validate")) {
                                    $("#form5").form("submit", {
                                        url: "/Base/Handler/childTableConfigHandler.ashx",
                                        onSubmit: function (param) {
                                            param.from = "tableImport";
                                            param.otype = "edit";
                                            param.iRecNo = columnSelectedRow.iRecNo;
                                            param.sMatchFields = getMatchFieldsStr("tabImportMatchFields");
                                            if (param.sMatchFields == false) {
                                                return false;
                                            }
                                            param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                                            $.messager.progress({
                                                title: "正在保存，请稍候...",
                                                text: "正在保存，请稍候..."
                                            });
                                        },
                                        success: function (data) {
                                            if (data.indexOf("error:") > -1) {
                                                var message = data.substr(6, data.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                            else if (data == "1") {
                                                $.messager.progress('close');
                                                $.messager.alert("成功", "保存成功！");
                                                needRefresh = true;
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        '-',
                        {
                            text: "上一行",
                            iconCls: "icon-preview",
                            handler: function () {
                                previewRow("tableImport", columnSelectedRow.iRecNo, editImportRow);
                            }
                        },
                        '-',
                        {
                            text: "下一行",
                            iconCls: "icon-next",
                            handler: function () {
                                nextRow("tableImport", columnSelectedRow.iRecNo, editImportRow);
                            }
                        },
                        '-',
                        {
                            text: "关闭",
                            iconCls: "icon-no",
                            handler: function () {
                                $("#divImport").dialog("close");
                                if (needRefresh) {
                                    refreshTableImportList();
                                    needRefresh = false;
                                }
                            }
                        }
                    ]*/
                });
                //getMainFields("tableMainFieldImport");
                //getChildFields("tableChildFieldImport");
                $("#ifrImport")[0].width = "300";
                $("#ifrImport")[0].height = "375";
                document.getElementById("ifrImport").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }
        //导入按钮刷新
        function refreshTableImportList() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bscChildTablesDImportBtn",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableImport").datagrid({
                data: data
            });
        }

        //公式新增
        function addExp(type) {
            var r = $("#form6").form("validate");
            if (r) {
                $("#form6").form("submit", {
                    url: "/Base/Handler/childTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableExp";
                        param.otype = "add";
                        param.iMainRecNo = selectedRow.iRecNo;
                        $.messager.progress({
                            title: "正在保存，请稍候...",
                            text: "正在保存，请稍候..."
                        });
                    },
                    success: function (data) {
                        if (data.indexOf("error:") > -1) {
                            var message = data.substr(6, data.length - 6);
                            $.messager.alert("错误", message);
                            $.messager.progress('close');
                        }
                        else if (data == "1") {
                            $.messager.progress('close');
                            if (type == 0) {
                                $("#divExp").dialog("close");
                            }
                            else {
                                $("#form6").form("clear");
                                $("#form6").form("load",
                                {
                                    iSerial: "0"
                                });
                            }
                            refreshTableExpList();
                        }
                    }
                });
            }
        }
        //公式编辑
        function editExpRow() {
            var columnSelectedRow = $("#tableExp").datagrid("getSelected");
            if (columnSelectedRow) {
                var sqlObj = {
                    TableName: "bacChildTablesDExpression",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: columnSelectedRow.iRecNo
                        }
                    ]
                };
                if (SqlGetData(sqlObj).length > 0) {
                    columnSelectedRow = SqlGetData(sqlObj)[0];
                }
                else {
                    alert("发生错误！");
                    return;
                }
                //getChildFields("tableChildFieldExp");
                expBindField();
                $("#textareaExp").validatebox({ required: true });
                $("#Text38").textbox("enable");
                $("#form6").form("clear");
                columnSelectedRow.iDisabled = columnSelectedRow.iDisabled == "1" ? "on" : "";
                $("#form6").form("load", columnSelectedRow);
                $("#divExp").dialog({
                    title: '修改',
                    toolbar: [
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {
                                if ($("#form6").form("validate")) {
                                    $("#form6").form("submit", {
                                        url: "/Base/Handler/childTableConfigHandler.ashx",
                                        onSubmit: function (param) {
                                            param.from = "tableExp";
                                            param.otype = "edit";
                                            param.iRecNo = columnSelectedRow.iRecNo;
                                            $.messager.progress({
                                                title: "正在保存，请稍候...",
                                                text: "正在保存，请稍候..."
                                            });
                                        },
                                        success: function (data) {
                                            if (data.indexOf("error:") > -1) {
                                                var message = data.substr(6, data.length - 6);
                                                $.messager.alert("错误", message);
                                                $.messager.progress('close');
                                            }
                                            else if (data == "1") {
                                                $.messager.progress('close');
                                                $.messager.alert("成功", "保存成功！");
                                                needRefresh = true;
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        '-',
                        {
                            text: "上一行",
                            iconCls: "icon-preview",
                            handler: function () {
                                previewRow("tableExp", columnSelectedRow.iRecNo, editExpRow);
                            }
                        },
                        '-',
                        {
                            text: "下一行",
                            iconCls: "icon-next",
                            handler: function () {
                                nextRow("tableExp", columnSelectedRow.iRecNo, editExpRow);
                            }
                        },
                        '-',
                        {
                            text: "关闭",
                            iconCls: "icon-no",
                            handler: function () {
                                $("#divExp").dialog("close");
                                if (needRefresh) {
                                    refreshTableExpList();
                                    needRefresh = false;
                                }
                            }
                        }
                    ]
                });
                //getMainFields("tableMainFieldExp");
                $("#ifrExp")[0].width = "300";
                $("#ifrExp")[0].height = "250";
                document.getElementById("ifrExp").src = "columns.htm?show=both&iformid=" + getQueryString("iformid") + "&iChildRecNo=" + selectedRow.iRecNo + "&height=375&random=" + Math.random();
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }
        //公式刷新
        function refreshTableExpList() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bacChildTablesDExpression",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableExp").datagrid({
                data: data
            });
        }
        //自增勾选时
        function autoAddCheck(obj) {
            if (obj.checked == true) {
                $("#Text17").textbox("enable");
            }
            else {
                $("#Text17").textbox("disable");
            }
        }
        //下一列
        function nextRow(tableid, id, fun) {
            //var index = $("#" + tableid).datagrid("getRowIndex", currentRow);
            var index = $("#" + tableid).datagrid("getRowIndex", id);
            var rows = $("#" + tableid).datagrid("getRows");
            if (index + 1 < rows.length) {
                $("#" + tableid).datagrid("selectRow", index + 1);
                fun(lastType);
            }
            else {
                $.messager.alert("错误", "已是最行一行！");
            }
        }
        //上一列
        function previewRow(tableid, id, fun) {
            //var index = $("#" + tableid).datagrid("getRowIndex", currentRow);
            var index = $("#" + tableid).datagrid("getRowIndex", id);
            //var rows = $("#tableColumn").datagrid("getRows");
            if (index > 0) {
                $("#" + tableid).datagrid("selectRow", index - 1);
                fun(lastType);
            }
            else {
                $.messager.alert("错误", "已是第一行！");
            }
        }
        function refreshTableEvent() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            $("#form4").form("clear");
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bscChildTablesDEvent",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#form4").form("load", data[0]);
        }
        //动态列加载
        function refreshTableDynColumn() {
            if (selectedRow == undefined) {
                $.messager.alert("错误", "请先选择一个子表！");
                return;
            }
            $("#formDyn").form("clear");
            var iMainRecNo = selectedRow.iRecNo;
            var sqlObj = {
                TableName: "bscChildDynColumn",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: iMainRecNo
                }]
            };
            var data = SqlGetData(sqlObj);
            if (data && data.length > 0) {
                data[0].iSummary = data[0].iSummary == "1" ? "on" : "";
                $("#formDyn").form("load", data[0]);
            }
        }
        //选主表字段
        function selectChildFields(tableid) {
            if (onFocusObj == undefined) {
                return;
            }
            var className = onFocusObj.className;
            if (className.indexOf("fieldPanel") > -1) {
                var selectedStr = "";
                var selectedRow = $("#" + tableid).datagrid("getSelected");
                selectedStr += "#" + selectedRow.sFieldName + "#";
                onFocusObj.focus();
                insertText(onFocusObj, selectedStr);
            }
        }
        //选子表字段
        function selectMainFields(tableid, noPre) {
            if (onFocusObj == undefined) {
                return;
            }
            var className = onFocusObj.className;
            if (className.indexOf("fieldPanel") > -1) {
                var selectedStr = "";
                var selectedRow = $("#" + tableid).datagrid("getSelected");
                if (noPre) {
                    selectedStr += "#" + selectedRow.field + "#";
                }
                else {
                    selectedStr += "#m." + selectedRow.field + "#";
                }
                onFocusObj.focus();
                insertText(onFocusObj, selectedStr);
            }
        }
        //获取公式绑定子表字段
        function expBindField() {
            var sqlObj = {
                TableName: "bscChildTablesDColumns",
                Fields: "sFieldName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }
                ],
                Sorts: [
                {
                    SortName: "iSerial",
                    SortOrder: "asc"
                }
                ]
            };
            var fieldsData = SqlGetData(sqlObj);
            if (fieldsData.length > 0) {
                $("#Text39").combobox({
                    data: fieldsData,
                    valueField: 'sFieldName',
                    textField: 'sFieldName',
                    required: true,
                    missingMessage: '不可空',
                    width: 100
                });
                $("#Text40").combobox({
                    data: fieldsData,
                    valueField: 'sFieldName',
                    textField: 'sFieldName',
                    required: true,
                    missingMessage: '不可空',
                    width: 100
                });
            }
            else {
                alert("子表未定义任何列！");
            }
        }

        //获取主表字段
        function getMainFields() {
            var iformid = getQueryString("iformid");
            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", "iformid=" + iformid + "&otype=getFormField", false, true);
            if (result.indexOf("error:") > -1) {
                alert(result.substr(6, result.length - 6));
            }
            else {
                var mainFields = eval("(" + result + ")");
                /*$("#" + tableid).datagrid({
                data: mainFields.rows
                });*/
                return mainFields.rows;
            }
        }
        function get_firstchild(n) {
            var x = n.firstChild;
            if (x != null) {
                while (x.nodeType != 1) {
                    x = x.nextSibling;
                }
                return x;
            }
            else {
                return null;
            }
        }
        function getChildNodes(obj) {
            var childnodes = new Array();
            var childS = obj.childNodes;
            for (var i = 0; i < childS.length; i++) {
                if (childS[i].nodeType == 1)
                    childnodes.push(childS[i]);
            }
            return childnodes;
        }
        //光标入插入文本
        function insertText(obj, str) {
            if (document.selection) {
                obj.focus();
                var sel = document.selection.createRange();
                sel.text = str;
            } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
                var startPos = obj.selectionStart,
            endPos = obj.selectionEnd,
            cursorPos = startPos,
            tmpStr = obj.value;
                obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length);
                cursorPos += str.length;
                obj.selectionStart = obj.selectionEnd = cursorPos;
            } else {
                obj.value += str;
            }
        }
        //lookUp获取lookUp标识符
        function getLookUpName() {
            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", "otype=getLookUpName", false, true);
            if (result.indexOf("error:") > -1) {
                alert(result.substr(6, result.length - 6));
                return [];
            }
            else {
                var jsonData = eval("(" + result + ")");
                return jsonData;
            }
        }
        //获取lookUp的字段
        function getLookUpField(lookUpName) {
            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", "otype=getLookUpField&lookUpName=" + lookUpName, false, true);
            if (result.indexOf("error:") > -1) {
                alert(result.substr(6, result.length - 6));
                return [];
            }
            else {
                var data = eval("(" + result + ")");
                return data;
            }
        }
        //绑定lookup选择
        /*function bindLookCombox(id, top, left) {
        $("#" + id).combogrid({
        idField: 'sOrgionName',
        textField: 'sOrgionName',
        columns: [[
        { field: 'sOrgionName', title: 'lookUp标识', width: 100 },
        { field: 'sControlName', title: '控件名称', width: 100 }
        ]],
        data: getLookUpName(),
        onSelect: function (index, row) {
        $("#Text41").val(row.sReturnField);
        $("#Text42").val(row.sDisplayField);
        var data = getLookUpField(row.sOrgionName);
        $("#divLookUpDetail").dialog({
        title: "lookUpName详情:" + row.sOrgionName,
        top: top,
        left: left
        });
        $("#divLookUpDetail").dialog("open");
        $("#lookUpField").datagrid({
        data: data
        });
        },
        filter: function (q, row) {
        if (row.sOrgionName.indexOf(q) == 0) {
        return true;
        }
        if (row.sControlName.indexOf(q) == 0) {
        return true;
        }
        }
        });
        }*/
        //获取所有FormID
        function getFormID() {
            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", "otype=getFormID", false, true);
            if (result.indexOf("error:") > -1) {
                alert(result.substr(6, result.length - 6));
                return [];
            }
            else {
                var jsonData = eval("(" + result + ")");
                return jsonData;
            }
        }
        //获取FormID字段
        function getFormIDField(iformid) {
            var result = callpostback("/Base/Handler/childTableConfigHandler.ashx", "iformid=" + iformid + "&otype=getFormField", false, true);
            if (result.indexOf("error:") > -1) {
                alert(result.substr(6, result.length - 6));
                return [];
            }
            else {
                var mainFields = eval("(" + result + ")");
                return mainFields;
            }
        }
        //绑定lookup选择
        function bindLookCombox(id, top, left, width, height) {
            $("#" + id).combogrid({
                idField: 'sOrgionName',
                textField: 'sOrgionName',
                columns: [[
                    { field: 'sOrgionName', title: 'lookUp标识', width: 100 },
                    { field: 'sControlName', title: '控件说明', width: 200 },
                    { field: 'iWindow', title: '是否下拉', hidden: true },
                ]],
                data: getLookUpName(),
                onChange: function (newValue, oldValue) {
                    var options = $(this).combogrid("options");
                    var data = options.data;
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].sOrgionName == newValue) {
                            $("#Text41").val(data[i].sReturnField);
                            $("#Text42").val(data[i].sDisplayField);
                            $("#Text45").val(data[i].sControlName);
                            if (data[i].iWindow == "1") {
                                $("#Text23").numberbox("setValue", 150);
                                $("#Text24").numberbox("setValue", 200);
                            } else {
                                $("#Text23").numberbox("setValue", 900);
                                $("#Text24").numberbox("setValue", 400);
                            }
                            $("#divLookUpDetail").dialog({
                                title: "lookUpName详情:" + data[i].sOrgionName,
                                top: top,
                                left: left,
                                width: width,
                                height: height
                            });
                            $("#divLookUpDetail").dialog("open");
                            var a = $("#ifrLookUpDetail")[0];
                            $("#ifrLookUpDetail")[0].width = (parseInt(width) - 50).toString();
                            $("#ifrLookUpDetail")[0].height = (parseInt(height) - 100).toString();
                            document.getElementById("ifrLookUpDetail").src = "columns.htm?show=lookUp&lookUpName=" + data[i].sOrgionName + "&height=" + width + "&random=" + Math.random();
                        }
                    }
                },
                //                onSelect: function (index, row) {
                //                    $("#Text41").val(row.sReturnField);
                //                    $("#Text42").val(row.sDisplayField);
                //                    $("#Text45").val(row.sControlName);
                //                    $("#divLookUpDetail").dialog({
                //                        title: "lookUpName详情:" + row.sOrgionName,
                //                        top: top,
                //                        left: left,
                //                        width: width,
                //                        height: height
                //                    });
                //                    $("#divLookUpDetail").dialog("open");
                //                    var a = $("#ifrLookUpDetail")[0];
                //                    $("#ifrLookUpDetail")[0].width = (parseInt(width) - 50).toString();
                //                    $("#ifrLookUpDetail")[0].height = (parseInt(height) - 100).toString();
                //                    document.getElementById("ifrLookUpDetail").src = "columns.htm?show=lookUp&lookUpName=" + row.sOrgionName + "&height=" + width + "&random=" + Math.random();
                //                },
                filter: function (q, row) {
                    if (row.sOrgionName.indexOf(q) == 0) {
                        return true;
                    }
                    if (row.sControlName.indexOf(q) == 0) {
                        return true;
                    }
                },
                panelWidth: 300
            });
        }
        //绑定formid选择
        function bindFormCombox(id, top, left, width, height) {
            $("#" + id).combogrid({
                idField: 'iFormID',
                textField: 'iFormID',
                columns: [[
                    { field: 'iFormID', title: 'iFormID', width: 80 },
                    { field: 'iMenuID', title: 'iMenuID', width: 60 },
                    { field: 'sBillType', title: '表单名称', width: 200 }
                ]],
                data: getFormID(),
                onChange: function (newValue, oldValue) {
                    var options = $(this).combogrid("options");
                    var data = options.data;
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].iFormID == newValue) {
                            $("#hidMenuID").val(data[i].iMenuID);
                            $("#divForm").dialog({
                                title: "表单:" + data[i].iFormID,
                                top: top,
                                left: left,
                                width: width,
                                height: height
                            });
                            $("#divForm").dialog("open");
                            $("#ifrForm")[0].width = width;
                            $("#ifrForm")[0].height = height;
                            document.getElementById("ifrForm").src = "columns.htm?show=Form&iformid=" + data[i].iFormID + "&height=" + width + "&random=" + Math.random();
                        }
                    }
                },
                //                onSelect: function (index, row) {
                //                    $("#hidMenuID").val(row.iMenuID);
                //                    $("#divForm").dialog({
                //                        title: "表单:" + row.iFormID,
                //                        top: top,
                //                        left: left,
                //                        width: width,
                //                        height: height
                //                    });
                //                    $("#divForm").dialog("open");
                //                    $("#ifrForm")[0].width = width;
                //                    $("#ifrForm")[0].height = height;
                //                    document.getElementById("ifrForm").src = "columns.htm?show=Form&iformid=" + row.iFormID + "&height=" + width + "&random=" + Math.random();
                //                },
                filter: function (q, row) {
                    if (row.iFormID.indexOf(q) == 0) {
                        return true;
                    }
                    if (row.sBillType.indexOf(q) == 0) {
                        return true;
                    }
                },
                panelWidth: 300
            });
        }

        //在文本框光标处插入文本
        function insertAtCursor(myField, myValue) {
            if (myField.tagName == "INPUT") {
                myValue = myValue.replace(/#/g, "");
            }
            //IE support
            if (document.selection) {
                if (getIEVersion() != "9") {
                    myField.focus();
                    sel = document.selection.createRange();
                    sel.text = myValue;
                    sel.select();
                }
                else {
                    myField.focus();
                    moveEnd(myField);
                    sel = document.selection.createRange();
                    sel.text = myValue;
                    sel.select();
                }
            }
                //MOZILLA/NETSCAPE support
            else if (myField.selectionStart || myField.selectionStart == '0') {
                var startPos = myField.selectionStart;
                var endPos = myField.selectionEnd;
                // save scrollTop before insert
                var restoreTop = myField.scrollTop;
                myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
                if (restoreTop > 0) {
                    // restore previous scrollTop
                    myField.scrollTop = restoreTop;
                }
                myField.focus();
                myField.selectionStart = startPos + myValue.length;
                myField.selectionEnd = startPos + myValue.length;
            } else {
                myField.value += myValue;
                myField.focus();
            }
        }
        function moveEnd(obj) {
            obj.focus();
            var len = obj.value.length;
            if (document.selection) {
                var sel = obj.createTextRange();
                sel.moveStart('character', len);
                sel.collapse();
                sel.select();
            } else if (typeof obj.selectionStart == 'number' && typeof obj.selectionEnd == 'number') {
                obj.selectionStart = obj.selectionEnd = len;
            }
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
        function getIEVersion() {
            var flag = true;
            if (navigator.userAgent.indexOf("MSIE") > 0) {
                if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                    flag = "6";
                }
                if (navigator.userAgent.indexOf("MSIE 7.0") > 0) {
                    flag = "7";
                }
                if (navigator.userAgent.indexOf("MSIE 8.0") > 0) {
                    return "8";
                }
                if (navigator.userAgent.indexOf("MSIE 9.0") > 0) {
                    return "9";
                }
            }
            else {
                flag = false;
            }
            if (!flag) {
                return ""
            }
        }

        function dynSave() {
            if ($("#formDyn").form("validate")) {
                $("#formDyn").form("submit", {
                    url: "/Base/Handler/childTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        if (selectedRow) {
                            param.from = "tableDyn";
                            param.iMainRecNo = selectedRow.iRecNo;
                            $.messager.progress({
                                title: "正在保存，请稍候...",
                                text: "正在保存，请稍候..."
                            });
                        }
                        else {
                            $.messager.alert("错误", "请先选择一个子表！");
                        }
                    },
                    success: function (data) {
                        if (data.indexOf("error:") > -1) {
                            var message = data.substr(6, data.length - 6);
                            $.messager.alert("错误", message);
                            $.messager.progress('close');
                        }
                        else if (data == "1") {
                            $.messager.progress('close');
                            refreshTableEvent();
                            $.messager.alert("成功", "保存成功！");
                        }
                    }
                });
            }
        }

        function dynDelete() {
            if (selectedRow) {
                $.messager.confirm("确认删除", "您确定删除动态列定义吗？", function (r) {
                    if (r) {
                        $.ajax({
                            url: "/Base/Handler/childTableConfigHandler.ashx",
                            async: false,
                            cache: false,
                            data: { from: "tableDyn", otype: "remove", iMainRecNo: selectedRow.iRecNo },
                            success: function (data) {
                                if (data == "1") {
                                    $.messager.alert("成功", "删除成功！");
                                }
                                else {
                                    $.messager.alert("失败", data);
                                }
                            }
                        })
                    }
                })
            }
        }

        function validateJS(id, title) {
            var jsCode = $("#" + id).val();
            if (jsCode != "") {
                try {
                    eval("return " + jsCode);
                }
                catch (e) {
                    $.messager.alert("错误", title);
                    return false;
                }
            }
        }

        function turnToTd(event) {
            var tdIndex = undefined;
            var obj = event.srcElement ? event.srcElement : event.target;
            var td = $(obj).parent()[0];
            var tr = $(td).parent()[0];
            var table = $($(tr).parent()[0]).parent()[0];
            var tdChildren = $(tr).children();
            $(tdChildren).each(function (index, element) {
                if (element == td) {
                    tdIndex = index;
                    return false;
                }
            })
            var trChildren = $($(table).children()[0]).children();
            $(trChildren).each(function (index, element) {
                if (element == tr) {
                    //上
                    if (event.keyCode == 38) {
                        //index大于0表示不是第一行
                        if (index > 0) {
                            if ($($(trChildren[index]).children()[0]).children()[0].value == "" && $($(trChildren[index]).children()[2]).children()[0].value == "") {
                                $(trChildren[index]).remove();
                            }
                            $($(trChildren[index - 1]).children()[tdIndex]).children()[0].click();
                            $($(trChildren[index - 1]).children()[tdIndex]).children()[0].focus();
                            $($(trChildren[index - 1]).children()[tdIndex]).children()[0].select();
                        }
                    }
                    //下
                    if (event.keyCode == 40) {
                        if (index < trChildren.length - 1) {
                            $($(trChildren[index + 1]).children()[tdIndex]).children()[0].click();
                            $($(trChildren[index + 1]).children()[tdIndex]).children()[0].focus();
                            $($(trChildren[index + 1]).children()[tdIndex]).children()[0].select();
                        }
                        else {
                            var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                            $($(table).children()[0]).append(trnew);
                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].click();
                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].focus();
                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].select();
                        }
                    }
                    if (event.keyCode == 13 || event.keyCode == 9) {
                        if (tdIndex == 0) {
                            $($(tr).children()[2]).children()[0].click();
                            $($(tr).children()[2]).children()[0].focus();
                            $($(tr).children()[2]).children()[0].select();
                        }
                        else {
                            if (index < trChildren.length - 1) {
                                $($(trChildren[index + 1]).children()[0]).children()[0].click();
                                $($(trChildren[index + 1]).children()[0]).children()[0].focus();
                                $($(trChildren[index + 1]).children()[0]).children()[0].select();
                            }
                            else {
                                var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                                $($(table).children()[0]).append(trnew);
                                $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].click();
                                $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].focus();
                                $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].select();
                            }
                        }
                    }
                    //                    if (event.keyCode == 9) {
                    //                        if (tdIndex == 2 && index == trChildren.length - 1) {
                    //                            var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                    //                            $($(table).children()[0]).append(trnew);
                    //                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].click();
                    //                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].focus();
                    //                            $($($($(table).children()[0]).children(":last-child")).children()[0]).children()[0].select();
                    //                        }
                    //                        return false;
                    //                    }
                    //左
                    if (event.keyCode == 37) {

                    }
                    //右
                    if (event.keyCode == 39) {

                    }
                    return false;
                }
            })
        }

        function getMatchFieldsStr(tableid) {
            var tr = $($("#" + tableid).children()[0]).children();
            var str = "";
            for (var i = 0; i < tr.length; i++) {
                var valueLeft = $($(tr[i]).children()[0]).children()[0].value;
                var valueRight = $($(tr[i]).children()[2]).children()[0].value;
                if (tr.length > 1) {
                    if (valueLeft == "") {
                        $.messager.alert("匹配字段不能为空", "匹配字段左边不能为空");
                        return false;
                    }
                    if (valueRight == "") {
                        $.messager.alert("匹配字段不能为空", "匹配字段右不能为空");
                        return false;
                    }
                }
                else {
                    if (valueLeft == "" && valueRight == "") {
                        return "null";
                    }
                    else {
                        if (valueLeft == "") {
                            $.messager.alert("匹配字段不能为空", "匹配字段左边不能为空");
                            return false;
                        }
                        if (valueRight == "") {
                            $.messager.alert("匹配字段不能为空", "匹配字段右不能为空");
                            return false;
                        }
                    }
                }
                str += valueLeft + "=" + valueRight + ",";
            }
            if (str != "") {
                str = str.substr(0, str.length - 1);
            }
            return str;
        }

        function tableNameChage(newValue, oldValue) {
            if (isInited == true) {
                $("#Text47").textbox("setValue", newValue);
            }
        }

        document.onkeydown = function () {
            var obj = event.srcElement ? event.srcElement : event.target;
            if (event.keyCode == 9 && $(obj).hasClass("fieldPanel")) {  //如果是其它键，换上相应在ascii 码即可。
                return false; //非常重要
            }
        }
    </script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false,split:true" style="height: 160px">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north',border:false" style="height: 20px;">
                FormID:
                <input id="Text8" name="iFormid" class="easyui-textbox" data-options="disabled:true"
                    type="text" />
            </div>
            <div data-options="region:'center',border:false">
                <table id="tableList">
                </table>
            </div>
        </div>
    </div>
    <div data-options="region:'center',border:false">
        <div id="divTabs" class="easyui-tabs" data-options="fit:true,border:false">
            <div title="列定义">
                <table id="tableColumn">
                </table>
            </div>
            <div title="lookUp定义">
                <table id="tableLookUp">
                </table>
            </div>
            <div title="事件定义">
                <div id="divtool" style="width: 100%; height: 35px; line-height: 35px; padding-left: 5px; vertical-align: middle; background-color: #f4f4f4; top: 0; overflow: hidden;"
                    class="easyui-panel">
                    <a id="btnEventSave" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                        onclick="eventSave()">保存</a>
                </div>
                <form id="form4" method="post">
                    <div>
                        <table style="width: 98%;">
                            <tr>
                                <td>增加行前<br />
                                    返回false阻止增加
                                </td>
                                <td>
                                    <textarea id="textarea11" name="sOnBeforeAddRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>增加行后
                                <br />
                                    参数row，增加的行
                                </td>
                                <td>
                                    <textarea id="textarea12" name="sOnAfterAddRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>删除行前
                                <br />
                                    参数rows，要删除的行；返回false，阻止删除
                                </td>
                                <td>
                                    <textarea id="textarea13" name="sOnBeforeDeleteRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>删除行后
                                <br />
                                    参数rows，删除的行
                                </td>
                                <td>
                                    <textarea id="textarea14" name="sOnAfterDeleteRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>编辑前<br />
                                    onBeforeEdit(index, row)
                                </td>
                                <td>
                                    <textarea id="textarea7" name="sOnBeforeEdit" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>开始编辑<br />
                                    onBeginEdit(index, row)
                                </td>
                                <td>
                                    <textarea id="textarea8" name="sOnBeginEdit" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>结束编辑<br />
                                    onEndEdit(index, row, changes)
                                </td>
                                <td>
                                    <textarea id="textarea9" name="sOnEndEdit" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>编辑后<br />
                                    onAfterEdit(index, row, changes)
                                </td>
                                <td>
                                    <textarea id="textarea10" name="sOnAfterEdit" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 30px; width: 220px;">单击行<br />
                                    onClickRow(index, row)
                                </td>
                                <td>
                                    <textarea id="textareaClickRow" name="sOnClickRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>双击行<br />
                                    onDblClickRow(index, row)
                                </td>
                                <td>
                                    <textarea id="textarea4" name="sOnDblClickRow" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>单击单元格<br />
                                    onClickCell(index, field, value)
                                </td>
                                <td>
                                    <textarea id="textarea5" name="sOnClickCell" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>双击单元格<br />
                                    onDblClickCell(index, field, value)
                                </td>
                                <td>
                                    <textarea id="textarea6" name="sOnDblClickCell" style="width: 100%; height: 150px;">
                                
                            </textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div title="导入按钮设置">
                <table id="tableImport">
                </table>
            </div>
            <div title="公式定义">
                <table id="tableExp">
                </table>
            </div>
            <div title="动态列定义">
                <div style="width: 100%; height: 35px; line-height: 35px; padding-left: 5px; vertical-align: middle; background-color: #f4f4f4; top: 0; overflow: hidden;"
                    class="easyui-panel">
                    <a id="btnSave" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                        onclick="dynSave()">保存</a> <a id="A1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
                            onclick="dynDelete()">删除</a>
                </div>
                <div>
                    <form id="formDyn" method="post">
                        <table>
                            <tr>
                                <td>主表触发字段
                                </td>
                                <td>
                                    <input id="Text2" type="text" class="easyui-combobox" name="sTriggerField" />
                                </td>
                                <td>列位置
                                </td>
                                <td>
                                    <input id="Text34" type="text" class="easyui-numberspinner" name="iColumnIndex" style="width: 50px;" />
                                </td>
                            </tr>
                            <tr>
                                <td>列源
                                </td>
                                <td>
                                    <input id="Text4" type="text" class="easyui-textbox" name="sColumnSource" data-options="width:300,height:200,multiline:true,required:true,missingMessage:'{this}表示选择的值'" />
                                </td>
                                <td>列数据源
                                </td>
                                <td>
                                    <input id="Text5" type="text" class="easyui-textbox" name="sColumnDataSource" data-options="required:true,width:300,height:200,multiline:true,missingMessage:'{column}表示列名'" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">目标表名
                                <input id="Text28" type="text" class="easyui-textbox" name="sTableName" data-options="required:true,width:100" />
                                </td>
                                <td>列宽<input id="Text46" type="text" class="easyui-numberspinner" name="iWidth" data-options="width:80,value:50" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">列对应字段
                                <input id="Text32" type="text" class="easyui-textbox" name="sColumnMatchField" data-options="required:true,missingMessage:'列名保存到表中的哪个字段',width:100" />
                                    &nbsp;&nbsp; 列值对应字段
                                <input id="Text33" type="text" class="easyui-textbox" name="sColumnValueMatchField"
                                    data-options="required:true,missingMessage:'列值保存到表中的哪个字段',width:100" />
                                    &nbsp;&nbsp;
                                <input id="dynSum" type="checkbox" name="iSummary" />
                                    <label for="dynSum">
                                        合计</label>
                                    主表合计字段<input id="Text43" type="text" class="easyui-textbox" name="sSummaryFieldM"
                                        data-options="width:100" />
                                    &nbsp; 子表合计字段<input id="Text44" type="text" class="easyui-textbox" name="sSummaryFieldD"
                                        data-options="width:100" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
            <div title="导入模板">
                <iframe id="ifrImportExcel" width="100%" height="99%" frameborder='0'></iframe>
            </div>
            <div title="打印模板选择">
                <div id="divtoolPb" style="width: 100%; height: 35px; line-height: 35px; padding-left: 5px; vertical-align: middle; background-color: #f4f4f4; top: 0; overflow: hidden;"
                    class="easyui-panel">
                    <a id="btnEventSavePb" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                        onclick="eventSavePb()">保存</a>
                </div>
                <form id="form7">
                    <div>
                        <table>
                            <tr>
                                <td>打印模板
                                </td>
                                <td>
                                    <input id="Text211" type="text" class="easyui-combobox" style="width: 300px;" name="sPbRecNos" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
        </div>
        <div id="divDetail" style="text-align: center;">
            <form id="form1" method="post">
                <table>
                    <tr>
                        <td style="text-align: left">序号
                        </td>
                        <td class="style1">
                            <input id="Text7" name="iSerial" class="easyui-textbox" data-options="width:50" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">表名
                        </td>
                        <td class="style1">
                            <input id="Text1" name="sTableName" class="easyui-textbox" data-options="width:150,required:true,missingMessage:'表名不能为空！',invalidMessage:'表名不能为空！'"
                                type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">主键表名
                        </td>
                        <td class="style1">
                            <input id="Text47" name="sSerialTableName" class="easyui-textbox" data-options="width:150,required:true,missingMessage:'主键表名不能为空！',invalidMessage:'主键表名不能为空！'"
                                type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">主键
                        </td>
                        <td class="style1">
                            <input id="Text12" name="sFieldKey" class="easyui-textbox" data-options="width:150,required:true,missingMessage:'主键不能为空！',invalidMessage:'主键不能为空！'"
                                type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">SQL语句
                        </td>
                        <td style="text-align: left" class="style1">
                            <%--<input id="TextArea3" name="sSql" class="easyui-textbox" data-options="required:true,missingMessage:'SQL不能为空，并在正确的位置加入{condition}！',invalidMessage:'SQL不能为空，并在正确的位置加入{condition}！',width:300,height:100" />--%>
                            <textarea id="TextArea3" name="sSql" class="easyui-validatebox" data-options="required:true,missingMessage:'SQL不能为空，并在正确的位置加入{condition}！',invalidMessage:'SQL不能为空，并在正确的位置加入{condition}！'"
                                style="width: 300px; height: 100px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">对应字段
                        </td>
                        <td class="style1">
                            <input id="Text3" name="sLinkField" type="text" class="easyui-textbox" data-options="width:150,missingMessage:'iRecNo=iMainRecNo,主在前，子在后',required:true,invalidMessage:'iRecNo=iMainRecNo,主在前，子在后'" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">排序
                        </td>
                        <td class="style1">
                            <input id="Text14" name="sOrder" type="text" class="easyui-textbox" data-options="width:150,prompt:'如:iSerial asc'" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">停用
                        </td>
                        <td class="style1">
                            <input id="Text20" name="iDisabled" type="checkbox" />
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div id="divColumnDetail" style="text-align: center;">
            <form id="form2" method="post">
                <table style="margin: auto;">
                    <tr>
                        <td style="text-align: left">序号
                        </td>
                        <td class="style1">
                            <input id="Text9" name="iSerial" class="easyui-textbox" data-options="width:50" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">子段名
                        </td>
                        <td class="style1">
                            <input id="Text10" name="sFieldName" class="easyui-textbox" data-options="width:150,required:true,missingMessage:'子段名不能为空！',invalidMessage:'子段名不能为空！'"
                                type="text" />
                        </td>
                        <td style="text-align: left">显示名
                        </td>
                        <td class="style1">
                            <input id="Text11" name="sTitle" class="easyui-textbox" data-options="width:150,"
                                type="text" />
                        </td>
                    </tr>
                    <tr>
                    </tr>
                    <tr>
                        <td style="text-align: left">数据类型
                        </td>
                        <td style="text-align: left" class="style1">
                            <select id="cc" class="easyui-combobox" name="sType" style="width: 150px;" data-options="editable:false">
                                <option>字符</option>
                                <option>整数</option>
                                <option>数据</option>
                                <option>日期</option>
                                <option>时间</option>
                                <option>逻辑</option>
                                <option>备注</option>
                                <option>图片</option>
                                <option>多图片</option>
                                <option>附件</option>
                            </select>
                        </td>
                        <td style="text-align: left">小数位数
                        </td>
                        <td style="text-align: left" class="style1">
                            <input id="Text15" name="iDigit" value="2" class="easyui-numberbox" data-options="width:100,precision:0,disabled:true"
                                type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">默认值
                        </td>
                        <td class="style1">
                            <input id="Text16" name="sDefaultValue" type="text" class="easyui-textbox" data-options="width:150" />
                        </td>
                        <td style="text-align: left">宽度
                        </td>
                        <td class="style1">
                            <input id="Text13" name="fWidth" type="text" class="easyui-textbox" data-options="width:150,prompt:'默认100'" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center">
                            <input id="Checkbox3" name="iRequired" type="checkbox" />
                            <label for="Checkbox3">
                                必填</label>&nbsp;&nbsp; &nbsp; &nbsp;
                        <input id="Checkbox2" name="iHidden" type="checkbox" />
                            <label for="Checkbox2">
                                隐藏</label>&nbsp; &nbsp; &nbsp; &nbsp;
                        <input id="Checkbox1" name="iEdit" type="checkbox" />
                            <label for="Checkbox1">
                                只读</label>&nbsp; &nbsp; &nbsp; &nbsp;
                        <input id="Checkbox4" name="iAutoAdd" type="checkbox" />
                            <label for="Checkbox4">
                                自增</label>&nbsp; &nbsp; &nbsp; &nbsp;
                        <input id="Checkbox16" name="iFix" type="checkbox" />
                            <label for="Checkbox16">
                                固定</label>&nbsp; &nbsp; &nbsp; &nbsp;
                        <input id="Checkbox17" name="iNoCopy" type="checkbox" />
                            <label for="Checkbox17">
                                不可复制</label>
                            <!--步数<input id="Text17" name="iStep" class="easyui-textbox" value="1" data-options="width:40,disabled:true" type="text" />-->
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <input id="Checkbox11" name="iSum" type="checkbox" />
                            <label for="Checkbox11">
                                求和</label>
                            &nbsp; 主表字段<input id="txtSumMainField" class="easyui-combobox" data-options="width:100,valueField:'field',textField:'field',editable:true"
                                name="sSumMainField" type="text" />
                        </td>
                        <td colspan="2" style="text-align: left;">
                            <input id="Checkbox12" name="iAvg" type="checkbox" />
                            <label for="Checkbox12">
                                求平均</label>
                            &nbsp; 主表字段<input id="txtAvgMainField" class="easyui-combobox" data-options="width:100,valueField:'field',textField:'field',editable:true"
                                name="sAvgMainField" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <input id="Checkbox13" name="iCount" type="checkbox" />
                            <label for="Checkbox13">
                                求个数</label>
                            &nbsp; 主表字段<input id="txtCountMainField" class="easyui-combobox" data-options="width:100,valueField:'field',textField:'field',editable:true"
                                name="sCountMainField" type="text" />
                        </td>
                        <td colspan="2" style="text-align: left;">
                            <input id="Checkbox14" name="iMax" type="checkbox" />
                            <label for="Checkbox14">
                                求最大值</label>
                            &nbsp; 主表字段<input id="txtMaxMainField" class="easyui-combobox" data-options="width:100,valueField:'field',textField:'field',editable:true"
                                name="sMaxMainField" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <input id="Checkbox15" name="iMin" type="checkbox" />
                            <label for="Checkbox15">
                                求最小值</label>
                            &nbsp; 主表字段<input id="txtMinMainField" class="easyui-combobox" data-options="width:100,valueField:'field',textField:'field',editable:true"
                                name="sMinMainField" type="text" />
                        </td>
                        <td>合计小数位数
                        </td>
                        <td>
                            <input id="Text161" name="iSummryDigit" type="text" class="easyui-numberspinner" data-options="width:100" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">背景色JS
                        </td>
                        <td colspan="3" style="text-align: left;">
                            <textarea id="TextArea1" name="sStyle" class="easyui-tooltip" data-options="position:'right'"
                                title="直接写函数体<br />参数：value(列值),row(当前行数据),index（当前行索引）<br />例如：if (value < 20){<br />return 'background-color:#ffee00;color:red;';<br />}"
                                style="width: 350px; height: 80px;"></textarea>
                            <%-- <input id="Text47" name="sStyle" type="text" class="easyui-textbox" data-options="width:200,height:80,multiline:true" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">隐藏条件Sql
                        </td>
                        <td colspan="3" style="text-align: left;">
                            <textarea id="TextArea2" name="sHideSql" class="easyui-tooltip" data-options="position:'right'"
                                title="可用参数{userid}，sql语句有返回行即表示字段隐藏" style="width: 350px; height: 80px;"></textarea>
                            <%-- <input id="Text47" name="sStyle" type="text" class="easyui-textbox" data-options="width:200,height:80,multiline:true" />--%>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div id="divLookUp">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" style="width: 480px; height: 490px;">
                    <form id="form3" method="post">
                        <table style="margin: auto;">
                            <tr>
                                <td>序号
                                </td>
                                <td>
                                    <input id="Text26" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                                        type="text" />
                                </td>
                                <td>停用
                                </td>
                                <td>
                                    <input id="Text21" name="iDisabled" type="checkbox" />
                                </td>
                            </tr>
                            <tr>
                                <td>字段
                                </td>
                                <td>
                                    <input id="Text27" name="sFieldName" class="easyui-combogrid" data-options="required:true,missingMessage:'子段不能为空',invalidMessage:'子段不能为空',width:150"
                                        type="text" />
                                </td>
                                <td>lookUp标识符
                                </td>
                                <td>
                                    <input id="Text17" name="sLookUpName" class="easyui-combogrid" data-options="idField:'sOrgionName',textField:'sOrgionName',required:true,missingMessage:'lookUp标识符不能为空',invalidMessage:'lookUp标识符不能为空',width:150"
                                        type="text" />
                                </td>
                            </tr>
                            <tr>
                                <td>执行条件(JS)
                                </td>
                                <td colspan="3">
                                    <textarea id="TextArea18" style="width: 400px; height: 50px;" title="对应lookUp的IsConditionFit事件，可直接写在页面上便于调试。返回true才成立"
                                        name="sCondition"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>选择字段
                                </td>
                                <td>
                                    <input id="Text18" name="sFields" class="easyui-textbox" data-options="prompt:'默认为全部字段'"
                                        type="text" />
                                </td>
                                <td>查询条件字段
                                </td>
                                <td>
                                    <input id="Text19" type="text" name="sSearchFields" class="easyui-textbox" data-options="prompt:'默认为全部字段'" />
                                </td>
                            </tr>
                            <tr>
                                <td>匹配字段
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text20" type="text" name="sMatchFields" class="easyui-validatebox easyui-tooltip fieldPanel"
                                title="目标在前，返回的值在后,以逗号隔开。如:tid=sid,tid1=sid1" data-options="required:true,missingMessage:'目标在前，返回的值在后,以逗号隔开。如:tid=sid,tid1=sid1',invalidMessage:'不能为空'"
                                style="width: 400px;" />-->
                                    <%--<textarea name="sMatchFields" class="easyui-validatebox easyui-tooltip fieldPanel"
                                    title="目标在前，返回的值在后,以逗号隔开。如:tid=sid,tid1=sid1" data-options="content:'目标在前，返回的值在后,以逗号隔开。如:tid=sid,tid1=sid1'"
                                    style="width: 400px; height: 120px; display: none;"></textarea>--%>
                                    <div style="height: 122px; overflow-y: auto; border: 1px solid #a0a0a0;">
                                        <table id="tabLookMatchFields" class="tabMatch">
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>修改浏览匹配字段<br />
                                    (只对手机表单有效)
                                </td>
                                <td colspan="4">
                                    <textarea name="sEditMatchFields" style="width: 400px; height: 50px;"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>固定查询条件(sql)
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text21" type="text" name="sFixFilters" class="easyui-tooltip fieldPanel"
                                title="取其他字段用{field}来表示，主表用{m.field}" style="width: 400px" />-->
                                    <textarea name="sFixFilters" class="easyui-tooltip fieldPanel" title="取其他字段用#field#来表示，主表用#m.field#"
                                        style="width: 400px; height: 50px;"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>变动查询条件(sql)
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text22" type="text" name="sChangeFilters" class="easyui-tooltip fieldPanel"
                                title="取其他字段用{field}来表示，主表用{m.field}" style="width: 400px" />-->
                                    <textarea name="sChangeFilters" class="easyui-tooltip fieldPanel" title="取其他字段用#field#来表示，主表用#m.field#"
                                        style="width: 400px; height: 50px;"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>宽度
                                </td>
                                <td>
                                    <input id="Text23" type="text" name="fWidth" class="easyui-numberbox" data-options="precision:0" />
                                </td>
                                <td>高度
                                </td>
                                <td>
                                    <input id="Text24" type="text" name="fHeight" class="easyui-numberbox" data-options="precision:0" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input id="Checkbox5" type="checkbox" name="iMulti" />
                                    <label for="Checkbox5">
                                        多选</label>
                                    &nbsp;&nbsp;
                                <input id="Checkbox9" type="checkbox" name="iEdit" checked="checked" />
                                    <label for="Checkbox9">
                                        可编辑</label>
                                </td>
                                <td>页大小
                                </td>
                                <td>
                                    <input id="Text25" type="text" name="iPageSize" class="easyui-numberbox" data-options="precision:0" />
                                </td>
                            </tr>
                            <tr>
                                <td>下拉数据过滤方法，参数data(数据源),返回数组。
                                </td>
                                <td colspan="3">
                                    <textarea name="sComboLoadFilters" class="easyui-tooltip" title="只对子表下拉和下拉树起作用，可调用Page对象等<br />例如：<br />var dataP=[];<br />for(var i=0;i《data.length;i++){<br />if(data[i].sCode!='master'){<br />dataP.push(data[i]);<br />} return dataP; <br />}"
                                        style="width: 400px; height: 60px;"></textarea>
                                </td>
                            </tr>
                            <%--<tr>
                            <td>
                                打开前执行(js)
                            </td>
                            <td colspan="3">
                                <textarea id="TextArea1" class="easyui-textarea" name="sBeforeOpen" title="对应lookUp的beforeOpen事件，可直接写在页面上便于调试。返回false阻止弹窗"
                                    style="width: 400px; height: 80px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                选择后执行(js，参数data)
                            </td>
                            <td colspan="3">
                                <textarea id="TextArea2" class="easyui-textarea" name="sAfterSelected" title="对应lookUp的afterSelected事件，可直接写在页面上便于调试。"
                                    style="width: 400px; height: 80px;"></textarea>
                            </td>
                        </tr>--%>
                        </table>
                    </form>
                </div>
                <div data-options="region:'east',split:true" style="width: 330px; height: 490px;">
                    <iframe id="ifrLookUp" frameborder="0" width="100%" height="99%"></iframe>
                    <%--<table>
                    <tr>
                        <td valign="top">
                            <iframe id="ifrLookUp" frameborder="0"></iframe>
                        </td>
                    </tr>
                </table>--%>
                </div>
            </div>
        </div>
        <div id="divImport">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" style="width: 570px; height: 450px;">
                    <form id="form5" method="post">
                        <table style="margin: auto;">
                            <tr>
                                <td>序号
                                </td>
                                <td>
                                    <input id="Text6" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                                        type="text" />
                                    停用<input id="Checkbox10" type="checkbox" name="iDisabled" />
                                    <input id="hidMenuID" type="hidden" name="iMenuID" />
                                </td>
                                <td>类型
                                </td>
                                <td>
                                    <select id="selectImport" class="easyui-combobox" name="sType">
                                        <option>从表单导入</option>
                                        <option>从lookUp导入</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="spanId">FormID</span>
                                </td>
                                <td>
                                    <input id="Text29" name="sIden" class="easyui-combogrid" data-options="required:true,missingMessage:'不能为空',invalidMessage:'不能为空',width:150"
                                        type="text" />
                                </td>
                                <td>标题
                                </td>
                                <td>
                                    <input id="Text30" name="sTitle" class="easyui-textbox" data-options="required:true,missingMessage:'不能为空',invalidMessage:'不能为空',width:150"
                                        type="text" />
                                </td>
                            </tr>
                            <tr>
                                <td>匹配字段
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text32" type="text" name="sMatchFields" style="width: 380px;" class="easyui-validatebox fieldPanel"
                                title="目标在前返回在后,以逗号隔开。如:sTCode=sSCode" data-options="required:true,missingMessage:'目标在前返回在后,以逗号隔开。如:sTCode=sSCode'" />-->
                                    <%--<textarea name="sMatchFields" style="width: 380px; height: 100px;" class="easyui-validatebox fieldPanel"
                                    title="目标在前返回在后,以逗号隔开。如:sTCode=sSCode" data-options="required:true,missingMessage:'目标在前返回在后,以逗号隔开。如:sTCode=sSCode'"></textarea>--%>
                                    <div style="height: 122px; overflow-y: auto; border: 1px solid #a0a0a0;">
                                        <table id="tabImportMatchFields" class="tabMatch">
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>宽度
                                </td>
                                <td>
                                    <input id="Text35" type="text" name="iWidth" class="easyui-numberbox" data-options="precision:0" />
                                </td>
                                <td>高度
                                </td>
                                <td>
                                    <input id="Text36" type="text" name="iHeight" class="easyui-numberbox" data-options="precision:0" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input id="Checkbox6" type="checkbox" name="iMulti" />
                                    <label for="Checkbox6">
                                        多选</label>
                                    &nbsp;&nbsp;
                                    显示样式
                                    <select id="selImportStyle" name="sStyle" class="easyui-combobox">
                                        <option>弹窗</option>
                                        <option>tab</option>
                                    </select>
                                </td>
                                <td>分组
                                </td>
                                <td>
                                    <input id="Checkbox18" type="text" name="sGroup" class="easyui-textbox" />
                                </td>
                            </tr>
                            <tr>
                                <td>固定查询条件(sql)
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text33" type="text" name="sFixFilters" class="easyui-tooltip fieldPanel"
                                            style="width: 380px;" title="取其他字段用{field}来表示，主表用{m.field}" data-options="prompt:'取其他字段用{field}来表示，主表用{m.field}',width:400" />-->
                                    <textarea name="sFixFilters" class="easyui-tooltip fieldPanel" style="width: 380px; height: 50px"
                                        title="取其他字段用#field#来表示，主表用#m.field#" data-options="prompt:'取其他字段用#field#来表示，主表用{m.field}'"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>变动查询条件(sql)
                                </td>
                                <td colspan="3">
                                    <!--<input id="Text34" type="text" name="sChangeFilters" class="easyui-tooltip fieldPanel"
                                            style="width: 380px;" title="取其他字段用{field}来表示，主表用{m.field}" data-options="prompt:'取其他字段用{field}来表示，主表用{m.field}',width:400" />-->
                                    <textarea name="sChangeFilters" class="easyui-tooltip fieldPanel" style="width: 380px; height: 50px;"
                                        title="取其他字段用#field#来表示，主表用#m.field#" data-options="prompt:'取其他字段用#field#来表示，主表用#m.field#'"></textarea>
                                </td>
                            </tr>
                            <%--<tr>
                            <td>
                                打开前执行(js)
                            </td>
                            <td colspan="3">
                                <textarea id="TextArea15" class="easyui-textarea" title="分别对应lookup和dataform的beforeOpen事件，可直接写在页面上便于调试，返回false阻止弹窗"
                                    name="sOnBeforeOpen" style="width: 400px; height: 80px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                选择后执行(js,参数data)
                            </td>
                            <td colspan="3">
                                <textarea id="TextArea16" class="easyui-textarea" name="sOnSelected" title="分别对应lookup和dataform的afterSelected事件，可直接写在页面上便于调试，"
                                    style="width: 400px; height: 80px;"></textarea>
                            </td>
                        </tr>--%>
                            <tr>
                                <td colspan="4">
                                    <table id="lookUpOnly" style="display: none;">
                                        <tr>
                                            <td>选择字段
                                            </td>
                                            <td>
                                                <input id="Text30" name="sFields" class="easyui-textbox" data-options="prompt:'默认为全部字段',width:150"
                                                    type="text" />
                                            </td>
                                            <td>条件字段
                                            </td>
                                            <td>
                                                <input id="Text31" type="text" name="sSearchFields" class="easyui-textbox" data-options="prompt:'默认为全部字段',width:150" />
                                            </td>
                                        </tr>
                                        <%--<tr>
                                        <td>
                                            固定查询条件(sql)
                                        </td>
                                        <td colspan="3">
                                            <!--<input id="Text33" type="text" name="sFixFilters" class="easyui-tooltip fieldPanel"
                                            style="width: 380px;" title="取其他字段用{field}来表示，主表用{m.field}" data-options="prompt:'取其他字段用{field}来表示，主表用{m.field}',width:400" />-->
                                            <textarea name="sFixFilters" class="easyui-tooltip fieldPanel" style="width: 380px;
                                                height: 50px" title="取其他字段用#field#来表示，主表用#m.field#" data-options="prompt:'取其他字段用#field#来表示，主表用{m.field}'"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            变动查询条件(sql)
                                        </td>
                                        <td colspan="3">
                                            <!--<input id="Text34" type="text" name="sChangeFilters" class="easyui-tooltip fieldPanel"
                                            style="width: 380px;" title="取其他字段用{field}来表示，主表用{m.field}" data-options="prompt:'取其他字段用{field}来表示，主表用{m.field}',width:400" />-->
                                            <textarea name="sChangeFilters" class="easyui-tooltip fieldPanel" style="width: 380px;
                                                height: 50px;" title="取其他字段用#field#来表示，主表用#m.field#" data-options="prompt:'取其他字段用#field#来表示，主表用#m.field#'"></textarea>
                                        </td>
                                    </tr>--%>
                                        <tr>
                                            <td>页大小
                                            </td>
                                            <td>
                                                <input id="Text37" type="text" name="iPageSize" class="easyui-numberbox" data-options="precision:0,width:50" />
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="dataFormOnly">
                                        <%--<tr>
                                        <td>
                                            过滤条件(sql)
                                        </td>
                                        <td colspan="3">
                                            <textarea name="sFilters" class="easyui-tooltip fieldPanel" title="取其他字段用#field#来表示"
                                                style="width: 380px; height: 50px;" data-options="messingMessage:'取其他字段用#field#来表示'"></textarea>
                                        </td>
                                    </tr>--%>
                                        <tr>
                                            <td colspan="2">
                                                <input id="Checkbox7" type="checkbox" name="iTree" />
                                                <label for="Checkbox7">
                                                    显示树
                                                </label>
                                            </td>
                                            <td colspan="2">
                                                <input id="Checkbox8" type="checkbox" name="iCover" />
                                                <label for="Checkbox8">
                                                    覆盖原数据</label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div data-options="region:'east',split:true" style="width: 300px; height: 450px;">
                    <iframe id="ifrImport" frameborder="0" width="100%" height="99%"></iframe>
                </div>
            </div>
        </div>
        <div id="divExp">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" style="width: 350px; height: 150px;">
                    <form id="form6" method="post">
                        <table style="margin: auto;">
                            <tr>
                                <td>序号
                                </td>
                                <td>
                                    <input id="Text38" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                                        type="text" />
                                </td>
                                <td>停用
                                </td>
                                <td>
                                    <input id="Text22" name="iDisabled" type="checkbox" />
                                </td>
                            </tr>
                            <tr>
                                <td>触发字段
                                </td>
                                <td>
                                    <input id="Text39" name="sSourceField" type="text" />
                                </td>
                                <td>目标字段
                                </td>
                                <td>
                                    <input id="Text40" name="sTargetField" type="text" />
                                </td>
                            </tr>
                            <tr>
                                <td>执行条件(js)
                                </td>
                                <td colspan="3">
                                    <textarea id="TextArea17" style="width: 300px; height: 100px;" name="sCondition"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>公式(js)
                                </td>
                                <td colspan="3">
                                    <textarea id="textareaExp" class="fieldPanel" style="width: 300px; height: 100px"
                                        name="sExpression">
                        
                    </textarea>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div data-options="region:'east',split:true" style="width: 350px; height: 150px;">
                    <table>
                        <tr>
                            <td style="vertical-align: top;">
                                <iframe id="ifrExp" frameborder="0"></iframe>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="divLookUpDetail">
            <table>
                <tr>
                    <td>控件说明
                    </td>
                    <td>
                        <input id="Text45" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>返回字段
                    </td>
                    <td>
                        <input id="Text41" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>显示字段
                    </td>
                    <td>
                        <input id="Text42" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <iframe frameborder="0" id="ifrLookUpDetail" style="margin: 0px; padding: 0px;"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divForm">
            <iframe frameborder="0" id="ifrForm" style="margin: 0px; padding: 0px;"></iframe>
        </div>
    </div>
</body>
</html>
