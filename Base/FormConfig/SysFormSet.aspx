<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>表单设置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/datagridOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <link href="/Base/JS/kindeditor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/kindeditor/plugins/code/prettify.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/kindeditor/kindeditor.js" type="text/javascript"></script>
    <script src="/Base/JS/kindeditor/lang/zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/kindeditor/plugins/code/prettify.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var selectedDepartName = "";
        var FormData = undefined;
        var iformid = getQueryString("iformid");
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
            error: function () {

            }
        });

        $(function () {
            $("#ifrImport").attr("src", "SysExportTemplate.aspx?iFormID=" + iformid);
            $("#FieldKeyValue").val(iformid);
            try {
                $("#ExtTextBox1").textbox("setValue", iformid);
            }
            catch (e) {
                $("#ExtTextBox1").val(iformid);
            }

            $("#ExtTextBox26").textbox("setValue", 200);

            var sqlObj = {
                TableName: "SysObjects",
                Fields: "Name",
                SelectAll: "True",
                Filters: [
                {
                    Field: "XType",
                    ComOprt: "=",
                    Value: "'U'"
                }
                ],
                Sorts: [{
                    SortName: "Name",
                    SortOrder: "asc"
                }]
            }
            var tableNameArr = SqlGetData(sqlObj);
            $("#ExtTextBox3").combobox(
            {
                valueField: "Name",
                textField: "Name",
                data: tableNameArr,
                editable: true,
                onChange: function (newValue, oldValue) {
                    $("#ExtTextBox4").combobox("loadData", getTableFields(newValue));
                    $("#ExtTextBox5").combobox("loadData", getTableFields(newValue));
                    $("#Text2").combobox("loadData", getTableFields(newValue));
                    $("#Text5").combobox("loadData", getTableFields(newValue));
                    if (isInited == true) {
                        $("#ExtTextBox24").textbox("setValue", newValue);
                    }
                }
            });
            $("#ExtTextBox3").attr("plugin", "combobox");
            $("#ExtTextBox4").combobox({
                valueField: "Name",
                textField: "Name",
                editable: true
            });
            $("#ExtTextBox4").attr("plugin", "combobox");
            $("#ExtTextBox5").combobox({
                valueField: "Name",
                textField: "Name",
                editable: true
            });
            $("#ExtTextBox5").attr("plugin", "combobox");
            $("#ExtTextBox10").combobox(
            {
                valueField: "Name",
                textField: "Name",
                data: tableNameArr,
                editable: true,
                onChange: function (newValue, oldValue) {
                    $("#ExtTextBox12").combobox("loadData", getTableFields(newValue));
                }
            });
            $("#ExtTextBox10").attr("plugin", "combobox");
            $("#ExtTextBox12").combobox({
                valueField: "Name",
                textField: "Name",
                editable: true
            });
            $("#ExtTextBox12").attr("plugin", "combobox");
            var summaryType = [
                {
                    text: "sum"
                },
                {
                    text: "avg"
                },
                {
                    text: "max"
                },
                {
                    text: "min"
                },
                {
                    text: "count"
                }
            ]

            $("#ExtTextBox36").combobox({
                valueField: "text",
                textField: "text",
                editable: true,
                data: summaryType
            });
            $("#ExtTextBox36").attr("plugin", "combobox");

            $("#tableAppro").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    //singleSelect: true,
                    columns: [[
                        { field: "__cb", checkbox: true },
                        { field: "GUID", hidden: true },
                        { field: "iSerial", title: "审批步", width: 40, align: 'center', editor: { type: "numberspinner" } },
                        { field: "sCheckName", title: "审批名称", width: 80, align: 'center', editor: { type: "text" } },
                        { field: "sCheckType", title: "审批类型", width: 80, align: 'center', editor: { type: "combobox", options: { panelHeight: 60, valueField: "text", textField: "text", data: [{ text: "单人审批" }, { text: "会签" }] } } },
                        { field: "sCheckPersonShow", title: "处理人", width: 130, align: 'center', editor: { type: "textbox", options: { buttonText: "...", onClickButton: selectCheckPerson } } },
                        { field: "sCheckPerson", title: "处理人", hidden: true },
                        { field: "sContion", title: "审批条件", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sNextPushInform", title: "推送人", width: 80, align: 'center', editor: { type: "text" } },
                        { field: "iPushSerial", title: "推送<br />节点", width: 40, align: 'center', editor: { type: "numberspinner" } },
                        { field: "iNoPushSerial", title: "不推送<br />节点", width: 40, align: 'center', editor: { type: "numberspinner" } },
                        {
                            field: "iFinish", title: "审批<br />完成", width: 40, align: 'center', formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                            },
                            editor: { type: "checkbox", options: { on: "1", off: "0" } }
                        },
                        { field: "sFinishCondition", title: "审批完成条件", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionAgree", title: "通过执行语句", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionReturn", title: "退回执行语句", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sReturnContion", title: "可退回条件", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionCancel", title: "撤销审批语句", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sBeforeAgree", title: "同意前检测", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sBeforeReturn", title: "退回前检测", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sAbandon", title: "终止语句", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sModifyFields", title: "可编辑字段", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sModifyFields", title: "可编辑字段", width: 170, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        {
                            field: "iSendWeiXinMessage", title: "发送额外<br />微信消息", width: 55, align: 'center',
                            formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                            },
                            editor: { type: "checkbox", options: { on: "1", off: "0" } }
                        },
                        {
                            field: "sWeixinConfig", title: "微信消<br />息设置", width: 50, align: 'center',
                            formatter: function (value, row, index) {
                                return "<a href='#' onclick=WeiXinSetOpen(" + index + ")>设置</a>";
                            },
                        },
                    ]],
                    toolbar: [
                    {
                        text: "增加行",
                        iconCls: 'icon-add',
                        handler: function () {
                            var iSerial = $("#tableAppro").datagrid("getRows").length + 1;
                            $("#tableAppro").datagrid("appendRow", { __hxstate: "add", GUID: NewGuid(), iSerial: iSerial, sUserID: userid, dinputDate: getNowDate() + " " + getNowTime() });
                        }
                    },
                    {
                        text: "删除行",
                        iconCls: 'icon-remove',
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#tableAppro").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        var deleteKey = $("#tableAppro").attr("deleteKey");
                                        if (deleteKey) {
                                            deleteKey += "'" + selectedRows[i].GUID + "',";
                                            $("#tableAppro").attr("deleteKey", deleteKey);
                                        } else {
                                            $("#tableAppro").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                        }

                                        $("#tableAppro").datagrid("deleteRow", $("#tableAppro").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                    ],
                    onClickCell: function (index, row) { datagridOp.cellClick("tableAppro", index, row); },
                    onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tableAppro", index, row); },
                    onBeginEdit: function (index, row) { datagridOp.beginEditor("tableAppro", index, row); },
                    onEndEdit: function (index, row, changes) { datagridOp.endEditor("tableAppro", index, row, changes); },
                    onAfterEdit: function (index, row, changes) { if (row.sCheckPersonShow == "") { $("#tableAppro").datagrid("updateRow", { index: index, row: { sCheckPerson: "" } }); } datagridOp.afterEditor("tableAppro", index, row, changes); }
                }
            );
            var assTypeData = [
                {
                    id: "1", text: "按钮关联"
                }, {
                    id: "2", text: "查询关联"
                }
            ]
            $("#tableAss").datagrid(
            {
                fit: true,
                border: false,
                remoteSort: false,
                //singleSelect: true,
                columns: [[
                        {
                            field: "__cb", checkbox: true, width: 40, align: "center"
                        },
                        {
                            field: "iSerial", title: "序号", width: 50, align: "center", editor: { type: "numberspinner" }
                        },
                        {
                            field: "iType", title: "类别", width: 80, align: "center", editor: {
                                type: "combobox", options:
                                {
                                    valueField: "id", textField: "text", data: assTypeData
                                }
                            },
                            formatter: function (value, row, index) {
                                for (var i = 0; i < assTypeData.length; i++) {
                                    if (assTypeData[i].id == value) {
                                        return assTypeData[i].text;
                                    }
                                }
                            }
                        },
                        { field: "iAssFormID", title: "关联单<br />据FORMID", width: 80, align: "center" },
                        { field: "iMenuID", title: "关联单<br />据菜单ID", width: 80, align: "center" },
                        { field: "sMenuName", title: "关联<br />单据名", width: 120, align: "center", editor: { type: "text" } },
                        { field: "sFilePath", title: "路径", width: 200, align: "center" },
                        { field: "sParamValue", title: "关联参数", width: 170, align: "center", editor: { type: "mytextarea", options: { style: "height:50px;" } } },
                        { field: "sReMark", title: "备注", width: 170, align: "center", editor: { type: "mytextarea", options: { style: "height:50px;" } } },
                        {
                            field: "GUID", hidden: true
                        }
                ]],
                toolbar: [
                    {
                        text: "增加",
                        iconCls: 'icon-add',
                        handler: function () {
                            $("#divForm").window("open");
                        }
                    },
                    {
                        text: "删除行",
                        iconCls: 'icon-remove',
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#tableAss").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        var deleteKey = $("#tableAss").attr("deleteKey");
                                        if (deleteKey) {
                                            deleteKey += "'" + selectedRows[i].GUID + "',";
                                            $("#tableAss").attr("deleteKey", deleteKey);
                                        } else {
                                            $("#tableAss").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                        }
                                        $("#tableAss").datagrid("deleteRow", $("#tableAss").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                ],
                onClickCell: function (index, row) { datagridOp.cellClick("tableAss", index, row); },
                onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tableAss", index, row); },
                onBeginEdit: function (index, row) { datagridOp.beginEditor("tableAss", index, row); },
                onEndEdit: function (index, row, changes) { datagridOp.endEditor("tableAss", index, row, changes); },
                onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("tableAss", index, row, changes); }
            });

            var messageTypeArr = [{ id: "0", text: "站内消息" }, { id: "1", text: "微信消息" }, { id: "2", text: "手机短信" }];
            $("#tableMessage").datagrid(
            {
                fit: true,
                border: false,
                remoteSort: false,
                //singleSelect: true,
                columns: [[
                    { field: "__cb11", checkbox: true, width: 40, align: "center" },
                    { field: "iSerial", title: "序号", width: 40, align: "center", editor: { type: "numberbox" } },
                    {
                        field: "iMessageType", title: "消息类型", width: 100, align: "center",
                        editor: { type: "combobox", options: { valueField: "id", textField: "text", data: messageTypeArr } },
                        formatter: function (value, row, index) {
                            for (var i = 0; i < messageTypeArr.length; i++) {
                                if (value == messageTypeArr[i].id) {
                                    return messageTypeArr[i].text;
                                }
                            }
                        }
                    },
                    { field: "sUserShow", title: "人员", width: 150, align: "center", editor: { type: "textbox", options: { buttonText: "...", onClickButton: selectPerson } } },
                    { field: "sOpenIDSql", title: "人员Sql(OpenID，手机号)", width: 300, align: "center", editor: { type: "textarea" } },
                    { field: "sMessageSql", title: "消息Sql(手机短信)", width: 300, align: "center", editor: { type: "textarea" } },
                    { field: "sUserID", title: "", width: 80, align: "center", hidden: true }
                ]],
                toolbar: [
                    {
                        text: "增加",
                        iconCls: 'icon-add',
                        handler: function () {
                            //selectPerson("message");
                            var allRows = $("#tableMessage").datagrid("getRows");
                            var iSerial = allRows.length + 1;
                            var appRow = { iSerial: iSerial, GUID: NewGuid(), __hxstate: "add", };
                            $("#tableMessage").datagrid("appendRow", appRow);
                        }
                    },
                    {
                        text: "删除行",
                        iconCls: 'icon-remove',
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#tableMessage").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        var deleteKey = $("#tableMessage").attr("deleteKey");
                                        if (deleteKey) {
                                            deleteKey += "'" + selectedRows[i].GUID + "',";
                                            $("#tableMessage").attr("deleteKey", deleteKey);
                                        } else {
                                            $("#tableMessage").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                        }
                                        $("#tableMessage").datagrid("deleteRow", $("#tableMessage").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                ],
                onClickCell: function (index, row) { datagridOp.cellClick("tableMessage", index, row); },
                onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tableMessage", index, row); },
                onBeginEdit: function (index, row) { datagridOp.beginEditor("tableMessage", index, row); },
                onEndEdit: function (index, row, changes) { datagridOp.endEditor("tableMessage", index, row, changes); },
                onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("tableMessage", index, row, changes); }
            });

            //部门
            var sqlobj = {
                TableName: "bscDataClass",
                Fields: "sClassID,sClassName,sParentID",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sType",
                        ComOprt: "=",
                        Value: "'depart'"
                    }
                ]
            }

            $("#Text1").combotree({
                url: "/Base/Handler/getTreeData.ashx?idField=sClassID&textField=sClassName&parentField=sParentID&rootValue=0",
                queryParams: { sqlobj: JSON2.stringify(sqlobj) },
                onSelect: function (node) {
                    selectedDepartName = node.text;
                }
            });
            //角色
            var sqlRoleObj = {
                TableName: "bscDataListD",
                Fields: "sName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID",
                        ComOprt: "=",
                        Value: "'sJobRoleSelect'"
                    }
                ]
            }
            var roleData = SqlGetData(sqlRoleObj);
            $("#Text3").combobox({
                valueField: "sName",
                textField: "sName",
                data: roleData,
                multiple: true
            });
            $("#Text3").attr("plugin", "combobox");
            $("#Text2").combobox({
                valueField: "Name",
                textField: "Name"
            });
            $("#Text2").attr("plugin", "combobox");
            $("#Text4").textbox({
                buttonText: "...",
                onClickButton: function () {
                    selectPerson("check");
                }
            });
            $("#Text4").attr("plugin", "combobox");
            $("#Text5").combobox({
                valueField: "Name",
                textField: "Name"
            });
            $("#Text5").attr("plugin", "combobox");
            var sqlFormObj = {
                TableName: "View_Yww_FSysMainMenu",
                Fields: "iMenuID,sMenuName,sFilePath=case when len(isnull(sParms,''))>0 then sFilePath+'?'+substring(isnull(sParms,''),6,len(sParms)-5)+'&' else sFilePath+'?' end,iFormID",
                SelectAll: "True"
            }
            FormData = SqlGetData(sqlFormObj);

            $("#tabForm").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                data: FormData,
                toolbar: "#divTabFormTb",
                columns: [[
                    { field: "__cb", checkbox: true },
                    { field: "iMenuID", title: "菜单ID" },
                    { field: "sMenuName", title: "单据名称" },
                    { field: "sFilePath", title: "路径", width: 250 },
                    { field: "iFormID", title: "FORMID" }
                ]]
            });

            $("#divSelectCheckPerson").window("close");
            $("#divPerson").window("close");
            $("#divForm").window("close");

            loadData();

            $("#TabWeiXinTemplet").datagrid(
            {
                fit: true,
                border: false,
                rownumbers: true,
                singleSelect: true,
                columns:
                [
                    [
                        {
                            title: "查看样式", width: 70, field: "__aa", formatter: function (value, row, index) {
                                return "<a href='javascript:void(0)' onclick='view(" + index + ")'>查看样式</a>";
                            }
                        },
                        { title: "模板ID", field: "template_id", width: 150 },
                        { title: "模板标题", field: "title", width: 100 },
                        { title: "一级行业", field: "primary_industry", width: 100 },
                        { title: "二级行业", field: "deputy_industry", width: 100 },
                        { title: "模板内容", field: "content", width: 400 },
                        { title: "模板示例", field: "example", width: 400 }

                    ]
                ],
                remoteSort: false,
                onDblClickRow: function (index, row) {
                    $("#" + weixinTempletTarget).textbox("setValue", row.template_id);
                    $("#divTemplet").dialog("close");
                }
            }
            );

            $("#ExtTextBox37").textbox({
                buttonText: "...",
                onClickButton: function () {
                    weixinTempletTarget = "ExtTextBox37";
                    openTempletWindow();
                }
            })
            $("#ExtTextBox40").textbox({
                buttonText: "...",
                onClickButton: function () {
                    weixinTempletTarget = "ExtTextBox40";
                    openTempletWindow();
                }
            })

            var dataWhenSend = [{
                v: 0, t: "通过时"
            }, {
                v: 1, t: "退回发"
            }, {
                v: 2, t: "撤销时"
            }, {
                v: 3, t: "都发"
            }];
            $("#ExtTextBox38").combobox({
                valueField: "v", textField: "t", data: dataWhenSend,
                panelHeight: 100
            });
            $("#ExtTextBox38").combobox("setValue", 0);

            $("#ExtTextBox39").combobox({
                valueField: "v", textField: "t", data: dataWhenSend,
                panelHeight: 100
            });
            $("#ExtTextBox39").combobox("setValue", 0);

            $("#tabWeixinMore").datagrid({
                fit: true,
                border: false,
                singleSelect:true,
                columns: [
                    [
                        { field: 'iSerial', title: '序号', width: 40, align: 'center' },
                        {
                            field: 'iWeiXinWhenSend', title: '何时发', width: 100, align: 'center',
                            formatter: function (value, row, index) {
                                for (var i = 0; i < dataWhenSend.length; i++) {
                                    if (value == dataWhenSend[i].v) {
                                        return dataWhenSend[i].t;
                                    }
                                }
                            }
                        },
                        { field: 'sSendWeiXinCondition', title: '发送条件', width: 100, align: 'center' },
                        { field: 'sWeiXinTemplet', title: '模板', width: 100, align: 'center' },
                        { field: 'sSendWeiXinOpenID', title: 'OpenID', width: 100, align: 'center' },
                        { field: 'sWeiXinFirstData', title: 'FirstData', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData1', title: 'KeyData1', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData2', title: 'KeyData2', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData3', title: 'KeyData3', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData4', title: 'KeyData4', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData5', title: 'KeyData5', width: 100, align: 'center' },
                        { field: 'sWeiXinKeyData6', title: 'KeyData6', width: 100, align: 'center' },
                        { field: 'sWeiXinRemarkData', title: 'RemarkData', width: 100, align: 'center' },
                        { field: 'sWeiXinUrl', title: '链接', width: 100, align: 'center' },
                        { field: 'iRecNo', hidden: true },
                        { field: 'sGUID', hidden: true },
                    ]
                ],
                onClickRow: function (index, row) {
                    weixinMoreUseType = "modify";
                    $("#formWeixinMore").form("load", row);
                },
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text:'增加',
                        handler: function () {
                            $("#formWeixinMore").form("clear");
                            var nextID = getChildID("bscDataBillDWeixinD");
                            var allRows = $("#tabWeixinMore").datagrid("getRows");
                            var theRow = $("#tableAppro").datagrid("getRows")[currentWeiXinIndex];
                            var guid = theRow.GUID;
                            $("#formWeixinMore").form("load", { iSerial: allRows.length + 1, sGUID: guid, iRecNo: nextID });
                            weixinMoreUseType = "add";
                        }
                    }, '-', {
                        iconCls: 'icon-remove',
                        text: '删除',
                        handler: function () {
                            var selectedRow = $("#tabWeixinMore").datagrid("getSelected");
                            if (selectedRow) {
                                $.messager.confirm("确认删除吗？", "确认删除吗？", function (r) {
                                    if (r) {
                                        $.ajax({
                                            url: "/Base/Handler/DataOperatorForSys.ashx",
                                            async: false,
                                            cache: false,
                                            data: { from: "sysBscDataBillDWeixinDDelete", iRecNo: selectedRow.iRecNo },
                                            success: function (data) {
                                                if (data == "1") {
                                                    var selectedRow = $("#tabWeixinMore").datagrid("getSelected");
                                                    var theIndexRow = $("#tabWeixinMore").datagrid("getRowIndex", selectedRow);
                                                    $("#tabWeixinMore").datagrid("deleteRow", theIndexRow);
                                                } else {
                                                    alert(data.substr(6));
                                                }
                                            }
                                        })
                                    }
                                })
                                
                            }
                        }
                    }
                ]
            });
        })
        var isInited = false;
        var weixinTempletTarget = undefined;
        function loadData() {
            iformid = getQueryString("iformid");
            //主表
            var sqlFormObj = {
                TableName: "bscDataBill",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + iformid + "'"
                    }
                ]
            }

            var FormOriData = SqlGetData(sqlFormObj);
            if (FormOriData.length > 0) {
                FormOriData[0].iQuery = FormOriData[0].iQuery == "1" ? "on" : "";
                FormOriData[0].iHasTree = FormOriData[0].iHasTree == "1" ? "on" : "";
                FormOriData[0].iStore = FormOriData[0].iStore == "1" ? "on" : "";
                FormOriData[0].iModifyNotCheck = FormOriData[0].iModifyNotCheck == "1" ? "on" : "";
                FormOriData[0].iDeleteNotCheck = FormOriData[0].iDeleteNotCheck == "1" ? "on" : "";
                FormOriData[0].iModify = FormOriData[0].iModify == "1" ? "on" : "";
                FormOriData[0].iIsTreeList = FormOriData[0].iIsTreeList == "1" ? "on" : "";
                FormOriData[0].iTreeCollapse = FormOriData[0].iTreeCollapse == "1" ? "on" : "";
                FormOriData[0].iDynColumnSummary = FormOriData[0].iDynColumnSummary == "1" ? "on" : "";
                try {
                    FormOriData[0].iAllowOtherCancel = FormOriData[0].iAllowOtherCancel == "1" ? "on" : "";
                } catch (e) {

                }
                if (FormOriData[0].iQuery == "on") {
                    $("#ExtCheckbox1")[0].checked = true;
                    storeswitch();
                }
                $("#form1").form("load", FormOriData[0]);
            }
            else {
                var sqlMenuObj = {
                    TableName: "FSysMainMenu",
                    Fields: "sMenuName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iFormID",
                            ComOprt: "=",
                            Value: "'" + iformid + "'"
                        }
                    ]
                }
                var menuInfo = SqlGetData(sqlMenuObj);
                if (menuInfo.length > 0) {
                    $("#ExtTextBox9").textbox("setValue", menuInfo[0].sMenuName);
                }
                $("#ExtTextBox4").combobox("setValue", "iRecNo");
            }
            isInited = true;
            //审批流
            var sqlFormCheckObj = {
                TableName: "bscDataBillD",
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
                    SortName: "dinputDate",
                    SortOrder: "asc"
                }
                ]
            }
            var formCheckData = SqlGetData(sqlFormCheckObj);
            if (formCheckData.length) {
                $("#tableAppro").datagrid("loadData", formCheckData);
            }
            //关联
            var sqlAssObj = {
                TableName: "VwbscDataBillDForm",
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
            var assData = SqlGetData(sqlAssObj);
            if (assData.length > 0) {
                $("#tableAss").datagrid("loadData", assData);
            }
            //人员
            var sqlPersonObj = {
                TableName: "bscDataBillDUser",
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
            var personData = SqlGetData(sqlPersonObj);
            if (personData.length > 0) {
                $("#tableMessage").datagrid("loadData", personData);
            }
        }

        function getTableFields(tableName) {
            var sqlObj = {
                TableName: "SysColumns",
                Fields: "Name",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "id",
                        ComOprt: "=",
                        Value: "Object_Id('" + tableName + "')"
                    }
                ]
            }
            var fields = SqlGetData(sqlObj);
            return fields;
        }
        function storeswitch() {
            var obj = document.getElementById("ExtCheckbox1");
            if (obj.checked == true) {
                document.getElementById("ExtCheckbox4").disabled = false;
                document.getElementById("divform").style.display = "none";
                document.getElementById("divquery").style.display = "block";
                document.getElementById("ExtTextArea2").removeAttribute("FieldID");
                document.getElementById("ExtTextArea2").removeAttribute("name");
                document.getElementById("ExtTextArea7").setAttribute("FieldID", "sShowSql");
                document.getElementById("ExtTextArea7").setAttribute("name", "sShowSql");

                document.getElementById("ExtTextArea6").removeAttribute("FieldID");
                document.getElementById("ExtTextArea6").removeAttribute("name");
                document.getElementById("ExtTextArea18").setAttribute("FieldID", "sOpenFilters");
                document.getElementById("ExtTextArea18").setAttribute("name", "sOpenFilters");
            }
            else {
                document.getElementById("ExtCheckbox4").checked = false;
                document.getElementById("ExtCheckbox4").disabled = true;
                var divform = document.getElementById("divform");
                var divquery = document.getElementById("divquery");
                divform.style.display = "block";
                divquery.style.display = "none";
                document.getElementById("ExtTextArea2").setAttribute("FieldID", "sShowSql");
                document.getElementById("ExtTextArea7").removeAttribute("FieldID");
                document.getElementById("ExtTextArea2").setAttribute("name", "sShowSql");
                document.getElementById("ExtTextArea7").removeAttribute("name");

                document.getElementById("ExtTextArea18").removeAttribute("FieldID");
                document.getElementById("ExtTextArea18").removeAttribute("name");
                document.getElementById("ExtTextArea6").setAttribute("FieldID", "sOpenFilters");
                document.getElementById("ExtTextArea6").setAttribute("name", "sOpenFilters");
            }
        }

        function selectCheckPerson() {
            $("#divSelectCheckPerson").window("open");
            var content = $("#tableAppro").datagrid("getRows")[datagridOp.currentRowIndex].sCheckPerson;
            if (content) {
                var otype = content.split(";")[0];
                var sp = content.split(";")[1];;
                var sindex;
                var svalue;
                if (parseInt(otype) < 3) {
                    sindex = sp.split(":")[0];
                    svalue = sp.split(":")[1];
                }
                else {
                    svalue = content.substr(content.indexOf(";") + 1, content.length - content.indexOf(";") - 1);;
                }
                switch (otype) {
                    case "0":
                        {
                            document.getElementById("Radio1").checked = true;
                            if (sindex == "0") {
                                $("#Text1").combotree("setValue", svalue);
                            }
                            else if (sindex == "1") {
                                document.getElementById("Text2").value = svalue;
                            }
                        } break;
                    case "1":
                        {
                            document.getElementById("Radio2").checked = true;
                            if (sindex == "0") {
                                var svalueArr = svalue.split(',');
                                $("#Text3").combobox("setValue", svalueArr);
                            }
                        } break;
                    case "2":
                        {
                            document.getElementById("Radio3").checked = true;
                            if (sindex == "0") {
                                //popup.setValue(svalue);
                                var sqlPersonObj = {
                                    TableName: "bscDataPerson",
                                    Fields: "sName",
                                    SelectAll: "True",
                                    Filters: [
                                        {
                                            Field: "sCode",
                                            ComOprt: "=",
                                            Value: "'" + svalue + "'"
                                        }
                                    ]
                                }
                                var personData = SqlGetData(sqlPersonObj);
                                if (personData.length > 0) {
                                    $("#Text4").textbox("setValue", personData[0].sName);
                                }
                                $("#Text4_val").val(svalue);

                            }
                            else if (sindex == "1") {
                                //document.getElementById("Text5").value = svalue;
                                $("#Text5").combobox("setValue", svalue);
                            }
                        } break;
                    case "3":
                        {
                            document.getElementById("Radio4").checked = true;
                            document.getElementById("TextArea4").value = svalue;
                        }
                }
            }

        }

        function checkPersonConfirm() {
            var returnvalue = "";
            var showStr = "";
            var radios = document.getElementsByName("type");
            for (var i = 0; i < radios.length; i++) {
                if (radios[i].checked == true) {
                    returnvalue += radios[i].value + ";";
                    if (radios[i].value == "0") {
                        showStr += "部门主管：";
                        var departID = $("#Text1").combotree("getValue");
                        if (departID) {
                            returnvalue += "0:" + departID;
                            showStr += selectedDepartName;
                            break;
                        }
                        else if (document.getElementById("Text2").value.length > 0) {
                            returnvalue += "1:" + document.getElementById("Text2").value;
                            showStr += "表单域[" + document.getElementById("Text2").value + "]";
                        }
                    }
                    else if (radios[i].value == "1") {
                        showStr += "角色：";
                        var role = $("#Text3").combobox("getValues");
                        if (role) {
                            returnvalue += "0:" + role;
                            showStr += role.toString();
                            break;
                        }
                    }
                    else if (radios[i].value == "2") {
                        showStr += "人员：";
                        var person = $("#Text4").textbox("getValue");
                        if (person != "") {
                            returnvalue += "0:" + $("#Text4_val").val();
                            showStr += person;
                            break;
                        }
                        else {
                            var comValue = $("#Text5").combobox("getValue");
                            if (comValue != "") {
                                returnvalue += "1:" + comValue;
                                showStr += "表单域[" + comValue + "]";
                                break;
                            }
                        }
                    }
                    else if (radios[i].value == "3") {
                        showStr += "自定义:";
                        returnvalue += document.getElementById("TextArea4").value;
                        showStr += document.getElementById("TextArea4").value;
                        break;
                    }
                }
            }
            $("#divSelectCheckPerson").window("close");
            $("#tableAppro").datagrid("updateRow", {
                index: datagridOp.currentRowIndex,
                row: {
                    sCheckPerson: returnvalue,
                    sCheckPersonShow: showStr
                }
            });
        }

        var messageRowIndex = undefined;
        function selectPerson(type) {
            messageRowIndex = datagridOp.currentRowIndex;
            var returnFn = type == "check" ? "selectPersonToCheck" : "selectPersonToMessage";
            var multi = 0;
            var url = "/Base/FormList.aspx?FormID=5031&MenuID=41&popup=1&multi=" + multi + "&returnFn=" + returnFn;
            var sheight = screen.height;
            var swidth = screen.width - 10;
            var iWidth = swidth + "px";
            var iHeight = screen.height + "px";
            window.open(url, "dataForm", "width=" + iWidth + ", height=" + iHeight + ",top=0,left=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
        }

        function selectPersonToCheck(data) {
            $("#Text4").textbox("setValue", data[0].sName);
            $("#Text4_val").val(data[0].sCode);
        }
        function selectPersonToMessage(data) {
            for (var i = 0; i < data.length; i++) {
                //var allRows = $("#tableMessage").datagrid("getRows");
                //data[i].sUserID = "2;0:" + data[i].sCode;
                //data[i].sUserShow = "人员：" + data[i].sName;
                //data[i].dInputDate = getNowDate() + " " + getNowTime();
                var uRow = { sUserID: "2;0:" + data[i].sCode, sUserShow: "人员：" + data[i].sName, dInputDate: getNowDate() + " " + getNowTime() };
                //data[i].iSerial = allRows.length;
                $("#tableMessage").datagrid("updateRow", { index: messageRowIndex, row: uRow });
            }
        }

        function formSearch() {
            var txtFormID = $("#Text6").textbox("getValue");
            var txtFormName = $("#Text7").textbox("getValue");
            var dataP = [];
            var data = FormData;
            if (txtFormID == "" && txtFormName == "") {
                $("#tabForm").datagrid("loadData", FormData);
                return false;
            }
            for (var i = 0; i < data.length; i++) {
                if (txtFormID != "" && txtFormName != "") {
                    if (data[i].iFormID.indexOf(txtFormID) > -1 && data[i].sMenuName.indexOf(txtFormID) > -1) {
                        dataP.push(data[i]);
                    }
                }
                if (txtFormID != "" && txtFormName == "") {
                    if (data[i].iFormID.indexOf(txtFormID) > -1) {
                        dataP.push(data[i]);
                    }
                }
                if (txtFormID == "" && txtFormName != "") {
                    if (data[i].sMenuName.indexOf(txtFormName) > -1) {
                        dataP.push(data[i]);
                    }
                }

            }
            $("#tabForm").datagrid("loadData", dataP);
        }

        function formSelect() {
            var selectedRow = $("#tabForm").datagrid("getChecked");
            if (selectedRow.length > 0) {
                for (var i = 0; i < selectedRow.length; i++) {
                    //if (selectedRow[i].sFilePath == "" || selectedRow[i].sFilePath == undefined || selectedRow[i].sFilePath == null) {
                    //    $.messager.alert("请选择表单", "第" + i.toString() + "行，请选择表单非目录！");
                    //    return false;
                    //}
                    selectedRow[i].iAssFormID = selectedRow[i].iFormID;
                    var allRows = $("#tableAss").datagrid("getRows");
                    selectedRow[i].iSerial = allRows.length + 1;
                    selectedRow[i].sUserID = userid;
                    selectedRow[i].dInputDate = getNowDate() + " " + getNowTime();
                    selectedRow[i].GUID = NewGuid();
                    selectedRow[i].iType = 1;
                    selectedRow[i].__hxstate = "add";
                    $("#tableAss").datagrid("appendRow", selectedRow[i]);
                }
                $("#divForm").window("close");
            }
        }

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

        function save() {
            editor.sync();

            var sqlFormObj = {
                TableName: "bscDataBill",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + iformid + "'"
                    }
                ]
            }
            var FormOriData = SqlGetData(sqlFormObj);

            if (FormOriData.length > 0) {
                var formid = Form.__update(iformid, "/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (formid.indexOf("error:") > -1) {
                    $.messager.alert("失败", formid.substr(6, formid.length - 6));
                }
                else {
                    $.messager.alert("保存成功", "保存成功");
                }
            }
            else {
                var formid = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (formid.indexOf("error:") > -1) {
                    $.messager.alert("失败", formid.substr(6, formid.length - 6));
                }
                else {
                    $.messager.alert("保存成功", "保存成功");
                }
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


        function downLoadTemplet() {
            $.messager.progress({ title: "正在下载中。。。" });
            $.ajax(
                {
                    url: "/Base/Handler/PublicHandler.ashx",
                    type: "get",
                    cache: false,
                    async: true,
                    data: { otype: "GetWeiXinAllTemplet" },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.messager.alert("错误", textStatus);
                        $.messager.progress("close");
                    },
                    success: function (data, textStatus) {
                        $.messager.show({
                            title: 'OK!',
                            msg: "下载成功!",
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        $.messager.progress("close");
                    }
                });
        }
        function openTempletWindow() {
            var sqlObj = {
                TableName: "WeiXinTemplet",
                Fields: "*",
                SelectAll: "True",
                Sorts: [
                    {
                        SortName: "title",
                        SortOrder: "asc"
                    }
                ]
            }
            var data = SqlGetData(sqlObj);
            $("#TabWeiXinTemplet").datagrid("loadData", data);
            $("#divTemplet").dialog("open");
        }
        function view(index) {
            var allRows = $("#TabWeiXinTemplet").datagrid("getRows");
            var example = allRows[index].example.replace(/\n/g, "<br />");
            $("#pview").html(example);
            $("#divView").dialog("open");
        }
        var currentWeiXinIndex = undefined;
        function WeiXinSetOpen(index) {
            currentWeiXinIndex = index;
            var theRow = $("#tableAppro").datagrid("getRows")[index];
            $("#ExtTextBox37").textbox("setValue", theRow.sWeiXinTemplet);
            $("#ExtTextArea19").val(theRow.sSendWeiXinOpenID);
            $("#ExtTextArea20").val(theRow.sWeiXinFirstData);
            $("#ExtTextArea21").val(theRow.sWeiXinKeyData1);
            $("#ExtTextArea22").val(theRow.sWeiXinKeyData2);
            $("#ExtTextArea23").val(theRow.sWeiXinKeyData3);
            $("#ExtTextArea24").val(theRow.sWeiXinKeyData4);
            $("#ExtTextArea25").val(theRow.sWeiXinKeyData5);
            $("#ExtTextArea26").val(theRow.sWeiXinKeyData6);
            $("#ExtTextArea27").val(theRow.sWeiXinRemarkData);
            $("#ExtTextArea28").val(theRow.sSendWeiXinCondition);
            $("#ExtTextArea29").val(theRow.sWeiXinUrl);
            var iWeiXinWhenSend = theRow.iWeiXinWhenSend == "" || theRow.iWeiXinWhenSend == 0 || theRow.iWeiXinWhenSend == null ? 0 : theRow.iWeiXinWhenSend;
            $("#ExtTextBox38").combobox("setValue", iWeiXinWhenSend);
            //$("#form2").form("load", theRow);
            $("#divWeiXinConfig").dialog("open");
        }
        function WeixinConfigConfirm() {
            var isRight = true;
            $(".toolTipValueAndSql").each(function (index, o) {
                var value = $(this).val();
                if (value.toUpperCase().indexOf("SELECT") > -1) {
                    if (value.toUpperCase().indexOf("SQL:") == -1) {
                        alert("如果是sql语句，请以sql:开头");
                        isRight = false;
                        return false;
                    }
                }
            });
            if (isRight == false) {
                return;
            }
            var iWeiXinWhenSend = $("#ExtTextBox38").combobox("getValue");
            $("#tableAppro").datagrid("updateRow", {
                index: currentWeiXinIndex,
                row: {
                    sWeiXinTemplet: $("#ExtTextBox37").textbox("getValue"),
                    sSendWeiXinOpenID: $("#ExtTextArea19").val(),
                    sWeiXinFirstData: $("#ExtTextArea20").val(),
                    sWeiXinKeyData1: $("#ExtTextArea21").val(),
                    sWeiXinKeyData2: $("#ExtTextArea22").val(),
                    sWeiXinKeyData3: $("#ExtTextArea23").val(),
                    sWeiXinKeyData4: $("#ExtTextArea24").val(),
                    sWeiXinKeyData5: $("#ExtTextArea25").val(),
                    sWeiXinKeyData6: $("#ExtTextArea26").val(),
                    sWeiXinRemarkData: $("#ExtTextArea27").val(),
                    sSendWeiXinCondition: $("#ExtTextArea28").val(),
                    iWeiXinWhenSend: iWeiXinWhenSend
                }
            });
            $("#divWeiXinConfig").dialog("close");
        }
        var weixinMoreUseType = undefined;
        function showMoreWeixin(currentWeiXinIndex) {
            var theRow = $("#tableAppro").datagrid("getRows")[currentWeiXinIndex];
            loadWeixinMore();
            $("#divWeixinMore").dialog("open");
            $("#divWeixinMore").dialog("maximize");
            weixinMoreUseType = undefined;
        }
        function loadWeixinMore() {
            var theRow = $("#tableAppro").datagrid("getRows")[currentWeiXinIndex];
            var sqlObjWeixinMore = {
                TableName: "bscDataBillDWeixinD", Fields: "*", SelectAll: "True",
                Filters: [
                    {
                        Field: "sGUID", ComOprt: "=", Value: "'" + theRow.GUID + "'"
                    }
                ]
            }
            var resultWeixinMore = SqlGetData(sqlObjWeixinMore);
            $("#tabWeixinMore").datagrid("loadData", resultWeixinMore);
        }
        function saveWeixinMore() {
            if (weixinMoreUseType) {
                var formData = $("#formWeixinMore").serializeObject();
                $.ajax({
                    url: "/Base/Handler/DataOperatorForSys.ashx",
                    async: false,
                    cache: false,
                    data: { from: "sysBscDataBillDWeixinDAddOrModify", formData: JSON.stringify(formData), useType: weixinMoreUseType },
                    success: function (data) {
                        if (data == "1") {
                            if (weixinMoreUseType == "add") {
                                $("#tabWeixinMore").datagrid("appendRow", formData);
                            } else {
                                var selectedRow = $("#tabWeixinMore").datagrid("getSelected");
                                var theIndexRow = $("#tabWeixinMore").datagrid("getRowIndex", selectedRow);
                                $("#tabWeixinMore").datagrid("updateRow", { index: theIndexRow, row: formData });
                            }
                        } else {
                            alert(data.substr(6));
                        }
                    }
                })
            }

        }
        $.fn.serializeObject = function () {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function () {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        }
    </script>
    <style type="text/css">
        body {
            font-size: 12px;
            font-family: Verdana;
        }

        .tabmain {
            margin-left: 10px;
            border-spacing: 5px;
        }

            .tabmain tr td {
                padding: 1px;
                height: 20px;
                text-align: left;
            }

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
            height: 18px;
            border-radius: 5px;
        }

        .txbrequired {
            background-color: #fff3f3;
            border: solid 1px #ffa8a8;
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <form id="form1" runat="server" method="post">
        <div data-options="region:'north',border:true" style="height: 30px; padding-left: 10px; background-color: #efefef;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
        </div>
        <div data-options="region:'center',border:false">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div title="表单信息">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div title="基本信息">
                            <input id="TableName" type="hidden" value="bscDataBill" />
                            <input id="FieldKey" type="hidden" value="iFormID" />
                            <input id="FieldKeyValue" type='hidden' />
                            <input id="UserID" type="hidden" />
                            <div id="divpublic">
                                <table class="tabmain">
                                    <tr>
                                        <td>FormID
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iFormID" Z_readOnly="True" />
                                            <%--<input id="Text2" name="iFormID" fieldid="iFormID" fieldtype="int" class="inputtxb" type="text" />--%>
                                        </td>
                                        <td>
                                            <%--<input id="Checkbox8" type="checkbox" name="iQuery" fieldid="iQuery" onclick="storeswitch(this)" /><label
                                    for="Checkbox8">是否通用查询</label>--%>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iQuery" onclick="storeswitch(this)" />
                                            <label for="ExtCheckbox1">
                                                是否通用查询</label>
                                        </td>
                                        <td>动态列位置
                                        </td>
                                        <td>
                                            <%--<input id="Text41" name="iDynColumnIndex" fieldid="iDynColumnIndex" fieldtype="int" class="inputtxb" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iDynColumnIndex" Z_FieldType="整数" Style="width: 50px;" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox9" runat="server" Z_FieldID="iDynColumnSummary" />
                                            <label for="ExtCheckbox9">
                                                动态列合计</label>
                                        </td>
                                        <td>合计方式
                                        </td>
                                        <td>
                                            <%--<input id="Text41" name="iDynColumnIndex" fieldid="iDynColumnIndex" fieldtype="int" class="inputtxb" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="sDynColumnSummaryType" Style="width: 70px;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div id="divform">
                                <table class="tabmain">
                                    <tr>
                                        <td>表名
                                        </td>
                                        <td>
                                            <%--<div id="divs1" fieldid="sTableName">
                                </div>--%>
                                            <%--<input id="Text1" name="sTableName" fieldid="sTableName" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTableName" />
                                        </td>
                                        <td>主键
                                        </td>
                                        <td>
                                            <%--<div id="divs3" fieldid="sFieldKey">
                                </div>--%>
                                            <%--<input id="Text3" name="sFieldKey" fieldid="sFieldKey" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sFieldKey" />
                                        </td>
                                        <td>主键表名
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox24" Z_FieldID="sSerialTableName" runat="server" />
                                        </td>
                                        <td>单据名称
                                        </td>
                                        <td>
                                            <%--&nbsp;<input id="Text8" fieldid="sBillType" fieldtype="char" class="inputtxb" type="text"
                                    style="width: 120px" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sBillType" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>自动编号字段
                                        </td>
                                        <td>
                                            <%--<div id="divs4" fieldid="sFieldName">
                                </div>--%>
                                            <%--<input id="Text4" name="sFieldName" fieldid="sFieldName" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sFieldName" />
                                        </td>
                                        <td>日期格式
                                        </td>
                                        <td>
                                            <%--<select id="Select6" name="sDateType" fieldid="sDateType" fieldtype="char" style="width: 100px;">
                                    <option selected="selected" value=""></option>
                                    <option value="YY">YY</option>
                                    <option value="YY-">YY-</option>
                                    <option value="YYMMDD">YYMMDD</option>
                                    <option value="YYMM">YYMM</option>
                                    <option value="YYMM-">YYMM-</option>
                                    <option value="YYYYMM">YYYYMM</option>
                                    <option value="YYYYMM-">YYYYMM-</option>
                                    <option value="YYYYMMDD">YYYYMMDD</option>
                                </select>--%>
                                            <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sDateType" Z_Options="YY;YYYY;YY-;YYMMDD;YYMM;YYMM-;YYYYMM;YYYYMM-;YYYYMMDD" />
                                        </td>
                                        <td>前缀
                                        </td>
                                        <td>
                                            <%--<input id="Text5" name="sPrefix" fieldid="sPrefix" fieldtype="char" class="inputtxb" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sPrefix" />
                                        </td>
                                        <td>序号格式
                                        </td>
                                        <td>
                                            <%--<input id="Text6" name="sSerialType" fieldid="sSerialType" fieldtype="char" class="inputtxb" type="text" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sSerialType" />
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>
                                            <%--<input id="Text12" name="pPageCount" fieldid="pPageCount" fieldtype="int" required="true" requiredtip="每页显示行数不能为空"
                                    class="inputtxb" style="width: 120px" type="text" value="30" />--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>明细表
                                        </td>
                                        <td>
                                            <%--<div id="divs2" fieldid="sDetailTableName">
                                </div>--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sDetailTableName" />
                                        </td>
                                        <td>关联字段
                                        </td>
                                        <td>
                                            <%--<input id="Text10" type="text" fieldid="sLinkField" fieldtype="char" title="主表在前,例如:iRecNo=iMainRecno"
                                    value="iRecNo=iMainRecNo" class="inputtxb" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" title="主表在前,例如:iRecNo=iMainRecno"
                                                Z_FieldID="sLinkField" value="iRecNo=iMainRecNo" />
                                        </td>
                                        <td>子表主键
                                        </td>
                                        <td>
                                            <%--<div id="divs5" fieldid="sDeitailFieldKey">
                                </div>--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sDeitailFieldKey" />
                                        </td>
                                        <td>每页显示行数
                                        </td>
                                        <td>
                                            <%--<textarea id="TextArea14" fieldid="sNoCopyFields" class="textarea"></textarea>--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="pPageCount" Z_FieldType="整数"
                                                Z_Value="30" Z_decimalDigits="0" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>操作界面Url
                                        </td>
                                        <td colspan="3">
                                            <%--<input id="Text11" type="text" fieldid="sDetailPage" fieldtype="char" class="inputtxb"
                                    style="width: 321px" />--%>
                                            <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sDetailPage" Style="width: 321px" />
                                        </td>
                                        <td colspan="4">
                                            <%--宽度<input id="Text15" style="width: 60px" type="text" class="inputtxb" fieldid="iDetailWidth"
                                    required="true" requiredtip="高度不能为空" fieldtype="char" value="800" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                高度<input id="Text16" style="width: 60px" type="text" class="inputtxb" fieldid="iDetailHeight"
                                    required="true" requiredtip="宽度不能为空" fieldtype="char" value="600" />--%>
                                        宽度<cc1:ExtTextBox2 ID="ExtTextBox14" Style="width: 60px" runat="server" Z_FieldID="iDetailWidth"
                                            Z_Value="-1" />
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 高度<cc1:ExtTextBox2 ID="ExtTextBox15"
                                                Style="width: 60px" runat="server" Z_FieldID="iDetailHeight" Z_Value="-1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>主表SQL
                                        </td>
                                        <td colspan="5">
                                            <%--<textarea id="TextArea1" fieldid="sShowSql" fieldtype="char" class="textarea" style="width: 547px"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Style="width: 547px; height: 100px;"
                                                Z_FieldID="sShowSql" />
                                        </td>
                                        <td>主表排序
                                        </td>
                                        <td>
                                            <%--<textarea id="TextArea8" fieldid="sMainOrder" fieldtype="char" class="textarea" style="height: 100px;
                                    width: 120px" name="S4" rows="1" cols="20"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sMainOrder" Style="height: 100px; width: 120px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>明细表SQL
                                        </td>
                                        <td colspan="5">
                                            <%--<textarea id="TextArea5" fieldid="sDetailSql" fieldtype="char" class="textarea" name="S2"
                                    rows="1" style="width: 543px;"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea4" runat="server" Z_FieldID="sDetailSql" Style="width: 543px; height: 100px;" />
                                        </td>
                                        <td>子表排序
                                        </td>
                                        <td>
                                            <%--<textarea id="TextArea9" fieldid="sChildOrder" fieldtype="char" class="textarea"
                                    style="height: 100px; width: 120px" cols="20" name="S5" rows="1"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea5" runat="server" Z_FieldID="sChildOrder" Style="height: 100px; width: 120px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>主表打开条件
                                        </td>
                                        <td colspan="3">
                                            <%--<textarea id="TextArea3" fieldid="sOpenFilters" fieldtype="char" class="textarea"
                                    name="S2" rows="1" style="width: 300px;"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea6" runat="server" Style="width: 300px; height: 100px;"
                                                Z_FieldID="sOpenFilters" />
                                        </td>
                                        <td colspan="4">
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iModifyNotCheck" />
                                            <label for="ExtCheckbox2">修改不判断状态</label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iDeleteNotCheck" />
                                            <label for="ExtCheckbox3">删除不判断状态</label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox10" runat="server" Z_FieldID="iAllowOtherCancel" />
                                            <label for="ExtCheckbox10">允许他们撤销审批</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>不可复制字段
                                        </td>
                                        <td colspan="3">
                                            <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sNoCopyFields" Height="73px"
                                                Width="294px" />
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div id="divquery" style="display: none;">
                                <hr />
                                <table class="tabmain">
                                    <tr>
                                        <td>是否存储过程
                                        </td>
                                        <td>
                                            <%--<input id="Checkbox3" type="checkbox" fieldid="iStore" disabled="disabled" />--%>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iStore" disabled="disabled" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>SQL语句
                                        </td>
                                        <td colspan="5">
                                            <%--<textarea id="TextArea4" fieldid="sShowSql" fieldtype="char" class="textarea" style="width: 547px"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea7" runat="server" Style="width: 547px; height: 100px;" />
                                        </td>
                                        <td>存储过程<br />
                                            参数默认值
                                        </td>
                                        <td>
                                            <%--<textarea id="TextArea10" fieldid="sStoreParms" class="textarea" name="S6" style="height: 100px;
                                    width: 150px;" title="参数以$隔开,如a=1$b=2"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea8" runat="server" Style="height: 100px; width: 150px;"
                                                title="参数以$隔开,如a=1$b=2" Z_FieldID="sStoreParms" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>打开条件<br />
                                            (非存储过程有效)
                                        </td>
                                        <td colspan="5">
                                            <%--<textarea id="TextArea4" fieldid="sShowSql" fieldtype="char" class="textarea" style="width: 547px"></textarea>--%>
                                            <cc1:ExtTextArea2 ID="ExtTextArea18" runat="server" Style="width: 547px; height: 100px;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div title="列表信息">
                            <table style="border-spacing: 5px; border-collapse: separate; width: 100%;">
                                <tr>
                                    <td style="width: 100px;">页面加载完后执行
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea15" fieldid="sAfterInit" fieldtype="char" class="textarea"
                                style="width: 97%; height: 150px;"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea9" runat="server" Style="width: 97%; height: 150px;"
                                            Z_FieldID="sAfterInit" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 30px; padding-left: 10px;">
                                        <%--<input id="Checkbox4" type="checkbox" fieldid="iModify" fieldtype="int" /><label
                                for="Checkbox4">列表可编辑</label>--%>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" Z_FieldID="iModify" />
                                        <label for="ExtCheckbox5">
                                            列表可编辑</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                                <tr>
                                    <td>修改前执行
                                    </td>
                                    <td>
                                        <%--<textarea id="TextArea12" style="width: 300px; height: 150px; font-family: Verdana;"
                                fieldid="sBeforeEdit"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea10" Style="width: 300px; height: 150px; font-family: Verdana;"
                                            runat="server" Z_FieldID="sBeforeEdit" />
                                    </td>
                                    <td>保存前执行
                                    </td>
                                    <td>
                                        <%--<textarea id="TextArea13" style="width: 300px; height: 150px; font-family: Verdana;"
                                fieldid="sBeforeSave"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea11" Style="width: 300px; height: 150px; font-family: Verdana;"
                                            runat="server" Z_FieldID="sBeforeSave" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>结束编辑执行<br />
                                        (参数index, row, changes)
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea16" style="width: 97%; height: 150px; font-family: Verdana;"
                                fieldid="sEndEdit"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea12" Style="width: 97%; height: 150px; font-family: Verdana;"
                                            runat="server" Z_FieldID="sEndEdit" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 30px; padding-left: 10px;">
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox6" runat="server" Z_FieldID="iHasTree" />
                                        <label for="ExtCheckbox6">
                                            是否有树</label>
                                        &nbsp;&nbsp;&nbsp;&nbsp; 父字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sPfield" Style="width: 80px;" />
                                        &nbsp;&nbsp;&nbsp; 子字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sCfield" Style="width: 80px;" />
                                        &nbsp;&nbsp;&nbsp; 显示字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sDfield" Style="width: 80px;" />
                                        &nbsp;&nbsp; 关联字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" title="主表字段在前，树字段在后" Z_FieldID="sTreeLinkFields" Style="width: 120px;" />
                                        &nbsp;&nbsp; 
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox8" runat="server" Z_FieldID="iTreeCollapse" />
                                        <label for="ExtCheckbox8">
                                            树默认收缩</label>
                                        &nbsp;&nbsp;收缩级数
                                    <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="iTreeCollapseLevel" Style="width: 40px;" />
                                        &nbsp;&nbsp; 宽度
                                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iTreeWidth" Style="width: 60px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>树数据源
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea6" fieldid="sTreeSql" fieldtype="char" class="textarea" name="S3"
                                style="width: 97%; height: 200px;"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea13" runat="server" Z_FieldID="sTreeSql" Style="width: 97%; height: 200px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 30px; padding-left: 10px;">
                                        <%--<input id="Checkbox2" fieldid="iIsTreeList" fieldtype="int" type="checkbox" /><label
                                for="Checkbox2">是否树列表</label>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 父字段&nbsp;
                            <input id="Text1" fieldid="sTreeListPField" fieldtype="char" class="inputtxb" style="width: 89px"
                                type="text" />&nbsp;&nbsp;&nbsp; 子字段&nbsp;
                            <input id="Text3" fieldid="sTreeListCField" fieldtype="char" class="inputtxb" style="width: 88px"
                                type="text" />&nbsp;&nbsp;&nbsp;&nbsp; 显示字段&nbsp;
                            <input id="Text43" fieldid="sTreeListDField" fieldtype="char" class="inputtxb" style="width: 90px"
                                type="text" />&nbsp;&nbsp; 根值&nbsp;
                            <input id="Text7" fieldid="sTreeListRootValue" fieldtype="char" class="inputtxb"
                                style="width: 150px" type="text" title="主表字段在前，树字段在后" />--%>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox7" Z_FieldID="iIsTreeList" runat="server" />
                                        <label for="ExtCheckbox7">
                                            是否树列表</label>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 父字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sTreeListPField" />
                                        &nbsp;&nbsp;&nbsp; 子字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sTreeListCField" />
                                        &nbsp;&nbsp;&nbsp;&nbsp; 显示字段
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sTreeListDField" />
                                        &nbsp;&nbsp; 根值
                                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sTreeListRootValue" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div title="审批主题">
                            <table style="border-spacing: 5px; border-collapse: separate; width: 100%;">
                                <tr>
                                    <td style="width: 120px;">审批主题
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea2" fieldid="sProTitle" fieldtype="char" class="textarea" style="width: 97%;height: 80px;"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea14" runat="server" Z_FieldID="sProTitle" Style="width: 97%; height: 80px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 120px;">App审批主题
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea11" fieldid="sAppProTitle" fieldtype="char" class="textarea"
                                style="height: 80px; width: 97%;"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea15" runat="server" Z_FieldID="sAppProTitle" Style="height: 80px; width: 97%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 120px;">审批列名定义
                                    </td>
                                    <td colspan="3">
                                        <%--<textarea id="TextArea7" fieldid="sCheckSQL" fieldtype="char" class="textarea" style="height: 150px;width: 97%;"></textarea>--%>
                                        <cc1:ExtTextArea2 ID="ExtTextArea16" runat="server" Style="height: 150px; width: 97%;"
                                            Z_FieldID="sCheckSQL" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div title="导入模板">
                            <iframe id="ifrImport" width="100%" height="99%" frameborder='0'></iframe>
                        </div>
                        <div title="帮助信息">
                            <cc1:ExtTextArea2 ID="editor_id" runat="server" Z_FieldID="sHelpInfo" Style="width: 99%; height: 500px;" />
                        </div>
                    </div>
                </div>
                <div title="审批流程定义">
                    <table id="tableAppro" tablename="bscDataBillD" isson="true" linkfield="iFormID=iFormID"
                        fieldkey="GUID">
                    </table>
                    <div id="divSelectCheckPerson" class="easyui-window" data-options="title:'选择审批人员',modal:true,collapsible:false,minimizable:false,maximizable:false"
                        style="width: 605px; height: 230px;">
                        <table id="tabmain">
                            <tr>
                                <td>
                                    <input id="Radio1" type="radio" name="type" value="0" />
                                    <label for="Radio1">
                                        部门主管</label>
                                </td>
                                <td>&nbsp;&nbsp; &nbsp;
                                </td>
                                <td>部门：
                                </td>
                                <td>
                                    <input id="Text1" type="text" />
                                </td>
                                <td>表单域：
                                </td>
                                <td>
                                    <input id="Text2" type="text" class="easyui-textbox" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input id="Radio2" type="radio" name="type" value="1" />
                                    <label for="Radio2">
                                        角色</label>
                                </td>
                                <td></td>
                                <td>角色名：
                                </td>
                                <td>
                                    <input id="Text3" type="text" />
                                </td>
                                <td>&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input id="Radio3" type="radio" name="type" value="2" />
                                    <label for="Radio3">
                                        人员</label>
                                </td>
                                <td></td>
                                <td>人员：
                                </td>
                                <td>
                                    <input id="Text4" type="text" />
                                    <input id="Text4_val" type="hidden" />
                                </td>
                                <td>表单域：
                                </td>
                                <td>
                                    <input id="Text5" type="text" class="easyui-textbox" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input id="Radio4" type="radio" name="type" value="3" />
                                    <label for="Radio4">
                                        自定义</label>
                                </td>
                                <td></td>
                                <td>SQL语句：
                                </td>
                                <td colspan="3">
                                    <textarea id="TextArea4" style="font-family: Verdana; width: 300px; height: 50px;"></textarea>
                                </td>
                            </tr>
                        </table>
                        <hr />
                        <div style="text-align: center;">
                            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                                onclick="checkPersonConfirm()">确认</a>&nbsp; &nbsp;&nbsp; <a href="javascript:void(0)"
                                    class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#divSelectCheckPerson').window('close');">取消</a>
                        </div>
                    </div>
                </div>
                <div title="关联单据">
                    <table id="tableAss" tablename="bscDataBillDForm" isson="true" linkfield="iFormID=iFormID"
                        fieldkey="GUID">
                    </table>
                    <div id="divForm" class="easyui-window" data-options="title:'选择表单',modal:true,collapsible:false,minimizable:false,maximizable:false"
                        style="width: 550px; height: 400px;">
                        <table id="tabForm">
                        </table>
                        <div id="divTabFormTb">
                            <table>
                                <tr>
                                    <td>iFormID
                                    </td>
                                    <td>
                                        <input id="Text6" type="text" class="easyui-textbox" data-options="width:100" />
                                    </td>
                                    <td>表单名称
                                    </td>
                                    <td>
                                        <input id="Text7" type="text" class="easyui-textbox" data-options="width:100" />
                                    </td>
                                    <td>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick="formSearch()">查询</a>
                                    </td>
                                    <td>
                                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                                            onclick="formSelect()">确认选择 </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div title="审批完发送消息">
                    <table id="tableMessage" tablename="bscDataBillDUser" isson="true" linkfield="iFormID=iFormID"
                        fieldkey="GUID">
                    </table>
                </div>
                <div title="微信模板消息">
                    <table class="tabmain">
                        <tr>
                            <td>模板号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sWeiXinTempletID" />
                                <input type="button" value="..." onclick="weixinTempletTarget = 'ExtTextBox25'; openTempletWindow()" />
                                <a href="javascript:void(0)" onclick="downLoadTemplet()">下载所有模板</a>
                            </td>
                        </tr>
                        <tr>
                            <td>用户OpenID(Sql)
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea17" runat="server" Style="width: 400px; height: 100px;"
                                    Z_FieldID="sWeiXinOpenIDSql" />
                            </td>
                        </tr>
                        <tr>
                            <td>FirstData
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="sWeiXinMessageFirstData" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData1
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sWeiXinMessageKeyword1" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData2
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sWeiXinMessageKeyword2" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData3
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sWeiXinMessageKeyword3" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData4
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sWeiXinMessageKeyword4" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData5
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sWeiXinMessageKeyword5" />
                            </td>
                        </tr>
                        <tr>
                            <td>KeyData6
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="sWeiXinMessageKeyword6" />
                            </td>
                        </tr>
                        <tr>
                            <td>RemarkData
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="sWeiXinMessageRemarkData" />
                            </td>
                        </tr>
                    </table>
                    <p style="padding-left: 20px;">
                        注：可以用{field}来代替主表SQL中的字段，{userid}代替当前人，{datetime}代替当前时间
                    </p>
                </div>
            </div>
        </div>
        <div id="divTemplet" class="easyui-dialog" data-options="width:860,height:400,closed:true,title: '选择模板',modal: true, cache: false">
            <table id="TabWeiXinTemplet">
            </table>
        </div>
        <div id="divWeiXinConfig" class="easyui-dialog" data-options="width:800,height:500,closed:true,title:'微信设置',modal: true, cache: false,buttons:[{text:'确定',handler:WeixinConfigConfirm},{text:'关闭',handler:function(){$('#divWeiXinConfig').dialog('close');}}]">
            <form id="form2">
                <table>
                    <tr>
                        <td>何时发送
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" />
                        </td>
                        <td>
                            <a href="#" onclick="showMoreWeixin()">更多微信消息
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td>模板
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox37" name="sWeiXinTemplet" runat="server" />
                            <a href="javascript:void(0)" onclick="downLoadTemplet()">下载所有模板</a>
                        </td>
                        <td>url
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea29" class="toolTipValueAndSql" name="sWeiXinUrl" Style="width: 300px; height: 30px;" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>发送条件
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea28" class="toolTipSql" name="sSendWeiXinCondition" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                        <td>用户OpenID
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea19" class="toolTipValueAndSql" name="sSendWeiXinOpenID" Style="width: 300px; height: 60px;" runat="server" />
                        </td>

                    </tr>
                    <tr>
                        <td>FirstData
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea20" class="toolTipValueAndSql" name="sWeiXinFirstData" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                        <td>KeyData1
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea21" class="toolTipValueAndSql" name="sWeiXinKeyData1" Style="width: 300px; height: 60px;" runat="server" />
                        </td>

                    </tr>
                    <tr>
                        <td>KeyData2
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea22" class="toolTipValueAndSql" name="sWeiXinKeyData2" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                        <td>KeyData3
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea23" class="toolTipValueAndSql" name="sWeiXinKeyData3" Style="width: 300px; height: 60px;" runat="server" />
                        </td>

                    </tr>
                    <tr>
                        <td>KeyData4
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea24" class="toolTipValueAndSql" name="sWeiXinKeyData4" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                        <td>KeyData5
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea25" class="toolTipValueAndSql" name="sWeiXinKeyData5" Style="width: 300px; height: 60px;" runat="server" />
                        </td>

                    </tr>
                    <tr>
                        <td>KeyData6
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea26" class="toolTipValueAndSql" name="sWeiXinKeyData6" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                        <td>RemarkData
                        </td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea27" class="toolTipValueAndSql" name="sWeiXinRemarkData" Style="width: 300px; height: 60px;" runat="server" />
                        </td>
                    </tr>

                </table>
            </form>
        </div>
        <div id="divView" class="easyui-dialog" data-options="width:400,height:250,closed:true,title: '模板样式',modal: true, cache: false">
            <p id="pview" style="font-size: 14px; padding: 10px;">
            </p>
        </div>
        <div id="divWeixinMore" class="easyui-dialog" data-options="closed:true,title: '更多微信消息',modal: true, cache: false,">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="height:200px;">
                    <table id="tabWeixinMore" class="easyui-datagrid">
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <form id="formWeixinMore">
                        <table>
                            <tr>
                                <td>序号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox41"  name="iSerial" runat="server" style="width:40px;" />
                                    <cc1:ExtHidden2 ID="ExtHidden1" runat="server" name="iRecNo" />
                                    <cc1:ExtHidden2 ID="ExtHidden2" runat="server" name="sGUID" />
                                </td>
                                <td>何时发送
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox39" name="iWeiXinWhenSend" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>模板
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox40" name="sWeiXinTemplet" runat="server" />
                                    <a href="javascript:void(0)" onclick="downLoadTemplet()">下载所有模板</a>
                                </td>
                                <td>url
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea30" class="toolTipValueAndSql" name="sWeiXinUrl" Style="width: 300px; height: 30px;" runat="server" />
                                </td>
                                <td>发送条件
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea31" class="toolTipSql" name="sSendWeiXinCondition" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                
                                <td>用户OpenID
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea32" class="toolTipValueAndSql" name="sSendWeiXinOpenID" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>FirstData
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea33" class="toolTipValueAndSql" name="sWeiXinFirstData" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>KeyData1
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea34" class="toolTipValueAndSql" name="sWeiXinKeyData1" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>KeyData2
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea35" class="toolTipValueAndSql" name="sWeiXinKeyData2" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>KeyData3
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea36" class="toolTipValueAndSql" name="sWeiXinKeyData3" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>KeyData4
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea37" class="toolTipValueAndSql" name="sWeiXinKeyData4" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                            </tr>
                            <tr>                                
                                <td>KeyData5
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea38" class="toolTipValueAndSql" name="sWeiXinKeyData5" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>KeyData6
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea39" class="toolTipValueAndSql" name="sWeiXinKeyData6" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                                <td>RemarkData
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea40" class="toolTipValueAndSql" name="sWeiXinRemarkData" Style="width: 300px; height: 60px;" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" style="text-align:center;">
                                    <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveWeixinMore()">保存</a>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(function () {
                $(".toolTipValueAndSql").tooltip({
                    content: "{field}来获取当前表单数据，如果是sql语句，请输入sql:sql语句，支持{field},{userid}"
                });
                $(".toolTipSql").tooltip({
                    content: "必须为sql语句，支持{field},{userid}，只要语句又返回数据，就算满足条件"
                });
            })
            //让textarea可以输入tab
            var tabStr = "    ";
            var myInput = document.getElementById("ExtTextArea9")
            if (myInput.addEventListener) {
                myInput.addEventListener('keydown', this.keyHandler, false);
            } else if (myInput.attachEvent) {
                myInput.attachEvent('onkeydown', this.keyHandler); /* damn IE hack */
            }
            var myInput1 = document.getElementById("ExtTextArea9")
            if (myInput1.addEventListener) {
                myInput1.addEventListener('keydown', this.keyHandler, false);
            } else if (myInput1.attachEvent) {
                myInput1.attachEvent('onkeydown', this.keyHandler); /* damn IE hack */
            }
            function keyHandler(e) {
                var TABKEY = 9;
                if (e.keyCode == TABKEY) {
                    insertText(myInput, tabStr);
                    if (e.preventDefault) {
                        e.preventDefault();
                    }
                }
            }
            function insertText(obj, str) {
                if (document.selection) {
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
        </script>
    </form>
</body>
</html>
