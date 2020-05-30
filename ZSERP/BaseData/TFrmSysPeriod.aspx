<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>会计期间</title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        .txb {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var iRecNo = "";
        var griddata = "";
        $(function () {
            var ScreenWidth = window.screen.width;
            if (ScreenWidth == "1440") {
                $('#aa').layout('panel', 'south').panel('resize', { height: 545 });
                $('#aa').layout('resize');
            }
            //初始化下拉框
            var myDate = new Date();
            var Year = myDate.getFullYear();
            var option = "<select id='Years' data-options='editable:false' fieldid='iYear' class='easyui-combobox' style='width: 150px'>";
            option += "<option value=''></option>";
            for (var i = Year - 5; i < Year + 15; i++) {
                option += "<option value='" + i + "'>" + i + "年</option>";
            }
            option += "</select>";
            $('#iYear').html(option);
            $.parser.parse('#iYear');
            //获取信息
            var sqlgrid = "select [iRecNo],[sYearMonth],[iYear],[sMonth],[dBeginDate]=convert(varchar(10),dBeginDate,23),[dEndDate]=convert(varchar(10),dEndDate,23),[sReMark],[sUserid],[dInputDate] from bscDataPeriod order by sYearMonth desc"
            griddata = SqlGetDataGridComm(sqlgrid);
            //初始化列表
            $("#maingrid").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                singleSelect: true,
                data: griddata.Rows,
                columns: [[
                        { field: "sYearMonth", title: "会计月份", width: 150, sortable: true },
                        { field: "iYear", title: "会计年", width: 150, sortable: true },
                        { field: "sMonth", title: "会计月", width: 150, sortable: true },
                        { field: "dBeginDate", title: "开始日期", width: 150, sortable: true },
                        { field: "dEndDate", title: "截止日期", width: 150, sortable: true }
                ]],
                onClickRow: function (index, row) {
                    $('#Years').combobox('setValue', griddata.Rows[index].iYear);
                    $('#sMonth').combobox('setValue', griddata.Rows[index].sMonth);
                    $('#sYearMonth').val(griddata.Rows[index].sYearMonth);
                    $('#dBeginDate').datebox('setValue', griddata.Rows[index].dBeginDate);
                    $('#dEndDate').datebox('setValue', griddata.Rows[index].dEndDate);
                    iRecNo = griddata.Rows[index].iRecNo;
                }
            });
        })

        function add() {
            $('#Years').combobox('setValue', "");
            $('#sMonth').combobox('setValue', "");
            $('#sYearMonth').val("0");
            $('#dBeginDate').datebox('setValue', "");
            $('#dEndDate').datebox('setValue', "");
            $('#sYearMonth').focus();
            iRecNo = "";
        }

        function Delete() {
            var sqlexists = "if exists(select 1 from bscDataPeriod where iRecNo=" + iRecNo + ")begin select 1 as r end else begin select 0 as r end";
            var sqlexistsdata = SqlGetDataComm(sqlexists);
            if (sqlexistsdata[0].r == "1") {
                $.messager.confirm("操作提示", "确认删除所选择分类？", function (data) {
                    if (data) {
                        var sql = "delete from bscDataPeriod where iRecNo=" + iRecNo;
                        var result = SqlExecComm(sql);
                        if (result != "1") {
                            $.messager.show({
                                title: '删除数据失败!',
                                msg: result,
                                showType: 'show',
                                timeout: 1000,
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                        }
                        else {
                            var sqlgrid = "select [iRecNo],[sYearMonth],[iYear],[sMonth],[dBeginDate]=convert(varchar(10),dBeginDate,23),[dEndDate]=convert(varchar(10),dEndDate,23),[sReMark],[sUserid],[dInputDate] from bscDataPeriod order by sYearMonth desc"
                            griddata = SqlGetDataGridComm(sqlgrid);
                            $("#maingrid").datagrid({ data: griddata.Rows });
                            add();
                        }
                    }
                });
            }
            else {
                alert("新增状态删除无效！");
            }
        }

        function save() {
            var year = $('#Years').combobox('getValue');
            var month = $('#sMonth').combobox('getValue');
            if (year != "" && month != "") {
                $('#sYearMonth').val(year + "-" + month);
                if (iRecNo == "") {
                    var jsonobj = {
                        StoreProName: "SpGetIden",
                        StoreParms: [{
                            ParmName: "@sTableName",
                            Value: "bscDataPeriod"
                        }]
                    }
                    Result = SqlStoreProce(jsonobj);
                    if (Result && Result.length > 0 && Result != "0") {
                        $('#TableName').val("bscDataPeriod");
                        $('#FieldKey').val("iRecNo");
                        $('#FieldKeyValue').val(Result);
                        var aa = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                        if (aa.indexOf('error') > 0) {
                            {
                                $.messager.show({
                                    title: '保存失败',
                                    msg: aa,
                                    showType: 'show',
                                    timeout: 1000,
                                    style: {
                                        right: '',
                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                                        bottom: ''
                                    }
                                });
                            }
                        }
                        else {
                            var sqlgrid = "select [iRecNo],[sYearMonth],[iYear],[sMonth],[dBeginDate]=convert(varchar(10),dBeginDate,101),[dEndDate]=convert(varchar(10),dEndDate,101),[sReMark],[sUserid],[dInputDate] from bscDataPeriod order by sYearMonth desc"
                            griddata = SqlGetDataGridComm(sqlgrid);
                            $("#maingrid").datagrid({ data: griddata.Rows });
                            $.messager.show({
                                title: 'OK!',
                                msg: "保存成功",
                                showType: 'show',
                                timeout: 1000,
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                        }
                    }
                }
                else {
                    $('#TableName').val("bscDataPeriod");
                    $('#FieldKey').val("iRecNo");
                    $('#FieldKeyValue').val(iRecNo);
                    var bb = Form.__update(iRecNo, "/Base/Handler/DataOperatorNew.ashx")
                    if (bb.indexOf('error') > 0) {
                        {
                            $.messager.show({
                                title: '保存失败',
                                msg: bb,
                                showType: 'show',
                                timeout: 1000,
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                        }
                    }
                    else {
                        var sqlgrid = "select [iRecNo],[sYearMonth],[iYear],[sMonth],[dBeginDate]=convert(varchar(10),dBeginDate,101),[dEndDate]=convert(varchar(10),dEndDate,101),[sReMark],[sUserid],[dInputDate] from bscDataPeriod order by sYearMonth desc"
                        griddata = SqlGetDataGridComm(sqlgrid);
                        $("#maingrid").datagrid({ data: griddata.Rows });
                        $.messager.show({
                            title: 'OK!',
                            msg: "保存成功",
                            showType: 'show',
                            timeout: 1000,
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                    }
                }
            }
            else {
                $.messager.show({
                    title: '提示',
                    msg: '会计年或者会计月不能为空！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
        }

        function back() {
            window.parent.closeTab();
        }
    </script>
</head>
<body class="easyui-layout" id="aa">
    <form id="ff" method="post" runat="server" style="height: 700px">
        <asp:HiddenField ID="TableName" runat="server" />
        <!--要保存的表名-->
        <asp:HiddenField ID="FieldKey" runat="server" />
        <!--表的主键字段-->
        <asp:HiddenField ID="FieldKeyValue" runat="server" />
        <!--表的主键值-->
        <div data-options="region:'north',title:'',border:false" style="height: 170px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north'" style="height:30px;background: #efefef; padding: 0px;" >
                    <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'"
                        onclick='add()'>新增</a>&nbsp;<a href='javascript:void(0)' class="easyui-linkbutton"
                            data-options="plain:true,iconCls:'icon-remove'" onclick='Delete()'>删除</a>&nbsp;<a
                                href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'"
                                onclick='save()'>保存</a>&nbsp;|&nbsp;<a href='javascript:void(0)' class="easyui-linkbutton"
                                    data-options="plain:true,iconCls:'icon-undo'" onclick='back()'>退出</a>
                </div>
                <div data-options="region:'center',border:false">
                    <table class="tab" style="margin-left: 10px;">
                        <tr>
                            <td>会计期间
                            </td>
                            <td>
                                <input id="sYearMonth" type="text" fieldid="sYearMonth" class="txb" style="width: 150px; background-color: #FFFF99;"
                                    readonly="readonly" value="0" />
                            </td>
                        </tr>
                        <tr>
                            <td>会计年
                            </td>
                            <td id="iYear"></td>
                            <td>会计月
                            </td>
                            <td>
                                <select id="sMonth" data-options="editable:false" fieldid="sMonth" class="easyui-combobox"
                                    style="width: 150px">
                                    <option value=""></option>
                                    <option value="01">1月</option>
                                    <option value="02">2月</option>
                                    <option value="03">3月</option>
                                    <option value="04">4月</option>
                                    <option value="05">5月</option>
                                    <option value="06">6月</option>
                                    <option value="07">7月</option>
                                    <option value="08">8月</option>
                                    <option value="09">9月</option>
                                    <option value="10">10月</option>
                                    <option value="11">11月</option>
                                    <option value="12">12月</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>开始日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="dBeginDate" runat="server" Z_FieldID="dBeginDate" Z_FieldType="日期" />
                            </td>
                            <td>结束日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="dEndDate" runat="server" Z_FieldID="dEndDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center',collapsible:false" style="height: 360px; background: #eee;">
            <table id="maingrid">
            </table>
        </div>
    </form>
</body>
</html>
