//+------------------------------------------------------------------+
//|                                                      Trading.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Arrays\ArrayInt.mqh>
#include "Objects\Trade\TradeObj.mqh"
#include "Collections\AccountsCollection.mqh"
#include "Collections\SymbolsCollection.mqh"
#include "Collections\MarketCollection.mqh"
#include "Collections\HistoryCollection.mqh"
//+------------------------------------------------------------------+
//| Trading class                                                    |
//+------------------------------------------------------------------+
class CTrading
  {
private:
   CAccount            *m_account;           // Pointer to the current account object
   CSymbolsCollection  *m_symbols;           // Pointer to the symbol collection list
   CMarketCollection   *m_market;            // Pointer to the list of the collection of market orders and positions
   CHistoryCollection  *m_history;           // Pointer to the list of the collection of historical orders and deals
   CArrayInt            m_list_errors;       // Error list
   bool                 m_is_trade_enable;   // Flag enabling trading
   ENUM_LOG_LEVEL       m_log_level;         // Logging level

//--- Add the error code to the list
   bool                 AddErrorCodeToList(const int error_code);
//--- Return the symbol object by (1) position, (2) order ticket
   CSymbol             *GetSymbolObjByPosition(const ulong ticket,const string source_method);
   CSymbol             *GetSymbolObjByOrder(const ulong ticket,const string source_method);
//--- Return a symbol trading object by (1) position, (2) order ticket, (3) symbol name
   CTradeObj           *GetTradeObjByPosition(const ulong ticket,const string source_method);
   CTradeObj           *GetTradeObjByOrder(const ulong ticket,const string source_method);
   CTradeObj           *GetTradeObjBySymbol(const string symbol,const string source_method);
//--- Return the number of (1) all positions, (2) buy, (3) sell positions
   int                  PositionsTotalAll(void)          const;
   int                  PositionsTotalLong(void)         const;
   int                  PositionsTotalShort(void)        const;
//--- Return the number of (1) all pending orders, (2) buy, (3) sell pending orders
   int                  OrdersTotalAll(void)             const;
   int                  OrdersTotalLong(void)            const;
   int                  OrdersTotalShort(void)           const;
//--- Return the total volume of (1) buy, (2) sell positions
   double               PositionsTotalVolumeLong(void)   const;
   double               PositionsTotalVolumeShort(void)  const;
//--- Return the total volume of (1) buy, (2) sell orders
   double               OrdersTotalVolumeLong(void)      const;
   double               OrdersTotalVolumeShort(void)     const;
//--- Return the order direction by an operation type
   ENUM_ORDER_TYPE      DirectionByActionType(ENUM_ACTION_TYPE action) const;
//--- Check the presence of a (1) position, (2) order by ticket
   bool                 CheckPositionAvailablity(const ulong ticket,const string source_method);
   bool                 CheckOrderAvailablity(const ulong ticket,const string source_method);
//--- Set the desired sound for a trading object
   void                 SetSoundByMode(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,CTradeObj *trade_obj);
public:
//--- Constructor
                        CTrading();
//--- Get the pointers to the lists (make sure to call the method in program's OnInit() since the symbol collection list is created there)
   void                 OnInit(CAccount *account,CSymbolsCollection *symbols,CMarketCollection *market,CHistoryCollection *history)
                          {
                           this.m_account=account;
                           this.m_symbols=symbols;
                           this.m_market=market;
                           this.m_history=history;
                          }
//--- Return the error list
   CArrayInt           *GetListErrors(void)                                { return &this.m_list_errors; }
//--- Check trading limitations
   bool                 CheckTradeConstraints(const double volume,
                                              const ENUM_ACTION_TYPE action_type,
                                              const CSymbol *symbol_obj,
                                              const string source_method,
                                              double sl=0,
                                              double tp=0);
//--- Check if the funds are sufficient
   bool                 CheckMoneyFree(const ENUM_ORDER_TYPE order_type,const double volume,const double price,const CSymbol *symbol_obj,const string source_method) const;

//--- Set the following for symbol trading objects:
//--- (1) correct filling policy, (2) filling policy,
//--- (3) correct order expiration type, (4) order expiration type,
//--- (5) magic number, (6) comment, (7) slippage, (8) volume, (9) order expiration date,
//--- (10) the flag of asynchronous sending of a trading request, (11) logging level
   void                 SetCorrectTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol=NULL);
   void                 SetTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol=NULL);
   void                 SetCorrectTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol=NULL);
   void                 SetTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol=NULL);
   void                 SetMagic(const ulong magic,const string symbol=NULL);
   void                 SetComment(const string comment,const string symbol=NULL);
   void                 SetDeviation(const ulong deviation,const string symbol=NULL);
   void                 SetVolume(const double volume=0,const string symbol=NULL);
   void                 SetExpiration(const datetime expiration=0,const string symbol=NULL);
   void                 SetAsyncMode(const bool mode=false,const string symbol=NULL);
   void                 SetLogLevel(const ENUM_LOG_LEVEL log_level=LOG_LEVEL_ERROR_MSG,const string symbol=NULL);

//--- Set standard sounds (1 symbol=NULL) for trading objects of all symbols, (2 symbol!=NULL) for a symbol trading object
   void                 SetSoundsStandart(const string symbol=NULL);
//--- Set a sound for a specified order/position type and symbol
//--- 'mode' specifies an event a sound is set for
//--- (symbol=NULL) for trading objects of all symbols,
//--- (symbol!=NULL) for a trading object of a specified symbol
   void                 SetSound(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,const string symbol=NULL);

//--- Open (1) Buy, (2) Sell position
   bool                 OpenBuy(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL);
   bool                 OpenSell(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL);
