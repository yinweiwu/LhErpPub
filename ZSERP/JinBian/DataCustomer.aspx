<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
			Page.setFieldDisabled("fLowTotal");
            if (Page.usetype == "add") {
                var sNextRecNo = Page.getChildID("bscDataCustomerD");
                var iSerial = $("#tableChild").datagrid("getRows").length + 1;
                $("#tableChild").datagrid("appendRow", {
                    iRecNo: sNextRecNo,
                    iSerial: iSerial,
                    sCompanyUserCode: Page.userid,
                    sCompanyUserName: Page.username,
                    sCompany: Page.companyid
                });
            }
			if (Page.usetype == "add" || Page.usetype == "modify") {
                var sqlObj = {
                    TableName: "View_Yww_UserRight_Unique",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iSystemMenuID",
                        ComOprt: "=",
                        Value: 105,
                        LinkOprt: 'and'
                    },
                    {
                        Field: "sRightName",
                        ComOprt: "=",
                        Value: "'dModify'",
                        LinkOprt: 'and'
                    },
                    {
                        Field: "sCode",
                        ComOprt: "=",
                        Value: "'" + Page.userid + "'"
                    }
                    ]
                };
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    //Page.setFieldDisabled("fLowTotal")
                    Page.setFieldEnabled("fLowTotal");
                    //alert(1);
                }
            }
        })
        Page.beforeSave = function () {
            Page.setFieldValue("ibscDataCustomerRecNo", Page.key);


            var myDate = new Date();
            sYear = myDate.getFullYear().toString()
            sYear = sYear.substring(2);


            if (Page.usetype == "add" && Page.getFieldValue("sCustID")=="") {
                var sCode = "";
                var sqlObj = {
                    TableName: "BscDataCustomer",
                    Fields: "max(sCustID) as sOrderNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sCustID like 'A" +  sYear + "%' and isnull(iCustType ,0)=0",
                            ComOprt: "",
                            Value: ""
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                console.log(result);
                if (result.length > 0) {
                    if (result[0].sOrderNo != null && result[0].sOrderNo != undefined && result[0].sOrderNo != "") {
                        var maxidStr = result[0].sOrderNo.substr(("A"  + sYear).length);
                        var maxid = parseFloat(maxidStr);
                        maxid = maxid + 1;
                        var length = maxid.toString().length;
                        for (var i = 0; i < 4 - length; i++) {
                            maxid = "0" + maxid.toString();
                        }
                        sCode = "A"  + sYear + maxid;
                    }
                    else {
                        sCode = "A" + sSaleCode + sYear + "0001";
                    }
                }
                else {
                    sCode = "A"  + sYear + "0001";
                }
                Page.setFieldValue("sCustID", sCode);
            }
            
        }
        Page.afterSave = function () {
            
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'">
            <br />
            <table align="center">
                <tr>
                    <td>
                        客户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sCustID" />
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="ibscDataCustomerRecNo" style="display:none;" />
                    </td>
                    <td>
                        客户简称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sCustShortName" />
                    </td>
                    <td>
                        客户全称
                    </td>
                    <td class="style1">
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sCustName" Z_Required="true"
                            Z_RequiredTip="" />
                    </td>
                   <%--<td>
                        助记符
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sZjCode" />
                    </td>--%>
                </tr>
                <tr>
                    <td>
                        联系人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="sMainPerson" />
                    </td>
                    <td>
                        单位电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        联系人电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sMainPersonTel" />
                    </td>
                     <td>
                        单位地址
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sChnAddr" Width="150px"
                            />
                    </td>
                </tr>
                <tr>
                    <td>
                        收货人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox53" runat="server" Z_FieldID="sPerson" />
                    </td>
                    <td>
                        收货人电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox55" runat="server" Z_FieldID="sPersonTel" Z_FieldType="空" />
                    </td>
                    <td>
                        收货地址
                    </td>
                    <td class="style1" colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea6" runat="server" Z_FieldID="sAddress" Width="342px"
                            Height="40px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Width="140px" Z_FieldID="iCustomerType" />
                    </td>
                    <td>
                        传真
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Width="140px" Z_FieldID="sFax" />
                    </td>
                     <%--<td>
                        客户等级
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Width="140px" Z_FieldID="sLeval" />
                    </td>--%>
                    <%--<td>
                        获得途径
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Width="140px" Z_FieldID="sGetWay" />
                    </td>--%>
                </tr>
            </table>
            <br />
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="" title="客户信息">
                    <table class="tabmain" align="center">
                        <tr>
                            <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                                <img src="/ZSERP/BaseData/images/gys.png" />客户信息
                            </td>
                        </tr>
                        <tr>
                            <td>
                                单位分类
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sClassID" Z_Required="true"
                                    Z_RequiredTip="未设置分类" />
                            </td>
                            <td>
                                企业类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="sComtypeCode" />
                            </td>
                            <td>
                                品牌
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox48" runat="server" Z_FieldID="sBrand" />
                            </td>
                            <td>
                                注册资金
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox41" runat="server" Z_FieldID="fLogonTotal" Z_FieldType="数值" />
                            </td>
                            
                        </tr>
                        <tr>
                            <td>
                                邮编
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="sZip" />
                            </td>
                            <td>
                                网址
                            </td>
                            <td colspan="5">
                                &nbsp;<cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sHomepage" Width="552px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                公司理念
                            </td>
                            <td colspan="7">
                                <cc1:ExtTextArea2 ID="ExtTextArea7" runat="server" Z_FieldID="sComNews" Width="98%"
                                    Height="40px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                银行帐号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox43" runat="server" Z_FieldID="sAccountNo" />
                            </td>
                            <td>
                                开户银行
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox42" runat="server" Z_FieldID="sBankName" />
                            </td>
                            <td>
                                账号地址
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea5" runat="server" Z_FieldID="sBankAddr" Width="92%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                企业税号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="sTax" />
                            </td>
                            <td>
                                信誉额度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="fLowTotal" Z_FieldType="数值" />
                            </td>
                            <td>
                                直营店数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="iShop" Z_FieldType="整数" />
                            </td>
                            <td>
                                代理店数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox40" runat="server" Z_FieldID="iOtherShop" Z_FieldType="整数" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                                <img src="/ZSERP/BaseData/images/hz.png" />合作信息
                            </td>
                        </tr>
                        <tr>
                            <td>
                                业务员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox45" runat="server" Z_FieldID="sSaleID" />
                            </td>
                            <td>
                                跟单员
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox46" runat="server" Z_FieldID="sTraceID" />
                            </td>
                            <td>
                                所属门店
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox56" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                            </td>
                            <td>
                                所属部门
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox59" runat="server" Z_FieldID="sDeptID" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                合作开始日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox49" runat="server" Z_FieldID="dBegindate" Z_FieldType="日期" />
                            </td>
                            <td>
                                合作结束日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox50" runat="server" Z_FieldID="dEndDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                停用日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox57" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                            </td>
                            <%--<td>
                                供应商价格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox44" runat="server" Z_FieldID="iCustomerType" Z_FieldType="数值" />
                            </td>--%>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="iInner" />
                                <label for="__ExtCheckbox3">
                                    是否本公司</label>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <cc1:ExtCheckbox2 ID="ExtCheckbox4" runat="server" Z_FieldID="iHaveFive" />                                
                                <label for="__ExtCheckbox4">
                                    是否有五证</label>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                 <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iProcessing" />
                                <label for="__ExtCheckbox1">
                                    是否来料加工</label>
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea8" runat="server" Z_FieldID="sReMark" Width="92%"
                                    Height="40px" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="font-family: 华文隶书; font-size: 20px">
                                <img src="/ZSERP/BaseData/images/ys.png" />运输信息
                            </td>
                        </tr>
                        <tr>
                            <td>
                                运输方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox52" runat="server" Z_FieldID="sTransType" Width="150px" />
                            </td>
                            <td>
                                运费结算方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox54" runat="server" Z_FieldID="sTransMoney" Width="150px" />
                            </td>
                            <td>
                                包装方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox51" runat="server" Z_FieldID="sPackageType" Width="150px" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                付款方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="sFinishCode" Width="150px" />
                            </td>
                            <td>
                                付款币种
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox47" runat="server" Z_FieldID="sCurrencyID" Width="150px" />
                            </td>
                            <%--<td>
                                价格条款
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sPriceItem" style="width:80px;" />
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sPriceItemGk" style="width:70px;"/>
                            </td>--%>
                            <%--<td>
                                目的地
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sDestination" style="width:99%" />
                            </td>--%>
                        </tr>
                        <tr>
                             <%--<td>
                                销售类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sTradeType" Width="150px" />
                            </td>--%>
                             <%--<td>
                                港口
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sPort" Width="150px" />
                            </td>--%>
                            <%--<td>
                                唛头模板
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iPrintMoudleRecNo" Width="150px" />
                            </td>--%>

                        </tr>
                        <tr style="display: none">
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox60" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                            </td>
                            <td>
                                制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox61" runat="server" Z_FieldID="dinputDate" Z_FieldType="日期"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox58" runat="server" Z_FieldID="iCustType" Z_Value="0" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="" title="联系信息">
                    <table id="tableChild" tablename="BscDataCustomerD">
                    </table>
                </div>
                <%--<div data-options="" title="条码生成规则">
                    <table id="tableChildRule" tablename="BscDataCustomerDBarcodeRule">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
