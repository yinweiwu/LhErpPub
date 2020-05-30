$(function () {
    var dataChartType = [{ v: "0", t: "曲线图" },
        { v: "1", t: "柱状图" },
        { v: "2", t: "饼图" },
        { v: "3", t: "极坐标" },
        { v: "4", t: "雷达图" }, { v: "5", t: "仪表图" }];
    $("#txbChartType").combobox({
        valueField: "v", textField: "t", data: dataChartType, multiple: true,
        formatter: function (row) {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField];
            }
            else {
                return row[opts.textField];
            }
        },
        onSelect: function (row) {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                var el = opts.finder.getEl(this, row[opts.valueField]);
                el.find('input.combobox-checkbox')._propAttr('checked', true);
            }
        },
        onUnselect: function (row) {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                var el = opts.finder.getEl(this, row[opts.valueField]);
                el.find('input.combobox-checkbox')._propAttr('checked', false);
            }
        },
        onShowPanel: function () {
            var opts = $(this).combobox('options');
            if (opts.multiple == true) {
                var target = this;
                var values = $(target).combobox('getValues');
                $.map(values, function (value) {
                    var el = opts.finder.getEl(target, value);
                    el.find('input.combobox-checkbox')._propAttr('checked', true);
                })
            }
        }
    });
    $("#txbChartType").attr("plugin", "combobox");
    var dataPointShap = [{ v: "circle", t: "圆圈" }, { v: "rect", t: "矩形" }, { v: "roundRect", t: "圆弧" },
        { v: "triangle", t: "三角形" }, { v: "diamond", t: "钻石" }, { v: "pin", t: "大头针" }, { v: "arrow", t: "箭头" }, { v: "none", t: "空" }];
    $("#txbLineItemSymbol").combobox({
        valueField: "v", textField: "t", data: dataPointShap
    });
    $("#txbLineItemSymbol").combobox("setValue", "circle");
    var dataRoseType = [{ v: "radius", t: "radius:扇区圆心角展现数据的百分比，半径展现数据的大小" }, { v: "area", t: "area:所有扇区圆心角相同，仅通过半径展现数据大小" }];
    $("#txbPieRoseType").combobox({
        valueField: "v", textField: "t", data: dataRoseType,
        panelWidth: 400, panelHeight: 100
    });
    $("#txbPieRoseType").combobox("setValue", "radius");
    var dataRadarShape = [{ v: "polygon", t: "多边形" }, { v: "circle", t: "圆圈" }];
    $("#txbRadarShape").combobox({
        valueField: "v", textField: "t", data: dataRadarShape, panelHeight: 100
    });
    $("#txbRadarShape").combobox("setValue", "polygon");
    var itemLabelFormatterSimple = "<p style=\"font-family:&quot;color:#333333;font-size:14px;\">" +
	"<span style=\"font-weight:700;\">字符串模板</span>&nbsp;模板变量有：" +
    "</p>" +
    "<ul style=\"font-family:&quot;color:#333333;font-size:14px;\">" +
	    "<li>" +
        "{a}：系列名。" +
	    "</li>" +
	    "<li>" +
        "{b}：数据名。" +
	    "</li>" +
	    "<li>" +
        "{c}：数据值。" +
	    "</li>" +
	    "<li>" +
        "{@xxx}：数据中名为'xxx'的维度的值，如{@product}表示名为'product'` 的维度的值。" +
    "</li>" +
    "<li>" +
        "{@[n]}：数据中维度n的值，如{@[3]}` 表示维度 3 的值，从 0 开始计数。" +
	    "</li>"
        "</ul>"
        "<p style=\"font-family:&quot;color:#333333;font-size:14px;\">" +
            "<span style=\"font-weight:700;\">示例：</span>" +
        "</p>" +
        "<pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;\">formatter</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;\"> </span><span class=\"str\" style=\"font-family:Monaco, Consolas, &quot;\">'{b}: {@score}'</span></pre>" +
        $($("#txbItemLabelFormatterSimple").textbox("textbox")).tooltip({ content: itemLabelFormatterSimple });
    $("#ExtTextArea11").tooltip({
        content: "function(params){ }" +
        "params参数：<br />" +
        "{" +
            "componentType: 'series',<br />" +
        "// 系列类型<br />" +
        "seriesType: string,<br />" +
        "// 系列在传入的 option.series 中的 index<br />" +
        "seriesIndex: number,<br />" +
        "// 系列名称<br />" +
        "seriesName: string,<br />" +
        "// 数据名，类目名<br />" +
        "name: string,<br />" +
        "// 数据在传入的 data 数组中的 index<br />" +
        "dataIndex: number,<br />" +
        "// 传入的原始数据项<br />" +
        "data: Object,<br />" +
        "// 传入的数据值<br />" +
        "value: number|Array,<br />" +
        "// 数据图形的颜色<br />" +
        "color: string<br />" +
        "}"
    });

    var dataValuePostion = [
        { t: "top" }, { t: "left" }, { t: "right" }, { t: "bottom" }, { t: "inside" }, { t: "insideLeft" }, { t: "insideRight" }, { t: "insideTop" },
        { t: "insideBottom" }, { t: "insideTopLeft" }, { t: "insideBottomLeft" }, { t: "insideTopRight" }, { t: "insideBottomRight" }
    ];
    $("#txbValuePostion").combobox({
        valueField: "t", textField: "t", data: dataValuePostion,width:70
    });
    $("#txbValuePostion").combobox("setValue", "top");

    var dataItemBorderType = [
        { t: "solid" }, { t: "dashed" }, { t: "dotted" }
    ];
    $("#txbLineItemBorderType").combobox({
        valueField: "t", textField: "t", data: dataItemBorderType
    });
    $("#txbLineItemBorderType").combobox("setValue", "solid");

    var toolTipSimpleToolTipStr = "<blockquote style=\"font-family:&quot;color:#999999;\">  <p>   <span style=\"font-weight:700;\">注意：</span>series.tooltip&nbsp;仅在&nbsp;<a href=\"http://echarts.baidu.com/option.html#tooltip.trigger\">tooltip.trigger</a>&nbsp;为&nbsp;'item'&nbsp;时有效。  </p> </blockquote> <p style=\"font-family:&quot;color:#333333;font-size:14px;\">  提示框浮层内容格式器，支持字符串模板和回调函数两种形式。 </p> <p style=\"font-family:&quot;color:#333333;font-size:14px;\">  <span style=\"font-weight:700;\">1, 字符串模板</span> </p> <p style=\"font-family:&quot;color:#333333;font-size:14px;\">  模板变量有&nbsp;{a},&nbsp;{b}，{c}，{d}，{e}，分别表示系列名，数据名，数据值等。 在&nbsp;<a href=\"http://echarts.baidu.com/option.html#tooltip.trigger\">trigger</a>&nbsp;为&nbsp;'axis'&nbsp;的时候，会有多个系列的数据，此时可以通过&nbsp;{a0},&nbsp;{a1},&nbsp;{a2}&nbsp;这种后面加索引的方式表示系列的索引。 不同图表类型下的&nbsp;{a}，{b}，{c}，{d}&nbsp;含义不一样。 其中变量{a},&nbsp;{b},&nbsp;{c},&nbsp;{d}在不同图表类型下代表数据含义为： </p> <ul style=\"font-family:&quot;color:#333333;font-size:14px;\">  <li>   <p>    折线（区域）图、柱状（条形）图、K线图 :&nbsp;{a}（系列名称），{b}（类目值），{c}（数值）,&nbsp;{d}（无）   </p>  </li>  <li>   <p>    散点图（气泡）图 :&nbsp;{a}（系列名称），{b}（数据名称），{c}（数值数组）,&nbsp;{d}（无）   </p>  </li>  <li>   <p>    地图 :&nbsp;{a}（系列名称），{b}（区域名称），{c}（合并数值）,&nbsp;{d}（无）   </p>  </li>  <li>   <p>    饼图、仪表盘、漏斗图:&nbsp;{a}（系列名称），{b}（数据项名称），{c}（数值）,&nbsp;{d}（百分比）   </p>  </li> </ul> <p style=\"font-family:&quot;color:#333333;font-size:14px;\">  更多其它图表模板变量的含义可以见相应的图表的 label.formatter 配置项。 </p> <p style=\"font-family:&quot;color:#333333;font-size:14px;\">  <span style=\"font-weight:700;\">示例：</span> </p> <pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">formatter</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"str\" style=\"font-family:Monaco, Consolas, &quot;color:#008800;\">'{b0}: {c0}&lt;br /&gt;{b1}: {c1}'</span></pre>";
    $($("#txbToolTipSimle").textbox("textbox")).tooltip({ content: toolTipSimpleToolTipStr });
    var toolTipFnToolTipStr = "<p>  <p style=\"font-family:&quot;color:#333333;font-size:14px;\">   回调函数格式：  </p> <pre><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">(</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">params</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"typ\" style=\"font-family:Monaco, Consolas, &quot;color:#660066;\">Object</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">|</span><span class=\"typ\" style=\"font-family:Monaco, Consolas, &quot;color:#660066;\">Array</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> ticket</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> callback</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">(</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">ticket</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> html</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">))</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">=&gt;</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span></pre>  <p style=\"font-family:&quot;color:#333333;font-size:14px;\">   第一个参数&nbsp;params&nbsp;是 formatter 需要的数据集。格式如下：  </p> <pre><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">{</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> componentType</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"str\" style=\"font-family:Monaco, Consolas, &quot;color:#008800;\">'series'</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span></pre> <pre>seriesType<span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span>// 系列类型</pre> <pre>seriesIndex<span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> number</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,// 系列在传入的 option.series 中的 index</span></pre> <pre><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">seriesName<span class=\"pun\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span></span>// 系列名称<span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span></pre> <pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">name</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span>// 数据名，类目名<span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span> </pre> <pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">dataIndex</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> number</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span>// 数据在传入的 data 数组中的 index<span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span></pre> <pre>data<span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"typ\" style=\"font-family:Monaco, Consolas, &quot;color:#660066;\">Object</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span>// 传入的原始数据项<span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span></pre> <pre>value<span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> number</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">|</span><span class=\"typ\" style=\"font-family:Monaco, Consolas, &quot;color:#660066;\">Array</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span>// 传入的数据值<span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span></pre> <pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">color</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> string</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">,</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span>// 数据图形的颜色<span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"></span></pre> <pre><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\">percent</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">:</span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> number</span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">// 饼图的百分比<span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span> </span><span class=\"pln\" style=\"font-family:Monaco, Consolas, &quot;color:#000000;\"> </span><span class=\"pun\" style=\"font-family:Monaco, Consolas, &quot;color:#666600;\">}</span></pre> </p> <p> </p>";
    $("#txaToolTipFn").tooltip({
        content: toolTipFnToolTipStr
    });
    $("#txbLineWidth").textbox("setValue", "2");
    $("#txbLineItemSymbolSize").textbox("setValue", "4");
    $("#txbLineItemBorderWidth").textbox("setValue", "0");
})