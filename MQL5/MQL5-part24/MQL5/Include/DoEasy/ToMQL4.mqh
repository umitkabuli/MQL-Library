//+------------------------------------------------------------------+
//|                                                       ToMQL4.mqh |
//|              Copyright 2017, Artem A. Trishkin, Skype artmedia70 |
//|                         https://www.mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Artem A. Trishkin, Skype artmedia70"
#property link      "https://www.mql5.com/en/users/artmedia70"
#property strict
#ifdef __MQL4__
//+------------------------------------------------------------------+
//| Error codes                                                      |
//+------------------------------------------------------------------+
#define ERR_SUCCESS                       (ERR_NO_ERROR)
#define ERR_MARKET_UNKNOWN_SYMBOL         (ERR_UNKNOWN_SYMBOL)
#define ERR_ZEROSIZE_ARRAY                (ERR_ARRAY_INVALID)
#define ERR_MAIL_SEND_FAILED              (ERR_SEND_MAIL_ERROR)
#define ERR_NOTIFICATION_SEND_FAILED      (ERR_NOTIFICATION_ERROR)
#define ERR_FTP_SEND_FAILED               (ERR_FTP_ERROR)
//+------------------------------------------------------------------+
//| Order types, execution policy, lifetime, reasons                 |
//+------------------------------------------------------------------+
#define ORDER_TYPE_CLOSE_BY               (8)
#define ORDER_TYPE_BUY_STOP_LIMIT         (9)
#define ORDER_TYPE_SELL_STOP_LIMIT        (10)
#define ORDER_REASON_EXPERT               (3)
#define ORDER_REASON_SL                   (4)
#define ORDER_REASON_TP                   (5)
#define ORDER_REASON_BALANCE              (6)
#define ORDER_REASON_CREDIT               (7)
//+------------------------------------------------------------------+
//| Flags of allowed order expiration modes                          |
//+------------------------------------------------------------------+
#define SYMBOL_EXPIRATION_GTC             (1)
#define SYMBOL_EXPIRATION_DAY             (2)
#define SYMBOL_EXPIRATION_SPECIFIED       (4)
#define SYMBOL_EXPIRATION_SPECIFIED_DAY   (8)
//+------------------------------------------------------------------+
//| Flags of allowed order filling modes                             |
//+------------------------------------------------------------------+
#define SYMBOL_FILLING_FOK                (1)
#define SYMBOL_FILLING_IOC                (2)
//+------------------------------------------------------------------+
//| Flags of allowed order types                                     |
//+------------------------------------------------------------------+
#define SYMBOL_ORDER_MARKET               (1)
#define SYMBOL_ORDER_LIMIT                (2)
#define SYMBOL_ORDER_STOP                 (4)
#define SYMBOL_ORDER_STOP_LIMIT           (8)
#define SYMBOL_ORDER_SL                   (16)
#define SYMBOL_ORDER_TP                   (32)
#define SYMBOL_ORDER_CLOSEBY              (64)
//+------------------------------------------------------------------+
//| MQL5 deal types                                                  |
//+------------------------------------------------------------------+
enum ENUM_DEAL_TYPE
  {
   DEAL_TYPE_BUY,
   DEAL_TYPE_SELL,
   DEAL_TYPE_BALANCE,
   DEAL_TYPE_CREDIT,
   DEAL_TYPE_CHARGE,
   DEAL_TYPE_CORRECTION,
   DEAL_TYPE_BONUS,
   DEAL_TYPE_COMMISSION,
   DEAL_TYPE_COMMISSION_DAILY,
   DEAL_TYPE_COMMISSION_MONTHLY,
   DEAL_TYPE_COMMISSION_AGENT_DAILY,
   DEAL_TYPE_COMMISSION_AGENT_MONTHLY,
   DEAL_TYPE_INTEREST,
   DEAL_TYPE_BUY_CANCELED,
   DEAL_TYPE_SELL_CANCELED,
   DEAL_DIVIDEND,
   DEAL_DIVIDEND_FRANKED,
   DEAL_TAX
  };
//+------------------------------------------------------------------+
//| Position change method                                           |
//+------------------------------------------------------------------+
enum ENUM_DEAL_ENTRY
  {
   DEAL_ENTRY_IN,
   DEAL_ENTRY_OUT,
   DEAL_ENTRY_INOUT,
   DEAL_ENTRY_OUT_BY
  };
//+------------------------------------------------------------------+
//| Open position direction                                          |
//+------------------------------------------------------------------+
enum ENUM_POSITION_TYPE
  {
   POSITION_TYPE_BUY,
   POSITION_TYPE_SELL
  };
