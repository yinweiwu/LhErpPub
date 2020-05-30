﻿//移动键盘
function dragMing(idORclass1, idORclass2) {
    var obj = this; //这里的this是指dragMing对象么
    this.idORclass1 = idORclass1; //给dragMing的idORclass1赋值
    this.idORclass2 = idORclass2; //给dragMing的idORclass2赋值
    this.deltaX = 0;
    this.deltaY = 0;

    function dragStart(dragEvent) {
        obj.deltaX = dragEvent.clientX - $(obj.idORclass2).offset().left;
        obj.deltaY = dragEvent.clientY - $(obj.idORclass2).offset().top;
        $(document).bind("mousemove", dragMove);
        $(document).bind("mouseup", dragStop);
        dragEvent.preventDefault();

    }
    function dragMove(dragEvent) {
        $(obj.idORclass2).css({
            "left": (dragEvent.clientX - obj.deltaX) + "px",
            "top": (dragEvent.clientY - obj.deltaY) + "px"
        })
        dragEvent.preventDefault();

    }
    function dragStop() {
        $(document).unbind("mousemove", dragMove);
        $(document).unbind("mouseup", dragStop);

    }

    $(document).ready(function () {
        $(obj.idORclass1).bind("mousedown", dragStart);

    })
}



//绘制键盘
function drawKeyboard(type) {
    $("#keyboardNum").empty();
    $("#keyboardLetterQ").empty();
    $("#keyboardLetterA").empty();
    $("#keyboardLetterZ").empty();
    $("#keyboardSpaceBar").empty();

    if (type == "lower") {
        var keyboardNum = { "192": "`", "49": "1", "50": "2", "51": "3", "52": "4", "53": "5", "54": "6", "55": "7", "56": "8", "57": "9", "48": "0", "189": "-", "187": "=", "8": "Backspace" };
        var keyboardLetterQ = { "81": "q", "87": "w", "69": "e", "82": "r", "84": "t", "89": "y", "85": "u", "73": "i", "79": "o", "80": "p", "219": "[", "221": "]" };
        var keyboardLetterA = { "20": "Caps Lock", "65": "a", "83": "s", "68": "d", "70": "f", "71": "g", "72": "h", "74": "j", "75": "k", "76": "l", "186": ";", "222": "'", "220": "\\" };
        var keyboardLetterZ = { "16": "Shift", "90": "z", "88": "x", "67": "c", "86": "v", "66": "b", "78": "n", "77": "m", "188": ",", "190": ".", "191": "/" };
        var keyboardSpaceBar = { "32": "Space", "": "Tim" };
        var key = "";
    }
    else {
        var keyboardNum = { "192": "~", "49": "!", "50": "@", "51": "#", "52": "$", "53": "%", "54": "^", "55": "&", "56": "*", "57": "(", "48": ")", "189": "_", "187": "+", "8": "Backspace" };
        var keyboardLetterQ = { "81": "Q", "87": "W", "69": "E", "82": "R", "84": "T", "89": "Y", "85": "U", "73": "I", "79": "O", "80": "p", "219": "{", "221": "}" };
        var keyboardLetterA = { "20": "Caps Lock", "65": "A", "83": "S", "68": "D", "70": "F", "71": "G", "72": "H", "74": "J", "75": "K", "76": "L", "186": ":", "222": "\"", "220": "|" };
        var keyboardLetterZ = { "16": "Shift", "90": "Z", "88": "X", "67": "C", "86": "V", "66": "B", "78": "N", "77": "M", "188": "<", "190": ">", "191": "?" };
        var keyboardSpaceBar = { "32": "Space", "": "Tim" };
        var key = "";
    }
    $.each(keyboardNum, function (key, value) {
        if (value != "Backspace") {
            key = $('<div class="simpleKey" name="key" key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardNum").append(key);
        }
        else {
            key = $('<div class="backspaceKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardNum").append(key);
        }
    });

    $.each(keyboardLetterQ, function (key, value) {
        key = $('<div class="simpleKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
        $("#keyboardLetterQ").append(key);
    });

    $.each(keyboardLetterA, function (key, value) {
        if (value != "Caps Lock") {
            key = $('<div class="simpleKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardLetterA").append(key);
        }
        else {
            key = $('<div class="capslockKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardLetterA").append(key);
        }
    });

    $.each(keyboardLetterZ, function (key, value) {
        if (value != "Shift") {
            key = $('<div class="simpleKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardLetterA").append(key);
        }
        else {
            key = $('<div class="shiftKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardLetterA").append(key);
        }
    });

    $.each(keyboardSpaceBar, function (key, value) {
        if (value != "Space") {
            key = $('<div class="simpleKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardSpaceBar").append(key);
        }
        else {
            key = $('<div class="spaceKey" name="key"  key="' + key + '" value="' + value + '">' + value + '</div>');
            $("#keyboardSpaceBar").append(key);
        }
    });

    addMouseClickEvent();


}

//监听鼠标点击事件
function addMouseClickEvent() {
    $("#close").click(function () {
        closeKeyboard()
    });

    $("div[name='key']").hover(function () {
        $(this).css("background-color", "Gray");
    }, function () {
        $(this).css("background-color", "White");
    }).click(function () {
        var thisValue = $(this).attr("value");
        var ID = $("#state").val();
        switch (thisValue) {
            case "": //"
                $("#" + ID).val($("#" + ID).val() + "\"");
                if ($("#shift").attr("checked") == true) {
                    if ($("#capsLock").attr("checked") != true) {
                        drawKeyboard("lower");
                    }
                    $("#shift").attr("checked", false);
                }
                break;
            case "Shift":
                $("#shift").attr("checked", $("#shift").attr("checked") == true ? false : true);
                if ($("#shift").attr("checked") == true) {
                    drawKeyboard("upper")
                }
                else {
                    if ($("#capsLock").attr("checked") != true) {
                        drawKeyboard("lower");
                    }
                }
                break;
            case "Caps Lock":
                $("#capsLock").attr("checked", $("#capsLock").attr("checked") == true ? false : true);
                $("#capsLock").attr("checked") == true ? drawKeyboard("upper") : drawKeyboard("lower");
                $("#shift").attr("checked", false)
                break;
            case "Space":
                $("#" + ID).val($("#" + ID).val() + " ");
                break;
            case "Backspace":
                $("#" + ID).val($("#" + ID).val().substring(0, $("#" + ID).val().length - 1));
                break;
            default:
                $("#" + ID).val($("#" + ID).val() + thisValue);
                if ($("#shift").attr("checked") == true) {
                    if ($("#capsLock").attr("checked") != true) {
                        drawKeyboard("lower");
                    }
                    $("#shift").attr("checked", false);
                }

                break;
        }
        $("#" + ID).focus();
    });
}


//监听键盘事件
function addKeydownEvent() {
    $("html").keydown(function (event) {
        var realkey = String.fromCharCode(event.keyCode);

        //特殊键
        if (event.keyCode == 32) { realkey = "Space" }
        if (event.keyCode == 13) { realkey = "Enter" }
        if (event.keyCode == 27) { realkey = " Esc" }
        if (event.keyCode == 16) {
            realkey = "Shift";
            $("#shift").attr("checked", $("#shift").attr("checked") == true ? false : true);
            if ($("#shift").attr("checked") == true) {
                drawKeyboard("upper")
            }
            else {
                if ($("#capsLock").attr("checked") != true) {
                    drawKeyboard("lower");
                }
            }
        }
        if (event.keyCode == 17) { realkey = " Ctrl" }
        if (event.keyCode == 18) { realkey = "Alt" }
        if (event.keyCode == 8) { realkey = "Backspace" }
        if (event.keyCode == 20) { realkey = "Caps Lock"; $("#capsLock").attr("checked", $("#capsLock").attr("checked") == true ? false : true); $("#capsLock").attr("checked") == true ? drawKeyboard("upper") : drawKeyboard("lower"); }


        $("div[name='key']").css("background-color", "White")
        $("div[key=" + event.keyCode + "]").css("background-color", "Gray");

        //如果按了shif再按其他键并且这个键不是shif键盘变回小写
        //如果capsLock选中了键盘就不用变回小写
        if ($("#shift").attr("checked") == true && event.keyCode != 16) {
            if ($("#capsLock").attr("checked") != true) {
                drawKeyboard("lower");
            }
            $("#shift").attr("checked", false);
        }

    });
}

//打开键盘
function openKeyboard(ID) {
    $("#keyboard").css("visibility", "visible");
    $("#state").val(ID);
}

//关闭键盘
function closeKeyboard() {
    $("#keyboard").css("visibility", "hidden")
}


$(function () {
    var divKeyBoard = '<div id="keyboard" class="keyboard"><div id="keyboardHead"><div><input id="shift" type="checkbox"/>Shift</div><div><input id="capsLock" type="checkbox"/>Caps Lock</div><div id="close" style="border:1px solid black; float:right; width:20px; height:20px; cursor:pointer;"><img src="/Image/close.gif" style=" width:20px; height:20px"/></div></div><div id="keyboardNum"></div><div id="keyboardLetterQ"></div><div id="keyboardLetterA"></div><div id="keyboardLetterZ"></div><div id="keyboardSpaceBar"></div></div>';
    $("body").append(divKeyBoard);
    drawKeyboard("lower");
    addKeydownEvent();
    $("#keyboard").css("visibility", "hidden");
    var drag = new dragMing("#keyboard", "#keyboard");

})