<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>快捷入口定义</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        .tab
        {
            margin-left: 20px;
        }
        .tab tr td
        {
            height: 30px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        $(function () {
            $.ajax({
                url: "/ashx/LoginHandler.ashx",
                type: "post",
                async: true,
                cache: false,
                data: { otype: "getcurtuserid" },
                success: function (data) {
                    $("#userid").val(data);
                }
            });

            var data;
            var dataStr = callpostback("/Base/Handler/PublicHandler.ashx", "otype=getLinkData", false, true);
            if (dataStr) {
                data = eval("(" + dataStr + ")");
            }
            $("#list").datagrid({
                columns: [[
            { field: 'iSerial', title: '序号', width: 50, sortable: true },
            { field: 'sLinkName', title: '名称', width: 200, sortable: true },
            { field: 'sMenuName', title: '链接表单名称', width: 200, sortable: true },
            { field: 'sGroupName', title: '分组', width: 150, sortable: true }
            ]],
                data: data,
                onSelect: function (index, row) {
                    $("#form1").form("load", row);
                },
                singleSelect: true,
                remoteSort: false
            });
            $("#Text3").combotree({
                url: "/Base/Handler/GetMenuTree.ashx",
                queryParams: { itype: "getUserMenu" },
                onBeforeSelect: function (node) {
                    var childNodes = $($("#Text3").combotree("tree")).tree("getChildren", node.target);
                    if (childNodes && childNodes.length > 0) {
                        return false;
                    }
                    return true;
                },
                onSelect: function (node) {
                    $("#Text2").textbox("setValue", node.text);
                    var pnode = $("#Text3").combotree('tree').tree("getParent", node.target);
                    $("#Text4").combobox("setValue", pnode.text);
                }
            });
            var sqlobj = {
                TableName: "bscDataShortcut",
                Fields: "distinct sGroupName",
                SelectAll: "True"
            }
            var data = SqlGetData(sqlobj);

            $("#Text4").combobox("loadData", data);
        })
        function add() {
            var newRow = {};
            newRow.iRecNo = getChildID("bscDataShortcut");
            newRow.iSerial = $("#list").datagrid("getRows").length + 1;
            $("#form1").form("clear");
            $("#form1").form("load", newRow);
        }
        function remove() {
            var row = $("#list").datagrid("getSelected");
            var rowIndex = undefined;
            if (row) {
                $.messager.confirm("确认删除吗", "您确认删除所选数据吗？", function (r) {
                    if (r) {
                        var result = callpostback("/Base/Handler/PublicHandler.ashx", "otype=deleteLinkData&iRecNo=" + row.iRecNo, false, true);
                        if (result != "1") {
                            $.messager.alert("错误", result);
                        }
                        else {
                            rowIndex = $("#list").datagrid("getRowIndex", row);
                            $("#list").datagrid("deleteRow", rowIndex);
                            if ($("#list").datagrid("getRows").length == 0) {
                                $("#form1").form("clear");
                            }
                            else if ($("#list").datagrid("getRows").length > rowIndex) {
                                $("#list").datagrid("selectRow", rowIndex);
                            }
                            else {
                                $("#list").datagrid("selectRow", $("#list").datagrid("getRows").length - 1);
                            }
                        }
                    }
                });
            }
        }
        function save() {
            if ($("#form1").form("validate")) {
                var iRecNo = $("#FieldKeyValue").val();
                var sqlObj = {
                    TableName: "bscDataShortcut",
                    Fields: "count(iRecNo) as c",
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
                if (result && result.length > 0) {
                    if (parseInt(result[0].c) > 0) {
                        if (Form.__update(iRecNo, "/Base/Handler/DataOperatorNew.ashx")) {
                            refresh();
                        }
                        else {

                        }
                    }
                    else {
                        var result = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                        if (result != undefined) {
                            refresh();
                        }
                        else {

                        }
                    }
                }
                //                if ($("#Hidden1").textbox("getValue") == "" || $("#Hidden1").textbox("getValue") == undefined) {
                //                    var newRow = {};
                //                    newRow.iRecNo = getChildID("bscDataShortcut");
                //                    newRow.iSerial = $("#list").datagrid("getRows").length + 1;
                //                    $("#form1").form("load", newRow);
                //                }
                //                $.messager.progress();
                //                $("#form1").form("submit", {
                //                    url: "/Base/Handler/PublicHandler.ashx",
                //                    onSubmit: function (param) {
                //                        param.otype = "modlistData";
                //                    },
                //                    success: function (result) {
                //                        if (result && result == "1") {
                //                            $.messager.alert("成功", "保存成功");
                //                            refresh();
                //                        }
                //                        else {
                //                            $.messager.alert("错误", result);
                //                        }
                //                        $.messager.progress('close'); // 如果提交成功则隐藏进度条
                //                    }
                //                });
                //                $.messager.progress("close");
            }
        }
        function refresh() {
            var data;
            var dataStr = callpostback("/Base/Handler/PublicHandler.ashx", "otype=getLinkData", false, true);
            if (dataStr) {
                data = eval("(" + dataStr + ")");
                $("#list").datagrid("loadData", data);
            }
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
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',split:true,title:'快捷入口定义'" style="height: 220px">
        <input type="hidden" id="TableName" value="bscDataShortcut" />
        <input type="hidden" id="FieldKey" value="iRecNo" />
        <input type="hidden" id="userid" value="" fieldid="sUserID" />
        <input type="hidden" id="inputdate" value="" fieldid="dInputTime" />
        <form id="form1" method="post">
        <input type="hidden" id="FieldKeyValue" name="iRecNo" />
        <!--表的主键值-->
        <div style="background-color: #efefef; height: 35px; line-height: 35px">
            <a id="btn" href="javascript:void(0)" class="easyui-linkbutton" onclick="add()" data-options="iconCls:'icon-add'">
                增加</a> <a id="A1" href="javascript:void(0)" class="easyui-linkbutton" onclick="remove()"
                    data-options="iconCls:'icon-remove'">删除</a> <a id="A2" href="javascript:void(0)"
                        class="easyui-linkbutton" onclick="save()" data-options="iconCls:'icon-save'">保存</a>
        </div>
        <table class="tab">
            <tr>
                <td>
                    序号
                </td>
                <td>
                    <input id="Text1" type="text" class="easyui-numberspinner" style="width: 50px;" name="iSerial"
                        fieldid="iSerial" />
                </td>
            </tr>
            <tr>
                <td>
                    业务单据
                </td>
                <td>
                    <input id="Text3" type="text" class="easyui-combotree" data-options="width:150,editable:false,required:true,invalidMessage:'不能为空'"
                        name="iMenuID" fieldid="iMenuID" plugin="combotree" />
                </td>
            </tr>
            <tr>
                <td>
                    显示名称
                </td>
                <td>
                    <input id="Text2" type="text" class="easyui-textbox" data-options="width:150,required:true,invalidMessage:'不能为空'"
                        name="sLinkName" fieldid="sLinkName" plugin="textbox" />
                </td>
            </tr>
            <tr>
                <td>
                    分组
                </td>
                <td>
                    <input id="Text4" type="text" class="easyui-combobox" data-options="width:150,valueField:'sGroupName',textField:'sGroupName',editable:true,required:true,invalidMessage:'不能为空'"
                        name="sGroupName" fieldid="sGroupName" plugin="combobox" />
                </td>
            </tr>
        </table>
        </form>
    </div>
    <div data-options="region:'center',split:true,title:'快捷入口列表'">
        <table id="list">
        </table>
    </div>
</body>
</html>
