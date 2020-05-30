<%@ WebHandler Language="C#" Class="FSysMainMenu1" %>
using System;
using System.Web;
using System.Data;
using System.Collections.Generic;

public class FSysMainMenu1 : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string command = context.Request.Params["Command"];
        if (command == "getMainMenu")
        { 
            List<StoreParm> sparms = new List<StoreParm>();
            sparms.Add(new StoreParm("@userid", "input", 50, context.User.Identity.Name));
            if (context.Request.Params["parentMenuID"] != null && context.Request.Params["parentMenuID"].ToString()!="-1")
            {
                sparms.Add(new StoreParm("@parnetMenuID", "input", context.Request.Params["parentMenuID"].ToString()));
            }            
            SqlStoreProcQuery ssq = new SqlStoreProcQuery();
            ssq.StoreParms = sparms;
            ssq.StoreProName = "GetUserMainMenu";
            try
            {
                DataTable table = ssq.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string jsonstr = JsonHelper.ToJsonNoRows(table);
                context.Response.Write(jsonstr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}