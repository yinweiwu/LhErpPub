<%@ WebHandler Language="C#" Class="UploadHandler" %>

using System;
using System.Web;
using System.IO;

public class UploadHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Charset = "utf-8";
        string irecno = context.Request.Params["irecno"].ToString();
        string tablename = context.Request.Params["tablename"].ToString();

        HttpPostedFile file = context.Request.Files["Filedata"];
        string uploadPath = HttpContext.Current.Server.MapPath("//BaseData//MaterialPic//");
        try
        {
            if (file != null)
            {
                string guid = System.Guid.NewGuid().ToString();
                if (!Directory.Exists(uploadPath))
                {
                    Directory.CreateDirectory(uploadPath);
                }
                if (!File.Exists(uploadPath + guid + file.FileName))
                {
                    file.SaveAs(uploadPath + tablename + irecno + "_" + file.FileName);
                }
                context.Response.Write(tablename + irecno + "_" + file.FileName);
            }
            else
            {
                context.Response.Write("error:没有文件！");
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("error:" + ex.Message);
        }  
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}