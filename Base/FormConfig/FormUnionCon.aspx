<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>联合报表定义</title>
    <link href="/Base/JS/easyui_new_1.5.5/themes/gray/easyui.css?r=3" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new_1.5.5/themes/icon.css?r=3" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new_1.5.5/jquery.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new_1.5.5/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new_1.5.5/datagrid-detailview.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new_1.5.5/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/datagridOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script type="text/javascript">
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
        var SqlObjForm = {
            TableName: "bscDataBill",
            Fields: "iFormID,sBillType,cast(iFormID as varchar(20))+'-'+sBillType as sShowText",
            SelectAll: "True",
            Filters: [
                {
                    Field: "iFormID", ComOprt: "in", Value: "(select iFormID from FSysMainMenu)"
                }
            ],
            Sorts: [{
                SortName: "iFormID", SortOrder: "asc"
            }]
        }
        var dataFormSource = SqlGetData(SqlObjForm);
        //if (dataForm.length > 0) {
        //    dataForm.splice(0, 0, { iFormID: null, sBillType: "" });
        //}
        $(function () {
            $("#FieldKeyValue").val(getQueryString("iFormID"));
            $("#tb").datagrid({
                fit: true,
                columns: [
                    [
                        { field: "__cb", checkbox: true, width: 40 },
                        { title: "区域", field: "iZone", width: 50, align: "center", editor: { type: "numberspinner" } },
                        {
                            title: "表单号", field: "iZoneForm", width: 200, align: "center",
                            editor: {
                                type: "combobox", options: {
                                    valueField: "iFormID", textField: "sShowText",
                                    data: dataFormSource
                                }
                            },
                            formatter: function (value, row, index) {
                                var isFound = false;
                                for (var i = 0; i < dataFormSource.length; i++) {
                                    if (dataFormSource[i].iFormID == row.iZoneForm) {
                                        isFound = true;
                                        return dataFormSource[i].sShowText;
                                    }
                                }
                                if (isFound == false) {
                                    return value;
                                }
                            }

                        },
                        { title: "查询条件对应字段", field: "sConditionFields", align: "center", width: 300, editor: { type: "textarea" } },
                        {
                            title: "显示<br />动态列", field: "iDynColumnShow", width: 60, align: "center", editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iDynColumnShow == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            title: "显示模式", field: "iChartOnly", width: 110, align: "center", editor: {
                                type: "combobox",
                                options: {
                                    valueField: "id", textField: "value",
                                    data: [{ id: 0, value: "只显示表格" }, { id: 1, value: "只显示图表" }, { id: 2, value: "都显示" }],
                                    panelHeight:100
                                }
                            },
                            formatter: function (value, row, index) {
                                if (row.iChartOnly == 0) {
                                    return "只显示表格";
                                }
                                if (row.iChartOnly == 1) {
                                    return "只显示图表";
                                }
                                if (row.iChartOnly == 2) {
                                    return "都显示";
                                }
                            }
                        },
                        {
                            title: "宽度<br />(%)", field: "iWidth", width: 40, align: "center", editor: { type: "numberbox", options: { precision: 0 } }
                        },
                        {
                            title: "高度<br />(%)", field: "iHeight", width: 40, align: "center", editor: { type: "numberbox", options: { precision: 0 } }
                        },
                        { title: "备注", field: "sRemark", width: 200, align: "center", editor: { type: "textarea" } },
                        {
                            title: "数据源定义", width: 100, align: "center", field: "___1",
                            formatter: function (value, row, index) {
                                return "<a href='javascript:void(0)' onclick='openDataSourcePage(" + row.iZoneForm + ")' >数据源定义</a>";
                            }
                        },
                        {
                            title: "列定义", width: 100, align: "center", field: "___2",
                            formatter: function (value, row, index) {
                                return "<a href='javascript:void(0)' onclick='openColumnDefinedPage(" + row.iZoneForm + ")' >列定义</a>";
                            }
                        },
                        { field: "GUID", hidden: true }
                    ]
                ],
                toolbar: [
                    {
                        iconCls: 'icon-add',
                        text: "增加行",
                        handler: function () {
                            var allRows = $("#tb").datagrid("getRows");
                            var nextGuid = NewGuid();
                            var appendRow = {
                                GUID: nextGuid,
                                iZone: (allRows.length + 1),
                                iFormID: getQueryString("iFormID"),
                                sUserID: userid,
                                dInputDate: getNowDate() + " " + getNowTime(),
                                __hxstate: "add"
                            }
                            $("#tb").datagrid("appendRow", appendRow);
                        }
                    },
                    {
                        iconCls: 'icon-remove',
                        text: "删除行",
                        handler: function () {
                            $.messager.confirm("确认删除吗", "确认删除所选行吗？", function (r) {
                                if (r) {
                                    var selectedRows = $("#tb").datagrid("getChecked");
                                    for (var i = 0; i < selectedRows.length; i++) {
                                        var deleteKey = $("#tb").attr("deleteKey");
                                        if (deleteKey) {
                                            deleteKey += "'" + selectedRows[i].GUID + "',";
                                            $("#tb").attr("deleteKey", deleteKey);
                                        } else {
                                            $("#tb").attr("deleteKey", "'" + selectedRows[i].GUID + "',");
                                        }
                                        $("#tb").datagrid("deleteRow", $("#tb").datagrid("getRowIndex", selectedRows[i]));
                                    }
                                }
                            });
                        }
                    }
                ],
                onClickCell: function (index, row) { datagridOp.cellClick("tb", index, row); },
                onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tb", index, row); },
                onBeginEdit: function (index, row) { datagridOp.beginEditor("tb", index, row); },
                onEndEdit: function (index, row, changes) { datagridOp.endEditor("tb", index, row, changes); },
                onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("tb", index, row, changes); }
            });

            $(".tdImg").tooltip({
                position: 'bottom',
                content: '<div><img style="width:500px;height:400px;" /></div>',
                onShow: function () {
                    var src = $(this).children().find("img").eq(0).attr("src");
                    $(this).tooltip('tip').children().find("img").attr("src", src);
                }
            });
            $(".tdImg").bind("click", function () {
                if ($(this).hasClass("tdImgSelect")) {
                    //$(this).removeClass("tdImgSelect");
                } else {
                    $(this).addClass("tdImgSelect").siblings().removeClass("tdImgSelect");
                    var id = $(this).attr("id");
                    var index = id.substr(id.length - 1, 1);
                    $("#txbStyle").combobox("setValue", index);
                }
            })
            $("#txbFormID").textbox("textbox").addClass("txbreadonly");

            var styleData = [
                { id: "1", text: "上下型" }, { id: "2", text: "左右型" }, { id: "3", text: "四象限" }, { id: "4", text: "上一下多型" },
                { id: "5", text: "上一下tab型" }
            ];
            $("#txbStyle").combobox({
                valueField: "id", textField: "text", data: styleData
            });
            $("#txbStyle").combobox("textbox").addClass("txbreadonly");
            var zoneConditionData = [
                { id: "0", text: "本身" }, { id: "1", text: "区域1" }, { id: "2", text: "区域2" }, { id: "3", text: "区域3" },
                { id: "4", text: "区域4" }, { id: "5", text: "区域5" }
            ];
            $("#txbZoneCondition").combobox({
                valueField: "id", textField: "text", data: zoneConditionData
            });
            $("#txbZoneCondition").combobox("setValue", "0");
            $("#txbFormID").textbox("setValue", getQueryString("iFormID"));
            loadData();
        })

        function loadData() {
            var iFormID = getQueryString("iFormID");
            var sqlObjMain = {
                TableName: "BscDataFormUnionM",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: iFormID
                    }
                ]
            };
            var dataMain = SqlGetData(sqlObjMain);
            if (dataMain.length > 0) {
                $("#form1").form("load", dataMain[0]);
                $("#ExtCheckbox1")[0].checked = (dataMain[0].iMobileApp == "1" ? true : false);
                var iShowType = dataMain[0].iShowType;
                $("#td" + iShowType).addClass("tdImgSelect");
                $("#FieldKeyValue").val(dataMain[0].iFormID);
                var sqlObjChild = {
                    TableName: "BscDataFormUnionD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iFormID", ComOprt: "=", Value: iFormID
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "iZone",
                            SortOrder: "asc"
                        }
                    ]
                };
                var dataChild = SqlGetData(sqlObjChild);
                $("#tb").datagrid("loadData", dataChild);
            }
        }

        function openDataSourcePage(iFormID) {
            var url = "/Base/FormConfig/SysFormSet.aspx?iformid=" + iFormID + "&r=" + Math.random();
            window.open(url, '数据源定义', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=yes');
        }

        function openColumnDefinedPage(iFormID) {
            var url = "/Base/FormConfig/SysQueryWinCnfig.aspx?iformid=" + iFormID + "&r=" + Math.random();
            window.open(url, '列定义', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=yes');
        }

        function save() {
            var useZone = $("#txbZoneCondition").combobox("getValue");
            if (useZone != "0") {
                var allRows = $("#tb").datagrid("getRows");
                var isFound = false;
                for (var i = 0; i < allRows.length; i++) {
                    if (useZone == allRows[i].iZone) {
                        isFound = true;
                    }
                }
                if (isFound == false) {
                    MessageShow("查询条件使用区域不存在", "查询条件使用区域不存在");
                    return false;
                }
            }

            var iShowType = $("#txbStyle").combobox("getValue");
            if (iShowType == "4") {
                var allRows = $("#tb").datagrid("getRows");
                if (allRows.length <= 2) {
                    MessageShow("上一下多型最少有三个区域", "上一下多型最少有三个区域");
                    return false;
                }
            }

            var allRows = $("#tb").datagrid("getRows");
            var zoneStr = ",";
            for (var i = 0; i < allRows.length; i++) {
                if (allRows[i].iZone == null || allRows[i].iZone == undefined) {
                    MessageShow("区域号不能为空", "区域号不能为空");
                    return false;
                }
                if (zoneStr.indexOf(allRows[i].iZone + ",") > -1) {
                    MessageShow("区域号不能重复", "区域号不能重复");
                    return false;
                }
                zoneStr += allRows[i].iZone + ",";
            }

            var iFormID = getQueryString("iFormID");
            var sqlFormObj = {
                TableName: "BscDataFormUnionM",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: "'" + iFormID + "'"
                    }
                ]
            }
            var FormOriData = SqlGetData(sqlFormObj);
            if (FormOriData.length > 0) {
                var result = Form.__update(iFormID, "/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (result.indexOf("error:") > -1) {
                    $.messager.alert("失败", result.substr(6, result.length - 6));
                }
                else {
                    $.messager.alert("保存成功", "保存成功");
                }
            }
            else {
                var result = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (result.indexOf("error:") > -1) {
                    $.messager.alert("失败", result.substr(6, result.length - 6));
                }
                else {
                    $.messager.alert("保存成功", "保存成功");
                }
            }
        }

        var lastIndex = undefined;
        function tabSelect(title, index) {
            if (index == 2) {
                $("#divTab").tabs("select", lastIndex);
                save();
            }
            else {
                lastIndex = index;
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

        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
        function MessageShow(title, message) {
            var iheight = (message.length / 20) * 20;
            iheight = iheight < 100 ? 100 : iheight;
            $.messager.show({
                showSpeed: 100,
                title: title,
                height: iheight,
                msg: message,
                showType: 'slide',
                timeout: 2000,
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });

        }
    </script>
    <style type="text/css">
        #tabImg {
            border-collapse: separate;
        }

        .tdImg {
            cursor: pointer;
            text-align: center;
            position: relative;
            border: solid 1px #e0e0e0;
        }

            .tdImg img + img {
                display: none;
                position: absolute;
                top: 0;
                right: 0;
            }

                .tdImg img + img + img {
                    display: none;
                    position: absolute;
                    top: 0;
                    left: 0;
                    z-index: 9999;
                }

            .tdImg:hover img + img + img {
                display: block;
            }

        .tdImgSelect {
            border: solid 1px #ff6a00;
        }

            .tdImgSelect img + img {
                display: block;
            }

        .img {
            width: 200px;
            height: 150px;
        }

        .txbreadonly {
            background-color: #ffffaa;
            border: none;
            border-bottom: solid 1px #95b8e7;
            height: 18px; /*border-radius: 5px;*/
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',border:false" style="height: 330px;">
        <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false,onSelect:tabSelect,tools:[{iconCls:'icon-save',plain:true,text:'保存',handler:function(){ save(); }}]">
            <div title="样式">
                <form id="form1" method="post" runat="server">
                    <div style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldID="sUserID" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="dInputDate" runat="server" />
                        <!--要保存的表名-->
                        <asp:HiddenField ID="TableName" runat="server" Value="BscDataFormUnionM" />
                        <!--要获取主键的表名-->
                        <asp:HiddenField ID="SerialTableName" runat="server" Value="BscDataFormUnionM" />
                        <!--表的主键字段-->
                        <asp:HiddenField ID="FieldKey" runat="server" Value="iFormID" />
                        <asp:HiddenField ID="FieldKeyValue" runat="server" />
                    </div>
                    <table id="tabImg" cellspacing="10">
                        <tr>
                            <td class="tdImg" id="td1">
                                <div>
                                    <img class="img" src="../CSS/img/type_1.png" />
                                    <img src="../CSS/img/selected.png" />
                                </div>
                                <div>
                                    上下型
                                </div>
                            </td>
                            <td class="tdImg" id="td2">
                                <div>
                                    <img class="img" src="../CSS/img/type_2.png" />
                                    <img src="../CSS/img/selected.png" />
                                </div>
                                <div>
                                    左右型
                                </div>
                            </td>
                            <td class="tdImg" id="td3">
                                <div>
                                    <img class="img" src="../CSS/img/type_3.png" />
                                    <img src="../CSS/img/selected.png" />
                                </div>
                                <div>
                                    四象限型
                                </div>
                            </td>
                            <td class="tdImg" id="td4">
                                <div>
                                    <img class="img" src="../CSS/img/type_4.png" />
                                    <img src="../CSS/img/selected.png" />
                                </div>
                                <div>
                                    上一下多型
                                </div>
                            </td>
                            <td class="tdImg" id="td5">
                                <div>
                                    <img class="img" src="../CSS/img/type_5.png" />
                                    <img src="../CSS/img/selected.png" />
                                </div>
                                <div>
                                    上一下tab型
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td>iFormID
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="txbFormID" Z_FieldID="iFormID" runat="server" Z_readOnly="true" />
                            </td>
                            <td>样式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="txbStyle" Z_FieldID="iShowType" runat="server" Z_readOnly="true" />
                            </td>
                            <td>查询条件使用区域
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="txbZoneCondition" Z_FieldID="iUseZoneCondition" runat="server" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iMobileApp" runat="server" />
                                <label for="ExtCheckbox1">手机报表</label>
                            </td>
                            <td>备注
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea3" Z_FieldID="sRemark" runat="server" Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>手机快速<br />
                                查询条件</td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea2" class="easyui-tooltip" title="格式：{中文名}:{字段名},{中文名}:{字段名},{中文名}:{字段名},{中文名}:{字段名},<br />至多定义4组，{中文名}是前端显示名，{字段名}是使用区域的查询条件字段字段名" Z_FieldID="sQuickCondition" runat="server" Style="width: 99%;" />
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div title="事件">
                <table>
                    <tr>
                        <td>页面加载后执行</td>
                        <td>
                            <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sAfterPageLoad" Style="width: 600px; height: 200px;" />
                        </td>
                    </tr>
                </table>
            </div>
            <%--<div title="保存" data-options="iconCls:'icon-save'">

            </div>--%>
        </div>
    </div>
    <div data-options="region:'center',border:false">
        <table id="tb" isson="true" tablename="BscDataFormUnionD" linkfield="iFormID=iFormID" fieldkey="GUID"></table>
    </div>
</body>
</html>
