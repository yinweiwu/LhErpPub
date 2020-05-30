<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                var sqlObj = {
                    //表名或视图名
                    TableName: "bscDataPeriod",
                    //选择的字段
                    Fields: "sYearMonth",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            //左括号
                            //字段名
                            Field: "convert(varchar(50),GETDATE(),23)",
                            //比较符
                            ComOprt: ">=",
                            //值
                            Value: "dBeginDate",
                            //连接符
                            LinkOprt: "and"
                        },
                                {
                                    Field: "convert(varchar(50),GETDATE(),23)",
                                    ComOprt: "<=",
                                    Value: "dEndDate"
                                }
                        ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }
            }
        })

        Page.afterSave = function () {
            if (Page.usetype == "add") {
                var jsonobj = {
                    StoreProName: "SpBuildBatchNo",
                    StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@iType",
                        Value: 1
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="2" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iMatType" Z_Value="2" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        入库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="150px" />
                    </td>
                    <td>
                        仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Width="150px" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Width="150px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        缸号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBatchNo" Width="150px" />
                    </td>
                    <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sBscDataPersonID" Width="150px" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td style="margin-left: 40px">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox21">
                            红冲</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        存货编码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iBscDataMatRecNo" Width="150px" />
                    </td>
                    <td>
                        存货名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" Width="150px" />
                    </td>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="iBscDataColorRecNo"
                            Width="150px" />
                    </td>
                    <td>
                        颜色
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                            Z_readOnly="True" Width="150px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        染色加工厂
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox218" runat="server" Width="150px" Z_FieldID="sCustShortName"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox219" runat="server" Width="150px" Z_FieldID="sOrderNo"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                    <td>
                        入库数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <%--<td>
                        入库单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sCompany" />
                    </td>--%>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="340px" Z_FieldID="sReMark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="150px" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--  子表1  -->
                    <table id="MMStockProductInD" tablename="MMStockProductInD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
