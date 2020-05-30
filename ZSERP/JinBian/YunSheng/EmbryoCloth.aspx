<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master"  %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                Page.setFieldValue("iMatType", getQueryString("iMatType"));
            }
        })
        //Page.Children.onAfterEdit = function (tableid, index, row, changes) {
        //    if (tableid == "table3") {
        //        if ((datagridOp.currentColumnName == "sLength" && changes.sLength) || (datagridOp.currentColumnName == "sCount" && changes.sCount) || (datagridOp.currentColumnName == "sCode" && changes.sCode != undefined && changes.sCode != null)) {
        //            var sLength = isNaN(parseFloat(row.sLength)) ? 0 : parseFloat(row.sLength);
        //            var iDenier = isNaN(parseFloat(row.iDenier)) ? 0 : parseFloat(row.iDenier);
        //            var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));
        //            var sCount = isNaN(parseFloat(row.sCount)) ? 0 : parseFloat(row.sCount);
        //            var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
        //            row.fWtmTmp = sss;
        //            var rows = $("#" + tableid).datagrid("getRows");
        //            var sum = 0;
        //            for (var i = 0; i < rows.length; i++) {
        //                sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
        //            }
        //            if (sum > 0) {
        //                row.fSrate = (sss / sum) * 100;
        //                for (var i = 0; i < rows.length; i++) {
        //                    $("#" + tableid).datagrid("updateRow", { index: i, row: { fSrate: (rows[i].fWtmTmp / sum) * 100 } });
        //                }
        //                var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
        //                var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
        //                Page.setFieldValue("sOutPut", saaa);
        //            }
        //            else {
        //                Page.setFieldValue("sOutPut", "");
        //                for (var i = 0; i < rows.length; i++) {
        //                    $("#" + tableid).datagrid("updateRow", { index: i, row: { fSrate: null } });
        //                }
        //            }
        //        }
        //    }
        //}

        Page.beforeSave = function () {
            var sqlCheckObj = {
                TableName: "bscDataMat",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + Page.getFieldValue("sCode") + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iRecNo",
                        ComOprt: "<>",
                        Value: "'" + Page.key + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlCheckObj);
            if (result.length > 0) {
                Page.MessageShow("坯布编号不能重复", "对不起，坯布编号不能重复！");
                return false;
            }

            /*var sModelType = Page.getFieldValue("sModelType");
            if (sModelType.indexOf("'") > -1) {
                Page.MessageShow("机台型号不能包含特殊字符", "机台型号中不能包含特殊字符：'(单引号),请用：\"（双引号）代替！");
                return false;
            }*/
        }

        //Page.Formula = function (field) {
        //    if (Page.isInited == true) {
        //        if (field == "iSumQty") {
        //            var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));

        //            var rows = $("#table3").datagrid("getRows");

        //            for (var i = 0; i < rows.length; i++) {
        //                var sLength = isNaN(parseFloat(rows[i].sLength)) ? 0 : parseFloat(rows[i].sLength);
        //                var iDenier = isNaN(parseFloat(rows[i].iDenier)) ? 0 : parseFloat(rows[i].iDenier);
        //                var sCount = isNaN(parseFloat(rows[i].sCount)) ? 0 : parseFloat(rows[i].sCount);
        //                var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
        //                //var fSrate = sum == 0 ? 100 : (row.fWtmTmp / sum) * 100
        //                $("#table3").datagrid("updateRow", { index: i, row: { fWtmTmp: sss } });
        //            }
        //            var sum = 0;
        //            for (var i = 0; i < rows.length; i++) {
        //                sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
        //            }
        //            for (var i = 0; i < rows.length; i++) {
        //                var fSrate = sum == 0 ? 100 : (rows[i].fWtmTmp / sum) * 100
        //                $("#table3").datagrid("updateRow", { index: i, row: { fSrate: fSrate } });
        //            }
        //        }
        //        if (field == "sRev" || field == "iWorkTime" || field == "iSumQty") {
        //            var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
        //            var rows = $("#table3").datagrid("getRows");
        //            var sum = 0;
        //            for (var i = 0; i < rows.length; i++) {
        //                sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
        //            }
        //            if (sum > 0) {
        //                var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
        //                Page.setFieldValue("sOutPut", saaa);
        //            }

        //        }
        //    }
        //}

        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "table3") {
                //caleUse();
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1117") {
                //caleUse();
            }
        }

        function caleUse() {
            var rows = $("#table3").datagrid("getRows");

            for (var i = 0; i < rows.length; i++) {
                var sLength = isNaN(parseFloat(rows[i].sLength)) ? 0 : parseFloat(rows[i].sLength);
                var iDenier = isNaN(parseFloat(rows[i].iDenier)) ? 0 : parseFloat(rows[i].iDenier);
                var iSumQty = isNaN(parseFloat(Page.getFieldValue("iSumQty"))) ? 0 : parseFloat(parseFloat(Page.getFieldValue("iSumQty")));
                var sCount = isNaN(parseFloat(rows[i].sCount)) ? 0 : parseFloat(rows[i].sCount);
                var sss = iDenier * 0.11 * sLength * iSumQty / 50 * sCount;
                $("#table3").datagrid("updateRow", { index: i, row: { fWtmTmp: sss } });
            }

            var sum = 0;
            for (var i = 0; i < rows.length; i++) {
                sum += (isNaN(parseFloat(rows[i].fWtmTmp)) ? 0 : parseFloat(rows[i].fWtmTmp));
            }
            if (sum > 0) {
                //row.fSrate = (sss / sum) * 100;
                for (var i = 0; i < rows.length; i++) {
                    $("#table3").datagrid("updateRow", { index: i, row: { fSrate: (rows[i].fWtmTmp / sum) * 100 } });
                }
                var sRev = isNaN(parseFloat(Page.getFieldValue("sRev"))) ? 0 : parseFloat(Page.getFieldValue("sRev"));
                var saaa = (sRev * Page.getFieldValue("iWorkTime") * sum / 100000000).toFixed(2);
                Page.setFieldValue("sOutPut", saaa);
            }
            else {
                Page.setFieldValue("sOutPut", "");
                for (var i = 0; i < rows.length; i++) {
                    //if (i != index) {
                    $("#table3").datagrid("updateRow", { index: i, row: { fSrate: null } });
                    //}
                }
            }
        }

        function setGYChar(obj) {
            if (datagridOp.current.id == "table2") {
                var updateRow = {};
                updateRow[(datagridOp.currentColumnName)] = obj.innerHTML;
                $("#table2").datagrid("updateRow", { index: datagridOp.currentRowIndex, row: updateRow });
            }
        }

        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpBscDataMatTechModifyCheck",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result);
            }
            else {
                //GridRefresh();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden; padding-top:20px;">
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iWarp" Z_Value="1" />
                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iMatType" />
            </div>
            <table class="tabmain">
                <tr>
                    <td>坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sName" />
                    </td>
                    <td>类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" />
                    </td>                    
                </tr>
                <tr>
                    
                    <td>
                        生产类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iProduceType" />
                    </td>
                     <td>
                        生产厂家
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iProduceBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                    </td>
                    <td>克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                    </td>
                    <td>落布米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fFullLength" Z_FieldType="整数" />
                    </td>
                    <td>停用日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox51" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                    </td>
                    <td>录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" Z_readOnly="True" />
                    </td>
                    <td>备注</td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sRemark" Style="width: 99%" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="纱线用量">
                    <table id="table3" tablename="bscDataMatDWaste">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

