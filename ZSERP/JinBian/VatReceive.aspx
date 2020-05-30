<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        function GetUrlParam(paraName) {
            var url = document.location.toString();
            var arrObj = url.split("?");

            if (arrObj.length > 1) {
                var arrPara = arrObj[1].split("&");
                var arr;

                for (var i = 0; i < arrPara.length; i++) {
                    arr = arrPara[i].split("=");

                    if (arr != null && arr[0] == paraName) {
                        return arr[1];
                    }
                }
                return "";
            }
            else {
                return "";
            }
        }

        function showAskDetail(i) {
            var allRows = $("#tbGridNotFinish").datagrid("getRows");
            if (allRows.length > 0) { 
                $("#txaDetailSpecAsk").val(allRows[i].sSpecAsk);
                $("#txaDetailCoilingAsk").val(allRows[i].sCoilingAsk);
                $("#txaDetailCheckStand").val(allRows[i].sCheckStand);
                $("#txaDetailSampleCloth").val(allRows[i].sSampleCloth);
                $("#txaDetailStackAsk").val(allRows[i].sStackAsk);
                $("#txaDetailShippingMark").val(allRows[i].sShippingMark);
            }
            
            $('#divAskDetail').window('open'); 
        }

        $(function () {
            Page.toolBarBtnAdd("mExit", " 取消 ", "remove", function () {
                top.closeTab();
            })

            //Page.DoNotCloseWinWhenSave = true;
            $("#tbGridNotFinish").datagrid(
                {
                    fit: true,
                    border: false,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 50,
                    pageList: [50, 100, 500, 1000],
                    remoteSort: false,
                    loadFilter: pagerFilter,
                    columns: [
                        [
                        { title: "订单号", field: "sOrderNo", width: 110, align: "center" },
                        {
                            title: "接收", field: "__aa", formatter: function (value, row, index) {
                                return "<input type='button' onclick='doReceive(" + index + ")' value='接收' />";
                            }, width: 60, algin: "center"
                        },
                        {
                            title: "全部要求", field: "__ab", formatter: function (value, row, index) {
                                return "<input type='button' onclick='showAskDetail(" + index + ")' value='全部要求' />";
                            }, width: 80, algin: "center"
                        },
                        { title: "客户简称", field: "sCustShortName", width: 80, align: "center" },
                        { title: "签订日期", field: "dDate1", width: 80, align: "center", hidden: true },
                        { title: "客户订单号", field: "sContractNo", width: 110, align: "center" },
                        { title: "成品名称", field: "sName", width: 80, align: "center" },
                        { title: "卷号生成规则", field: "sReelNoBuildName", width: 80, align: "center", hidden: true },
                        { title: "前缀", field: "sReelNoPre", width: 60, align: "center", hidden: true },
                        { title: "流水规则", field: "sReelNoFlag", width: 60, align: "center", hidden: true },
                        { title: "序列号", field: "sSerial", width: 80, align: "center" },
                        { title: "客户色号", field: "sCustColorID", width: 110, align: "center" },
                        { title: "色号", field: "sColorID", width: 80, align: "center" },
                        { title: "颜色", field: "sColorName", width: 80, align: "center" },
                        { title: "幅宽", field: "fProductWidth", width: 60, align: "center" },
                        { title: "克重", field: "fProductWeight", width: 60, align: "center" },
                        { title: "米长", field: "fSumQty", width: 60, align: "center" },
                        { title: "已接收米数", field: "fReceiveQty", width: 80, align: "center" },
                        { title: "已接收缸数", field: "iVatReceiveCount", width: 80, align: "center" },
                        { title: "已接收缸号", field: "sReceiveVatNo", width: 300, align: "center" },
                        { field: "iRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true },
                        { field: "sSpecAsk", hidden: true },
                        { field: "sCoilingAsk", hidden: true },
                        { field: "sCheckStand", hidden: true },
                        { field: "sSampleCloth", hidden: true },
                        { field: "sStackAsk", hidden: true },
                        { field: "sShippingMark", hidden: true } 
                        ]
                    ],
                    singleSelect: true,
                    toolbar: "#divMenu" /*[
                        {
                            iconCls: "icon-search",
                            text: "查询",
                            handler: function () {
                                search(0);
                            }
                        },
                        {
                            iconCls: "icon-ok",
                            text: "接收完成",
                            handler: function () {
                                flagFinish(1);
                            }
                        }
                    ]*/
                }
            );

            $("#tbGridFinish").datagrid(
                {
                    fit: true,
                    border: false,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 50,
                    pageList: [50, 100, 500, 1000],
                    remoteSort: false,
                    loadFilter: pagerFilter,
                    columns: [
                        [
                        { title: "订单号", field: "sOrderNo", width: 80, align: "center" },
                        { title: "客户简称", field: "sCustShortName", width: 80, align: "center" },
                        { title: "签订日期", field: "dDate1", width: 80, align: "center" },
                        { title: "成品编号", field: "sCode", width: 80, align: "center" },
                        { title: "成品名称", field: "sName", width: 80, align: "center" },
                        { title: "卷号生成规则", field: "sReelNoBuildName", width: 80, align: "center" },
                        { title: "前缀", field: "sReelNoPre", width: 60, align: "center" },
                        { title: "流水规则", field: "sReelNoFlag", width: 60, align: "center" },
                        { title: "序列号", field: "sSerial", width: 80, align: "center" },
                        { title: "色号", field: "sColorID", width: 80, align: "center" },
                        { title: "颜色", field: "sColorName", width: 80, align: "center" },
                        { title: "幅宽", field: "fProductWidth", width: 60, align: "center" },
                        { title: "克重", field: "fProductWeight", width: 60, align: "center" },
                        { title: "米长", field: "fQty", width: 60, align: "center" },
                        { title: "已接收米数", field: "fReceiveQty", width: 80, align: "center" },
                        { title: "已接收缸数", field: "iVatReceiveCount", width: 80, align: "center" },
                        { title: "已接收缸号", field: "sReceiveVatNo", width: 300, align: "center" },
                        { field: "iRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true }
                        ]
                    ],
                    singleSelect: true,
                    toolbar: "#divMenu2"
                }
            );

            if (Page.usetype != "add") {
                $("#divTab").tabs("select", 1);
                var sqlObj = {
                    TableName: "vwSDOrderMD",
                    Fields: "sCustColorID,sOrderNo,sCustShortName,dDate1,sCode,sName,sReelNoBuildName,sReelNoPre,sReelNoFlag,sColorID,sColorName,fProductWidth,fProductWeight,fSumQty,iRecNo,iSDOrderMRecNo,sContractNo,sSerial",
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
                    $("#form1").form("load", result[0]);
                }

            }
            else {
                Page.usetype = "modify";
            }
            Page.DoNotCloseWinWhenSave = true;
            $("#__saveAndContinue").hide();
            $("#__cancel").hide();
            //            Page.Children.toolBarBtnAdd("table1", "print", "打印", "print", function () {

            //            });
        })

        //type=0表示未完成，1表示完成
        function doSearch(type) {
            var filters = [
                {
                    Field: "isnull(iVatReceiveFinish,0)",
                    ComOprt: "=",
                    Value: type,
                    LinkOprt:"and"
                },
                {
                    Field: "isnull(iNeedCheck,0)",
                    ComOprt: "=",
                    Value: "1"
            }
        ];
        if (type == 0) {
            var sCustName = $("#Text1").textbox("getValue");
            var sOrderNo = $("#Text2").textbox("getValue");
            var sCustOrder = $("#Text3").textbox("getValue");
            if (sCustName != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        //LeftParenthese: "(",
                        Field: "sCustShortName",
                        ComOprt: "like",
                        Value: "'%" + sCustName + "%'"/*,
                            LinkOprt: "or"*/
                    }
                );
                /*filters.push(
                    {
                        Field: "sCustName",
                        ComOprt: "like",
                        Value: "'%" + sCustName + "%'",
                        RightParenthese: ")"
                    }
                );*/
            }
            if (sOrderNo) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        Field: "sOrderNo",
                        ComOprt: "like",
                        Value: "'%" + sOrderNo + "%'"
                    }
                );
            }
            if (sCustOrder) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        Field: "sContractNo",
                        ComOprt: "like",
                        Value: "'%" + sCustOrder + "%'"
                    }
                );
            }

            var sqlObj2 = {
                TableName: "vwSDOrderM_GMJ",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCustShortName",
                        ComOprt: "like",
                        Value: "'%" + sCustName + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sOrderNo",
                        ComOprt: "like",
                        Value: "'%" + sOrderNo + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sContractNo",
                        ComOprt: "like",
                        Value: "'%" + sCustOrder + "%'" 
                    }]
            };
            var result2 = SqlGetData(sqlObj2);
            if (result2.length == 0) {
                if (GetUrlParam("param") == "1") {
                    alert("投坯计划未提交");
                    return false;
                } else {
                    alert("订单尚未生成");
                    return false;
                }
            } else {
                var sqlObj3 = {
                    TableName: "vwSDOrderMD",
                    Fields: "1",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sCustShortName",
                            ComOprt: "like",
                            Value: "'%" + sCustName + "%'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "sOrderNo",
                            ComOprt: "like",
                            Value: "'%" + sOrderNo + "%'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "sContractNo",
                            ComOprt: "like",
                            Value: "'%" + sCustOrder + "%'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "isnull(iNeedCheck,0)",
                            ComOprt: "=",
                            Value: "1"
                        }]
                };
                var result3 = SqlGetData(sqlObj3);
                if (result3.length == 0) {
                    alert("缺少验布工序");
                    return false;
                }
            }
            
        }


        if (type == 1) {
            var sCustName = $("#Text11").textbox("getValue");
            var sOrderNo = $("#Text22").textbox("getValue");
            var sCustOrder = $("#Text33").textbox("getValue");
            if (sCustName != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        //LeftParenthese: "(",
                        Field: "sCustShortName",
                        ComOprt: "like",
                        Value: "'%" + sCustName + "%'"/*,
                            LinkOprt: "or"*/
                    }
                );
                /*filters.push(
                    {
                        Field: "sCustName",
                        ComOprt: "like",
                        Value: "'%" + sCustName + "%'",
                        RightParenthese: ")"
                    }
                );*/
            }
            if (sOrderNo) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        Field: "sOrderNo",
                        ComOprt: "like",
                        Value: "'%" + sOrderNo + "%'"
                    }
                );
            }
            if (sCustOrder) {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push(
                    {
                        Field: "sContractNo",
                        ComOprt: "like",
                        Value: "'%" + sCustOrder + "%'"
                    }
                );
            }
        }
        
        
        
        var sqlObj = {
            TableName: "vwSDOrderMD",
            Fields: "sCustColorID,sOrderNo,sCustShortName,dDate1,sCode,sName,sReelNoBuildName,sReelNoPre,sReelNoFlag,sColorID,sColorName,fProductWidth,fProductWeight,fSumQty,iRecNo,iSDOrderMRecNo,iVatReceiveCount,sReceiveVatNo,sContractNo,fReceiveQty,sSerial,sSpecAsk,sCoilingAsk,sCheckStand,sSampleCloth,sStackAsk,sShippingMark",
            SelectAll: "True",
            Filters: filters,
            Sorts: [
                {
                    SortName: "sOrderNo",
                    SortOrder: "desc"
                },
                {
                    SortName: "dDate1",
                    SortOrder: "desc"
                },
                {
                    SortName: "dInputDate",
                    SortOrder: "desc"
                }
            ]
        };
        var result = SqlGetData(sqlObj);
        if (type == 0) {
            $("#tbGridNotFinish").datagrid("loadData", result);
        } else {
            $("#tbGridFinish").datagrid("loadData", result);
        }
        }
        var notFinishLoad = false;
        function tabSelect(title, index) {
            if (index == 2) {
                if (notFinishLoad == false) {
                    doSearch(1);
                    notFinishLoad = true;
                }
            }
        }
        function flagFinish(type) {
            var iRecNo = 0;
            var message = "";
            if (type == 0) {
                var selectedRow = $("#tbGridFinish").datagrid("getSelected");
                if (selectedRow) {
                    iRecNo = selectedRow.iRecNo;
                    message = "确认标记选择行为未完成吗？";
                }
            }
            else {
                var selectedRow = $("#tbGridNotFinish").datagrid("getSelected");
                if (selectedRow) {
                    iRecNo = selectedRow.iRecNo;
                    message = "确认标记选择行为完成吗？";
                }
            }
            if (iRecNo != 0) {

                $.messager.confirm("确定吗？", message, function (r) {
                    if (r) {
                        var jsonobj = {
                            StoreProName: "SpSDOrderDVatReceiveFinish",
                            StoreParms: [
                            {
                                ParmName: "@iRecNo",
                                Value: iRecNo
                            },
                            {
                                ParmName: "@iType",
                                Value: type
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                        else {
                            if (type == 0) {
                                doSearch(1);
                            }
                            else {
                                doSearch(0);
                            }
                        }
                    }
                })

            }
        }
        function pagerFilter(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    dg.datagrid('loadData', data);
                }
            });
            if (!data.originalRows) {
                data.originalRows = (data.rows);
            }
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }
        function doReceive(index) {
            var allRows = $("#tbGridNotFinish").datagrid("getRows");
            if (allRows.length > 0) {
                $("#form1").form("load", allRows[index]);
                Page.setFieldValue("sReelNoBulidName", allRows[index].sReelNoBulidName);
                Page.key = allRows[index].iRecNo;
                var sqlObj = {
                    TableName: "SDOrderDD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "'" + Page.key + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                $("#table1").datagrid("loadData", result);

                $("#divTab").tabs("select", 1);
            }
        }
        Page.beforeSave = function () {
            var str = ",";
            var allRows = $("#table1").datagrid("getRows");
            for (var i = 0; i < allRows.length; i++) {
                if (str.indexOf("," + allRows[i].sVatNo + ",") > -1) {
                    alert("检测到有重复缸号！");
                    return false;
                }
                str += allRows[i].sVatNo + ',';
            }
        }
        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpSDOrderDDBulidBarcode",
                StoreParms: [{
                    ParmName: "@iMainRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result);
            }
            else {

            }
        }
        function printShow() {
            var selectRow = $("#tbGridNotFinish").datagrid("getSelected");
            if (selectRow) {
                var iRecNo = selectRow.iRecNo;
                var url = "/Base/PbPage.aspx?otype=show&iformid=20022&irecno=107&key=" + iRecNo + "&r=" + Math.random();
                $("#ifrpb").attr("src", "");
                $("#ifrpb").attr("src", url);
            }
            else {
                Page.MessageShow("请选择", "请选择一行");
            }
        }
        function printOrderShow() {
            var selectRow = $("#tbGridNotFinish").datagrid("getSelected");
            if (selectRow) {
                var iRecNo = selectRow.iRecNo;
                var url = "/Base/PbPage.aspx?otype=show&iformid=20022&irecno=124&key=" + iRecNo + "&r=" + Math.random();
                $("#ifrpb").attr("src", "");
                $("#ifrpb").attr("src", url);
            }
            else {
                Page.MessageShow("请选择", "请选择一行");
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false,onSelect:tabSelect">
            <div title="未接收完成缸号订单明细">
                <table id="tbGridNotFinish">
                </table>
            </div>
            <div title="接收明细">
                <div id="div1" class="easyui-layout" data-options="fit:true,border:false">
                    <div data-options="region:'west',border:false" style="width: 950px;">
                        <div class="easyui-layout" data-options="fit:true,border:false">
                            <div data-options="region:'north',border:false" style="overflow: hidden;">
                                <!—如果只有一个主表，这里的north要变为center-->
                                <div id="divHiden" style="display: none;">
                                    <!--隐藏字段位置-->
                                </div>
                                <!--主表部分-->
                                <table class="tabmain">
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>订单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>客户
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sCustShortName" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>产品编号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sCode" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>产品名称
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sName" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>色号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sColorID" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>颜色
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sColorName" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>幅宽
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fProductWidth" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>克重
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fProductWeight" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>序列号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sSerial" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>卷号生成规格
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReelNoBuildName" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>前缀
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sReelNoPre" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>卷号规则
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReelNoFlag" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>米长
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fSumQty" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>客户订单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sContractNo" Z_readOnly="true"
                                                Z_NoSave="true" />
                                        </td>

                                    </tr>
                                </table>
                            </div>
                            <div data-options="region:'center',border:false ">
                                <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                                <div class="easyui-tabs" data-options="fit:true,border:false">
                                    <div data-options="fit:true" title="缸号明细">
                                        <!--  子表1  -->
                                        <table id="table1" tablename="SDOrderDD">
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-options="region:'center',border:false">
                        <table>
                            <tr>
                                <td>
                                    <cc1:ExtImage runat="server"></cc1:ExtImage>
                                </td>
                            </tr>
                        </table>
                    </div>

                </div>
            </div>
            <div title="接收完成缸号订单明细">
                <table id="tbGridFinish">
                </table>
            </div>
        </div>
    </div>
    <div id="divAskDetail" class="easyui-window" title="全部要求" style="width: 80%; height: 80%"
        data-options="modal:true,collapsible:false,minimizable:false,closable:true,maximizable:false,closed:true">
        <div>
            <div id="ttAskDetail" class="easyui-tabs" data-options="tabWidth:90,tabHeight:80,onSelect:function(title,index){if(title=='关闭') { $('#ttAskDetail').tabs('select', '特别要求' ); $('#divAskDetail').window('close');}}" style="width: 100%;">
                <div title="特别要求" style="padding: 20px; height: 98%">
                    <textarea id="txaDetailSpecAsk" name="sDetailSpecAsk" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="打卷要求" style="overflow: auto; padding: 20px;">
                    <textarea id="txaDetailCoilingAsk" name="sDetailCoilingAsk" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="验货标准" style="overflow: auto; padding: 20px;">
                    <textarea id="txaDetailCheckStand" name="sDetailCheckStand" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="样布" style="overflow: auto; padding: 20px;">
                    <textarea id="txaDetailSampleCloth" name="sDetailSampleCloth" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="堆放要求" style="overflow: auto; padding: 20px;">
                    <textarea id="txaDetailStackAsk" name="sDetailStackAsk" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="唛头" style="overflow: auto; padding: 20px;">
                    <textarea id="txaDetailShippingMark" name="sDetailShippingMark" style="width: 98%; height: 390px; background-color: #fff; font-size: 24px; font-weight: bold; color: Red;"
                        readonly="readonly"></textarea>
                </div>
                <div title="关闭" style="overflow: auto; padding: 20px;">
                </div>
            </div>
        </div>
    </div>
    <div id="divMenu">
        <table>
            <tr>
                <td>客户
                </td>
                <td>
                    <input id="Text1" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>订单号
                </td>
                <td>
                    <input id="Text2" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>客户订单号
                </td>
                <td>
                    <input id="Text3" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true"
                        onclick="doSearch(0)">查询</a>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true"
                        onclick="flagFinish(1)">接收完成</a>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true"
                        onclick="printShow()">打印</a>
                    <div style="display: none;">
                        <iframe id="ifrpb"></iframe>
                    </div>
                </td>
                <td>
                    <%--<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print',plain:true"
                        onclick="printOrderShow()">打印整个订单</a>--%>
                </td>
            </tr>
        </table>
    </div>
    <div id="divMenu2">
        <table>
            <tr>
                <td>客户
                </td>
                <td>
                    <input id="Text11" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>订单号
                </td>
                <td>
                    <input id="Text22" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>客户订单号
                </td>
                <td>
                    <input id="Text33" class="easyui-textbox" type="text" style="width: 120px;" />
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true"
                        onclick="doSearch(1)">查询</a>
                </td>
                <td>
                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true"
                        onclick="flagFinish(0)">取消接收完成</a>
                </td> 
            </tr>
        </table>
    </div>
</asp:Content>
