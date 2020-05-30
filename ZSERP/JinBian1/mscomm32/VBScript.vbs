' VBScript 文件

function   bytes2BSTR(vIn)   
    dim strReturn,i,ThisCharCode,innerCode,Hight8,Low8,NextCharCode   
    strReturn=""   
    for   i=1   to   LenB(vIn)   
        ThisCharCode=AscB(MidB(vIn,i,1))   
        if   ThisCharCode<&H80   Then   
            strReturn=strReturn   &   Chr(ThisCharCode)   
        else   
        NextCharCode=AscB(MidB(vIn,i+1,1))   
        strReturn=strReturn&Chr(CLng(ThisCharCode)*&H100+CInt(NextCharCode))   
        i=i+1   
        end   if   
    next   
    bytes2BSTR=strReturn   
end   function   

