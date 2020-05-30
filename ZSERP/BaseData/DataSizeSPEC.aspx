<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">

        var Spec = "";
        var sClassID = "";
        var DataSize = [];
        $(function () {
            Spec = Page.getFieldValue('Spec');
            sClassID = Page.getFieldValue('sClassID');
            if (Spec == "") {
                Page.toolBarBtnAdd("SizeBtn", "尺码转入保存", "save", function () {
                    var SizeSelect = Page.getFieldValue('SizeSelect');
                    var sClassID2 = Page.getFieldValue('sClassID');
                    if (sClassID2 != "" && SizeSelect != "") {

                        var sqlObj = { TableName: "BscDataSize",
                            Fields: "sClassID,sParentID",
                            SelectAll: "True",
                            Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + sClassID2 + "'"}]
                        };
                        var data = SqlGetData(sqlObj);
                        var max = 0;
                        var PraentID = "";
                        if (data.length > 0) {
                            max = data[0].sParentID;
                            for (var i = 0; i < data.length; i++) {
                                if (max < data[i].sParentID) {
                                    max = data[i].sParentID;
                                }
                            }
                            max++;
                            PraentID = "0" + max;
                        }
                        else {
                            PraentID = sClassID2 + "01";
                        }
                        Page.setFieldValue('sParentID', PraentID);

                        var arr = SizeSelect.split(',');
                        for (var i = 0; i < arr.length; i++) {
                            var jsonobj = {
                                StoreProName: "spSizeCheck",
                                StoreParms: [{
                                    ParmName: "@sSizeName",
                                    Value: arr[i]
                                }, {
                                    ParmName: "@sClassID",
                                    Value: sClassID2
                                }]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result && result.length > 0 && result != "1") {
                                $.messager.show({
                                    title: '错误',
                                    msg: arr[i] + result,
                                    timeout: 1000,
                                    showType: 'show',
                                    style: {
                                        right: '',
                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                                        bottom: ''
                                    }
                                });
                                return false;
                                break;
                            }
                            else {
                                DataSize.push(arr[i]);
                            }
                        }
                        if (DataSize.length == arr.length) {
                            for (var j = 0; j < arr.length; j++) {
                                Page.setFieldValue('Spec', arr[j]);
                                var result = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                                if (result.indexOf("error") > -1) {
                                    $.messager.alert("错误", result);
                                    return false;
                                }
                                else {
                                    var jsonobj = {
                                        StoreProName: "SpGetIden",
                                        StoreParms: [{
                                            ParmName: "@sTableName",
                                            Value: "BscDataSize"
                                        }]
                                    }
                                    var Result = SqlStoreProce(jsonobj);
                                    if (Result && Result.length > 0 && Result != "0") {
                                        $('#FieldKeyValue').val(Result);
                                    }
                                }
                                if (j + 1 == arr.length) {
                                    window.returnValue = "1";
                                    alert("保存成功！");
                                    window.parent.CloseBillWindow();
                                    window.parent.GridRefresh();
                                }
                            }
                        }
                        else {
                            $.messager.show({
                                title: '提示',
                                msg: "请刷新页面！",
                                timeout: 1000,
                                showType: 'show',
                                style: {
                                    right: '',
                                    top: document.body.scrollTop + document.documentElement.scrollTop,
                                    bottom: ''
                                }
                            });
                        }
                    }
                    else {
                        $.messager.show({
                            title: '提示',
                            msg: "类别、规格名称（尺码转入）不能为空！",
                            timeout: 1200,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        return false;
                    }
                })
            }
            else {
                $("#aa").hide();
                $("#bb").hide();
                $("#__ExtTextBox21").combobox('disable');
                //$("#__ExtTextBox21").attr("readonly", "readonly");
            }
        })

        Page.beforeSave = function () {
            var ClassID1 = Page.getFieldValue('sClassID');
            var Spec1 = Page.getFieldValue('Spec');

            if (Spec != "") {
                var sqlobj1 = { TableName: "bscDataPerson",
                    Fields: "iSupper",
                    SelectAll: "True",
                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
                }
                var data1 = SqlGetData(sqlobj1);
                if (data1.length > 0) {
                    if (data1[0].iSupper != "1" || Page.userid != "master") {
                        if (Spec != Spec1) {
                            $.messager.show({
                                title: '错误',
                                msg: '修改款号或尺码组请联系超级用户！',
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

            var sqlObj = { TableName: "BscDataSize",
                Fields: "sClassID,sParentID",
                SelectAll: "True",
                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + ClassID1 + "'"}]
            };
            var data = SqlGetData(sqlObj);
            var max = 0;
            var PraentID = "";
            if (data.length > 0) {
                max = data[0].sParentID;
                for (var i = 0; i < data.length; i++) {
                    if (max < data[i].sParentID) {
                        max = data[i].sParentID;
                    }
                }
                max++;
                PraentID = "0" + max;
            }
            else {
                PraentID = ClassID1 + "01";
            }
            Page.setFieldValue('sParentID', PraentID);

            var sqlObj1 = { TableName: "vwBscDataSize",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ LeftParenthese: "(", Field: "sParentID", ComOprt: "=", Value: "'" + ClassID1 + "'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sName", ComOprt: "=", Value: "'" + Spec1 + "'"}]
            };
            var data1 = SqlGetData(sqlObj1);
            if (data1.length > 0) {
                if (Spec == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该规格已存在！',
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
                    if (Spec != Spec1) {
                        $.messager.show({
                            title: '错误',
                            msg: '该规格已存在！',
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
        <div data-options="region:'center'" style="overflow: hidden;">
            <table class="tabmain">
                <tr>
                    <td>
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                    <td>
                        规格名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="Spec" Z_Required="True"
                            Z_RequiredTip="规格名称不能为空" />
                    </td>
                </tr>
                <tr>
                    <td style="display: none">
                        编号
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sParentID" />
                    </td>
                    <td>
                        停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                    <td id="aa">
                        规格名称（尺码转入）
                    </td>
                    <td id="bb">
                        <input lookupoptions="[{lookupName:'DataSizeSPECSelect',width:600,height:400,fields:'*',searchFields:'*',isMulti:true,fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                            type="text" id="ExtTextBox10" runat="server" style="width: 150px" fieldid="SizeSelect"
                            nosave="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="100%" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td>
                        用户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
