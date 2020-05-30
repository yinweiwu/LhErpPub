<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>主表设置</title>
    <style type="text/css">
        body
        {
            margin: 0px;
            padding: 0px;
            font-family: Verdana;
        }
        .tabMatch
        {
            margin: 0px;
            padding: 0px;
            border-collapse: collapse;
        }
        .tabMatch tr td
        {
        }
        .tabMatch tr td input
        {
            font-size: 12px;
            width: 150px;
        }
        .txb
        {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var needRefresh = false;
        var mainFields;
        var focusText = undefined;
        var lastType = undefined;
        $(function () {
            var iformid = getQueryString("iformid");

            var formFields = callpostback("/Base/Handler/mainTableConfigHandler.ashx", "iformid=" + iformid + "&otype=getFormField", true, true, function (resultText) {
                if (resultText.indexOf("error:") > -1) {
                    alert(resultText.substr(6, resultText.length - 6));
                }
                else {
                    try {
                        var jsonObj = eval("(" + resultText + ")");
                        mainFields = jsonObj;
                        $("#Text2").combobox({
                            valueField: 'field',
                            textField: 'field',
                            data: jsonObj.rows,
                            width: 150,
                            required: true
                        });
                        $("#Text5").combobox({
                            valueField: 'field',
                            textField: 'field',
                            data: jsonObj.rows,
                            width: 150,
                            required: true
                        });
                        $("#Text8").combobox({
                            valueField: 'field',
                            textField: 'field',
                            data: jsonObj.rows,
                            width: 150,
                            required: true
                        });
                        $("#Text39").combobox({
                            data: jsonObj.rows,
                            valueField: 'field',
                            textField: 'field',
                            required: true,
                            missingMessage: '不可空',
                            width: 100
                        });
                        $("#Text40").combobox({
                            data: jsonObj.rows,
                            valueField: 'field',
                            textField: 'field',
                            required: true,
                            missingMessage: '不可空',
                            width: 100
                        });
                    }
                    catch (e) {
                        alert(resultText);
                    }
                }
            });

            $("#divDefault").dialog({
                width: 300,
                height: 200,
                modal: true,
                top: 50,
                left: 100
            });
            $("#divDefault").dialog("close");
            $("#divRequired").dialog({
                width: 350,
                height: 200,
                modal: true,
                top: 50,
                left: 100
            });
            $("#divRequired").dialog("close");

            $("#divForm").dialog({
                width: 250,
                height: 600,
                modal: false
            });
            $("#divLookUpDetail").dialog({
                modal: false,
                width: 250,
                height: 600
            });
            $("#divLookUpDetail").dialog("close");
            $("#divForm").dialog({
                width: 250,
                height: 600
            });
            $("#divForm").dialog("close");
            $("#divLookUp").dialog({
                width: 730,
                height: 600,
                //modal: true,
                top: 50,
                left: 100,
                closable: false,
                onClose: function () {
                    $("#divLookUpDetail").dialog("close");
                    $("#divForm").dialog("close");
                }
            });
            $("#divLookUp").dialog("close");
            $("#divExp").dialog({
                width: 630,
                height: 350,
                modal: true,
                top: 50,
                left: 100
            });
            $("#divExp").dialog("close");

            $("#tableDefault").datagrid({
                fit: true,
                border: false,
                columns: [[
                    { field: "iSerial", title: "序号", width: 50 },
                    { field: "sFieldName", title: "字段", width: 150 },
                    { field: "sDefaultValue", title: "默认值", width: 300 },
                    { field: "iDisabled", title: "停用", width: 50, formatter: function (value, row, index) {
                        if (value == "1") {
                            return "是";
                        } else {
                            return "否";
                        }
                    }
                    }
                ]],
                toolbar:
                [
                    {
                        iconCls: 'icon-add',
                        text: '增加',
                        handler: function () {
                            $("#form1").form("clear");
                            $("#form1").form("load", { iSerial: '0' });
                            $("#divDefault").dialog({
                                title: '默认值增加',
                                toolbar: [{
                                    text: '保存',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addDefault(0);
                                    }
                                },
                                {
                                    text: '保存并继续',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addDefault(1);
                                    }
                                },
                                {
                                    text: '关闭',
                                    iconCls: "icon-no",
                                    handler: function () {
                                        $("#divDefault").dialog("close");
                                    }
                                }
                                ]
                            });
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: '编辑',
                        handler: function () {
                            editDefault();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: '删除',
                        handler: function () {
                            var selectedRow = $("#tableDefault").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除'" + selectedRow.sFieldName + "'的默认值吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form1").form("submit", {
                                            url: "/Base/Handler/mainTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableDefault";
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
                                                    $("#divDefault").dialog("close");
                                                    var index = $("#tableDefault").datagrid("getRowIndex", selectedRow);
                                                    refreshTableDefault();
                                                    if ($("#tableDefault").datagrid("getRows").length > index) {
                                                        $("#tableDefault").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableDefault").datagrid("getRows").length > 0) {
                                                        $("#tableDefault").datagrid("selectRow", $("#tableList").datagrid("getRows").length - 1);
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
                onDblClickRow: function (index, row) {
                    editDefault();
                },
                idField: "iRecNo",
                singleSelect: true
            });
            var defaultData = [{ text: 'UserID' }, { text: 'UserName' }, { text: 'CurrentDate' }, { text: 'CurrentDateTime' }, { text: 'Departid' }, { text: 'NewGUID'}];
            $("#Text3").combobox({
                data: defaultData,
                valueField: 'text',
                textField: 'text',
                required: true,
                width: 150,
                editable: true
            });

            $("#tableRequired").datagrid({
                fit: true,
                border: false,
                columns: [[
                    { field: "iSerial", title: "序号", width: 50 },
                    { field: "sFieldName", title: "字段", width: 150 },
                    { field: "sRequiredTip", title: "为空提示", width: 300 },
                    { field: "iDisabled", title: "停用", width: 50, formatter: function (value, row, index) {
                        if (value == "1") {
                            return "是";
                        } else {
                            return "否";
                        }
                    }
                    }
                ]],
                toolbar:
                [
                    {
                        iconCls: 'icon-add',
                        text: '增加',
                        handler: function () {
                            $("#form2").form("clear");
                            $("#form2").form("load", { iSerial: '0' });
                            $("#divRequired").dialog({
                                title: '必填项增加',
                                toolbar: [{
                                    text: '保存',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addRequired(0);
                                    }
                                },
                                {
                                    text: '保存并继续',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addRequired(1);
                                    }
                                },
                                {
                                    text: '关闭',
                                    iconCls: "icon-no",
                                    handler: function () {
                                        $("#divRequired").dialog("close");
                                    }
                                }
                                ]
                            });
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: '编辑',
                        handler: function () {
                            editRequired();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: '删除',
                        handler: function () {
                            var selectedRow = $("#tableRequired").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除必填项'" + selectedRow.sFieldName + "'吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form2").form("submit", {
                                            url: "/Base/Handler/mainTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableRequired";
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
                                                    $("#divRequired").dialog("close");
                                                    var index = $("#tableRequired").datagrid("getRowIndex", selectedRow);
                                                    refreshTableRequired();
                                                    if ($("#tableRequired").datagrid("getRows").length > index) {
                                                        $("#tableRequired").datagrid("selectRow", index);
                                                    }
                                                    else if ($("#tableRequired").datagrid("getRows").length > 0) {
                                                        $("#tableRequired").datagrid("selectRow", $("#tableRequired").datagrid("getRows").length - 1);
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
                onDblClickRow: function (index, row) {
                    editRequired();
                },
                idField: "iRecNo",
                singleSelect: true
            });

            $("#tableLookUp").datagrid({
                fit: true,
                border: false,
                columns: [[
                    { field: 'iRecNo', title: '唯一号', width: 60 },
                    { field: "iSerial", title: "序号", width: 50 },
                    { field: "sFieldName", title: "字段", width: 150 },
                    { field: "sType", title: "类型", width: 100 },
                    { field: "sIden", title: "标识符", width: 150 },
                    { field: "sMatchFields", title: "匹配字段", width: 300 },
                    { field: "iWidth", title: "宽度", width: 80 },
                    { field: "iHeight", title: "高度", width: 80 },
                    { field: "iDisabled", title: "停用", width: 50, formatter: function (value, row, index) {
                        if (value == "1") {
                            return "是";
                        } else {
                            return "否";
                        }
                    }
                    }
                ]],
                toolbar:
                [
                    {
                        iconCls: 'icon-add',
                        text: '增加',
                        handler: function () {
                            $("#form3").form("clear");
                            $("#form3").form("load", { iSerial: '0', iWidth: "900", iHeight: "600", iPageSize: "20", sFields: "*", sSearchFields: "*", iEdit: "on" });
                            $("#selectLookUp").combobox("select", "lookUp");

                            $("#tabLookMatchFields").html("");
                            var tr = ("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                            $("#tabLookMatchFields").append(tr);

                            $("#divLookUp").dialog({
                                title: 'lookUp增加',
                                toolbar: [{
                                    text: '保存',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addLookUp(0);
                                    }
                                },
                                {
                                    text: '保存并继续',
                                    iconCls: 'icon-add',
                                    handler: function () {
                                        addLookUp(1);
                                    }
                                },
                                {
                                    text: '关闭',
                                    iconCls: "icon-no",
                                    handler: function () {
                                        $("#divLookUp").dialog("close");
                                    }
                                }
                                ]
                            });

                            document.getElementById("ifrLookUp").src = "columns.htm?show=main&iformid=" + getQueryString("iformid") + "&height=595&random=" + Math.random();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-edit',
                        text: '编辑',
                        handler: function () {
                            lastType = 0;
                            editLookUp(0);
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: '删除',
                        handler: function () {
                            var selectedRow = $("#tableLookUp").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除'" + selectedRow.sFieldName + "'吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form3").form("submit", {
                                            url: "/Base/Handler/mainTableConfigHandler.ashx",
                                            onSubmit: function (param) {
                                                param.from = "tableLookUp";
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
                                                    $("#divLookUp").dialog("close");
                                                    var index = $("#tableLookUp").datagrid("getRowIndex", selectedRow);
                                                    refreshTableLookUp();
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
                    '-',
                    {
                        iconCls: 'icon-copy',
                        text: '复制',
                        handler: function () {
                            lastType = 1;
                            editLookUp(1);
                        }
                    }
                ],
                onDblClickRow: function (index, row) {
                    lastType = 0;
                    editLookUp(0);
                },
                idField: "iRecNo",
                singleSelect: true
            });
            $("#selectLookUp").combobox({
                panelHeight: 50,
                editable: false,
                onSelect: function (record) {
                    $("#divForm").dialog("close");
                    $("#divLookUpDetail").dialog("close");
                    if (record.text == "dataForm") {
                        $("#spanId").html("FormID");
                        $("#lookUpOnly").hide();
                        $("#dataFormOnly").show();
                        bindFormCombox("Text29", 50, 832, 250, 600);
                        //$("#Text35").textbox("setValue", "1024");
                        //$("#Text36").textbox("setValue", "768");
                    }
                    else if (record.text == "lookUp") {
                        $("#spanId").html("lookUp标识符");
                        $("#lookUpOnly").show();
                        $("#dataFormOnly").hide();
                        /*$("#Text29").combogrid({
                        idField: 'sOrgionName',
                        textField: 'sOrgionName',
                        filter: function (q, row) {
                        if (row.sOrgionName.indexOf(q) == 0) {
                        return true;
                        }
                        if (row.sControlName.indexOf(q) == 0) {
                        return true;
                        }
                        }
                        });*/
                        bindLookCombox("Text29", 50, 832, 250, 600);
                        //$("#Text35").textbox("setValue", "600");
                        //$("#Text36").textbox("setValue", "400");
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
                    { field: "iDisabled", title: "停用", width: 50, formatter: function (value, row, index) {
                        if (value == "1") {
                            return "是";
                        } else {
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
                            $("#form4").form("clear");
                            $("#textareaExp").validatebox({ required: true });
                            $("#form4").form("load", {
                                iSerial: "0"
                            });
                            /*$("#tableMainFieldExp").datagrid({
                            data: mainFields
                            });*/
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
                            document.getElementById("ifrExp").src = "columns.htm?show=main&iformid=" + getQueryString("iformid") + "&height=345&random=" + Math.random();
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
                            var columnSelectedRow = $("#tableExp").datagrid("getSelected");
                            if (columnSelectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form4").form("submit", {
                                            url: "/Base/Handler/mainTableConfigHandler.ashx",
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
                                                    refreshTableExp();
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
                    editExp();
                }
            });

            refreshTableDefault();
            setTimeout("refreshTableRequired()", 500);
            setTimeout("refreshTableLookUp()", 500);
            setTimeout("refreshTableExp()", 1000);
            setTimeout("refreshTableEvent()", 1000);
            //setTimeout("bindLookCombox('Text17',50,902)", 1000);
            setTimeout("bindLookCombox('Text29',50,832,250,600)", 1000);

            $(document).click(function (event) {
                if (event.target.className && event.target.className.indexOf("fieldPanel") > -1) {
                    focusText = event.target;
                }
                else {
                    focusText = undefined;
                }
            });
        })
        function refreshTableDefault() {
            var sqlObj = {
                TableName: "bscMainTableDefault",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableDefault").datagrid({
                data: data
            });
        }
        function addDefault(type) {
            var r = $("#form1").form("validate");
            if (r) {
                $("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                $("#form1").form("submit", {
                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableDefault";
                        param.otype = "add";
                        param.iformid = getQueryString("iformid");

                        //param.iRecNo = selectedRow.iRecNo;
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
                                $("#divDefault").dialog("close");
                            }
                            else {
                                $("#form1").form("reset");
                                $("#form1").form("load", { iSerial: "0" });
                            }
                            refreshTableDefault();
                        }
                    }
                });
            }
        }
        function editDefault() {
            var selectedRow = $("#tableDefault").datagrid("getSelected");
            if (selectedRow) {

                $("#Text1").textbox("enable");
                var sqlObj = {
                    TableName: "bscMainTableDefault",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }]
                };
                var data = SqlGetData(sqlObj)[0];
                $("#form1").form("clear");
                data.iDisabled = data.iDisabled == "1" ? "on" : "";
                $("#form1").form("load", data);
                $("#divDefault").dialog({
                    title: '修改默认值',
                    toolbar: [
                    {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            var r = $("#form1").form("validate");
                            if (r) {
                                $("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                                $("#form1").form("submit", {
                                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                                    onSubmit: function (param) {
                                        param.iformid = getQueryString("iformid");
                                        param.from = "tableDefault";
                                        param.otype = "edit";
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
                                            needRefresh = true;
                                        }
                                    }
                                });
                            }
                        }
                    },
                    '-',
                    {
                        text: '上一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            previewRow("tableDefault", selectedRow.iRecNo, editDefault);
                        }
                    },
                    '-',
                    {
                        text: '下一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            nextRow("tableDefault", selectedRow.iRecNo, editDefault);
                        }
                    },
                    '-',
                    {
                        text: '关闭',
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divDefault").dialog("close");
                            if (needRefresh) {
                                refreshTableDefault();
                                needRefresh = false;
                            }
                        }
                    }
                ]
                });
            }
        }

        function refreshTableRequired() {
            var sqlObj = {
                TableName: "bscMainTableRequired",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "asc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableRequired").datagrid({
                data: data
            });
        }
        function addRequired(type) {
            var r = $("#form2").form("validate");
            if (r) {
                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                $("#form2").form("submit", {
                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableRequired";
                        param.otype = "add";
                        param.iformid = getQueryString("iformid");

                        //param.iRecNo = selectedRow.iRecNo;
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
                                $("#divRequired").dialog("close");
                            }
                            else {
                                $("#form2").form("reset");
                                $("#form2").form("load", { iSerial: "0" });
                            }
                            refreshTableRequired();
                        }
                    }
                });
            }
        }
        function editRequired() {
            var selectedRow = $("#tableRequired").datagrid("getSelected");
            if (selectedRow) {
                $("#Text4").textbox("enable");
                var sqlObj = {
                    TableName: "bscMainTableRequired",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }]
                };
                var data = SqlGetData(sqlObj)[0];
                $("#form2").form("clear");
                data.iDisabled = data.iDisabled == "1" ? "on" : "";
                $("#form2").form("load", data);
                $("#divRequired").dialog({
                    title: '修改必填项',
                    toolbar: [
                    {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            var r = $("#form2").form("validate");
                            if (r) {
                                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                                $("#form2").form("submit", {
                                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                                    onSubmit: function (param) {
                                        param.iformid = getQueryString("iformid");
                                        param.from = "tableRequired";
                                        param.otype = "edit";
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
                                            needRefresh = true;
                                        }
                                    }
                                });
                            }
                        }
                    },
                    '-',
                    {
                        text: '上一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            previewRow("tableRequired", selectedRow.iRecNo, editRequired);
                        }
                    },
                    '-',
                    {
                        text: '下一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            nextRow("tableRequired", selectedRow.iRecNo, editRequired);
                        }
                    },
                    '-',
                    {
                        text: '关闭',
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divRequired").dialog("close");
                            if (needRefresh) {
                                refreshTableRequired();
                                needRefresh = false;
                            }
                        }
                    }
                ]
                });
            }
        }

        function refreshTableLookUp() {
            var sqlObj = {
                TableName: "bscMainTableLookUp",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
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
        function addLookUp(type) {
            var r = $("#form3").form("validate");
            if (r) {
                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                var sType = $("#selectLookUp").combobox("getText");
                if (sType == "dataForm") {
                    var textID = $("#Text9").val();
                    if (textID == "") {
                        $.messager.alert("错误", "dataForm显示字段不能为空！");
                        return false;
                    }
                    var valueID = $("#Text10").val();
                    if (valueID == "") {
                        $.messager.alert("错误", "dataForm值字段不能为空！");
                        return false;
                    }
                }

                $("#form3").form("submit", {
                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableLookUp";
                        param.otype = "add";
                        param.iformid = getQueryString("iformid");
                        param.sMatchFields = getMatchFieldsStr("tabLookMatchFields");
                        if (param.sMatchFields == false) {
                            return false;
                        }
                        param.sMatchFields = param.sMatchFields == "null" ? "" : param.sMatchFields;
                        //param.iRecNo = selectedRow.iRecNo;
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
                                $("#form3").form("load", { iSerial: '0', iWidth: "600", iHeight: "400", iPageSize: "20", sFields: "*", sSearchFields: "*", iEdit: "on" });
                                //$("#form3").form("load", { iSerial: "0" });
                            }
                            refreshTableLookUp();
                        }
                    }
                });
            }
        }
        
        function editLookUp(type) {//type=0修改，1复制
            var selectedRow = $("#tableLookUp").datagrid("getSelected");
            if (selectedRow) {
                /*$('#tableMainField').datagrid({
                data: mainFields
                });*/

                $("#Text7").textbox("enable");
                var sqlObj = {
                    TableName: "bscMainTableLookUp",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }]
                };

                var data = SqlGetData(sqlObj)[0];

                if (data.sType == "lookUp") {
                    $("#spanId").html("lookUp标识符");
                    $("#lookUpOnly").show();
                    $("#dataFormOnly").hide();
                    bindLookCombox("Text29", 50, 832, 250, 600);
                }
                else {
                    $("#spanId").html("FormID");
                    $("#lookUpOnly").hide();
                    $("#dataFormOnly").show();
                    bindFormCombox("Text29", 50, 832, 250, 600);
                }
                data.iTree = data.iTree == "1" ? "on" : "";
                data.iCover = data.iCover == "1" ? "on" : "";
                data.iEdit = data.iEdit == "1" ? "on" : "";
                data.iMulti = data.iMulti == "1" ? "on" : "";
                $("#form3").form("clear");
                data.iDisabled = data.iDisabled == "1" ? "on" : "";
                $("#form3").form("load", data);
                //$("#Text29").combogrid("setValue", data.sIden);
                var matchFields = data.sMatchFields;
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
                    $($("#tabLookMatchFields").children(":last-child")).remove();
                    var trnew = $("<tr><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td><td>=</td><td><input type='text' class='txb fieldPanel' onkeydown=turnToTd(event) /></td></tr>");
                    $("#tabLookMatchFields").append(trnew);
                }

                var datagridToolbar = [];
                datagridToolbar.push(
                    {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            var r = $("#form3").form("validate");
                            if (r) {
                                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                                var sType = $("#selectLookUp").combobox("getText");
                                if (sType == "dataForm") {
                                    var textID = $("#Text9").val();
                                    if (textID == "") {
                                        $.messager.alert("错误", "dataForm显示字段不能为空！");
                                        return false;
                                    }
                                    var valueID = $("#Text10").val();
                                    if (valueID == "") {
                                        $.messager.alert("错误", "dataForm值字段不能为空！");
                                        return false;
                                    }
                                }
                                $("#form3").form("submit", {
                                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                                    onSubmit: function (param) {
                                        param.iformid = getQueryString("iformid");
                                        param.from = "tableLookUp";
                                        param.otype = type == "0" ? "edit" : "add";
                                        param.iRecNo = selectedRow.iRecNo;
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
                                            needRefresh = true;
                                        }
                                    }
                                });
                            }
                        }
                    }
                )

                if (type == 0) {
                    datagridToolbar.push("-");
                    datagridToolbar.push(
                            {
                                text: '上一行',
                                iconCls: 'icon-add',
                                handler: function () {                                    
                                    previewRow("tableLookUp", selectedRow.iRecNo, editLookUp);
                                }
                            }
                        );
                    datagridToolbar.push("-");
                    datagridToolbar.push({
                        text: '下一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            nextRow("tableLookUp", selectedRow.iRecNo, editLookUp);
                        }
                    });
                }
                datagridToolbar.push("-");
                datagridToolbar.push({
                    text: '关闭',
                    iconCls: "icon-no",
                    handler: function () {
                        $("#divLookUp").dialog("close");
                        if (needRefresh) {
                            refreshTableLookUp();
                            needRefresh = false;
                        }
                    }
                });

                $("#divLookUp").dialog({
                    title: '修改lookUp',
                    toolbar: datagridToolbar /*[
                    {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            var r = $("#form3").form("validate");
                            if (r) {
                                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                                var sType = $("#selectLookUp").combobox("getText");
                                if (sType == "dataForm") {
                                    var textID = $("#Text9").val();
                                    if (textID == "") {
                                        $.messager.alert("错误", "dataForm显示字段不能为空！");
                                        return false;
                                    }
                                    var valueID = $("#Text10").val();
                                    if (valueID == "") {
                                        $.messager.alert("错误", "dataForm值字段不能为空！");
                                        return false;
                                    }
                                }
                                $("#form3").form("submit", {
                                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                                    onSubmit: function (param) {
                                        param.iformid = getQueryString("iformid");
                                        param.from = "tableLookUp";
                                        param.otype = type == "0" ? "edit" : "add";
                                        param.iRecNo = selectedRow.iRecNo;
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
                                            needRefresh = true;
                                        }
                                    }
                                });
                            }
                        }
                    },
                    '-',
                    {
                        text: '上一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            previewRow("tableLookUp", selectedRow.iRecNo, editLookUp);
                        }
                    },
                    '-',
                    {
                        text: '下一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            nextRow("tableLookUp", selectedRow.iRecNo, editLookUp);
                        }
                    },
                    '-',
                    {
                        text: '关闭',
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divLookUp").dialog("close");
                            if (needRefresh) {
                                refreshTableLookUp();
                                needRefresh = false;
                            }
                        }
                    }
                ]*/
                });
                document.getElementById("ifrLookUp").src = "columns.htm?show=main&iformid=" + getQueryString("iformid") + "&height=595&random=" + Math.random();
            }
        }
        function refreshTableExp() {
            var sqlObj = {
                TableName: "bscMainTableExpression",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
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
        function addExp(type) {
            var r = $("#form4").form("validate");
            if (r) {
                //$("#Text3").combobox("setValue", $("#Text3").combobox("getText"));
                $("#form4").form("submit", {
                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                    onSubmit: function (param) {
                        param.from = "tableExp";
                        param.otype = "add";
                        param.iformid = getQueryString("iformid");

                        //param.iRecNo = selectedRow.iRecNo;
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
                                $("#form4").form("reset");
                                $("#form4").form("load", { iSerial: "0" });
                            }
                            refreshTableExp();
                        }
                    }
                });
            }
        }
        function editExp() {
            var selectedRow = $("#tableExp").datagrid("getSelected");
            if (selectedRow) {
                /*$('#tableMainFieldExp').datagrid({
                data: mainFields
                });*/
                $("#Text38").textbox("enable");
                var sqlObj = {
                    TableName: "bscMainTableExpression",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: selectedRow.iRecNo
                    }]
                };

                var data = SqlGetData(sqlObj)[0];
                $("#form4").form("clear");
                data.iDisabled = data.iDisabled == "1" ? "on" : "";
                $("#form4").form("load", data);
                $("#divExp").dialog({
                    title: '修改公式',
                    toolbar: [
                    {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            var r = $("#form4").form("validate");
                            if (r) {
                                $("#form4").form("submit", {
                                    url: "/Base/Handler/mainTableConfigHandler.ashx",
                                    onSubmit: function (param) {
                                        param.iformid = getQueryString("iformid");
                                        param.from = "tableExp";
                                        param.otype = "edit";
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
                                            needRefresh = true;
                                        }
                                    }
                                });
                            }
                        }
                    },
                    '-',
                    {
                        text: '上一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            previewRow("tableExp", selectedRow.iRecNo, editExp);
                        }
                    },
                    '-',
                    {
                        text: '下一行',
                        iconCls: 'icon-add',
                        handler: function () {
                            nextRow("tableExp", selectedRow.iRecNo, editExp);
                        }
                    },
                    '-',
                    {
                        text: '关闭',
                        iconCls: "icon-no",
                        handler: function () {
                            $("#divExp").dialog("close");
                            if (needRefresh) {
                                refreshTableExp();
                                needRefresh = false;
                            }
                        }
                    }
                ]
                });
                document.getElementById("ifrExp").src = "columns.htm?show=main&iformid=" + getQueryString("iformid") + "&height=345&random=" + Math.random();
            }
        }

        function refreshTableEvent() {
            $("#form5").form("clear");
            var sqlObj = {
                TableName: "bscMaintableEvent",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormid",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#form5").form("load", data[0]);
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
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
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

        //绑定lookup选择
        function bindLookCombox(id, top, left, width, height) {
            $("#" + id).combogrid({
                idField: 'sOrgionName',
                textField: 'sOrgionName',
                columns: [[
                    { field: 'sOrgionName', title: 'lookUp标识', width: 100 },
                    { field: 'sControlName', title: '控件名称', width: 200 },
                    { field: 'iWindow', title: '下拉', hidden:true }
                ]],
                data: getLookUpName(),
                onChange: function (newValue, oldValue) {
                    var options = $(this).combogrid("options");
                    var data = options.data;
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].sOrgionName == newValue) {
                            $("#Text41").val(data[i].sReturnField);
                            $("#Text42").val(data[i].sDisplayField);
                            $("#Text15").val(data[i].sControlName);
                            if (data[i].iWindow == 1) {
                                $("#Text35").numberbox("setValue", 150);
                                $("#Text36").numberbox("setValue", 200);
                            } else {
                                $("#Text35").numberbox("setValue", 900);
                                $("#Text36").numberbox("setValue", 400);
                            }
                            //var data = getLookUpField(row.sOrgionName);
                            $("#divLookUpDetail").dialog({
                                title: "lookUpName详情:" + data[i].sOrgionName,
                                top: top,
                                left: left,
                                width: width,
                                height: height
                            });
                            $("#divLookUpDetail").dialog("open");
                            /*$("#lookUpField").datagrid({
                            data: data
                            });*/
                            var a = $("#ifrLookUpDetail")[0];
                            $("#ifrLookUpDetail")[0].width = (parseInt(width) - 50).toString();
                            $("#ifrLookUpDetail")[0].height = (parseInt(height) - 100).toString();
                            //var aa = $("#ifrLookUpDetail")[0];
                            document.getElementById("ifrLookUpDetail").src = "columns.htm?show=lookUp&lookUpName=" + data[i].sOrgionName + "&height=" + width + "&random=" + Math.random();
                            break;
                        }
                    }
                },
                //                onSelect: function (index, row) {
                //                    $("#Text41").val(row.sReturnField);
                //                    $("#Text42").val(row.sDisplayField);
                //                    $("#Text15").val(row.sControlName);
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
                    { field: 'iFormID', title: 'iFormID', width: 100 },
                    { field: 'iMenuID', title: 'iMenuID', width: 60 },
                    { field: 'sBillType', title: '表单名称', width: 100 }
                ]],
                data: getFormID(),
                onChange: function (newValue, oldValue) {
                    var options = $(this).combogrid("options");
                    var data = options.data;
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].iFormID == newValue) {
                            $("#divForm").dialog({
                                title: "表单:" + data[i].iFormID,
                                top: top,
                                left: left,
                                width: width,
                                height: height
                            });
                            $("#hidMenuID").val(data[i].iMenuID);
                            $("#divForm").dialog("open");
                            $("#ifrForm")[0].width = width;
                            $("#ifrForm")[0].height = height;
                            document.getElementById("ifrForm").src = "columns.htm?show=Form&iformid=" + data[i].iFormID + "&height=" + width + "&random=" + Math.random();
                            break;
                        }
                    }
                },
                //                onSelect: function (index, row) {
                //                    $("#divForm").dialog({
                //                        title: "表单:" + row.iFormID,
                //                        top: top,
                //                        left: left,
                //                        width: width,
                //                        height: height
                //                    });
                //                    $("#hidMenuID").val(row.iMenuID);
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
                }
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

        //事件保存
        function eventSave() {
            $("#form5").form("submit", {
                url: "/Base/Handler/mainTableConfigHandler.ashx",
                onSubmit: function (param) {
                    param.from = "tableEvent";
                    //param.iMainRecNo = selectedRow.iRecNo;
                    param.iFormID = getQueryString("iformid");
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
                        //refreshTableEvent();
                        $.messager.alert("成功", "保存成功！");
                    }
                }
            });
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

        document.onkeydown = function () {
            var obj = event.srcElement ? event.srcElement : event.target;
            if (event.keyCode == 9 && $(obj).hasClass("fieldPanel")) {  //如果是其它键，换上相应在ascii 码即可。
                return false; //非常重要
            }
        }
    </script>
