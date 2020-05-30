<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var clickfield = "";
        var clickindex = 0;
        Page.beforeInit = function () {
            var iMatType = getQueryString("iMatType");
            if (iMatType == "0") {
                $("#Table1").removeAttr("tablename");
                $("#tabC").tabs("close", 1);
            }
        }
        $(function () {
            var iMatType = getQueryString("iMatType");
            Page.setFieldValue('iMatType', iMatType);
            if (Page.usetype == "add") {
                if (iMatType == "1") {
                    var sremarkArr = [
                        {
                            iSerial: 1,
                            sRemark: "请注意坯布针条，油针，瑕疵，停车痕等异常问题100M不超四个疵点，"
                        },
                        {
                            iSerial: 2,
                            sRemark: "若此批货在坯布检验时有异常情况，我司要退回贵公司，如在水洗定型等生产过程中出现问题（属于坯布问题）我司要退回贵公司，对已处理好的产品及半产品由贵司收回并赔偿后处理等费用."
                        },
                        {
                            iSerial: 3,
                            sRemark: "请在出货单上附上贵司的品检记录以便我司工作，品检记录上要明确记录每匹布的异常情况，"
                        },
                        {
                            iSerial: 4,
                            sRemark: "请在我司指定日期内交完全部，否则一切损失由贵司承担。"
                        },
                        {
                            iSerial: 5,
                            sRemark: "包装：卷布，PE膜，外编织带，不得出现污脏情况，"
                        },
                        {
                            iSerial: 6,
                            sRemark: "特别注意事项：此单对布面\"竖条，经编条，\"特别注意，不得出现横条，停车档现象，"
                        }
                        ,
                        {
                            iSerial: 7,
                            sRemark: ""
                        }
                        ,
                        {
                            iSerial: 8,
                            sRemark: ""
                        }
                    ]
                    for (var i = 0; i < sremarkArr.length; i++) {
                        Page.tableToolbarClick("add", "Table1", sremarkArr[i]);
                    }



                }
                if (iMatType == "2") {
                    var sremarkArr = [
                        {
                            iSerial: 1,
                            sRemark: "物料必须符合环保纺织物品标准及符合oeko-tex standard标准"
                        },
                        {
                            iSerial: 2,
                            sRemark: "每色每缸须提供2-3YD批色及测试，确认后方式可出货"
                        },
                        {
                            iSerial: 3,
                            sRemark: "出货前每匹布上麦头须注明合同号，匹号，缸号，规格，净重/毛重，长度等资料"
                        },
                        {
                            iSerial: 4,
                            sRemark: "请控制交货数量，允收范围±3%以内，克重按受范围±5G/M2以内"
                        },
                        {
                            iSerial: 5,
                            sRemark: "如因品质问题或时间等因素影响我司交期，由此造成的损失由贵司全额承担"
                        },
                        {
                            iSerial: 6,
                            sRemark: "布面品质，不得出现竖条/横条/拆痕/色花/污胜/破洞/等异常问题"
                        }
                        ,
                        {
                            iSerial: 7,
                            sRemark: "色牢度必须达到3-4级，测试标准，SGS测试"
                        }
                        ,
                        {
                            iSerial: 8,
                            sRemark: "风格跟时来样"
                        },
                        {
                            iSerial: 9,
                            sRemark: ""
                        },
                        {
                            iSerial: 10,
                            sRemark: ""
                        }
                    ]
                    for (var i = 0; i < sremarkArr.length; i++) {
                        Page.tableToolbarClick("add", "Table1", sremarkArr[i]);
                    }
                }
            }

            var options = $("#PurOrderD").datagrid("options");
            delete options.url;
            for (var i = 0; i < options.columns[0].length; i++) {
                if (options.columns[0][i].field == "fStockQtyCanUse") {
                    options.columns[0][i].formatter = function (value, row, index) {
                        if (row.iRecNo) {
                            if (row.fStockQtyCanUse != null && row.fStockQtyCanUse != undefined) {
                                return "<a href='#' onclick='showStockQty(&apos;PurOrderD&apos;," + index + "," + iMatType + ")'>" + row.fStockQtyCanUse + "</a>";
                            } else {
                                return "<a href='#' onclick='showStockQty(&apos;PurOrderD&apos;," + index + "," + iMatType + ")'>显示库存</a>";
                            }
                        }
                    }
                }
            }
            $("#table1").datagrid(options);

            dataForm.beforeSetValue = function (uniqueid, data) {
                if (uniqueid == 415) {
                    var lastType = "";
                    for (var i = 0; i < data.length; i++) {
                        var theType = data[i].sType;
                        if (lastType != "" && theType != lastType) {
                            Page.MessageShow("只能转入同一类型的明细", "只能转入同一类型的明细");
                            return false;
                        } else {
                            lastType = data[i].sType;
                        }
                    }
                    var sPurType = Page.getFieldValue("sPurType");
                    if (sPurType != "") {
                        if (lastType == "成品布") {
                            if (sPurType != "成品采购") {
                                Page.MessageShow("采购类型为【" + sPurType + "】，不能转入其他类型的布", "采购类型为【" + sPurType + "】，不能转入其他类型的布");
                                return false;
                            }
                        }
                        if (lastType == "面布") {
                            if (sPurType != "面布采购") {
                                Page.MessageShow("采购类型为【" + sPurType + "】，不能转入其他类型的布", "采购类型为【" + sPurType + "】，不能转入其他类型的布");
                                return false;
                            }
                        }
                        if (lastType == "底布") {
                            if (sPurType != "底布采购") {
                                Page.MessageShow("采购类型为【" + sPurType + "】，不能转入其他类型的布", "采购类型为【" + sPurType + "】，不能转入其他类型的布");
                                return false;
                            }
                        }
                    }
                }
            }

            dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
                if (uniqueid == 415) {
                    if (row.sUnitID == "0") {
                        row.fRealFab = data[index].fNeedWeight;
                        row.fQty = data[index].fNotProcessWeight;
                    }
                    if (row.sUnitID == "1") {
                        row.fRealFab = data[index].fNeedQty;
                        row.fQty = data[index].fNotProcessQty;
                    }
                    if (row.sUnitID == "2") {
                        row.fRealFab = data[index].fNeedQty/0.9144;
                        row.fQty = data[index].fNotProcessQty/0.9144;
                    }
                    return row;
                }
            }

            dataForm.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
                var iBscDataMatRecNo = row.iBscDataMatRecNo;
                if (iBscDataMatRecNo) {
                    var sqlObj = {
                        TableName: "bscDataMat",
                        Fields: "fLastPrice",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        $("#PurOrderD").datagrid("updateRow", { row: { fPrePrice: result[0].fLastPrice }, index: rowIndex });
                    }
                    if (uniqueid == "270" || uniqueid == "392") {
                        var sqlObjD = {
                            TableName: "vwbscDataMatDProcesses",
                            Fields: "iBscDataProcessesMRecNo,sProcessesName",
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
                            SortOrder: "desc"
                        }
                            ]
                        }
                        var result = SqlGetData(sqlObjD);
                        if (result.length > 0) {
                            $("#PurOrderD").datagrid("updateRow", {
                                row: {
                                    sProcessesName: result[0].sProcessesName,
                                    iBscDataProcessMRecNo: result[0].iBscDataProcessesMRecNo
                                }, index: rowIndex
                            });
                        }
                    }
                }
            }

            dataForm.afterSelected = function (uniqueid, data) {
                if (uniqueid == "270") {
                    $("#Table1").datagrid("loadData", []);
                    var iPurAskMainRecNo = data[0].iMainRecNo;
                    var sqlObj = {
                        TableName: "PurAskDRemark",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: iPurAskMainRecNo
                            }
                        ]
                    }
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        for (var i = 0; i < data.length; i++) {
                            var dataRemark = {
                                iSerial: i + 1,
                                sRemark: data[i].sRemark
                            }
                            Page.tableToolbarClick("add", "Table1", dataRemark);
                        }
                    }
                }
                if (uniqueid == 415) {
                    var theFirstData = data[0];
                    var sType = theFirstData.sType;
                    if (sType == "成品布") {
                        Page.setFieldValue("sPurType", "成品采购");
                    } else if (sType == "面布") {
                        Page.setFieldValue("sPurType", "面布采购");
                    } else if (sType == "底布") {
                        Page.setFieldValue("sPurType", "底布采购");
                    }
                }
            }

        })
        Page.beforeSave = function () {
            //            dDate = Page.getFieldValue('dDate');
            //            dOrderDate = Page.getFieldValue('dOrderDate');
            //            if (dOrderDate > dDate) {
            //                $.messager.show({
            //                    title: '错误',
            //                    msg: '采购交期不能大于需求日期！',
            //                    timeout: 1000,
            //                    showType: 'show',
            //                    style: {
            //                        right: '',
            //                        top: document.body.scrollTop + document.documentElement.scrollTop,
            //                        bottom: ''
            //                    }
            //                });
            //                return false;
            //            }
        }       
        
        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
            var iBscDataMatRecNo = row.iBscDataMatRecNo;
            if (iBscDataMatRecNo) {
                var sqlObj = {
                    TableName: "bscDataMat",
                    Fields: "fLastPrice",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + iBscDataMatRecNo + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    $("#PurOrderD").datagrid("updateRow", { row: { fPrePrice: result[0].fLastPrice }, index: rowIndex });
                }
                if (uniqueid == "942") {
                    var sqlObjD = {
                        TableName: "vwbscDataMatDProcesses",
                        Fields: "iBscDataProcessesMRecNo,sProcessesName",
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
                            SortOrder: "desc"
                        }
                        ]
                    }
                    var result = SqlGetData(sqlObjD);
                    if (result.length > 0) {
                        $("#PurOrderD").datagrid("updateRow", { row: { sProcessesName: result[0].sProcessesName, iBscDataProcessMRecNo: result[0].iBscDataProcessesMRecNo }, index: rowIndex });
                    }
                }
            }
        }

        

        function showStockQty(tableid, index, iMatType) {
            //var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
            //if (iBscDataCustomerRecNo == "" || iBscDataCustomerRecNo == null) {
            //    Page.MessageShow("请先选择客户", "请先选择客户");
            //    return;
            //}
            var theRow = $("#" + tableid).datagrid("getRows")[index];
            var iBscDataMatRecNo = theRow.iBscDataMatRecNo;
            var iSDOrderMRecNo = theRow.iSdOrderMRecNo ? theRow.iSdOrderMRecNo : 0;
            if (iMatType == 1) {
                if (iBscDataMatRecNo) {
                    var sqlObj = {
                        TableName: "MMStockQty", Fields: "sum(fQty) as fQty", SelectAll: "True",
                        Filters: [
                            { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'", LinkOprt: "and" },
                            //{ Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + iBscDataColorRecNo + "'", LinkOprt: "and" },
                            { LeftParenthese: "(", Field: "iSDOrderMRecNo", ComOprt: "=", Value: "'" + iSDOrderMRecNo + "'", LinkOprt: "or" },
                            { Field: "isnull(iSDOrderMRecNo,0)", ComOprt: "=", Value: "0", RightParenthese: ")" }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: (result[0].fQty ? result[0].fQty : 0) } });
                    } else {
                        $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: 0 } });
                    }
                }
                else {
                    Page.MessageShow("坯布编号不能为空", "坯布编号不能为空");
                }
            }
            else {
                var ibscDataColorRecNo = theRow.ibscDataColorRecNo ? theRow.ibscDataColorRecNo : 0;
                if (iBscDataMatRecNo && ibscDataColorRecNo) {
                    var sqlObj = {
                        TableName: "MMStockQty", Fields: "sum(fQty) as fQty", SelectAll: "True",
                        Filters: [
                            { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'", LinkOprt: "and" },
                            { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + ibscDataColorRecNo + "'", LinkOprt: "and" },
                            { LeftParenthese: "(", Field: "iSDOrderMRecNo", ComOprt: "=", Value: "'" + iSDOrderMRecNo + "'", LinkOprt: "or" },
                            { Field: "isnull(iSDOrderMRecNo,0)", ComOprt: "=", Value: "0", RightParenthese: ")" }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: (result[0].fQty ? result[0].fQty : 0) } });
                    } else {
                        $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: 0 } });
                    }
                }
                else {
                    Page.MessageShow("产品编号或颜色不能为空", "产品编号或颜色不能为空");
                }
            }

        }
        Page.Children.onClickCell = function (tableid, index, field, value) {
            if (tableid == "PurOrderD") {
                if (field == "iBscDataProcessMRecNo") {
                    clickfield = "iBscDataProcessMRecNo";
                }
            }
        }
        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (tableid == "PurOrderD") {
                if (clickfield == "iBscDataProcessMRecNo") {
                    if (row["iSDContractDProcessDRecNo"]) {
                        Page.MessageShow("提示", "投批转入，不可修改！")
                        return false;
                    }
                }
            }
        }
        function importLast() {
            var allRows = $("#PurOrderD").datagrid("getRows");
            if (allRows.length > 0) {
                var iBscDataMatRecNo = allRows[0].iBscDataMatRecNo;
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                var sqlObj = {
                    TableName: "PurOrderM AS A",
                    Fields: " top 1 sAskandStand,sStandAndPack",
                    SelectAll: "True", Filters: [
                       { Field: "iBscDataCustomerRecNo", ComOprt: "=", Value: "'" + iBscDataCustomerRecNo + "'", LinkOprt: "and" },
                       { Field: "iRecNo", ComOprt: "<>", Value: "'" + Page.key + "'", LinkOprt: "and" },
                       { Field: "iMatType", ComOprt: "=", Value: "'" + Page.getQueryString("iMatType") + "'", LinkOprt: "and" },
                       { LeftParenthese: "(", Field: "isnull(sAskandStand,'')", ComOprt: "<>", Value: "''", LinkOprt: "or" },
                       { Field: "isnull(sStandAndPack,'')", ComOprt: "<>", Value: "''",RightParenthese: ")", LinkOprt: "and" },
                       { Field: "exists", ComOprt: "", Value: " (select 1 from PurOrderD as b where b.iMainRecNo=a.iRecNo and b.iBscDataMatRecNo='"+iBscDataMatRecNo+"' )" }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    Page.setFieldValue("sAskandStand", result[0].sAskandStand);
                    Page.setFieldValue("sStandAndPack", result[0].sStandAndPack);
                }
            } else {
                Page.MessageShow("尚未增加明细", "尚未增加明细");
            }
        }
        Page.Children.onAfterDeleteRow = function (tableid,rows) {
            if (tableid == "PurOrderD") {
                var allRows = $("#" + tableid).datagrid("getRows");
                if (allRows.length == 0) {
                    Page.setFieldValue("sPurType", "");
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;height:160px;">
            <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div title="采购订单信息">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iMatType" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>采购订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>采购日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>供应商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>采购交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>采购员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                            </td>
                            <td>采购部门
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sDeptID" />
                            </td>
                            <td>采购类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sPurType" />
                            </td>
                            <td>结算方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sMoneyContion" />
                            </td>
                            <%--<td>
                                物料类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sMatTypeID" />
                            </td>--%>
                        </tr>
                        <tr>
                            <td>备注
                            </td>
                            <td colspan='5'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="98%" Z_FieldID="sReMark" />
                            </td>
                            <td>交货方式
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea2" Z_FieldID="sDeliveryAddr" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldType="数值" runat="server" Z_FieldID="fQty"
                                    Z_readOnly="True" Z_decimalDigits="2" />
                            </td>
                            <td>金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fTotal" Z_FieldType="数值"
                                    Z_readOnly="True" Z_decimalDigits="2" />
                            </td>
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                            </td>
                            <td>制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div title="要求内容">
                    <table class="tabmain">                        
                        <tr>
                            <td>质量要求验布标准：
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea3" Style="width: 500px; height: 50px;" Z_FieldID="sAskandStand" runat="server" />
                            </td>
                            <td>
                                <input type="button" value="从上次导入" onclick="importLast()" />
                            </td>
                        </tr>
                        <tr>
                            <td>标准及包装要求：
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea4" Style="width: 500px; height: 50px;" Z_FieldID="sStandAndPack" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" id="tabC" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <table id="PurOrderD" tablename="PurOrderD">
                    </table>
                </div>
                <div data-options="fit:true" title="备注明细">
                    <table id="Table1" tablename="PurOrderDRemark">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
