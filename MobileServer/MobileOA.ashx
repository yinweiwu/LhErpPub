<%@ WebHandler Language="C#" Class="MobileOAHandler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Text;
using System.IO;

public class MobileOAHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "AddWordTask")
        {
            requestResult result = new requestResult();
            string sContent = context.Request.Params["sContent"] == null ? "" : context.Request.Params["sContent"].ToString();
            string sReceiveUsers = context.Request.Params["sReceiveUsers"] == null ? "" : context.Request.Params["sReceiveUsers"].ToString();
            string dExpireDate = context.Request.Params["dExpireDate"] == null ? "" : context.Request.Params["dExpireDate"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.AddWorkTask(sContent, sReceiveUsers, dExpireDate, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "EditWorkTask")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sContent = context.Request.Params["sContent"] == null ? "" : context.Request.Params["sContent"].ToString();
            string sReceiveUsers = context.Request.Params["sReceiveUsers"] == null ? "" : context.Request.Params["sReceiveUsers"].ToString();
            string dExpireDate = context.Request.Params["dExpireDate"] == null ? "" : context.Request.Params["dExpireDate"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.EditWorkTask(iRecNo, sContent, sReceiveUsers, dExpireDate);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "SetWorkTaskFinish")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sRealWorks = context.Request.Params["sRealWorks"] == null ? "" : context.Request.Params["sRealWorks"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.SetWorkTaskFinish(iRecNo, sRealWorks);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "SetWorkTaskNotFinish")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sReason = context.Request.Params["sReason"] == null ? "" : context.Request.Params["sReason"].ToString();
            string dExpireDate = context.Request.Params["dExpireDate"] == null ? "" : context.Request.Params["dExpireDate"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.SetWorkTaskNotFinish(iRecNo, dExpireDate, sReason);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeleteWorkTask")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNoStr"] == null ? "0" : context.Request.Params["iRecNoStr"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.DeleteWorkTask(iRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeleteWorkTaskM")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.DeleteWorkTaskM(iRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddWeekPlan")
        {
            requestResult result = new requestResult();
            string sContent = context.Request.Params["sContent"] == null ? "" : context.Request.Params["sContent"].ToString();
            string dPlanDate = context.Request.Params["dPlanDate"] == null ? "" : context.Request.Params["dPlanDate"].ToString();
            string sNeedHelp = context.Request.Params["sNeedHelp"] == null ? "" : context.Request.Params["sNeedHelp"].ToString();
            string iProjectRecNo = context.Request.Params["iProjectRecNo"] == null ? "" : context.Request.Params["iProjectRecNo"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.AddWeekPlan(sContent, dPlanDate, sNeedHelp, userid, iProjectRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddWeekPlanM")
        {
            requestResult result = new requestResult();
            string iWeek = context.Request.Params["iWeek"] == null ? "" : context.Request.Params["iWeek"].ToString();
            string dStartDate = context.Request.Params["dStartDate"] == null ? "" : context.Request.Params["dStartDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetailStr = context.Request.Params["sDetailStr"] == null ? "" : context.Request.Params["sDetailStr"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.AddWeekPlanM(iWeek, dStartDate, dEndDate, sRemark, userid, sDetailStr);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "EditWeekPlan")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sContent = context.Request.Params["sContent"] == null ? "" : context.Request.Params["sContent"].ToString();
            string dPlanDate = context.Request.Params["dPlanDate"] == null ? "" : context.Request.Params["dPlanDate"].ToString();
            string sNeedHelp = context.Request.Params["sNeedHelp"] == null ? "" : context.Request.Params["sNeedHelp"].ToString();
            string iProjectRecNo = context.Request.Params["iProjectRecNo"] == null ? "" : context.Request.Params["iProjectRecNo"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.EditWeekPlan(iRecNo, sContent, dPlanDate, sNeedHelp, iProjectRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "EditWeekPlanM")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string iWeek = context.Request.Params["iWeek"] == null ? "" : context.Request.Params["iWeek"].ToString();
            string dStartDate = context.Request.Params["dStartDate"] == null ? "" : context.Request.Params["dStartDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetailStr = context.Request.Params["sDetailStr"] == null ? "" : context.Request.Params["sDetailStr"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.EditWeekPlanM(iRecNo, iWeek, dStartDate, dEndDate, sRemark, userid, sDetailStr);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "SubmitWeekPlanM")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();           
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.SubmitWeekPlanM(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "SubmitCancelWeekPlanM")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();

            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.SubmitCancelWeekPlanM(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWorkTaskOfReceive")
        {
            requestTablesResult result = new requestTablesResult();
            string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWorkTaskOfReceive(sReceiveUserID);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWorkTask")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWorkTask(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWeekPlan")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWeekPlan(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWeekPlanM")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWeekPlanM(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWeekPlanD")
        {
            requestTablesResult result = new requestTablesResult();
            string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "" : context.Request.Params["iMainRecNo"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWeekPlanD(iMainRecNo);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetWeekPlanChecked")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetWeekPlanChecked(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddLeave")
        {
            requestResult result = new requestResult();
            string sCode = context.Request.Params["sCode"] == null ? "" : context.Request.Params["sCode"].ToString();
            string sType = context.Request.Params["sType"] == null ? "" : context.Request.Params["sType"].ToString();
            string dBeginDate = context.Request.Params["dBeginDate"] == null ? "" : context.Request.Params["dBeginDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string sDate = context.Request.Params["sDate"] == null ? "" : context.Request.Params["sDate"].ToString();
            string sCause = context.Request.Params["sCause"] == null ? "" : context.Request.Params["sCause"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.AddLeave(sCode, sType, dBeginDate, dEndDate, sDate, sCause, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "EditLeave")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sCode = context.Request.Params["sCode"] == null ? "" : context.Request.Params["sCode"].ToString();
            string sType = context.Request.Params["sType"] == null ? "" : context.Request.Params["sType"].ToString();
            string dBeginDate = context.Request.Params["dBeginDate"] == null ? "" : context.Request.Params["dBeginDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string sDate = context.Request.Params["sDate"] == null ? "" : context.Request.Params["sDate"].ToString();
            string sCause = context.Request.Params["sCause"] == null ? "" : context.Request.Params["sCause"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.EditLeave(iRecNo, sCode, sType, dBeginDate, dEndDate, sDate, sCause);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeleteLeave")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNoStr"] == null ? "0" : context.Request.Params["iRecNoStr"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.DeleteLeave(iRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetLeave")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetLeave(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetLeaveType")
        {
            requestTablesResult result = new requestTablesResult();
            //string sReceiveUserID = context.Request.Params["sReceiveUserID"] == null ? "" : context.Request.Params["sReceiveUserID"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetLeaveType();
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddProject")
        {
            requestResult result = new requestResult();
            string sProjectName = context.Request.Params["sProjectName"] == null ? "" : context.Request.Params["sProjectName"].ToString();
            string sWeek = context.Request.Params["sWeek"] == null ? "" : context.Request.Params["sWeek"].ToString();
            string dBeginDate = context.Request.Params["dBeginDate"] == null ? "" : context.Request.Params["dBeginDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string fFinishPercent = context.Request.Params["fFinishPercent"] == null ? "" : context.Request.Params["fFinishPercent"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                int iRecNo = ma.AddProject(sProjectName, sWeek, dBeginDate, dEndDate, fFinishPercent, userid);
                result.success = true;
                result.message = iRecNo.ToString();
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddProjectFile")
        {
            requestResult result = new requestResult();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.AddProjectFile(context);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "EditProject")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sProjectName = context.Request.Params["sProjectName"] == null ? "" : context.Request.Params["sProjectName"].ToString();
            string sWeek = context.Request.Params["sWeek"] == null ? "" : context.Request.Params["sWeek"].ToString();
            string dBeginDate = context.Request.Params["dBeginDate"] == null ? "" : context.Request.Params["dBeginDate"].ToString();
            string dEndDate = context.Request.Params["dEndDate"] == null ? "" : context.Request.Params["dEndDate"].ToString();
            string fFinishPercent = context.Request.Params["fFinishPercent"] == null ? "" : context.Request.Params["fFinishPercent"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.EditProject(iRecNo, sProjectName, sWeek, dBeginDate, dEndDate, fFinishPercent);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeleteProject")
        {
            requestResult result = new requestResult();
            string iRecNo = context.Request.Params["iRecNoStr"] == null ? "0" : context.Request.Params["iRecNoStr"].ToString();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                ma.DeleteProject(iRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetProject")
        {
            requestTablesResult result = new requestTablesResult();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetProject(userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }



        else if (otype == "GetAllPerson")
        {
            requestTablesResult result = new requestTablesResult();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetAllPerson();
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetProjectName")
        {
            requestTablesResult result = new requestTablesResult();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetProjectName();
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getProjectShowName")
        {
            requestTablesResult result = new requestTablesResult();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetProjectName();
                result.tables.Add(table);
                result.success = true;
                //result.message = sProjectName;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getProjectList")
        {
            requestTablesResult result = new requestTablesResult();
            MobileReport mf = new MobileReport(sConnStr);
            string sFilters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            try
            {
                DataTable table = mf.GetProjectList(userid, sFilters);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetFormFile")
        {
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string sTableName = context.Request.Params["sTableName"] == null ? "" : context.Request.Params["sTableName"].ToString();
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            MobileOA ma = new MobileOA(sConnStr);
            try
            {
                DataTable table = ma.GetFormFile(iFormID, sTableName, iRecNo);
                result.tables.Add(table);
                result.success = true;
                //result.message = sProjectName;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
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