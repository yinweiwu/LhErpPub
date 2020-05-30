<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>工票扫描</title>
    <style type="text/css">
        body
        {
            font-family: 微软雅黑;
        }
        .bigFont
        {
            font-size: 20px;
            font-weight: bold;
        }
        .bigFont1
        {
            font-size: 14px;
            font-weight: bold;
        }
        .txbInput
        {
            height: 25px;
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-bottom: 1px solid #a0a0a0;
            width: 100px;
        }
        .txbInputDisabled
        {
            height: 25px;
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-bottom: 1px solid #a0a0a0;
            background-color: #efefef;
            width: 100px;
        }
        .txbInput1
        {
            height: 25px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-bottom: 1px solid #a0a0a0;
            width: 100px;
        }
        .tab
        {
            /*border-spacing: 3px;*/
        }
        .tab tr td
        {
            /*padding: 3px;*/
        }
        /*.easyui-linkbutton span
        {
            display: inline-block;
            vertical-align: top;
            width: auto;
            line-height: 24px;
            font-size: 14px;
            font-weight: bold;
            padding: 0;
            margin: 0 4px;
        }*/
    </style>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.easyui.min.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <%--<script src="/Base/JS/datagridExtend.js" type="text/javascript"></script>--%>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/ProBarcodeScanOther.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        /*
        {sCode:"",sName:"",sClassID:"",sSerialID:"",sSerialName:"",iMatWaste:""}
        */
        var currentUser = undefined;
        var isWindowStockInit = false;
        var isWindowCheckInit = false;
        var isChangePc = false;
        var isMatUseWindowOpen = false;
        var isCheckWindowOpen = false;
        //var isSeachByBarcode = false; //标记列表是否是按条码查询的。如果是，则在刷好条码后重新获取员工数据
        $(function () {
            //工序生产明细
            $("#tableSerial").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                //data: gridData,
                columns: [[
                    { field: 'sDeptName', title: '所在部门', width: 80, sortable: true },
                    { field: 'sBscDataPersonName', title: '人员', width: 80, sortable: true },
                    { field: 'sSerialID', title: '工序', width: 60, sortable: true },
                    { field: 'dDateStr', title: '时间', width: 140, sortable: true },
                    { field: 'sOrderNo', title: '订单号', width: 100, sortable: true },
                    { field: 'sCustShortName', title: '客户', width: 100, sortable: true },
                    { field: 'sStyleNo', title: '款号', width: 100, sortable: true },
                    { field: 'sColorName', title: '颜色', width: 120, sortable: true },
                    { field: 'iQty', title: '数量', width: 60, sortable: true },
                    { field: 'fQty', title: '搭色用料', width: 80, sortable: true },
                    { field: 'fQty2', title: '换片用料', width: 80, sortable: true },
                    { field: 'fAddQty', title: '补料用料', width: 80, sortable: true },
                    { field: 'sSerialName', title: '工票名称', width: 100, sortable: true },
                    { field: 'sBarCodeSerial', title: '工票号', width: 100, sortable: true },
                    { field: 'sUserName', title: '登记人员', width: 100, sortable: true },
                    { field: 'sProOrderNo', title: '生产单号', width: 120, sortable: true }
                ]],
                singleSelect: true
            });

            //工序生产明细
            $("#tableChange").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                //data: gridData,
                columns: [[
                    { field: 'sType', title: '类型', width: 60, sortable: true },
                    { field: 'sUserName', title: '人员', width: 80, sortable: true },
                    { field: 'sSerialID', title: '工序', width: 60, sortable: true },
                    { field: 'sSerialName', title: '工序名称', width: 80, sortable: true },
                    { field: 'dInputDateStr', title: '时间', width: 140, sortable: true },
                    { field: 'sStyleNo', title: '订单号', width: 100, sortable: true },
                    { field: 'sCustShortName', title: '客户', width: 120, sortable: true },
                    { field: 'sStyleNo', title: '款号', width: 60, sortable: true },
                    { field: 'sColorName', title: '颜色', width: 80, sortable: true },
                    { field: 'sName', title: '物料名称', width: 80, sortable: true },
                    { field: 'fQty', title: '补料/换片数量', width: 100, sortable: true },
                    { field: 'sBarCodeSerial', title: '工票号', width: 100, sortable: true },
                    { field: 'fBecause', title: '原因分析', width: 150, sortable: true }
                ]],
                singleSelect: true
            });

            $("#tableStock").datagrid({
                fit: true,
                remoteSort: false,
                singleSelect: true,
                columns: [[
                    { field: 'sStockName', title: '仓库', width: 100 },
                    { field: 'sCode', title: '物料编码', width: 100 },
                    { field: 'sName', title: '物料名称', width: 100 },
                    { field: 'Spec', title: '规格', width: 100 },
                    { field: 'sUnitName', title: '计量单位', width: 100 },
                    { field: 'fQty', title: '数量', width: 100 },
                //                    { field: 'sOrderNo', title: '订单号', width: 100 },
                //                    { field: 'sStyleNo', title: '款号', width: 100 },
                    {field: 'sBatchNo', title: '批号', width: 100 },
                //                    { field: 'sName', title: '客供', width: 100 },
                    {field: 'sName', title: '供应商', width: 100 }
                    ]]
            });

            var userid = "";
            $.ajax({
                url: "/ashx/LoginHandler.ashx",
                type: "get",
                async: false,
                cache: false,
                data: { otype: "getcurtuserid" },
                success: function (data) {
                    userid = data;
                },
                error: function (data) {
                    txbMessage(data.responseText, "txbMessage");
                }
            });
            //库存弹窗关闭
            $("#divMatWaste").window("close");
            $("#divCheck").window("close");
            //获取当前用户的部门、默认工序
            var sqlObjCurretUser = {
                TableName: "vwbscDataPerson",
                Fields: "sClassID,sSerialID,sName,sCode,sSerialName,iMatWaste,iStock,iCheck",
                SelectAll: "True",
                Filters: [{
                    Field: "sClassID",
                    ComOprt: "=",
                    Value: "(select sClassID from bscDataPerson where sCode='" + userid + "')"
                }]
            }
            var personData = SqlGetData(sqlObjCurretUser);
            if (personData && personData.length > 0) {
                for (var i = 0; i < personData.length; i++) {
                    if (personData[i].sCode == userid) {
                        currentUser = personData[i];
                        break;
                    }
                }
                $("#txbCode").val(currentUser.sCode);
                $("#txbName").val(currentUser.sName);
                $("#txbSerialID").val(currentUser.sSerialID);
                $("#txbSerialName").val(currentUser.sSerialName);
                $("#hidIsMatWaste").val(currentUser.iMatWaste);
                $("#hidIsStock").val(currentUser.iStock);
                $("#hidDefaultIsMatWaste").val(currentUser.iMatWaste);
                $("#hidDefaultIsStock").val(currentUser.iStock);
                $("#hidDefaultSerialID").val(currentUser.sSerialID);
                $("#hidDefaultSerialName").val(currentUser.sSerialName);
                $("#hidDefaultIsCheck").val(currentUser.iCheck);
                var gridData = {};
                var personTodayYield = getTodayYield(currentUser.sCode, currentUser.sSerialID);
                if (personTodayYield.length > 0) {
                    $("#txbTodayPerson").val("今天:" + personTodayYield.length);
                    gridData = { rows: personTodayYield, total: personTodayYield.length };
                    $("#tableSerial").datagrid("loadData", gridData);
                }
                else {
                    $("#txbTodayPerson").val("今天:0");
                }

                getSerialTodyYield(currentUser.sSerialID, function (data) {
                    if (data.success == true) {
                        $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                    }
                });

                $("#tablePerson").datagrid(
                {
                    fit: true,
                    border: false,
                    singleSelect: true,
                    data: personData,
                    columns: [[
                        { field: 'sSerialName', title: '工序', width: 80 },
                        { field: 'sCode', title: '工号', width: 80 },
                        { field: 'sName', title: '姓名', width: 80 }
                    ]],
                    onDblClickRow: function (index, row) {
                        $("#txbCode").val(row.sCode);
                        $("#txbName").val(row.sName);
                        $("#txbSerialID").val(row.sSerialID);
                        $("#txbSerialName").val(row.sSerialName);
                        $("#hidIsMatWaste").val(row.iMatWaste);
                        $("#hidIsStock").val(row.iStock);
                        $("#hidDefaultIsMatWaste").val(row.iMatWaste);
                        $("#hidDefaultIsStock").val(row.iStock);
                        $("#hidDefaultSerialID").val(row.sSerialID);
                        $("#hidDefaultSerialName").val(row.sSerialName);
                        $("#hidDefaultIsCheck").val(row.iCheck);
                        var personTodayYield = getTodayYield(row.sCode, row.sSerialID);
                        if (personTodayYield.length > 0) {
                            $("#txbTodayPerson").val("今天:" + personTodayYield.length);
                            var gridData = { rows: personTodayYield, total: personTodayYield.length };
                            $("#tableSerial").datagrid("loadData", gridData);
                        }
                        else {
                            $("#txbTodayPerson").val("今天:0");
                            $("#tableSerial").datagrid("loadData", { rows: [], total: 0 });

                        }
                        getSerialTodyYield(row.sSerialID, function (data) {
                            if (data.success == true) {
                                $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                            }
                        });
                        $("#txbBarcode").select();
                        //isSeachByBarcode = false;
                    }
                });
            }

            //如果当前工序是用料工序，则要显示出库存查询，否则隐藏
            if (currentUser.iMatWaste == "1" /*|| 1 == 1*/) {
                var sqlObjStockCondition = {
                    TableName: "BscDataStockM",
                    Fields: "iRecNo,sStockName",
                    SelectAll: "True",
                    Filters: [
                               {
                                   Field: "sDeptID",
                                   ComOprt: "=",
                                   Value: "'" + currentUser.sClassID + "'"
                               }
                             ]
                };
                var StockCondition = SqlGetData(sqlObjStockCondition);
                if (StockCondition && StockCondition.length > 0) {
                    for (var i = 0; i < StockCondition.length; i++) {
                        var option = $("<option>").val(StockCondition[i].iRecNo).text(StockCondition[i].sStockName);
                        $("#selStockNameCondition").append(option);
                    }
                }
            }
            else {
                $("#panel").layout("remove", "north");
            }
            $("#txbBarcode").focus();
        })
        //获取员工当前产量
        function getTodayYield(sCode, sSerialID) {
            var dateStr = new Date().Format("yyyy-MM-dd");
            var filterPersonObj = [
            //                {
            //                    Field: "right(sBarCodeSerial,4)",
            //                    ComOprt: "=",
            //                    Value: "'" + currentUser.sSerialID + "'",
            //                    LinkOprt: "and"
            //                },
                {
                Field: "convert(varchar(10),dDate,23)",
                ComOprt: "=",
                Value: "'" + dateStr + "'",
                LinkOprt: "and"
            },
                {
                    Field: "sBscDataPersonID",
                    ComOprt: "=",
                    Value: "'" + sCode + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iFinish,0)",
                    ComOprt: "=",
                    Value: "1"
                }
                ];

            var personTodayYield = getSerialList(filterPersonObj);
            return personTodayYield;
        }
        //获取工序当天产量
        function getSerialTodyYield(sSerialID, fun) {
            var dateStr = new Date().Format("yyyy-MM-dd");
            var sqlObj = {
                TableName: "ProOrderDBarCodeSerial",
                Fields: "count(iFinish) as count",
                SelectAll: "True",
                Filters: [
                {
                    Field: "right(sBarCodeSerial,4)",
                    ComOprt: "=",
                    Value: "'" + sSerialID + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "convert(varchar(10),dDate,23)",
                    ComOprt: "=",
                    Value: "'" + dateStr + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iFinish,0)",
                    ComOprt: "=",
                    Value: "1"
                }
                ]
            };
            SqlGetData(sqlObj, true, true, fun);
        }

        function MessageShow(title, message) {
            $.messager.show({
                showSpeed: 100,
                title: title,
                msg: message,
                showType: 'slide',
                timeout: 2000,
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
        }
        function searchCondition() {
            var iStockRecNo = $("#selStockNameCondition").val();
            var sOrderNo = $("#txbOrderNoCondition").val();
            var sCode = $("#txbMatCondition").val();
            var sStyleNo = $("#txbStyleNoCondition").val();
            var filters = [];
            if (iStockRecNo != "") {
                filters.push({
                    Field: "iBscDataStockMRecNo",
                    ComOprt: "=",
                    Value: "'" + iStockRecNo + "'"
                });
            }
            if (sOrderNo != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "sOrderNo",
                    ComOprt: "like",
                    Value: "'%" + sOrderNo + "%'"
                });
            }
            if (sCode != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "sCode",
                    ComOprt: "like",
                    Value: "'%" + sCode + "%'"
                });
            }
            if (sStyleNo != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "sStyleNo",
                    ComOprt: "like",
                    Value: "'%" + sStyleNo + "%'"
                });
            }
            var sqlObj = {
                TableName: "vwMMStockQty",
                Fields: "*",
                SelectAll: "True",
                Filters: filters
            }
            SqlGetData(sqlObj, true, true, function (data) {
                if (data.success == true) {
                    $("#tableStock").datagrid("loadData", { rows: data.tables[0], total: data.tables[0].length });
                }
            });
        }

        function getSerialList(filter) {
            var sqlObj = {
                TableName: "vwProOrderDBarCodeSerialFull",
                Fields: "*",
                SelectAll: "True",
                Filters: filter,
                Sorts: [
                {
                    SortName: "dDate",
                    SortOrder: "desc"
                }]
            }
            var result = SqlGetData(sqlObj);
            return result;
        }

        function doSearchSerialList(type) {
            if (type == "sCode") {
                var sCode = $("#txbCode").val();
                var dateStr = (new Date()).Format("yyyy-MM-dd");
                //alert(dateStr);
                var filter = [
                {
                    Field: "sBscDataPersonID",
                    ComOprt: "=",
                    Value: "'" + sCode + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "convert(varchar(10),dDate,23)",
                    ComOprt: "=",
                    Value: "'" + dateStr + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iFinish,0)",
                    ComOprt: "=",
                    Value: "1"
                }
                ];
                var data = getSerialList(filter);
                var gridData = { rows: data, total: data.length };
                $("#tableSerial").datagrid("loadData", gridData);
                //isSeachByBarcode = false;
            }
            if (type == "sBarcode") {
                var sBarcode = $("#txbBarcode").val();
                var filter = [
                    {
                        Field: "sBarCode",
                        ComOprt: "=",
                        Value: "'" + sBarcode + "'"
                    }
                    ];
                var data = getSerialList(filter);
                if (data.length > 0) {
                    var gridData = { rows: data, total: data.length };
                    $("#tableSerial").datagrid("loadData", gridData);
                }
                else {
                    $("#tableSerial").datagrid("loadData", { rows: [], total: 0 });
                }

                if (sBarcode == "") {
                    return;
                }
                //换片、补料
                var sqlObj = {
                    TableName: "vwProOrderDBarCodeD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sBarCodeSerial",
                            ComOprt: "like",
                            Value: "'" + sBarcode + "%'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "iFlag",
                            ComOprt: "in",
                            Value: "(1,2)"
                        }
                    ],
                    Sorts: [
                    {
                        SortName: "dInputDate",
                        SortOrder: "desc"
                    }]
                };
                SqlGetData(sqlObj, true, true, function (data) {
                    if (data.success == true) {
                        $("#tableChange").datagrid("loadData", { rows: data.tables[0], total: data.tables[0].length });
                    }
                });

            }
        }

        function doScan() {
            var event = arguments.callee.caller.arguments[0] || window.event; //消除浏览器差异
            if (event.keyCode == 13) {
                $("#txbBarcode").select();
                $("#txbMessage").val("");
                var scanText = $("#txbBarcode").val();
                if (scanText.length > 0) {
                    scanBarcodeProc(scanText);
                }
            }
        }

        function scanBarcodeProc(scanText) {
            $("#divCheck").window("close");
            var length = scanText.length;
            //4位是工序
            if (length == 4) {
                var sqlObj = {
                    TableName: "bscDataSerial",
                    Fields: "sSerialID,sSerialName,iMatWaste,iStock",
                    SelectAll: "True",
                    Filters: [
                                {
                                    Field: "sSerialID",
                                    ComOprt: "=",
                                    Value: "'" + scanText + "'"
                                }
                            ]
                };
                var resSerail = SqlGetData(sqlObj);
                if (resSerail.length > 0) {
                    $("#txbSerialID").val(resSerail[0].sSerialID);
                    $("#txbSerialName").val(resSerail[0].sSerialName);
                    $("#hidIsMatWaste").val(resSerail[0].iMatWaste);
                    $("#hidIsStock").val(resSerail[0].iStock);
                    $("#hidDefaultIsCheck").val(resSerail[0].iCheck);
                    getSerialTodyYield(resSerail[0].sSerialID, function (data) {
                        $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                    });
                }
                else {
                    //$("#txbMessage").val("工序不存在！");
                    txbMessage("工序不存在！", "txbMessage");
                }
            }
            //3~7位是员工工号
            else if ((length > 3 && length <= 7) || length > 12) {
                var sqlObj = {};
                if (length > 3 && length <= 7) {
                    sqlObj = {
                        TableName: "vwbscDataPerson",
                        Fields: "sCode,sName,sSerialID,sSerialName,iMatWaste,iStock",
                        SelectAll: "True",
                        Filters: [
                                {
                                    Field: "sCode",
                                    ComOprt: "=",
                                    Value: "'" + scanText + "'"
                                }
                            ]
                    };
                }
                if (length > 12) {
                    sqlObj = {
                        TableName: "vwbscDataPerson",
                        Fields: "sCode,sName,sSerialID,sSerialName,iMatWaste,iStock",
                        SelectAll: "True",
                        Filters: [
                                {
                                    Field: "sKqCode",
                                    ComOprt: "=",
                                    Value: "'" + scanText + "'"
                                }
                            ]
                    };
                }
                var resPerson = SqlGetData(sqlObj);
                if (resPerson.length > 0) {
                    $("#txbCode").val(resPerson[0].sCode);
                    $("#txbName").val(resPerson[0].sName);
                    $("#txbSerial").val(resPerson[0].sSerialID);
                    $("#txbSerialName").val(resPerson[0].sSerialName);
                    $("#hidIsMatWaste").val(resPerson[0].iMatWaste);
                    $("#hidIsStock").val(resPerson[0].iStock);
                    $("#hidDefaultIsMatWaste").val(resPerson[0].iMatWaste);
                    $("#hidDefaultIsStock").val(resPerson[0].iStock);
                    $("#hidDefaultSerialID").val(resPerson[0].sSerialID);
                    $("#hidDefaultSerialName").val(resPerson[0].sSerialName);
                    var personTodayYield = getTodayYield(row.sCode, row.sSerialID);
                    if (personTodayYield.length > 0) {
                        $("#txbTodayPerson").val("今天:" + personTodayYield.length);
                        var gridData = { rows: personTodayYield, total: personTodayYield.length };
                        $("#tableSerial").datagrid("loadData", gridData);
                    }
                    else {
                        $("#txbTodayPerson").val("今天:0");
                        $("#tableSerial").datagrid("loadData", { rows: [], total: 0 });
                    }
                    getSerialTodyYield(resPerson[0].sSerialID, function (data) {
                        $("#txbTodaySerial").val("今天：" + data[0].count);
                    });
                    //isSeachByBarcode = false;
                }
                else {
                    //$("#txbMessage").val("员工不存在！");
                    txbMessage("员工不存在！", "txbMessage");
                }
            }
            //8~12是条码、工票、返修
            else if (length > 7 && length <= 12) {
                var iMatWaste = $("#hidIsMatWaste").val();
                var barcodefull = "";
                if (scanText.substr(0, 2) == "99") {
                    if ($("#hidDefaultIsCheck").val() != "1") {
                        txbMessage($("#txbName").val() + "无检验权限", "txbMessage");
                        return;
                    }
                    else {
                        CheckWindowOpen($("#txbBarcode").val().substr(2, $("#txbBarcode").val().length - 2));
                        return;
                    }
                }
                if (length == 8) {
                    //8位是条码
                    barcodefull = $("#txbBarcode").val() + $("#txbSerialID").val();
                }
                if (length == 12) {
                    barcodefull = $("#txbBarcode").val();
                }

                if (iMatWaste == "1") {
                    MatWasteWindowOpen(barcodefull, "0");
                    $("#txbMatWasteBarcode").val(barcodefull);
                }
                else {
                    Register(barcodefull, "0");
                }
            }


            if (length != 4) {
                //是否保持工序，不是扫描工序时
                if ($("#cbkKeySerail")[0].checked == false) {
                    $("#txbSerialID").val($("#hidDefaultSerialID").val());
                    $("#txbSerialName").val($("#hidDefaultSerialName").val());
                    $("#hidIsMatWaste").val($("#hidDefaultIsMatWaste").val());
                    $("#hidIsStock").val($("#hidDefaultIsStock").val());
                }
            }
        }
        function MatWasteWindowOpen(barcodefull, type) {
            $("#matUseConfirm").attr("type", type);
            $("#txaChangeReason").val("");
            //先判断工票是否存在
            var sqlObjExists = {
                TableName: "vwProOrderDBarCodeSerialFull",
                Fields: "convert(varchar(10),dDate,23) as dDate,sUserID,sUserName,isnull(iFinish,0) as iFinish,iBscDataColorRecNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sBarCodeSerial",
                        ComOprt: "=",
                        Value: "'" + barcodefull + "'"
                    }
                ]
            }
            var resultExits = SqlGetData(sqlObjExists);
            if (resultExits.length == 0) {
                //$("#txbMessage").val("条码或工票不存在！");
                txbMessage("条码或工票不存在！", "txbMessage");
                return;
            }
            else {
                if (type == "0") {
                    if (resultExits[0].iFinish == "1") {
                        txbMessage("此条码已于[" + resultExits[0].dDate + "]被[" + resultExits[0].sUserName + "]登记,请先取消登记！", "txbMessage");
                        return;
                    }
                }
            }

            if (type != "0") {
                $("#tdChangeReason").show();
                if (type == "1") {
                    $("#matUseReson").html("换片原因");
                }
                else {
                    $("#matUseReson").html("补料原因");
                }
                isChangePc = true;
            }
            else {
                $("#tdChangeReason").hide();
                isChangePc = false;
            }
            if (isWindowStockInit == false) {
                $("#tableMatWasteStock").datagrid({
                    fit: true,
                    remoteSort: false,
                    columns: [[
                        { field: "sBatchNo", title: "批号", width: 60, sortable: true },
                        { field: "sCode", title: "物料编码", width: 80, sortable: true },
                        { field: "sName", title: "物料名称", width: 80, sortable: true },
                        { field: "Spec", title: "规格", width: 80, sortable: true },
                        { field: "fQty", title: "库存数", width: 50, sortable: true },
                        { field: "fQtyUse", title: "<span style='color:blue;'>实际用料</span>", width: 60, sortable: true, editor: { type: "numberbox"} },
                        { field: "sOrderNo", title: "订单号", width: 70, sortable: true },
                        { field: "sStyleNo", title: "款号", width: 70, sortable: true },
                        { field: "sUnitName", title: "计量单位", width: 50, sortable: true },
                        { field: "sCustShortName", title: "供应商", width: 80, sortable: true },
                        { field: "sStockName", title: "仓库", width: 80, sortable: true }
                    ]]
                });
                isWindowStockInit = true;
            }
            //if (barcodefull != $("#txbMatWasteBarcode").val()) {
            //            var isAllMat = $("#ckbAllMat")[0].checked;
            //            if (isAllMat == false) {
            var sqlObj = {
                TableName: "vwSdOrderDBomStockQty",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iMainRecNo",
                    ComOprt: "=",
                    Value: "(select iSdOrderMRecNo from vwProOrderDBarCodeSerial where sBarCodeSerial='" + barcodefull + "')",
                    LinkOprt: "and"
                },
                {
                    LeftParenthese: "(",
                    Field: "CHARINDEX('" + resultExits[0].iBscDataColorRecNo + ",',sClothColorName+',',1)",
                    ComOprt: ">",
                    Value: "0",
                    LinkOprt: "or"
                },
                {
                    Field: "isnull(sClothColorName,'')",
                    ComOprt: "=",
                    Value: "''",
                    RightParenthese: ")"
                }
                ]
            };
            var resData = SqlGetData(sqlObj);
            if (resData && resData.length > 0) {
                var gridData = { rows: resData, total: resData.length };
                $("#tableMatWasteStock").datagrid("loadData", gridData);
            }

            var rows = $("#tableMatWasteStock").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#tableMatWasteStock").datagrid("beginEdit", i);
                var ed = $("#tableMatWasteStock").datagrid("getEditor", { index: i, field: "fQtyUse" });
                $(ed.target).numberbox("textbox").attr("id", i);
                $(ed.target).numberbox("textbox").bind("keydown", function () {
                    var event = arguments.callee.caller.arguments[0] || window.event; //消除浏览器差异
                    if (event.keyCode == 13) {
                        var rows = $("#tableMatWasteStock").datagrid("getRows");
                        if (this.id == rows.length - 1) {
                            $("#matUseConfirm").click();
                        }
                        else {
                            var ed = $("#tableMatWasteStock").datagrid("getEditor", { index: parseInt(this.id) + 1, field: "fQtyUse" });
                            $(ed.target).numberbox("textbox").focus();
                            $(ed.target).numberbox("textbox").select();
                        }
                    }
                });
            }

            $("#divMatWaste").window("open");

            if (rows.length > 0) {
                var editor = $("#tableMatWasteStock").datagrid("getEditor", { index: 0, field: "fQtyUse" });
                $(editor.target).numberbox("textbox").focus();
                $(editor.target).numberbox("textbox").select();
            }
        }

        function MatWasteWindowOpenConfirm() {
            var barcodefull = $("#txbMatWasteBarcode").val();
            var rows = $("#tableMatWasteStock").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#tableMatWasteStock").datagrid("endEdit", i);
            }
            Register(barcodefull, $("#matUseConfirm").attr("type"));
            $("#divMatWaste").window("close");
        }

        function Register(barcodefull, type) {
            var matUseStr = "";
            var totalQty = 0;
            if ($("#hidIsMatWaste").val() == "1") {
                var rows = $("#tableMatWasteStock").datagrid("getRows");
                if (rows.length > 0) {
                    var fieldsArr = ["iBscDataStockMRecNo", "iBscDataStockDRecNo", "iBscDataCustomerRecNo", "iBscDataMatRecNo", "iBscDataSizeRecNo", "sBatchNo", "fPrice", "fQty", "fPurQty", "fQtyUse"];
                    for (var i = 0; i < rows.length; i++) {
                        for (var o in rows[i]) {
                            if ($.inArray(o, fieldsArr) == -1) {
                                delete rows[i][o];
                            }
                        }
                        var fQty = isNaN(parseFloat(rows[i].fQty)) ? 0 : parseFloat(rows[i].fQty);
                        var fPurQty = isNaN(parseFloat(rows[i].fPurQty)) ? 0 : parseFloat(rows[i].fPurQty);
                        var fQtyWaste = isNaN(parseFloat(rows[i].fQtyUse)) ? 0 : parseFloat(rows[i].fQtyUse);
                        var fPurQtyMatWaste = fQtyWaste / (fQty / fPurQty);
                        rows[i].fQty = fQtyWaste;
                        rows[i].fPurQty = fPurQtyMatWaste;
                        totalQty += fQtyWaste;
                        delete rows[i].fQtyUse;
                    }
                }
                for (var i = 0; i < rows.length; i++) {
                    var fieldsArr = ["iBscDataStockMRecNo", "iBscDataStockDRecNo", "iBscDataCustomerRecNo", "iBscDataMatRecNo", "iBscDataSizeRecNo", "fPrice", "fQty", "fPurQty", "fQtyUse"];
                    for (var o in rows[i]) {
                        if ($.inArray(o, fieldsArr) > -1) {
                            if (rows[i][o] == null || rows[i][o] == "" || rows[i][o] == undefined) {
                                rows[i][o] = "0";
                            }
                        }
                    }
                    if (rows[i].sBatchNo == null || rows[i].sBatchNo == undefined) {
                        rows[i].sBatchNo = "";
                    }
                }
                matUseStr = JSON2.stringify(rows);
            }
            var changeReason = "";
            if (isChangePc == true) {
                changeReason = $("#txaChangeReason").val();
            }
            var jsonobj = {
                StoreProName: "SpBarCodeSerialDRegister",
                StoreParms: [
                    {
                        ParmName: "@sBarCodeSerial",
                        Value: barcodefull
                    },
                    {
                        ParmName: "@MatUseStr",
                        Value: matUseStr
                    },
                    {
                        ParmName: "@sCode",
                        Value: $("#txbCode").val()
                    }
                    ,
                    {
                        ParmName: "@type",
                        Value: type
                    }
                    ,
                    {
                        ParmName: "@sChangeReason",
                        Value: changeReason
                    }
                    ,
                    {
                        ParmName: "@sUserID",
                        Value: currentUser.sCode
                    }
                    ]
            }
            var resultObj = SqlStoreProceResult(jsonobj, true);
            if (resultObj.success == true) {
                if (type == "0") {
                    var appRow = resultObj.tables[0][0];
                    var rowsAll = $("#tableSerial").datagrid("getRows");
                    var isExist = false;
                    for (var i = 0; i < rowsAll.length; i++) {
                        if (appRow.sBarCodeSerial == rowsAll[i].sBarCodeSerial) {
                            $("#tableSerial").datagrid("updateRow", { index: i, row: appRow });
                            $("#tableSerial").datagrid("selectRow", i);
                            isExist = true;
                            break;
                        }
                    }
                    if (isExist == false) {
                        $("#tableSerial").datagrid("appendRow", appRow);
                        $("#tableSerial").datagrid("selectRow", $("#tableSerial").datagrid("getRows").length - 1);
                    }
                    $("#txbTodayPerson").val("今天:" + rowsAll.length);
                    getSerialTodyYield($("#txbSerialID").val(), function (data) {
                        $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                    });
                }
                else if (type == "1") {
                    var selectRow = $("#tableSerial").datagrid("getSelected");
                    var oldQty2 = isNaN(parseFloat(selectRow.fQty2)) ? 0 : parseFloat(selectRow.fQty2)
                    selectRow.fQty2 = oldQty2 + totalQty;
                    $("#tableSerial").datagrid("updateRow", { index: $("#tableSerial").datagrid("getRowIndex", selectRow), row: selectRow });
                }

                else if (type == "2") {
                    var selectRow = $("#tableSerial").datagrid("getSelected");
                    var oldAddQty = isNaN(parseFloat(selectRow.fAddQty)) ? 0 : parseFloat(selectRow.fAddQty)
                    selectRow.fAddQty = oldAddQty + totalQty;
                    $("#tableSerial").datagrid("updateRow", { index: $("#tableSerial").datagrid("getRowIndex", selectRow), row: selectRow });
                }
                txbMessage("成功", "txbMessage");
                $("#txbBarcode").select();
            }
            else {
                //$("#txbMessage").val(resultObj.message);
                txbMessage(resultObj.message, "txbMessage");
            }
        }

        function cancelRegister() {
            var selectedRow = $("#tableSerial").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("确认", "确认取消登记吗？", function (r) {
                    if (r) {
                        var jsonobj = {
                            StoreProName: "SpBarCodeSerialDRegister",
                            StoreParms: [
                            {
                                ParmName: "@sBarCodeSerial",
                                Value: selectedRow.sBarCodeSerial
                            },
                            {
                                ParmName: "@MatUseStr",
                                Value: ""
                            },
                            {
                                ParmName: "@sCode",
                                Value: $("#txbCode").val()
                            }
                            ,
                            {
                                ParmName: "@type",
                                Value: "-1"
                            }
                            ,
                            {
                                ParmName: "@sChangeReason",
                                Value: ""
                            }
                            ,
                            {
                                ParmName: "@sUserID",
                                Value: currentUser.sCode
                            }
                            ]
                        }
                        var resultObj = SqlStoreProceResult(jsonobj);
                        if (resultObj.success == true) {
                            if (resultObj.message == "1") {
                                $("#tableSerial").datagrid("deleteRow", $("#tableSerial").datagrid("getRowIndex", selectedRow));
                            }
                            else {
                                txbMessage(resultObj.message, "txbMessage");
                                //$("#txbMessage").val(resultObj.message);
                            }
                        }
                        else {
                            //$("#txbMessage").val(resultObj.message);
                            txbMessage(resultObj.message, "txbMessage");
                        }
                    }
                })
            }
            else {
                txbMessage("请先选择要取消登记的数据！", "txbMessage");
            }
        }

        function changePiece() {
            var selectRow = $("#tableSerial").datagrid("getSelected");
            if (selectRow) {
                MatWasteWindowOpen(selectRow.sBarCodeSerial, "1");
                $("#txbMatWasteBarcode").val(selectRow.sBarCodeSerial);
            }
            else {
                txbMessage("请先选择要换片的数据！", "txbMessage");
            }
        }
        function feedMat() {
            var selectRow = $("#tableSerial").datagrid("getSelected");
            if (selectRow) {
                MatWasteWindowOpen(selectRow.sBarCodeSerial, "2");
                $("#txbMatWasteBarcode").val(selectRow.sBarCodeSerial);
            }
            else {
                txbMessage("请先选择要补料的数据！", "txbMessage");
            }
        }

        function CheckWindowOpen(barcode) {
            var barcodefull = barcode + $("#txbSerialID").val();
            //先判断工票是否存在
            var sqlObjExists = {
                TableName: "vwProOrderDBarCodeSerialFull",
                Fields: "sCustShortName,sOrderNo,sStyleNo,sColorName,sSizeName,sProOrderNo,iFinish,sUserName,dDate",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sBarCodeSerial",
                        ComOprt: "=",
                        Value: "'" + barcodefull + "'"
                        //LinkOprt: "and"
                    }
                ]
            }
            var resultExits = SqlGetData(sqlObjExists);
            if (resultExits.length == 0) {
                txbMessage("条码不存在！", "txbMessage");
                return;
            }
            else {
                $("#txbCheckCode").val($("#txbCode").val());
                $("#txbCheckName").val($("#txbName").val());
                $("#txbCheckSerialID").val($("#txbSerialID").val());
                $("#txbCheckSerialName").val($("#txbSerialName").val());
                $("#txbCheckSerialToday").val($("#txbTodaySerial").val());
                $("#txbCheckBarcode").val(barcode);

                $("#txbCheckCustomer").val(resultExits[0].sCustShortName);
                $("#txbCheckOrderNo").val(resultExits[0].sOrderNo)
                $("#txbCheckStyleNo").val(resultExits[0].sStyleNo);
                $("#txbCheckSizeName").val(resultExits[0].sSizeName);
                $("#txbCheckColor").val(resultExits[0].sColorName);
                $("#txbCheckProOrderNo").val(resultExits[0].sProOrderNo);

                if (resultExits[0].iFinish == "1") {
                    txbMessage("此条码已于[" + resultExits[0].dDate + "]被[" + resultExits[0].sUserName + "]登记,请先取消登记！", "txbMessage");
                    return;
                }
            }
            if (isCheckWindowOpen == false) {
                $("#tableCheck").datagrid({
                    fit: true,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { field: "sSerialName", title: "工序名称", width: 100, sortable: true },
                        { field: "sBscDataPersonName", title: "人员", width: 100, sortable: true },
                        { field: "sDeptName", title: "所在部门", width: 100, sortable: true },
                        { field: "sReson", title: "不合格原因", width: 200, sortable: true },

                    ]]
                });
                isCheckWindowOpen = true;
            }
            //产生生产质检主表
            var storeObj = {
                StoreProName: "SpAddProShopCheckM",
                StoreParms: [{
                    ParmName: "@sPersonCode",
                    Value: $("#txbCode").val()
                },
                    {
                        ParmName: "@sSerialID",
                        Value: $("#txbSerialID").val()
                    },
                    {
                        ParmName: "@sBarCode",
                        Value: barcode
                    },
                    {
                        ParmName: "@sUserID",
                        Value: currentUser.sCode
                    }
                    ]
            }

            var result = SqlStoreProceResult(storeObj);
            if (result.success == true) {
                var iRecNo = result.message;
                $("#hidCheckRecNo").val(iRecNo);
                $("#divCheck").window("open");
                getCheckSerialToday($("#txbCheckSerialID").val(), $("#txbCheckCode").val(), function (data) {
                    if (data.success == true) {
                        $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                        $("#txbCheckSerialToday").val("今天:" + data.tables[0][0].count);
                    }
                });
                $("#txbCheckBarcodeScan").select();
                $("#txbCheckMessage").val("");
            }
            else {
                txbMessage(result.message, "txbMessage");
            }
        }

        function doCheckScan() {
            var event = arguments.callee.caller.arguments[0] || window.event; //消除浏览器差异
            if (event.keyCode == 13) {
                var checkScanText = $("#txbCheckBarcodeScan").val();
                if (checkScanText.length > 0) {
                    var length = checkScanText.length;
                    if (length == 6) {
                        var sqlObjSerialD = {
                            TableName: "bscDataSerialD",
                            Fields: "iRecNo,iMainRecNo,sBarCode,sItemName",
                            SelectAll: "True",
                            Filters: [
                            {
                                Field: "sBarCode",
                                ComOprt: "=",
                                Value: "'" + checkScanText + "'"
                            }
                        ]
                        }

                        var serialDResult = SqlGetData(sqlObjSerialD);
                        if (serialDResult.length > 0) {
                            var barcodefull = $("#txbCheckBarcode").val() + checkScanText.substr(0, 4);
                            var sqlObj = {
                                TableName: "vwProOrderDBarCodeSerialFull",
                                Fields: "sSerialName,sBscDataPersonName,sDeptName",
                                SelectAll: "True",
                                Filters: [{
                                    Field: "sBarCodeSerial",
                                    ComOprt: "=",
                                    Value: "'" + barcodefull + "'"
                                }]
                            }
                            var dataShow = SqlGetData(sqlObj);
                            if (dataShow.length > 0) {
                                dataShow[0].sReson = serialDResult[0].sItemName;
                                var jsonobj = {
                                    StoreProName: "SpAddProShopCheckD",
                                    StoreParms: [{
                                        ParmName: "@iMainRecNo",
                                        Value: $("#hidCheckRecNo").val()
                                    },
                                    {
                                        ParmName: "@ibscDataSerialDRecNo",
                                        Value: serialDResult[0].iRecNo
                                    }]
                                }
                                var result = SqlStoreProceResult(jsonobj);
                                if (result.success == true) {
                                    $("#tableCheck").datagrid("appendRow", dataShow[0]);
                                    $("#tableCheck").datagrid("selectRow", $("#tableCheck").datagrid("getRows").length - 1);
                                    getCheckSerialToday($("#txbCheckSerialID").val(), $("#txbCheckCode").val(), function (data) {
                                        if (data.success == true) {
                                            $("#txbTodaySerial").val("今天:" + data.tables[0][0].count);
                                            $("#txbCheckSerialToday").val("今天:" + data.tables[0][0].count);
                                            txbMessage("成功", "txbCheckMessage");
                                        }
                                    });
                                }
                                else {
                                    txbMessage(result.message, "txbCheckMessage");
                                }
                            }
                        }
                        else {
                            txbMessage("不存在此不合格项目！", "txbCheckMessage");
                        }
                    }
                    else {
                        $("#txbBarcode").val(checkScanText);
                        scanBarcodeProc(checkScanText);
                    }
                    $("#txbCheckBarcodeScan").select();
                }
            }
        }

        function getCheckSerialToday(sSerialID, sCode, fun) {
            var sqlObj = {
                TableName: "vwProShopCheckD",
                Fields: "count(*) as count",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sSerialID",
                        ComOprt: "=",
                        Value: "'" + $("#txbCheckSerialID").val() + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sPersonCode",
                        ComOprt: "=",
                        Value: "'" + $("#txbCheckCode").val() + "'"
                    }
                ]
            }
            SqlGetData(sqlObj, true, true, fun);
        }
    </script>
