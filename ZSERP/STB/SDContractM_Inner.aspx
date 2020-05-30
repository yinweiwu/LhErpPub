<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var isModify = false;
        $(function () {
            //Page.DoNotCloseWinWhenSave = true;
            var options = $("#table1").datagrid("options");
            var columns = options.columns;
            var appendField = {
                field: "__xj", title: "选卷", width: 60, align: "center", formatter: function (value, row, index) {
                    if (row.__isFoot != true) {
                        return "<a href='#' onclick='openJuanWindow(" + index + ")'>选卷</a>"
                    }
                }
            };
            if (columns.length == 1) {
                columns[0].splice(7, 0, appendField);
            } else {
                columns[1].splice(7, 0, appendField);
            }

            delete options.url;
            $("#table1").datagrid(options);

            $("#tabJuan").datagrid({
                fit: true,
                border: false,
                columns: [
                    [
                        { field: "__ck", checkbox: true, width: 40, align: "center" },
                        { field: "sBarCode", title: "条码", width: 80, align: "center" },
                        { field: "fQty", title: "米数", width: 80, align: "center" }
                    ]
                ],
                rownumbers: true,
                remoteSort: false,
            })

            if (Page.usetype == "modify") {
                if (getQueryString("isChangePrice") == "1") {
                    Page.mainDisabled();
                    Page.Children.toolBarBtnDisabled("table1", "add");
                    Page.Children.toolBarBtnDisabled("table1", "delete");
                    Page.Children.toolBarBtnDisabled("table1", "copy");
                    $("#__saveAndSubmit").hide();
                }
            }
        })

        var isStockEnough = true;
        Page.beforeSave = function () {
            //var isStockEnough=true;
            var dRows = $("#table1").datagrid("getRows");
            for (var i = 0; i < dRows.length; i++) {
                for (var j = i + 1; j < dRows.length; j++) {
                    if (dRows[i].iBscDataMatRecNo == dRows[j].iBscDataMatRecNo) {
                        alert("第" + (i + 1) + "行和第" + (j + 1) + "行重复");
                        return false;
                    }
                }
                if (dRows[i].iStockEnough != "1") {
                    isStockEnough = false;
                }
            }
        }

        Page.afterSave = function () {
            if (getQueryString("isChangePrice") != "1") {
                //var notEnoughCode = "";
                //var dRows = $("#table1").datagrid("getRows");
                //for (var i = 0; i < dRows.length; i++) {
                //    if (dRows[i].iStockEnough != "1") {
                //        notEnoughCode += dRows[i].sCode + ",";
                //    }
                //}
                //if (notEnoughCode != "") {
                //    notEnoughCode = "注意，产品型号：" + notEnoughCode + "库存不足，";
                //}
                //$.messager.confirm("直接生成剪货单？", notEnoughCode + "是否直接生成剪货单？", function (r) {
                //    if (r) {
                //        var jsonobj = {
                //            StoreProName: "SpSDContractMBuildSendM",
                //            StoreParms: [{
                //                ParmName: "@iRecNo",
                //                Value: Page.key
                //            }, {
                //                ParmName: "@sUserID",
                //                Value: Page.userid
                //            }, {
                //                ParmName: "@sExpressCompany",
                //                Value: ""
                //            }, {
                //                ParmName: "@sExpressNo",
                //                Value: ""
                //            }, {
                //                ParmName: "@sRecevieAddress",
                //                Value: Page.getFieldValue("iCustomerReceiveAddr")
                //            }
                //            ]
                //        }
                //        var result = SqlStoreProce(jsonobj);
                //        if (result != "1") {
                //            Page.MessageShow("生成失败", result);
                //        }
                //        else {
                //            $.messager.alert("生成剪货单成功", "生成剪货单成功", "info", function () {
                //                approval.submit(Page.iformid, Page.key);
                //                window.parent.CloseBillWindow();
                //                window.parent.GridRefresh();
                //            })
                //        }
                //    }
                //})
            }
            else {
                if (Page.usetype == "modify") {
                    var jsonobj = {
                        StoreProName: "SpSDContractMChangePrice",
                        StoreParms: [{
                            ParmName: "@iRecNo",
                            Value: Page.key
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result != "1") {
                        alert("修改单价失败");
                    } else {
                        window.parent.CloseBillWindow();
                        window.parent.GridRefresh();
                    }
                }
            }
        }

        var clickRowIndex = undefined;
        function openJuanWindow(index) {
            if (getQueryString("isChangePrice") != "1") {
                clickRowIndex = index;
                var theRow = $("#table1").datagrid("getRows")[index];
                if (theRow.iBscDataMatRecNo == null || theRow.iBscDataMatRecNo == undefined) {
                    Page.MessageShow("请先选择产品", "请先选择产品");
                    return;
                }
                var sqlObj = {
                    TableName: "MMStockQty",
                    Fields: "iRecNo,fQty,sBarCode,sReelNo",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iBscDataMatRecNo",
                        ComOprt: "=",
                        Value: "'" + theRow.iBscDataMatRecNo + "'"
                    }],
                    Sorts: [
                        {
                            SortName: "fQty",
                            SortOrder: "asc"
                        }
                    ]
                };
                var result = SqlGetData(sqlObj);

                $("#tabJuan").datagrid("loadData", result);
                if (result.length > 0) {
                    $("#divSelectJuan").dialog("open");
                }
                else {
                    Page.MessageShow("无库存", "此产品无库存");
                }
            }
        }
        function selectJuan() {
            var selectedRows = $("#tabJuan").datagrid("getChecked");
            var theClickRow = $("#table1").datagrid("getRows")[clickRowIndex];
            if (selectedRows.length > 0) {
                var selectedQty = "";
                $.each(selectedRows, function (index, o) {
                    selectedQty += o.fQty + ",";
                })
                if (selectedQty != "") {
                    selectedQty = selectedQty.substr(0, selectedQty.length - 1);
                }
                var jsonobj = {
                    StoreProName: "SpSDContractDSelectReel",
                    StoreParms: [{
                        ParmName: "@iRecNo",
                        Value: theClickRow.iRecNo
                    }, {
                        ParmName: "@sQtyStr",
                        Value: selectedQty
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj, true);
                if (result.length > 0) {
                    var selectJuanStr = "";
                    $.each(result, function (index1, o1) {
                        selectJuanStr += o1.iQty + ","
                    });
                    $("#table1").datagrid("updateRow", { index: clickRowIndex, row: { sSelectedReel: selectJuanStr } });
                    $("#divSelectJuan").dialog("close");
                }
                else {

                }
            }
            else {
                Page.MessageShow("尚未选择", "请选择一卷");
            }
        }

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (tableid == "table1" && Page.usetype == "modify" && getQueryString("isChangePrice") == "1") {
                if (datagridOp.clickColumnName != "fPrice" && datagridOp.clickColumnName != "fSjPrice") {
                    return false;
                }
            }
        }
        Page.Children.onBeforeAddRow = function (tableid) {
            if (tableid == "table1" && Page.usetype == "modify" && getQueryString("isChangePrice") == "1") {
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden; height: 190px;">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div title="订单信息">
                    <!--如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sDeptID" />
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iOrderType" />
                    </div>
                    <!--主表部分-->
                    <table>
                        <tr>
                            <td>
                                <table class="tabmain">
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>订单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_readOnly="True" Z_FieldID="sOrderNo" />
                                        </td>
                                        <td>客户订单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sContractNo" />
                                        </td>
                                        <td>客户
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                                        </td>
                                        <td>签订日期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>业务员
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSaleID" />
                                        </td>
                                        <td>计量单位
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUnitID" />
                                        </td>
                                        <td>订单交期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                                        </td>
                                        <td>生产交期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>总数
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                                                Z_FieldID="fQty" Z_FieldType="数值" />
                                            <table>
                                            </table>
                                        </td>
                                        <td>总金额
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                                                Z_FieldID="fTotal" Z_FieldType="数值" />
                                        </td>
                                        <td>备注</td>
                                        <td colspan="3">
                                            <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="99%" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>制单人
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                                        </td>
                                        <!--这里是主表字段摆放位置-->
                                        <td>制单日期
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                                Z_readOnly="true" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align: top;">
                                <div class="easyui-panel" data-options="title:'物流信息'" style="width: 250px; height: 155px; text-align: center;">
                                    <table class="tabmain" style="margin: auto;">
                                        <tr>
                                            <td>收货地址
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iCustomerReceiveAddr" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>物流公司</td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sExpressCompany" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>快递单号</td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sExpressNo" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>运费</td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fFreight" Z_FieldType="数值" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div title="客户收货地址">
                    <table class="tabmain">
                        <tr>
                            <td>收货地址1</td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sAddress" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                            <td>收货人1</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sPerson" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                            <td>收货人电话1</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sPersonTel" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>收货地址2</td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sAddress2" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                            <td>收货人2</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sPerson2" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                            <td>收货人电话2</td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sPersonTel2" Z_readOnly="true" Z_NoSave="true" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDContractD">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="divSelectJuan" class="easyui-dialog" data-options="title:'选择卷号',width:300,height:400,closed:true,buttons:[{text:'确定',handler:selectJuan},{text:'取消',handler:function(){$('#divSelectJuan').dialog('close');}}]">
        <table id="tabJuan"></table>
    </div>
</asp:Content>

