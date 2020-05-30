<%@ WebHandler Language="C#" Class="LoginOut" %>

using System;
using System.Web;
using sysBaseDAL.common;
public class LoginOut : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
        sqlhelper.commExec("IF EXISTS(SELECT * FROM sysobjects WHERE id=object_id('SysLogs') AND OBJECTPROPERTY(id,'IsUserTable') = 1)begin insert into SysLogs(iType,sUserID,dDateTime,sIP) values (2,'" + HttpContext.Current.User.Identity.Name + "',getdate(),'" + HttpContext.Current.Request.UserHostAddress + "') end ");
        
        
        System.Web.Security.FormsAuthentication.SignOut();
        HttpCookie aCookie;
        string cookieName;
        int limit = HttpContext.Current.Request.Cookies.Count;
        for (int i = 0; i < limit; i++)
        {
            cookieName = HttpContext.Current.Request.Cookies[i].Name;
            if (cookieName != "LastUser" && cookieName != "rememberMobileUserid")
            {
                aCookie = new HttpCookie(cookieName);
                aCookie.Expires = DateTime.Now.AddDays(-1);//设置Cookie过期   
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("login.html");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}