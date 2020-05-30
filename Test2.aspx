<!DOCTYPE html>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>联合报表
    </title>
    <link href="/Base/JS/easyui1.7.3/themes/gray/easyui.css?r=1" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui1.7.3/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui1.7.3/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui1.7.3/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui1.7.3/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="Base/JS2/datagrid-cellediting.js"></script>
    <script type="text/javascript">
        var data = [];
        var rowCount = 2000;
        //for (var i = 0; i < rowCount; i++) {
        //    var row = {
        //        a: "aaaaaa" + i,
        //        b: "bbbbbb" + i,
        //        c: "cccccc" + i,
        //        d: "dddddd" + i,
        //        e: "eeeeee" + i,
        //        f: "ffffff" + i,
        //        g: "gggggg" + i,
        //        h: "hhhhhh" + i,
        //        i: "iiiiii" + i,
        //        j: "jjjjjj" + i,
        //    }
        //    data.push(row);
        //}

        $(function () {
            $("#tab").datagrid({
                //fit: Page.Children.fit,
                border: false,
                showFooter: true,
                //url: '/Base/Handler/getDataList2.ashx',
                //queryParams: { otype: 'childTable', iformid: '8023', tableName: 'MMStockProductCheckD', key: 1174 },
                onLoadError: function (result) {
                },
                onLoadSuccess: function (data) {

                },
                columns: [[{ field: '__cb', checkbox: true, width: 30 },
                    {
                        field: 'iSerial', align: 'center', title: '序号', editor: { type: 'numberbox', options: { precision: 0, height: 25 } }
                        //
                        , width: 40
                    },
                    {
                        field: 'sCode', align: 'center', title: '产品编号', editor: { type: 'textbox', options: { height: 25 } }
                        //,
                        //lookupOptions: [{
                        //    lookupName: 'bscDataMatProduct', uniqueid: '1580', condition: undefined, fields: '*', searchFields: '*',
                        //    matchFields: ['sCode=sCode', 'sName=sName', 'fProductWidth=fProductWidth', 'fProductWeight=fProductWeight', 'iBscDataMatRecNo=iRecNo'], isMulti: false, editable: true, fixFilters: "iMatType=2 and (sCode like '%{this}%' or sName like '%{this}%')", nofixFilters: "1=1", pageSize: 20, loadFilters: undefined, width: 900, height: 400, onBeforeOpen: undefined, onAfterSelected: undefined
                        //}]
                        , width: 100
                    },
                    {
                        field: 'sName', align: 'center', title: '产品名称'
                        //,
                        //styler: function (value, row, index) { return 'background-color:#ffffaa;' }
                        , width: 100
                    },
                    {
                        field: 'sSerial', align: 'center', title: '序列号',
                        editor: { type: 'textbox', options: { height: 25 } },
                        width: 50
                    },
                    {
                        field: 'sOrderNo', align: 'center', title: '盘点订单',
                        //styler: function (value, row, index) { return 'background-color:#ffffaa;' },
                        width: 100
                    },
                    {
                        field: 'sColorID', align: 'center', title: '色号', editor: { type: 'textbox', options: { height: 25 } },
                        //lookupOptions: [{
                        //    lookupName: 'bscDataColor3', uniqueid: '1582', condition: undefined, fields: '*', searchFields: '*', matchFields: ['sColorID=sColorID', 'sColorName=sColorName', 'iBscDataColorRecNo=iRecNo'], isMulti: false, editable: true, fixFilters: "(sColorID like '%{this}%' or sColorName like '%{this}%')", nofixFilters: "1=1", pageSize: 20, loadFilters: undefined, width: 900, height: 400, onBeforeOpen: undefined, onAfterSelected: undefined
                        //}],
                        width: 100
                    },
                    {
                        field: 'sColorName', align: 'center', title: '颜色',
                        //styler: function (value, row, index) { return 'background-color:#ffffaa;' },
                        width: 100
                    },
                    {
                        field: 'fProductWidth', align: 'center', title: '<span style=color:red>幅宽*</span>',
                        //editor: { type: 'numberbox', options: { precision: 0, height: 25 } },
                        //formatter: function (value, row, index) { if (isNaN(parseFloat(value)) == false) return parseFloat(value).toFixed(0); },
                        width: 80
                    },
                {
                    field: 'fProductWeight', align: 'center', title: '<span style=color:red>克重*</span>',
                    //editor: { type: 'numberbox', options: { precision: 0, height: 25 } },
                    //formatter: function (value, row, index) { if (isNaN(parseFloat(value)) == false) return parseFloat(value).toFixed(0); },
                    width: 100
                },
                {
                    field: 'iStockQty', align: 'center', title: '库存匹数',
                    //styler: function (value, row, index) { return 'background-color:#ffffaa;' },
                    width: 100
                },
                {
                    field: 'fStockQty', align: 'center', title: '库存米数',
                    width: 60
                },
                {
                    field: 'fStockPurQty', align: 'center', title: '库存重量',width: 60
                }, {
                    field: 'fStockLetCode', align: 'center', title: '库存码数',width: 60
                }
                ]],
                toolbar: "#divMenu",
                onEndEdit: function (index, row, changes) {
                    for (var key in changes) {
                        alert(changes[key]);
                    }
                }
            });

            $("#tab").datagrid("enableCellEditing");
            $("#tab").datagrid("appendRow", { sCode: "abc", sName: "aadfa" });
            $("#tab").datagrid("appendRow", { sCode: "abc", sName: "aadfa" });
            $("#tab").datagrid("appendRow", { sCode: "abc", sName: "aadfa" });
        })

        function addRow() {
            $("#tab").datagrid("appendRow", {});
            var cell = $("#tab").datagrid("cell");
        }
        function daoRow(i) {
            var cell = $("#tab").datagrid("cell");
            $("#tab").datagrid("endEdit", cell.index);
        }
    </script>

</head>
<body class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',border:false">
    </div>
    <div data-options="region:'center',border:false">
        <div class="easyui-tabs" data-options="border:false">
            <div title="明细">
                <table id="tab"></table>
                <%--<table id="tab" class="easyui-datagrid" data-options="singleSelect:true,toolbar:'#divMenu',
                    url: '/Base/Handler/getDataList2.ashx',
                    queryParams: { otype: 'childTable', iformid: '8023', tableName: 'MMStockProductCheckD', key: 1181 },">
                    <thead>
                        <tr>
                            <th data-options="field:'a',width:100">编码</th>
                            <th data-options="field:'b',width:100">名称</th>
                            <th data-options="field:'c',width:100">习性</th>
                            <th data-options="field:'d',width:100">下对方</th>
                            <th data-options="field:'e',width:100">阿斯蒂芬</th>
                            <th data-options="field:'f',width:100">啊啊</th>
                            <th data-options="field:'g',width:100">啊啊</th>
                            <th data-options="field:'h',width:100">3大师傅</th>
                            <th data-options="field:'i',width:100">阿斯顿</th>
                            <th data-options="field:'j',width:100">啊啊</th>

                        </tr>
                    </thead>
                </table>--%>
            </div>
        </div>
    </div>
    <div id="divMenu">
        <table>
            <tr>
                <td>
                    <a id="btnAdd" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addRow()">增加行</a>
                </td>
                <td>
                    <a id="btnRemove" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="removeRow()">删除行</a>
                </td>
                <td>
                    <a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="daoRow(300)">载入300条数据</a>
                </td>
                <td>
                    <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="daoRow(1000)">载入1000条数据</a>
                </td>
                <td>
                    <a id="btn3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="daoRow(2000)">载入2000条数据</a>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
