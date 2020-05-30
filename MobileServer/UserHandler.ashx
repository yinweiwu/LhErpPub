<%@ WebHandler Language="C#" Class="UserHandler" %>

using System;
using System.Web;
using System.Data;
using sysBaseDAL.common;
using sysBaseRequestResult;
using Newtonsoft.Json;
public class UserHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        //context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "getTodaySignIn")
        {
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            try
            {
                DataTable table = sqlhelper.getTableData("select * from MobileSign where sUserID='" + userid + "' and CONVERT(varchar(10), dSignDate, 23)=CONVERT(varchar(10), getdate(), 23)");
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
        else if (otype == "doSignIn")
        {
            string address = context.Request.Params["address"] == null ? "" : context.Request.Params["address"].ToString();
            string platform = context.Request.Params["platform"] == null ? "" : context.Request.Params["platform"].ToString();
            string iBscDataCustomerRecNo = context.Request.Params["iBscDataCustomerRecNo"] == null ? "" : context.Request.Params["iBscDataCustomerRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            requestResult result = new requestResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);

            string realadress = address.Split(',')[0].Split(':')[1].Replace("\"", "");
            try
            {
                sqlhelper.commExec("insert into MobileSign(sUserID,dSignDate,sSignAdress,sSignPlatForm,iBscDataCustomerRecNo,sRemark) values ('" + userid + "',getdate(),'" + address + "','" + platform + "','" + iBscDataCustomerRecNo + "','" + sRemark + "') ");
                sqlhelper.commExec("declare @maxid int exec GetTableLsh 'BscDataCustomerVisit',@maxid output  insert into BscDataCustomerVisit(iRecNo,iMainRecNo,sUserID,dinputDate,dDate,sAdress,sContent,sPersonID,sSignPlatForm) values (@maxid,'" + iBscDataCustomerRecNo + "','" + userid + "',getdate(),getdate(),'" + realadress + "','" + sRemark + "','" + userid + "','" + platform + "') ");
                result.success = true;
                result.message = "1";
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "doSignIn2")
        {
            string address = context.Request.Params["address"] == null ? "" : context.Request.Params["address"].ToString();
            string platform = context.Request.Params["platform"] == null ? "" : context.Request.Params["platform"].ToString();
            string iBscDataCustomerRecNo = context.Request.Params["iBscDataCustomerRecNo"] == null ? "" : context.Request.Params["iBscDataCustomerRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string filename = context.Request.Params["filename"] == null ? "" : context.Request.Params["filename"].ToString();
            string datastring = context.Request.Params["senddate"] == null ? "" : context.Request.Params["senddate"].ToString();
            requestResult result = new requestResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);

            string realadress = address.Split(',')[0].Split(':')[1].Replace("\"", "");
            try
            {
                // string datastring = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();
                string sYearMonth = DateTime.Now.ToString("yyyy-MM");
                string realname = datastring + filename;
                sqlhelper.commExec("insert into MobileSign(sUserID,dSignDate,sSignAdress,sSignPlatForm,iBscDataCustomerRecNo,sRemark) values ('" + userid + "',getdate(),'" + address + "','" + platform + "','" + iBscDataCustomerRecNo + "','" + sRemark + "') ");

                string aa = sqlhelper.commExecAndReturn("declare @maxid int exec GetTableLsh 'BscDataCustomerVisit',@maxid output  insert into BscDataCustomerVisit(iRecNo,iMainRecNo,sUserID,dinputDate,dDate,sAdress,sContent,sPersonID,sSignPlatForm) values (@maxid,'" + iBscDataCustomerRecNo + "','" + userid + "',getdate(),getdate(),'" + realadress + "','" + sRemark + "','" + userid + "','" + platform + "') select @maxid").Rows[0][0].ToString();
                sqlhelper.commExec("insert into FileUplad(iFormID,sTableName,iTableRecNo,sYearMonth,sFileName,sUserID,dInputDate,sImageID) values ('5030','BscDataCustomerVisit','" + aa + "','" + sYearMonth + "','" + realname + "','" + userid + "',getdate(),'__ExtFile1') ");
                result.success = true;
                result.message = aa;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "doSignBack")
        {
            string ireno = context.Request.Params["ireno"] == null ? "" : context.Request.Params["ireno"].ToString();
            string backcontent = context.Request.Params["backcontent"] == null ? "" : context.Request.Params["backcontent"].ToString();
            requestResult result = new requestResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            try
            {
                sqlhelper.commExec("update BscDataCustomerVisit set sBackContent= '" + backcontent + "' where iRecno=" + ireno + "");
                result.success = true;
                result.message = "1";
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddCus2")
        {
            string sCustShortName = context.Request.Params["sCustShortName"] == null ? "" : context.Request.Params["sCustShortName"].ToString();
            string sCustName = context.Request.Params["sCustName"] == null ? "" : context.Request.Params["sCustName"].ToString();
            string sChnAddr = context.Request.Params["sChnAddr"] == null ? "" : context.Request.Params["sChnAddr"].ToString();
            string sTel = context.Request.Params["sTel"] == null ? "" : context.Request.Params["sTel"].ToString();
            string sFirstPerson = context.Request.Params["sFirstPerson"] == null ? "" : context.Request.Params["sFirstPerson"].ToString();
            requestResult result = new requestResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            try
            {
                sqlhelper.commExec("declare @maxid int,@Sbill varchar(20) exec GetTableLsh 'BscDataCustomer',@maxid output  create table #tmp(Sbill varchar(20)) insert into #tmp exec Yww_FormBillNoBulid '5030' set @Sbill=(select * from #tmp)  insert into BscDataCustomer(iRecNo,sCustID,sUserID,dInputDate,sType,iCustType,sCustShortName,sCustName,sChnAddr,sTel,sFirstPerson) values (@maxid,@Sbill,'" + userid + "',getdate(),'临时客户',0,'" + sCustShortName + "','" + sCustName + "','" + sChnAddr + "','" + sTel + "','" + sFirstPerson + "') drop table #tmp ");
                result.success = true;
                result.message = "1";
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddCus")
        {
            string sCustShortName = context.Request.Params["sCustShortName"] == null ? "" : context.Request.Params["sCustShortName"].ToString();
            string sCustName = context.Request.Params["sCustName"] == null ? "" : context.Request.Params["sCustName"].ToString();
            string sChnAddr = context.Request.Params["sChnAddr"] == null ? "" : context.Request.Params["sChnAddr"].ToString();
            string sTel = context.Request.Params["sTel"] == null ? "" : context.Request.Params["sTel"].ToString();
            string sFirstPerson = context.Request.Params["sFirstPerson"] == null ? "" : context.Request.Params["sFirstPerson"].ToString();
            requestResult result = new requestResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            try
            {
                string re = sqlhelper.commExecAndReturn("exec SpAddCusMobile '" + userid + "','" + sCustShortName + "', '" + sCustName + "','" + sChnAddr + "', '" + sTel + "','" + sFirstPerson + "' ").Rows[0][0].ToString();
                if (re == "1")
                {
                    result.success = true;
                    result.message = "1";
                }
                else
                {
                    result.success = false;
                    result.message = re;
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getNowTime")
        {
            context.Response.Write(context.Request.Params["callback"].ToString() + "({\"nowTime\":\"" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "\"})");
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