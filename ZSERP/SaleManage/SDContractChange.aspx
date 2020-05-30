<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            if (Page.usetype == "add") {
                if (getQueryString("orderRecNo") != null) {
                    var orderRecNo = getQueryString("orderRecNo");
                    //var changeType = getQueryString("changeType");
                    setTimeout(function () {
                        Page.setFieldValue('iChangeType', getQueryString('changeType'));
                    }, 1100);
                    Page.setFieldValue("iSdContractMRecNo", orderRecNo);
                }
            }
            Page.Children.toolBarBtnDisabled("table2", "add");
			lookUp.beforeOpen = function (uniqueid) {
                if (uniqueid == "24") {
                    var iChangeType = Page.getFieldValue('iChangeType');
                    if (iChangeType > 0) {
                        alert("订单变更取消作废、作废时，不需要转入明细！");
                        return false;
                    }
                }
            }
        })



        lookUp.IsConditionFit = function (uniqueid) {
            if (uniqueid == "110") {
                if (Page.sysParms.iColorFrom != null && Page.sysParms.iColorFrom != undefined && Page.sysParms.iColorFrom != '1') {
                    return true;
                }
            }
            if (uniqueid == "112") {
                if (Page.sysParms.iColorFrom != null && Page.sysParms.iColorFrom != undefined && Page.sysParms.iColorFrom == '1') {
                    return true;
                }
            }
        }



        lookUp.beforeSetValue = function (uniqueid, data) {
            if (uniqueid == "191") {
                //获取data中每一行尺码资料，并设置到data的每一行中
                var iRecNoStr = "";
                for (var i = 0; i < data.length; i++) {
                    iRecNoStr += "'" + data[i].iRecNo + "',";
                }
                if (data.length > 0) {
                    iRecNoStr = iRecNoStr.substr(0, iRecNoStr.length - 1);
                }
                iRecNoStr = "(" + iRecNoStr + ")";
//                alert(iRecNoStr);
                var sqlobj = {
                    TableName: "vwSDContractDD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
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
//                alert(resultSizeQty);
//                alert(resultSizeQty.length);
                if (resultSizeQty && resultSizeQty.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        for (var j = 0; j < resultSizeQty.length; j++) {
//                            alert(data[i].iRecNo.toString() + "--" + resultSizeQty[j].iMainRecNo.toString() + " " + resultSizeQty[j].iQty.toString() + " " + resultSizeQty[j].sSizeName);
                            if (data[i].iRecNo == resultSizeQty[j].iMainRecNo) {
                                data[i][(resultSizeQty[j].sSizeName)] = resultSizeQty[j].iQty;
                            }
                        }
                    }
                }
                return data;
            }
        }
        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "191") {
                //赋值每行资料前检测是否有重复
                var rows = $("#table2").datagrid("getRows");

                //将尺码数据设置到行上
                var dynColumns = Page.Children.GetDynColumns("table2");
                for (var i = 0; i < dynColumns.length; i++) {
                    if (data[index][(dynColumns[i])]) {
                        row[(dynColumns[i])] = data[index][(dynColumns[i])];
                    }
                }
                return row;
            }
        }

        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            //uniqueid=62表示从生产计划明细转入
            if (uniqueid == "191") {
                //动态列合计数量，DynFieldRowSummary是专门合计动态列的方法
                Page.Children.DynFieldRowSummary("table2", rowIndex);
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            //uniqueid=62表示从生产计划明细转入
            if (uniqueid == "191") {
                //全部转入完成后合计页脚数据
                Page.Children.ReloadFooter("table2");
                Page.Children.ReloadDynFooter("table2");
            }
        }

        Page.afterSave = function () {

            var iRecNo = Page.key;
            var jsonobj = {
                StoreProName: "spSDContractChangeD",
                StoreParms: [{ ParmName: "@iRecNo", Value: iRecNo }
                        ]
            }
            SqlStoreProce(jsonobj);

        }