//--- Modify a position
   bool                 ModifyPosition(const ulong ticket,const double sl=WRONG_VALUE,const double tp=WRONG_VALUE);
//--- Close a position (1) fully, (2) partially, (3) by an opposite one
   bool                 ClosePosition(const ulong ticket);
   bool                 ClosePositionPartially(const ulong ticket,const double volume);
   bool                 ClosePositionBy(const ulong ticket,const ulong ticket_by);
//--- Set (1) BuyStop, (2) BuyLimit, (3) BuyStopLimit pending order
   bool                 PlaceBuyStop(const double volume,
                                     const string symbol,
                                     const double price,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
   bool                 PlaceBuyLimit(const double volume,
                                     const string symbol,
                                     const double price,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
   bool                 PlaceBuyStopLimit(const double volume,
                                     const string symbol,
                                     const double price_stop,
                                     const double price_limit,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
//--- Set (1) SellStop, (2) SellLimit, (3) SellStopLimit pending order
   bool                 PlaceSellStop(const double volume,
                                     const string symbol,
                                     const double price,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
   bool                 PlaceSellLimit(const double volume,
                                     const string symbol,
                                     const double price,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
   bool                 PlaceSellStopLimit(const double volume,
                                     const string symbol,
                                     const double price_stop,
                                     const double price_limit,
                                     const double sl=0,
                                     const double tp=0,
                                     const ulong magic=ULONG_MAX,
                                     const string comment=NULL,
                                     const datetime expiration=0,
                                     const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
//--- Modify a pending order
   bool                 ModifyOrder(const ulong ticket,
                                    const double price=WRONG_VALUE,
                                    const double sl=WRONG_VALUE,
                                    const double tp=WRONG_VALUE,
                                    const double stoplimit=WRONG_VALUE,
                                    datetime expiration=WRONG_VALUE,
                                    ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE);
//--- Remove a pending order
   bool                 DeleteOrder(const ulong ticket);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrading::CTrading()
  {
   this.m_list_errors.Clear();
   this.m_list_errors.Sort();
   this.m_log_level=LOG_LEVEL_ALL_MSG;
  }
//+------------------------------------------------------------------+
//| Check trading limitations                                        |
//+------------------------------------------------------------------+
bool CTrading::CheckTradeConstraints(const double volume,
                                     const ENUM_ACTION_TYPE action_type,
                                     const CSymbol *symbol_obj,
                                     const string source_method,
                                     double sl=0,
                                     double tp=0)
  {
//--- the result of conducting all checks
   bool res=true;
//--- Clear the error list (codes of found limitations)
   this.m_list_errors.Clear();
   this.m_list_errors.Sort();

//--- Check connection with the trade server (not in the test mode)
   if(!::TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      if(!::MQLInfoInteger(MQL_TESTER))
        {
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_LIB_TEXT_TERMINAL_NOT_CONNECTED);
         res &=false;
        }
     }
//--- Check if trading is enabled for an account (if there is a connection with the trade server)
   else if(!this.m_account.TradeAllowed())
     {
      //--- add the error code to the list and write 'false' to the result
      this.AddErrorCodeToList(MSG_LIB_TEXT_ACCOUNT_NOT_TRADE_ENABLED);
      res &=false;
     }
//--- Check if trading is allowed for any EAs/scripts for the current account
   if(!this.m_account.TradeExpert())
     {
      //--- add the error code to the list and write 'false' to the result
      this.AddErrorCodeToList(MSG_LIB_TEXT_ACCOUNT_EA_NOT_TRADE_ENABLED);
      res &=false;
     }
//--- Check if auto trading is allowed in the terminal.
//--- AutoTrading button (Options --> Expert Advisors --> "Allowed automated trading")
   if(!::TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      //--- add the error code to the list and write 'false' to the result
      this.AddErrorCodeToList(MSG_LIB_TEXT_TERMINAL_NOT_TRADE_ENABLED);
      res &=false;
     }
//--- Check if auto trading is allowed for the current EA.
//--- (F7 --> Common --> Allow Automated Trading)
   if(!::MQLInfoInteger(MQL_TRADE_ALLOWED))
     {
      //--- add the error code to the list and write 'false' to the result
      this.AddErrorCodeToList(MSG_LIB_TEXT_EA_NOT_TRADE_ENABLED);
      res &=false;
     }
//--- Check if trading is enabled on a symbol.
//--- If trading is disabled, add the error code to the list and write 'false' to the result
   if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_DISABLED)
     {
      this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_DISABLED);
      res &=false;
     }

//--- If not closing/removal/modification
   if(action_type>WRONG_VALUE && action_type<ACTION_TYPE_CLOSE_BY)
     {
      //--- In case of close-only, add the error code to the list and write 'false' to the result
      if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_CLOSEONLY)
        {
         this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_CLOSEONLY);
         res &=false;
        }
      //--- Check the minimum volume
      if(volume<symbol_obj.LotsMin())
        {
         //--- The volume in a request is less than the minimum allowed one
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_LIB_TEXT_REQ_VOL_LESS_MIN_VOLUME);
         res &=false;
        }
      //--- Check the maximum volume
      else if(volume>symbol_obj.LotsMax())
        {
         //--- The volume in the request exceeds the maximum acceptable one
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_LIB_TEXT_REQ_VOL_MORE_MAX_VOLUME);
         res &=false;
        }
      //--- Check the minimum volume gradation
      double step=symbol_obj.LotsStep();
      if(fabs((int)round(volume/step)*step-volume)>0.0000001)
        {
         //--- The volume in the request is not a multiple of the minimum gradation of the lot change step
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_LIB_TEXT_INVALID_VOLUME_STEP);
         res &=false;
        }
     }

