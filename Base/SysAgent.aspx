<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>代理人设置</title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=3" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css?r=3" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-groupview.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="JS/datagridExtend.js" type="text/javascript"></script>
    <script src="JS2/datagridOp.js" type="text/javascript"></script>
    <script src="JS2/Form.js"></script>
    <script type="text/javascript">
        var userid = "";
        var selectRow = undefined;
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
            $("#ExtTextBox1").textbox({
                buttonText: "...",
                required: true,
                onClickButton: function () {
                    showPerson();
                }
            });
            //var iRecNo = row.iRecNo;

            $('#pt').datagrid({
                fit: true,
                border: false,
                columns: [[
                    //{ field: 'cc', checkbox: true, width: 30 },
                    { field: 'sCode', title: '工号', width: 100, sortable: true },
                    { field: 'sName', title: '姓名', width: 150, sortable: true }
                ]],
                pagination: true,
                pageSize: 100,
                pageList: [100, 200, 1000],
                remoteSort: false,
                view: groupview,
                groupField: 'sClassID',
                groupFormatter: function (value, rows) {
                    if (rows.length > 0) {
                        return "<span style='font-size:12px; font-weight:bolder;'>" + value + "-" + rows[0].DepartName + "</span> ";
                    }
                    else {
                        return value;
                    }
                },
                toolbar: "#tb",
                onDblClickRow: function (index, row) {
                    selectRow = row;
                    confirmSelect();
                },
                onSelect: function (index, row) {
                    selectRow = row;
                }
            });
            personSearch();
            $("#hidCode").val(userid);
            loadData();
        })
        function loadData() {
            var sqlObj = {
                TableName: "vwSysAgent",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "sCode", ComOprt: "=", Value: "'" + userid + "'"
                }],
                Sorts: [
                    {
                        SortName: "iRecNo", SortOrder: "desc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#table1").datagrid("loadData", result);
        }

        function fnStop(value, row, index) {
            if (row.iDisable == 1) {
                return "<a href='#' onclick='DisableTheAgent(" + row.iRecNo + "," + index + ")'>启用</a>";
            } else {
                return "<a href='#' onclick='DisableTheAgent(" + row.iRecNo + "," + index + ")'>停用</a>";
            }
        }
        function fnDelete(value, row, index) {
            return "<a href='#' onclick='DeleteTheAgent(" + row.iRecNo + "," + index + ")'>删除</a>";
        }

        function DisableTheAgent(iRecNo, index) {
            var iDisabed = $("#table1").datagrid("getRows")[index].iDisabed;
            var text = iDisabed == 1 ? "停用" : "启用";
            $.messager.confirm("确定" + text + "吗？", "确定" + text + "吗？", function (r) {
                if (r) {
                    var jsonobj = {
                        StoreProName: "SpSysAgentOprate",
                        StoreParms: [{
                            ParmName: "@iRecNo",
                            Value: iRecNo
                        }, {
                            ParmName: "@iType",
                            Value: 2
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result != "1") {
                        MessageShow("错误", result);
                    } else {
                        $("#table1").datagrid("updateRow", { index: index, row: { iDisabed: (iDisabed == 1 ? 0 : 1) } });
                    }
                }
            })
        }
        function DeleteTheAgent(iRecNo, index) {
            $.messager.confirm("确定删除吗？", "确定删除吗？", function (r) {
                if (r) {
                    var jsonobj = {
                        StoreProName: "SpSysAgentOprate",
                        StoreParms: [{
                            ParmName: "@iRecNo",
                            Value: iRecNo
                        }, {
                            ParmName: "@iType",
                            Value: 1
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result != "1") {
                        MessageShow("错误", result);
                    }
                    else {
                        $("#table1").datagrid("deleteRow", index);
                    }
                }
            })
        }
        function add() {
            $("#form1").form("reset");
            $("#FieldKeyValue").val("");
            var nextID = getChildID("SysAgent");
            $("#FieldKeyValue").val(nextID);
        }
        function save() {
            if ($("#ExtTextBox1").textbox("getValue") == "") {
                MessageShow("代理人不能为空", "代理人不能为空");
                return;
            }
            var iRecNo = $("#FieldKeyValue").val();
            if (iRecNo == "" || iRecNo == null || iRecNo == undefined) {
                $("#hidInputDate").val(getNowDate() + " " + getNowTime());
                $("#hidCode").val(userid);
                iRecNo = getChildID("SysAgent");
                $("#FieldKeyValue").val(iRecNo);
                var iRecNo = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                if (iRecNo.indexOf("error:") > -1) {
                    MessageShow("失败", iRecNo.substr(6, iRecNo.length - 6));
                }
                else {
                    MessageShow("新增成功", "新增成功");
                    loadData();
                }
            } else {
                var sqlObj = {
                    TableName: "SysAgent",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + $("#FieldKeyValue").val() + "'"
                        }
                    ]
                }
                var OriData = SqlGetData(sqlObj);
                if (OriData.length > 0) {
                    var iRecNo = Form.__update($("#FieldKeyValue").val(), "/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (iRecNo.indexOf("error:") > -1) {
                        MessageShow("失败", iRecNo.substr(6, iRecNo.length - 6));
                    }
                    else {
                        MessageShow("修改成功", "修改成功");
                        loadData();
                    }
                }
                else {
                    $("#hidInputDate").val(getNowDate() + " " + getNowTime());
                    $("#hidCode").val(userid);
                    var iRecNo = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
                    if (iRecNo.indexOf("error:") > -1) {
                        MessageShow("失败", iRecNo.substr(6, iRecNo.length - 6));
                    }
                    else {
                        MessageShow("新增成功", "新增成功");
                        loadData();
                    }
                }
            }

        }
        function fnSelect(index, row) {
            var iRecNo = row.iRecNo;
            var sqlObj = {
                TableName: "vwSysAgent",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo", ComOprt: "=", Value: "'" + iRecNo + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                //$("#form1").form("load", result[0]);
                $("#FieldKeyValue").val(iRecNo);
                $("#hidCode").val(result[0].sCode);
                $("#hidInputDate").val(result[0].sInputDate);
                $("#ExtTextBox1_val").val(result[0].sAgent);
                $("#ExtTextBox1").textbox("setValue", result[0].sAgentName);
                $("#ExtTextBox2").datetimebox("setValue", result[0].sBeginTime);
                $("#ExtTextBox3").datetimebox("setValue", result[0].sEndTime);
                if (result[0].iDisable == 1) {
                    $("#ExtCheckbox1")[0].checked = true;
                } else {
                    $("#ExtCheckbox1")[0].checked = false;
                }
            } else {
                MessageShow("数据不存在", "数据不存在");
            }
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
        function pagerFilter(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    dg.datagrid('loadData', data);
                }
            });
            if (!data.originalRows) {
                data.originalRows = (data.rows);
            }
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }

        function showPerson() {
            $("#divPerson").window("open");
        }
        function winPersonClose() {
            $("#divPerson").window("close");
        }
        function personSearch() {
            var DeptStr = $("#txtDept").val();
            var personStr = $("#txtPerson").val();
            //if (DeptStr == "" && personStr == "") {
            //    return;
            //}
            var filters = [];
            if (DeptStr != "") {
                filters.push(
                    {
                        LeftParenthese: "(",
                        Field: "sClassID",
                        ComOprt: "like",
                        Value: "'%" + DeptStr + "%'",
                        LinkOprt: "or"
                    }
                );
                filters.push(
                    {
                        RightParenthese: ")",
                        Field: "DepartName",
                        ComOprt: "like",
                        Value: "'%" + DeptStr + "%'"
                    }
                );
            }
            if (personStr != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    LeftParenthese: "(",
                    Field: "sCode",
                    ComOprt: "like",
                    Value: "'%" + personStr + "%'",
                    LinkOprt: "or"
                });
                filters.push({
                    RightParenthese: ")",
                    Field: "sName",
                    ComOprt: "like",
                    Value: "'%" + personStr + "%'"
                });
            }
            var personSqlObj = {
                TableName: "View_Yww_bscDataPerson",
                Fields: "sCode,sName,sClassID,DepartName",
                SelectAll: "True",
                Filters: filters,
                Sorts: [
                    {
                        SortName: "sClassID", SortOrder: "asc"
                    }, {
                        SortName: "sCode", SortOrder: "asc"
                    }
                ]
            };
            var resultPerson = SqlGetData(personSqlObj);
            $("#pt").datagrid("loadData", resultPerson);
        }
        function confirmSelect() {
            //var row = $("#pt").datagrid("getSelected");
            if (selectRow) {
                $("#ExtTextBox1").textbox("setValue", selectRow.sName);
                $("#ExtTextBox1_val").val(selectRow.sCode);
                $("#divPerson").window("close");
            }
        }
    </script>
