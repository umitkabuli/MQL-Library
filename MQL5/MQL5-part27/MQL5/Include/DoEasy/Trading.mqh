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
//| Pending request object class                                     |
//+------------------------------------------------------------------+
class CPendingReq : public CObject
  {
private:
   MqlTradeRequest      m_request;                       // Trading request structure
   uchar                m_id;                            // Trading request ID
   int                  m_type;                          // Pending request type
   int                  m_retcode;                       // Result a request is based on
   double               m_price_create;                  // Price at the moment of a request generation
   ulong                m_time_create;                   // Request generation time
   ulong                m_time_activate;                 // Next attempt activation time
   ulong                m_waiting_msc;                   // Waiting time between requests
   uchar                m_current_attempt;               // Current attempt index
   uchar                m_total_attempts;                // Number of attempts
//--- Copy trading request data
   void                 CopyRequest(const MqlTradeRequest &request)  { this.m_request=request;        }
//--- Compare CPendingReq objects by IDs
   virtual int          Compare(const CObject *node,const int mode=0) const;

public:
//--- Return (1) the request structure, (2) the price at the moment of the request generation,
//--- (3) request generation time, (4) current attempt time,
//--- (5) waiting time between requests, (6) current attempt index,
//--- (7) number of attempts, (8) request ID
   MqlTradeRequest      MqlRequest(void)                       const { return this.m_request;         }
   double               PriceCreate(void)                      const { return this.m_price_create;    }
   ulong                TimeCreate(void)                       const { return this.m_time_create;     }
   ulong                TimeActivate(void)                     const { return this.m_time_activate;   }
   ulong                WaitingMSC(void)                       const { return this.m_waiting_msc;     }
   uchar                CurrentAttempt(void)                   const { return this.m_current_attempt; }
   uchar                TotalAttempts(void)                    const { return this.m_total_attempts;  }
   uchar                ID(void)                               const { return this.m_id;              }
   int                  Retcode(void)                          const { return this.m_retcode;         }
//--- Set (1) the price when creating a request, (2) request creation time,
//--- (3) current attempt time, (4) waiting time between requests,
//--- (5) current attempt index, (6) number of attempts, (7) request ID
   void                 SetPriceCreate(const double price)           { this.m_price_create=price;     }
   void                 SetTimeCreate(const ulong time)              { this.m_time_create=time;       }
   void                 SetTimeActivate(const ulong time)            { this.m_time_activate=time;     }
   void                 SetWaitingMSC(const ulong miliseconds)       { this.m_waiting_msc=miliseconds;}
   void                 SetCurrentAttempt(const uchar number)        { this.m_current_attempt=number; }
   void                 SetTotalAttempts(const uchar number)         { this.m_total_attempts=number;  }
   void                 SetID(const uchar id)                        { this.m_id=id;                  }
   
//--- Return the description of the (1) request structure, (2) the price at the moment of the request generation,
//--- (3) request generation time, (4) current attempt time,
//--- (5) waiting time between requests, (6) current attempt index,
//--- (7) number of attempts, (8) request ID
   string               MqlRequestDescription(void)            const { return RequestActionDescription(this.m_request); }
   string               TypeDescription(void)                  const
                          { 
                           return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TYPE) +
                             (this.Type()==PENDING_REQUEST_ID_TYPE_ERR           ?
                              CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_BY_ERROR) :
                              CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_BY_REQUEST)
                             );
                          }
   string               PriceCreateDescription(void)           const 
                          {
                           return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_PRICE_CREATE)+": "+
                                  ::DoubleToString(this.PriceCreate(),(int)::SymbolInfoInteger(this.m_request.symbol,SYMBOL_DIGITS));
                          }
   string               TimeCreateDescription(void)            const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TIME_CREATE)+TimeMSCtoString(this.TimeCreate());    }
   string               TimeActivateDescription(void)          const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TIME_ACTIVATE)+TimeMSCtoString(this.TimeActivate());}
   string               WaitingMSCDescription(void)            const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_WAITING)+(string)this.WaitingMSC();                 }
   string               CurrentAttemptDescription(void)        const 
                          {
                           return
                             (CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_CURRENT_ATTEMPT)+
                              (this.CurrentAttempt()==0 ? CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_WAITING_ONSET) : (string)this.CurrentAttempt())
                             );
                          }
   string               TotalAttemptsDescription(void)         const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TOTAL_ATTEMPTS)+(string)this.TotalAttempts();       }
   string               IdDescription(void)                    const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ID)+(string)this.ID();                              }
   string               RetcodeDescription(void)               const { return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_RETCODE)+(string)this.Retcode();                    }
   string               ReasonDescription(void)                const { return CMessage::Text(this.m_retcode);  }

//--- Return a request type
   virtual int          Type(void)                             const { return this.m_type;   }
//--- Display request data in the journal
   void                 Print(void);
//--- Constructors
                        CPendingReq(void){;}
                        CPendingReq(const uchar id,const double price,const ulong time,const MqlTradeRequest &request,const int retcode);
  };
//+------------------------------------------------------------------+
//| Parametric constructor                                           |
//+------------------------------------------------------------------+
CPendingReq::CPendingReq(const uchar id,const double price,const ulong time,const MqlTradeRequest &request,const int retcode) : m_price_create(price),
                                                                                                                                m_time_create(time),
                                                                                                                                m_id(id),
                                                                                                                                m_retcode(retcode)
  {
   this.CopyRequest(request);
   this.m_type=(retcode>0 ? PENDING_REQUEST_ID_TYPE_ERR : PENDING_REQUEST_ID_TYPE_REQ);
  }
//+------------------------------------------------------------------+
//| Compare CPendingReq objects by properties                        |
//+------------------------------------------------------------------+
int CPendingReq::Compare(const CObject *node,const int mode=0) const
  {
   const CPendingReq *compared_req=node;
   return
     (
      //--- Compare by ID
      mode==0  ?  
      (this.ID()>compared_req.ID() ? 1 : this.ID()<compared_req.ID() ? -1 : 0)   :
      //--- Compare by type
      (this.Type()>compared_req.Type() ? 1 : this.Type()<compared_req.Type() ? -1 : 0)
     );
  }
//+------------------------------------------------------------------+
//| Display request data in the journal                              |
//+------------------------------------------------------------------+
void CPendingReq::Print(void)
  {
   string action=" - "+RequestActionDescription(this.m_request)+"\n";
   string symbol="",order="",volume="",price="",stoplimit="",sl="",tp="",deviation="",type="",type_filling="";
   string type_time="",expiration="",position="",position_by="",magic="",comment="",request_data="";
   string type_req=" - "+this.TypeDescription()+"\n";
   
   if(this.m_request.action==TRADE_ACTION_DEAL)
     {
      symbol=" - "+RequestSymbolDescription(this.m_request)+"\n";
      volume=" - "+RequestVolumeDescription(this.m_request)+"\n";
      price=" - "+RequestPriceDescription(this.m_request)+"\n";
      sl=" - "+RequestStopLossDescription(this.m_request)+"\n";
      tp=" - "+RequestTakeProfitDescription(this.m_request)+"\n";
      deviation=" - "+RequestDeviationDescription(this.m_request)+"\n";
      type=" - "+RequestTypeDescription(this.m_request)+"\n";
      type_filling=" - "+RequestTypeFillingDescription(this.m_request)+"\n";
      magic=" - "+RequestMagicDescription(this.m_request)+"\n";
      comment=" - "+RequestCommentDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+symbol+volume+price+sl+tp+deviation+type+type_filling+magic+comment+
         " ==================\n"
        );
     }
   else if(this.m_request.action==TRADE_ACTION_SLTP)
     {
      symbol=" - "+RequestSymbolDescription(this.m_request)+"\n";
      sl=" - "+RequestStopLossDescription(this.m_request)+"\n";
      tp=" - "+RequestTakeProfitDescription(this.m_request)+"\n";
      position=" - "+RequestPositionDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+symbol+sl+tp+position+
         " ==================\n"
        );
     }
   else if(this.m_request.action==TRADE_ACTION_PENDING)
     {
      symbol=" - "+RequestSymbolDescription(this.m_request)+"\n";
      volume=" - "+RequestVolumeDescription(this.m_request)+"\n";
      price=" - "+RequestPriceDescription(this.m_request)+"\n";
      stoplimit=" - "+RequestStopLimitDescription(this.m_request)+"\n";
      sl=" - "+RequestStopLossDescription(this.m_request)+"\n";
      tp=" - "+RequestTakeProfitDescription(this.m_request)+"\n";
      type=" - "+RequestTypeDescription(this.m_request)+"\n";
      type_filling=" - "+RequestTypeFillingDescription(this.m_request)+"\n";
      type_time=" - "+RequestTypeTimeDescription(this.m_request)+"\n";
      expiration=" - "+RequestExpirationDescription(this.m_request)+"\n";
      magic=" - "+RequestMagicDescription(this.m_request)+"\n";
      comment=" - "+RequestCommentDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+symbol+volume+price+stoplimit+sl+tp+type+type_filling+type_time+expiration+magic+comment+
         " ==================\n"
        );
     }
   else if(this.m_request.action==TRADE_ACTION_MODIFY)
     {
      order=" - "+RequestOrderDescription(this.m_request)+"\n";
      price=" - "+RequestPriceDescription(this.m_request)+"\n";
      sl=" - "+RequestStopLossDescription(this.m_request)+"\n";
      tp=" - "+RequestTakeProfitDescription(this.m_request)+"\n";
      type_time=" - "+RequestTypeTimeDescription(this.m_request)+"\n";
      expiration=" - "+RequestExpirationDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+order+price+sl+tp+type_time+expiration+
         " ==================\n"
        );
     }
   else if(this.m_request.action==TRADE_ACTION_REMOVE)
     {
      order=" - "+RequestOrderDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+order+
         " ==================\n"
        );
     }
   else if(this.m_request.action==TRADE_ACTION_CLOSE_BY)
     {
      position=" - "+RequestPositionDescription(this.m_request)+"\n";
      position_by=" - "+RequestPositionByDescription(this.m_request)+"\n";
      magic=" - "+RequestMagicDescription(this.m_request)+"\n";
      request_data=
        ("================== "+
         CMessage::Text(MSG_LIB_TEXT_REQUEST_DATAS)+" ==================\n"+
         action+position+position_by+magic+
         " ==================\n"
        );
     }
   string datas=
     (
      " - "+this.TypeDescription()+"\n"+
      " - "+this.IdDescription()+"\n"+
      " - "+this.RetcodeDescription()+" \""+this.ReasonDescription()+"\"\n"+
      " - "+this.TimeCreateDescription()+"\n"+
      " - "+this.PriceCreateDescription()+"\n"+
      " - "+this.TimeActivateDescription()+"\n"+
      " - "+this.WaitingMSCDescription()+" ("+TimeToString(this.WaitingMSC()/1000,TIME_MINUTES|TIME_SECONDS)+")"+"\n"+
      " - "+this.CurrentAttemptDescription()+"\n"+
      " - "+this.TotalAttemptsDescription()+"\n"
     );
   ::Print("================== ",CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_DATAS)," ==================\n",datas,request_data);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trading class                                                    |
//+------------------------------------------------------------------+
class CTrading
  {
private:
   CAccount            *m_account;                       // Pointer to the current account object
   CSymbolsCollection  *m_symbols;                       // Pointer to the symbol collection list
   CMarketCollection   *m_market;                        // Pointer to the list of the collection of market orders and positions
   CHistoryCollection  *m_history;                       // Pointer to the list of the collection of historical orders and deals
   CArrayObj            m_list_request;                  // List of pending requests
   CArrayInt            m_list_errors;                   // Error list
   bool                 m_is_trade_disable;              // Flag disabling trading
   bool                 m_use_sound;                     // The flag of using sounds of the object trading events
   uchar                m_total_try;                     // Number of trading attempts
   ENUM_LOG_LEVEL       m_log_level;                     // Logging level
   MqlTradeRequest      m_request;                       // Trade request prices
   ENUM_TRADE_REQUEST_ERR_FLAGS m_error_reason_flags;    // Flags of error source in a trading method
   ENUM_ERROR_HANDLING_BEHAVIOR m_err_handling_behavior; // Behavior when handling error
   
//--- Add the error code to the list
   bool                 AddErrorCodeToList(const int error_code);
//--- Return the symbol object by (1) position, (2) order ticket
   CSymbol             *GetSymbolObjByPosition(const ulong ticket,const string source_method);
   CSymbol             *GetSymbolObjByOrder(const ulong ticket,const string source_method);
//--- Return a symbol trading object by (1) position, (2) order ticket, (3) symbol name
   CTradeObj           *GetTradeObjByPosition(const ulong ticket,const string source_method);
   CTradeObj           *GetTradeObjByOrder(const ulong ticket,const string source_method);
   CTradeObj           *GetTradeObjBySymbol(const string symbol,const string source_method);
//--- Return an order object by ticket
   COrder              *GetOrderObjByTicket(const ulong ticket);
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
   ENUM_ORDER_TYPE      DirectionByActionType(const ENUM_ACTION_TYPE action)  const;
//--- Check the presence of a (1) position, (2) order by ticket
   bool                 CheckPositionAvailablity(const ulong ticket,const string source_method);
   bool                 CheckOrderAvailablity(const ulong ticket,const string source_method);
//--- Set the desired sound for a trading object
   void                 SetSoundByMode(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,CTradeObj *trade_obj);

//--- Set trading request prices
   template <typename PS,typename SL,typename TP,typename PL> 
   bool                 SetPrices(const ENUM_ORDER_TYPE action,const PS price,const SL sl,const TP tp,const PL limit,const string source_method,CSymbol *symbol_obj);
//--- Return the flag checking the permission to trade by (1) StopLoss, (2) TakeProfit distance, (3) order placement level by a StopLevel-based price
   bool                 CheckStopLossByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const double sl,const CSymbol *symbol_obj);
   bool                 CheckTakeProfitByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const double tp,const CSymbol *symbol_obj);
   bool                 CheckPriceByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const CSymbol *symbol_obj,const double limit=0);