//--- When opening a position
   if(action_type>WRONG_VALUE && action_type<ACTION_TYPE_BUY_LIMIT)
     {
      //--- Check if sending market orders is allowed on a symbol.
      //--- If trading market orders is disabled, add the error code to the list and write 'false' to the result
      if(!symbol_obj.IsMarketOrdersAllowed())
        {
         this.AddErrorCodeToList(MSG_SYM_MARKET_ORDER_DISABLED);
         res &=false;
        }
     }
//--- When placing a pending order
   else if(action_type>ACTION_TYPE_SELL && action_type<ACTION_TYPE_CLOSE_BY)
     {
      //--- If there is a limitation on the number of pending orders on the account
      //--- and placing a new order exceeds the acceptable number
      if(this.m_account.LimitOrders()>0 && this.OrdersTotalAll()+1 > this.m_account.LimitOrders())
        {
         //--- The maximum number of pending orders is reached
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(10033);
         res &=false;
        }  
      //--- Check if placing limit orders is allowed on a symbol.
      if(action_type==ACTION_TYPE_BUY_LIMIT || action_type==ACTION_TYPE_SELL_LIMIT)
        {
         //--- If it is not, add the error code to the list and write 'false' to the result
         if(!symbol_obj.IsLimitOrdersAllowed())
           {
            this.AddErrorCodeToList(MSG_SYM_LIMIT_ORDER_DISABLED);
            res &=false;
           }
        }
      //--- Check if placing stop orders is allowed on a symbol.
      else if(action_type==ACTION_TYPE_BUY_STOP || action_type==ACTION_TYPE_SELL_STOP)
        {
         //--- If placing stop orders is disabled, add the error code to the list and write 'false' to the result
         if(!symbol_obj.IsStopOrdersAllowed())
           {
            this.AddErrorCodeToList(MSG_SYM_STOP_ORDER_DISABLED);
            res &=false;
           }
        }
      //--- For MQL5, check if placing stop limit orders is allowed on a symbol.
      #ifdef __MQL5__
      else if(action_type==ACTION_TYPE_BUY_STOP_LIMIT || action_type==ACTION_TYPE_SELL_STOP_LIMIT)
        {
         //--- If it is not, add the error code to the list and write 'false' to the result
         if(!symbol_obj.IsStopLimitOrdersAllowed())
           {
            this.AddErrorCodeToList(MSG_SYM_STOP_LIMIT_ORDER_DISABLED);
            res &=false;
           }
        }
      #endif 
     }

//--- In case of opening/placing/modification
   if(action_type>WRONG_VALUE && action_type!=ACTION_TYPE_CLOSE_BY)
     {
      //--- If not modification
      if(action_type!=ACTION_TYPE_MODIFY)
        {
         //--- When buying, check if long trading is enabled on a symbol
         if(this.DirectionByActionType(action_type)==ORDER_TYPE_BUY)
           {
            //--- If only selling is allowed, add the error code to the list and write 'false' to the result
            if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_SHORTONLY)
              {
               this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_SHORTONLY);
               res &=false;
              }
            //--- If a symbol has the limitation on the total volume of an open position and pending orders in the same direction   
            if(symbol_obj.VolumeLimit()>0)
              {
               //--- (If the total volume of placed long orders and open long positions)+open volume exceed the maximum one
               if(this.OrdersTotalVolumeLong()+this.PositionsTotalVolumeLong()+volume > symbol_obj.VolumeLimit())
                 {
                  //--- Exceeded maximum allowed aggregate volume of orders and positions in one direction
                  //--- add the error code to the list and write 'false' to the result
                  this.AddErrorCodeToList(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED);
                  res &=false;
                 }
              }
           }
         //--- When selling, check if short trading is enabled on a symbol
         else if(this.DirectionByActionType(action_type)==ORDER_TYPE_SELL)
           {
            //--- If only buying is allowed, add the error code to the list and write 'false' to the result
            if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_LONGONLY)
              {
               this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_LONGONLY);
               res &=false;
              }
            //--- If a symbol has the limitation on the total volume of an open position and pending orders in the same direction   
            if(symbol_obj.VolumeLimit()>0)
              {
               //--- (If the total volume of placed short orders and open short positions)+open volume exceed the maximum one
               if(this.OrdersTotalVolumeShort()+this.PositionsTotalVolumeShort()+volume > symbol_obj.VolumeLimit())
                 {
                  //--- Exceeded maximum allowed aggregate volume of orders and positions in one direction
                  //--- add the error code to the list and write 'false' to the result
                  this.AddErrorCodeToList(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED);
                  res &=false;
                 }
              }
           }
        }
      //--- If the request features StopLoss and its placing is not allowed
      if(sl>0 && !symbol_obj.IsStopLossOrdersAllowed())
        {
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_SYM_SL_ORDER_DISABLED);
         res &=false;
        }
      //--- If the request features TakeProfit and its placing is not allowed
      if(tp>0 && !symbol_obj.IsTakeProfitOrdersAllowed())
        {
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_SYM_TP_ORDER_DISABLED);
         res &=false;
        }
     }

//--- When closing by an opposite position
   else if(action_type==ACTION_TYPE_CLOSE_BY)
     {
      //--- When closing by an opposite position is disabled
      if(!symbol_obj.IsCloseByOrdersAllowed())
        {
         //--- add the error code to the list and write 'false' to the result
         this.AddErrorCodeToList(MSG_LIB_TEXT_CLOSE_BY_ORDERS_DISABLED);
         res &=false;
        }
     }