//+------------------------------------------------------------------+
//| Order state                                                      |
//+------------------------------------------------------------------+
enum ENUM_ORDER_STATE
  {
   ORDER_STATE_STARTED,
   ORDER_STATE_PLACED,
   ORDER_STATE_CANCELED,
   ORDER_STATE_PARTIAL,
   ORDER_STATE_FILLED,
   ORDER_STATE_REJECTED,
   ORDER_STATE_EXPIRED,
   ORDER_STATE_REQUEST_ADD,
   ORDER_STATE_REQUEST_MODIFY,
   ORDER_STATE_REQUEST_CANCEL
  };
//+------------------------------------------------------------------+
//| Margin calculation mode                                          |
//+------------------------------------------------------------------+
enum ENUM_ACCOUNT_MARGIN_MODE
  {
   ACCOUNT_MARGIN_MODE_RETAIL_NETTING,
   ACCOUNT_MARGIN_MODE_EXCHANGE,
   ACCOUNT_MARGIN_MODE_RETAIL_HEDGING
  };
//+------------------------------------------------------------------+
//| Prices a symbol chart is based on                                |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_CHART_MODE
  {
   SYMBOL_CHART_MODE_BID,                          // Bars are based on Bid prices
   SYMBOL_CHART_MODE_LAST                          // Bars are based on Last prices
  };
//+------------------------------------------------------------------+
//| The lifetime of pending orders and                               |
//| placed StopLoss/TakeProfit levels                                |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_ORDER_GTC_MODE
  {
   SYMBOL_ORDERS_GTC,                              // Pending orders and Stop Loss/Take Profit levels are valid for an unlimited period until their explicit cancellation
   SYMBOL_ORDERS_DAILY,                            // At the end of the day, all Stop Loss and Take Profit levels, as well as pending orders are deleted
   SYMBOL_ORDERS_DAILY_EXCLUDING_STOPS             // At the end of the day, only pending orders are deleted, while Stop Loss and Take Profit levels are preserved
  };
//+------------------------------------------------------------------+
//| Option types                                                     |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_OPTION_MODE
  {
   SYMBOL_OPTION_MODE_EUROPEAN,                    // European option may only be exercised on a specified date
   SYMBOL_OPTION_MODE_AMERICAN                     // American option may be exercised on any trading day or before expiry
  };
#define SYMBOL_OPTION_MODE_NONE     (2)            // Option type absent in MQL4
//+------------------------------------------------------------------+
//| Right provided by an option                                      |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_OPTION_RIGHT
  {
   SYMBOL_OPTION_RIGHT_CALL,                       // A call option gives you the right to buy an asset at a specified price
   SYMBOL_OPTION_RIGHT_PUT                         // A put option gives you the right to sell an asset at a specified price
  };
#define SYMBOL_OPTION_RIGHT_NONE    (2)            // No option - no right
//+------------------------------------------------------------------+
//| Symbol margin calculation method                                 |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_CALC_MODE
  {
   SYMBOL_CALC_MODE_FOREX,                         // (MQL5 - 0, MQL4 - 0) Forex mode
   SYMBOL_CALC_MODE_CFD,                           // (MQL5 - 3, MQL4 - 1) CFD mode
   SYMBOL_CALC_MODE_FUTURES,                       // (MQL5 - 2, MQL4 - 2) Futures mode
   SYMBOL_CALC_MODE_CFDINDEX,                      // (MQL5 - 4, MQL4 - 3) CFD index mode
   SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE,             // (MQL5 - 1, MQL4 - N) Forex No Leverage mode
   SYMBOL_CALC_MODE_CFDLEVERAGE,                   // CFD Leverage mode
   SYMBOL_CALC_MODE_EXCH_STOCKS,                   // Exchange mode
   SYMBOL_CALC_MODE_EXCH_FUTURES,                  // Futures mode
   SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS,            // FORTS Futures mode
   SYMBOL_CALC_MODE_EXCH_BONDS,                    // Exchange Bonds mode
   SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX,              // Exchange MOEX Stocks mode
   SYMBOL_CALC_MODE_EXCH_BONDS_MOEX,               // Exchange MOEX Bonds mode
   SYMBOL_CALC_MODE_SERV_COLLATERAL,               // Collateral mode - a symbol is used as a non-tradable asset on a trading account
   SYMBOL_CALC_MODE_EXCH_OPTIONS_MARGIN            // Option
  };  