//--- Return the flag checking if a distance from a price to (1) StopLoss, (2) TakeProfit, (3) order placement level by FreezeLevel is acceptable
   bool                 CheckStopLossByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double sl,const CSymbol *symbol_obj);
   bool                 CheckTakeProfitByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double tp,const CSymbol *symbol_obj);
   bool                 CheckPriceByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double price,const CSymbol *symbol_obj);
//--- Return the flag presence in the trading event error reason
   bool                 IsPresentErrorFlag(const int code)     const { return (this.m_error_reason_flags & code)==code;                               }
//--- Return the error code in the list
   bool                 IsPresentErorCode(const int code)            { this.m_list_errors.Sort(); return this.m_list_errors.Search(code)>WRONG_VALUE; }
//--- Set/return the error handling action
   void                 SetErrorHandlingBehavior(const ENUM_ERROR_HANDLING_BEHAVIOR behavior) { this.m_err_handling_behavior=behavior;                }
   ENUM_ERROR_HANDLING_BEHAVIOR  ErrorHandlingBehavior(void)   const { return this.m_err_handling_behavior;                                           }

//--- Check trading limitations
   bool                 CheckTradeConstraints(const double volume,
                                              const ENUM_ACTION_TYPE action,
                                              const CSymbol *symbol_obj,
                                              const string source_method,
                                              double sl=0,
                                              double tp=0);
//--- Check if the funds are sufficient
   bool                 CheckMoneyFree(const double volume,
                                       const double price,
                                       const ENUM_ORDER_TYPE order_type,
                                       const CSymbol *symbol_obj,
                                       const string source_method);
//--- Check parameter values by StopLevel and FreezeLevel
   bool                 CheckLevels(const ENUM_ACTION_TYPE action,
                                       const ENUM_ORDER_TYPE order_type,
                                       double price,
                                       double limit,
                                       double sl,
                                       double tp,
                                       const CSymbol *symbol_obj,
                                       const string source_method);
//--- Return the correct (1) StopLoss, (2) TakeProfit and (3) order placement price
   double               CorrectStopLoss(const ENUM_ORDER_TYPE order_type,
                                       const double price_set,
                                       const double stop_loss,
                                       const CSymbol *symbol_obj,
                                       const uint spread_multiplier=1);
   double               CorrectTakeProfit(const ENUM_ORDER_TYPE order_type,
                                       const double price_set,
                                       const double take_profit,
                                       const CSymbol *symbol_obj,
                                       const uint spread_multiplier=1);
   double               CorrectPricePending(const ENUM_ORDER_TYPE order_type,
                                       const double price_set,
                                       const double price,
                                       const CSymbol *symbol_obj,
                                       const uint spread_multiplier=1);
//--- Return the volume, at which it is possible to open a position
   double               CorrectVolume(const double price,
                                       const ENUM_ORDER_TYPE order_type,
                                       CSymbol *symbol_obj,
                                       const string source_method);

//--- Return the error handling method
   ENUM_ERROR_CODE_PROCESSING_METHOD   ResultProccessingMethod(const uint result_code);
//--- Correct errors
   ENUM_ERROR_CODE_PROCESSING_METHOD   RequestErrorsCorrecting(MqlTradeRequest &request,const ENUM_ORDER_TYPE order_type,const uint spread_multiplier,CSymbol *symbol_obj,CTradeObj *trade_obj);
   
