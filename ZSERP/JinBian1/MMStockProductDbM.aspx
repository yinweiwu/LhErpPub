<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            if (Page.usetype == "add") {
                var sqlObj = {
                    //表名或视图名
                    TableName: "bscDataPeriod",
                    //选择的字段
                    Fields: "sYearMonth",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            //左括号
                            //字段名
                            Field: "convert(varchar(50),GETDATE(),23)",
                            //比较符
                            ComOprt: ">=",
                            //值
                            Value: "dBeginDate",
                            //连接符
                            LinkOprt: "and"
                        },
                                {
                                    Field: "convert(varchar(50),GETDATE(),23)",
                                    ComOprt: "<=",
                                    Value: "dEndDate"
                                }
                        ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }
            }
            $("#txtBarcode").focus();
        })
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (Page.getFieldValue("iOutBscDataStockMRecNo") == "") {
                    Page.MessageShow("错误", "请选择调出仓库！");
                    return;
                }
                if (barcode != "") {
                    var rows = $("#table1").datagrid("getRows");
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == barcode) {
                                alert("条码已存在！");
                                return false;
                            }
                        }
                    }
                    var sqlObj = { TableName: "MMStockQty",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                        { Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", LinkOprt: "and" },
                        { Field: "fQty", ComOprt: ">", Value: "0", LinkOprt: "and" },
                        { Field: "iBscDataStockMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iOutBscDataStockMRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataStockDRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iOutBscDataStockDRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataMatRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataColorRecNo") + "'", LinkOprt: "and" },
                        { Field: "fProductWidth", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWidth") + "'", LinkOprt: "and" },
                        { Field: "fProductWeight", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWeight") + "'" }
                        ]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var addRow = [{
                            sBarCode: data[0].sBarCode,
                            sBatchNo: data[0].sBatchNo,
                            sReelNo: data[0].sReelNo,
                            fQty: data[0].fQty,
                            fPurQty: data[0].fPurQty,
                            sLetCode: data[0].sLetCode,
                            iOutSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            iInSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            iOutBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iInBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo
                        }];
                        Page.tableToolbarClick("add", "table1", addRow[0]);
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                        //PlayVoice("条码" + barcode + "不存在");
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
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单据号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        调拨日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        调出仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iOutBscDataStockMRecNo" />
                    </td>
                    <td>
                        调入仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iInBscDataStockMRecNo" />
                    </td>
                </tr>
                <tr>
                    <%--<td>
                        调出仓位</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="iOutBscDataStockDRecNo" />
                    </td>
                    <td>
                        调入仓位</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="iInBscDataStockDRecNo" />
                    </td>--%>
                    <td>
                        调出订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" Z_FieldID="iOutSdOrderMRecNo" runat="server" />
                    </td>
                    <td>
                        调入订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" Z_FieldID="iInSdOrderMRecNo" runat="server" />
                    </td>
                </tr>
                <tr>
                    <%--<td>
                        调出客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iOutBscDataCustomerRecNo" />
                    </td>
                    <td>
                        调入客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iInBscDataCustomerRecNo" />
                    </td>--%>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iBscDataMatRecNo" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iBscDataColorRecNo" />
                    </td>
                    <td>
                        颜色
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                    </td>
                    <td>
                        克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="737px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>请扫入条码</strong>
                    </td>
                    <td colspan="3">
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 335px;
                            height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                    </td>
                    <td colspan="4">
                        <textarea id="txaBarcodeTip" style="height: 40px; width: 260px;" readonly="readonly"
                            class="txb"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调拨明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="MMStockProductDbD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
