<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {

            Page.Children.toolBarBtnDisabled("table2", "add");
            Page.Children.toolBarBtnDisabled("table2", "copy");
            Page.Children.toolBarBtnDisabled("table2", "delete");

        });
        Page.afterLoad = function () {
            var sqlObj = {
                TableName: "bscdataperson",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sJobRole",
                        ComOprt: "like",
                        Value: "'%工艺员%'",
                        LinkOprt: 'and'
                    },
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + Page.userid + "'"
                    }
                ]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                Page.setFieldDisabled("sRemark");
                Page.setFieldDisabled("sMark");

            } else {
                Page.setFieldDisabled("sFlowerCode");
                Page.setFieldDisabled("sColour");
                Page.setFieldDisabled("sModelType");
                Page.setFieldDisabled("sCoilingWale");
                Page.setFieldDisabled("fUpDensity");
                Page.setFieldDisabled("iSumQty");
                Page.setFieldDisabled("fProPrice");
                Page.setFieldDisabled("sRemark1");
                Page.setFieldDisabled("fFlowerDistance");
                Page.setFieldDisabled("sContent");
                Page.setFieldDisabled("fWeftDistance");
                Page.setFieldDisabled("sElements");
                Page.setFieldDisabled("iYear");

                Page.Children.onBeforeEdit = function (tableid, index, row) {
                    if (tableid == "table4") {
                        return false;
                    }
                }

                Page.Children.toolBarBtnDisabled("table4", "add");
                Page.Children.toolBarBtnDisabled("table4", "copy");
                Page.Children.toolBarBtnDisabled("table4", "delete");
            }

        }
        Page.beforeSave = function () {
            if (Page.usetype == "modify") {
                Page.setFieldValue("dInputDate", Page.getNowDate() + ' ' + Page.getNowTime());
                Page.setFieldValue("sUserid", Page.userid);
            }
            if (Page.usetype == "add") {
                var sqlObj = {
                    TableName: "bscDataMat",
                    Fields: "1",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sCode",
                            ComOprt: "=",
                            Value: "'" + Page.getFieldValue("sCode") + "'",
                            LinkOprt: 'and'
                        },
                        {
                            Field: "iRecNo",
                            ComOprt: "<>",
                            Value: Page.key
                        }
                    ]
                };
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    alert("产品型号不允许重复");
                    return false;
                }
                /*var sqlObj = {
                    TableName: "bscDataMat",
                    Fields: "1",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sFlowerCode",
                            ComOprt: "=",
                            Value: "'" + Page.getFieldValue("sFlowerCode") + "'",
                            LinkOprt: 'and'
                        },
                        {
                            Field: "iRecNo",
                            ComOprt: "<>",
                            Value: Page.key
                        }
                    ]
                };
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    alert("花本型号不允许重复");
                    return false;
                }*/
            }

        }
        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpBscDataMatCalcIden",
                StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result);
            }
        }
        Page.Children.onAfterEdit = function () {
            var rows = $("#table4").datagrid("getRows");
            var totalJX = 0.00;
            var totalWX = 0.00;
            var headJX = 0;
            for (i = 0; i < rows.length; i++) {
                if (rows[i].iType == 0) {
                    headJX += parseInt(rows[i].iHead);
                    totalJX += parseFloat(rows[i].fGramWeight);

                }
                if (rows[i].iType == 1) {
                    totalWX += parseFloat(rows[i].fGramWeight);
                }
            }
            Page.setFieldValue("iYarnQty", headJX);

            for (j = 0; j < rows.length; j++) {
                if (rows[j].iType == 0) {
                    var material = parseFloat(rows[j].fGramWeight) / totalJX * 100;
                    $("#table4").datagrid("updateRow", { index: j, row: { sMaterial: material } });
                }
                if (rows[j].iType == 1) {
                    var material = parseFloat(rows[j].fGramWeight) / totalWX * 100;
                    $("#table4").datagrid("updateRow", { index: j, row: { sMaterial: material } });
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="花本型号" data-options="border:false">
            <div data-options="region:'north'" style="overflow: hidden;">
                <br />
                <div id="divHiden" style="display: none;">
                    <!--隐藏字段位置-->
                    <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="sInputUserName" runat="server" />
                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="2" />
                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iWarp" Z_Value="2" />
                </div>
                <table align="center">
                    <tr>
                        <td colspan="8" style="font-family: 华文隶书; font-size: 20px">产品信息
                        </td>
                    </tr>
                    <tr>
                        <td colspan='10'>
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <table align="center">
                                    <tr>
                                        <td>产品型号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sCode" />
                                        </td>
                                        <td>产品定位
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sClassID" />
                                        </td>
                                        <td width="50px">产品所属
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sProductBelong" />
                                        </td>
                                        <td>整卷价
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fSalePrice" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>

                                    </tr>
                                    <tr>

                                        <td>散剪费
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fSjPrice" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>
                                        <td>供应商色号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sSupplierColorID" />
                                        </td>
                                        <td>供应商型号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sWholeStyleNo" />
                                        </td>
                                        <td>采购成本
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fPurPrice" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>

                                    </tr>
                                    <tr>

                                        <td>采购散剪费
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fPurSjPrice" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>
                                        <td>最大库存
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fHighQty" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>
                                        <td>最小库存
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="fLowQty" Z_FieldType="数值" Z_decimalDigits="2" />
                                        </td>
                                        <td>
                                            计量单位
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sUnitName" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>品 牌
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sMark" />
                                        </td>
                                        <td>年 份
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iYear" />
                                        </td>
                                    </tr>
                                    <tr>

                                        <td>备 注
                                        </td>
                                        <td colspan="3">
                                            <textarea name="sRemark" fieldid="sRemark" style="border-bottom: 1px solid black; width: 99%; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>

                </table>
                <table align="center">
                    <tr>
                        <td colspan="8" style="font-family: 华文隶书; font-size: 20px">花本型号
                        </td>
                    </tr>
                    <tr>
                        <td colspan='10'>
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <table align="center">

                                    <tr>

                                        <td>花本型号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sFlowerCode" />
                                        </td>
                                        <td>整经色号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox51" runat="server" Z_FieldID="sColour" />
                                        </td>
                                        <td>生厂商家
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                                        </td>
                                        <td>机 型
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sModelType" />
                                        </td>
                                    </tr>
                                    <tr>



                                        <td>工 序
                                        </td>
                                        <td colspan="3">
                                            <cc1:ExtTextBox2 ID="ExtTextBox27" Width="360px" runat="server" Z_FieldID="sSerial" />
                                        </td>
                                        <td>花 距
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fFlowerDistance"/>
                                        </td>
                                        <td>纬 距
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fWeftDistance" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='10'>
                                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                                <table align="center">
                                                    <tr>
                                                        <td>成品纬密
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sCoilingWale" Z_FieldType="数值" Z_decimalDigits="2" />
                                                        </td>
                                                        <td>上机纬密
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="fUpDensity" Z_FieldType="数值" Z_decimalDigits="2" />
                                                        </td>
                                                        <td>总根数
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iYarnQty" Z_readOnly="True" Z_FieldType="数值" />
                                                        </td>
                                                        <td>针 数
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iSumQty" Z_FieldType="数值" Z_decimalDigits="0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>幅 宽
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fProductWidth" Z_FieldType="数值" />
                                                        </td>
                                                        <td>克 重
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fProductWeight" Z_FieldType="数值" />
                                                        </td>
                                                        <td>生产成本
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fProPrice" Z_Required="True" Z_FieldType="数值" Z_decimalDigits="2" />
                                                        </td>
                                                        <td>规 格
                                                        </td>
                                                        <td>
                                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sElements" />
                                                        </td>
                                                    </tr>
                                                    <tr>

                                                        <td>成 分
                                                        </td>
                                                        <td colspan="3">
                                                            <textarea name="sContent" fieldid="sContent" style="border-bottom: 1px solid black; width: 99%; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                                                        </td>

                                                    </tr>
                                                </table>
                                            </fieldset>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>制单人
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                                        </td>
                                        <td>制单时间
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                                        </td>
                                        <td>工艺备注
                                        </td>
                                        <td colspan="3">
                                            <textarea name="sRemark1" fieldid="sRemark1" style="border-bottom: 1px solid black; width: 99%; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                                        </td>
                                    </tr>

                                </table>
                            </fieldset>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="8">
                            <cc1:ExtImage ID="ExtImage1" runat="server" />
                        </td>
                    </tr>
                </table>

            </div>
        </div>
        <div title="纱线组成" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" data-options="fit:true">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div title="纱线组成">
                            <table id="table4" tablename="bscDataMatDWaste">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- <div title="加工工序" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center'" data-options="fit:true">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div title="加工工序">
                            <table id="table2" tablename="BscDataMatDSerial">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>
    </div>
</asp:Content>
