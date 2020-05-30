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
        $(function () {
            Page.Children.toolBarBtnDisabled("SDOrderD", "add");
            Page.Children.toolBarBtnDisabled("SDOrderD", "delete");
            Page.Children.toolBarBtnDisabled("SDOrderD", "copy");

            //加按钮
            var options = $("#SDOrderD").datagrid("options");   //新增一个深加工用料按钮
            options.columns[0].splice(6, 0,
                {
                    title: "成品库存",
                    field: "dddd",
                    formatter: function (value, row, index) {
                        if (row.iRecNo)
                            return "<a href='javascript:void(0)' onclick='openwin1(" + index + ")'>成品库存</a>";
                    },
                    width: 70,
                    align: "center"
                }
                );
            delete options.url;
            $("#SDOrderD").datagrid(options);   //新增一个纱线用量
        });

        Page.Children.onLoadSuccess = function () {
            var allRows = $("#SDOrderD").datagrid("getRows");
            for (var i = 1; i < allRows.length; i++) {
                $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabOrderStockQty: null, fFabCommStockQty: null} });
            }
            calcStockQty();
        }

        Page.beforeLoad = function () {
            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj1 = { TableName: "SDOrderD",
                    Fields: "SUM(fWeight) as fWeight",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iMainRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                    ]

                }
                var data1 = SqlGetData(sqlobj1);
                Page.setFieldValue('fWeight', data1[0].fWeight);

                var sqlobj2 = { TableName: "vwSDOrderM_GMJ",
                    Fields: "sName,sBscDataFabCode,fProductWidth,fProductWeight,sCustShortName",
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

                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);
                Page.setFieldValue('fProductWidth', data2[0].fProductWidth);
                Page.setFieldValue('fProductWeight', data2[0].fProductWeight);
                Page.setFieldValue('sCustShortName', data2[0].sCustShortName);
            }
        }

        //        Page.Children.onClickCell = function (tableid, index, field, value) {
        //            if (tableid == "SDOrderD" && field == "fFabStockQty") {
        //                var rows = $("#SDOrderD").datagrid("getRows");
        //                $.messager.show({
        //                    title: '纱线批号',
        //                    msg: rows[index].sFabBatchNo,
        //                    timeout: 1000,
        //                    showType: 'show',
        //                    style: {
        //                        right: '',
        //                        top: document.body.scrollTop + document.documentElement.scrollTop,
        //                        bottom: ''
        //                    }
        //                });
        //            }
        //        }
        Page.beforeSave = function () {
            /*var sqlObjExists = {
                TableName: "SDOrderM",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(iBscDataManufacturerRecNo,0)",
                        ComOprt: "<>",
                        Value: "0",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.key + "'"
                    }
                ]
            }
            var resultEx = SqlGetData(sqlObjExists);
            if (resultEx.length > 0) {
                if (selectedRow.dProDate) {
                    alert('订单已生产，不可修改！');
                    return false;
                }
            }
            else {
                var sqlObj = {
                    TableName: "ProPlanM",
                    Fields: "1",
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
                            Value: "'3'"
                        }
                    ]
                }
                var resultCard = SqlGetData(sqlObj);
                if (resultCard.length > 0) {
                    alert("订单已染色，不可修改！");
                    return false;
                }
            }*/
        }

        Page.afterSave = function () {

        }

        function openwin1(index) {
            var theRow = $("#SDOrderD").datagrid("getRows")[index];
            var iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
            var iBscDataColoRecNo = theRow.iBscDataColorRecNo;
            var filters = "iBscDataMatRecNo='" + iBscDataMatRecNo + "' and iBscDataColorRecNo='" + iBscDataColoRecNo + "'";

            var src = "/Base/FormList.aspx?MenuID=351&FormID=82012&filters=" + filters + "&isAss=1";
            window.open(src, "newwindow", "height=600,width=1100,top=0,left=0,toolbar=no,menubar=no,resizable=yes,scrollbars=no");
            //$("#ifrStockProduct").attr("src", src);
            //$("#divStockProduct").dialog("open");
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (changes.fUseFalg != null && changes.fUseFalg != undefined) {
                calcStockQty();
            }
        }

        function calcStockQty() {
            var allRows = $("#SDOrderD").datagrid("getRows");
            for (var i = 1; i < allRows.length; i++) {
                var fLastFabOrderStockQty = isNaN(parseFloat(allRows[i - 1].fFabOrderStockQty)) ? 0 : parseFloat(allRows[i - 1].fFabOrderStockQty);
                var fUseFalg = isNaN(parseFloat(allRows[i - 1].fUseFalg)) ? 0 : parseFloat(allRows[i - 1].fUseFalg);
                var fLastFabCommStockQty = isNaN(parseFloat(allRows[i - 1].fFabCommStockQty)) ? 0 : parseFloat(allRows[i - 1].fFabCommStockQty);
                if (fLastFabOrderStockQty > 0) {
                    if (fLastFabOrderStockQty > fUseFalg) {
                        var fFabOrderStockQty = fLastFabOrderStockQty - fUseFalg;
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabOrderStockQty: fFabOrderStockQty} });
                    }
                    if (fLastFabOrderStockQty == fUseFalg) {
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabOrderStockQty: 0} });
                    }
                    if (fLastFabOrderStockQty < fUseFalg) {
                        var fLastFabCommStockQty = isNaN(parseFloat(allRows[i - 1].fFabCommStockQty)) ? 0 : parseFloat(allRows[i - 1].fFabCommStockQty);
                        fFabCommStockQty = fLastFabOrderStockQty - fUseFalg + fLastFabCommStockQty;
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabOrderStockQty: 0, fFabCommStockQty: fFabCommStockQty} });
                    }
                }
                if (fLastFabOrderStockQty == 0) {
                    if (fLastFabCommStockQty > fUseFalg) {
                        var fFabCommStockQty = fLastFabCommStockQty - fUseFalg;
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabCommStockQty: fFabCommStockQty} });
                    }
                    if (fLastFabCommStockQty == fUseFalg) {
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabCommStockQty: 0} });
                    }
                    if (fLastFabCommStockQty < fUseFalg) {
                        $("#SDOrderD").datagrid("updateRow", { index: i, row: { fFabCommStockQty: 0} });
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_disabled="true" />
                    </td>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iBscDataMatRecNo" Z_readOnly="True" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        幅宽（cm）
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fProductWidth" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        克重（g/㎡）
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWeight" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCustShortName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        总产品重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fWeight" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        总投坯重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fFabQty" Z_readOnly="True" />
                    </td>
                    <td>
                        实际投坯匹数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iFabQty" style="width:60px;" Z_FieldType="整数" />
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
            </div>
        </div>
    </div>
    <%--<div id="divStockProduct" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: false, cache: false,
     maximizable: true,resizable: true,width:900,height:600">
        <iframe style='margin: 0; padding: 0' id='ifrStockProduct' name='ifrStockProduct' width='100%'
            height='99.5%' frameborder='0'></iframe>
    </div>--%>
</asp:Content>
