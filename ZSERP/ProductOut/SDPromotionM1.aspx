<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.beforeSave = function () {
            var dBeginDate = Page.getFieldValue("dBeginDate");
            var dEndDate = Page.getFieldValue("dEndDate");
            if (dBeginDate != "" && dEndDate != "") {
                if (dBeginDate >= dEndDate) {
                    Page.MessageShow("错误", "促销截至日期必须大于开始日期！");
                    return false;
                }
            }

            var allRows = $("#table1").datagrid("getRows");
            for (var i = 0; i < allRows.length; i++) {
                $("#table1").datagrid("endEdit", i);
                if (isNaN(parseFloat(allRows[i].fDisCount)) && isNaN(parseFloat(allRows[i].fNewPrice))) {
                    Page.MessageShow("折扣和新价格不能都为空", "第" + (i + 1) + "行，折扣和新价格不能同时为空！");
                    return false;
                }
                if (!isNaN(parseFloat(allRows[i].fDisCount)) && !isNaN(parseFloat(allRows[i].fNewPrice))) {
                    Page.MessageShow("折扣和新价格不能同时存在", "第" + (i + 1) + "行，折扣和新价格不能同时存在！");
                    return false;
                }
            }
        }
        Page.Children.onBeginEdit = function (tableid, index, row) {
            if (tableid == "table1") {
                if (datagridOp.clickColumnName == "fOldPrice" && isNaN(row.fOldPrice)) {
                    var sBscDataStockMRecNo = Page.getFieldValue("sBscDataStockMRecNo");
                    var iBscDataStyleMRecNo = row.iBscDataStyleMRecNo;
                    var iBscDataColorRecNo = row.iBscDataColorRecNo;
                    var sSizeName = row.sSizeName;
                    var fOldPrice = undefined;
                    if (iBscDataStyleMRecNo) {
                        var sqlObj = {
                            TableName: "BscDataStyleM",
                            Fields: "iPriceType,iShop,fSalePrice",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "iRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataStyleMRecNo + "'"
                            }]
                        };
                        var StyleData = SqlGetData(sqlObj);
                        if (StyleData.length > 0) {
                            if (sBscDataStockMRecNo.indexOf(",") > -1) {
                                fOldPrice = StyleData[0].fSalePrice;
                            }
                            else {
                                if (StyleData[0].iShop != "1" && StyleData[0].iPriceType == "0") {
                                    fOldPrice = StyleData[0].fSalePrice;
                                }
                                else {
                                    var sqlDetailObj = {
                                        TableName: "bscDataStyleDPrice",
                                        Fields: "ibscDataStockMRecNo,ibscDataColorRecNo,sSizeName,fSalePrice",
                                        SelectAll: "True",
                                        Filters: [
                                    {
                                        Field: "iMainRecNo",
                                        ComOprt: "=",
                                        Value: "'" + iBscDataStyleMRecNo + "'"
                                    }
                                    ]
                                    };
                                    var StylePriceData = SqlGetData(sqlDetailObj);
                                    if (StylePriceData.length > 0) {
                                        if (StyleData[0].iShop == "1") {
                                            if (StyleData[0].iPriceType == "0") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataStockMRecNo == sBscDataStockMRecNo) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (StyleData[0].iPriceType == "1") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataStockMRecNo == sBscDataStockMRecNo && StylePriceData[j].ibscDataColorRecNo == iBscDataColorRecNo) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (StyleData[0].iPriceType == "2") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataStockMRecNo == sBscDataStockMRecNo && StylePriceData[j].sSizeName == sSizeName) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (StyleData[0].iPriceType == "3") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataStockMRecNo == sBscDataStockMRecNo && StylePriceData[j].ibscDataColorRecNo == iBscDataColorRecNo && StylePriceData[j].sSizeName == sSizeName) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                        else {
                                            if (StyleData[0].iPriceType == "1") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataColorRecNo == iBscDataColorRecNo) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (StyleData[0].iPriceType == "2") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].sSizeName == sSizeName) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (StyleData[0].iPriceType == "3") {
                                                for (var j = 0; j < StylePriceData.length; j++) {
                                                    if (StylePriceData[j].ibscDataColorRecNo == iBscDataColorRecNo && StylePriceData[j].sSizeName == sSizeName) {
                                                        fOldPrice = StylePriceData[j].fSalePrice;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            fOldPrice = fOldPrice ? fOldPrice : StyleData[0].fSalePrice;
                        }
                        var ed = $("#" + tableid).datagrid("getEditor", { index: index, field: "fOldPrice" });
                        if (fOldPrice) {
                            $(ed.target).numberbox("setValue", fOldPrice);
                        }
                    }
                }
            }
        }
