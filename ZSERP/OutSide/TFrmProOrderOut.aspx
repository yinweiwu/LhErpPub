<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            //var result = $('#table1').datagrid('getRows');
            if (Page.usetype == "modify" || Page.usetype == "" || Page.usetype == "view") {
                var ProOrderMRecNo = Page.getFieldValue('iProOrderMRecNo');
                var sqlobj = { TableName: "vwProOrderM",
                    Fields: "sOrderNo,sStyleNo,sSaleName",
                    SelectAll: "True",
                    Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + ProOrderMRecNo + "'"}]
                };
                var data = SqlGetData(sqlobj);
                if (data.length > 0) {
                    Page.setFieldValue('sOrderNo', data[0].sOrderNo);
                    Page.setFieldValue('iBscDataStyleMRecNo', data[0].sStyleNo);
                    Page.setFieldValue('sSaleName', data[0].sSaleName);
                }
            }
            lookUp.beforeSetValue = function (uniqueid, data) {
                //uniqueid=66表示从订单生产明细转入
                if (uniqueid == "66") {
                    //赋值之前，获取尺码数量
                    var dataProc = data;
                    var iMainRecNoStr = "";

                    for (var i = 0; i < data.length; i++) {
                        iMainRecNoStr += "'" + data[i].iRecNo + "',";
                    }
                    if (data.length > 0) {
                        iMainRecNoStr = iMainRecNoStr.substr(0, iMainRecNoStr.length - 1);
                    }
                    iMainRecNoStr = "(" + iMainRecNoStr + ")";
                    var sqlObj = {
                        TableName: "ProOrderPlanDProOrderM",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "in",
                            Value: iMainRecNoStr
                        }
                        ],
                        Sorts: [
                            { SortName: "iRecNo", SortOrder: "asc" },
                            { SortName: "sSizeName", SortOrder: "asc" }
                        ]
                    };
                    var resultSize = SqlGetData(sqlObj);
                    if (resultSize && resultSize.length > 0) {
                        for (var i = 0; i < dataProc.length; i++) {
                            var iRecNo = dataProc[i].iRecNo;
                            for (var j = 0; j < resultSize.length; j++) {
                                if (iRecNo == resultSize[j].iRecNo) {
                                    dataProc[i][(resultSize[j].sSizeName)] = resultSize[j].iQty;
                                }
                            }
                        }
                    }
                    return dataProc;
                }
            }

            lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
                //uniqueid=66表示从订单生产明细转入
                if (uniqueid == "66") {
                    var rows = $("#table1").datagrid("getRows");
                    for (var i = 0; i < rows.length; i++) {
                        if (rows[i].iSdContractDProduceRecNo == row.iSdContractDProduceRecNo) {
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
                            //Page.MessageShow("不可转入", "不可转入相同数据！");
                            return false;
                        }
                    }
                    var dynColumns = Page.Children.GetDynColumns("table1");
                    for (var i = 0; i < dynColumns.length; i++) {
                        if (data[index][(dynColumns[i])]) {
                            row[(dynColumns[i])] = data[index][(dynColumns[i])];
                        }
                    }
                    return row;
                }
            }

            lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
                //uniqueid=66表示从订单生产明细转入
                if (uniqueid == "66") {
                    //var rows = $("#table1").datagrid("getRows")[rowIndex];
                    Page.Children.DynFieldRowSummary("table1", rowIndex);
                }
            }
            lookUp.afterSelected = function (uniqueid, data) {
                //uniqueid=66表示从订单生产明细转入
                if (uniqueid == "66") {
                    Page.Children.ReloadFooter("table1");
                    Page.Children.ReloadDynFooter("table1");
                }
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <table class="tabmain" style="margin: auto;">
                <tr>
                    <td>
                        加工单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        加工厂家
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Z_Required="True" />
                    </td>
                    <td>
                        下单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Z_Required="True" />
                    </td>
                    <td>
                        计划领料日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dPlanDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        生产单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="iProOrderMRecNo" />
                    </td>
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataStyleMRecNo"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                    <td>
                        业务员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sSaleName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        采购交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        外发件数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="fQty" Z_FieldType="整数" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fTotal" Z_FieldType="数值" />
                    </td>
                    <td>
                        采购类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sPurType" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        工价
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fPrice" Z_FieldType="数值" />
                    </td>
                    <td>
                        采购员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBscDataPersonID" Z_readOnly="False" />
                    </td>
                    <td>
                        付款条件
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sMoneyContion" Width="98%" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td>
                        单据类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iPurType" Z_readOnly="True"
                            Z_Value="2" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <table id="table1" tablename="ProOrderOutD">
                    </table>
                </div>
                <div data-options="fit:true" title="工序外加工">
                    <table id="table2" tablename="ProOrderOutDSerial">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
