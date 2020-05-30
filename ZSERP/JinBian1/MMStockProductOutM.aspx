<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        $(function () {
            //            Page.Children.toolBarBtnDisabled("SDOrderD", "add");
            //            Page.Children.toolBarBtnDisabled("SDOrderD", "copy");

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

                //                $("#tabTop").tabs({
                //                    tools: [{
                //                        iconCls: 'icon-search',
                //                        handler: function () {
                //                            searchSDSendD();
                //                        }
                //                    }
                //                        ]
                //                });

                //                $("#ProOutProduceD").datagrid(
                //                {
                //                    fit: true,
                //                    border: false,
                //                    remoteSort: false,
                //                    singleSelect: true,
                //                    columns: [[
                //                        { title: "加工单号", field: "sBillNo", width: 110, sortable: true },
                //                        { title: "出库", field: "btnOut", width: 80, align: "center", formatter: function (value, row, index) {
                //                            var str = JSON2.stringify(row);
                //                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnOut(" + str + ", " + index + ")' value='出库' />";
                //                            return btnStr;
                //                        }
                //                        },
                //                        { title: "加工厂家", field: "sCustShortName", width: 80, sortable: true },
                //                        { title: "订单号", field: "sOrderNo", width: 120, sortable: true },
                //                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                //                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                //                        { title: "加工重量", field: "fWeight", width: 80, sortable: true },
                //                        { title: "未出库重量", field: "fNoOutWeight", width: 80, sortable: true },
                //                        { title: "色号", field: "sColorID", width: 80, sortable: true },
                //                        { title: "颜色名称", field: "sColorName", width: 80, sortable: true },
                //                        { field: "iRecNo", hidden: true }
                //                    ]],
                //                    onDblClickRow: function (index, row) {
                //                        btnOut(row, index);
                //                    }
                //                }
                //                );
                //                searchSDSendD();
            }
            else if (Page.usetype == "modify" || Page.usetype == "view") {
                //                $("#tabTop").tabs("close", "未出库加工单");

                //                var sqlobj2 = { TableName: "vwMMStockProductOutM",
                //                    Fields: "iProOutProduceDRecNo,sOutProduceBillNo,sOutProduceCode,sOutProduceName,sOutProduceColorID,sOutProduceColorName,sOutProduceBillNo,sOutProduceCustShortName,sOutProduceOrderNo,iOutProduceSdOrderMRecNo,iOutProduceBscDataMatRecNo,iOutProduceBscDataColorRecNo",
                //                    SelectAll: "True",
                //                    Filters: [
                //                    {
                //                        //字段名
                //                        Field: "iRecNo",
                //                        //比较符
                //                        ComOprt: "=",
                //                        //值
                //                        Value: Page.key
                //                    }
                //                    ]

                //                }
                //                var data2 = SqlGetData(sqlobj2);

                //                Page.setFieldValue('iProOutProduceDRecNo', data2[0].iProOutProduceDRecNo);
                //                Page.setFieldValue('sOutProduceBillNo', data2[0].sOutProduceBillNo);
                //                Page.setFieldValue('sCustShortName', data2[0].sOutProduceCustShortName);
                //                Page.setFieldValue('sOrderNo', data2[0].sOutProduceOrderNo);
                //                Page.setFieldValue('sCode', data2[0].sOutProduceCode);
                //                Page.setFieldValue('sName', data2[0].sOutProduceName);
                //                Page.setFieldValue('sColorID', data2[0].sOutProduceColorID);
                //                Page.setFieldValue('sColorName', data2[0].sOutProduceColorName);
                //                Page.setFieldValue('iBscDataMatRecNo', data2[0].iOutProduceBscDataMatRecNo);
                //                Page.setFieldValue('iBscDataColorRecNo', data2[0].iOutProduceBscDataColorRecNo);
                //                Page.setFieldValue('iSdOrderMRecNo', data2[0].iOutProduceSdOrderMRecNo);
                //                //Page.setFieldValue('iBscDataCustomerRecNo', data2[0].iBscDataCustomerRecNo);
            }
        });

        //        function btnOut(row, index) {
        //            Page.setFieldValue("iProOutProduceDRecNo", row.iRecNo);
        //            Page.setFieldValue("sOutProduceBillNo", row.sBillNo);
        //            Page.setFieldValue("sCustShortName", row.sCustShortName);
        //            Page.setFieldValue("sOrderNo", row.sOrderNo);
        //            Page.setFieldValue("sCode", row.sCode);
        //            Page.setFieldValue("sName", row.sName);
        //            Page.setFieldValue("sColorID", row.sColorID);
        //            Page.setFieldValue("sColorName", row.sColorName);
        //            Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo);
        //            Page.setFieldValue("iBscDataColorRecNo", row.iBscDataColorRecNo);
        //            Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
        //            //Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
        //            $("#tabTop").tabs("select", "领用出库单");
        //        }

        //        function searchSDSendD() {
        //            var sqlObjSDSendD = {
        //                TableName: "vwProOutProduceMD",
        //                Fields: "*",
        //                Filters: [
        //                    {
        //                        Field: "iBillType",
        //                        ComOprt: "=",
        //                        Value: "2",
        //                        LinkOprt: "and"
        //                    },
        //                    {
        //                        Field: "iStatus",
        //                        ComOprt: "=",
        //                        Value: "4",
        //                        LinkOprt: "and"
        //                    },
        //                    {
        //                        Field: "fNoOutWeight",
        //                        ComOprt: ">",
        //                        Value: "0"
        //                    }
        //                ],
        //                SelectAll: "True",
        //                Sorts: [
        //                {
        //                    SortName: "iRecNo",
        //                    SortOrder: "asc"
        //                }
        //                ]
        //            };
        //            var resultSDSendD = SqlGetData(sqlObjSDSendD);
        //            if (resultSDSendD.length > 0) {
        //                $("#ProOutProduceD").datagrid("loadData", resultSDSendD);
        //            }
        //        }


        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    var rows = $("#MMStockProductOutD").datagrid("getRows");
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == barcode) {
                                alert("条码已存在！");
                                return false;
                            }
                        }
                    }
                    var sqlObj = { TableName: "vwMMStockQty",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                                { Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", LinkOprt: "and" },
                                { Field: "fQty", ComOprt: ">", Value: "0", LinkOprt: "and" },
                                { Field: "iBscDataStockMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'", LinkOprt: "and" },
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
                            sCustShortName: data[0].sCustShortName,
                            iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                            iStockSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            sBerChID: data[0].sBerChID
                        }];

                        Page.tableToolbarClick("add", "MMStockProductOutD", addRow[0]);
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

        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }

        Page.beforeSave = function () {
            var typeName = Page.getFieldValue("sTypeName");
            if (typeName == "加工出库") {
                var iProOutProduceDRecNo = Page.getFieldValue("iProOutProduceDRecNo");
                if (iProOutProduceDRecNo == "") {
                    Page.MessageShow("加工单号不能为空", "加工出库时，加工单号不能为空！");
                    return false;
                }
            }
            else {
                var fQty = Page.getFieldValue("fQty");
                if (fQty == "") {
                    Page.MessageShow("加工单号不能为空", "样品出库时，长度不能为空！");
                    return false;
                }
            }
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "MMStockProductOutD") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fQty: fQty} });
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div style="display: none;">
            <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iBillType" />
            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                Z_FieldType="数值" Z_decimalDigits="2" Style="display: none;" />
            <%--<cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iProOutProduceDRecNo"
                Style="display: none;" />--%>
            <%--<cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataMatRecNo" Style="display: none;"
                Z_NoSave="True" />
            <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBscDataColorRecNo"
                Style="display: none;" Z_NoSave="True" />--%>
            <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iSdOrderMRecNo" Style="display: none;"
                Z_NoSave="True" />
            <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
        </div>
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        出库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        出库日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Width="150px" />
                    </td>
                    <td>
                        出库类型
                    </td>
                    <td>
                        <%--<cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="display: none;" Z_NoSave="True" />--%>
                        <cc1:ExtSelect2 ID="ExtSelect21" runat="server" Z_FieldID="sTypeName" Width="121px"
                            Z_Options="样品出库" />
                    </td>
                </tr>
                <tr>
                    <%--<td>
                        成品加工单
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iProOutProduceDRecNo" />
                    </td>--%>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <%-- <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>--%>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox1">
                            红冲</label>
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBscDataMatRecNo" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iBscDataColorRecNo" />
                    </td>
                    <td>
                        颜色名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox214" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                    </td>
                    <td>
                        克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sRemark" Width="341px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>
                        长度
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fPurQty" Z_readOnly="True"
                            Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iCalc" Z_NoSave="true" runat="server" />
                        <label for="__ExtCheckbox2">
                            米数转重量</label>
                    </td>
                    <td>
                    </td>
                    <td>
                        发货通知单
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iSDSendDRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>请扫入条码</strong>
                    </td>
                    <td colspan="3">
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 300px;
                            height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                    </td>
                    <td colspan="4">
                        <textarea id="txaBarcodeTip" style="height: 40px; width: 260px;" readonly="readonly"
                            class="txb"></textarea>
                    </td>
                </tr>
                <tr style="display: none;">
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Z_Required="False" Width="120px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="120px" />
                    </td>
                    <%--<td>
                                出库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sCompany" />
                            </td>--%>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="领用出库单明细">
                    <!--  子表1  -->
                    <table id="MMStockProductOutD" tablename="MMStockProductOutD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
