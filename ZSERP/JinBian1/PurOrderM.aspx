<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.beforeInit = function () {
            var iMatType = getQueryString("iMatType");
            if (iMatType == "0") {
                $("#Table1").removeAttr("tablename");
                $("#tabC").tabs("close", 1);
            }
        }
        $(function () {
            var iMatType = getQueryString("iMatType");
            Page.setFieldValue('iMatType', iMatType);
            if (Page.usetype == "add") {
                if (iMatType == "1") {
                    var sremarkArr = [
                        {
                            iSerial: 1,
                            sRemark: "请注意坯布针条，油针，瑕疵，停车痕等异常问题100M不超四个疵点，"
                        },
                        {
                            iSerial: 2,
                            sRemark: "若此批货在坯布检验时有异常情况，我司要退回贵公司，如在水洗定型等生产过程中出现问题（属于坯布问题）我司要退回贵公司，对已处理好的产品及半产品由贵司收回并赔偿后处理等费用."
                        },
                        {
                            iSerial: 3,
                            sRemark: "请在出货单上附上贵司的品检记录以便我司工作，品检记录上要明确记录每匹布的异常情况，"
                        },
                        {
                            iSerial: 4,
                            sRemark: "请在我司指定日期内交完全部，否则一切损失由贵司承担。"
                        },
                        {
                            iSerial: 5,
                            sRemark: "包装：卷布，PE膜，外编织带，不得出现污脏情况，"
                        },
                        {
                            iSerial: 6,
                            sRemark: "特别注意事项：此单对布面\"竖条，经编条，\"特别注意，不得出现横条，停车档现象，"
                        }
                        ,
                        {
                            iSerial: 7,
                            sRemark: ""
                        }
                        ,
                        {
                            iSerial: 8,
                            sRemark: ""
                        }
                    ]
                    for (var i = 0; i < sremarkArr.length; i++) {
                        Page.tableToolbarClick("add", "Table1", sremarkArr[i]);
                    }
                }
                if (iMatType == "2") {
                    var sremarkArr = [
                        {
                            iSerial: 1,
                            sRemark: "物料必须符合环保纺织物品标准及符合oeko-tex standard标准"
                        },
                        {
                            iSerial: 2,
                            sRemark: "每色每缸须提供2-3YD批色及测试，确认后方式可出货"
                        },
                        {
                            iSerial: 3,
                            sRemark: "出货前每匹布上麦头须注明合同号，匹号，缸号，规格，净重/毛重，长度等资料"
                        },
                        {
                            iSerial: 4,
                            sRemark: "请控制交货数量，允收范围±3%以内，克重按受范围±5G/M2以内"
                        },
                        {
                            iSerial: 5,
                            sRemark: "如因品质问题或时间等因素影响我司交期，由此造成的损失由贵司全额承担"
                        },
                        {
                            iSerial: 6,
                            sRemark: "布面品质，不得出现竖条/横条/拆痕/色花/污胜/破洞/等异常问题"
                        }
                        ,
                        {
                            iSerial: 7,
                            sRemark: "色牢度必须达到3-4级，测试标准，SGS测试"
                        }
                        ,
                        {
                            iSerial: 8,
                            sRemark: "风格跟时来样"
                        },
                        {
                            iSerial: 9,
                            sRemark: ""
                        },
                        {
                            iSerial: 10,
                            sRemark: ""
                        }
                    ]
                    for (var i = 0; i < sremarkArr.length; i++) {
                        Page.tableToolbarClick("add", "Table1", sremarkArr[i]);
                    }
                }
            }
        })
        Page.beforeSave = function () {
            //            dDate = Page.getFieldValue('dDate');
            //            dOrderDate = Page.getFieldValue('dOrderDate');
            //            if (dOrderDate > dDate) {
            //                $.messager.show({
            //                    title: '错误',
            //                    msg: '采购交期不能大于需求日期！',
            //                    timeout: 1000,
            //                    showType: 'show',
            //                    style: {
            //                        right: '',
            //                        top: document.body.scrollTop + document.documentElement.scrollTop,
            //                        bottom: ''
            //                    }
            //                });
            //                return false;
            //            }
        }
        dataForm.afterSelected = function (uniqueid, data) {
            if (uniqueid == "270") {
                $("#Table1").datagrid("loadData", []);
                var iPurAskMainRecNo = data[0].iMainRecNo;
                var sqlObj = {
                    TableName: "PurAskDRemark",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: iPurAskMainRecNo
                        }
                    ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        var dataRemark = {
                            iSerial: i + 1,
                            sRemark: data[i].sRemark
                        }
                        Page.tableToolbarClick("add", "Table1", dataRemark);
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <div style="display: none;">
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iMatType" />
            </div>
            <table class="tabmain">
                <tr>
                    <td>
                        采购订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        采购日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>
                        供应商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                    <td>
                        采购交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        采购员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>
                        采购部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sDeptID" />
                    </td>
                    <td>
                        付款条件
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextBox2 ID="ExtTextBox13" Width="98%" runat="server" Z_FieldID="sMoneyContion" />
                    </td>
                    <%--<td>
                        采购类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sPurType" />
                    </td>
                    <td>
                        物料类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sMatTypeID" />
                    </td>--%>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan='5'>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="98%" Z_FieldID="sReMark" />
                    </td>
                    <td>
                        交货地点
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea2" Z_FieldID="sDeliveryAddr" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldType="数值" runat="server" Z_FieldID="fQty"
                            Z_readOnly="True" Z_decimalDigits="2" />
                    </td>
                    <td>
                        金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fTotal" Z_FieldType="数值"
                            Z_readOnly="True" Z_decimalDigits="2" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" id="tabC" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <table id="PurOrderD" tablename="PurOrderD">
                    </table>
                </div>
                <div data-options="fit:true" title="备注明细">
                    <table id="Table1" tablename="PurOrderDRemark">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
