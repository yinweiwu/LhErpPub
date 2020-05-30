<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var iSerial = 0;
        $(function () {
            $('#win').window('close');
        })
        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "SDSampleD") {
                if (datagridOp.currentColumnName == "iColorSample" && changes.iColorSample) {
                    //                    var iColorSample = row.iColorSample;
                    //                    if (iColorSample == "1") {
                    //                        $('#win').window('open');
                    //                        $("#b").hide();
                    //                        $("#c").hide();
                    //                        $("#d").hide();
                    //                    }
                    //                    else if (iColorSample == "2") {
                    //                        $('#win').window('open');
                    //                        $("#b").show();
                    //                        $("#c").hide();
                    //                        $("#d").hide();
                    //                    }
                    //                    else if (iColorSample == "3") {
                    //                        $('#win').window('open');
                    //                        $("#b").show();
                    //                        $("#c").show();
                    //                        $("#d").hide();
                    //                    }
                    //                    else if (iColorSample == "4") {
                    //                        $('#win').window('open');
                    //                        $("#b").show();
                    //                        $("#c").show();
                    //                        $("#d").show();
                    //                    }
                    //                    else {
                    //                        alert("请输入合法的色样数！");
                    //                    }
                }
            }
        }
        Page.Children.onClickCell = function (tableid, index, field, value) {
            if (tableid == "SDSampleD") {
                iSerial = index;
            }
        }
        function aa() {
            $('#SDSampleD').datagrid('updateRow', {
                index: iSerial,
                row: {
                    sConfirmColor: 'A'
                }
            });
            $('#win').window('close');
            document.getElementById('__ExtCheckbox1').checked = false;
        }
        function bb() {
            $('#SDSampleD').datagrid('updateRow', {
                index: iSerial,
                row: {
                    sConfirmColor: 'B'
                }
            });
            $('#win').window('close');
            document.getElementById('__ExtCheckbox2').checked = false;
        }
        function cc() {
            $('#SDSampleD').datagrid('updateRow', {
                index: iSerial,
                row: {
                    sConfirmColor: 'C'
                }
            });
            $('#win').window('close');
            document.getElementById('__ExtCheckbox3').checked = false;
        }
        function dd() {
            $('#SDSampleD').datagrid('updateRow', {
                index: iSerial,
                row: {
                    sConfirmColor: 'D'
                }
            });
            $('#win').window('close');
            document.getElementById('__ExtCheckbox4').checked = false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <br />
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table align="center">
                        <tr>
                            <td>
                                通知单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                            <td>
                                产品编号/名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataMatRecNo" />
                            </td>
                            <td>
                                坯布编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="true"
                                    Z_readOnly="true" />
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table class="tabmain">
                        <tr>
                            <td>
                                打色类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sType" Z_disabled="False" />
                            </td>
                            <td>
                                色样规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sElements" />
                            </td>
                            <td>
                                对色光源
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sLightSources" Z_FieldType="空" />
                            </td>
                            <td>
                                测试报告
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldType="空" Z_FieldID="sTestReport" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                加工面
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sMachFace" Z_disabled="False"
                                    Z_FieldType="空" />
                            </td>
                            <td>
                                毛要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sEffectRemark" Z_FieldType="空"
                                    Z_readOnly="False" />
                            </td>
                            <td>
                                风格要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sStyleRemark" Z_readOnly="False" />
                            </td>
                            <td>
                                加工要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldType="空" Z_FieldID="sProcessRemark" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                色牢度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" Z_FieldID="sColourFastness" runat="server" />
                            </td>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" Z_FieldID="iBscDataCustomerRecNoC" runat="server" />
                            </td>
                            <td>
                                打样品质要<br />
                                求及备注
                            </td>
                            <td colspan="3">
                                <textarea fieldid="sRemark" style="border-bottom: 1px solid black; width: 331px;
                                    border-left-style: none; border-left-color: inherit; border-left-width: 0px;
                                    border-right-style: none; border-right-color: inherit; border-right-width: 0px;
                                    border-top-style: none; border-top-color: inherit; border-top-width: 0px; height: 34px;"
                                    name="S1"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td>
                                收样日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dGetDate" Z_disabled="False"
                                    Z_FieldType="日期" />
                            </td>
                            <td>
                                寄样日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dSendDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                染厂交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dWorkDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                客户确认日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldType="日期" Z_FieldID="dInputDate"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="通知明细">
                    <table id="SDSampleD" tablename="SDSampleD">
                    </table>
                </div>
            </div>
        </div>
        <div id="win" class="easyui-window" title="客户确认色" style="width: 300px; height: 300px"
            data-options="modal:true,collapsible:false,minimizable:false,maximizable:false">
            <table>
                <tr id="a">
                    <td onclick="aa()">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox1">
                            A</label>
                    </td>
                </tr>
                <tr id="b">
                    <td onclick="bb()">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox2">
                            B</label>
                    </td>
                </tr>
                <tr id="c">
                    <td onclick="cc()">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox3">
                            C</label>
                    </td>
                </tr>
                <tr id="d">
                    <td onclick="dd()">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" />
                    </td>
                    <td>
                        <label for="__ExtCheckbox4">
                            D</label>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
