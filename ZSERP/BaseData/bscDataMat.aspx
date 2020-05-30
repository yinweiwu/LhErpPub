<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        a:link
        {
            text-decoration: none;
        }
        a:visited
        {
            text-decoration: none;
        }
        .txb
        {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var sCode = "";
        var sClassID = "";
        $(function () {
            var sqlobj1 = { TableName: "BscDataColor",
                Fields: "sColorName",
                SelectAll: "True"
            }
            var data1 = SqlGetData(sqlobj1);
            var option = "<select id='Color' data-options='editable:true' fieldid='sMatColorName' class='easyui-combobox' style='width: 150px'>";
            option += "<option></option>";
            if (data1.length > 0) {
                for (var i = 0; i < data1.length; i++) {
                    option += "<option>" + data1[i].sColorName + "</option>";
                }
                $('#ColorName').html(option);
                $.parser.parse('#ColorName');
            }
            //            $('#ColorName').combobox({
            //                textField: 'sColorName',
            //                valueField: 'sColorName',
            //                data: griddata.Rows
            //            });

            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "copy");
            Page.Children.toolBarBtnDisabled("table3", "add");
            Page.Children.toolBarBtnDisabled("table3", "copy");

            sCode = Page.getFieldValue('sCode');
            sClassID = Page.getFieldValue('sClassID');
            setTimeout(getClassID, 1001); //延后执行

            var sqlobj = { TableName: "bscDataMat",
                Fields: "sMatColorName",
                SelectAll: "True",
                Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + sCode + "'"}]
            }
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                $('#Color').combobox('setValue', data[0].sMatColorName);
            }
            //            var queryParams = $("#table1").datagrid("options").queryParams;
            //            var linkField = $("#table1").attr("linkfield");
            //            var linkField0 = linkField.split("=")[0];
            //            var linkField0Value = Page.getFieldValue(linkField0);
            //            queryParams.key = linkField0Value;
            //            //加入其他的关联字段查询条件
            //            queryParams.filters = "sClassID='" + sClassID + "' or sClassID='" + sClassID + "'";
            //            $('#table1').datagrid('reload', queryParams);

        })

        function getClassID() {
            var ClassID = Page.getFieldValue('sClassID');
            var sqlobj3 = { TableName: "bscDataClass",
                Fields: "sParentID",
                SelectAll: "True",
                Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'mat'", RightParenthese: ")", LinkOprt: "and" },
                    { Field: "sClassID", ComOprt: "=", Value: "'" + ClassID + "'"}]
            }
            var data3 = SqlGetData(sqlobj3);
            if (data3.length > 0) {
                Page.setFieldValue('sParentID', data3[0].sParentID);
            }

            if (sClassID == "") {
                Page.Children.toolBarBtnDisabled("table1", "delete");
                var sqlobj1 = { TableName: "bscDataClassPropertyM",
                    Fields: "iRecNo as PropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
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
                        Page.tableToolbarClick("add", "table1", data1[i]);
                    }
                }

                var sqlobj = { TableName: "bscDataClass",
                    Fields: "sUnitID,sPurUnitID",
                    SelectAll: "True",
                    Filters: [{ LeftParenthese: "(", Field: "sType", ComOprt: "=", Value: "'mat'", RightParenthese: ")", LinkOprt: "and" },
                             { Field: "sClassID", ComOprt: "=", Value: "'" + ClassID + "'"}]
                };
                var data = SqlGetData(sqlobj);
                if (data.length > 0) {
                    var UnitID = data[0].sUnitID;
                    var PurUnitID = data[0].sPurUnitID;
                    if (UnitID != "" && UnitID != undefined && UnitID != null) {
                        Page.setFieldValue('sUnitName', UnitID);
                    }
                    if (PurUnitID != "" && PurUnitID != undefined && PurUnitID != null) {
                        Page.setFieldValue('sPurUnitName', PurUnitID);
                    }
                }
            }
            else {
                var result = $('#table1').datagrid('getRows');
                var sqlobj = { TableName: "bscDataClassPropertyM",
                    Fields: "iRecNo as PropertyMRecNo,sClassID,iSerial,sPropertyName,sReMark",
                    SelectAll: "True",
                    Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'" + sClassID + "'"}],
                    Sorts: [{
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }]
                };
                var data = SqlGetData(sqlobj);
                if (data.length != result.length) {
                    for (var i = 0; i < data.length; i++) {
                        Page.tableToolbarClick("add", "table1", data[i]);
                    }
                }
                else {
                    Page.Children.toolBarBtnDisabled("table1", "delete");
                }
            }
        }

        function AddProperty() {
            var PropertyName = "";
            var resultObject = $('#table1').datagrid('getRows');
            if (resultObject.length > 0) {
                for (var i = 0; i < resultObject.length; i++) {
                    var PValue = resultObject[i].sPropertyValue;
                    if (PValue != "" && PValue != undefined) {
                        PropertyName += PValue;
                    }
                    else {
                        $.messager.show({
                            title: '错误',
                            msg: '请检查属性值是否填写完整！',
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        PropertyName = "";
                        return false;
                    }
                }
                if (PropertyName != "") {
                    Page.setFieldValue('sName', "");
                    var ClassName = $('#__ExtTextBox2').textbox('getText');
                    PropertyName += ClassName;
                    Page.setFieldValue('sName', PropertyName);

                }
            }
            else {
                $.messager.show({
                    title: '提示',
                    msg: '属性值为空！',
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

        lookUp.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "167") {
                var rows = $("#table3").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].iBscDataStockDRecNo == row.iBscDataStockDRecNo) {
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
            var sClassID = Page.getFieldValue('sClassID');
            if (sClassID.length <= 2) {
                $.messager.show({
                    title: '错误',
                    msg: '根节点不能选作物料类别！',
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

            var Code1 = Page.getFieldValue('sCode');
            if (Code1 != "") {
                var sqlobj1 = { TableName: "bscDataPerson",
                    Fields: "iSupper",
                    SelectAll: "True",
                    Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Page.userid + "'"}]
                }
                var data1 = SqlGetData(sqlobj1);
                if (data1.length > 0) {
                    if (data1[0].iSupper != "1" || Page.userid != "master") {
                        if (sCode != Code1) {
                            $.messager.show({
                                title: '错误',
                                msg: '修改物料编码请联系超级用户！',
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

            var sqlObj = { TableName: "bscDataMat",
                Fields: "sCode",
                SelectAll: "True",
                Filters: [{ Field: "sCode", ComOprt: "=", Value: "'" + Code1 + "'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                if (sCode == "") {
                    $.messager.show({
                        title: '错误',
                        msg: '改物料编码已存在！',
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
                    if (sCode != Code1) {
                        $.messager.show({
                            title: '错误',
                            msg: '改物料编码已存在！',
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

            var fInRate = Page.getFieldValue('sCode');
            var fOutRate = Page.getFieldValue('fOutRate');
            if (fInRate != "") {
                if (fInRate <= 0) {
                    $.messager.show({
                        title: '错误',
                        msg: '入库超额上限需大于0！',
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
            if (fOutRate != "") {
                if (fOutRate <= 0) {
                    $.messager.show({
                        title: '错误',
                        msg: '出库超额上限需大于0！',
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <br />
            <table align="center" style="width: 80%">
                <tr>
                    <td width="70px">
                        物料编码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sCode" Z_Required="True" />
                    </td>
                    <td align="center">
                        物料名称
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sName" Z_Required="True"
                            Width="250px" />
                        <a href='javascript:void(0)' class="" data-options="plain:true" onclick='AddProperty()'>
                            <img src="images/add.ico" width="19px" /><span style="font-family: 隶书; font-size: 15px;">自动生成</span>
                        </a>
                    </td>
                    <td width="50px">
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sClassID" Z_Required="True" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="cc" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'center',title:'',border:false">
                    <div id="tt" class="easyui-tabs" style="margin: auto;" align="center" data-options="fit:true">
                        <div title="属性">
                            <table>
                                <tr>
                                    <td>
                                        <table class="tabmain">
                                            <tr>
                                                <td colspan="6">
                                                    <div class="easyui-panel" data-options="title:'库存属性'" style="padding: 5px; width: 690px;
                                                        text-align: center; vertical-align: middle;">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    规格型号
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sElements" />
                                                                </td>
                                                                <td>
                                                                    计数单位
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sUnitName" Z_Required="True" />
                                                                </td>
                                                                <td>
                                                                    计件单位
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sPurUnitName" Z_Required="True" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    最高库存
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="fHighQty" />
                                                                </td>
                                                                <td>
                                                                    最低库存
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="fLowQty" />
                                                                </td>
                                                                <td>
                                                                    安全库存
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fSafeQty" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    入库超额上限
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fInRate" Z_FieldType="数值" />
                                                                </td>
                                                                <td>
                                                                    出库超额上限
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fOutRate" Z_FieldType="数值" />
                                                                </td>
                                                                <td>
                                                                    条码
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sBarCode" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    颜色
                                                                </td>
                                                                <td id="ColorName">
                                                                </td>
                                                                <td>
                                                                    换算系数
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fPerQty" Z_FieldType="数值"
                                                                        Width="60px" />
                                                                    <em style="color: Blue">%</em>（件数/数量）
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="6">
                                                    <div class="easyui-panel" data-options="title:'采购属性'" style="padding: 5px; width: 690px;
                                                        text-align: center; vertical-align: middle;">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    采购员
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sPurBscDataPersonID" />
                                                                </td>
                                                                <td>
                                                                    采购周期
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iPurDays" />
                                                                </td>
                                                                <td>
                                                                    最新供应商
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                                                        Z_readOnly="True" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    税率
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="fTaxRate" />
                                                                </td>
                                                                <td>
                                                                    请购超额上限
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="fAskRate" />
                                                                </td>
                                                                <td>
                                                                    采购超额上限
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="fPurRate" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="6">
                                                    <div class="easyui-panel" data-options="title:'其他属性'" style="padding: 5px; text-align: center;
                                                        vertical-align: middle; width: 690px;">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iReadyMat" />
                                                                </td>
                                                                <td>
                                                                    <label for="__ExtCheckbox21">
                                                                        是否备料</label>
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtCheckbox2 ID="ExtCheckbox22" runat="server" Z_FieldID="iBatch" />
                                                                </td>
                                                                <td>
                                                                    <label for="__ExtCheckbox22">
                                                                        是否批次管理</label>
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtCheckbox2 ID="ExtCheckbox23" runat="server" Z_FieldID="iFix" />
                                                                </td>
                                                                <td>
                                                                    <label for="__ExtCheckbox23">
                                                                        是否固定资产</label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <cc1:ExtCheckbox2 ID="ExtCheckbox24" runat="server" Z_FieldID="iCheck" />
                                                                </td>
                                                                <td>
                                                                    <label for="__ExtCheckbox24">
                                                                        是否质检</label>
                                                                </td>
                                                                <td>
                                                                    售价
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="fSalePrice" Z_FieldType="数值" />
                                                                </td>
                                                                <td>
                                                                    助记符
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sZjCode" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    停用日期
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                                                                </td>
                                                                <td>
                                                                    备注
                                                                </td>
                                                                <td colspan="3">
                                                                    <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="98%" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    制单人
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                                                                </td>
                                                                <td>
                                                                    制单时间
                                                                </td>
                                                                <td>
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                                                                        Z_readOnly="True" />
                                                                </td>
                                                                <td style="display: none">
                                                                    <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sParentID" Z_NoSave="True" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td id="Property">
                                        <div class="easyui-panel" data-options="title:'物料属性设置'" style="text-align: center;
                                            vertical-align: middle; width: 380px; height: 410px">
                                            <table id="table1" tablename="bscDataMatDProperty">
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div data-options="fit:true" title="图片">
                            <table align="center">
                                <tr>
                                    <td>
                                        <cc1:ExtFile ID="ExtFile2" runat="server" Z_FileType="图片" Z_ImageHeight="220" Z_ImageWidth="220"
                                            Z_Height="250" Z_Width="300"></cc1:ExtFile>
                                    </td>
                                    <td>
                                        <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="图片" Z_ImageHeight="220" Z_ImageWidth="220"
                                            Z_Height="250" Z_Width="300"></cc1:ExtFile>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <cc1:ExtFile ID="ExtFile3" runat="server" Z_FileType="图片" Z_ImageHeight="220" Z_ImageWidth="220"
                                            Z_Height="250" Z_Width="300"></cc1:ExtFile>
                                    </td>
                                    <td>
                                        <cc1:ExtFile ID="ExtFile4" runat="server" Z_FileType="图片" Z_ImageHeight="220" Z_ImageWidth="220"
                                            Z_Height="250" Z_Width="300"></cc1:ExtFile>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div data-options="fit:true" title="物料仓位">
                            <table id="table3" tablename="bscDataMatDStock">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
