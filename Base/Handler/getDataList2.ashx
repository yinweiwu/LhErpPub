<%@ WebHandler Language="C#" Class="getDataList2" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Text;
using sysBaseExplain;

public class getDataList2 : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        tableExplain tableEp = new tableExplain(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
        try
        {
            string str= tableEp.GetData(context);
            context.Response.Write(str);
        }
        catch(Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}