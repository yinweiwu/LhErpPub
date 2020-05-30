
function OpenPort() {
    if (MSComm1.PortOpen == false) {
        MSComm1.PortOpen = true;
    }
    else {
        window.alert("已经开始接收数据!");
    }
}


function ClosePort() {
    if (MSComm1.PortOpen == true) {
        MSComm1.PortOpen = false;
    }
    else {
        window.alert("串口已经关闭!");
    }
}


function String.prototype.stringToArray()     //串转为数组   
{
    var ar = new Array()
    for (var i = 0; i < this.length; i++)
        ar[i] = this.charCodeAt(i);
    return ar;
}

function Array.prototype.arrayToStringtring()   //数组转为传   
{
    var str = "";
    for (var i = 0; i < this.length; i++)
        str += String.fromCharCode(this[i]);
    return str;
}
function Array.prototype.or(ar)     //数组或操作   
{
    var l = ar.length;
    var result = new Array();
    if (ar.length > this.length) l = this.length;
    for (var i = 0; i < l; i++)
        result[i] = this[i] | ar[i];
    return result;
}

function Array.prototype.and(ar)   //数组与操作   
{
    var l = ar.length;
    var result = new Array();
    if (ar.length > this.length) l = this.length;
    for (var i = 0; i < l; i++)
        result[i] = this[i] & ar[i];
    return result;
}