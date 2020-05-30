<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            var iBscDataFabRecNo = Page.getFieldValue('iBscDataFabRecNo');
            var sqlobj = { TableName: "bscDataMat",
                Fields: "sName",
                SelectAll: "True",
                Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + iBscDataFabRecNo + "'"}]
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                Page.setFieldValue('sName1', data[0].sName);
            }

            if (getQueryString("iBillType") == "2") {
                $(".span").html("样品");
                $(".hide").hide();
                $("#__ExtTextBox1").removeClass("txbrequired");
                $("#__ExtTextBox1").addClass("txbreadonly");
            }
        })
        Page.beforeSave = function () {
            if (getQueryString("iBillType") == "2") {
                if (Page.usetype == "add") {
                    var sCode = "";
                    var sqlObj = {
                        TableName: "BscDataMat",
                        Fields: "max(sCode) as sCode",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sCode",
                                ComOprt: "like",
                                Value: "'KF%'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        if (result[0].sCode != null && result[0].sCode != undefined && result[0].sCode != "") {
                            var maxidStr = result[0].sCode.substr(2, 6);
                            var maxid = parseFloat(maxidStr);
                            maxid = maxid + 1;
                            var length = maxid.toString().length;
                            for (var i = 0; i < 6 - length; i++) {
                                maxid = "0" + maxid.toString();
                            }
                            sCode = "KF" + maxid;
                        }
                        else {
                            sCode = "KF000001";
                        }
                    }
                    else {
                        sCode = "KF000001";
                    }
                    Page.setFieldValue("sCode", sCode);
                }

                var iBscDataFabRecNo = Page.getFieldValue("iBscDataFabRecNo");
                if (iBscDataFabRecNo == "") {
                    Page.MessageShow("开发样坯布编号不能为空", "开发样坯布编号不能为空");
                }
            }

            
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <br />
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <table align="center" style="width: 70%">
                <tr>
                    <td>
                        <span class="span">产品</span>编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>
                        <span class="span">产品</span>名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sName" />
                    </td>
                    <td width="50px">
                        类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" />
                    </td>
                    <td class="hide">
                        供应商编号
                    </td>
                    <td class="hide">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sWholeStyleNo" />
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="tt" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="基本信息">
                    <div class="easyui-layout" data-options="fit:true">
                        <div data-options="region:'north'" style="height: 185px">
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        坯布编号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataFabRecNo" />
                                    </td>
                                    <td>
                                        坯布名称
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sName1" Z_NoSave="True"
                                            Z_readOnly="True" />
                                    </td>
                                    <td>
                                        客户价
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fSalePrice" Z_disabled="False" />
                                    </td>
                                    <td>
                                        停用时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan='8'>
                                        <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                            <table align="center">
                                                <tr>
                                                    <td>
                                                        样品幅宽(cm)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fSampleWidth" Z_disabled="False"
                                                            Z_NoSave="False" Z_readOnly="True" />
                                                    </td>
                                                    <td>
                                                        坯布幅宽(cm)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fFabWidth" Z_disabled="False"
                                                            Z_readOnly="True" />
                                                    </td>
                                                    <td>
                                                        成品幅宽(cm)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fProductWidth" Z_disabled="False" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        样品克重(g/㎡)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fSampleWeight" Z_disabled="False"
                                                            Z_readOnly="True" />
                                                    </td>
                                                    <td>
                                                        坯布克重(g/㎡)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fFabWeight" Z_disabled="False"
                                                            Z_readOnly="True" />
                                                    </td>
                                                    <td>
                                                        成品克重(g/㎡)
                                                    </td>
                                                    <td>
                                                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fProductWeight" Z_disabled="False" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </td>
                                </tr>
                            </table>
                            <table class="tabmain">
                                <tr>
                                    <td>
                                        成 份
                                    </td>
                                    <td>
                                        <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sMatUse" Z_readOnly=true 
                                            Z_NoSave=true runat="server" Width="309px" />
                                    </td>
                                    <td>
                                        备 注
                                    </td>
                                    <td>
                                        <textarea name="sRemark" fieldid="sRemark" style="border-bottom: 1px solid black;
                                            width: 380px; border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                                            border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                                            border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        制单人
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                                    </td>
                                    <td>
                                        录入时间
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" Z_FieldType="时间" />
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td>
                                        类型
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="2" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div data-options="region:'center'">
                            <div class="easyui-tabs" data-options="fit:true,border:false">
				<div data-options="fit:true" title="组成成份">
                                    <!--  子表1  -->
                                    <table id="table2" tablename="bscDataMatDWaste">
                                    </table>
                                </div>
                                <div data-options="fit:true" title="样品成份">
                                    <!--  子表1  -->
                                    <table id="table1" tablename="BscDataMatDSampleElements">
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