//        Page.Children.onEndEdit = function (tableid, index, row, changes) {
//            if (tableid == "table1") {
//                if (datagridOp.currentColumnName == "fOldPrice" && changes.fOldPrice) {
//                    var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
//                    var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;

//                    if (fDisCount != 0 && fOldPrice != 0) {
//                        var fNewPrice = fOldPrice * (fDisCount / 10);
//                        if (row.iDig == 1) {
//                            fNewPrice = fNewPrice.toFixed(2);
//                        }
//                        if (row.iDig == 2) {
//                            fNewPrice = fNewPrice.toFixed(1);
//                        }
//                        if (row.iDig == 3) {
//                            fNewPrice = Math.round(fNewPrice);
//                        }
//                        if (row.iDig == 4) {
//                            fNewPrice = Math.round((fNewPrice / 10)) * 10;
//                        }
//                        if (row.iDig == 5) {
//                            fNewPrice = Math.round((fNewPrice / 100)) * 100;
//                        }
//                        row.fNewPrice = fNewPrice;
//                    }
//                    else {
//                        row.fNewPrice = null;
//                    }
//                }
//                if (datagridOp.currentColumnName == "fDisCount" && changes.fDisCount) {
//                    var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
//                    var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;
//                    if (fDisCount != 0 && fOldPrice != 0) {
//                        var fNewPrice = fOldPrice * (fDisCount / 10);
//                        if (row.iDig == 1) {
//                            fNewPrice = fNewPrice.toFixed(2);
//                        }
//                        if (row.iDig == 2) {
//                            fNewPrice = fNewPrice.toFixed(1);
//                        }
//                        if (row.iDig == 3) {
//                            fNewPrice = Math.round(fNewPrice);
//                        }
//                        if (row.iDig == 4) {
//                            fNewPrice = Math.round((fNewPrice / 10)) * 10;
//                        }
//                        if (row.iDig == 5) {
//                            fNewPrice = Math.round((fNewPrice / 100)) * 100;
//                        }
//                        row.fNewPrice = fNewPrice;
//                    }
//                    else {
//                        row.fNewPrice = null;
//                    }
//                }
//                if (datagridOp.currentColumnName == "iDig" && changes.iDig) {
//                    var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
//                    var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;
//                    if (fDisCount != 0 && fOldPrice != 0) {
//                        var fNewPrice = fOldPrice * (fDisCount / 10);
//                        if (row.iDig == 1) {
//                            fNewPrice = fNewPrice.toFixed(2);
//                        }
//                        if (row.iDig == 2) {
//                            fNewPrice = fNewPrice.toFixed(1);
//                        }
//                        if (row.iDig == 3) {
//                            fNewPrice = Math.round(fNewPrice);
//                        }
//                        if (row.iDig == 4) {
//                            fNewPrice = Math.round((fNewPrice / 10)) * 10;
//                        }
//                        if (row.iDig == 5) {
//                            fNewPrice = Math.round((fNewPrice / 100)) * 100;
//                        }
//                        row.fNewPrice = fNewPrice;
//                    }
//                    else {
//                        row.fNewPrice = null;
//                    }
//                }
//                if (datagridOp.currentColumnName == "fNewPrice" && changes.fNewPrice) {
//                    var fNewPrice = row.fNewPrice ? parseFloat(row.fNewPrice) : 0;
//                    var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
//                    if (fNewPrice != 0 && fOldPrice != 0) {
//                        fDisCount = (fNewPrice / fOldPrice * 10).toFixed(2);
//                        row.fDisCount = fDisCount;
//                    }
//                    else {
//                        row.fDisCount = null;
//                    }
//                }
//            }
//        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <table class="tabmain">
                <tr>
                    <td>
                        促销编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        促销开始日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="dBeginDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        截至日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dEndDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        促销门店
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sBscDataStockMRecNo" />
                    </td>
                    <td>
                        申请人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        申请部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sDeptID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="90%" Z_FieldID="sReMark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dinputDate" Z_readOnly="True" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td>
                        单据类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="iBillType" Z_Value="1" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="促销单明细">
                    <table id="table1" tablename="SDPromotionD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
