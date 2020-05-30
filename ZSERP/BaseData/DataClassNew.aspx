<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
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
    </style>
    <script language="javascript" type="text/javascript">
        var iAdd = false; //判断是否新增状态
        $(function () {
            var attribute = "sType,sClassID,sClassName,sParentID,iWork,iMoveType,sUnitID,sPurUnitID,sPurPersonID,fPerQty,sCharger,fPurSrate,fInSrate,fOutSrate,sReMark,iRecNo";
            var stype = getQueryString("stype");
            if (stype != "") {
                if (stype == "depart") { $("#divdept").show(); }
                else if (stype == "mat") { $("#divpur").show(); }
                var sqlobj = { TableName: "vwBscDataListDAll",
                    Fields: "*,text1=case when sClassID='0' then sClassName else sClassID+'-'+sClassName end",
                    SelectAll: "True",
                    Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + stype + "'"}],
                    Sorts: [{
                        SortName: "sClassID",
                        SortOrder: "asc"
                    }]
                };
                //加密
                sqlobj = encodeURIComponent(JSON.stringify(sqlobj));
                UplodeTree(sqlobj, "sClassID", "text1", "sParentID", attribute, "-1");
                //加载lookup
                lookUp.initFrame();
                lookUp.initHead();
            }
        })

        //树初始化
        function UplodeTree(sqlobj, idField, textField, parentField, attribute, rootValue) {
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
                            data: resultObj
                        });
                    }
                    var node = $('#tt').tree('getRoot');
                    var nodes = $('#tt').tree('getChildren', node.target);
                    //获取焦点
                    if (nodes.length > 0) {
                        $('#tt').tree('select', nodes[0].target);
                    }
                    else {
                        $('#tt').tree('select', node.target);
                    }
                }
            });
            ClickTree();
        }

        //点击事件
        function ClickTree() {
            $('#tt').tree({
                onClick: function (node) {
                    //CheckBox中on表示选中
                    if (node.attributes.iMoveType == "1") {
                        node.attributes.iMoveType = "on";
                    }
                    var getParent = $('#tt').tree('getParent', node.target);
                    if (getParent) {
                        node.attributes.sParentName = getParent.attributes.sClassName;
                    }
                    else {
                        node.attributes.sParentName = "";
                    }
                    $('#ff').form('load', node.attributes);
                    $('#sClassName').attr("readonly", false);
                    iAdd = false;
                }
            });
        }

        //新增分类
        function add() {
            var node = $('#tt').tree('getSelected');
            var getParent = $('#tt').tree('getParent', node.target);
            if (node) {
                //物料大类以公共数据为准
                if (node.attributes.sType == "mat" && node.attributes.sParentID == "0") {
                    MessagerShow('提示', '物料根节点名称请根据公共数据中物料分类名称！');
                }
                else if (node.text == "全部") {
                    MessagerShow('错误', '这里无法新增分类！');
                }
                else {
                    $('#ff').form('clear');
                    //获取sClassID
                    var sqlObj = { TableName: "vwBscDataListDAll",
                        Fields: "sClassID=case when len('" + node.attributes.sParentID + "')>1 then '" + node.attributes.sParentID + "'+RIGHT(('00'+cast((isnull(MAX(sClassID),'00')+1) as varchar(20))),2) else RIGHT(('00'+cast((isnull(MAX(sClassID),'00')+1) as varchar(20))),2) end",
                        SelectAll: "True",
                        Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + node.attributes.sType + "'", LinkOprt: "and" },
                                  { Field: "sParentID", ComOprt: "=", Value: "'" + node.attributes.sParentID + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        $('#ff').form('load', {
                            sClassID: data[0].sClassID,
                            sParentID: node.attributes.sParentID,
                            sParentName: node.attributes.sParentName,
                            sType: node.attributes.sType
                        });
                        //$('#ExtTextBox1').textbox().next('span').find('input').focus();
                        $('#sClassName').attr("readonly", false)
                        $('#sClassName').focus();
                        iAdd = true;
                    }
                }
            }
        }

        //新增子分类
        function addChild() {
            var node = $('#tt').tree('getSelected');
            var getChildren = $('#tt').tree('getChildren', node.target);
            if (node) {
                //物料大类以公共数据为准
                if (node.attributes.sType == "mat" && node.attributes.sClassID == "0") {
                    MessagerShow('提示', '物料根节点名称请根据公共数据中物料分类名称！');
                }
                else {
                    $('#ff').form('clear');
                    //获取sClassID
                    var sqlObj = { TableName: "vwBscDataListDAll",
                        Fields: "sClassID=case when len('" + node.attributes.sClassID + "')>1 then '" + node.attributes.sClassID + "'+RIGHT(('00'+cast((isnull(MAX(sClassID),'00')+1) as varchar(20))),2) else RIGHT(('00'+cast((isnull(MAX(sClassID),'00')+1) as varchar(20))),2) end",
                        SelectAll: "True",
                        Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + node.attributes.sType + "'", LinkOprt: "and" },
                                  { Field: "sParentID", ComOprt: "=", Value: "'" + node.attributes.sClassID + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        $('#ff').form('load', {
                            sClassID: data[0].sClassID,
                            sParentID: node.attributes.sClassID,
                            sParentName: node.attributes.sClassName,
                            sType: node.attributes.sType
                        });
                        $('#sClassName').attr("readonly", false)
                        $('#sClassName').focus();
                        iAdd = true;
                    }
                }
            }
        }

        //删除分类
        function deleteChild() {
            var node = $('#tt').tree('getSelected');
            if (node) {
                if (iAdd == false) {
                    //物料大类以公共数据为准
                    if (node.attributes.sType == "mat" && node.attributes.sParentID == "0") {
                        MessagerShow('提示', '不能删除物料根节点！');
                    }
                    else if (node.children.length > 0 || node.attributes.sParentID == "-1") {
                        MessagerShow('错误', '根节点无法删除，请先删除子节点！');
                    }
                    else {
                        if (node.attributes.sType == "customer") {
                            var sqlObj = { TableName: "BscDataCustomer",
                                Fields: "1",
                                SelectAll: "True",
                                Filters: [{ Field: "iCustType", ComOprt: "=", Value: "0", LinkOprt: "and" },
                                          { Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                MessagerShow('提示', '该分类已使用，不能被删除！');
                                return false;
                            }
                        }
                        else if (node.attributes.sType == "supplier") {
                            var sqlObj = { TableName: "BscDataCustomer",
                                Fields: "1",
                                SelectAll: "True",
                                Filters: [{ Field: "iCustType", ComOprt: "=", Value: "1", LinkOprt: "and" },
                                                          { Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                MessagerShow('提示', '该分类已使用，不能被删除！');
                                return false;
                            }
                        }
                        else if (node.attributes.sType == "depart") {
                            var sqlObj = { TableName: "bscDataPerson",
                                Fields: "1",
                                SelectAll: "True",
                                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                MessagerShow('提示', '该分类已使用，不能被删除！');
                                return false;
                            }
                        }
                        else if (node.attributes.sType == "color") {
                            var sqlObj = { TableName: "BscDataColor",
                                Fields: "1",
                                SelectAll: "True",
                                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                MessagerShow('提示', '该分类已使用，不能被删除！');
                                return false;
                            }
                        }
                        else if (node.attributes.sType == "mat") {
                            var sqlObj = { TableName: "bscDataMat",
                                Fields: "1",
                                SelectAll: "True",
                                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + node.id + "'"}]
                            };
                            var data = SqlGetData(sqlObj);
                            if (data.length > 0) {
                                MessagerShow('提示', '该分类已使用，不能被删除！');
                                return false;
                            }
                        }
                        $.messager.confirm("操作提示", "确认删除所选择分类？", function (data) {
                            if (data) {
                                var jsonobj = {
                                    StoreProName: "SpDeleteClass",
                                    StoreParms: [{
                                        ParmName: "@iRecNo",
                                        Value: node.attributes.iRecNo
                                    }]
                                };
                                var result = SqlStoreProce(jsonobj);
                                if (result == "1") {
                                    $('#tt').tree('remove', node.target);
                                    $('#ff').form('clear');
                                    var getRoot = $('#tt').tree('getRoot');
                                    var getChildren = $('#tt').tree('getChildren', node.target);
                                    if (getChildren.length > 0) {
                                        $('#tt').tree('select', getChildren[0].target);
                                    }
                                    else {
                                        $('#tt').tree('select', getRoot.target);
                                    }
                                }
                                else {
                                    MessagerShow('错误', '删除分类失败,请联系管理员！');
                                }
                            }
                        });
                    }
                }
                else {
                    MessagerShow('提示！', '新增状态删除无效！');
                }
            }
        }

        //保存||修改
        function save() {
            if (iAdd == true) {
                //新增保存
                var sClassName = $('#sClassName').val();
                if (sClassName != "") {
                    //保存前检测
                    var sType = $('#sType').val();
                    var sClassID = $('#sClassID').val();
                    var sqlObj = { TableName: "bscDataClass",
                        Fields: "1",
                        SelectAll: "True",
                        Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + sType + "'", LinkOprt: "and" },
                                  { Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        MessagerShow('提示！', '该分类编号已存在！');
                    }
                    else {
                        var sqlObj1 = { TableName: "bscDataClass",
                            Fields: "1",
                            SelectAll: "True",
                            Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + sType + "'", LinkOprt: "and" },
                                  { Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'", LinkOprt: "and" },
                                  { Field: "sClassName", ComOprt: "=", Value: "'" + sClassName + "'"}]
                        };
                        var data1 = SqlGetData(sqlObj1);
                        if (data1.length > 0) {
                            MessagerShow('提示！', '该分类名称已存在！');
                        }
                        else {
                            //获取主键，保存
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
                                var formAdd = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                                if (formAdd.indexOf('error') > 0) {
                                    MessagerShow('错误！', formAdd);
                                }
                                else {
                                    iAdd = false;
                                    //保存成功，刷新表单
                                    var node = $('#tt').tree('getSelected');
                                    var getParent = "";
                                    if (sClassID.length == node.attributes.sClassID.length) {
                                        //新增分类
                                        getParent = $('#tt').tree('getParent', node.target);
                                    }
                                    else {
                                        //新增子分类
                                        getParent = node;
                                    }
                                    $('#tt').tree('append', {
                                        parent: getParent.target,
                                        data: [{
                                            id: $('#sClassID').val(),
                                            text: $('#sClassID').val() + "-" + $('#sClassName').val(),
                                            state: open,
                                            attributes: {
                                                sType: $('#sType').val(),
                                                sClassID: $('#sClassID').val(),
                                                sClassName: $('#sClassName').val(),
                                                sParentID: $('#sParentID').val(),
                                                iWork: $('#iWork').textbox('getText'),
                                                iMoveType: document.getElementById('iMoveType').checked,
                                                sPurUnitID: $('#sPurUnitID').textbox('getText'),
                                                sUnitID: $('#sUnitID').textbox('getText'),
                                                sPurPersonID: $('#sPurPersonID').textbox('getValue'),
                                                fPerQty: $('#fPerQty').val(),
                                                sCharger: $('#sCharger').textbox('getText'),
                                                fPurSrate: $('#fPurSrate').val(),
                                                fInSrate: $('#fInSrate').val(),
                                                fOutSrate: $('#fOutSrate').val(),
                                                sReMark: $('#sReMark').val(),
                                                iRecNo: Result
                                            },
                                            children: ""
                                        }]
                                    });
                                    var getChildren = $('#tt').tree('getChildren', getParent.target);
                                    $('#tt').tree('select', getChildren[getChildren.length - 1].target);
                                }
                            }
                        }
                    }
                }
                else {
                    MessagerShow('提示！', '分类名称不能为空！');
                    $('#sClassName').focus();
                }
            }
            else {
                //修改保存
                $.ajax({
                    url: "/ashx/LoginHandler.ashx",
                    type: "post",
                    cache: false,
                    data: { otype: "getcurtuserid" },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.messager.alert("错误", textStatus);
                    },
                    success: function (user, textStatus) {
                        var sqlobj = { TableName: "bscDataPerson",
                            Fields: "iSupper",
                            SelectAll: "True",
                            Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + user + "'"}]
                        }
                        var GetUser = SqlGetData(sqlobj);
                        if (GetUser && GetUser[0].iSupper == "1") {
                            var sClassName = $('#sClassName').val();
                            if (sClassName != "") {
                                //保存前检测
                                var sType = $('#sType').val();
                                var sClassID = $('#sClassID').val();
                                var node = $('#tt').tree('getSelected');
                                if (sClassID == node.attributes.sClassID) {
                                    if (sClassName != node.attributes.sClassName) {
                                        var sqlObj = { TableName: "bscDataClass",
                                            Fields: "1",
                                            SelectAll: "True",
                                            Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + node.attributes.sType + "'", LinkOprt: "and" },
                                      { Field: "sClassName", ComOprt: "=", Value: "'" + sClassName + "'"}]
                                        };
                                        var data = SqlGetData(sqlObj);
                                        if (data.length > 0) {
                                            MessagerShow('提示！', '该分类名称已存在！');
                                            return false;
                                        }
                                    }
                                }
                                else {
                                    var sqlObj = { TableName: "bscDataClass",
                                        Fields: "1",
                                        SelectAll: "True",
                                        Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + node.attributes.sType + "'", LinkOprt: "and" },
                                      { Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'"}]
                                    };
                                    var data = SqlGetData(sqlObj);
                                    if (data.length > 0) {
                                        MessagerShow('提示！', '该分类编码已存在！');
                                        return false;
                                    }
                                    else {
                                        var sqlObj1 = { TableName: "bscDataClass",
                                            Fields: "1",
                                            SelectAll: "True",
                                            Filters: [{ Field: "sType", ComOprt: "=", Value: "'" + node.attributes.sType + "'", LinkOprt: "and" },
                                                   { Field: "sClassName", ComOprt: "=", Value: "'" + sClassName + "'"}]
                                        };
                                        var data1 = SqlGetData(sqlObj1);
                                        if (data1.length > 0) {
                                            MessagerShow('提示！', '该分类名称已存在！');
                                            return false;
                                        }
                                    }
                                }
                                $('#TableName').val("bscDataClass");
                                $('#FieldKey').val("iRecNo");
                                $('#FieldKeyValue').val(node.attributes.iRecNo);
                                var formUpdate = Form.__update(node.attributes.iRecNo, "/Base/Handler/DataOperatorNew.ashx");
                                if (formUpdate.indexOf('error') > 0) {
                                    MessagerShow('错误！', formAdd);
                                }
                                else {
                                    //刷新树
                                    $('#tt').tree('update', {
                                        target: node.target,
                                        id: $('#sClassID').val(),
                                        text: $('#sClassID').val() + "-" + $('#sClassName').val(),
                                        attributes: {
                                            sType: $('#sType').val(),
                                            sClassID: $('#sClassID').val(),
                                            sClassName: $('#sClassName').val(),
                                            sParentID: $('#sParentID').val(),
                                            iWork: $('#iWork').textbox('getText'),
                                            iMoveType: document.getElementById('iMoveType').checked,
                                            sPurUnitID: $('#sPurUnitID').textbox('getText'),
                                            sUnitID: $('#sUnitID').textbox('getText'),
                                            sPurPersonID: $('#sPurPersonID').textbox('getValue'),
                                            fPerQty: $('#fPerQty').val(),
                                            sCharger: $('#sCharger').textbox('getText'),
                                            fPurSrate: $('#fPurSrate').val(),
                                            fInSrate: $('#fInSrate').val(),
                                            fOutSrate: $('#fOutSrate').val(),
                                            sReMark: $('#sReMark').val(),
                                            iRecNo: node.attributes.iRecNo
                                        }
                                    });
                                }
                            }
                            else {
                                MessagerShow('提示！', '分类名称不能为空！');
                                $('#sClassName').focus();
                            }
                        }
                        else {
                            MessagerShow('提示！', '修改分类请联系超级用户！');
                        }
                    }
                });
            }
        }

        //退出
        function back() {
            window.parent.closeTab();
        }

        //获取URL传参
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }

        function MessagerShow(title, msg) {
            $.messager.show({
                title: title,
                msg: msg,
                timeout: 2000,
                showType: 'show',
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''
                }
            });
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
    <div id="divlookUp" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: true, cache: false,
     maximizable: true,resizable: true,onBeforeOpen:lookUp.onBeforeOpen,onBeforeClose:lookUp.onBeforeClose,onBeforeDestroy:lookUp.onBeforeDestroy">
        <iframe style='margin: 0; padding: 0' id='ifrlookup' name='ifrlookup' width='100%'
            height='99.5%' frameborder='0'></iframe>
    </div>
    <div data-options="region:'north',title:''" style="height: 35px; background: #efefef;
        padding: 1px;">
        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'"
            onclick='add()'>新增分类</a> <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'"
                onclick='addChild()' id="addChild">新增子分类</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                    data-options="plain:true,iconCls:'icon-remove'" onclick='deleteChild()'>删除子分类</a>&nbsp;<a
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
                        <td>
                            分类名称
                        </td>
                        <td>
                            <input type="text" id="sClassName" fieldid="sClassName" name="sClassName" class="txb"
                                readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            分类编号
                        </td>
                        <td>
                            <input type="text" id="sClassID" fieldid="sClassID" name="sClassID" class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            父分类编号
                        </td>
                        <td>
                            <input type="text" id="sParentID" fieldid="sParentID" name="sParentID" class="txb"
                                size="6" />
                            <input type="text" id="sParentName" plugin="textbox" class="txb" readonly="readonly"
                                size="18" name="sParentName" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            备 注
                        </td>
                        <td>
                            <textarea id="sReMark" cols="20" rows="2" class="txb" style="height: 60px; width: 208px;"
                                fieldid="sReMark" name="sReMark"></textarea>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td>
                            标 识
                        </td>
                        <td>
                            <input type="text" id="sType" fieldid="sType" class="txb" name="sType" />
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
                        <td>
                            部门类型
                        </td>
                        <td>
                            &nbsp;&nbsp;&nbsp;
                            <input lookupoptions="[{lookupName:'DataClass_department',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="iWork" fieldid="iWork" name="iWork" style="width: 120px" />
                        </td>
                        <td>
                            <input id="iMoveType" type="checkbox" fieldid="iMoveType" name="iMoveType" />
                            <label for="iMoveType">
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
                                type="text" id="sCharger" fieldid="sCharger" name="sCharger" style="width: 120px" />
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
                        <td>
                            数量单位
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'DataClass_sdUnit',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="sUnitID" fieldid="sUnitID" name="sUnitID" style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            计数单位
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'DataClass_sdUnit',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="sPurUnitID" fieldid="sPurUnitID" name="sPurUnitID" style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            采购员
                        </td>
                        <td>
                            <input lookupoptions="[{lookupName:'bscDataPerson1',width:600,height:400,fields:'*',searchFields:'*',fixFilters:&quot;sJobRole like &apos;%采购员%&apos;&quot;,nofixFilters:&quot;&quot;,editable:true,pageSize:20}]"
                                type="text" id="sPurPersonID" fieldid="sPurPersonID" name="sPurPersonID" style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            换算率
                        </td>
                        <td>
                            <input type="text" id="fPerQty" fieldid="fPerQty" class="easyui-numberbox" name="fPerQty"
                                style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td>
                            采购超数
                        </td>
                        <td>
                            <input type="text" id="fPurSrate" fieldid="fPurSrate" class="easyui-numberbox" name="fPurSrate"
                                style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td>
                            入库超数
                        </td>
                        <td>
                            <input type="text" id="fInSrate" fieldid="fInSrate" class="easyui-numberbox" name="fInSrate"
                                style="width: 60px" />
                            %
                        </td>
                    </tr>
                    <tr>
                        <td>
                            领用超数
                        </td>
                        <td>
                            <input type="text" id="fOutSrate" fieldid="fOutSrate" class="easyui-numberbox" name="fOutSrate"
                                style="width: 60px" />
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
