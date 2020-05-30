$.ajax(
{
    url: "Handler/AutoLogin.ashx",
    async: false,
    success: function (data) {
        if (data == "1") {
            window.location.href = "Default.htm";
        }
    },
    cache: false
}
);

function Submit() {
    var strUsername = $("#TxtUserName").val();
    var strPwd = $("#TxtUserPwd").val();
    if (strUsername == "") {
        alert("请输入用户名！"); $("#TxtUserName").focus(); return false;
    }

    $.ajax({
        type: "Post",
        url: "Handler/Login.ashx",
        data: { sCode: strUsername, sPassWord: strPwd },
        cache: false,
        success: function (data) {
            if (data == "1") {
                window.location.href = "Default.htm?random=" + Math.random();

            }
            else {
                alert("您输入的用户名或密码错误")
            }
        },
        error: function (xhr) {
            alert("出现错误，请稍后再试" + xhr.responseText);
        }
    });
}

$(function () {
    ReadCookies(false);
})

function ReadCookies(isAsync) {
    $.ajax(
    {
        url: "Handler/Login.ashx",
        type: "post",
        cache: false,
        async: isAsync,
        data: { otype: "ReadCookies" },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.messager.alert("错误", textStatus);
            EndLoad();
        },
        success: function (data) {
            $("#TxtUserName").val("" + data + "");
        }
    });
}