<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/datagridExtend.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $.extend($.fn.datagrid.methods, {
            editCell: function (jq, param) {
                return jq.each(function () {
                    //var opts = $(this).datagrid('options');
                    var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
                    for (var i = 0; i < fields.length; i++) {
                        var col = $(this).datagrid('getColumnOption', fields[i]);
                        col.editor1 = col.editor;
                        if (fields[i] != param.field) {
                            col.editor = null;
                        }
                    }
                    $(this).datagrid('beginEdit', param.index);
                    for (var i = 0; i < fields.length; i++) {
                        var col = $(this).datagrid('getColumnOption', fields[i]);
                        col.editor = col.editor1;
                    }
                });
            }
        });
        $.extend($.fn.datagrid.defaults.editors, {
            mytextarea: {
                init: function (container, options) {
                    var input = $("<textarea style='" + options.style + "'></textarea>").appendTo(container);
                    return input;
                },
                getValue: function (target) {
                    return $(target).val();
                },
                setValue: function (target, value) {
                    $(target).val(value);
                },
                resize: function (target, width) {
                    var textarea = $(target);
                    if ($.boxModel == true) {
                        textarea.width(width - (input.outerWidth() - input.width()));
                    } else {
                        textarea.width(width);
                    }
                }
            }
        });
        $(function () {
            //订单主表
            $("#tabSDContractM").datagrid(
            {
                columns: [
                    [
                        { field: "__ckb", checkbox: true, width: 40 },
                        { field: "sOrderNo", title: "订单号", width: 100, align: "center", sortable: true },
                        { field: "sContractNo", title: "客户订单号", width: 100, align: "center", sortable: true },
                        { field: "sCustShortName", title: "客户简称", width: 100, align: "center", sortable: true },
                        { field: "sDate", title: "签单日期", width: 100, align: "center", sortable: true },
                        { field: "sSaleUnitName", title: "销售单位", width: 80, align: "center", sortable: true },
                        { field: "sPlanFinish", title: "计划完成", width: 80, align: "center", sortable: true },
                        { field: "iRecNo", hidden: true }
                    ]
                ],
                toolbar: "#divSDContractMMenu",
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: true,
                onDblClickRow: searchSDContractD,
                fit: true,
                border: false,
                checkOnSelect: false
            });
            $("#tabSDContractD").datagrid(
            {
                columns: [
                    [
                        { field: "__ckb", checkbox: true, width: 40 },
                        { field: "sCode", title: "产品编号", width: 100, align: "center", sortable: true },
                        { field: "sColorID", title: "色号", width: 80, align: "center", sortable: true },
                        { field: "fQty", title: "数量", width: 60, align: "center", sortable: true },
                        { field: "sFlowerTypeID", title: "花型号", width: 80, align: "center", sortable: true },
                        { field: "sColorName", title: "颜色名称", width: 80, align: "center", sortable: true },
                        { field: "sName", title: "产品名称", width: 80, align: "center", sortable: true },
                        { field: "sFlowerType", title: "花型", width: 60, align: "center", sortable: true },
                        { field: "fProductWidth", title: "幅宽", width: 60, align: "center", sortable: true },
                        { field: "fProductWeight", title: "克重", width: 60, align: "center", sortable: true },
                        { field: "iRecNo", hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true }
                    ]
                ],
                //toolbar: "#divSDContractMMenu",
                striped: true,
                rownumbers: true,
                singleSelect: true,
                //remoteSort: true,
                onDblClickRow: searchSDContractDPlanD,
                fit: true,
                border: false,
                checkOnSelect: false
            });
            $("#tabSDContractDPlanD").treegrid(
                {
                    fit: true,
                    border: false,
                    idField: "iBscDataMatRecNo",
                    treeField: "sCode",
                    columns: [
                        [
                            { field: "sCode", title: "产品编号", width: 100, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }, rowspan: 2
                            },
                            { field: "sName", title: "名称", width: 80, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }, rowspan: 2
                            },
                            { field: "sProcessesName", title: "工序", width: 80, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }, rowspan: 2
                            },
                            { /*field: "fStockQty",*/title: "需求", width: 80, align: "center",
                                colspan: 2
                            },
                            { /*field: "fStockQty",*/title: "库存", width: 80, align: "center",
                                colspan: 2
                            },
                            { /*field: "fStockQty",*/title: "使用库存", width: 80, align: "center",
                                colspan: 2
                            },
                             { field: "fLoss", title: "损耗%", width: 60, align: "center",
                                 editor: { type: "numberbox", options: { precision: 2, height: 35} }, rowspan: 2
                             },
                             { /*field: "fStockQty",*/title: "实际投坯", width: 80, align: "center",
                                 colspan: 2
                             },
                             { field: "iPurchase", title: "是否采购", width: 60, align: "center",
                                 editor: { type: 'checkbox', options: { on: '1', off: '0', height: 35} },
                                 formatter: function (value, row, index) {
                                     if (row.iPurchase == "1") {
                                         return "√";
                                     } else {
                                         return "";
                                     }
                                 }, rowspan: 2
                             },
                            { field: "sRemark", title: "备注", width: 200, align: "center",
                                editor: { type: 'mytextarea', style: "width:35px;border:none;" }, rowspan: 2
                            },
                        ],
                        [
                            { field: "fOrderQty", title: "重量", width: 60, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }
                            },
                            { field: "fOrderQtyM", title: "米数", width: 60, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }
                            },
                            { field: "fStockQty", title: "重量", width: 60, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }
                            },
                            { field: "fStockQtyM", title: "米数", width: 60, align: "center",
                                styler: function (value, row, index) {
                                    return 'background-color:#ffffaa;';
                                }
                            },
                            { field: "fUseStockQty", title: "重量", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2, height: 35}} },
                            { field: "fUseStockQtyM", title: "米数", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2, height: 35}} },


                            { field: "fRealQty", title: "重量", width: 60, align: "center", 
                            editor: { type: "numberbox", options: { precision: 2, height: 35}} },
                            { field: "fRealQtyM", title: "米数", width: 60, align: "center",
                                editor: { type: "numberbox", options: { precision: 2, height: 35}}
                            },

                            { field: "iRecNo", hidden: true },
                            { field: "iMainRecNo", hidden: true },
                            { field: "iBscDataMatRecNo", hidden: true },
                            { field: "iBscDataProcessesMRecNo", hidden: true }
                        ]
                    ],
                    onClickCell: clickCell,
                    toolbar: [{
                        iconCls: 'icon-save',
                        text: '保存',
                        handler: function () {

                        }
                    }]
                }
            )
        })

        var isEidtorTextarea = undefined;
        var isTreeGridEdit = undefined;
        function doFoucus(ed) {
            if (ed) {
                if (ed.type == "textbox") {
                    $(ed.target).textbox("textbox").focus();
                    $(ed.target).textbox("textbox").select();
                }
                else if (ed.type == "numberbox") {
                    $(ed.target).numberbox("textbox").focus();
                    $(ed.target).numberbox("textbox").select();
                }
                else if (ed.type == "combobox") {
                    $(ed.target).combobox("textbox").focus();
                    $(ed.target).combobox("textbox").select();
                }
                else if (ed.type == "combotree") {
                    $(ed.target).combotree("textbox").focus();
                    $(ed.target).combotree("textbox").select();
                }
                else if (ed.type == "numberspinner") {
                    $(ed.target).numberspinner("textbox").focus();
                    $(ed.target).numberspinner("textbox").select();
                }
                else if (ed.type == "datebox") {
                    $(ed.target).datebox("textbox").focus();
                    $(ed.target).datebox("textbox").select();
                }
                else if (ed.type == "datetimebox") {
                    $(ed.target).datetimebox("textbox").focus();
                    $(ed.target).datetimebox("textbox").select();
                }
                else {
                    $(ed.target).focus();
                    $(ed.target).select();
                }
                if (ed.target[0].tagName.toLowerCase() == "textarea") {
                    isEidtorTextarea = true;
                }
                else {
                    isEidtorTextarea = undefined;
                }
            }
        }

        var editid = undefined;
        function clickCell(field, row) {
            if (editid) {
                $("#tabSDContractDPlanD").treegrid("endEdit", editid);
            }
            var fields = $("#tabSDContractDPlanD").treegrid('getColumnFields', true).concat($("#tabSDContractDPlanD").treegrid('getColumnFields'));
            for (var i = 0; i < fields.length; i++) {
                var col = $("#tabSDContractDPlanD").treegrid('getColumnOption', fields[i]);
                col.editor1 = col.editor;
                if (fields[i] != field) {
                    col.editor = null;
                }
            }
            $("#tabSDContractDPlanD").treegrid("beginEdit", row.iBscDataMatRecNo);
            isTreeGridEdit = true;
            editid = row.iBscDataMatRecNo;
            for (var i = 0; i < fields.length; i++) {
                var col = $("#tabSDContractDPlanD").treegrid('getColumnOption', fields[i]);
                col.editor = col.editor1;
            }

            var ed = $("#tabSDContractDPlanD").treegrid('getEditor', { id: row.iBscDataMatRecNo, field: field });
            doFoucus(ed);
            event.stopPropagation();
        }

        function endEdit(row, changes) { 
            
        }

        function searchSdContractM() {
            var filters = [{
                Field: "iStatus",
                ComOprt: "=",
                Value: "4"
            }];
            var hasPlan = false;
            var theFormDataArr = $("#formSDContractMCondition").serializeArray();
            for (var i = 0; i < theFormDataArr.length; i++) {
                if (theFormDataArr[i].value != "" && theFormDataArr[i].value != null && theFormDataArr[i].value != undefined) {
                    if (theFormDataArr[i].name != "iPlanFinish") {
                        filters[filters.length - 1].LinkOprt = "and";
                        filters.push(
                        {
                            Field: theFormDataArr[i].name,
                            ComOprt: "like",
                            Value: "'%" + theFormDataArr[i].value + "%'"
                        })
                    }
                    else {
                        hasPlan = true;
                        //                        filters[filters.length - 1].LinkOprt = "and";
                        //                        if (theFormDataArr[i].value == "on") {
                        //                            filters.push(
                        //                            {
                        //                                Field: theFormDataArr[i].name,
                        //                                ComOprt: "=",
                        //                                Value: "1"
                        //                            })
                        //                        }
                        //                        else {
                        //                            filters.push(
                        //                            {
                        //                                Field: "isnull(" + theFormDataArr[i].name + ",0)",
                        //                                ComOprt: "<>",
                        //                                Value: "1"
                        //                            })
                        //                        }
                    }
                }
            }
            if (hasPlan == false) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                {
                    Field: "isnull(iPlanFinish,0)",
                    ComOprt: "<>",
                    Value: "1"
                })
            }
            var sqlObj = {
                TableName: "vwSDContractM",
                Fields: "iRecNo,sOrderNo,sContractNo,sDate,sPlanFinish,sSaleUnitName,sCustShortName",
                SelectAll: "True",
                Filters: filters,
                Sorts: [
                    {
                        SortName: "sDate",
                        SortOrder: "desc"
                    }
                ]
            }
            var resultData = SqlGetData(sqlObj);
            $("#tabSDContractM").datagrid("loadData", { total: resultData.length, rows: resultData });
        }

        function searchSDContractD(index, row) {
            $("#tabSDContractM").datagrid("checkRow", index);
            var sqlObj = {
                TableName: "vwSDContractD",
                Fields: "iSerial,sCode,sName,sColorID,sColorName,sFlowerTypeID,sFlowerType,fQty,iBscDataMatRecNo,fProductWidth,fProductWeight",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + row.iRecNo + "'"
                    }
                ],
                Sorts: [
                    {
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }
                ]
            }
            var resultObj = SqlGetData(sqlObj);
            $("#tabSDContractD").datagrid("loadData", { total: resultObj.length, rows: resultObj });
        }

        function searchSDContractDPlanD(index, row) {
            $("#tabSDContractD").datagrid("checkRow", index);
            var iBscDataMatRecNo = row.iBscDataMatRecNo;
            var jsonobj = {
                StoreProName: "SpGetSDContractDProcessMat",
                StoreParms: [{
                    ParmName: "@iBscDataMatRecNo",
                    Value: iBscDataMatRecNo
                },
                {
                    ParmName: "@sCodeSeparator",
                    Value: "-"
                }
                ]
            }
            var result = SqlStoreProce(jsonobj, true);
            if (result.length > 0) {
                var treeGridData = [];
                for (var i = 0; i < result.length; i++) {
                    if (result[i].iParentBscDataMatRecNo == 0) {
                        result[i].children = [];
                        treeGridData.push(result[i]);
                        delete result[i];
                        BulidTreeData(treeGridData[treeGridData.length - 1].iBscDataMatRecNo, result, treeGridData[treeGridData.length - 1]);
                    }
                }
            }
            else {
                MessageShow("没有找到产品", "没有找到产品信息");
            }
            $("#tabSDContractDPlanD").treegrid("loadData", treeGridData);
        }

        function BulidTreeData(iParentBscDataMatRecNo, data, theData) {
            for (var i = 0; i < data.length; i++) {
                if (data[i]) {
                    if (data[i].iParentBscDataMatRecNo == iParentBscDataMatRecNo) {
                        data[i].children = [];
                        theData.children.push(data[i]);
                        delete data[i];
                        BulidTreeData(theData.children[theData.children.length - 1].iBscDataMatRecNo, data, theData.children[theData.children.length - 1]);
                    }
                }
            }
        }

        $(document).click(function (event) {
            if (isTreeGridEdit) {
                $("#tabSDContractDPlanD").treegrid("endEdit", editid);
            }
        });
        function MessageShow(title, message) {
            $.messager.show({
                timeout: 2000,
                title: title,
                msg: "<span style='color:red;font-weight:bold;'>" + message + "</span>",
                showType: 'show',
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
        }
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',split:true" style="height: 200px;">
        <table id="tabSDContractM">
        </table>
    </div>
    <div data-options="region:'west',split:true" style="width: 400px;">
        <table id="tabSDContractD">
        </table>
    </div>
    <div data-options="region:'center'">
        <table id="tabSDContractDPlanD">
        </table>
    </div>
    <div id="divSDContractMMenu">
        <form id="formSDContractMCondition">
        <table>
            <tr>
                <td>
                    订单号
                </td>
                <td>
                    <input id="txbOrderNo" type="text" class="easyui-textbox" name="sOrderNo" style="width: 100px;" />
                </td>
                <td>
                    客户订单号
                </td>
                <td>
                    <input id="txbContractNo" type="text" class="easyui-textbox" name="sContractNo" style="width: 100px;" />
                </td>
                <td>
                    客户
                </td>
                <td>
                    <input id="txbCustomer" type="text" class="easyui-textbox" name="sCustShortName"
                        style="width: 100px;" />
                </td>
                <td>
                    <input id="ckbFinish" type="checkbox" name="iPlanFinish" />
                    <label for="ckbFinish">
                        包含已计划</label>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchSdContractM()">
                        查询</a>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="sdcontractMPlanFinish()">
                        计划完成</a>
                </td>
            </tr>
        </table>
        </form>
    </div>
</body>
</html>
