<%@ page language="C#" autoeventwireup="true" inherits="Base_PbLodopDesign, App_Web_pblodop.aspx.fca1e55" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>lodop报表</title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script language="javascript" src="/Base/Lodop/LodopFuncs.js?r=1"></script>
    <object id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0">
        <embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0"></embed>
    </object>
    <script type="text/javascript">
        var dataSourceDefined;
        window.onload = function () {
            try {
                LODOP = getLodop();
            } catch (e) {

            }

        };
    </script>
    <style type="text/css">
        body {
            font-family: 微软雅黑;
        }

        .ul {
            list-style: none;
            margin: 0px;
            padding: 0px;
        }

            .ul li {
                margin-top: 10px;
            }

                .ul li input {
                    width: 80px;
                    height: 40px;
                    font-size: 18px;
                }
    </style>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
        <div data-options="region:'north',split:true" style="height: 200px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'center',border:false">
                    <table id="tabDataSource">
                    </table>
                </div>
                <div data-options="region:'east',split:true,border:false" style="width: 680px;">
                    <div class="WordSection1" style='layout-grid: 15.6pt'>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>1</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、<span
                                lang="EN-US">Lodop</span>打印指令<span lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>PRINT_INIT(strPrintTaskName)</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>打印初始化<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>SET_PRINT_PAGESIZE(intOrient,intPageWidth,intPageHeight,strPageName)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>设定纸张大小<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>ADD_PRINT_HTM(intTop,intLeft,intWidth,intHeight,strHtml)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>增加超文本项<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>ADD_PRINT_TEXT(intTop,intLeft,intWidth,intHeight,strContent)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>增加纯文本项<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>ADD_PRINT_TABLE(intTop,intLeft,intWidth,intHeight,strHtml)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>增加表格项<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>ADD_PRINT_SHAPE<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>(intShapeType,intTop,intLeft,intWidth,intHeight,intLineStyle,intLineWidth,intColor)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>画图形<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>SET_PRINT_STYLE(strStyleName, varStyleValue)</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>设置对象风格<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>PREVIEW</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>打印预览<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>PRINT</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>直接打印<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>PRINT_SETUP</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>打印维护<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>PRINT_DESIGN</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>打印设计<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: red'>注意：<span lang="EN-US">&lt;table&gt;</span>如果有<span lang="EN-US">&lt;thead&gt;</span>会被当成页眉、<span
                                lang="EN-US">&lt;tfoot&gt;</span>被当成页脚，每页都会打印。<span lang="EN-US">”</span>生成子表<span
                                    lang="EN-US">”</span>的按钮默认都会带<span lang="EN-US">&lt;thead&gt;</span>、<span
                                        lang="EN-US">&lt;tfoot&gt;</span>，如不需要，可自行修改代码。</span><span lang="EN-US"
                                            style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><o:p></o:p></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>2</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、设计纸张大小<span
                                lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>SET_PRINT_PAGESIZE(intOrient,intPageWidth,intPageHeight,strPageName);<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>参数说明：
                                <span lang="EN-US">
                                    <o:p></o:p>
                                </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>intOrient</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：打印方向及纸张类型<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span>1---</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>纵向打印，固定纸张； <span
                                        lang="EN-US">
                                        <o:p></o:p>
                                    </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span>2---</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>横向打印，固定纸张；<span
                                        lang="EN-US"><span style='mso-spacerun: yes'>&nbsp; </span>
                                        <o:p></o:p>
                                    </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span>3---</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>纵向打印，宽度固定，高度按打印内容的高度自适应<span
                                        lang="EN-US">(</span>见样例<span lang="EN-US">18)</span>；<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span>0---</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>方向不定，由操作者自行选择或按打印机缺省设置。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>
                                <o:p>&nbsp;</o:p>
                            </span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>intPageWidth</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span></span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>纸张宽，单位为<span
                                        lang="EN-US">0.1mm </span>譬如该参数值为<span lang="EN-US">45</span>，则表示<span lang="EN-US">4.5mm,</span>计量精度是<span
                                            lang="EN-US">0.1mm</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>intPageHeight</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span></span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>固定纸张时该参数是纸张高；高度自适应时该参数是纸张底边的空白高，计量单位与纸张宽一样。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>strPageName</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span></span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>纸张类型名，<span
                                        lang="EN-US"> intPageWidth</span>等于零时本参数才有效，具体名称参见操作系统打印服务属性中的格式定义。<span
                                            lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp; </span></span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>关键字“<span lang="EN-US">CreateCustomPage</span>”会在系统内建立一个名称为“<span
                                        lang="EN-US">LodopCustomPage</span>”自定义纸张类型。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>
                                <o:p>&nbsp;</o:p>
                            </span>
                        </p>

                        <h2><span lang="EN-US">3</span><span style='font-family: 宋体; mso-ascii-font-family: Cambria; mso-ascii-theme-font: major-latin; mso-fareast-font-family: 宋体; mso-fareast-theme-font: major-fareast; mso-hansi-font-family: Cambria; mso-hansi-theme-font: major-latin'>、</span><span
                            lang="EN-US" style='color: blue'>LODOP.ADD_PRINT_RECT</span><span
                                style='font-family: 宋体; mso-ascii-font-family: Cambria; mso-ascii-theme-font: major-latin; mso-fareast-font-family: 宋体; mso-fareast-theme-font: major-fareast; mso-hansi-font-family: Cambria; mso-hansi-theme-font: major-latin'>画矩形边框：</span></h2>

                        <p class="MsoNormal"><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>LODOP.ADD_PRINT_RECT(10,55,360,220,0,1);<o:p></o:p></span></p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>边框离纸张顶端<span
                                lang="EN-US">10px(px</span>是绝对值长度，等于<span lang="EN-US">1/96</span>英寸<span
                                    lang="EN-US">,</span>下同<span lang="EN-US">)</span>距左边<span lang="EN-US">55px</span>、宽<span
                                        lang="EN-US">360px</span>、高<span lang="EN-US">220px</span>、<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>框为实线<span
                                lang="EN-US">(0-</span>实线<span lang="EN-US"> 1-</span>破折线<span lang="EN-US"> 2-</span>点线<span
                                    lang="EN-US"> 3-</span>点划线<span lang="EN-US"> 4-</span>双点划线<span lang="EN-US">)</span>、线宽为<span
                                        lang="EN-US">1px<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>1</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>英寸大约是<span lang="EN-US">2.54</span>厘米 <span lang="EN-US">
                                <o:p></o:p>
                            </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>1</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>英寸大约是<span lang="EN-US">96</span>像素 <span lang="EN-US">
                                <o:p></o:p>
                            </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>1</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>毫米大约是<span lang="EN-US">3.77</span>像素</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'> <span lang="EN-US">
                                    <o:p></o:p>
                                </span></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>4</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、<span
                                lang="EN-US" style='color: #0000CC'>LODOP.SET_PRINT_STYLE/ SET_PRINT_STYLEA</span><span
                                    lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>SET_PRINT_STYLE<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>名称：设置打印项风格<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>格式：<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal"><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>SET_PRINT_STYLE(strStyleName,varStyleValue)<o:p></o:p></span></p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>功能：设置打印项的输出风格，成功执行该函数，此后再增加的打印项按此风格输出。<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>SET_PRINT_STYLEA</span><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>(varItemNameID,strStyleName,varStyleValue)<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>序号设<span
                                lang="EN-US">0</span>表示最新对象，注意<span lang="EN-US">SET_PRINT_STYLEA</span>与<span
                                    lang="EN-US">SET_PRINT_STYLE</span>的区别。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>参数：<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>strStyleName</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：打印风格名，风格名称及其含义如下：<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">FontName</span>”：设定纯文本打印项的字体名称。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">FontSize</span>”：设定纯文本打印项的字体大小。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">FontColor</span>”：设定纯文本打印项的字体颜色。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Bold</span>”：设定纯文本打印项是否粗体。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Italic</span>”：设定纯文本打印项是否斜体。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Underline</span>”：设定纯文本打印项是否下滑线。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Alignment</span>”：设定纯文本打印项的内容左右靠齐方式。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Angle</span>”：设定纯文本打印项的旋转角度。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">ItemType</span>”：设定打印项的基本属性。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">HOrient</span>”：设定打印项在纸张内的水平位置锁定方式。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">VOrient</span>”：设定打印项在纸张内的垂直位置锁定方式。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">PenWidth</span>”：线条宽度。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">PenStyle</span>”：线条风格。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">Stretch</span>”：图片截取缩放模式。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">PreviewOnly</span>”<span lang="EN-US">:</span>内容仅仅用来预览。<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">ReadOnly</span>”<span lang="EN-US">:</span>纯文本内容在打印维护时，是否禁止修改。<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><span
                                style='mso-spacerun: yes'>&nbsp;</span>&quot;LinkedItem&quot;:</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>设置关联对象<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>
                                <o:p>&nbsp;</o:p>
                            </span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>varStyleValue</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>：打印风格值，相关值如下：<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>FontName</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：字符型，与操作系统字体名一致，缺省是“宋体”。<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>FontSize</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数值型，单位是<span
                                    lang="EN-US">pt</span>，缺省值是<span lang="EN-US">9</span>，可以含小数，如<span lang="EN-US">13.5</span>。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>FontColor</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：整数或字符型，整数时是颜色的十进制<span
                                    lang="EN-US">RGB</span>值；字符时是超文本颜色值，可以是“<span lang="EN-US">#</span>”加三色<span
                                        lang="EN-US">16</span>进制值组合，也可以是英文颜色名；<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Bold</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">1</span>代表粗体，<span lang="EN-US">0</span>代表非粗体，缺省值是<span lang="EN-US">0</span>。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Italic</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">1</span>代表斜体，<span lang="EN-US">0</span>代表非斜体，缺省值是<span lang="EN-US">0</span>。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Underline</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">1</span>代表有下划线，<span lang="EN-US">0</span>代表无下划线，缺省值是<span lang="EN-US">0</span>。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Alignment</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">1--</span>左靠齐<span lang="EN-US"> 2--</span>居中<span lang="EN-US"> 3--</span>右靠齐，缺省值是<span
                                        lang="EN-US">1</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Angle</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，逆时针旋转角度数，单位是度，<span
                                    lang="EN-US">0</span>度表示不旋转。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>ItemType</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">0--</span>普通项<span lang="EN-US"> 1--</span>页眉页脚<span lang="EN-US"> 2--</span>页号项<span
                                        lang="EN-US"> 3--</span>页数项<span lang="EN-US"> 4--</span>多页项<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>缺省（不调用本函数时）值<span
                                lang="EN-US">0</span>。普通项只打印一次；页眉页脚项则每页都在固定位置重复打印；页号项和页数项是特殊的页眉页脚项，其内容包含当前页号和全部页数；多页项每页都打印，直到把内容打印完毕，打印时在每页上的位置和区域大小固定一样（多页项只对纯文本有效）<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>在页号或页数对象的文本中，有两个特殊控制字符：<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>“<span
                                lang="EN-US">#</span>”特指“页号”，“<span lang="EN-US">&amp;</span>”特指“页数”。<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>HOrient</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">0--</span>左边距锁定<span lang="EN-US"> 1--</span>右边距锁定<span lang="EN-US">
