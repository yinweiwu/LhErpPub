<%@ WebHandler Language="C#" Class="PsdMd5" %>

using System;
using System.Web;
using sysBaseDAL;

public class PsdMd5 : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        if (otype == "")
        {
            string psd = context.Request.Params["psd"].ToString();
            User sqlhelper = new User(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            context.Response.Write(sqlhelper.getEncryptStr(psd));
        }
        else if(otype=="getPwdField")
        {
            string psdField = System.Configuration.ConfigurationManager.AppSettings["pwdField"].ToString();
            context.Response.Write(psdField);
        }
        else if (otype == "getAppUserCount")
        {
            User user = new User(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            int userCount = user.SysAppUserCount();
            context.Response.Write(userCount);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}