<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript" language="javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("MMStockProductDbD", "add"); 
            dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
                if (uniqueid == 438) {
                    var iSDContractDProcessDRecNo = Page.getFieldValue("iSDContractDProcessDRecNo");
                    row.iInSDContractDProcessDRecNo = (iSDContractDProcessDRecNo == "" ? row.iOutSDContractDProcessDRecNo : Page.getFieldText("iSDContractDProcessDRecNo"));
                }
                return row;
            }
        })

        Page.beforeSave = function () {
            var d = Page.getFieldValue("dDate");
            Page.setFieldValue("sYearMonth", d.substring(0, 7));
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    var rows = $("#MMStockProductDbD").datagrid("getRows");
                    for (var j = 0; j < rows.length; j++) {
                        if (barcode == rows[j].sBarCode) {
                            alert("已扫描");
                            var oldMessage = $("#txaMessage").val();
                            oldMessage += "已扫描\n";
                            $("#txaMessage").val(oldMessage);
                            $("#txtBarcode").val("");
                            return false;
                        }
                    }
                    var iSDContractDProcessDRecNo = Page.getFieldValue("iSDContractDProcessDRecNo");
                    var iInBscDataStockDRecNo = Page.getFieldValue("iInBscDataStockDRecNo");
                    var filters = [
                            {
                                //字段名
                                Field: "sBarCode",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + barcode + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataStockMRecNo",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + Page.getFieldValue("iOutBscDataStockMRecNo") + "'"
                            }
                    ];
                    if (iSDContractDProcessDRecNo != "") {
                        filters[filters.length - 1].LinkOprt = "and";
                        filters.push(
                            {
                                Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iInBscDataMatRecNo") + "'", LinkOprt: "and"
                            }
                        );
                        filters.push({
                            Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iInBscDataColorRecNo") + "'"
                        });
                    }

                    var sqlObj = {
                        //表名或视图名
                        TableName: "vwMMStockQty",                       //选择的字段
                        Fields: "iRecNo,sReelNo,sBarCode,sCode,sName,sBatchNo,fProductWidth,fProductWeight,sColorID,fQty,fPurQty,iSDOrderMRecNoBatch,sOrderNo,sLetCode,sBerChID,iBscDataStockDRecNo,sOrderNoProcess,sContractNoProcess,sFlowerType,sProcessesName,iBscDataMatRecNo," +
                        "iBscDataColorRecNo,iSdOrderMRecNo,iBscDataCustomerRecNo,iBscDataStockDRecNo,iBscDataFlowerTypeRecNo,sTrayCode,iSDContractDProcessDRecNo",
                        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                        SelectAll: "True",
                        //过滤条件，数组格式
                        Filters: filters
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var appendRow = {
                            sReelNo: data[0].sReelNo,
                            sBarCode: data[0].sBarCode,
                            sCode: data[0].sCode,
                            sName: data[0].sName,
                            sBatchNo: data[0].sBatchNo,
                            fProductWidth: data[0].fProductWidth,
                            fProductWeight: data[0].fProductWeight,
                            sColorID: data[0].sColorID,
                            fQty: data[0].fQty,
                            fPurQty: data[0].fPurQty,
                            sLetCode: data[0].sLetCode,
                            iOutSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            sOutBerChID: data[0].sBerChID, 
                            iInBscDataStockDRecNo: (iInBscDataStockDRecNo == "" ? data[0].iBscDataStockDRecNo : iInBscDataStockDRecNo),
                            sOutOrderNoProcess: data[0].sOrderNoProcess,
                            sInOrderNoProcess: (iSDContractDProcessDRecNo == "" ? data[0].sOrderNoProcess : Page.getFieldText("iSDContractDProcessDRecNo")),
                            sTrayCode: data[0].sTrayCode,
                            sFlowerType: data[0].sFlowerType,
                            sProcessesName: data[0].sProcessesName,
                            iBscDataMatRecNo: data[0].iBscDataMatRecNo,
                            iBscDataColorRecNo: data[0].iBscDataColorRecNo,
                            iOutBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iInBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iOutBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                            iBscDataFlowerTypeRecNo: data[0].iBscDataFlowerTypeRecNo,
                            iOutSDContractDProcessDRecNo: data[0].iSDContractDProcessDRecNo,
                            iInSDContractDProcessDRecNo: (iSDContractDProcessDRecNo == "" ? data[0].iSDContractDProcessDRecNo : Page.getFieldText("iSDContractDProcessDRecNo")),
                            iQty: data[0].iQty,
                            sOutOrderNo: data[0].sOrderNo,
                            sInOrderNo: data[0].sOrderNo,
                            iOutSDOrderMRecNoBatch: data[0].iSDOrderMRecNoBatch,
                            iInSDOrderMRecNoBatch: data[0].iSDOrderMRecNoBatch
                    }
                    Page.tableToolbarClick("add", "MMStockProductDbD", appendRow);
                }
                else {
                    var oldMessage = $("#txaMessage").val();
                    oldMessage += "条码不存在\n";
                    $("#txaMessage").val(oldMessage);
                    if (iSDContractDProcessDRecNo != "") {
                        Page.MessageShow("有调入订单明细时，注意产品品名颜色一致", "有调入订单明细时，产品品名颜色需一致！");
                    }
                }
            }
            $("#txtBarcode").val("");
            $("#txtBarcode").focus();
            stopBubble($("#txtBarcode")[0]);                
        }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iInBscDataMatRecNo" Z_NoSave="true" />
                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iInBscDataColorRecNo" Z_NoSave="true" />
            </div>
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>调拔单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>调拔日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>调出仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iOutBscDataStockMRecNo" />
                    </td>
                    <td>调入仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iInBscDataStockMRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>调拨类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sTypeName" />
                    </td>
                    <td>会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                    </td>
                    <td>重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fPurQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                    </td>
                </tr>
                <tr>
                    <td>备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Style="width: 99%;" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" Z_readOnly="True" />
                    </td>
                    <td>调入订单明细
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSDContractDProcessDRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>条码
                    </td>
                    <td colspan="4">
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码"
                            style="width: 99%; height: 50px; font-size: 20px; font-weight: bold; background-color: pink;" class="txb" />
                    </td>
                    <td>
                        <textarea id="txaMessage" style="width: 99%; height: 50px;" readonly="readonly"></textarea>
                    </td>
                    <td>调入仓位</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldID="iInBscDataStockDRecNo" Z_NoSave="true" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调拔明细">
                    <!--  子表1  -->
                    <table id="MMStockProductDbD" tablename="MMStockProductDbD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
