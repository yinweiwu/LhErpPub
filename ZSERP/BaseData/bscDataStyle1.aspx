<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var sStyleName = "";
        var sStyleNo = "";
        var sSizeGroupID = "";
        var sClassID = "";

        $(function () {
            var PF = false; //批发价权限
            var LS = false; //零售价权限
            var KH = false; //客户价权限
            //获取权限
            var sqlObj = { TableName: "View_Yww_UserRight_Unique",
                Fields: "sRightDetail",
                SelectAll: "True",
                Filters: [{ Field: "iSystemMenuID", ComOprt: "=", Value: "103", LinkOprt: "and" },
                { Field: "iFormID", ComOprt: "=", Value: "7001", LinkOprt: "and" },
                                    { Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].sRightDetail == "批发价显示") {
                        PF = true;
                    }
                    else if (data[i].sRightDetail == "零售价显示") {
                        LS = true;
                    }
                    else if (data[i].sRightDetail == "客户价显示") {
                        KH = true;
                    }
                }
            }

            if (PF == false) {
                $('#tt').tabs('close', '批发价');
            }
            if (LS == false) {
                $('#tt').tabs('close', '零售价');
            }
            if (KH == false) {
                $('#tt').tabs('close', '客户价');
            }

            Page.Children.toolBarBtnDisabled("table5", "add");
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table2", "add");
            Page.Children.toolBarBtnDisabled("table6", "add");
            Page.Children.toolBarBtnDisabled("table6", "copy");
            //Page.Children.toolBarBtnDisabled("table6", "delete");

            sClassID = Page.getFieldValue('sClassID');
            sStyleNo = Page.getFieldValue('sStyleNo');
            sStyleName = Page.getFieldValue('sStyleName');
            sSizeGroupID = Page.getFieldValue('sSizeGroupID');
            setTimeout(getClassID, 1001); //延后执行

            Page.toolBarBtnAdd("mybtn", "批发价总成本核对", "ok", function () {
                var FT1 = Page.getFieldValue('fFabTotal');
                var FT2 = Page.getFieldValue('fAccTotal');
                var FT3 = Page.getFieldValue('fOtherTotal');
                var FT4 = Page.getFieldValue('fProTotal');
                var total = Number(FT1) + Number(FT2) + Number(FT3) + Number(FT4);
                Page.setFieldValue('fCostTotal', total);
            })
        })

        function getClassID() {
            var ClassID = Page.getFieldValue('sClassID');
            if (sClassID == "") {
                var ClassName = $('#__ExtTextBox3').textbox('getText');
                Page.setFieldValue('sStyleName', ClassName);
                Page.Children.toolBarBtnDisabled("table6", "delete");
                var sqlobj1 = { TableName: "bscDataClassPropertyM",
                    Fields: "iRecNo as PropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + ClassID + "'"}],
                    Sorts: [{
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }]
                };
                var data1 = SqlGetData(sqlobj1);
                if (data1.length > 0) {
                    for (var i = 0; i < data1.length; i++) {
                        Page.tableToolbarClick("add", "table6", data1[i]);
                    }
                }
            }
            else {
                var result = $('#table6').datagrid('getRows');
                var sqlobj = { TableName: "bscDataClassPropertyM",
                    Fields: "iRecNo as PropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'"}],
                    Sorts: [{
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }]
                };
                var data = SqlGetData(sqlobj);
                if (data.length != result.length) {
                    for (var i = 0; i < data.length; i++) {
                        Page.tableToolbarClick("add", "table6", data[i]);
                    }
                }
                else {
                    Page.Children.toolBarBtnDisabled("table6", "delete");
                }
            }
        }

        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "129") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sSizeName == row.sSizeName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "131") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sColorName == row.sColorName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "133") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sColorName == row.sColorName && rows[i].sSizeName == row.sSizeName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "137") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sStockName == row.sStockName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "139") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sStockName == row.sStockName && rows[i].sSizeName == row.sSizeName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "141") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sStockName == row.sStockName && rows[i].sColorName == row.sColorName) {
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
                        return false;
                    }
                }
            }
            else if (uniqueid == "143") {
                var rows = $("#table1").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].sStockName == row.sStockName && rows[i].sSizeName == row.sSizeName && rows[i].sColorName == row.sColorName) {
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
                        return false;
                    }
                }
            }
        }

        Page.beforeSave = function () {
            var StyleNo1 = Page.getFieldValue('sStyleNo');

            if (Page.usetype == "modify") {
                if (sStyleNo != "") {
                    var SizeGroupID1 = Page.getFieldValue('sSizeGroupID');
                    var sqlobj1 = { TableName: "bscDataPerson",
                        Fields: "iSupper",
                        SelectAll: "True",
                        Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
                    }
                    var data1 = SqlGetData(sqlobj1);
                    if (data1.length > 0) {
                        if (data1[0].iSupper != "1" || Page.userid != "master") {
                            if (sStyleNo != StyleNo1 || sSizeGroupID != SizeGroupID1) {
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
            }

            var sqlObj = { TableName: "BscDataStyleM",
                Fields: "sStyleNo,sStyleName",
                SelectAll: "True",
                Filters: [{ Field: "sStyleNo", ComOprt: "=", Value: "'" + StyleNo1 + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                if (sStyleNo == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '改款号已存在！',
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
                    if (sStyleNo != StyleNo1) {
                        $.messager.show({
                            title: '错误',
                            msg: '改款号已存在！',
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

            var result = $('#table5').datagrid('getRows');
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    for (var j = i + 1; j < result.length; j++) {
                        if (result[i].sColorName == result[j].sColorName) {
                            var iSerial = result[j].iSerial;
                            $.messager.show({
                                title: '错误',
                                msg: '【批发价】序号' + iSerial + '重复！',
                                timeout: 1100,
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

            var result1 = $('#table3').datagrid('getRows');
            if (result1.length > 0) {
                for (var i = 0; i < result1.length; i++) {
                    for (var j = i + 1; j < result1.length; j++) {
                        if (result1[i].iBscDataCustomerMRecNo == result1[j].iBscDataCustomerMRecNo) {
                            var iSerial = result1[j].iSerial;
                            $.messager.show({
                                title: '错误',
                                msg: '【客户价】序号' + iSerial + '重复！',
                                timeout: 1100,
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

            var FT1 = Page.getFieldValue('fFabTotal');
            var FT2 = Page.getFieldValue('fAccTotal');
            var FT3 = Page.getFieldValue('fOtherTotal');
            var FT4 = Page.getFieldValue('fProTotal');
            var total = Number(FT1) + Number(FT2) + Number(FT3) + Number(FT4);
            Page.setFieldValue('fCostTotal', total);
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
                        款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sStyleNo" />
                    </td>
                    <td>
                        款式名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sStyleName" />
                    </td>
                    <td>
                        分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                    <td>
                        尺码组
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sSizeGroupID" Z_Required="True"
                            Z_RequiredTip="尺码组不能为空" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center',height:300">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="" title="基本信息" style="padding: 20px;">
                    <table class="tabmain">
                        <tr>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>
                                客户款号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCustStyleNo" />
                            </td>
                            <td id="Property" rowspan="7" style="font-family: 宋体; font-size: 18px;">
                                <div style="width: 300px; height: 380px">
                                    <table id="table6" tablename="bscDataStyleDProperty">
                                    </table>
                                </div>
                            </td>
                            <td rowspan="7">
                                <cc1:ExtImage runat="server" Z_FileSize="1000"></cc1:ExtImage>
                                <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="图片" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                品牌
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sLabelName" />
                            </td>
                            <td>
                                计量单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUnitName" Z_Value="件" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                设计师
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sDesignUserID" />
                            </td>
                            <td>
                                参照款式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sFromStyleNo" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                上市年份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iYear" />
                            </td>
                            <td>
                                流行季节
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sSeasonName" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                停用时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                款式描述
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sStyleDetail" Height="50px"
                                    Width="100%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Height="50px"
                                    Width="100%" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                用户编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sUserID" />
                            </td>
                            <td>
                                录入时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="fit:true" title="颜色">
                    <table id="table4" tablename="BscDataStyleDColor">
                    </table>
                </div>
                <div data-options="fit:true" title="水洗唛">
                    <table id="table2" tablename="bscDataStyleDWater">
                    </table>
                </div>
                <div data-options="" title="批发价" style="padding: 20px;">
                    <table class="tabmain">
                        <tr>
                            <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                                成本
                            </td>
                        </tr>
                        <tr>
                            <td>
                                主料成本
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fFabTotal" Z_FieldType="数值" />
                            </td>
                            <td>
                                辅料成本
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fAccTotal" Z_FieldType="数值" />
                            </td>
                            <td>
                                其它成本
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fOtherTotal" Z_FieldType="数值" />
                            </td>
                            <td>
                                加工费
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fProTotal" Z_FieldType="数值" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                总成本
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fCostTotal" Z_readOnly="True"
                                    Z_FieldType="数值" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                                批发价
                            </td>
                        </tr>
                        <tr>
                            <td>
                                A价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="fBulkTotal1" Z_FieldType="数值" />
                            </td>
                            <td>
                                B价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="fBulkTotal2" Z_FieldType="数值" />
                            </td>
                            <td>
                                C价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fBulkTotal3" Z_FieldType="数值" />
                            </td>
                            <td>
                                D价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fBulkTotal4" Z_FieldType="数值" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iPriceColor" />
                            </td>
                            <td>
                                <label for="__ExtCheckbox1">
                                    代理价是否分颜色</label>
                            </td>
                        </tr>
                    </table>
                    <div style="width: 70.5%; height: 400px">
                        <table id="table5" tablename="BscDataStyleDColorPrice">
                        </table>
                    </div>
                </div>
                <div data-options="" title="零售价" style="padding: 20px;">
                    <table class="tabmain" style="width: 70%">
                        <tr>
                            <td>
                                价格体系
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iPriceType" Width="150px" />
                            </td>
                            <td>
                                吊牌价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="fSalePrice" Z_FieldType="数值" />
                            </td>
                            <td>
                                出厂价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fOutPrice" Z_FieldType="数值" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iShop" />
                            </td>
                            <td>
                                <label for="__ExtCheckbox2">
                                    分门店
                                </label>
                            </td>
                        </tr>
                    </table>
                    <div style="width: 76%; height: 400px">
                        <table id="table1" tablename="bscDataStyleDPrice">
                        </table>
                    </div>
                </div>
                <div data-options="" title="客户价">
                    <table id="table3" tablename="bscDataStyleDPriceCust">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
