<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            var bscdataStyleMRecNo = Page.getFieldValue('iBscdataStyleMRecNo');
            var sqlobj = { TableName: "vwbscDataStyleM",
                Fields: "sCustStyleNo,sStyleName",
                SelectAll: "True",
                Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + bscdataStyleMRecNo + "'"}]
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                Page.setFieldValue('sCustStyleNo', data[0].sCustStyleNo);
                Page.setFieldValue('sStyleName', data[0].sStyleName);
            }
            if (Page.usetype == "add") {
                var orderType = getQueryString("iOrderType");
                Page.setFieldValue("iOrderType", orderType);
                Page.setFieldValue("sSizeGroupID", "0901");
            }
        })
        Page.Children.onAfterAddRow = function () {
            var bscdataStyleMRecNo = Page.getFieldValue('iBscdataStyleMRecNo');
            if (bscdataStyleMRecNo != "") {
                var opts = $('#table1').datagrid('getRows');
                var Rowlength = opts.length - 1;
                $('#table1').datagrid('updateRow', {
                    index: Rowlength,
                    row: { iBscDataStyleMRecNo: bscdataStyleMRecNo }
                });
            }
            //            else {
            //                $.messager.show({
            //                    title: '提示',
            //                    msg: '请先选择款号！',
            //                    timeout: 1000,
            //                    showType: 'show',
            //                    style: {
            //                        right: '',
            //                        top: document.body.scrollTop + document.documentElement.scrollTop,
            //                        bottom: ''
            //                    }
            //                });
            //                var opts = $('#table1').datagrid('getRows');
            //                var Rowlength = opts.length - 1;
            //                $('#table1').datagrid('deleteRow', Rowlength);
            //            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'">
            <br />
            <table align="center" style="width: 80%">
                <tr>
                    <td>
                        打样单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sOrderNo" Z_readOnly="True" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        签单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox41" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iBscdataStyleMRecNo" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="打样信息" style="padding: 20px;">
                    <table class="tabmain">
                        <tr>
                            <td>
                                样品类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox40" runat="server" Z_FieldID="sSampleType" />
                            </td>
                            <td>
                                客户款号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sCustStyleNo" Z_Required="False"
                                    Z_NoSave="True" Z_readOnly="True" />
                            </td>
                            <td>
                                款式名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="sStyleName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                版本号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox42" runat="server" Z_FieldID="sLabelNo" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                制版类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sPaperType" />
                            </td>
                            <td>
                                参照款号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sFromStyleNo" />
                            </td>
                            <td>
                                图纸条码
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox43" runat="server" Z_FieldID="sPictureBarCode" />
                            </td>
                            <td>
                                原样衣条码
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox44" runat="server" Z_FieldID="sClothBarCode" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                尺码组
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSizeGroupID" />
                            </td>
                            <td>
                                订单交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期"
                                    Z_Required="True" />
                            </td>
                            <td>
                                主料类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="sMatType" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                业务员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sSaleID" />
                            </td>
                            <td>
                                部门
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sDeptID" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="98%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                订单数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iQty" Z_FieldType="数值"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                订单金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="fTotal" Z_FieldType="数值"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                样品订单
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iOrderType" Z_Value="2" />
                            </td>
                            <td>
                                纸样师
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sPaperID" />
                            </td>
                        </tr>
                    </table>
                    <div style="width: 76%; height: 400px">
                        <table id="table1" tablename="SDContractD">
                        </table>
                    </div>
                </div>
                <div data-options="fit:true" title="款式图" style="padding: 20px;">
                    <table align="center">
                        <tr>
                            <td style="font-family: 华文隶书; font-size: 20px">
                                原样衣图片
                            </td>
                            <td style="font-family: 华文隶书; font-size: 20px">
                                样衣图片
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="图片" Z_ImageHeight="200" Z_ImageWidth="200"
                                    Z_Height="230" Z_Width="350"></cc1:ExtFile>
                            </td>
                            <td>
                                <cc1:ExtFile ID="ExtFile2" runat="server" Z_FileType="图片" Z_ImageHeight="200" Z_ImageWidth="200"
                                    Z_Height="230" Z_Width="350"></cc1:ExtFile>
                            </td>
                        </tr>
                    </table>
                    <div style="width: 76%; height: 400px">
                        <table id="table2" tablename="SDContractDAsk">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
