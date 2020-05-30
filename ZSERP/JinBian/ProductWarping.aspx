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
            //var sqlObj3 = {
            //    TableName: "BscDataPanHead",
            //    Fields: "*",
            //    SelectAll: "True",
            //    Filters: [],
            //    Sorts: [{
            //        SortName: "sCode",
            //        SortOrder: "asc"
            //    }]
            //};
            //var data3 = SqlGetData(sqlObj3);
            //$("#txbCzBegin").combobox("loadData", data3);
            //$("#txbCzEnd").combobox("loadData", data3);

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

            $("#txbJgsBegin").textbox("textbox").css("font-size", "20px");
            $("#txbJgsBegin").textbox("textbox").css("font-weight", "bold");

            $("#txbJgsEnd").textbox("textbox").css("font-size", "20px");
            $("#txbJgsEnd").textbox("textbox").css("font-weight", "bold");

            $("#txbPerson").combobox("textbox").css("font-size", "20px");
            $("#txbPerson").combobox("textbox").css("font-weight", "bold");

            //$("#txbCzBegin").combobox("textbox").css("font-size", "20px");
            //$("#txbCzBegin").combobox("textbox").css("font-weight", "bold");

            //$("#txbCzEnd").combobox("textbox").css("font-size", "20px");
            //$("#txbCzEnd").combobox("textbox").css("font-weight", "bold");

            $("#txbMachineBegin").combobox("textbox").css("font-size", "20px");
            $("#txbMachineBegin").combobox("textbox").css("font-weight", "bold");

            $("#txbMachineEnd").combobox("textbox").css("font-size", "20px");
            $("#txbMachineEnd").combobox("textbox").css("font-weight", "bold");

            $("#txbFinishQty").combobox("textbox").css("font-size", "20px");
            $("#txbFinishQty").combobox("textbox").css("font-weight", "bold");

            $("#txbPerson").combobox("textbox").css("font-size", "20px");
            $("#txbPerson").combobox("textbox").css("font-weight", "bold");
            doSearch();

            var sqlObj5 = {
                TableName: "bscDataPerson",
                Fields: "sJobRole",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + userid + "'"
                    }
                ]
            }
            var data5 = SqlGetData(sqlObj5);
            if (data5.length > 0) {
                if (data5[0].sJobRole.indexOf("工艺员") > -1) {
                    $("#tdCancel").show();
                }
            }
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
                    var sqlObjCheck1 = {
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
                                Value: "'" + sBarCode + "'"
                            }
                        ]
                    }
                    var resultCheck1 = SqlGetData(sqlObjCheck1);
                    if (resultCheck1.length > 0) {
                        alert("已经开始或完成整经，不可重复");
                        PlayVoice("/sound/error.wav");
                        event.preventDefault();
                        $("#txbBarcodeBegin").val("");
                        return false;
                    }

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
                        PlayVoice("/sound/error.wav");
                        event.preventDefault();
                        $("#txbBarcodeBegin").val("");
                        return false;
                    }
                    var bl = false;
                    var sqlObj3 = {
                        TableName: "vwProWarpingM",
                        Fields: "iRecNo,sCustShortName",
                        SelectAll: "True",
                        Filters: [
                            { Field: "sBillNo", ComOprt: "=", Value: "'" + sBarCode + "'", LinkOprt: "and" },
                            { Field: "iStatus", ComOprt: "=", Value: "4" }],
                        Sorts: []
                    };
                    var data3 = SqlGetData(sqlObj3);
                    if (data3.length > 0) {
                        $("#txbWarpingBillNoBegin").val(sBarCode);
                        $("#txbJgsBegin").val(data3[0].sCustShortName);
                        $("#hd1").val(data3[0].iRecNo);
                        PlayVoice("/sound/success.wav");
                    } else {
                        alert("整经单号[" + sBarCode + "]不存在");
                        PlayVoice("/sound/error.wav");
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
                        PlayVoice("/sound/error.wav");
                        event.preventDefault();
                        $("#txbBarcodeEnd").val("");
                        return false;
                    }
                    $("#txbJgsEnd").textbox("setValue", resultCheck[0].sCustShortName);
                    $("#txbMachineEnd").combobox("setValue", resultCheck[0].ibscDataMachineRecNo);
                    $("#txbWarpingBillNoEnd").val(sBarCode);
                    $("#hd2").val(resultCheck[0].iRecNo);
                    $("#txbBarcodeEnd").val("");
                    PlayVoice("/sound/success.wav");
                }
            }
        }

        function StartWarping() {
            if (!$("#hd1").val()) {
                alert("整经单号不能为空");
                PlayVoice("/sound/error.wav");
                return;
            }

            if (!$("#txbMachineBegin").combobox("getValue")) {
                alert("机台号不能为空");
                PlayVoice("/sound/error.wav");
                return;
            }
            if ($("#txbPerson").combobox("getValue") == undefined || $("#txbPerson").combobox("getValue") == null || $("#txbPerson").combobox("getValue") == "") {
                alert("操作工不能为空");
                PlayVoice("/sound/error.wav");
                return;
            }

            var jsonobj1 = {
                StoreProName: "spKaiShiZhengJin",
                StoreParms: [{
                    ParmName: "@iBillRecNo",
                    Value: $("#hd1").val()
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
                doSearch();
                MessageShow("成功", "成功");
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
                //$("#txbCzEnd").combobox("setValue", "");
                $("#txbMachineEnd").combobox("setValue", "");
                $("#txbFinishQty").numberbox("setValue", 0);
                doSearch();
                MessageShow("成功", "成功");
            }
        }

        function doSearch(type) {
            var filters = [];
            var dDate1 = $("#Date1").datebox("getValue");
            var dDate2 = $("#Date2").datebox("getValue");
            var DateFinish1 = $("#DateFinish1").datebox("getValue");
            var DateFinish2 = $("#DateFinish2").datebox("getValue");
            if (dDate1 != "") {
                filters.push({
                    Field: "convert(varchar(50),dDate,23)", ComOprt: ">=", Value: "'" + dDate1 + "'", LinkOprt: "and"
                });
            }
            if (dDate2 != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }                
                filters.push({
                    Field: "convert(varchar(50),dDate,23)", ComOprt: "<=", Value: "'" + dDate2 + "'"
                })
            }
            if (DateFinish1 != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "convert(varchar(50),dEndTime,23)", ComOprt: ">=", Value: "'" + DateFinish1 + "'"
                });
            }
            if (DateFinish2 != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "convert(varchar(50),dEndTime,23)", ComOprt: "<=", Value: "'" + DateFinish2 + "'"
                })
            }
            if ($("#Text2").combobox("getValue") != "") {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "sPersonID", ComOprt: "=", Value: "'" + $("#Text2").combobox("getValue") + "'"
                })
            }
            var iFinish = $("#cbkFinish")[0].checked;
            if (iFinish) {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "dEndTime",
                    ComOprt: "is not",
                    Value: "NULL"
                })
            }
            else {
                if (filters.length > 0) {
                    filters[filters.length - 1].LinkOprt = "and";
                }
                filters.push({
                    Field: "dEndTime",
                    ComOprt: "is",
                    Value: "NULL"
                })
            }

            var sqlObj3 = {
                TableName: "vwProWarpingMWidthYield",
                Fields: "*",
                SelectAll: "True",
                Filters: filters,
                Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
            };
            //var data3 = SqlGetData(sqlObj3);
			var data3=[{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"112"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			},{
				sBillNo:"00001",sColour:"0101",sCustShortName:"客户1",fQty:"101",sPersonName:"用户1",
				sProcessPersonName:"用户1",sMachineCode:"001",sBeginTime:"2018-06-06 12:31:01",sEndTime:"2018-06-07 08:31:01",fFinishQty:"100",iRecNo:"111"
			}];
            $("#table1").datagrid("loadData", data3);
        }

        function showday() {
            //var dDate1 = $("#Date1").val() == "" ? "1990-01-01" : $("#Date1").val();
            //var dDate2 = $("#Date2").val() == "" ? "2990-01-01" : $("#Date2").val();
            var ndate = new Date();
            ndate = new Date(ndate.setDate(ndate.getDate()));
            // alert(ndate.getFullYear() + '-' + ((ndate.getMonth() + 1) + 100).toString().substring(1) + '-' + ((ndate.getDate() ) + 100).toString().substring(1))
            var syear = ndate.getFullYear();
            var smonth = ndate.getMonth() + 101;
            smonth = smonth.toString().substring(1);
            var sday = ndate.getDate() + 100;
            sday = sday.toString().substring(1)
            dDate1 = syear + '-' + smonth + '-' + sday;
            var filters = [{
                Field: "iType",
                ComOprt: "=",
                Value: "0",
                LinkOprt: "and"
            }];
            filters.push({
                Field: "convert(varchar(50),dBeginTime,23)", ComOprt: "=", Value: "'" + dDate1 + "'"
            });
            if ($("#Text2").combobox("getValue") != "") {
                filters[filters.length - 1].LinkOprt = "and";
                filters.push({
                    Field: "sPerson", ComOprt: "=", Value: "'" + $("#Text2").combobox("getValue") + "'"
                })
            }
            // alert(dDate1)
            var sqlObj3 = {
                TableName: "vwProYield",
                Fields: "*",
                SelectAll: "True",
                Filters: filters,
                Sorts: []
            };
            var data3 = SqlGetData(sqlObj3);
            $("#table1").datagrid("loadData", data3);
        }

        function columnStyle(value, row, index) {
            return "font-size:16px;";
        }
        function colorStyle(value, row, index) {
            if (row.dBeginTime==null) {
                return "font-size:16px;background-color:red;";
            } else if (row.dEndTime == null) {
                return "font-size:16px;background-color:yellow;";
            } else {
                return "font-size:16px;background-color:green;";
            }
        }

        function doCancel() {
            var selectRow = $("#table1").datagrid("getSelected");
            if (selectRow) {
                $.messager.confirm("确认撤销吗？", "确认撤销吗？", function (r) {
                    if (r) {
                        var jsonobj1 = {
                            StoreProName: "SpProYieldWarpingCancel",
                            StoreParms: [{
                                ParmName: "@iRecNo",
                                Value: selectRow.iRecNo
                            }]
                        }
                        var Result1 = SqlStoreProce(jsonobj1);
                        if (Result1 == "1") {
                            MessageShow("成功", "成功");
                            doSearch();
                        }
                    }
                })
            }

        }
        function rowStyle(index, row) {
            return "cursor:pointer";
        }
        function rowClick(index, row) {
            $("#txbWarpingBillNoBegin").val(row.sBillNo);
            $("#hd1").val(row.iRecNo);
            $("#txbJgsBegin").textbox("setValue", row.sCustShortName);
            $("#txbPerson").combobox("setValue", row.sProcessPerson);
            $("#txbMachineBegin").combobox("setValue", row.ibscDataMachineRecNo);


            $("#txbWarpingBillNoEnd").val(row.sBillNo);
            $("#hd2").val(row.iProYieldRecNo);
            $("#txbJgsEnd").textbox("setValue", row.sCustShortName);
            $("#txbFinishQty").numberbox("setValue", row.fFinishQty);
            $("#txbMachineEnd").combobox("setValue", row.ibscDataMachineRecNo);

        }
        function MessageShow(title, message) {
            $.messager.show({
                title: title,
                msg: message,
                showType: 'none',
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                },
                timeout: 2000
            });
        }
    </script>
    <style type="text/css">
        /** {
            font-size: 20px;
        }*/

        .combobox-item {
            font-size: 18px;
        }

        .table {
            margin: auto;
        }

            .table tr td {
                font-size: 20px;
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
            font-size: 18px;
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

        .datagrid-cell {
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body class="easyui-layout">
    <div data-options="region:'north'" style="padding-top: 10px; height:250px;">
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
                                <td>加工商
                                </td>
                                <td>
                                    <input type="text" id="txbJgsBegin" class="easyui-textbox" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>
                                <td>操作工
                                </td>
                                <td>
                                    <input type="text" id="txbPerson" class="easyui-combobox" data-options="valueField:'sCode',textField:'sName',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
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
                                <td>加工商
                                </td>
                                <td>
                                    <input type="text" id="txbJgsEnd" class="easyui-textbox" data-options="readonly:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                            </tr>
                            <tr>                                
                                <td>机台
                                </td>
                                <td>
                                    <input type="text" id="txbMachineEnd" class="easyui-combobox" data-options=" readonly:true, valueField:'iRecNo',textField:'sMachineCode',required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
                                </td>
                                <td>完成米数
                                </td>
                                <td>
                                    <input type="text" id="txbFinishQty" class="easyui-numberbox" data-options="required:true" style="width: 130px; height: 35px; font-size: 20px; font-weight: bold;" />
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
            <table style="font-size: 16px; font-family: 'Microsoft YaHei'; font-weight: bold;">
                <tr>
                    <td>下单日期从：
                    </td>
                    <td>
                        <input id="Date1" type="text" class="easyui-datebox" style="width: 100px; height: 30px;">
                    </td>
                    <td>至：
                    </td>
                    <td>
                        <input id="Date2" type="text" class="easyui-datebox" style="width: 100px; height: 30px;">
                    </td>
                    <td>完成日期从
                    </td>
                    <td>
                        <input id="DateFinish1" type="text" class="easyui-datebox" style="width: 100px; height: 30px;">
                    </td>
                    <td>至：
                    </td>
                    <td>
                        <input id="DateFinish2" type="text" class="easyui-datebox" style="width: 100px; height: 30px;">
                    </td>
                    <td>操作工
                    </td>
                    <td>
                        <input type="text" id="Text2" class="easyui-combobox" data-options="valueField:'sCode',textField:'sName'" style="border: none; border-bottom: solid 1px #d3d3de; width: 100px; height: 30px;" />
                    </td>
                    <td>
                        <input type="checkbox" id="cbkFinish" />
                        <label for="cbkFinish">已完成</label>
                    </td>
                    <%--<td>
                        <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="showday()">查询当天</a>
                    </td>--%>
                    <td>
                        <a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
                    </td>
                    <td id="tdCancel" style="display: none;">
                        <a id="btn3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="doCancel()">撤销</a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div data-options="region:'center'">
        <table class="easyui-datagrid" id="table1" data-options="fit:true,border:false,singleSelect:true,collapsible:true,method:'get',rownumbers:true,toolbar:'#dsearch',rowStyler:rowStyle,onClickRow:rowClick">
            <thead>
                <tr>
                    <th data-options="field:'sBillNo',width:120,styler:columnStyle">整经单号</th>
                    <th data-options="field:'sColour',width:120,styler:columnStyle">整经色号</th>
                    <th data-options="field:'sCustShortName',width:120,styler:columnStyle">加工商</th>
                    <th data-options="field:'fQty',width:120,styler:columnStyle">订单米数</th>
                    <th data-options="field:'sPersonName',width:100,styler:columnStyle">下发操作工</th>
                    <th data-options="field:'sProcessPersonName',width:100,styler:columnStyle">实际操作工</th>
                    <th data-options="field:'sMachineCode',width:80,styler:columnStyle">机台号</th>
                    <th data-options="field:'sBeginTime',width:160,styler:colorStyle,">开始时间</th>
                    <th data-options="field:'sEndTime',width:160,styler:colorStyle">结束时间</th>
                    <th data-options="field:'fFinishQty',width:100,styler:columnStyle">完成米数</th>
                    <th data-options="field:'iRecNo',width:100,hidden:true"></th>
                    <th data-options="field:'iProYieldRecNo',width:100,hidden:true"></th>
                    <th data-options="field:'ibscDataMachineRecNo',width:100,hidden:true"></th>
                </tr>
            </thead>

        </table>
    </div>	
</body>
</html>