//--- (1) Open a position, (2) place a pending order
   template<typename SL,typename TP> 
   bool                 OpenPosition(const ENUM_POSITION_TYPE type,
                                    const double volume,
                                    const string symbol,
                                    const ulong magic=ULONG_MAX,
                                    const SL sl=0,
                                    const TP tp=0,
                                    const string comment=NULL,
                                    const ulong deviation=ULONG_MAX,
                                    const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   template<typename PS,typename PL,typename SL,typename TP>
   bool                 PlaceOrder( const ENUM_ORDER_TYPE order_type,
                                    const double volume,
                                    const string symbol,
                                    const PS price_stop,
                                    const PL price_limit=0,
                                    const SL sl=0,
                                    const TP tp=0,
                                    const ulong magic=ULONG_MAX,
                                    const string comment=NULL,
                                    const datetime expiration=0,
                                    const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                    const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
                                    
//--- Look for the first free pending request ID
   int                  GetFreeID(void);
//--- Return the request object index in the list by ID
   int                  GetIndexPendingRequestByID(const uchar id);

public:
//--- Constructor
                        CTrading();
//--- Timer
   void                 OnTimer(void);
//--- Get the pointers to the lists (make sure to call the method in program's OnInit() since the symbol collection list is created there)
   void                 OnInit(CAccount *account,CSymbolsCollection *symbols,CMarketCollection *market,CHistoryCollection *history)
                          {
                           this.m_account=account;
                           this.m_symbols=symbols;
                           this.m_market=market;
                           this.m_history=history;
                          }
//--- Return the list of (1) errors and (2) pending requests
   CArrayInt           *GetListErrors(void)                             { return &this.m_list_errors;                }
   CArrayObj           *GetListRequests(void)                           { return &this.m_list_request;               }
//--- Set the number of trading attempts
   void                 SetTotalTry(const uchar number)                 { this.m_total_try=number;                   }
//--- Check limitations and errors
   ENUM_ERROR_CODE_PROCESSING_METHOD CheckErrors(const double volume,
                                                 const double price,
                                                 const ENUM_ACTION_TYPE action,
                                                 const ENUM_ORDER_TYPE order_type,
                                                 CSymbol *symbol_obj,
                                                 CTradeObj *trade_obj,
                                                 const string source_method,
                                                 const double limit=0,
                                                 double sl=0,
                                                 double tp=0);

//--- Set the following for symbol trading objects:
//--- (1) correct filling policy, (2) filling policy,
//--- (3) correct order expiration type, (4) order expiration type,
//--- (5) magic number, (6) comment, (7) slippage, (8) volume, (9) order expiration date,
//--- (10) the flag of asynchronous sending of a trading request, (11) logging level, (12) spread multiplier
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
   void                 SetSpreadMultiplier(const uint value=1,const string symbol=NULL);

//--- Set standard sounds (1 symbol=NULL) for trading objects of all symbols, (2 symbol!=NULL) for a symbol trading object
   void                 SetSoundsStandart(const string symbol=NULL);
//--- Set a sound for a specified order/position type and symbol
//--- 'mode' specifies an event a sound is set for
//--- (symbol=NULL) for trading objects of all symbols,
//--- (symbol!=NULL) for a trading object of a specified symbol
   void                 SetSound(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,const string symbol=NULL);
//--- Set/return the flag enabling sounds
   void                 SetUseSounds(const bool flag);
   bool                 IsUseSounds(void)                            const { return this.m_use_sound;       }

//--- Set/return the flag enabling trading
   void                 SetTradingDisableFlag(const bool flag)             { this.m_is_trade_disable=flag;  }
   bool                 IsTradingDisable(void)                       const { return this.m_is_trade_disable;}

//--- Open (1) Buy, (2) Sell position
   template<typename SL,typename TP> 
   bool                 OpenBuy(const double volume,
                                const string symbol,
                                const ulong magic=ULONG_MAX,
                                const SL sl=0,
                                const TP tp=0,
                                const string comment=NULL,
                                const ulong deviation=ULONG_MAX,
                                const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   
   template<typename SL,typename TP> 
   bool                 OpenSell(const double volume,
                                 const string symbol,
                                 const ulong magic=ULONG_MAX,
                                 const SL sl=0,
                                 const TP tp=0,
                                 const string comment=NULL,
                                 const ulong deviation=ULONG_MAX,
                                 const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);

//--- Modify a position
   template<typename SL,typename TP> 
   bool                 ModifyPosition(const ulong ticket,const SL sl=WRONG_VALUE,const TP tp=WRONG_VALUE);

//--- Close a position (1) fully, (2) partially, (3) by an opposite one
   bool                 ClosePosition(const ulong ticket,const double volume=WRONG_VALUE,const string comment=NULL,const ulong deviation=ULONG_MAX);
   bool                 ClosePositionPartially(const ulong ticket,const double volume,const string comment=NULL,const ulong deviation=ULONG_MAX);
   bool                 ClosePositionBy(const ulong ticket,const ulong ticket_by);

//--- Set (1) BuyStop, (2) BuyLimit, (3) BuyStopLimit pending order
   template<typename PS,typename SL,typename TP>
   bool                 PlaceBuyStop(const double volume,
                                           const string symbol,
                                           const PS price,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   template<typename PS,typename SL,typename TP>
   bool                 PlaceBuyLimit(const double volume,
                                           const string symbol,
                                           const PS price,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   template<typename PS,typename PL,typename SL,typename TP>
   bool                 PlaceBuyStopLimit(const double volume,
                                           const string symbol,
                                           const PS price_stop,
                                           const PL price_limit,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);

//--- Set (1) SellStop, (2) SellLimit, (3) SellStopLimit pending order
   template<typename PS,typename SL,typename TP>
   bool                 PlaceSellStop(const double volume,
                                           const string symbol,
                                           const PS price,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   template<typename PS,typename SL,typename TP>
   bool                 PlaceSellLimit(const double volume,
                                           const string symbol,
                                           const PS price,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
   template<typename PS,typename PL,typename SL,typename TP>
   bool                 PlaceSellStopLimit(const double volume,
                                           const string symbol,
                                           const PS price_stop,
                                           const PL price_limit,
                                           const SL sl=0,
                                           const TP tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const string comment=NULL,
                                           const datetime expiration=0,
                                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
//--- Modify a pending order
   template<typename PS,typename PL,typename SL,typename TP>
   bool                 ModifyOrder(const ulong ticket,
                                          const PS price=WRONG_VALUE,
                                          const SL sl=WRONG_VALUE,
                                          const TP tp=WRONG_VALUE,
                                          const PL limit=WRONG_VALUE,
                                          datetime expiration=WRONG_VALUE,
                                          const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                          const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE);
//--- Remove a pending order
   bool                 DeleteOrder(const ulong ticket);
//--- Create a pending request
   bool                 CreatePendingRequest(const uchar id,const uchar attempts,const ulong wait,const MqlTradeRequest &request,const int retcode,CSymbol *symbol_obj);

//--- Data location in the magic number int value
      //-----------------------------------------------------------
      //  bit   32|31       24|23       16|15        8|7         0|
      //-----------------------------------------------------------
      //  byte    |     3     |     2     |     1     |     0     |
      //-----------------------------------------------------------
      //  data    |   uchar   |   uchar   |         ushort        |
      //-----------------------------------------------------------
      //  descr   |pend req id| id2 | id1 |          magic        |
      //-----------------------------------------------------------
      
//--- Set the ID of the (1) first group, (2) second group, (3) pending request to the magic number value
   void              SetGroupID1(const uchar group,uint &magic)            { magic &=0xFFF0FFFF; magic |= uint(ConvToXX(group,0)<<16);    }
   void              SetGroupID2(const uchar group,uint &magic)            { magic &=0xFF0FFFFF; magic |= uint(ConvToXX(group,1)<<16);    }
   void              SetPendReqID(const uchar id,uint &magic)              { magic &=0x00FFFFFF; magic |= (uint)id<<24;                   }
//--- Convert the value of 0 - 15 into the necessary uchar number bits (0 - lower, 1 - upper ones)
   uchar             ConvToXX(const uchar number,const uchar index)  const { return((number>15 ? 15 : number)<<(4*(index>1 ? 1 : index)));}
//--- Return (1) the specified magic number, the ID of (2) the first group, (3) second group, (4) pending request from the magic number value
   ushort            GetMagicID(const uint magic)                    const { return ushort(magic & 0xFFFF);                               }
   uchar             GetGroupID1(const uint magic)                   const { return uchar(magic>>16) & 0x0F;                              }
   uchar             GetGroupID2(const uint magic)                   const { return uchar((magic>>16) & 0xF0)>>4;                         }
   uchar             GetPendReqID(const uint magic)                  const { return uchar(magic>>24) & 0xFF;                              }

  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrading::CTrading()
  {
   this.m_list_errors.Clear();
   this.m_list_errors.Sort();
   this.m_list_request.Clear();
   this.m_list_request.Sort();
   this.m_total_try=TOTAL_TRY;
   this.m_log_level=LOG_LEVEL_ALL_MSG;
   this.m_is_trade_disable=false;
   this.m_err_handling_behavior=ERROR_HANDLING_BEHAVIOR_CORRECT;
   ::ZeroMemory(this.m_request);
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTrading::OnTimer(void)
  {
   //--- In a loop by the list of pending requests
   int total=this.m_list_request.Total();
   for(int i=total-1;i>WRONG_VALUE;i--)
     {
      //--- receive the next request object
      CPendingReq *req_obj=this.m_list_request.At(i);
      if(req_obj==NULL)
         continue;
      
      //--- get the request structure and the symbol object a trading operation should be performed for
      MqlTradeRequest request=req_obj.MqlRequest();
      CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(request.symbol);
      if(symbol_obj==NULL || !symbol_obj.RefreshRates())
         continue;
      
      //--- if the current attempt exceeds the defined number of trading attempts,
      //--- or the current time exceeds the waiting time of all attempts
      //--- remove the current request object and move on to the next one
      if(req_obj.CurrentAttempt()>req_obj.TotalAttempts() || req_obj.CurrentAttempt()>=UCHAR_MAX || 
         (long)symbol_obj.Time()>long(req_obj.TimeCreate()+req_obj.WaitingMSC()*req_obj.TotalAttempts()))
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
           {
            ::Print(CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_DELETED));
            req_obj.Print();
           }
         this.m_list_request.Delete(i);
         continue;
        }
      
      //--- Get the pending request ID
      uchar id=this.GetPendReqID((uint)request.magic);
      //--- Get the list of orders/positions containing the order/position with the pending request ID
      CArrayObj *list=this.m_market.GetList(ORDER_PROP_PEND_REQ_ID,id,EQUAL);
      if(::CheckPointer(list)==POINTER_INVALID)
         continue;
      //--- If the order/position is present, the request is handled: remove it and proceed to the next
      if(list.Total()>0)
        {
         this.m_list_request.Delete(i);
         continue;
        }

      //--- Set the request activation time in the request object
      req_obj.SetTimeActivate(req_obj.TimeCreate()+req_obj.WaitingMSC()*(req_obj.CurrentAttempt()+1));
      
      //--- If the current time is less than the request activation time,
      //--- this is not the request time - move on to the next request in the list
      if((long)symbol_obj.Time()<(long)req_obj.TimeActivate())
         continue;
      
      //--- Set the attempt number in the request object
      req_obj.SetCurrentAttempt(uchar(req_obj.CurrentAttempt()+1));
      
      //--- Display the number of the trading attempt in the journal
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(CMessage::Text(MSG_LIB_TEXT_RE_TRY_N)+(string)req_obj.CurrentAttempt());
      
      //--- Depending on the type of action performed in the trading request 
      switch(request.action)
        {
         //--- Open a position
         case TRADE_ACTION_DEAL :
            this.OpenPosition((ENUM_POSITION_TYPE)request.type,request.volume,request.symbol,request.magic,request.sl,request.tp,request.comment,request.deviation,request.type_filling);
            break;
         //--- Place a pending order
         case TRADE_ACTION_PENDING :
            this.PlaceOrder(request.type,request.volume,request.symbol,request.price,request.stoplimit,request.sl,request.tp,request.magic,request.comment,request.expiration,request.type_time,request.type_filling);
            break;
         //---
         default:
            break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Return the error handling method                                 |
//+------------------------------------------------------------------+
ENUM_ERROR_CODE_PROCESSING_METHOD CTrading::ResultProccessingMethod(const uint result_code)
  {
   switch(result_code)
     {
   #ifdef __MQL4__
      //--- Malfunctional trade operation
      case 9   :
      //--- Account disabled
      case 64  :
      //--- Invalid account number
      case 65  :  return ERROR_CODE_PROCESSING_METHOD_DISABLE;
      
      //--- No error but result is unknown
      case 1   :
      //--- General error
      case 2   :
      //--- Old client terminal version
      case 5   :
      //--- Not enough rights
      case 7   :
      //--- Market closed
      case 132 :
      //--- Trading disabled
      case 133 :
      //--- Order is locked and being processed
      case 139 :
      //--- Buy only
      case 140 :
      //--- The number of open and pending orders has reached the limit set by the broker
      case 148 :
      //--- Attempt to open an opposite order if hedging is disabled
      case 149 :
      //--- Attempt to close a position on a symbol contradicts the FIFO rule
      case 150 :  return ERROR_CODE_PROCESSING_METHOD_EXIT;
      
      //--- Invalid trading request parameters
      case 3   :
      //--- Invalid price
      case 129 :
      //--- Invalid stop levels
      case 130 :
      //--- Invalid volume
      case 131 :
      //--- Not enough money to perform the operation
      case 134 :
      //--- Expirations are denied by broker
      case 147 :  return ERROR_CODE_PROCESSING_METHOD_CORRECT;
      
      //--- Trade server is busy
      case 4   :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- No connection to the trade server
      case 6   :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- Too frequent requests
      case 8   :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)10000;   // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- No price
      case 136 :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- Broker is busy
      case 137 :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- Too many requests
      case 141 :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)10000;   // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- Modification denied because the order is too close to market
      case 145 :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- Trade context is busy
      case 146 :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)1000;    // ERROR_CODE_PROCESSING_METHOD_WAIT
      
      //--- Trade timeout
      case 128 :
      //--- Price has changed
      case 135 :
      //--- New prices
      case 138 :  return ERROR_CODE_PROCESSING_METHOD_REFRESH;

   //--- MQL5
   #else
      //--- Auto trading disabled by the server
      case 10026  :  return ERROR_CODE_PROCESSING_METHOD_DISABLE;
      
      //--- Request canceled by a trader
      case 10007  :
      //--- Request expired
      case 10012  :
      //--- Trading disabled
      case 10017 :
      //--- Market closed
      case 10018  :
      //--- Order status changed
      case 10023  :
      //--- Request unchanged
      case 10025  :
      //--- Request blocked for handling
      case 10028  :
      //--- Transaction is allowed for live accounts only
      case 10032  :
      //--- The maximum number of pending orders is reached
      case 10033  :
      //--- Reached the maximum order and position volume for this symbol
      case 10034  :
      //--- Invalid or prohibited order type
      case 10035  :
      //--- Position with the specified ID already closed
      case 10036  :
      //--- A close order is already present for a specified position
      case 10039  :
      //--- The maximum number of open positions is reached
      case 10040  :
      //--- Request to activate a pending order is rejected, the order is canceled
      case 10041  :
      //--- Request is rejected, because the rule "Only long positions are allowed" is set for the symbol
      case 10042  :
      //--- Request is rejected, because the rule "Only short positions are allowed" is set for the symbol
      case 10043  :
      //--- Request is rejected, because the rule "Only closing of existing positions is allowed" is set for the symbol
      case 10044  :
      //--- Request is rejected, because the rule "Only closing of existing positions by FIFO rule is allowed" is set for the symbol
      case 10045  :  return ERROR_CODE_PROCESSING_METHOD_EXIT;

      //--- Requote
      case 10004  :
      //--- Prices changed
      case 10020  :  return ERROR_CODE_PROCESSING_METHOD_REFRESH;

      //--- Invalid request
      case 10013  :
      //--- Invalid request volume
      case 10014  :
      //--- Invalid request price
      case 10015  :
      //--- Invalid request stop levels
      case 10016  :
      //--- Insufficient funds for request execution
      case 10019  :
      //--- Invalid order expiration in a request
      case 10022  :
      //--- The specified type of order execution by balance is not supported
      case 10030  :
      //--- Closed volume exceeds the current position volume
      case 10038  :  return ERROR_CODE_PROCESSING_METHOD_CORRECT;

      //--- Request rejected
      case 10006  :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)15000;   // ERROR_CODE_PROCESSING_METHOD_WAIT;
      //--- No quotes to handle the request
      case 10021  :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000;    // ERROR_CODE_PROCESSING_METHOD_WAIT;
      //--- Too frequent requests
      case 10024  :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)10000;   // ERROR_CODE_PROCESSING_METHOD_WAIT
      //--- An order or a position is frozen
      case 10029  :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)10000;   // ERROR_CODE_PROCESSING_METHOD_WAIT;
      //--- No connection to the trade server
      case 10031  :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)20000;   // ERROR_CODE_PROCESSING_METHOD_WAIT;

      //--- Request handling error
      case 10011  :
      //--- Auto trading disabled by the client terminal
      case 10027  :  return ERROR_CODE_PROCESSING_METHOD_PENDING;

      //--- Order placed
      case 10008  :
      //--- Request executed
      case 10009  :
      //--- Request executed partially
      case 10010  :
   #endif 
      //--- "OK"
      default:
        break;
     }
   return ERROR_CODE_PROCESSING_METHOD_OK;
  }
//+------------------------------------------------------------------+
//| Correct errors                                                   |
//+------------------------------------------------------------------+
ENUM_ERROR_CODE_PROCESSING_METHOD CTrading::RequestErrorsCorrecting(MqlTradeRequest &request,
                                                                    const ENUM_ORDER_TYPE order_type,
                                                                    const uint spread_multiplier,
                                                                    CSymbol *symbol_obj,
                                                                    CTradeObj *trade_obj)
  {
//--- The empty error list means no errors are detected, return success
   int total=this.m_list_errors.Total();
   if(total==0)
      return ERROR_CODE_PROCESSING_METHOD_OK;

//--- Trading is disabled for the current account
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_ACCOUNT_NOT_TRADE_ENABLED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_ACCOUNT_NOT_TRADE_ENABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Trading on the trading server side is disabled for EAs on the current account
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_ACCOUNT_EA_NOT_TRADE_ENABLED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_ACCOUNT_EA_NOT_TRADE_ENABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Trading operations are disabled in the terminal
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_TERMINAL_NOT_TRADE_ENABLED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_TERMINAL_NOT_TRADE_ENABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Trading operations are disabled for the EA
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_EA_NOT_TRADE_ENABLED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_EA_NOT_TRADE_ENABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Disable trading on a symbol
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_TRADE_MODE_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_TRADE_MODE_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Close only
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_TRADE_MODE_CLOSEONLY))
     {
      trade_obj.SetResultRetcode(MSG_SYM_TRADE_MODE_CLOSEONLY);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Market orders are disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_MARKET_ORDER_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_MARKET_ORDER_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Limit orders are disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_LIMIT_ORDER_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_LIMIT_ORDER_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Stop orders are disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_STOP_ORDER_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_STOP_ORDER_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- StopLimit orders are disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_STOP_LIMIT_ORDER_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_STOP_LIMIT_ORDER_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Sell only
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_TRADE_MODE_SHORTONLY))
     {
      trade_obj.SetResultRetcode(MSG_SYM_TRADE_MODE_SHORTONLY);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Buy only
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_TRADE_MODE_LONGONLY))
     {
      trade_obj.SetResultRetcode(MSG_SYM_TRADE_MODE_LONGONLY);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- CloseBy orders are disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_SYM_CLOSE_BY_ORDER_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_SYM_CLOSE_BY_ORDER_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Exceeded maximum allowed aggregate volume of orders and positions in one direction
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Close by is disabled
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_CLOSE_BY_ORDERS_DISABLED))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_CLOSE_BY_ORDERS_DISABLED);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Symbols of opposite positions are not equal
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_CLOSE_BY_SYMBOLS_UNEQUAL))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_CLOSE_BY_SYMBOLS_UNEQUAL);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Unsupported price parameter type in a request
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_UNSUPPORTED_PRICE_TYPE_IN_REQ))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_UNSUPPORTED_PRICE_TYPE_IN_REQ);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Trading disabled for the EA until the reason is eliminated
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(MSG_LIB_TEXT_TRADING_DISABLE))
     {
      trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- The maximum number of pending orders is reached
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(10033))
     {
      trade_obj.SetResultRetcode(10033);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }
//--- Reached the maximum order and position volume for this symbol
//--- write the error code to the base trading class object and return "exit from the trading method"
   if(this.IsPresentErorCode(10034))
     {
      trade_obj.SetResultRetcode(10034);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      return ERROR_CODE_PROCESSING_METHOD_EXIT;
     }

//--- Correcting trading request parameters
//--- Price, according to which stop orders are placed
   double price_set=(this.IsPresentErrorFlag(TRADE_REQUEST_ERR_FLAG_PRICE_ERROR) ? request.price : request.stoplimit);
//--- First, adjust stop orders relative to the order/position level
   if(this.IsPresentErorCode(MSG_LIB_TEXT_SL_LESS_STOP_LEVEL))
      request.sl=this.CorrectStopLoss(order_type,price_set,request.sl,symbol_obj,spread_multiplier);
   if(this.IsPresentErorCode(MSG_LIB_TEXT_TP_LESS_STOP_LEVEL))
      request.tp=this.CorrectTakeProfit(order_type,price_set,request.tp,symbol_obj,spread_multiplier);
//--- Pending orders price
   double shift=0;
   if(this.IsPresentErrorFlag(TRADE_REQUEST_ERR_FLAG_PRICE_ERROR))
     {
      price_set=request.price;
      request.price=this.CorrectPricePending(order_type,price_set,0,symbol_obj,spread_multiplier);   
      shift=request.price-price_set; 
      //--- If this is not a stop limit order, move stop orders by the calculated correcting order level shift
      if(request.stoplimit==0)
        {
         if(request.sl>0)
            request.sl=this.CorrectStopLoss(order_type,request.price,request.sl+shift,symbol_obj,spread_multiplier);
         if(request.tp>0)
            request.tp=this.CorrectTakeProfit(order_type,request.price,request.tp+shift,symbol_obj,spread_multiplier);                                                               
        }
     }
//--- The specified type of order execution by balance is not supported
   if(this.IsPresentErorCode(10030))
      request.type_filling=symbol_obj.GetCorrectTypeFilling();
//--- Invalid order expiration in a request -
   if(this.IsPresentErorCode(10022))
     {
      //--- Set a correct order expiration type
      request.type_time=symbol_obj.GetCorrectTypeExpiration();
      //--- if the expiration type is not supported as set by the expiration date and the expiration data is defined, reset the expiration date
      if(!symbol_obj.IsExpirationModeSpecified() && request.expiration>0)
         request.expiration=0;
     }
