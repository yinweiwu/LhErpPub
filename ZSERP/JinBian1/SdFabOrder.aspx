<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 843px;
        }
        .style2
        {
            width: 72px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        Page.beforeLoad = function () {
            $(function () {

                Page.Children.toolBarBtnDisabled("SDOrderD", "add");
                Page.Children.toolBarBtnDisabled("SDOrderD", "delete");
                Page.Children.toolBarBtnDisabled("SDOrderD", "copy");
            });

            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj2 = { TableName: "vwSDOrderM_GMJ",
                    Fields: "sBscDataFabName,fBscDataFabWeight,fBscDataFabWidth",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                    ]

                }
                var data2 = SqlGetData(sqlobj2);

                Page.setFieldValue('sBscDataFabName', data2[0].sBscDataFabName);
                Page.setFieldValue('fBscDataFabWeight', data2[0].fBscDataFabWeight);
                Page.setFieldValue('fBscDataFabWidth', data2[0].fBscDataFabWidth);
            }
            else if (Page.usetype == "add") {
                var sqlObj = { TableName: "BscDataColor",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{ Field: "sColorID", ComOprt: "=", Value: "'000'"}]
                };
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    var addRow = [{
                        sColorID: data[0].sColorID,
                        sColorName: data[0].sColorName,
                        iBscDataColorRecNo: data[0].iRecNo
                    }];
                    Page.tableToolbarClick("add", "SDOrderD", addRow[0]);
                }
                Page.setFieldValue("sProductAsk", "以供方出具的确认样或头缸为准。");
                Page.setFieldValue("sCheckStand", "需方收到货后，如有异议请在7-8天内提出异议，由双方确认后再行处理，不得深加工及后续胚布投染（坯布经水洗预定完后如有品质问题需方必须停止，否则视为需方确认合格，）");
                Page.setFieldValue("sMiddleCostName", "款到发货");
            }
            Page.DoNotAutoSerial = true;
        }
        var isModify = "0";
        $(function () {
            if (Page.usetype == "modify") {
                isModify = Page.pageData.iModifying;
                if (isModify == "1") {
                    var sqlObj1 = {
                        TableName: "SDChange",
                        Fields: "top 1 sType",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iSdOrderMRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.key + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "isnull(iStatus,0)",
                                ComOprt: ">",
                                Value: "3"
                            }
                        ],
                        Sorts: [
                        {
                            SortName: "iRecNo",
                            SortOrder: "desc"
                        }
                        ]
                    }
                    var result11 = SqlGetData(sqlObj1);
                    if (result11.length > 0) {
                        sModifyType = result11[0].sType;
                    }
                    if (sModifyType == "客户信息变更") {
                        Page.mainDisabled();
                        Page.childrenDisabled();
                        Page.setFieldEnabled("iBscDataCustomerRecNo");
                        Page.setFieldEnabled("iSubscription");
                        Page.setFieldEnabled("sMiddleCostName");
                        Page.setFieldEnabled("iMiddleCost");
                        Page.setFieldEnabled("iEndCost");
                        //                        Page.setFieldEnabled("iSubscription");
                        //                        Page.setFieldEnabled("sMiddleCostName");
                    }
                    else if (sModifyType == "单价变更") {
                        Page.mainDisabled();
                        //Page.childrenDisabled();
                        Page.Children.toolBarBtnDisabled("SDOrderD", "add");
                        Page.Children.toolBarBtnDisabled("SDOrderD", "delete");
                        Page.Children.toolBarBtnDisabled("SDOrderD", "copy");
                        //Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "add");
                        //Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "delete");
                        //Page.Children.toolBarBtnDisabled("SDOrderDOtherCost", "copy");
                        //Page.Children.toolBarBtnDisabled("SDOrderDFab", "add");
                        //Page.Children.toolBarBtnDisabled("SDOrderDFab", "delete");
                        //Page.Children.toolBarBtnDisabled("SDOrderDFab", "copy");
                    }
                    else {
                        Page.mainDisabled();
                        if (sModifyType == "数量变更") {
                            Page.setFieldEnabled("iBscDataMatFabRecNo");
                            //Page.setFieldEnabled("fProductWidth");
                            //Page.setFieldEnabled("fProductWeight");
                            //Page.setFieldEnabled("fFabPrice");
                            //Page.setFieldEnabled("sRollWeight");
                            //Page.setFieldEnabled("iUnitID");
                            Page.setFieldEnabled("iOrderType");
                        }
                    }
                }
            }
        })

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (isModify == "1") {
                if (sModifyType == "单价变更") {
                    if (datagridOp.clickColumnName != "fPrice") {
                        return false;
                    }
                }
                /*else if (sModifyType == "颜色变更") {
                if (datagridOp.clickColumnName != "sColorID") {
                return false;
                }
                }*/
                else if (sModifyType != "数量变更") {
                    return false;
                }
            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "SDOrderD") {
                if (datagridOp.currentColumnName == "fSumQty" && changes.fSumQty) {
                    //                    var iUnitID = Page.getFieldValue("iUnitID");
                    //                    var fBscDataFabWidth = Page.getFieldValue("fBscDataFabWidth");
                    //                    var fBscDataFabWeight = Page.getFieldValue("fBscDataFabWeight");
                    //                    var fSumQty = row.fSumQty;
                    //                    if (iUnitID != "" && fBscDataFabWidth != "" && fBscDataFabWeight != "" && fSumQty != "") {
                    //                        var fWeight = 0;
                    //                        if (iUnitID == "1") {
                    //                            fWeight = Number(fBscDataFabWidth) / 100 * Number(fSumQty) * Number(fBscDataFabWeight) / 1000
                    //                        }
                    //                        else if (iUnitID == "2") {
                    //                            fWeight = Number(fBscDataFabWidth) / 100 * Number(fSumQty) * 0.9144 * Number(fBscDataFabWeight) / 1000
                    //                        }
                    //                        else if (iUnitID == "0") {
                    //                            fWeight = Number(fSumQty);
                    //                        }
                    //                        fWeight = fWeight.toFixed(2);
                    //                        row.fWeight = fWeight;
                    //                        var fPrice = row.fPrice;
                    //                        if (fPrice != "") {
                    //                            row.fTotal = Number(fWeight) * Number(fPrice);
                    //                        }
                    //                    }
                }
                else if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
                    var fWeight = row.fWeight;
                    if (fWeight != "") {
                        row.fTotal = Number(fWeight) * Number(row.fPrice);
                    }
                }
            }
        }

        Page.Children.onBeforeAddRow = function (tableid) {
            if (tableid == "SDOrderD") {
                if (Page.isInited == true) {
                    var rows = $("#SDOrderD").datagrid("getRows");
                    if (rows.length > 0) {
                        return false;
                    }
                }
            }
        }

        Page.afterLoad = function () {
            $('#__ExtTextBox_iUnitID').combobox({
                onSelect: function (rec) { SeliUnitID(); }
            });
        }

        function SeliUnitID() {
            var rows = $("#SDOrderD").datagrid("getRows");
            if (rows.length > 0) {
                var iUnitID = Page.getFieldValue("iUnitID");
                var fBscDataFabWidth = Page.getFieldValue("fBscDataFabWidth");
                var fBscDataFabWeight = Page.getFieldValue("fBscDataFabWeight");
                var main_fTotal = 0;
                if (iUnitID != "" && fBscDataFabWidth != "" && fBscDataFabWeight != "") {
                    for (var i = 0; i < rows.length; i++) {
                        var fSumQty = rows[i].fSumQty;
                        if (fSumQty != "") {
                            var fWeight = 0;
                            if (iUnitID == "1") {
                                fWeight = Number(fBscDataFabWidth) / 100 * Number(fSumQty) * Number(fBscDataFabWeight) / 1000
                            }
                            else if (iUnitID == "2") {
                                fWeight = Number(fBscDataFabWidth) / 100 * Number(fSumQty) * 0.9144 * Number(fBscDataFabWeight) / 1000
                            }
                            else if (iUnitID == "0") {
                                fWeight = Number(fSumQty);
                            }
                            fWeight = fWeight.toFixed(2);
                            rows[i].fWeight = fWeight;
                            var fPrice = rows[i].fPrice;
                            if (fPrice != "") {
                                var fTotal = Number(fWeight) * Number(fPrice);
                                rows[i].fTotal = fTotal;
                                main_fTotal += fTotal;
                            }
                            $('#SDOrderD').datagrid('updateRow', {
                                index: i
                            });
                        }
                    }
                    Page.setFieldValue('fTotal', main_fTotal);
                    Page.Children.ReloadFooter("SDOrderD");
                }
            }
        }

        Page.beforeSave = function () {
            if (Page.usetype == "add") {
                var sOrderNo = Page.getFieldValue("sOrderNo");
                if (sOrderNo == "") {
                    var jsonobj = {
                        StoreProName: "Yww_FormBillNoBulid",
                        StoreParms: [
                        {
                            ParmName: "@formid",
                            Value: 5568
                        }
                    ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    Page.setFieldValue("sOrderNo", result);
                }
            }
        }

        Page.afterSave = function () {
            if (isModify == "1") {
                //判断是否是变更
                var jsonobj = {
                    StoreProName: "SpSDOrderFabMChangeSave",
                    StoreParms: [
                        {
                            ParmName: "@iformid",
                            Value: Page.iformid
                        },
                        {
                            ParmName: "@iRecNo",
                            Value: Page.key
                        },
                        {
                            ParmName: "@sUserID",
                            Value: Page.userid
                        }

                        ]
                }
                var result = SqlStoreProce(jsonobj);
            }
            else {
                if (Page.usetype == "modify") {
                    var jsonobj = {
                        StoreProName: "SpSDOrderMPriceChange",
                        StoreParms: [
                        {
                            ParmName: "@iRecNo",
                            Value: Page.key
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divTab" class="easyui-tabs" data-options="fit:true">
        <div title="订单信息" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" />
                            </td>
                            <td>
                                客户订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sContractNo" />
                            </td>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Z_Required="True" />
                            </td>
                            <td>
                                签订日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldType="日期" Z_FieldID="dDate"
                                    Z_Required="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                坯布编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iBscDataMatFabRecNo"
                                    Z_Required="True" />
                            </td>
                            <td>
                                坯布名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sBscDataFabName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                需方编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sCustomerProductNo" />
                            </td>
                            <td>
                                幅宽（cm）
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fProductWidth" Z_readOnly="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                克重（g/㎡）
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWeight" Z_readOnly="true" />
                            </td>
                            <td>
                                单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox_iUnitID" runat="server" Z_FieldID="iUnitID" Z_Required="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                订单类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iOrderType" Z_Required="True" />
                            </td>
                            <td>
                                寄样类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sSampleType" Z_Required="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                订单交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sCompany" />
                            </td>
                            <td style="display: none;">
                                部门
                            </td>
                            <td style="display: none;">
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sDeptID" />
                            </td>
                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fQty" Style="display: none;" />
                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Style="display: none;" />
                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSaleID" Style="display: none;" />
                        </tr>
                        <tr>
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
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td class="style2">
                                备注
                            </td>
                            <td class="style1">
                                <textarea id="sReMark" style="border-bottom: 1px solid black; width: 839px; border-left-style: none;
                                    border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                                    border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                                    border-top-color: inherit; border-top-width: 0px;" fieldid="sReMark"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="订单明细">
                            <!--  子表1  -->
                            <table id="SDOrderD" tablename="SDOrderD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="坯布要求">
                            <!--  子表2  -->
                            <table id="SDOrderDFab" tablename="SDOrderDFab">
                            </table>
                        </div>
                        <%--<div data-options="fit:true" title="染色要求">
                    <!--  子表2  -->
                    <table id="SDOrderDColor" tablename="SDOrderDColor">
                    </table>
                </div>--%>
                    </div>
                </div>
            </div>
        </div>
        <div title="付款要求">
            <table>
                <tr>
                    <td>
                        身份证号：
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" Z_FieldID="sId" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        一.品质要求：
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sProductAsk" runat="server" Width="400px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        二.原料是否指定
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" Z_FieldID="iMatZD" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        三.运输方式及到港和费用负担
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea2" Z_FieldID="sTransType" runat="server" Width="400px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        四.包装及布面附加要求：
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea3" Z_FieldID="sPackType" runat="server" Width="400px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        五.验收标准：
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea5" Z_FieldID="sCheckStand" runat="server" Width="403px"
                            Height="70px" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        六.订单可用传真或邮件方式，乙方在本合同项下的欠款，由
                        <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="sPerson" runat="server" Width="81px" />
                        个人保证担保，保证期二年。
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        七.结算方式：定金<cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Width="35px" Z_FieldID="iSubscription"
                            Z_FieldType="整数" />
                        %&nbsp;&nbsp;
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sMiddleCostName" Width="99px" />
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iMiddleCost" Width="36px"
                            Z_FieldType="整数" />
                        %&nbsp; 尾款
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iEndCost" Width="32px"
                            Z_FieldType="整数" />
                        %
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        乙方应于甲方交付产品后<cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iDay" Width="60px" />
                        天内付清该批货款，且双方交易过程中的累积欠款金额不得超过<cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fMoney"
                            Width="80px" />
                        元
                    </td>
                </tr>
                <tr>
                    <td>
                        八.特别要求：
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea7" Z_FieldID="sSpeAsk" runat="server" Width="400px" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
