//+------------------------------------------------------------------+
//|                                               PendReqControl.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
#property strict    // Necessary for mql4
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "Trading.mqh"
//+------------------------------------------------------------------+
//| Class for managing pending trading requests                      |
//+------------------------------------------------------------------+
class CTradingControl : public CTrading
  {
private:
//--- Set actual order/position data to a pending request object
   void                 SetActualProperties(CPendRequest *req_obj,const COrder *order);
public:
//--- Return itself
   CTradingControl     *GetObject(void)            { return &this;   }
//--- Timer
   virtual void         OnTimer(void);
//--- Constructor
                        CTradingControl();
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTradingControl::CTradingControl()
  {
   this.m_list_request.Clear();
   this.m_list_request.Sort();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTradingControl::OnTimer(void)
  {
   //--- In a loop by the list of pending requests
   int total=this.m_list_request.Total();
   for(int i=total-1;i>WRONG_VALUE;i--)
     {
      //--- receive the next request object
      CPendRequest *req_obj=this.m_list_request.At(i);
      if(req_obj==NULL)
         continue;
      
      //--- get the request structure and the symbol object a trading operation should be performed for
      MqlTradeRequest request=req_obj.MqlRequest();
      CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(request.symbol);
      if(symbol_obj==NULL || !symbol_obj.RefreshRates())
         continue;
      
      //--- Set the flag disabling trading in the terminal by two properties simultaneously
      //--- (the AutoTrading button in the terminal and the Allow Automated Trading option in the EA settings)
      //--- If any of the two properties is 'false', the flag is 'false' as well
      bool terminal_trade_allowed=::TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);
      terminal_trade_allowed &=::MQLInfoInteger(MQL_TRADE_ALLOWED);
      //--- If a request object is based on the error code
      if(req_obj.TypeRequest()==PEND_REQ_TYPE_ERROR)
        {
         //--- if the error has been caused by trading disabled on the terminal side and has been eliminated
         if(req_obj.Retcode()==10027 && terminal_trade_allowed)
           {
            //--- if the current attempt has not exceeded the defined number of trading attempts yet
            if(req_obj.CurrentAttempt()<req_obj.TotalAttempts()+1)
              {
               //--- Set the request creation time equal to its creation time minus waiting time, i.e. send the request immediately
               //--- Also, decrease the number of a successful attempt since during the next attempt, its number is increased, and if this is the last attempt,
               //--- it is not executed. However, this is related to fixing the error cause by a user, which means we need to give more time for the last attempt
               req_obj.SetTimeCreate(req_obj.TimeCreate()-req_obj.WaitingMSC());
               req_obj.SetCurrentAttempt(uchar(req_obj.CurrentAttempt()>0 ? req_obj.CurrentAttempt()-1 : 0));
              }
           }
        }

      //--- if the current attempt exceeds the defined number of trading attempts,
      //--- or the current time exceeds the waiting time of all attempts
      //--- remove the current request object and move on to the next one
      if(req_obj.CurrentAttempt()>req_obj.TotalAttempts() || req_obj.CurrentAttempt()>=UCHAR_MAX || 
         (long)symbol_obj.Time()>long(req_obj.TimeCreate()+req_obj.WaitingMSC()*req_obj.TotalAttempts()))
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_DELETED));
         this.m_list_request.Delete(i);
         continue;
        }
      
      //--- If this is a position opening or placing a pending order
      if((req_obj.Action()==TRADE_ACTION_DEAL && req_obj.Position()==0) || req_obj.Action()==TRADE_ACTION_PENDING)
        {
         //--- Get the pending request ID
         uchar id=this.GetPendReqID((uint)request.magic);
         //--- Get the list of orders/positions containing the order/position with the pending request ID
         CArrayObj *list=this.m_market.GetList(ORDER_PROP_PEND_REQ_ID,id,EQUAL);
         if(::CheckPointer(list)==POINTER_INVALID)
            continue;
         //--- If the order/position is present, the request is handled: remove it and proceed to the next
         if(list.Total()>0)
           {
            if(this.m_log_level>LOG_LEVEL_NO_MSG)
               ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
            this.m_list_request.Delete(i);
            continue;
           }
        }
      //--- Otherwise: full and partial position closure, removing an order, modifying order parameters and position stop orders
      else
        {
         CArrayObj *list=NULL;
         //--- if this is a position closure, including a closure by an opposite one
         if((req_obj.Action()==TRADE_ACTION_DEAL && req_obj.Position()>0) || req_obj.Action()==TRADE_ACTION_CLOSE_BY)
           {
            //--- Get a position with the necessary ticket from the list of open positions
            list=this.m_market.GetList(ORDER_PROP_TICKET,req_obj.Position(),EQUAL);
            if(::CheckPointer(list)==POINTER_INVALID)
               continue;
            //--- If the market has no such position - the request is handled: remove it and proceed to the next one
            if(list.Total()==0)
              {
               if(this.m_log_level>LOG_LEVEL_NO_MSG)
                  ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
               this.m_list_request.Delete(i);
               continue;
              }
            //--- Otherwise, if the position still exists, this is a partial closure
            else
              {
               //--- Get the list of all account trading events
               list=this.m_events.GetList();
               if(list==NULL)
                  continue;
               //--- In the loop from the end of the account trading event list
               int events_total=list.Total();
               for(int j=events_total-1; j>WRONG_VALUE; j--)
                 {
                  //--- get the next trading event
                  CEvent *event=list.At(j);
                  if(event==NULL)
                     continue;
                  //--- If this event is a partial closure or there was a partial closure when closing by an opposite one
                  if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL || event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS)
                    {
                     //--- If a position ticket in a trading event coincides with the ticket in a pending trading request
                     if(event.PositionID()==req_obj.Position())
                       {
                        //--- Get a position object from the list of market positions
                        CArrayObj *list_orders=this.m_market.GetList(ORDER_PROP_POSITION_ID,req_obj.Position(),EQUAL);
                        if(list_orders==NULL || list_orders.Total()==0)
                           break;
                        COrder *order=list_orders.At(list_orders.Total()-1);
                        if(order==NULL)
                           break;
                        //--- Set actual position data to the pending request object
                        this.SetActualProperties(req_obj,order);
                        //--- If (executed request volume + unexecuted request volume) is equal to the requested volume in a pending request -
                        //--- the request is handled: remove it and break the loop by the list of account trading events
                        if(req_obj.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME)==event.VolumeOrderExecuted()+event.VolumeOrderCurrent())
                          {
                           if(this.m_log_level>LOG_LEVEL_NO_MSG)
                              ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
                           this.m_list_request.Delete(i);
                           break;
                          }
                       }
                    }
                 }
               //--- If a handled pending request object was removed by the trading event list in the loop, move on to the next one
               if(::CheckPointer(req_obj)==POINTER_INVALID)
                  continue;
              }
           }
         //--- If this is a modification of position stop orders
         if(req_obj.Action()==TRADE_ACTION_SLTP)
           {
            //--- Get the list of all account trading events
            list=this.m_events.GetList();
            if(list==NULL)
               continue;
            //--- In the loop from the end of the account trading event list
            int events_total=list.Total();
            for(int j=events_total-1; j>WRONG_VALUE; j--)
              {
               //--- get the next trading event
               CEvent *event=list.At(j);
               if(event==NULL)
                  continue;
               //--- If this is a change of the position's stop orders
               if(event.TypeEvent()>TRADE_EVENT_MODIFY_ORDER_TAKE_PROFIT)
                 {
                  //--- If a position ticket in a trading event coincides with the ticket in a pending trading request
                  if(event.PositionID()==req_obj.Position())
                    {
                     //--- Get a position object from the list of market positions
                     CArrayObj *list_orders=this.m_market.GetList(ORDER_PROP_POSITION_ID,req_obj.Position(),EQUAL);
                     if(list_orders==NULL || list_orders.Total()==0)
                        break;
                     COrder *order=list_orders.At(list_orders.Total()-1);
                     if(order==NULL)
                        break;
                     //--- Set actual position data to the pending request object
                     this.SetActualProperties(req_obj,order);
                     //--- If all modifications have worked out -
                     //--- the request is handled: remove it and break the loop by the list of account trading events
                     if(req_obj.IsCompleted())
                       {
                        if(this.m_log_level>LOG_LEVEL_NO_MSG)
                           ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
                        this.m_list_request.Delete(i);
                        break;
                       }
                    }
                 }
              }
            //--- If a handled pending request object was removed by the trading event list in the loop, move on to the next one
            if(::CheckPointer(req_obj)==POINTER_INVALID)
               continue;
           }
         //--- If this is a pending order removal
         if(req_obj.Action()==TRADE_ACTION_REMOVE)
           {
            //--- Get the list of removed pending orders from the historical list
            list=this.m_history.GetList(ORDER_PROP_STATUS,ORDER_STATUS_HISTORY_PENDING,EQUAL);
            if(::CheckPointer(list)==POINTER_INVALID)
               continue;
            //--- Leave a single order with the necessary ticket in the list
            list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,req_obj.Order(),EQUAL);
            //--- If the order is present, the request is handled: remove it and proceed to the next
            if(list.Total()>0)
              {
               if(this.m_log_level>LOG_LEVEL_NO_MSG)
                  ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
               this.m_list_request.Delete(i);
               continue;
              }
           }
         //--- If this is a pending order modification
         if(req_obj.Action()==TRADE_ACTION_MODIFY)
           {
            //--- Get the list of all account trading events
            list=this.m_events.GetList();
            if(list==NULL)
               continue;
            //--- In the loop from the end of the account trading event list
            int events_total=list.Total();
            for(int j=events_total-1; j>WRONG_VALUE; j--)
              {
               //--- get the next trading event
               CEvent *event=list.At(j);
               if(event==NULL)
                  continue;
               //--- If this event involves any change of modified pending order parameters
               if(event.TypeEvent()>TRADE_EVENT_TRIGGERED_STOP_LIMIT_ORDER && event.TypeEvent()<TRADE_EVENT_MODIFY_POSITION_STOP_LOSS_TAKE_PROFIT)
                 {
                  //--- If an order ticket in a trading event coincides with the ticket in a pending trading request
                  if(event.TicketOrderEvent()==req_obj.Order())
                    {
                     //--- Get an order object from the list
                     CArrayObj *list_orders=this.m_market.GetList(ORDER_PROP_TICKET,req_obj.Order(),EQUAL);
                     if(list_orders==NULL || list_orders.Total()==0)
                        break;
                     COrder *order=list_orders.At(0);
                     if(order==NULL)
                        break;
                     //--- Set actual order data to the pending request object
                     this.SetActualProperties(req_obj,order);
                     //--- If all modifications have worked out -
                     //--- the request is handled: remove it and break the loop by the list of account trading events
                     if(req_obj.IsCompleted())
                       {
                        if(this.m_log_level>LOG_LEVEL_NO_MSG)
                           ::Print(req_obj.Header(),": ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_EXECUTED));
                        this.m_list_request.Delete(i);
                        break;
                       }
                    }
                 }
              }
           }
        }
      
      //--- Exit if the pending request object has been removed after checking its operation
      if(::CheckPointer(req_obj)==POINTER_INVALID)
         return;
      //--- Set the request activation time in the request object
      req_obj.SetTimeActivate(req_obj.TimeCreate()+req_obj.WaitingMSC()*(req_obj.CurrentAttempt()+1));
      
      //--- If the current time is less than the request activation time,
      //--- this is not the request time - move on to the next request in the list
      if((long)symbol_obj.Time()<(long)req_obj.TimeActivate())
         continue;
      
      //--- Set the attempt number in the request object
      req_obj.SetCurrentAttempt(uchar(req_obj.CurrentAttempt()+1));
      
      //--- Display the number of a trading attempt in the journal

      if(this.m_log_level>LOG_LEVEL_NO_MSG)
        {
         ::Print(CMessage::Text(MSG_LIB_TEXT_RE_TRY_N)+(string)req_obj.CurrentAttempt()+":");
         req_obj.PrintShort();
        }
      
      //--- Depending on the type of action performed in the trading request 
      switch(request.action)
        {
         //--- Opening/closing a position
         case TRADE_ACTION_DEAL :
            //--- If no ticket is present in the request structure - this is opening a position
            if(request.position==0)
               this.OpenPosition((ENUM_POSITION_TYPE)request.type,request.volume,request.symbol,request.magic,request.sl,request.tp,request.comment,request.deviation,request.type_filling);
            //--- If the ticket is present in the request structure - this is a position closure
            else
               this.ClosePosition(request.position,request.volume,request.comment,request.deviation);
            break;
         //--- Modify StopLoss/TakeProfit position
         case TRADE_ACTION_SLTP :
            this.ModifyPosition(request.position,request.sl,request.tp);
            break;
         //--- Close by an opposite one
         case TRADE_ACTION_CLOSE_BY :
            this.ClosePositionBy(request.position,request.position_by);
            break;
         //---
         //--- Place a pending order
         case TRADE_ACTION_PENDING :
            this.PlaceOrder(request.type,request.volume,request.symbol,request.price,request.stoplimit,request.sl,request.tp,request.magic,request.comment,request.expiration,request.type_time,request.type_filling);
            break;
         //--- Modify a pending order
         case TRADE_ACTION_MODIFY :
            this.ModifyOrder(request.order,request.price,request.sl,request.tp,request.stoplimit,request.expiration,request.type_time,request.type_filling);
            break;
         //--- Remove a pending order
         case TRADE_ACTION_REMOVE :
            this.DeleteOrder(request.order);
            break;
         //---
         default:
            break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Set order/position data to a pending request object              |
//+------------------------------------------------------------------+
void CTradingControl::SetActualProperties(CPendRequest *req_obj,const COrder *order)
  {
   req_obj.SetActualExpiration(order.TimeExpiration());
   req_obj.SetActualPrice(order.PriceOpen());
   req_obj.SetActualSL(order.StopLoss());
   req_obj.SetActualStopLimit(order.PriceStopLimit());
   req_obj.SetActualTP(order.TakeProfit());
   req_obj.SetActualTypeFilling(order.TypeFilling());
   req_obj.SetActualTypeTime(order.TypeTime());
   req_obj.SetActualVolume(order.Volume());
  }
//+------------------------------------------------------------------+
