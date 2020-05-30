<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>


<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.beforeInit = function () {
            if (getQueryString("iOrderType") == "0") {
                $("#divSup").hide();
                $("#spanSup").hide();
                $("#spanProDate").html("生产交期");
                //$("#__ExtCheckbox21").remove();
                $("#labelRepIn").html("委托供销");
                //$("#spanOrderTotal").remove();
                //$("#__ExtTextBox216").remove();
                $("#spanPurTotal").remove();
                $("#__ExtTextBox217").remove();
                //$("#labelRepIn").html("是否客户代销");
            }
            if (getQueryString("iOrderType") == "1") {
                $("#table1").remove();
                $("#divProDate").hide();
                $("#spanProDate").hide();
                $("#spanOrderQty").remove();
                $("#labelRepIn").html("受托供销");
                $("#__ExtTextBox214").remove();
                $("#spanProduceQty").html("数量");
                //$("#spanOrderTotal").remove();
                //$("#__ExtTextBox216").remove();
                $("#spanPurTotal").remove();
                $("#__ExtTextBox217").remove();
                $("#trRowHide").hide();
            }
            if (getQueryString("iOrderType") == "3") {
                //                $("#divProDate").hide();
                //                $("#spanProDate").hide();
                $("#spanProDate").html("采购交期");
                $("#spanProduceQty").html("采购数量");
                $("#__ExtCheckbox21").remove();
                $("#labelRepIn").remove();
            }
            if (getQueryString("iOrderType") == "4") {
                $("#divSup").hide();
                $("#spanSup").hide();
                $("#spanProDate").html("生产交期");
                $("#table1").remove();
                //$("#divProDate").hide();
                //$("#spanProDate").html("供应商");
                $("#spanOrderQty").remove();
                $("#__ExtTextBox214").remove();
                $("#spanProduceQty").html("数量");
                $("#spanOrderTotal").remove();
                $("#__ExtTextBox216").remove();
                $("#spanPurTotal").remove();
                $("#__ExtTextBox217").remove();
                $("#labelRepIn").remove();
                $("#__ExtCheckbox21").remove();
                $("#spanOrderDate").remove();
                $("#divOrderDate").remove();
            }
        }
        $(function () {
            Page.Formula = function (field) {
                if (field == "dOrderDate") {
                    var newValue = Page.getFieldValue(field);
                    var iProduceDays = Page.sysParms.iProduceDays ? isNaN(parseInt(Page.sysParms.iProduceDays)) ? 0 : parseInt(Page.sysParms.iProduceDays) : 0;
                    var produceDate = AddDays(newValue, iProduceDays * -1);
                    Page.setFieldValue("dProduceDate", produceDate);
                }

            }
            //为客户订单时，关闭生产明细的增加按钮，隐藏单价列
            if (getQueryString("iOrderType") == "0") {
                Page.Children.toolBarBtnDisabled("table2", "add");
                $("#table2").datagrid("hideColumn", "fPrice");
                //$("#__ExtTextBox21").textbox("textbox").addClass("txbrequired");
                if (Page.usetype == "modify") {
                    //Page.setFieldDisabled("sSizeGroupID");
                }
            }
            //条码订单只保留生产明细
            if (getQueryString("iOrderType") == "1") {
                $("#divTableTab").tabs("close", "订单明细");
                Page.setFieldValue("dProduceDate", "2000-01-01");
                if (Page.usetype == "add") {
                    Page.setFieldDisabled("iSupBscDataCustomerRecNo");
                }
                else {
                    var checked = $("#__ExtCheckbox21")[0].checked;
                    if (checked) {
                        Page.setFieldEnabled("iSupBscDataCustomerRecNo");
                    }
                    else {
                        Page.setFieldValue("iSupBscDataCustomerRecNo", "");
                        Page.setFieldDisabled("iSupBscDataCustomerRecNo");

                    }
                }
                $("#__ExtCheckbox21").bind("click", function () {
                    var checked = $("#__ExtCheckbox21")[0].checked;
                    if (checked) {
                        Page.setFieldEnabled("iSupBscDataCustomerRecNo");
                    }
                    else {
                        Page.setFieldValue("iSupBscDataCustomerRecNo", "");
                        Page.setFieldDisabled("iSupBscDataCustomerRecNo");
                    }
                });
            }
            //为成衣采购单时，生产订单明细不可增加，将标题改为采购明细
            if (getQueryString("iOrderType") == "3") {
                Page.Children.toolBarBtnDisabled("table2", "add");
                Page.setFieldValue("dProduceDate", "2000-01-01");
                var tab2 = $("#divTableTab").tabs("getTab", "生产明细");
                $("#divTableTab").tabs("update", { tab: tab2, options: { title: "采购明细" } });
                $("#__ExtTextBox5").textbox("textbox").addClass("txbrequired");
            }
            if (getQueryString("iOrderType") == "4") {
                $("#divTableTab").tabs("close", "订单明细");
                $("#__process").hide();
            }
            if (Page.usetype == "add") {
                var orderType = getQueryString("iOrderType");
                Page.setFieldValue("iOrderType", orderType);
                Page.setFieldValue("iStatus", "0");
                Page.setFieldValue("sCurrencyID", "01");
                //Page.setFieldValue("sSizeGroupID", "0901")
            }
            if (Page.usetype == "add" || Page.usetype == "modify") {
                if (getQueryString("iOrderType") == "0" || getQueryString("iOrderType") == "3") {
                    Page.Children.toolBarBtnAdd("table2", "import", "从订单明细转入", "import", function () {
                        var orderRows = $("#table1").datagrid("getRows");
                        var produceRows = DeepCopy(orderRows)
                        $("#table2").datagrid("loadData", produceRows);
                        Page.Children.ReloadFooter("table2");
                        Page.Children.ReloadDynFooter("table2");
                    });
                }
            }

            Page.Children.onAfterEdit = function (tableid, index, row, changes) {
                if (tableid == "table1" && getQueryString("iOrderType") == "0") {
                    if (datagridOp.currentColumnName == "dOrderDate") {
                        var orderDate = row.dOrderDate;
                        if (orderDate != undefined && orderDate != null && orderDate != "") {
                            var iProduceDays = Page.sysParms.iProduceDays ? isNaN(parseInt(Page.sysParms.iProduceDays)) ? 0 : parseInt(Page.sysParms.iProduceDays) : 0;
                            var produceDate = AddDays(orderDate, iProduceDays * -1);
                            var updateData = {
                                dProduceDate: produceDate
                            };
                            $("#table1").datagrid("updateRow", { index: index, row: updateData });
                        }
                    }
                }
            }
            Page.beforeSave = function () {
                if (getQueryString("iOrderType") == "0") {
                    var dDate = Page.getFieldValue("dDate");
                    var dProduceDate = Page.getFieldValue("dProduceDate");
                    var dOrderDate = Page.getFieldValue("dOrderDate");
                    if (dDate > dProduceDate) {
                        Page.MessageShow("签单日期不能大于生产交期", "签单日期不能大于生产交期");
                        return false;
                    }
                    if (dProduceDate > dOrderDate) {
                        Page.MessageShow("生产交期不能大于订单交期", "生产交期不能大于订单交期");
                        return false;
                    }

                    var orderDetailRows = $("#table1").datagrid("getRows");

                    var proDetailRows = $("#table2").datagrid("getRows");
                    for (var i = 0; i < proDetailRows.length; i++) {

                        var exists = false;
                        for (var j = 0; j < orderDetailRows.length; j++) {
                            if (orderDetailRows[j].dOrderDate && orderDetailRows[j].dProduceDate && orderDetailRows[j].dOrderDate < orderDetailRows[j].dProduceDate) {
                                Page.MessageShow("生产交期不能大于订单交期", "订单明细第" + (j + 1) + "行，生产交期不能大于订单交期");
                                return false;
                            }
                            if (proDetailRows[i].iRecNo == orderDetailRows[j].iRecNo && proDetailRows[i].iBscDataStyleMRecNo == orderDetailRows[j].iBscDataStyleMRecNo && proDetailRows[i].iBscDataColorRecNo == orderDetailRows[j].iBscDataColorRecNo) {
                                exists = true;
                                break;
                            }
                        }
                        if (exists == false) {
                            $.messager.alert("错误", "生产明细中的数据必须与相应订单明细相同！如果是复制，请先删除生产明细再重新转入");
                            return false;
                        }
                    }
                }
                if (getQueryString("iOrderType") == "1") {
                    if (Page.getFieldValue("iRepIn") == "1") {
                        if (Page.getFieldValue("iSupBscDataCustomerRecNo") == "") {
                            Page.MessageShow("供应商不能为空", "为受托代销时，供应商不能为空！");
                            return false;
                        }
                    }
                }
                if (getQueryString("iOrderType") == "3") {
                    var ibscDataSup = Page.getFieldValue("iSupBscDataCustomerRecNo");
                    if (ibscDataSup == "") {
                        Page.MessageShow("供应商不能为空", "供应商不能为空");
                        return false;
                    }

                    var orderDetailRows = $("#table1").datagrid("getRows");
                    for (var j = 0; j < orderDetailRows.length; j++) {
                        if (orderDetailRows[j].dOrderDate && orderDetailRows[j].dProduceDate && orderDetailRows[j].dOrderDate < orderDetailRows[j].dProduceDate) {
                            Page.MessageShow("采购交期不能大于订单交期", "订单明细第" + (j + 1) + "行，采购交期不能大于订单交期");
                            return false;
                        }
                    }
                }
                var iColorOnly = getQueryString("iColorOnly");
                if (getQueryString("iColorOnly") == "1") {
                    var rows = $("#table1").datagrid("getRows");
                    for (var i = 0; i < rows.length; i++) {
                        for (var j = i + 1; j < rows.length; j++) {
                            if (rows[i].iBscDataStyleMRecNo == rows[j].iBscDataStyleMRecNo && rows[i].iBscDataColorRecNo == rows[j].iBscDataColorRecNo) {
                                Page.MessageShow("同一款号颜色不可重复", "订单明细：第" + (i + 1) + "和" + (j + 1) + "行的款号、颜色重复！");
                                return false;
                            }
                        }
                    }
                }
            }
            Page.Children.toolBarBtnAdd("table1", "import", "导入", "import", function () {
                Page.Children.btnImport("table1");
            })

            //            var options = $("#table1").datagrid("options");
            //            options.columns[0].splice(7, 0,
            //                {
            //                    title: "查看库存",
            //                    field: "__dddd",
            //                    formatter: function (value, row, index) {
            //                        return "<a href='javascript:void(0)' onclick='alert(1)'>查看库存</a>";
            //                    },
            //                    width: 70,
            //                    align: "center"
            //                }
            //                );
            //            delete options.url;
            //            $("#table1").datagrid(options);
        })
        function AddDays(date, days) {
            var nd = new Date(date);
            nd = nd.valueOf();
            nd = nd + days * 24 * 60 * 60 * 1000;
            nd = new Date(nd);
            // alert(nd.getFullYear() + "年" + (nd.getMonth() + 1) + "月" + nd.getDate() +
            // "日");
            var y = nd.getFullYear();
            var m = nd.getMonth() + 1;
            var d = nd.getDate();
            if (m <= 9) m = "0" + m;
            if (d <= 9) d = "0" + d;
            var cdate = y + "-" + m + "-" + d;
            return cdate;
        }
        lookUp.IsConditionFit = function (uniqueid) {
            //从款式颜色明细表转入
            //58客户订单明细64 客户生产订单明细   90条码订单明细   97成衣采购单订单明细  101成衣采购单采购订单明细
            if (uniqueid == "58" || uniqueid == "64" || uniqueid == "90" || uniqueid == "97" || uniqueid == "101") {
                if (Page.sysParms.iColorFrom != undefined && Page.sysParms.iColorFrom == 1) {
                    return true;
                }
            }
            //从颜色表转入
            //60客户订单明细 66客户生产订单明细  89条码订单明细   89成衣采购单订单明细  100成衣采购单采购订单明细
            if (uniqueid == "60" || uniqueid == "66" || uniqueid == "89" || uniqueid == "98" || uniqueid == "100") {
                if (Page.sysParms.iColorFrom !== undefined && (Page.sysParms.iColorFrom == 0 || Page.sysParms.iColorFrom == '')) {
                    return true;
                }
            }
        }
        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            if (uniqueid == "56") {
                var rows = $("#table1").datagrid("getRows");
                var theRow = rows[rowIndex];
                if (theRow.fPrice == undefined || theRow.fPrice == null) {
                    var sqlObj = {
                        TableName: "vwSDContractMD",
                        Fields: " top 1 fPrice",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iBscDataCustomerRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iOrderType",
                                ComOprt: "=",
                                Value: "1",
                                LinkOprt: "and"
                            },
                            {
                                Field: "fPrice",
                                ComOprt: ">",
                                Value: "0",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataStyleMRecNo",
                                ComOprt: "=",
                                Value: "'" + theRow.iBscDataStyleMRecNo + "'"
                            }
                        ],
                        Sorts: [
                            { SortName: "dInputDate", SortOrder: "desc" }
                        ]
                    }
                    var dataResult = SqlGetData(sqlObj);
                    if (dataResult.length > 0) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: { fPrice: dataResult[0].fPrice } });
                    }
                }

            }
        }
        //动态列编辑，总金额变化
        //        Page.Children.DynFieldAfterEdit = function (tableid, index) {
        //            if (tableid == "table1") {
        //                var dynFields = Page.Children.GetDynColumns("table1");
        //                var row = $("#table1").datagrid("getRows")[index];
        //                var sumQty = 0;
        //                for (var i = 0; i < dynFields.length; i++) {
        //                    if (row[(dynFields[i])]) {
        //                        var dQty = isNaN(parseInt(row[(dynFields[i])])) ? 0 : parseInt(row[(dynFields[i])]);
        //                        sumQty += dQty;
        //                    }
        //                }
        //                var fPrice = isNaN(parseFloat(row.fPrice)) ? 0.00 : parseFloat(row.fPrice);
        //                var fTotal = sumQty * fPrice;
        //                if (fTotal > 0) {
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fTotal: fTotal} });
        //                }
        //            }
        //        }
        onImportExcelSuccess = function (tableName, tableid) {
            var jsonobj = {
                StoreProName: "SpImportTest",
                StoreParms: [{
                    ParmName: "@sTableName",
                    Value: tableName
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result == "1") {
                setImportFinishInfo("导入成功！");
            }
            else {
                setImportFinishInfo(result);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="">
            <!--隐藏字段-->
            <div id="divHid" style="display: none;">
                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iOrderType" />
                <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="sCurrencyID" />
                <cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="iStatus" />
            </div>
            <!—如果只有一个主表，这里的north要变为center-->
                        <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td>订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="True" />
                    </td>
                    <td>客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo" Z_Required="true" />
                        <%--Z_Required="True"--%>
                    </td>
                    <td>签单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Z_Required="True" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRepIn" />
                        <label id="labelRepIn" for="__ExtCheckbox21">
                            <%--<cc1:ExtFile ID="ExtFile1" runat="server" />--%>
                            内部代销</label>
                    </td>
                </tr>
                <tr>

                    <td>业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sSaleID" Style="width: 120px;" />
                    </td>
                    <td>跟单员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sTraceID" />
                    </td>
                    <td>部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sDeptID" />
                    </td>
                    <td>
                        <span id="spanSup">供应商</spanSupplier>
                    </td>
                    <td>
                        <div id="divSup">
                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iSupBscDataCustomerRecNo" />
                        </div>
                    </td>
                </tr>
                <tr id="trRowHide">
                    <td>
                        <span id="spanOrderDate">订单交期</span>
                    </td>
                    <td>
                        <div id="divOrderDate">
                            <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                        </div>
                    </td>
                    <td>
                        <span id="spanProDate">生产交期</span>
                    </td>
                    <td>
                        <div id="divProDate">
                            <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期" />
                        </div>
                    </td>
                    <td>商标
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sLogon" />
                    </td>
                    <td>洗唛/吊牌
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sTag" Z_readOnly="true" />
                    </td>
                </tr>
                <tr>
                    <td>尺码组
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sSizeGroupID" Z_Required="True" />
                    </td>
                    <td>备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Z_Required="False" />
                    </td>

                </tr>
                <tr style="display:none;">
                    <td>
                        <span id="spanOrderQty">订单数量</span>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox214" runat="server" Z_FieldID="iQty" Z_readOnly="True" />
                    </td>
                    <td>
                        <span id="spanProduceQty">生产数量</span>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="iProduceQty" Z_readOnly="True" />
                    </td>
                    <td>
                        <span id="spanOrderTotal">订单金额</span>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
                    </td>
                    <td>
                        <span id="spanPurTotal">采购金额</span>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox217" runat="server" Z_FieldID="fPurTotal" Z_readOnly="True" />
                    </td>
                </tr>
                <%--<tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td>
                                                <cc1:ExtFile ID="ExtFile2" runat="server" Z_FileType="附件" Z_FileSize="10" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>--%>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="订单明细" id="tabOrderDetail">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDContractD">
                    </table>
                </div>
                <div id="divTable2" data-options="fit:true" title="生产明细" id="tabOrderProductDetail">
                    <!--  子表2  -->
                    <table id="table2" tablename="SDContractDProduce">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
