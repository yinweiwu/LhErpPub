<%@ WebHandler Language="C#" Class="NuoZhiHandler" %>

using System;
using System.Web;
using System.Data;
using sysBaseDAL.common;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Text;
using WebMobileBLL;
public class NuoZhiHandler : IHttpHandler {
    
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
        else if (otype == "GetPDANotSubmitOrderList")
        {
            //string barcode = context.Request.Params["sUserID"] == null ? "" : context.Request.Params["barcode"].ToString();
            string filters = context.Request.Params["filters"] == null || context.Request.Params["filters"] == "" ? "1=1" : context.Request.Params["filters"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetPDANotSubmitOrderList(userid, filters);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetThePDAOrderM")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetThePDAOrderM(iRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetBscDataCustomer")
        {
            //string barcode = context.Request.Params["sUserID"] == null ? "" : context.Request.Params["barcode"].ToString();
            //string filters = context.Request.Params["filters"] == null || context.Request.Params["filters"] == "" ? "1=1" : context.Request.Params["filters"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetBscDataCustomer(userid);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetSizeGroup")
        {
            //string barcode = context.Request.Params["sUserID"] == null ? "" : context.Request.Params["barcode"].ToString();
            //string filters = context.Request.Params["filters"] == null || context.Request.Params["filters"] == "" ? "1=1" : context.Request.Params["filters"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetSizeGroup();
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetBscDataStockM")
        {            
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetBscDataStockM(userid);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "AddPDAOrderM")
        {
            string iBscDataCustomerRecNo = context.Request.Params["ibscDataCustomerRecNo"] == null ? "" : context.Request.Params["ibscDataCustomerRecNo"].ToString();
            string ibscDataStockMRecNo = context.Request.Params["ibscDataStockMRecNo"] == null ? "" : context.Request.Params["ibscDataStockMRecNo"].ToString();
            string dOrderDate = context.Request.Params["dOrderDate"] == null ? "" : context.Request.Params["dOrderDate"].ToString();
            string sSizeGroupID = context.Request.Params["sSizeGroupID"] == null ? "" : context.Request.Params["sSizeGroupID"].ToString();
            string sSizeGroupName = context.Request.Params["sSizeGroupName"] == null ? "" : context.Request.Params["sSizeGroupName"].ToString();
            string sLogon = context.Request.Params["sLogon"] == null ? "" : context.Request.Params["sLogon"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                int iRecNo = nz.AddPDAOrderM(iBscDataCustomerRecNo, ibscDataStockMRecNo, dOrderDate, userid, sSizeGroupID, sSizeGroupName, sLogon, sRemark);
                result.message = iRecNo.ToString();
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "EditPDAOrderM")
        {
            string iPADOrderMRecNo = context.Request.Params["iPADOrderMRecNo"] == null ? "" : context.Request.Params["iPADOrderMRecNo"].ToString();
            string iBscDataCustomerRecNo = context.Request.Params["ibscDataCustomerRecNo"] == null ? "" : context.Request.Params["ibscDataCustomerRecNo"].ToString();
            string ibscDataStockMRecNo = context.Request.Params["ibscDataStockMRecNo"] == null ? "" : context.Request.Params["ibscDataStockMRecNo"].ToString();
            string dOrderDate = context.Request.Params["dOrderDate"] == null ? "" : context.Request.Params["dOrderDate"].ToString();
            string sSizeGroupID = context.Request.Params["sSizeGroupID"] == null ? "" : context.Request.Params["sSizeGroupID"].ToString();
            string sSizeGroupName = context.Request.Params["sSizeGroupName"] == null ? "" : context.Request.Params["sSizeGroupName"].ToString();
            string sLogon = context.Request.Params["sLogon"] == null ? "" : context.Request.Params["sLogon"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                nz.EditPDAOrderM(iPADOrderMRecNo,iBscDataCustomerRecNo, ibscDataStockMRecNo, dOrderDate, userid, sSizeGroupID, sSizeGroupName, sLogon, sRemark);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeletePDAOrderM")
        {
            string iPADOrderMRecNo = context.Request.Params["iPADOrderMRecNo"] == null ? "" : context.Request.Params["iPADOrderMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                nz.DeletePDAOrderM(iPADOrderMRecNo);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "SubmitPDAOrderM")
        {
            string iPADOrderMRecNo = context.Request.Params["iPADOrderMRecNo"] == null ? "" : context.Request.Params["iPADOrderMRecNo"].ToString();
            string sBank = context.Request.Params["sBank"] == null ? "" : context.Request.Params["sBank"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                nz.SubmitPDAOrderM(iPADOrderMRecNo, sBank, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetPDAOrderListD")
        {
            string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "" : context.Request.Params["iMainRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetPDAOrderListD(iMainRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetPDAOrderDD")
        {
            string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "" : context.Request.Params["iMainRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetPDAOrderDD(iMainRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
            
            
        else if (otype == "GetPDAOrderSizeName")
        {
            string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "" : context.Request.Params["iMainRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetPDAOrderSizeName(iMainRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetTheStyleNo")
        {
            string text = context.Request.Params["text"] == null ? "" : context.Request.Params["text"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetTheStyleNo(text);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetBscDataStyleColor")
        {
            string iBscDataStyleMRecNo = context.Request.Params["iBscDataStyleMRecNo"] == null ? "" : context.Request.Params["iBscDataStyleMRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetBscDataStyleColor(iBscDataStyleMRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetBscDataColor")
        {
            string text = context.Request.Params["text"] == null ? "" : context.Request.Params["text"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetBscDataColor(text);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetThePDAOrderMStyleNoPrice")
        {
            string iPDAOrderMRecNo = context.Request.Params["iPDAOrderMRecNo"] == null ? "" : context.Request.Params["iPDAOrderMRecNo"].ToString();
            string iBscDataStyleMRecNo = context.Request.Params["iBscDataStyleMRecNo"] == null ? "" : context.Request.Params["iBscDataStyleMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                string price = nz.GetThePDAOrderMStyleNoPrice(iPDAOrderMRecNo, iBscDataStyleMRecNo);
                result.message = price;
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "AddOrderDetail")
        {
            string iPDAOrderMRecNo = context.Request.Params["iPDAOrderMRecNo"] == null ? "" : context.Request.Params["iPDAOrderMRecNo"].ToString();
            string ibscDataStyleMRecNo = context.Request.Params["ibscDataStyleMRecNo"] == null ? "" : context.Request.Params["ibscDataStyleMRecNo"].ToString();
            string ibscDataColorRecNo = context.Request.Params["ibscDataColorRecNo"] == null ? "" : context.Request.Params["ibscDataColorRecNo"].ToString();
            string fPrice = context.Request.Params["fPrice"] == null ? "" : context.Request.Params["fPrice"].ToString();
            string dDeliveryDate = context.Request.Params["dDeliveryDate"] == null ? "" : context.Request.Params["dDeliveryDate"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string iSumQty = context.Request.Params["iSumQty"] == null ? "" : context.Request.Params["iSumQty"].ToString();
            string sGrandData = context.Request.Params["sGrandData"] == null ? "" : context.Request.Params["sGrandData"].ToString();
            //string sGrandData1 = context.Request.Params["sGrandData1"] == null ? "" : context.Request.Params["sGrandData1"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                bool success = nz.AddOrderDetail(iPDAOrderMRecNo, ibscDataStyleMRecNo, ibscDataColorRecNo, fPrice, dDeliveryDate, sRemark, iSumQty, sGrandData);
                result.message = (success ? "1" : "0");
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "ModifyOrderDetail")
        {
            string iPDAOrderMRecNo = context.Request.Params["iPDAOrderMRecNo"] == null ? "" : context.Request.Params["iPDAOrderMRecNo"].ToString();
            string iRecNoD = context.Request.Params["iRecNoD"] == null ? "" : context.Request.Params["iRecNoD"].ToString();
            string ibscDataStyleMRecNo = context.Request.Params["ibscDataStyleMRecNo"] == null ? "" : context.Request.Params["ibscDataStyleMRecNo"].ToString();
            string ibscDataColorRecNo = context.Request.Params["ibscDataColorRecNo"] == null ? "" : context.Request.Params["ibscDataColorRecNo"].ToString();
            string fPrice = context.Request.Params["fPrice"] == null ? "" : context.Request.Params["fPrice"].ToString();
            string dDeliveryDate = context.Request.Params["dDeliveryDate"] == null ? "" : context.Request.Params["dDeliveryDate"].ToString();
            string sRemark = context.Request.Params["sRemark"] == null ? "" : context.Request.Params["sRemark"].ToString();
            string iSumQty = context.Request.Params["iSumQty"] == null ? "" : context.Request.Params["iSumQty"].ToString();
            string sGrandData = context.Request.Params["sGrandData"] == null ? "" : context.Request.Params["sGrandData"].ToString();
            //string sGrandData1 = context.Request.Params["sGrandData1"] == null ? "" : context.Request.Params["sGrandData1"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                bool success = nz.ModifyOrderDetail(iPDAOrderMRecNo,iRecNoD, ibscDataStyleMRecNo, ibscDataColorRecNo, fPrice, dDeliveryDate, sRemark, iSumQty, sGrandData);
                result.message = (success ? "1" : "0");
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "DeleteOrderDetail")
        {
            string iRecNoD = context.Request.Params["iRecNoD"] == null ? "" : context.Request.Params["iRecNoD"].ToString();
            requestResult result = new requestResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                bool success = nz.DeleteOrderDetail(iRecNoD);
                result.message = (success ? "1" : "0");
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetStyleAllStockQty")
        {
            string iBscDataStyleMRecNo = context.Request.Params["iBscDataStyleMRecNo"] == null ? "" : context.Request.Params["iBscDataStyleMRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetStyleAllStockQty(iBscDataStyleMRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetStyleStockQty")
        {
            string iBscDataStyleMRecNo = context.Request.Params["iBscDataStyleMRecNo"] == null ? "" : context.Request.Params["iBscDataStyleMRecNo"].ToString();
            string iBscDataColorRecNo = context.Request.Params["iBscDataColorRecNo"] == null ? "" : context.Request.Params["iBscDataColorRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetStyleStockQty(iBscDataStyleMRecNo,iBscDataColorRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetStylePublickStockQty")
        {
            string iBscDataStyleMRecNo = context.Request.Params["iBscDataStyleMRecNo"] == null ? "" : context.Request.Params["iBscDataStyleMRecNo"].ToString();
            string iBscDataColorRecNo = context.Request.Params["iBscDataColorRecNo"] == null ? "" : context.Request.Params["iBscDataColorRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                NuozhiHelper nz = new NuozhiHelper(sConnStr);
                DataTable table = nz.GetStylePublickStockQty(iBscDataStyleMRecNo, iBscDataColorRecNo);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}