2--</span>水平方向居中<span lang="EN-US"> 3--</span>左边距和右边距同时锁定（中间拉伸），缺省值是<span
    lang="EN-US">0</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>VOrient</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">0--</span>上边距锁定<span lang="EN-US"> 1--</span>下边距锁定<span lang="EN-US">
2--</span>垂直方向居中<span lang="EN-US"> 3--</span>上边距和下边距同时锁定（中间拉伸），缺省值是<span
    lang="EN-US">0</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>PenWidth</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：整数型，单位是<span
                                    lang="EN-US">(</span>打印<span lang="EN-US">)</span>像素，缺省值是<span lang="EN-US">1</span>，非实线的线条宽也是<span
                                        lang="EN-US">0</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>PenStyle</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">0--</span>实线<span lang="EN-US"> 1--</span>破折线<span lang="EN-US"> 2--</span>点线<span
                                        lang="EN-US"> 3--</span>点划线<span lang="EN-US"> 4--</span>双点划线<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>缺省值是<span
                                lang="EN-US">0</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Stretch</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：数字型，<span
                                    lang="EN-US">0--</span>截取图片<span lang="EN-US"> 1--</span>扩展（可变形）缩放<span lang="EN-US">
2--</span>按原图长和宽比例（不变形）缩放。缺省值是<span lang="EN-US">0</span>。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>PreviewOnly</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：字符或数字型，<span
                                    lang="EN-US">1</span>或“<span lang="EN-US">true</span>”代表仅预览，否则为正常内容。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>ReadOnly</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>的值：字符或数字型，<span
                                    lang="EN-US">1</span>或“<span lang="EN-US">true</span>”代表“是”，其它表示“否”，缺省值为“是”，即缺省情况下，纯文本内容在打印维护时是禁止修改的。<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>
                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>LinkedItem</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>”被关联对象”的序号，为负数表示前移几位。</span>
                        </p>
                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>结果：无<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>建议或要求：<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>打印初始化后、增加打印项之前调用本函数。<span
                                lang="EN-US"><span style='mso-spacerun: yes'>&nbsp; </span>
                                <o:p></o:p>
                            </span></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>5</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、<span
                                lang="EN-US" style='color: #0000CC'>LODOP.ADD_PRINT_TEXT</span>在矩形框内打印姓名栏：<span
                                    lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>LODOP.ADD_PRINT_TEXT(20,180,100,25,&quot;</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>郭德强<span lang="EN-US">&quot;);<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>姓名栏离纸张顶端<span
                                lang="EN-US">20px</span>、距左边<span lang="EN-US">180px</span>、宽<span lang="EN-US">100px</span>、高<span
                                    lang="EN-US">25px</span>、内容为“郭德强”<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>6</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、<span
                                lang="EN-US" style='color: #0000CC'>LODOP.ADD_PRINT_HTM</span>用超文本实现该名片打印：<span
                                    lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal"><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>LODOP.ADD_PRINT_HTM(10,55,&quot;100%&quot;,&quot;100%&quot;,strHtml);<o:p></o:p></span></p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>7</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、增加条码<span
                                lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: #0000CC'>ADD_PRINT_BARCODE(Top,Left,Width,Height,BarCodeType,BarCodeValue);<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>关键参数含义<span
                                lang="EN-US">:<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Width
                            </span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>条码的总宽度，计量单位<span
                                lang="EN-US">px</span>（<span lang="EN-US">1px=1/96</span>英寸）<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Height
                            </span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>条码的总高度（一维条码时包括文字高度）<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>BarCodeType
                            </span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>条码的类型（规制）名称<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>BarCodeValue
                            </span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>条码值<span
                                lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>目前控件支持的条码类型有如下<span
                                lang="EN-US">26</span>种，包含<span lang="EN-US">24</span>种一维码和<span lang="EN-US">2</span>种二维码：<span
                                    lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>128A<span
                                style='mso-tab-count: 1'>&nbsp; </span>128B<span style='mso-tab-count: 1'>&nbsp; </span>128C<span
                                    style='mso-tab-count: 1'>&nbsp; </span>128Auto<span style='mso-tab-count: 1'> </span>
                                <o:p></o:p>
                            </span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>EAN8<span
                                style='mso-tab-count: 1'> </span>EAN13<span style='mso-tab-count: 1'>&nbsp;&nbsp;&nbsp; </span>EAN128A<span
                                    style='mso-tab-count: 1'>&nbsp;&nbsp;&nbsp;&nbsp; </span>EAN128B<span
                                        style='mso-tab-count: 2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>EAN128C<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Code39<span
                                style='mso-tab-count: 1'>&nbsp; </span>39Extended<span style='mso-tab-count: 1'> </span>
                                <o:p></o:p>
                            </span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>2_5interleaved<span
                                style='mso-tab-count: 1'> </span>2_5industrial<span style='mso-tab-count: 1'>&nbsp;&nbsp;&nbsp; </span>2_5matrix<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>UPC_A<span
                                style='mso-tab-count: 1'>&nbsp;&nbsp;&nbsp; </span>UPC_E0<span style='mso-tab-count: 1'>&nbsp;&nbsp; </span>UPC_E1<span style='mso-tab-count: 1'>&nbsp;&nbsp; </span>UPCsupp2<span
                                    style='mso-tab-count: 1'>&nbsp;&nbsp; </span>UPCsupp5<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>Code93<span
                                style='mso-tab-count: 1'>&nbsp; </span>93Extended<span style='mso-tab-count: 1'> </span>MSI<span style='mso-tab-count: 1'>&nbsp;&nbsp; </span>PostNet<span
                                    style='mso-tab-count: 1'>&nbsp; </span>Codabar<span style='mso-tab-count: 1'> </span>QRCode<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal"><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>PDF417<o:p></o:p></span></p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>8</span><span style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>、指定<span lang="EN-US">Windows</span>默认打印机：<span
                            lang="EN-US"><br>
                            &nbsp;</span></span><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: #0000CC'>LODOP.SET_PRINT_MODE</span><span
                                lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>(&quot;WINDOW_DEFPRINTER&quot;,</span><span
                                    style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>打印机名称或序号<span
                                        lang="EN-US">);<o:p></o:p></span></span></h2>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>9</span><span style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>、指定<span lang="EN-US">Windows</span>默认纸张：<span
                            lang="EN-US"><br>
                            &nbsp;</span></span><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: #0000CC'>LODOP.SET_PRINT_MODE</span><span
                                lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>(&quot;WINDOW_DEFPAGESIZE:</span><span
                                    style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>打印机名称或序号<span
                                        lang="EN-US">&quot;,</span>纸张名称<span lang="EN-US">);<o:p></o:p></span></span></h2>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>10</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、打印设计在生成程序代码时依据以下方法，让页面变量与数据项内容对接：<span
                                lang="EN-US">&nbsp;<o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
                                lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>LODOP.SET_PRINT_STYLEA(0,&quot;ContentVName&quot;,&quot;</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>变量名<span
                                        lang="EN-US">&quot;);</span></span><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>例如：</span><span lang="EN-US"
                                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>LODOP.ADD_PRINT_TEXT(256,61,191,30,&quot;</span><span
                                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>演示发货地址信息<span
                                                        lang="EN-US">&quot;);</span></span><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;<br>
                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span lang="EN-US"
                                                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>LODOP.SET_PRINT_STYLEA(0,&quot;ContentVName&quot;,&quot;MyData&quot;);</span><span
                                                                    lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>设计完毕，关闭设计窗口，设计时的内容自动替换为变量名称<span
                                    lang="EN-US">,</span>关闭设计窗口生成代码如下<span lang="EN-US">:&nbsp;<br>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span><span lang="EN-US"
                                            style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>LODOP.ADD_PRINT_TEXT(256,61,191,30,MyData);</span><span
                                                lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>&nbsp;<o:p></o:p></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>11</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"'>、格式转换<span
                                lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>LODOP.FORMAT(strType,strValue);<o:p></o:p></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>参数</span><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>strType</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>是格式类型（参见下面蓝色内容）<span lang="EN-US">,</span></span><span
                                lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>strValue</span><span
                                    style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: black'>是要转换的数据，下面演示一部分：<span
                                        lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-no-proof: yes'>
                                <v:shapetype id="_x0000_t75" coordsize="21600,21600" o:spt="75"
                                    o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
 <v:stroke joinstyle="miter"/>
 <v:formulas>
  <v:f eqn="if lineDrawn pixelLineWidth 0"/>
  <v:f eqn="sum @0 1 0"/>
  <v:f eqn="sum 0 0 @1"/>
  <v:f eqn="prod @2 1 2"/>
  <v:f eqn="prod @3 21600 pixelWidth"/>
  <v:f eqn="prod @3 21600 pixelHeight"/>
  <v:f eqn="sum @0 0 1"/>
  <v:f eqn="prod @6 1 2"/>
  <v:f eqn="prod @7 21600 pixelWidth"/>
  <v:f eqn="sum @8 21600 0"/>
  <v:f eqn="prod @7 21600 pixelHeight"/>
  <v:f eqn="sum @10 21600 0"/>
 </v:formulas>
 <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
 <o:lock v:ext="edit" aspectratio="t"/>
