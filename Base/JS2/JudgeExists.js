//是否存在指定函数 
function IsExitsFunction(funcName) {
    try {
        if (typeof (eval(funcName)) == "function") {
            return true;
        }
    } catch (e) { }
    return false;
}
//是否存在指定变量 
function IsExitsVariable(variableName) {
    try {
        //var aa= typeof (lookUp);
        if (typeof (variableName) == "undefined") {
            //alert("value is undefined"); 
            return false;
        } else {
            //alert("value is true"); 
            return true;
        }
    } catch (e) { }
    return false;
}