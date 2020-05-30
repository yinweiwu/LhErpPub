<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        
    </style>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add" && getQueryString("copyKey") == null) {
                Page.setFieldValue("sSizeGroupID", "0901");
            }
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnAdd("table1", "showQty", "尺码计划数量", "search", function () {
                var sqlObj = {
                    TableName: "vwProOrderPlanDDNotCut",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue("iProOrderPlanMRecNo") + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iSdOrderMRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue("iSdOrderMRecNo") + "'"
                    }
                    ]
                }
                var data = SqlGetData(sqlObj);
                var gridData = { rows: data, total: data.length };
                $("#planList").datagrid("loadData", gridData);
                $("#detailList").window("open");


            });
//            Page.Children.toolBarBtnAdd("table1", "copy", "复制", "copy", function () {
//                Page.Children.Copy("table1");
//            });
            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlObj = {
                    TableName: "vwProOrderPlanD",
                    Fields: "sStyleNo,iSumQty",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "'" + Page.getFieldValue("iProOrderPlanMRecNo") + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "iSdOrderMRecNo",
                            ComOprt: "=",
                            Value: "'" + Page.getFieldValue("iSdOrderMRecNo") + "'"
                        }
                    ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sStyleNo", data[0].sStyleNo);
                    Page.setFieldValue("iSumQty", data[0].iSumQty);
                }
            }
            $("#detailList").window("close");
            $("#planList").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                singleSelect: true,
                columns: [[
                    { field: "sStyleNo", title: "款号", width: 80, sortable: true },
                    { field: "sColorName", title: "颜色", width: 80, sortable: true },
                    { field: "sSizeName", title: "尺码", width: 50, sortable: true },
                    { field: "iQty", title: "计划数", width: 60, sortable: true },
                    { field: "iCutQty", title: "裁剪数", width: 60, sortable: true },
                    { field: "iNotCutQty", title: "差数", width: 60, sortable: true }
                ]]
            });

            Page.Children.toolBarBtnDisabled("table2", "add");
            Page.Children.toolBarBtnDisabled("table2", "delete");
            Page.Children.toolBarBtnAdd("table2", "bulidBarcode", "生成条码", "barcode", function () {

            });
        })
        //在赋值全部数据前
        lookUp.beforeSetValue = function (uniqueid, data) {
            if (uniqueid == "62") {
                //获取data中每一行尺码数据，并设置到data的每一行中
                var iRecNoStr = "";
                for (var i = 0; i < data.length; i++) {
                    iRecNoStr += "'" + data[i].iRecNo + "',";
                }
                if (data.length > 0) {
                    iRecNoStr = iRecNoStr.substr(0, iRecNoStr.length - 1);
                }
                iRecNoStr = "(" + iRecNoStr + ")";
                var sqlobj = {
                    TableName: "vwProOrderPlanDDNotCut",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "in",
                        Value: iRecNoStr
                    }
                    ],
                    Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
                };
                var resultSizeQty = SqlGetData(sqlobj);
                if (resultSizeQty && resultSizeQty.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        for (var j = 0; j < resultSizeQty.length; j++) {
                            if (data[i].iRecNo == resultSizeQty[j].iRecNo) {
                                data[i][(resultSizeQty[j].sSizeName)] = resultSizeQty[j].iNotCutQty;
                            }
                        }
                    }
                }
                return data;
            }
        }
        //在赋值行数据前，index是相对于data的行号，row是要赋值的行数据
        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "62") {
                //赋值每行数据前检测是否有重复
                //                var rows = $("#table1").datagrid("getRows");
                //                for (var i = 0; i < rows.length; i++) {
                //                    if (rows[i].iProOrderPlanDRecNo == row.iProOrderPlanDRecNo) {
                //                        Page.MessageShow("不可转入","不可重复转入相同数据");
                //                        return false;
                //                    }
                //                }
                //将尺码数据设置到行上
                var dynColumns = Page.Children.GetDynColumns("table1");
                for (var i = 0; i < dynColumns.length; i++) {
                    if (data[index][(dynColumns[i])]) {
                        row[(dynColumns[i])] = data[index][(dynColumns[i])];
                    }
                }
                return row;
            }
        }
        //在赋值行数据后rowIndex是相对于子表的行号
        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            //uniqueid=62表示从生产计划明细转入
            if (uniqueid == "62") {
                //合计行数量
                Page.Children.DynFieldRowSummary("table1", rowIndex);
            }
        }
        //在赋值全部数据后
        lookUp.afterSelected = function (uniqueid, data) {
            //uniqueid=62表示从生产计划明细转入
            if (uniqueid == "62") {
                //全部转入完成后合计页脚数据
                Page.Children.ReloadFooter("table1");
                Page.Children.ReloadDynFooter("table1");
            }
        }

        Page.beforeSave = function () {
            $("#table2").removeAttr("tablename");
            Page.DoNotCloseWinWhenSave = true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="overflow: hidden; height: 190px;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <div id="detailList" class="easyui-window" data-options="iconCls:'icon-list',title:'计划数量',top:100,collapsible:false,minimizable:false,maximizable:false,width:450,height:200">
                <table id="planList">
                </table>
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td>
                        <table class="tabmain">
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    裁剪单号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                                        Z_Required="False" />
                                </td>
                                <td>
                                    裁剪日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    尺码组
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sSizeGroupID" Z_Required="True" />
                                </td>
                                <td>
                                    裁剪部门
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sDeptID" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="easyui-panel" data-options="title:'单据信息',iconCls:'icon-job'">
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        计划单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iProOrderPlanMRecNo"
                                            Z_Required="True" />
                                    </td>
                                    <td>
                                        订单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iSdOrderMRecNo" Z_Required="False"
                                            Z_readOnly="True" />
                                    </td>
                                    <td>
                                        款号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sStyleNo" Z_readOnly="True" Z_NoSave="True" />
                                    </td>
                                    <td>
                                        计划数量
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="iSumQty" Z_readOnly="True" Z_NoSave="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        床次
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBedSerial" />
                                    </td>
                                    <td>
                                        开始扎号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iBindFrom" />
                                    </td>
                                    <td>
                                        截至扎号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iBindEnd" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table class="tabmain">
                            <tr>
                                <td>
                                    备注
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="140px" Z_FieldID="sReMark" />
                                </td>
                                <td>
                                    裁剪总数量
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="iQty" Z_readOnly="True" />
                                </td>
                                <td>
                                    制单人
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                                </td>
                                <td>
                                    制单日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="裁床明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="ProOrderCutD">
                    </table>
                </div>
                <div data-options="fit:true" title="条码清单">
                    <!--  子表1  -->
                    <table id="table2" tablename="ProOrderDBarCode">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
