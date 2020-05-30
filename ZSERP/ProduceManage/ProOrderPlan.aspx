<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            if (Page.usetype == "add") {
                Page.setFieldValue("sSizeGroupID", "0901");
            }

            lookUp.beforeSetValue = function (uniqueid, data) {
                //uniqueid=60表示从订单生产明细转入
                if (uniqueid == "60") {
                    //赋值之前，获取尺码数量
                    var dataProc = data;
                    var iMainRecNoStr = "";

                    for (var i = 0; i < data.length; i++) {
                        iMainRecNoStr += "'" + data[i].iRecNo + "',";
                    }
                    if (data.length > 0) {
                        iMainRecNoStr = iMainRecNoStr.substr(0, iMainRecNoStr.length - 1);
                    }
                    iMainRecNoStr = "(" + iMainRecNoStr + ")";
                    var sqlObj = {
                        TableName: "vwSDContractDProduceDNotPlan",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "in",
                            Value: iMainRecNoStr
                        }
                        ],
                        Sorts: [
                            { SortName: "iRecNo", SortOrder: "asc" },
                            { SortName: "sSizeName", SortOrder: "asc" }
                        ]
                    };
                    var resultSize = SqlGetData(sqlObj);
                    if (resultSize && resultSize.length > 0) {
                        for (var i = 0; i < dataProc.length; i++) {
                            var iRecNo = dataProc[i].iRecNo;
                            for (var j = 0; j < resultSize.length; j++) {
                                if (iRecNo == resultSize[j].iRecNo) {
                                    dataProc[i][(resultSize[j].sSizeName)] = resultSize[j].iNotPlanQty;
                                }
                            }
                        }
                    }
                    return dataProc;
                }
            }

            lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
                //uniqueid=60表示从订单生产明细转入
                if (uniqueid == "60") {
                    var rows = $("#table1").datagrid("getRows");
                    for (var i = 0; i < rows.length; i++) {
                        if (rows[i].iSdContractDProduceRecNo == row.iSdContractDProduceRecNo) {
                            Page.MessageShow("不可转入", "不可转入相同数据！");
                            return false;
                        }
                    }
                    var dynColumns = Page.Children.GetDynColumns("table1");
                    for (var i = 0; i < dynColumns.length; i++) {
                        if (data[index][(dynColumns[i])]) {
                            row[(dynColumns[i])] = data[index][(dynColumns[i])];
                        }
                    }
                    return row;
                }
            }

            lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {
                //uniqueid=60表示从订单生产明细转入
                if (uniqueid == "60") {
                    //var rows = $("#table1").datagrid("getRows")[rowIndex];
                    Page.Children.DynFieldRowSummary("table1", rowIndex);
                }
            }
            lookUp.afterSelected = function (uniqueid, data) {
                //uniqueid=60表示从订单生产明细转入
                if (uniqueid == "60") {
                    Page.Children.ReloadFooter("table1");
                    Page.Children.ReloadDynFooter("table1");
                }
            }
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden; height: 200px;">
            <!--如果只有一个主表，这里的north要变为center-->
            <div id="divHiden">
                <!--隐藏字段位置-->
                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sDeptID" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        生产单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sProOrderNo" Z_readOnly="True"
                            Z_Required="False" />
                    </td>
                    <td>
                        计划日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        尺码组
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sSizeGroupID" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iPur" />
                        <label id="labPur" for="__ExtCheckbox21">
                            是否采购</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id="divCut" class="easyui-panel" data-options="title:'裁剪',width:250,height:130"
                            style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td>
                                        计划开始时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dCutPlanBeginDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        计划结束时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dCutPlanEndDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sCutDeptID" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td colspan="2">
                        <div id="div1" class="easyui-panel" data-options="title:'缝制',width:250,height:130"
                            style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td>
                                        计划开始时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dSewPlanBeginDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        计划结束时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dSewPlanEndDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sSewDeptID" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td colspan="2">
                        <div id="div2" class="easyui-panel" data-options="title:'手工',width:250,height:130"
                            style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td>
                                        计划开始时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dOutPlanBeginDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        计划结束时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dOutPlanEndDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sOutDeptID" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td colspan="2">
                        <div id="div3" class="easyui-panel" data-options="title:'后道',width:250,height:130"
                            style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td>
                                        计划开始时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dLastPlanBeginDate"
                                            Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        计划结束时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dLastPlanEndDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        车间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sLastDeptID" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        生产总数
                    </td>
                    <td>
                        &nbsp;
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Width="91px" Z_FieldID="iQty" Z_readOnly="True" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        &nbsp;
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_readOnly="True" Z_FieldID="sUserID" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        &nbsp;
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_readOnly="True" Z_FieldID="dInputDate"
                            Z_FieldType="时间" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="生产明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="ProOrderPlanD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
