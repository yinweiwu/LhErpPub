<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        //var textData = [
        //    {
        //        sOrderNo: "SC171129-001", sCode: "12342-1", sFlowerCode: "111-1", fProductWidth: 150, fProductWeight: 200, fWeavingArrQty: 100, fNotWeavingQty: 100, sWeftStatus: "未采购"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "22342-1", sFlowerCode: "121-1", fProductWidth: 150, fProductWeight: 190, fWeavingArrQty: 150, fNotWeavingQty: 200, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "32342-1", sFlowerCode: "131-1", fProductWidth: 180, fProductWeight: 210, fWeavingArrQty: 130, fNotWeavingQty: 50, sWeftStatus: "采购中"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "22342-1", sFlowerCode: "112-1", fProductWidth: 140, fProductWeight: 180, fWeavingArrQty: 140, fNotWeavingQty: 123, sWeftStatus: "部分完成"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "52342-1", sFlowerCode: "171-1", fProductWidth: 150, fProductWeight: 300, fWeavingArrQty: 120, fNotWeavingQty: 223, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "45342-1", sFlowerCode: "181-1", fProductWidth: 140, fProductWeight: 450, fWeavingArrQty: 110, fNotWeavingQty: 456, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "23342-1", sFlowerCode: "151-1", fProductWidth: 120, fProductWeight: 280, fWeavingArrQty: 0, fNotWeavingQty: 245, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "18342-1", sFlowerCode: "119-1", fProductWidth: 140, fProductWeight: 260, fWeavingArrQty: 0, fNotWeavingQty: 12, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "12342-1", sFlowerCode: "120-1", fProductWidth: 150, fProductWeight: 210, fWeavingArrQty: 0, fNotWeavingQty: 356, sWeftStatus: "齐料"
        //    },
        //    {
        //        sOrderNo: "SC171129-001", sCode: "12342-1", sFlowerCode: "锦纶", fProductWidth: 155, fProductWeight: 250, fWeavingArrQty: 40, fNotWeavingQty: 123, sWeftStatus: "未采购"
        //    }
        //];
        //$(function () {
        //    $("#tabSDContractD").datagrid(
        //        {
        //            fit: true,
        //            border: false,
        //            columns: [
        //                [
        //                    { field: "__ck", width: 40, checkbox: true, rowspan: 2 },
        //                    { field: "sOrderNo", title: "生产单号", align: "center", width: 110, rowspan: 2 },
        //                    { field: "sCode", title: "产品编号", align: "center", width: 80, rowspan: 2 },
        //                    { field: "sFlowerCode", title: "花本型号", align: "center", width: 80, rowspan: 2 },
        //                    { field: "fProductWidth", title: "幅宽", align: "center", width: 60, rowspan: 2 },
        //                    { field: "fProductWeight", title: "克重", align: "center", width: 60, rowspan: 2 },
        //                    { field: "fProduceQty", title: "生产米数", align: "center", width: 60, rowspan: 2 },
        //                    { field: "fWeavingArrQty", title: "已排米数", align: "center", width: 60, rowspan: 2 },
        //                    { field: "fNotWeavingQty", title: "未排米数", align: "center", width: 60, rowspan: 2 },
        //                    { field: "sWeftStatus", title: "纬线状态", align: "center", width: 60, rowspan: 2 },
        //                    { title: "本次排产", align: "center", colspan: 8 }
        //                ],
        //                [
        //                    {
        //                        field: "fLong", title: "匹长", align: "center", width: 60,
        //                        editor: { type: "numberbox", options: { width: 60, height: 35 } }
        //                    },
        //                    {
        //                        field: "iQty", title: "卷数", align: "center", width: 60,
        //                        editor: { type: "numberbox", options: { width: 60, height: 35 } }
        //                    },
        //                    {
        //                        field: "fTheProduceQty", title: "米数", align: "center", width: 80,
        //                        editor: {
        //                            type: "numberbox", options: {
        //                                width: 80, height: 35
        //                            }
        //                        }
        //                    },
        //                    {
        //                        field: "fWarpingQty", title: "整经米数", align: "center", width: 60,
        //                        editor: { type: "numberbox", options: { width: 60, height: 35 } }
        //                    },
        //                    {
        //                        field: "dWeavingPlanBeginDate", title: "计划开始日期", align: "center", width: 100,
        //                        editor: { type: "datebox", options: { width: 100, height: 35 } }
        //                    },
        //                    {
        //                        field: "dWarpingEndDate", title: "计划未完成日期", align: "center", width: 100,
        //                        editor: { type: "datebox", options: { width: 100, height: 35 } }
        //                    },
        //                    {
        //                        field: "sMachineID", title: "机台", align: "center", width: 60,
        //                        editor: { type: "textbox", options: { width: 60, height: 35 } }
        //                    },
        //                    {
        //                        field: "sReMark", title: "备注", align: "center", width: 100,
        //                        editor: { type: "textarea", options: { width: 100, height: 35 } }
        //                    }
        //                ]
        //            ],
        //            toolbar: "#divMenu",
        //            rownumbers: true,
        //            pagination: true,
        //            pageSize: 50,
        //            pageList: [50, 100, 200, 500],
        //            remoteSort: true,
        //            loadFilter: pagerFilter
        //        })
        //})
        //function loadSDContractD() {
        //    $("#tabSDContractD").datagrid("loadData", textData);
        //    var allRows = $("#tabSDContractD").datagrid("getRows");
        //    $.each(allRows, function (index, o) {
        //        $("#tabSDContractD").datagrid("beginEdit", index);
        //    })
        //}
        //function BuildWeaving() {
        //    var checkedRows = $("#tabSDContractD").datagrid("getChecked");
        //    if (checkedRows.length > 0) {
        //        $.each(checkedRows, function (index, o) {
        //            $("#tabSDContractD").datagrid("endEdit", index);
        //        });
        //    } else {
        //        MessageShow("请选择行", "请选择行");
        //    }
        //}
        //function MessageShow(title, message) {
        //    $.messager.show({
        //        timeout: 2000,
        //        title: title,
        //        msg: "<span style='color:red;font-weight:bold;'>" + message + "</span>",
        //        showType: 'show',
        //        style: {
        //            right: '',
        //            top: document.body.scrollTop + document.documentElement.scrollTop,
        //            bottom: ''
        //        }
        //    });
        //}
        //function pagerFilter(data) {
        //    if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
        //        data = {
        //            total: data.length,
        //            rows: data
        //        }
        //    }
        //    var dg = $(this);
        //    var opts = dg.datagrid('options');
        //    var pager = dg.datagrid('getPager');
        //    pager.pagination({
        //        onSelectPage: function (pageNum, pageSize) {
        //            opts.pageNumber = pageNum;
        //            opts.pageSize = pageSize;
        //            pager.pagination('refresh', {
        //                pageNumber: pageNum,
        //                pageSize: pageSize
        //            });
        //            dg.datagrid('loadData', data);
        //        }
        //    });
        //    if (!data.originalRows) {
        //        data.originalRows = (data.rows);
        //    }
        //    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        //    var end = start + parseInt(opts.pageSize);
        //    data.rows = (data.originalRows.slice(start, end));
        //    return data;
        //}
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table1", "copy");
            Page.Children.toolBarBtnAdd("table1", "buildYarnUse", "生成纱线用料", "import", function () {
                var iSDContractDRecNo = Page.getFieldValue("iSDContractDRecNo");
                var fQty = Page.getFieldValue("fQty");
                if (iSDContractDRecNo == "") {
                    Page.MessageShow("错误", "请先选择生产单");
                    return;
                }
                if (fQty == "") {
                    Page.MessageShow("错误", "请先输入总米数");
                    return;
                }
                $("#table1").datagrid("loadData", []);
                var jsonobj = {
                    StoreProName: "SpProWeavingCalcYarnUse",
                    StoreParms: [{
                        ParmName: "@iSDContractDRecNo",
                        Value: iSDContractDRecNo
                    },
                    {
                        ParmName: "@fQty",
                        Value: fQty
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj, true);
                if (result.length > 0) {
                    $.each(result, function (index, o) {
                        Page.tableToolbarClick("add", "table1", o);
                    })
                }
                else {
                    Page.MessageShow("未返回任务行", "请到产品工艺中完善纱线用料");
                }
            })
        })
        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpProWeavingSavleBuild",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                Page.MessageShow("生成条码时出错", result);
                Page.DoNotCloseWinWhenSave = true;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->

                    </div>

            <!--主表部分-->

            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>织造单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>生产单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iSDContractDRecNo" />
                    </td>
                    <td>匹长
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fLong" Z_FieldType="数值" />
                    </td>
                    <td>卷数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iQty" Z_FieldType="整数" />
                    </td>

                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>总米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>整经米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fWarpingQty" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>计划开始日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dPlanBeginDate" Z_FieldType="日期" />
                    </td>
                    <td>计划完成日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dPlanEndDate" Z_FieldType="日期" />
                    </td>

                </tr>
                <tr>
                    <td>机台
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sMachineID" />
                    </td>
                    <!--这里是主表字段摆放位置-->
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dInputDate" Z_readOnly="true" />
                    </td>
                    <td>备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sRemark" Style="width: 99%;" />
                    </td>

                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="纱线用量">
                    <!--子表1  -->
                    <table id="table1" tablename="ProWeavingDYarnUse">
                    </table>
                </div>
                <div data-options="fit:true" title="条码明细">
                    <!--子表1  -->
                    <table id="table2" tablename="ProWeavingDBarcode">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

