//+------------------------------------------------------------------+
//|                                                  PendReqOpen.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "PendRequest.mqh"
//+------------------------------------------------------------------+
//| Pending request for opening a position                           |
//+------------------------------------------------------------------+
class CPendReqOpen : public CPendRequest
  {
public:
//--- Constructor
                     CPendReqOpen(const uchar id,
                                  const double price,
                                  const ulong time,
                                  const MqlTradeRequest &request,
                                  const int retcode) : CPendRequest(PEND_REQ_STATUS_OPEN,id,price,time,request,retcode) {}
                                  
//--- Supported deal properties (1) real, (2) integer
   virtual bool      SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property);
   virtual bool      SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property);
   virtual bool      SupportProperty(ENUM_PEND_REQ_PROP_STRING property);
//--- Display a brief message with request data in the journal
   virtual void      PrintShort(void);
  };
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| integer property, otherwise return 'false'                       |
//+------------------------------------------------------------------+
bool CPendReqOpen::SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property)
  {
   if(property==PEND_REQ_PROP_MQL_REQ_ORDER        ||
      property==PEND_REQ_PROP_MQL_REQ_POSITION     ||
      property==PEND_REQ_PROP_MQL_REQ_POSITION_BY  ||
      property==PEND_REQ_PROP_MQL_REQ_EXPIRATION   ||
      property==PEND_REQ_PROP_MQL_REQ_TYPE_TIME
     ) return false;
   return true;
  }
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| real property, otherwise return 'false'                          |
//+------------------------------------------------------------------+
bool CPendReqOpen::SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property)
  {
   return(property==PEND_REQ_PROP_MQL_REQ_STOPLIMIT ? false : true);
  }
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| string property, otherwise return 'false'                        |
//+------------------------------------------------------------------+
bool CPendReqOpen::SupportProperty(ENUM_PEND_REQ_PROP_STRING property)
  {
   return true;
  }
//+------------------------------------------------------------------+
//| Display a brief message with request data in the journal         |
//+------------------------------------------------------------------+
void CPendReqOpen::PrintShort(void)
  {
   string params=this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL)+" "+::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME),this.m_digits_lot)+" "+
                 OrderTypeDescription((ENUM_ORDER_TYPE)this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE));
   string price=CMessage::Text(MSG_LIB_TEXT_REQUEST_PRICE)+" "+::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_PRICE),this.m_digits);
   string sl=this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL)>0 ? ", "+CMessage::Text(MSG_LIB_TEXT_REQUEST_SL)+" "+::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL),this.m_digits) : "";
   string tp=this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP)>0 ? ", "+CMessage::Text(MSG_LIB_TEXT_REQUEST_TP)+" "+::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP),this.m_digits) : "";
   string time=this.IDDescription()+", "+CMessage::Text(MSG_LIB_TEXT_CREATED)+" "+TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE));
   string attempts=CMessage::Text(MSG_LIB_TEXT_ATTEMPTS)+" "+(string)this.GetProperty(PEND_REQ_PROP_TOTAL);
   string wait=CMessage::Text(MSG_LIB_TEXT_WAIT)+" "+::TimeToString(this.GetProperty(PEND_REQ_PROP_WAITING)/1000,TIME_SECONDS);
   string end=CMessage::Text(MSG_LIB_TEXT_END)+" "+
              TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE)+this.GetProperty(PEND_REQ_PROP_WAITING)*this.GetProperty(PEND_REQ_PROP_TOTAL));
   //---
   string message=CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_STATUS_OPEN)+": "+
   "\n- "+params+", "+price+sl+tp+
   "\n- "+time+", "+attempts+", "+wait+", "+end+"\n";
   ::Print(message);
  }
//+------------------------------------------------------------------+
