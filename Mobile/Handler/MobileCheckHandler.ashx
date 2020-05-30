<%@ WebHandler Language="C#" Class="MobileCheckHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
using sysBaseApproval;

public class MobileCheckHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        if (otype == "GetNoCheckList")
        {
            requestTablesResult result = new requestTablesResult();
            //string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            //string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                DataTable noCheckData = mf.GetNoCheckList(HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(noCheckData);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetNoCheckCount")
        {
            requestResult result = new requestResult();
            //string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            //string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                int count = mf.GetNoCheckCount(HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.message = count.ToString();
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetCheckedList")
        {
            requestTablesResult result = new requestTablesResult();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string chooseCount = context.Request.Params["chooseCount"] == null ? "" : context.Request.Params["chooseCount"].ToString();
            string skipCount = context.Request.Params["skipCount"] == null ? "" : context.Request.Params["skipCount"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                List<DataTable> checkedData = mf.GetCheckedList(HttpContext.Current.User.Identity.Name, chooseCount, skipCount);
                result.success = true;
                result.tables = checkedData;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetFormColumn")
        {
            requestTablesResult result = new requestTablesResult();
            //string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                DataTable dataColumns = mf.GetFormFields(iFormID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(dataColumns);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetFormData")
        {
            requestTablesResult result = new requestTablesResult();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                List<DataTable> tableData = mf.GetFormData(iFormID, iRecNo, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables = tableData;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetCheckOpinion")
        {
            requestTablesResult result = new requestTablesResult();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            MobileCheck mf = new MobileCheck(sConnStr);
            try
            {
                DataTable tableData = mf.GetCheckOpinion(iFormID, iRecNo, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables.Add(tableData);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
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