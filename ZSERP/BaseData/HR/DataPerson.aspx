<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="JS/DatePerson.js?<%= Guid.NewGuid() %>>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        $(function () {
            Page.Children.toolBarBtnDisabled("table2", "add");
            var needClose = true;
            var sqlobj1 = {
                TableName: "FSysGroupUser",
                Fields: "iSysGroupRecNo",
                SelectAll: "True",
                Filters: [{ Field: "sUserID", ComOprt: "=", Value: "'" + Page.userid + "'"}]
            }
            var data1 = SqlGetData(sqlobj1);
            if (data1.length > 0) {
                for (var i = 0; i < data1.length; i++) {
                    if (data1[i].iSysGroupRecNo == 1 || data1[i].iSysGroupRecNo == 35) {
                        needClose = false;
                    }
                }
            }
            if (needClose) {
                $('#tt').tabs('close', '系统用户');
            }
        })

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
                    $.messager.show({
                        title: '错误',
                        msg: '在密码加密时发生错误',
                        showType: 'show',
                        timeout: 1000,
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
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
            if (resut.length > 0) {
                if (resut[0][(psdField)] == oPsd) {
                    return true;
                }
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
                    $.messager.show({
                        title: '错误',
                        msg: '在密码加密时发生错误',
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                    error = true;
                }
            });
            if (error == false) {
                Page.setFieldValue(psdField, psd);
            }

            var result = $('#table2').datagrid('getRows');            
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    for (var j = i + 1; j < result.length; j++) {
                        if (result[i].sSerialName == result[j].sSerialName) {
                            $.messager.show({
                                title: '错误',
                                msg: '【员工工序权限】工序名称有重复！',
                                timeout: 1100,
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

            var iAppLogin = Page.getFieldValue("iAppLogin");
            if (iAppLogin == "1")
            {
                var canSave = true;
                $.ajax({
                    url: "/Base/Handler/PsdMd5.ashx",
                    async: false,
                    cache: false,
                    data: { otype: "getAppUserCount" },
                    success: function (data) {
                        var sqlObjPersonAppUser = {
                            TableName: "bscDataPerson",
                            Fields: "count(iRecNo) as c",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iAppLogin",
                                    ComOprt: "=",
                                    Value: "1"
                                }
                            ]
                        };
                        var resultAppUser = SqlGetData(sqlObjPersonAppUser);
                        if (resultAppUser.length > 0) {
                            var rCount = isNaN(Number(resultAppUser[0].c)) ? 0 : Number(resultAppUser[0].c);
                            var sCount = isNaN(Number(data)) ? 0 : Number(data);
                            if (Page.usetype == "add") {
                                if (rCount >= sCount) {
                                    alert("抱歉，手机app用户数已满（共" + sCount + "个）,不可再设置为app用户");
                                    canSave = false;
                                }
                            }
                            else {
                                if (rCount > sCount) {
                                    alert("抱歉，手机app用户数已满（共" + sCount + "个）,不可再设置为app用户");
                                    canSave = false;
                                }
                            }
                        }
                    },
                    error: function (data) {

                    }
                });
                if (canSave == false) {
                    return false;
                }
            }            
        };

        function getAllUserInfo() {
            $.messager.progress({ title: "正在下载中..." });
            $.ajax({
                url: "/Base/Handler/PublicHandler.ashx",
                type: "get",
                async: true,
                cache: false,
                data: { otype: "GetWeiXinAllUserInfo" },
                success: function (data) {
                    if (data == "1") {
                        Page.MessageShow("成功", "获取用户信息成功");
                    }
                    else {
                        Page.MessageShow("失败", "获取用户信息失败");
                    }
                    $.messager.progress("close");
                },
                error: function () {
                    Page.MessageShow("失败", "获取用户信息失败");
                    $.messager.progress("close");
                }
            });
            
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'">
            <table align="center" width="700px">
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
                        状态
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iState" />
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
                        职务
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sType" />
                    </td>
                    <td>
                        职称
                    </td>
                    <td>
                        <cc2:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sZcName" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div id="tt" class="easyui-tabs" style="margin: auto;" align="center" data-options="fit:true">
                <div title="基本信息" align="center">
                    <table style="width: 850px;">
                        <tr>
                            <td colspan="6" align="left">
                                <img src="../images/rzxx.jpg" width="35px" />
                                <div style="margin: -16px auto">
                                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" width="95%" />
                                </div>
                                <div style="padding: 0 0 0 37px; margin: -25px auto">
                                    <span style="font-family: 黑体; font-size: 15px">入职信息</span>
                                </div>
                                <br />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
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
                                离职日期
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dLeaveDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                联系电话
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sTel" />
                            </td>
                            <td>
                                考勤卡号
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sKqCode" />
                            </td>
                            <td>
                                介绍人
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sPerson" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;" width="150px">
                                毕业学校
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sChool" />
                            </td>
                            <td>
                                毕业日期
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sSchEndDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                专 业
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sZYName" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                学 历
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sXlName" />
                            </td>
                            <td>
                                岗位角色
                            </td>
                            <td colspan="2">
                                <cc2:ExtTextBox2 ID="ExtTextBox4" runat="server" Width="200px" Z_FieldID="sJobRole"
                                    Z_Required="False" Z_RequiredTip="岗位角色不能为空" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                微信OpenID
                            </td>
                            <td colspan="7" style="text-align:left;">
                                <cc2:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="sWeiXinOpenID" />
                                <a href="#" onclick="getAllUserInfo()">下载公众号所有用户信息</a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" align="left">
                                <img src="../images/sfzxx.jpg" width="35px" />
                                <div style="margin: -16px auto">
                                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" width="95%" />
                                </div>
                                <div style="padding: 0 0 0 37px; margin: -25px auto">
                                    <span style="font-family: 黑体; font-size: 15px">身份证信息</span>
                                </div>
                                <br />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                身份证号
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sfCode" />
                            </td>
                            <td>
                                性 别
                            </td>
                            <td>
                                <cc2:ExtSelect2 ID="ExtSelect1" runat="server" Z_Options="&lt;option value='男'&gt;男&lt;/option&gt;&lt;option value='女'&gt;女&lt;/option&gt;"
                                    Z_FieldID="sSex" Width="50px" />
                            </td>
                            <td>
                                家庭地址
                            </td>
                            <td>
                                <cc2:ExtTextArea2 ID="ExtTextArea3" runat="server" Z_FieldID="sAddress" Width="90%"
                                    Height="30px" Style="font-size: 15px; font-family: 宋体" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                出生年月
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dBirthday" Z_FieldType="日期" />
                            </td>
                            <td>
                                民 族
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sNation" />
                            </td>
                            <td>
                                籍 贯
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sBirdayAdress" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                发证机关
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sfDepart" />
                            </td>
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
                        </tr>
                        <tr>
                            <td colspan="6" align="left">
                                <img src="../images/htcbxx.jpg" width="35px" />
                                <div style="margin: -12px auto">
                                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" width="95%" />
                                </div>
                                <div style="padding: 0 0 0 37px; margin: -22px auto">
                                    <span style="font-family: 黑体; font-size: 15px">合同参保信息</span>
                                </div>
                                <br />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
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
                                底 薪
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="fSalary" Z_FieldType="数值" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
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
                                技术等级
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sTeckType" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                参保日期
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="dSbAttend" Z_FieldType="日期" />
                            </td>
                            <td>
                                参保类型
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="sSbType" Z_FieldType="字符"
                                    Width="150px" />
                            </td>
                            <td>
                                停止参保日期
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="dsbStopDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" align="left">
                                <img src="../images/jsxx.jpg" width="35px" />
                                <div style="margin: -16px auto">
                                    <hr style="height: 1px; border: none; border-top: 1px solid #bababa;" width="95%" />
                                </div>
                                <div style="padding: 0 0 0 37px; margin: -25px auto">
                                    <span style="font-family: 黑体; font-size: 15px">角色信息</span>
                                </div>
                                <br />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
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
                            <td>
                                调岗记录
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox42" runat="server" Z_FieldID="sJobRecord" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 0 0 37px;">
                                调薪记录
                            </td>
                            <td>
                                <cc2:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sSalaryRecord" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
                            <td>
                                备 注
                            </td>
                            <td>
                                <cc2:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sRemark" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
                            <td>
                                首页流程图
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="sMainFlow" />
                            </td>
                        </tr>
                        <tr style="display: none">
                            <td>
                                审批角色
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sCheckRoles" Width="150px" />
                            </td>
                            <td>
                                用户组
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="sGroupName" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox44" runat="server" Enabled="False" Z_FieldID="sUserID" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc2:ExtTextBox2 ID="ExtTextBox45" runat="server" Enabled="False" Z_FieldID="dInputDate"
                                    Z_FieldType="时间" Width="150px" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div title="系统用户">
                    <table style="padding: 5px;">
                        <tr>
                            <td>
                                <cc2:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iUser" />
                                <label for="__ExtCheckbox1">
                                    是否系统用户</label>
                            </td>
                            <td>
                                <cc2:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iSupper" />
                                <label for="__ExtCheckbox2">
                                    是否超级用户</label>
                            </td>
                            <td>
                                <cc2:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iAppLogin" />
                                <label for="__ExtCheckbox3">
                                    是否App用户</label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div title="仓库档案用户权限">
                    <table id="table1" tablename="BscDataStockDUser">
                    </table>
                </div>
                <div title="员工工序权限">
                    <table id="table2" tablename="bscDataPersonD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
