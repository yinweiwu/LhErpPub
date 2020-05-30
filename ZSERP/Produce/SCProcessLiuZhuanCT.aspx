<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style type="text/css">
        .auto-style1 {
            height: 20px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var sBarCode = $("#txtBarcode").val();
                $("#txtBarcode").val("");
                var len = 0;
                for (var i = 0; i < sBarCode.length; i++) {
                    var a = sBarCode.charAt(i);
                    if (a.match(/[^\x00-\xff]/ig) != null) {
                        len += 2;
                    }
                    else {
                        len += 1;
                    }
                }
                if (len == 7) {
                    var sqlObj = {
                        TableName: "vwbscDataPerson",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                                    {
                                        Field: "sCode",
                                        ComOprt: "=",
                                        Value: "'" + sBarCode + "'",
                                    }
                        ]
                    };
                    var result = SqlGetData(sqlObj);
                    Page.setFieldValue("sProcessCode", result[0]['sCode']);
                    Page.setFieldValue("sSCGroup", result[0]['sSCGroup']);
                    Page.setFieldValue("sProcessPostName", result[0]['sSCPostName']);
                    Page.setFieldValue("fPostRate", result[0]['fPostRate']);

                    var date = new Date();
                    var date1 = date.toLocaleDateString();
                    var sqlObjSCProcessLiuZhuanD = {
                        TableName: "vwSCProcessLiuZhuanM",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                                    {
                                        Field: "sProcessCode",
                                        ComOprt: "=",
                                        Value: "'" + sBarCode + "'",
                                        LinkOprt: "and"
                                    },
                                    {
                                        Field: "dDate",
                                        ComOprt: "=",
                                        Value: "'" + date1 + "'",
                                    }
                        ],
                        Sorts: [
                           {
                               SortName: "dInputdate",
                               SortOrder: "desc"
                           }
                        ]

                    };
                    var resultSCProcessLiuZhuanD = SqlGetData(sqlObjSCProcessLiuZhuanD);
                    if (resultSCProcessLiuZhuanD.length > 0) {
                        $("#SCProcessLiuZhuanD").datagrid("loadData", resultSCProcessLiuZhuanD);
                        $("#SCProcessLiuZhuanD").datagrid(
                        {
                            fit: true,
                            border: false,
                            remoteSort: false,
                            columns: [[
                                { title: "作废", field: 'bStop1', checkbox: true },
                                { title: "工艺卡号", field: "sBillNo", width: 110, sortable: true },
                                { title: "车间", field: "sSCClassID", width: 100, sortable: true },
                                { title: "当前道次", field: "iCurDaoCi", width: 100, sortable: true },
                                { title: "当前工序编码", field: "sCurProcessNo", width: 100, sortable: true },
                                { title: "当前工序名称", field: "sProcessName", width: 80, sortable: true },
                                { title: "当前外径", field: "fCurOutDiameter", width: 80, sortable: true },
                                { title: "当前壁厚", field: "fCurWallHeight", width: 80, sortable: true },
                                { title: "当前支数", field: "fCurPurQty", width: 80, sortable: true },
                                { title: "当前重量", field: "fCurQty", width: 80, sortable: true },
                                { title: "操作者工号", field: "sProcessCode", width: 80, sortable: true },
                                { title: "操作工姓名", field: "sName", width: 80, sortable: true },
                                { title: "操作工岗位", field: "sProcessPostName", width: 80, sortable: true },
                                { title: "岗位系数", field: "fPostRate", width: 80, sortable: true },
                                { title: "工序分值", field: "fProcessValue", width: 80, sortable: true },
                                { title: "工作后支数", field: "fWorkPurQty", width: 80, sortable: true },
                                { title: "工作后重量", field: "fWorkQty", width: 80, sortable: true },
                                { title: "工作后长度", field: "fWorkLength", width: 80, sortable: true },
                                { title: "产量积分", field: "sWorkpoints", width: 80, sortable: true },
                                { title: "当前计产单位", field: "sCurProductionUnit", width: 80, sortable: true },
                                { title: "当前计产方式", field: "sCurProductionMode", width: 80, sortable: true },
                                { title: "磨具尺寸和实测记录", field: "sMoJuShiCeJiLu", width: 150, sortable: true },
                                { title: "首检记录", field: "sShouJian", width: 150, sortable: true },
                                { title: "检验员", field: "sjianyanName", width: 80, sortable: true },
                                { title: "备注", field: "sReMark", width: 80, sortable: true },
                                { title: "制单时间", field: "dInputDate", width: 80, sortable: true },
                                { field: "iRecNo", hidden: true },
                            ]],
                        })
                    }
                    else if (resultSCProcessLiuZhuanD.length == 0) {
                        var date = new Date();
                        var date1 = date.toLocaleDateString();
                        var sUserID = Page.userid;
                        var sqlObjSCProcessLiuZhuanD1 = {
                            TableName: "vwSCProcessLiuZhuanM",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                        {
                                            Field: "sUserID",
                                            ComOprt: "=",
                                            Value: "'" + sUserID + "'",
                                            LinkOprt: "and"
                                        },
                                        {
                                            Field: "dDate",
                                            ComOprt: "=",
                                            Value: "'" + date1 + "'",
                                        }
                            ]

                        };
                        var resultSCProcessLiuZhuanD1 = SqlGetData(sqlObjSCProcessLiuZhuanD1);
                        $("#SCProcessLiuZhuanD").datagrid("loadData", resultSCProcessLiuZhuanD1);
                        $("#SCProcessLiuZhuanD").datagrid(
                        {
                            fit: true,
                            border: false,
                            remoteSort: false,
                            columns: [[
                                { title: "作废", field: 'bStop1', checkbox: true },
                                { title: "工艺卡号", field: "sBillNo", width: 110, sortable: true },
                                { title: "车间", field: "sSCClassID", width: 100, sortable: true },
                                { title: "当前道次", field: "iCurDaoCi", width: 100, sortable: true },
                                { title: "当前工序编码", field: "sCurProcessNo", width: 100, sortable: true },
                                { title: "当前工序名称", field: "sProcessName", width: 80, sortable: true },
                                { title: "当前外径", field: "fCurOutDiameter", width: 80, sortable: true },
                                { title: "当前壁厚", field: "fCurWallHeight", width: 80, sortable: true },
                                { title: "当前支数", field: "fCurPurQty", width: 80, sortable: true },
                                { title: "当前重量", field: "fCurQty", width: 80, sortable: true },
                                { title: "操作者工号", field: "sProcessCode", width: 80, sortable: true },
                                { title: "操作工姓名", field: "sName", width: 80, sortable: true },
                                { title: "操作工岗位", field: "sProcessPostName", width: 80, sortable: true },
                                { title: "岗位系数", field: "fPostRate", width: 80, sortable: true },
                                { title: "工序分值", field: "fProcessValue", width: 80, sortable: true },
                                { title: "工作后支数", field: "fWorkPurQty", width: 80, sortable: true },
                                { title: "工作后重量", field: "fWorkQty", width: 80, sortable: true },
                                { title: "工作后长度", field: "fWorkLength", width: 80, sortable: true },
                                { title: "产量积分", field: "sWorkpoints", width: 80, sortable: true },
                                { title: "当前计产单位", field: "sCurProductionUnit", width: 80, sortable: true },
                                { title: "当前计产方式", field: "sCurProductionMode", width: 80, sortable: true },
                                { title: "磨具尺寸和实测记录", field: "sMoJuShiCeJiLu", width: 150, sortable: true },
                                { title: "首检记录", field: "sShouJian", width: 150, sortable: true },
                                { title: "检验员", field: "sjianyanName", width: 80, sortable: true },
                                { title: "备注", field: "sReMark", width: 80, sortable: true },
                                { title: "制单时间", field: "dInputDate", width: 80, sortable: true },
                                { field: "iRecNo", hidden: true },
                            ]],
                        })
                    }
                }
                else if (len == 8) {

                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div id="divHid" style="display: none;">

                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sDeptID" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        工序完成
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckBox1" runat="server" Z_FieldID="fProcessFinish" />
                    </td>
                </tr>
                <tr>
                    <td>生产日期</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="dDate" Z_FieldType="日期" Z_Required="True" />
                    </td>
                    <td>工艺卡号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iSCTouChanMRecNo" Z_readOnly="True" />
                    </td>
                    <td>车间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sSCClassID" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td colspan="6" class="auto-style1" style="vertical-align:top;">
                        <div class="easyui-panel" style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td colspan="6">来料情况：</td>
                                </tr>
                                <tr>
                                    <td width="50">道次</td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iBeforeDaoCi" Z_readOnly="True" />
                                    </td>
                                    <td width="50">工序名称
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sBeforeProcessNo" Z_readOnly="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50">外径
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fBeforeOutDiameter" Z_readOnly="True" />
                                    </td>
                                    <td width="50">壁厚
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fBeforeWallHeight" Z_readOnly="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50">支数
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fBeforePurQty" Z_readOnly="True" />
                                    </td>
                                    <td width="50">重量
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fBeforeQty" Z_readOnly="True" />
                                    </td>
                                    <td width="50">长度
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fBeforeLength" Z_readOnly="True" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td colspan="6" class="auto-style1" style="vertical-align:top;">
                        <div class="easyui-panel" style="padding: 10px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td colspan="6">当前情况:</td>
                                </tr>
                                <tr>
                                    <td width="50">道次</td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iCurDaoCi" />
                                    </td>
                                    <td width="50">工序名称
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sCurProcessNo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50">外径
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fCurOutDiameter" />
                                    </td>
                                    <td width="50">壁厚
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="fCurWallHeight" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50">支数
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fCurPurQty" />
                                    </td>
                                    <td width="50">重量
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fCurQty" />
                                    </td>
                                    <td width="50">长度
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fCurLength" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="50">计产方式
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCurProductionMode" Z_readOnly="True" />
                                    </td>
                                    <td width="50">计产单位
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sCurProductionUnit" Z_readOnly="True" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" style="vertical-align:top;">
                        <div class="easyui-panel" style="padding: 5px; text-align: center; vertical-align: middle;">
                            <table>
                                <tr>
                                    <td>流转信息：</td>
                                </tr>
                                <tr>
                                    <td>磨具尺寸和实测记录
                                    </td>
                                    <td>
                                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sMoJuShiCeJiLu" />
                                    </td>
                                    <td>首检记录
                                    </td>
                                    <td>
                                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sShouJian" />
                                    </td>
                                    <td>检验员
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sJianYanCode" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table>
                            <tr>
                                <td>备注
                                </td>
                                <td>
                                    <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sMoJuShiCeJiLu" />
                                </td>
                            </tr>
                            <tr>
                                <td>扫码
                                </td>
                                <td>
                                    <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 200px; height: 40px; font-size: 20px; font-weight: bold;"
                                        class="txb" />
                                </td>
                                <td colspan="2">
                                    <textarea id="sbarcoderemark" style="border: 0px; border-bottom: 1px solid black;"></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td colspan="6" style="vertical-align:top;">
                        <div class="easyui-panel" style="padding: 10px; text-align: center; vertical-align: middle;">
                            <table>                               
                                <tr>
                                    <td colspan="6">工作登记：</td>
                                </tr>
                                <tr>
                                    <td>操作工
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sProcessCode" Z_readOnly="True" Z_Required="True" />
                                    </td>
                                    <td>班组
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sSCGroup" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>岗位
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sProcessPostName" Z_readOnly="True" />
                                    </td>
                                    <td>岗位系数
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="fPostRate" Z_readOnly="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>外径
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fAfterOutDiameter" Z_Required="True" />
                                    </td>
                                    <td>壁厚
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fAfterWallHeight" Z_Required="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>支数
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fWorkPurQty" Z_Required="True" />
                                    </td>
                                    <td>重量
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="fWorkQty" Z_Required="True" />
                                    </td>
                                    <td>长度
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fWorkLength" Z_Required="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>加热温度
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="sYuanShiHeatTemperature" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>  
                <tr>
                    <td></td>
                </tr>              
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="工艺流转记录">
                    <!--  子表1  -->
                    <table id="SCProcessLiuZhuanD">
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'south',border:false">
            <table>
                <tr>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>

