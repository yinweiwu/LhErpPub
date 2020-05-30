<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (getQueryString("iBillType") == "3") {
                $("#sBarCodeTable").hide();
            }
            var sqlObj = {
                //表名或视图名
                TableName: "vwMMStockProductInM",
                //选择的字段
                Fields: "sYearMonth",
                //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                SelectAll: "True",
                //过滤条件，数组格式
                Filters: [
                    {
                        //左括号
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                ]
            }
            var data = SqlGetData(sqlObj);

            if (data.length > 0) {
                Page.setFieldValue("sYearMonth", data[0].sYearMonth);
            }
            Page.Children.toolBarBtnDisabled("MMStockProductInD", "add");
        })

        Page.beforeSave = function () {
            var d = Page.getFieldValue("dDate");
            Page.setFieldValue("sYearMonth", d.substring(0, 7));
        }

        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }

        function TrayScan() {
            if (event.keyCode == 13) {
                stopBubble($("#txtTrayCode")[0]);
                var TrayCode = $("#txtTrayCode").val();
                if (TrayCode != "") {
                    var sqlObj = {
                        TableName: "BscDataTray",
                        Fields: "1",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sCode",
                                ComOprt: "=",
                                Value: "'" + TrayCode + "'"
                            }
                        ]
                    }
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        Page.setFieldValue("sTrayCode", TrayCode);
                        PlayVoice("/sound/success.wav");
                    } else {
                        PlayVoice("/sound/error.wav");
                        alert("托盘号不存在");
                        $("#txtTrayCode").val("");
                        $("#txtTrayCode").focus();
                        return false;
                    }
                }
                $("#txtTrayCode").val("");
                stopBubble($("#txtTrayCode")[0]);
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
                return false;
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {

                    var rows = $("#MMStockProductInD").datagrid("getRows");
                    for (var j = 0; j < rows.length; j++) {
                        if (barcode == rows[j].sBarCode) {
                            PlayVoice("/sound/error.wav");
                            alert("已扫描");
                            return false;
                        }
                    }


                    var sqlObj = {
                        //表名或视图名
                        TableName: "vwSDOrderDDVatNoDReelNo as a left join (select a.sBarCode,a.iRecNo from MMStockProductInD a inner join MMStockProductInM b on a.iMainRecNo=b.iRecNo and b.iStatus>3) b on a.sBarcode=b.sBarCode left join SDContractDProcessD c on a.iSDOrderDRecNo=c.iSDContractDRecNo and c.iBscDataProcessMRecNo=a.iBscDataProcessMRecNo",
                        //选择的字段
                        Fields: "a.*,c.iRecNo as iSDContractDProcessDRecNo,case when exists(select 1 from dbo.MMStockProductOutM aa INNER JOIN dbo.MMStockProductOutD bb ON aa.iRecNo=bb.iMainRecNo AND aa.iStatus>3 AND bb.sBarCode=a.sBarcode AND aa.iBillType=4) THEN 0 else b.iRecNo end as iStockRecNo",
                        //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                        SelectAll: "True",
                        //过滤条件，数组格式
                        Filters: [
                            { 
                                Field: "a.iRepair", 
                                ComOprt: "=", 
                                Value: 0, 
                                LinkOprt: "and"
                            },{
                                //左括号
                                //字段名
                                Field: "a.sBarCode",
                                //比较符
                                ComOprt: "=",
                                //值
                                Value: "'" + barcode + "'"
                            }
                        ]
                    }
                    var data = SqlGetData(sqlObj);

                    if (data.length > 0) {
                        if (data[0].iStockRecNo > 0) {
                            PlayVoice("/sound/error.wav");
                            alert("条码已入库");
                            return false;
                        }
                        if (data[0].iRepair == 1) {
                            PlayVoice("/sound/error.wav");
                            alert("条码已经二次验布，请扫描新条码");
                            return false;
                        } 
                        var allRows = $("#MMStockProductInD").datagrid("getRows"); 
                        if (allRows.length > 0) { 
                            if (allRows[0].iSdOrderMRecNo != data[0].iSdOrderMRecNo && ((data[0].iSdOrderMRecNo != "" && data[0].iSdOrderMRecNo != undefined) || (allRows[0].iSdOrderMRecNo != "" && allRows[0].iSdOrderMRecNo != undefined))) {
                                PlayVoice("/sound/error.wav");
                                alert("条码订单不同,不能入库");
                                return false;
                            }
                        }


                        data[0].sBarCode = data[0].sBarcode;
                        data[0].sBatchNo = data[0].sVatNo;
                        data[0].iSdOrderMRecNo = data[0].iSDOrderMRecNo;
                        data[0].iSDOrderDDVatNoDReelNoRecNo = data[0].iRecNo;
                        data[0].sInputUserName = data[0].sCheckPersonName;
                        data[0].sCompany = '01';
                        data[0].sMachineID;
                        data[0].fQty = data[0].fRealQty;
                        data[0].fPurQty = data[0].fWeight;
                        Page.tableToolbarClick("add", "MMStockProductInD", data[0]);

                        PlayVoice("/sound/success.wav");
                    } else {
                        PlayVoice("/sound/error.wav");
                        alert("条码不存在");
                        return false;
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtHidden2 ID="ExtHidden4" Z_FieldID="iRed" Z_Value="0" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden5" Z_FieldID="iBscDataCustomerRecNo" Z_Value="0" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="2" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iMatType" Z_Value="2" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="sReMark" Z_Value="扫托盘入库" runat="server" />
                <%--<cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="iSdOrderMRecNo" runat="server" />--%>
                
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        入库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="150px" />
                    </td>
                    <td>
                        仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Width="150px" />
                    </td>
                </tr>
                <tr> 
                    <td>
                        托盘号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTrayCode" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td style="margin-left: 40px">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        入库数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                            Width="150px" />
                    </td>
                </tr>
                
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="150px" />
                    </td>
                    
                </tr>
            </table>
            <table id="sBarCodeTable">
                            <tr>
                                <td>
                                    <strong style="font-size:xx-large">托盘号</strong>
                                </td>
                                <td>
                                    <input id="txtTrayCode" onkeydown="TrayScan()" type="text" title="请刷入托盘号" style="width: 200px;
                                                        height: 50px; font-size: 20px; font-weight: bold;background-color:pink;" class="txb" />
                                </td>
                                <td>
                                    <strong style="font-size:xx-large">条 码</strong>
                                </td>
                                <td>
                                    <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 200px;
                                                        height: 50px; font-size: 20px; font-weight: bold;background-color:pink;" class="txb" />
                                </td>
                            </tr>
             </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--  子表1  -->
                    <table id="MMStockProductInD" tablename="MMStockProductInD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>