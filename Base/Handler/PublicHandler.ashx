<%@ WebHandler Language="C#" Class="PublicHandler" %>

using System;
using System.Web;
using System.Data;
using sysBaseDAL.common;
using System.Text;
using sysBaseChartExplain;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Web.SessionState;
using sysBaseMessage;
using sysBaseBll;
public class PublicHandler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string otype = context.Request.Params["otype"].ToString();
            sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            if (otype == "SysGroup")
            {
                string sGroupID = context.Request.Params["sGroupID"].ToString();
                string sGroupName = context.Request.Params["sGroupName"].ToString();
                string sUserID = context.Request.Params["sUserID"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "Yww_FSysGroup";
                ssp.StoreParms = new System.Collections.Generic.List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@groupid", sGroupID));
                ssp.StoreParms.Add(new StoreParm("@groupname", sGroupName));
                ssp.StoreParms.Add(new StoreParm("@userid", sUserID));
                if (context.Request.Params["isdelete"] != null && context.Request.Params["isdelete"].ToString() == "1")
                {
                    ssp.StoreParms.Add(new StoreParm("@isdelete", "1"));
                }
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                context.Response.Write(table.Rows[0][0].ToString());
            }
            else if (otype == "SysGroupUser")
            {
                string groupid = context.Request.Params["groupid"].ToString();
                string userids = context.Request.Params["userids"].ToString();
                string op = context.Request.Params["op"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "Yww_FSysGroupUser";
                ssp.StoreParms = new System.Collections.Generic.List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@groupid", groupid));
                ssp.StoreParms.Add(new StoreParm("@userids", userids));
                ssp.StoreParms.Add(new StoreParm("@op", op));
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                context.Response.Write(table.Rows[0][0].ToString());
            }
            else if (otype == "FormConfigCopy")
            {
                string sourceFormID = context.Request.Params["sourceFormID"] == null ? "" : context.Request.Params["sourceFormID"].ToString();
                string targetFormID = context.Request.Params["targetFormID"] == null ? "" : context.Request.Params["targetFormID"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "SpFormConfigCopy";
                ssp.StoreParms = new System.Collections.Generic.List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@iOldFormID", sourceFormID));
                ssp.StoreParms.Add(new StoreParm("@iNewFormID", targetFormID));
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                context.Response.Write(table.Rows[0][0].ToString());
            }
            else if (otype == "sendSMSBirthday")
            {
                try
                {
                    DataTable tableBir = sqlhelper.getTableData("select top 1 sBirthdayMessage from SMSDefault");
                    string content = tableBir.Rows.Count > 0 ? tableBir.Rows[0][0].ToString() : "";
                    if (content.Length > 0)
                    {
                        StringBuilder comm = new StringBuilder();
                        //comm.Append("select top 1 sBirthdayMessage from SMSDefault");
                        comm.Append("select sPhone from bscMemberShip as a where ISNULL(itype,0)=0 ");
                        comm.Append("and DATEDIFF(DAY,getdate(),cast(datepart(year,getdate()) as varchar(4))+'-'+cast(datepart(month,ISNULL(dBirtyday,'2099-12-31')) as varchar(2))+'-'+cast(datepart(day,ISNULL(dBirtyday,'2099-12-31')) as varchar(2)))<=3 ");
                        comm.Append("and DATEDIFF(DAY,getdate(),cast(datepart(year,getdate()) as varchar(4))+'-'+cast(datepart(month,ISNULL(dBirtyday,'2099-12-31')) as varchar(2))+'-'+cast(datepart(day,ISNULL(dBirtyday,'2099-12-31')) as varchar(2)))>=0 ");
                        comm.Append("and LEN(sPhone)=11 and ISNULL(dBirtyday,'2099-12-31')<>'2099-12-31' and not exists(select 1 from SMSSentPhoneBirthday as b where a.sPhone=b.sPhone and datepart(year,getdate())=b.iYear) ");
                        DataTable tablePhone = sqlhelper.getTableData(comm.ToString());
                        StringBuilder phone = new StringBuilder();
                        if (tablePhone.Rows.Count > 0)
                        {
                            for (int i = 0; i < tablePhone.Rows.Count; i++)
                            {
                                phone.Append(tablePhone.Rows[i]["sPhone"].ToString() + ",");
                            }
                        }
                        if (phone.Length > 0)
                        {
                            phone.Remove(phone.Length - 1, 1);
                            requestResult result = sendMSM(phone.ToString(), content);
                            if (result.success == true)
                            {
                                comm.Clear();
                                comm.Append("insert into SMSSentPhoneBirthday(sPhone,iYear)  ");
                                comm.Append("select sPhone,DATEPART(YEAR,GETDATE()) ");
                                comm.Append("from bscMemberShip as a ");
                                comm.Append("where ISNULL(itype,0)=0 ");
                                comm.Append("and DATEDIFF(DAY,getdate(),cast(datepart(year,getdate()) as varchar(4))+'-'+cast(datepart(month,ISNULL(dBirtyday,'2099-12-31')) as varchar(2))+'-'+cast(datepart(day,ISNULL(dBirtyday,'2099-12-31')) as varchar(2)))<=3 ");
                                comm.Append("and DATEDIFF(DAY,getdate(),cast(datepart(year,getdate()) as varchar(4))+'-'+cast(datepart(month,ISNULL(dBirtyday,'2099-12-31')) as varchar(2))+'-'+cast(datepart(day,ISNULL(dBirtyday,'2099-12-31')) as varchar(2)))>=0 ");
                                comm.Append("and LEN(sPhone)=11 and ISNULL(dBirtyday,'2099-12-31')<>'2099-12-31' and not exists(select 1 from SMSSentPhoneBirthday as b where a.sPhone=b.sPhone and datepart(year,getdate())=b.iYear) ");
                                sqlhelper.commExec(comm.ToString());
                            }
                        }
                    }
                }
                catch
                {

                }
            }
            else if (otype == "getTodo")
            {
                string hasChecked = context.Request.Params["hasChecked"] == null ? "" : context.Request.Params["hasChecked"].ToString();
                //string comm = "SpDeleteMessage '" + HttpContext.Current.User.Identity.Name + "' ";
                string comm = "";
                if (hasChecked == "1")//是否包含已审批完发送的消息
                {
                    comm += "select a.iRecNo,a.iFormid,a.sSendUserID,a.sReceiveUserid,a.sContent,a.dinputDate,b.sDetailPage,a.itype from SysMessage as a,bscDataBill as b where a.sReceiveUserid='" + HttpContext.Current.User.Identity.Name + "' and a.iRead=0 and a.iFormid=b.iFormID order by a.dinputDate desc";
                }
                else
                {
                    comm += "select a.iRecNo,a.iFormid,a.sSendUserID,a.sReceiveUserid,a.sContent,a.dinputDate,b.sDetailPage from SysMessage as a,bscDataBill as b where a.sReceiveUserid='" + HttpContext.Current.User.Identity.Name + "' and a.iRead=0 and isnull(a.itype,0)<>2 and a.iFormid=b.iFormID order by a.dinputDate desc";
                }
                DataTable table = sqlhelper.getTableData(comm);
                context.Response.Write(JsonConvert.SerializeObject(table));
            }
            else if (otype == "getRemind")
            {
                DataTable table = sqlhelper.getTableData("select iRecNo,sTypeName,sName,sQtySql,sTitle from SysWarningConfigM where iRecNo in (select iMainRecNo from SysWarningConfigD where UserID='" + HttpContext.Current.User.Identity.Name + "' )");
                StringBuilder stringCount = new StringBuilder();
                for (int i = 0; i < table.Rows.Count; i++)
                {
                    DataTable tableCount = sqlhelper.getTableData(table.Rows[i]["sQtySql"].ToString());
                    stringCount.Append(tableCount.Rows[0][0].ToString() + ",");
                }
                if (stringCount.Length > 0)
                {
                    stringCount.Remove(stringCount.Length - 1, 1);
                }

                string tableJquery = JsonHelper.ToJsonNoRows(table);
                string backStr = "{data:" + tableJquery + ",count:[" + stringCount + "]}";
                context.Response.Write(backStr);
            }
            else if (otype == "getCheckedMessage")
            {
                string oprate = context.Request.Params["oprate"] == null ? "" : context.Request.Params["oprate"].ToString();
                if (oprate == "")
                {
                    DataTable table = sqlhelper.commExecAndReturn("select iRecNo,sContent from SysMessage where sReceiveUserid='" + HttpContext.Current.User.Identity.Name + "' and itype=2 and iRead=0 order by dinputDate desc");
                    context.Response.Write(JsonConvert.SerializeObject(table));
                }
                else
                {
                    string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                    sqlhelper.commExec(" update SysMessage set iRead=1 where sReceiveUserid='" + HttpContext.Current.User.Identity.Name + "' and itype=2 and iRecNo='" + iRecNo + "'");
                }
            }
            else if (otype == "haveJob")
            {
                string dateStr = context.Request.Params["date"] == null ? "" : context.Request.Params["date"].ToString();
                DataTable table = sqlhelper.getTableData("select iFinish from bscDataMyJob where sDate='" + dateStr + "' and sUserID='" + HttpContext.Current.User.Identity.Name + "'");
                if (table.Rows.Count > 0)
                {
                    DataRow[] rows = table.Select("isnull(iFinish,0)=0");
                    if (rows.Length > 0)
                    {
                        context.Response.Write("1");
                    }
                    else
                    {
                        context.Response.Write("2");
                    }
                }
                else
                {
                    context.Response.Write("0");
                }
            }
            else if (otype == "getDateJob")
            {
                string dateStr = context.Request.Params["date"] == null ? "" : context.Request.Params["date"].ToString();
                DataTable table = sqlhelper.getTableData("select * from bscDataMyJob where sDate='" + dateStr + "' and sUserID='" + HttpContext.Current.User.Identity.Name + "'");
                context.Response.Write(JsonHelper.ToJsonNoRows(table));
            }
            else if (otype == "getTopDateJob")
            {
                string dateStr = context.Request.Params["date"] == null ? "" : context.Request.Params["date"].ToString();
                DataTable table = sqlhelper.getTableData("select top 1000 sDate,COUNT(*) as count,SUM(ISNULL(iFinish,0)) as total  from bscDataMyJob where sUserID='" + HttpContext.Current.User.Identity.Name + "'  group by sDate order by sDate asc ");
                context.Response.Write(JsonHelper.ToJsonNoRows(table));
            }
            else if (otype == "addDateJob")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                string dateStr = context.Request.Params["date"] == null ? "" : context.Request.Params["date"].ToString();
                string iSerial = context.Request.Params["iSerial"] == null ? "" : context.Request.Params["iSerial"].ToString();
                sqlhelper.commExec("insert into bscDataMyJob (iRecNo,sDate,iSerial,sUserID,dInputTime) values ('" + iRecNo + "','" + dateStr + "','" + iSerial + "','" + HttpContext.Current.User.Identity.Name + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')");
                context.Response.Write("1");
            }
            else if (otype == "updateDateJob")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                string iSerial = context.Request.Params["iSerial"] == null ? "null" : "'" + context.Request.Params["iSerial"].ToString() + "'";
                string sDate = context.Request.Params["sDate"] == null ? "null" : "'" + context.Request.Params["sDate"].ToString() + "'";
                string dTime = context.Request.Params["dTime"] == null ? "null" : "'" + context.Request.Params["dTime"].ToString() + "'";
                string sContent = context.Request.Params["sContent"] == null ? "null" : "'" + context.Request.Params["sContent"].ToString() + "'";
                string iFinish = context.Request.Params["iFinish"] == null ? "null" : "'" + context.Request.Params["iFinish"].ToString() + "'";
                sqlhelper.commExec("update bscDataMyJob set iSerial=" + iSerial + ",sDate=" + sDate + ",dTime=" + dTime + ",sContent=" + sContent + ",iFinish=" + iFinish + " where iRecNo='" + iRecNo + "'");
                context.Response.Write("1");
            }
            else if (otype == "jobFinish")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                string iFinish = context.Request.Params["iFinish"] == null ? "" : context.Request.Params["iFinish"].ToString();
                sqlhelper.commExec("update bscDataMyJob set iFinish='" + iFinish + "' where iRecNo='" + iRecNo + "'");
                context.Response.Write("1");
            }
            else if (otype == "deleteJobs")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                sqlhelper.commExec("delete from bscDataMyJob where iRecNo in (" + iRecNo + ")");
                context.Response.Write("1");
            }
            else if (otype == "getLinkData")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                if (iRecNo == "")
                {
                    DataTable table = sqlhelper.getTableData("select a.*,b.sMenuName from bscDataShortcut as a left join FSysMainMenu as b on a.iMenuID=b.iMenuID where a.sUserID='" + HttpContext.Current.User.Identity.Name + "' order by a.iSerial asc ");
                    context.Response.Write(JsonHelper.ToJsonNoRows(table));
                }
                else
                {
                    DataTable table = sqlhelper.getTableData("select a.*,b.sMenuName from bscDataShortcut as a left join FSysMainMenu as b on a.iMenuID=b.iMenuID where a.sUserID='" + HttpContext.Current.User.Identity.Name + "' and iRecNo='" + iRecNo + "'");
                    context.Response.Write(JsonHelper.ToJsonNoRows(table));
                }
            }
            else if (otype == "deleteLinkData")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                sqlhelper.commExec("delete from bscDataShortcut where iRecNo in(" + iRecNo + ")");
                context.Response.Write("1");
            }
            else if (otype == "modlistData")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                string iSerial = context.Request.Params["iSerial"] == null ? "" : "'" + context.Request.Params["iSerial"].ToString() + "'";
                string sLinkName = context.Request.Params["sLinkName"] == null ? "" : "'" + context.Request.Params["sLinkName"].ToString() + "'";
                string iMenuID = context.Request.Params["iMenuID"] == null ? "" : "'" + context.Request.Params["iMenuID"].ToString() + "'";
                StringBuilder comm = new StringBuilder();
                comm.Append(" if exists(select 1 from bscDataShortcut where iRecNo=" + iRecNo + ") begin update bscDataShortcut set iSerial=" + iSerial + ",sLinkName=" + sLinkName + ",iMenuID=" + iMenuID + ",sUserID='" + HttpContext.Current.User.Identity.Name + "',dInputTime='" + DateTime.Now.ToShortDateString() + "' where iRecNo=" + iRecNo + " ");
                comm.Append(" end else begin ");
                comm.Append(" insert into bscDataShortcut (iRecNo,iSerial,sLinkName,iMenuID,sUserid,dInputTime) values (" + iRecNo + "," + iSerial + "," + sLinkName + "," + iMenuID + ",'" + HttpContext.Current.User.Identity.Name + "','" + DateTime.Now.ToString() + "') end");
                sqlhelper.commExec(comm.ToString());
                context.Response.Write("1");
            }
            else if (otype == "getLinkBtn")
            {
                DataSet ds = sqlhelper.getTablesData("select isnull(iHiddenShotcut,0) as iHiddenShotcut from SysParam select a.iMenuID,b.sMenuName from bscDataShortcut as a left join FSysMainMenu as b on a.iMenuID=b.iMenuID where a.sUserID='" + HttpContext.Current.User.Identity.Name + "' order by a.iSerial asc ");
                requestTablesResult result = new requestTablesResult();
                result.success = true;
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0][0].ToString() == "1")
                    {
                        result.message = "0";//message为0表示不显示快捷入口
                    }
                    else
                    {
                        result.message = "1";//message为1表示显示快捷入口
                    }
                }
                else
                {
                    result.message = "1";
                }
                result.tables.Add(ds.Tables[1]);
                context.Response.Write(JsonConvert.SerializeObject(result));
                //context.Response.Write(JsonHelper.ToJsonNoRows(table));
            }
            else if (otype == "getMenuInfo")
            {
                string iMenuID = context.Request.Params["iMenuID"] == null ? "" : "'" + context.Request.Params["iMenuID"].ToString() + "'";
                DataTable table = sqlhelper.getTableData("select * from View_Yww_FSysMainMenu where iMenuID=" + iMenuID + " ");
                context.Response.Write(JsonHelper.ToJsonNoRows(table));
            }
            else if (otype == "getChart")
            {
                string parentElementID = context.Request.Params["pid"] == null ? "" : context.Request.Params["pid"].ToString();
                chartExplain chartExp = new chartExplain(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                requestResult result = chartExp.doExplain(HttpContext.Current.User.Identity.Name, parentElementID);
                context.Response.Write(JsonHelper.JsonSerialize<requestResult>(result));
            }
            else if (otype == "getNotice")
            {
                string commStr = "select iRecNo,sTitle,iSerial,dInputDate from bscDataNotice where isnull(sDepartMent,'')='' and isnull(dExpTime,'2299-12-31')>getdate() and isnull(iHidden,0)=0 union select iRecNo,sTitle,iSerial,dInputDate from bscDataNotice where isnull(sDepartMent,'')<>'' and isnull(dExpTime,'2299-12-31')>getdate() and ','+sDepartMent+',' like '%,'+(select sClassID from bscDataPerson where sCode='" + HttpContext.Current.User.Identity.Name + "')+',%'";
                DataTable table = sqlhelper.getTableData(commStr);
                DataTable dtCopy = table.Copy();
                DataView dv = table.DefaultView;
                dv.Sort = "iSerial desc,dInputDate desc";
                dtCopy = dv.ToTable();
                context.Response.Write(JsonHelper.ToJsonNoRows(dtCopy));
            }
            else if (otype == "getTheNotice")
            {
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                DataTable table = sqlhelper.getTableData("select sContent from bscDataNotice where iRecNo='" + iRecNo + "' and  isnull(dExpTime,'2299-12-31')>getdate() and isnull(iHidden,0)=0");
                if (table.Rows.Count > 0)
                {
                    context.Response.Write(table.Rows[0]["sContent"]);
                }
                else
                {
                    context.Response.Write("error:公布已过期或下架");
                }
            }
            else if (otype == "getColumnsBySql")
            {
                string strSql = context.Request.Params["sql"] == null ? "" : context.Request.Params["sql"].ToString();
                if (strSql != "")
                {
                    requestResult result = new requestResult();
                    StringBuilder columnsStr = new StringBuilder();
                    columnsStr.Append("[");
                    try
                    {
                        DataTable tableC = sqlhelper.getTableData(strSql.Replace("{condition}", "1<>1"));
                        for (int i = 0; i < tableC.Columns.Count; i++)
                        {
                            columnsStr.Append("\"" + tableC.Columns[i].ColumnName + "\",");
                        }
                        if (tableC.Columns.Count > 0)
                        {
                            columnsStr.Remove(columnsStr.Length - 1, 1);
                        }
                        columnsStr.Append("]");
                        result.message = columnsStr.ToString();
                        result.success = true;
                        context.Response.Write(JsonConvert.SerializeObject(result));
                    }
                    catch (Exception ex)
                    {
                        result.success = false;
                        result.message = ex.Message;
                        context.Response.Write(JsonConvert.SerializeObject(result));
                    }

                }
            }
            else if (otype == "getCompanyName")
            {
                context.Response.Write(HttpContext.Current.Session["companyName"].ToString());
            }
            else if (otype == "sendSMS")
            {
                requestResult result = new requestResult();
                string mobile = context.Request.Params["mobile"] == null ? "" : context.Request.Params["mobile"].ToString();
                string content = context.Request.Params["content"] == null ? "" : context.Request.Params["content"].ToString();
                result = sendMSM(mobile, content);
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "getSMSBalance")
            {
                requestResult result = new requestResult();
                SMSHelper smsh = new SMSHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                result = smsh.GetSMSBalance();
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "getAppQrcodeStr")
            {
                requestResult result = new requestResult();
                StringBuilder Str = new StringBuilder();
                try
                {
                    string userid = HttpContext.Current.User.Identity.Name;
                    DataSet ds = sqlhelper.getTablesData("select top 1 sAppServerAddr,sAppServerImageAddr from SysParam select DB_NAME() /*select sPassWord from bscDataPerson where sCode='" + userid + "'*/");
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        Str.Append("{\"ServerAddr\":");
                        Str.Append("\"" + ds.Tables[0].Rows[0]["sAppServerAddr"].ToString() + "\",");
                        Str.Append("\"ServerImageAddr\":");
                        Str.Append("\"" + ds.Tables[0].Rows[0]["sAppServerImageAddr"].ToString() + "\",");
                        Str.Append("\"Database\":");
                        Str.Append("\"" + ds.Tables[1].Rows[0][0].ToString() + "\"}");
                        //Str.Append("\"UserID\":");
                        //Str.Append("\"" + userid + "\",");
                        //Str.Append("\"Password\":");
                        //User user=new User();
                        //string psd=ds.Tables[2].Rows.Count>0? user.getDecryptStr(ds.Tables[2].Rows[0][0].ToString()):"";
                        //Str.Append("\"" + psd + "\"}");
                        result.success = true;
                        result.message = Str.ToString();
                    }
                    else
                    {
                        result.success = false;
                        result.message = "生成二维码失败，请先联系管理员设置手机APP服务端地址";
                    }
                }
                catch (Exception ex)
                {
                    result.success = false;
                    result.message = "生成二维码失败," + ex.Message;
                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "getChineseDate")
            {
                CountryDate cd = new CountryDate();
                //string ChineseTimeNow = cd.GetChineseDate(DateTime.Now);//农历日期  
                string ForignTimeNow = DateTime.Now.GetDateTimeFormats('D')[0].ToString();//公历日期


                string[] Day = new string[] { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
                string week = Day[Convert.ToInt32(DateTime.Now.DayOfWeek.ToString("d"))].ToString();

                context.Response.Write(ForignTimeNow + " " + week);
            }
            else if (otype == "getChineseDate")
            {
                CountryDate cd = new CountryDate();
                //string ChineseTimeNow = cd.GetChineseDate(DateTime.Now);//农历日期  
                string ForignTimeNow = DateTime.Now.GetDateTimeFormats('D')[0].ToString();//公历日期


                string[] Day = new string[] { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
                string week = Day[Convert.ToInt32(DateTime.Now.DayOfWeek.ToString("d"))].ToString();

                context.Response.Write(ForignTimeNow + " " + week);
            }
            else if (otype == "getWarningList")
            {
                requestResult result = new requestResult();
                remindExplain re = new remindExplain(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                result = re.doExplain(HttpContext.Current.User.Identity.Name);
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "getIsNotCheckMessage")
            {
                requestResult result = new requestResult();
                try
                {
                    DataTable table = sqlhelper.getTableData("select top 1 iNotChecKMessage from SysParam");
                    result.success = true;
                    if (table.Rows.Count > 0)
                    {
                        result.message = table.Rows[0]["iNotChecKMessage"].ToString();
                    }
                    else
                    {
                        result.message = "0";
                    }
                }
                catch
                {
                    result.success = false;
                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "GetWeiXinAllUserInfo")
            {
                string appidSql = "select top 1 sWeiXinAppID,sWeiXinSecret from SysParam ";
                DataTable table = sqlhelper.getTableData(appidSql);
                sysBaseMessage.WeiXin.WeiXinHelper wxh = new sysBaseMessage.WeiXin.WeiXinHelper(table.Rows[0]["sWeiXinAppID"].ToString(), table.Rows[0]["sWeiXinSecret"].ToString(), System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                bool success = wxh.UpdateAllUserInfoOnline();
                context.Response.Write((success ? 1 : 0));
            }
            else if (otype == "GetWeiXinAllTemplet")
            {
                string appidSql = "select top 1 sWeiXinAppID,sWeiXinSecret from SysParam ";
                //string appid=context.Request.Params["appid"]
                DataTable table = sqlhelper.getTableData(appidSql);
                sysBaseMessage.WeiXin.WeiXinHelper wxh = new sysBaseMessage.WeiXin.WeiXinHelper(table.Rows[0]["sWeiXinAppID"].ToString(), table.Rows[0]["sWeiXinSecret"].ToString(), System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                bool success = wxh.UpdateAllTemplet();
                context.Response.Write((success ? 1 : 0));
            }
            else if (otype == "SendWeiXinMessage")
            {
                string appidSql = "select top 1 sWeiXinAppID,sWeiXinSecret from SysParam ";
                string templet = context.Request["templet"] == null ? "" : context.Request["templet"].ToString();
                string message = context.Request["message"] == null ? "" : context.Request["message"].ToString();
                string openid = context.Request["openid"] == null ? "" : context.Request["openid"].ToString();
                string url = context.Request["url"] == null ? "" : context.Request["url"].ToString();
                sysBaseMessage.WeiXin.MessageContent mc = JsonConvert.DeserializeObject<sysBaseMessage.WeiXin.MessageContent>(message);
                DataTable table = sqlhelper.getTableData(appidSql);
                sysBaseMessage.WeiXin.WeiXinHelper wxh = new sysBaseMessage.WeiXin.WeiXinHelper(table.Rows[0]["sWeiXinAppID"].ToString(), table.Rows[0]["sWeiXinSecret"].ToString(), System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString, templet);
                wxh.Url = url;
                sysBaseMessage.WeiXin.MessageResult mr = wxh.SendTempletMessage(openid, mc);
                requestResult result = new requestResult();
                if (mr == null)
                {
                    result.success = false;
                    result.message = "发生未知错误";
                }
                else
                {
                    if (mr.errcode == "0")
                    {
                        result.success = true;
                    }
                    else
                    {
                        result.success = false;
                        result.message = mr.errmsg;
                    }
                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "SendFormWeiXinMessage")
            {
                string appidSql = "select top 1 sWeiXinAppID,sWeiXinSecret from SysParam ";
                string iFormID = context.Request["iFormID"] == null ? "" : context.Request["iFormID"].ToString();
                string iRecNo = context.Request["iRecNo"] == null ? "" : context.Request["iRecNo"].ToString();
                DataTable table = sqlhelper.getTableData(appidSql);
                sysBaseMessage.WeiXin.WeiXinHelper wxh = new sysBaseMessage.WeiXin.WeiXinHelper(table.Rows[0]["sWeiXinAppID"].ToString(), table.Rows[0]["sWeiXinSecret"].ToString(), System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string sendResult = wxh.SendFormMessage(iFormID, iRecNo, HttpContext.Current.User.Identity.Name);
                requestResult result = new requestResult();
                if (sendResult == "1")
                {
                    result.success = true;
                }
                else
                {
                    result.success = false;
                    result.message = sendResult;
                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "checkTimerProcedureExists")
            {
                string existsSql = "if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SpSysTimerTask]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) select 1 else select 0 ";
                DataTable table = sqlhelper.getTableData(existsSql);
                if (table.Rows.Count > 0)
                {
                    context.Response.Write(table.Rows[0][0].ToString());
                }
                else
                {
                    context.Response.Write("0");
                }                
            }
            /*else if (otype == "getListImage")
            {
                string iformid = context.Request.Params["iformid"] == null ? "" :context.Request.Params["iformid"].ToString();
                string tablename = context.Request.Params["tablename"] == null ? "" :  context.Request.Params["tablename"].ToString();
                string irecno = context.Request.Params["irecno"] == null ? "" : context.Request.Params["irecno"].ToString() ;
                string imageid = context.Request.Params["imageid"] == null ? "" : context.Request.Params["imageid"].ToString() ;
                DataTable table = sqlHelper.getTableData("select sYearMonth,sFileName from FileUplad where iFormID='" + iformid + "' and sTableName='" + tablename + "' and iTableRecNo='" + irecno + "' and sImageID='" + imageid + "'");
                if (table.Rows.Count > 0)
                {
                    string url = "/Base/imageUpload/images/" + table.Rows[0]["sYearMonth"] + "/" + iformid + tablename + irecno + imageid + table.Rows[0]["sFileName"].ToString();
                    context.Response.ContentType = "text/html";
                    context.Response.Write("<div style=\"margin:auto; width:30px;height:30px;border:solid 1px #a0a0a0;\"><img alt=\"" + table.Rows[0]["sFileName"].ToString() + "\" width=\"25px\" height=\"25px\" src=\"" + url + "\" onmouseover=\"ShowFloatingImage(this, 300, 300);\" /></div>");
                }
                else
                {
                    context.Response.ContentType = "text/html";
                    //context.Response.Write("<div style=\"margin:auto;width:30px;height:30px;border:solid 1px #a0a0a0;\"><img  width=\"25px\" height=\"25px\" alt=\"\" src=\"\" /></div>");
                    context.Response.Write("");
                }
            }*/
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }

    private requestResult sendMSM(string mobile, string content)
    {
        requestResult result = new requestResult();
        try
        {
            sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            DataTable tableSMS = sqlhelper.getTableData("select top 1 sSMSAccount,sSMSPassword,iChannelGroup from SysParam order by iRecNo desc ");
            if (tableSMS.Rows.Count > 0)
            {
                string accut = tableSMS.Rows[0]["sSMSAccount"].ToString();
                string psd = tableSMS.Rows[0]["sSMSPassword"].ToString();
                uint cgid = Convert.ToUInt32(tableSMS.Rows[0]["iChannelGroup"]);
                SMS sms = new SMS(accut, psd, cgid);
                // 请修改发送的手机号码和内容, 发送单个号码
                int nRet = sms.sendOnce(mobile, content);
                switch (nRet)
                {
                    case 1:
                        {
                            result.success = true;
                        } break;
                    case 0:
                        {
                            result.success = false;
                            result.message = "帐户格式不正确(正确的格式为:员工编号@企业编号)";
                        } break;
                    case -1:
                        {
                            result.success = false;
                            result.message = "服务器拒绝(速度过快、限时或绑定IP不对等)如遇速度过快可延时再发";
                        } break;
                    case -2:
                        {
                            result.success = false;
                            result.message = "密钥不正确";
                        } break;
                    case -3:
                        {
                            result.success = false;
                            result.message = "密钥已锁定";
                        } break;
                    case -4:
                        {
                            result.success = false;
                            result.message = "参数不正确(内容和号码不能为空，手机号码数过多，发送时间错误等)";
                        } break;
                    case -5:
                        {
                            result.success = false;
                            result.message = "无此帐户";
                        } break;
                    case -6:
                        {
                            result.success = false;
                            result.message = "帐户已锁定或已过期";
                        } break;
                    case -7:
                        {
                            result.success = false;
                            result.message = "帐户未开启接口发送";
                        } break;
                    case -8:
                        {
                            result.success = false;
                            result.message = "不可使用该通道组";
                        } break;
                    case -9:
                        {
                            result.success = false;
                            result.message = "帐户余额不足";
                        } break;
                    case -10:
                        {
                            result.success = false;
                            result.message = "内部错误";
                        } break;
                    case -11:
                        {
                            result.success = false;
                            result.message = "扣费失败";
                        } break;

                }
            }
        }
        catch (Exception ex)
        {
            result.success = false;
            result.message = ex.Message;
        }
        return result;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}