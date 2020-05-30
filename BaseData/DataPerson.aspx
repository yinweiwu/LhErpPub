<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.beforeSave = function () {
            var error = false;
            var psdField = "sPassWord";
            $.ajax({
                url: "/Base/Handler/PsdMd5.ashx",
                async: false,
                cache: false,
                data: { otype: "getPwdField" },
                success: function (data) {
                    psdField = data;
                },
                error: function (data) {
                    $.messager.alert("错误", "在密码加密时发生错误");
                    error = true;
                }
            })
            if (error == true) {
                return false;
            }

            var oPsd = Page.getFieldValue(psdField);
            var jsonObj = {
                TableName: "bscDataPerson",
                Fields: psdField,
                SelectAll: "True",
                Filters: [{
                    Field: "sCode",
                    ComOprt: "=",
                    Value: "'" + Page.getFieldValue("sCode") + "'"
                }]
            };
            var resut = SqlGetData(jsonObj);
            if (resut[0][(psdField)] == oPsd) {
                return true;
            }
            var psd = "";

            $.ajax({
                url: "/Base/Handler/PsdMd5.ashx",
                async: false,
                cache: false,
                data: { psd: Page.getFieldValue(psdField) },
                success: function (data) {
                    psd = data;
                },
                error: function (data) {
                    $.messager.alert("错误", "在密码加密时发生错误");
                    error = true;
                }
            });
            if (error == false) {
                Page.setFieldValue(psdField, psd);
            }
            return true;
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div style="text-align: center;">
        <h3>
            人员信息
        </h3>
    </div>
    <div id="tt" class="easyui-tabs" style="width: 1000px; margin: auto;">
        <div title="基本信息" style="padding: 20px;">
            <table class="tabmain">
                <tr>
                    <td>
                        工号
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" Z_Required="True"
                            Z_RequiredTip="工号不能为空" />
                    </td>
                    <td>
                        姓名
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sName" Z_Required="True"
                            Z_RequiredTip="姓名不能为空" />
                    </td>
                    <td>
                        出生年月
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dBirthday" Z_FieldType="日期" />
                    </td>
                    <td>
                        性别
                    </td>
                    <td>
                        <cc2:ExtSelect2 ID="ExtSelect1" runat="server" Z_Options="&lt;option value='男'&gt;男&lt;/option&gt;&lt;option value='女'&gt;女&lt;/option&gt;"
                            Z_FieldID="sSex" />
                    </td>
                </tr>
                <tr>
                    <td>
                        部门
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sClassID" />
                    </td>
                    <td>
                        入职日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dAttendDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        试用到期日
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dTryEndDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        介绍人
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sPerson" />
                    </td>
                </tr>
                <tr>
                    <td>
                        身份证号
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sfCode" />
                    </td>
                    <td>
                        民族
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sNation" />
                    </td>
                    <td>
                        状态
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iState" />
                    </td>
                    <td>
                        职务
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        离职日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dLeaveDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        职称
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sZcName" />
                    </td>
                    <td>
                        联系电话
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        毕业学校
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sChool" />
                    </td>
                </tr>
                <tr>
                    <td>
                        专业
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sZYName" />
                    </td>
                    <td>
                        学历
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sXlName" />
                    </td>
                    <td>
                        毕业日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sSchEndDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        技术等级
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sTeckType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        考勤卡号
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sKqCode" />
                    </td>
                    <td>
                        生产工序
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sSerialID" />
                    </td>
                    <td>
                        工资类型
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sGzType" />
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
        <div title="身份证信息" style="padding: 20px;">
            <table>
                <tr>
                    <td>
                        开始日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sBeginDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        截止日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sEndDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        发证机关
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sfDepart" />
                    </td>
                    <td>
                        籍贯
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBirdayAdress" />
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;家庭地址
                    </td>
                    <td colspan="7">
                        <cc2:ExtTextBox2 ID="ExtTextBox28" runat="server" Width="644px" Z_FieldID="sAddress" />
                    </td>
                </tr>
            </table>
        </div>
        <div title="合同信息" style="padding: 20px;">
            <table>
                <tr>
                    <td>
                        合同开始日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dhtBeginDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        合同截至日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="dHtEndDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        底薪
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fSalary" Z_FieldType="数值" />
                    </td>
                    <td>
                        参保日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="dSbAttend" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        参保类型
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="sSbType" Z_FieldType="日期" />
                    </td>
                    <td>
                        停止参保日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="dsbStopDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        暂住证号码
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="sTempCode" />
                    </td>
                    <td>
                        暂住证到期日
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="dEndTemp" Z_FieldType="日期" />
                    </td>
                </tr>
            </table>
        </div>
        <div title="权限角色密码" style="padding: 20px;">
            <table>
                <tr>
                    <td>
                        用户组
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="sGroupName" />
                    </td>
                    <td>
                        是否系统用户
                        <cc2:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iUser" Z_FieldType="数值" />
                    </td>
                    <td>
                        是否超级用户
                        <cc2:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iSupper" Z_FieldType="数值" />
                    </td>
                    <td>
                        是否采购员<cc2:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iProcurer" />
                    </td>
                    <td>
                        是否业务员<cc2:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iSaler" />
                    </td>
                </tr>
                <tr>
                    <td>
                        密码
                    </td>
                    <td>
                        <cc2:ExtTxbPsd2 ID="ExtTxbPsd1" runat="server" Z_FieldID="sPassWord" />
                    </td>
                    <td>
                        开户银行
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox41" runat="server" Z_FieldID="sBankName" />
                    </td>
                    <td>
                        银行账号
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox40" runat="server" Z_FieldID="sBankNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        调岗记录
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox42" runat="server" Z_FieldID="sJobRecord" />
                    </td>
                    <td>
                        调薪记录
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox43" runat="server" Z_FieldID="sSalaryRecord" />
                    </td>
                    <td>
                        审批角色
                    </td>
                    <td>
                        <cc2:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sCheckRoles" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="5">
                        <cc2:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="629px" Z_FieldID="sRemark" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox44" runat="server" Enabled="False" Z_FieldID="sUserID" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox45" runat="server" Enabled="False" Z_FieldID="dInputDate"
                            Z_FieldType="时间" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
