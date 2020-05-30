<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>订单发货明细</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <%--<script src="/Base/JS/easyui/datagrid-detailview.js" type="text/javascript"></script>--%>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var userid = "";
        var originalColumns = [];
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

            }
        });
        $(function () {
            //获取当前人员客户
            var sqlobjCustomer = {
                TableName: "bscDataCustomer",
                Fields: "iRecNo,sCustShortName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "in",
                        Value: "(select iBscDataCustomerRecNo from sysRightCustomer where sUserID='" + userid + "')"
                    }
                ]
            }
            var customerData = SqlGetData(sqlobjCustomer);
            //绑定客户下拉
            $("#iBscDataCustomerRecNo").combobox({
                valueField: "iRecNo",
                textField: "sCustShortName",
                data: customerData
            });
            //获取尺码组
            var sqlobjSizeGroup = {
                TableName: "BscDataSizeM",
                Fields: "sGroupID,sGroupName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(dStopDate,'2199-12-31')",
                        ComOprt: ">",
                        Value: "getdate()"
                    }
                ]
            }
            var sizeGroupData = SqlGetData(sqlobjSizeGroup);
            $("#sSizeGroupID").combobox({
                valueField: "sGroupID",
                textField: "sGroupName",
                data: sizeGroupData,
                onSelect: function (record) {
                    //$.messager.progress({ title: "正在获取数据，请稍候..." });
                    var sqlObj = {
                        TableName: "bscDataSizeD",
                        Fields: "sSizeName",
                        SelectAll: "True",
                        Filters: [{
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "(select iRecNo from bscDataSizeM where sGroupID='" + record.sGroupID + "')"
                        }]
                    }
                    var sizeColumn = SqlGetData(sqlObj);
                    var newColumns = DeepCopy(originalColumns);
                    for (var i = 0; i < sizeColumn.length; i++) {
                        newColumns[0].push({
                            title: sizeColumn[i].sSizeName,
                            colspan: 4
                        });
                        newColumns[1].push({
                            title: "订单数",
                            field: sizeColumn[i].sSizeName + "_Qty"
                        });
                        newColumns[1].push({
                            title: "入库数",
                            field: sizeColumn[i].sSizeName + "_StockInQty"
                        });
                        newColumns[1].push({
                            title: "发货数",
                            field: sizeColumn[i].sSizeName + "_StockSendQty"
                        });
                        newColumns[1].push({
                            title: "未发数",
                            field: sizeColumn[i].sSizeName + "_NotSendQty"
                        });
                    }
                    var datagridOption = $("#dg").datagrid("options");
                    datagridOption.columns = newColumns;
                    $("#dg").datagrid({ columns: newColumns });
                    //$("#dg").datagrid(datagridOption);
                    BtnSearch();
                }
            });

            originalColumns = [
                    [
                        {
                            title: "订单信息", colspan: 8
                        },
                        {
                            title: "数量", colspan: 4
                        }
                    ],
                    [
                        { title: "订单号", field: "sOrderNo", sortable: true, width: 80 },
                        { title: "客户", field: "sCustShortName", sortable: true, width: 80 },
                        { title: "款号", field: "sStyleNo", sortable: true, width: 80 },
                        { title: "下单日期", field: "dDate", sortable: true, width: 100 },
                        { title: "订单交期", field: "dOrderDate", sortable: true, width: 100 },
                        { title: "生产交期", field: "dProduceDate", sortable: true, width: 100 },
                        { title: "颜色", field: "sColorName", sortable: true, width: 100 },
                        { title: "单价", field: "fPrice", sortable: true, width: 60 },
                        { title: "订单数", field: "iSumQty", sortable: true, width: 60 },
                        { title: "入库数", field: "iStockInQty", sortable: true, width: 60 },
                        { title: "发货数", field: "iSendQty", sortable: true, width: 60 },
                        { title: "未发数", field: "iNotSendQty", sortable: true, width: 60 }
                    ]
                ];
            //表格
            $("#dg").datagrid({
                fit: true,
                border: false,
                remoteSort: false,
                rownumbers: true,
                //                pageNumber:1,
                //                pagination:true,
                //                pageSize: 30,
                //                pageList: [30, 50, 100, 200],
                columns: originalColumns,
                singleSelect: true
            })
        })

        $.extend($.fn.form.methods, {
            getData: function (jq, params) {
                var formArray = jq.serializeArray();
                var oRet = {};
                for (var i in formArray) {
                    if (typeof (oRet[formArray[i].name]) == 'undefined') {
                        if (params) {
                            oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                        }
                        else {
                            oRet[formArray[i].name] = formArray[i].value;
                        }
                    }
                    else {
                        if (params) {
                            oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                        }
                        else {
                            oRet[formArray[i].name] += "," + formArray[i].value;
                        }
                    }
                }
                return oRet;
            }
        });

        function BtnSearch() {
            var formData = $("#form1").form("getData", true);
            //            var filters = "1=1";
            //            if (formData.iBscDataCustomerRecNo) {
            //                filters += " and iBscDataCustomerRecNo='" + formData.iBscDataCustomerRecNo + "'";
            //            }
            //            if (formData.sOrderNo) {
            //                filters += " and sOrderNo like '%" + formData.sOrderNo + "%'";
            //            }
            //            if (formData.sStyleNo) {
            //                filters += " and sStyleNo like '%" + formData.sStyleNo + "%'";
            //            }
            //            if (formData.sSizeGroupID) {
            //                filters += " and ";
            //            }
            var ibscDataCustomer = formData.iBscDataCustomerRecNo == undefined || formData.iBscDataCustomerRecNo == null ? 0 : formData.iBscDataCustomerRecNo;
            var sOrderNo = formData.sOrderNo == undefined || formData.sOrderNo == null ? "" : formData.sOrderNo;
            var sStyleNo = formData.sStyleNo == undefined || formData.sStyleNo == null ? "" : formData.sStyleNo;
            var sSizeGroupID = formData.sSizeGroupID == undefined || formData.sSizeGroupID == null ? "" : formData.sSizeGroupID;
            var jsonobj = {
                StoreProName: "SpOrderSendDetail",
                StoreParms: [{
                    ParmName: "@ibscDataCustomerRecNo",
                    Value: ibscDataCustomer
                },
                {
                    ParmName: "@sOrderNo",
                    Value: sOrderNo
                },
                {
                    ParmName: "@sStyleNo",
                    Value: sStyleNo
                },
                {
                    ParmName: "@sSizeGroupID",
                    Value: sSizeGroupID
                }
                ]
            }
            var result = SqlStoreProce(jsonobj, true);
            if (result.length > 0) {
                $("#dg").datagrid("loadData", { rows: result, total: result.length });
            }
            //$.messager.progress("close");
        }

        function DeepCopy(obj) {
            var out = [], i = 0, len = obj.length;
            for (; i < len; i++) {
                if (obj[i] instanceof Array) {
                    out[i] = DeepCopy(obj[i]);
                }
                else out[i] = obj[i];
            }
            return out;
        }
    </script>
    <style type="text/css">
        .datagridRowStyle
        {
            height: 30px;
            font-size: 14px;
            font-family: Verdana;
            background-color: Red;
        }
        .datagrid-row
        {
            height: 32px;
            font-family: Verdana;
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <div data-options="region:'north',split:false,border:false" style="padding-left: 5px;
        padding-top: 3px; height: 70px" id="divNorth">
        <div style="vertical-align: middle">
            <img alt="" src="/Base/JS/easyui/themes/icons/search.png" />查询条件
            <hr />
        </div>
        <div style="float: left;">
            <form id="form1" method="post">
            <table id="tabConditions" style="margin-left: 35px;">
                <tr>
                    <td>
                        客户
                    </td>
                    <td>
                        <input id="iBscDataCustomerRecNo" type="text" name="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        订单号
                    </td>
                    <td>
                        <input id="sOrderNo" type="text" name="sOrderNo" class="easyui-textbox" />
                    </td>
                    <td>
                        款号
                    </td>
                    <td>
                        <input id="sStyleNo" type="text" name="sStyleNo" class="easyui-textbox" />
                    </td>
                    <td>
                        尺码组
                    </td>
                    <td>
                        <input id="sSizeGroupID" type="text" name="sSizeGroupID" />
                    </td>
                </tr>
            </table>
            </form>
        </div>
        <div>
            <a href="javascript:void(0)" onclick="BtnSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">
                查询</a>
        </div>
    </div>
    <div data-options="region:'center',border:true" style="padding: 3px;">
        <table id="dg">
        </table>
    </div>
</body>
</html>