//--- View the list of remaining errors and correct trading request parameters
   for(int i=0;i<total;i++)
     {
      int err=this.m_list_errors.At(i);
      if(err==NULL)
         continue;
      switch(err)
        {
         //--- Correct an invalid volume and disabling stop levels in a trading request
         case MSG_LIB_TEXT_REQ_VOL_LESS_MIN_VOLUME :
         case MSG_LIB_TEXT_REQ_VOL_MORE_MAX_VOLUME :
         case MSG_LIB_TEXT_INVALID_VOLUME_STEP     :  request.volume=symbol_obj.NormalizedLot(request.volume);                                              break;
         case MSG_SYM_SL_ORDER_DISABLED            :  request.sl=0;                                                                                         break;
         case MSG_SYM_TP_ORDER_DISABLED            :  request.tp=0;                                                                                         break;
         
         //--- If unable to select the position lot, return "abort trading attempt" since the funds are insufficient even for the minimum lot
         case MSG_LIB_TEXT_NOT_ENOUTH_MONEY_FOR    :  request.volume=this.CorrectVolume(request.price,order_type,symbol_obj,DFUN);
                                                      if(request.volume==0)
                                                        {
                                                         trade_obj.SetResultRetcode(MSG_LIB_TEXT_NOT_POSSIBILITY_CORRECT_LOT);
                                                         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
                                                         return ERROR_CODE_PROCESSING_METHOD_EXIT;                                                                                      break;
                                                        }
         //--- No quotes to handle the request
         case 10021                                :  trade_obj.SetResultRetcode(10021);
                                                      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
                                                      return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000; // ERROR_CODE_PROCESSING_METHOD_WAIT - wait 5 seconds
         //--- No connection to the trade server
         case 10031                                :  trade_obj.SetResultRetcode(10031);
                                                      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
                                                      return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000; // ERROR_CODE_PROCESSING_METHOD_WAIT - wait 5 seconds
                                                      
         //--- Proximity to the order activation level is handled by five-second waiting - during this time, the price may go beyond the freeze level
         case MSG_LIB_TEXT_SL_LESS_FREEZE_LEVEL    :
         case MSG_LIB_TEXT_TP_LESS_FREEZE_LEVEL    :
         case MSG_LIB_TEXT_PR_LESS_FREEZE_LEVEL    :  return (ENUM_ERROR_CODE_PROCESSING_METHOD)5000; // ERROR_CODE_PROCESSING_METHOD_WAIT - wait 5 seconds
         default:
           break;
        }
     }
//--- No errors - return ОК
   trade_obj.SetResultRetcode(0);
   trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
   return ERROR_CODE_PROCESSING_METHOD_OK;
  }
//+------------------------------------------------------------------+
//| Check limitations and errors                                     |
//+------------------------------------------------------------------+
ENUM_ERROR_CODE_PROCESSING_METHOD CTrading::CheckErrors(const double volume,
                                                        const double price,
                                                        const ENUM_ACTION_TYPE action,
                                                        const ENUM_ORDER_TYPE order_type,
                                                        CSymbol *symbol_obj,
                                                        CTradeObj *trade_obj,
                                                        const string source_method,
                                                        const double limit=0,
                                                        double sl=0,
                                                        double tp=0)
  {
//--- Check the previously set flag disabling trading for an EA
   if(this.IsTradingDisable())
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_FATAL_ERROR;
      this.AddErrorCodeToList(MSG_LIB_TEXT_TRADING_DISABLE);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
      return ERROR_CODE_PROCESSING_METHOD_DISABLE;
     }
//--- result of all checks and error flags
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   bool res=true;
//--- Clear the error list
   this.m_list_errors.Clear();
   this.m_list_errors.Sort();
//--- Check trading limitations
   res &=this.CheckTradeConstraints(volume,action,symbol_obj,source_method,sl,tp);
//--- Check the funds sufficiency for opening positions/placing orders
   if(action<ACTION_TYPE_CLOSE_BY)
      res &=this.CheckMoneyFree(volume,price,order_type,symbol_obj,source_method);
//--- Check parameter values by StopLevel and FreezeLevel
   res &=this.CheckLevels(action,order_type,price,limit,sl,tp,symbol_obj,source_method);
   
//--- If there are limitations and errors, display the header and the error list
   if(!res)
     {
      //--- Request was rejected before sending to the server due to:
      int total=this.m_list_errors.Total();
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
        {
         //--- For MQL5, first display the list header followed by the error list
         #ifdef __MQL5__
         ::Print(source_method,CMessage::Text(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK ? MSG_LIB_TEXT_REQUEST_REJECTED_DUE : MSG_LIB_TEXT_INVALID_REQUEST));
         for(int i=0;i<total;i++)
            ::Print((total>1 ? string(i+1)+". " : ""),CMessage::Text(m_list_errors.At(i)));
         //--- For MQL4, the journal messages are displayed in the reverse order: the error list in the reverse loop is followed by the list header
         #else    
         for(int i=total-1;i>WRONG_VALUE;i--)
            ::Print((total>1 ? string(i+1)+". " : ""),CMessage::Text(m_list_errors.At(i)));
         ::Print(source_method,CMessage::Text(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK ? MSG_LIB_TEXT_REQUEST_REJECTED_DUE : MSG_LIB_TEXT_INVALID_REQUEST));
         #endif 
        }
      //--- If the action is performed at the "abort trading operation" error
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
         return ERROR_CODE_PROCESSING_METHOD_EXIT;
      //--- If the action is performed at the "create a pending request" error
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
         return ERROR_CODE_PROCESSING_METHOD_PENDING;
      //--- If the action is performed at the "correct parameters" error
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_CORRECT)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CORRECTED_TRADE_REQUEST));
         //--- Return the result of an attempt to correct the request parameters
         return this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
        }
     }
//--- No limitations and errors
   trade_obj.SetResultRetcode(0);
   trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
   return ERROR_CODE_PROCESSING_METHOD_OK;
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
//--- Check connection with the trade server (not in the test mode)
   if(!::TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      if(!::MQLInfoInteger(MQL_TESTER))
        {
         //--- Write the error code to the list and return 'false' - there is no point in further checks
         this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(10031);
         return false;
        }
     }
//--- Check if trading is enabled for an account (if there is a connection with the trade server)
   else if(!this.m_account.TradeAllowed())
     {
      //--- Write the error code to the list and return 'false' - there is no point in further checks
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_LIB_TEXT_ACCOUNT_NOT_TRADE_ENABLED);
      return false;
     }
//--- Check if trading is allowed for any EAs/scripts for the current account
   if(!this.m_account.TradeExpert())
     {
      //--- Write the error code to the list and return 'false' - there is no point in further checks
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_LIB_TEXT_ACCOUNT_EA_NOT_TRADE_ENABLED);
      return false;
     }
//--- Check if auto trading is allowed in the terminal.
//--- AutoTrading button (Options --> Expert Advisors --> "Allowed automated trading")
   if(!::TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      //--- Write the error code to the list and return 'false' - there is no point in further checks
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_LIB_TEXT_TERMINAL_NOT_TRADE_ENABLED);
      return false;
     }
//--- Check if auto trading is allowed for the current EA.
//--- (F7 --> Common --> Allow Automated Trading)
   if(!::MQLInfoInteger(MQL_TRADE_ALLOWED))
     {
      //--- Write the error code to the list and return 'false' - there is no point in further checks
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_LIB_TEXT_EA_NOT_TRADE_ENABLED);
      return false;
     }
//--- Check if trading is enabled on a symbol.
//--- If trading is disabled, write the error code to the list and return 'false' - there is no point in further checks
   if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_DISABLED)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_DISABLED);
      return false;
     }

//--- If not closing/removal/modification
   if(action_type<ACTION_TYPE_CLOSE_BY)
     {
      //--- In case of close-only, write the error code to the list and return 'false' - there is no point in further checks
      if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_CLOSEONLY)
        {
         this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_CLOSEONLY);
         return false;
        }
      //--- Check the minimum volume
      if(volume<symbol_obj.LotsMin())
        {
         //--- The volume in a request is less than the minimum allowed one.
         //--- add the error code to the list
         this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_LIB_TEXT_REQ_VOL_LESS_MIN_VOLUME);
         //--- If the EA behavior during the trading error is set to "abort trading operation",
         //--- return 'false' - there is no point in further checks
         if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
            return false;
         //--- If the EA behavior during a trading error is set to
         //--- "correct parameters" or "create a pending request",
         //--- write 'false' to the result
         else res &=false;
        }
      //--- Check the maximum volume
      else if(volume>symbol_obj.LotsMax())
        {
         //--- The volume in the request exceeds the maximum acceptable one.
         //--- add the error code to the list
         this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_LIB_TEXT_REQ_VOL_MORE_MAX_VOLUME);
         //--- If the EA behavior during the trading error is set to "abort trading operation",
         //--- return 'false' - there is no point in further checks
         if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
            return false;
         //--- If the EA behavior during a trading error is set to
         //--- "correct parameters" or "create a pending request",
         //--- write 'false' to the result
         else res &=false;
        }
      //--- Check the minimum volume gradation
      double step=symbol_obj.LotsStep();
      if(fabs((int)round(volume/step)*step-volume)>0.0000001)
        {
         //--- The volume in the request is not a multiple of the minimum gradation of the lot change step
         //--- add the error code to the list
         this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_LIB_TEXT_INVALID_VOLUME_STEP);
         //--- If the EA behavior during the trading error is set to "abort trading operation",
         //--- return 'false' - there is no point in further checks
         if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
            return false;
         //--- If the EA behavior during a trading error is set to
         //--- "correct parameters" or "create a pending request",
         //--- write 'false' to the result
         else res &=false;
        }
     }

//--- When opening a position
   if(action_type<ACTION_TYPE_BUY_LIMIT)
     {
      //--- Check if sending market orders is allowed on a symbol.
      //--- If using market orders is disabled, write the error code to the list and return 'false' - there is no point in further checks
      if(!symbol_obj.IsMarketOrdersAllowed())
        {
         this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_SYM_MARKET_ORDER_DISABLED);
         return false;
        }
     }
//--- When placing a pending order
   else if(action_type>ACTION_TYPE_SELL && action_type<ACTION_TYPE_CLOSE_BY)
     {
      //--- If there is a limitation on the number of pending orders on an account and placing a new order exceeds it
      if(this.m_account.LimitOrders()>0 && this.OrdersTotalAll()+1 > this.m_account.LimitOrders())
        {
         //--- The limit on the number of pending orders is reached - write the error code to the list and return 'false' - there is no point in further checks
         this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(10033);
         return false;
        }  
      //--- Check if placing limit orders is allowed on a symbol.
      if(action_type==ACTION_TYPE_BUY_LIMIT || action_type==ACTION_TYPE_SELL_LIMIT)
        {
         //--- If setting limit orders is disabled, write the error code to the list and return 'false' - there is no point in further checks
         if(!symbol_obj.IsLimitOrdersAllowed())
           {
            this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.AddErrorCodeToList(MSG_SYM_LIMIT_ORDER_DISABLED);
            return false;
           }
        }
      //--- Check if placing stop orders is allowed on a symbol.
      else if(action_type==ACTION_TYPE_BUY_STOP || action_type==ACTION_TYPE_SELL_STOP)
        {
         //--- If setting stop orders is disabled, write the error code to the list and return 'false' - there is no point in further checks
         if(!symbol_obj.IsStopOrdersAllowed())
           {
            this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.AddErrorCodeToList(MSG_SYM_STOP_ORDER_DISABLED);
            return false;
           }
        }
      //--- For MQL5, check if placing stop limit orders is allowed on a symbol.
      #ifdef __MQL5__
      else if(action_type==ACTION_TYPE_BUY_STOP_LIMIT || action_type==ACTION_TYPE_SELL_STOP_LIMIT)
        {
         //--- If setting stop limit orders is disabled, write the error code to the list and return 'false' - there is no point in further checks
         if(!symbol_obj.IsStopLimitOrdersAllowed())
           {
            this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.AddErrorCodeToList(MSG_SYM_STOP_LIMIT_ORDER_DISABLED);
            return false;
           }
        }
      #endif 
     }

//--- In case of opening/placing/modification
   if(action_type!=ACTION_TYPE_CLOSE_BY)
     {
      //--- If not modification
      if(action_type!=ACTION_TYPE_MODIFY)
        {
         //--- When buying, check if long trading is enabled on a symbol
         if(this.DirectionByActionType(action_type)==ORDER_TYPE_BUY)
           {
            //--- If only short positions are enabled, write the error code to the list and return 'false' - there is no point in further checks
            if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_SHORTONLY)
              {
               this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_SHORTONLY);
               return false;
              }
            //--- If a symbol has the limitation on the total volume of an open position and pending orders in the same direction   
            if(symbol_obj.VolumeLimit()>0)
              {
               //--- (If the total volume of placed long orders and open long positions)+open volume exceed the maximum one
               if(this.OrdersTotalVolumeLong()+this.PositionsTotalVolumeLong()+volume > symbol_obj.VolumeLimit())
                 {
                  //--- Exceeded maximum allowed aggregate volume of orders and positions in one direction
                  //--- write the error code to the list and return 'false' - there is no point in further checks
                  this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
                  this.AddErrorCodeToList(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED);
                  return false;
                 }
              }
           }
         //--- When selling, check if short trading is enabled on a symbol
         else if(this.DirectionByActionType(action_type)==ORDER_TYPE_SELL)
           {
            //--- If only long positions are enabled, write the error code to the list and return 'false' - there is no point in further checks
            if(symbol_obj.TradeMode()==SYMBOL_TRADE_MODE_LONGONLY)
              {
               this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.AddErrorCodeToList(MSG_SYM_TRADE_MODE_LONGONLY);
               return false;
              }
            //--- If a symbol has the limitation on the total volume of an open position and pending orders in the same direction   
            if(symbol_obj.VolumeLimit()>0)
              {
               //--- (If the total volume of placed short orders and open short positions)+open volume exceed the maximum one
               if(this.OrdersTotalVolumeShort()+this.PositionsTotalVolumeShort()+volume > symbol_obj.VolumeLimit())
                 {
                  //--- Exceeded maximum allowed aggregate volume of orders and positions in one direction
                  //--- write the error code to the list and return 'false' - there is no point in further checks
                  this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
                  this.AddErrorCodeToList(MSG_LIB_TEXT_MAX_VOLUME_LIMIT_EXCEEDED);
                  return false;
                 }
              }
           }
        }
      //--- If the request features StopLoss and its placing is not allowed
      if(sl>0 && !symbol_obj.IsStopLossOrdersAllowed())
        {
         //--- add the error code to the list
         this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_SYM_SL_ORDER_DISABLED);
         //--- If the EA behavior during the trading error is set to "abort trading operation",
         //--- return 'false' - there is no point in further checks
         if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
            return false;
         //--- If the EA behavior during a trading error is set to
         //--- "correct parameters" or "create a pending request",
         //--- write 'false' to the result
         else res &=false;
        }
      //--- If the request features TakeProfit and its placing is not allowed
      if(tp>0 && !symbol_obj.IsTakeProfitOrdersAllowed())
        {
         //--- add the error code to the list
         this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_SYM_TP_ORDER_DISABLED);
         //--- If the EA behavior during the trading error is set to "abort trading operation",
         //--- return 'false' - there is no point in further checks
         if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_BREAK)
            return false;
         //--- If the EA behavior during a trading error is set to
         //--- "correct parameters" or "create a pending request",
         //--- write 'false' to the result
         else res &=false;
        }
     }

