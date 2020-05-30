<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var sColorName = "";
        var sColorID = "";
        $(function () {
            sColorName = Page.getFieldValue('sColorName');
            sColorID = Page.getFieldValue('sColorID');
        })

        Page.beforeSave = function () {
//            var ColorName1 = Page.getFieldValue('sColorName');
//            var sqlObj = { TableName: "BscDataColor",
//                Fields: "sColorName",
//                SelectAll: "True",
//                Filters: [{ Field: "sColorName", ComOprt: "=", Value: "'" + ColorName1 + "'"}]
//            };
//            var data = SqlGetData(sqlObj);
//            if (data.length > 0) {
//                if (sColorName == "") {
//                    $.messager.show({
//                        title: '错误',
//                        msg: '该颜色已存在！',
//                        timeout: 1000,
//                        showType: 'show',
//                        style: {
//                            right: '',
//                            top: document.body.scrollTop + document.documentElement.scrollTop,
//                            bottom: ''
//                        }
//                    });
//                    return false;
//                }
//                else {
//                    if (sColorName != ColorName1) {
//                        $.messager.show({
//                            title: '错误',
//                            msg: '该颜色已存在！',
//                            timeout: 1000,
//                            showType: 'show',
//                            style: {
//                                right: '',
//                                top: document.body.scrollTop + document.documentElement.scrollTop,
//                                bottom: ''
//                            }
//                        });
//                        return false;
//                    }
//                }
//            }

//            var ColorID1 = Page.getFieldValue('sColorID');

//            if (ColorID1 != "") {
//                //                var sqlobj1 = { TableName: "bscDataPerson",
//                //                    Fields: "iSupper",
//                //                    SelectAll: "True",
//                //                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
//                //                }
//                //                var data1 = SqlGetData(sqlobj1);
//                //                if (data1.length > 0) {
//                //                    if (data1[0].iSupper != "1" || Page.userid != "master") {
//                //                        if (sCode != Code1) {
//                //                            $.messager.show({
//                //                                title: '错误',
//                //                                msg: '修改颜色名称请联系超级用户！',
//                //                                timeout: 1000,
//                //                                showType: 'show',
//                //                                style: {
//                //                                    right: '',
//                //                                    top: document.body.scrollTop + document.documentElement.scrollTop,
//                //                                    bottom: ''
//                //                                }
//                //                            });
//                //                            return false;
//                //                        }
//                //                    }
//                //                }
//            }

//            if (ColorID1 != "") {
//                var sqlObj1 = { TableName: "BscDataColor",
//                    Fields: "sColorID",
//                    SelectAll: "True",
//                    Filters: [{ Field: "sColorID", ComOprt: "=", Value: "'" + ColorID1 + "'"}]
//                };
//                var data1 = SqlGetData(sqlObj1);
//                if (data1.length > 0) {
//                    if (sColorID == "") {
//                        $.messager.show({
//                            title: '错误',
//                            msg: '该色号已存在！',
//                            timeout: 1000,
//                            showType: 'show',
//                            style: {
//                                right: '',
//                                top: document.body.scrollTop + document.documentElement.scrollTop,
//                                bottom: ''
//                            }
//                        });
//                        return false;
//                    }
//                    else {
//                        if (sColorID != ColorID1) {
//                            $.messager.show({
//                                title: '错误',
//                                msg: '该色号已存在！',
//                                timeout: 1000,
//                                showType: 'show',
//                                style: {
//                                    right: '',
//                                    top: document.body.scrollTop + document.documentElement.scrollTop,
//                                    bottom: ''
//                                }
//                            });
//                            return false;
//                        }
//                    }
//                }
//            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center'" style="overflow: hidden;">
            <div>
                <img src="../../images/colorimg.png" />
                <div style="margin: -28px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 30px; margin: 8px auto">
                    <span style="font-family: 黑体; font-size: 15px">颜色信息</span>
                </div>
            </div>
            <br />
            <table class="tabmain" style="height: 300px">
                <tr>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sColorID" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong style="color: Red">颜色名称</strong>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sColorName" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        颜色英文名
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sEngColorName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        条码标识
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBarCode" />
                    </td>
                </tr>
                <tr>
                    <td>
                        停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="80%" />
                    </td>
                </tr>
                <tr>
                    <td>
                        用户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
