<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>LookUp设置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../JS/json2.js" type="text/javascript"></script>
    <script src="../JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="../JS/SqlOp.js" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        .tabmain {
            margin: 0px;
        }

            .tabmain tr td {
                padding: 3px;
                height: 30px;
            }

        .style1 {
            color: #FF0000;
        }

        .txabottom {
        }
    </style>
    <script language="javascript" type="text/javascript">
        var _userid = "";
        $.ajax({
            url: "/ashx/LoginHandler.ashx",
            async: false,
            cache: false,
            data: { otype: "getcurtuserid" },
            success: function (data) {
                _userid = data;
            },
            error: {

            }
        });

        var selectedLookRows = undefined;
        $(function () {
            var jsonobj = {
                TableName: "bscInitLookup",
                Fields: "sOrgionName,sControlName,dCtDate,GUID",
                FieldKeys: "GUID"
            }
            $("#list").datagrid(
                {
                    columns: [[
                    { field: 'sOrgionName', title: '标识符', width: 150, sortable: true },
                    { field: 'sControlName', title: '控件名称', width: 150, sortable: true },
                    { field: 'dCtDate', title: '录入时间', width: 150, sortable: true }
                    ]],
                    toolbar: "#tb",
                    url: "/Base/Handler/getData.ashx",
                    queryParams: {
                        plugin: "datagrid",
                        sqlobj: encodeURIComponent(JSON.stringify(jsonobj)),
                        random: Math.random()
                    },
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 200],
                    singleSelect: true,
                    remoteSort: true,
                    sortName: "dCtDate",
                    sortOrder: "desc",
                    onClickRow: function (rowIndex, rowData) {
                        selectedLookRows = rowData;
                        var resultObj = SqlGetData({
                            TableName: "bscInitLookup",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "GUID",
                                ComOprt: "=",
                                Value: "'" + rowData.GUID + "'"
                            }]
                        });
                        if (resultObj.length > 0) {
                            resultObj[0].iWindow = resultObj[0].iWindow == "1" ? "on" : "";
                            resultObj[0].iTree = resultObj[0].iTree == "1" ? "on" : "";
                            $("#FieldKeyValue").val(resultObj[0].GUID);
                            $("#form1").form("load", resultObj[0]);
                        }

                        var resultDetialObj = SqlGetData({
                            TableName: "bscInitLookupD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "MainGUID",
                                ComOprt: "=",
                                Value: "'" + rowData.GUID + "'"
                            }
                            ],
                            Sorts: [
                                {
                                    SortName: "isnull(iHidden,0)",
                                    SortOrder: "asc"
                                },
                                {
                                    SortName: "iSerial",
                                    SortOrder: "asc"
                                }
                            ]
                        });
                        //if (resultDetialObj && resultDetialObj.length > 0) {
                        $("#table1").datagrid("loadData", resultDetialObj);
                        //}
                    }
                });
            $("#table1").datagrid({
                fit: true,
                columns: [[
                        { field: "__cb", checkbox: true, width: 30 },
                        { field: 'iSerial', title: '序号', width: 40, editor: { type: "numberbox" } },
                        { field: 'sFieldName', title: '字段', width: 100, editor: { type: "text" } },
                        { field: 'sDisplayName', title: '显示名称', width: 100, editor: { type: "text" } },
                        {
                            field: 'sFieldType', title: '类型', align: "center", width: 40, editor: { type: "combobox", options: { valueField: 'id', textField: 'text', data: [{ id: 'string', text: '字符' }, { id: 'date', text: '日期' }, { id: 'datetime', text: '时间' }, { id: 'number', text: '数据' }], panelHeight: 90 } },
                            formatter: function (value, row, index) {
                                var text = "";
                                switch (value) {
                                    case "string": text = "字符"; break;
                                    case "date": text = "日期"; break;
                                    case "datetime": text = "时间"; break;
                                    case "number": text = "数据"; break;
                                    default: text = "字符"; break;
                                }
                                return text;
                            }
                        },
                        {
                            field: 'iHidden', title: '隐藏', width: 30, align: "center", editor: { type: "checkbox", options: { on: '1', off: '0' } },
                            //editor: { type: "checkbox", options: { data: [{ id: "0", text: "否" }, { id: "1", text: "是"}], valueField: "id", textField: "text"} },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                else {
                                    return "×";
                                }
                            }
                        },
                        {
                            field: 'iEdit', title: '可否<br />编辑', align: "center", width: 30, editor: { type: "checkbox", options: { on: '1', off: '' } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                else {
                                    return "×";
                                }
                            }
                        },
                        { field: 'iWidth', title: '宽度', width: 40, editor: { type: "numberspinner" } },
                        {
                            field: 'iSearch', title: '是否查<br />询条件', width: 60, align: "center",
                            editor: { type: "checkbox", options: { on: '1', off: '0' } },
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                                else {
                                    return "×";
                                }
                            }
                        },
                        {
                            field: "sComOprt", title: "比较符", width: 40,
                            editor: { type: "combobox", options: { data: [{ text: "=" }, { text: "like" }, { text: ">=" }, { text: "<=" }, { text: "in" }], valueField: "text", textField: "text", panelHeight: 100 } }
                        },
                        { field: 'sLookUpName', title: '查询条件lookup', width: 100, editor: { type: "text" } },
                        { field: 'sLookUpFilters', title: 'lookup固定条件', width: 200, editor: { type: "textarea" } }
                ]],
                toolbar: [
                    {
                        iconCls: "icon-add",
                        text: "增加",
                        handler: function () {
                            if (selectedLookRows == undefined) {
                                $.messager.alert("错误", "请先选择一个LOOKUP");
                                return;
                            }
                            var newData = {};
                            var iRecNo = getNextRecNo("bscInitLookupD");
                            var rows = $("#table1").datagrid("getRows");
                            newData.iRecNo = iRecNo;
                            newData.iSerial = rows.length + 1;
                            newData.sComOprt = "like";
                            newData.__hxstate = "add";
                            $("#table1").datagrid("appendRow", newData);
                        }
                    },
                    {
                        iconCls: "icon-remove",
                        text: "删除",
                        handler: function () {
                            if (selectedLookRows == undefined) {
                                $.messager.alert("错误", "请先选择一个LOOKUP");
                                return;
                            }
                            var selectedRows = $("#table1").datagrid("getChecked");
                            if (selectedRows.length > 0) {
                                $.messager.confirm("确定删除吗？", "确定删除所选行吗？", function (r) {
                                    if (r) {
                                        for (var i = 0; i < selectedRows.length; i++) {
                                            var deleteKey = $("#table1").attr("deleteKey");
                                            if (deleteKey) {
                                                deleteKey += selectedRows[i].iRecNo + ",";
                                                $("#table1").attr("deleteKey", deleteKey);
                                            } else {
                                                $("#table1").attr("deleteKey", selectedRows[i].iRecNo + ",");
                                            }
                                            $("#table1").datagrid("deleteRow", $("#table1").datagrid("getRowIndex", selectedRows[i]));
                                        }
                                    }
                                });
                            }
                        }
                    }
                    ,
                    {
                        iconCls: "icon-import",
                        text: "生成列",
                        handler: function () {
                            //                        if (selectedLookRows == undefined) {
                            //                            $.messager.alert("错误", "请先选择一个LOOKUP");
                            //                            return;
                            //                        }
                            var sql = $("#ExtTextArea1").val();
                            if (sql.indexOf("{condition}") == -1) {
                                $.messager.alert("错误", "请在SQL语句中加入{condition}");
                                return;
                            }

                            var doBuilder = function (sql) {
                                var selectedRows = $("#table1").datagrid("getRows");
                                for (var i = 0; i < selectedRows.length; i++) {
                                    $("#table1").datagrid("deleteRow", $("#table1").datagrid("getRowIndex", selectedRows[i]));
                                }
                                $.ajax({
                                    url: "/Base/Handler/PublicHandler.ashx",
                                    type: "post",
                                    async: false,
                                    cache: false,
                                    data: { otype: "getColumnsBySql", sql: sql },
                                    success: function (data) {
                                        var resultObj = JSON2.parse(data);
                                        if (resultObj.success == true) {
                                            var columns = JSON2.parse(resultObj.message);
                                            for (var i = 0; i < columns.length; i++) {
                                                var newData = {};
                                                var iRecNo = getNextRecNo("bscInitLookupD");
                                                var rows = $("#table1").datagrid("getRows");
                                                newData.iRecNo = iRecNo;
                                                newData.iSerial = rows.length + 1;
                                                newData.sFieldName = columns[i];
                                                newData.sComOprt = "like";
                                                newData.__hxstate = "add";
                                                $("#table1").datagrid("appendRow", newData);
                                            }
                                        }
                                        else {
                                            $.messager.alert("错误", resultObj.message);
                                        }
                                    }
                                });
                                $.messager.progress("close");
                            }
                            $.messager.progress({ title: "正在生成，请稍等..." });
                            var allRows = $("#table1").datagrid("getRows");
                            if (allRows.length > 0) {
                                $.messager.confirm("确认生成吗？", "确认生成列吗，将删除现有列？", function (r) {
                                    if (r) {
                                        doBuilder(sql);
                                    }
                                    else {
                                        $.messager.progress("close");
                                    }
                                });
                            }
                            else {
                                doBuilder(sql);
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
                    }
                ],
                onClickCell: f_clickRowCell

            });
        })
        function f_add() {
            $("#form1").form("reset");
            var newguid = NewGuid();
            $("#FieldKeyValue").val(newguid);
            setFieldValue("sCtUid", _userid);
            setFieldValue("dCtDate", getNowDate() + " " + getNowTime());

            var allrows = $("#table1").datagrid("getRows");
            while (allrows.length > 0) {
                $("#table1").datagrid("deleteRow", $("#table1").datagrid("getRowIndex", allrows[0]));
            }
        }
        function f_delete() {
            var selectedRow = $("#list").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("确认", "确认删除吗？", function (r) {
                    if (r) {
                        var result = SqlCommExec({
                            Comm: "delete from bscInitLookup where GUID=@p1",
                            Parms: [
                        {
                            ParmName: "@p1",
                            Value: selectedRow.GUID
                        }
                            ]
                        });
                        if (result != "1") {
                            $.messager.alert("错误", result);
                        }
                        else {
                            //$.messager.alert("成功", "删除成功");
                            //$("#list").datagrid("reload");
                            var index = $("#list").datagrid("getRowIndex", selectedLookRows);
                            $("#list").datagrid("deleteRow", index);
                            $("#form1").form("reset");

                        }
                    }
                });
            }
            else {
                $.messager.alert("错误", "请先选择一行！");
            }
        }
        function f_save() {
            $("#ExtTextBox3").val(trim($("#ExtTextBox3").val()));
            $("#ExtTextBox4").val(trim($("#ExtTextBox4").val()));
            $("#ExtTextBox5").val(trim($("#ExtTextBox5").val()));
            $("#ExtTextBox6").val(trim($("#ExtTextBox6").val()));
            $("#ExtTextBox7").val(trim($("#ExtTextBox7").val()));
            $("#ExtTextBox8").val(trim($("#ExtTextBox8").val()));
            var sql = $("#ExtTextArea1").val();
            if (sql.indexOf("{condition}") == -1) {
                $.messager.alert("错误", "请在SQL语句中加入{condition}");
                return;
            }
            var result = $("#form1").form("validate");
            if (result != true) {
                return;
            }
            else {
                if ($("#FieldKeyValue").val() == "") {
                    var newguid = NewGuid();
                    //            setFieldValue("GUID", newguid);
                    $("#FieldKeyValue").val(newguid);
                }
                var sqlobj = {
                    TableName: "bscInitLookup",
                    Fields: "c=count(*)",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "GUID",
                            ComOprt: "=",
                            Value: "'" + $("#FieldKeyValue").val() + "'"
                        }
                    ]
                };
                var objData = SqlGetData(sqlobj);
                if (parseInt(objData[0].c) > 0) {
                    var result = Form.__update($("#FieldKeyValue").val(), "/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (result.indexOf("error:") == -1) {
                        $.messager.alert("成功", "修改成功！");
                        var index = $("#list").datagrid("getRowIndex", selectedLookRows);
                        var pageData = formData("form1");
                        $("#list").datagrid("updateRow", { index: index, row: pageData });

                        /*$("#table1").removeAttr("deleteKey");
                        var data1 = $("#table1").datagrid("getRows");
                        for (var i = 0; i < data1.length; i++) {
                            delete data1[i].__hxstate;
                        }*/
                    }
                    else {
                        $.messager.alert("错误", result);
                    }
                }
                else {
                    var result = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (result.indexOf("error:") == -1) {
                        $.messager.alert("成功", "新增成功！");
                        //$("#list").datagrid("reload");
                        var pageData = formData("form1");
                        pageData.GUID = $("#FieldKeyValue").val();
                        $("#list").datagrid("insertRow", { index: 0, row: pageData });
                    }
                    else {
                        $.messager.alert("错误", result);
                    }
                }
            }
        }
        function f_cancel() {
            $("#form1").form("reset");
            $("#FieldKeyValue").val("");
        }
        function f_search() {
            var text = $("#Text1").val();
            var queryParms = $("#list").datagrid('options')["queryParams"];
            queryParms.filters = encodeURIComponent(JSON.stringify([
                {
                    Field: "sOrgionName",
                    ComOprt: "like",
                    Value: "'%" + text + "%'",
                    LinkOprt: "or"
                },
                 {
                     Field: "sControlName",
                     ComOprt: "like",
                     Value: "'%" + text + "%'"
                 }
            ]));
            $("#list").datagrid({ queryParams: queryParms });
        }
        function f_refresh() {
            var queryParms = $("#list").datagrid('options')["queryParams"];
            delete queryParms["filters"];
            $("#list").datagrid({ queryParams: queryParms });
        }
        var editIndex = undefined;

        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function NewGuid() {
            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        }

        function getFieldValue(field) {
            var c = $("[FieldID='" + field + "']")[0];
            //var c = $(":contains(\"FieldID='" + field + "'\")");
            var value = "";
            if (c) {
                var tagName = c.tagName;
                switch (tagName) {
                    case "TEXTAREA":
                        {
                            value = c.value;
                        } break;
                    case "INPUT":
                        {
                            if (c.type == "text" || c.type == "hidden" || c.type == "password") {
                                //var plugin = c.attributes["plugin"].nodeValue;
                                var plugin = $(c).attr("plugin");
                                if (plugin) {
                                    switch (plugin) {
                                        case "textbox":
                                            {
                                                try {
                                                    value = $("#" + c.id).textbox("getValue");
                                                }
                                                catch (e) {
                                                    value = $("#" + c.id).val();
                                                }

                                            } break;
                                        case "numberbox": value = $("#" + c.id).numberbox("getValue"); break;
                                        case "datebox": value = $("#" + c.id).datebox("getValue"); break;
                                        case "datetimebox": value = $("#" + c.id).datetimebox("getValue"); break;
                                        case "combobox":
                                            {
                                                var valueArr = $("#" + c.id).combobox("getValues");
                                                value = valueArr.join(",");
                                                return value;
                                            } break;
                                        case "combotree":
                                            {
                                                var valueArr = $("#" + c.id).combobox("getValues");
                                                value = valueArr.join(",");
                                                return value;
                                            } break;
                                    }
                                }
                                else {
                                    value = c.value;
                                }
                            }
                            else if (c.type == "checkbox") {
                                value = c.checked == true ? 1 : 0;
                            }
                        } break;
                    case "SELECT":
                        {
                            value = $("#" + c.id).combobox("getValue");
                        }
                }
            }
            return value;
        }
        //设置主表字段值
        function setFieldValue(field, value) {
            var c = $("[FieldID='" + field + "']");
            if (c && c.length > 0) {
                if (c[0].tagName.toLowerCase() == "textarea") {
                    c[0].value = value;
                }
                else if (c[0].tagName.toLowerCase() == "select") {
                    //c[0].value = value;
                    $(c[0]).combobox("setValue", value);
                }
                else if (c[0].tagName.toLowerCase() == "input") {
                    if (c[0].type == "checkbox") {
                        c[0].checked = value == "1" || value == true ? true : false;
                    }
                    else if (c[0].type == "text" || c[0].type == "hidden" || c[0].type == "password") {
                        var plugin = $(c[0]).attr("plugin");
                        switch (plugin) {
                            case "textbox":
                                {
                                    try {
                                        $(c[0]).textbox("setValue", value);
                                    }
                                    catch (e) {
                                        $(c[0]).val(value);
                                    }
                                } break;
                            case "numberbox": $(c[0]).numberbox("setValue", value); break;
                            case "datebox": $(c[0]).datebox("setValue", value); break;
                            case "datetimebox": $(c[0]).datetimebox("setValue", value); break;
                            case "combobox": $(c[0]).combobox("setValue", value); break;
                            case "combotree": $(c[0]).combotree("setValue", value); break;
                            case undefined: c[0].value = value; break;
                        }
                    }
                }
            }
        }

        //获取当前日期
        function getNowDate() {
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
        }
        //获取当前时间
        function getNowTime() {
            var nowdate = new Date();
            var hour = nowdate.getHours();      //获取当前小时数(0-23)
            var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
            var second = nowdate.getSeconds();
            return hour + ":" + minute + ":" + second;
        }

        function ltrim(s) {
            return s.replace(/(^s*)/g, "");
        }
        //去右空格;
        function rtrim(s) {
            return s.replace(/(s*$)/g, "");
        }
        //去左右空格;
        function trim(s) {
            s = s.replace(/\s+/g, "");
            return s;
        }

        function getNextRecNo(tablename) {
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

        function f_clickRowCell(rowIndex, field, value) {
            if (editIndex == undefined) {
                $("#table1").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#table1").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#table1").datagrid('endEdit', editIndex);
                $('#table1').datagrid('unselectRow', editIndex);
                $("#table1").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#table1").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    //var target = ed.target;
                    $(ed.target).focus();
                    $(ed.target).select();
                }
            }
            editIndex = rowIndex;
        }

        function formData(formid) {
            var serializeObj = {};
            var array = $("#" + formid).serializeArray();
            var str = $("#" + formid).serialize();
            $(array).each(function () {
                if (serializeObj[this.name]) {
                    if ($.isArray(serializeObj[this.name])) {
                        serializeObj[this.name].push(this.value);
                    } else {
                        serializeObj[this.name] = [serializeObj[this.name], this.value];
                    }
                } else {
                    serializeObj[this.name] = this.value;
                }
            });
            return serializeObj;
        }
        document.onkeyup = function () {
            var e = event.srcElement
            if (event.keyCode == 13) {
                if ($("#Text1").val().length > 0) {
                    document.getElementById("btnsearch").click();
                }
            }
        }


        //上移
        function MoveUp() {
            var rows = $("#table1").datagrid('getChecked');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#table1").datagrid('getRowIndex', rows[i]);
                $("#table1").datagrid("endEdit", index);
                mysort(index, 'up', 'table1');
            }
        }
        //下移
        function MoveDown() {
            var rows = $("#table1").datagrid('getChecked');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#table1").datagrid('getRowIndex', rows[i]);
                $("#table1").datagrid("endEdit", index);
                mysort(index, 'down', 'table1');
            }
        }
        function mysort(index, type, gridname) {
            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datagrid('getData').rows[index];
                    //toup.iSerial = parseInt(toup.iSerial) - 1;
                    var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
                    //todown.iSerial = parseInt(todown.iSerial) + 1;
                    var theSerial = toup.iSerial;
                    toup.iSerial = todown.iSerial;
                    todown.iSerial = theSerial;
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
                    //todown.iSerial = parseInt(todown.iSerial) + 1;
                    var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
                    //toup.iSerial = parseInt(toup.iSerial) - 1;
                    var theSerial = todown.iSerial;
                    todown.iSerial = toup.iSerial;
                    toup.iSerial = theSerial;
                    $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
                    $('#' + gridname).datagrid('getData').rows[index] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index + 1);
                    $('#' + gridname).datagrid('checkRow', index + 1);
                    $('#' + gridname).datagrid('uncheckRow', index);
                }
            }
        }
    </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
        <div data-options="region:'west',split:true,border:false" style="width: 400px;">
            <table id="list" data-options="fit:true">
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north',split:true" style="height: 415px;">
                    <div id="tb">
                        <div>
                            <input id="Text1" type="text" />
                            <a href="#" id="btnsearch" class="easyui-linkbutton" iconcls="icon-search" plain="true"
                                onclick="f_search()"></a><a href="#" class="easyui-linkbutton" iconcls="icon-reload"
                                    plain="true" onclick="f_refresh()"></a>
                        </div>
                    </div>
                    <div style="height: 30px; width: 100%; line-height: 30px; background-color: #efefef;">
                        <a href="#" class="easyui-linkbutton" iconcls="icon-add" plain="true" onclick="f_add()">新增</a> <a href="#" class="easyui-linkbutton" iconcls="icon-remove" plain="true" onclick="f_delete()">删除</a> <a href="#" class="easyui-linkbutton" iconcls="icon-save" plain="true" onclick="f_save()">保存</a> <a href="#" class="easyui-linkbutton" iconcls="icon-cancel" plain="true" onclick="f_cancel()">取消</a>
                        <input id="TableName" type="hidden" value="bscInitLookup" />
                        <input id="FieldKey" type="hidden" value="GUID" />
                        <input id="FieldKeyValue" type="hidden" />
                    </div>
                    <div id="divmain">
                        <table class="tabmain">
                            <tr>
                                <td>唯一标识符：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox1" runat="server" CssClass="txbbottom" Width="100px"
                                        Z_FieldID="sOrgionName" Z_Required="True" Z_RequiredTip="唯一标识符不能为空" />
                                    <span class="style1">*</span>
                                    <cc2:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="GUID" />
                                    <cc2:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="sCtUid" />
                                    <cc2:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="dCtDate" />
                                </td>
                                <td>控件说明
                                </td>
                                <td colspan="3">
                                    <cc2:ExtTextArea2 ID="ExtTextArea5" runat="server" Z_FieldID="sControlName" Width="251px" />
                                </td>
                            </tr>
                            <tr>
                                <td>SQL语句：
                                </td>
                                <td colspan="5">
                                    <cc2:ExtTextArea2 ID="ExtTextArea1" runat="server" Height="80px" Width="484px" CssClass="txabottom"
                                        Z_FieldID="sSQL" Z_Required="True" Z_RequiredTip="SQL语句不能为空" />
                                    <span class="style1">*</span>
                                </td>
                            </tr>
                            <tr>
                                <td>固定查询条件
                                </td>
                                <td colspan="5">
                                    <cc2:ExtTextArea2 ID="ExtTextArea2" runat="server" Height="50px" Width="484px" CssClass="txabottom"
                                        Z_FieldID="sFilters" />
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="2">排序语句
                                </td>
                                <td rowspan="2">
                                    <cc2:ExtTextArea2 ID="ExtTextArea3" runat="server" Height="80px" Width="124px" Z_FieldID="sOrder" />
                                </td>
                                <td>显示字符
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox3" runat="server" CssClass="txbbottom" Z_FieldID="sDisplayField"
                                        Z_Required="True" Z_RequiredTip="显示字符不能为空" Width="100px" />
                                    <span class="style1">*</span>
                                </td>
                                <td>返回字符
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox4" runat="server" CssClass="txbbottom" Z_FieldID="sReturnField"
                                        Z_Required="True" Z_RequiredTip="返回字符不能为空" Width="100px" />
                                    <span class="style1">*</span>
                                </td>
                            </tr>
                            <tr>
                                <td>窗口宽度
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox10" runat="server" CssClass="txbbottom" Z_FieldID="iWidth"
                                        Z_FieldType="数值" Width="50px" Z_Value="600" />
                                </td>
                                <td>窗口高度
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox9" runat="server" CssClass="txbbottom" Z_FieldID="iHeight"
                                        Z_FieldType="数值" Width="50px" Z_Value="400" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">是否下拉<cc2:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iWindow" />
                                    是否树<cc2:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iTree" />
                                    &nbsp;树展开级数(0不展开)<cc2:ExtTextBox2 ID="ExtTextBox11" runat="server" CssClass="txbbottom"
                                        Width="24px" Z_FieldID="iExtend" Z_FieldType="数值" />
                                    &nbsp;根值<cc2:ExtTextBox2 ID="ExtTextBox12" runat="server" CssClass="txbbottom" Width="50px"
                                        Z_FieldID="sRootValue" Z_FieldType="空" />
                                    &nbsp;只能选叶子<cc2:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iLeaf" />
                                </td>
                                <td>弹窗分页字段
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox5" runat="server" CssClass="txbbottom" Z_FieldID="sPageField"
                                        Width="100px" />
                                </td>
                            </tr>
                            <tr>
                                <td>树父节点字段
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox6" runat="server" CssClass="txbbottom" Z_FieldID="sParentField"
                                        Width="100px" />
                                </td>
                                <td>树子节点字段
                                
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox7" runat="server" CssClass="txbbottom" Z_FieldID="sChildField"
                                        Width="100px" />
                                </td>
                                <td>树显示字段
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox8" runat="server" CssClass="txbbottom" Z_FieldID="sTreeDisplayField"
                                        Width="100px" />
                                </td>
                                
                            </tr>
                            <tr>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'center',split:true,border:false">
                    <table id="table1" tablename="bscInitLookupD" isson="true" linkfield="GUID=MainGUID"
                        fieldkey="iRecNo">
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