</head>
<body class="easyui-layout" data-options="border:false">
    <div data-options="region:'center',border:false">
        <div id="tt" class="easyui-tabs" data-options="fit:true">
            <div title="默认值定义">
                <table id="tableDefault">
                </table>
            </div>
            <div title="必填字段定义(在可编辑列表中生效)">
                <table id="tableRequired">
                </table>
            </div>
            <div title="lookUp及dataform定义(lookup在可编辑列表中生效)">
                <table id="tableLookUp">
                </table>
            </div>
            <div title="公式定义">
                <table id="tableExp">
                </table>
            </div>
            <div title="事件定义">
                <div id="divtool" style="width: 100%; height: 35px; line-height: 35px; padding-left: 5px;
                    vertical-align: middle; background-color: #f4f4f4; top: 0; overflow: hidden;"
                    class="easyui-panel">
                    <a id="btnEventSave" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                        onclick="eventSave()">保存</a>
                </div>
                <form id="form5" method="post">
                <table style="width: 800px;">
                    <tr>
                        <td style="width: 100px;">
                            加载数据前
                        </td>
                        <td>
                            <textarea id="TextArea4" style="width: 100%; height: 150px;" name="sBeforeLoad"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;">
                            加载数据后
                        </td>
                        <td>
                            <textarea id="TextArea5" style="width: 100%; height: 150px;" name="sAfterLoad"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;">
                            保存前
                        </td>
                        <td>
                            <textarea id="TextArea2" style="width: 100%; height: 150px;" name="sBeforeSave"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;">
                            保存后
                        </td>
                        <td>
                            <textarea id="TextArea3" style="width: 100%; height: 150px;" name="sAfterSave"></textarea>
                        </td>
                    </tr>
                </table>
                </form>
            </div>
        </div>
        <div id="divDefault">
            <form id="form1" method="post">
            <table style="margin: auto;">
                <tr>
                    <td>
                        序号
                    </td>
                    <td>
                        <input id="Text1" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                            type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        字段值
                    </td>
                    <td>
                        <input id="Text2" name="sFieldName" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        默认值
                    </td>
                    <td>
                        <input id="Text3" type="text" name="sDefaultValue" />
                    </td>
                </tr>
                <tr>
                    <td>
                        停用
                    </td>
                    <td>
                        <input id="Text11" type="checkbox" name="iDisabled" />
                    </td>
                </tr>
            </table>
            </form>
        </div>
        <div id="divRequired">
            <form id="form2" method="post">
            <table style="margin: auto;">
                <tr>
                    <td>
                        序号
                    </td>
                    <td>
                        <input id="Text4" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                            type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        字段值
                    </td>
                    <td>
                        <input id="Text5" name="sFieldName" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        为空时提示
                    </td>
                    <td>
                        <input id="Text6" type="text" class="easyui-textbox" data-options="width:200" name="sRequiredTip" />
                    </td>
                </tr>
                <tr>
                    <td>
                        停用
                    </td>
                    <td>
                        <input id="Text12" name="iDisabled" type="checkbox" />
                    </td>
                </tr>
            </table>
            </form>
        </div>
        <div id="divLookUp">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" style="width: 500px; height: 600px;">
                    <form id="form3" method="post">
                    <table style="margin: auto;">
                        <tr>
                            <td>
                                序号
                            </td>
                            <td>
                                <input id="Text7" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                                    type="text" />
                                停用
                                <input id="Checkbox2" type="checkbox" name="iDisabled" />
                                <input id="hidMenuID" type="hidden" name="iMenuID" />
                            </td>
                            <td>
                                类型
                            </td>
                            <td>
                                <select id="selectLookUp" class="easyui-combobox" data-options="panelHeight:50" name="sType">
                                    <option value="lookUp">lookUp</option>
                                    <option value="dataForm">dataForm</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                字段
                            </td>
                            <td>
                                <input id="Text8" type="text" name="sFieldName" />
                            </td>
                            <td>
                                执行条件(js)
                            </td>
                            <td rowspan="2">
                                <textarea name="sCondition" class="fieldPanel" title="分另对应lookUp和dataForm的IsConditionFit事件，可直接写在页面上便于调试。返回true才成立"
                                    style="height: 50px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span id="spanId">lookUp</span>
                            </td>
                            <td>
                                <input id="Text29" name="sIden" class="easyui-combogrid" data-options="required:true,missingMessage:'不能为空',invalidMessage:'不能为空',width:150"
                                    type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                其他匹配字段
                            </td>
                            <td colspan="3">
                                <%--<textarea name="sMatchFields" style="width: 380px; height: 120px;" class="fieldPanel"
                                    title="目标在前返回在后,以逗号隔开。如:sTCode=sSCode"></textarea>--%>
                                <div style="height: 122px; overflow-y: auto; border: 1px solid #a0a0a0;">
                                    <table id="tabLookMatchFields" class="tabMatch">
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                修改、浏览时匹配字段<br />
                                （仅在页面初始化时生效）
                            </td>
                            <td colspan="3">
                                <textarea name="sEditMatchFields" style="width: 380px; height: 80px;" class="fieldPanel"
                                    title="目标在前返回在后,以逗号隔开。如:sTCode=sSCode"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                宽度
                            </td>
                            <td colspan="2">
                                <input id="Text35" type="text" name="iWidth" class="easyui-numberbox" data-options="precision:0"
                                    style="width: 80px;" />
                                高度
                                <input id="Text36" type="text" name="iHeight" class="easyui-numberbox" data-options="precision:0"
                                    style="width: 80px;" />
                            </td>
                            <td>
                                多选
                                <input id="Checkbox3" name="iMulti" type="checkbox" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                固定查询条件(sql)
                            </td>
                            <td colspan="3">
                                <!--<input id="Text33" type="text" name="sFixFilters" class="easyui-tooltip fieldPanel"
                                            style="width: 380px;" title="取其他字段用{field}来表示，主表用{m.field}" data-options="prompt:'取其他字段用{field}来表示，主表用{m.field}',width:400" />-->
                                <textarea name="sFixFilters" class="easyui-tooltip fieldPanel" style="width: 380px;
                                    height: 50px" title="取其他字段用#field#来表示" data-options="prompt:'取其他字段用#field#来表示'"></textarea>
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
                                    height: 50px;" title="取其他字段用#field#来表示" data-options="prompt:'取其他字段用#field#来表示'"></textarea>
                            </td>
                        </tr>
                        <%--<tr>
                        <td>
                            打开前执行(js)
                        </td>
                        <td colspan="3">
                            <textarea id="TextArea15" class="easyui-textarea" name="sOnBeforeOpen" title="分别对应lookUp和dataForm的beforeOpen事件，可直接写在页面上便于调试。返回false阻止弹窗" style="width: 400px;
                                height: 80px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            选择后执行(js，参数data)
                        </td>
                        <td colspan="3">
                            <textarea id="TextArea16" class="easyui-textarea" name="sOnSelected" title="分别对应lookUp和dataForm的afterSelected事件，可直接写在页面上便于调试。" style="width: 400px;
                                height: 80px;"></textarea>
                        </td>
                    </tr>--%>
                        <tr>
                            <td colspan="4">
                                <table id="lookUpOnly" style="display: none;">
                                    <tr>
                                        <td>
                                            选择字段
                                        </td>
                                        <td>
                                            <input id="Text30" name="sFields" class="easyui-textbox" data-options="prompt:'默认为全部字段',width:150"
                                                type="text" />
                                        </td>
                                        <td>
                                            查询条件字段
                                        </td>
                                        <td>
                                            <input id="Text31" type="text" name="sSearchFields" class="easyui-textbox fieldPanel"
                                                data-options="prompt:'默认为全部字段',width:150" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            页大小
                                        </td>
                                        <td colspan="2">
                                            <input id="Text37" type="text" name="iPageSize" class="easyui-numberbox" data-options="precision:0,width:50" />
                                            下拉分组字段
                                            <input id="Text14" type="text" name="sGroupField" class="easyui-textbox" data-options="width:100" />
                                        </td>
                                        <td>
                                            可编辑
                                            <input id="Checkbox1" name="iEdit" type="checkbox" checked="checked" />
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
                                        <td>
                                            显示字段
                                        </td>
                                        <td>
                                            <input id="Text9" name="sTextID" class="fieldPanel" style="width: 120px;" type="text" />
                                        </td>
                                        <td>
                                            值字段
                                        </td>
                                        <td>
                                            <input id="Text10" name="sValueID" class="fieldPanel" style="width: 120px;" type="text" />
                                        </td>
                                    </tr>
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
                <div data-options="region:'east',split:true" style="width: 170px; height: 600px;">
                    <!--<table id="tableMainField" style="width: 160px; height: 490px" data-options="singleSelect:true,title:'主表字段'">
                    <thead>
                        <tr>
                            <th data-options="field:'field',width:140,sortable:true">
                                字段名
                            </th>
                        </tr>
                    </thead>
                </table>-->
                    <iframe frameborder="0" id="ifrLookUp" width="100%" height="99%"></iframe>
                </div>
            </div>
        </div>
        <div id="divExp">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" style="width: 450px; height: 350px;">
                    <form id="form4" method="post">
                    <table style="margin: auto;">
                        <tr>
                            <td>
                                序号
                            </td>
                            <td>
                                <input id="Text38" name="iSerial" class="easyui-textbox" data-options="disabled:true,width:50"
                                    type="text" />
                            </td>
                            <td>
                                停用
                            </td>
                            <td colspan="3">
                                <input id="Text13" name="iDisabled" type="checkbox" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                触发字段
                            </td>
                            <td>
                                <input id="Text39" name="sSourceField" type="text" />
                            </td>
                            <td>
                                目标字段
                            </td>
                            <td>
                                <input id="Text40" name="sTargetField" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                执行条件(js)
                            </td>
                            <td colspan="3">
                                <textarea id="TextArea1" name="sCondition" class="fieldPanel" style="width: 300px;
                                    height: 100px"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                公式(js)
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
                <div data-options="region:'east',split:true" style="width: 180px; height: 350px;">
                    <!--<table id="tableMainFieldExp" class="easyui-datagrid" data-options="title:'主表字段',singleSelect:true"
                    style="width: 150px;">
                    <thead>
                        <tr>
                            <th data-options="field:'field',width:140,sortable:true">
                                字段名
                            </th>
                        </tr>
                    </thead>
                </table>-->
                    <iframe frameborder="0" id="ifrExp" width="100%" height="99%" style="margin: 0px;
                        padding: 0px;"></iframe>
                </div>
            </div>
        </div>
        <div id="divLookUpDetail">
            <table>
                <tr>
                    <td>
                        控件说明
                    </td>
                    <td>
                        <input id="Text15" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        返回字段
                    </td>
                    <td>
                        <input id="Text41" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td>
                        显示字段
                    </td>
                    <td>
                        <input id="Text42" readonly="readonly" style="border: none;" type="text" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <iframe frameborder="0" id="ifrLookUpDetail" style="margin: 0px; padding: 0px;">
                        </iframe>
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
