<%@ WebHandler Language="C#" Class="LoginOut" %>

using System;
using System.Web;

public class LoginOut : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        System.Web.Security.FormsAuthentication.SignOut();
        HttpCookie aCookie;
        string cookieName;
        int limit = HttpContext.Current.Request.Cookies.Count;
        for (int i = 0; i < limit; i++)
        {
            cookieName = HttpContext.Current.Request.Cookies[i].Name;
            if (cookieName != "LastUser")
            {
                aCookie = new HttpCookie(cookieName);
                aCookie.Expires = DateTime.Now.AddDays(-1);//设置Cookie过期   
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("loginMobile.htm");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}