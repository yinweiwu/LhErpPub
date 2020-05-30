<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.Children.onBeginEdit = function (tableid, index, row) {
            if (tableid == "table1") {
                if (datagridOp.clickColumnName == "fOldPrice") {
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
                        $(ed.target).numberbox("setValue", fOldPrice);
                    }
                }
            }
        }

        //    Page.Children.onEndEdit = function (tableid, index, row, changes) {
        //        if (tableid == "table1") {
        //            if (datagridOp.currentColumnName == "fOldPrice" && changes.fOldPrice) {
        //                var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
        //                var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;
        //                var iDig = 1;
        //                if (row.iDig == 1) {
        //                    iDig = 0.01;
        //                }
        //                if (row.iDig == 2) {
        //                    iDig = 0.1;
        //                }
        //                if (row.iDig == 3) {
        //                    iDig = 1;
        //                }
        //                if (row.iDig == 4) {
        //                    iDig = 10;
        //                }
        //                if (row.iDig == 5) {
        //                    iDig = 500;
        //                }

        //                if (fDisCount != 0 && fOldPrice != 0) {
        //                    var fNewPrice = (fOldPrice * (fDisCount / 10) * iDig).toFixed(2);
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fNewPrice: fNewPrice} });
        //                }
        //                else {
        //                    $("#" + tableid).datagrid("fDisCount", { index: index, row: { fNewPrice: ''} });
        //                }
        //            }
        //            if (datagridOp.currentColumnName == "fDisCount" && changes.fDisCount) {
        //                var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
        //                var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;
        //                var iDig = 1;
        //                if (row.iDig == 1) {
        //                    iDig = 0.01;
        //                }
        //                if (row.iDig == 2) {
        //                    iDig = 0.1;
        //                }
        //                if (row.iDig == 3) {
        //                    iDig = 1;
        //                }
        //                if (row.iDig == 4) {
        //                    iDig = 10;
        //                }
        //                if (row.iDig == 5) {
        //                    iDig = 500;
        //                }

        //                if (fDisCount != 0 && fOldPrice != 0) {
        //                    var fNewPrice = (fOldPrice * (fDisCount / 10) * iDig).toFixed(2);
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fNewPrice: fNewPrice} });
        //                }
        //                else {
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fNewPrice: ''} });
        //                }
        //            }
        //            if (datagridOp.currentColumnName == "iDig" && changes.iDig) {
        //                var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
        //                var fDisCount = row.fDisCount ? parseFloat(row.fDisCount) : 0;
        //                var iDig = 1;
        //                if (row.iDig == 1) {
        //                    iDig = 0.01;
        //                }
        //                if (row.iDig == 2) {
        //                    iDig = 0.1;
        //                }
        //                if (row.iDig == 3) {
        //                    iDig = 1;
        //                }
        //                if (row.iDig == 4) {
        //                    iDig = 10;
        //                }
        //                if (row.iDig == 5) {
        //                    iDig = 500;
        //                }

        //                if (fDisCount != 0 && fOldPrice != 0) {
        //                    var fNewPrice = (fOldPrice * (fDisCount / 10) * iDig).toFixed(2);
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fNewPrice: fNewPrice} });
        //                }
        //                else {
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fNewPrice: ''} });
        //                }
        //            }
        //            if (datagridOp.currentColumnName == "fNewPrice" && changes.fNewPrice) {
        //                var fNewPrice = row.fNewPrice ? parseFloat(row.fNewPrice) : 0;
        //                var fOldPrice = row.fOldPrice ? parseFloat(row.fOldPrice) : 0;
        //                var iDig = 1;
        //                if (row.iDig == 1) {
        //                    iDig = 0.01;
        //                }
        //                if (row.iDig == 2) {
        //                    iDig = 0.1;
        //                }
        //                if (row.iDig == 3) {
        //                    iDig = 1;
        //                }
        //                if (row.iDig == 4) {
        //                    iDig = 10;
        //                }
        //                if (row.iDig == 5) {
        //                    iDig = 500;
        //                }

        //                if (fNewPrice != 0 && fOldPrice != 0) {
        //                    //var fNewPrice = (fOldPrice * fDisCount).toFixed(2);
        //                    fDisCount = (fNewPrice / fOldPrice*10).toFixed(2);
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fDisCount: fDisCount} });
        //                }
        //                else {
        //                    $("#" + tableid).datagrid("updateRow", { index: index, row: { fDisCount: ''} });
        //                }
        //            }
        //        }
        //    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <table class="tabmain">
                <tr>
                    <td>
                        调价单号
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
                        调价门店
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sBscDataStockMRecNo" />
                    </td>
                </tr>
                <tr>
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
                    <td>
                        备注
                    </td>
                    <td rowspan="2">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="171px"
                            Height="47px" />
                    </td>
                </tr>
                <tr>
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
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="iBillType" Z_Value="2" />
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dBeginDate" Z_FieldType="日期" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调价单明细">
                    <table id="table1" tablename="SDPromotionD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
