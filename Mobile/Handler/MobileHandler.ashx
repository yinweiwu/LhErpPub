<%@ WebHandler Language="C#" Class="MobileHandler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Collections.Generic;
using System.Text;
public class MobileHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        if (otype == "GetFormInfo")
        {
            requestResult result=new requestResult();
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            MobileForm mf = new MobileForm(sConnStr);
            try
            {
                DataTable billData = mf.GetFormInfo(iformid);
                result.success = true;
                StringBuilder jsonStr = new StringBuilder();
                jsonStr.Append("{");
                jsonStr.Append("\"title\":\"" + billData.Rows[0]["sBillType"].ToString() + "\",");
                jsonStr.Append("\"FieldKey\":\"" + billData.Rows[0]["sFieldKey"].ToString() + "\",");
                jsonStr.Append("\"sDetailTableName\":\"" + billData.Rows[0]["sDetailTableName"].ToString() + "\",");
                jsonStr.Append("\"sLinkField\":\"" + billData.Rows[0]["sLinkField"].ToString() + "\",");
                jsonStr.Append("\"sDeitailFieldKey\":\"" + billData.Rows[0]["sDeitailFieldKey"].ToString() + "\",");
                jsonStr.Append("\"sOpenFilters\":\"" + billData.Rows[0]["sOpenFilters"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name) + "\",");
                jsonStr.Append("\"PageUrl\":\"" + billData.Rows[0]["sDetailPage"].ToString() + "\",");
                jsonStr.Append("\"tableName\":\"" + billData.Rows[0]["sTableName"].ToString() + "\"");
                jsonStr.Append("}");
                //result.message = "{\"title\":\"" + billData.Rows[0]["sBillType"].ToString() + "\",\"FieldKey\":\"" + billData.Rows[0]["sFieldKey"].ToString() + "\"" +
                //",\"sDetailTableName\":\"" + billData.Rows[0]["sDetailTableName"].ToString() + "\",\"sLinkField\":\"" + billData.Rows[0]["sLinkField"].ToString() + "\"" +
                //",\"sDeitailFieldKey\":\"" + billData.Rows[0]["sDeitailFieldKey"].ToString() + "\",\"sOpenFilters\":\"" + billData.Rows[0]["sOpenFilters"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name) + "\"}";
                result.message = jsonStr.ToString();
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
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            int rows = context.Request.Params["rows"] == null ? 0 : int.Parse(context.Request.Params["rows"]);
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            bool isDetail = context.Request.Params["isDetail"] != null && context.Request.Params["isDetail"].ToString() == "1" ? true : false;
            MobileForm mf = new MobileForm(sConnStr);
            try
            {
                List<DataTable> dts = mf.GetFormListData(iformid, HttpContext.Current.User.Identity.Name, rows, filters, isDetail);
                result.success = true;
                result.tables = dts;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetFormDataStyle")
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestResult result = new requestResult();
            try
            {
                result = mf.GetFormListDataStyle(context, HttpContext.Current.User.Identity.Name);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetFormButton")
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
                DataTable table = mf.GetFormButton(iMenuID, HttpContext.Current.User.Identity.Name);
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
        else if (otype == "GetFormQuery")
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
                List<DataTable> tables = mf.GetFormQuery(iFormID, HttpContext.Current.User.Identity.Name);
                result.success = true;
                result.tables = tables;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetLookUpDefine")
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                string lookupname = context.Request.Params["lookUpName"] == null ? "" : context.Request.Params["lookUpName"].ToString();
                string targetID = context.Request.Params["targetID"] == null ? "" : context.Request.Params["targetID"].ToString();
                DataTable table = mf.GetLookUpDefine(lookupname, targetID);
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
        else if (otype == "GetLookUpCondition")
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                string lookupname = context.Request.Params["lookUpName"] == null ? "" : context.Request.Params["lookUpName"].ToString();
                DataTable table = mf.GetLookUpCondition(lookupname);
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
        else if (otype == "GetLookUpData") 
        {
            MobileForm mf = new MobileForm(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                string lookupname = context.Request.Params["lookUpName"] == null ? "" : context.Request.Params["lookUpName"].ToString();
                string rows = context.Request.Params["rows"] == null ? "0" : context.Request.Params["rows"].ToString();
                string pageSize = context.Request.Params["pageSize"] == null ? "30" : context.Request.Params["pageSize"].ToString();
                string filters = context.Request.Params["filters"] == null ? "1=1" : context.Request.Params["filters"].ToString();
                filters = filters == "" ? "1=1" : filters;
                List<DataTable> tables = mf.GetLookUpData(lookupname, HttpContext.Current.User.Identity.Name, rows, pageSize, filters);
                result.success = true;
                result.tables = tables;
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