</head>
<body id="panel" class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',split:true,collapsible:true,border:false" style="height: 170px;">
        <div class="easyui-layout" data-options="border:false,fit:true,border:false">
            <div data-options="region:'north',border:false">
                <table>
                    <tr>
                        <td>
                            <span class="bigFont1">仓库</span>
                        </td>
                        <td>
                            <%--<input id="txbStockNameCondition" type="text" class="txbInput1" />--%>
                            <select id="selStockNameCondition" class="txbInput1">
                            </select>
                        </td>
                        <td>
                            <span class="bigFont1">物料编码</span>
                        </td>
                        <td>
                            <input id="txbMatCondition" type="text" class="txbInput1" />
                        </td>
                        <td>
                            <span class="bigFont1">订单号</span>
                        </td>
                        <td>
                            <input id="txbOrderNoCondition" type="text" class="txbInput1" />
                        </td>
                        <td>
                            <span class="bigFont1">款号</span>
                        </td>
                        <td>
                            <input id="txbStyleNoCondition" type="text" class="txbInput1" />
                        </td>
                        <td>
                            <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchCondition()">
                                查询</a>
                            <%--<input id="ckbAllMat" type="checkbox" />
                            <label for="ckbAllMat" class="bigFont1">
                                全部物料</label>--%>
                            <input id="ckbReplaceMat" type="checkbox" />
                            <label for="ckbReplaceMat" class="bigFont1">
                                替代物料</label>
                        </td>
                    </tr>
                </table>
            </div>
            <div data-options="region:'center',border:false">
                <table id="tableStock">
                </table>
            </div>
        </div>
    </div>
    <div data-options="region:'center',border:false">
        <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'north'" style="height: 130px; padding-left: 10px;">
                <table class="tab">
                    <tr>
                        <td>
                            <span class="calendar-today bigFont">工号</span>
                        </td>
                        <td>
                            <input id="txbCode" type="text" class="txbInputDisabled" readonly="readonly" />
                        </td>
                        <td>
                            <input id="txbName" type="text" class="txbInputDisabled" readonly="readonly" />
                        </td>
                        <td>
                            <input id="txbTodayPerson" type="text" class="txbInputDisabled" style="width: 80px;"
                                readonly="readonly" />
                        </td>
                        <td colspan="4">
                            <input id="txbMessage" type="text" readonly="readonly" class="txbInputDisabled" style="width: 450px;
                                color: Red" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="calendar-today bigFont">工序</span>
                        </td>
                        <td>
                            <input id="txbSerialID" type="text" class="txbInputDisabled" readonly="readonly" />
                        </td>
                        <td>
                            <input id="txbSerialName" type="text" class="txbInputDisabled" readonly="readonly" />
                            <input id="hidIsMatWaste" type="hidden" />
                            <input id="hidIsStock" type="hidden" />
                            <input id="hidDefaultSerialID" type="hidden" />
                            <input id="hidDefaultSerialName" type="hidden" />
                            <input id="hidDefaultIsMatWaste" type="hidden" />
                            <input id="hidDefaultIsStock" type="hidden" />
                            <input id="hidDefaultIsCheck" type="hidden" />
                        </td>
                        <td>
                            <input id="txbTodaySerial" type="text" class="txbInputDisabled" readonly="readonly"
                                style="width: 80px;" />
                        </td>
                        <td>
                            <input id="cbkKeySerail" type="checkbox" checked="checked" />
                            <label for="cbkKeySerail" class="bigFont1">
                                保持工序号</label>
                        </td>
                    </tr>
                    <%--<tr>
                        <td>
                            <span class="calendar-today bigFont">配件</span>
                        </td>
                        <td colspan="2">
                            <input id="txbPart" type="text" class="txbInput" style="width: 150px;" />
                        </td>
                        <td colspan="3">
                            <span class="calendar-today bigFont">款号</span>&nbsp;
                            <input id="txbStyleNo" type="text" class="txbInputDisabled" readonly="readonly" style="width: 120px;" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td>
                            <span class="calendar-today bigFont">条码</span>
                        </td>
                        <td colspan="2">
                            <input id="txbBarcode" type="text" class="txbInput" onkeydown="doScan()" style="width: 190px;" />
                        </td>
                        <td colspan="3">
                            <span class="calendar-today bigFont">用料</span>&nbsp;
                            <input id="txbMatUse" type="text" class="txbInputDisabled" readonly="readonly" style="width: 120px;" />
                        </td>
                    </tr>
                </table>
                <div>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="font-size: 14px;"
                        onclick="doSearchSerialList('sCode')">按工号</a>&nbsp;&nbsp; <a class="easyui-linkbutton"
                            data-options="iconCls:'icon-search'" onclick="doSearchSerialList('sBarcode')">按条码</a>&nbsp;&nbsp;
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-customer'" onclick="changePiece()">
                        换片</a>&nbsp;&nbsp; <a class="easyui-linkbutton" data-options="iconCls:'icon-customer'"
                            onclick="feedMat()">补料</a>&nbsp;&nbsp; <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
                                onclick="cancelRegister()">取消登记</a>&nbsp;&nbsp; <a class="easyui-linkbutton" data-options="iconCls:'icon-undo'"
                                    onclick="quit()">退出</a>
                </div>
                <div id="divMatWaste" class="easyui-window" title="用料确认" style="width: 800px; height: 400px"
                    data-options="iconCls:'icon-ok',modal:true,top:50,collapsible:false,
                    minimizable:false,maximizable:false,collapsible:false,onOpen:function(){isMatUseWindowOpen=true;},
                    onClose:function(){isChangePc=false;isMatUseWindowOpen=false;}">
                    <div class="easyui-layout" data-options="fit:true,border:false">
                        <div data-options="region:'north',border:false">
                            <table>
                                <tr>
                                    <td>
                                        <span class="bigFont">条码</span>
                                    </td>
                                    <td>
                                        <input type="text" id="txbMatWasteBarcode" class="txbInputDisabled" style="width: 200px;" />
                                    </td>
                                    <td style="padding: 5px;">
                                        <a id="matUseConfirm" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                                            onclick="MatWasteWindowOpenConfirm()">确认</a>
                                    </td>
                                    <td style="padding: 5px;">
                                        <a class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="$('#divMatWaste').window('close');">
                                            退出</a>
                                    </td>
                                </tr>
                                <tr id="tdChangeReason" style="visibility: none;">
                                    <td>
                                        <span id="matUseReson" class="bigFont">换片原因</span>
                                    </td>
                                    <td colspan="3">
                                        <textarea id="txaChangeReason" style="width: 500px; height: 30px;"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div data-options="region:'center',border:false">
                            <table id="tableMatWasteStock">
                            </table>
                        </div>
                    </div>
                </div>
                <div id="divCheck" class="easyui-window" title="车间返修" style="width: 850px; height: 500px"
                    data-options="iconCls:'icon-customer',modal:true,top:50,collapsible:false,
                    minimizable:false,maximizable:false,collapsible:false,onOpen:function(){isCheckWindowOpen=true;},
                    onClose:function(){isCheckWindowOpen=false;}">
                    <div class="easyui-layout" data-options="fit:true,borer:false">
                        <div data-options="region:'north',border:false">
                            <table>
                                <tr>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <span class="bigFont">工号</span><input id="hidCheckRecNo" type="hidden" />
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckCode" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                                <td colspan="2">
                                                    <input type="text" id="txbCheckName" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Span1" class="bigFont">工序</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckSerialID" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckSerialName" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckSerialToday" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Span2" class="bigFont">条码</span>
                                                </td>
                                                <td colspan="2">
                                                    <input type="text" id="txbCheckBarcodeScan" onkeydown="doCheckScan()" class="txbInput"
                                                        style="width: 170px;" />
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckBarcode" class="txbInputDisabled" style="width: 90px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <span id="Span3" class="bigFont">客户</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckCustomer" class="txbInputDisabled" />
                                                </td>
                                                <td>
                                                    <span id="Span7" class="bigFont">订单号</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckOrderNo" class="txbInputDisabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Span4" class="bigFont">款号</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckStyleNo" class="txbInputDisabled" />
                                                </td>
                                                <td>
                                                    <span id="Span6" class="bigFont">尺码</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckSizeName" class="txbInputDisabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Span5" class="bigFont">颜色</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckColor" class="txbInputDisabled" />
                                                </td>
                                                <td>
                                                    <span id="Span8" class="bigFont">生产单号</span>
                                                </td>
                                                <td>
                                                    <input type="text" id="txbCheckProOrderNo" class="txbInputDisabled" style="width: 150px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <a class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="$('#divCheck').window('close')">
                                            退出</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input type="text" id="txbCheckMessage" class="txbInputDisabled" style="color: Red;
                                            width: 750px;" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div data-options="region:'center',border:false">
                            <table id="tableCheck">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div data-options="region:'west',split:true,collapsible:true,title:'人员'" style="width: 250px;">
                <table id="tablePerson">
                </table>
            </div>
            <div data-options="region:'center'">
                <div class="easyui-tabs" data-options="fit:true,border:false">
                    <div title="工序生产明细">
                        <table id="tableSerial">
                        </table>
                    </div>
                    <div title="换片/补料">
                        <table id="tableChange">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