//--- When closing by an opposite position
   else if(action_type==ACTION_TYPE_CLOSE_BY)
     {
      //--- When closing by an opposite position is disabled
      if(!symbol_obj.IsCloseByOrdersAllowed())
        {
         //--- write the error code to the list and return 'false'
         this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
         this.AddErrorCodeToList(MSG_LIB_TEXT_CLOSE_BY_ORDERS_DISABLED);
         return false;
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//| Check if the funds are sufficient                                |
//+------------------------------------------------------------------+
bool CTrading::CheckMoneyFree(const double volume,
                              const double price,
                              const ENUM_ORDER_TYPE order_type,
                              const CSymbol *symbol_obj,
                              const string source_method)
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
      #else/*__MQL4__*/::AccountFreeMarginCheck(symbol_obj.Name(),action,volume) #endif 
     );
   //--- If no free funds are left, inform of that and return 'false'
   if(money_free<=0 #ifdef __MQL4__ || ::GetLastError()==134 #endif )
     {
      this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
      this.AddErrorCodeToList(MSG_LIB_TEXT_NOT_ENOUTH_MONEY_FOR);
      return false;
     }
   //--- Verification successful
   return true;
  }
//+------------------------------------------------------------------+
//| Check parameter values by StopLevel and FreezeLevel              |
//+------------------------------------------------------------------+
bool CTrading::CheckLevels(const ENUM_ACTION_TYPE action,
                           const ENUM_ORDER_TYPE order_type,
                           double price,
                           double limit,
                           double sl,
                           double tp,
                           const CSymbol *symbol_obj,
                           const string source_method)
  {
//--- the result of conducting all checks
   bool res=true;
//--- StopLevel
//--- If this is not a position closure/order removal
   if(action!=ACTION_TYPE_CLOSE && action!=ACTION_TYPE_CLOSE_BY)
     {
      //--- When placing a pending order
      if(action>ACTION_TYPE_SELL)
        {
         //--- If the order placement distance in points from the price is less than StopLevel
         if(!this.CheckPriceByStopLevel(order_type,price,symbol_obj))
           {
            //--- add the error code to the list and write 'false' to the result
            this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_PRICE_ERROR;
            this.AddErrorCodeToList(MSG_LIB_TEXT_PRICE_LESS_STOP_LEVEL);
            res &=false;
           }
         //--- If this is a stop limit order
         if(action>ACTION_TYPE_SELL_STOP && action<ACTION_TYPE_CLOSE_BY)
           {
            //--- If the limit order placement distance in points from the stop order price is less than StopLevel
            if(!this.CheckPriceByStopLevel(order_type,price,symbol_obj,limit))
              {
               //--- add the error code to the list and write 'false' to the result
               this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_LIMIT_ERROR;
               this.AddErrorCodeToList(MSG_LIB_TEXT_LIMIT_LESS_STOP_LEVEL);
               res &=false;
              }
           }
        }
      //--- If StopLoss is present
      if(sl>0)
        {
         //--- If StopLoss distance in points from the open price is less than StopLevel
         double price_open=(action==ACTION_TYPE_BUY_STOP_LIMIT || action==ACTION_TYPE_SELL_STOP_LIMIT ? limit : price);
         if(!this.CheckStopLossByStopLevel(order_type,price_open,sl,symbol_obj))
           {
            //--- add the error code to the list and write 'false' to the result
            this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.AddErrorCodeToList(MSG_LIB_TEXT_SL_LESS_STOP_LEVEL);
            res &=false;
           }
        }
      //--- If TakeProfit is present
      if(tp>0)
        {
         double price_open=(action==ACTION_TYPE_BUY_STOP_LIMIT || action==ACTION_TYPE_SELL_STOP_LIMIT ? limit : price);
         //--- If TakeProfit distance in points from the open price is less than StopLevel
         if(!this.CheckTakeProfitByStopLevel(order_type,price_open,tp,symbol_obj))
           {
            //--- add the error code to the list and write 'false' to the result
            this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
            this.AddErrorCodeToList(MSG_LIB_TEXT_TP_LESS_STOP_LEVEL);
            res &=false;
           }
        }
     }
//--- FreezeLevel
//--- If this is a position closure/order removal/modification
   if(action>ACTION_TYPE_SELL_STOP_LIMIT)
     {
      //--- If this is a position
      if(order_type<ORDER_TYPE_BUY_LIMIT)
        {
         //--- StopLoss modification
         if(sl>0)
           {
            //--- If the distance from the price to StopLoss is less than FreezeLevel
            if(!this.CheckStopLossByFreezeLevel(order_type,sl,symbol_obj))
              {
               //--- add the error code to the list and write 'false' to the result
               this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.AddErrorCodeToList(MSG_LIB_TEXT_SL_LESS_FREEZE_LEVEL);
               res &=false;
              }
           }
         //--- TakeProfit modification
         if(tp>0)
           {
            //--- If the distance from the price to StopLoss is less than FreezeLevel
            if(!this.CheckTakeProfitByFreezeLevel(order_type,tp,symbol_obj))
              {
               //--- add the error code to the list and write 'false' to the result
               this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.AddErrorCodeToList(MSG_LIB_TEXT_TP_LESS_FREEZE_LEVEL);
               res &=false;
              }
           }
        }
      //--- If this is a pending order
      else
        {
         //--- Placement price modification
         if(price>0)
           {
            //--- If the distance from the price to the order activation price is less than FreezeLevel
            if(!this.CheckPriceByFreezeLevel(order_type,price,symbol_obj))
              {
               //--- add the error code to the list and write 'false' to the result
               this.m_error_reason_flags |=TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST;
               this.AddErrorCodeToList(MSG_LIB_TEXT_PR_LESS_FREEZE_LEVEL);
               res &=false;
              }
           }
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//| Set trading request prices                                       |
//+------------------------------------------------------------------+
template <typename PS,typename SL,typename TP,typename PL> 
bool CTrading::SetPrices(const ENUM_ORDER_TYPE action,const PS price,const SL sl,const TP tp,const PL limit,const string source_method,CSymbol *symbol_obj)
  {
//--- Reset prices
   ::ZeroMemory(this.m_request);
//--- Update all data by symbol
   if(!symbol_obj.RefreshRates())
     {
      this.AddErrorCodeToList(10021);  // No quotes to handle the request
      return false;
     }
//--- Open/close price
   if(price>0)
     {
      //--- price parameter type (double) - normalize the price up to Digits(), since the price has been passed
      if(typename(price)=="double")
         this.m_request.price=::NormalizeDouble(price,symbol_obj.Digits());
      //--- price parameter type (int) - the distance has been passed
      else if(typename(price)=="int" || typename(price)=="uint" || typename(price)=="long" || typename(price)=="ulong")
        {
         //--- Calculate the order price
         switch((int)action)
           {
            //--- Pending order
            case ORDER_TYPE_BUY_LIMIT       :   this.m_request.price=::NormalizeDouble(symbol_obj.AskLast()-price*symbol_obj.Point(),symbol_obj.Digits()); break;
            case ORDER_TYPE_BUY_STOP        :
            case ORDER_TYPE_BUY_STOP_LIMIT  :   this.m_request.price=::NormalizeDouble(symbol_obj.AskLast()+price*symbol_obj.Point(),symbol_obj.Digits()); break;
            
            case ORDER_TYPE_SELL_LIMIT      :   this.m_request.price=::NormalizeDouble(symbol_obj.BidLast()+price*symbol_obj.Point(),symbol_obj.Digits()); break;
            case ORDER_TYPE_SELL_STOP       :
            case ORDER_TYPE_SELL_STOP_LIMIT :   this.m_request.price=::NormalizeDouble(symbol_obj.BidLast()-price*symbol_obj.Point(),symbol_obj.Digits()); break;
            //--- Default - current position open prices
            default  :  this.m_request.price=
              (
               this.DirectionByActionType((ENUM_ACTION_TYPE)action)==ORDER_TYPE_BUY ? ::NormalizeDouble(symbol_obj.AskLast(),symbol_obj.Digits()) : 
               ::NormalizeDouble(symbol_obj.BidLast(),symbol_obj.Digits())
              ); break;
           }
        }
      //--- unsupported price types - display the message and return 'false'
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_UNSUPPORTED_PR_TYPE));
         return false;
        }
     }
   //--- If no price is specified, use the current prices
   else
     {
      this.m_request.price=
        (
         this.DirectionByActionType((ENUM_ACTION_TYPE)action)==ORDER_TYPE_BUY ? 
         ::NormalizeDouble(symbol_obj.AskLast(),symbol_obj.Digits())          : 
         ::NormalizeDouble(symbol_obj.BidLast(),symbol_obj.Digits())
        );
     }
   
//--- StopLimit order price or distance
   if(limit>0)
     {
      //--- limit order price parameter type (double) - normalize the price up to Digits(), since the price has been passed
      if(typename(limit)=="double")
         this.m_request.stoplimit=::NormalizeDouble(limit,symbol_obj.Digits());
      //--- limit order price parameter type (int) - the distance has been passed
      else if(typename(limit)=="int" || typename(limit)=="uint" || typename(limit)=="long" || typename(limit)=="ulong")
        {
         //--- Calculate a limit order price
         if(this.DirectionByActionType((ENUM_ACTION_TYPE)action)==ORDER_TYPE_BUY)
            this.m_request.stoplimit=::NormalizeDouble(this.m_request.price-limit*symbol_obj.Point(),symbol_obj.Digits());
         else
            this.m_request.stoplimit=::NormalizeDouble(this.m_request.price+limit*symbol_obj.Point(),symbol_obj.Digits());
        }
      //--- unsupported limit order price types - display the message and return 'false'
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_UNSUPPORTED_PL_TYPE));
         return false;
        }
     }  
     
//--- Order price stop order prices are calculated from
   double price_open=
     (
      (action==ORDER_TYPE_BUY_STOP_LIMIT || action==ORDER_TYPE_SELL_STOP_LIMIT) && limit>0 ? this.m_request.stoplimit : this.m_request.price
     );
     
//--- StopLoss
   if(sl>0)
     {
      //--- StopLoss parameter type (double) - normalize the price up to Digits(), since the price has been passed
      if(typename(sl)=="double")
         this.m_request.sl=::NormalizeDouble(sl,symbol_obj.Digits());
      //--- StopLoss parameter type (int) - calculate the placement distance
      else if(typename(sl)=="int" || typename(sl)=="uint" || typename(sl)=="long" || typename(sl)=="ulong")
        {
         //--- Calculate the StopLoss price
         if(this.DirectionByActionType((ENUM_ACTION_TYPE)action)==ORDER_TYPE_BUY)
            this.m_request.sl=::NormalizeDouble(price_open-sl*symbol_obj.Point(),symbol_obj.Digits());
         else
            this.m_request.sl=::NormalizeDouble(price_open+sl*symbol_obj.Point(),symbol_obj.Digits());
        }
      //--- unsupported StopLoss types - display the message and return 'false'
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_UNSUPPORTED_SL_TYPE));
         return false;
        }
     }
     
//--- TakeProfit
   if(tp>0)
     {
      //--- TakeProfit parameter type (double) - normalize the price up to Digits(), since the price has been passed
      if(typename(tp)=="double")
         this.m_request.tp=::NormalizeDouble(tp,symbol_obj.Digits());
      //--- TakeProfit parameter type (int) - calculate the placement distance
      else if(typename(tp)=="int" || typename(tp)=="uint" || typename(tp)=="long" || typename(tp)=="ulong")
        {
         if(this.DirectionByActionType((ENUM_ACTION_TYPE)action)==ORDER_TYPE_BUY)
            this.m_request.tp=::NormalizeDouble(price_open+tp*symbol_obj.Point(),symbol_obj.Digits());
         else
            this.m_request.tp=::NormalizeDouble(price_open-tp*symbol_obj.Point(),symbol_obj.Digits());
        }
      //--- unsupported TakeProfit types - display the message and return 'false'
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(source_method,CMessage::Text(MSG_LIB_TEXT_UNSUPPORTED_TP_TYPE));
         return false;
        }
     }
      