//--- If there are limitations, display the header and the error list
   if(!res)
     {
      //--- Request was rejected before sending to the server due to:
      int total=this.m_list_errors.Total();
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
        {
         //--- For MQL5, first display the list header followed by the error list
         #ifdef __MQL5__
         ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_REQUEST_REJECTED_DUE));
         for(int i=0;i<total;i++)
            ::Print((total>1 ? string(i+1)+". " : ""),CMessage::Text(m_list_errors.At(i)));
         //--- For MQL4, the journal messages are displayed in the reverse order: the error list is followed by the list header
         #else    
         for(int i=total-1;i>WRONG_VALUE;i--)
            ::Print((total>1 ? string(i+1)+". " : ""),CMessage::Text(m_list_errors.At(i)));
         ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_REQUEST_REJECTED_DUE));
         #endif 
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//| Check if the funds are sufficient                                |
//+------------------------------------------------------------------+
bool CTrading::CheckMoneyFree(const ENUM_ORDER_TYPE order_type,const double volume,const double price,const CSymbol *symbol_obj,const string source_method) const
  {
   ::ResetLastError();
   //--- Get the type of a market order by a trading operation type
   ENUM_ORDER_TYPE action=this.DirectionByActionType((ENUM_ACTION_TYPE)order_type);
   //--- Get the value of free funds to be left after conducting a trading operation
   double money_free=
     (
      //--- For MQL5, calculate the difference between free funds and the funds required to conduct a trading operation
      #ifdef __MQL5__  this.m_account.MarginFree()-this.m_account.MarginForAction(action,symbol_obj.Name(),volume,price)
      //--- For MQL4, use the operation result of the standard function returning the amount of funds left
      #else/*__MQL4__*/::AccountFreeMarginCheck(symbol_obj.Name(),order_type,volume) #endif 
     );
   //--- If no free funds are left, inform of that and return 'false'
   if(money_free<=0 #ifdef __MQL4__ || ::GetLastError()==134 #endif )
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
        {
         //--- create a message text
         string message=
           (
            symbol_obj.Name()+" "+::DoubleToString(volume,symbol_obj.DigitsLot())+" "+
            (
             order_type>ORDER_TYPE_SELL ? OrderTypeDescription(order_type,false,false) : 
             PositionTypeDescription(PositionTypeByOrderType(order_type))
            )+" ("+::DoubleToString(money_free,(int)this.m_account.CurrencyDigits())+")"
           );
         //--- display a journal message
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_NOT_ENOUTH_MONEY_FOR),message);
        }
      return false;
     }
   //--- Verification successful
   return true;
  }
//+------------------------------------------------------------------+
//| Return the number of positions                                   |
//+------------------------------------------------------------------+
int CTrading::PositionsTotalAll(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Return the number of buy positions                               |
//+------------------------------------------------------------------+
int CTrading::PositionsTotalLong(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Return the number of sell positions                              |
//+------------------------------------------------------------------+
int CTrading::PositionsTotalShort(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Returns the number of pending orders                             |
//+------------------------------------------------------------------+
int CTrading::OrdersTotalAll(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Return the number of buy pending orders                          |
//+------------------------------------------------------------------+
int CTrading::OrdersTotalLong(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_BUY,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Return the number of sell pending orders                         |
//+------------------------------------------------------------------+
int CTrading::OrdersTotalShort(void) const
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_SELL,EQUAL);
   return(list==NULL ? 0 : list.Total());
  }
//+------------------------------------------------------------------+
//| Return the total volume of buy positions                         |
//+------------------------------------------------------------------+
double CTrading::PositionsTotalVolumeLong(void) const
  {
   double vol=0;
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
   if(list==NULL || list.Total()==0)
      return 0;
   for(int i=0;i<list.Total();i++)
     {
      COrder *obj=list.At(i);
      if(obj==NULL)
         continue;
      vol+=obj.Volume();
     }
   return vol;
  }
//+------------------------------------------------------------------+
//| Return the total volume of sell positions                        |
//+------------------------------------------------------------------+
double CTrading::PositionsTotalVolumeShort(void) const
  {
   double vol=0;
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
   if(list==NULL || list.Total()==0)
      return 0;
   for(int i=0;i<list.Total();i++)
     {
      COrder *obj=list.At(i);
      if(obj==NULL)
         continue;
      vol+=obj.Volume();
     }
   return vol;
  }
//+------------------------------------------------------------------+
//| Return the total volume of buy orders                            |
//+------------------------------------------------------------------+
double CTrading::OrdersTotalVolumeLong(void) const
  {
   double vol=0;
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_BUY,EQUAL);
   if(list==NULL || list.Total()==0)
      return 0;
   for(int i=0;i<list.Total();i++)
     {
      COrder *obj=list.At(i);
      if(obj==NULL)
         continue;
      vol+=obj.Volume();
     }
   return vol;
  }
//+------------------------------------------------------------------+
//| Return the total volume of sell orders                           |
//+------------------------------------------------------------------+
double CTrading::OrdersTotalVolumeShort(void) const
  {
   double vol=0;
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_SELL,EQUAL);
   if(list==NULL || list.Total()==0)
      return 0;
   for(int i=0;i<list.Total();i++)
     {
      COrder *obj=list.At(i);
      if(obj==NULL)
         continue;
      vol+=obj.Volume();
     }
   return vol;
  }
//+------------------------------------------------------------------+
//| Return the order direction by an operation type                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CTrading::DirectionByActionType(ENUM_ACTION_TYPE action) const
  {
   if(action>ACTION_TYPE_SELL_STOP_LIMIT)
      return WRONG_VALUE;
   return ENUM_ORDER_TYPE(action%2);
  }
//+------------------------------------------------------------------+
//| Add the error code to the list                                   |
//+------------------------------------------------------------------+
bool CTrading::AddErrorCodeToList(const int error_code)
  {
   this.m_list_errors.Sort();
   if(this.m_list_errors.Search(error_code)==WRONG_VALUE)
      return this.m_list_errors.Add(error_code);
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol object by a position ticket                      |
//+------------------------------------------------------------------+
CSymbol *CTrading::GetSymbolObjByPosition(const ulong ticket,const string source_method)
  {
   //--- Get the list of open positions
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   //--- If failed to get the list of open positions, display the message and return NULL
   if(list==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_ENG_FAILED_GET_MARKET_POS_LIST));
      return NULL;
     }
   //--- If the list is empty (no open positions), display the message and return NULL
   if(list.Total()==0)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(source_method,CMessage::Text(MSG_ENG_NO_OPEN_POSITIONS));
      return NULL;
     }
   //--- Sort the list by a ticket 
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   //--- If failed to get the list of open positions, display the message and return NULL
   if(list==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_ENG_FAILED_GET_MARKET_POS_LIST));
      return NULL;
     }
   //--- If the list is empty (no required ticket), display the message and return NULL
   if(list.Total()==0)
     {
      //--- Error. No open position with #ticket
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(source_method,CMessage::Text(MSG_LIB_SYS_ERROR_NO_OPEN_POSITION_WITH_TICKET),(string)ticket);
      return NULL;
     }
   //--- Get a position with #ticket from the obtained list
   COrder *pos=list.At(0);
   //--- If failed to get the position object, display the message and return NULL
   if(pos==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_POS_OBJ));
      return NULL;
     }
   //--- Get a symbol object by name
   CSymbol * symbol_obj=this.m_symbols.GetSymbolObjByName(pos.Symbol());
   //--- If failed to get the symbol object, display the message and return NULL
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return NULL;
     }
   //--- Return a symbol object
   return symbol_obj;
  }
