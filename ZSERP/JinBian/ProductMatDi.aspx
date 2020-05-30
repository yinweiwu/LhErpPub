<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            var iBscDataFabRecNo = Page.getFieldValue('iBscDataFabRecNo');
            var sqlobj = {
                TableName: "bscDataMat",
                Fields: "sName",
                SelectAll: "True",
                Filters: [{ Field: "iRecNo", ComOprt: "=", Value: "'" + iBscDataFabRecNo + "'" }]
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                Page.setFieldValue('sName1', data[0].sName);
            }

            if (getQueryString("iBillType") == "2") {
                //$(".span").html("样品");
                //$(".hide").hide();
                //$("#__ExtTextBox1").removeClass("txbrequired");
                //$("#__ExtTextBox1").addClass("txbreadonly");
            }

            if (Page.getQueryString("usetype") == "add") {
                Page.tableToolbarClick("add", "table4", {
                    iProduceType: 1,
                    fLoss: 0,
                    iBscDataProcessesMRecNo: 22,
                    sProcessesName:'成品'
                });
            }
        })
        Page.beforeSave = function () {
            //获取分类，编号自动产生时分类不能为空
            var sClassID = Page.getFieldValue("sClassID");
            if (sClassID == "") {
                Page.MessageShow("分类不能为空！", "分类不能为空！");
                return false;
            }
            var sqlObjClass = {
                TableName: "BscDataClass",
                Fields: "1", SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID", ComOprt: "like", Value: "'" + sClassID + "%'", LinkOprt: "and"
                    }, {
                        Field: "len(sClassID)", ComOprt: ">", Value: sClassID.length, LinkOprt: "and"
                    }, {
                        Field: "sType", ComOprt: "=", Value: "'mat'"
                    }
                ]
            }
            var resultClass = SqlGetData(sqlObjClass);
            if (resultClass.length > 0) {
                Page.MessageShow("分类必须要是末级分类", "分类必须要是末级分类");
                return false;
            }
            /*if (Page.usetype == "add") {
                var sCode = "";
                var resultMaxCode = SqlGetData(
                    {
                        TableName: "BscDataMat", Fields: "max(sCode) as sMaxCode", SelectAll: "True",
                        Filters: [
                            {
                                Field: "sClassID", ComOprt: "like", Value: "'DP%'", LinkOprt: "and"
                            }, {
                                Field: "iMatType", ComOprt: "=", Value: 2
                            }
                        ]
                    });
                if (resultMaxCode.length > 0) {
                    var sMaxCode = resultMaxCode[0].sMaxCode;
                    if (sMaxCode) {
                        var lsh = sMaxCode.substr(sMaxCode.length - 4, 4);
                        var maxid = parseInt(lsh, 10);
                        maxid = maxid + 1;
                        var length = maxid.toString().length;
                        for (var i = 0; i < 4 - length; i++) {
                            maxid = "0" + maxid.toString();
                        }
                        sCode = sClassID + maxid;
                    }
                    else {
                        sCode = "DP0001";
                    }
                } else {
                    sCode = "DP0001";
                }
                Page.setFieldValue("sCode", sCode);
            }*/


            $("#table3").attr("tablename", "bscDataMatDWaste")
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
            var sCode = Page.getFieldValue("sCode");
            var sqlObj1 = {
                TableName: "BscDataMat",
                Fields: "iRecNo",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sCode", ComOprt: "=", Value: "'" + sCode + "'", LinkOprt: "and"
                    }, {
                        Field: "iRecNo", ComOprt: "<>", Value: "'" + Page.key + "'"
                    }
                ]
            }
            var result1 = SqlGetData(sqlObj1);
            if (result1.length > 0) {
                Page.MessageShow("成品编号不能重复", "成品编号不能重复");
                return false;
            }
            if (Page.getFieldValue("sName") == '') {
                var sname = "";
                if (Page.getFieldValue("bMergeMat") == "1") {
                   
                } else {
                    sname = Page.getFieldValue("sName1");
                    var rows = $("#table4").datagrid("getRows");
                    $(rows).each(function () {
                        sname = sname + (this.sProcessesName || "");
                    })

                }
                Page.setFieldValue("sName", sname);
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
                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iMatType" Z_Value="2" />
            </div>
            <table class="tabmain">
                <tr>
                    <td>
                        <span class="span">底布</span>编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" />
                    </td>
                    <td>
                        <span class="span">底布</span>名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sName" />
                    </td>
                    
                    <td width="50px">类别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassID" />
                    </td>
                    <td style="display:none"><label>复合布<cc1:ExtCheckbox2 runat="server" Z_FieldID="bMergeMat" /></label></td>
                </tr>
                <tr>
                    <td>坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataFabRecNo" />
                    </td>
                    <td>坯布名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sName1" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>成品幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="fProductWidth" Z_disabled="False" />
                    </td>
                    <td>成品克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fProductWeight" Z_disabled="False" />
                    </td>
                </tr>
                
                <%--<tr>
                    <td>经纱
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sSelvage" />
                    </td>
                    <td>纬纱
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sTopRowNeedles"  />
                    </td>
                    <td>支数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iCount" />
                    </td>
                    <td>纬密
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sDownRowNeedles" />
                    </td>
                </tr>--%>
                <tr>
                    <td>规格组成
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" Z_FieldID="sElements" runat="server" style="width:99%; height:60px;" />
                    </td>
                    <td>备 注
                    </td>
                    <td colspan="3">
                        <textarea name="sRemark" fieldid="sRemark" style="width:99%;height:60px;"></textarea>
                    </td>
                </tr>
                <tr>
                    <td>停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserid" Z_readOnly="True" />
                    </td>
                    <td>录入时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_readOnly="True" Z_FieldType="时间" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'" style="overflow: hidden;">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="后处理工序">
                    <table id="table4" tablename="bscDataMatDProcesses">
                    </table>
                </div>
               <div data-options="fit:true" title="纱线工艺">
                    <!--  子表1  -->
                    <table id="bscDataMatDWaste" tablename="bscDataMatDWaste">
                    </table>
                </div>
                 <%--<div data-options="fit:true" title="底布">
                    <!--  子表1  -->
                    <table id="table3" tablename="bscDataMatDWaste2">
                    </table>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
