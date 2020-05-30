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
            if (Page.usetype == "add") {
                $("#tabTop").tabs({
                    tools: [{
                        iconCls: 'icon-search',
                        handler: function () {
                            searchProPlanD();
                        }
                    }
                        ]
                });

                $("#ProPlanD").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { title: "染色单号", field: "sBillNo", width: 110, sortable: true },
                        { title: "下单日期", field: "dDate", width: 110, sortable: true },
                        { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                        { title: "染厂", field: "sCustName", width: 110, sortable: true },
                        { title: "投缸", field: "btnPro", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnPro(" + str + ", " + index + ")' value='投缸' />";
                            return btnStr;
                        }
                        },
                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                        { title: "坯布编号", field: "sBscDataFabCode", width: 80, sortable: true },
                        { title: "色号", field: "sColorID", width: 80, sortable: true },
                        { title: "颜色名称", field: "sColorName", width: 80, sortable: true },
                        { title: "坯布重量", field: "fQty", width: 80, sortable: true },
                        { title: "业务员", field: "sOrderUserName", width: 80, sortable: true },
                        { field: "iRecNo", hidden: true }
                    ]],
                    onDblClickRow: function (index, row) {
                        btnPro(row, index);
                    }
                }
                );
                //searchProPlanD();
            }
            else if (Page.usetype == "modify" || Page.usetype == "view") {
                $("#tabTop").tabs("close", "染色单明细");

                var sqlobj2 = { TableName: "vwProPlanDD",
                    Fields: "*",
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

                Page.setFieldValue('sBillNo', data2[0].sBillNo);
                Page.setFieldValue('sOrderNo', data2[0].sOrderNo);
                Page.setFieldValue('sCustName', data2[0].sOrderNo);
                Page.setFieldValue('sCode', data2[0].sCode);
                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);
                Page.setFieldValue('sColorID', data2[0].sColorID);
                Page.setFieldValue('sColorName', data2[0].sColorName);
                Page.setFieldValue('fQty', data2[0].fQty);

                var sqlobj1 = { TableName: "vwProPlanDD_SumWeight",
                    Fields: "fSumWeight",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iMainRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.getFieldValue("iMainRecNo")
                    }
                    ]

                }
                var data1 = SqlGetData(sqlobj1);
                if (data1.length > 0) {
                    Page.setFieldValue('fNotWeight', Number(data2[0].fQty) - Number(data1[0].fSumWeight));
                }
                else {
                    Page.setFieldValue('fNotWeight', Number(data2[0].fQty));
                }
            }
        });

        function btnPro(row, index) {
            Page.setFieldValue("sBillNo", row.sBillNo);
            Page.setFieldValue("sOrderNo", row.sOrderNo);
            Page.setFieldValue("sCustName", row.sCustName);
            Page.setFieldValue("sCode", row.sCode);
            Page.setFieldValue("sName", row.sName);
            Page.setFieldValue("sBscDataFabCode", row.sBscDataFabCode);
            Page.setFieldValue("fQty", row.fQty);
            Page.setFieldValue("sColorID", row.sColorID);
            Page.setFieldValue("sColorName", row.sColorName);
            Page.setFieldValue("iMainRecNo", row.iRecNo);

            var sqlobj1 = { TableName: "vwProPlanDD_SumWeight",
                Fields: "fSumWeight",
                SelectAll: "True",
                Filters: [
                    {
                        //字段名
                        Field: "iMainRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: row.iRecNo
                    }
                    ]

            }
            var data1 = SqlGetData(sqlobj1);
            if (data1.length > 0) {
                Page.setFieldValue('fNotWeight', Number(row.fQty) - Number(data1[0].fSumWeight));
            }
            else {
                Page.setFieldValue('fNotWeight', Number(row.fQty));
            }

            $("#tabTop").tabs("select", "投缸单");
        }

        function searchProPlanD() {
            if (Page.getFieldValue("dDate1") == "" || Page.getFieldValue("dDate2") == "") {
                $.messager.alert("错误", "请选择查询日期", "error");
                return;
            }
            if (Page.getFieldValue("iBscDataCustomerRecNo1") == "") {
                $.messager.alert("错误", "请选择染厂", "error");
                return;
            }
            var sqlObjProPlanD = {
                TableName: "vwProPlanD_ProPlanDD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataCustomerRecNo",
                        ComOprt: "=",
                        Value: Page.getFieldValue("iBscDataCustomerRecNo1"),
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + Page.getFieldValue("dDate1") + " 00:00:00'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + Page.getFieldValue("dDate2") + " 23:59:59'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "4",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(fNotWeight,0)",
                        ComOprt: ">",
                        Value: "0"
                    }
                    ],
                Sorts: [
                {
                    SortName: "iRecNo",
                    SortOrder: "asc"
                }
                ]
            };
            var resultProPlanD = SqlGetData(sqlObjProPlanD);
            if (resultProPlanD.length > 0) {
                $("#ProPlanD").datagrid("loadData", resultProPlanD);
            }
        }

        //        Page.Children.onEndEdit = function (tableid, index, row, changes) {
        //            if (tableid == "ProPlanD") {
        //                if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
        //                    if (Number(row.fQty) > Number(row.fNotProQty)) {
        //                        row.fQty = row.fNotProQty;
        //                        $.messager.show({
        //                            title: '投坯重量',
        //                            msg: "投坯重量输入错误,剩余未投坯重量为" + row.fNotProQty,
        //                            timeout: 1000,
        //                            showType: 'show',
        //                            style: {
        //                                right: '',
        //                                top: document.body.scrollTop + document.documentElement.scrollTop,
        //                                bottom: ''
        //                            }
        //                        });
        //                    }
        //                }
        //            }
        //        }

        function checkClick(obj) {
            if (obj.checked == true) {
                var checked1 = document.getElementById("__ExtCheckbox15").checked;
                if (checked1 == false) {
                    alert("尚未通知发货，不可发出！");
                    obj.checked = false;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="染色单明细">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <table>
                            <tr>
                                <td>
                                    下单日期从
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldType="日期" Z_FieldID="dDate1"
                                        Z_NoSave="True" />
                                </td>
                                <td>
                                    至
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldType="日期" Z_FieldID="dDate2"
                                        Z_NoSave="True" />
                                </td>
                                <td>
                                    染厂
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iBscDataCustomerRecNo1"
                                        Z_NoSave="True" Z_Required="true" />
                                </td>
                                <td>
                                    <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                        onclick='searchProPlanD()'>查询</a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="ProPlanD">
                    </table>
                </div>
            </div>
        </div>
        <div title="投缸单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                染色单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iMainRecNo" Style="display: none;" />
                            </td>
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCustName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                坯布编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                坯布重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fQty" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                剩余重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fNotWeight" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sColorID" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                颜色名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                投缸日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                缸号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sBatchNo" Z_Required="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                匹数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fPurQty" Z_FieldType="数值"
                                    Z_Required="True" />
                            </td>
                            <td>
                                重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fWeight" Z_FieldType="数值"
                                    Z_decimalDigits="2" Z_Required="True" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReMark" Z_FieldType="备注" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                工序
                            </td>
                            <td colspan="7">
                                <table border="1" cellspacing="0">
                                    <tr>
                                        <td>
                                            开卡
                                        </td>
                                        <td>
                                            退卷
                                        </td>
                                        <td>
                                            回潮
                                        </td>
                                        <td>
                                            水洗
                                        </td>
                                        <td>
                                            磨毛
                                        </td>
                                        <td>
                                            预定
                                        </td>
                                        <td>
                                            复色
                                        </td>
                                        <td>
                                            进缸
                                        </td>
                                        <td>
                                            展福
                                        </td>
                                        <td>
                                            风干
                                        </td>
                                        <td>
                                            拉毛
                                        </td>
                                        <td>
                                            成定
                                        </td>
                                        <td>
                                            打卷
                                        </td>
                                        <td>
                                            入库
                                        </td>
                                        <td>
                                            通知
                                        </td>
                                        <td>
                                            发出
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iProcess01" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iProcess02" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iProcess03" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iProcess04" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox5" runat="server" Z_FieldID="iProcess05" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox6" runat="server" Z_FieldID="iProcess06" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox7" runat="server" Z_FieldID="iProcess07" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox8" runat="server" Z_FieldID="iProcess08" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox9" runat="server" Z_FieldID="iProcess09" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox10" runat="server" Z_FieldID="iProcess10" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" Z_FieldID="iProcess11" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox12" runat="server" Z_FieldID="iProcess12" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox13" runat="server" Z_FieldID="iProcess13" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox14" runat="server" Z_FieldID="iProcess14" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox15" runat="server" Z_FieldID="iProcess15" disabled="disabled"
                                                Z_NoSave="true" />
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox16" runat="server" Z_FieldID="iProcess16" onclick="checkClick(this)" />
                                        </td>
                                    </tr>
                                </table>
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
                <%--<div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="投缸工序">
                            <!--  子表1  -->
                            <table id="ProPlanDD" tablename="ProPlanDD">
                            </table>
                        </div>
                    </div>
                </div>--%>
            </div>
        </div>
</asp:Content>
