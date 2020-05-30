<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>系统平台</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../JS/json2.js" type="text/javascript"></script>
    <script src="../JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="../JS/SqlOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="../JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
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


        var editIndex = undefined;
        var editIndex1 = undefined;
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

            $('#tt').tree({
                url: '/Base/Handler/GetMenuTree.ashx',
                onSelect: f_treeSelect,
                dnd: true,
                onBeforeDrop: function (target, source, point) {
                    if (point == "append") {
                        return false;
                    }
                    var tparent = $("#tt").tree("getParent", target);
                    var sparent = $("#tt").tree("getParent", source.target);
                    //var theFirstChildren;
                    if (tparent == null && sparent == null) {

                    }
                    else if (tparent != sparent) {
                        return false;
                    }
                },
                onDrop: function (target, source, point) {
                    var tparent = $("#tt").tree("getParent", target);
                    var sparent = $("#tt").tree("getParent", source.target);
                    var theFirstChildren;
                    if (tparent != null) {
                        theFirstChildren = $("#tt").tree("getLeafChildren", tparent.target);
                    }
                    else {
                        theFirstChildren = $("#tt").tree("getRoots");
                    }
                    var iMenuIDStr = "";
                    var iSerialStr = "";
                    for (var i = 0; i < theFirstChildren.length; i++) {
                        iMenuIDStr += theFirstChildren[i].id + ",";
                        iSerialStr += i + ",";
                    }
                    if (iMenuIDStr.length > 0) {
                        iMenuIDStr = iMenuIDStr.substr(0, iMenuIDStr.length - 1);
                        iSerialStr = iSerialStr.substr(0, iSerialStr.length - 1);
                    }
                    if (iMenuIDStr.length > 0) {
                        var jsonobj = {
                            StoreProName: "SpSysMainMenuSaveSerial",
                            StoreParms: [
                                {
                                    ParmName: "@iMenuIDStr",
                                    Value: iMenuIDStr
                                },
                                {
                                    ParmName: "@iSerialStr",
                                    Value: iSerialStr
                                }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            alert(result);
                        }
                        else {
                            //GridRefresh();
                        }
                    }
                }
            });
            var iconData = [
                {
                    id: "add",
                    text: "增加"
                },
                {
                    id: "edit",
                    text: "编辑"
                },
                {
                    id: "remove",
                    text: "删除"
                },
                {
                    id: "copy",
                    text: "复制"
                },
                {
                    id: "save",
                    text: "保存"
                },
                {
                    id: "ok",
                    text: "ok"
                },
                {
                    id: "cut",
                    text: "剪切"
                },
                {
                    id: "reload",
                    text: "刷新"
                },
                {
                    id: "search",
                    text: "查询"
                },
                {
                    id: "print",
                    text: "打印"
                },
                {
                    id: "preview",
                    text: "上一步"
                },
                {
                    id: "next",
                    text: "下一步"
                },
                {
                    id: "import",
                    text: "转入"
                }
            ];

            $('#right').datagrid({
                //url: 'datagrid_data.json',
                ctrlSelect: true,
                fit: true,
                borer: false,
                //url: "/Base/Handler/getData.ashx",
                columns: [[
            { field: 'cc', checkbox: true, width: 30 },
            { field: 'iSerial', title: '顺序号', width: 50, editor: { type: 'numberbox' } },
            { field: 'sRightName', title: '权限参数', width: 80, editor: { type: 'text' } },
            { field: 'sRightDetail', title: '权限说明', width: 80, editor: { type: 'text' } },
            { field: 'sType', title: '类型', width: 60, editor: { type: 'combobox', options: { data: [{ text: '按钮' }, { text: '文本框' }], panelHeight: 40, textField: 'text', valueField: 'text' } } },
            { field: 'sIcon', title: "图标", width: 60, editor: { type: 'combobox', options: { data: iconData, valueField: "id", textField: "text" } } },
            { field: 'iHidden', title: '隐藏', align: 'center', width: 40, editor: { type: 'checkbox', options: { on: '1', off: '' } }, formatter: function (value, row, index) { if (value == "1") { return "√"; } } },
            { field: 'sDisabledCondition', title: '禁用条件', width: 200, editor: { type: 'mytextarea', options: { style: "width:98%; height:100px;border:solid 1px #dddddd;overflow:auto;" } } },
            { field: 'sStoredProce', title: '存储过程', width: 100, editor: { type: 'text' } },
            { field: 'sJsCode', title: 'JS代码', width: 200, editor: { type: 'mytextarea', options: { style: "width:98%; height:100px;border:solid 1px #dddddd;overflow:auto;" } } }
                ]],
                onClickCell: f_clickRowCell,
                toolbar: [
            {
                id: 'add',
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#right").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: '',
                            iSerial: rows.length + 1,
                            sRightDetail: '',
                            sStoredProce: '',
                            sJsCode: '',
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }
                }
            },
            "-",
            {
                id: 'addBaseModule',
                text: "新增基础操作模板",
                iconCls: "icon-add",
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#right").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fadd',
                            iSerial: rows.length + 1,
                            sRightDetail: '增加',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fmodify',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '修改',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fdelete',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '删除',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fcopy',
                            iSerial: rows.length + 1,
                            //sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '复制',
                            __hxstate: "add"
                        });

                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fview',
                            iSerial: rows.length + 1,
                            sRightDetail: '浏览',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fquery',
                            iSerial: rows.length + 1,
                            sRightDetail: '查询',
                            __hxstate: "add"
                        });
                        //iRecNo = getChildID("FSysMainMenuRight");
                        //$('#right').datagrid('appendRow', {
                        //    iRecNo: iRecNo,
                        //    sRightName: 'frefresh',
                        //    iSerial: rows.length + 1,
                        //    sRightDetail: '刷新'
                        //});
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fprint',
                            iSerial: rows.length + 1,
                            sRightDetail: '打印',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fimport',
                            iSerial: rows.length + 1,
                            //sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '导入',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fexport',
                            iSerial: rows.length + 1,
                            sRightDetail: '导出',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fcolumnset',
                            iSerial: rows.length + 1,
                            sRightDetail: '列配置',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fhelp',
                            iSerial: rows.length + 1,
                            sRightDetail: '帮助',
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }
                }
            },
            "-",
            {
                id: 'addBaseModule',
                text: "新增审批模板",
                iconCls: "icon-add",
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#right").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'submit',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '提交',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'submitcancel',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=2&&{iStatus}!=undefined",
                            sRightDetail: '撤销提交',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'checkcancel',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "({iStatus}<=2||{iStatus}==20&&{iStatus}==5&&{iStatus}==10)&&{iStatus}!=undefined",
                            sRightDetail: '撤销审批',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'checkcancelAsk',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=3&&{iStatus}!=4&&{iStatus}!=undefined",
                            sRightDetail: '申请撤销审批',
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }
                }
            },
            "-",
            {
                id: 'addModule',
                text: '新增权限模板',
                iconCls: 'icon-add',
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#right").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery1',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本人',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery2',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本部门',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery3',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本单位',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery4',
                            iSerial: rows.length + 1,
                            sRightDetail: '查全部',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery5',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本客户',
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }
                }
            },
            "-",
            {
                id: 'addModule',
                text: '新增全部模板',
                iconCls: 'icon-add',
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#right").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fadd',
                            iSerial: rows.length + 1,
                            sRightDetail: '增加',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fmodify',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '修改',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fdelete',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '删除',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fcopy',
                            iSerial: rows.length + 1,
                            //sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '复制',
                            __hxstate: "add"
                        });


                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fview',
                            iSerial: rows.length + 1,
                            sRightDetail: '浏览',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fquery',
                            iSerial: rows.length + 1,
                            sRightDetail: '查询',
                            __hxstate: "add"
                        });
                        //iRecNo = getChildID("FSysMainMenuRight");
                        //$('#right').datagrid('appendRow', {
                        //    iRecNo: iRecNo,
                        //    sRightName: 'frefresh',
                        //    iSerial: rows.length + 1,
                        //    sRightDetail: '刷新'
                        //});
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fprint',
                            iSerial: rows.length + 1,
                            sRightDetail: '打印',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fimport',
                            iSerial: rows.length + 1,
                            //sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '导入',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fexport',
                            iSerial: rows.length + 1,
                            sRightDetail: '导出',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'fcolumnset',
                            iSerial: rows.length + 1,
                            sRightDetail: '列配置',
                            __hxstate: "add"
                        });

                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'submit',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=1&&{iStatus}!=0&&{iStatus}!=''&&{iStatus}!=undefined",
                            sRightDetail: '提交',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'submitcancel',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=2&&{iStatus}!=undefined",
                            sRightDetail: '撤销提交',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'checkcancel',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "({iStatus}<=2||{iStatus}==20&&{iStatus}==5&&{iStatus}==10)&&{iStatus}!=undefined",
                            sRightDetail: '撤销审批',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'checkcancelAsk',
                            iSerial: rows.length + 1,
                            sDisabledCondition: "{iStatus}!=3&&{iStatus}!=4&&{iStatus}!=undefined",
                            sRightDetail: '申请撤销审批',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery1',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本人',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery2',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本部门',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery3',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本单位',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery4',
                            iSerial: rows.length + 1,
                            sRightDetail: '查全部',
                            __hxstate: "add"
                        });
                        iRecNo = getChildID("FSysMainMenuRight");
                        $('#right').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sRightName: 'bquery5',
                            iSerial: rows.length + 1,
                            sRightDetail: '查本客户',
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }
                }
            },
            '-',
            {
                id: 'delete',
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                    var checkedRows = $("#right").datagrid('getChecked');
                    if (checkedRows.length > 0) {
                        $.messager.confirm('确认', '您确认要删除吗？', function (r) {
                            if (r) {
                                for (var i = 0; i < checkedRows.length; i++) {
                                    var rowIndex = $("#right").datagrid("getRowIndex", checkedRows[i]);
                                    var deleteKey = $("#right").attr("deleteKey");
                                    if (deleteKey) {
                                        deleteKey += checkedRows[i].iRecNo + ",";
                                        $("#right").attr("deleteKey", deleteKey);
                                    } else {
                                        $("#right").attr("deleteKey", checkedRows[i].iRecNo + ",");
                                    }
                                    $("#right").datagrid("deleteRow", rowIndex);
                                }
                            }
                        });
                    }
                    else {
                        $.messager.alert('错误', '未选择任务行！');
                    }
                }
            },
            '-',
            {
                id: 'save',
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    $('#right').datagrid("reload");
                }
            },
            '-',
            {
                id: 'save',
                text: "<span style='color:red'>（图标仅对自定义按钮有效）</span>"
            }
                ],
                onLoadSuccess: function (data) {
                    var aaa = data;
                },
                onLoadError: function (res) {
                    var re = res;
                }
            });
            $('#form').datagrid({
                //url: 'datagrid_data.json',
                ctrlSelect: true,
                fit: true,
                //url: "/Base/Handler/getData.ashx",
                columns: [[
            { field: 'cc', checkbox: true, width: 30 },
            { field: 'sParamName', title: '参数名', width: 100, editor: { type: 'text' } },
            { field: 'sParamValue', title: '参数值', width: 100, editor: { type: 'text' } },
            { field: 'sReMark', title: '备注', width: 200, editor: { type: 'mytextarea', options: { style: "width:98%; height:50px;overflow:hidden; border:solid 1px #dddddd;" } } },
            { field: 'sUserID', title: '录入员', width: 100 },
            { field: 'dinputDate', title: '录入时间', width: 100 }
                ]],
                onClickCell: f_clickRowCell1,
                toolbar: [
            {
                id: 'add',
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    if ($("#tt").tree("getSelected")) {
                        var rows = $("#form").datagrid("getRows");
                        var iRecNo = getChildID("FSysMainMenuParam");
                        $('#form').datagrid('appendRow', {
                            iRecNo: iRecNo,
                            sUserID: _userid,
                            dinputDate: getNowDate() + " " + getNowTime(),
                            __hxstate: "add"
                        });
                    }
                    else {
                        $.messager.alert("错误", "请先选择一个节点！");
                    }

                }
            },
            '-',
            {
                id: 'delete',
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                    var checkedRows = $("#form").datagrid('getChecked');
                    if (checkedRows.length > 0) {
                        $.messager.confirm('确认', '您确认要删除吗？', function (r) {
                            if (r) {
                                for (var i = 0; i < checkedRows.length; i++) {
                                    var rowIndex = $("#form").datagrid("getRowIndex", checkedRows[i]);
                                    var deleteKey = $("#form").attr("deleteKey");
                                    if (deleteKey) {
                                        deleteKey += checkedRows[i].iRecNo + ",";
                                        $("#form").attr("deleteKey", deleteKey);
                                    } else {
                                        $("#form").attr("deleteKey", checkedRows[i].iRecNo + ",");
                                    }
                                    $("#form").datagrid("deleteRow", rowIndex);
                                }
                            }
                        });
                    }
                    else {
                        $.messager.alert('警告', '未选择任务行！');
                    }
                }
            },
            '-',
            {
                //id: 'save',
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    $('#form').datagrid("reload");
                }
            }
                ]
            });
            DataFormatInit();
            document.getElementById("ifrIcon").src = "/Base/menuIcon.aspx";
            setTimeout("treeCollapseAll()", 500);

            $("#mm").menu({
                onClick: iconSelect
            });
        })
        function addchild() {
            var selectedNode = $("#tt").tree("getSelected");
            var sqlobj = {
                TableName: "FSysMainMenu",
                Fields: "nextMenuID=max(iMenuID)+1",
                SelectAll: "True"
            }
            var objdata = SqlGetData(sqlobj);
            while ($("#right").datagrid("getRows").length > 0) {
                $("#right").datagrid("deleteRow", 0);
            }
            while ($("#form").datagrid("getRows").length > 0) {
                $("#form").datagrid("deleteRow", 0);
            }
            if (selectedNode) {
                var iMaxFormID = 0;
                var iMaxSerial = 0;
                var childrenNode = $("#tt").tree("getLeafChildren", selectedNode.target);
                for (var i = 0; i < childrenNode.length; i++) {
                    var iFormID = isNaN(Number(childrenNode[i].attributes.iFormID)) ? 0 : Number(childrenNode[i].attributes.iFormID);
                    var iSerial = isNaN(Number(childrenNode[i].attributes.iSerial)) ? 0 : Number(childrenNode[i].attributes.iSerial);
                    if (iFormID > iMaxFormID) {
                        iMaxFormID = iFormID;
                    }
                    if (iSerial > iMaxSerial) {
                        iMaxSerial = iSerial;
                    }
                }
                var iNextFormID;
                if (iMaxFormID == 0) {
                    iNextFormID = iMaxFormID + "01";
                }
                else {
                    iNextFormID = iMaxFormID + 1;
                }

                setFieldValue("iMenuID", objdata[0].nextMenuID);
                $("#FieldKeyValue").val(objdata[0].nextMenuID)
                setFieldValue("iParentMenuId", selectedNode.id);
                setFieldValue("iSerial", iMaxSerial + 1);
                setFieldValue("sUserID", _userid);
                setFieldValue("dinputDate", getNowDate() + " " + getNowTime());

                setFieldValue("iFormID", iNextFormID);
                setFieldValue("sFilePath", "");
                setFieldValue("sMenuName", "");
                //document.getElementById("ifrIcon").src = "menuIcon.aspx?menuID=" + objdata[0].nextMenuID;
            }
            else {
                setFieldValue("iMenuID", objdata[0].nextMenuID);
                $("#FieldKeyValue").val(objdata[0].nextMenuID)
                setFieldValue("iParentMenuId", 0);
                setFieldValue("iSerial", 0);
                setFieldValue("sUserID", _userid);
                setFieldValue("dinputDate", getNowDate() + " " + getNowTime());

                setFieldValue("iFormID", "");
                setFieldValue("sFilePath", "");
                setFieldValue("sMenuName", "");

            }
            document.getElementById("Button1").style.display = "";
            document.getElementById("ifrIcon").src = "/Base/menuIcon.aspx?menuID=" + objdata[0].nextMenuID + "&random=" + Math.random();
        }
        function deletechild() {
            var selectedNode = $("#tt").tree("getSelected");
            if (selectedNode) {
                if ($("#tt").tree("getChildren", selectedNode.target).length > 0) {
                    $.messager.alert("错误", "存在子节点，请先删除子节点！");
                    return false;
                }
                else {
                    $.messager.confirm("确认", "确认删除吗？", function (r) {
                        if (r) {
                            var sqltext = "delete from FSysMainMenu where iMenuID=@p1 select 1";
                            var result = SqlCommExec({
                                Comm: sqltext,
                                Parms: [
                                {
                                    ParmName: "@p1",
                                    Value: getFieldValue("iMenuID")
                                }
                                ]
                            });
                            if (result == "1") {
                                //$.messager.alert("删除成功", "删除成功");
                                //$("#tt").tree("reload");
                                //setTimeout("treeCollapseAll()",500 );
                                var parentNode = $("#tt").tree("getParent", selectedNode.target);
                                $("#tt").tree("remove", selectedNode.target);
                                if (parentNode) {
                                    var childenNode = $("#tt").tree("getChildren", parentNode.target);
                                    if (childenNode.length > 0) {
                                        $("#tt").tree("select", childenNode[0].target);
                                    }
                                    else {
                                        $("#tt").tree("select", parentNode.target);
                                    }
                                }
                            }
                        }
                    });
                }
            }
            else {
                $.messager.alert("错误", "未选择任务行！");
            }
        }
        function save() {
            //var result = OpertatCheckvalue();
            var result = $("#form1").form("validate");
            if (result != true) {
                return;
            }
            else {
                var sqlobj = {
                    TableName: "FSysMainMenu",
                    Fields: "c=count(*)",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "iMenuID",
                    ComOprt: "=",
                    Value: "'" + getFieldValue("iMenuID") + "'"//,
                    //LinkOprt: "and"
                }
                    /*{
                    Field: "sMenuName",
                    ComOprt: "=",
                    Value: "'" + getFieldValue("sMenuName") + "'"
                    }*/
                    ]
                };
                var objData = SqlGetData(sqlobj);
                if (parseInt(objData[0].c) > 0) {
                    var result = Form.__update(getFieldValue("iMenuID"), "/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (result.indexOf("error:") == -1) {
                        $.messager.alert("成功", "修改成功！");
                        //$("#tt").tree("reload");
                        //setTimeout("treeCollapseAll()", 1000);
                        var selectedNode = $("#tt").tree("getSelected");
                        var attributes = {};
                        attributes.iFormID = getFieldValue('iFormID');
                        attributes.iSerial = getFieldValue('iSerial');
                        attributes.sFilePath = getFieldValue('sFilePath');
                        $("#tt").tree("update", {
                            target: selectedNode.target,
                            text: getFieldValue('sMenuName'),
                            attributes: attributes
                        });

                        /*$("#right").removeAttr("deleteKey");
                        $("#form").removeAttr("deleteKey");
                        var data1 = $("#right").datagrid("getRows");
                        for (var i = 0; i < data1.length; i++) {
                            delete data1[i].__hxstate;
                        }
                        var data2 = $("#form").datagrid("getRows");
                        for (var i = 0; i < data2.length; i++) {
                            delete data2[i].__hxstate;
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
                        var selectedNode = $("#tt").tree("getSelected");
                        $('#tt').tree('append', {
                            parent: selectedNode.target,
                            data: [
                                {
                                    id: result,
                                    text: $("#ExtTextBox4").textbox("getValue"),
                                    attributes: {
                                        sFilePath: $("#ExtTextBox8").textbox("getValue"),
                                        iSerial: $("#ExtTextBox6").textbox("getValue"),
                                        iFormID: $("#ExtTextBox1").textbox("getValue"),
                                        sUserID: $("#ExtTextBox7").textbox("getValue"),
                                        sOpenSql: $("#ExtTextArea1").val(),
                                        dinputDate: $("#ExtTextBox5").textbox("getValue"),
                                        iFullScreen: $("#ExtCheckbox2")[0].checked == true ? "on" : "",
                                        sIcon: $("#hidIcon").val()
                                    }
                                }]
                        });
                        //$("#tt").tree("reload");
                        //setTimeout("treeCollapseAll()", 1000);
                        document.getElementById("Button1").style.display = "none";
                    }
                    else {
                        $.messager.alert("错误", result);
                    }
                }
            }
        }
        function refresh() {
            var sqlobj = {
                TableName: "FSysMainMenu",
                Fields: "nextMenuID=max(iMenuID)+1",
                SelectAll: "True"
            }
            var objdata = SqlGetData(sqlobj);
            setFieldValue("iMenuID", objdata[0].nextMenuID);
            $("#FieldKeyValue").val(objdata[0].nextMenuID);
        }
        function f_treeSelect(node) {
            /*var chilren = $("#tt").tree('getChildren', node.target);
            if (chilren && chilren.length > 0) {
                if (node.state == "closed") {
                    $("#tt").tree('expand', node.target);
                }
                else {
                    $("#tt").tree('collapse', node.target);
                }            
            }*/
            var parent = $("#tt").tree('getParent', node.target);
            var sqlObj = {
                TableName: "View_Yww_FSysMainMenu",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "iMenuID",
                    ComOprt: "=",
                    Value: "'" + node.id + "'"
                }]
            }
            var jsonobj = SqlGetData(sqlObj)[0];
            jsonobj.iHidden = jsonobj.iHidden == "1" ? "on" : "";
            jsonobj.iQueryFirst = jsonobj.iQueryFirst == "1" ? "on" : "";
            jsonobj.iFullScreen = jsonobj.iFullScreen == "1" ? "on" : "";
            jsonobj.iIsUnion = jsonobj.iIsUnion == "1" ? "on" : "";
            //        var jsonobj = {
            //            iFormID: node.attributes.iFormID,
            //            iMenuID: node.id,
            //            sMenuName: node.text,
            //            iParentMenuId: parent == null ? "0" : parent.id,
            //            sFilePath: node.attributes.sFilePath,
            //            iSerial: node.attributes.iSerial,
            //            sUserID: node.attributes.sUserID,
            //            dinputDate: node.attributes.dinputDate,
            //            iHidden: node.attributes.iHidden == "1" ? "on" : "",
            //            sOpenSql: node.attributes.sOpenSql,
            //            sIcon: node.attributes.sIcon
            //        };
            $("#FieldKeyValue").val(node.id);
            $("#form1").form("load", jsonobj);
            $("#spanIcon").attr("class", jsonobj.sIcon);
            document.getElementById("Button1").style.display = "none";
            document.getElementById("ifrIcon").src = "/Base/menuIcon.aspx?menuID=" + node.id + "&random=" + Math.random();
            //$("#right").datagrid({ url: "/Base/Handler/getData.ashx" });
            var sqlobj = {
                TableName: "FSysMainMenuRight",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iSystemMenuID",
                    ComOprt: "=",
                    Value: node.id
                }
                ],
                Sorts: [
            {
                SortName: "iSerial",
                SortOrder: "asc"
            }
                ]
            }
            //        //$("#right").datagrid({ queryParams: { plugin: "datagrid", sqlobj: encodeURIComponent(JSON.stringify(sqlobj)) }, url: "/Base/Handler/getData.ashx" });
            //        var queryParams1 = $("#right").datagrid("options").queryParams;
            //        queryParams1.sqlobj = encodeURIComponent(JSON.stringify(sqlobj));
            //        $("#right").datagrid("reload", queryParams1);
            //        var sqlobj1 = {
            //            TableName: "FSysMainMenuParam",
            //            Fields: "*",
            //            SelectAll: "True",
            //            Filters: [
            //            {
            //                Field: "iSystemMenuID",
            //                ComOprt: "=",
            //                Value: node.id
            //            }
            //        ],
            //            Sorts: [
            //        {
            //            SortName: "iRecNo",
            //            SortOrder: "asc"
            //        }
            //        ]
            //        }
            //        $("#form").datagrid({ queryParams: { plugin: "datagrid", sqlobj: encodeURIComponent(JSON.stringify(sqlobj1)) }, url: "/Base/Handler/getData.ashx" });

            //        var queryParams2 = $("#form").datagrid("options").queryParams;
            //        queryParams2.sqlobj = encodeURIComponent(JSON.stringify(sqlobj1));
            //        $("#form").datagrid("reload", queryParams2);
            //        //$("#right").datagrid('reload');

            var rightData = getRightData(node.id);
            $("#right").datagrid("loadData", rightData);
            var formData = getFormData(node.id);
            $("#form").datagrid("loadData", formData);
        }

        function getRightData(iMenuID) {
            var sqlobj = {
                TableName: "FSysMainMenuRight",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iSystemMenuID",
                    ComOprt: "=",
                    Value: "'" + iMenuID + "'"
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
            return data;
        }

        function getFormData(iMenuID) {
            var sqlobj = {
                TableName: "FSysMainMenuParam",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iSystemMenuID",
                    ComOprt: "=",
                    Value: "'" + iMenuID + "'"
                }
                ],
                Sorts: [
            {
                SortName: "iRecNo",
                SortOrder: "asc"
            }
                ]
            }
            var data = SqlGetData(sqlobj);
            return data;
        }

        function f_clickRowCell(rowIndex, field, value) {
            if (editIndex == undefined) {
                $("#right").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#right").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#right").datagrid('endEdit', editIndex);
                $('#right').datagrid('unselectRow', editIndex);
                $("#right").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#right").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    //var target = ed.target;
                    $(ed.target).focus();
                    $(ed.target).select();
                }
            }
            editIndex = rowIndex;
        }
        function f_clickRowCell1(rowIndex, field, value) {
            if (editIndex1 == undefined) {
                $("#form").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#form").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).select();
                }
            }
            else {
                $("#form").datagrid('endEdit', editIndex1);
                $('#form').datagrid('unselectRow', editIndex1);
                $("#form").datagrid('selectRow', rowIndex)
                      .datagrid('editCell', { index: rowIndex, field: field });
                var ed = $("#form").datagrid('getEditor', { index: rowIndex, field: field });
                if (ed) {
                    $(ed.target).focus();
                    $(ed.target).select();
                }
            }
            editIndex1 = rowIndex;
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
                                        case "textbox":
                                            {
                                                try {
                                                    value = $(c).textbox("getValue");
                                                }
                                                catch (e) {
                                                    //value = $("#" + c.id).textbox("getValue");
                                                    value = $(c).val();
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

        //新增
        function oprateadd(url) {
            var querystr = "";
            var tablename = "FSysMainMenu";
            var fieldkeys = "iMenuID";
            var fieldkeyvalue = getFieldValue("iMenuID");
            //var fieldkeysvalues = getQueryString("lsh");
            var queryaddpart1 = "";
            var queryaddpart2 = "";
            var queryupdatepart1 = "";
            var queryupdatepart2 = "";
            var input = document.getElementById("divmain").getElementsByTagName("INPUT");
            var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
            var select = document.getElementById("divmain").getElementsByTagName("SELECT");
            for (var i = 0; i < textarea.length; i++) {
                var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue != fieldkeys && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
                    //var objtype = textarea[i].type;
                    var fieldid = textarea[i].attributes["FieldID"].nodeValue;
                    var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
                    var saveValue = textarea[i].attributes["SaveValue"] == null ? "" : textarea[i].attributes["SaveValue"].nodeValue;
                    //if (queryaddpart1.indexOf(fieldid) < 0) {
                    queryaddpart1 += fieldid + ",";
                    var value = textarea[i].value;
                    if (document.getElementById(textarea[i].id + "_val") && (saveValue == "" || saveValue.toUpperCase() == "TRUE")) {
                        value = value.length == 0 ? "" : document.getElementById(textarea[i].id + "_val").value.length == 0 ? value : document.getElementById(textarea[i].id + "_val").value;
                    }
                    //queryaddpart2 += value.replace(/%/g, "%25") + "<|>";
                    queryaddpart2 += value + "<|>";
                    //}
                }
            }
            for (var i = 0; i < input.length; i++) {
                var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue != fieldkeys && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
                    var objtype = input[i].type;
                    var fieldid = input[i].attributes["FieldID"].nodeValue;
                    var fieldtype = "空";
                    if (input[i].attributes["FieldType"] == null) {
                        fieldtype = "空";
                    }
                    else {
                        fieldtype = input[i].attributes["FieldType"].nodeValue;
                    }
                    var saveValue = input[i].attributes["SaveValue"] == null ? "" : input[i].attributes["SaveValue"].nodeValue;
                    //if (queryaddpart1.indexOf(fieldid) < 0) {
                    queryaddpart1 += fieldid + ",";
                    if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                        var value = input[i].value;
                        if (document.getElementById(input[i].id + "_val") && (saveValue == "" || saveValue.toUpperCase() == "TRUE")) {
                            value = value.length == 0 ? "" : document.getElementById(input[i].id + "_val").value.length == 0 ? value : document.getElementById(input[i].id + "_val").value;
                        }
                        //queryaddpart2 += value.replace(/%/g, "%25") + "<|>";
                        queryaddpart2 += value + "<|>";
                    }
                    if (objtype == "checkbox") {
                        var value = input[i].checked == true ? "1" : "0";
                        queryaddpart2 += value + "<|>";
                    }
                }
            }
            for (var i = 0; i < select.length; i++) {
                var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue != fieldkeys && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
                    //var objtype = textarea[i].type;
                    var fieldid = select[i].attributes["FieldID"].nodeValue;
                    var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
                    //if (queryaddpart1.indexOf(fieldid) < 0) {
                    queryaddpart1 += fieldid + ",";
                    var value = select[i].value;  //select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
                    var saveValue = select[i].attributes["SaveValue"] == null ? "" : select[i].attributes["SaveValue"].nodeValue;
                    if (document.getElementById(select[i].id + "_val") && (saveValue == "" || saveValue.toUpperCase() == "TRUE")) {
                        value = value.length == 0 ? "" : document.getElementById(select[i].id + "_val").value.length == 0 ? value : document.getElementById(select[i].id + "_val").value;
                    }
                    //queryaddpart2 += value.replace(/%/g, "%25") + "<|>";
                    queryaddpart2 += value + "<|>";
                    //}
                }
            }
            if (queryaddpart1.length > 0) {
                queryaddpart1 = queryaddpart1.substr(0, queryaddpart1.length - 1);
                queryaddpart2 = queryaddpart2.substr(0, queryaddpart2.length - 3);
            }
            var operate = "add";
            querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"add\",\"Fields\":\"" + queryaddpart1 + "\",\"FieldsValues\":\"" + queryaddpart2 + "\"," +
                    "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + fieldkeyvalue + "\"}";
            //子表、孙子表
            var jsonchildren = [];
            var children = $("[isson='true']");
            for (var i = 0; i < children.length; i++) {
                var jsonobj = {};
                var tablename = children[i].attributes["tablename"].nodeValue;
                var linkfield = children[i].attributes["linkfield"].nodeValue;
                var fieldkey = children[i].attributes["fieldkey"].nodeValue;
                jsonobj.childtype = "son";
                jsonobj.tablename = tablename;
                jsonobj.linkfield = linkfield;
                jsonobj.fieldkey = fieldkey;
                var data;
                var data = $("#" + children[i].id).datagrid("getRows");
                for (var z = 0; z < data.length; z++) {
                    $("#" + children[i].id).datagrid("endEdit", z);
                }
                //data = $("#" + children[i].id).datagrid("getData").rows;
                //只保存表中的列
                var sqltext = "SELECT Name from SysColumns WHERE id=Object_Id('" + tablename + "')";
                var tablefields = SqlGetDataComm(sqltext);
                for (var ic = 0; ic < data.length; ic++) {
                    for (var key in data[ic]) {
                        var exists = false;
                        for (var j = 0; j < tablefields.length; j++) {
                            if (key == tablefields[j].Name) {
                                exists = true;
                            }
                        }
                        if (exists == false) {
                            delete data[ic][key];
                        }
                    }
                }
                jsonobj.data = data;
                jsonchildren.push(jsonobj);
            }
            //var parms = "mainquery=" + encodeURIComponent(querystr) + "&children=" + encodeURIComponent(JSON.stringify(jsonchildren));
            $.ajax({
                url: url,
                data: { mainquery: querystr, children: JSON.stringify(jsonchildren) },
                cache: false,
                type: "POST",
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function (data) {
                    $.messager.alert("出错", "与服务器连接失败！");
                }

            });
            //var result = callpostback(url, parms, false, true);
            return result;
        }
        //修改
        function operateupdate(irecno, url) {
            var queryupdatepart1 = "";
            var queryupdatepart2 = "";
            //主表
            var querystr = "";
            var tablename = "FSysMainMenu";
            var fieldkeys = "iMenuID";

            var input = document.getElementById("divmain").getElementsByTagName("INPUT");
            var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
            var select = document.getElementById("divmain").getElementsByTagName("SELECT");
            for (var i = 0; i < textarea.length; i++) {
                var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue != fieldkeys && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
                    var fieldid = textarea[i].attributes["FieldID"].nodeValue;
                    var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
                    //if (queryupdatepart1.indexOf(fieldid) < 0) {
                    queryupdatepart1 += fieldid + ",";
                    var value = textarea[i].value;
                    if (document.getElementById(textarea[i].id + "_val")) {
                        value = value.length == 0 ? "" : document.getElementById(textarea[i].id + "_val").value.length == 0 ? value : document.getElementById(textarea[i].id + "_val").value;
                    }
                    //queryupdatepart2 += value.replace(/%/g, "%25") + "<|>";
                    queryupdatepart2 += value + "<|>";
                    //}
                }
            }
            for (var i = 0; i < input.length; i++) {
                var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue != fieldkeys && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
                    var objtype = input[i].type;
                    var fieldid = input[i].attributes["FieldID"].nodeValue;
                    var fieldtype = input[i].attributes["FieldType"] == null ? "空" : input[i].attributes["FieldType"].nodeValue;
                    //if (queryupdatepart1.indexOf(fieldid) < 0) {
                    queryupdatepart1 += fieldid + ",";
                    if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                        var value = input[i].value;
                        if (document.getElementById(input[i].id + "_val")) {
                            value = value.length == 0 ? "" : document.getElementById(input[i].id + "_val").value.length == 0 ? value : document.getElementById(input[i].id + "_val").value;
                        }
                        //                queryupdatepart2 += value.replace(/%/g, "%25") + "<|>";
                        queryupdatepart2 += value + "<|>";
                    }
                    if (objtype == "checkbox") {
                        var value = input[i].checked == true ? "1" : "0";
                        queryupdatepart2 += value + "<|>";
                    }
                }
            }
            for (var i = 0; i < select.length; i++) {
                var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
                if (nosave == "TRUE") {
                    continue;
                }
                if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue != fieldkeys && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
                    //var objtype = textarea[i].type;
                    var fieldid = select[i].attributes["FieldID"].nodeValue;
                    var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
                    //if (queryupdatepart1.indexOf(fieldid) < 0) {
                    queryupdatepart1 += fieldid + ",";
                    var value = select[i].value;  //select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
                    if (document.getElementById(select[i].id + "_val")) {
                        value = value.length == 0 ? "" : document.getElementById(select[i].id + "_val").value.length == 0 ? value : document.getElementById(select[i].id + "_val").value;
                    }
                    //            queryupdatepart2 += value.replace(/%/g, "%25") + "<|>";
                    queryupdatepart2 += value + "<|>";
                    //}
                }
            }
            if (queryupdatepart1.length > 0) {
                queryupdatepart1 = queryupdatepart1.substr(0, queryupdatepart1.length - 1);
                queryupdatepart2 = queryupdatepart2.substr(0, queryupdatepart2.length - 3);
            }
            var operate = "update";
            querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"" + operate + "\",\"Fields\":\"" + queryupdatepart1 + "\",\"FieldsValues\":\"" + queryupdatepart2 + "\"," +
        "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + irecno + "\",\"FilterFields\":\"" + fieldkeys + "\",\"FilterComOprts\":\"=\",\"FilterValues\":\"" + irecno + "\"}";

            //子表、孙子表
            var jsonchildren = [];
            var children = $("[isson='true']");
            for (var i = 0; i < children.length; i++) {
                var jsonobj = {};
                var tablename = children[i].attributes["tablename"].nodeValue;
                var linkfield = children[i].attributes["linkfield"].nodeValue;
                var fieldkey = children[i].attributes["fieldkey"].nodeValue;
                jsonobj.childtype = "son";
                jsonobj.tablename = tablename;
                jsonobj.linkfield = linkfield;
                jsonobj.fieldkey = fieldkey;
                var data;
                var data = $("#" + children[i].id).datagrid("getRows");
                for (var z = 0; z < data.length; z++) {
                    $("#" + children[i].id).datagrid("endEdit", z);
                }
                //data = $("#" + children[i].id).datagrid("getData").rows;
                //只保存表中的列
                var sqltext = "SELECT Name from SysColumns WHERE id=Object_Id('" + tablename + "')";
                var tablefields = SqlGetDataComm(sqltext);
                for (var ic = 0; ic < data.length; ic++) {
                    for (var key in data[ic]) {
                        var exists = false;
                        for (var j = 0; j < tablefields.length; j++) {
                            if (key == tablefields[j].Name) {
                                exists = true;
                            }
                        }
                        if (exists == false) {
                            delete data[ic][key];
                        }
                    }
                }
                jsonobj.data = data;
                jsonchildren.push(jsonobj);
            }
            //var parms = "mainquery=" + encodeURIComponent(querystr) + "&children=" + encodeURIComponent(JSON.stringify(jsonchildren).replace(/%/g, "%25"));
            $.ajax({
                url: url,
                data: { mainquery: querystr, children: JSON.stringify(jsonchildren) },
                cache: false,
                type: "POST",
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function (data) {
                    $.messager.alert("出错", "与服务器连接失败！");
                }

            });
            //var result = callpostback(url, parms, false, true);
            return result;
        }

        function treeCollapseAll() {
            $('#tt').tree("collapseAll");
            var roots = $("#tt").tree("getRoots");
            for (var i = 0; i < roots.length; i++) {
                $("#tt").tree("expand", roots[i].target);
            }
        }

        function CheckUnique() {
            var iformid = getFieldValue("iFormID");
            var iMenuID = getFieldValue("iMenuID");
            var sqlobj = {
                TableName: "FSysMainMenu",
                Fields: "count(*) as c",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + iformid + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "iMenuID",
                    ComOprt: "<>",
                    Value: "'" + iMenuID + "'"
                }
                ]
            };
            var result = SqlGetData(sqlobj);
            if (result.length > 0) {
                if (parseInt(result[0].c) > 0) {
                    //$.messager.alert("错误", "表单号已存在！");
                    $("#tip1").html("表单号已存在！");
                    setTimeout("hidTip('tip1')", 2000);
                    return false;
                }
                $("#tip1").html("表单号无重复！");
                setTimeout("hidTip('tip1')", 2000);
                return true;
            }
            $("#tip1").html("表单号无重复！");
            setTimeout("hidTip('tip1')", 2000);
            return true;
        }

        function CheckNameUnique() {
            var iformid = getFieldValue("iFormID");
            var iMenuID = getFieldValue("sMenuName");
            var sqlobj = {
                TableName: "FSysMainMenu",
                Fields: "count(*) as c",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + iformid + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "iMenuName",
                    ComOprt: "<>",
                    Value: "'" + iMenuID + "'"
                }
                ]
            };
            var result = SqlGetData(sqlobj);
            if (result.length > 0) {
                if (parseInt(result[0].c) > 0) {
                    //$.messager.alert("错误", "表单号已存在！");
                    $("#tip2").html("菜单名已存在！");
                    setTimeout("hidTip('tip2')", 2000);
                    return false;
                }
                $("#tip2").html("菜单名无重复！");
                setTimeout("hidTip('tip2')", 2000);
                return true;
            }
            $("#tip2").html("菜单名无重复！");
            setTimeout("hidTip('tip2')", 2000);
            return true;
        }
        function hidTip(tipid) {
            $("#" + tipid).html("");
        }

        function iconSelect(obj) {
            var iconCls = obj.iconCls == undefined || obj.iconCls == null || obj.iconCls == "" ? "" : obj.iconCls;
            $("#spanIcon").attr("class", iconCls);
            $("#hidIcon").val(iconCls);
        }
        function openFormUionListCon() {
            var iFormID = $("#ExtTextBox1").val();
            if (iFormID == "") {
                $("#tip2").html("联合报表FormID不能为空！");
                setTimeout("hidTip('tip2')", 2000);
                return;
            };
            //var path = $("#ExtTextBox8").val();
            //if (path != "/Base/FormUnionList.aspx" && path != "Base/FormUnionList.aspx") {
            //    $("#tip2").html("联合报表的路径应为/Base/FormUnionList.aspx");
            //    setTimeout("hidTip('tip2')", 2000);
            //    return;
            //};
            var sqlobj = {
                TableName: "FSysMainMenu",
                Fields: "c=count(*)",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + iFormID + "'"
                }]
            };
            var objData = SqlGetData(sqlobj);
            if (parseInt(objData[0].c) == 0) {
                $("#tip2").html("请先保存！");
                setTimeout("hidTip('tip2')", 2000);
                return;
            }
            if (parseInt(objData[0].c) > 0 && parseInt(objData[0].c) > 1) {
                $("#tip2").html("检测到FormID重复！");
                setTimeout("hidTip('tip2')", 2000);
                return;
            }
            top.turntoTab(iFormID, iFormID, $("#ExtTextBox4").val()+"-设置", "", "/Base/FormConfig/FormUnionCon.aspx?iFormID=" + iFormID + "&");
        }
    </script>
    <style type="text/css">
        .tabmain {
            margin: auto;
            width: 100%;
        }

            .tabmain tr td {
                padding: 3px;
                height: 25px;
            }

                .tabmain tr td input {
                    border-bottom: solid 1px #aaaaaa;
                    height: 17px;
                    border-left-style: none;
                    border-left-color: inherit;
                    border-left-width: medium;
                    border-right-style: none;
                    border-right-color: inherit;
                    border-right-width: medium;
                    border-top-style: none;
                    border-top-color: inherit;
                    border-top-width: medium;
                }

        .style1 {
            color: #FF0000;
        }
    </style>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
        <div data-options="region:'west',title:'系统菜单',split:true" style="width: 200px;">
            <ul id="tt">
            </ul>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north',split:true" style="height: 350px">
                    <div style="height: 35px; line-height: 35px; background-color: #f4f4f4; border-bottom: solid 1px #dddddd;">
                        <a href="javascript:void(0)" id="mb" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
                            onclick="addchild()">新增孩子菜单 </a><a href="javascript:void(0)" id="A1" class="easyui-linkbutton"
                                data-options="iconCls:'icon-remove'" onclick="deletechild()">删除孩子菜单 </a>
                        <a href="javascript:void(0)" id="A2" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                            onclick="save()">保存 </a>
                        <input id="TableName" type="hidden" value="FSysMainMenu" />
                        <input id="FieldKey" type="hidden" value="iMenuID" />
                        <input id="FieldKeyValue" type="hidden" />
                    </div>
                    <div id="divmain">
                        <table class="tabmain">
                            <tr>
                                <td colspan="7" style="text-align: left; font-weight: bolder;">系统菜单
                                <hr />
                                </td>
                            </tr>
                            <tr>
                                <td>FormID:
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iFormID" Z_Required="False"
                                        Z_RequiredTip="FormID不能为空" Z_FieldType="数值" />
                                    <input id="btnCheck" type="button" onclick="CheckUnique()" value="检测" />
                                </td>
                                <td>
                                    <span class="style1" id="tip1"></span>
                                </td>
                                <td>&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                                <td>
                                    <span class="style1" id="tip2"></span>
                                </td>
                                <td rowspan="4">
                                    <table>
                                        <tr>
                                            <td>APP图标：
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <iframe id="ifrIcon" name="ifrIcon" width="200px" frameborder="0" height="120px;"></iframe>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <cc2:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iQueryFirst" />
                                                <label for="ExtCheckbox1">
                                                    先显示查询条件</label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>菜单编号：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox2" runat="server" Style="background-color: #efefef;"
                                        readonly="readonly" Z_FieldID="iMenuID" />
                                    <input id="Button1" style="border-style: none; width: 40px; height: 20px; display: none;"
                                        type="button" value="刷新" onclick="refresh()" />
                                </td>
                                <td>父菜单编号
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iParentMenuId" Z_Required="True"
                                        Z_RequiredTip="父菜单编号不能为空" Z_FieldType="数值" />
                                    <span class="style1">*</span>
                                </td>
                                <td>菜单名称：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sMenuName" />
                                    <input id="Button2" type="button" onclick="CheckNameUnique()" value="检测" />
                                </td>
                            </tr>
                            <tr>
                                <td>录入时间：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox5" runat="server" Style="background-color: #efefef;"
                                        readonly="readonly" Z_FieldID="dinputDate" />
                                </td>
                                <td>顺序号：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iSerial" Z_FieldType="数值" />
                                </td>
                                <td>录入员：
                                </td>
                                <td>
                                    <cc2:ExtTextBox2 ID="ExtTextBox7" runat="server" Style="background-color: #efefef;"
                                        readonly="readonly" Z_FieldID="sUserID" />
                                </td>
                            </tr>
                            <tr>
                                <td>文件路径：
                                </td>
                                <td colspan="3">
                                    <cc2:ExtTextBox2 ID="ExtTextBox8" runat="server" Width="300px" Z_FieldID="sFilePath" />
                                    <cc2:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iIsUnion" />
                                    <label for="ExtCheckbox3">联合报表</label>
                                    <a href="javascript:void(0)" onclick="openFormUionListCon()">联合报表配置</a>                                    
                                </td>
                                <td colspan="2">
                                    <cc2:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iHidden" />
                                    <label for="ExtCheckbox21">
                                        目录中不显示</label>
                                    &nbsp;&nbsp;
                                <cc2:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iFullScreen" />
                                    <label for="ExtCheckbox2">
                                        全屏打开</label>
                                    <cc2:ExtHidden2 ID="hidIcon" Z_FieldID="sIcon" runat="server" />
                                    <span id="spanIcon" style="height: 35px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><a
                                        href="javascript:void(0)" id="A3" class="easyui-menubutton" data-options="menu:'#mm'">选择图标</a>
                                    <div id="mm" style="width: 100px;">
                                        <div data-options="iconCls:''">
                                            空
                                        </div>
                                        <div data-options="iconCls:'icon-barcode'">
                                            条码
                                        </div>
                                        <div data-options="iconCls:'icon-warehouse'">
                                            仓库
                                        </div>
                                        <div data-options="iconCls:'icon-word'">
                                            word
                                        </div>
                                        <div data-options="iconCls:'icon-order'">
                                            订单
                                        </div>
                                        <div data-options="iconCls:'icon-document'">
                                            文档
                                        </div>
                                        <div data-options="iconCls:'icon-finishWork'">
                                            成品
                                        </div>
                                        <div data-options="iconCls:'icon-finance'">
                                            财务
                                        </div>
                                        <div data-options="iconCls:'icon-stock'">
                                            库存
                                        </div>
                                        <div data-options="iconCls:'icon-sale'">
                                            销售
                                        </div>
                                        <div data-options="iconCls:'icon-purchase'">
                                            采购
                                        </div>
                                        <div data-options="iconCls:'icon-basedata'">
                                            基础数据
                                        </div>
                                        <div data-options="iconCls:'icon-system'">
                                            系统
                                        </div>
                                        <div data-options="iconCls:'icon-all'">
                                            全部
                                        </div>
                                        <div data-options="iconCls:'icon-add'">
                                            增加
                                        </div>
                                        <div data-options="iconCls:'icon-edit'">
                                            编辑
                                        </div>
                                        <div data-options="iconCls:'icon-copy'">
                                            复制
                                        </div>
                                        <div data-options="iconCls:'icon-clear'">
                                            清除
                                        </div>
                                        <div data-options="iconCls:'icon-remove'">
                                            删除
                                        </div>
                                        <div data-options="iconCls:'icon-save'">
                                            保存
                                        </div>
                                        <div data-options="iconCls:'icon-cut'">
                                            剪切
                                        </div>
                                        <div data-options="iconCls:'icon-ok'">
                                            OK
                                        </div>
                                        <div data-options="iconCls:'icon-no'">
                                            NO
                                        </div>
                                        <div data-options="iconCls:'icon-import'">
                                            转入
                                        </div>
                                        <div data-options="iconCls:'icon-cancel'">
                                            取消
                                        </div>
                                        <div data-options="iconCls:'icon-reload'">
                                            刷新
                                        </div>
                                        <div data-options="iconCls:'icon-search'">
                                            查询
                                        </div>
                                        <div data-options="iconCls:'icon-print'">
                                            打印
                                        </div>
                                        <div data-options="iconCls:'icon-help'">
                                            帮助
                                        </div>
                                        <div data-options="iconCls:'icon-undo'">
                                            退回
                                        </div>
                                        <div data-options="iconCls:'icon-redo'">
                                            重做
                                        </div>
                                        <div data-options="iconCls:'icon-back'">
                                            后退
                                        </div>
                                        <div data-options="iconCls:'icon-sum'">
                                            汇总
                                        </div>
                                        <div data-options="iconCls:'icon-tip'">
                                            提示
                                        </div>
                                        <div data-options="iconCls:'icon-filter'">
                                            过滤
                                        </div>
                                        <div data-options="iconCls:'icon-man'">
                                            人
                                        </div>
                                        <div data-options="iconCls:'icon-lock'">
                                            锁住
                                        </div>
                                        <div data-options="iconCls:'icon-next'">
                                            下一步
                                        </div>
                                        <div data-options="iconCls:'icon-preview'">
                                            上一步
                                        </div>
                                        <div data-options="iconCls:'icon-todo'">
                                            待办
                                        </div>
                                        <div data-options="iconCls:'icon-remind'">
                                            提醒
                                        </div>
                                        <div data-options="iconCls:'icon-gg'">
                                            公告
                                        </div>
                                        <div data-options="iconCls:'icon-calendar'">
                                            日历
                                        </div>
                                        <div data-options="iconCls:'icon-job'">
                                            记事
                                        </div>
                                        <div data-options="iconCls:'icon-chart'">
                                            图表
                                        </div>
                                        <div data-options="iconCls:'icon-home'">
                                            首页
                                        </div>
                                        <div data-options="iconCls:'icon-associate'">
                                            关联
                                        </div>
                                        <div data-options="iconCls:'icon-export'">
                                            excel
                                        </div>
                                        <div data-options="iconCls:'icon-word'">
                                            word
                                        </div>
                                        <div data-options="iconCls:'icon-default'">
                                            工具
                                        </div>
                                        <div data-options="iconCls:'icon-book'">
                                            书
                                        </div>
                                        <div data-options="iconCls:'icon-list'">
                                            列表
                                        </div>
                                        <div data-options="iconCls:'icon-group'">
                                            分组
                                        </div>
                                    </div>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>打开条件
                                </td>
                                <td colspan="3">
                                    <cc2:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sOpenSql" Style="width: 400px; height: 50px;" />
                                </td>
                                <td>app报表描述sql
                                </td>
                                <td colspan="3">
                                    <cc2:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sAppDescribeSql" Style="width: 400px; height: 50px;" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'center'">
                    <div id="Div1" class="easyui-tabs" data-options="fit:true">
                        <div title="权限列表" data-options="closable:false">
                            <table id="right" isson="true" tablename="FSysMainMenuRight" linkfield="iMenuID=iSystemMenuID"
                                fieldkey="iRecNo">
                            </table>
                        </div>
                        <div title="窗体列表" data-options="closable:false">
                            <table id="form" isson="true" tablename="FSysMainMenuParam" linkfield="iMenuID=iSystemMenuID"
                                fieldkey="iRecNo">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