</v:shapetype>
                                <v:shape id="图片_x0020_1" o:spid="_x0000_i1025" type="#_x0000_t75"
                                    style='width: 255.75pt; height: 491.25pt; visibility: visible; mso-wrap-style: square'>
 <v:imagedata src="lodop打印命令.files/image001.png" o:title=""/>
</v:shape>
                            </span><span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>
                                <o:p></o:p>
                            </span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>12 </span><span style='font-size: 14.0pt; line-height: 173%; font-family: "微软雅黑","sans-serif"; color: black'>、明细表合计<span lang="EN-US"><o:p></o:p></span></span></h2>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>利用</span><span
                                lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue; mso-fareast-language: ZH'>ADD_PRINT_TABLE</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>专用超文本元素属性可以轻松实现分页小计、累计、分类统计、页数及总合计等功能，<span
                                    lang="EN-US"><br>
                                </span>这四个属性是：<span lang="EN-US" style='color: blue'>tdata</span><span
                                    style='color: blue'>、<span lang="EN-US">format</span>、<span lang="EN-US">tclass</span>、<span
                                        lang="EN-US">tindex</span></span><span lang="EN-US">&nbsp;</span>它们可以用在<span
                                            lang="EN-US">table</span>内任何元素上，详细解释和演示如下：<span lang="EN-US"><br>
                                                <br>
                                            </span><b>一、属性“<span lang="EN-US" style='color: blue'>tdata</span>”：</b>设置统计类型，属性值及对应含义如下<span
                                                lang="EN-US">:<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>SubCount(</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>本页行数<span lang="EN-US">) SubDistinctCount(</span>本页非重复行数<span
                                    lang="EN-US">) SubSum(</span>本页合计<span lang="EN-US">) SubAverage(</span>本页平均数<span
                                        lang="EN-US">) SubMax(</span>本页最大值<span lang="EN-US">) SubMin(</span>本页最小值<span
                                            lang="EN-US">)<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>Count(</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>目前累计行数<span lang="EN-US">) DistinctCount(</span>目前累计非重复行数<span
                                    lang="EN-US">) Sum(</span>目前累计数<span lang="EN-US">) Average(</span>目前累计平均数<span
                                        lang="EN-US">) Max(</span>目前最大值<span lang="EN-US">)<span
                                            style='mso-spacerun: yes'>&nbsp; </span>Min(</span>目前最小值<span lang="EN-US">)<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>AllCount(</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>全表总行数<span lang="EN-US">)
