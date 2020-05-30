<%@ WebHandler Language="C#" Class="DataGridToExcel" %>

using System;
using System.Web;
using System.IO;
using System.Text;

public class DataGridToExcel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
        
        string title = context.Request.Params["title"] == null ? "" : context.Request.Params["title"].ToString();
        try
        {
            DirectoryInfo path = new System.IO.DirectoryInfo(context.Server.MapPath("/ExcelTmp"));
            deletefile(path);
        }
        catch
        { 
            
        }
        if (!Directory.Exists(context.Server.MapPath("/ExcelTmp")))
        {
            Directory.CreateDirectory(context.Server.MapPath("/ExcelTmp")); 
        }
        string fn = title +"_"+ DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".xls";
        string data = context.Request.Form["data"];
        File.WriteAllText(context.Server.MapPath("/ExcelTmp/"+fn), data, Encoding.UTF8);//如果是gb2312的xml申明，第三个编码参数修改为Encoding.GetEncoding(936)
        context.Response.Write("/ExcelTmp/"+fn);//返回文件名提供下载
    }

    private void deletefile(DirectoryInfo path)
    {
        foreach (DirectoryInfo d in path.GetDirectories())
        {
            deletefile(d);
        }
        foreach (FileInfo f in path.GetFiles())
        {
            var ex = f.Extension;
            if (ex.ToLower() == ".xls")
            {
                DateTime ct = f.CreationTime;
                TimeSpan ts = DateTime.Now - ct;
                if (ts.Days > 0 || ts.Hours > 0 || ts.Minutes > 10)
                {
                    f.Delete();
                }
            }
        }
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}