//+------------------------------------------------------------------+
//| Swap charging methods during a rollover                          |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_SWAP_MODE
  {
   SYMBOL_SWAP_MODE_POINTS,                        // (MQL5 - 1, MQL4 - 0) Swaps are charged in points
   SYMBOL_SWAP_MODE_CURRENCY_SYMBOL,               // (MQL5 - 2, MQL4 - 1) Swaps are charged in money in symbol base currency
   SYMBOL_SWAP_MODE_INTEREST_OPEN,                 // (MQL5 - 6, MQL4 - 2) Swaps are charged as the specified annual interest from the open price of position
   SYMBOL_SWAP_MODE_CURRENCY_MARGIN,               // (MQL5 - 3, MQL4 - 3) Swaps are charged in money in margin currency of the symbol
   SYMBOL_SWAP_MODE_DISABLED,                      // (MQL5 - 0, MQL4 - N) No swaps
   SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT,              // Swaps are charged in money, in client deposit currency
   SYMBOL_SWAP_MODE_INTEREST_CURRENT,              // Swaps are charged as the specified annual interest from the instrument price at calculation of swap
   SYMBOL_SWAP_MODE_REOPEN_CURRENT,                // Swaps are charged by reopening positions by the close price
   SYMBOL_SWAP_MODE_REOPEN_BID                     // Swaps are charged by reopening positions by the current Bid price
  };
//+------------------------------------------------------------------+
//| Trade operation types                                            |
//+------------------------------------------------------------------+
enum ENUM_TRADE_REQUEST_ACTIONS
  {
   TRADE_ACTION_DEAL,                              // Place an order for an instant deal with the specified parameters (set a market order)
   TRADE_ACTION_PENDING,                           // Place an order for performing a deal at specified conditions (pending order)
   TRADE_ACTION_SLTP,                              // Change open position Stop Loss and Take Profit
   TRADE_ACTION_MODIFY,                            // Change parameters of the previously placed trading order
   TRADE_ACTION_REMOVE,                            // Remove previously placed pending order
   TRADE_ACTION_CLOSE_BY,                          // Close a position by an opposite one 
  };
//+------------------------------------------------------------------+
//| Order filling policies                                           |
//+------------------------------------------------------------------+
enum ENUM_ORDER_TYPE_FILLING
  {
   ORDER_FILLING_FOK,                              // Fill or Kill
   ORDER_FILLING_IOC,                              // Immediate or Cancel (unfilled portion is removed)
   ORDER_FILLING_RETURN                            //  Immediate or Cancel (unfilled portion is not removed) 
  };
//+------------------------------------------------------------------+
//| Order expiration term                                            |
//+------------------------------------------------------------------+
enum ENUM_ORDER_TYPE_TIME
  {
   ORDER_TIME_GTC,                                 // The order will stay in the queue until it is manually canceled
   ORDER_TIME_DAY,                                 // The order will be valid only during the current trading day
   ORDER_TIME_SPECIFIED,                           // The order will be valid until the specified date
   ORDER_TIME_SPECIFIED_DAY,                       // The order will be valid until 23:59:59 of the specified day
  };
//+------------------------------------------------------------------+
//| Integer properties of a selected position                        |
//+------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_INTEGER
  {
   POSITION_TICKET,                                // Position ticket
   POSITION_TIME,                                  // Position open time
   POSITION_TIME_MSC,                              // Position opening time in milliseconds since 01.01.1970 
   POSITION_TIME_UPDATE,                           // Position changing time in seconds since 01.01.1970
   POSITION_TIME_UPDATE_MSC,                       // Position changing time in milliseconds since 01.01.1970
   POSITION_TYPE,                                  // Position type
   POSITION_MAGIC,                                 // Magic number for a position 
   POSITION_IDENTIFIER,                            // Position ID 
   POSITION_REASON,                                // Position opening reason
  };
//+------------------------------------------------------------------+
//| Real properties of a selected position                          |
//+------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_DOUBLE
  {
   POSITION_VOLUME,                                // Position volume
   POSITION_PRICE_OPEN,                            // Position price
   POSITION_SL,                                    // Stop Loss level for an open position
   POSITION_TP,                                    // Take Profit level for an open position
   POSITION_PRICE_CURRENT,                         // Symbol current price
   POSITION_SWAP,                                  // Accumulated swap
   POSITION_PROFIT,                                // Current profit
  };
//+------------------------------------------------------------------+
//| String properties of a selected position                         |
//+------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTY_STRING
  {
   POSITION_SYMBOL,                                // Symbol a position is opened for
   POSITION_COMMENT,                               // Comment to a position
   POSITION_EXTERNAL_ID,                           // Position ID in an external system (on the exchange)
  };
