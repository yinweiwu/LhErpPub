<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        Page.beforeSave = function () {
            var sqlObj1 = {
                TableName: "BscDataFlowerType",
                Fields: "iRecNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sFlowerTypeID", ComOprt: "=", Value: "'" + Page.getFieldValue("sFlowerTypeID") + "'", LinkOprt: "and"
                    }, {
                        Field: "iRecNo", ComOprt: "<>", Value: "'" + Page.key + "' and iBscDataProcessesMRecNo='" + Page.getFieldValue("iBscDataProcessesMRecNo") + "'"
                    }
                ]
            }
            var result1 = SqlGetData(sqlObj1);
            if (result1.length > 0) {
                Page.MessageShow("同工序的花型编号不能重量", "同工序的花型编号不能重量");
                return false;
            }
        }
        $(function () {
            window.setTimeout(function () {
                var treeid = Page.getQueryString("treeid")
                if (treeid != "") {
                    var sqlObj1 = {
                        TableName: "BscDataProcessesM",
                        Fields: "iRecNo",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sProcessesCode", ComOprt: "=", Value: "'" + treeid + "'"
                            }
                        ]
                    }
                    var result1 = SqlGetData(sqlObj1);
                    if (result1.length > 0) {
                        Page.setFieldValue("iBscDataProcessesMRecNo", result1[0].iRecNo);
                    }
                }
            }, 1000)
            
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        工艺编号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sFlowerTypeID" />
                    </td>
                    <td>
                        工艺名称
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="sFlowerType" />
                    </td>
                    <td>
                        工序
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="iBscDataProcessesMRecNo" />
                    </td>
                   <%-- <td>
                        花型英文名称
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="sFlowerTypeEnglish" />
                    </td>--%>
                    
                </tr>
                <tr>
                    <td>
                        套色号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox5" runat="server" z_fieldid="sCoverColorID" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="iBscDataCustomerRecNo" />
                    </td>

                </tr>
                <tr>
                    <td>
                        加工厂代码
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox6" runat="server" z_fieldid="sProduceCode" />
                    </td>
                    <td>
                        加工厂
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox7" runat="server" z_fieldid="iProduceBscDataCustomerRecNo" />
                    </td>

                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" z_fieldid="sRemark" />
                    </td>
                    <td>
                        制单人</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_readOnly="true" Z_FieldID="sUserID" />
                    </td>
                    <td>
                        制单时间</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_readOnly="true" Z_FieldType="时间" Z_FieldID="dInputDate" />
                    </td>
                    
                </tr>
                <tr>
                    <td rowspan="10" colspan="4" >
                        <cc1:ExtImage runat="server"  />

                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
