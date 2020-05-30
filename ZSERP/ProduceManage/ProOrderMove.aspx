<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                if (getQueryString("iBillType") == "1") {
                    Page.setFieldValue("sOutBscDataPersonID", Page.userid);
                }
            }
            if (getQueryString("iBillType") == "2") {
                Page.mainDisabled();
                Page.Children.toolBarBtnDisabled("ProOrderMoveD", "add");
                Page.Children.toolBarBtnDisabled("ProOrderMoveD", "delete");
            }
            Page.Children.toolBarBtnDisabled("ProOrderMoveD", "add");
        })
        Page.beforeSave = function () {
            if (getQueryString("iBillType") == "1") {
                var iWorkOut = 0;
                var iWorkIn = 0;
                var sqlObj1 = {
                    TableName: "bscDataClass",
                    Fields: "isnull(iWork,0) as iWork",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "sType",
                    ComOprt: "=",
                    Value: "'depart'",
                    LinkOprt: "and"
                },
                {
                    Field: "sClassID",
                    ComOprt: "=",
                    Value: "'" + Page.getFieldValue("sOutDeptID") + "'"
                }
                ]
                }
                var result1 = SqlGetData(sqlObj1);
                if (result1.length > 0) {
                    iWorkOut = isNaN(parseInt(result1[0].iWork)) ? 0 : parseInt(result1[0].iWork);
                }

                var sqlObj2 = {
                    TableName: "bscDataClass",
                    Fields: "isnull(iWork,0) as iWork",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "sType",
                    ComOprt: "=",
                    Value: "'depart'",
                    LinkOprt: "and"
                },
                {
                    Field: "sClassID",
                    ComOprt: "=",
                    Value: "'" + Page.getFieldValue("sInDeptID") + "'"
                }
                ]
                }
                var result2 = SqlGetData(sqlObj2);
                if (result2.length > 0) {
                    iWorkIn = isNaN(parseInt(result2[0].iWork)) ? 0 : parseInt(result2[0].iWork);
                }
                if (iWorkOut >= iWorkIn) {
                    Page.MessageShow("错误", "对不起，不能反向交接！");
                    return false;
                }
            }
        }
        lookUp.beforeSetValue = function (uniqueid, data) {
            if (uniqueid == "118") {
                if (Page.getFieldValue("iRed") == "1") {
                    for (var i = 0; i < data.length; i++) {
                        data[i].iQty = data[i].iQty * -1;
                        data[i].iMcQty = data[i].iMcQty * -1;
                    }
                    return data;
                }
            }
        }
        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            var rows = $("#ProOrderMoveD").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                if (row.sBarCode == rows[i].sBarCode) {
                    var message = $("#txaBarcodeTip").val();
                    $("#txaBarcodeTip").val(message + "条码" + row.sBarCode + "重复\n");
                    Page.MessageShow("条码重复", "条码" + row.sBarCode + "重复！");
                    return false;
                }
            }
        }
        //已被接收条码
        var receivedBarcode = [];
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    var iRed = Page.getFieldValue("iRed");
                    if (getQueryString("iBillType") == "1") {
                        var Filters = [
                        {
                            Field: "sBarCode",
                            ComOprt: "=",
                            Value: "'" + barcode + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "iQty",
                            ComOprt: ">",
                            Value: "0",
                            LinkOprt: "and"
                        }
                    ];
                        if (iRed == 1) {
                            Filters.push({
                                Field: "sDeptID",
                                ComOprt: "like",
                                Value: "'" + Page.getFieldValue("sInDeptID") + "%'"
                            });
                        }
                        else {
                            Filters.push({
                                Field: "sDeptID",
                                ComOprt: "like",
                                Value: "'" + Page.getFieldValue("sOutDeptID") + "%'"
                            });
                        }
                        var sqlObj = {
                            TableName: "vwProStock",
                            Fields: " sBarCode,iQty,iQty as iMcQty,sOrderNo,sStyleNo,sCustShortName,sColorName,sSizeName,iReTurn,sDeptID",
                            SelectAll: "True",
                            Filters: Filters
                        }
                        var resultData = SqlGetData(sqlObj);
                        if (resultData.length > 0) {
                            if (Page.getFieldValue("iRed") == "1") {
                                for (var i = 0; i < resultData.length; i++) {
                                    resultData[i].iQty = resultData[i].iQty * -1;
                                    resultData[i].iMcQty = resultData[i].iMcQty * -1;
                                }
                            }
                            for (var i = 0; i < resultData.length; i++) {
                                var rows = $("#ProOrderMoveD").datagrid("getRows");
                                for (var j = 0; j < rows.length; j++) {
                                    if (resultData[i].sBarCode == rows[j].sBarCode) {
                                        var message = $("#txaBarcodeTip").val();
                                        $("#txaBarcodeTip").val(message + "条码" + barcode + "重复\n");
                                        PlayVoice("条码" + barcode + "重复");
                                        $("#txtBarcode").val("");
                                        $("#txtBarcode").focus();
                                        stopBubble($("#txtBarcode")[0]);
                                        return false;
                                    }
                                }
                                Page.tableToolbarClick("add", "ProOrderMoveD", resultData[i]);
                            }
                        }
                        else {
                            var message = $("#txaBarcodeTip").val();
                            $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                            PlayVoice("条码" + barcode + "不存在");
                        }
                    }
                    if (getQueryString("iBillType") == "2") {
                        if ($.inArray(barcode, receivedBarcode) > -1) {
                            var message = $("#txaBarcodeTip").val();
                            $("#txaBarcodeTip").val(message + "条码" + barcode + "重复\n");
                            PlayVoice("条码" + barcode + "重复");
                        }
                        else {
                            var rows = $("#ProOrderMoveD").datagrid("getRows");
                            var isFind = false;
                            for (var i = 0; i < rows.length; i++) {
                                if (rows[i].sBarCode == barcode) {
                                    isFind = true;
                                    rows[i].iMoveQty = 1;
                                    rows[i].iMcQty = rows[i].iMcQty - 1;
                                    $("#ProOrderMoveD").datagrid("updateRow", {
                                        index: i,
                                        row: rows[i]
                                    });
                                    receivedBarcode.push(rows[i].sBarCode);
                                    break;
                                }
                            }
                            if (isFind == false) {
                                var message = $("#txaBarcodeTip").val();
                                $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                PlayVoice("条码" + barcode + "不存在");
                            }
                        }
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }
        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north',border:false" style="overflow: hidden; height: 230px;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td>
                        <table>
                            <tr>
                                <!--这里是主表字段摆放位置-->
                                <td>
                                    交接单号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                                </td>
                                <td>
                                    交接日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                                </td>
                                <td>
                                    交接类型
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sMoveType" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="easyui-panel" data-options="title:'交接信息',iconCls:'icon-list'">
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        转出车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sOutDeptID" Z_readOnly="False"
                                            Z_Required="True" />
                                    </td>
                                    <td>
                                        转出经办人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sOutBscDataPersonID" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        转入车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sInDeptID" Z_Required="True" />
                                    </td>
                                    <td>
                                        转入经办人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sInBscDataPersonID" />
                                    </td>
                                    <td>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRed" />
                                        <label for="__ExtCheckbox21">
                                            是否返修</label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    备注
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="166px" Z_FieldID="sReMark" />
                                </td>
                                <td>
                                    总数量
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iQty" Z_readOnly="True" />
                                </td>
                                <td>
                                    制单人
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                                </td>
                                <td>
                                    制单日期
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dInputDate" Z_readOnly="True"
                                        Z_FieldType="日期" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <strong>条码</strong>
                                </td>
                                <td>
                                    <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 384px;
                                        height: 30px; font-size: 30px; font-weight: bold;" />
                                </td>
                                <td>
                                    <textarea id="txaBarcodeTip" style="height: 30px; width: 291px;" readonly="readonly"></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="交接明细">
                    <!--  子表1  -->
                    <table id="ProOrderMoveD" tablename="ProOrderMoveD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
