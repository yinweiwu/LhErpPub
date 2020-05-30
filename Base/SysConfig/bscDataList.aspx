<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
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
        .txbbottom {
            border: none;
            border-bottom: solid 1px #aaaaaa;
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
        $(function () {
            var jsonobj = {
                TableName: "BscDataListM",
                Fields: "*",
                FieldKeys: "sClassID"//,
            }
            $("#datalist").datagrid(
            {
                columns: [[
                    { field: 'sClassID', title: '分组编号', width: 150, sortable: true },
                    { field: 'sClasName', title: '分组名称', width: 150, sortable: true },
                    { field: 'dInputDate', title: '录入时间', width: 150, sortable: true }
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
                sortName: "dInputDate",
                sortOrder: "desc",
                onClickRow: function (rowIndex, rowData) {
                    //pageinit(rowData);
                    $("#form1").form("load", rowData);
                    $("#ExtTextBox1")[0].disabled = true;

                    var detailObj = {
                        TableName: "BscDataListD",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sClassID",
                                ComOprt: "=",
                                Value: "'" + rowData.sClassID + "'"
                            }
                        ],
                        Sorts: [
                        {
                            SortName: "iSerial",
                            SortOrder: "asc"
                        }
                        ]
                    };
                    $("#detail").datagrid(
                        {
                            queryParams: {
                                plugin: "datagrid",
                                sqlobj: encodeURIComponent(JSON.stringify(detailObj)),
                                random: Math.random()
                            },
                            url: "/Base/Handler/getData.ashx"

                        });


                }
            });
            $("#detail").datagrid({
                columns: [[
                    { field: 'cc', checkbox: true },
                    { field: 'iSerial', title: '序号', width: 30, editor: "numberbox" },
                    { field: 'sName', title: '参数中文名', width: 150, editor: "text" },
                    { field: 'sEngName', title: '参数英文名', width: 150, editor: "text" },
                    { field: 'sCode', title: '代码', width: 150, editor: "text" },
                    { field: 'sRemark', title: '备注', width: 250, editor: "text" }
                ]],
                onClickCell: f_clickRowCell,
                toolbar: [
            {
                text: "新增行",
                iconCls: 'icon-add',
                handler: function () {
                    var iRecNo = getChildID("BscDataListD");
                    $("#detail").datagrid("appendRow",
                    {
                        iRecNo: iRecNo,
                        iSerial: $("#detail").datagrid("getRows").length + 1,
                        sUserID: _userid,
                        dInputDate: getNowDate() + " " + getNowTime(),
                        __hxstate: "add"
                    }
                    )
                }
            },
            {
                text: "删除行",
                iconCls: 'icon-remove',
                handler: function () {
                    var checkedRows = $("#detail").datagrid('getChecked');
                    if (checkedRows.length > 0) {
                        $.messager.confirm('确认', '您确认要删除吗？', function (r) {
                            if (r) {
                                for (var i = 0; i < checkedRows.length; i++) {
                                    var rowIndex = $("#detail").datagrid("getRowIndex", checkedRows[i]);
                                    var deleteKey = $("#detail").attr("deleteKey");
                                    if (deleteKey) {
                                        deleteKey += checkedRows[i].iRecNo + ",";
                                        $("#detail").attr("deleteKey", deleteKey);
                                    } else {
                                        $("#detail").attr("deleteKey", checkedRows[i].iRecNo + ",");
                                    }
                                    $("#detail").datagrid("deleteRow", rowIndex);
                                }
                            }
                        });
                    }
                }
            }
                ]
            })

            $($("#ExtTextBox1").textbox("textbox")).bind("blur", function () {
                setClassID();
            })
        })
        function f_add() {
            //document.getElementById("ExtTextBox1").readOnly = false;
            //document.getElementById("ExtTextBox1").style.backgroundColor = "";
            $("#ExtTextBox1")[0].disabled = false;
            setFieldValue("sClassID", "");
            $("#FieldKeyValue").val("");
            setFieldValue("sClasName", "");
            setFieldValue("sFormular", "");
            setFieldValue("sReMark", "");
            setFieldValue("sUserID", _userid);
            setFieldValue("dInputDate", getNowDate() + " " + getNowTime());

            while ($("#detail").datagrid("getRows").length > 0) {
                $("#detail").datagrid("deleteRow", 0);
            }
        }
        function f_delete() {
            var selectedRow = $("#datalist").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("确认", "确认删除吗？", function (r) {
                    if (r) {
                        var result = SqlCommExec({
                            Comm: "delete from BscDataListM where sClassID=@p1",
                            Parms: [
                    {
                        ParmName: "@p1",
                        Value: selectedRow.sClassID
                    }
                            ]
                        });
                        if (result != "1") {
                            $.messager.alert("错误", result);
                        }
                        else {
                            $.messager.alert("成功", "删除成功");
                            $("#datalist").datagrid("reload");
                        }
                    }
                });
            }
            else {
                $.messager.alert("错误", "请先选择一行！");
            }
        }
        function f_save() {
            //var result = OpertatCheckvalue();
            var result = $("#form1").form("validate");
            if (result != true) {
                return;
            }
            else {
                var sqlobj = {
                    TableName: "BscDataListM",
                    Fields: "c=count(*)",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "sClassID",
                    ComOprt: "=",
                    Value: "'" + getFieldValue("sClassID") + "'"
                }
                    ]
                };
                var objData = SqlGetData(sqlobj);
                if (parseInt(objData[0].c) > 0) {
                    var result = Form.__update(getFieldValue("sClassID"), "/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (result.indexOf("error:") == -1) {
                        $.messager.alert("成功", "修改成功！");
                        /*$("#detail").removeAttr("deleteKey");
                        var data1 = $("#detail").datagrid("getRows");
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
                        $("#datalist").datagrid("reload");
                    }
                    else {
                        $.messager.alert("错误", result);
                    }
                }
            }
        }
        function f_cancel() {
            document.getElementById("ExtTextBox1").readOnly = false;
            document.getElementById("ExtTextBox1").style.backgroundColor = "";
            setFieldValue("sClassID", "");
            $("#FieldKeyValue").val("");
            setFieldValue("sClasName", "");
            setFieldValue("sFormular", "");
            setFieldValue("sReMark", "");
            setFieldValue("sUserID", _userid);
            setFieldValue("dInputDate", getNowDate() + " " + getNowTime());

            while ($("#detail").datagrid("getRows").length > 0) {
                $("#detail").datagrid("deleteRow", 0);
            }
        }

        function f_search() {
            var text = $("#Text1").val();
            //var pro = $("#datalist").datagrid.defaults;
            var queryParms = $("#datalist").datagrid('options')["queryParams"];
            queryParms.filters = encodeURIComponent(JSON.stringify([
        {
            Field: "sClassID",
            ComOprt: "like",
            Value: "'%" + text + "%'",
            LinkOprt: "or"
        },
         {
             Field: "sClasName",
             ComOprt: "like",
             Value: "'%" + text + "%'"
         }
            ]));
            $("#datalist").datagrid({ queryParams: queryParms });
            //$("#datalist").datagrid("reload");
        }
        function f_refresh() {
            var queryParms = $("#datalist").datagrid('options')["queryParams"];
            delete queryParms["filters"];
            $("#datalist").datagrid({ queryParams: queryParms });
        }
        var editIndex = undefined;
        function f_clickRowCell(rowIndex, field, value) {
            if (editIndex == undefined) {
                $("#detail").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#detail").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#detail").datagrid('endEdit', editIndex);
                $('#detail').datagrid('unselectRow', editIndex);
                $("#detail").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#detail").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).focus();
                    $(ed.target).select();
                }
            }
            editIndex = rowIndex;
        }

        function getChildID(tablename) {
            var jsonobj = {
                StoreProName: "SpGetIden",
                ParamsStr: "'" + tablename + "'"
            }
            var url = "/Base/Handler/StoreProHandler.ashx";
            var parms = "sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj));
            var async = false;
            var ispost = true;
            var result = callpostback(url, parms, async, ispost);
            if (result && result.length > 0 && result != "-1") {
                return result;
            }
            else {
                return "-1";
            }
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
                                        case "textbox": { try { value = $("#" + c.id).textbox("getValue"); } catch (e) { } value = $(c).val(); } break;
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
                            value = $("#" + c.id).datetimebox("getValue");
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
        function pageinit(jsonobj) {
            var input = document.getElementById("divmain").getElementsByTagName("INPUT");
            var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
            var select = document.getElementById("divmain").getElementsByTagName("SELECT");
            for (var i = 0; i < textarea.length; i++) {
                if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null) {
                    var field = textarea[i].attributes["FieldID"].nodeValue;
                    for (var key in jsonobj) {
                        if (key.toUpperCase() == field.toUpperCase()) {
                            textarea[i].value = jsonobj[key];
                            if (document.getElementById(textarea[i].id + "_val")) {
                                document.getElementById(textarea[i].id + "_val").value = jsonobj[key];
                            }
                            break;
                        }
                    }
                }
            }
            for (var i = 0; i < input.length; i++) {
                if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].id != "fieldkeys") {
                    var objtype = input[i].type;
                    var field = input[i].attributes["FieldID"].nodeValue;
                    var fieldtype = input[i].attributes["FieldType"] == null ? "" : input[i].attributes["FieldType"].nodeValue;
                    for (var key in jsonobj) {
                        if (key.toUpperCase() == field.toUpperCase()) {
                            if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                                if (fieldtype == "日期") {
                                    var indexblank = jsonobj[key].indexOf(" ");
                                    if (indexblank > -1) {
                                        input[i].value = jsonobj[key].substr(0, indexblank).replace(/\//g, '-');
                                        if (document.getElementById(input[i].id + "_val")) {
                                            document.getElementById(input[i].id + "_val").value = jsonobj[key].substr(0, indexblank).replace(/\//g, '-');;
                                        }
                                    }
                                    else {
                                        input[i].value = jsonobj[key].replace(/\//g, '-');;
                                        if (document.getElementById(input[i].id + "_val")) {
                                            document.getElementById(input[i].id + "_val").value = jsonobj[key].replace(/\//g, '-');;
                                        }
                                    }
                                }
                                else {
                                    input[i].value = jsonobj[key];
                                    if (document.getElementById(input[i].id + "_val")) {
                                        document.getElementById(input[i].id + "_val").value = jsonobj[key];
                                    }
                                }
                                break;
                            }
                            if (objtype == "checkbox") {
                                var value = jsonobj[key];
                                if (jsonobj[key] == "True" || jsonobj[key] == "1") {
                                    input[i].checked = true;
                                    if (document.getElementById(input[i].id + "_val")) {
                                        document.getElementById(input[i].id + "_val").checked = true;
                                    }
                                }
                                else {
                                    input[i].checked = false;
                                    if (document.getElementById(input[i].id + "_val")) {
                                        document.getElementById(input[i].id + "_val").checked = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for (var i = 0; i < select.length; i++) {
                if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null) {
                    var field = select[i].attributes["FieldID"].nodeValue;
                    for (var key in jsonobj) {
                        if (key.toUpperCase() == field.toUpperCase()) {
                            this.SelectItemByText(select[i], jsonobj[key]);
                            select[i].value = jsonobj[key];
                            //select[i].value = jsonobj[key];
                            if (document.getElementById(select[i].id + "_val")) {
                                this.SelectItemByText(document.getElementById(select[i].id + "_val"), jsonobj[key]);
                            }
                            break;
                        }
                    }
                }
            }
            //lookupinit();
        }
        //检查必填项
        function OpertatCheckvalue() {
            //var input = document.getElementById("divmain").getElementsByTagName("INPUT");
            var input = document.getElementsByTagName("INPUT");
            var textarea = document.getElementsByTagName("TEXTAREA");
            //var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
            //var select = document.getElementById("divmain").getElementsByTagName("SELECT");
            for (var i = 0; i < input.length; i++) {
                if (input[i].attributes["Required"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0) {
                    if (input[i].attributes["Required"].nodeValue.toLowerCase() == "true") {
                        if (input[i].value.length == 0 && (input[i].type == "text" || input[i].type == "password")) {
                            var bkcolor = input[i].style.backgroundColor;
                            input[i].style.backgroundColor = "#ff0000";
                            if (input[i].attributes["Requiredtip"] != undefined && input[i].attributes["Requiredtip"] != null) {
                                //alert(input[i].attributes["Requiredtip"].nodeValue);
                                input[i].style.backgroundColor = bkcolor;
                                return input[i].attributes["Requiredtip"].nodeValue;
                            }
                            else {
                                //alert(input[i].attributes["FieldID"].nodeValue + "不能为空");
                                input[i].style.backgroundColor = bkcolor;
                                return input[i].attributes["FieldID"].nodeValue + "不能为空"
                            }
                            //return false;
                        }
                    }
                }
            }
            for (var i = 0; i < textarea.length; i++) {
                if (textarea[i].attributes["Required"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0) {
                    if (textarea[i].attributes["Required"].nodeValue.toLowerCase() == "true") {
                        if (textarea[i].value.length == 0) {
                            var bkcolor = textarea[i].style.backgroundColor;
                            textarea[i].style.backgroundColor = "#ff0000";
                            if (textarea[i].attributes["Requiredtip"] != undefined && textarea[i].attributes["Requiredtip"] != null) {
                                //alert(textarea[i].attributes["Requiredtip"].nodeValue);
                                textarea[i].style.backgroundColor = bkcolor;
                                return textarea[i].attributes["Requiredtip"].nodeValue
                            }
                            else {
                                //alert(textarea[i].attributes["FieldID"].nodeValue + "不能为空");
                                textarea[i].style.backgroundColor = bkcolor;
                                return (textarea[i].attributes["FieldID"].nodeValue + "不能为空");
                            }
                            //return false;
                        }
                    }
                }
            }
            return "1";
        }
        function DataFormatInit() {
            var controls = $("[FieldType='数值']");
            for (var i = 0; i < controls.length; i++) {
                controls[i].onkeyup = function () { if (isNaN(this.value)) { document.execCommand("undo"); } };
                controls[i].onafterpaste = function () { if (isNaN(this.value)) return false; };
            }
        }
        function setClassID() {
            $("#FieldKeyValue").val($("#ExtTextBox1").textbox("getValue"));
        }
        document.onkeyup = function () {
            var e = event.srcElement
            if (event.keyCode == 13) {
                if ($("#Text1").val().length > 0) {
                    document.getElementById("btnsearch").click();
                }
            }
        }
    </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
        <div data-options="region:'west',title:'公共数据列表',split:true" style="width: 400px;">
            <table id="datalist" style="overflow: hidden;" data-options="fit:true">
            </table>
        </div>
        <div data-options="region:'center'">
            <div style="height: 30px; width: 100%; line-height: 30px; background-color: #efefef;">
                <a href="#" class="easyui-linkbutton" iconcls="icon-add" plain="true" onclick="f_add()">新增</a> <a href="#" class="easyui-linkbutton" iconcls="icon-remove" plain="true" onclick="f_delete()">删除</a> <a href="#" class="easyui-linkbutton" iconcls="icon-save" plain="true" onclick="f_save()">保存</a> <a href="#" class="easyui-linkbutton" iconcls="icon-cancel" plain="true" onclick="f_cancel()">取消</a>
                <input id="TableName" type="hidden" value="BscDataListM" />
                <input id="FieldKey" type="hidden" value="sClassID" />
                <input id="FieldKeyValue" type="hidden" />
            </div>
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north',split:true" style="height: 100px;">
                    <div id="divmain">
                        <table cellpadding="5" cellspacing="5" style="margin-top: 8px; margin-left: 20px;">
                            <tr>
                                <td>分组编号：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox1" CssClass="txbbottom" runat="server" Z_FieldID="sClassID"
                                        Z_Required="True" Z_RequiredTip="不可为空" onblur="setClassID()" />
                                </td>
                                <td>分组名称：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox2" CssClass="txbbottom" runat="server" Z_FieldID="sClasName" />
                                </td>
                            </tr>
                            <tr>
                                <td>模组说明：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox3" CssClass="txbbottom" runat="server" Z_FieldID="sFormular" />
                                </td>
                                <td>备注：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox4" CssClass="txbbottom" runat="server" Z_FieldID="sReMark" />
                                    <cc2:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                                    <cc2:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'center'">
                    <table id="detail" isson="true" tablename="BscDataListD" linkfield="sClassID=sClassID"
                        fieldkey="iRecNo">
                    </table>
                </div>
            </div>
        </div>
        <div id="tb">
            <div>
                <input id="Text1" type="text" />
                <a href="#" id="btnsearch" class="easyui-linkbutton" iconcls="icon-search" plain="true"
                    onclick="f_search()"></a><a href="#" class="easyui-linkbutton" iconcls="icon-reload"
                        plain="true" onclick="f_refresh()"></a>
            </div>
        </div>
    </form>
</body>
</html>
