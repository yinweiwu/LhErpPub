<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>表单查询条件定义</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js" type="text/javascript"></script>
    <script src="/Base/JS2/lookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/datagridOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var iformid = undefined;
        var userid = undefined;
        $.ajax({
            url: "/ashx/LoginHandler.ashx",
            type: "get",
            async: false,
            cache: false,
            data: { otype: "getcurtuserid" },
            success: function (data) {
                userid = data;
            },
            error: function (data) {
                var aa = data;
            }
        });
        $(function () {
            iformid = getQueryString("iformid");

            $("#Text1").val(iformid);

            var mainFields = undefined;
            $.ajax({
                url: "/Base/Handler/sysHandler.ashx",
                type: "post",
                async: false,
                cache: false,
                data: { otype: "getmainsqlfield", iformid: iformid },
                success: function (data) {
                    try {
                        mainFields = eval("(" + data + ")");
                    }
                    catch (e) {

                    }
                },
                error: function () {

                }
            })


            $("#dg").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                columns: [[
                    { field: "__cb", checkbox: true },
                    { field: "iSerial", title: "序号", width: 40, editor: { type: "numberspinner"} },
                    { field: "sFieldName", title: "字段名", width: 120, editor: { type: "combobox", options: { valueField: "Name", textField: "Name", data: mainFields}} },
                    { field: "sCaption", title: "标题", width: 150, editor: { type: "text"} },
                    { field: "sFieldType", title: "字段<br />类型", width: 50, editor: { type: "combobox", options: { valueField: "text", textField: "text", data: [{ text: "S" }, { text: "F" }, { text: "D" }, { text: "DT" }, { text: "B"}]}} },
                    { field: "sOpTion", title: "操作符", width: 60, editor: { type: "combobox", options: { valueField: "text", textField: "text", editable: true, data: [{ text: "=" }, { text: "%like%" }, { text: "like%" }, { text: "%like" }, { text: ">=" }, { text: "<=" }, { text: ">" }, { text: "<" }, { text: "in" }, { text: "not in"}]}} },
                    { field: "sValue", title: "初始值", width: 80, editor: { type: "combobox", options: { valueField: "text", textField: "text", editable: true, data: [{ text: "UserID" }, { text: "UserName" }, { text: "CurrentDate" }, { text: "CurrentDateTime" }, { text: "Departid" }, { text: "NewGUID"}]}} },
                    { field: "iRequired", title: "必填", width: 40, align: 'center', editor: { type: "checkbox", options: { on: '1', off: '0'} },
                        formatter: function (value, row, index) {
                            if (value == "1") {
                                return "√";
                            }
                        }
                    },
                    { field: "iMulti", title: "多选", width: 40, align: 'center', editor: { type: "checkbox", options: { on: '1', off: '0'} },
                        formatter: function (value, row, index) {
                            if (value == "1") {
                                return "√";
                            }
                        }
                    },
                    { field: "bQuery", title: "动态列<br />触发字段", width: 40, align: 'center', editor: { type: "checkbox", options: { on: '1', off: '0'} },
                        formatter: function (value, row, index) {
                            if (value == "1" || value == "on" || value == "True") {
                                return "√";
                            }
                        }
                    },
                    { field: "sColumnSource", title: "列源", align: "center", width: 200, editor: { type: "mytextarea", options: { style: "height:80px;"}} },
                    { field: "sColumnDataSource", title: "列数据源", align: "center", width: 200, editor: { type: "mytextarea", options: { style: "height:80px;"}} },
                    { field: "sLookUpName", title: "lookUp", align: "center", width: 150, editor: { type: "text"} },
                    { field: "sLookUpFilters", title: "lookUp过滤条件", align: "center", width: 200, editor: { type: "mytextarea", options: { style: "height:80px;"}} }
                ]],
                toolbar: [
                    {
                        text: "增加行",
                        iconCls: 'icon-add',
                        handler: function () {
                            var iSerial = $("#dg").datagrid("getRows").length + 1;
                            var appRow = {
                                GUID: NewGuid(),
                                iFormID: iformid,
                                iSerial: iSerial,
                                sUserID: userid,
                                dInputDate: getNowDate() + " " + getNowTime(),
                                sOpTion: "like"
                            };
                            $("#dg").datagrid("appendRow", appRow);
                        }
                    },
                    {
                        text: "删除行",
                        iconCls: 'icon-remove',
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#dg").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        $("#dg").datagrid("deleteRow", $("#dg").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                    ],
                onClickCell: function (index, row) { datagridOp.cellClick("dg", index, row); },
                onBeforeEdit: function (index, row) { datagridOp.beforeEditor("dg", index, row); },
                onBeginEdit: function (index, row) { datagridOp.beginEditor("dg", index, row); },
                onEndEdit: function (index, row, changes) { datagridOp.endEditor("dg", index, row, changes); },
                onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("dg", index, row, changes); }
            });

            var sqlobj = {
                TableName: "bscDataSearch",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + iformid + "'"
                }
                ],
                Sorts: [
                    {
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }
                ]
            }
            var data = SqlGetData(sqlobj);
            $("#dg").datagrid("loadData", data);

        })

        function save() {
            var json = {
                "TableName": "bscDataSearch",
                "FieldKeysValues": $("#Text1").val()
            }
            var allRows = $("#dg").datagrid("getRows");
            for (var i = 0; i < allRows.length; i++) {
                $("#dg").datagrid("endEdit", i);
            }
            var allRows = $("#dg").datagrid("getRows");
            $.ajax({
                url: "/Base/Handler/DataOperatorForSys.ashx",
                type: "post",
                async: false,
                cache: false,
                //data: { from: "sysquerycnditn", mainquery: encodeURIComponent(JSON.stringify(json)), detaildata: encodeURIComponent(JSON2.stringify(allRows)) },
                data: { from: "sysquerycnditn", mainquery: JSON.stringify(json), children: JSON2.stringify(allRows) },
                success: function (data) {
                    if (data.indexOf("error:") > -1) {
                        $.messager.alert("错误", data.substr(6, data.length - 6));
                        return false;
                    }
                    else {
                        $.messager.alert("成功", "保存成功");
                    }
                }
            })

        }
        function NewGuid_S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function NewGuid() {
            return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }

        //获取今天日期：格式2015-01-01
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
        //获取当前时时
        function getNowTime() {
            var nowdate = new Date();
            var hour = nowdate.getHours();      //获取当前小时数(0-23)
            var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
            var second = nowdate.getSeconds();
            return hour + ":" + minute + ":" + second;
        }
    </script>
</head>
<body class="easyui-layout" data-options="border:false">
    <form id="form1" runat="server">
    <div data-options="region:'north',border:true" style="height: 60px;">
        <div style="height: 30px; padding-left: 10px; background-color: #efefef;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
        </div>
        <div>
            FormID：&nbsp;&nbsp;<input id="Text1" style="border: none;" readonly="readonly" type="text" />
        </div>
    </div>
    <div data-options="region:'center',border:true">
        <table id="dg">
        </table>
    </div>
    </form>
</body>
</html>
