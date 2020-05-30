<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>分类设置</title>
    <link href="/Base/JS/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/lib/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
    <script src="/Base/JS/lib/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="/Base/JS/lib/json2.js" type="text/javascript"></script>
    <script src="JS/DataClass.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/DataClassOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/LookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        .tab
        {
            margin: 10px;
        }
        .tab tr td
        {
            height: 22px;
            padding: 5px;
            text-align: left;
        }
        .tdtitle
        {
            width: 100px;
            text-align: left;
        }
        .txbbottom
        {
            border: none;
            border-bottom: solid 1px #d0d0d0;
            width: 120px;
        }
        .textarea
        {
            border: solid 1px #d1d1d1;
            overflow: hidden;
            width: 200px;
            height: 50px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="tool" style="height: 30px; line-height: 30px; vertical-align: middle;">
    </div>
    <div id="layout1">
        <div position="left" ishidetitle="true">
            <div id="accordion1">
                <div title="分类树">
                    <ul id="tree1">
                    </ul>
                </div>
            </div>
        </div>
        <div position="center">
            <div id="accordion2">
                <div title="分类属性">
                    <div id="divmain" style="width: 400px; margin-left: 5px;">
                        <input id="TableName" type="hidden" value="bscDataClass" />
                        <input id="FieldKey" type="hidden" value="iRecNo" />
                        <input id="FieldKeyValue" type="hidden" />
                        <cc2:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iType" />
                        <div id="divpublic">
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <legend style="margin: 5px; padding: 5px;">公共属性</legend>
                                <table class="tab">
                                    <tr>
                                        <td class="tdtitle">
                                            分类名称
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="ExtTextBox3" runat="server" Z_FieldID="sClassName"
                                                Z_Required="True" Z_RequiredTip="分类名称不能为空" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            分类编号
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="cbh" runat="server" Z_Required="True" Z_RequiredTip="分类编号不能为空！"
                                                Z_FieldID="sClassID" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            父分类编号
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="pbh" runat="server" Z_FieldID="sParentID"
                                                Width="70px" Z_Value="0" />
                                            &nbsp;
                                            <cc2:ExtTextBox2 ID="ExtTextBox1" runat="server" CssClass="txbbottom" readonly="readonly" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            备注
                                        </td>
                                        <td>
                                            <cc2:ExtTextArea2 CssClass="textarea" ID="ExtTextArea1" runat="server" Height="51px"
                                                Width="237px" Z_FieldID="sRemark" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                        <div style="height: 5px;">
                        </div>
                        <div id="divdept" style="display: none;">
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <legend style="margin: 5px; padding: 5px;">部门分类专属</legend>
                                <table class="tab">
                                    <tr>
                                        <td class="tdtitle">
                                            部门属性
                                        </td>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <cc2:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldType="数值" Z_FieldID="iWork"
                                                            Z_LookUpName="deptProp" />
                                                    </td>
                                                    <td>
                                                        <cc2:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iTurnConfirm" Z_FieldType="数值" />
                                                        <label for="ExtCheckbox3">
                                                            转移确认</label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            部门主管
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sDeptCharge"
                                                CssClass="txbbottom" LookUpName="personSelect" />
                                            <!--<input id="Button3" type="button" value="..." style="width: 20px" LookUpTarget="ExtTextBox14" />-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            分管副总
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sAssCEO"
                                                CssClass="txbbottom"  LookUpName="personSelect" />
                                            <!--<input id="Button4" type="button" value="..." style="width: 20px" LookUpTarget="ExtTextBox15" />-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" >
                                            <cc2:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iCompany" />
                                            <label for="ExtCheckbox4">
                                                是否公司</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" >
                                            <cc2:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="bAccountCenter" />
                                            <label for="ExtCheckbox1">
                                                是否结算中心</label>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                        <div id="divpur" style="display: none;">
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <legend style="margin: 5px; padding: 5px;">物料分类专属</legend>
                                <table class="tab">
                                    <tr>
                                        <td class="tdtitle">
                                            计数单位
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_LookUpName="unitSelect" Z_FieldID="sUnitID" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            计件单位
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_LookUpName="unitSelect" Z_FieldID="sPurUnitID" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            换算率
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="ExtTextBox7" runat="server" Z_FieldID="fPerQty"
                                                Z_FieldType="数值" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            采购超数
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="ExtTextBox8" runat="server" Z_FieldID="fPurSrate"
                                                Z_FieldType="数值" />
                                            %
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            入库超数
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="ExtTextBox9" runat="server" Z_FieldID="fInSrate"
                                                Z_FieldType="数值" />
                                            %
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            领用超数
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 CssClass="txbbottom" ID="ExtTextBox10" runat="server" Z_FieldID="fOutSrate"
                                                Z_FieldType="数值" />
                                            %
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdtitle">
                                            采购员
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sPurPersonID" Z_LookUpName="cgySelect" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                        <div id="divAssets" style="display: none;">
                            <fieldset style="margin: auto; border: solid 1px #d0d0d0;">
                                <legend style="margin: 5px; padding: 5px;">固定资产分类专属</legend>
                                <table class="tab">
                                    <tr>
                                        <td class="tdtitle">
                                            使用年限
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox4" runat="server" CssClass="txbbottom" Z_FieldID="fUserYear" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            净残值率
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox2" runat="server" CssClass="txbbottom" Z_FieldID="fNetSalvage" Width="60px" />
                                            %
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            折旧方法
                                        </td>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <cc2:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sDepreMethod" Z_LookUpName="DepreMethodSelect" />
                                                    </td>
                                                    <td>
                                                        <span style="color: Red;">*</span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            计量单位
                                        </td>
                                        <td>
                                            <cc2:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_LookUpName="unitSelect" Z_FieldID="sUnitCode" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>