</head>
<body class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',split:true,collapsible:false" style="height: 100px;">
        <div style="height: 30px; background-color: #efefef;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="add()">新增代理人</a>
            &nbsp;&nbsp;
                <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
        </div>
        <div style="padding-top: 10px; padding-left: 20px;">

            <form id="form1" runat="server">
                <input id="TableName" type="hidden" value="SysAgent" />
                <input id="FieldKey" type="hidden" value="iRecNo" />
                <input id="FieldKeyValue" type='hidden' />
                <input id="hidCode" name="sCode" fieldid="sCode" type="hidden" />
                <input id="hidInputDate" name="dInputDate" fieldid="dInputDate" type="hidden" />
                <table>
                    <tr>
                        <td>代理人
                        </td>
                        <td>
                            <input id="ExtTextBox1" class="easyui-textbox" style="width: 150px;" type="text" />
                            <input id="ExtTextBox1_val" type='hidden' fieldid="sAgent" name="sAgent" />
                        </td>
                        <td>开始时间
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldID="dBeginTime" Z_FieldType="时间" runat="server" />
                        </td>
                        <td>结束时间
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox3" Z_FieldID="dEndTime" Z_FieldType="时间" runat="server" />
                        </td>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iDisable" runat="server" />
                            <label for="ExtCheckbox1">停用</label>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
    <div data-options="region:'center',title:'历史记录'">
        <table id="table1" class="easyui-datagrid" data-options="fit:true,border:false,striped:true,pagination:true,rownumbers:true,
            singleSelect:true,pageSize:30,pageList:[30,50,100,200,500,1000,5000],remoteSort:false,showFooter:true,
            onSelect:fnSelect,loadFilter:pagerFilter">
            <thead>
                <tr>
                    <th data-options="field:'sAgentName',width:100">代理人</th>
                    <th data-options="field:'sBeginTime',width:140">开始时间</th>
                    <th data-options="field:'sEndTime',width:140">结束时间</th>
                    <th data-options="field:'sExpired',width:40">超期</th>
                    <th data-options="field:'sInputDate',width:140">设置时间</th>
                    <%--<th data-options="field:'_stop',width:80,formatter:fnStop">停用</th>--%>
                    <th data-options="field:'_delete',width:80,formatter:fnDelete">删除</th>
                    <th data-options="field:'sBeginTimeShow',hidden:true"></th>
                    <th data-options="field:'sEndTimeShow',hidden:true"></th>
                    <th data-options="field:'iRecNo',hidden:true"></th>
                </tr>
            </thead>
        </table>
    </div>

    <div id="divPerson" class="easyui-window" title="人员选择" style="width: 550px; height: 500px; overflow-x: hidden;"
        data-options="iconCls:'icon-save',modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:true,closed:true">
        <table id="pt">
        </table>
    </div>
    <div id="tb">
        <table style="font-size: 12px;">
            <tr>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true"
                        onclick="confirmSelect()">确认选择 </a>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true"
                        onclick="winPersonClose()">取消 </a>
                </td>
                <td>部门：<input id="txtDept" style="width: 100px; border: none; border-bottom: solid 1px #efefef;"
                    type="text" />
                </td>
                <td>人员：<input id="txtPerson" style="width: 100px; border: none; border-bottom: solid 1px #efefef;"
                    type="text" />
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true"
                        onclick="personSearch()">搜索 </a>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