//+------------------------------------------------------------------+
//| Return a symbol object by an order ticket                        |
//+------------------------------------------------------------------+
CSymbol *CTrading::GetSymbolObjByOrder(const ulong ticket,const string source_method)
  {
   //--- Get the list of placed orders
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   //--- If failed to get the list of placed orders, display the message and return NULL
   if(list==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_ENG_FAILED_GET_PENDING_ORD_LIST));
      return NULL;
     }
   //--- If the list is empty (no placed orders), display the message and return NULL
   if(list.Total()==0)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(source_method,CMessage::Text(MSG_ENG_NO_PLACED_ORDERS));
      return NULL;
     }
   //--- Sort the list by a ticket 
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   //--- If failed to get the list of placed orders, display the message and return NULL
   if(list==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_ENG_FAILED_GET_PENDING_ORD_LIST));
      return NULL;
     }
   //--- If the list is empty (no required ticket), display the message and return NULL
   if(list.Total()==0)
     {
      //--- Error. No placed order with #ticket
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(source_method,CMessage::Text(MSG_LIB_SYS_ERROR_NO_PLACED_ORDER_WITH_TICKET),(string)ticket);
      return NULL;
     }
   //--- Get an order with #ticket from the obtained list
   COrder *ord=list.At(0);
   //--- If failed to get an object order, display the message and return NULL
   if(ord==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return NULL;
     }
   //--- Get a symbol object by name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(ord.Symbol());
   //--- If failed to get the symbol object, display the message and return NULL
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return NULL;
     }
   //--- Return a symbol object
   return symbol_obj;
  }
//+------------------------------------------------------------------+
//| Return a symbol trading object by a position ticket              |
//+------------------------------------------------------------------+
CTradeObj *CTrading::GetTradeObjByPosition(const ulong ticket,const string source_method)
  {
   //--- Get a symbol object by a position ticket
   CSymbol * symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return NULL
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return NULL;
     }
   //--- Get and return the trading object from the symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   return trade_obj;
  }
//+------------------------------------------------------------------+
//| Return a symbol trading object by an order ticket                |
//+------------------------------------------------------------------+
CTradeObj *CTrading::GetTradeObjByOrder(const ulong ticket,const string source_method)
  {
   //--- Get a symbol object by an order ticket
   CSymbol * symbol_obj=this.GetSymbolObjByOrder(ticket,source_method);
   //--- If failed to get the symbol object, display the message and return NULL
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return NULL;
     }
   //--- Get and return the trading object from the symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   return trade_obj;
  }
//+------------------------------------------------------------------+
//| Return a symbol trading object by a symbol name                  |
//+------------------------------------------------------------------+
CTradeObj *CTrading::GetTradeObjBySymbol(const string symbol,const string source_method)
  {
   //--- Get a symbol object by its name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return NULL
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_NOT_SYMBOL_ON_LIST));
      return NULL;
     }
   //--- Get and return the trading object from the symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   return trade_obj;
  }
//+------------------------------------------------------------------+
//| Check if a position is present by ticket                         |
//+------------------------------------------------------------------+
bool CTrading::CheckPositionAvailablity(const ulong ticket,const string source_method)
  {
   CArrayObj* list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   list.Sort(SORT_BY_ORDER_TICKET);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   if(list.Total()==1)
      return true;
   if(this.m_log_level>LOG_LEVEL_NO_MSG)
      ::Print(source_method,CMessage::Text(MSG_LIB_SYS_ERROR_NO_OPEN_POSITION_WITH_TICKET),(string)ticket);
   return false;
  }
//+------------------------------------------------------------------+
//| Check the presence of an order by ticket                         |
//+------------------------------------------------------------------+
bool CTrading::CheckOrderAvailablity(const ulong ticket,const string source_method)
  {
   CArrayObj* list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   list.Sort(SORT_BY_ORDER_TICKET);
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   if(list.Total()==1)
      return true;
   if(this.m_log_level>LOG_LEVEL_NO_MSG)
      ::Print(source_method,CMessage::Text(MSG_LIB_SYS_ERROR_NO_PLACED_ORDER_WITH_TICKET),(string)ticket);
   return false;
  }
