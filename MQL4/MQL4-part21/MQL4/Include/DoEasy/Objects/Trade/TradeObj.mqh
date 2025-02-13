//+------------------------------------------------------------------+
//|                                                     TradeObj.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\..\Services\DELib.mqh"
//+------------------------------------------------------------------+
//| Trading object class                                             |
//+------------------------------------------------------------------+
class CTradeObj
  {
private:
   MqlTick                    m_tick;                                            // Tick structure for receiving prices
   MqlTradeRequest            m_request;                                         // Trading request structure
   MqlTradeResult             m_result;                                          // Trading request execution result structure
   ENUM_ACCOUNT_MARGIN_MODE   m_margin_mode;                                     // Margin calculation mode
   ENUM_ORDER_TYPE_FILLING    m_type_filling;                                    // Filling policy
   ENUM_ORDER_TYPE_TIME       m_type_expiration;                                 // Order expiration type
   int                        m_symbol_expiration_flags;                         // Flags of order expiration modes for a trading object symbol
   ulong                      m_magic;                                           // Magic number
   string                     m_symbol;                                          // Symbol
   string                     m_comment;                                         // Comment
   ulong                      m_deviation;                                       // Slippage in points
   double                     m_volume;                                          // Volume
   datetime                   m_expiration;                                      // Order expiration time (for ORDER_TIME_SPECIFIED type orders)
   bool                       m_async_mode;                                      // Flag of asynchronous sending of a trade request
   ENUM_LOG_LEVEL             m_log_level;                                       // Logging level
   int                        m_stop_limit;                                      // Distance of placing a StopLimit order in points
public:
//--- Constructor
                              CTradeObj();;

//--- Set default values
   void                       Init(const string symbol,
                                   const ulong magic,
                                   const double volume,
                                   const ulong deviation,
                                   const int stoplimit,
                                   const datetime expiration,
                                   const bool async_mode,
                                   const ENUM_ORDER_TYPE_FILLING type_filling,
                                   const ENUM_ORDER_TYPE_TIME type_expiration,
                                   ENUM_LOG_LEVEL log_level);
                                   
//--- (1) Return the margin calculation mode, (2) hedge account flag
   ENUM_ACCOUNT_MARGIN_MODE   GetMarginMode(void)                                const { return this.m_margin_mode;           }
   bool                       IsHedge(void) const { return this.GetMarginMode()==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;          }
//--- (1) Set, (2) return the error logging level
   void                       SetLogLevel(const ENUM_LOG_LEVEL level)                  { this.m_log_level=level;              }
   ENUM_LOG_LEVEL             GetLogLevel(void)                                  const { return this.m_log_level;             }
//--- (1) Set, (2) return the filling policy
   void                       SetTypeFilling(const ENUM_ORDER_TYPE_FILLING type)       { this.m_type_filling=type;            }
   ENUM_ORDER_TYPE_FILLING    GetTypeFilling(void)                               const { return this.m_type_filling;          }
//--- (1) Set, (2) return order expiration type
   void                       SetTypeExpiration(const ENUM_ORDER_TYPE_TIME type)       { this.m_type_expiration=type;         }
   ENUM_ORDER_TYPE_TIME       GetTypeExpiration(void)                            const { return this.m_type_expiration;       }
//--- (1) Set, (2) return the magic number
   void                       SetMagic(const ulong magic)                              { this.m_magic=magic;                  }
   ulong                      GetMagic(void)                                     const { return this.m_magic;                 }
//--- (1) Set, (2) return a symbol
   void                       SetSymbol(const string symbol)                           { this.m_symbol=symbol;                }
   string                     GetSymbol(void)                                    const { return this.m_symbol;                }
//--- (1) Set, (2) return a comment
   void                       SetComment(const string comment)                         { this.m_comment=comment;              }
   string                     GetComment(void)                                   const { return this.m_comment;               }
//--- (1) Set, (2) return slippage
   void                       SetDeviation(const ulong deviation)                      { this.m_deviation=deviation;          }
   ulong                      GetDeviation(void)                                 const { return this.m_deviation;             }
//--- (1) Set, (2) return volume
   void                       SetVolume(const double volume)                           { this.m_volume=volume;                }
   double                     GetVolume(void)                                    const { return this.m_volume;                }
//--- (1) Set, (2) return order expiration date
   void                       SetExpiration(const datetime time)                       { this.m_expiration=time;              }
   datetime                   GetExpiration(void)                                const { return this.m_expiration;            }
//--- (1) Set, (2) return the flag of the asynchronous sending of a trading request
   void                       SetAsyncMode(const bool async)                           { this.m_async_mode=async;             }
   bool                       GetAsyncMode(void)                                 const { return this.m_async_mode;            }
   
//--- Last request data:
//--- Return (1) executed action type, (2) magic number, (3) order ticket, (4) volume,
//--- (5) open, (6) StopLimit order, (7) StopLoss, (8) TakeProfit price, (9) deviation,
//--- type of (10) order, (11) execution, (12) lifetime, (13) order expiration date,
//--- (14) comment, (15) position ticket, (16) opposite position ticket
   ENUM_TRADE_REQUEST_ACTIONS GetLastRequestAction(void)                         const { return this.m_request.action;        }
   ulong                      GetLastRequestMagic(void)                          const { return this.m_request.magic;         }
   ulong                      GetLastRequestOrder(void)                          const { return this.m_request.order;         }
   double                     GetLastRequestVolume(void)                         const { return this.m_request.volume;        }
   double                     GetLastRequestPrice(void)                          const { return this.m_request.price;         }
   double                     GetLastRequestStopLimit(void)                      const { return this.m_request.stoplimit;     }
   double                     GetLastRequestStopLoss(void)                       const { return this.m_request.sl;            }
   double                     GetLastRequestTakeProfit(void)                     const { return this.m_request.tp;            }
   ulong                      GetLastRequestDeviation(void)                      const { return this.m_request.deviation;     }
   ENUM_ORDER_TYPE            GetLastRequestType(void)                           const { return this.m_request.type;          }
   ENUM_ORDER_TYPE_FILLING    GetLastRequestTypeFilling(void)                    const { return this.m_request.type_filling;  }
   ENUM_ORDER_TYPE_TIME       GetLastRequestTypeTime(void)                       const { return this.m_request.type_time;     }
   datetime                   GetLastRequestExpiration(void)                     const { return this.m_request.expiration;    }
   string                     GetLastRequestComment(void)                        const { return this.m_request.comment;       }
   ulong                      GetLastRequestPosition(void)                       const { return this.m_request.position;      }
   ulong                      GetLastRequestPositionBy(void)                     const { return this.m_request.position_by;   }

//--- Data on the last request result:
//--- Return (1) operation result code, (2) performed deal ticket, (3) placed order ticket,
//--- (4) deal volume confirmed by a broker, (5) deal price confirmed by a broker,
//--- (6) current market Bid (requote) price, (7) current market Ask (requote) price
//--- (8) broker comment to operation (by default, it is filled by the trade server return code description),
//--- (9) request ID set by the terminal when sending, (10) external trading system return code
   uint                       GetResultRetcode(void)                             const { return this.m_result.retcode;        }
   ulong                      GetResultDeal(void)                                const { return this.m_result.deal;           }
   ulong                      GetResultOrder(void)                               const { return this.m_result.order;          }
   double                     GetResultVolume(void)                              const { return this.m_result.volume;         }
   double                     GetResultPrice(void)                               const { return this.m_result.price;          }
   double                     GetResultBid(void)                                 const { return this.m_result.bid;            }
   double                     GetResultAsk(void)                                 const { return this.m_result.ask;            }
   string                     GetResultComment(void)                             const { return this.m_result.comment;        }
   uint                       GetResultRequestID(void)                           const { return this.m_result.request_id;     }
   uint                       GetResultRetcodeEXT(void)                          const { return this.m_result.retcode_external;}

//--- Open a position
   bool                       OpenPosition(const ENUM_POSITION_TYPE type,
                                           const double volume,
                                           const double sl=0,
                                           const double tp=0,
                                           const ulong magic=ULONG_MAX,
                                           const ulong deviation=ULONG_MAX,
                                           const string comment=NULL);
//--- Close a position
   bool                       ClosePosition(const ulong ticket,
                                            const ulong deviation=ULONG_MAX,
                                            const string comment=NULL);
//--- Close a position partially
   bool                       ClosePositionPartially(const ulong ticket,
                                                     const double volume,
                                                     const ulong deviation=ULONG_MAX,
                                                     const string comment=NULL);
//--- Close a position by an opposite one
   bool                       ClosePositionBy(const ulong ticket,const ulong ticket_by);
//--- Modify a position
   bool                       ModifyPosition(const ulong ticket,const double sl=WRONG_VALUE,const double tp=WRONG_VALUE);
//--- Place an order
   bool                       SetOrder(const ENUM_ORDER_TYPE type,
                                       const double volume,
                                       const double price,
                                       const double sl=0,
                                       const double tp=0,
                                       const double price_stoplimit=0,
                                       const ulong magic=ULONG_MAX,
                                       const datetime expiration=0,
                                       const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,
                                       const string comment=NULL);
//--- Remove an order
   bool                       DeleteOrder(const ulong ticket);
//--- Modify an order
   bool                       ModifyOrder(const ulong ticket,
                                          const double price=WRONG_VALUE,
                                          const double sl=WRONG_VALUE,
                                          const double tp=WRONG_VALUE,
                                          const double price_stoplimit=WRONG_VALUE,
                                          const datetime expiration=WRONG_VALUE,
                                          const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE);
   
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTradeObj::CTradeObj(void) : m_magic(0),
                             m_deviation(5),
                             m_stop_limit(0),
                             m_expiration(0),
                             m_async_mode(false),
                             m_type_filling(ORDER_FILLING_FOK),
                             m_type_expiration(ORDER_TIME_GTC),
                             m_comment(::MQLInfoString(MQL_PROGRAM_NAME)+" by DoEasy"),
                             m_log_level(LOG_LEVEL_ERROR_MSG)
  {
   //--- Margin calculation mode
   this.m_margin_mode=
     (
      #ifdef __MQL5__ (ENUM_ACCOUNT_MARGIN_MODE)::AccountInfoInteger(ACCOUNT_MARGIN_MODE)
      #else /* MQL4 */ ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif 
     );
  }
//+------------------------------------------------------------------+
//| Set default values                                               |
//+------------------------------------------------------------------+
void CTradeObj::Init(const string symbol,
                     const ulong magic,
                     const double volume,
                     const ulong deviation,
                     const int stoplimit,
                     const datetime expiration,
                     const bool async_mode,
                     const ENUM_ORDER_TYPE_FILLING type_filling,
                     const ENUM_ORDER_TYPE_TIME type_expiration,
                     ENUM_LOG_LEVEL log_level)
  {
   this.SetSymbol(symbol);
   this.SetMagic(magic);
   this.SetDeviation(deviation);
   this.SetVolume(volume);
   this.SetExpiration(expiration);
   this.SetTypeFilling(type_filling);
   this.SetTypeExpiration(type_expiration);
   this.SetAsyncMode(async_mode);
   this.SetLogLevel(log_level);
   this.m_symbol_expiration_flags=(int)::SymbolInfoInteger(this.m_symbol,SYMBOL_EXPIRATION_MODE);
   this.m_volume=::SymbolInfoDouble(this.m_symbol,SYMBOL_VOLUME_MIN);
  }
//+------------------------------------------------------------------+
//| Open a position                                                  |
//+------------------------------------------------------------------+
bool CTradeObj::OpenPosition(const ENUM_POSITION_TYPE type,
                             const double volume,
                             const double sl=0,
                             const double tp=0,
                             const ulong magic=ULONG_MAX,
                             const ulong deviation=ULONG_MAX,
                             const string comment=NULL)
  {
   //--- If failed to get the current prices, write the error code and description, send the message to the journal and return 'false'
   if(!::SymbolInfoTick(this.m_symbol,this.m_tick))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_NOT_GET_PRICE),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   this.m_request.action   =  TRADE_ACTION_DEAL;
   this.m_request.symbol   =  this.m_symbol;
   this.m_request.magic    =  (magic==ULONG_MAX ? this.m_magic : magic);
   this.m_request.type     =  OrderTypeByPositionType(type);
   this.m_request.price    =  (type==POSITION_TYPE_BUY ? this.m_tick.ask : this.m_tick.bid);
   this.m_request.volume   =  volume;
   this.m_request.sl       =  sl;
   this.m_request.tp       =  tp;
   this.m_request.deviation=  (deviation==ULONG_MAX ? this.m_deviation : deviation);
   this.m_request.comment  =  (comment==NULL ? this.m_comment : comment);
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         (::OrderSend(m_request.symbol,m_request.type,m_request.volume,m_request.price,(int)m_request.deviation,m_request.sl,m_request.tp,m_request.comment,(int)m_request.magic,m_request.expiration,clrNONE)!=WRONG_VALUE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Close a position                                                 |
//+------------------------------------------------------------------+
bool CTradeObj::ClosePosition(const ulong ticket,
                              const ulong deviation=ULONG_MAX,
                              const string comment=NULL)
  {
   //--- If failed to select a position. Write the error code and description, send the message to the journal and return 'false'
   if(!::PositionSelectByTicket(ticket))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_POS),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get a position symbol
   string symbol=::PositionGetString(POSITION_SYMBOL);
   //--- If failed to get the current prices, write the error code and description, send the message to the journal and return 'false'
   if(!::SymbolInfoTick(symbol,this.m_tick))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_NOT_GET_PRICE),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get a position type and an order type inverse of the position type
   ENUM_POSITION_TYPE position_type=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);
   ENUM_ORDER_TYPE type=OrderTypeOppositeByPositionType(position_type);
   //--- Get a position volume and magic number
   double position_volume=::PositionGetDouble(POSITION_VOLUME);
   ulong magic=::PositionGetInteger(POSITION_MAGIC);
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   this.m_request.action   =  TRADE_ACTION_DEAL;
   this.m_request.symbol   =  symbol;
   this.m_request.magic    =  magic;
   this.m_request.type     =  type;
   this.m_request.price    =  (position_type==POSITION_TYPE_SELL ? this.m_tick.ask : this.m_tick.bid);
   this.m_request.volume   =  position_volume;
   this.m_request.deviation=  (deviation==ULONG_MAX ? this.m_deviation : deviation);
   this.m_request.comment  =  (comment==NULL ? this.m_comment : comment);
   //--- In case of a hedging account, write the ticket of a closed position to the structure
   if(this.IsHedge())
      this.m_request.position=::PositionGetInteger(POSITION_TICKET);
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderClose((int)m_request.position,m_request.volume,m_request.price,(int)m_request.deviation,clrNONE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Close a position partially                                       |
//+------------------------------------------------------------------+
bool CTradeObj::ClosePositionPartially(const ulong ticket,
                                       const double volume,
                                       const ulong deviation=ULONG_MAX,
                                       const string comment=NULL)
  {
   //--- If failed to select a position. Write the error code and description, send the message to the journal and return 'false'
   if(!::PositionSelectByTicket(ticket))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_POS),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get a position symbol
   string symbol=::PositionGetString(POSITION_SYMBOL);
   //--- If failed to get the current prices, write the error code and description, send the message to the journal and return 'false'
   if(!::SymbolInfoTick(symbol,this.m_tick))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_NOT_GET_PRICE),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get a position type and an order type inverse of the position type
   ENUM_POSITION_TYPE position_type=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);
   ENUM_ORDER_TYPE type=OrderTypeOppositeByPositionType(position_type);
   //--- Get a position volume and magic number
   double position_volume=::PositionGetDouble(POSITION_VOLUME);
   ulong magic=::PositionGetInteger(POSITION_MAGIC);
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   this.m_request.action   =  TRADE_ACTION_DEAL;
   this.m_request.position =  ticket;
   this.m_request.symbol   =  symbol;
   this.m_request.magic    =  magic;
   this.m_request.type     =  type;
   this.m_request.price    =  (position_type==POSITION_TYPE_SELL ? this.m_tick.ask : this.m_tick.bid);
   this.m_request.volume   =  (volume<position_volume ? volume : position_volume);
   this.m_request.deviation=  (deviation==ULONG_MAX ? this.m_deviation : deviation);
   this.m_request.comment  =  (comment==NULL ? this.m_comment : comment);
   //--- In case of a hedging account, write the ticket of a closed position to the structure
   if(this.IsHedge())
      this.m_request.position=::PositionGetInteger(POSITION_TICKET);
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderClose((int)m_request.position,m_request.volume,m_request.price,(int)m_request.deviation,clrNONE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Close a position by an opposite one                              |
//+------------------------------------------------------------------+
bool CTradeObj::ClosePositionBy(const ulong ticket,const ulong ticket_by)
  {
   #ifdef __MQL5__
   //--- If this is not a hedging account. 
   if(::AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
     {
      //--- Close by is available only on hedging accounts.
      //---Write the error code and description, send the message to the journal and return 'false'
      this.m_result.retcode=MSG_ACC_UNABLE_CLOSE_BY;
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_ACC_UNABLE_CLOSE_BY));
      return false;
     }
   #endif 
//--- Closed position
   //--- If failed to select a position, write the error code and description, send the message to the journal and return 'false'
   if(!::PositionSelectByTicket(ticket))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_POS),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get a type and magic of a closed position
   ENUM_POSITION_TYPE position_type=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);
   ulong magic=::PositionGetInteger(POSITION_MAGIC);
   