AllDistinctCount(</span>全表非重复行数<span lang="EN-US">) AllSum(</span>全表总合计<span
    lang="EN-US">) AllAverage(</span>全表总平均<span lang="EN-US">) AllMax(</span>全表最大值<span
        lang="EN-US">) AllMin(</span>全表最小值<span lang="EN-US">)<o:p></o:p></span></span>
                        </p>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>PageNO(</span><span
                                style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; mso-bidi-font-family: 宋体; color: #0000CC; mso-font-kerning: 0pt'>页号<span lang="EN-US">) PageCount(</span>页数<span
                                    lang="EN-US">)<span style='mso-spacerun: yes'>&nbsp; </span>
                                    <o:p></o:p>
                                </span></span>
                        </p>

                        <p class="MsoNormal">
                            <span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'>以上属性值还可以组合成表达式<span
                                lang="EN-US">, </span>甚至以复杂四则运算形式统计运算<span lang="EN-US">, </span>表达式内除了<span
                                    lang="EN-US">&quot;</span><span style='color: blue'>加<span lang="EN-US">+</span>减<span
                                        lang="EN-US">-</span>乘<span lang="EN-US">*</span>除<span lang="EN-US">/</span></span><span
                                            lang="EN-US">&quot;</span>和<span lang="EN-US">&quot;</span><span style='color: blue'>括号<span
                                                lang="EN-US">( )</span></span><span lang="EN-US">&quot;</span>外，还支持数学函数：<span
                                                    lang="EN-US"><br>
                                                    <span style='color: blue'>Trunc Round Sqrt Int Sqr Abs Sin Cos Tan Arcsin Arccos
Arctin Logo10 Log2 Round1-6</span></span>等<span lang="EN-US">, </span>表格内单元格原始<span
    lang="EN-US">(</span>或统计结果<span lang="EN-US">)</span>数据可用其<span lang="EN-US">id</span>值参与运算。<span
        lang="EN-US"><br>
        <br>
    </span><b>二、属性“<span lang="EN-US" style='color: blue'>format</span>”：</b>设置数据格式，属性值样式如下：<span
        lang="EN-US"><br>
        &nbsp;&nbsp; </span>“<span lang="EN-US" style='color: blue'>0</span>” “<span
            lang="EN-US" style='color: blue'>0.00</span>” “<span lang="EN-US" style='color: blue'>#.##</span>”
“<span lang="EN-US" style='color: blue'>#,##0.00</span>”“<span lang="EN-US"
    style='color: blue'>0.000E+00</span>”“<span lang="EN-US" style='color: blue'>#.###E-0&nbsp;</span>”“<span
        lang="EN-US" style='color: blue'>UpperMoney</span><span lang="EN-US">(</span>大写金额<span
            lang="EN-US">)</span>”“<span lang="EN-US" style='color: blue'>ChineseNum</span><span
                lang="EN-US">(</span>中文数字<span lang="EN-US">)</span>”等等<span lang="EN-US">...<br>
                    <br>
                </span><b>三、属性“<span lang="EN-US" style='color: blue'>tclass</span>”：</b>设置统计分组<span
                    lang="EN-US">(</span>也就是分类统计<span lang="EN-US">)</span>，属性值任意，参见本演示的“<span
                        lang="EN-US">A</span>型”“<span lang="EN-US">B</span>型”个数统计。<span lang="EN-US"><br>
                            <br>
                        </span><b>四、属性“<span lang="EN-US" style='color: blue'>tindex</span>”：</b>设置统计的目标列，默认情况下是同列统计，也就是统计结果与目标列一致，如果无法一致
