<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>整经生产</title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui_new/themes/gray/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui_new/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui_new/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui_new/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui_new/jquery.easyui.min.js"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/lookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        $(function () {
            var sqlObj3 = {
                TableName: "bscDataMachine",
                Fields: "*",
                SelectAll: "True",
                Filters: [{
                    Field: "sClassID",
                    ComOprt: "like",
                    Value: "'01%'"
                }],
                Sorts: [
                    {
                        SortName: "sMachineCode",
                        SortOrder: "asc"
                    }
                ]
            };
            var data3 = SqlGetData(sqlObj3);
            $("#txbMachineBegin").combobox("loadData", data3);
            $("#txbMachineEnd").combobox("loadData", data3);
            var sqlObj3 = {
                TableName: "BscDataPanHead",
                Fields: "*",
                SelectAll: "True",
                Filters: [],
                Sorts: [{
                    SortName: "sCode",
                    SortOrder: "asc"
                }]
            };
            var data3 = SqlGetData(sqlObj3);
            $("#txbCzBegin").combobox("loadData", data3);
            $("#txbCzEnd").combobox("loadData", data3);

            var sqlObj4 = {
                TableName: "bscDataPerson",
                Fields: "sCode,sName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sJobRole",
                        ComOprt: "like",
                        Value: "'%整经工%'"
                    }
                ],
                Sorts: [
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var data4 = SqlGetData(sqlObj4);
            $("#txbPerson").combobox("loadData", data4);
            $("#Text2").combobox("loadData", data4);

            $("#txbPerson").combobox("textbox").css("font-size", "20px");
            $("#txbPerson").combobox("textbox").css("font-weight", "bold");

            $("#txbCzBegin").combobox("textbox").css("font-size", "20px");
            $("#txbCzBegin").combobox("textbox").css("font-weight", "bold");

            $("#txbCzEnd").combobox("textbox").css("font-size", "20px");
            $("#txbCzEnd").combobox("textbox").css("font-weight", "bold");

            $("#txbMachineBegin").combobox("textbox").css("font-size", "20px");
            $("#txbMachineBegin").combobox("textbox").css("font-weight", "bold");

            $("#txbMachineEnd").combobox("textbox").css("font-size", "20px");
            $("#txbMachineEnd").combobox("textbox").css("font-weight", "bold");

            $("#txbFinishQty").combobox("textbox").css("font-size", "20px");
            $("#txbFinishQty").combobox("textbox").css("font-weight", "bold");

            $("#txbPerson").combobox("textbox").css("font-size", "20px");
            $("#txbPerson").combobox("textbox").css("font-weight", "bold");
            showday();
        });
        var userid = "";
        $.ajax({
            url: "/ashx/LoginHandler.ashx",
            type: "post",
            async: false,
            cache: false,
            data: { otype: "getcurtuserid" },
            success: function (data) {
                userid = data;
            },
            error: function (data) {
            }
        });
        function BarcodeScan(from) {
            if (event.keyCode == 13) {
                var sBarCode = from == 0 ? document.getElementById("txbBarcodeBegin").value : document.getElementById("txbBarcodeEnd").value;
                //$("#Text10").val("");
                if (sBarCode) {

                } else {
                    event.preventDefault();
                    return false;
                }
                //如果是开始，则要判断是否有未结束的
                if (from == 0) {
                    var sqlObjCheck = {
                        TableName: "vwProYield",
                        Fields: "1",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iType",
                                ComOprt: "=",
                                Value: "0",
                                LinkOprt: "and"
                            }, {
                                Field: "sProWarpingMBillNo",
                                ComOprt: "=",
                                Value: "'" + sBarCode + "'",
                                LinkOprt: "and"
                            }, {
                                Field: "isnull(dEndTime,'2299-12-31')",
                                ComOprt: "=",
                                Value: "'2299-12-31'"
                            }
                        ]
                    }
                    var resultCheck = SqlGetData(sqlObjCheck);
                    if (resultCheck.length > 0) {
                        alert("检测到此整经单尚有未结束的任务，结束后才可再次开始！");
                        event.preventDefault();
                        $("#txbBarcodeBegin").val("");
                        return false;
                    }
                    var bl = false;
                    var sqlObj3 = {
                        TableName: "ProWarpingM",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            { Field: "sBillNo", ComOprt: "=", Value: "'" + sBarCode + "'", LinkOprt: "and" },
                            { Field: "iStatus", ComOprt: "=", Value: "4" }],
                        Sorts: []
                    };
                    var data3 = SqlGetData(sqlObj3);
                    if (data3.length > 0) {
                        $("#txbWarpingBillNoBegin").val(sBarCode);
                        $("#hd1").val(data3[0].iRecNo);
                    } else {
                        alert("整经单号[" + sBarCode + "]不存在");
                    }
                    $("#txbBarcodeBegin").val("");                    
                    event.preventDefault();
                } else {//判断有没有
                    var sqlObjCheck = {
                        TableName: "vwProYield",
                        Fields: "top 1 *",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iType",
                                ComOprt: "=",
                                Value: "0",
                                LinkOprt: "and"
                            }, {
                                Field: "sProWarpingMBillNo",
                                ComOprt: "=",
                                Value: "'" + sBarCode + "'",
                                LinkOprt: "and"
                            }, {
                                Field: "isnull(dEndTime,'2299-12-31')",
                                ComOprt: "=",
                                Value: "'2299-12-31'"
                            }
                        ]
                    }
                    var resultCheck = SqlGetData(sqlObjCheck);
                    if (resultCheck.length == 0) {
                        alert("抱歉，未找到任务，请确认是否已经开始");
                        event.preventDefault();
                        $("#txbBarcodeEnd").val("");
                        return false;
                    }
                    $("#txbCzEnd").combobox("setValue", resultCheck[0].iBscDataPanHeadRecNo);
                    $("#txbMachineEnd").combobox("setValue", resultCheck[0].ibscDataMachineRecNo);
                    $("#txbWarpingBillNoEnd").val(sBarCode);
                    $("#hd2").val(resultCheck[0].iRecNo);
                    $("#txbBarcodeEnd").val("");
                }
            }
        }

        function StartWarping() {
            if (!$("#hd1").val()) {
                alert("整经单号不能为空");
                return;
            }
            if (!$("#txbCzBegin").combobox("getValue")) {
                alert("衬子不能为空");
                return;
            }
            if (!$("#txbMachineBegin").combobox("getValue")) {
                alert("机台号不能为空");
                return;
            }
            if ($("#txbPerson").combobox("getValue") == undefined || $("#txbPerson").combobox("getValue") == null || $("#txbPerson").combobox("getValue") == "") {
                alert("操作工不能为空");
                return;
            }

            var jsonobj1 = {
                StoreProName: "spKaiShiZhengJin",
                StoreParms: [{
                    ParmName: "@iBillRecNo",
                    Value: $("#hd1").val()
                }, {
                    ParmName: "@iBscDataPanHeadRecNo",
                    Value: $("#txbCzBegin").combobox("getValue")
                }, {
                    ParmName: "@ibscDataMachineRecNo",
                    Value: $("#txbMachineBegin").combobox("getValue")
                }, {
                    ParmName: "@sPerson",
                    Value: $("#txbPerson").combobox("getValue")
                }]
            }
            var Result1 = SqlStoreProce(jsonobj1);
            if (Result1 != "1") {
                alert("提交时发生错误: " + Result1);
            } else {
                $("#hd1").val("");
                $("#txbWarpingBillNoBegin").val("");
                $("#txbPerson").combobox("setValue", "");
                $("#txbCzBegin").combobox("setValue", "");
                $("#txbMachineBegin").combobox("setValue", "");
                showday();
            }
        }

        function EndWarping() {
            if (!$("#hd2").val()) {
                alert("整经单号不能为空");
                return;
            }
            //if (!$("#txbCzEnd").combobox("getValue")) {
            //    alert("衬子不能为空");
            //    return;
            //}
            //if (!$("#txbMachineEnd").combobox("getValue")) {
            //    alert("机台号不能为空");
            //    return;
            //}
            if ($("#txbFinishQty").numberbox("getValue") == null) {
                alert("完成米数不能为空");
                return;
            }

            var jsonobj1 = {
                StoreProName: "spJieShuZhengJin",
                StoreParms: [{
                    ParmName: "@iProYieldRecNo",
                    Value: $("#hd2").val()
                }, {
                    ParmName: "@fQty",
                    Value: $("#txbFinishQty").numberbox("getValue")
                }]
            }
            var Result1 = SqlStoreProce(jsonobj1);
            if (Result1 != "1") {
                alert("提交时发生错误: " + Result1);
            } else {
                $("#hd2").val("");
                $("#txbWarpingBillNoEnd").val("");
                $("#txbCzEnd").combobox("setValue", "");
                $("#txbMachineEnd").combobox("setValue", "");
                $("#txbFinishQty").numberbox("setValue", 0);
                showday();
            }
        }

        function doSearch() {

            var dDate1 = $("#Date1").datebox("getValue") == "" ? "1990-01-01" : $("#Date1").datebox("getValue");
            var dDate2 = $("#Date2").datebox("getValue") == "" ? "2990-01-01" : $("#Date2").datebox("getValue");
            var sqlObj3 = {
                TableName: "vwProYield",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "convert(varchar(50),dBeginTime,23)", ComOprt: ">=", Value: "'" + dDate1 + "'", LinkOprt: "and" },
                    { Field: "convert(varchar(50),dBeginTime,23)", ComOprt: "<=", Value: "'" + dDate2 + "'", LinkOprt: "and" },
                    { Field: "sPersonName", ComOprt: "like", Value: "'%" + $("#Text2").val() + "%'" }
                ],
                Sorts: []
            };
            var data3 = SqlGetData(sqlObj3);
            $("#table1").datagrid("loadData", data3);
        }

        function showday() {
            var dDate1 = $("#Date1").val() == "" ? "1990-01-01" : $("#Date1").val();
            var dDate2 = $("#Date2").val() == "" ? "2990-01-01" : $("#Date2").val();
            var ndate = new Date();
            ndate = new Date(ndate.setDate(ndate.getDate()));

            // alert(ndate.getFullYear() + '-' + ((ndate.getMonth() + 1) + 100).toString().substring(1) + '-' + ((ndate.getDate() ) + 100).toString().substring(1))
            var syear = ndate.getFullYear();
            var smonth = ndate.getMonth() + 101;
            smonth = smonth.toString().substring(1);
            var sday = ndate.getDate() + 100;
            sday = sday.toString().substring(1)
            dDate1 = syear + '-' + smonth + '-' + sday;
            // alert(dDate1)
            var sqlObj3 = {
                TableName: "vwProYield",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "convert(varchar(50),dBeginTime,23)", ComOprt: "=", Value: "'" + dDate1 + "'" },
                    //{ Field: "convert(varchar(50),dBeginTime,23)", ComOprt: "<=", Value: "'" + dDate2 + "'", LinkOprt: "and" },
                    //{ Field: "sPersonName", ComOprt: "like", Value: "'%" + $("#Text2").val() + "%'" }
                ],
                Sorts: []
            };
            var data3 = SqlGetData(sqlObj3);
            $("#table1").datagrid("loadData", data3);
        }

        function columnStyle() {
            return "font-size:18px;"
        }
    </script>
    <style type="text/css">
        /** {
            font-size: 20px;
        }*/

        .combobox-item {
            font-size: 24px;
        }

        .table {
            margin: auto;
        }

            .table tr td {
                font-size: 24px;
                vertical-align: top;
                font-weight: bold;
                font-family: 'Microsoft YaHei';
            }

        .button {
            display: inline-block;
            outline: none;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            /*font: 14px/100% 'Microsoft yahei' ,Arial, Helvetica, sans-serif;*/
            font-size: 20px;
            padding: .5em 2em .50em;
            text-shadow: 0 1px 1px rgba(0,0,0,.3);
            -webkit-border-radius: .5em;
            -moz-border-radius: .5em;
            border-radius: .5em;
            -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            -moz-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            box-shadow: 0 1px 2px rgba(0,0,0,.2);
            font-weight: bold;
            width: 150px;
            height: 30px;
        }

            .button:hover {
                text-decoration: none;
            }

            .button:active {
                position: relative;
                top: 1px;
            }

        /* orange */
        .orange {
            /*color: #fef4e9;*/
            color: #ffffff;
            border: solid 1px #da7c0c;
            background: #f78d1d;
            background: -webkit-gradient(linear, left top, left bottom, from(#faa51a), to(#f47a20));
            background: -moz-linear-gradient(top, #faa51a, #f47a20);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#faa51a', endColorstr='#f47a20');
        }

            .orange:hover {
                background: #f47c20;
                background: -webkit-gradient(linear, left top, left bottom, from(#f88e11), to(#f06015));
                background: -moz-linear-gradient(top, #f88e11, #f06015);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f88e11', endColorstr='#f06015');
            }

            .orange:active {
                /*color: #fcd3a5;*/
                color: #ffffff;
                background: -webkit-gradient(linear, left top, left bottom, from(#f47a20), to(#faa51a));
                background: -moz-linear-gradient(top, #f47a20, #faa51a);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f47a20', endColorstr='#faa51a');
            }

        .button:active {
            /*text-decoration: none;*/
            color: red;
        }
    </style>
</head>
<body class="easyui-layout">
    <div data-options="region:'north'" style="padding-top:20px;">
        <table class="table">
            <tr>
                <td style="width: 550px;">
                    <fieldset>
                        <legend>开始整经</legend>
                        <table style="margin: auto;">
                            <tr>
                                <td>条码</td>
                                <td colspan="3">
                                    <input type="text" id="txbBarcodeBegin" onkeydown="BarcodeScan(0)"
                                        style="border: none; border-bottom: solid 1px #d3d3de; width: 250px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td>整经单号
                                </td>
                                <td>
                                    <input type="text" id="txbWarpingBillNoBegin" disabled="disabled" style="border: none; border-bottom: solid 1px #d3d3de; width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                    <input type="hidden" id="hd1" />
                                </td>
                                <td>操作工
                                </td>
                                <td>
                                    <input type="text" id="txbPerson" class="easyui-combobox" data-options="valueField:'sCode',textField:'sName',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td>衬子
                                </td>
                                <td>
                                    <input type="text" id="txbCzBegin" class="easyui-combobox" data-options=" valueField:'iRecNo',textField:'sCode',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                                <td>机台
                                </td>
                                <td>
                                    <input type="text" id="txbMachineBegin" class="easyui-combobox" data-options=" valueField:'iRecNo',textField:'sMachineCode',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center;">
                                    <a href="#" class="button orange" onclick="StartWarping()">开始整经</a>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
                <td style="width: 550px;">
                    <fieldset>
                        <legend>结束整经</legend>
                        <table style="margin: auto;">
                            <tr>
                                <td>条码</td>
                                <td colspan="3">
                                    <input type="text" id="txbBarcodeEnd" onkeydown="BarcodeScan(1)"
                                        style="border: none; border-bottom: solid 1px #d3d3de; width: 250px; height: 35px; font-size: 20px; font-weight: bold;" /></td>
                            </tr>
                            <tr>
                                <td>整经单号
                                </td>
                                <td>
                                    <input type="text" id="txbWarpingBillNoEnd" disabled="disabled" style="border: none; border-bottom: solid 1px #d3d3de; width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                    <input type="hidden" id="hd2" />
                                </td>
                                <td>完成米数
                                </td>
                                <td>
                                    <input type="text" id="txbFinishQty" class="easyui-numberbox" data-options="required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td>衬子
                                </td>
                                <td>
                                    <input type="text" id="txbCzEnd" class="easyui-combobox" data-options=" readonly:true, valueField:'iRecNo',textField:'sCode',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                                <td>机台
                                </td>
                                <td>
                                    <input type="text" id="txbMachineEnd" class="easyui-combobox" data-options=" readonly:true, valueField:'iRecNo',textField:'sMachineCode',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center;">
                                    <a href="#" class="button orange" onclick="EndWarping()">结束整经</a>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>

        </table>

        <%--<div class="top_table">
            <table cellpadding="5">
                <tr>
                    <td>条码</td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td>整经单号</td>
                    <td></td>
                    <td>衬子
                    </td>
                    <td></td>
                    <td>机台号</td>
                    <td></td>
                    <td>整经米数</td>
                    <td>
                        <input type="text" id="Text1" class="easyui-numberbox" data-options="precision:2,width:150,height:30" />

                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="text-align: center;">
                        <a id="btn" href="#" class="button orange" data-options="iconCls:'icon-search'" onclick="StartWarping()">开始整经</a>
                        <a id="btn" href="#" class="button orange" data-options="iconCls:'icon-search'" onclick="EndWarping()">结束整经</a>

                    </td>
                </tr>
            </table>
        </div>--%>
        <div id="dsearch" style="text-align: left;">
            <table style="font-size: 20px; font-family: 'Microsoft YaHei'; font-weight: bold;">
                <tr>
                    <td>日期从：
                    </td>
                    <td>
                        <input id="Date1" type="text" class="easyui-datebox" style="width: 120px; height: 30px;">
                    </td>
                    <td>至：
                    </td>
                    <td>
                        <input id="Date2" type="text" class="easyui-datebox" style="width: 120px; height: 30px;">
                    </td>
                    <td>操作工
                    </td>
                    <td>
                        <input type="text" id="Text2" class="easyui-combobox" data-options="valueField:'sCode',textField:'sName'" style="border: none; border-bottom: solid 1px #d3d3de; width: 120px; height: 30px;" />
                    </td>
                    <td>
                        <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showday()">查询当天</a>
                    </td>
                    <td>
                        <a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询全部</a>
                    </td>
                    
                </tr>
            </table>
        </div>
    </div>
    <div data-options="region:'center'">
        <table class="easyui-datagrid" id="table1" data-options="fit:true,border:false,singleSelect:true,collapsible:true,method:'get',rownumbers:true,toolbar:'#dsearch'">
            <thead>
                <tr>
                    <th data-options="field:'sBeginTime',width:140,styler:columnStyle">开始时间</th>
                    <th data-options="field:'sProWarpingMBillNo',width:120,styler:columnStyle">整经单号</th>
                    <th data-options="field:'sHeadCode',width:100,styler:columnStyle">衬子号</th>
                    <th data-options="field:'sMachineCode',width:80,styler:columnStyle">机台号</th>
                    <th data-options="field:'sPersonName',width:100,styler:columnStyle">操作工</th>
                    <th data-options="field:'sEndTime',width:140,styler:columnStyle">结束时间</th>
                    <th data-options="field:'fQty',width:100,styler:columnStyle">完成米数</th>

                </tr>
            </thead>

        </table>
    </div>
</body>
</html>
