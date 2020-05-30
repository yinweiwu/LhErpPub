<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var OldData = [];
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table1", "copy");
            Page.Children.toolBarBtnDisabled("table1", "export");

            var sqlObj = {
                TableName: "bscDataPeriod",
                Fields: "sYearMonth",
                SelectAll: "True",
                Filters: [{
                    Field: "convert(varchar(50),GETDATE(),23)",
                    ComOprt: ">=",
                    Value: "dBeginDate",
                    LinkOprt: "and"
                }, {
                    Field: "convert(varchar(50),GETDATE(),23)",
                    ComOprt: "<=",
                    Value: "dEndDate"
                }]
            }
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
            }

            Page.Children.onEndEdit = function (tableid, index, row, changes) {
                if (tableid == "table1") {
                    if (datagridOp.currentColumnName == "fNoOutQty" && changes.fNoOutQty) {
                        row.fNoOutTotal = row.fNoOutQty * row.fPrice;
                    }
                }
                else if (tableid == "MMStockOutD") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
                        row.fTotal = row.fQty * row.fPrice;
                    }
                }
            }

            lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
                if (uniqueid = "1363") {
                    var getQty = $('#MMStockOutD').datagrid('getRows')[index].fQty == "" ? 0 : $('#MMStockOutD').datagrid('getRows')[index].fQty;
                    row.fTotal = row.fPrice * getQty;
                }
            }

            //批次号：生产工艺卡主键存在时，不能编辑
            Page.Children.onBeforeEdit = function (tableid, index, row) {
                if (tableid = "MMStockOutD") {
                    var getiSCTouChanMRecNo = $('#MMStockOutD').datagrid('getRows')[index].iSCTouChanMRecNo;
                    if (getiSCTouChanMRecNo > 0 && datagridOp.clickColumnName == "sBatchNo") {
                        return false;
                    }
                }
            }

            Page.beforeSave = function () {
                $("#table1").removeAttr("tablename");
            }
        })

        function ToSearch() {
            var sDeptID1 = Page.getFieldValue('sDeptID1');
            var sUseDeptID1 = Page.getFieldValue('sUseDeptID1');
            var sAskType1 = Page.getFieldValue('sAskType1');
            var sBscDataPersonID1 = Page.getFieldValue('sBscDataPersonID1');
            var dDate1 = Page.getFieldValue('dDate1') == "" ? "1990-01-01" : Page.getFieldValue('dDate1');
            var dDate2 = Page.getFieldValue('dDate2') == "" ? "2990-01-01" : Page.getFieldValue('dDate2');
            var ApplyFields = "iBscDataMatRecNo,fNoOutQty,fNoOutPurQty,";
            ApplyFields += "sCode,sName,sUnitName,sPurUnitName,iSdOrderDRecNo,iMMStockApplyDRecNo";
            var sqlObjvwMMStockApply = {
                TableName: "vwMMStockApplyMD",
                Fields: ApplyFields,
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sDeptID",
                        ComOprt: "like",
                        Value: "'%" + sDeptID1 + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sUseDeptID",
                        ComOprt: "like",
                        Value: "'%" + sUseDeptID1 + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sAskType",
                        ComOprt: "like",
                        Value: "'%" + sAskType1 + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sBscDataPersonID",
                        ComOprt: "like",
                        Value: "'%" + sBscDataPersonID1 + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iFinish,0)",
                        ComOprt: "=",
                        Value: 0,
                        LinkOprt: "and"
                    },
                    {
                        Field: "fNoOutQty",
                        ComOprt: ">",
                        Value: 0,
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: 4
                    }],
                Sorts: [
                {
                    SortName: "iRecNo",
                    SortOrder: "asc"
                }]
            };
            var resultvwMMStockApply = SqlGetData(sqlObjvwMMStockApply);
            $('#table1').datagrid({
                data: resultvwMMStockApply,
                width: 400,
                height: 'auto',
                nowrap: true,
                pageSize: 30,
                pageList: [30, 60, 120, 300],
                rownumbers: true,
                pagination: true,
                fit: true,
                border: false,
                striped: true,
                loadFilter: function (resultvwMMStockApply) {
                    return pagerFilter(resultvwMMStockApply);
                }
            });
        }

        function passIn() {
            var getRows = $('#table1').datagrid('getChecked');
            if (getRows.length > 0) {
                for (var i = 0; i < getRows.length; i++) {
                    getRows[i].fQty = getRows[i].fNoOutQty;
                    getRows[i].fPurQty = getRows[i].fNoOutPurQty;
                    Page.tableToolbarClick("add", "MMStockOutD", getRows[i]);
                }
            }
            $("#tabTop").tabs("select", "领用出库");
        }

        function pagerFilter(data) {
            if (data.length > 0) {
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
                OldData = data;
                if (Page.usetype == "add") {
                    return data;
                }
                else {
                    return { originalRows: [], rows: [], total: 0 };
                }
            }
            else {
                if (Page.usetype == "add" && OldData.length > 0) {
                    var OldData2 = OldData;
                    OldData = [];
                    return OldData2;
                }
                else if (Page.usetype == "modify" && (OldData.length > 0 || OldData.total >= 1)) {
                    var OldData2 = OldData;
                    OldData = [];
                    return OldData2;
                }
                else {
                    return { originalRows: [], rows: [], total: 0 };
                }
            }
        }

        function toFinish() {
            var getRows = $('#table1').datagrid('getChecked');
            if (getRows.length > 0) {
                for (var i = 0; i < getRows.length; i++) {
                    var jsonobj = {
                        StoreProName: "SpFinish",
                        StoreParms: [{
                            ParmName: "@iformid",
                            Value: 4
                        },
                            {
                                ParmName: "@iRecNo",
                                Value: getRows[i].iMMStockApplyDRecNo
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
                        ToSearch()
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未出库申领单">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <div style="float: left; width: 80%;">
                            <table>
                                <tr>
                                    <td>
                                        申领部门
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sDeptID1" Z_NoSave="True" />
                                    </td>
                                    <td>
                                        使用部门
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sUseDeptID1" Z_NoSave="True" />
                                    </td>
                                    <td>
                                        申请类型
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sAskType1" Z_NoSave="True" />
                                    </td>
                                    <td>
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='ToSearch()'>查询</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='passIn()'>转入</a> <a href='javascript:void(0)'
                                                    class="easyui-linkbutton" data-options="iconCls:'icon-finishWork'" onclick='toFinish()'>
                                                    申领完成</a>
                                    </td>
                                </tr>
                                <tr>
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
                                        使用部门
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sBscDataPersonID1" Z_NoSave="True" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="table1" tablename="table1">
                    </table>
                </div>
            </div>
        </div>
        <div title="领用出库">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden; height: 245px;">
                    <table class="tabmain">
                        <tr>
                            <td colspan="8">
                                <div class="easyui-panel" style="padding: 5px; text-align: center; vertical-align: middle;">
                                    <table>
                                        <tr>
                                            <td>
                                                单据日期
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                                            </td>
                                            <td>
                                                单据号
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8">
                                <div class="easyui-panel" style="padding: 5px; text-align: center; vertical-align: middle;">
                                    <table>
                                        <tr>
                                            <td>
                                                仓库
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                                    Width="150px" />
                                            </td>
                                            <td>
                                                出库类型
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sTypeName" Width="150px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                领用部门
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sDeptID" Z_Required="False"
                                                    Width="150px" />
                                            </td>
                                            <td>
                                                领用人
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sBscDataPersonID" Width="150px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                                <label for="__ExtCheckbox1">
                                                    红冲</label>
                                            </td>
                                            <td>
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iGuiHuan" />
                                                <label for="__ExtCheckbox2">
                                                    归还</label>
                                            </td>
                                            <td>
                                                计划归还日期
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldType="日期" Z_FieldID="dPlanGuiHuanDate" />
                                            </td>
                                            <td>
                                                会计月份
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sYearMonth" Z_disabled="true"
                                                    Width="150px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                备 注
                                            </td>
                                            <td colspan='3'>
                                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="99%" Z_FieldID="sReMark" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8">
                                <div class="easyui-panel" style="padding: 5px; text-align: center; vertical-align: middle;">
                                    <table>
                                        <tr>
                                            <td>
                                                出库数量
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fQty" Z_disabled="true"
                                                    Z_FieldType="数值" />
                                            </td>
                                            <td>
                                                出库件数
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fPurQty" Z_disabled="true"
                                                    Z_FieldType="数值" />
                                            </td>
                                            <td>
                                                出库金额
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                                                    Z_FieldType="数值" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="明细">
                            <table id="MMStockOutD" tablename="MMStockOutD">
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'south'">
                    <table>
                        <tr>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true"
                                    Width="150px" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                            <td style="display: none">
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBillType" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
