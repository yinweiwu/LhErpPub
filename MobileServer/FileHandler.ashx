<%@ WebHandler Language="C#" Class="FileHandler" %>

using System;
using System.Web;
using System.IO;
public class FileHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            HttpPostedFile httpPostedFile = context.Request.Files[0];
            string fileall = "\\Base\\imageUpload\\images\\" + DateTime.Now.ToString("yyyy-MM") + "\\";
            if (Directory.Exists(context.Request.MapPath(fileall)) == false)//如果不存在就创建file文件夹
            {
                Directory.CreateDirectory(context.Request.MapPath(fileall));
            }
            string datastring = context.Request.Form["senddate"];
            string irecno = context.Request.Form["irecno"] == null ? "" : context.Request.Form["irecno"].ToString();    //文件名是：" + iformid + "_" + tablename + "_" + irecno + "_" + imageid + "_" + fileNameFull
            string iformid = context.Request.Form["iformid"] == null ? "" : context.Request.Form["iformid"].ToString();
            string tablename = context.Request.Form["tablename"] == null ? "" : context.Request.Form["tablename"].ToString();
            string imageid = context.Request.Form["imageid"] == null ? iformid + "_1" : context.Request.Form["imageid"].ToString();
            string fileNameFull = datastring + "_" + httpPostedFile.FileName;
            string path = fileall + iformid + "_" + tablename + "_" + irecno + "_" + imageid + "_" + fileNameFull;
            string realfilepath = context.Request.MapPath(path);
            httpPostedFile.SaveAs(realfilepath);
            context.Response.Write("1");
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}