//        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
//            var colname = datagridOp.currentColumnName;
//            var iRecNo = $("#table2").datagrid("getRows")[datagridOp.currentRowIndex].iSDContractDecNo
////            alert(iRecNo);
//            var jsonobj = {
//                StoreProName: "spSDContractDD",
//                StoreParms: [{ ParmName: "@sSizeName", Value: colname },
//                { ParmName: "@iRecNo", Value: iRecNo }
//                        ]
//            }
//            var result = SqlStoreProce(jsonobj);
//         //   alert(result);
//            //alert(("#table2").datagrid("getRows")[datagridOp.currentRowIndex][currentColumnIndex]
//            if (result == 1) {
//                switch (datagridOp.currentColumnName) {
//                    case "S":
//                        if ($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].S == "")
//                        $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { S: 0} });
//                        break;
//                    case "M":
//                        if ($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].M == "")
//                        $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { M: 0} });
//                        break;
//                    case "L":
//                    if($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].L=="")
//                        $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { L: 0} });
//                        break;
//                    case "XL":
//                        if ($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].L == "")
//                            $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { XL: 0} });
//                        break;
//                    case "L":
//                        if ($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].L == "")
//                            $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { 2XL: 0} });
//                        break;
//                    case "L":
//                        if ($("#table2").datagrid("getRows")[datagridOp.currentRowIndex].L == "")
//                            $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: { L: 0} });
//                        break;
//                    default:
//                        break;
//                }
//            }
//        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="overflow: hidden; height:205px; padding-left:10px;">
            <!--隐藏字段-->
            <div id="divHid" style="display: none;">
            </div>
            <!—如果只有一个主表，这里的north要变为center-->
            <!--主表部分-->
            <table>
                <tr>
                    <td colspan="2">
                        <table class="tabmain">
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    变更单号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                                </td>
                                <td>
                                    变更日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    变更类型
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iChangeType" />
                                </td>
                                <td>
                                    变更原因
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="145px" Z_FieldID="sChangeBecause" />
                                </td>
                                <td>
                                    尺码组
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSizeGroupID"  />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="easyui-panel" data-options="title:'变更前',iconCls:'icon-original',width:480,height:100">
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        订单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iSdContractMRecNo" />
                                    </td>
                                    <td>
                                        原客户
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iOldbscDataCustomerRecNo"
                                            Z_readOnly="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        原订单交期
                                    </td>
                                    <td style="margin-left: 40px">
                                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_readOnly="True" Z_FieldID="dOldOrderDate"
                                            Z_FieldType="日期" />
                                    </td>
                                    <td>
                                        原生产交期
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_readOnly="True" Z_FieldID="dOldProduceDate"
                                            Z_FieldType="日期" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td>
                        <div class="easyui-panel" data-options="title:'变更后',iconCls:'icon-now',width:480,height:100">
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        新客户
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="ibscDataCustomerRecNo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        新订单交期
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dNewOrderDate" Z_FieldType="日期" />
                                    </td>
                                    <td>
                                        新生产交期
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dNewProduceDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <%--<tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        新客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        新订单交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dNewOrderDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        新生产交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dNewProduceDate" Z_FieldType="日期" />
                    </td>
                </tr>--%>
                <tr>
                    <td colspan="2">
                        <table class="tabmain">
                            <tr>
                                <td>
                                    备注
                                </td>
                                <td colspan="3">
                                    <cc1:ExtTextArea2 ID="ExtTextArea22" runat="server" Width="358px" Z_FieldID="sReMark" />
                                </td>
                                <td>
                                    制单人
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_readOnly="True" Z_FieldID="sUserID" />
                                </td>
                                <td>
                                    制单日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_readOnly="True" Z_FieldID="dInputDate"
                                        Z_FieldType="时间" />
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
                <div data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="table2" tablename="SDContractChangeDNew">
                    </table>
                </div>
                <div data-options="fit:true" title="订单变更明细">
                    <!--  子表2  -->
                    <table id="table1" tablename="SDContractChangeD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