//+------------------------------------------------------------------+
//| Set the valid filling policy                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetCorrectTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol=NULL)
  {
   //--- Declare the empty pointer to a symbol object
   CSymbol *symbol_obj=NULL;
   //--- If a symbol name passed in the method inputs is not set, specify a valid filling policy for all symbols
   if(symbol==NULL)
     {
      //--- get the list of all used symbols
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      //--- In a loop by the list of symbol objects
      for(int i=0;i<total;i++)
        {
         //--- get the next symbol object
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         //--- get a trading object from a symbol object 
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         //--- set correct filling policy to the trading object (the default is "fill or kill", or a supported one)
         trade_obj.SetTypeFilling(symbol_obj.GetCorrectTypeFilling(type));
        }
     }
   //--- If a symbol name is specified in the method inputs, set the filling policy only for the specified symbol
   else
     {
      //--- Get a symbol object by a symbol name
      symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
      if(symbol_obj==NULL)
         return;
      //--- get a trading object from a symbol object 
      CTradeObj *trade_obj=symbol_obj.GetTradeObj();
      if(trade_obj==NULL)
         return;
      //--- set correct filling policy to the trading object (the default is "fill or kill", or a supported one)
      trade_obj.SetTypeFilling(symbol_obj.GetCorrectTypeFilling(type));
     }
  }
//+------------------------------------------------------------------+
//| Set the filling policy                                           |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol=NULL)
  {
   //--- Declare the empty pointer to a symbol object
   CSymbol *symbol_obj=NULL;
   //--- If a symbol name passed in the method inputs is not set, specify a filling policy for all symbols
   if(symbol==NULL)
     {
      //--- get the list of all used symbols
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      //--- In a loop by the list of symbol objects
      for(int i=0;i<total;i++)
        {
         //--- get the next symbol object
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         //--- get a trading object from a symbol object 
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         //--- for the trading object, set a filling policy passed to the method in the inputs (the default is "fill or kill")
         trade_obj.SetTypeFilling(type);
        }
     }
   //--- If a symbol name is specified in the method inputs, set the filling policy only for the specified symbol
   else
     {
      //--- get a trading object by a symbol name
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      //--- for the trading object, set a filling policy passed to the method in the inputs (the default is "fill or kill")
      trade_obj.SetTypeFilling(type);
     }
  }
//+------------------------------------------------------------------+
//| Set a correct order expiration type                              |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetCorrectTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetTypeExpiration(symbol_obj.GetCorrectTypeExpiration(type));
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetTypeExpiration(symbol_obj.GetCorrectTypeExpiration(type));
     }
  }
//+------------------------------------------------------------------+
//| Set an order expiration type                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetTypeExpiration(type);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetTypeExpiration(type);
     }
  }
//+------------------------------------------------------------------+
//| Set a magic number for trading objects of all symbols            |
//+------------------------------------------------------------------+
void CTrading::SetMagic(const ulong magic,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetMagic(magic);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetMagic(magic);
     }
  }
//+------------------------------------------------------------------+
//| Set a comment for trading objects of all symbols                 |
//+------------------------------------------------------------------+
void CTrading::SetComment(const string comment,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetComment(comment);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetComment(comment);
     }
  }
//+------------------------------------------------------------------+
//| Set a slippage                                                   |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetDeviation(const ulong deviation,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetDeviation(deviation);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetDeviation(deviation);
     }
  }
//+------------------------------------------------------------------+
//| Set a volume for trading objects of all symbols                  |
//+------------------------------------------------------------------+
void CTrading::SetVolume(const double volume=0,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetVolume(volume!=0 ? symbol_obj.NormalizedLot(volume) : symbol_obj.LotsMin());
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetVolume(volume!=0 ? symbol_obj.NormalizedLot(volume) : symbol_obj.LotsMin());
     }
  }
//+------------------------------------------------------------------+
//| Set an order expiration date                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetExpiration(const datetime expiration=0,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetExpiration(expiration);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetExpiration(expiration);
     }
  }
//+------------------------------------------------------------------+
//| Set the flag of asynchronous sending of trading requests         |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetAsyncMode(const bool mode=false,const string symbol=NULL)
  {
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetAsyncMode(mode);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetAsyncMode(mode);
     }
  }
//+------------------------------------------------------------------+
//| Set a logging level of trading requests                          |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetLogLevel(const ENUM_LOG_LEVEL log_level=LOG_LEVEL_ERROR_MSG,const string symbol=NULL)
  {
   this.m_log_level=log_level;
   CSymbol *symbol_obj=NULL;
   if(symbol==NULL)
     {
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         trade_obj.SetLogLevel(log_level);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetLogLevel(log_level);
     }
  }
//+------------------------------------------------------------------+
//| Set standard sounds for a symbol trading object                  |
//+------------------------------------------------------------------+
void CTrading::SetSoundsStandart(const string symbol=NULL)
  {
   //--- Declare an empty symbol object
   CSymbol *symbol_obj=NULL;
   //--- If NULL is passed as a symbol name, set sounds for trading objects of all symbols
   if(symbol==NULL)
     {
      //--- Get the symbol list
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      //--- In a loop by the list of symbols
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         //--- get the next symbol object
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         //--- get a symbol trading object
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         //--- set standard sounds for a trading object
         trade_obj.SetSoundsStandart();
        }
     }
   //--- If a symbol name is passed
   else
     {
      //--- get a symbol trading object
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      //--- set standard sounds for a trading object
      trade_obj.SetSoundsStandart();
     }
  }