时，<span lang="EN-US"><br>
    &nbsp;&nbsp;&nbsp;&nbsp; </span>可以用其指定具体列，属性值是数字型的列序号，从<span lang="EN-US">1</span>起始。<span
        lang="EN-US"><br>
        <br>
    </span><b>五、占位符：</b>统计结果的占位符是任意个“<span lang="EN-US" style='color: blue'>#</span>”组成的字符串，当结果值较大时，注意占位符要足够多<span
        lang="EN-US">,</span>除非周围有空白区。<span lang="EN-US"><o:p></o:p></span></span>
                        </p>

                        <h2><span lang="EN-US" style='font-size: 14.0pt; line-height: 173%'>13</span><span
                            style='font-size: 14.0pt; line-height: 173%; font-family: 宋体; mso-ascii-font-family: Cambria; mso-ascii-theme-font: major-latin; mso-fareast-font-family: 宋体; mso-fareast-theme-font: major-fareast; mso-hansi-font-family: Cambria; mso-hansi-theme-font: major-latin'>、获得打印设备和选择打印机输出</span><span
                                lang="EN-US" style='font-size: 14.0pt; line-height: 173%; color: black'><o:p></o:p></span></h2>

                        <p class="MsoNormal">
                            <span lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>GET_PRINTER_COUNT;</span><span style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"; color: blue'>获得打印机个数<span lang="EN-US"><br>
                                GET_PRINTER_NAME(intPrinterIndex);</span>用序号获得打印机名，一般序号从<span lang="EN-US">0</span>开始，<span
                                    lang="EN-US">-1</span>特指默认打印机；<span lang="EN-US"><br>
                                        SET_PRINTER_INDEX(oIndexOrName);</span>按序号或名称指定打印机，选定后禁止手工重选；<span lang="EN-US"><br>
                                            SET_PRINTER_INDEXA(IndexorName);</span>按序号或名称指定打印机，选定后允许手工重选；<span lang="EN-US"><br>
                                                SELECT_PRINTER;</span>弹出界面选打印机并返回其序号，序号从<span lang="EN-US">0</span>开始<span
                                                    lang="EN-US">,</span>返回<span lang="EN-US">-1</span>表示放弃<span lang="EN-US"><br>
                                                        SET_PRINT_COPIES(intCopies);</span>指定每次打印份数，缺省为<span lang="EN-US">1</span></span><span
                                                            lang="EN-US" style='font-size: 14.0pt; font-family: "微软雅黑","sans-serif"'><o:p></o:p></span>
                        </p>

                    </div>
                </div>
            </div>
        </div>
        <div data-options="region:'center'" style="padding: 5px;">
            <table style="width: 100%; height: 100%;">
                <tr>
                    <td style="width: 45%; height: 4%; text-align: left; font-weight: bold;">最终代码
                    </td>
                    <td style="width: 4%; text-align: center; font-weight: bold;">操作
                    </td>
                    <td style="width: 45%; text-align: left; font-weight: bold;">设计代码
                    </td>
                </tr>
                <tr>
                    <td style="width: 45%; height: 95%; text-align: left;">
                        <textarea id="txaDesinCodeSave" class="textarea" style="width: 99%; height: 99%;"></textarea>
                        <input id="txbPrintJob" type="hidden" />
                    </td>
                    <td style="width: 4%; height: 99%; vertical-align: top; text-align: center;">
                        <ul class="ul">
                            <li>
                                <input type="button" value="设计" onclick="doDesign()" /></li>
                            <li>
                                <input type="button" value="<-预览" onclick="doPreview(1)" /></li>
                            <li>
                                <input type="button" value="预览->" onclick="doPreview(2)" /></li>
                            <li>
                                <input type="button" value="清空" onclick="doClear()" /></li>
                            <li>
                                <input type="button" value="保存" onclick="doSave()" /></li>
                        </ul>
                    </td>
                    <td style="width: 49%; height: 99%; text-align: left;">
                        <textarea id="txaDesinCode" class="textarea" style="width: 99%; height: 99%;"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <%--<div data-options="region:'east',split:true" style="width: 200px; vertical-align: top;">
            <ul class="ul">
                <li>
                    <input type="button" value="设计" onclick="doDesign()" /></li>
                <li>
                    <input type="button" value="预览" onclick="doPreview()" /></li>
                <li>
                    <input type="button" value="清空" onclick="doClear()" /></li>
                <li>
                    <input type="button" value="保存" onclick="doSave()" /></li>
            </ul>
        </div>--%>
        <div id="divToolBar">
            <a href="javascript:void(0)" id="mbMain" class="easyui-menubutton"
                data-options="menu:'#divMainmm',iconCls:'icon-import'">生成主表语句</a>
            <div id="divMainmm" style="width: 150px;" data-options="onClick:mainMenuClick">
                <div data-options="iconCls:'icon-remove',name:'single'">单个报表</div>
                <div data-options="iconCls:'icon-add',name:'multi'">多个报表</div>
            </div>
            <a href="javascript:void(0)" id="mbChild" class="easyui-menubutton"
                data-options="menu:'#divChildmm',iconCls:'icon-import'">生成子表语句</a>
            <div id="divChildmm" style="width: 150px;" data-options="onClick:childMenuClick">
                <div data-options="iconCls:'icon-remove',name:'withOutSum'">不带合计行</div>
                <div data-options="iconCls:'icon-add',name:'withSum'">带合计行</div>
            </div>
            <a href="javascript:void(0)" id="mbStyle" class="easyui-linkbutton"
                data-options="iconCls:'icon-import',plain:true" onclick="buildStyle()">生成报表全局样式</a>
            <a href="javascript:void(0)" id="mbThisCompany" class="easyui-linkbutton"
                data-options="iconCls:'icon-import',plain:true" onclick="buildThisCompany()">生成本公司信息</a>
        </div>
        <script type="text/javascript">
            var LODOP;

            //让textarea可以输入tab
            var tabStr = "    ";
            var myInput = document.getElementById("txaDesinCodeSave")
            if (myInput.addEventListener) {
                myInput.addEventListener('keydown', this.keyHandler, false);
            } else if (myInput.attachEvent) {
                myInput.attachEvent('onkeydown', this.keyHandler); /* damn IE hack */
            }
            var myInput1 = document.getElementById("txaDesinCode")
            if (myInput1.addEventListener) {
                myInput1.addEventListener('keydown', this.keyHandler, false);
            } else if (myInput1.attachEvent) {
                myInput1.attachEvent('onkeydown', this.keyHandler); /* damn IE hack */
            }
            function keyHandler(e) {
                var TABKEY = 9;
                if (e.keyCode == TABKEY) {
                    insertText(myInput, tabStr);
                    if (e.preventDefault) {
                        e.preventDefault();
                    }
                }
            }
            $("#txaDesinCodeSave").val((pbDefined[0].sPbStr ? pbDefined[0].sPbStr.replace(/&apos;/g, "'") : ""));
            if ($("#txaDesinCodeSave").val() == "") {
                $("#txaDesinCodeSave").val("LODOP.PRINT_INIT(\"" + getQueryString("title") + "\");\r\nLODOP.SET_PRINT_STYLE(\"FontSize\",12);\r\nLODOP.SET_PRINT_STYLE(\"FontName\",\"微软雅黑\");\r\nLODOP.SET_PRINT_MODE(\"PROGRAM_CONTENT_BYVAR\",true);//生成程序时，内容参数有变量用变量，无变量用具体值\r\n");
            }

            $("#tabDataSource").datagrid({
                fit: true,
                columns: [
                    [
                        { title: "数据源名", field: "sSourceName", width: 100, align: "center" },
                        {
                            title: "数据源语句", field: "sSourceSql", width: 700, align: "center"
                            ,
                            formatter: function (value, row, index) {
                                return "<a href=\"#\" title=\"" + row.sSourceSql + "\" class=\"easyui-tooltip\">" + row.sSourceSql + "</a>";
                            }
                        }
                    ]
                ],
                toolbar: "#divToolBar",
                singleSelect: true,
                remoteSort: false
            });
            //dataSourceDefined.push({ sSourceName: "thisCompany", sSourceSql: "select * from vwbscDataThisCompanyInfo" });
            $("#tabDataSource").datagrid("loadData", dataSourceDefined);

            function copyTo() {
                var code = $("#txaDesinCode").val();
                var codeSave = $("#txaDesinCodeSave").val();
                if (codeSave != "") {
                    if (confirm("确定覆盖代码？") == true) {
                        $("#txaDesinCodeSave").val(code);
                    }
                }
                else {
                    $("#txaDesinCodeSave").val(code);
                }
            }
            function doClear() {
                if (confirm("你确定清空吗？") == true) {
                    $("#txaDesinCodeSave").val("");
                }
            }

            function exportExcel() {
                var code = $("#txaDesinCodeSave").val()
                LODOP = getLodop();
                eval(code);
                if (LODOP.CVERSION) CLODOP.On_Return = null;
                LODOP.SET_SAVE_MODE("Orientation", 2); //Excel文件的页面设置：横向打印   1-纵向,2-横向;
                LODOP.SET_SAVE_MODE("PaperSize", 9);  //Excel文件的页面设置：纸张大小   9-对应A4
                LODOP.SET_SAVE_MODE("Zoom", 90);       //Excel文件的页面设置：缩放比例
                LODOP.SET_SAVE_MODE("CenterHorizontally", true);//Excel文件的页面设置：页面水平居中
                LODOP.SET_SAVE_MODE("CenterVertically", true); //Excel文件的页面设置：页面垂直居中
                //		LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//快速生成（无表格样式,数据量较大时或许用到） 
                LODOP.SAVE_TO_FILE("新文件名.xls");
            }

            function doSave() {
                var code = $("#txaDesinCodeSave").val();
                $.ajax({
                    url: "PbLodop.aspx",
                    type: "post",
                    async: false,
                    cache: false,
                    data: { backType: "saveLodopReport", irecno: getQueryString("irecno"), str: encodeURIComponent(code) },
                    success: function (data) {
                        if (data == "1") {
                            alert("保存成功");
                        }
                        else {
                            alert(data);
                        }
                    },
                    error: function () {

                    }
                });

                //$.ajax({
                //    url: "/Base/PbLodop.aspx",
                //    type: "post",
                //    async: false,
                //    cache: false,
                //    data: { otype: "saveLodopReport", str: code },
                //    success: function (data) {
                //        if (data == "1") {
                //            alert("保存成功");
                //        }
                //        else {
                //            alert(data);
                //        }
                //    },
                //    error: function (data) {
                //        var aa = data;
                //    }
                //})
            }
            function mainMenuClick(item) {
                var selectedRow = $("#tabDataSource").datagrid("getSelected");
                if (selectedRow) {
                    var code = "";
                    if (item.name == "single") {
                        var i = 0;
                        var data = [];
                        eval("(data=" + selectedRow.sSourceName + ")");
                        for (var key in data[0]) {
                            code += "mainData" + selectedRow.sSourceName + i.toString() + "=\"" + key + "： \"+(" + selectedRow.sSourceName + "[0][\"" + key + "\"]==null?\"\":" + selectedRow.sSourceName + "[0][\"" + key + "\"]);\r\n";
                            i++;
                        }
                        i = 0;
                        for (var key in data[0]) {
                            var colNum = i % 4;
                            var rowNum = Math.floor(i / 4);
                            code += "LODOP.ADD_PRINT_TEXT(" + (50 + rowNum * 28) + ",  " + (20 + 165 * colNum) + ", 150, 25,mainData" + selectedRow.sSourceName + i.toString() + ");\r\n";
                            code += "LODOP.SET_PRINT_STYLEA(0,\"ContentVName\",\"mainData" + selectedRow.sSourceName + i.toString() + "\");\r\n";
                            //code += "LODOP.SET_PRINT_STYLEA(0,\"ItemType\",1);\r\n";
                            i++;
                        }
                    }
                    else if (item.name == "multi") {
                        code += "$.each(" + selectedRow.sSourceName + ",function(index,o){\r\n";
                        var i = 0;
                        var data = [];
                        eval("(data=" + selectedRow.sSourceName + ")");
                        for (var key in data[0]) {
                            code += "\tmainData" + selectedRow.sSourceName + i.toString() + "=\"" + key + "： \"+(" + selectedRow.sSourceName + "[index][\"" + key + "\"]==null?\"\":" + selectedRow.sSourceName + "[index][\"" + key + "\"]);\r\n";
                            i++;
                        }
                        i = 0;
                        for (var key in data[0]) {
                            var colNum = i % 4;
                            var rowNum = Math.floor(i / 4);
                            code += "\tLODOP.ADD_PRINT_TEXT(" + (50 + rowNum * 28) + ",  " + (20 + 165 * colNum) + ", 150, 25,mainData" + selectedRow.sSourceName + i.toString() + ");\r\n";
                            code += "\tLODOP.SET_PRINT_STYLEA(0,\"ContentVName\",\"mainData" + selectedRow.sSourceName + i.toString() + "\");\r\n";
                            //code += "\tLODOP.SET_PRINT_STYLEA(0,\"ItemType\",1);\r\n";
                            i++;
                        }
                        code += "\tif(index<" + selectedRow.sSourceName + ".length-1){\r\n" +
                        "\t\tLODOP.NewPageA();\r\n" +
                        "\t}\r\n" +
                        "});\r\n";
                    }
                    insertText(document.getElementById("txaDesinCodeSave"), code);

                    //var oCode = $("#txaDesinCodeSave").val();
                    //oCode += code;
                    //$("#txaDesinCodeSave").val(oCode);
                }
                else {
                    alert("请选择一个数据源！");
                }
            }
            function childMenuClick(item) {
                var selectedRow = $("#tabDataSource").datagrid("getSelected");
                if (selectedRow) {
                    var data = [];
                    eval("(data=" + selectedRow.sSourceName + ")");
                    var code = "//表格\r\nvar tableCss=\"<style type='text/css'>.table{width:98%;border-collapse:collapse;border:solid 1px #000000;font-family: 微软雅黑;font-size:14px;} .table tr th{border:solid 1px #000000;height:25px;text-align:center;} .table tr td{border:solid 1px #000000;height:25px;text-align:center;}</style>\";\r\n";
                    code += "var div" + selectedRow.sSourceName + "=$(\"<div id='div" + selectedRow.sSourceName + "'></div>\")\r\n";
                    code += "var table" + selectedRow.sSourceName + "=$(\"<table class='table'></table>\");\r\n";
                    code += "//表头\r\n";
                    //code += "var thead" + selectedRow.sSourceName + "=$(\"<thead></thead>\"); \r\n";
                    code += "var trHead" + selectedRow.sSourceName + "=$(\"<tr style='text-align:center;'></tr>\");\r\n";
                    code += "table" + selectedRow.sSourceName + ".append(trHead" + selectedRow.sSourceName + ");\r\n";
                    var i = 0;
                    for (var key in data[0]) {
                        code += "trHead" + selectedRow.sSourceName + ".append(\"<td>" + key + "</td>\");\r\n";
                        i++;
                    }
                    //code += "thead" + selectedRow.sSourceName + ".append(trHead" + selectedRow.sSourceName + ")\r\n";
                    code += "//表体\r\n";
                    //code += "var t" + selectedRow.sSourceName + "=$(<thead></thead>); table" + selectedRow.sSourceName + ".append(thead" + selectedRow.sSourceName + ")";
                    code += "$.each(" + selectedRow.sSourceName + ",function(index,o){\r\n" +
                    "\tvar trBody" + selectedRow.sSourceName + "=$(\"<tr style='text-align:center;'></tr>\");\r\n";
                    for (var key in data[0]) {
                        code += "\ttrBody" + selectedRow.sSourceName + ".append(\"<td>\"+(" + selectedRow.sSourceName + "[index][\"" + key + "\"]==null?\"\":" + selectedRow.sSourceName + "[index][\"" + key + "\"])+\"</td>\");\r\n";
                    }
                    code += "\ttable" + selectedRow.sSourceName + ".append(trBody" + selectedRow.sSourceName + ")\r\n";
                    code += "});\r\n";

                    if (item.name == "withOutSum") {

                    }
                    else if (item.name = "withSum") {
                        code += "//表尾合计\r\n";
                        //code += "var tfoot" + selectedRow.sSourceName + "=$(\"<tfoot></tfoot>\"); table" + selectedRow.sSourceName + ".append(tfoot" + selectedRow.sSourceName + ");\r\n";
                        code += "var trFooter" + selectedRow.sSourceName + "=$(\"<tr style='text-align:center;'></tr>\");\r\n";
                        code += "table" + selectedRow.sSourceName + ".append(trFooter" + selectedRow.sSourceName + ");\r\n";
                        for (var key in data[0]) {
                            code += "trFooter" + selectedRow.sSourceName + ".append(\"<td></td>\");\r\n";
                        }
                        //code += "tfoot" + selectedRow.sSourceName + ".append(trFooter" + selectedRow.sSourceName + ")\r\n";
                    }
                    code += "div" + selectedRow.sSourceName + ".append(table" + selectedRow.sSourceName + ");\r\n";
                    code += "LODOP.ADD_PRINT_TABLE(150,10,\"96%\",\"60%\",tableCss+div" + selectedRow.sSourceName + ".html())\r\n";

                    insertText(document.getElementById("txaDesinCodeSave"), code);
                }
                else {
                    alert("请选择一个数据源！");
                }
            }
            function buildStyle() {
                var code = "LODOP.PRINT_INIT(\"" + getQueryString("title") + "\");\r\nLODOP.SET_PRINT_STYLE(\"FontSize\",12);\r\nLODOP.SET_PRINT_STYLE(\"FontName\",\"微软雅黑\");\r\nLODOP.SET_PRINT_MODE(\"PROGRAM_CONTENT_BYVAR\",true);//生成程序时，内容参数有变量用变量，无变量用具体值\r\n";
                insertText(document.getElementById("txaDesinCodeSave"), code);
            }

            function getQueryString(name) {
                var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
                var r = window.location.search.substr(1).match(reg);
                if (r != null) return unescape(r[2]); return null;
            }

            function insertText(obj, str) {
                if (document.selection) {
                    var sel = document.selection.createRange();
                    sel.text = str;
                } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
                    var startPos = obj.selectionStart,
                    endPos = obj.selectionEnd,
                    cursorPos = startPos,
                    tmpStr = obj.value;
                    obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length);
                    cursorPos += str.length;
                    obj.selectionStart = obj.selectionEnd = cursorPos;
                } else {
                    obj.value += str;
                }
            }
            function moveEnd(obj) {
                obj.focus();
                var len = obj.value.length;
                if (document.selection) {
                    var sel = obj.createTextRange();
                    sel.moveStart('character', len);
                    sel.collapse();
                    sel.select();
                } else if (typeof obj.selectionStart == 'number' && typeof obj.selectionEnd == 'number') {
                    obj.selectionStart = obj.selectionEnd = len;
                }
            }

            function PrintPreview() {
                doPreview(1);
            }
            function PrintSetup() {
                LODOP = getLodop();
                var designCode = $("#txaDesinCodeSave").val();
                eval(designCode);
                LODOP.PRINT_SETUP();
            }
            function doDesign() {
                LODOP = getLodop();
                var designCode = $("#txaDesinCodeSave").val();
                eval(designCode);
                if (LODOP.CVERSION) CLODOP.On_Return = function (TaskID, Value) { $("#txaDesinCode").val(Value); };
                LODOP.PRINT_DESIGN();
            }

            function doPreview(itype) {
                var code = itype == 1 ? $("#txaDesinCodeSave").val() : $("#txaDesinCode").val();	//打印前变量重读一下最新值
                LODOP = getLodop();
                eval(code);
                //LODOP.SET_PRINT_MODE("CATCH_PRINT_STATUS", true);
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        if (Value > 0) {
                            afterPrint(Value);
                        }
                    };
                    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
                    LODOP.PREVIEW();
                } else {
                    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
                    var printCount = LODOP.PREVIEW();
                    afterPrint(printCount);
                }
                var returnFn = getQueryString("returnFn");
                if (returnFn != null && returnFn != undefined) {
                    if (window.opener) {
                        eval("window.opener." + returnFn + "()");
                    }
                    else {
                        if (window.parent) {
                            eval("window.parent." + returnFn + "()");
                        }
                    }
                }
                return;
            }
            function Print() {
                LODOP = getLodop();
                var designCode = $("#txaDesinCodeSave").val();
                eval(designCode);
                //LODOP.SET_PRINT_MODE("CATCH_PRINT_STATUS", true);
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        //document.getElementById('txbPrintJob').value = Value;
                        //printEvent();
                        if (Value == true) {
                            afterPrint(1);
                        }
                    };
                    LODOP.PRINT();
                } else {
                    var success = LODOP.PRINT();
                    if (success == true) {
                        afterPrint(1);
                    }
                }
                var returnFn = getQueryString("returnFn");
                if (returnFn != null && returnFn != undefined) {
                    if (window.opener) {
                        eval("window.opener." + returnFn + "()");
                    }
                    else {
                        if (window.parent) {
                            eval("window.parent." + returnFn + "()");
                        }
                    }
                }
                return;
            }

            function afterPrint(printCount) {
                //alert(1);
                var iformid = getQueryString("iformid");
                var key = getQueryString("key");
                var irecno = getQueryString("irecno");
                if (iformid == pbDefined[0].iFormID && irecno == pbDefined[0].iRecNo) {
                    //存储过程有四个固定参数  iFormID,key,userid,printCount
                    if (pbDefined[0].sAfterPrintStoredProcedure) {
                        var jsonobj = {
                            StoreProName: pbDefined[0].sAfterPrintStoredProcedure,
                            StoreParms: [{
                                ParmName: "@iFormID",
                                Value: iformid
                            }, {
                                ParmName: "@key",
                                Value: key
                            }, {
                                ParmName: "@sUserID",
                                Value: userid
                            }, {
                                ParmName: "@iPrintCount",
                                Value: printCount
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            alert(result);
                        }
                        else {
                            if (window.opener) {
                                window.opener.GridRefresh();
                            }
                            else if (window.parent && window.parent.FormList) {
                                window.parent.FormList.NeedSelectedKey = null;
                                window.parent.GridRefresh();
                            }
                            else {
                                window.returnValue = "1";
                            }
                        }
                    }
                }
            }

            function printEvent() {
                var afterPrint = function () {
                    //alert(1);
                    var iformid = getQueryString("iformid");
                    var key = getQueryString("key");
                    var irecno = getQueryString("irecno");
                    if (iformid == pbDefined[0].iFormID && irecno == pbDefined[0].iRecNo) {
                        //存储过程有三个固定参数  iFormID,key,userid
                        if (pbDefined[0].sAfterPrintStoredProcedure) {
                            var jsonobj = {
                                StoreProName: pbDefined[0].sAfterPrintStoredProcedure,
                                StoreParms: [{
                                    ParmName: "@iFormID",
                                    Value: iformid
                                }, {
                                    ParmName: "@key",
                                    Value: key
                                }, {
                                    ParmName: "@sUserID",
                                    Value: userid
                                }
                                ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                alert(result);
                            }
                            else {
                                if (window.opener) {
                                    window.opener.GridRefresh();
                                }
                                else if (window.parent && window.parent.FormList) {
                                    window.parent.FormList.NeedSelectedKey = null;
                                    window.parent.GridRefresh();
                                }
                                else {
                                    window.returnValue = "1";
                                }
                            }
                        }
                    }
                }

                var jobCode = document.getElementById('txbPrintJob').value;
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        if (Value == "1") {
                            afterPrint();
                        }
                    };
                }
                var strResult = LODOP.GET_VALUE("PRINT_STATUS_OK", jobCode);
                if (!LODOP.CVERSION) {
                    if (strResult == "1") {
                        afterPrint();
                    }
                }
            }

            function getNowDate() {
                var nowdate = new Date();
                var year = nowdate.getFullYear();
                var month = nowdate.getMonth();
                var date = nowdate.getDate();
                var monthstr = (month + 1).toString();
                var datestr = date.toString();
                if (month < 9) {
                    monthstr = '0' + (month + 1).toString();
                }
                if (date < 10) {
                    datestr = '0' + date.toString();
                }
                return year.toString() + "-" + monthstr + "-" + datestr;
            }
            //获取当前时时
            function getNowTime() {
                var nowdate = new Date();
                var hour = nowdate.getHours();      //获取当前小时数(0-23)
                var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
                var second = nowdate.getSeconds();
                return hour + ":" + minute + ":" + second;
            }

            var compare = function (prop) {
                return function (obj1, obj2) {
                    var val1 = obj1[prop];
                    var val2 = obj2[prop];
                    if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                        val1 = Number(val1);
                        val2 = Number(val2);
                    }
                    if (val1 < val2) {
                        return -1;
                    } else if (val1 > val2) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            }
            var hxLodop = {
                getNowDate: function () {
                    var nowdate = new Date();
                    var year = nowdate.getFullYear();
                    var month = nowdate.getMonth();
                    var date = nowdate.getDate();
                    var monthstr = (month + 1).toString();
                    var datestr = date.toString();
                    if (month < 9) {
                        monthstr = '0' + (month + 1).toString();
                    }
                    if (date < 10) {
                        datestr = '0' + date.toString();
                    }
                    return year.toString() + "-" + monthstr + "-" + datestr;
                },
                getNowTime: function () {
                    var nowdate = new Date();
                    var hour = nowdate.getHours();      //获取当前小时数(0-23)
                    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
                    var second = nowdate.getSeconds();
                    return hour + ":" + minute + ":" + second;
                }
            }

            function buildThisCompany() {
                var code = "";
                var i = 0;
                var data = [];
                eval("(data=thisCompany)");
                for (var key in data[0]) {
                    code += "thisCompany" + key.substr(1) + "=thisCompany[0][\"" + key + "\"]==null?\"\":thisCompany[0][\"" + key + "\"];\r\n";
                    i++;
                }
                i = 0;
                for (var key in data[0]) {
                    var colNum = i % 3;
                    var rowNum = Math.floor(i / 3);
                    if (key == "sLogo") {
                        code += "LODOP.ADD_PRINT_IMAGE(0,0,50,50,\"<img src='/images/companyLogo/\"+thisCompany" + key.substr(1) + "+\"'>\");\r\n";
                        code += "LODOP.SET_PRINT_STYLEA(0,\"Stretch\",2);\r\n";
                    }
                    else{
                        code += "LODOP.ADD_PRINT_TEXT(" + (5 + rowNum * 28) + ",  " + (60 + 230 * colNum) + ", 215, 25,thisCompany" + key.substr(1) + ");\r\n";
                        code += "LODOP.SET_PRINT_STYLEA(0,\"ContentVName\",\"thisCompany" + key.substr(1) + "\");\r\n";
                        i++;
                    }   
                }
                insertText(document.getElementById("txaDesinCodeSave"), code);
            }
        </script>
    </form>

</body>
</html>
