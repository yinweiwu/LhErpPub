<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>用户客户权限</title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var idField = "sClassID";
        var textField = "sClassName";
        var rootValue = "0";
        var parentField = "sParentID";
        var sUserID = "";
        var CustomerRecNo = "";
        var resultObject;
        var resultObject1;
        $(function () {
            //获取员工信息
            var sqlgrid = { TableName: "vwPersonDataClass",
                Fields: "*",
                SelectAll: "True",
                Sorts: [{
                    SortName: "sClassID",
                    SortOrder: "asc"
                }]
            };
            sqlgrid = encodeURIComponent(JSON.stringify(sqlgrid));
            $.ajax(
            {
                url: "/ZSERP/BaseData/Hander/GetTreegrid.ashx",
                type: "post",
                cache: false,
                data: { sqlobj: sqlgrid, idField: idField, textField: textField, parentField: parentField, rootValue: rootValue },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.messager.alert("错误", textStatus);
                },
                success: function (data, textStatus) {
                    var resultObj = eval("(" + data + ")");
                    if (resultObj.length > 0) {
                        $("#Person").treegrid({
                            fit: true,
                            remoteSort: false,
                            method: "get",
                            idField: 'sParentID',
                            treeField: 'sClassName',
                            data: resultObj,
                            //                            frozenColumns: [[
                            //                            { field: 'sParentID', title: 'ID', width: 150, sortable: true }
                            //                            ]],
                            columns: [[
                            { title: '部门', field: 'sClassName', width: 150 },
                            { field: "sCode", title: "员工编号", width: 150, sortable: true },
                            { field: "sName", title: "员工姓名", width: 150, sortable: true }
                            ]],
                            enableHeaderClickMenu: false,
                            enableHeaderContextMenu: false,
                            enableRowContextMenu: false,
                            toggleOnClick: true,
                            onClickRow: function (row) {
                                sUserID = row.sCode;
                                if (sUserID != "") {
                                    //可分配用户
                                    var sqlgrid = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                                    sqlgrid += "where iRecNo not in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                                    var griddata = SqlGetDataGridComm(sqlgrid);
                                    $("#CustomerSelect").datagrid({
                                        fit: true,
                                        remoteSort: false,
                                        //singleSelect: true,
                                        data: griddata.Rows,
                                        columns: [[
                                        { field: "sCustID", title: "客户编码", width: 80, sortable: true, checkbox: true },
                                        { field: "sCustShortName", title: "客户简称", width: 100, sortable: true },
                                        { field: "depart1", title: "部门", width: 80, sortable: true },
                                        { field: "sClassName", title: "单位分类", width: 100, sortable: true },
                                        { field: "sSaleName", title: "业务员", width: 80, sortable: true },
                                        { field: "sTraceName", title: "跟单员", width: 80, sortable: true }
                                        ]]
                                        //                                        onCheck: function (index, row) {
                                        //                                            if (resultObject == undefined) {
                                        //                                                CustomerRecNo = griddata.Rows[index].iRecNo;
                                        //                                            }
                                        //                                            else {
                                        //                                                CustomerRecNo = resultObject.Rows[index].iRecNo;
                                        //                                            }
                                        //                                        }
                                    });
                                    //已分配用户
                                    var sqlgrid1 = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                                    sqlgrid1 += "where iRecNo in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                                    var griddata1 = SqlGetDataGridComm(sqlgrid1);
                                    $("#Customer").datagrid({
                                        fit: true,
                                        remoteSort: false,
                                        //singleSelect: true,
                                        data: griddata1.Rows,
                                        columns: [[
                                        { field: "sCustID", title: "客户编码", width: 80, sortable: true, checkbox: true },
                                        { field: "sCustShortName", title: "客户简称", width: 100, sortable: true },
                                        { field: "depart1", title: "部门", width: 80, sortable: true },
                                        { field: "sClassName", title: "单位分类", width: 100, sortable: true },
                                        { field: "sSaleName", title: "业务员", width: 80, sortable: true },
                                        { field: "sTraceName", title: "跟单员", width: 80, sortable: true }
                                        ]]
                                    });
                                }
                            }
                        });
                    }
                }
            });
        })

        function Add() {
            var GetCustomerRecNo = $('#CustomerSelect').datagrid('getChecked');
            if (GetCustomerRecNo.length > 0) {
                for (var i = 0; i < GetCustomerRecNo.length; i++) {
                    var jsonobj = {
                        StoreProName: "SpGetIden",
                        StoreParms: [{
                            ParmName: "@sTableName",
                            Value: "spRightCustomer"
                        }]
                    }
                    var Result = SqlStoreProce(jsonobj);
                    var jsonobj1 = {
                        StoreProName: "spRightCustomer",
                        StoreParms: [{
                            ParmName: "@iRecNo",
                            Value: Result
                        },
                    {
                        ParmName: "@index",
                        Value: 1//1增加0删除
                    },
                    {
                        ParmName: "@userid",
                        Value: sUserID
                    },
                    {
                        ParmName: "@customerRecNo",
                        Value: GetCustomerRecNo[i].iRecNo
                    }]
                    }
                    var Result1 = SqlStoreProce(jsonobj1);
                    if (Result1 != "1") {
                        $.messager.show({
                            title: '错误',
                            msg: Result1,
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
                //可分配用户
                var sqlgrid = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                sqlgrid += "where iRecNo not in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                resultObject = SqlGetDataGridComm(sqlgrid);
                //已分配用户
                var sqlgrid1 = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                sqlgrid1 += "where iRecNo in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                resultObject1 = SqlGetDataGridComm(sqlgrid1);
                $("#CustomerSelect").datagrid({ data: resultObject.Rows });
                $("#Customer").datagrid({ data: resultObject1.Rows });
                $.messager.show({
                    title: 'OK',
                    msg: '分配成功！',
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
                $.messager.show({
                    title: '提示',
                    msg: "请选择要分配的用户！",
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

        function Delete() {
            var GetCustomerRecNo = $('#Customer').datagrid('getChecked');
            if (GetCustomerRecNo.length > 0) {
                for (var i = 0; i < GetCustomerRecNo.length; i++) {
                    var jsonobj1 = {
                        StoreProName: "spRightCustomer",
                        StoreParms: [{
                            ParmName: "@iRecNo",
                            Value: ""
                        },
                    {
                        ParmName: "@index",
                        Value: 0//1增加0删除
                    },
                    {
                        ParmName: "@userid",
                        Value: ""
                    },
                    {
                        ParmName: "@customerRecNo",
                        Value: GetCustomerRecNo[i].iRecNo
                    }]
                    }
                    var Result1 = SqlStoreProce(jsonobj1);
                    if (Result1 != "1") {
                        $.messager.show({
                            title: '错误',
                            msg: Result1,
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
                //可分配用户
                var sqlgrid = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                sqlgrid += "where iRecNo not in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                resultObject = SqlGetDataGridComm(sqlgrid);
                //已分配用户
                var sqlgrid1 = "select [iRecNo],[sCustID],[sCustShortName],[depart1],[sClassName],[sSaleName],[sTraceName] from vwBscDataCustomer "
                sqlgrid1 += "where iRecNo in (select ibscDataCustomerRecNo from sysRightCustomer where sUserID='" + sUserID + "')";
                resultObject1 = SqlGetDataGridComm(sqlgrid1);
                $("#CustomerSelect").datagrid({ data: resultObject.Rows });
                $("#Customer").datagrid({ data: resultObject1.Rows });
                $.messager.show({
                    title: 'OK',
                    msg: '分配成功！',
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
                $.messager.show({
                    title: '提示',
                    msg: "请选择要分配的用户！",
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

        function back() {
            window.parent.closeTab();
        }
    </script>
</head>
<body class="easyui-layout">
    <form id="ff" method="post" runat="server" style="height: 700px">
    <div data-options="region:'north',title:''" style="height: 30px; background: #efefef;
        padding: 0px;">
        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-undo'"
            onclick='back()'>退出</a>
    </div>
    <div data-options="region:'center'">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'north',title:'员工选择'" style="height: 40%;">
                <table id="Person">
                </table>
            </div>
            <div data-options="region:'center',border:false">
                <div class="easyui-layout" data-options="fit:true">
                    <div data-options="region:'center',title:'已分配客户'">
                        <table id="Customer">
                        </table>
                    </div>
                    <div data-options="region:'east'" style="width: 5%">
                        <div style="margin: 15px">
                        </div>
                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-back'"
                            onclick='Add()'></a>
                        <br />
                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true"
                            onclick='Delete()'>
                            <img src="images/go.png" /></a>
                    </div>
                </div>
            </div>
            <div data-options="region:'east',title:'可分配客户',collapsible:false" style="width: 49%">
                <table id="CustomerSelect">
                </table>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
