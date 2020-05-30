<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table1", "copy");

            Page.Children.toolBarBtnAdd("table2", "print", "打印", "print", function () {
                var selectedRows = $("#table2").datagrid("getSelections");
                if (selectedRows.length > 0) {
                    var sMachineIDs = "";
                    for (var i = 0; i < selectedRows.length; i++) {
                        sMachineIDs += selectedRows[i].sMachineID + ",";
                    }
                    if (sMachineIDs.length > 0) {
                        sMachineIDs = sMachineIDs.substr(0, sMachineIDs.length - 1);
                    }
                    $.messager.confirm("您确认打印吗？", "您确认打印机台号【" + sMachineIDs + "】吗？", function (r) {
                        if (r) {
                            var dbTime = selectedRows[0].dDebugTime == "" || selectedRows[0].dDebugTime == null || selectedRows[0].dDebugTime == undefined ? "" : selectedRows[0].dDebugTime;
                            var urlParams = "pb_iRecNoD=" + selectedRows[0].iRecNo + "&pb_sMachine=" + sMachineIDs.replace(/#/g, "%23") +
                                "&pb_DbTime=" + dbTime + "&pb_sUserName=" + encodeURI(Page.username) + "&pb_dInputDate=" + Page.getNowDate() +
                                "";
                            var url = "/Base/PbPage.aspx?otype=show&iformid=8991&irecno=59&key=" + Page.key + "&" + urlParams + "&r=" + Math.random();
                            $("#ifrpb").attr("src", "");
                            $("#ifrpb").attr("src", url);
                        }
                    });

                }
            });
            Page.DoNotCloseWinWhenSave = true;

            if (Page.getFieldValue("sCode").indexOf("KF") > -1) {
                $("#isSample").show();
            }
        })
        Page.beforeLoad = function () {
            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj2 = { TableName: "vwSDOrderM_GMJ",
                    Fields: "sCode,sName,iBscDataFabRecNo,sBscDataFabCode,sBscDataFabName,sBscDataFabModelType,sBscDataFabRev,fBscDataFabWidth,fBscDataFabWeight,fProductWidth,fProductWeight,fFabQty,sRemark,sUserName,sRollWeight",
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
                Page.setFieldValue('sCode', data2[0].sCode);
                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('iBscDataFabRecNo', data2[0].iBscDataFabRecNo);
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);
                Page.setFieldValue('sBscDataFabName', data2[0].sBscDataFabName);
                Page.setFieldValue('fBscDataFabWidth', data2[0].fBscDataFabWidth);
                Page.setFieldValue('fBscDataFabWeight', data2[0].fBscDataFabWeight);
                Page.setFieldValue('sBscDataFabModelType', data2[0].sBscDataFabModelType);
                Page.setFieldValue('sBscDataFabRev', data2[0].sBscDataFabRev);
                Page.setFieldValue('fProductWidth', data2[0].fProductWidth);
                Page.setFieldValue('fProductWeight', data2[0].fProductWeight);
                Page.setFieldValue('fFabQty', data2[0].fFabQty);
                Page.setFieldValue("sOrderRemark", data2[0].sRemark);
                Page.setFieldValue("sUserName", data2[0].sUserName);
            }
        }
        Page.beforeSave = function () {
            $("#table1").removeAttr("tablename");
            $("#SDOrderDFab").removeAttr("tablename");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
            </div>
            <!--主表部分-->
            <div data-options="region:'north'" style="overflow: hidden;">
                <!--主表部分-->
                <table class="tabmain">
                    <tr>
                        <!--这里是主表字段摆放位置-->
                        <td>
                            生产单号
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sProOrderNo" Z_readOnly="True"
                                Z_NoSave="true" />
                        </td>
                        <td>
                            下单日期
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dProDate"
                                Z_readOnly="True" Z_NoSave="true" />
                        </td>
                        <td>
                            生产厂家
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataManufacturerRecNo"
                                Z_readOnly="True" Z_NoSave="true" />
                        </td>
                        <td>
                            订单号
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOrderNo" Z_readOnly="True"
                                Z_NoSave="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            成品编号
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="sCode" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            成品名称
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox214" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            成品幅度
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="fProductWidth" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            成品克重
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fProductWeight" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            坯布编号
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            坯布幅宽
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fBscDataFabWidth" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            机台型号
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sBscDataFabModelType"
                                Z_NoSave="True" Z_readOnly="True" />
                        </td>
                        <td>
                            订单数量
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                                Z_NoSave="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            坯布名称
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sBscDataFabName" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            坯布克重
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fBscDataFabWeight" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            转速
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBscDataFabRev" Z_NoSave="True"
                                Z_readOnly="True" />
                        </td>
                        <td>
                            生产交期
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期"
                                Z_NoSave="true" Z_readOnly="True" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            要求匹重
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="sRollWeight" Z_readOnly="True" runat="server"
                                Z_NoSave="true" />
                        </td>
                        <td>
                            订单制单人
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox212" Z_FieldID="sUserName" Z_readOnly="True" runat="server"
                                Z_NoSave="true" />
                        </td>
                        <td>
                            订单备注
                        </td>
                        <td colspan="3">
                            <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="338px" Z_FieldID="sOrderRemark"
                                Z_NoSave="True" Z_readOnly="True" />
                        </td>
                    </tr>
                    <tr>
                        <%--<td>
                        进纱路数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iBscDataFabYarnQty"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>--%>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iPurchaseStatus" Z_NoSave="true"
                                Z_disabled="true" />
                            <label for="__ExtCheckbox1">
                                是否采购</label>
                        </td>
                        <td colspan="2">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iProLKFXStatus" Z_NoSave="true"
                                Z_disabled="true" />
                            <label for="__ExtCheckbox2">
                                是否留开幅线</label>
                        </td>
                        <td>
                            带刨类型
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sProDaiPao" Z_NoSave="true"
                                Z_readOnly="true" />
                        </td>
                        <td>
                            纸管类型
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sLightSources" Z_NoSave="true"
                                Z_readOnly="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            投坯重量
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fFabQty" Z_NoSave="true"
                                Z_FieldType="数值" Z_readOnly="True" Z_decimalDigits="2" />
                        </td>
                        <td>
                            外加工重量
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fOutProduceQty" Z_NoSave="true"
                                Z_FieldType="数值" Z_readOnly="True" Z_decimalDigits="2" />
                        </td>
                        <td>
                            生产重量
                        </td>
                        <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_NoSave="true" Z_FieldID="fProduceQty"
                                Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                        </td>
                        <td colspan="2" id="isSample" style=" display:none;">
                            <span style=" color:Red; font-size:20px; font-weight:bold;">样品开发</span>
                        </td>
                    </tr>
                </table>
                <table class="tabmain">
                    <tr>
                        <td class="style2">
                            备注
                        </td>
                        <td class="style1">
                            <textarea id="sProReMark" readonly="readonly" nosave="true" style="border-bottom: 1px solid black;
                                width: 839px; border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                                border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                                border-top-style: none; border-top-color: inherit; border-top-width: 0px;" fieldid="sProReMark"></textarea>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="机台明细">
                    <!--  子表1  -->
                    <table id="table2" tablename="SDOrderDMachine">
                    </table>
                </div>
                <div data-options="fit:true" title="用料明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDOrderDPro">
                    </table>
                </div>
                <div data-options="fit:true" title="坯布要求">
                    <!--  子表2  -->
                    <table id="SDOrderDFab" tablename="SDOrderDFab">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
