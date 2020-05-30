<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                var sqlObj = {
                    //表名或视图名
                    TableName: "bscCostItems",
                    //选择的字段
                    Fields: "iRecNo,sCostID,sCostName,iPayMan",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            Field: "iYearPay",
                            ComOprt: "=",
                            Value: 1,
                            LinkOprt: "and"
                        },
                        {
                            Field: "isnull(dStopDate,'2299-12-31')",
                            ComOprt: ">",
                            Value: "getdate()"
                        }
                    ],
                    Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    for (var i = 0; i < result.length; i++) {
                        var appRow = {
                            iBscCostItemsRecNo: result[i].iRecNo,
                            iPayMan: result[i].iPayMan,
                            sCostID: result[i].sCostID,
                            sCostName: result[i].sCostName
                        };
                        Page.tableToolbarClick("add", "table2", appRow);
                    }
                }
            }
            if (Page.usetype == "modify") {
                Page.setFieldDisabled("sShopID");
            }
        })
        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "sManagerName") {
                    var sManagerName = Page.getFieldValue("sManagerName");
                    var sOperatorName = Page.getFieldValue("sOperatorName");
                    if (sOperatorName == "") {
                        Page.setFieldValue("sOperatorName", sManagerName);
                    }
                }
                if (field == "sCard") {
                    var sCard = Page.getFieldValue("sCard");
                    var sOperatorCard = Page.getFieldValue("sOperatorCard");
                    if (sOperatorCard == "") {
                        Page.setFieldValue("sOperatorCard", sCard);
                    }
                }
                if (field == "sTel") {
                    var sTel = Page.getFieldValue("sTel");
                    var sOperatorTel = Page.getFieldValue("sOperatorTel");
                    if (sOperatorTel == "") {
                        Page.setFieldValue("sOperatorTel", sTel);
                    }
                }
            }
        }

        Page.beforeSave = function () {
            var stel = Page.getFieldValue("sTel");
            var scard = Page.getFieldValue("sCard");
            var sshopid = Page.getFieldValue("sShopID");
            if (!/^\d{17}(\d|x)$/i.test(scard)) {
                Page.MessageShow("身份证有误", "所有者身份证长度或格式错误，请重填");
                return false;
            }
            if (!(/^1[3|4|5|7|8]\d{9}$/.test(stel))) {
                Page.MessageShow("手机号有误", "所有者手机号码有误，请重填");
                return false;
            }

            var stel = Page.getFieldValue("sOperatorTel");
            var scard = Page.getFieldValue("sOperatorCard");
            if (!/^\d{17}(\d|x)$/i.test(scard)) {
                Page.MessageShow("身份证有误", "经营者身份证长度或格式错误，请重填");
                return false;
            }
            if (!(/^1[3|4|5|7|8]\d{9}$/.test(stel))) {
                Page.MessageShow("手机号有误", "经营者手机号码有误，请重填");
                return false;
            }

            if (Page.usetype == 'add') {
                var sqlObj = {
                    //表名或视图名
                    TableName: "BscShop",
                    //选择的字段
                    Fields: "1",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            Field: "sShopID",
                            ComOprt: "=",
                            Value: "'" + sshopid + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "sClassID",
                            ComOprt: "=",
                            Value: "'" + Page.getFieldValue("sClassID") + "'"
                        }
                ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.MessageShow("同一区域下商铺号不能重复","同一区域下商铺号不允许重复"); 
                    return false;
                }
            }
        }
    </script>
    <style type="text/css">
        .style1
        {
            width: 100px;
        }
        .style2
        {
            height: 60px;
        }
        .style3
        {
            width: 130px;
            height: 35px;
        }
        .style4
        {
            height: 35px;
        }
        .style5
        {
            height: 50px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true" style="text-align: center;">
        <div data-options="region:'center',border:false">
            <table>
                <tr>
                    <td>
                        <!--隐藏字段-->
                        <div id="divHid" style="display: none;">
                            <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                            <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                            <cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="sDeptID" />
                        </div>
                        <!—如果只有一个主表，这里的north要变为center-->
                        <!--主表部分-->
                        <%--<table class="tabmain" style="margin: auto">--%>
                        <span style="font-size: 16px; width: 300px; height: 55px; line-height: 80px; display: block;
                            margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第一步：</span>商铺信息输入</span>
                        <table border="0" style="border: 1px solid #B4CDCD; width: 850px; height: 120px;
                            margin-left: 50px" cellpadding="0" cellspacing="1">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td class="style1">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商铺号&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sShopID" Width="260px"
                                                    Height="30px" Style="margin-bottom: 6px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所有者&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sManagerName" Width="260px"
                                                    Height="30px" />
                                            </td>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营者&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOperatorName" Width="260px"
                                                    Height="30px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所有者身份证号&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sCard" Width="260px"
                                                    Height="30px" />
                                            </td>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营者身份证号&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOperatorCard" Width="260px"
                                                    Height="30px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所有者手机&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sTel" Width="260px"
                                                    Height="30px" Style="margin-bottom: 0px" />
                                            </td>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营者手机&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sOperatorTel" Width="260px"
                                                    Height="30px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所属区域&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sClassID" Width="260px"
                                                    Height="30px" />
                                            </td>
                                            <td class="style3">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商铺面积&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td class="style4">
                                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sArea" Width="260px"
                                                    Height="30px" Z_decimalDigits="2" Z_FieldType="数值" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商铺地址&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td colspan="3" style="text-align: left;">
                                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sAdress" Width="657px"
                                                    Height="30px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td colspan="3" style="text-align: left;">
                                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sRemark" Style="width: 657px;
                                                    height: 30px;" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="style4">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server"
                                                    Z_FieldID="iHold" />
                                                <label id="Label1" for="__ExtCheckbox1">
                                                    是否抵押</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iStop" />
                                                <label id="Label2" for="__ExtCheckbox2">
                                                    是否停用</label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                        </table>
                        <span style="font-size: 16px; width: 300px; height: 55px; line-height: 80px; display: block;
                            margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第二步：</span>商铺费用填写
                        </span>
                        <table border="0" style="border: 1px solid #B4CDCD; width: 850px; height: 300px;
                            margin-left: 50px" cellpadding="0" cellspacing="1">
                            <tr>
                                <td style="width: 850px">
                                    <div class="easyui-tabs" data-options="fit:true,border:false" style="width: 850px;">
                                        <div data-options="fit:true" title="商铺费用明细">
                                            <!--  子表1  -->
                                            <table id="table2" tablename="BscShopD">
                                            </table>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%--<tr>
                    <td>
                        <table>
                            <tr>
                                <td class="style3">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;租金金额
                                </td>
                                <td class="style4">
                                    <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fRent" Width="260px"
                                        Height="30px" Z_decimalDigits="2" Z_FieldType="数值" />
                                    (年)
                                </td>
                            </tr>
                            <tr>
                                <td class="style3">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;物管金额
                                </td>
                                <td class="style4">
                                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fProperty" Width="260px"
                                        Height="30px" Z_decimalDigits="2" Z_FieldType="数值" />
                                    (年)
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td class="style3">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空调金额
                                </td>
                                <td class="style4">
                                    <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fAir" Width="260px"
                                        Height="30px" Z_decimalDigits="2" Z_FieldType="数值" />
                                    (年)
                                </td>
                            </tr>
                            <tr>
                                <td class="style3">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 总金额
                                </td>
                                <td class="style4">
                                    <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fTotal" Width="260px"
                                        Height="30px" Z_decimalDigits="2" Z_FieldType="数值" />
                                    (年)
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>--%>
            </table>
        </div>
        <%--<div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="费用项目明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="BscShopD">
                    </table>
                </div>
            </div>
        </div>--%>
    </div>
</asp:Content>