//+------------------------------------------------------------------+
//| Set a sound for a specified order/position type and symbol       |
//| 'mode' specifies an event a sound is set for                     |
//| (symbol=NULL) for trading objects of all symbols,                |
//| (symbol!=NULL) for a trading object of a specified symbol        |
//+------------------------------------------------------------------+
void CTrading::SetSound(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,const string symbol=NULL)
  {
   //--- Declare an empty symbol object
   CSymbol *symbol_obj=NULL;
   //--- If NULL is passed as a symbol name, set sounds for trading objects of all symbols
   if(symbol==NULL)
     {
      //--- Get the symbol list
      CArrayObj *list=this.m_symbols.GetList();
      if(list==NULL || list.Total()==0)
         return;
      //--- In a loop by the list of symbols
      int total=list.Total();
      for(int i=0;i<total;i++)
        {
         //--- get the next symbol object
         symbol_obj=list.At(i);
         if(symbol_obj==NULL)
            continue;
         //--- get a symbol trading object
         CTradeObj *trade_obj=symbol_obj.GetTradeObj();
         if(trade_obj==NULL)
            continue;
         //--- set a sound of a necessary event for a trading object
         this.SetSoundByMode(mode,action,sound,trade_obj);
        }
     }
   //--- If a symbol name is passed
   else
     {
      //--- get a symbol trading object
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      //--- set a sound of a necessary event for a trading object
      this.SetSoundByMode(mode,action,sound,trade_obj);
     }
  }
//+------------------------------------------------------------------+
//| Set a necessary sound to a trading object                        |
//+------------------------------------------------------------------+
void CTrading::SetSoundByMode(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,CTradeObj *trade_obj)
  {
   switch(mode)
     {
      case MODE_SET_SOUND_OPEN               : trade_obj.SetSoundOpen(action,sound);               break;
      case MODE_SET_SOUND_CLOSE              : trade_obj.SetSoundClose(action,sound);              break;
      case MODE_SET_SOUND_MODIFY_SL          : trade_obj.SetSoundModifySL(action,sound);           break;
      case MODE_SET_SOUND_MODIFY_TP          : trade_obj.SetSoundModifyTP(action,sound);           break;
      case MODE_SET_SOUND_MODIFY_PRICE       : trade_obj.SetSoundModifyPrice(action,sound);        break;
      case MODE_SET_SOUND_ERROR_OPEN         : trade_obj.SetSoundErrorOpen(action,sound);          break;
      case MODE_SET_SOUND_ERROR_CLOSE        : trade_obj.SetSoundErrorClose(action,sound);         break;
      case MODE_SET_SOUND_ERROR_MODIFY_SL    : trade_obj.SetSoundErrorModifySL(action,sound);      break;
      case MODE_SET_SOUND_ERROR_MODIFY_TP    : trade_obj.SetSoundErrorModifyTP(action,sound);      break;
      case MODE_SET_SOUND_ERROR_MODIFY_PRICE : trade_obj.SetSoundErrorModifyPrice(action,sound);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
bool CTrading::OpenBuy(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_BUY,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
//--- If the funds are insufficient, inform of that and exit
   if(!this.CheckMoneyFree(ORDER_TYPE_BUY,volume,symbol_obj.Ask(),symbol_obj,DFUN))
     {
      return false;
     }

//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.OpenPosition(POSITION_TYPE_BUY,volume,sl,tp,magic,trade_obj.GetDeviation(),comment);
  }
//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
bool CTrading::OpenSell(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_SELL,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- If the funds are insufficient, inform of that and exit
   if(!this.CheckMoneyFree(ORDER_TYPE_SELL,volume,symbol_obj.Bid(),symbol_obj,DFUN))
     {
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.OpenPosition(POSITION_TYPE_SELL,volume,sl,tp,magic,trade_obj.GetDeviation(),comment);
  }
//+------------------------------------------------------------------+
//| Modify a position                                                |
//+------------------------------------------------------------------+
bool CTrading::ModifyPosition(const ulong ticket,const double sl=WRONG_VALUE,const double tp=WRONG_VALUE)
  {
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,ACTION_TYPE_MODIFY,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.ModifyPosition(ticket,sl,tp);
  }
//+------------------------------------------------------------------+
//| Close a position in full                                         |
//+------------------------------------------------------------------+
bool CTrading::ClosePosition(const ulong ticket)
  {
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,WRONG_VALUE,symbol_obj,DFUN))
     {
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.ClosePosition(ticket);
  }
//+------------------------------------------------------------------+
//| Close a position partially                                       |
//+------------------------------------------------------------------+
bool CTrading::ClosePositionPartially(const ulong ticket,const double volume)
  {
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,WRONG_VALUE,symbol_obj,DFUN))
     {
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.ClosePositionPartially(ticket,symbol_obj.NormalizedLot(volume));
  }
//+------------------------------------------------------------------+
//| Close a position by an opposite one                              |
//+------------------------------------------------------------------+
bool CTrading::ClosePositionBy(const ulong ticket,const ulong ticket_by)
  {
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,ACTION_TYPE_CLOSE_BY,symbol_obj,DFUN))
     {
      return false;
     }
   //--- trading object of a closed position
   CTradeObj *trade_obj_pos=this.GetTradeObjByPosition(ticket,DFUN);
   if(trade_obj_pos==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- check the presence of an opposite position
   if(!this.CheckPositionAvailablity(ticket_by,DFUN))
      return false;
   //--- trading object of an opposite position
   CTradeObj *trade_obj_pos_by=this.GetTradeObjByPosition(ticket_by,DFUN);
   if(trade_obj_pos_by==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- If a symbol of a closed position is not equal to an opposite position's one, inform of that and exit
   if(symbol_obj.Name()!=trade_obj_pos_by.GetSymbol())
     {
      //--- Symbols of opposite positions are not equal
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_TEXT_CLOSE_BY_SYMBOLS_UNEQUAL));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj_pos.ClosePositionBy(ticket,ticket_by);
  }
