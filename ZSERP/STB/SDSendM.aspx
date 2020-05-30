<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        //测试数据，正式环境要删除
        var testData = [
            {
                sOrderNo: "SD201711-0001", sCustShortName: "客户1", iBscDataCustomerRecNo: 1, sCode: "50891-1", sFlowerCode: "111-1", fProductWidth: 150, fProductWeight: 200, fPrice: 20.5,fQty:1000, fSendQty: 0, fNotSendQty: 1000, fStockQty: 500, iRecNo: 1000, iRecNoM: 1234
            },
            {
                sOrderNo: "SD201711-0002", sCustShortName: "客户1", iBscDataCustomerRecNo: 1, sCode: "23456-2", sFlowerCode: "111-2", fProductWidth: 150, fProductWeight: 300, fPrice: 50, fQty: 1000, fSendQty: 100, fNotSendQty: 850, fStockQty: 200, iRecNo: 1001, iRecNoM: 1235
            },
            {
                sOrderNo: "SD201711-0003", sCustShortName: "客户1", iBscDataCustomerRecNo: 1, sCode: "22343-1", sFlowerCode: "3323-1", fProductWidth: 200, fProductWeight: 250, fPrice: 5, fQty: 1000, fSendQty: 20, fNotSendQty: 234, fStockQty: 500, iRecNo: 1002, iRecNoM: 1264
            },
            {
                sOrderNo: "SD201711-0004", sCustShortName: "客户2", iBscDataCustomerRecNo: 2, sCode: "21452-1", sFlowerCode: "1234-1", fProductWidth: 160, fProductWeight: 290, fPrice: 6, fQty: 1000, fSendQty: 32, fNotSendQty: 332, fStockQty: 500, iRecNo: 1003, iRecNoM: 1274
            },
            {
                sOrderNo: "SD201711-0005", sCustShortName: "客户3", iBscDataCustomerRecNo: 3, sCode: "32345-1", sFlowerCode: "5533-1", fProductWidth: 120, fProductWeight: 145, fPrice: 8, fQty: 1000, fSendQty: 34, fNotSendQty: 234, fStockQty: 500, iRecNo: 1004, iRecNoM: 1284
            },
            {
                sOrderNo: "SD201711-0006", sCustShortName: "客户3", iBscDataCustomerRecNo: 3, sCode: "33123-1", sFlowerCode: "1344-1", fProductWidth: 300, fProductWeight: 180, fPrice: 11, fQty: 1000, fSendQty: 66, fNotSendQty: 331, fStockQty: 500, iRecNo: 1005, iRecNoM: 1294
            },
            {
                sOrderNo: "SD201711-0001", sCustShortName: "客户1", iBscDataCustomerRecNo: 1, sCode: "50891-1", sFlowerCode: "111-1", fProductWidth: 150, fProductWeight: 200, fPrice: 20.5, fQty: 1000, fSendQty: 0, fNotSendQty: 1000, fStockQty: 500, iRecNo: 1000, iRecNoM: 1234
            },
            {
                sOrderNo: "SD201711-0002", sCustShortName: "客户2", iBscDataCustomerRecNo: 2, sCode: "23456-2", sFlowerCode: "111-2", fProductWidth: 150, fProductWeight: 300, fPrice: 50, fQty: 1000, fSendQty: 100, fNotSendQty: 850, fStockQty: 200, iRecNo: 1001, iRecNoM: 1235
            },
            {
                sOrderNo: "SD201711-0003", sCustShortName: "客户3", iBscDataCustomerRecNo: 3, sCode: "22343-1", sFlowerCode: "3323-1", fProductWidth: 200, fProductWeight: 250, fPrice: 5, fQty: 1000, fSendQty: 20, fNotSendQty: 234, fStockQty: 500, iRecNo: 1002, iRecNoM: 1264
            },
            {
                sOrderNo: "SD201711-0004", sCustShortName: "客户4", iBscDataCustomerRecNo: 4, sCode: "21452-1", sFlowerCode: "1234-1", fProductWidth: 160, fProductWeight: 290, fPrice: 6, fSendQty: 32, fNotSendQty: 332, fStockQty: 500, iRecNo: 1003, iRecNoM: 1274
            },
            {
                sOrderNo: "SD201711-0005", sCustShortName: "客户5", sCode: "32345-1", sFlowerCode: "5533-1", fProductWidth: 120, fProductWeight: 145, fPrice: 8, fSendQty: 34, fNotSendQty: 234, fStockQty: 500, iRecNo: 1004, iRecNoM: 1284
            },
            {
                sOrderNo: "SD201711-0006", sCustShortName: "客户6", sCode: "33123-1", sFlowerCode: "1344-1", fProductWidth: 300, fProductWeight: 180, fPrice: 11, fSendQty: 66, fNotSendQty: 331, fStockQty: 500, iRecNo: 1005, iRecNoM: 1294
            }
        ]
        $(function () {
            $("#tabSDContractD").datagrid(
                {
                    fit: true,
                    border: false,
                    columns: [
                        [
                            { field: "__ck", width: 40, checkbox: true },
                            { field: "sOrderNo", title: "订单号", align: "center", width: 120 },
                            { field: "sCustShortName", title: "客户", align: "center", width: 80 },
                            { field: "sCode", title: "产品编号", align: "center", width: 80 },
                            { field: "sFlowerCode", title: "花本型号", align: "center", width: 80 },
                            { field: "fProductWidth", title: "幅宽", align: "center", width: 50 },
                            { field: "fProductWeight", title: "克重", align: "center", width: 50 },
                            { field: "fQty", title: "订单米数", align: "center", width: 60 },
                            { field: "fPrice", title: "单价", align: "center", width: 60 },
                            { field: "fSendQty", title: "已发米数", align: "center", width: 80 },
                            { field: "fNotSendQty", title: "未发米数", align: "center", width: 60 },
                            { field: "fStockQty", title: "库存数", align: "center", width: 50 },
                            { field: "fTheSendQty", title: "本次发货", align: "center", width: 80, editor: { type: "numberbox" } },
                            { field: "iRecNo", hidden: true },
                            { field: "iRecNoM", hidden: true },
                            { field: "iBscDataCustomerRecNo", hidden: true }
                        ]
                    ],
                    toolbar: "#divOrderMenu",
                    rownumbers: true,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 200, 500],
                    remoteSort: true,
                    loadFilter: pagerFilter
                })
        });

        function loadSContractD() {
            $("#tabSDContractD").datagrid("loadData", testData);
            var allRows = $("#tabSDContractD").datagrid("getRows");
            $.each(allRows, function (index,o) {
                $("#tabSDContractD").datagrid("beginEdit", index);
            });
        }

        function TurnTo() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                $.each(checkedRows, function (index, o) {
                    $("#tabSDContractD").datagrid("endEdit", index);
                });
                var isCustomerSame = true;
                var iBscDataCustomerRecNo = checkedRows[0].iBscDataCustomerRecNo;
                $.each(checkedRows, function (index, o) {
                    if (o.iBscDataCustomerRecNo != iBscDataCustomerRecNo) {
                        isCustomerSame = false;
                        return false;
                    }
                });
                if (isCustomerSame == false) {
                    Page.MessageShow("只能转相同客户的明细", "只能转相同客户的明细");
                }
                else {
                    $("#table1").datagrid("loadData", []);
                    $.each(checkedRows, function (index, o) {
                        var appendRow = {
                            iBscDataMatRecNo: o.iBscDataMatRecNo,
                            iBscDataColorRecNo: o.iBscDataColorRecNo,
                            iSdOrderDRecNo: o.iRecNo,
                            //iSDContractMRecNo: o.fNotWarpingArrQty,
                            sOrderNo: o.sOrderNo,
                            sCode: o.sCode,
                            sFlowerCode: o.sFlowerCode,
                            fProductWidth: o.fProductWidth,
                            fProductWeight: o.fProductWeight,
                            fOrderPrice: o.fPrice,
                            fPrice: o.fPrice,
                            fSumQty: o.fTheSendQty,
                            fTotal: Number(o.fPrice) * Number(o.fTheSendQty)
                        }
                        Page.tableToolbarClick("add", "table1", appendRow);
                    });                   

                    Page.setFieldValue("iBscDataCustomerRecNo", iBscDataCustomerRecNo);
                    $("#divTab").tabs("select", 1);
                    $.each(checkedRows, function (index, o) {
                        $("#tabSDContractD").datagrid("beginEdit", index);
                    });
                }
            }
            else {
                Page.MessageShow("请选择行", "请选择行");
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="订单明细" data-options="border:false">
            <table id="tabSDContractD"></table>
        </div>
        <div title="发货通知单" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden;">
                    <!--主表部分-->
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>通知单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>通知日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>计划出库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期" />
                            </td>
                            <td>客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                        </tr>
                        <tr>
                            <td>运输方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sTransType" />
                            </td>
                            <td>包装方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPackageType" />
                            </td>
                            <td>业务员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sSaleID" />
                            </td>
                            <td>收货人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sPerson" />
                            </td>
                        </tr>
                        <tr>
                            <td>联系方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sTel" />
                            </td>
                            <td>发货地址
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sAddress" />
                            </td>
                            <td>金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBillType" Style="display: none;" />
                            </td>
                            <td colspan="1">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iRed" runat="server" />
                                <label for="__ExtCheckbox1">
                                    是否退货通知</label>
                            </td>
                            <td colspan="1">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iSample" runat="server" />
                                <label for="__ExtCheckbox2">
                                    是否样品发货</label>
                            </td>
                        </tr>
                        <%--<tr>
                            <td>信用额度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fLowTotal" Z_readOnly="True"
                                    Width="120px" Z_NoSave="True" />
                            </td>
                            <td>客户余额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fShouldReceTotal" Z_readOnly="True"
                                    Width="120px" Z_NoSave="True" />
                            </td>
                        </tr>--%>
                        <tr>
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                                    Z_Required="False" Width="120px" />
                            </td>
                            <td>制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" Width="120px" />
                            </td>
                            <td>备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" Style="width: 99%" Z_FieldID="sReMark" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="通知明细">
                            <!--  子表1  -->
                            <table id="table1" tablename="SDSendD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divOrderMenu" style="display: none;">
        <table>
            <tr>
                <td>下单日期从
                </td>
                <td>
                    <input id="txbMenuDateFrom" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>至
                </td>
                <td>
                    <input id="txbMenuDateTo" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>交期从
                </td>
                <td>
                    <input id="txbMenuOrderDateFrom" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>至
                </td>
                <td>
                    <input id="txbMenuOrderDateTo" class="easyui-datebox" style="width: 100px;" type="text" />
                </td>
                <td>客户
                </td>
                <td>
                    <input id="txbMenuCustomer" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="#" onclick="loadSContractD()">查询</a>
                </td>
                <td style="padding-left: 10px;">
                    <a class="button orange" href="#" onclick="TurnTo()">转入</a>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

