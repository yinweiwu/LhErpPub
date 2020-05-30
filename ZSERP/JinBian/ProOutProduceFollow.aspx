<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">

        $(function () {
            var ThisRows = "";
            var editor = "";
            var user = Page.userid;
            $("#__save").hide();
            $("#__saveAndContinue").hide();
            /* Page.Children.toolBarBtnAdd("table2", "send", "坯布仓发出", "tool", function () {
            window.open("/ZSERP/Jinbian/MMStockOutM.aspx?iBillType=1&iformid=3007&usetype=add&sProcessesName=" + ThisRows.sProcessesName + "&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo = " + ThisRows.iBscDataMatFabRecNo + "&iSdOrderMRecNo = " + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'height=600,width=1150,top=(window.screen.availHeight-30-iHeight)/2,left=(window.screen.availWidth-10-iWidth)/2,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
            });
            Page.Children.toolBarBtnAdd("table2", "productsend", "成品仓发出", "tool", function () {
            window.open("/ZSERP/Jinbian/MMStockProductOutM_OutProduce.aspx?iBillType=4&iformid=8033&usetype=add&fProductWeight=" + ThisRows.fProductWeight + "&fProductWidth=" + ThisRows.fProductWidth + "&iBscDataColorRecNo=" + ThisRows.iBscDataColorRecNo + "&sProcessesName=" + ThisRows.sProcessesName + "&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo = " + ThisRows.iBscDataMatRecNo + "&iSdOrderMRecNo = " + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'height=600,width=1150,top=(window.screen.availHeight-30-iHeight)/2,left=(window.screen.availWidth-10-iWidth)/2,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
            });
            Page.Children.toolBarBtnAdd("table2", "receive", "坯布仓接收", "tool", function () {
            window.open("/ZSERP/Jinbian/MMStockIn_Out.aspx?iBillType=0&iformid=9091&usetype=add&sProcessesName=" + ThisRows.sProcessesName + "&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo = " + ThisRows.iBscDataMatFabRecNo + "&iSdOrderMRecNo = " + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'height=600,width=1150,top=(window.screen.availHeight-30-iHeight)/2,left=(window.screen.availWidth-10-iWidth)/2,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
            });
            Page.Children.toolBarBtnAdd("table2", "productreceive", "成品仓接收", "tool", function () {
            window.open("/ZSERP/Jinbian/MMStockProductInM_OutProduce.aspx?iBillType=4&iformid=8032&sProcessesName=" + ThisRows.sProcessesName + "&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&usetype=add&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo = " + ThisRows.iBscDataMatRecNo + "&iSdOrderMRecNo = " + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'height=600,width=1150,top=(window.screen.availHeight-30-iHeight)/2,left=(window.screen.availWidth-10-iWidth)/2,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
            });*/
            $("#table2").datagrid({
                autoRowHeight: false,
                toolbar: [{
                    id: 'send',
                    text: '坯布仓发出',
                    iconCls: 'icon-import',
                    handler: function () {
                        if (ThisRows.iProcessOrderDRecNo)
                            window.open("/ZSERP/Jinbian/MMStockOutM.aspx?iBillType=1&iformid=3007&usetype=add&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo=" + ThisRows.iBscDataMatFabRecNo + "&iSdOrderMRecNo=" + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
                    }
                }, {
                    id: 'productsend',
                    text: '成品仓发出',
                    iconCls: 'icon-import',
                    handler: function () {
                        if (ThisRows.iProcessOrderDRecNo)
                            window.open("/ZSERP/Jinbian/MMStockProductOutM_OutProduce.aspx?iBillType=4&iformid=8033&usetype=add&fProductWeight=" + ThisRows.fProductWeight + "&fProductWidth=" + ThisRows.fProductWidth + "&iBscDataColorRecNo=" + ThisRows.iBscDataColorRecNo + "&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo=" + ThisRows.iBscDataMatRecNo + "&iSdOrderMRecNo=" + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
                    }
                }, {
                    id: 'receive',
                    text: '坯布仓接收',
                    iconCls: 'icon-import',
                    handler: function () {
                        if (ThisRows.iProcessOrderDRecNo)
                            window.open("/ZSERP/Jinbian/MMStockIn_Out.aspx?iBillType=0&iformid=9091&usetype=add&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo=" + ThisRows.iBscDataMatFabRecNo + "&iSdOrderMRecNo=" + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
                    }
                }, {
                    id: 'productreceive',
                    text: '成品仓接收',
                    iconCls: 'icon-import',
                    handler: function () {
                        if (ThisRows.iProcessOrderDRecNo)
                            window.open("/ZSERP/Jinbian/MMStockProductInM_OutProduce.aspx?iBillType=4&iformid=8032&iBscDataProcessMRecNo=" + ThisRows.iBscDataProcessMRecNo + "&usetype=add&savetype=producefollow&iBscDataCustomerRecNo=" + ThisRows.iBscDataCustomerRecNo + "&iBscDataMatRecNo=" + ThisRows.iBscDataMatRecNo + "&iSdOrderMRecNo=" + ThisRows.iSdOrderMRecNo + "&iProcessOrderDRecNo=" + ThisRows.iProcessOrderDRecNo + "&r=" + Math.random() + "", 'newwindow', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
                    }
                }, {
                    id: 'refresh',
                    text: '刷新',
                    iconCls: 'icon-reload',
                    handler: function () {
                        if (ThisRows != "") {
                            $("#table2").datagrid("loadData", []);
                            var jsonobj = {
                                StoreProName: "SpProcessOrderDFollowD",
                                StoreParms: [{
                                    ParmName: "@iProcessOrderDRecNo",
                                    Value: ThisRows.iProcessOrderDRecNo
                                }]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result.length > 0) {
                                for (var i = 0; i < result.length; i++) {
                                    result[i].fOutQty = result[i].sOutUnitID == "1" ? result[i].fOutPurQty + "米" : result[i].sOutUnitID == "2" ? result[i].sOutLetCode + "码" : result[i].fOutQty + "KG";
                                    result[i].fFeedQty = result[i].sFeedUnitID == "1" ? result[i].fFeedPurQty + "米" : result[i].sFeedUnitID == "2" ? result[i].sFeedLetCode + "码" : result[i].fFeedQty + "KG";
                                    result[i].fInQty = result[i].sInUnitID == "1" ? result[i].fInPurQty + "米" : result[i].sInUnitID == "2" ? result[i].sInLetCode + "码" : result[i].fInQty + "KG";
                                }
                                $("#table2").datagrid("loadData", result);
                            }
                        }
                    }
                }],
                nowrap: true,
                pageSize: 6,
                pageList: [6, 12, 18, 25],
                rownumbers: true,
                pagination: true,
                fit: true,
                border: false,
                striped: true,
                remoteSort: false,
                columns: [[
                        { title: "日期", field: "dDate", width: 110, sortable: true, rowspan: 2 },
                        { title: "发出", colspan: 2 },
                        { title: "投入", colspan: 2 },
                        { title: "接收(加工后)", colspan: 2}], [
                        { title: "批号", field: "sOutBatchNo", width: 110, rowspan: 1 },
                        { title: "数量", field: "fOutQty", width: 120, rowspan: 1 },
                        { title: "批号", field: "sFeedBatchNo", width: 120, rowspan: 1 },
                        { title: "数量", field: "fFeedQty", width: 80, rowspan: 1 },
                        { title: "批号", field: "sInBatchNo", width: 80, rowspan: 1 },
                        { title: "数量", field: "fInQty", width: 80, rowspan: 1 },
                        { field: "sOutUnitID", width: 90, hidden: true },
                        { field: "sFeedUnitID", width: 90, hidden: true },
                        { field: "sInUnitID", width: 90, hidden: true }
                    ]], loadFilter: function (data) {
                        return pagerFilter2(data);    //自定义过滤方法         
                    }
            });

            $('.datagrid-header:last').find('tr').css({
                "height": "18px"
            });

            Page.Children.toolBarBtnRemove("table1", "add");
            Page.Children.toolBarBtnRemove("table1", "delete");
            Page.Children.toolBarBtnRemove("table1", "copy");
            Page.Children.toolBarBtnRemove("table1", "export");

            $('#table1').datagrid({
                onSelect: function (index, row) {
                    ThisRows = row;
                    //                    $("#table2").datagrid("loadData", []);
                    //                    var jsonobj = {
                    //                        StoreProName: "SpProcessOrderDFollowD",
                    //                        StoreParms: [{
                    //                            ParmName: "@iProcessOrderDRecNo",
                    //                            Value: row.iProcessOrderDRecNo
                    //                        }]
                    //                    }
                    //                    var result = SqlStoreProce(jsonobj);
                    //                    if (result.length > 0) {
                    //                        for (var i = 0; i < result.length; i++) {
                    //                            result[i].fOutQty = result[i].sOutUnitID == "1" ? result[i].fOutPurQty + "米" : result[i].sOutUnitID == "2" ? result[i].sOutLetCode + "码" : result[i].fOutQty + "KG";
                    //                            result[i].fFeedQty = result[i].sFeedUnitID == "1" ? result[i].fFeedPurQty + "米" : result[i].sFeedUnitID == "2" ? result[i].sFeedLetCode + "码" : result[i].fFeedQty + "KG";
                    //                            result[i].fInQty = result[i].sInUnitID == "1" ? result[i].fInPurQty + "米" : result[i].sInUnitID == "2" ? result[i].sInLetCode + "码" : result[i].fInQty + "KG";
                    //                        }
                    //                        $("#table2").datagrid("loadData", result);
                    //                    }
                },
                singleSelect: true,
                width: 400,
                height: 'auto',
                nowrap: true,
                pageSize: 6,
                pageList: [6, 12, 18, 25],
                rownumbers: true,
                pagination: true,
                fit: true,
                border: false,
                striped: true,
                loadFilter: function (data) {
                    return pagerFilter(data);
                }
            });
            var options = $("#table1").datagrid("options");
            options.columns[0].splice(0, 1);
            var _cbTd = $("[field='__cb']");
            _cbTd.hide();
            Page.Children.onBeforeEdit = function (tableid, index, row) {
                if (tableid == 'table1') {
                    return false;
                }
            }
        })
        function pagerFilter2(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $('#table2');
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
        function pagerFilter(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $('#table1');
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
        function ToSearchUnFinish() {
            var iBscDataProcessMRecNo1 = Page.getFieldValue('iBscDataProcessMRecNo1');
            var bb = {};
            if (iBscDataProcessMRecNo1 == '') {
                bb= {
                    Field: "1",
                    ComOprt: "=",
                    Value: "1",
                    LinkOprt: "and"
                }
            } else {
                bb= {
                    Field: "isnull(iBscDataProcessMRecNo,0)",
                    ComOprt: "=",
                    Value: iBscDataProcessMRecNo1,
                    LinkOprt: "and"
                }
            }
//            if (iBscDataProcessMRecNo1 == "") {
//                $.messager.show({
//                    title: '提示',
//                    msg: '加工工序不能为空！',
//                    timeout: 1000,
//                    showType: 'show',
//                    style: {
//                        right: '',
//                        top: document.body.scrollTop + document.documentElement.scrollTop,
//                        bottom: ''
//                    }
//                });
//                return false;
//            }
            var iBscDataCustomerRecNo1 = Page.getFieldValue('iBscDataCustomerRecNo1');
            var dDate1 = Page.getFieldValue('dDate1') == "" ? "1990-01-01" : Page.getFieldValue('dDate1');
            var dDate2 = Page.getFieldValue('dDate2') == "" ? "2990-01-01" : Page.getFieldValue('dDate2');
            var aa = {};
            if (iBscDataCustomerRecNo1 == '') {
                aa = {
                    Field: "iBscDataCustomerRecNo",
                    ComOprt: "like",
                    Value: "'%" + "%'",
                    LinkOprt: "and"
                }
            } else {
                aa = {
                    Field: "iBscDataCustomerRecNo",
                    ComOprt: "=",
                    Value: "'" + iBscDataCustomerRecNo1 + "'",
                    LinkOprt: "and"
                }
            }
            var sqlObj = {
                TableName: "vwProcessOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt: "and"
                    },
                    {
                        LeftParenthese: "(",
                        Field: "isnull(fNoReceiveQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        LinkOprt: "or"
                    },
                    {
                        Field: "isnull(fNoReceivePurQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        RightParenthese: ")",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iFinish,0)",
                        ComOprt: "=",
                        Value: 0,
                        LinkOprt: "and"
                    },
                    bb,
                    aa,
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'"
                    }
                    ],
                Sorts: [
                {
                    SortName: "dDate",
                    SortOrder: "asc"
                }]
            };
            var result = SqlGetData(sqlObj);
            $("#table1").datagrid('loadData', result);
        }
        function ToSearchAll() {
            var iBscDataProcessMRecNo1 = Page.getFieldValue('iBscDataProcessMRecNo1');
            if (iBscDataProcessMRecNo1 == "") {
                $.messager.show({
                    title: '提示',
                    msg: '加工工序不能为空！',
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
            var iBscDataCustomerRecNo1 = Page.getFieldValue('iBscDataCustomerRecNo1');
            var aa = {};
            if (iBscDataCustomerRecNo1 == '') {
                aa = {
                    Field: "iBscDataCustomerRecNo1",
                    ComOprt: "like",
                    Value: "'%" + "%'",
                    LinkOprt: "and"
                }
            } else {
                aa = {
                    Field: "iBscDataCustomerRecNo1",
                    ComOprt: "=",
                    Value: "'" + iBscDataCustomerRecNo1 + "'",
                    LinkOprt: "and"
                }
            }
            var dDate1 = Page.getFieldValue('dDate1') == "" ? "1990-01-01" : Page.getFieldValue('dDate1');
            var dDate2 = Page.getFieldValue('dDate2') == "" ? "2990-01-01" : Page.getFieldValue('dDate2');

            var sqlObj = {
                TableName: "vwProcessOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iBscDataProcessMRecNo,0)",
                        ComOprt: "=",
                        Value: iBscDataProcessMRecNo1,
                        LinkOprt: "and"
                    },
                    aa,
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'"
                    }
                    ],
                Sorts: [
                {
                    SortName: "dDate",
                    SortOrder: "asc"
                }]
            };
            var result = SqlGetData(sqlObj);
            $("#table1").datagrid('loadData', result);
        }
        function toFinish() {
         
            var getRows = $('#table1').datagrid('getChecked');
            
            if (getRows.length > 0) {
            $.messager.confirm("确认吗？", "您确认完成/取消完成吗？", function (r) {
                if (r) {
                for (var i = 0; i < getRows.length; i++) {
                    var jsonobj = {
                        StoreProName: "SpFinish",
                        StoreParms: [{
                            ParmName: "@iformid",
                            Value: 4
                        },
                            {
                                ParmName: "@iRecNo",
                                Value: getRows[i].iProcessOrderDRecNo
                            },
                            {
                                ParmName: "@sUserID",
                                Value: getRows[i].sUserID
                            }]
                    }
                    var Result = SqlStoreProce(jsonobj);
                    if (Result != "1") {
                        $.messager.show({
                            title: '提示',
                            msg: Result,
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                    }
                    else {
                        $.messager.alert("成功", "已完成！");
                        ToSearchUnFinish();
                    }
                }
                }
                });
            } else {
                alert("未选择行");
            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="div1" class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north'" style="overflow: hidden; height: 65px">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <div style="float: left; width: 80%;">
                            <table>
                                <tr>
                                    <td>
                                        加工工序
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBscDataProcessMRecNo1"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        加工商
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iBscDataCustomerRecNo1"
                                            Z_NoSave="True" />
                                    </td>
                                    
                                    <td>
                                        日期从
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldType="日期" Z_FieldID="dDate1"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        至
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldType="日期" Z_FieldID="dDate2"
                                            Z_NoSave="True" />
                                    </td>
                                    <td>
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='ToSearchUnFinish()'>查询</a><%-- <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='ToSearchAll()'>查询全部</a> --%>
                                    </td>
                                    <td>
                                         <a href='javascript:void(0)'
                                                    class="easyui-linkbutton" data-options="iconCls:'icon-finishWork'" onclick='toFinish()'>
                                                    完成</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
        <div data-options="region:'center',split:true" style="overflow: hidden;">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <%--<div data-options="fit:true" title="加工订单">--%>
                    <table id="table1" tablename="vwProcessOrderMD">
                    </table>
                <%--</div>--%>
            </div>
        </div>
        <div data-options="region:'south',split:true" style="height: 300px;">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="发出/接受">
                    <table id="table2">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>