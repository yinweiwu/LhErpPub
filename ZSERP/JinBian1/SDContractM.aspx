<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var isModify = false;
        var iOrderType = "";
        var iModifying = 0;
        var sModifyType = "";
        $(function () {
            iOrderType = getQueryString("iOrderType");
            if (iOrderType == "2") {
                $("#divTabs").tabs("disableTab", 1);
                $("#divTabs1").tabs("disableTab", 1);
            }
            if (Page.usetype == "modify") {
                var sqlObj = {
                    TableName: "SDContractM",
                    Fields: "iStatus,iModifying",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + Page.key + "'"
                        }
                    ]
                };
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    if (result[0].iStatus != "" && result[0].iStatus != null && result[0].iStatus != undefined) {
                        var iStatus = parseInt(result[0].iStatus);
                        if (iStatus > 1) {
                            iModifying = result[0].iModifying;
                            if (iModifying == 1) {
                                //获取变更类型
                                var sqlObjChange = {
                                    TableName: "SDChange",
                                    Fields: "top 1 sType",
                                    SelectAll: "True",
                                    Filters: [
                                        {
                                            Field: "iSdOrderMRecNo",
                                            ComOprt: "=",
                                            Value: Page.key
                                        }
                                    ],
                                    Sorts: [
                                        {
                                            SortOrder: "desc",
                                            SortName: "iRecNo"
                                        }
                                    ]
                                }
                                var resultChange = SqlGetData(sqlObjChange);
                                if (resultChange.length > 0) {
                                    sModifyType = resultChange[0].sType;
                                    if (sModifyType == "合同主表变更") {
                                        Page.Children.toolBarBtnDisabled("table1", "add");
                                        Page.Children.toolBarBtnDisabled("table1", "delete");
                                        Page.Children.toolBarBtnDisabled("table1", "copy");
                                    }
                                    else if (sModifyType == "产品明细变更") {
                                        Page.mainDisabled();
                                    }
                                    else if (sModifyType == "全部变更") {
                                        //Page.mainDisabled();
                                    }
                                }
                                //                                Page.mainDisabled();
                                //                                isModify = true;
                                //                                Page.setFieldEnabled("sReMark");
                                //                                Page.setFieldEnabled("sUnitID");
                                //                                Page.setFieldEnabled("iReelNoBulidType");
                                //                                Page.setFieldEnabled("sReelNoPre");
                                //                                Page.setFieldEnabled("sReelNoFlag");
                                //                                Page.setFieldEnabled("iPrintMoudleRecNo");
                                //                                Page.setFieldEnabled("iPrintCount");
                                //                                Page.setFieldEnabled("iPrintMoudleRecNo2");
                                //                                Page.setFieldEnabled("fPaperTube");
                                //                                Page.setFieldEnabled("fMargin");
                                //                                Page.setFieldEnabled("iAllowBlankReelNo");
                                //                                Page.setFieldEnabled("sContractNo");
                                //                                Page.Children.toolBarBtnDisabled("table1", "delete");
                                //                                Page.Children.toolBarBtnDisabled("table1", "copy");
                            }
                        }
                    }
                }
            }
        })
        //        Page.Children.onBeforeEdit = function (tableid, index, row) {
        //            if (isModify == true) {
        //                if (tableid == "table1") {
        //                    if (row.iMainRecNo) {
        //                        if (datagridOp.clickColumnName == "sCode" || datagridOp.clickColumnName == "sColorID" || datagridOp.clickColumnName == "sBaseCode") {
        //                            return false;
        //                        }
        //                    }
        //                }
        //                if (tableid == "table2") {
        //                    return true;
        //                }
        //            }
        //        }
        Page.beforeSave = function () {
            if (iOrderType == "1") {
                //var allRows = $("#table2").datagrid("getRows");
                //if (allRows.length == 0) {
                //    alert("注意：条码规则未输入");
                //}
            }
        }
        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            if (uniqueid == "1772") {
                var getLastOrderBase = function (iBscDataMatRecNo, iBscDataCustomerRecNo) {
                    var sqlObj1 = {
                        TableName: "vwSDContractMD",
                        Fields: "top 1 iBaseBscDataMatRecNo,sBaseCode,sBaseName",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "ibscDataCustomerRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataCustomerRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataMatRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "dInputDate",
                                SortOrder: "desc"
                            }
                        ]
                    }
                    var result1 = SqlGetData(sqlObj1);
                    if (result1.length > 0) {
                        return result1[0];
                    }
                    else {
                        return null;
                    }
                }

                var getMatBase = function (iBscDataMatRecNo) {
                    var sqlObj2 = {
                        TableName: "vwbscDataMatDWaste",
                        Fields: "top 1 iBscDataMatRecNo as iBaseBscDataMatRecNo,sCode as sBaseCode,sName as sBaseName",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "iSerial",
                                SortOrder: "asc"
                            }
                        ]
                    }
                    var result2 = SqlGetData(sqlObj2);
                    if (result2.length > 0) {
                        return result2[0];
                    }
                    else {
                        return null;
                    }
                }


                var iBscDataMatRecNo = data.iRecNo;
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                if (iBscDataCustomerRecNo == "") {
                    var result = getMatBase(iBscDataMatRecNo);
                    if (result != null) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: result });
                    }
                }
                else {
                    var result = getLastOrderBase(iBscDataMatRecNo, iBscDataCustomerRecNo);
                    if (result == null) {
                        result = getMatBase(iBscDataMatRecNo);
                    }
                    if (result != null) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: result });
                    }
                }


            }
        }

        Page.afterSave = function () {
            if (iModifying == "1") {
                if (Page.usetype == "modify") {

                    //                    var jsonobj = {
                    //                        StoreProName: "SpSDContractMModify",
                    //                        StoreParms: [{
                    //                            ParmName: "@iRecNo",
                    //                            Value: Page.key
                    //                        }
                    //                        ]
                    //                    }
                    //                    var result = SqlStoreProce(jsonobj);
                    //                    if (result != "1") {
                    //                        alert(result + ",变更明细数据失败");
                    //                    }
                    //判断是否是变更
                    var jsonobj = {
                        StoreProName: "SpSDOrderMChangeSave",
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
            }
        }
        Page.Formula = function (field) {
            if (field == "dOrderDate") {
                var dOrderDate = Page.getFieldValue("dOrderDate");
                Page.setFieldValue("dProduceDate", dOrderDate);
            }
        }
        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (iModifying == "1") {
                if (sModifyType == "合同主表变更") {
                    if (tableid == "table2") {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
            }
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            height: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="height:210px; overflow: hidden;">
            <div id="divTabs" class="easyui-tabs" data-options="fit:true">
                <div data-options="title:'订单信息',fit:true,border:false">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sDeptID" />
                        <%--<cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iOrderType" />--%>
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true" />
                            </td>
                            <td>
                                客户订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sContractNo" />
                            </td>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>
                                签订日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                订单类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" Z_FieldID="iOrderType" runat="server" />
                            </td>
                            <td>
                                产品类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" Z_FieldID="sProductType" runat="server" />
                            </td>
                            <td>
                                业务员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSaleID" />
                            </td>
                            <td>
                                销售单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sSaleUnitID" />
                            </td>
                            <!--这里是主表字段摆放位置-->
                            
                        </tr>
                        <tr>
                            <td>
                                订单交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期" />
                            </td>
                            <td>币种</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBiZhong" /></td>
                            <td>成交方式</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sChengJiaoFangShi" /></td>

                            
                            
                        </tr>
                        <tr>
                            <td class="auto-style1">
                                总数量
                            </td>
                            <td class="auto-style1">
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                                    Z_FieldID="fQty" Z_FieldType="数值" />
                                <table>
                                </table>
                            </td>
                            <td class="auto-style1">
                                总金额
                            </td>
                            <td class="auto-style1">
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_decimalDigits="4" Z_readOnly="true"
                                    Z_FieldID="fTotal" Z_FieldType="数值" />
                            </td>
                            <td>合同号</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox1119" runat="server" Z_FieldID="sHTBillNo" /></td>
                            
                        </tr>
                        <tr>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                            </td>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="true" />
                            </td>
                            <td class="auto-style1">
                                备注
                            </td>
                            <td colspan='3'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="98%" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="title:'验布要求',fit:true,border:false">
                    <table class="tabmain">
                        <tr>
                            <td>
                                计量单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUnitID" Style="width: 150px;" />
                            </td>
                            <td>
                                卷号生成规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iReelNoBulidType" Style="width: 150px;" />
                            </td>
                            <td>
                                前缀
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sReelNoPre" Style="width: 150px;" />
                            </td>
                            <td>
                                流水位数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReelNoFlag" Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                打印模板
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iPrintMoudleRecNo" Style="width: 150px;" />
                            </td>
                            <td>
                                打印份数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iPrintCount" Z_FieldType="数值"
                                    Z_decimalDigits="0" Style="width: 150px;" />
                            </td>
                            <td>
                                合格证模板
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="iPrintMoudleRecNo2"
                                    Style="width: 150px;" />
                            </td>
                            <td>
                                允许卷号空号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iAllowBlankReelNo" Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <%--<td>
                                纸管重量(KG)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fPaperTube" Z_FieldType="数值"
                                    Z_decimalDigits="2" Style="width: 150px;" />
                            </td>
                            <td>
                                差额重量(KG)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fMargin" Z_FieldType="数值"
                                    Z_decimalDigits="2" Style="width: 150px;" />
                            </td>--%>
                            <td>
                                是否切边
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="iCutEdge" runat="server" />
                            </td>
                            <td>
                                是否打纸筒
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iPaperTube" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="title:'付款条件',fit:true,border:false">
                    <table class="tabmain">
                        <tr>
                            <td>付款条件</td>
                             <td colspan="5">
                                 <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sChanPinZhiLiangBiaoZhun" Width="600px"  Height="150px"/>
                                 <%--<cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sChanPinZhiLiangBiaoZhun" Style="width:450px;" />--%>

                             </td>
                        </tr>
                        <%--<tr>
                           
                            <td>交货时间，地点</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sJiaoHuoSHiJian" Style="width: 150px;" /></td>
                            <td>运输方式及到港站和金额费用负担</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sYunShuFangShi" Style="width: 150px;" /></td>
                        </tr>
                        <tr>
                            <td>送货地址</td>
                            <td colspan="5"><cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sSongHuoDiZhi" Style="width: 450px;" /></td>
                        </tr>
                        <tr>
                            <td>包装要求</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sBaoZhuangYaoQiu" Style="width: 150px;" /></td>
                            <td>付款方式及期限</td>
                            <td><cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="sFuKuanFangShi" Style="width: 150px;" /></td>
                        </tr>--%>
                        </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTabs1" class="easyui-tabs" data-options="fit:true,border:false">
                <div id="divTabs1" data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDContractD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="条码生成规则">
                    <!--  子表1  -->
                    <table id="table2" tablename="SDContractDBarcodeRule">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