//+------------------------------------------------------------------+
//| Place BuyStop pending order                                      |
//+------------------------------------------------------------------+
bool CTrading::PlaceBuyStop(const double volume,
                           const string symbol,
                           const double price,
                           const double sl=0,
                           const double tp=0,
                           const ulong magic=WRONG_VALUE,
                           const string comment=NULL,
                           const datetime expiration=0,
                           const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_BUY_STOP,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.SetOrder(ORDER_TYPE_BUY_STOP,volume,price,sl,tp,0,magic,expiration,type_time,comment);
  }
//+------------------------------------------------------------------+
//| Place BuyLimit pending order                                     |
//+------------------------------------------------------------------+
bool CTrading::PlaceBuyLimit(const double volume,
                            const string symbol,
                            const double price,
                            const double sl=0,
                            const double tp=0,
                            const ulong magic=WRONG_VALUE,
                            const string comment=NULL,
                            const datetime expiration=0,
                            const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_BUY_LIMIT,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.SetOrder(ORDER_TYPE_BUY_LIMIT,volume,price,sl,tp,0,magic,expiration,type_time,comment);
  }
//+------------------------------------------------------------------+
//| Place BuyStopLimit pending order                                 |
//+------------------------------------------------------------------+
bool CTrading::PlaceBuyStopLimit(const double volume,
                                const string symbol,
                                const double price_stop,
                                const double price_limit,
                                const double sl=0,
                                const double tp=0,
                                const ulong magic=WRONG_VALUE,
                                const string comment=NULL,
                                const datetime expiration=0,
                                const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_BUY_STOP_LIMIT,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   #ifdef __MQL5__
      //--- get a trading object from a symbol object
      CTradeObj *trade_obj=symbol_obj.GetTradeObj();
      if(trade_obj==NULL)
        {
         //--- Error. Failed to get trading object
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
         return false;
        }
      //--- Return the result of sending a trading request in a symbol trading object
      return trade_obj.SetOrder(ORDER_TYPE_BUY_STOP_LIMIT,volume,price_stop,sl,tp,price_limit,magic,expiration,type_time,comment);
   //--- MQL4
   #else 
      return true;
   #endif 
  }
//+------------------------------------------------------------------+
//| Place SellStop pending order                                     |
//+------------------------------------------------------------------+
bool CTrading::PlaceSellStop(const double volume,
                            const string symbol,
                            const double price,
                            const double sl=0,
                            const double tp=0,
                            const ulong magic=WRONG_VALUE,
                            const string comment=NULL,
                            const datetime expiration=0,
                            const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_SELL_STOP,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.SetOrder(ORDER_TYPE_SELL_STOP,volume,price,sl,tp,0,magic,expiration,type_time,comment);
  }
//+------------------------------------------------------------------+
//| Place SellLimit pending order                                    |
//+------------------------------------------------------------------+
bool CTrading::PlaceSellLimit(const double volume,
                             const string symbol,
                             const double price,
                             const double sl=0,
                             const double tp=0,
                             const ulong magic=WRONG_VALUE,
                             const string comment=NULL,
                             const datetime expiration=0,
                             const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_SELL_LIMIT,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.SetOrder(ORDER_TYPE_SELL_LIMIT,volume,price,sl,tp,0,magic,expiration,type_time,comment);
  }
//+------------------------------------------------------------------+
//| Place SellStopLimit pending order                                |
//+------------------------------------------------------------------+
bool CTrading::PlaceSellStopLimit(const double volume,
                                 const string symbol,
                                 const double price_stop,
                                 const double price_limit,
                                 const double sl=0,
                                 const double tp=0,
                                 const ulong magic=WRONG_VALUE,
                                 const string comment=NULL,
                                 const datetime expiration=0,
                                 const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(volume,ACTION_TYPE_SELL_STOP_LIMIT,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   #ifdef __MQL5__
      //--- get a trading object from a symbol object
      CTradeObj *trade_obj=symbol_obj.GetTradeObj();
      if(trade_obj==NULL)
        {
         //--- Error. Failed to get trading object
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
         return false;
        }
      //--- Return the result of sending a trading request in a symbol trading object
      return trade_obj.SetOrder(ORDER_TYPE_SELL_STOP_LIMIT,volume,price_stop,sl,tp,price_limit,magic,expiration,type_time,comment);
   //--- MQL4
   #else 
      return true;
   #endif 
  }
//+------------------------------------------------------------------+
//| Modify a pending order                                           |
//+------------------------------------------------------------------+
bool CTrading::ModifyOrder(const ulong ticket,
                          const double price=WRONG_VALUE,
                          const double sl=WRONG_VALUE,
                          const double tp=WRONG_VALUE,
                          const double stoplimit=WRONG_VALUE,
                          datetime expiration=WRONG_VALUE,
                          ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE)
  {
//--- Get a symbol object by an order ticket
   CSymbol *symbol_obj=this.GetSymbolObjByOrder(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,ACTION_TYPE_MODIFY,symbol_obj,DFUN,sl,tp))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.ModifyOrder(ticket,price,sl,tp,stoplimit,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Remove a pending order                                           |
//+------------------------------------------------------------------+
bool CTrading::DeleteOrder(const ulong ticket)
  {
//--- Get a symbol object by an order ticket
   CSymbol *symbol_obj=this.GetSymbolObjByOrder(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Update symbol quotes
   symbol_obj.RefreshRates();
//--- If there are trading limitations, inform of that and exit
   if(!this.CheckTradeConstraints(0,WRONG_VALUE,symbol_obj,DFUN))
     {
      return false;
     }
   //--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      //--- Error. Failed to get trading object
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return trade_obj.DeleteOrder(ticket);
  }
//+------------------------------------------------------------------+
