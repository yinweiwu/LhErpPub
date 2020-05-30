<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="JS/MMStockInM.js?<%= Guid.NewGuid() %>" type="text/javascript">
    </script>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (getQueryString("sType") == "2" || getQueryString("iBillType") == "2") {
                $("#tdInvoiceLabel").hide();
                $("#tdInvoice").hide();
                $("#tdOutTotalLabel").hide();
                $("#tdOutTotal").hide();
                $("#tdBscDataCustomerRecNoLabel").html("客户");

            }
        })

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "dDate") {
                    var dDate = Page.getFieldValue("dDate");
                    var SqlObjYearMonth = {
                        TableName: "bscDataPeriod",
                        Fields: "sYearMonth",
                        SelectAll: "True",
                        Filters: [
                {
                    Field: "dBeginDate",
                    ComOprt: "<=",
                    Value: "'" + dDate + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "dEndDate",
                    ComOprt: ">=",
                    Value: "'" + dDate + "'"
                }
            ]
                    }
                    var resultYearMonth = SqlGetData(SqlObjYearMonth);
                    if (resultYearMonth.length > 0) {
                        Page.setFieldValue("sYearMonth", resultYearMonth[0].sYearMonth);
                    }
                    checkMonth();
                }
            }
        }

        function checkMonth() {
            var sYearMonth = Page.getFieldValue("sYearMonth");
            var stockRecNo = Page.getFieldValue("iBscDataStockMRecNo");
            var SqlObj = {
                TableName: "MMStockMonthM",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + stockRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sYearMonth",
                        ComOprt: "=",
                        Value: "'" + sYearMonth + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "'4'"
                    }
                ]
            };
            var result = SqlGetData(SqlObj);
            if (result.length > 0) {
                Page.MessageShow("仓库此月份已月结", "对不起，此仓库此月份已月结！");
                return false;
            }
        }

        Page.beforeSave = function () {
            if (checkMonth == false) {
                return false;
            }
        }

        dataForm.beforeOpen = function (uniqueid) {
            if (getQueryString("iPur") == "1") {
                if (uniqueid == "288" || uniqueid == "292" || uniqueid == "370") {
                    $.messager.alert("提醒", "纱线入库只能从采购订单入库！");
                    return false;
                }
            }
            if (uniqueid == "370") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    $.messager.alert("非红冲不可转入", "非红冲不可从物料入库单列表转入！");
                    return false;
                }
            }
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                if (uniqueid == "288") {
                    $.messager.alert("红冲不可转入", "红冲只能从入库单、库存转入、采购订单转入！");
                    return false;
                }
            }
        }
        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "370") {
                row.fQty = isNaN(Number(row.fQty)) ? 0 : Number(row.fQty) * -1;
                row.fPurQty = isNaN(Number(row.fPurQty)) ? 0 : Number(row.fPurQty) * -1;
                row.iQty = isNaN(Number(row.iQty)) ? 0 : Number(row.iQty) * -1;
                row.fTotal = isNaN(Number(row.fTotal)) ? 0 : Number(row.fTotal) * -1;
                return row;
            }
        }

        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var allRows = $("#MMStockInD").datagrid("getRows");
                for (var i = 0; i < allRows.length; i++) {
                    var fQty = isNaN(Number(allRows[i].fQty)) ? 0 : Number(allRows[i].fQty);
                    var fPurQty = isNaN(Number(allRows[i].fPurQty)) ? 0 : Number(allRows[i].fPurQty);
                    var iQty = isNaN(Number(allRows[i].iQty)) ? 0 : Number(allRows[i].iQty);
                    var fTotal = isNaN(Number(allRows[i].fTotal)) ? 0 : Number(allRows[i].fTotal);
                    var updateRow = {};
                    if (fQty > 0) {
                        updateRow.fQty = fQty * -1;
                    }
                    if (fPurQty > 0) {
                        updateRow.fPurQty = fPurQty * -1;
                    }
                    if (iQty > 0) {
                        updateRow.iQty = iQty * -1;
                    }
                    if (fTotal > 0) {
                        updateRow.fTotal = fTotal * -1;
                    }
                    $("#MMStockInD").datagrid("updateRow", { index: i, row: updateRow });
                }
            }
        }

        lookUp.IsConditionFit = function (uniqueid) {
            if (uniqueid == "1316") {
                if (Page.getFieldValue("iCust") != "1") {
                    return true;
                }
            }
            if (uniqueid == "1318") {
                if (Page.getFieldValue("iCust") == "1") {
                    return true;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        入库仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iBerCh" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iPurOrder" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sMatClass" Z_NoSave="true"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox200" runat="server" Z_FieldID="iBillType" Z_NoSave="false"
                            Style="display: none;" />
                    </td>
                    <td id="tdBscDataCustomerRecNoLabel">
                        供应商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        入库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true" />
                    </td>
                    <td>
                        检验员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sYearMonth" Z_disabled="true"
                            Z_Required="true" />
                    </td>
                    <td id="tdInvoiceLabel">
                        <span id="spanInvoice">发票号</span>
                    </td>
                    <td id="tdInvoice">
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sInvoice" />
                    </td>
                </tr>
                <tr>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true" />
                    </td>
                    <td id="tdOutTotalLabel">
                        <span id="spanProTotal">加工费</span>
                    </td>
                    <td id="tdOutTotal">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fOutTotal" Z_disabled="true" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox2">
                            红冲</label>
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCust" />
                        <label for="__ExtCheckbox1">
                            客供</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        检验单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox199" runat="server" Z_FieldID="sCheckBillNo" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true"
                            Z_FieldType="时间" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        <%--<cc1:ExtHidden2 ID="ExtHidden1"  runat="server" Z_FieldID="iPurType" Z_Value="0"/>--%>
                    </td>
                </tr>
                <tr>
                    <td>
                        所属单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                    </td>
                    <td>
                        仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
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
            </table>
            <hr />
            <table class="tabmain">
                <tr>
                    <td>
                        条码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBarCode" Z_NoSave="true"
                            Font-Bold="True" Style="border: 0px; border-bottom: 1px solid black;" Height="21px" />
                    </td>
                    <td colspan="2">
                        <textarea id="sbarcoderemark" style="border-bottom: 1px solid black; height: 21px;
                            border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                            border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                            border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                    </td>
                    <%-- <td>
                        仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
                    </td>--%>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--  子表1  -->
                    <table id="MMStockInD" tablename="MMStockInD">
                    </table>
                </div>
                <%-- <div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