//--- Opposite position
   //--- If failed to select a position, write the error code and description, send the message to the journal and return 'false'
   if(!::PositionSelectByTicket(ticket_by))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket_by,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_POS),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Get an opposite position type
   ENUM_POSITION_TYPE position_type_by=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);
   //--- If types of a closed and an opposite position match, write the error code and description, send the message to the journal and return 'false'
   if(position_type==position_type_by)
     {
      this.m_result.retcode=MSG_ACC_SAME_TYPE_CLOSE_BY;
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,CMessage::Text(MSG_ACC_SAME_TYPE_CLOSE_BY));
      return false;
     }
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   this.m_request.action      =  TRADE_ACTION_CLOSE_BY;
   this.m_request.position    =  ticket;
   this.m_request.position_by =  ticket_by;
   this.m_request.magic       =  magic;
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderCloseBy((int)m_request.position,(int)m_request.position_by,clrNONE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Modify a position                                                |
//+------------------------------------------------------------------+
bool CTradeObj::ModifyPosition(const ulong ticket,const double sl=WRONG_VALUE,const double tp=WRONG_VALUE)
  {
   //--- If all default values are passed, there is nothing to be modified
   if(sl==WRONG_VALUE && tp==WRONG_VALUE)
     {
      //--- There are no changes in the request - write the error code and description, send the message to the journal and return 'false'
      this.m_result.retcode= #ifdef __MQL5__ TRADE_RETCODE_NO_CHANGES #else 10025 #endif ;
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,CMessage::Text(this.m_result.retcode),CMessage::Retcode(this.m_result.retcode));
      return false;
     }
   //--- If failed to select a position, write the error code and description, send the message to the journal and return 'false'
   if(!::PositionSelectByTicket(ticket))
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_POS),CMessage::Text(this.m_result.retcode));
      return false;
     }
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   m_request.action  =  TRADE_ACTION_SLTP;
   m_request.position=  ticket;
   m_request.symbol  =  ::PositionGetString(POSITION_SYMBOL);
   m_request.magic   =  ::PositionGetInteger(POSITION_MAGIC);
   m_request.sl      =  (sl==WRONG_VALUE ? ::PositionGetDouble(POSITION_SL) : sl);
   m_request.tp      =  (tp==WRONG_VALUE ? ::PositionGetDouble(POSITION_TP) : tp);
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderModify((int)m_request.position,::OrderOpenPrice(),m_request.sl,m_request.tp,::OrderExpiration(),clrNONE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Place an order                                                   |
//+------------------------------------------------------------------+
bool CTradeObj::SetOrder(const ENUM_ORDER_TYPE type,
                         const double volume,
                         const double price,
                         const double sl=0,
                         const double tp=0,
                         const double price_stoplimit=0,
                         const ulong magic=ULONG_MAX,
                         const datetime expiration=0,
                         const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,
                         const string comment=NULL)
  {
   //--- If an invalid order type has been passed, write the error code and description, send the message to the journal and return 'false'
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_SELL || type==ORDER_TYPE_CLOSE_BY 
      #ifdef __MQL4__ || type==ORDER_TYPE_BUY_STOP_LIMIT || type==ORDER_TYPE_SELL_STOP_LIMIT #endif )
     {
      this.m_result.retcode=MSG_LIB_SYS_INVALID_ORDER_TYPE;
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_INVALID_ORDER_TYPE),OrderTypeDescription(type));
      return false;
     }
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   m_request.action     =  TRADE_ACTION_PENDING;
   m_request.symbol     =  this.m_symbol;
   m_request.magic      =  (magic==ULONG_MAX ? this.m_magic : magic);
   m_request.volume     =  volume;
   m_request.type       =  type;
   m_request.stoplimit  =  price_stoplimit;
   m_request.price      =  price;
   m_request.sl         =  sl;
   m_request.tp         =  tp;
   m_request.type_time  =  type_time;
   m_request.expiration =  expiration;
   m_request.comment    =  (comment==NULL ? this.m_comment : comment);
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         (::OrderSend(m_request.symbol,m_request.type,m_request.volume,m_request.price,(int)m_request.deviation,m_request.sl,m_request.tp,m_request.comment,(int)m_request.magic,m_request.expiration,clrNONE)!=WRONG_VALUE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Remove an order                                                  |
//+------------------------------------------------------------------+
bool CTradeObj::DeleteOrder(const ulong ticket)
  {
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   m_request.action  =  TRADE_ACTION_REMOVE;
   m_request.order   =  ticket;
   //--- Return the result of sending a request to the server
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderDelete((int)m_request.order,clrNONE)
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Modify an order                                                  |
//+------------------------------------------------------------------+
bool CTradeObj::ModifyOrder(const ulong ticket,
                            const double price=WRONG_VALUE,
                            const double sl=WRONG_VALUE,
                            const double tp=WRONG_VALUE,
                            const double price_stoplimit=WRONG_VALUE,
                            const datetime expiration=WRONG_VALUE,
                            const ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE)
  {
   //--- If failed to select an order, write the error code and description, send the message to the journal and return 'false'
   #ifdef __MQL5__
   if(!::OrderSelect(ticket))
   #else 
   if(!::OrderSelect((int)ticket,SELECT_BY_TICKET))
   #endif 
     {
      this.m_result.retcode=::GetLastError();
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,"#",(string)ticket,": ",CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_SELECT_ORD),CMessage::Text(this.m_result.retcode));
      return false;
     }
   double order_price=::OrderGetDouble(ORDER_PRICE_OPEN);
   double order_sl=::OrderGetDouble(ORDER_SL);
   double order_tp=::OrderGetDouble(ORDER_TP);
   double order_stoplimit=::OrderGetDouble(ORDER_PRICE_STOPLIMIT);
   ENUM_ORDER_TYPE_TIME order_type_time=(ENUM_ORDER_TYPE_TIME)::OrderGetInteger(ORDER_TYPE_TIME);
   datetime order_expiration=(datetime)::OrderGetInteger(ORDER_TIME_EXPIRATION);
   //--- If the default values are passed and the price is equal to the price set in the order, the request is unchanged
   //---Write the error code and description, send the message to the journal and return 'false'
   if(price==order_price && sl==WRONG_VALUE && tp==WRONG_VALUE && price_stoplimit==WRONG_VALUE && type_time==WRONG_VALUE && expiration==WRONG_VALUE)
     {
      this.m_result.retcode = #ifdef __MQL5__ TRADE_RETCODE_NO_CHANGES #else 10025 #endif ;
      this.m_result.comment=CMessage::Text(this.m_result.retcode);
      if(this.m_log_level>LOG_LEVEL_NO_MSG)
         Print(DFUN,CMessage::Text(this.m_result.retcode),CMessage::Retcode(this.m_result.retcode));
      return false;
     }
   //--- Clear the structures
   ::ZeroMemory(this.m_request);
   ::ZeroMemory(this.m_result);
   //--- Fill in the request structure
   m_request.action     =  TRADE_ACTION_MODIFY;
   m_request.order      =  ticket;
   m_request.price      =  (price==WRONG_VALUE ? order_price : price);
   m_request.sl         =  (sl==WRONG_VALUE ? order_sl : sl);
   m_request.tp         =  (tp==WRONG_VALUE ? order_tp : tp);
   m_request.stoplimit  =  (price_stoplimit==WRONG_VALUE ? order_stoplimit : price_stoplimit);
   m_request.type_time  =  (type_time==WRONG_VALUE ? order_type_time : type_time);
   m_request.expiration =  (expiration==WRONG_VALUE ? order_expiration : expiration);
   //--- Return an order modification result
   return
     (
      #ifdef __MQL5__
         !this.m_async_mode ? ::OrderSend(this.m_request,this.m_result) : ::OrderSendAsync(this.m_request,this.m_result)
      #else 
         ::OrderModify((int)m_request.order,m_request.price,m_request.sl,m_request.tp,m_request.expiration,clrNONE)
      #endif 
     );
   Print(DFUN);
  }
//+------------------------------------------------------------------+
