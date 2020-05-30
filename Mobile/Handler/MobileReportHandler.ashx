<%@ WebHandler Language="C#" Class="MobileReportHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
public class MobileReportHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        if (otype == "GetReportMenu")
        {
            requestTablesResult result = new requestTablesResult();
            string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable menuData = mf.GetReportMenu(HttpContext.Current.User.Identity.Name, parentMenuID,false);
                result.success = true;
                result.tables.Add(menuData);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetReportInfo")
        {
            requestResult result = new requestResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tableBill = mf.GetReportInfo(iMenuID, HttpContext.Current.User.Identity.Name);
                StringBuilder str = new StringBuilder();
                str.Append("{");
                str.Append("\"pPageCount\":\""+tableBill.Rows[0]["pPageCount"].ToString()+"\"");
                str.Append(",\"sBillType\":\"" + tableBill.Rows[0]["sBillType"].ToString() + "\"");
                str.Append(",\"iStore\":\"" + tableBill.Rows[0]["iStore"].ToString() + "\"");
                str.Append("}");
                result.success = true;
                result.message=str.ToString();
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }            
        else if (otype == "GetReportCondition") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tableCondition = mf.GetReportCondition(iMenuID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(tableCondition);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getReportStyle") 
        {
            requestResult result = new requestResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                string sStyle = mf.GetReportStyle(iMenuID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.message = sStyle;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getReportData")
        {
            //requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            string chooseCount = context.Request.Params["rows"] == null ? "30" : context.Request.Params["rows"].ToString();
            string skipCount = ((int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(chooseCount)).ToString();
            string sort = "";
            string sortname = context.Request.Params["sort"] == null ? "" : context.Request.Params["sort"].ToString();
            string sortorder = context.Request.Params["order"] == null ? "asc" : context.Request.Params["order"].ToString();
            bool isFirst = context.Request.Params["isFirst"] == null ? false : (context.Request.Params["isFirst"].ToString() == "1" ? true : false);
            if (sortname != "") {
                sort = sortname + " " + sortorder;
            }
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                List<DataTable> tables = mf.GetReportData(iMenuID, HttpContext.Current.User.Identity.Name, filters, int.Parse(chooseCount), int.Parse(skipCount), sort,isFirst,false);
                string backStr = "{\"rows\":" + JsonConvert.SerializeObject(tables[0]) + ",\"total\":\"" + tables[1].Rows[0][0].ToString() + "\"}";
                context.Response.Write(backStr);
            }
            catch (Exception ex)
            {
                //result.success = false;
                //result.message = ex.Message;
                context.Response.Write(ex.Message);
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetReportSort")
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();            
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tables = mf.GetReportSort(iMenuID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(tables);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetReportColumns") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetReportColumns(iMenuID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex) 
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetAssicateData") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetAssicateData(iMenuID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}