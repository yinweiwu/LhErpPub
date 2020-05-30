<%@ WebHandler Language="C#" Class="imageHandler" %>

using System;
using System.Web;
using sysBaseBll;
public class imageHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/binary;";
        string sDbStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
        string tablename = context.Request.Params["tablename"] == null ? "" : context.Request.Params["tablename"].ToString();
        string irecno = context.Request.Params["irecno"] == null ? "" : context.Request.Params["irecno"].ToString();
        string imageid = context.Request.Params["imageid"] == null ? "" : context.Request.Params["imageid"].ToString();
        bool isThum = context.Request.Params["isThum"] == null ? true : (context.Request.Params["isThum"].ToString() == "0" ? false : true);
        imageHelper imagehelper = new imageHelper(sDbStr);
        try
        {
            byte[] img = imagehelper.getImage(iformid, tablename, irecno, imageid,isThum);
            context.Response.BinaryWrite(img);
            //context.Response.Flush();
            //context.Response.End();  
        }
        catch
        {
            
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}