<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            $(".length1").hide();
            Page.Children.toolBarBtnDisabled("table1", "add");
            //初始化table2数据    
            if (otype == "add")
                change();            
            if (getQueryString("iBillType") == "1") {

                $("#tableMatUse").datagrid(
                {
                    border: false,
                    fit: true,
                    singleSelect: true,
                    remoteSort: false,
                    toolbar: [
                        {
                            iconCls: "icon-save",
                            text: "保存",
                            handler: function () {
                                save();   //调用保存函数
                            }
                        },
                        {
                            iconCls: "icon-cancel",
                            text: "退出",
                            handler: function () {
                                $("#divMatUse").window("close");
                            }
                        }
                    ],
                    columns: [
                        [
                            { field: "sCode", title: "物料编码", width: 100, align: "center" },
                            { field: "sName", title: "物料名称", width: 80, align: "center" },
                            { field: "sElements", title: "规格", width: 110, align: "center" },
                            { field: "fSrate1", title: "用料%", width: 60, align: "center" },
                            { field: "fStockQty", title: "库存量", width: 80, align: "center" },
                            { field: "fNeedQty", title: "需用量", width: 80, align: "center" },
                            { field: "fQty", title: "采购量", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2, required: true}} },
                            { field: "fsupplierQty", title: "加工厂<br />提供量", width: 60, align: "center", editor: { type: "numberbox", options: { precision: 2, required: true}} },
                            { field: "sCustShortName", title: "纱线产地", width: 80, align: "center", editor: { type: "text"} },
                            { field: "sBatchNo", title: "纱线批号", width: 80, align: "center", editor: { type: "text"} },
                            { field: "iBscDataMatRecNo", hidden: true },
                            { field: "iRecNo", hidden: true },
                            { field: "iMainRecNo", hidden: true }
                        ]
                    ]
                }
                );

                var options = $("#table1").datagrid("options");   //新增一个纱线用量
                options.columns[0].splice(10, 0,
                {
                    title: "纱线用量",
                    field: "__dddd",
                    formatter: function (value, row, index) {
                        return "<a href='javascript:void(0)' onclick='openwin(" + row.iRecNo + "," + row.iBscDataMatRecNo + "," + index + ")'>纱线用量</a>";
                    },
                    width: 70,
                    align: "center"
                }
                );
                $("#table1").datagrid(options);   //新增一个纱线用量

                $(".length").hide();

                Page.Children.toolBarBtnDisabled("table1", "copy");
                Page.Children.toolBarBtnAdd("table1", "print", "打印", "print", function () {
                    var selectedRows = $("#table1").datagrid("getChecked");
                    if (selectedRows.length > 0) {
                        $.messager.confirm("您确认打印吗？", "您确认打印坯布编号【" + selectedRows[0].sBscDataFabCode + "】吗？", function (r) {
                            if (r) {
                                var sqlObj = {
                                    TableName: "ProOutProduceD",
                                    Fields: "1",
                                    SelectAll: "True",
                                    Filters: [
                                        {
                                            Field: "iRecNo",
                                            ComOprt: "=",
                                            Value: "'" + selectedRows[0].iRecNo + "'"
                                        }
                                    ]
                                }
                                var result = SqlGetData(sqlObj);
                                if (result.length == 0) {
                                    alert("请选保存再打印");
                                    return;
                                }
                                var iWarp = selectedRows[0].iWarp;
                                if (iWarp == "1") {
                                    //                                    var fQty = parseFloat(selectedRows[0].fQty);
                                    //                                    var sAsk = selectedRows[0].sProduceAsk == undefined || selectedRows[0].sProduceAsk == null ? "" : selectedRows[0].sProduceAsk;
                                    //                                    var fFabWeight = selectedRows[0].fFabWeight;
                                    //                                    var fPrice = parseFloat(selectedRows[0].fPrice);
                                    //                                    var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                                    //                                    var iBscDataMatRecNo = selectedRows[0].iBscDataMatRecNo;
                                    //                                    var iSdOrderMRecNo = selectedRows[0].iSdOrderMRecNo;
                                    //var urlParams = "pb_fQty=" + fQty + "&pb_sAsk=" + encodeURI(sAsk) +
                                    //                                    "&pb_fFabWeight=" + fFabWeight + "&pb_fPrice=" + fPrice + "&pb_iBscDataCustomerRecNo=" + iBscDataCustomerRecNo +
                                    //                                    "&pb_iBscDataMatRecNo=" + iBscDataMatRecNo + "&pb_iSdOrderMRecNo=" + iSdOrderMRecNo;
                                    var urlParams = "pb_iRecNo=" + selectedRows[0].iRecNo;
                                    var url = "/Base/PbPage.aspx?otype=show&iformid=8901&irecno=58&key=" + Page.key + "&" + urlParams + "&r=" + Math.random();
                                }
                                else {
                                    var sqlObj = {
                                        TableName: "ProOutProduceDMatD",
                                        Fields: "1",
                                        SelectAll: "True",
                                        Filters: [
                                        {
                                            Field: "iMainRecNo",
                                            ComOprt: "=",
                                            Value: "'" + selectedRows[0].iRecNo + "'"
                                        }
                                    ]
                                    }
                                    var result = SqlGetData(sqlObj);
                                    if (result.length == 0) {
                                        alert("请先分配纱线用量！");
                                        return;
                                    }
                                    var urlParams = "pb_iRecNo=" + selectedRows[0].iRecNo;
                                    var url = "/Base/PbPage.aspx?otype=show&iformid=8901&irecno=82&key=" + Page.key + "&" + urlParams + "&r=" + Math.random();
                                }
                                $("#ifrpb").attr("src", "");
                                $("#ifrpb").attr("src", url);
                            }
                        });
                    }
                    else {
                        $.messager.alert("请选择一行", "请勾选一行！");
                    }
                });
                Page.DoNotCloseWinWhenSave = true;


            }
            else {
                $(".tdCompany").hide();
            }
        })
        var otype = "add";

        function openwin(iRecNo, iBscDataMatRecNo, index) {
            var sqlObj = {
                TableName: "vwProOutProduceDMatD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + iRecNo + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                otype = "modify";
                $("#tableMatUse").datagrid("loadData", result);
            }
            else {
                otype = "add";
                var sqlObj1 = {
                    TableName: "vwBscDataMatDWaste",
                    Fields: "sCode,sName,sElements,fSrate1,iBscDataMatRecNo,fStockQty",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + iBscDataMatRecNo + "'"
                    }
                ]
                }
                var result1 = SqlGetData(sqlObj1);
                if (result1.length > 0) {
                    var selectedRow = $("#table1").datagrid("getRows")[index];
                    var fQty = Number(selectedRow.fQty);
                    for (var i = 0; i < result1.length; i++) {
                        result1[i].iMainRecNo = iRecNo;
                        result1[i].fNeedQty = (fQty * Number(result1[i].fSrate1) / 100).toFixed(2);
                    }
                    $("#tableMatUse").datagrid("loadData", result1);
                }
            }
            var rows = $("#tableMatUse").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#tableMatUse").datagrid("beginEdit", i);
            }
            if (rows.length > 0) {
                var ed = $('#tableMatUse').datagrid('getEditor', { index: 0, field: 'fQty' });
                $($(ed.target).numberbox('textbox')).focus;
                $($(ed.target).numberbox('textbox')).select;
            }
            $("#divMatUse").window("open");
        }

        function save() {
            var bo = 0;
            var rows = $("#tableMatUse").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#tableMatUse").datagrid("endEdit", i);
                var iMainRecNo = rows[i].iMainRecNo;
                var iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                var fSrate1 = rows[i].fSrate1;
                var sCustShortName = rows[i].sCustShortName;
                var sBatchNo = rows[i].sBatchNo;
                var fNeedQty = rows[i].fNeedQty;
                var fQty = rows[i].fQty;
                var fsupplierQty = rows[i].fsupplierQty;
                var sUserID = Page.userid;
                //var dInputDate = Page.getNowDate() + " " + Page.getNowTime()
                if (sCustShortName == undefined)
                    sCustShortName = "";
                if (sBatchNo == undefined)
                    sBatchNo = "";
                if (fQty == undefined)
                    fQty = 0;
                var jsonobj = {
                    StoreProName: "SpProOutProduceDMatD",
                    StoreParms: [{
                        ParmName: "@iMainRecNo", Value: iMainRecNo
                    },
                        { ParmName: "@iBscDataMatRecNo", Value: iBscDataMatRecNo },
		                { ParmName: "@fSrate1 ", Value: fSrate1 },
		                { ParmName: "@sCustShortName", Value: sCustShortName },
                        { ParmName: "@sBatchNo", Value: sBatchNo },
                        { ParmName: "@fNeedQty", Value: fNeedQty },
                        { ParmName: "@fQty", Value: fQty },
                        { ParmName: "@fsupplierQty", Value: fsupplierQty },
                        { ParmName: "@sUserID", Value: sUserID },
                        { ParmName: "@isDel", Value: i}]
                }
                var result = SqlStoreProce(jsonobj);
                if (result == "1") {
                    bo = 1;
                }
                else {
                    bo = 0;
                    break;
                }
            }
            if (bo == 1) {
                alert("保存成功");
                $("#divMatUse").window("close");
            }
            else
                alert("保存失败，请重试");

        }

        function change() {

            var myArr = new Array(5)
            myArr[0] = "请用PE袋包装，保持坯布干净。";
            myArr[1] = "布头必须缝头，请在布头50公分内详细注明：生产编号，日期，匹重。";
            myArr[2] = "布面不能有横条，竖条，毛针等显著外观疵点。";
            myArr[3] = "下布后，必须由我司确认后方可开机。";
            myArr[4] = "每次发完货后，必须把码单传回我司。传真号：0573-87769280。";

            //ProOutProduceRemark的iRecNo值
            var imainrecno = Page.key;
            var userid = Page.userid;
            var data = Page.getNowDate() + " " + Page.getNowTime();
            for (var i = 0; i < 5; i++) {
                var iSerial = i + 1;
                var irecno = Page.getChildID('ProOutProduceDRemark');
                $("#table2").datagrid("insertRow", {
                    index: i, // 索引从0开始
                    row: {
                        iRecNo: irecno,
                        imainrecno: imainrecno,
                        iSerial: iSerial,
                        sRemark: myArr[i],
                        suserid: userid,
                        dInputDate: data
                    }
                });
            }


            //            var irecno = 0;
            //            var jsonobj = {
            //                StoreProName: "GetTableLsh",
            //                StoreParms: [{
            //                    ParmName: "@tablename",
            //                    Value: 'ProOutProduceDRemark'
            //                }]
            //            }
            //            var result = SqlStoreProce(jsonobj);
            //            if (result> 0) {
            //                irecno=result;
            //            }
            //            alert(irecno);
            //            $('#table2').datagrid({

            //                data: [
            //		                    { iSerial: '1', sRemark: '请用PE袋包装，保持坯布干净。' },
            //		                    { iSerial: '2', sRemark: '布头必须缝头，请在布头50公分内详细注明：生产编号，日期，匹重。' },
            //                            { iSerial: '3', sRemark: '布面不能有横条，竖条，毛针等显著外观疵点。' },
            //		                    { iSerial: '4', sRemark: '下布后，必须由我司确认后方可开机。' },
            //		                    { iSerial: '5', sRemark: '每次发完货后，必须把码单传回我司。传真号：0573-87769280。' }
            //	                    ]
            //            });
        }
        function save2() {
            var bo = 0;
            var iMainRecNo;
            var iBscDataMatRecNo;
            var fSrate1;
            var sCustShortName;
            var sBatchNo;
            var fNeedQty;
            var sUserID = Page.userid;
            var rows = $("#tableMatUse").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#tableMatUse").datagrid("endEdit", i);
                if (i = 0)
                    var iMainRecNo = rows[i].iMainRecNo;
                var iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                var fSrate1 = rows[i].fSrate1;
                var sCustShortName = rows[i].sCustShortName;
                var sBatchNo = rows[i].sBatchNo;
                var fNeedQty = rows[i].fNeedQty;
                var fQty = rows[i].fQty;
                var sUserID = Page.userid;
                //var dInputDate = Page.getNowDate() + " " + Page.getNowTime()
                if (sCustShortName == undefined)
                    sCustShortName = "";
                if (sBatchNo == undefined)
                    sBatchNo = "";
                if (fQty == undefined)
                    fQty = 0;
                var jsonobj = {
                    StoreProName: "SpProOutProduceDMatD",
                    StoreParms: [{
                        ParmName: "@iMainRecNo", Value: iMainRecNo
                    },
                        { ParmName: "@iBscDataMatRecNo", Value: iBscDataMatRecNo },
		                { ParmName: "@fSrate1 ", Value: fSrate1 },
		                { ParmName: "@sCustShortName", Value: sCustShortName },
                        { ParmName: "@sBatchNo", Value: sBatchNo },
                        { ParmName: "@fNeedQty", Value: fNeedQty },
                        { ParmName: "@fQty", Value: fQty },
                        { ParmName: "@sUserID", Value: sUserID },
                        { ParmName: "@isDel", Value: i}]
                }
                var result = SqlStoreProce(jsonobj);
                if (result == "1") {
                    bo = 1;
                }
                else {
                    bo = 0;
                    break;
                }
            }
            if (bo == 1) {
                alert("保存成功");
                $("#divMatUse").window("close");
            }
            else
                alert("保存失败，请重试");

        }

        Page.beforeSave = function () {
            if (getQueryString("iBillType") == "2") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if ((rows[i].iOut == null || rows[i].iOut == undefined) && (rows[i].iIn == null || rows[i].iIn == undefined)) {
                        alert("第" + (i + 1).toString() + "条明细：完成入库、加工出库请至少勾选一个！\r\n完成入库表示是最终加工完成的成品，要入库的；加工出库表示这是要发给加工厂加工的半成品。");
                        return false;
                    }
                }
            }
            if (getQueryString("iBillType") == "1") {
                var rows = $("#table1").datagrid("getRows");
                var iRecNoStr = ",";
                for (var i = 0; i < rows.length; i++) {
                    if (iRecNoStr.indexOf("," + rows[i].iSDOrderDRecNo + ",") > -1) {
                        $.messager.alert("同一订单不能重复", "同一订单不能重复转入！");
                        return false;
                    }
                    else {
                        iRecNoStr += rows[i].iSDOrderDRecNo + ",";
                    }
                }
            }
        }
        
        lookUp.beforeOpen = function (uniqueid) {
            if (uniqueid == "2039") {
                var iBscDataProcessMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
                if (iBscDataProcessMRecNo == "" || iBscDataProcessMRecNo == null || iBscDataProcessMRecNo == undefined) {
                    Page.MessageShow("请先选择加工工序", "请先选择加工工序");
                    return false;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iBillType" />
                <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="sDeptID" />
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        加工单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        加工日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        加工厂家
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td class="tdCompany">
                        所属单位
                    </td>
                    <td class="tdCompany">
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCompany" />
                    </td>
                </tr>
                <tr>
                    <td>
                        交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="dDeliveryDate" Z_FieldType="日期" />
                    </td>
                    <td class="length1">
                        长度单位
                    </td>
                    <td class="length1">
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iUnitID" />
                    </td>
                    <td class="length" colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iSupply" />
                        <label for="__ExtCheckbox1">
                            提供委托单位样品</label>
                    </td>
                    <td class="length">
                        加工工序
                    </td>
                    <td class="length">
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataProcessMRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="334px" Z_FieldID="sRemark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="加工明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="ProOutProduceD">
                    </table>
                </div>
                <div data-options="fit:true" title="加工要求">
                    <!--  子表1  -->
                    <table id="table3" tablename="ProOutProduceDTech">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="备注明细">
                    <!--  子表1  -->
                    <table id="table2" tablename="ProOutProduceDRemark">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
    <div id="divMatUse" class="easyui-window" data-options="closed:true,closable:true,title:'纱线用料',collapsible:false,minimizable:false,maximizable:false,modal:true,width:800,height:250">
        <table id="tableMatUse">
        </table>
    </div>
</asp:Content>
