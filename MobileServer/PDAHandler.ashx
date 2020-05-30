<%@ WebHandler Language="C#" Class="PDAHandler" %>

using System;
using System.Web;
using System.Data;
using sysBaseDAL.common;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Text;
using WebMobileBLL;
public class PDAHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "Hello")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                result.success = true;
                result.message = "Hello World";
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 获取未出库完成通知单明细
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetNotOutSDSendList")
        {
            string isCP = context.Request.Params["isCP"] == null ? "" : context.Request.Params["isCP"].ToString();
            string sql=" and iBillType=2 ";
            if(isCP=="1")
                sql = " and iBillType=1 ";
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select  a.iBscDataColorRecNo,a.sColorID,a.sCode,a.sName,a.sOrderNo,a.iSdOrderMRecNo,a.iSdOrderDRecNo,a.fSumQty,a.fOutQty,");
            commB.Append("b.sCustShortName,CONVERT(varchar(10),b.dDate,23) as sDateStr,b.sBillNo,b.iRecNo as iRecNoM,a.iRecNo,a.iBscDataMatRecNo ");
            commB.Append("from vwSdSendD_GMJ as a ");
            commB.Append("inner join vwSDSendM_GMJ as b on a.iMainRecNo=b.iRecNo ");
            commB.Append("where a.fSumQty>ISNULL(a.fOutQty,0) and b.iStatus=4 ");
            commB.Append(sql);
            commB.Append(" order by b.dDate asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 扫描条码
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <param name="iBscDataStockMRecNo">仓库主键</param>
        /// <param name="iBscDataMatRecNo">坯布主键</param>
        /// <param name="sBarCode">条码</param>
        /// <returns>requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetMMStockQtyByBarcode")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iBscDataMatRecNo = context.Request.Params["iBscDataMatRecNo"] == null ? "" : context.Request.Params["iBscDataMatRecNo"].ToString();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select fProductWeight,fProductWidth,iBscDataColorRecNo,sCode,sName,fQty,fPurQty,sBatchNo,sBarCode,iSdOrderMRecNo as iStockSdOrderMRecNo,iBscDataCustomerRecNo,iBscDataMatRecNo,iBscDataStockDRecNo,sReelNo,sMachine ");
            commB.Append("from vwMMStockQty ");
            commB.Append("where iBscDataStockMRecNo='" + iBscDataStockMRecNo + "'  and sBarCode='" + sBarCode + "' ");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 保存出库单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <param name="isSubmit">是否提交，1表示提交，非1表示不提交只保存</param>
        /// <param name="iMMStockOutMRecNo">出库单主键值，如果不为空，则表示是修改，则否为增加</param>
        /// <param name="iBscDataStockMRecNo">仓库主键</param>
        /// <param name="iBscDataStockDRecNo">仓位主键</param>
        /// <param name="iSDSendDRecNo">发货通知单明细主键</param>
        /// <param name="sRemark">备注</param>
        /// <param name="sDetails">明细数据，字符串结构：iSerial,iBscDataMatRecNo,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iSdSendDRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo|下一行|下一行|...</param>
        /// <returns>requestResult.success=true表示成功，=false表示失败；如果失败，则显示requestResult.message</returns>
        else if (otype == "SaveMMStockOut")
        {
            Boolean bo = true;
            string isSubmit = context.Request.Params["isSubmit"] == null ? "" : context.Request.Params["isSubmit"].ToString();
            string iMMStockOutMRecNo = context.Request.Params["iMMStockOutMRecNo"] == null ? "" : context.Request.Params["iMMStockOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iSDSendDRecNo = context.Request.Params["iSDSendDRecNo"] == null ? "" : context.Request.Params["iSDSendDRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetails = context.Request.Params["sDetails"] == null ? "" : context.Request.Params["sDetails"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            if (string.IsNullOrEmpty(iMMStockOutMRecNo))
            {
                commB.Append("declare @iRecNoM int,@iRecNoD int,@iSdSendMRecNo int,@iBscDataCustomerRecNo int,@sYearMonth varchar(10),@sCompany varchar(20) \r\n");
                commB.Append("exec GetTableLsh 'MMStockOutM',@iRecNoM output \r\n");
                commB.Append("create table #tmp(sBillNo varchar(30) null) \r\n");
                commB.Append("insert into #tmp exec Yww_FormBillNoBulid '3108'  \r\n");
                commB.Append("select @iSdSendMRecNo=iMainRecNo from SDSendD where iRecNo='" + iSDSendDRecNo + "' \r\n");
                commB.Append("select @iBscDataCustomerRecNo=b.iBscDataCustomerRecNo from SDSendD as a,SDSendM as b where a.iRecNo='" + iSDSendDRecNo + "' and a.iMainRecNo=b.iRecNo \r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sCompany=left(sClassID,2) from bscDataPerson where sCode='" + UserID + "'\r\n");
                commB.Append("insert into MMStockOutM (iRecNo,sBillNo,sTypeName,dDate,iBscDataStockMRecNo,iSDSendMRecNo,iBscDataCustomerRecNo,sYearMonth,sCompany,dInputDate,sUserID,sReMark,iRed,iBillType) \r\n");
                commB.Append("select @iRecNoM,sBillNo,'销售出库',getdate(),'" + @iBscDataStockMRecNo + "','" + iSDSendDRecNo + "',@iBscDataCustomerRecNo,@sYearMonth,@sCompany,getdate(),'" + UserID + "','" + sRemark + "',0,2 \r\n");
                commB.Append("from #tmp \r\n");
            }
            else
            {
                //修改
                commB.Append("update MMStockOutM set iBscDataStockMRecNo='" + iBscDataStockMRecNo + "',sRemark='" + sRemark + "' where iRecNo='" + iMMStockOutMRecNo + "'\r\n");
                commB.Append("delete from MMStockOutD where iMainRecNo='" + iMMStockOutMRecNo + "'\r\n");
            }
            //明细
            //明细数据结构iSerial,iBscDataMatRecNo,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iSdSendRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo|下一行
            if (!string.IsNullOrEmpty(sDetails))
            {
                string iBscDataMatRecNoStr = "";
                string[] rowStr = sDetails.Split('|');
                if (rowStr.Length > 0)
                {
                    string[] columnAttrStr = rowStr[0].Split(',');
                    iBscDataMatRecNoStr = columnAttrStr[1];
                }
                for (int i = 0; i < rowStr.Length; i++)
                {
                    if (i > 0)
                    {
                        string[] columnAttrStr = rowStr[i].Split(',');
                        if (!string.Equals(iBscDataMatRecNoStr, columnAttrStr[1]))
                        {
                            result.success = false;
                            result.message = "一个出库单只能出一种品种！";
                            bo=false;
                            break;
                        }
                    }
                    commB.Append("exec GetTableLsh 'MMStockOutD',@iRecNoD output \r\n");
                    commB.Append("insert into MMStockOutD (iRecNo,iMainRecNo,iSerial,iBscDataMatRecNo,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iSdSendDRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo,sReelNo,sMachineID)\r\n");
                    commB.Append("values\r\n");
                    commB.Append("(@iRecNoD,@iRecNoM," + rowStr[i] + ")\r\n");
                    commB.Append("update MMStockOutD set fSalePrice=b.fPrice,fSaleTotal=a.fQty*b.fPrice from MMStockOutD as a,SdSendD as b where a.iSdSendDRecNo=b.iRecNo and a.iRecNo=@iRecNoD \r\n");
                }
                commB.Append("update a set fQty=(select sum(fQty) from MMStockOutD as b where b.iMainRecNo=a.iRecNo),fTotal=(select sum(fSaleTotal) from MMStockOutD as b where b.iMainRecNo=a.iRecNo) from MMStockOutM as a where iRecNo=@iRecNoM  \r\n");
            }
            //是否提交
            if (isSubmit == "1")
            {
                commB.Append("exec SpStockSetQty 3108,@iRecNoM,'" + UserID + "','submit' \r\n");
            }
            try
            {
                if (bo)
                {
                    commB.Append("select 1 as result \r\n");
                    //DataTable table = sqlhelper.getTableData(commB.ToString());
                    result.success = true;
                    //result.message = table.Rows[0][0].ToString();
                    //result.tables.Add(table);
                    DataSet tables = sqlhelper.getTablesData(commB.ToString());
                    foreach (DataTable dt in tables.Tables)
                    {
                        result.message = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 获取当前人的仓库
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetStockM")
        {
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select iRecNo,sStockName ");
            commB.Append("from BscDataStockM ");
            commB.Append("where iRecNo in(select iMainRecNo from bscDataStockDUser where sCode='" + UserID + "')");
            commB.Append("order by sStockName asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 获取未提交出库单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetNotSubmitOut")
        {
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select iRecNo,sBillNo,CONVERT(varchar(10),dDate,23) as dDate,sStockName,sCustShortName,sUserName,sStatusName from vwMMStockOutM ");
            commB.Append("where ibilltype=2 and isnull(istatus,0)<4 ");
            commB.Append("order by dDate asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 未提交出库单提交
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "OutSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("exec SpStockSetQty 3108,'" + iRecNo + "','" + UserID + "','submit' \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 获取未提交盘点单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetNotSubmitPan")
        {
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select iRecNo,sBillNo,CONVERT(varchar(10),dDate,23) as dDate,sStockName,sUserName,sStatusName from vwMMStockCheckM where isnull(istatus,0)<4");
            commB.Append("order by dDate asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 未提交盘点单提交
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "PanSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("exec SpStockSetQty 3019,'" + iRecNo + "','" + UserID + "','submit' \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
		/// <summary>
        /// 保存盘点单
        /// </summary>
        else if (otype == "SaveMMStockCheck")
        {
            Boolean bo = true;
            string isSubmit = context.Request.Params["isSubmit"] == null ? "" : context.Request.Params["isSubmit"].ToString();
            string iMMStockOutMRecNo = context.Request.Params["iMMStockOutMRecNo"] == null ? "" : context.Request.Params["iMMStockOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetails = context.Request.Params["sDetails"] == null ? "" : context.Request.Params["sDetails"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            if (string.IsNullOrEmpty(iMMStockOutMRecNo))
            {
                commB.Append("declare @iRecNoM int,@iRecNoD int,@iSdSendMRecNo int,@sYearMonth varchar(10),@sCompany varchar(20) \r\n");
                commB.Append("exec GetTableLsh 'MMStockCheckM',@iRecNoM output \r\n");
                commB.Append("create table #tmp(sBillNo varchar(30) null) \r\n");
                commB.Append("insert into #tmp exec Yww_FormBillNoBulid '3019'  \r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sCompany=left(sClassID,2) from bscDataPerson where sCode='" + UserID + "'\r\n");
                commB.Append("insert into MMStockCheckM (iRecNo,sBillNo,dDate,iBscDataStockMRecNo,sBscDataPerson,sYearMonth,sDeptID,dInputDate,sUserID,sReMark) \r\n");
                commB.Append("select @iRecNoM,sBillNo,getdate(),'" + @iBscDataStockMRecNo + "','" + UserID + "',@sYearMonth,@sCompany,getdate(),'" + UserID + "','" + sRemark + "' \r\n");
                commB.Append("from #tmp \r\n");
            }
            else
            {
                //修改
                commB.Append("update MMStockCheckM set iBscDataStockMRecNo='" + iBscDataStockMRecNo + "',sRemark='" + sRemark + "' where iRecNo='" + iMMStockOutMRecNo + "'\r\n");
                commB.Append("delete from MMStockCheckD where iMainRecNo='" + iMMStockOutMRecNo + "'\r\n");
            }
            //明细
            
            if (!string.IsNullOrEmpty(sDetails))
            {
                string iBscDataMatRecNoStr = "";
                string[] rowStr = sDetails.Split('|');
                if (rowStr.Length > 0)
                {
                    string[] columnAttrStr = rowStr[0].Split(',');
                    iBscDataMatRecNoStr = columnAttrStr[1];
                }
                for (int i = 0; i < rowStr.Length; i++)
                {
                    if (i > 0)
                    {
                        string[] columnAttrStr = rowStr[i].Split(',');
                        if (!string.Equals(iBscDataMatRecNoStr, columnAttrStr[1]))
                        {
                            result.success = false;
                            result.message = "一个出库单只能出一种品种！";
                            bo = false;
                            break;
                        }
                    }
                    commB.Append("exec GetTableLsh 'MMStockCheckD',@iRecNoD output \r\n");
                    commB.Append("insert into MMStockCheckD (iRecNo,iMainRecNo,iSerial,iBscDataMatRecNo,fStockQty,fStockPurQty,fPcPurQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo,sReelNo,sMachineID,fPcQty,fQty)\r\n");
                    commB.Append("values\r\n");
                    commB.Append("(@iRecNoD,@iRecNoM," + rowStr[i] + ")\r\n");
                    //commB.Append("update MMStockOutD set fSalePrice=b.fPrice,fSaleTotal=a.fQty*b.fPrice from MMStockOutD as a,SdSendD as b where a.iSdSendDRecNo=b.iRecNo and a.iRecNo=@iRecNoD \r\n");
                }
                commB.Append("update a set fQty=(select sum(fQty) from MMStockCheckD as b where b.iMainRecNo=a.iRecNo),fTotal=(select sum(fTotal) from MMStockCheckD as b where b.iMainRecNo=a.iRecNo) from MMStockCheckM as a where iRecNo=@iRecNoM  \r\n");
            }
            //是否提交
            if (isSubmit == "1")
            {
                commB.Append("exec SpStockSetQty 3019,@iRecNoM,'" + UserID + "','submit' \r\n");
            }
            try
            {
                if (bo)
                {
                    commB.Append("select 1 as result \r\n");
                    //DataTable table = sqlhelper.getTableData(commB.ToString());
                    result.success = true;
                    //result.message = table.Rows[0][0].ToString();
                    //result.tables.Add(table);
                    DataSet tables = sqlhelper.getTablesData(commB.ToString());
                    foreach (DataTable dt in tables.Tables)
                    {
                        result.message = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        ///////////成品
        //////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>
        /// 获取未提交出库单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "CPGetNotSubmitOut")
        {
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select a.* from vwMMStockProductOutM as a where  iBillType=2 and isnull(istatus,0)<4 and iBscDataStockMRecNo in");
            commB.Append("(select iMainRecNo from BscDataStockDUser where sCode='" + UserID + "' and isnull(iBill,0)=1)");
            commB.Append("order by irecno desc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 未提交出库单提交
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "CPOutSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("exec SpStockProductSetQty 8021,'" + iRecNo + "','" + UserID + "','submit' \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 获取未提交盘点单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "CPGetNotSubmitPan")
        {
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select * from vwMMStockProductCheckM where iBscDataStockMRecNo in(select iMainRecNo from BscDataStockDUser where sCode='" + UserID + "' and isnull(iBill,0)=1) and isnull(iStatus,0)<4");
            commB.Append("order by dDate asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 未提交盘点单提交
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "CPPanSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("exec SpStockProductSetQty 8023,'" + iRecNo + "','" + UserID + "','submit' \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 保存盘点单
        /// </summary>
        else if (otype == "CPSaveMMStockCheck")
        {
            Boolean bo = true;
            string isSubmit = context.Request.Params["isSubmit"] == null ? "" : context.Request.Params["isSubmit"].ToString();
            string iMMStockOutMRecNo = context.Request.Params["iMMStockOutMRecNo"] == null ? "" : context.Request.Params["iMMStockOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetails = context.Request.Params["sDetails"] == null ? "" : context.Request.Params["sDetails"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            if (string.IsNullOrEmpty(iMMStockOutMRecNo))
            {
                commB.Append("declare @iRecNoM int,@iRecNoD int,@iSdSendMRecNo int,@sYearMonth varchar(10),@sCompany varchar(20) \r\n");
                commB.Append("exec GetTableLsh 'MMStockProductCheckM',@iRecNoM output \r\n");
                commB.Append("create table #tmp(sBillNo varchar(30) null) \r\n");
                commB.Append("insert into #tmp exec Yww_FormBillNoBulid '8023'  \r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sCompany=left(sClassID,2) from bscDataPerson where sCode='" + UserID + "'\r\n");
                commB.Append("insert into MMStockProductCheckM (iRecNo,sBillNo,dDate,iBscDataStockMRecNo,sBscDataPerson,sYearMonth,sDeptID,dInputDate,sUserID,sReMark) \r\n");
                commB.Append("select @iRecNoM,sBillNo,getdate(),'" + @iBscDataStockMRecNo + "','" + UserID + "',@sYearMonth,@sCompany,getdate(),'" + UserID + "','" + sRemark + "' \r\n");
                commB.Append("from #tmp \r\n");
            }
            else
            {
                //修改
                commB.Append("update MMStockProductCheckM set iBscDataStockMRecNo='" + iBscDataStockMRecNo + "',sRemark='" + sRemark + "' where iRecNo='" + iMMStockOutMRecNo + "'\r\n");
                commB.Append("delete from MMStockProductCheckD where iMainRecNo='" + iMMStockOutMRecNo + "'\r\n");
            }
            //明细

            if (!string.IsNullOrEmpty(sDetails))
            {
                string iBscDataMatRecNoStr = "";
                string[] rowStr = sDetails.Split('|');
                if (rowStr.Length > 0)
                {
                    string[] columnAttrStr = rowStr[0].Split(',');
                    iBscDataMatRecNoStr = columnAttrStr[1];
                }
                for (int i = 0; i < rowStr.Length; i++)
                {
                    if (i > 0)
                    {
                        string[] columnAttrStr = rowStr[i].Split(',');
                        if (!string.Equals(iBscDataMatRecNoStr, columnAttrStr[1]))
                        {
                            result.success = false;
                            result.message = "一个出库单只能出一种品种！";
                            bo = false;
                            break;
                        }
                    }
                    commB.Append("exec GetTableLsh 'MMStockProductCheckD',@iRecNoD output \r\n");
                    commB.Append("insert into MMStockProductCheckD (iRecNo,iMainRecNo,iSerial,iBscDataMatRecNo,fStockQty,fStockPurQty,fPcPurQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo,sReelNo,fPcQty,fQty)\r\n");
                    commB.Append("values\r\n");
                    commB.Append("(@iRecNoD,@iRecNoM," + rowStr[i] + ")\r\n");
                    //commB.Append("update MMStockOutD set fSalePrice=b.fPrice,fSaleTotal=a.fQty*b.fPrice from MMStockOutD as a,SdSendD as b where a.iSdSendDRecNo=b.iRecNo and a.iRecNo=@iRecNoD \r\n");
                }
                commB.Append("update a set fQty=(select sum(fQty) from MMStockProductCheckD as b where b.iMainRecNo=a.iRecNo) from MMStockProductCheckM as a where iRecNo=@iRecNoM  \r\n");
            }
            //是否提交
            if (isSubmit == "1")
            {
                commB.Append("exec SpStockProductSetQty 8023,@iRecNoM,'" + UserID + "','submit' \r\n");
            }
            try
            {
                if (bo)
                {
                    commB.Append("select 1 as result \r\n");
                    //DataTable table = sqlhelper.getTableData(commB.ToString());
                    result.success = true;
                    //result.message = table.Rows[0][0].ToString();
                    //result.tables.Add(table);
                    DataSet tables = sqlhelper.getTablesData(commB.ToString());
                    foreach (DataTable dt in tables.Tables)
                    {
                        result.message = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 保存出库单
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <param name="isSubmit">是否提交，1表示提交，非1表示不提交只保存</param>
        /// <param name="iMMStockOutMRecNo">出库单主键值，如果不为空，则表示是修改，则否为增加</param>
        /// <param name="iBscDataStockMRecNo">仓库主键</param>
        /// <param name="iBscDataStockDRecNo">仓位主键</param>
        /// <param name="iSDSendDRecNo">发货通知单明细主键</param>
        /// <param name="sRemark">备注</param>
        /// <param name="sDetails">明细数据，字符串结构：iSerial,iBscDataMatRecNo,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iSdSendDRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo|下一行|下一行|...</param>
        /// <returns>requestResult.success=true表示成功，=false表示失败；如果失败，则显示requestResult.message</returns>
        else if (otype == "CPSaveMMStockOut")
        {
            Boolean bo = true;
            string isSubmit = context.Request.Params["isSubmit"] == null ? "" : context.Request.Params["isSubmit"].ToString();
            string iMMStockOutMRecNo = context.Request.Params["iMMStockOutMRecNo"] == null ? "" : context.Request.Params["iMMStockOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iSDSendDRecNo = context.Request.Params["iSDSendDRecNo"] == null ? "" : context.Request.Params["iSDSendDRecNo"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string sDetails = context.Request.Params["sDetails"] == null ? "" : context.Request.Params["sDetails"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            string iBscDataMatRecNo = context.Request.Params["iBscDataMatRecNo"] == null ? "" : context.Request.Params["iBscDataMatRecNo"].ToString();
            string iBscDataColorRecNo = context.Request.Params["iBscDataColorRecNo"] == null ? "" : context.Request.Params["iBscDataColorRecNo"].ToString();
            string fProductWidth = context.Request.Params["fProductWidth"] == null ? "" : context.Request.Params["fProductWidth"].ToString();
            string fProductWeight = context.Request.Params["fProductWeight"] == null ? "" : context.Request.Params["fProductWeight"].ToString();
           
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            if (string.IsNullOrEmpty(iMMStockOutMRecNo))
            {
                commB.Append("declare @iRecNoM int,@iRecNoD int,@iSdSendMRecNo int,@iBscDataCustomerRecNo int,@sYearMonth varchar(10),@sCompany varchar(20) \r\n");
                commB.Append("exec GetTableLsh 'MMStockProductOutM',@iRecNoM output \r\n");
                commB.Append("create table #tmp(sBillNo varchar(30) null) \r\n");
                commB.Append("insert into #tmp exec Yww_FormBillNoBulid '8021'  \r\n");
                //commB.Append("select @iSdSendMRecNo=iMainRecNo from SDSendD where iRecNo='" + iSDSendDRecNo + "' \r\n");
                commB.Append("select @iBscDataCustomerRecNo=b.iBscDataCustomerRecNo from SDSendD as a,SDSendM as b where a.iRecNo='" + iSDSendDRecNo + "' and a.iMainRecNo=b.iRecNo \r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sYearMonth=sYearMonth from bscDataPeriod where dBeginDate<=getdate() and dEndDate>=getdate()\r\n");
                commB.Append("select top 1 @sCompany=left(sClassID,2) from bscDataPerson where sCode='" + UserID + "'\r\n");
                commB.Append("insert into MMStockProductOutM (iRecNo,sBillNo,fProductWidth,fProductWeight,iBscDataColorRecNo,iBscDataMatRecNo,sTypeName,dDate,iBscDataStockMRecNo,iSDSendDRecNo,iBscDataCustomerRecNo,sYearMonth,sCompany,dInputDate,sUserID,sReMark,iRed,iBillType) \r\n");
                commB.Append("select @iRecNoM,sBillNo,'" + @fProductWidth + "','" + @fProductWidth + "','" + @iBscDataColorRecNo + "','" + @iBscDataMatRecNo+ "','销售出库',getdate(),'" + @iBscDataStockMRecNo + "','" + iSDSendDRecNo + "',@iBscDataCustomerRecNo,@sYearMonth,@sCompany,getdate(),'" + UserID + "','" + sRemark + "',0,2 \r\n");
                commB.Append("from #tmp \r\n");
            }
            else
            {
                //修改
                commB.Append("update MMStockProductOutM set iBscDataStockMRecNo='" + iBscDataStockMRecNo + "',sRemark='" + sRemark + "' where iRecNo='" + iMMStockOutMRecNo + "'\r\n");
                commB.Append("delete from MMStockProductOutD where iMainRecNo='" + iMMStockOutMRecNo + "'\r\n");
            }
            //明细
            //明细数据结构iSerial,iBscDataMatRecNo,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iSdSendRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo|下一行
            if (!string.IsNullOrEmpty(sDetails))
            {
                string iBscDataMatRecNoStr = "";
                string[] rowStr = sDetails.Split('|');
                if (rowStr.Length > 0)
                {
                    string[] columnAttrStr = rowStr[0].Split(',');
                    iBscDataMatRecNoStr = columnAttrStr[1];
                }
                for (int i = 0; i < rowStr.Length; i++)
                {
                    if (i > 0)
                    {
                        string[] columnAttrStr = rowStr[i].Split(',');
                        if (!string.Equals(iBscDataMatRecNoStr, columnAttrStr[1]))
                        {
                            result.success = false;
                            result.message = "一个出库单只能出一种品种！";
                            bo = false;
                            break;
                        }
                    }
                    commB.Append("exec GetTableLsh 'MMStockProductOutD',@iRecNoD output \r\n");
                    commB.Append("insert into MMStockProductOutD (iRecNo,iMainRecNo,iSerial,fQty,fPurQty,sBatchNo,sBarCode,iStockSdOrderMRecNo,iBscDataStockDRecNo,iBscDataCustomerRecNo,sReelNo)\r\n");
                    commB.Append("values\r\n");
                    commB.Append("(@iRecNoD,@iRecNoM," + rowStr[i] + ")\r\n");
                    //commB.Append("update MMStockProductOutD set fSalePrice=b.fPrice,fSaleTotal=a.fQty*b.fPrice from MMStockOutD as a,SdSendD as b where a.iSdSendDRecNo=b.iRecNo and a.iRecNo=@iRecNoD \r\n");
                }
                commB.Append("update a set fQty=(select sum(fQty) from MMStockProductOutD as b where b.iMainRecNo=a.iRecNo) from MMStockCheckM as a where iRecNo=@iRecNoM  \r\n");
            }
            //是否提交
            if (isSubmit == "1")
            {
                commB.Append("exec SpStockProductSetQty 8021,@iRecNoM,'" + UserID + "','submit' \r\n");
            }
            try
            {
                if (bo)
                {
                    commB.Append("select 1 as result \r\n");
                    //DataTable table = sqlhelper.getTableData(commB.ToString());
                    result.success = true;
                    //result.message = table.Rows[0][0].ToString();
                    //result.tables.Add(table);
                    DataSet tables = sqlhelper.getTablesData(commB.ToString());
                    foreach (DataTable dt in tables.Tables)
                    {
                        result.message = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
	/// <summary>
        /// 获取未提交零时表
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "GetPDANotList")
        {
            string isCP = context.Request.Params["isCP"] == null ? "" : context.Request.Params["isCP"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            string sql = " and iType=2";
            if (isCP == "1")
                sql = " and iType=1";
            else if (isCP == "3")
                sql = " and iType=3";
            else if (isCP == "4")
                sql = " and iType=4";
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select *,CONVERT(varchar(10),dDate,23) as sDateStr from vwPDAtmp ");
            commB.Append(" where suserid='" + UserID + "' and isnull(ifinish,0)=0 ");
            commB.Append(sql);
            commB.Append(" order by dDate asc");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
        /// <summary>
        /// 保存临时单
        /// </summary>
        
        else if (otype == "SavePDAlist")
        {
            Boolean bo = true;
            string iMMStockOutMRecNo = context.Request.Params["iMMStockOutMRecNo"] == null ? "" : context.Request.Params["iMMStockOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iSDSendDRecNo = context.Request.Params["iSDSendDRecNo"] == null ? "" : context.Request.Params["iSDSendDRecNo"].ToString();
            string sBarcode = context.Request.Params["sBarcode"] == null ? "" : context.Request.Params["sBarcode"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            string iType = context.Request.Params["iType"] == null ? "" : context.Request.Params["iType"].ToString();
            string all = context.Request.Params["all"] == null ? "" : context.Request.Params["all"].ToString();
            string allqty = context.Request.Params["allqty"] == null ? "" : context.Request.Params["allqty"].ToString();
            string allpurqty = context.Request.Params["allpurqty"] == null ? "" : context.Request.Params["allpurqty"].ToString();
            string allletcode = context.Request.Params["allletcode"] == null ? "" : context.Request.Params["allletcode"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            if (string.IsNullOrEmpty(iMMStockOutMRecNo))
            {
                commB.Append("insert into PDAtmp values('" + iType + "','" + sBarcode + "',0,'" + UserID + "',getdate(),'" + iBscDataStockMRecNo + "','" + iSDSendDRecNo + "','" + all + "','" + allqty + "','" + allpurqty + "','" + allletcode + "') \r\n");
            }
            else
            {
                //修改
                commB.Append("update PDAtmp set iBscDataStockMRecNo='" + iBscDataStockMRecNo + "',sBarcode='" + sBarcode + "' where ID='" + iMMStockOutMRecNo + "'\r\n");
             }
            try
            {
                if (bo)
                {
                    commB.Append("select 1 as result \r\n");
                    //DataTable table = sqlhelper.getTableData(commB.ToString());
                    result.success = true;
                    //result.message = table.Rows[0][0].ToString();
                    //result.tables.Add(table);
                    DataSet tables = sqlhelper.getTablesData(commB.ToString());
                    foreach (DataTable dt in tables.Tables)
                    {
                        result.message = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
         /// <summary>
        /// PDA提交
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "PDASubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string UserID = context.Request.Params["UserID"] == null ? "" : context.Request.Params["UserID"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("exec PDAsubmit '" + iRecNo + "' \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        /// <summary>
        /// 扫描条码
        /// </summary>
        else if (otype == "GetPDABarcode")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("select iRecNo,sBerChID,sLetCode,iBscDataColorRecNo,sCode,sName,fQty,fPurQty,iBscDataMatRecNo ");
            commB.Append(" from vwMMStockQty ");
            commB.Append(" where iBscDataStockMRecNo='" + iBscDataStockMRecNo + "'  and sBarCode='" + sBarCode + "' ");
            try
            {
                DataTable table = sqlhelper.getTableData(commB.ToString());
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
       
        /// <summary>
        /// PDA表删除
        /// </summary>
        /// <param name="Database">数据库名</param>
        /// <returns>requestListResult对象。requestListResult.success=true表示成功，=false表示失败；如果失败，则显示requestListResult.message</returns>
        else if (otype == "PDADelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            StringBuilder commB = new StringBuilder();
            commB.Append("delete  PDAtmp where ID='" + iRecNo + "'");
            commB.Append(" select 1 as result \r\n");
            try
            {
                //DataTable table = sqlhelper.getTableData(commB.ToString());
                result.success = true;
                //result.message = table.Rows[0][0].ToString();
                //result.tables.Add(table);
                DataSet tables = sqlhelper.getTablesData(commB.ToString());
                foreach (DataTable dt in tables.Tables)
                {
                    result.message = dt.Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}