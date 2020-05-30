<%@ WebHandler Language="C#" Class="MobileImageHandler" %>

using System;
using System.Web;
using sysBaseBll;

public class MobileImageHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);        
        context.Response.ContentType = "application/binary;";
        //string sDbStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
        string tablename = context.Request.Params["tablename"] == null ? "" : context.Request.Params["tablename"].ToString();
        string irecno = context.Request.Params["irecno"] == null ? "" : context.Request.Params["irecno"].ToString();
        string imageid = context.Request.Params["imageid"] == null ? "" : context.Request.Params["imageid"].ToString();
        bool isThum = context.Request.Params["isThum"] == null ? true : (context.Request.Params["isThum"].ToString() == "0" ? false : true);
        imageHelper imagehelper = new imageHelper(sConnStr);
        try
        {
            byte[] img = imagehelper.getImage(iformid, tablename, irecno, imageid, isThum);
            context.Response.BinaryWrite(img);
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