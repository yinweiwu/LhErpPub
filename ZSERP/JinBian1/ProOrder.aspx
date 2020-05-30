<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var lastedSelectedIndex = undefined;
        Page.beforeLoad = function () {

        }
        $(function () {
            $("#tableStock").datagrid(
            {
                border: false,
                fit: true,
                singleSelect: true,
                remoteSort: false,
                columns: [
                    [
                        { field: "__sss", title: "选择", width: 60, align: "center", formatter: function (value, row, index) {
                            return "<a href='javascript:void(0)' onclick='select(" + index + ")' >选择</a>";
                        }
                        },
                        { field: "sCode", title: "物料编码", width: 100, align: "center" },
                        { field: "sName", title: "物料名称", width: 80, align: "center" },
                        { field: "sElements", title: "规格", width: 110, align: "center" },
                        { field: "sClassName", title: "物料分类", width: 80, align: "center" },
                        { field: "fQty", title: "数量", width: 70, align: "center" },
                        { field: "fPurQty", title: "箱数", width: 40, align: "center" },
                        { field: "iQty", title: "个数", width: 40, align: "center" },
                        { field: "sBatchNo", title: "批号", width: 80, align: "center" },
                        { field: "sMatLevel", title: "物料等级", width: 60, align: "center" },
                        { field: "sCustShortName", title: "供应商", width: 80, align: "center" },

                        { field: "sOrderNo", title: "订单号", width: 80, align: "center" },
                        { field: "sStockName", title: "仓库", width: 100, align: "center" },
                        { field: "sBerChID", title: "仓位", width: 60, align: "center" },
                        { field: "iBscDataCustomerRecNo", hidden: true }
                    ]
                ],
                onDblClickRow: function (index, row) {
                    select(index);
                }
            }

            )

            if (Page.usetype == "modify") {
                $("#SDOrderDPro").datagrid({
                    onLoadSuccess: function (data) {
                        var rows = $("#SDOrderDPro").datagrid("getRows");
                        if (rows.length == 0) {
                            var sqlObj111 = {
                                TableName: "vwBscDataMatDWaste",
                                Fields: "iRecNo,iMainRecNo,iBscDataMatRecNo,sCode,sName,sElements,fSrate,iSerial,sLength",
                                SelectAll: "True",
                                Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: "'" + Page.getFieldValue("iBscDataFabRecNo") + "'"
                                }
                                ]
                            }
                            var result111 = SqlGetData(sqlObj111);
                            if (result111.length > 0) {
                                for (var i = 0; i < result111.length; i++) {
                                    var approw = {};
                                    approw.sCode = result111[i].sCode;
                                    approw.sName = result111[i].sName;
                                    approw.sElements = result111[i].sElements;
                                    approw.fYarnRate = result111[i].fSrate;
                                    approw.iBscDataMatRecNo = result111[i].iBscDataMatRecNo;
                                    approw.iSerial = result111[i].iSerial;
                                    approw.sLength = result111[i].sLength;
                                    Page.tableToolbarClick("add", "SDOrderDPro", approw);


                                }
                            }
                        }
                    }
                });

            }

            //            var sqlObjProduct = {
            //                TableName: "SDOrderD",
            //                Fields: "top 1 fProduceQty",
            //                SelectAll: "True",
            //                Filters: [
            //                    {
            //                        Field: "iMainRecNo",
            //                        ComOprt: "=",
            //                        Value: "'" + Page.key + "'"
            //                    }
            //                ]
            //            }
            //            var resultProduct = SqlGetData(sqlObjProduct);
            //            if (resultProduct.length > 0) {

            //            }

            Page.setFieldValue("iBscDataManufacturerRecNo", "736");

            if (Page.usetype == "modify" || Page.usetype == "view") {
                var sqlobj2 = { TableName: "vwSDOrderM_GMJ",
                    Fields: "sName,iBscDataFabRecNo,sBscDataFabCode,sBscDataFabName,fBscDataFabWidth,fBscDataFabWeight,fProductWidth,fProductWeight,fFabQty,sReMark,sUserName,sRollWeight",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                    ]

                }
                var data2 = SqlGetData(sqlobj2);

                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('iBscDataFabRecNo', data2[0].iBscDataFabRecNo);
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);
                Page.setFieldValue('sBscDataFabName', data2[0].sBscDataFabName);
                Page.setFieldValue('fBscDataFabWidth', data2[0].fBscDataFabWidth);
                Page.setFieldValue('fBscDataFabWeight', data2[0].fBscDataFabWeight);
                Page.setFieldValue('fProductWidth', data2[0].fProductWidth);
                Page.setFieldValue('fProductWeight', data2[0].fProductWeight);
                Page.setFieldValue('fFabQty', data2[0].fFabQty);
                Page.setFieldValue("sOrderRemark", data2[0].sReMark);
                Page.setFieldValue("sUserName", data2[0].sUserName);
                var options = $("#SDOrderDPro").datagrid("options");
                options.columns[0].splice(7, 0,
                {
                    title: "查看库存",
                    field: "__dddd",
                    formatter: function (value, row, index) {
                        return "<a href='javascript:void(0)' onclick='openwin(" + row.iBscDataMatRecNo + "," + index + ")'>查看库存</a>";
                    },
                    width: 70,
                    align: "center"
                }
                );
                $("#SDOrderDPro").datagrid(options);
            }

            if (Page.getFieldValue("sCode").indexOf("KF") > -1) {
                $("#isSample").show();
            }
        })
        Page.beforeSave = function () {
            //if (Page.getFieldValue("sProOrderNo") == "") {
            var sqlStoreObj = {
                StoreProName: "Yww_FormBillNoBulid",
                StoreParms: [{
                    ParmName: "@formid",
                    Value: getQueryString("iformid")
                }
                    ]
            };
            //var result = SqlExecStore("Yww_FormBillNoBulid", getQueryString("iformid"), false);
            var result = SqlStoreProce(sqlStoreObj);
            Page.setFieldValue('sProOrderNo', result);
            $("#SDOrderDFab").removeAttr("tablename");
        }
        Page.afterSave = function () {
            var message = "您有新<a href=\"#\" style=\"color:blue;text-decoration:underline;\" onclick=\"top.turntoTab(363,8991,'生产单','1=1','Base/FormList.aspx?','')\">生产单</a>需要完成，坯布编号：【" + Page.getFieldValue("sBscDataFabCode") + "】，请尽快完成，谢谢！";
            var sqlObjUser = {
                TableName: "bscDataPerson",
                Fields: "sCode",
                SelectAll: "True",
                Filters: [
                {
                    Field: "sJobRole",
                    ComOprt: "like",
                    Value: "'工艺员'"
                }
                ]
            }
            var resultUser = SqlGetData(sqlObjUser);
            if (resultUser.length > 0) {
                for (var i = 0; i < resultUser.length; i++) {
                    var jsonobj = {
                        StoreProName: "SpSendMessage",
                        StoreParms: [
                        {
                            ParmName: "@sSendUserID",
                            Value: Page.userid
                        },
                        {
                            ParmName: "@sReceiveID",
                            Value: resultUser[i].sCode
                        },
                        {
                            ParmName: "@sMessage",
                            Size: 1000,
                            Value: message
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result != "1") {
                        alert(result);
                    }
                }
            }
        }

        $(function () {
            Page.Children.toolBarBtnDisabled("SDOrderDPro", "add");
        })
        //        lookUp.afterSelected = function (uniqueid, index, data, row) {
        //            if (uniqueid == "276") {
        //                var rows = $("#SDOrderDPro").datagrid("getRows");
        //                var fFabQty = isNaN(parseFloat(Page.getFieldValue("fFabQty"))) ? 0 : parseFloat(Page.getFieldValue("fFabQty"));
        //                for (var i = 0; i < rows.length; i++) {
        //                    var rate = (isNaN(parseFloat(rows[i].fYarnRate)) ? 0 : parseFloat(rows[i].fYarnRate)) / 100;
        //                    var matUse = fFabQty * rate;
        //                    $("#SDOrderDPro").datagrid("updateRow", { index: i, row: { fSrate: matUse} });
        //                }
        //            }
        //        }
        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "fProduceQty") {
                    var rows = $("#SDOrderDPro").datagrid("getRows");
                    var fProduceQty = isNaN(parseFloat(Page.getFieldValue("fProduceQty"))) ? 0 : parseFloat(Page.getFieldValue("fProduceQty"));
                    for (var i = 0; i < rows.length; i++) {
                        var rate = (isNaN(parseFloat(rows[i].fYarnRate)) ? 0 : parseFloat(rows[i].fYarnRate)) / 100;
                        var matUse = fProduceQty * rate;
                        $("#SDOrderDPro").datagrid("updateRow", { index: i, row: { fSrate: matUse, fNeedQty: matUse} });
                    }
                }
            }
        }

        function openwin(iBscDataMatRecNo, index) {
            lastedSelectedIndex = index;
            var sqlObjMat = {
                TableName: "vwMMStockQty",
                Fields: "sCode,sName,sElements,sClassName,fQty,fPurQty,iQty,sBatchNo,sMatLevel,sCustShortName,sOrderNo,sStockName,sBerChID,iBscDataCustomerRecNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataMatRecNo",
                        ComOprt: "=",
                        Value: "'" + iBscDataMatRecNo + "'"
                    }
                ]
            }
            var resultStock = SqlGetData(sqlObjMat);
            if (resultStock.length > 0) {
                $("#tableStock").datagrid("loadData", resultStock);
                $("#divStock").window("open");
            }
            else {
                $("#tableStock").datagrid("loadData", []);
                $.messager.alert("没有库存", "此物料没有库存！");
            }
        }
        function select(index) {
            var rowsStock = $("#tableStock").datagrid("getRows");
            var rowSelected = rowsStock[index];
            $("#SDOrderDPro").datagrid("updateRow", {
                index: lastedSelectedIndex,
                row:
                {
                    iStockBscDataCustomerRecNo: rowSelected.iBscDataCustomerRecNo,
                    sYarnBatchNo: rowSelected.sBatchNo,
                    sYarnProduction: rowSelected.sCustShortName
                }
            });
            $("#divStock").window("close");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        生产单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sProOrderNo" Z_readOnly="True" />
                    </td>
                    <td>
                        下单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dProDate" />
                    </td>
                    <td>
                        生产厂家
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataManufacturerRecNo" />
                    </td>
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOrderNo" Z_readOnly="True"
                            Z_NoSave="true" />
                    </td>
                </tr>
                <tr>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        坯布幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fBscDataFabWidth" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        产品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iBscDataMatRecNo" Z_readOnly="True"
                            Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCode" Z_readOnly="True"
                            Z_NoSave="true" style=" display:none;" />
                    </td>
                    <td>
                        产品幅宽
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="fProductWidth" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sBscDataFabName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        坯布克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iBscDataFabRecNo" Z_NoSave="True"
                            Style="display: none;" />
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fBscDataFabWeight" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        产品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        产品克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="fProductWeight" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        订单数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                            Z_NoSave="true" />
                    </td>
                    <td>
                        机台型号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sBscDataFabModelType"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                    <td>
                        转速
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sBscDataFabRev" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        生产交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期"
                            Z_NoSave="true" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        要求匹重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="sRollWeight" Z_readOnly="True" runat="server"
                            Z_NoSave="true" />
                    </td>
                    <td>
                        订单制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" Z_FieldID="sUserName" Z_readOnly="True" runat="server"
                            Z_NoSave="true" />
                    </td>
                    <td>
                        订单备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="352px" Z_FieldID="sOrderRemark"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <%--<td>
                        是否采购
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" Z_FieldID="iPurchaseStatus" runat="server" />
                    </td>--%>
                    <%--<td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iProLKFXStatus" />
                        <label for="__ExtCheckbox2">
                            是否留开幅线</label>
                    </td>--%>
                    <td>
                        带刨类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sProDaiPao" />
                    </td>
                    <td>
                        纸管类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sLightSources" />
                    </td>

                    <td>
                        投坯重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fFabQty" Z_FieldType="数值"
                            Z_readOnly="True" Z_decimalDigits="2" />
                    </td>
                    <td>
                        预计生产重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fProduceQty" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr style="display:none">                    
                    <td style="display:none">
                        外加工重量
                    </td>
                    <td style="display:none">
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="fOutProduceQty" Z_FieldType="数值"
                            Z_readOnly="True" Z_decimalDigits="2" />
                    </td>
                    
                </tr>
                <tr style="display: none;">
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Z_Required="False" Width="120px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="120px" />
                    </td>
                    <td colspan="2" id="isSample" style="display: none;">
                        <span style="color: Red; font-size: 20px; font-weight: bold;">样品开发</span>
                    </td>
                </tr>
            </table>
            <table class="tabmain">
                <tr>
                    <td class="style2">
                        备注
                    </td>
                    <td class="style1">
                        <textarea id="sProReMark" style="border-bottom: 1px solid black; width: 798px; border-left-style: none;
                            border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                            border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                            border-top-color: inherit; border-top-width: 0px;" fieldid="sProReMark"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="原料明细">
                    <table id="SDOrderDPro" tablename="SDOrderDPro">
                    </table>
                </div>
                <div data-options="fit:true" title="坯布要求">
                    <!--  子表2  -->
                    <table id="SDOrderDFab" tablename="SDOrderDFab">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="divStock" class="easyui-window" data-options="closed:true,closable:true,title:'当前库存',collapsible:false,minimizable:false,maximizable:false,modal:true,width:700,height:300">
        <table id="tableStock">
        </table>
    </div>
</asp:Content>
