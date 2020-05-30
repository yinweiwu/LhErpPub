<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>更新日志</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <link href="/Base/JS/kindeditor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/kindeditor/plugins/code/prettify.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/kindeditor/kindeditor.js" type="text/javascript"></script>
    <script src="/Base/JS/kindeditor/lang/zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/kindeditor/plugins/code/prettify.js" type="text/javascript"></script>
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
        var editor;

        KindEditor.ready(function (K) {
            editor = K.create('#editor_id', {
                cssPath: '/Base/JS/kindeditor/plugins/code/prettify.css',
                uploadJson: '/Base/kindHandler/upload_json.ashx',
                fileManagerJson: '/Base/kindHandler/file_manager_json.ashx',
                allowFileManager: true,
                items: [
                    'source', '|', 'undo', 'redo', '|', 'preview', 'cut', 'copy', 'paste',
                    'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
                    'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
                    'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
                    'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
                    'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage', 'insertfile',
                    'table', 'hr', 'emoticons', 'pagebreak',
                    'anchor', 'link', 'unlink'
                ],
                afterCreate: function () {
                    /*var self = this;
                    K.ctrl(document, 13, function () {
                    self.sync();
                    K('form[name=example]')[0].submit();
                    });
                    K.ctrl(self.edit.doc, 13, function () {
                    self.sync();
                    K('form[name=example]')[0].submit();
                    });*/
                    this.sync();
                }
            });
            prettyPrint();
        });

        $(function () {
            var iformid = getQueryString("iformid");
            $("#Text8").textbox("setValue", iformid);
            $("#divDetail").dialog({
                modal: true,
                width: 950,
                height: 500,
                top: 20,
                left: 100,
                closable: false
            });
            $("#divDetail").dialog("close");
            //子表表格
            $("#tableList").datagrid({
                fit: true,
                idField: "iRecNo",
                columns: [[
                    { field: 'iSerial', title: '序号', width: 40 },
                    { field: "sContent", hidden: true },
                    { field: 'sUserID', title: '录入人', width: 100 },
                    { field: 'dInputDate', title: '录入时间', width: 180 },
                    { field: 'sReMark', title: '备注', width: 350 },
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
                        text: "新增日志",
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
                            $("#Text1").textbox("disable");
                            editor.html("");
                            $("#divDetail").dialog({
                                title: '新增日志',
                                toolbar: [
                                    {
                                        text: "保存",
                                        iconCls: "icon-save",
                                        handler: function () {                                           
                                            editor.sync();
                                            if ($("#editor_id").val()=="") {
                                                $.messager.alert("错误", "请输入更新内容");
                                                return;
                                            }
                                            var r = $("#form1").form("validate");
                                            if (r) {
                                                $("#form1").form("submit", {
                                                    url: "/Base/Handler/UpdateLogHandler.ashx",
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
                        text: "修改日志",
                        handler: function () {
                            editRow();
                        }
                    },
                    '-',
                    {
                        iconCls: 'icon-remove',
                        text: "删除日志",
                        handler: function () {
                            //var selectedRow = $("#tableList").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除？", "您确认删除'" + selectedRow.iSerial + "'号日志吗,删除后将无法恢复？", function (r) {
                                    if (r) {
                                        $("#form1").form("submit", {
                                            url: "/Base/Handler/UpdateLogHandler.ashx",
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
                    }
                ],
                singleSelect: true,
                onDblClickRow: function (index, row) {
                    editRow();
                },
                onClickRow: function (index, row) {
                    selectedRow = row;
                },
                onSelect: function (index, row) {
                    selectedRow = row;
                }
            });
            setTimeout("refreshTableList()", 500);

        });
        //子表表格刷新
        function refreshTableList() {
            var sqlObj = {
                TableName: "bscDataBillDUpdateLog",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormid",
                    ComOprt: "=",
                    Value: getQueryString("iformid")
                }],
                Sorts: [{
                    SortName: "iSerial",
                    SortOrder: "desc"
                }]
            };
            var data = SqlGetData(sqlObj);
            $("#tableList").datagrid({
                data: data
            });
            selectedRow = undefined;
            $("#tableList").datagrid('clearSelections');
        }

        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }

        function editRow() {
            if (selectedRow) {
                $("#form1").form("clear");
                $("#Text1").textbox("enable");
                var sqlObj = {
                    TableName: "bscDataBillDUpdateLog",
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
                editor.html(selectedRow.sContent);
                $("#divDetail").dialog({
                    title: '修改子表',
                    toolbar: [
                        {
                            text: "保存",
                            iconCls: "icon-save",
                            handler: function () {
                                editor.sync();
                                if ($("#editor_id").val() == "") {
                                    $.messager.alert("错误", "请输入更新内容");
                                    return;
                                }
                                if ($("#form1").form("validate")) {
                                    $("#form1").form("submit", {
                                        url: "/Base/Handler/UpdateLogHandler.ashx",
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
                    ]
                });
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }

    </script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false,split:true" style="height: 100%">
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
    <div id="divDetail" style="text-align: center;">
        <form id="form1" method="post">
            <table style="width:99%;">
                <tr>
                    <td colspan="4">
                        <textarea id="editor_id" name="sContent"  style="width:100%;height:340px;"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">备注
                    </td>
                    <td class="style1" colspan="3">
                        <textarea id="TextArea2" name="sReMark" style="width:100%;"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;width:50px;">序号
                    </td>
                    <td class="style1" style="text-align: left;width:50px;">
                        <input id="Text1" name="iSerial" class="easyui-textbox" data-options="width:50" type="text" />
                    </td>
                    <td style="text-align: right;width:50px;" >停用
                    </td>
                    <td class="style1" style="text-align: left">
                        <input id="Text2" name="iDisabled" type="checkbox" />
                    </td>
                </tr>               
            </table>
        </form>
    </div>
</body>
</html>