//--- All prices are recorded
   return true;
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the distance            |
//| from the price to StopLoss by StopLevel                          |
//+------------------------------------------------------------------+
bool CTrading::CheckStopLossByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const double sl,const CSymbol *symbol_obj)
  {
   double lv=symbol_obj.TradeStopLevel()*symbol_obj.Point();
   double pr=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : order_type==ORDER_TYPE_SELL ? symbol_obj.AskLast() : price);
   return(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? sl<(pr-lv) : sl>(pr+lv));
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the distance            |
//| from the price to TakeProfit by StopLevel                        |
//+------------------------------------------------------------------+
bool CTrading::CheckTakeProfitByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const double tp,const CSymbol *symbol_obj)
  {
   double lv=symbol_obj.TradeStopLevel()*symbol_obj.Point();
   double pr=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : order_type==ORDER_TYPE_SELL ? symbol_obj.AskLast() : price);
   return(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? tp>(pr+lv) : tp<(pr-lv));
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the distance            |
//| from the price to the placement level by StopLevel               |
//+------------------------------------------------------------------+
bool CTrading::CheckPriceByStopLevel(const ENUM_ORDER_TYPE order_type,const double price,const CSymbol *symbol_obj,const double limit=0)
  {
   double lv=symbol_obj.TradeStopLevel()*symbol_obj.Point();
   double pr=(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? symbol_obj.AskLast() : symbol_obj.BidLast());
   return
     (limit==0 ?
      //--- Order placement prices relative to the price
      (
       order_type==ORDER_TYPE_SELL_STOP         ||
       order_type==ORDER_TYPE_SELL_STOP_LIMIT   ||
       order_type==ORDER_TYPE_BUY_LIMIT         ?  price<(pr-lv)     :
       order_type==ORDER_TYPE_BUY_STOP          ||
       order_type==ORDER_TYPE_BUY_STOP_LIMIT    ||
       order_type==ORDER_TYPE_SELL_LIMIT        ?  price>(pr+lv)     :
       true
      ) : 
      //--- Limit order placement prices relative to the stop order price
      (
       order_type==ORDER_TYPE_BUY_STOP_LIMIT    ?  limit<(price-lv)  :  
       order_type==ORDER_TYPE_SELL_STOP_LIMIT   ?  limit>(price+lv)  :
      true
      )
     );
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the                     |
//| distance from the price to StopLoss by FreezeLevel               |
//+------------------------------------------------------------------+
bool CTrading::CheckStopLossByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double sl,const CSymbol *symbol_obj)
  {
   if(symbol_obj.TradeFreezeLevel()==0 || order_type>ORDER_TYPE_SELL)
      return true;
   double lv=symbol_obj.TradeFreezeLevel()*symbol_obj.Point();
   double pr=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : symbol_obj.AskLast());
   return(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? sl<(pr-lv) : sl>(pr+lv));
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the                     |
//| from the price to TakeProfit by FreezeLevel                      |
//+------------------------------------------------------------------+
bool CTrading::CheckTakeProfitByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double tp,const CSymbol *symbol_obj)
  {
   if(symbol_obj.TradeFreezeLevel()==0 || order_type>ORDER_TYPE_SELL)
      return true;
   double lv=symbol_obj.TradeFreezeLevel()*symbol_obj.Point();
   double pr=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : symbol_obj.AskLast());
   return(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? tp>(pr+lv) : tp<(pr-lv));
  }
//+------------------------------------------------------------------+
//| Return the flag checking the validity of the distance            |
//| from the price to the order price by FreezeLevel                 |
//+------------------------------------------------------------------+
bool CTrading::CheckPriceByFreezeLevel(const ENUM_ORDER_TYPE order_type,const double price,const CSymbol *symbol_obj)
  {
   if(symbol_obj.TradeFreezeLevel()==0 || order_type<ORDER_TYPE_BUY_LIMIT)
      return true;
   double lv=symbol_obj.TradeFreezeLevel()*symbol_obj.Point();
   double pr=(this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY ? symbol_obj.AskLast() : symbol_obj.BidLast());
   return
     (
      order_type==ORDER_TYPE_SELL_STOP       ||
      order_type==ORDER_TYPE_SELL_STOP_LIMIT ||
      order_type==ORDER_TYPE_BUY_LIMIT       ?  price<(pr-lv)  :
      order_type==ORDER_TYPE_BUY_STOP        ||
      order_type==ORDER_TYPE_BUY_STOP_LIMIT  ||
      order_type==ORDER_TYPE_SELL_LIMIT      ?  price>(pr+lv)  :
      true
     );
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
//| Return an order object by ticket                                 |
//+------------------------------------------------------------------+
COrder *CTrading::GetOrderObjByTicket(const ulong ticket)
  {
   CArrayObj *list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   if(list==NULL || list.Total()==0)
      return NULL;
   return list.At(0);
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
//| Set the spread multiplier                                        |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CTrading::SetSpreadMultiplier(const uint value=1,const string symbol=NULL)
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
         trade_obj.SetSpreadMultiplier(value);
        }
     }
   else
     {
      CTradeObj *trade_obj=this.GetTradeObjBySymbol(symbol,DFUN);
      if(trade_obj==NULL)
         return;
      trade_obj.SetSpreadMultiplier(value);
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
//| Set the flag enabling sounds                                     |
//+------------------------------------------------------------------+
void CTrading::SetUseSounds(const bool flag)
  {
   //--- Set the flag enabling sounds
   this.m_use_sound=flag;
   //--- Get the symbol list
   CArrayObj *list=this.m_symbols.GetList();
   if(list==NULL || list.Total()==0)
      return;
   //--- In a loop by the list of symbols
   int total=list.Total();
   for(int i=0;i<total;i++)
     {
      //--- get the next symbol object
      CSymbol *symbol_obj=list.At(i);
      if(symbol_obj==NULL)
         continue;
      //--- get a symbol trading object
      CTradeObj *trade_obj=symbol_obj.GetTradeObj();
      if(trade_obj==NULL)
         continue;
      //--- set the flag enabling sounds for a trading object
      trade_obj.SetUseSound(flag);
     }
  }
//+------------------------------------------------------------------+
//| Open a position                                                  |
//+------------------------------------------------------------------+
template<typename SL,typename TP> 
bool CTrading::OpenPosition(const ENUM_POSITION_TYPE type,
                            const double volume,
                            const string symbol,
                            const ulong magic=ULONG_MAX,
                            const SL sl=0,
                            const TP tp=0,
                            const string comment=NULL,
                            const ulong deviation=ULONG_MAX,
                            const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Set the trading request result as 'true' and the error flag as "no errors"
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)type;
   ENUM_ACTION_TYPE action=(ENUM_ACTION_TYPE)order_type;
//--- Get a symbol object by a symbol name. If failed to get
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
//--- If failed to get - write the "internal error" flag, display the message in the journal and return 'false'
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
//--- If failed to get - write the "internal error" flag, display the message in the journal and return 'false'
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- Set the prices
//--- If failed to set - write the "internal error" flag, set the error code in the return structure,
//--- display the message in the journal and return 'false'
   if(!this.SetPrices(order_type,0,sl,tp,0,DFUN,symbol_obj))
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));   // No quotes to process the request
      return false;
     }

//--- Write the volume to the request structure
   this.m_request.volume=volume;
//--- Get the method of handling errors from the CheckErrors() method while checking for errors in the request parameters
   double pr=(type==POSITION_TYPE_BUY ? symbol_obj.AskLast() : symbol_obj.BidLast());
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(this.m_request.volume,pr,action,order_type,symbol_obj,trade_obj,DFUN,0,this.m_request.sl,this.m_request.tp);
//--- In case of trading limitations, funds insufficiency,
//--- if there are limitations by StopLevel or FreezeLevel ...
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled, set the error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);
         //--- after waiting, update all data
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }
   
//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj.OpenPosition(type,this.m_request.volume,this.m_request.sl,this.m_request.tp,magic,comment,deviation,type_filling);
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,order_type);
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         
         //--- Get the error handling method
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request
         //--- create a pending request and end the loop
         if(method>ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            //--- If the trading request magic number, has no pending request ID
            if(this.GetPendReqID((uint)magic)==0)
              {
               //--- Waiting time in milliseconds:
               //--- for the "Wait and repeat" handling method, the waiting value corresponds to the 'method' value,
               //--- for the "Create a pending request" handling method - till there is a zero waiting time
               ulong wait=(method>ERROR_CODE_PROCESSING_METHOD_PENDING ? method : 0);
               //--- Look for the least of the possible IDs. If failed to find
               //--- or in case of an error while updating the current symbol data, return 'false'
               int id=this.GetFreeID();
               if(id<1 || !symbol_obj.RefreshRates())
                  return false;
               //--- Write the request ID to the magic number, while a symbol name is set in the request structure,
               //--- set a comment, as well as position and trading operation types (the remaining structure fields are already filled in)
               uint mn=(magic==ULONG_MAX ? (uint)trade_obj.GetMagic() : (uint)magic);
               ulong dev=(deviation==ULONG_MAX ? trade_obj.GetDeviation() : deviation);
               this.SetPendReqID((uchar)id,mn);
               this.m_request.magic=mn;
               this.m_request.deviation=dev;
               this.m_request.symbol=symbol_obj.Name();
               this.m_request.action=TRADE_ACTION_DEAL;
               this.m_request.type=order_type;
               this.m_request.comment=(comment==NULL ? trade_obj.GetComment() : comment);
               //--- Pass the number of trading attempts to the pending request
               uchar attempts=(this.m_total_try < 1 ? 1 : this.m_total_try);
               this.CreatePendingRequest((uchar)id,attempts,wait,this.m_request,trade_obj.GetResultRetcode(),symbol_obj);
               break;
              }
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
template<typename SL,typename TP> 
bool CTrading::OpenBuy(const double volume,
                       const string symbol,
                       const ulong magic=ULONG_MAX,
                       const SL sl=0,
                       const TP tp=0,
                       const string comment=NULL,
                       const ulong deviation=ULONG_MAX,
                       const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request from the OpenPosition() method
   return this.OpenPosition(POSITION_TYPE_BUY,volume,symbol,magic,sl,tp,comment,deviation,type_filling);
  }
//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
template<typename SL,typename TP> 
bool CTrading::OpenSell(const double volume,
                        const string symbol,
                        const ulong magic=ULONG_MAX,
                        const SL sl=0,
                        const TP tp=0,
                        const string comment=NULL,
                        const ulong deviation=ULONG_MAX,
                        const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request from the OpenPosition() method
   return this.OpenPosition(POSITION_TYPE_SELL,volume,symbol,magic,sl,tp,comment,deviation,type_filling);
  }
//+------------------------------------------------------------------+
//| Modify a position                                                |
//+------------------------------------------------------------------+
template<typename SL,typename TP> 
bool CTrading::ModifyPosition(const ulong ticket,const SL sl=WRONG_VALUE,const TP tp=WRONG_VALUE)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=ACTION_TYPE_MODIFY;
//--- Get an order object by ticket
   COrder *order=this.GetOrderObjByTicket(ticket);
   if(order==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return false;
     }
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)order.TypeOrder();
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- Set the prices
//--- If failed to set - write the "internal error" flag, set the error code in the return structure,
//--- display the message in the journal and return 'false'
   if(!this.SetPrices(order_type,0,(sl==WRONG_VALUE ? order.StopLoss() : sl),(tp==WRONG_VALUE ? order.TakeProfit() : tp),0,DFUN,symbol_obj))
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));   // No quotes to process the request
      return false;
     }
     
//--- If there are trading limitations, there are StopLevel/FreezeLevel limitations - play the error sound and exit
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(0,0,action,order_type,symbol_obj,trade_obj,DFUN,0,this.m_request.sl,this.m_request.tp);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type,(sl<0 ? false : true),(tp<0 ? false : true));
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds() && trade_obj.GetResultRetcode()!=10025)
            trade_obj.PlaySoundError(action,order_type,(sl<0 ? false : true),(tp<0 ? false : true));
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj.ModifyPosition(ticket,this.m_request.sl,this.m_request.tp);
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,(int)order.TypeOrder(),(sl<0 ? false : true),(tp<0 ? false : true));
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds() && trade_obj.GetResultRetcode()!=10025)
            trade_obj.PlaySoundError(action,(int)order.TypeOrder(),(sl<0 ? false : true),(tp<0 ? false : true));
         
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request -
         //--- set the last error code to the return structure and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request -
         //--- in this implementation, we wait the number of milliseconds equal to the 'method' value and move on to the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
           {
            Sleep(method);
            continue;
           }
         //--- If "Create a pending request" is received as a result of sending a request -
         //--- create a pending request with the trading request parameters and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_PENDING)
           {
            break;
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Close a position in full                                         |
//+------------------------------------------------------------------+
bool CTrading::ClosePosition(const ulong ticket,const double volume=WRONG_VALUE,const string comment=NULL,const ulong deviation=ULONG_MAX)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=ACTION_TYPE_CLOSE;
//--- Get an order object by ticket
   COrder *order=this.GetOrderObjByTicket(ticket);
   if(order==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return false;
     }
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)order.TypeOrder();
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   //--- If failed to get the symbol object, display the message and return 'false'
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- Update symbol quotes
   if(!symbol_obj.RefreshRates())
     {
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      this.AddErrorCodeToList(10021);  // No quotes to handle the request
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));
      return false;
     }
     
