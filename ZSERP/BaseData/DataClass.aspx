<%@ Page Language="VB" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/lookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        .txb
        {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
        .style1
        {
            height: 24px;
        }
        .style2
        {
            height: 25px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var checkboxstatue = "";
        var sqlobj = "";
        var stype = "";
        var a = 1;
        var AddAttributes = [];
        var idField = "sClassID";
        var textField = "text1";
        var attribute = "sParentID,sReMark,iRecNo";
        var rootValue = "-1";
        var parentField = "sParentID";
        var user = "";
        var ClassID1 = "";
        var iRec = "";
        var AddTree = false;
        var AddChild = false;
        var NewAdd = false;
        $(function () {
            $.ajax(
             {
                 url: "/ashx/LoginHandler.ashx",
                 type: "post",
                 cache: false,
                 data: { otype: "getcurtuserid" },
                 error: function (XMLHttpRequest, textStatus, errorThrown) {
                     $.messager.alert("错误", textStatus);
                 },
                 success: function (data, textStatus) {
                     user = data;
                 }
             });
            stype = getQueryString("stype");
            if (stype == "depart") {
                attribute = "sParentID,sReMark,iRecNo,iWork,iMoveType,sCharger";
                $("#divdept").show();
                sqlobj = { TableName: "vwBscDataListDAll",
                    Fields: "*,text1=case when sClassID='0' then sClassName else sClassID+'-'+sClassName end",
                    SelectAll: "True",
                    Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + stype + "'"}],
                    Sorts: [{
                        SortName: "sClassID",
                        SortOrder: "asc"
                    }]
                };
            }
            else if (stype == "mat") {
                attribute = "sParentID,sReMark,iRecNo,sUnitID,sPurUnitID,fPerQty,fPurSrate,fInSrate,sPurPersonID,fOutSrate";
                $("#divpur").show();
                sqlobj = { TableName: "vwBscDataListD",
                    //Fields: "*,(sClassID+'-'+sClassName) as text1",
                    Fields: "*,text1=case when sClassID='0' then sClassName else sClassID+'-'+sClassName end",
                    SelectAll: "True",
                    Sorts: [{
                        SortName: "sClassID",
                        SortOrder: "asc"
                    }]
                };
            }
            else {
                sqlobj = { TableName: "vwBscDataListDAll",
                    Fields: "*,text1=case when sClassID='0' then sClassName else sClassID+'-'+sClassName end",
                    SelectAll: "True",
                    Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + stype + "'"}],
                    Sorts: [{
                        SortName: "sClassID",
                        SortOrder: "asc"
                    }]
                };
            }
            sqlobj = encodeURIComponent(JSON.stringify(sqlobj));
            UplodeTree();
            lookUp.initFrame();
            lookUp.initHead();
        })

        function UplodeTree() {
            $.ajax(
            {
                url: "/Base/Handler/getTreeData.ashx",
                type: "post",
                cache: false,
                data: { sqlobj: sqlobj, idField: idField, textField: textField, parentField: parentField, attribute: attribute, rootValue: rootValue },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.messager.alert("错误", textStatus);
                },
                success: function (data, textStatus) {
                    var resultObj = eval("(" + data + ")");
                    if (resultObj.length > 0) {
                        $('#tt').tree({
                            data: [{
                                id: resultObj[0].id,
                                text: resultObj[0].text,
                                state: resultObj[0].state,
                                attributes: resultObj[0].attributes,
                                children: resultObj[0].children
                            }]
                        });
                        AddAttributes.push(resultObj[0].attributes);
                        for (var i = 1; i < resultObj.length; i++) {
                            $('#tt').tree('append', {
                                data: [{
                                    id: resultObj[i].id,
                                    text: resultObj[i].text,
                                    state: resultObj[i].state,
                                    attributes: resultObj[i].attributes,
                                    children: resultObj[i].children
                                }]
                            });
                        }
                    }
                    var node = $('#tt').tree('getRoot');
                    var nodes = $('#tt').tree('getChildren', node.target);
                    $('#tt').tree('select', nodes[0].target); //获取焦点
                }
            });
            ClickTree();
        }

        function ClickTree() {
            $('#tt').tree({
                onClick: function (node) {
                    AddChild = false;
                    AddTree = false;
                    NewAdd = false;
                    $('#ff').form('clear');
                    ClassID1 = node.id;
                    iRec = node.attributes.iRecNo;
                    $('#ExtTextBox2').val(node.id);
                    var arr = node.text.split('-');
                    $('#ExtTextBox1').val(arr[1]);
                    $('#ExtTextArea1').val(node.attributes.sReMark);
                    $('#FieldKeyValue').val(node.attributes.iRecNo);
                    $('#ExtTextBox3').val(node.attributes.sParentID);
                    var selected = $('#tt').tree('getParent', node.target);
                    if (selected != null) {
                        var brr = selected.text.split('-');
                        $('#ExtTextBox4').val(brr[1]);
                    }
                    if (stype == "depart") {
                        var sqlobj3 = { TableName: "bscdatalistd",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [{ LeftParenthese: "(", Field: "sClassId", ComOprt: "=", Value: "'sdepartmenselect'", RightParenthese: ")", LinkOprt: "and" },
                            { Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.iWork + "'"}]
                        }
                        var data3 = SqlGetData(sqlobj3);
                        if (data3.length > 0) {
                            $('#ExtTextBox5').textbox('setValue', data3[0].sCode);
                            $('#ExtTextBox5').textbox('setText', data3[0].sName);
                        }
                        else {
                            var sqlobj8 = { TableName: "bscdatalistd",
                                Fields: "*",
                                SelectAll: "True",
                                Filters: [{ LeftParenthese: "(", Field: "sClassId", ComOprt: "=", Value: "'sdepartmenselect'", RightParenthese: ")", LinkOprt: "and" },
                                { Field: "sName", ComOprt: "=", Value: "'" + node.attributes.iWork + "'"}]
                            }
                            var data8 = SqlGetData(sqlobj8);
                            if (data8.length > 0) {
                                $('#ExtTextBox5').textbox('setValue', data8[0].sCode);
                                $('#ExtTextBox5').textbox('setText', data8[0].sName);
                            }
                        }
                        var sqlobj4 = { TableName: "bscDataPerson",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sCharger + "'"}]
                        };
                        var data4 = SqlGetData(sqlobj4);
                        if (data4.length > 0) {
                            $('#Charger').textbox('setValue', data4[0].sCode);
                            $('#Charger').textbox('setText', data4[0].sName);
                        }
                        else {
                            var sqlobj9 = { TableName: "bscDataPerson",
                                Fields: "*",
                                SelectAll: "True",
                                Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sCharger + "'"}]
                            };
                            var data9 = SqlGetData(sqlobj9);
                            if (data9.length > 0) {
                                $('#Charger').textbox('setValue', data9[0].sCode);
                                $('#Charger').textbox('setText', data9[0].sName);
                            }
                        }
                        document.getElementById('CheckBox1').checked = node.attributes.iMoveType == "1" ? true : false;
                        checkboxstatue = node.attributes.iMoveType == "1" ? true : false;
                    }
                    else if (stype == "mat") {
                        $('#ExtTextBox11').textbox('setText', node.attributes.sUnitID);
                        $('#ExtTextBox10').textbox('setText', node.attributes.sPurUnitID);
                        $('#ExtTextBox6').textbox('setText', node.attributes.fOutSrate);
                        $('#ExtTextBox7').textbox('setText', node.attributes.fInSrate);
                        $('#ExtTextBox8').textbox('setText', node.attributes.fPurSrate);
                        $('#ExtTextBox9').textbox('setText', node.attributes.fPerQty);
                        var sqlobj5 = { TableName: "bscDataPerson",
                            Fields: "sName,sCode",
                            SelectAll: "True",
                            Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sPurPersonID + "'"}]
                        };
                        var data5 = SqlGetData(sqlobj5);
                        if (data5.length > 0) {
                            $('#ExtTextBox12').textbox('setValue', data5[0].sCode);
                            $('#ExtTextBox12').textbox('setText', data5[0].sName);
                        }
                        else {
                            var sqlobj6 = { TableName: "bscDataPerson",
                                Fields: "sName,sCode",
                                SelectAll: "True",
                                Filters: [{ Field: "sName", ComOprt: "=", Value: "'" + node.attributes.sPurPersonID + "'"}]
                            };
                            var data6 = SqlGetData(sqlobj6);
                            if (data6.length > 0) {
                                $('#ExtTextBox12').textbox('setValue', data6[0].sCode);
                                $('#ExtTextBox12').textbox('setText', data6[0].sName);
                            }
                        }
                    }
                }
            });
        }

        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }

        function add() {
            NewAdd = true;
            AddChild = false;
            AddTree = true;
            $('#ff').form('clear');
            var node = $('#tt').tree('getSelected');
            if (node != null) {
                if (node.text == "全部") {
                    $.messager.show({
                        title: '错误',
                        msg: '这里无法新增分类！',
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
                    if (node == null || node.attributes.sParentID == "0" || node.attributes.sParentID == undefined) {
                        var selected = $('#tt').tree('getParent', node.target);
                        $('#ExtTextBox3').val("0");
                        if (stype == "mat") {
                            var sqlObj = { TableName: "vwBscDataListD",
                                Fields: "sClassID",
                                SelectAll: "True",
                                Filters: [{ Field: "sParentID", ComOprt: "=", Value: "'" + selected.id + "'"}]
                            }
                        }
                        else {
                            var sqlObj = { TableName: "bscDataClass",
                                Fields: "sClassID",
                                SelectAll: "True",
                                Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'" + stype + "'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sParentID", ComOprt: "=", Value: "'" + selected.id + "'"}]
                            };
                        }
                        var data = SqlGetData(sqlObj);
                        if (data.length > 0) {
                            var max = data[0].sClassID;
                            for (var i = 0; i < data.length; i++) {
                                if (max < data[i].sClassID) {
                                    max = data[i].sClassID;
                                }
                            }
                            max++;
                            $('#ExtTextBox2').val("0" + max);
                        }
                        else {
                            $('#ExtTextBox2').val("01");
                        }
                    }
                    else {
                        var selected = $('#tt').tree('getParent', node.target);
                        $('#ExtTextBox3').val(node.attributes.sParentID);
                        var ClassID = node.attributes.sParentID;
                        if (stype == "mat") {
                            var sqlObj = { TableName: "vwBscDataListD",
                                Fields: "sClassID",
                                SelectAll: "True",
                                Filters: [{ Field: "sParentID", ComOprt: "=", Value: "'" + selected.id + "'"}]
                            }
                        }
                        else {
                            var sqlObj = { TableName: "bscDataClass",
                                Fields: "sClassID",
                                SelectAll: "True",
                                Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'" + stype + "'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sParentID", ComOprt: "=", Value: "'" + selected.id + "'"}]
                            };
                        }
                        var data = SqlGetData(sqlObj);
                        var max = data[0].sClassID;
                        for (var i = 0; i < data.length; i++) {
                            if (max < data[i].sClassID) {
                                max = data[i].sClassID;
                            }
                        }
                        max++;
                        $('#ExtTextBox2').val("0" + max);
                        var selected = $('#tt').tree('getParent', node.target);
                        var arr2 = selected.text.split('-');
                        $('#ExtTextBox4').val(arr2[1]);
                    }
                    $('#ExtTextBox1').focus();
                }
            }
            else {
                return false;
            }
        }
        function addChild() {
            AddChild = true;
            AddTree = true;
            var num = "0";
            $('#ff').form('clear');
            var node = $('#tt').tree('getSelected');
            if (node == null) {
                return false;
            }
            else {
                if (node.id == "0") {
                    num = "";
                }
                if (node.children.length > 0) {
                    var max = node.children[0].id;
                    for (var i = 0; i < node.children.length; i++) {
                        if (max < node.children[i].id) {
                            max = node.children[i].id;
                        }
                    }
                    max++;
                    var ClassID = "0" + max;
                }
                else {
                    if (stype == "mat") {
                        var sqlObj = { TableName: "vwBscDataListD",
                            Fields: "sClassID",
                            SelectAll: "True",
                            Filters: [{ Field: "sParentID", ComOprt: "=", Value: "0"}]
                        }
                    }
                    else {
                        var sqlObj = { TableName: "bscDataClass",
                            Fields: "sClassID",
                            SelectAll: "True",
                            Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'" + stype + "'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sParentID", ComOprt: "=", Value: "0"}]
                        };
                    }
                    var max = 1;
                    var ClassID = node.id + num + max;
                }

                $('#ExtTextBox2').val(ClassID);
                $('#ExtTextBox3').val(node.id);
                var arr2 = node.text.split('-');
                $('#ExtTextBox4').val(arr2[1]);
                $('#ExtTextBox1').focus();
                //$('#ExtTextBox1').textbox().next('span').find('input').focus();
            }
        }
        function deleteChild() {
            var node = $('#tt').tree('getSelected');
            if (node == null) {
                return false;
            }
            else {
                if (NewAdd == true) {
                    $.messager.show({
                        title: '提示！',
                        msg: '新增状态删除无效！',
                        showType: 'show',
                        timeout: 1000,
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    return false;
                }
                else {
                    if (node.children.length > 0 || node.text == "0-全部") {
                        $.messager.show({
                            title: '错误',
                            msg: '根节点无法删除，请先删除子节点！',
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
                        if (stype == "mat" && node.attributes.sParentID == "0") {
                            $.messager.show({
                                title: '错误',
                                msg: '不能删除物料根节点',
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
                            $.messager.confirm("操作提示", "确认删除所选择分类？", function (data) {
                                if (data) {
                                    var node = $('#tt').tree('getSelected');
                                    if (stype == "customer") {
                                        var sqlObj2 = { TableName: "BscDataCustomer",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ LeftParenthese: "(", Field: "iCustType", ComOprt: "=", Value: "'0'", RightParenthese: ")", LinkOprt: "and" },
                                        { Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                                        };
                                        var data2 = SqlGetData(sqlObj2);
                                        if (data2.length > 0) {
                                            $.messager.show({
                                                title: '错误',
                                                msg: '已使用!',
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
                                    else if (stype == "supplier") {
                                        var sqlObj3 = { TableName: "BscDataCustomer",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ LeftParenthese: "(", Field: "iCustType", ComOprt: "=", Value: "'1'", RightParenthese: ")", LinkOprt: "and" },
                                        { Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                                        };
                                        var data3 = SqlGetData(sqlObj3);
                                        if (data3.length > 0) {
                                            $.messager.show({
                                                title: '错误',
                                                msg: '已使用!',
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
                                    else if (stype == "color") {
                                        var sqlObj4 = { TableName: "BscDataColor",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                                        };
                                        var data4 = SqlGetData(sqlObj4);
                                        if (data4.length > 0) {
                                            $.messager.show({
                                                title: '错误',
                                                msg: '已使用!',
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
                                    else if (stype == "depart") {
                                        var sqlObj5 = { TableName: "bscDataPerson",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                                        };
                                        var data5 = SqlGetData(sqlObj5);
                                        if (data5.length > 0) {
                                            $.messager.show({
                                                title: '错误',
                                                msg: '已使用!',
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
                                    else if (stype == "mat") {
                                        var sqlObj6 = { TableName: "bscDataMat",
                                            Fields: "*",
                                            SelectAll: "True",
                                            Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                                        };
                                        var data6 = SqlGetData(sqlObj6);
                                        if (data6.length > 0) {
                                            $.messager.show({
                                                title: '错误',
                                                msg: '已使用!',
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
                                    var arr3 = node.text.split('-');
                                    var jsonobj = {
                                        StoreProName: "SpDeleteClass",
                                        StoreParms: [{
                                            ParmName: "@sType",
                                            Value: stype
                                        },
                                   {
                                       ParmName: "@sClassID",
                                       Value: node.id
                                   },
                                    {
                                        ParmName: "@sClassName",
                                        Value: arr3[1]
                                    }]
                                    };
                                    var result = SqlStoreProce(jsonobj);
                                    if (result == 1) {
                                        $('#tt').tree('remove', node.target);
                                        $('#ff').form('clear');
                                        var node = $('#tt').tree('getRoot');
                                        var nodes = $('#tt').tree('getChildren', node.target);
                                        $('#tt').tree('select', nodes[0].target);
                                    }
                                    else {
                                        $.messager.show({
                                            title: '错误',
                                            msg: '删除数据失败!',
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
                            });
                        }
                    }
                }
            }
        }
        function back() {
            //需要关闭tab
            window.parent.closeTab();
        }
        function save() {
            $('#ExtTextBox9').textbox().next('span').find('input').focus()
            $('#ExtTextBox8').textbox().next('span').find('input').focus()
            $('#ExtTextBox7').textbox().next('span').find('input').focus()
            $('#ExtTextBox6').textbox().next('span').find('input').focus()
            $('#ExtTextBox1').focus()
            $('#sType').val(stype);
            var SortNO = $('#ExtTextBox2').val();
            var SortName = $('#ExtTextBox1').val();
            if (SortName == "" || SortNO == "") {
                $.messager.show({
                    title: '错误',
                    msg: '请填写分类编号和分类名称！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
                $('#ExtTextBox2').focus();
            }
            else {
                var sqlobj3 = { TableName: "bscdatalistd",
                    Fields: "sCode,sName",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'pubMatClass'"}]
                };
                var data3 = SqlGetData(sqlobj3);
                var iname = 0;
                for (var i = 0; i < data3.length; i++) {
                    if (SortName == data3[i].sName || SortNO == data3[i].sCode) {
                        iname = 1;
                        break;
                    }
                }
                if (iname != 0 || stype != "mat" || $('#ExtTextBox3').val() != "0") {
                    var sqlObj2 = { TableName: "bscDataClass",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'" + stype + "'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sClassID", ComOprt: "=", Value: "'" + SortNO + "'"}]
                    };
                    var data2 = SqlGetData(sqlObj2);
                    if (AddTree == false) {
                        if (data2.length > 0 || $('#FieldKeyValue').val() != "" || ClassID1 != "") {
                            if (ClassID1 != "") {
                                var sqlobj1 = { TableName: "bscDataPerson",
                                    Fields: "iSupper",
                                    SelectAll: "True",
                                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + user + "'"}]
                                }
                                var data1 = SqlGetData(sqlobj1);
                                if (data1.length > 0) {
                                    if (data1[0].iSupper != "1" && user != "master") {
                                        $.messager.show({
                                            title: '错误',
                                            msg: '修改分类请联系超级用户！',
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
                                        if (data2.length > 0) {
                                            if (data2[0].sClassID == ClassID1) {
                                                if (data2[0].sParentID == "0") {
                                                    $('#ExtTextBox3').val("0");
                                                }
                                                var irecno = data2[0].iRecNo;
                                            }
                                            else {
                                                $.messager.show({
                                                    title: '错误',
                                                    msg: '分类编号已存在',
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
                                        else {
                                            var irecno = iRec;
                                            var SortNO1 = $('#ExtTextBox2').val();
                                            var sqlObj3 = { TableName: "bscDataClass",
                                                Fields: "sClassID",
                                                SelectAll: "True",
                                                Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'" + stype + "'", RightParenthese: ")", LinkOprt: "and" },
                                                 { Field: "sClassID", ComOprt: "=", Value: "'" + SortNO1 + "'"}]
                                            };
                                            var data3 = SqlGetData(sqlObj3);
                                            if (data3.length > 0) {
                                                $.messager.show({
                                                    title: '错误',
                                                    msg: '分类编号已存在',
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
                                        $('#sType').val(stype);
                                        $('#TableName').val("bscDataClass");
                                        $('#FieldKey').val("iRecNo");
                                        $('#FieldKeyValue').val(irecno);
                                        var bb = Form.__update(irecno, "/Base/Handler/DataOperatorNew.ashx")
                                        if (bb.indexOf('error') > 0) {
                                            {
                                                $.messager.show({
                                                    title: '保存失败',
                                                    msg: bb,
                                                    showType: 'show',
                                                    timeout: 1000,
                                                    style: {
                                                        right: '',
                                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                                                        bottom: ''
                                                    }
                                                });
                                            }
                                        }
                                        else {
                                            AddAttributes[0].sClassName = $('#ExtTextBox1').val();
                                            AddAttributes[0].sClassID = $('#ExtTextBox2').val();
                                            AddAttributes[0].sReMark = $('#ExtTextArea1').val();
                                            AddAttributes[0].sParentID = $('#ExtTextBox3').val();
                                            if (stype == "depart") {
                                                AddAttributes[0].iWork = $('#ExtTextBox5').textbox('getValue');
                                                AddAttributes[0].iMoveType = checkboxstatue;
                                                AddAttributes[0].sCharger = $('#Charger').val();
                                            }
                                            else if (stype == "mat") {
                                                AddAttributes[0].sUnitID = $('#ExtTextBox11').textbox('getText');
                                                AddAttributes[0].sPurUnitID = $('#ExtTextBox10').textbox('getText');
                                                AddAttributes[0].fOutSrate = $('#ExtTextBox6').textbox('getText');
                                                AddAttributes[0].fInSrate = $('#ExtTextBox7').textbox('getText');
                                                AddAttributes[0].fPurSrate = $('#ExtTextBox8').textbox('getText');
                                                AddAttributes[0].fPerQty = $('#ExtTextBox9').textbox('getText');
                                                AddAttributes[0].sPurPersonID = $('#ExtTextBox12').textbox('getText');
                                            }
                                            var node = $('#tt').tree('getSelected');
                                            if (node) {
                                                $('#tt').tree('update', {
                                                    target: node.target,
                                                    text: $('#ExtTextBox2').val() + "-" + $('#ExtTextBox1').val(),
                                                    id: $('#ExtTextBox2').val(),
                                                    attributes: AddAttributes[0]
                                                });
                                                $.messager.show({
                                                    title: 'OK',
                                                    msg: '保存成功！',
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
                                    }
                                }
                            }

                        }
                    }
                    else {
                        if (data2.length > 0) {
                            $.messager.show({
                                title: '错误',
                                msg: '分类编号已存在',
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
                            var jsonobj = {
                                StoreProName: "SpGetIden",
                                StoreParms: [{
                                    ParmName: "@sTableName",
                                    Value: "bscDataClass"
                                }]
                            }
                            Result = SqlStoreProce(jsonobj);
                            if (Result && Result.length > 0 && Result != "0") {
                                $('#TableName').val("bscDataClass");
                                $('#FieldKey').val("iRecNo");
                                $('#FieldKeyValue').val(Result);
                                var aa = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                                if (aa.indexOf('error') > 0) {
                                    {
                                        $.messager.show({
                                            title: '保存失败',
                                            msg: aa,
                                            showType: 'show',
                                            timeout: 1000,
                                            style: {
                                                right: '',
                                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                                bottom: ''
                                            }
                                        });
                                    }
                                }
                                else {
                                    if (AddAttributes.length > 0) {
                                        AddAttributes[0].iRecNo = Result;
                                        AddAttributes[0].sClassName = $('#ExtTextBox1').val();
                                        AddAttributes[0].sClassID = $('#ExtTextBox2').val();
                                        AddAttributes[0].sReMark = $('#ExtTextArea1').val();
                                        AddAttributes[0].sParentID = $('#ExtTextBox3').val();
                                        if (stype == "depart") {
                                            AddAttributes[0].iWork = $('#ExtTextBox5').textbox('getValue');
                                            AddAttributes[0].iMoveType = checkboxstatue;
                                            AddAttributes[0].sCharger = $('#Charger').val();
                                        }
                                        else if (stype == "mat") {
                                            AddAttributes[0].sUnitID = $('#ExtTextBox11').textbox('getText');
                                            AddAttributes[0].sPurUnitID = $('#ExtTextBox10').textbox('getText');
                                            AddAttributes[0].fOutSrate = $('#ExtTextBox6').textbox('getText');
                                            AddAttributes[0].fInSrate = $('#ExtTextBox7').textbox('getText');
                                            AddAttributes[0].fPurSrate = $('#ExtTextBox8').textbox('getText');
                                            AddAttributes[0].fPerQty = $('#ExtTextBox9').textbox('getText');
                                            AddAttributes[0].sPurPersonID = $('#ExtTextBox12').textbox('getValue');
                                        }
                                        var selected = $('#tt').tree('getSelected');
                                        if (selected) {
                                            var class1 = selected.id;
                                            var class2 = $('#ExtTextBox2').val();
                                            if (class1.length == class2.length || AddChild == false) {
                                                var getParent = $('#tt').tree('getParent', selected.target);
                                                $('#tt').tree('append', {
                                                    parent: getParent.target,
                                                    data: [{
                                                        id: $('#ExtTextBox2').val(),
                                                        text: $('#ExtTextBox2').val() + "-" + $('#ExtTextBox1').val(),
                                                        state: open,
                                                        attributes: AddAttributes[0],
                                                        children: ""
                                                    }]
                                                });
                                                $.messager.show({
                                                    title: 'OK',
                                                    msg: '保存成功！',
                                                    timeout: 1000,
                                                    showType: 'show',
                                                    style: {
                                                        right: '',
                                                        top: document.body.scrollTop + document.documentElement.scrollTop,
                                                        bottom: ''
                                                    }
                                                });
                                            }
                                            else {
                                                $('#tt').tree('append', {
                                                    parent: selected.target,
                                                    data: [{
                                                        id: $('#ExtTextBox2').val(),
                                                        text: $('#ExtTextBox2').val() + "-" + $('#ExtTextBox1').val(),
                                                        state: open,
                                                        attributes: AddAttributes[0],
                                                        children: ""
                                                    }]
                                                });
                                                $.messager.show({
                                                    title: 'OK',
                                                    msg: '保存成功！',
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
                                            $('#tt').tree('insert', {
                                                data: [{
                                                    id: $('#ExtTextBox2').val(),
                                                    text: $('#ExtTextBox2').val() + "-" + $('#ExtTextBox1').val(),
                                                    state: open,
                                                    attributes: AddAttributes[0],
                                                    children: ""
                                                }]
                                            });
                                            $.messager.show({
                                                title: 'OK',
                                                msg: '保存成功！',
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
                                        UplodeTree();
                                        $.messager.show({
                                            title: 'OK',
                                            msg: '保存成功！',
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
                            }
                        }
                    }
                }
                else {
                    $.messager.show({
                        title: '保存失败',
                        msg: '物料根节点名称请根据公共数据中物料分类名称',
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
        }
        function Copy() {
            add();
            var node = $('#tt').tree('getSelected');
            if (stype == "depart") {
                var sqlobj3 = { TableName: "bscdatalistd",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{ LeftParenthese: "(", Field: "sClassId", ComOprt: "=", Value: "'sdepartmenselect'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.iWork + "'"}]
                }
                var data3 = SqlGetData(sqlobj3);
                if (data3.length > 0) {
                    $('#ExtTextBox5').textbox('setValue', data3[0].sCode);
                    $('#ExtTextBox5').textbox('setText', data3[0].sName);
                }
                else {
                    var sqlobj8 = { TableName: "bscdatalistd",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [{ LeftParenthese: "(", Field: "sClassId", ComOprt: "=", Value: "'sdepartmenselect'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sName", ComOprt: "=", Value: "'" + node.attributes.iWork + "'"}]
                    }
                    var data8 = SqlGetData(sqlobj8);
                    if (data8.length > 0) {
                        $('#ExtTextBox5').textbox('setValue', data8[0].sCode);
                        $('#ExtTextBox5').textbox('setText', data8[0].sName);
                    }
                }
                var sqlobj4 = { TableName: "bscDataPerson",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sCharger + "'"}]
                };
                var data4 = SqlGetData(sqlobj4);
                if (data4.length > 0) {
                    $('#Charger').textbox('setValue', data4[0].sCode);
                    $('#Charger').textbox('setText', data4[0].sName);
                }
                else {
                    var sqlobj9 = { TableName: "bscDataPerson",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sCharger + "'"}]
                    };
                    var data9 = SqlGetData(sqlobj9);
                    if (data9.length > 0) {
                        $('#Charger').textbox('setValue', data9[0].sCode);
                        $('#Charger').textbox('setText', data9[0].sName);
                    }
                }
                document.getElementById('CheckBox1').checked = node.attributes.iMoveType == "1" ? true : false;
                checkboxstatue = node.attributes.iMoveType == "1" ? true : false;
            }
            else if (stype == "mat") {
                $('#ExtTextBox11').textbox('setText', node.attributes.sUnitID);
                $('#ExtTextBox10').textbox('setText', node.attributes.sPurUnitID);
                $('#ExtTextBox6').textbox('setText', node.attributes.fOutSrate);
                $('#ExtTextBox7').textbox('setText', node.attributes.fInSrate);
                $('#ExtTextBox8').textbox('setText', node.attributes.fPurSrate);
                $('#ExtTextBox9').textbox('setText', node.attributes.fPerQty);
                var sqlobj5 = { TableName: "bscDataPerson",
                    Fields: "sName,sCode",
                    SelectAll: "True",
                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + node.attributes.sPurPersonID + "'"}]
                };
                var data5 = SqlGetData(sqlobj5);
                if (data5.length > 0) {
                    $('#ExtTextBox12').textbox('setValue', data5[0].sCode);
                    $('#ExtTextBox12').textbox('setText', data5[0].sName);
                }
                else {
                    var sqlobj6 = { TableName: "bscDataPerson",
                        Fields: "sName,sCode",
                        SelectAll: "True",
                        Filters: [{ Field: "sName", ComOprt: "=", Value: "'" + node.attributes.sPurPersonID + "'"}]
                    };
                    var data6 = SqlGetData(sqlobj6);
                    if (data6.length > 0) {
                        $('#ExtTextBox12').textbox('setValue', data6[0].sCode);
                        $('#ExtTextBox12').textbox('setText', data6[0].sName);
                    }
                }
            }
        }
        function Change() {
            if (checkboxstatue == true) {
                document.getElementById("CheckBox1").value = false;
                checkboxstatue = false;
            }
            else {
                document.getElementById("CheckBox1").value = true;
                checkboxstatue = true;
            }
        }
    </script>
</head>
<body class="easyui-layout">
    <form id="ff" method="post" runat="server">
    <asp:HiddenField ID="TableName" runat="server" />
    <!--要保存的表名-->
    <asp:HiddenField ID="FieldKey" runat="server" />
    <!--表的主键字段-->
    <asp:HiddenField ID="FieldKeyValue" runat="server" />
    <!--表的主键值-->
    <div data-options="region:'north',title:''" style="height: 35px; background: #efefef;
        padding: 1px;">
        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'"
            onclick='add()'>新增分类</a> <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'"
                onclick='addChild()' id="addChild">新增子分类</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                    data-options="plain:true,iconCls:'icon-remove'" onclick='deleteChild()'>删除子分类</a>&nbsp;<a
                        href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true"
                        onclick='Copy()'><img src="../../Base/JS/easyui/themes/icons/copy.png" style="margin: -5px auto" />复制</a>&nbsp;<a
                            href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'"
                            onclick='save()'>保存</a>&nbsp;|<a href='javascript:void(0)' class="easyui-linkbutton"
                                data-options="plain:true,iconCls:'icon-undo'" onclick='back()'>退出</a>
    </div>
    <div data-options="region:'west',title:'',split:true" style="width: 200px;">
        <ul id="tt">
        </ul>
    </div>
    <div data-options="region:'center',title:''">
        <div id="divpublic">
            <div>
                <img alt="" src="images/ggsx.png" height="40px" width="35px" />
                <div style="margin: -16px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 37px; margin: -25px auto">
                    <span style="font-family: 黑体; font-size: 15px">公共属性</span>
                </div>
                <br />
                <br />
            </div>
            <div style="padding: 0 0 0 37px;">
                <br />
                <table class="tab">
                    <tr>
                        <td class="tdtitle">
                            分类名称
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox1" runat="server" fieldid="sClassName" name="sClassName"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style1">
                            分类编号
                        </td>
                        <td class="style1">
                            <input type="text" id="ExtTextBox2" runat="server" fieldid="sClassID" name="sClassID"
                                class="txb" />
                        </td>
                    </tr>
                    <tr id="fNO">
                        <td class="tdtitle">
                            父分类编号
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox3" runat="server" fieldid="sParentID" name="sParentID"
                                class="txb" size="6" />
                            <input type="text" id="ExtTextBox4" runat="server" plugin="textbox" class="txb" readonly="readonly"
                                size="18" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            备 注
                        </td>
                        <td>
                            <textarea id="ExtTextArea1" cols="20" rows="2" class="txb" style="height: 60px; width: 208px;"
                                fieldid="sReMark" name="sReMark"></textarea>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td class="tdtitle">
                            标 识
                        </td>
                        <td>
                            <input type="text" id="sType" runat="server" fieldid="sType" class="txb" name="sType" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div style="height: 15px;">
        </div>
        <div id="divdept" style="display: none">
            <div>
                <img alt="" src="images/wl.png" height="40px" width="35px" />
                <div style="margin: -16px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 37px; margin: -25px auto">
                    <span style="font-family: 黑体; font-size: 15px">部门分类专属</span>
                </div>
                <br />
                <br />
            </div>
            <div style="padding: 0 0 0 37px">
                <br />
                <table class="tab">
                    <tr>
                        <td class="tdtitle">
                            部门类型
                        </td>
                        <td>
                            &nbsp;&nbsp;&nbsp;
                            <input lookupoptions="[{lookupName:'DataClass_department',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="ExtTextBox5" runat="server" fieldid="iWork" name="iWork" style="width: 120px" />
                        </td>
                        <td onclick="Change()">
                            <input id="CheckBox1" type="checkbox" fieldid="iMoveType" value="" />
                            <label for="CheckBox1">
                                是否交接确认</label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            主 管
                        </td>
                        <td>
                            &nbsp;&nbsp;&nbsp;
                            <input lookupoptions="[{lookupName:'personSelect2',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="Charger" runat="server" fieldid="sCharger" name="sCharger" style="width: 120px" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="divpur" style="display: none">
            <div>
                <img alt="" src="images/bm.png" height="40px" width="35px" />
                <div style="margin: -16px auto">
                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" />
                </div>
                <div style="padding: 0 0 0 37px; margin: -25px auto">
                    <span style="font-family: 黑体; font-size: 15px">物料分类专属</span>
                </div>
                <br />
                <br />
            </div>
            <div style="padding: 0 0 0 37px;">
                <br />
                <table class="tab">
                    <tr>
                        <td class="tdtitle">
                            数量单位
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'DataClass_sdUnit',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="ExtTextBox11" runat="server" fieldid="sUnitID" name="sUnitID"
                                style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            计数单位
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'DataClass_sdUnit',width:600,height:400,fields:'*',searchFields:'*',editable:true,pageSize:20}]"
                                type="text" id="ExtTextBox10" runat="server" fieldid="sPurUnitID" name="sPurUnitID"
                                style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            采购员
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'bscDataPerson1',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;sJobRole like &apos;%采购员%&apos;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="ExtTextBox12" runat="server" fieldid="sPurPersonID" name="sPurPersonID"
                                style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            换算率
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox9" runat="server" fieldid="fPerQty" class="easyui-numberbox"
                                name="fPerQty" style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            采购超数
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox8" runat="server" fieldid="fPurSrate" class="easyui-numberbox"
                                name="fPurSrate" style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            入库超数
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox7" runat="server" fieldid="fInSrate" class="easyui-numberbox"
                                name="fInSrate" style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle">
                            领用超数
                        </td>
                        <td>
                            <input type="text" id="ExtTextBox6" runat="server" fieldid="fOutSrate" class="easyui-numberbox"
                                name="fOutSrate" style="width: 60px" />
                            %
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
