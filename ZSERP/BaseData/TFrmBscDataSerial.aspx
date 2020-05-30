<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var sSerialID = "";
        var sSerialName = "";
        $(function () {
            sSerialID = Page.getFieldValue('sSerialID');
            sSerialName = Page.getFieldValue('sSerialName');
        })
        Page.beforeInit = function () {
            var ScreenWidth = window.screen.width;
            if (ScreenWidth == "1280") {
                $("#DataSerialD").width("360px");
            }
        }
        Page.beforeSave = function () {
            var SerialID1 = Page.getFieldValue('sSerialID');
            var sqlObj = { TableName: "bscDataSerial",
                Fields: "sSerialID",
                SelectAll: "True",
                Filters: [{ Field: "sSerialID", ComOprt: "=", Value: "'" + SerialID1 + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                if (sSerialID == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该工序号已存在！',
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
                else {
                    if (sSerialID != SerialID1) {
                        $.messager.show({
                            title: '错误',
                            msg: '该工序号已存在！',
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

            var SerialName1 = Page.getFieldValue('sSerialName');
            var sqlObj1 = { TableName: "bscDataSerial",
                Fields: "sSerialName",
                SelectAll: "True",
                Filters: [{ Field: "sSerialName", ComOprt: "=", Value: "'" + SerialName1 + "'"}]
            };
            var data1 = SqlGetData(sqlObj1);
            if (data1.length > 0) {
                if (sSerialName == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该工序名称已存在！',
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
                else {
                    if (sSerialName != SerialName1) {
                        $.messager.show({
                            title: '错误',
                            msg: '该工序名称已存在！',
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'">
            <br />
            <table align="center" width="80%">
                <tr>
                    <td>
                        工序号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sSerialID" Z_Required="True" />
                    </td>
                    <td>
                        工序名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sSerialName" Z_Required="True" />
                    </td>
                    <td>
                        生产顺序
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iProSerial" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div data-options="region:'center',title:'',border:false">
                <table class="tabmain">
                    <tr>
                        <td colspan="6">
                            <div class="easyui-panel" data-options="title:'工序属性'" style="width: 700px; text-align: center;
                                vertical-align: middle;">
                                <table align="center">
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iProgress" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox21">
                                                是否进度统计</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox22" runat="server" Z_FieldID="iNoProduce" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox22">
                                                不生成工票</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox23" runat="server" Z_FieldID="iSalary" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox23">
                                                是否计件工资</label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td rowspan="8">
                            <div id="DataSerialD" class="easyui-panel" data-options="title:'工序不合格原因'" style="width: 500px;
                                height: 350px; text-align: center; vertical-align: middle;">
                                <table id="table1" tablename="bscDataSerialD">
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div class="easyui-panel" data-options="title:'工序权限'" style="padding: 5px; width: 700px;
                                text-align: center; vertical-align: middle;">
                                <table align="center" style="width: 450px">
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox24" runat="server" Z_FieldID="iDefault" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox24">
                                                是否大货默认工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox25" runat="server" Z_FieldID="iSample" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox25">
                                                是否样品默认工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox26" runat="server" Z_FieldID="iControlStyle" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox26">
                                                是否控制生产顺序</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox30" runat="server" Z_FieldID="iImportant" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox30">
                                                是否重要工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox32" runat="server" Z_FieldID="iCheck" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox32">
                                                是否检验工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox27" runat="server" Z_FieldID="iWorkShopFinish" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox27">
                                                是否车间完成工序</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox31" runat="server" Z_FieldID="iPart" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox31">
                                                是否配件工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox29" runat="server" Z_FieldID="iMatWaste" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox29">
                                                是否用料工序</label>
                                        </td>
                                        <td>
                                            <cc1:ExtCheckbox2 ID="ExtCheckbox28" runat="server" Z_FieldID="iStock" />
                                        </td>
                                        <td>
                                            <label for="__ExtCheckbox28">
                                                是否库存工序</label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div class="easyui-panel" data-options="title:'其他属性'" style="padding: 5px; text-align: center;
                                vertical-align: middle; width: 700px;">
                                <table>
                                    <tr>
                                        <td>
                                            前道工序1
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sPreSerialID1" />
                                        </td>
                                        <td>
                                            前道工序2
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sPreSerialID2" />
                                        </td>
                                        <td>
                                            前道控制模式
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iControlQty" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            打印顺序
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iPrintSerial" Z_FieldType="整数" />
                                        </td>
                                        <td>
                                            标准工时
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="fTime" />
                                        </td>
                                        <td>
                                            标准工价
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="fPrice" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            最高库存
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="iHighQty" Z_FieldType="整数" />
                                        </td>
                                        <td>
                                            安全库存
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iSafeQty" Z_FieldType="整数" />
                                        </td>
                                        <td>
                                            最低库存
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="iLowQty" Z_FieldType="整数" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            所属车间类型
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="iWork" />
                                        </td>
                                        <td>
                                            备注
                                        </td>
                                        <td colspan="3">
                                            <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="98%" Z_FieldID="sReMark" />
                                        </td>
                                    </tr>
                                    <tr style="display: none">
                                        <td>
                                            制单人
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                                        </td>
                                        <td>
                                            制单时间
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                                                Z_readOnly="True" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