//--- If there are trading limitations,
//--- there are limitations on FreezeLevel - play the error sound and exit
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(0,0,action,order_type,symbol_obj,trade_obj,DFUN);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=(volume==WRONG_VALUE ? trade_obj.ClosePosition(ticket,comment,deviation) : trade_obj.ClosePositionPartially(ticket,volume,comment,deviation));
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,(int)order.TypeOrder());
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,(int)order.TypeOrder());
         
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request -
         //--- in this implementation, we wait the number of milliseconds equal to the 'method' value and move on to the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
           {
            Sleep(method);
            continue;
           }
         //--- If "Create a pending request" is received as a result of sending a request -
         //--- create a pending request with the trading request parameters and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_PENDING)
           {
            break;
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Close a position partially                                       |
//+------------------------------------------------------------------+
bool CTrading::ClosePositionPartially(const ulong ticket,const double volume,const string comment=NULL,const ulong deviation=ULONG_MAX)
  {
//--- Return the result of sending a trading request using the ClosePosition method
   return this.ClosePosition(ticket,volume,comment,deviation);
  }
//+------------------------------------------------------------------+
//| Close a position by an opposite one                              |
//+------------------------------------------------------------------+
bool CTrading::ClosePositionBy(const ulong ticket,const ulong ticket_by)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=ACTION_TYPE_CLOSE_BY;
//--- Get an order object by ticket
   COrder *order=this.GetOrderObjByTicket(ticket);
   if(order==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return false;
     }
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)order.TypeOrder();
//--- Get a symbol object by a position ticket
   CSymbol *symbol_obj=this.GetSymbolObjByPosition(ticket,DFUN);
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- trading object of a closed position
   CTradeObj *trade_obj_pos=this.GetTradeObjByPosition(ticket,DFUN);
   if(trade_obj_pos==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
   if(!this.m_account.IsHedge())
     {
      trade_obj_pos.SetResultRetcode(MSG_ACC_UNABLE_CLOSE_BY);
      trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
      return false;
     }
//--- check the presence of an opposite position
   if(!this.CheckPositionAvailablity(ticket_by,DFUN))
     {
      trade_obj_pos.SetResultRetcode(MSG_LIB_SYS_ERROR_POSITION_BY_ALREADY_CLOSED);
      trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
      return false;
     }
//--- trading object of an opposite position
   CTradeObj *trade_obj_pos_by=this.GetTradeObjByPosition(ticket_by,DFUN);
   if(trade_obj_pos_by==NULL)
     {
      trade_obj_pos.SetResultRetcode(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ);
      trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- If a symbol of a closed position is not equal to an opposite position's one, inform of that and exit
   if(symbol_obj.Name()!=trade_obj_pos_by.GetSymbol())
     {
      trade_obj_pos.SetResultRetcode(MSG_LIB_TEXT_CLOSE_BY_SYMBOLS_UNEQUAL);
      trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_TEXT_CLOSE_BY_SYMBOLS_UNEQUAL));
      return false;
     }
//--- Update symbol quotes
   if(!symbol_obj.RefreshRates())
     {
      trade_obj_pos.SetResultRetcode(10021);
      trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
      this.AddErrorCodeToList(10021);  // No quotes to handle the request
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));
      return false;
     }
     
//--- If there are trading limitations, there are FreezeLevel limitations - play the error sound and exit
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(0,0,action,order_type,symbol_obj,trade_obj_pos,DFUN);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj_pos.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj_pos.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj_pos.SetResultRetcode(code);
            trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds())
            trade_obj_pos.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj_pos.SetResultRetcode(code);
            trade_obj_pos.SetResultComment(CMessage::Text(trade_obj_pos.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj_pos.ClosePositionBy(ticket,ticket_by);
      //--- If the request is successful, play the success sound set for a symbol trading object for this type of trading operation
      if(res || trade_obj_pos.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj_pos.PlaySoundSuccess(action,(int)order.TypeOrder());
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj_pos.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj_pos.PlaySoundError(action,(int)order.TypeOrder());
         
         method=this.ResultProccessingMethod(trade_obj_pos.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj_pos.SpreadMultiplier(),symbol_obj,trade_obj_pos);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request -
         //--- in this implementation, we wait the number of milliseconds equal to the 'method' value and move on to the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
           {
            Sleep(method);
            continue;
           }
         //--- If "Create a pending request" is received as a result of sending a request -
         //--- create a pending request with the trading request parameters and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_PENDING)
           {
            break;
           }
        }
     }
   //--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Place a pending order                                            |
//+------------------------------------------------------------------+
template<typename PS,typename PL,typename SL,typename TP>
bool CTrading::PlaceOrder(const ENUM_ORDER_TYPE order_type,
                          const double volume,
                          const string symbol,
                          const PS price_stop,
                          const PL price_limit=0,
                          const SL sl=0,
                          const TP tp=0,
                          const ulong magic=ULONG_MAX,
                          const string comment=NULL,
                          const datetime expiration=0,
                          const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                          const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=(ENUM_ACTION_TYPE)order_type;
//--- Get a symbol object by a symbol name
   CSymbol *symbol_obj=this.m_symbols.GetSymbolObjByName(symbol);
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- Get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false; 
     }
//--- Set the prices
//--- If failed to set - write the "internal error" flag, set the error code in the return structure,
//--- display the message in the journal and return 'false'
   if(!this.SetPrices(order_type,price_stop,sl,tp,price_limit,DFUN,symbol_obj))
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));   // No quotes to process the request
      return false;
     }
     
//--- In case of trading limitations, funds insufficiency,
//--- there are limitations on StopLevel - play the error sound and exit
   this.m_request.volume=volume;
   this.m_request.type_filling=type_filling;
   this.m_request.type_time=type_time;
   this.m_request.expiration=expiration;
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(this.m_request.volume,
                                                             this.m_request.price,
                                                             action,
                                                             order_type,
                                                             symbol_obj,
                                                             trade_obj,
                                                             DFUN,
                                                             this.m_request.stoplimit,
                                                             this.m_request.sl,
                                                             this.m_request.tp);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj.SetOrder(order_type,
                             this.m_request.volume,
                             this.m_request.price,
                             this.m_request.sl,
                             this.m_request.tp,
                             this.m_request.stoplimit,
                             magic,
                             comment,
                             this.m_request.expiration,
                             this.m_request.type_time,
                             this.m_request.type_filling);
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,order_type);
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request
         //--- create a pending request and end the loop
         if(method>ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            //--- If the trading request magic number, has no pending request ID
            if(this.GetPendReqID((uint)magic)==0)
              {
               //--- Waiting time in milliseconds:
               //--- for the "Wait and repeat" handling method, the waiting value corresponds to the 'method' value,
               //--- for the "Create a pending request" handling method - till there is a zero waiting time
               ulong wait=(method>ERROR_CODE_PROCESSING_METHOD_PENDING ? method : 0);
               //--- Look for the least of the possible IDs. If failed to find
               //--- or in case of an error while updating the current symbol data, return 'false'
               int id=this.GetFreeID();
               if(id<1 || !symbol_obj.RefreshRates())
                  return false;
               //--- Write the request ID to the magic number, while a symbol name is set in the request structure,
               //--- set the trading operation and order types, comment and position type, filling and expiration type
               uint mn=(magic==ULONG_MAX ? (uint)trade_obj.GetMagic() : (uint)magic);
               this.SetPendReqID((uchar)id,mn);
               this.m_request.magic=mn;
               this.m_request.symbol=symbol_obj.Name();
               this.m_request.action=TRADE_ACTION_PENDING;
               this.m_request.type=order_type;
               this.m_request.comment=(comment==NULL ? trade_obj.GetComment() : comment);
               this.m_request.type_time=(type_time>WRONG_VALUE ? type_time : trade_obj.GetTypeExpiration());
               this.m_request.type_filling=(type_filling>WRONG_VALUE ? type_filling : trade_obj.GetTypeFilling());
               //--- Pass the number of trading attempts to the pending request
               uchar attempts=(this.m_total_try < 1 ? 1 : this.m_total_try);
               this.CreatePendingRequest((uchar)id,attempts,wait,this.m_request,trade_obj.GetResultRetcode(),symbol_obj);
               break;
              }
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Place BuyStop pending order                                      |
//+------------------------------------------------------------------+
template<typename PS,typename SL,typename TP>
bool CTrading::PlaceBuyStop(const double volume,
                            const string symbol,
                            const PS price,
                            const SL sl=0,
                            const TP tp=0,
                            const ulong magic=ULONG_MAX,
                            const string comment=NULL,
                            const datetime expiration=0,
                            const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                            const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_BUY_STOP,volume,symbol,price,0,sl,tp,magic,comment,expiration,type_time,type_filling);
  }
//+------------------------------------------------------------------+
//| Place BuyLimit pending order                                     |
//+------------------------------------------------------------------+
template<typename PS,typename SL,typename TP>
bool CTrading::PlaceBuyLimit(const double volume,
                             const string symbol,
                             const PS price,
                             const SL sl=0,
                             const TP tp=0,
                             const ulong magic=ULONG_MAX,
                             const string comment=NULL,
                             const datetime expiration=0,
                             const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                             const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_BUY_LIMIT,volume,symbol,price,0,sl,tp,magic,comment,expiration,type_time,type_filling);
  }
//+------------------------------------------------------------------+
//| Place BuyStopLimit pending order                                 |
//+------------------------------------------------------------------+
template<typename PS,typename PL,typename SL,typename TP>
bool CTrading::PlaceBuyStopLimit(const double volume,
                                 const string symbol,
                                 const PS price_stop,
                                 const PL price_limit,
                                 const SL sl=0,
                                 const TP tp=0,
                                 const ulong magic=ULONG_MAX,
                                 const string comment=NULL,
                                 const datetime expiration=0,
                                 const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                 const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
#ifdef __MQL5__
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_BUY_STOP_LIMIT,volume,symbol,price_stop,price_limit,sl,tp,magic,comment,expiration,type_time,type_filling);
//--- MQL4
#else 
   return true;
#endif 
  }
//+------------------------------------------------------------------+
//| Place SellStop pending order                                     |
//+------------------------------------------------------------------+
template<typename PS,typename SL,typename TP>
bool CTrading::PlaceSellStop(const double volume,
                             const string symbol,
                             const PS price,
                             const SL sl=0,
                             const TP tp=0,
                             const ulong magic=ULONG_MAX,
                             const string comment=NULL,
                             const datetime expiration=0,
                             const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                             const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_SELL_STOP,volume,symbol,price,0,sl,tp,magic,comment,expiration,type_time,type_filling);
  }
//+------------------------------------------------------------------+
//| Place SellLimit pending order                                    |
//+------------------------------------------------------------------+
template<typename PS,typename SL,typename TP>
bool CTrading::PlaceSellLimit(const double volume,
                              const string symbol,
                              const PS price,
                              const SL sl=0,
                              const TP tp=0,
                              const ulong magic=ULONG_MAX,
                              const string comment=NULL,
                              const datetime expiration=0,
                              const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                              const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_SELL_LIMIT,volume,symbol,price,0,sl,tp,magic,comment,expiration,type_time,type_filling);
  }
//+------------------------------------------------------------------+
//| Place SellStopLimit pending order                                |
//+------------------------------------------------------------------+
template<typename PS,typename PL,typename SL,typename TP>
bool CTrading::PlaceSellStopLimit(const double volume,
                                  const string symbol,
                                  const PS price_stop,
                                  const PL price_limit,
                                  const SL sl=0,
                                  const TP tp=0,
                                  const ulong magic=ULONG_MAX,
                                  const string comment=NULL,
                                  const datetime expiration=0,
                                  const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                                  const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
#ifdef __MQL5__
//--- Return the result of sending a trading request using the PlaceOrder() method
   return this.PlaceOrder(ORDER_TYPE_SELL_STOP_LIMIT,volume,symbol,price_stop,price_limit,sl,tp,magic,comment,expiration,type_time,type_filling);
   //--- MQL4
#else 
   return true;
#endif 
  }
//+------------------------------------------------------------------+
//| Modify a pending order                                           |
//+------------------------------------------------------------------+
template<typename PS,typename PL,typename SL,typename TP>
bool CTrading::ModifyOrder(const ulong ticket,
                           const PS price=WRONG_VALUE,
                           const SL sl=WRONG_VALUE,
                           const TP tp=WRONG_VALUE,
                           const PL limit=WRONG_VALUE,
                           datetime expiration=WRONG_VALUE,
                           const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE,
                           const ENUM_ORDER_TYPE_FILLING type_filling=WRONG_VALUE)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=ACTION_TYPE_MODIFY;
//--- Get an order object by ticket
   COrder *order=this.GetOrderObjByTicket(ticket);
   if(order==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return false;
     }
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)order.TypeOrder();
//--- Get a symbol object by an order ticket
   CSymbol *symbol_obj=this.GetSymbolObjByOrder(ticket,DFUN);
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- Set the prices
//--- If failed to set - write the "internal error" flag, set the error code in the return structure,
//--- display the message in the journal and return 'false'
   if(!this.SetPrices(order_type,
                      (price>0 ? price : order.PriceOpen()),
                      (sl>0 ? sl : sl<0 ? order.StopLoss() : 0),
                      (tp>0 ? tp : tp<0 ? order.TakeProfit() : 0),
                      (limit>0 ? limit : order.PriceStopLimit()),
                      DFUN,symbol_obj))
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));   // No quotes to process the request
      return false;
     }
     
//--- If there are trading limitations,
//--- StopLevel or FreezeLevel limitations, play the error sound and exit
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(0,this.m_request.price,action,order_type,symbol_obj,trade_obj,DFUN,this.m_request.stoplimit,this.m_request.sl,this.m_request.tp);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type,(sl<0 ? false : true),(tp<0 ? false : true),(price>0 || limit>0 ? true : false));
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds() && trade_obj.GetResultRetcode()!=10025)
            trade_obj.PlaySoundError(action,order_type,(sl<0 ? false : true),(tp<0 ? false : true),(price>0 || limit>0 ? true : false));
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj.ModifyOrder(ticket,price,sl,tp,limit,expiration,type_time,type_filling);
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,(int)order.TypeOrder(),(sl<0 ? false : true),(tp<0 ? false : true),(price>0 || limit>0 ? true : false));
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,(int)order.TypeOrder(),(sl<0 ? false : true),(tp<0 ? false : true),(price>0 || limit>0 ? true : false));
         
         //--- Get the error handling method
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request -
         //--- in this implementation, we wait the number of milliseconds equal to the 'method' value and move on to the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
           {
            ::Sleep(method);
            continue;
           }
         //--- If "Create a pending request" is received as a result of sending a request -
         //--- create a pending request with the trading request parameters and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_PENDING)
           {
            break;
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Remove a pending order                                           |
//+------------------------------------------------------------------+
bool CTrading::DeleteOrder(const ulong ticket)
  {
   bool res=true;
   this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_NO_ERROR;
   ENUM_ACTION_TYPE action=ACTION_TYPE_CLOSE;
//--- Get an order object by ticket
   COrder *order=this.GetOrderObjByTicket(ticket);
   if(order==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_ORD_OBJ));
      return false;
     }
   ENUM_ORDER_TYPE order_type=(ENUM_ORDER_TYPE)order.TypeOrder();
