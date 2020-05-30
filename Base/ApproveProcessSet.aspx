<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>审批流定义</title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=3" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css?r=3" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="JS/datagridExtend.js" type="text/javascript"></script>
    <script src="JS2/datagridOp.js" type="text/javascript"></script>
    <script src="JS2/Form.js"></script>
    <script type="text/javascript">
        var userid = "";
        var usetype = "";
        var curtFormID = "";
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
            $("#txbFormID").textbox("textbox").addClass("txbreadonly");
            $("#tt").tree({
                url: "/Base/Handler/GetMenuTree.ashx",
                onSelect: function (node) {
                    if ($("#tt").tree("getChildren", node.target).length > 0) {
                        if (node.state == "closed") {
                            $("#tt").tree("expand", node.target);
                        }
                        else {
                            $("#tt").tree("collapse", node.target);
                        }
                        return;
                    }
                    curtFormID = node.attributes.iFormID;
                    loadData();
                }
            });
            setTimeout("treeCollapseAll()", 1000);

            $("#table1").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    columns: [[
                        { field: "__cb", checkbox: true },
                        { field: "iSerial", title: "审批步", width: 40, align: 'center', editor: { type: "numberspinner", options: { height: 35 } } },
                        { field: "sCheckName", title: "审批名称", width: 80, align: 'center', editor: { type: "textbox", options: { height: 35 } } },
                        { field: "sCheckType", title: "审批类型", width: 80, align: 'center', editor: { type: "combobox", options: { height: 35, panelHeight: 60, valueField: "text", textField: "text", data: [{ text: "单人审批" }, { text: "会签" }] } } },
                        { field: "sCheckPersonShow", title: "处理人", width: 130, align: 'center', editor: { type: "textbox", options: { height: 35, buttonText: "...", onClickButton: selectCheckPerson } } },
                        { field: "sCheckPerson", title: "处理人", hidden: true },
                        { field: "sContion", title: "审批条件", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sNextPushInform", title: "推送人", width: 80, align: 'center', editor: { type: "textbox", options: { height: 35 } } },
                        { field: "iPushSerial", title: "推送<br />节点", width: 40, align: 'center', editor: { type: "numberspinner", options: { height: 35 } } },
                        { field: "iNoPushSerial", title: "不推送<br />节点", width: 40, align: 'center', editor: { type: "numberspinner", options: { height: 35 } } },
                        {
                            field: "iFinish", title: "审批<br />完成", width: 40, align: 'center', formatter: function (value, row, index) {
                                if (value == "1") {
                                    return "√";
                                }
                            },
                            editor: { type: "checkbox", options: { on: "1", off: "0" } }
                        },
                        { field: "sFinishCondition", title: "审批完成条件", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionAgree", title: "通过执行语句", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionReturn", title: "退回执行语句", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sReturnContion", title: "可退回条件", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sActionCancel", title: "撤销审批语句", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sBeforeAgree", title: "同意前检测", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sBeforeReturn", title: "退回前检测", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } },
                        { field: "sModifyFields", title: "可编辑字段", width: 200, align: 'center', editor: { type: "mytextarea", options: { style: "height:50px" } } }
                    ]],
                    toolbar: [
                    {
                        text: "增加行",
                        iconCls: 'icon-add',
                        handler: function () {
                            var iSerial = $("#table1").datagrid("getRows").length + 1;
                            $("#table1").datagrid("appendRow", { __hxstate: "add", GUID: NewGuid(), iSerial: iSerial, sUserID: userid, dinputDate: getNowDate() + " " + getNowTime() });
                        }
                    },
                    {
                        text: "删除行",
                        iconCls: 'icon-remove',
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#table1").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        var deleteKey = $("#table1").attr("deleteKey");
                                        if (deleteKey) {
                                            deleteKey += "'" + selectedRows[i].GUID + "',";
                                            $("#table1").attr("deleteKey", deleteKey);
                                        } else {
                                            $("#table1").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                        }

                                        $("#table1").datagrid("deleteRow", $("#table1").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                    ],
                    onClickCell: function (index, row) { datagridOp.cellClick("table1", index, row); },
                    onBeforeEdit: function (index, row) { datagridOp.beforeEditor("table1", index, row); },
                    onBeginEdit: function (index, row) { datagridOp.beginEditor("table1", index, row); },
                    onEndEdit: function (index, row, changes) { datagridOp.endEditor("table1", index, row, changes); },
                    onAfterEdit: function (index, row, changes) { if (row.sCheckPersonShow == "") { $("#table1").datagrid("updateRow", { index: index, row: { sCheckPerson: "" } }); } datagridOp.afterEditor("table1", index, row, changes); }
                }
            );
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

            $("#txbDept").combotree({
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
            $("#txbRole").combobox({
                valueField: "sName",
                textField: "sName",
                data: roleData,
                multiple: true
            });
            $("#txbRole").attr("plugin", "combobox");
            $("#txbDeptDomain").combobox({
                valueField: "Name",
                textField: "Name"
            });
            $("#txbDeptDomain").attr("plugin", "combobox");
            $("#txbPersonName").textbox({
                buttonText: "...",
                onClickButton: function () {
                    selectPerson("check");
                }
            });
            $("#txbPersonName").attr("plugin", "combobox");
            $("#txbPersonDomain").combobox({
                valueField: "Name",
                textField: "Name"
            });
            $("#txbPersonDomain").attr("plugin", "combobox");
        })
        function loadData() {
            var sqlObjMain = {
                TableName: "bscDataBill",
                Fields: "iFormID,sBillType,sProTitle,sTableName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID", ComOprt: "=", Value: curtFormID
                    }
                ]
            }
            var dataMain = SqlGetData(sqlObjMain);
            if (dataMain.length == 0) {
                usetype = "add";
                $("#form1").form("load", { iFormID: curtFormID });
                $("#FieldKeyValue").val(curtFormID);
            } else {
                $("#FieldKeyValue").val(curtFormID);
                $(".fields").combobox("loadData", getTableFields(dataMain[0].sTableName));
                usetype = "modify";
                $("#form1").form("load", dataMain[0]);
                var sqlObjChild = {
                    TableName: "bscDataBillD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iFormID", ComOprt: "=", Value: curtFormID
                        }
                    ]
                }
                var dataChild = SqlGetData(sqlObjChild);
                $("#table1").datagrid("loadData", dataChild);
            }
        }
        function treeCollapseAll() {
            $("#tt").tree('collapseAll');
            var rootNodes = $("#tt").tree("getRoots");
            for (var i = 0; i < rootNodes.length; i++) {
                $("#tt").tree("expand", rootNodes[i].target);
            }
        }

        function selectCheckPerson() {
            $("#divSelectCheckPerson").window("open");
            var content = $("#table1").datagrid("getRows")[datagridOp.currentRowIndex].sCheckPerson;
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
                                $("#txbDept").combotree("setValue", svalue);
                            }
                            else if (sindex == "1") {
                                document.getElementById("txbDeptDomain").value = svalue;
                            }
                        } break;
                    case "1":
                        {
                            document.getElementById("Radio2").checked = true;
                            if (sindex == "0") {
                                var svalueArr = svalue.split(',');
                                $("#txbRole").combobox("setValue", svalueArr);
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
                                    $("#txbPersonName").textbox("setValue", personData[0].sName);
                                }
                                $("#txbPersonName_val").val(svalue);

                            }
                            else if (sindex == "1") {
                                //document.getElementById("txbPersonDomain").value = svalue;
                                $("#txbPersonDomain").combobox("setValue", svalue);
                            }
                        } break;
                    case "3":
                        {
                            document.getElementById("Radio4").checked = true;
                            document.getElementById("txaManSql").value = svalue;
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
                        var departID = $("#txbDept").combotree("getValue");
                        if (departID) {
                            returnvalue += "0:" + departID;
                            showStr += selectedDepartName;
                            break;
                        }
                        else if (document.getElementById("txbDeptDomain").value.length > 0) {
                            returnvalue += "1:" + document.getElementById("txbDeptDomain").value;
                            showStr += "表单域[" + document.getElementById("txbDeptDomain").value + "]";
                        }
                    }
                    else if (radios[i].value == "1") {
                        showStr += "角色：";
                        var role = $("#txbRole").combobox("getValues");
                        if (role) {
                            returnvalue += "0:" + role;
                            showStr += role.toString();
                            break;
                        }
                    }
                    else if (radios[i].value == "2") {
                        showStr += "人员：";
                        var person = $("#txbPersonName").textbox("getValue");
                        if (person != "") {
                            returnvalue += "0:" + $("#txbPersonName_val").val();
                            showStr += person;
                            break;
                        }
                        else {
                            var comValue = $("#txbPersonDomain").combobox("getValue");
                            if (comValue != "") {
                                returnvalue += "1:" + comValue;
                                showStr += "表单域[" + comValue + "]";
                                break;
                            }
                        }
                    }
                    else if (radios[i].value == "3") {
                        showStr += "自定义:";
                        returnvalue += document.getElementById("txaManSql").value;
                        showStr += document.getElementById("txaManSql").value;
                        break;
                    }
                }
            }
            $("#divSelectCheckPerson").window("close");
            $("#table1").datagrid("updateRow", {
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
            //$("#form2").form("reset");
            $("#txbPersonDomain").combobox("setValue", "");
            $("#txbPersonName").textbox("setValue", data[0].sName);
            $("#txbPersonName_val").val(data[0].sCode);
        }
        function selectPersonToMessage(data) {
            for (var i = 0; i < data.length; i++) {
                var uRow = { sUserID: "2;0:" + data[i].sCode, sUserShow: "人员：" + data[i].sName, dInputDate: getNowDate() + " " + getNowTime() };
                $("#tableMessage").datagrid("updateRow", { index: messageRowIndex, row: uRow });
            }
        }

        function save() {
            var sqlFormObj = {
                TableName: "bscDataBill",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + curtFormID + "'"
                    }
                ]
            }
            var FormOriData = SqlGetData(sqlFormObj);
            if (FormOriData.length > 0) {
                var formid = Form.__update(curtFormID, "/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (formid.indexOf("error:") > -1) {
                    MessageShow("失败", formid.substr(6, formid.length - 6));
                }
                else {
                    MessageShow("保存成功", "保存成功");
                }
            }
            else {
                var formid = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (formid.indexOf("error:") > -1) {
                    MessageShow("失败", formid.substr(6, formid.length - 6));
                }
                else {
                    MessageShow("保存成功", "保存成功");
                }
            }
        }

        function NewGuid_S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function NewGuid() {
            return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
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

        function MessageShow(title, message) {
            var iheight = (message.length / 20) * 20;
            iheight = iheight < 100 ? 100 : iheight;
            $.messager.show({
                showSpeed: 100,
                title: title,
                height: iheight,
                msg: "<font style='color:red;font-weight:bold;'>" + message + "</font>",
                showType: 'slide',
                timeout: 2000,
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
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
    </script>
    <style type="text/css">
        .txbreadonly {
            background-color: #ffffaa;
            border: none;
            border-bottom: solid 1px #95b8e7;
            height: 18px; /*border-radius: 5px;*/
        }
    </style>
</head>
<body class="easyui-layout" data-opiotns="border:false">
    <div data-options="region:'west',split:true" style="width: 250px;">
        <ul id="tt"></ul>
    </div>
    <div data-options="region:'center',border:false">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north',split:true" style="height: 150px">
                <div style="height: 30px; padding-left: 10px; background-color: #efefef;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
                </div>
                <div>
                    <form id="form1">
                        <input id="TableName" type="hidden" value="bscDataBill" />
                        <input id="FieldKey" type="hidden" value="iFormID" />
                        <input id="FieldKeyValue" type='hidden' />
                        <input id="UserID" type="hidden" />
                        <table>
                            <tr>
                                <td>表单号</td>
                                <td>
                                    <cc1:ExtTextBox2 ID="txbFormID" Z_FieldID="iFormID" Z_readOnly="true" runat="server" />
                                </td>
                                <td>表单名</td>
                                <td>
                                    <cc1:ExtTextBox2 ID="txbFormName" Z_FieldID="sBillType" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>审批主题
                                </td>
                                <td colspan="7">
                                    <cc1:ExtTextArea2 ID="txaProTitle" Style="width: 500px; height: 50px;" Z_FieldID="sProTitle" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>

            </div>
            <div data-options="region:'center'">
                <table id="table1" tablename="bscDataBillD" linkfield="iFormID=iFormID" fieldkey="GUID" deletekey="" isson='true'></table>
            </div>
        </div>
    </div>
    <div id="divSelectCheckPerson" class="easyui-window" data-options="title:'选择审批人员',modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false"
        style="width: 605px; height: 250px;">
        <form id="form2">
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
                        <input id="txbDept" style="width: 150px;" type="text" />
                    </td>
                    <td>表单域：
                    </td>
                    <td>
                        <input id="txbDeptDomain" class="fields" style="width: 150px;" type="text" />
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
                        <input id="txbRole" type="text" style="width: 150px;" />
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
                        <input id="txbPersonName" type="text" style="width: 150px;" />
                        <input id="txbPersonName_val" type="hidden" />
                    </td>
                    <td>表单域：
                    </td>
                    <td>
                        <input id="txbPersonDomain" class="fields" type="text" style="width: 150px;" />
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
                        <textarea id="txaManSql" style="font-family: Verdana; width: 300px; height: 50px;"></textarea>
                    </td>
                </tr>
            </table>
        </form>
        <hr />
        <div style="text-align: center;">
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                onclick="checkPersonConfirm()">确认</a>&nbsp; &nbsp;&nbsp; <a href="javascript:void(0)"
                    class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#divSelectCheckPerson').window('close');">取消</a>
        </div>
    </div>
</body>
</html>
