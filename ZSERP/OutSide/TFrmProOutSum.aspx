<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .txb
        {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
        });

        lookUp.beforeOpen = function (uniqueid, data) {
            if (uniqueid == "76") {
                var iRed = Page.getFieldValue('iRed');
                if (iRed == "0") {
                    var sDeptID = Page.getFieldValue('sDeptID');
                    var sqlObj = { TableName: "bscDataClass",
                        Fields: "iwork",
                        SelectAll: "True",
                        Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'depart'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sClassID", ComOprt: "=", Value: "'" + sDeptID + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        if (data[0].iwork != "10") {
                            $.messager.show({
                                title: '错误',
                                msg: '该部门不属于主料仓！',
                                timeout: 1000,
                                showType: 'show',
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                            return false;
                        }
                    }
                }
                else {
                    $.messager.show({
                        title: '错误',
                        msg: '请选择红冲转入！',
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    return false;
                }
            }
            else if (uniqueid == "92") {
                var iRed = Page.getFieldValue('iRed');
                if (iRed == "0") {
                    var sDeptID = Page.getFieldValue('sDeptID');
                    var sqlObj = { TableName: "bscDataClass",
                        Fields: "iwork",
                        SelectAll: "True",
                        Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'depart'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sClassID", ComOprt: "=", Value: "'" + sDeptID + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        if (data[0].iwork == "10") {
                            $.messager.show({
                                title: '错误',
                                msg: '该部门属于主料仓！',
                                timeout: 1000,
                                showType: 'show',
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                            return false;
                        }
                    }
                }
                else {
                    $.messager.show({
                        title: '错误',
                        msg: '请选择红冲转入！',
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    return false;
                }
            }
            else if (uniqueid == "94") {
                var iRed = Page.getFieldValue('iRed');
                if (iRed == "0") {
                    $.messager.show({
                        title: '错误',
                        msg: '请选择退回！',
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    return false;
                }
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if ($("#__ExtCheckbox21")[0].checked == false) {
                    if (barcode != "") {
                        var sqlobj = { TableName: "vw_PurOrderMSelect2",
                            Fields: "sBarCode,iQty,sBillNo,iRecNo as iPurOrderMRecNo",
                            SelectAll: "True",
                            Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                        };
                        var data = SqlGetData(sqlobj);
                        if (data.length > 0) {
                            var rows = $("#table1").datagrid("getRows");
                            var addRow = true;
                            for (var i = 0; i < rows.length; i++) {
                                if (rows[i].sBarCode == data[0].sBarCode) {
                                    addRow = false;
                                }
                            }
                            if (addRow == true) {
                                Page.tableToolbarClick("add", "table1", data[0]);
                            }
                            else {
                                $.messager.show({
                                    title: '错误',
                                    msg: '不可转入相同数据！',
                                    timeout: 1000,
                                    showType: 'show',
                                    style: {
                                        right: '',
                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                                        bottom: ''
                                    }
                                });
                            }
                        }
                        else {
                            var sqlobj1 = { TableName: "vw_PurOrderMSelect1",
                                Fields: "sBarCode,iQty,sBillNo,iRecNo as iPurOrderMRecNo",
                                SelectAll: "True",
                                Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                            };
                            var data1 = SqlGetData(sqlobj1);
                            if (data1.length > 0) {
                                var rows = $("#table1").datagrid("getRows");
                                var addRow = true;
                                for (var i = 0; i < rows.length; i++) {
                                    if (rows[i].sBarCode == data1[0].sBarCode) {
                                        addRow = false;
                                    }
                                }
                                if (addRow == true) {
                                    Page.tableToolbarClick("add", "table1", data1[0]);
                                }
                                else {
                                    $.messager.show({
                                        title: '错误',
                                        msg: '不可转入相同数据！',
                                        timeout: 1000,
                                        showType: 'show',
                                        style: {
                                            right: '',
                                            top: document.body.scrollTop + document.documentElement.scrollTop,
                                            bottom: ''
                                        }
                                    });
                                }
                            }
                            else {
                                var message = $("#txaBarcodeTip").val();
                                $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                                PlayVoice("条码" + barcode + "不存在");
                            }
                        }
                    }
                }
                else {
                    var sqlobj = { TableName: "vwProStockSelect",
                        Fields: "sBarCode,iQty,sBillNo,iPurOrderMRecNo",
                        SelectAll: "True",
                        Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'"}]
                    };
                    var data = SqlGetData(sqlobj);
                    if (data.length > 0) {
                        var rows = $("#table1").datagrid("getRows");
                        var addRow = true;
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == data[0].sBarCode) {
                                addRow = false;
                            }
                        }
                        if (addRow == true) {
                            Page.tableToolbarClick("add", "table1", data[0]);
                        }
                        else {
                            $.messager.show({
                                title: '错误',
                                msg: '不可转入相同数据！',
                                timeout: 1000,
                                showType: 'show',
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                        }
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                        PlayVoice("条码" + barcode + "不存在");
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }

        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "76") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sBarCode == row.sBarCode) {
                        $.messager.show({
                            title: '错误',
                            msg: '不可转入相同数据！',
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        return false;
                    }
                }
            }
            else if (uniqueid == "92") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sBarCode == row.sBarCode) {
                        $.messager.show({
                            title: '错误',
                            msg: '不可转入相同数据！',
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        return false;
                    }
                }
            }
            else if (uniqueid == "94") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sBarCode == row.sBarCode) {
                        $.messager.show({
                            title: '错误',
                            msg: '不可转入相同数据！',
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        return false;
                    }
                }
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
        <div data-options="region:'north'" style="overflow: hidden;">
            <table class="tabmain" style="margin: auto;">
                <tr>
                    <td>
                        外发单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        加工商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Z_Required="True" />
                    </td>
                    <td>
                        加工单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iPurOrderMRecNo" />
                    </td>
                    <td>
                        发出车间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sDeptID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        外发日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Z_Required="True" />
                    </td>
                    <td>
                        数 量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iQty" Z_FieldType="数值" />
                    </td>
                    <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        备 注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="80%" Z_FieldID="sReMark" />
                    </td>
                </tr>
                <tr>
                    <td colspan="8">
                        <table>
                            <tr>
                                <td>
                                    <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRed" />
                                </td>
                                <td>
                                    <label for="__ExtCheckbox21">
                                        是否退回</label>
                                </td>
                                <td>
                                    <strong>请扫入条码</strong>
                                </td>
                                <td colspan="3">
                                    <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 400px;
                                        height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                                </td>
                                <td colspan="2">
                                    <textarea id="txaBarcodeTip" style="height: 40px; width: 310px;" readonly="readonly"
                                        class="txb"></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="display: none">
                    <td>
                        收发/类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="iType" Z_Value="1" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sUserID" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="工序外加工发出明细">
                    <table id="table1" tablename="ProOrderOutSendD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
