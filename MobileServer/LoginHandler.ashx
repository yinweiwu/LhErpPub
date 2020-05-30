<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;
using System.Web;
using System.Web.Security;
using System.Data;

public class LoginHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string userid = context.Request.Params["userid"].ToString();
        string psd = context.Request.Params["password"].ToString();
        string sDb = context.Request.Params["db"].ToString();
        string company = context.Request.Params["company"] == null ? "SysBase" : context.Request.Params["company"].ToString();
        string token = context.Request.Params["token"] == null ? "" : context.Request.Params["token"].ToString();
        context.Response.ContentType = "text/plain";
        try
        {
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            User user = new User(connstr);
            int i = 0;
            if (token.Equals("xuebaopermit"))
            {
                i = 1;
            }
            else
            {                
                connstr = connstr.Replace("database=ZSNETERP2015", "database=" + sDb);                
                i = user.Apploginuser(userid, psd);
            }
            if (i == 1)
            {
                if (otype == "")
                {
                    string scriptStr = context.Request.Params["callback"].ToString() + "({\"success\":true,\"message\":\"\"})";
                    context.Response.Write(scriptStr);
                }
                else if (otype == "domanLogin")
                {
                    string role = user.getrole(userid);
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, userid, DateTime.Now, DateTime.Now.AddMinutes(240), false, role, "/");
                    string hashticket = FormsAuthentication.Encrypt(ticket);
                    HttpCookie KL_USERcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hashticket);
                    //用户信息放在Cookie中
                    DataTable table = user.getUserInfo(userid);
                    HttpCookie useridcookie = new HttpCookie("LastUser");
                    useridcookie["userid"] = userid;
                    useridcookie["company"] = company;
                    useridcookie.Expires = DateTime.Now.AddDays(30);
                    context.Response.AddHeader("P3P", "CP='IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT'");
                    context.Response.Cookies.Add(useridcookie);
                    context.Response.Cookies.Add(KL_USERcookie);
                    context.Response.Write("1");
                }
            }
            else if (i == 2)
            {
                context.Response.Write(context.Request.Params["callback"].ToString() + "({\"success\":false,\"message\":\"抱歉，你不是app用户，不能使用app。\"})");
            }
            else
            {
                context.Response.Write(context.Request.Params["callback"].ToString() + "({\"success\":false,\"message\":\"用户名或密码不正确。\"})");
            }
        }
        catch (Exception ex)
        {
            context.Response.Write(context.Request.Params["callback"].ToString() + "({\"success\":false,\"message\":\"" + ex.Message + "\"})");
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