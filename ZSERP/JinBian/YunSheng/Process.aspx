<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var dataOdd=[];
        $(function () {
            if (Page.usetype != "add") {                
                var sqlObjDD = {
                    TableName: "vwBscDataProcessesDD",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNoM", ComOprt: "=", Value: Page.key
                        }
                    ],
                    Sorts: [
                        { SortName: "iSerialP", SortOrder: "asc" },
                        { SortName: "iSerial", SortOrder: "asc" }
                    ]
                }
                dataOdd = SqlGetData(sqlObjDD);                
            }
        })

        Page.Children.onBeforeAddRow = function (tableid) {
            if (tableid == "tableDD") {
                if (selectDRecNo == undefined) {
                    Page.MessageShow("请先点击项目", "请先点击项目");
                    return false;
                }
            }
            
        }

        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid == "tableDD") {
                if (selectDRecNo == undefined) {
                    Page.MessageShow("请先点击项目", "请先点击项目");
                }
                var allRows = $("#tableDD").datagrid("getRows");                
                $("#tableDD").datagrid("updateRow", { row: { iMainRecNo: selectDRecNo, sProjectName: selectProject }, index: allRows.length - 1 });
                var appRow = allRows[allRows.length - 1];
                var theRowss = dataOdd.filter(function (p) {
                    return p.iRecNO == appRow.iRecNo;
                })
                if (theRowss.length == 0) {
                    dataOdd.push(appRow);
                }
            }
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {
            if (tableid == "tableDD") {                
                for (var i = 0; i < dataOdd.length; i++) {
                    if (dataOdd[i].iRecNo == row.iRecNo) {
                        dataOdd[i].iMainRecNo = row.iMainRecNo;
                        dataOdd[i].iSerial = row.iSerial;
                        dataOdd[i].sValue = row.sValue;
                        dataOdd[i].sProjectName = row.sProjectName;
                    }
                }
            }
        }

        Page.Children.onAfterDeleteRow = function (tableid,rows) {
            for (var i = 0; i < rows.length; i++) {
                for (var j = 0; j < dataOdd.length; j++) {
                    if (rows[i].iRecNo == dataOdd[j].iRecNo) {
                        dataOdd.splice(j, 1);
                        break;
                    }
                }
            }
        }

        var selectDRecNo = undefined;
        var selectProject = undefined;
        Page.Children.onClickRow = function (tableid, index, row) {
            if (tableid == "BscDataProcessesD") {
                var allRowsDD = $("#tableDD").datagrid("getRows");
                for (var i = 0; i < allRowsDD.length; i++) {
                    $("#tableDD").datagrid("endEdit", i);
                }
                selectDRecNo = row.iRecNo;
                selectProject = row.sProjectName;


                $("#txbCurt").val(selectProject);
                var theRows = dataOdd.filter(function (p) {
                    return p.iMainRecNo == selectDRecNo;
                })
                $("#tableDD").datagrid("loadData", theRows);
                
            }
            else if (tableid == "tableDD") {
                var allRowsD = $("#BscDataProcessesD").datagrid("getRows");
                for (var i = 0; i < allRowsD.length; i++) {
                    $("#BscDataProcessesD").datagrid("endEdit", i);
                }
            }

        }

        Page.beforeSave = function () {
            $("#tableDD").removeAttr("tablename");
            var Str = "";
            for (var i = 0; i < dataOdd.length; i++) {
                Str += dataOdd[i].iMainRecNo + "," + (dataOdd[i].iSerial == null || dataOdd[i].iSerial == undefined ? "null" : dataOdd[i].iSerial) + ",'" + dataOdd[i].sValue + "'`";
            }
            if (Str != "") {
                Str = Str.substr(0, Str.length - 1);
            }
            var jsonobj = {
                StoreProName: "SpBscDataProcessesDDSave",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }, {
                    ParmName: "@sStr",
                    Value: Str,
                    Size:-1
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                Page.MessageShow("保存参数失败", result);
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
                        工序编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sProcessesCode"/>
                    </td>
                    <td>
                        工序名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sProcessesName" />
                    </td>
                    <td>
                        类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iFeedType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        损耗
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fLoss"  Z_FieldType="数值" Z_decimalDigits="2"/>
                    </td>
                    <td>
                        生产类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iProduceType" />
                    </td>
                     <td>
                        必填
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iRequired" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" style="width:99%;"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                    <td>
                        当前选择项目：
                    </td>
                    <td>
                        <input id="txbCurt" type="text" style="color:red; font-weight:bold;font-size:18px;width:150px; border:none;border-bottom:solid 1px #e0e0e0;" readonly="readonly" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',border:true,title:'工序要求项目',split:true" style="width:600px;">
                    <table id="BscDataProcessesD" tablename="BscDataProcessesD">
                    </table>
                </div>
               <%-- <div data-options="region:'center',border:true,title:'项目值'">
                    <table id="tableDD" tablename="BscDataProcessesDD"></table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
