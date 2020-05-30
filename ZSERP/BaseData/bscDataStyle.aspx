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
        var OldId = "";
        var OldValue = "";
        $(function () {
            //价格显示
            var sqlObj = {
                TableName: "vwSysGetRight",
                Fields: "1",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: "'" + Page.iformid + "'",
                    LinkOprt: "and"
                }, {
                    Field: "sCode",
                    ComOprt: "=",
                    Value: "'" + Page.userid + "'",
                    LinkOprt: "and"
                }, {
                    Field: "sRightName",
                    ComOprt: "=",
                    Value: "'fshowPrice'"
                }]
            }
            var data = SqlGetData(sqlObj);
            if (data.length == 0) {
                $(".showPrice").hide();
            }

            Page.Children.toolBarBtnRemove("table4", "copy");
            $('#__ExtTextBox3').combotree({
                onChange: function (record) {
                    var aa = Page.getFieldValue("sClassID").substring(0, 6);
                    if (aa == "090303")
                        aa = Page.getFieldValue("sClassID");
                    var sql = {
                        TableName: "bscDataClass",
                        Fields: "sClassName",
                        SelectAll: "True",
                        Filters: [
                        {
                            Field: "sType",
                            ComOprt: "=",
                            Value: "'mat'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "sParentID",
                            ComOprt: "like",
                            Value: "'09%'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "sClassID",
                            ComOprt: "=",
                            Value: "'" + aa + "'"
                        }
                        ]
                    }
                    var result = SqlGetData(sql);
                    Page.setFieldValue("sStyleName", result[0].sClassName);
                    // getClassID();
                }
            })
            Page.Children.toolBarBtnDisabled("table5", "add");
            Page.Children.toolBarBtnDisabled("table5", "copy");
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "copy");
            Page.Children.toolBarBtnDisabled("table8", "add");
            Page.Children.toolBarBtnDisabled("table8", "copy");
            //Page.Children.toolBarBtnDisabled("table6", "copy");
            //Page.Children.toolBarBtnDisabled("table6", "delete");
            Page.Children.toolBarBtnAdd("table8", "mybtn8", "安全库存设置", "tool", function () {
                var getRows = $('#table4').datagrid('getRows');
                if (getRows.length > 0) {
                    var SizeGroup = Page.getFieldValue('sSizeGroupID');
                    if (SizeGroup == "") {
                        $.messager.show({
                            title: '提示',
                            msg: '尺码组不能为空！',
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
                        var sqlobj = {
                            TableName: "vwBscDataSizeMD",
                            Fields: "sSizeName,iSerial",
                            SelectAll: "True",
                            Filters: [{ Field: "sGroupID", ComOprt: "=", Value: "'" + SizeGroup + "'"}],
                            Sorts: [{
                                SortName: "iSerial",
                                SortOrder: "asc"
                            }]
                        }
                        var data = SqlGetData(sqlobj);
                        if (data.length > 0) {
                            for (var i = 0; i < getRows.length; i++) {
                                for (var j = 0; j < data.length; j++) {
                                    var beginSerial = "0";
                                    var Toadd = true;
                                    var getBarCodes = $('#table8').datagrid('getRows');
                                    if (getBarCodes.length > 0) {
                                        //新增前判断
                                        var MaxSerialID = 0;
                                        for (var m = 0; m < getBarCodes.length; m++) {
                                            if (getBarCodes[m].sSerialID > MaxSerialID) {
                                                MaxSerialID = getBarCodes[m].sSerialID;
                                            }
                                            if (getBarCodes[m].sSizeName == data[j].sSizeName && getBarCodes[m].iBscDataColorRecNo == getRows[i].ibscDataColorRecNo) {
                                                Toadd = false;
                                            }
                                        }
                                        if (Toadd == true) {
                                            beginSerial = MaxSerialID;
                                            var sSerialID = parseFloat(beginSerial) + 1;
                                            if (sSerialID < 10) { sSerialID = "0" + sSerialID }
                                            Page.tableToolbarClick("add", "table8", { sColorName: getRows[i].sColorName, sSizeName: data[j].sSizeName, sSerialID: sSerialID, iBscDataColorRecNo: getRows[i].ibscDataColorRecNo, dColorStopDate: getRows[i].dStopDate });
                                        }
                                    }
                                    else {
                                        var sSerialID = "0";
                                        sSerialID = sSerialID.substring(sSerialID.length - 2, sSerialID.length);
                                        Page.tableToolbarClick("add", "table8", { sColorName: getRows[i].sColorName, sSizeName: data[j].sSizeName, sSerialID: sSerialID, iBscDataColorRecNo: getRows[i].ibscDataColorRecNo, dColorStopDate: getRows[i].dStopDate });
                                    }
                                }
                            }
                        }
                        else {
                            $.messager.show({
                                title: '提示',
                                msg: '该尺码没有数据！',
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
                else {
                    $.messager.show({
                        title: '提示',
                        msg: '请先添加颜色',
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
            })

            Page.Children.toolBarBtnAdd("table8", "mybtn9", "一键填充", "tool", function () {
                var getChecked = $('#table8').datagrid('getChecked');
                var getRows = $('#table8').datagrid('getRows');
                if (getChecked.length > 0) {
                    for (var i = 0; i < getRows.length; i++) {
                        getRows[i].iSafeQty = getChecked[0].iSafeQty;
                    }
                    $('#table8').datagrid('loadData', getRows);
                }
                else {
                    Page.MessageShow("提示", "请先勾选一行作为参考行");
                }
            })
            if (Page.getFieldValue('iSaleBack') == "0") {
                Page.setFieldDisabled("fSaleBackPct");
            }

            $("#__ExtCheckbox3").change(function () {
                if ($("#__ExtCheckbox3").prop('checked') == true) {
                    Page.setFieldEnabled("fSaleBackPct");
                }
                else {
                    Page.setFieldDisabled("fSaleBackPct");
                }
            });

            sClassID = Page.getFieldValue('sClassID');
            sStyleNo = Page.getFieldValue('sStyleNo');
            sStyleName = Page.getFieldValue('sStyleName');
            sSizeGroupID = Page.getFieldValue('sSizeGroupID');
            //setTimeout(getClassID, 1001); //延后执行
            //setTimeout(setMeasure, 1001); //延后执行

            Page.Children.toolBarBtnAdd("bscDataStyleDMeasure", "mybtn1", "档差计算", "tool", function () {
                var getRows11 = $('#bscDataStyleDMeasure').datagrid('getSelections');
                if (getRows11.length > 0) {
                    var cha = prompt("请输入档差", ""); //将输入的内容赋给变量 name ，  
                    if (cha) {//如果返回的有内容  
                        var getRows1 = "";
                        for (var i = 0; i < getRows11.length; i++) {
                            getRows1 = getRows11[i];
                            var rowIndex = $('#bscDataStyleDMeasure').datagrid('getRowIndex', getRows1)
                            var mm = getRows1.M;
                            if (mm != undefined) {
                                var ss = parseFloat(mm) - 1 * parseFloat(cha);
                                var ll = parseFloat(ss) + 2 * parseFloat(cha);
                                var xl = parseFloat(ss) + 3 * parseFloat(cha);
                                var xl2 = parseFloat(ss) + 4 * parseFloat(cha);
                                var xl3 = parseFloat(ss) + 5 * parseFloat(cha);
                                var xl4 = parseFloat(ss) + 6 * parseFloat(cha);
                                var ff = parseFloat(ss) + 7 * parseFloat(cha);
                                if (checkRate(ss))
                                    ss = ss.toFixed(1);
                                if (checkRate(ll))
                                    ll = ll.toFixed(1);
                                if (checkRate(xl))
                                    xl = xl.toFixed(1);
                                if (checkRate(xl2))
                                    xl2 = xl2.toFixed(1);
                                if (checkRate(xl3))
                                    xl3 = xl3.toFixed(1);
                                if (checkRate(xl4))
                                    xl4 = xl4.toFixed(1);
                                if (checkRate(ff))
                                    ff = ff.toFixed(1);
                                //$("#bscDataStyleDMeasure").datagrid("updateRow", { index: rowIndex, row: { S: ss, L: ll, XL: xl,["2XL"]:xl2,["3XL"]:xl3} });
                            }
                            //                        else
                            //                            alert("M码不能为空");
                        }
                    }
                }
                else {
                    alert("未选中行");
                }

            })

            Page.Children.toolBarBtnAdd("bscDataStyleDFillRong", "btnsize", "尺码导入", "tool", function () {

                var sSizeGroupID = Page.getFieldValue("sSizeGroupID");
                var sql = {
                    TableName: "BscDataSizeD a left join BscDataSizeM b on a.iMainRecNo=b.iRecNo",
                    Fields: "a.sSizeName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sGroupID",
                            ComOprt: "=",
                            Value: "'" + sSizeGroupID + "'"
                        }
                    ]
                }
                var result = SqlGetData(sql);
                for (var i = 0; i < result.length; i++) {
                    Page.tableToolbarClick("add", "bscDataStyleDFillRong", result[i]);
                }
            })

           
        })

        function checkRate(input) {
            var re = /^[1-9]+[0-9]*]*$/;   //判断字符串是否为数字     //判断正整数  
            if (!re.test(input)) {
                return true;
            }
            else
                return false;
        }
        function getClassID() {
            var ClassID = Page.getFieldValue('sClassID');
            if (ClassID == "") {
                var ClassName = $('#__ExtTextBox3').textbox('getText');
                Page.setFieldValue('sStyleName', ClassName);
                Page.Children.toolBarBtnDisabled("table6", "delete");
                var sqlobj1 = { TableName: "bscDataClassPropertyM",
                    Fields: "iRecNo as ibscDataClassPropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
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
                var bo = true;
                //                var sqlobj = { TableName: "bscDataClassPropertyM",
                //                    Fields: "iRecNo as PropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
                //                    SelectAll: "True",
                //                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'"}],
                //                    Sorts: [{
                //                        SortName: "iSerial",
                //                        SortOrder: "asc"
                //                    }]
                //                };
                //                var data = SqlGetData(sqlobj);
                var jsonobj = {
                    StoreProName: "GetZhi",
                    StoreParms: [{
                        ParmName: "@sClassID",
                        Value: ClassID
                    }]
                }
                var data = SqlStoreProce(jsonobj, true);

                if (data.length != result.length) {
                    for (var i = 0; i < data.length; i++) {
                        bo = true;
                        var aa = data[i].sPropertyName;
                        for (var j = 0; j < result.length; j++) {
                            var bb = result[j].sPropertyName;
                            if (aa == bb) {
                                bo = false;
                                break;
                            }
                        }
                        if (bo)
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
                        if (data1[0].iSupper != "1" && Page.userid != "master") {
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
                Filters: [{ Field: "sStyleNo", ComOprt: "=", Value: "'" + StyleNo1 + "'", LinkOprt: "and" },
                { Field: "iRecNo", ComOprt: "<>", Value: Page.key}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                if (sStyleNo == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '该款号已存在！',
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
                        if (result1[i].ibscDataCustomerMRecNo == result1[j].ibscDataCustomerMRecNo) {
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
            var result11 = $('#table4').datagrid('getRows');
            if (result11.length > 0) {
                for (var i = 0; i < result11.length; i++) {
                    for (var j = i + 1; j < result11.length; j++) {
                        if (result11[i].ibscDataColorRecNo == result11[j].ibscDataColorRecNo) {
                            var iSerial = result11[j].iSerial;
                            $.messager.show({
                                title: '错误',
                                msg: '【颜色】序号' + iSerial + '重复！',
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
            if (total > 0) {
                Page.setFieldValue('fCostTotal', total);
            }
        }

        function setMeasure() {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                var Measurerows = $('#bscDataStyleDMeasure').datagrid('getRows');
                var sqlobjMeasure = {
                    TableName: "bscDataListD",
                    Fields: "sName",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + 'sPartName' + "'"}]
                }
                var dataMeasure = SqlGetData(sqlobjMeasure);

                //     alert(Measurerows.length);
                var strMeasure = "";
                for (var i = 0; i < Measurerows.length; i++) {
                    strMeasure = strMeasure + "," + Measurerows[i].sPartName;

                }

                for (var i = 0; i < dataMeasure.length; i++) {
                    // $('#bscDataStyleDMeasure').datagrid('appendRow',{sPartName:dataMeasure[i].sName});
                    if (strMeasure.indexOf(dataMeasure[i].sName) < 0) {
                        Page.tableToolbarClick('add', 'bscDataStyleDMeasure', { sPartName: dataMeasure[i].sName });
                    }
                }

            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'">
            <table align="center" style="width: 80%; padding: 5px;">
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
        </div>
        <div data-options="region:'center',height:300">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="" title="款式信息" style="padding: 0 10px 0 10px">
                    <table class="tabmain">
                        <tr>
                            <td colspan="5">
                                <span style="color: #0033CC; font-size: 20px">基本信息</span>
                            </td>
                            <td colspan="4" class="showPrice">
                                <span style="color: #FF6600; font-size: 20px">价格信息</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                供应商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="iSupBscDataCustomerRecNo"
                                    Width="110px" />
                            </td>
                            <td>
                                供应商款号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="sSupCustStyleNo" Width="110px" />
                            </td>
                            <td class="showPrice" rowspan="4" style="border-left: 1px solid #e5e5e5;">
                            </td>
                            <td class="showPrice">
                                采购价
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="fPurPrice" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                            <td class="showPrice">
                                订货价
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="fOutPrice" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Width="110px" />
                            </td>
                            <td>
                                客户款号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sCustStyleNo" Width="110px" />
                            </td>
                            <td class="showPrice">
                                批发价
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="fBulkTotal1" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                            <td class="showPrice">
                                零售价
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fSalePrice" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                品牌
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sLabelName" Width="110px" />
                            </td>
                            <td>
                                计量单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUnitName" Width="110px" />
                            </td>
                            <td class="showPrice">
                                进货价<br />
                                调整幅度
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="fAdjustInPrice" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                            <td class="showPrice">
                                采购价<br />
                                调整幅度
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="fAdjustInBul" Z_FieldType="数值"
                                    Width="110px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                设计师
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sDesignUserID" Width="110px" />
                            </td>
                            <td>
                                参照款式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sFromStyleNo" Width="110px" />
                            </td>
                            <td class="showPrice">
                                折扣(%)
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fDiscount" Width="110px" />
                            </td>
                            <td class="showPrice">
                                最低折扣(%)
                            </td>
                            <td class="showPrice">
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="fDiscountMin" Width="110px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                上市年份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iYear" Width="110px" />
                            </td>
                            <td>
                                流行季节
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sSeasonName" Width="110px" />
                            </td>
                            <td class="showPrice">
                            </td>
                            <td>
                                停用时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期"
                                    Width="110px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                款式描述
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sStyleDetail" Width="100%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="100%" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" style="height: 200px">
                                <table id="table4" tablename="BscDataStyleDColor">
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="fit:true" title="水洗唛">
                    <table id="table2" tablename="bscDataStyleDWater">
                    </table>
                </div>
                <div data-options="fit:true" title="安全库存">
                    <table id="table8" tablename="BscDataStyleDSafeQty">
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'east',iconCls:'icon-reload',split:true" style="width: 30%;">
            <cc1:ExtImage ID="ExtImage1" runat="server" />
        </div>
        <div data-options="region:'south'" style="height: 50px;">
            <table class="tabmain">
                <tr>
                    <td>
                        录入人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dinputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                    <td style="display: none">
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="iPass" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div style="display: none">
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
                    <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fFabTotal" Z_FieldType="数值"
                        Width="110px" />
                </td>
                <td>
                    辅料成本
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fAccTotal" Z_FieldType="数值"
                        Width="110px" />
                </td>
                <td>
                    其它成本
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fOtherTotal" Z_FieldType="数值"
                        Width="110px" />
                </td>
                <td>
                    加工费
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fProTotal" Z_FieldType="数值"
                        Width="110px" />
                </td>
            </tr>
            <tr>
                <td>
                    总成本
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fCostTotal" Z_readOnly="False"
                        Z_FieldType="数值" Width="110px" />
                </td>
            </tr>
            <tr>
                <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                    批发价
                </td>
            </tr>
            <tr>
                <td>
                    B价
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="fBulkTotal2" Z_FieldType="数值"
                        Width="110px" />
                </td>
                <td>
                    C价
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fBulkTotal3" Z_FieldType="数值"
                        Width="110px" />
                </td>
                <td>
                    D价
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fBulkTotal4" Z_FieldType="数值"
                        Width="110px" />
                </td>
            </tr>
            <tr>
                <td>
                    <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iPriceColor" />
                </td>
                <td>
                    <label for="__ExtCheckbox1">
                        分颜色</label>
                </td>
            </tr>
        </table>
        <div style="width: 90%; height: 200px">
            <table id="table5" tablename="BscDataStyleDColorPrice">
            </table>
        </div>
    </div>
    <div style="display: none">
        <table class="tabmain" style="width: 90%">
            <tr>
                <td>
                    价格体系
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iPriceType" Width="110px" />
                </td>
            </tr>
            <tr>
                <td>
                    <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iShop" />
                    <label for="__ExtCheckbox2">
                        分门店
                    </label>
                </td>
            </tr>
        </table>
        <div style="width: 90%; height: 300px">
            <table id="table1" tablename="bscDataStyleDPrice">
            </table>
        </div>
    </div>
    <div style="display: none">
        <table id="table3" tablename="bscDataStyleDPriceCust">
        </table>
    </div>
</asp:Content>
