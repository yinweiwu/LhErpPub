<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var sGroupName = "";
        var sGroupID = "";
        $(function () {
            sGroupName = Page.getFieldValue('sGroupName');
            sGroupID = Page.getFieldValue('sGroupID');
        })

        Page.beforeSave = function () {
            var sOwnerGroupNo = Page.getFieldValue('sOwnerGroupNo');
            var iOwner = Page.getFieldValue('iOwner');
            if (sOwnerGroupNo == "" && iOwner == false) {
                $.messager.show({
                    title: '错误',
                    msg: '本厂尺码组不能为空！',
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
            else if (sOwnerGroupNo != "" && iOwner == true) {
                $.messager.show({
                    title: '错误',
                    msg: '是本厂尺不需要选择本厂尺码组！',
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

            var GroupName1 = Page.getFieldValue('sGroupName');
            var sqlObj = { TableName: "BscDataSizeM",
                Fields: "sGroupName",
                SelectAll: "True",
                Filters: [{ Field: "sGroupName", ComOprt: "=", Value: "'" + GroupName1 + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                if (sGroupName == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该尺码已存在！',
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
                    if (sGroupName != GroupName1) {
                        $.messager.show({
                            title: '错误',
                            msg: '该尺码已存在！',
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

            var GroupID1 = Page.getFieldValue('sGroupID');
            if (sGroupID != "" && GroupID1 != "" && sGroupID != GroupID1) {
                $.messager.show({
                    title: '错误',
                    msg: '尺码组编号不能修改！',
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

            var sqlObj1 = { TableName: "BscDataSizeM",
                Fields: "sGroupID",
                SelectAll: "True",
                Filters: [{ Field: "sGroupID", ComOprt: "=", Value: "'" + GroupID1 + "'"}]
            };
            var data1 = SqlGetData(sqlObj1);
            if (data1.length > 0) {
                if (sGroupID == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该尺码组编号已存在！',
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
                    if (sGroupID != GroupID1) {
                        $.messager.show({
                            title: '错误',
                            msg: '该尺码组编号已存在！',
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
        <div data-options="region:'north'" style="overflow: hidden;">
            <table class="tabmain">
                <tr>
                    <td>
                        编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sGroupID" />
                    </td>
                    <td>
                        名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sGroupName" />
                    </td>
                    <td>
                        客户
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iOwner" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox1">
                            是否本厂</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        本厂尺码组
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sOwnerGroupNo" />
                    </td>
                    <td>
                        停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                    <td style="display: none">
                        用户编号
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sUserID" />
                    </td>
                    <td style="display: none">
                        录入时间
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="100%" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="尺码明细">
                    <table id="table1" tablename="bscDataSizeD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