//--- Get a symbol object by an order ticket
   CSymbol *symbol_obj=this.GetSymbolObjByOrder(ticket,DFUN);
   if(symbol_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_SYM_OBJ));
      return false;
     }
//--- get a trading object from a symbol object
   CTradeObj *trade_obj=symbol_obj.GetTradeObj();
   if(trade_obj==NULL)
     {
      this.m_error_reason_flags=TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR;
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_GET_TRADE_OBJ));
      return false;
     }
//--- Update symbol quotes
   if(!symbol_obj.RefreshRates())
     {
      trade_obj.SetResultRetcode(10021);
      trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
      this.AddErrorCodeToList(10021);  // No quotes to handle the request
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(10021));
      return false;
     }
     
//--- If there are trading limitations,
//--- there are limitations on FreezeLevel - play the error sound and exit
   ENUM_ERROR_CODE_PROCESSING_METHOD method=this.CheckErrors(0,0,action,order_type,symbol_obj,trade_obj,DFUN);
   if(method!=ERROR_CODE_PROCESSING_METHOD_OK)
     {
      //--- If trading is completely disabled
      if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
        {
         trade_obj.SetResultRetcode(MSG_LIB_TEXT_TRADING_DISABLE);
         trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_DISABLE));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "abort trading operation" - set the last error code to the return structure,
      //--- display a journal message, play the error sound and exit
      if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRADING_OPERATION_ABORTED));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,order_type);
         return false;
        }
      //--- If the check result is "waiting" - set the last error code to the return structure and display the message in the journal
      if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
        {
         int code=this.m_list_errors.At(this.m_list_errors.Total()-1);
         if(code!=NULL)
           {
            trade_obj.SetResultRetcode(code);
            trade_obj.SetResultComment(CMessage::Text(trade_obj.GetResultRetcode()));
           }
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
         //--- Instead of creating a pending request, we temporarily wait the required time period (the CheckErrors() method result is returned)
         ::Sleep(method);           
         symbol_obj.Refresh();
        }
      //--- If the check result is "create a pending request", do nothing temporarily
      if(this.m_err_handling_behavior==ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST)
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_CREATE_PENDING_REQUEST));
        }
     }

//--- In the loop by the number of attempts
   for(int i=0;i<this.m_total_try;i++)
     {                
      //--- Send the request
      res=trade_obj.DeleteOrder(ticket);
      //--- If the request is executed successfully or the asynchronous order sending mode is set, play the success sound
      //--- set for a symbol trading object for this type of trading operation and return 'true'
      if(res || trade_obj.IsAsyncMode())
        {
         if(this.IsUseSounds())
            trade_obj.PlaySoundSuccess(action,(int)order.TypeOrder());
         return true;
        }
      //--- If the request is not successful, play the error sound set for a symbol trading object for this type of trading operation
      else
        {
         if(this.m_log_level>LOG_LEVEL_NO_MSG)
            ::Print(CMessage::Text(MSG_LIB_TEXT_TRY_N),string(i+1),". ",CMessage::Text(MSG_LIB_SYS_ERROR),": ",CMessage::Text(trade_obj.GetResultRetcode()));
         if(this.IsUseSounds())
            trade_obj.PlaySoundError(action,(int)order.TypeOrder());
         
         //--- Get the error handling method
         method=this.ResultProccessingMethod(trade_obj.GetResultRetcode());
         //--- If "Disable trading for the EA" is received as a result of sending a request, enable the disabling flag and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_DISABLE)
           {
            this.SetTradingDisableFlag(true);
            break;
           }
         //--- If "Exit the trading method" is received as a result of sending a request, end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_EXIT)
           {
            break;
           }
         //--- If "Correct the parameters and repeat" is received as a result of sending a request -
         //--- correct the parameters and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_CORRECT)
           {
            this.RequestErrorsCorrecting(this.m_request,order_type,trade_obj.SpreadMultiplier(),symbol_obj,trade_obj);
            continue;
           }
         //--- If "Update data and repeat" is received as a result of sending a request -
         //--- update data and start the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_REFRESH)
           {
            symbol_obj.Refresh();
            continue;
           }
         //--- If "Wait and repeat" is received as a result of sending a request -
         //--- in this implementation, we wait the number of milliseconds equal to the 'method' value and move on to the next iteration
         if(method==ERROR_CODE_PROCESSING_METHOD_WAIT)
           {
            ::Sleep(method);
            continue;
           }
         //--- If "Create a pending request" is received as a result of sending a request -
         //--- create a pending request with the trading request parameters and end the attempt loop
         if(method==ERROR_CODE_PROCESSING_METHOD_PENDING)
           {
            break;
           }
        }
     }
//--- Return the result of sending a trading request in a symbol trading object
   return res;
  }
//+------------------------------------------------------------------+
//| Return correct StopLoss relative to StopLevel                    |
//+------------------------------------------------------------------+
double CTrading::CorrectStopLoss(const ENUM_ORDER_TYPE order_type,const double price_set,const double stop_loss,const CSymbol *symbol_obj,const uint spread_multiplier=1)
  {
   if(stop_loss==0) return 0;
   uint lv=(symbol_obj.TradeStopLevel()==0 ? symbol_obj.Spread()*spread_multiplier : symbol_obj.TradeStopLevel()*spread_multiplier);
   double price=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : order_type==ORDER_TYPE_SELL ? symbol_obj.AskLast() : price_set);
   return
     (this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY            ?
      ::NormalizeDouble(fmin(price-lv*symbol_obj.Point(),stop_loss),symbol_obj.Digits())  :
      ::NormalizeDouble(fmax(price+lv*symbol_obj.Point(),stop_loss),symbol_obj.Digits())
     );
  }
//+------------------------------------------------------------------+
//| Return correct TakeProfit relative to StopLevel                  |
//+------------------------------------------------------------------+
double CTrading::CorrectTakeProfit(const ENUM_ORDER_TYPE order_type,const double price_set,const double take_profit,const CSymbol *symbol_obj,const uint spread_multiplier=1)
  {
   if(take_profit==0) return 0;
   uint lv=(symbol_obj.TradeStopLevel()==0 ? symbol_obj.Spread()*spread_multiplier : symbol_obj.TradeStopLevel()*spread_multiplier);
   double price=(order_type==ORDER_TYPE_BUY ? symbol_obj.BidLast() : order_type==ORDER_TYPE_SELL ? symbol_obj.AskLast() : price_set);
   return
     (this.DirectionByActionType((ENUM_ACTION_TYPE)order_type)==ORDER_TYPE_BUY             ?
      ::NormalizeDouble(fmax(price+lv*symbol_obj.Point(),take_profit),symbol_obj.Digits()) :
      ::NormalizeDouble(fmin(price-lv*symbol_obj.Point(),take_profit),symbol_obj.Digits())
     );
  }
//+------------------------------------------------------------------+
//| Return the correct order placement price                         |
//| relative to StopLevel                                            |
//+------------------------------------------------------------------+
double CTrading::CorrectPricePending(const ENUM_ORDER_TYPE order_type,const double price_set,const double price,const CSymbol *symbol_obj,const uint spread_multiplier=1)
  {
   uint lv=(symbol_obj.TradeStopLevel()==0 ? symbol_obj.Spread()*spread_multiplier : symbol_obj.TradeStopLevel()*spread_multiplier);
   switch((int)order_type)
     {
      case ORDER_TYPE_BUY_LIMIT        :  return ::NormalizeDouble(fmin(symbol_obj.AskLast()-lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      case ORDER_TYPE_BUY_STOP         :  return ::NormalizeDouble(fmax(symbol_obj.AskLast()+lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      case ORDER_TYPE_SELL_LIMIT       :  return ::NormalizeDouble(fmax(symbol_obj.BidLast()+lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      case ORDER_TYPE_SELL_STOP        :  return ::NormalizeDouble(fmin(symbol_obj.BidLast()-lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      
      case ORDER_TYPE_BUY_STOP_LIMIT   :  if(price==0) return ::NormalizeDouble(fmax(symbol_obj.AskLast()+lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
                                          else         return ::NormalizeDouble(fmin(price-lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      case ORDER_TYPE_SELL_STOP_LIMIT  :  if(price==0) return ::NormalizeDouble(fmin(symbol_obj.BidLast()-lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
                                          else         return ::NormalizeDouble(fmax(price+lv*symbol_obj.Point(),price_set),symbol_obj.Digits());
      default                          :  if(this.m_log_level>LOG_LEVEL_NO_MSG) ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_INVALID_ORDER_TYPE),::EnumToString(order_type)); return 0;
     }
  }
//+------------------------------------------------------------------+
//| Return the volume, at which it is possible to open a position    |
//+------------------------------------------------------------------+
double CTrading::CorrectVolume(const double price,const ENUM_ORDER_TYPE order_type,CSymbol *symbol_obj,const string source_method)
  {
//--- If funds are insufficient for the minimum lot, inform of that and return zero
   if(!this.CheckMoneyFree(symbol_obj.LotsMin(),price,order_type,symbol_obj,source_method))
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(CMessage::Text(MSG_LIB_TEXT_NOT_POSSIBILITY_CORRECT_LOT));
      return 0;
     }
//--- Update account and symbol data
   this.m_account.Refresh();
   symbol_obj.RefreshRates();
//--- Calculate the lot, which is closest to the acceptable one
   double vol=symbol_obj.NormalizedLot(this.m_account.Equity()*this.m_account.Leverage()/symbol_obj.TradeContractSize()/(symbol_obj.CurrencyBase()=="USD" ? 1.0 : symbol_obj.BidLast()));
//--- Calculate a sufficient lot
   double margin=this.m_account.MarginForAction(order_type,symbol_obj.Name(),1.0,price);
   if(margin!=EMPTY_VALUE)
      vol=symbol_obj.NormalizedLot(this.m_account.MarginFree()/margin);

//--- If the calculated lot is invalid or the margin calculation returns an error
   if(!this.CheckMoneyFree(vol,price,order_type,symbol_obj,source_method))
     {
      //--- In the do-while loop, while the calculated valid volume exceeds the minimum lot
      do
        {
         //--- Subtract the minimum lot from the valid lot value
         vol-=symbol_obj.LotsStep();
         //--- If the calculated lot allows opening a position/setting an order, return the lot value
         if(this.CheckMoneyFree(symbol_obj.NormalizedLot(vol),price,order_type,symbol_obj,source_method))
            return vol;
        }
      while(vol>symbol_obj.LotsMin() && !::IsStopped());
     }
//--- If the lot is calculated correctly, return the calculated lot
   else
      return vol;
//--- If the current stage is reached, the funds are insufficient. Inform of that and return zero
   if(this.m_log_level>LOG_LEVEL_NO_MSG)
      ::Print(CMessage::Text(MSG_LIB_TEXT_NOT_POSSIBILITY_CORRECT_LOT));
   return 0;
  }
//+------------------------------------------------------------------+
//| Create a pending request                                         |
//+------------------------------------------------------------------+
bool CTrading::CreatePendingRequest(const uchar id,const uchar attempts,const ulong wait,const MqlTradeRequest &request,const int retcode,CSymbol *symbol_obj)
  {
   //--- Create a new pending request object
   CPendingReq *req_obj=new CPendingReq(id,symbol_obj.BidLast(),symbol_obj.Time(),request,retcode);
   if(req_obj==NULL)
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_TEXT_FAILING_CREATE_PENDING_REQ));
      return false;
     }
   //--- If failed to add the request to the list, display the appropriate message,
   //--- remove the created object and return 'false'
   if(!this.m_list_request.Add(req_obj))
     {
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_TEXT_FAILING_CREATE_PENDING_REQ));
      delete req_obj;
      return false;
     }
   //--- Filled in the fields of a successfully created object by the values passed to the method
   req_obj.SetTimeActivate(symbol_obj.Time()+wait);
   req_obj.SetWaitingMSC(wait);
   req_obj.SetCurrentAttempt(0);
   req_obj.SetTotalAttempts(attempts);
   
   if(this.m_log_level>LOG_LEVEL_NO_MSG)
     {
      ::Print(CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_CREATED)," #",req_obj.ID(),":");
      req_obj.Print();
     }
   
   return true;
  }
//+------------------------------------------------------------------+
//| Look for the first free pending request ID                       |
//+------------------------------------------------------------------+
int CTrading::GetFreeID(void)
  {
   int id=WRONG_VALUE;
   CPendingReq *element=new CPendingReq();
   if(element==NULL)
      return 0;
   for(int i=1;i<256;i++)
     {
      element.SetID((uchar)i);
      this.m_list_request.Sort();
      if(this.m_list_request.Search(element)==WRONG_VALUE)
        {
         id=i;
         break;
        }
     }
   delete element;
   return id;
  }
//+------------------------------------------------------------------+
//| Return the request object index in the list by ID                |
//+------------------------------------------------------------------+
int CTrading::GetIndexPendingRequestByID(const uchar id)
  {
   CPendingReq *req=new CPendingReq();
   if(req==NULL)
      return WRONG_VALUE;
   req.SetID(id);
   this.m_list_request.Sort();
   int index=this.m_list_request.Search(req);
   delete req;
   return index;
  }
//+------------------------------------------------------------------+
