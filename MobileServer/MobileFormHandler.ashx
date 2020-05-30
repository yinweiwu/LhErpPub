<%@ WebHandler Language="C#" Class="MobileFormHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Text;
using Newtonsoft.Json;
using sysBaseExplain;
using System.Collections.Generic;
public class MobileFormHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "GetFormData")
        {
            FormList fl = new FormList(sConnStr);
            requestTablesResult result = fl.GetFormListData(context, HttpContext.Current.User.Identity.Name);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getFormInfo")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            requestDataSetResult result = new requestDataSetResult();
            try
            {
                DataSet ds = mfn.GetFormInfo(iformid);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getFormListData")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            string page = context.Request.Params["page"] == null ? "1" : context.Request.Params["page"].ToString();
            bool isFirst = context.Request.Params["isFirst"] == null ? true : (context.Request.Params["isFirst"].ToString() == "1" ? true : false);
            bool isDetail = context.Request.Params["isDetail"] == null ? false : (context.Request.Params["isDetail"].ToString() == "1" ? true : false);

            requestTablesResult result = new requestTablesResult();
            try
            {
                List<DataTable> tables = mfn.GetFormListData(iformid, filters, page, isFirst, isDetail, userid);
                result.success = true;
                result.tables = tables;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getFormDefined")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            requestDataSetResult result = new requestDataSetResult();
            try
            {
                DataSet ds = mfn.GetFormDefine(iformid, userid);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getLookupData")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string lookupName = context.Request.Params["lookupName"] == null ? "" : context.Request.Params["lookupName"].ToString();
            string page = context.Request.Params["page"] == null ? "" : context.Request.Params["page"].ToString();
            string pageSize = context.Request.Params["pageSize"] == null ? "" : context.Request.Params["pageSize"].ToString();
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            string targetid = context.Request.Params["targetid"] == null ? "" : context.Request.Params["targetid"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                List<DataTable> tables = mfn.GetLookUpData(lookupName, userid, page, pageSize, filters, targetid);
                result.success = true;
                result.tables = tables;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getLookupDefined")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string lookupName = context.Request.Params["lookupName"] == null ? "" : context.Request.Params["lookupName"].ToString();
            string targetID = context.Request.Params["targetid"] == null ? "" : context.Request.Params["targetid"].ToString();
            requestDataSetResult result = new requestDataSetResult();
            try
            {
                DataSet ds = mfn.GetLookupDefined(lookupName, targetID, userid);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getLookupDefineds")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string lookupNames = context.Request.Params["lookupNames"] == null ? "" : context.Request.Params["lookupNames"].ToString();
            requestDataSetResult result = new requestDataSetResult();
            try
            {
                DataSet ds = mfn.GetLookupDefineds(lookupNames, userid);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getTheFormData")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestDataSetResult result = new requestDataSetResult();
            try
            {
                DataSet ds = mfn.GetTheFormData(iformid, key, userid);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getTheFormChildData")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string tableName = context.Request.Params["tableName"] == null ? "" : context.Request.Params["tableName"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                DataTable dt = mfn.GetTheFormChildData(iformid, tableName, key, userid);
                result.success = true;
                result.tables.Add(dt);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "saveTheFormData")
        {
            string mainquery = context.Request.Params["mainquery"].ToString();
            string childrenstr = context.Request.Params["children"].ToString();
            requestResult result = new requestResult();
            try
            {
                SqlOperatorObject soo = JsonConvert.DeserializeObject<SqlOperatorObject>(mainquery);
                List<ChildObj> children = JsonConvert.DeserializeObject<List<ChildObj>>(childrenstr);
                sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(sConnStr);
                for (int i = 0; i < children.Count; i++)
                {
                    string tableName = children[i].tablename;
                    DataTable tableColumn = sqlhelper.getTableData("select Name from SysColumns where id=Object_Id('" + tableName + "')");
                    if (tableColumn.Rows.Count > 0)
                    {
                        for (int j = 0; j < children[i].data.Columns.Count; j++)
                        {
                            if (soo.Operatortype == "add")
                            {
                                DataRow[] rows = tableColumn.Select("Name='" + children[i].data.Columns[j].ColumnName + "'");
                                if (rows.Length == 0)
                                {
                                    children[i].data.Columns.RemoveAt(j);
                                    j--;
                                }
                            }
                            else
                            {
                                DataRow[] rows = tableColumn.Select("Name='" + children[i].data.Columns[j].ColumnName + "'");
                                if (rows.Length == 0 && children[i].data.Columns[j].ColumnName != "__hxstate")
                                {
                                    children[i].data.Columns.RemoveAt(j);
                                    j--;
                                }
                            }
                        }
                    }
                }

                string key = soo.SqlFormOperatorWithGrandsonDic1(children, sConnStr);
                result.success = true;
                result.message = key;
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
        }
        else if (otype == "deleteTheFormData")
        {
            string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string tablename = context.Request.Params["tableName"] == null ? "" : context.Request.Params["tableName"].ToString();
            string fieldkey = context.Request.Params["fieldKey"] == null ? "" : context.Request.Params["fieldKey"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = new requestResult();
            try
            {
                MobileFormNew mfn = new MobileFormNew(sConnStr);
                string result1 = mfn.DeleteTheFormData(iformid, tablename, fieldkey, key, userid);
                if (result1 == "1")
                {
                    result.success = true;
                }
                else
                {
                    result.success = false;
                    result.message = result1;
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getNextID")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string tablename = context.Request.Params["tablename"] == null ? "" : context.Request.Params["tablename"].ToString();
            requestResult result = new requestResult();
            try
            {
                string nextID = mfn.GetNextID(tablename);
                result.success = true;
                result.message = nextID;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetAutoSerialField")
        {
            MobileFormNew mfn = new MobileFormNew(sConnStr);
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            requestResult result = new requestResult();
            try
            {
                string nextID = mfn.GetAutoSerialField(iFormID, userid);
                result.success = true;
                result.message = nextID;
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