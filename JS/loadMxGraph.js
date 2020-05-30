function graphLoad(container, xmlStr) {
    // Checks if the browser is supported
    if (!mxClient.isBrowserSupported()) {
        // Displays an error message if the browser is not supported.
        mxUtils.error('浏览器不支持流程图', 200, false);
    }
    else {
        var graph = new mxGraph(container);
        new mxRubberband(graph);

        graph.setConnectable(false);
        //graph.setCellsLocked(true);
        //        graph.isWrapping = function (cell) {
        //            return true;
        //        }
        graph.setEnabled(false);
        graph.setTooltips(false);
        graph.isHtmlLabel = function (cell) {
            return true;
        }

        graph.convertValueToString = function (cell) {
            if (mxUtils.isNode(cell.value)) {
                if (cell.value.nodeName.toLowerCase() == 'object') {
                    var title = cell.getAttribute('label', '');
                    return title;
                }
                else if (cell.value.nodeName.toLowerCase() == 'userobject') {
                    var title = cell.getAttribute('label', '');
                    return title;
                }
                else {
                    return cell.value;
                }
            }
            return cell.value;
        };
        // Handles clicks on cells
        graph.addListener(mxEvent.CLICK, function (sender, evt) {
            var cell = evt.getProperty('cell');
            if (cell != null) {
                if (mxUtils.isNode(cell.value)) {
                    if (cell.value.nodeName.toLowerCase() == 'object') {
                        var iMenuID = cell.getAttribute('iMenuID', '');
                        if (iMenuID != null && iMenuID != undefined && iMenuID != "") {
                            var urlObj = {
                                isLink: false,
                                link: null,
                                iMenuID: iMenuID,
                                title: ""
                            }
                            openMxGraphTab(urlObj);
                        }
                    }
                    else if (cell.value.nodeName.toLowerCase() == 'userobject') {
                        var iMenuID = cell.getAttribute('iMenuID', '');
                        if (iMenuID != null && iMenuID != undefined && iMenuID != "") {
                            var urlObj = {
                                isLink: false,
                                link: null,
                                iMenuID: iMenuID,
                                title: ""
                            }
                            openMxGraphTab(urlObj);
                            return;
                        }
                        var link = cell.getAttribute('link', '');
                        var urlObj = {
                            isLink: true,
                            link: link,
                            title: cell.getAttribute('label', '')
                        }
                        openMxGraphTab(urlObj);
                    }
                }
                else {

                }
            }
        });

        graph.getCursorForCell = function (cell) {
            if (mxUtils.isNode(cell.value))
                return 'pointer';
            //                    if (cell != null &&	cell.value != null &&typeof (cell.value.create) == 'function') {
            //                        
            //                    }
        };

        // Changes the style for match the markup
        // Creates the default style for vertices
        var style = graph.getStylesheet().getDefaultVertexStyle();
        style[mxConstants.STYLE_STROKECOLOR] = 'gray';
        style[mxConstants.STYLE_ROUNDED] = true;
        style[mxConstants.STYLE_SHADOW] = true;
        style[mxConstants.STYLE_FILLCOLOR] = '#DFDFDF';
        style[mxConstants.STYLE_GRADIENTCOLOR] = 'white';
        style[mxConstants.STYLE_FONTCOLOR] = 'black';
        style[mxConstants.STYLE_FONTSIZE] = '14';
        style[mxConstants.STYLE_SPACING] = 4;

        // Creates the default style for edges
        //        style = graph.getStylesheet().getDefaultEdgeStyle();
        //        style[mxConstants.STYLE_STROKECOLOR] = '#0C0C0C';
        //        style[mxConstants.STYLE_LABEL_BACKGROUNDCOLOR] = 'white';
        //        style[mxConstants.STYLE_EDGE] = mxEdgeStyle.ElbowConnector;
        //        style[mxConstants.STYLE_ROUNDED] = true;
        //        style[mxConstants.STYLE_FONTCOLOR] = 'black';
        //        style[mxConstants.STYLE_FONTSIZE] = '10';
        //        style[mxConstants.STYLE_WHITE_SPACE] = "wrap";

        //        graph.getModel().beginUpdate();
        //        var xml = xmlStr;

        //        graph.addListener(mxEvent.CLICK, function (sender, evt) {
        //            var cell = evt.getProperty('cell');
        //            if (cell != null) {
        //                if (mxUtils.isNode(cell.value)) {
        //                    if (cell.value.nodeName.toLowerCase() == 'object') {
        //                        var iMenuID = cell.getAttribute('iMenuID', '');
        //                        if (iMenuID != null && iMenuID != undefined && iMenuID != "") {
        //                            var urlObj = {
        //                                isLink: false,
        //                                link: null,
        //                                iMenuID: iMenuID,
        //                                title: ""
        //                            }
        //                            openMxGraphTab(urlObj);
        //                        }
        //                    }
        //                    else if (cell.value.nodeName.toLowerCase() == 'userobject') {
        //                        var iMenuID = cell.getAttribute('iMenuID', '');
        //                        if (iMenuID != null && iMenuID != undefined && iMenuID != "") {
        //                            var urlObj = {
        //                                isLink: false,
        //                                link: null,
        //                                iMenuID: iMenuID,
        //                                title: ""
        //                            }
        //                            openMxGraphTab(urlObj);
        //                            return;
        //                        }
        //                        var link = cell.getAttribute('link', '');
        //                        var urlObj = {
        //                            isLink: true,
        //                            link: link,
        //                            title: cell.getAttribute('label', '')
        //                        }
        //                        openMxGraphTab(urlObj);
        //                    }
        //                }
        //                else {

        //                }
        //            }
        //        });

        //        graph.getCursorForCell = function (cell) {
        //            if (mxUtils.isNode(cell.value))
        //                return 'pointer';
        //            //                    if (cell != null &&	cell.value != null &&typeof (cell.value.create) == 'function') {
        //            //                        
        //            //                    }
        //        };
        var xml = xmlStr;
        var doc = mxUtils.parseXml(xml);
        var codec = new mxCodec(doc);
        codec.decode(doc.documentElement, graph.getModel());
        graph.getModel().endUpdate();
    }
}

/*
urlObj={
isLink:true or false,
link:"",
iMenuID:int,
title:""
}
*/
function openMxGraphTab(urlObj) {
    var node = {
        text: urlObj.title,
        attributes: {}
    }
    if (urlObj.isLink == true) {
        node.attributes.sFilePath = urlObj.link;
        node.attributes.sParms = "";
        top.MenuClick(node);
    }
    else {
        var iMenuID = urlObj.iMenuID;
        //获取菜单详情
        $.ajax({
            url: "/MainPage.request",
            type: "get",
            async: false,
            cache: false,
            data: { Command: "getTheMenuDetail", iMenuID: iMenuID },
            success: function (data) {
                if (data.success == true) {
                    if (data.tables.length > 0) {
                        var obj = data.tables[0][0];
                        node.attributes.iconCls = obj.sIcon;
                        node.attributes.sParms = obj.sParms == null ? "" : obj.sParms;
                        node.attributes.sFilePath = obj.sFilePath;
                        node.attributes.iFormID = obj.iFormID;
                        node.id = iMenuID;
                        node.text = obj.sMenuName;
                        top.MenuClick(node);
                    }
                }
                else {
                    alert("目录表单不存在");
                }
            },
            error: function (data) {
                var aa = "11";
            },
            dataType: "json"
        });

    }
}