//+------------------------------------------------------------------+
//| Trade request structure                                          |
//+------------------------------------------------------------------+
struct MqlTradeRequest 
  { 
   ENUM_TRADE_REQUEST_ACTIONS    action;           // Type of a performed action 
   ulong                         magic;            // Stamp of an Expert Advisor (the magic number identifier) 
   ulong                         order;            // Order ticket 
   string                        symbol;           // Symbol name 
   double                        volume;           // Requested volume of a deal in lots 
   double                        price;            // Price  
   double                        stoplimit;        // StopLimit 
   double                        sl;               // Stop Loss 
   double                        tp;               // Take Profit 
   ulong                         deviation;        // Maximum acceptable deviation from the requested price 
   ENUM_ORDER_TYPE               type;             // Order type 
   ENUM_ORDER_TYPE_FILLING       type_filling;     // Order filling type 
   ENUM_ORDER_TYPE_TIME          type_time;        // Order lifetime type 
   datetime                      expiration;       // Order expiration time (for ORDER_TIME_SPECIFIED type orders) 
   string                        comment;          // Order comment 
   ulong                         position;         // Position ticket 
   ulong                         position_by;      // Opposite position ticket 
  };
//+------------------------------------------------------------------+
//| Structure of the trade request result                            |
//+------------------------------------------------------------------+
struct MqlTradeResult 
  { 
   uint     retcode;                               // Operation result code 
   ulong    deal;                                  // Deal ticket if executed 
   ulong    order;                                 // Order ticket if placed 
   double   volume;                                // Deal volume confirmed by a broker 
   double   price;                                 // Deal price confirmed by a broker 
   double   bid;                                   // The current market Bid price (requote price) 
   double   ask;                                   // The current market Ask price (requote price) 
   string   comment;                               // Broker comment to operation (by default, it is filled by the trade server return code description) 
   uint     request_id;                            // Request ID set by the terminal when sending  
   uint     retcode_external;                      // Response code of an external trading system 
  };
//+------------------------------------------------------------------+
//| Select a position by ticket                                      |
//+------------------------------------------------------------------+
bool PositionSelectByTicket(ulong ticket)
  {
   return ::OrderSelect((int)ticket,SELECT_BY_TICKET);
  }
//+------------------------------------------------------------------+
//| Return a requested integer property of a selected position       |
//+------------------------------------------------------------------+
long PositionGetInteger(ENUM_POSITION_PROPERTY_INTEGER property)
  {
   return
     (
      property==POSITION_TICKET           ?  ::OrderTicket()      :  // Position ticket
      property==POSITION_TIME             ?  ::OrderOpenTime()    :  // Position open time
      property==POSITION_TIME_MSC         ?  ::OrderOpenTime()    :  // Position open time in milliseconds since 01.01.1970  (equivalent - open time)
      property==POSITION_TIME_UPDATE      ?  ::OrderOpenTime()    :  // Position change time in seconds since 01.01.1970      (rough equivalent - open time)
      property==POSITION_TIME_UPDATE_MSC  ?  ::OrderOpenTime()    :  // Position change time in seconds since 01.01.1970 (rough equivalent - open time)
      property==POSITION_TYPE             ?  ::OrderType()        :  // Position type
      property==POSITION_MAGIC            ?  ::OrderMagicNumber() :  // Position magic number 
      property==POSITION_IDENTIFIER       ?  ::OrderTicket()      :  // Position ID (equivalent - ticket)
      WRONG_VALUE                                                    // POSITION_REASON Position opening reason (no equivalents in MQL4)
     );
  }
//+------------------------------------------------------------------+
//| Return a requested real property of a selected position          |
//+------------------------------------------------------------------+
double PositionGetDouble(ENUM_POSITION_PROPERTY_DOUBLE property)
  {
   return
     (
      property==POSITION_VOLUME           ?  ::OrderLots()        :  // Position volume
      property==POSITION_PRICE_OPEN       ?  ::OrderOpenPrice()   :  // Position price
      property==POSITION_SL               ?  ::OrderStopLoss()    :  // Stop Loss level for an open position
      property==POSITION_TP               ?  ::OrderTakeProfit()  :  // Take Profit level for an open position
      property==POSITION_SWAP             ?  ::OrderSwap()        :  // Accumulated swap
      property==POSITION_PROFIT           ?  ::OrderProfit()      :  // Current profit
      WRONG_VALUE                                                    // POSITION_PRICE_CURRENT Symbol current price (no equivalents in MQL4)
     );
  }
//+------------------------------------------------------------------+
//| Return a requested string property of a selected position        |
//+------------------------------------------------------------------+
string PositionGetString(ENUM_POSITION_PROPERTY_STRING property)
  {
   return
     (
      property==POSITION_SYMBOL           ?  OrderSymbol()        :  // Symbol a position is opened for
      property==POSITION_COMMENT          ?  OrderComment()       :  // Comment to a position
      NULL                                                           // POSITION_EXTERNAL_ID Position ID in an external system (on the exchange) (no equivalents in MQL4)
     );
  }
//+------------------------------------------------------------------+
#endif 
