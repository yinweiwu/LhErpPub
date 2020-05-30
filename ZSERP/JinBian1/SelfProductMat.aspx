<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            //            var sqlObjdd = {
            //                TableName: "bscDataListD",
            //                Fields: "sCode",
            //                SelectAll: "True",
            //                Filters: [
            //                    {
            //                        Field: "sClassID",
            //                        ComOprt: "=",
            //                        Value: "'machineWorkTime'"
            //                    }
            //                ]
            //            }
            //            var result11 = SqlGetData(sqlObjdd);
            //            if (result11.length > 0) {
            //                machineWorkTime = isNaN(parseFloat(result11[0].sCode)) ? 24 : parseFloat(result11[0].sCode);
            //            }
            Page.Children.toolBarBtnDisabled("table2", "add");
            Page.Children.toolBarBtnDisabled("table2", "delete");
            Page.Children.toolBarBtnDisabled("table2", "copy");
            $("#table2").datagrid({ fit: false, height: 258, width: 1200 });
            if (Page.usetype == "add") {
                var data1 = [{
                    iSerial: 1,
                    sProcedureName: "上针"
                }];
                var data2 = [{
                    iSerial: 2,
                    sProcedureName: ""
                }];
                var data3 = [{
                    iSerial: 3,
                    sProcedureName: "下针"
                }];
                var data4 = [{
                    iSerial: 4,
                    sProcedureName: ""
                }];
                var data5 = [{
                    iSerial: 5,
                    sProcedureName: ""
                }];
                var data6 = [{
                    iSerial: 6,
                    sProcedureName: ""
                }];
                var data7 = [{
                    iSerial: 7,
                    sProcedureName: "排纱顺序"
                }];
                var data8 = [{
                    iSerial: 8,
                    sProcedureName: "备注"
                }];
                Page.tableToolbarClick("add", "table2", data1[0]);
                Page.tableToolbarClick("add", "table2", data2[0]);
                Page.tableToolbarClick("add", "table2", data3[0]);
                Page.tableToolbarClick("add", "table2", data4[0]);
                Page.tableToolbarClick("add", "table2", data5[0]);
                Page.tableToolbarClick("add", "table2", data6[0]);
                Page.tableToolbarClick("add", "table2", data7[0]);

                Page.setFieldValue("iMatType", getQueryString("iMatType"));
            }

            if (getQueryString("iMatType") == "-1") {
                $("#tt").tabs("disableTab", 1);
            }
        })

        //        Page.beforeInit = function () {
        //            if (getQueryString("iMatType") == "-1") {
        //                $("#tt").tabs("close", "坯布工艺");
        //            }
        //        }

        Page.Children.onBeginEdit = function (tableid, index, row) {
            if (tableid == "table2") {
                if (datagridOp.currentColumnName != "sProcedureName" && datagridOp.currentColumnName != "iSerial") {
                    if (index < 2) {
                        var editor = $("#table2").datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                        if (editor.type == "combobox") {
                            $(editor.target).combobox({ loadFilter: function (data) {
                                var dataP = [];
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].sEngName == "0" || data[i].sEngName == "1") {
                                        dataP.push(data[i]);
                                    }
                                }
                                return dataP;
                            }
                            })
                        }
                    }
                    else if (index >= 2 && index < 6) {
                        var editor = $("#table2").datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                        if (editor.type == "combobox") {
                            $(editor.target).combobox({ loadFilter: function (data) {
                                var dataP = [];
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].sEngName == "0" || data[i].sEngName == "2") {
                                        dataP.push(data[i]);
                                    }
                                }
                                return dataP;
                            }
                            })
                        }
                    }
                    else if (index == 6) {
                        var editor = $("#table2").datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                        if (editor.type == "combobox") {
                            $(editor.target).combobox({ loadFilter: function (data) {
                                var dataP = [];
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].sEngName == "3") {
                                        dataP.push(data[i]);
                                    }
                                }
                                return dataP;
                            },
                                panelHeight: 200
                            }
                            )
                        }
                    }
                    //                    else {
                    //                        $("#table2").datagrid("mergeCells", { index: 7, field: "way1", rowspan: 1, colspan: 24 });
                    //                        var editor = $("#table2").datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                    //                        if (editor.type == "combobox") {
                    //                            $(editor.target).textbox({ multiline: true, width: 500 });
                    //                            editor.type = "text";
                    //                        }
                    //                    }
                }
            }
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "table3") {
                if ((datagridOp.currentColumnName == "sLength" && changes.sLength) || (datagridOp.currentColumnName == "sCount" && changes.sCount) || (datagridOp.currentColumnName == "sCode" && changes.sCode != undefined && changes.sCode != null)) {
                    var sLength = isNaN(parseFloat(row.sLength)) ? 0 : parseFloat(row.sLength);
                    var iDenier = isNaN(parseFloat(row.iDenier)) ? 0 : parseFloat(row.iDenier);
                    var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));
                    var sCount = isNaN(parseFloat(row.sCount)) ? 0 : parseFloat(row.sCount);

                    var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
                    row.fWtmTmp = sss;

                    var rows = $("#" + tableid).datagrid("getRows");
                    var sum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
                    }
                    if (sum > 0) {
                        row.fSrate = (sss / sum) * 100;
                        for (var i = 0; i < rows.length; i++) {
                            //if (i != index) {
                            $("#" + tableid).datagrid("updateRow", { index: i, row: { fSrate: (rows[i].fWtmTmp / sum) * 100} });
                            //}
                        }
                        var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
                        var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
                        Page.setFieldValue("sOutPut", saaa);
                    }
                    else {
                        Page.setFieldValue("sOutPut", "");
                        for (var i = 0; i < rows.length; i++) {
                            //if (i != index) {
                            $("#" + tableid).datagrid("updateRow", { index: i, row: { fSrate: null} });
                            //}
                        }
                    }
                }

            }
        }

        Page.beforeSave = function () {
            var sqlCheckObj = {
                TableName: "bscDataMat",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue("sCode") + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iRecNo",
                        ComOprt: "<>",
                        Value: "'" + Page.key + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlCheckObj);
            if (result.length > 0) {
                Page.MessageShow("坯布编号不能重复", "对不起，坯布编号不能重复！");
                return false;
            }

            var sModelType = Page.getFieldValue("sModelType");
            if (sModelType.indexOf("'") > -1) {
                Page.MessageShow("机台型号不能包含特殊字符", "机台型号中不能包含特殊字符：'(单引号),请用：\"（双引号）代替！");
                return false;
            }
        }

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "iSumQty") {
                    var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));

                    var rows = $("#table3").datagrid("getRows");

                    for (var i = 0; i < rows.length; i++) {
                        var sLength = isNaN(parseFloat(rows[i].sLength)) ? 0 : parseFloat(rows[i].sLength);
                        var iDenier = isNaN(parseFloat(rows[i].iDenier)) ? 0 : parseFloat(rows[i].iDenier);
                        var sCount = isNaN(parseFloat(rows[i].sCount)) ? 0 : parseFloat(rows[i].sCount);
                        var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
                        //var fSrate = sum == 0 ? 100 : (row.fWtmTmp / sum) * 100
                        $("#table3").datagrid("updateRow", { index: i, row: { fWtmTmp: sss} });
                    }
                    var sum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
                    }
                    for (var i = 0; i < rows.length; i++) {
                        //                        var sLength = isNaN(parseFloat(rows[i].sLength)) ? 0 : parseFloat(rows[i].sLength);
                        //                        var iDenier = isNaN(parseFloat(rows[i].iDenier)) ? 0 : parseFloat(rows[i].iDenier);
                        //                        var sCount = isNaN(parseFloat(rows[i].sCount)) ? 0 : parseFloat(rows[i].sCount);
                        //                        var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
                        var fSrate = sum == 0 ? 100 : (rows[i].fWtmTmp / sum) * 100
                        $("#table3").datagrid("updateRow", { index: i, row: { fSrate: fSrate} });
                    }
                }
                if (field == "sRev" || field == "iWorkTime" || field == "iSumQty") {
                    var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
                    var rows = $("#table3").datagrid("getRows");
                    var sum = 0;
                    for (var i = 0; i < rows.length; i++) {
                        sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
                    }
                    if (sum > 0) {
                        var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
                        Page.setFieldValue("sOutPut", saaa);
                    }

                }
            }
        }

        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "table3") {
                caleUse();
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1117") {
                caleUse();
            }
        }

        function caleUse() {
            var rows = $("#table3").datagrid("getRows");

            for (var i = 0; i < rows.length; i++) {
                var sLength = isNaN(parseFloat(rows[i].sLength)) ? 0 : parseFloat(rows[i].sLength);
                var iDenier = isNaN(parseFloat(rows[i].iDenier)) ? 0 : parseFloat(rows[i].iDenier);
                var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));
                var sCount = isNaN(parseFloat(rows[i].sCount)) ? 0 : parseFloat(rows[i].sCount);
                var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
                $("#table3").datagrid("updateRow", { index: i, row: { fWtmTmp: sss} });
            }

            var sum = 0;
            for (var i = 0; i < rows.length; i++) {
                sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
            }
            if (sum > 0) {
                //row.fSrate = (sss / sum) * 100;
                for (var i = 0; i < rows.length; i++) {
                    $("#table3").datagrid("updateRow", { index: i, row: { fSrate: (rows[i].fWtmTmp / sum) * 100} });
                }
                var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
                var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
                Page.setFieldValue("sOutPut", saaa);
            }
            else {
                Page.setFieldValue("sOutPut", "");
                for (var i = 0; i < rows.length; i++) {
                    //if (i != index) {
                    $("#table3").datagrid("updateRow", { index: i, row: { fSrate: null} });
                    //}
                }
            }
        }

        function setGYChar(obj) {
            if (datagridOp.current.id == "table2") {
                var updateRow = {};
                updateRow[(datagridOp.currentColumnName)] = obj.innerHTML;
                $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: updateRow });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <br />
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table align="center" style="width: 70%">
                <tr>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>
                        坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sName" />
                    </td>
                    <td width="50px">
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="基本信息">
                    <div data-options="region:'north'" style="overflow: hidden;">
                        <table class="tabmain">
                            <tr>
                                <td>
                                    客户名称
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                                </td>
                                <td>
                                    客户规格
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sElements" />
                                </td>
                                <td>
                                    来样编号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sSampleBillNo" />
                                </td>
                                <td>
                                    来样时间
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox19" Z_FieldType="日期" runat="server" Z_FieldID="dSampleGetDate" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan='8'>
                                    <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                        <table align="center">
                                            <tr>
                                                <td>
                                                    样品幅宽(cm)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fSampleWidth" Z_disabled="False" />
                                                </td>
                                                <td>
                                                    坯布幅宽(cm)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fFabWidth" Z_disabled="False" />
                                                </td>
                                                <td style="display: none">
                                                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="1" />
                                                </td>
                                                <td>
                                                    成品幅宽(cm)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fProductWidth" Z_disabled="False" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    样品克重(g/㎡)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fSampleWeight" Z_disabled="False" />
                                                </td>
                                                <td>
                                                    坯布克重(g/㎡)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fFabWeight" Z_disabled="False" />
                                                </td>
                                                <td>
                                                    成品克重(g/㎡)
                                                </td>
                                                <td>
                                                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fProductWeight" Z_disabled="False" />
                                                </td>
                                                <td style="display: none">
                                                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iWarp" Z_Value="1" />
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    开发时间
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dDevelopDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    大货日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dSampleOutDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    机台型号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sModelType" />
                                </td>
                                <td>
                                    机号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sModelNo" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    车 速
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sRev" Z_disabled="False"
                                        Z_FieldType="数值" Z_decimalDigits="2" />
                                </td>
                                <td>
                                    匹重量
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fOneWeight" Z_disabled="False"
                                        Z_decimalDigits="2" Z_FieldType="数值" />
                                </td>
                                <td>
                                    工作时间(MIN)
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iWorkTime" Z_FieldType="整数"
                                        Z_decimalDigits="0" />
                                </td>
                                <td>
                                    工作针数
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iSumQty" Z_FieldType="整数"
                                        Z_decimalDigits="0" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    产 量
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOutPut" Z_disabled="False"
                                        Z_decimalDigits="2" Z_FieldType="数值" />
                                </td>
                                <td>
                                    停用时间
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    备 注
                                </td>
                                <td colspan="2">
                                    <textarea name="sRemark" fieldid="sRemark" style="border-bottom: 1px solid black;
                                        width: 188px; border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                                        border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                                        border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div data-options="region:'center'">
                        <div data-options="fit:true" title="坯布用料" style="height: 390px;">
                            <table id="table3" tablename="bscDataMatDWaste">
                            </table>
                        </div>
                    </div>
                    <div data-options="region:'south',border:false" style="height: 40px">
                        <table width="75%">
                            <tr>
                                <td style="font-family: 微软雅黑; font-size: 20px">
                                    制单人
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                                </td>
                                <td style="font-family: 微软雅黑; font-size: 20px">
                                    录入时间
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="fit:true" title="坯布工艺">
                    <table class="tabmain">
                        <tr>
                            <td rowspan="2">
                                排 针
                            </td>
                            <td>
                                上
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Width="300px" Z_FieldID="sTopRowNeedles" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                下
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Width="300px" Z_FieldID="sDownRowNeedles" />
                            </td>
                            <td style="vertical-align: bottom;">
                                <a href="javascript:void(0)" style="font-size: 22px; font-weight: bold; text-decoration: none;
                                    color: Black;" onclick="setGYChar(this)">－</a>&nbsp;&nbsp; <a href="javascript:void(0)"
                                        style="font-size: 22px; font-weight: bold; text-decoration: none; color: Black;"
                                        onclick="setGYChar(this)">∨</a>&nbsp;&nbsp; <a href="javascript:void(0)" style="font-size: 22px;
                                            font-weight: bold; text-decoration: none; color: Black;" onclick="setGYChar(this)">
                                            ∪</a>&nbsp;&nbsp; <a href="javascript:void(0)" style="font-size: 22px; font-weight: bold;
                                                text-decoration: none; color: Black;" onclick="setGYChar(this)">∧</a>&nbsp;&nbsp;
                                <a href="javascript:void(0)" style="font-size: 22px; font-weight: bold; text-decoration: none;
                                    color: Black;" onclick="setGYChar(this)">∩</a>
                            </td>
                        </tr>
                    </table>
                    <table id="table2" tablename="bscDataMatDTech">
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td style="width: 140px; text-align: center;">
                                备 注
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Style="width: 800px;" Z_FieldID="sTechRemark" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="fit:true" title="坯布要求">
                    <table id="table1" tablename="BscDataMatDFabAsk">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
