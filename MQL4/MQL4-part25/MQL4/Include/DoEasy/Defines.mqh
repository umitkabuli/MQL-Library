//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "DataSND.mqh"
#include "DataIMG.mqh"
#include "Datas.mqh"
#ifdef __MQL4__
#include "ToMQL4.mqh"
#endif 
//+------------------------------------------------------------------+
//| Macro substitutions                                              |
//+------------------------------------------------------------------+
//--- Describe the function with the error line number
#define DFUN_ERR_LINE                  (__FUNCTION__+(TerminalInfoString(TERMINAL_LANGUAGE)=="Russian" ? ", Page " : ", Line ")+(string)__LINE__+": ")
#define DFUN                           (__FUNCTION__+": ")        // "Function description"
#define COUNTRY_LANG                   ("Russian")                // Country language
#define END_TIME                       (D'31.12.3000 23:59:59')   // End date for account history data requests
#define TIMER_FREQUENCY                (16)                       // Minimal frequency of the library timer in milliseconds
#define TOTAL_TRY                      (5)                        // Default number of trading attempts
//--- Standard sounds
#define SND_ALERT                      "alert.wav"
#define SND_ALERT2                     "alert2.wav"
#define SND_CONNECT                    "connect.wav"
#define SND_DISCONNECT                 "disconnect.wav"
#define SND_EMAIL                      "email.wav"
#define SND_EXPERT                     "expert.wav"
#define SND_NEWS                       "news.wav"
#define SND_OK                         "ok.wav"
#define SND_REQUEST                    "request.wav"
#define SND_STOPS                      "stops.wav"
#define SND_TICK                       "tick.wav"
#define SND_TIMEOUT                    "timeout.wav"
#define SND_WAIT                       "wait.wav"
//--- Parameters of the orders and deals collection timer
#define COLLECTION_ORD_PAUSE           (250)                      // Orders and deals collection timer pause in milliseconds
#define COLLECTION_ORD_COUNTER_STEP    (16)                       // Increment of the orders and deals collection timer counter
#define COLLECTION_ORD_COUNTER_ID      (1)                        // Orders and deals collection timer counter ID
//--- Parameters of the account collection timer
#define COLLECTION_ACC_PAUSE           (1000)                     // Account collection timer pause in milliseconds
#define COLLECTION_ACC_COUNTER_STEP    (16)                       // Account timer counter increment
#define COLLECTION_ACC_COUNTER_ID      (2)                        // Account timer counter ID
//--- Symbol collection timer 1 parameters
#define COLLECTION_SYM_PAUSE1          (100)                      // Pause of the symbol collection timer 1 in milliseconds (for scanning market watch symbols)
#define COLLECTION_SYM_COUNTER_STEP1   (16)                       // Increment of the symbol timer 1 counter
#define COLLECTION_SYM_COUNTER_ID1     (3)                        // Symbol timer 1 counter ID
//--- Symbol collection timer 2 parameters
#define COLLECTION_SYM_PAUSE2          (300)                      // Pause of the symbol collection timer 2 in milliseconds (for events of the market watch symbol list)
#define COLLECTION_SYM_COUNTER_STEP2   (16)                       // Increment of the symbol timer 2 counter
#define COLLECTION_SYM_COUNTER_ID2     (4)                        // Symbol timer 2 counter ID
//--- Trading class timer parameters
#define COLLECTION_REQ_PAUSE           (300)                      // Trading class timer pause in milliseconds
#define COLLECTION_REQ_COUNTER_STEP    (16)                       // Trading class timer counter increment
#define COLLECTION_REQ_COUNTER_ID      (5)                        // Trading class timer counter ID
//--- Collection list IDs
#define COLLECTION_HISTORY_ID          (0x7779)                   // Historical collection list ID
#define COLLECTION_MARKET_ID           (0x777A)                   // Market collection list ID
#define COLLECTION_EVENTS_ID           (0x777B)                   // Event collection list ID
#define COLLECTION_ACCOUNT_ID          (0x777C)                   // Account collection list ID
#define COLLECTION_SYMBOLS_ID          (0x777D)                   // Symbol collection list ID
//--- Data parameters for file operations
#define DIRECTORY                      ("DoEasy\\")               // Library directory for storing object folders
#define RESOURCE_DIR                   ("DoEasy\\Resource\\")     // Library directory for storing resource folders
//--- Symbol parameters
#define CLR_DEFAULT                    (0xFF000000)               // Default color
#define SYMBOLS_COMMON_TOTAL           (1000)                     // Total number of working symbols
//+------------------------------------------------------------------+
//| Structures                                                       |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Enumerations                                                     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Search and sorting data                                          |
//+------------------------------------------------------------------+
enum ENUM_COMPARER_TYPE
  {
   EQUAL,                                                   // Equal
   MORE,                                                    // More
   LESS,                                                    // Less
   NO_EQUAL,                                                // Not equal
   EQUAL_OR_MORE,                                           // Equal or more
   EQUAL_OR_LESS                                            // Equal or less
  };
//+------------------------------------------------------------------+
//| Possible options of selecting by time                            |
//+------------------------------------------------------------------+
enum ENUM_SELECT_BY_TIME
  {
   SELECT_BY_TIME_OPEN,                                     // By open time (in milliseconds)
   SELECT_BY_TIME_CLOSE,                                    // By close time (in milliseconds)
  };
//+------------------------------------------------------------------+
//| Possible event reasons of the object library base object         |
//+------------------------------------------------------------------+
enum ENUM_BASE_EVENT_REASON
  {
   BASE_EVENT_REASON_INC,                                   // Increase in the object property value
   BASE_EVENT_REASON_DEC,                                   // Decrease in the object property value
   BASE_EVENT_REASON_MORE_THEN,                             // Object property value exceeds the control value
   BASE_EVENT_REASON_LESS_THEN,                             // Object property value is less than the control value
   BASE_EVENT_REASON_EQUALS                                 // Object property value is equal to the control value
  };
//+------------------------------------------------------------------+
//| List of flags of possible order and position change options      |
//+------------------------------------------------------------------+
enum ENUM_CHANGE_TYPE_FLAGS
  {
   CHANGE_TYPE_FLAG_NO_CHANGE    =  0,                      // No changes
   CHANGE_TYPE_FLAG_TYPE         =  1,                      // Order type change
   CHANGE_TYPE_FLAG_PRICE        =  2,                      // Price change
   CHANGE_TYPE_FLAG_STOP         =  4,                      // StopLoss change
   CHANGE_TYPE_FLAG_TAKE         =  8,                      // TakeProfit change
   CHANGE_TYPE_FLAG_ORDER        =  16                      // Order properties change flag
  };
//+------------------------------------------------------------------+
//| Possible order and position change options                       |
//+------------------------------------------------------------------+
enum ENUM_CHANGE_TYPE
  {
   CHANGE_TYPE_NO_CHANGE,                                   // No changes
   CHANGE_TYPE_ORDER_TYPE,                                  // Order type change
   CHANGE_TYPE_ORDER_PRICE,                                 // Order price change
   CHANGE_TYPE_ORDER_PRICE_STOP_LOSS,                       // Order and StopLoss price change 
   CHANGE_TYPE_ORDER_PRICE_TAKE_PROFIT,                     // Order and TakeProfit price change
   CHANGE_TYPE_ORDER_PRICE_STOP_LOSS_TAKE_PROFIT,           // Order, StopLoss and TakeProfit price change
   CHANGE_TYPE_ORDER_STOP_LOSS_TAKE_PROFIT,                 // StopLoss and TakeProfit change
   CHANGE_TYPE_ORDER_STOP_LOSS,                             // Order's StopLoss change
   CHANGE_TYPE_ORDER_TAKE_PROFIT,                           // Order's TakeProfit change
   CHANGE_TYPE_POSITION_STOP_LOSS_TAKE_PROFIT,              // Change position's StopLoss and TakeProfit
   CHANGE_TYPE_POSITION_STOP_LOSS,                          // Change position's StopLoss
   CHANGE_TYPE_POSITION_TAKE_PROFIT,                        // Change position's TakeProfit
  };
//+------------------------------------------------------------------+
//| Data for working with orders                                     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Abstract order type (status)                                     |
//+------------------------------------------------------------------+
enum ENUM_ORDER_STATUS
  {
   ORDER_STATUS_MARKET_PENDING,                             // Market pending order
   ORDER_STATUS_MARKET_ORDER,                               // Market order
   ORDER_STATUS_MARKET_POSITION,                            // Market position
   ORDER_STATUS_HISTORY_ORDER,                              // History market order
   ORDER_STATUS_HISTORY_PENDING,                            // Removed pending order
   ORDER_STATUS_BALANCE,                                    // Balance operation
   ORDER_STATUS_DEAL,                                       // Deal
   ORDER_STATUS_UNKNOWN                                     // Unknown status
  };
//+------------------------------------------------------------------+
//| Order, deal, position integer properties                         |
//+------------------------------------------------------------------+
enum ENUM_ORDER_PROP_INTEGER
  {
   ORDER_PROP_TICKET = 0,                                   // Order ticket
   ORDER_PROP_MAGIC,                                        // Order magic
   ORDER_PROP_TIME_OPEN,                                    // Open time in milliseconds (MQL5 Deal time)
   ORDER_PROP_TIME_CLOSE,                                   // Close time in milliseconds (MQL5 Execution or removal time - ORDER_TIME_DONE)
   ORDER_PROP_TIME_EXP,                                     // Order expiration date (for pending orders)
   ORDER_PROP_STATUS,                                       // Order status (from the ENUM_ORDER_STATUS enumeration)
   ORDER_PROP_TYPE,                                         // Order/deal type
   ORDER_PROP_REASON,                                       // Deal/order/position reason or source
   ORDER_PROP_STATE,                                        // Order status (from the ENUM_ORDER_STATE enumeration)
   ORDER_PROP_POSITION_ID,                                  // Position ID
   ORDER_PROP_POSITION_BY_ID,                               // Opposite position ID
   ORDER_PROP_DEAL_ORDER_TICKET,                            // Ticket of the order that triggered a deal 
   ORDER_PROP_DEAL_ENTRY,                                   // Deal direction – IN, OUT or IN/OUT
   ORDER_PROP_TIME_UPDATE,                                  // Position change time in milliseconds
   ORDER_PROP_TICKET_FROM,                                  // Parent order ticket
   ORDER_PROP_TICKET_TO,                                    // Derived order ticket
   ORDER_PROP_PROFIT_PT,                                    // Profit in points
   ORDER_PROP_CLOSE_BY_SL,                                  // Flag of closing by StopLoss
   ORDER_PROP_CLOSE_BY_TP,                                  // Flag of closing by TakeProfit
   ORDER_PROP_GROUP_ID,                                     // Order/position group ID
   ORDER_PROP_DIRECTION,                                    // Direction (Buy, Sell)
  }; 
#define ORDER_PROP_INTEGER_TOTAL    (21)                    // Total number of integer properties
#define ORDER_PROP_INTEGER_SKIP     (0)                     // Number of order properties not used in sorting
//+------------------------------------------------------------------+
//| Order, deal, position real properties                            |
//+------------------------------------------------------------------+
enum ENUM_ORDER_PROP_DOUBLE
  {
   ORDER_PROP_PRICE_OPEN = ORDER_PROP_INTEGER_TOTAL,        // Open price (MQL5 deal price)
   ORDER_PROP_PRICE_CLOSE,                                  // Close price
   ORDER_PROP_SL,                                           // StopLoss price
   ORDER_PROP_TP,                                           // TaleProfit price
   ORDER_PROP_PROFIT,                                       // Profit
   ORDER_PROP_COMMISSION,                                   // Commission
   ORDER_PROP_SWAP,                                         // Swap
   ORDER_PROP_VOLUME,                                       // Volume
   ORDER_PROP_VOLUME_CURRENT,                               // Unexecuted volume
   ORDER_PROP_PROFIT_FULL,                                  // Profit+commission+swap
   ORDER_PROP_PRICE_STOP_LIMIT,                             // Limit order price when StopLimit order is activated
  };
#define ORDER_PROP_DOUBLE_TOTAL     (11)                    // Total number of real properties
//+------------------------------------------------------------------+
//| Order, deal, position string properties                          |
//+------------------------------------------------------------------+
enum ENUM_ORDER_PROP_STRING
  {
   ORDER_PROP_SYMBOL = (ORDER_PROP_INTEGER_TOTAL+ORDER_PROP_DOUBLE_TOTAL), // Order symbol
   ORDER_PROP_COMMENT,                                      // Order comment
   ORDER_PROP_COMMENT_EXT,                                  // Order custom comment
   ORDER_PROP_EXT_ID                                        // Order ID in an external trading system
  };
#define ORDER_PROP_STRING_TOTAL     (4)                     // Total number of string properties
//+------------------------------------------------------------------+
//| Possible criteria of sorting orders and deals                    |
//+------------------------------------------------------------------+
#define FIRST_ORD_DBL_PROP          (ORDER_PROP_INTEGER_TOTAL-ORDER_PROP_INTEGER_SKIP)
#define FIRST_ORD_STR_PROP          (ORDER_PROP_INTEGER_TOTAL+ORDER_PROP_DOUBLE_TOTAL-ORDER_PROP_INTEGER_SKIP)
enum ENUM_SORT_ORDERS_MODE
  {
//--- Sort by integer properties
   SORT_BY_ORDER_TICKET = 0,                                // Sort by an order ticket
   SORT_BY_ORDER_MAGIC,                                     // Sort by an order magic number
   SORT_BY_ORDER_TIME_OPEN,                                 // Sort by an order open time in milliseconds
   SORT_BY_ORDER_TIME_CLOSE,                                // Sort by an order close time in milliseconds
   SORT_BY_ORDER_TIME_EXP,                                  // Sort by an order expiration date
   SORT_BY_ORDER_STATUS,                                    // Sort by an order status (market order/pending order/deal/balance and credit operation)
   SORT_BY_ORDER_TYPE,                                      // Sort by an order type
   SORT_BY_ORDER_REASON,                                    // Sort by a deal/order/position reason/source
   SORT_BY_ORDER_STATE,                                     // Sort by an order status
   SORT_BY_ORDER_POSITION_ID,                               // Sort by a position ID
   SORT_BY_ORDER_POSITION_BY_ID,                            // Sort by an opposite position ID
   SORT_BY_ORDER_DEAL_ORDER,                                // Sort by the order a deal is based on
   SORT_BY_ORDER_DEAL_ENTRY,                                // Sort by a deal direction – IN, OUT or IN/OUT
   SORT_BY_ORDER_TIME_UPDATE,                               // Sort by position change time in seconds
   SORT_BY_ORDER_TICKET_FROM,                               // Sort by a parent order ticket
   SORT_BY_ORDER_TICKET_TO,                                 // Sort by a derived order ticket
   SORT_BY_ORDER_PROFIT_PT,                                 // Sort by order profit in points
   SORT_BY_ORDER_CLOSE_BY_SL,                               // Sort by the flag of closing an order by StopLoss
   SORT_BY_ORDER_CLOSE_BY_TP,                               // Sort by the flag of closing an order by TakeProfit
   SORT_BY_ORDER_GROUP_ID,                                  // Sort by order/position group ID
   SORT_BY_ORDER_DIRECTION,                                 // Sort by direction (Buy, Sell)
//--- Sort by real properties
   SORT_BY_ORDER_PRICE_OPEN = FIRST_ORD_DBL_PROP,           // Sort by open price
   SORT_BY_ORDER_PRICE_CLOSE,                               // Sort by close price
   SORT_BY_ORDER_SL,                                        // Sort by StopLoss price
   SORT_BY_ORDER_TP,                                        // Sort by TakeProfit price
   SORT_BY_ORDER_PROFIT,                                    // Sort by profit
   SORT_BY_ORDER_COMMISSION,                                // Sort by commission
   SORT_BY_ORDER_SWAP,                                      // Sort by swap
   SORT_BY_ORDER_VOLUME,                                    // Sort by volume
   SORT_BY_ORDER_VOLUME_CURRENT,                            // Sort by unexecuted volume
   SORT_BY_ORDER_PROFIT_FULL,                               // Sort by profit+commission+swap
   SORT_BY_ORDER_PRICE_STOP_LIMIT,                          // Sort by Limit order when StopLimit order is activated
//--- Sort by string properties
   SORT_BY_ORDER_SYMBOL = FIRST_ORD_STR_PROP,               // Sort by symbol
   SORT_BY_ORDER_COMMENT,                                   // Sort by comment
   SORT_BY_ORDER_COMMENT_EXT,                               // Sort by custom comment
   SORT_BY_ORDER_EXT_ID                                     // Sort by order ID in an external trading system
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Data for working with account events                             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| List of trading event flags on the account                       |
//+------------------------------------------------------------------+
enum ENUM_TRADE_EVENT_FLAGS
  {
   TRADE_EVENT_FLAG_NO_EVENT        =  0,                   // No event
   TRADE_EVENT_FLAG_ORDER_PLASED    =  1,                   // Pending order placed
   TRADE_EVENT_FLAG_ORDER_REMOVED   =  2,                   // Pending order removed
   TRADE_EVENT_FLAG_ORDER_ACTIVATED =  4,                   // Pending order activated by price
   TRADE_EVENT_FLAG_POSITION_OPENED =  8,                   // Position opened
   TRADE_EVENT_FLAG_POSITION_CHANGED=  16,                  // Position changed
   TRADE_EVENT_FLAG_POSITION_REVERSE=  32,                  // Position reversal
   TRADE_EVENT_FLAG_POSITION_CLOSED =  64,                  // Position closed
   TRADE_EVENT_FLAG_ACCOUNT_BALANCE =  128,                 // Balance operation (clarified by a deal type)
   TRADE_EVENT_FLAG_PARTIAL         =  256,                 // Partial execution
   TRADE_EVENT_FLAG_BY_POS          =  512,                 // Executed by opposite position
   TRADE_EVENT_FLAG_PRICE           =  1024,                // Modify the placement price
   TRADE_EVENT_FLAG_SL              =  2048,                // Execute by StopLoss
   TRADE_EVENT_FLAG_TP              =  4096,                // Execute by TakeProfit
   TRADE_EVENT_FLAG_ORDER_MODIFY    =  8192,                // Modify an order
   TRADE_EVENT_FLAG_POSITION_MODIFY =  16384,               // Modify a position
  };
//+------------------------------------------------------------------+
//| List of possible trading events on the account                   |
//+------------------------------------------------------------------+
enum ENUM_TRADE_EVENT
  {
   TRADE_EVENT_NO_EVENT = 0,                                // No trading event
   TRADE_EVENT_PENDING_ORDER_PLASED,                        // Pending order placed
   TRADE_EVENT_PENDING_ORDER_REMOVED,                       // Pending order removed
//--- enumeration members matching the ENUM_DEAL_TYPE enumeration members
//--- (constant order below should not be changed, no constants should be added/deleted)
   TRADE_EVENT_ACCOUNT_CREDIT = DEAL_TYPE_CREDIT,           // Charging credit (3)
   TRADE_EVENT_ACCOUNT_CHARGE,                              // Additional charges
   TRADE_EVENT_ACCOUNT_CORRECTION,                          // Correcting entry
   TRADE_EVENT_ACCOUNT_BONUS,                               // Charging bonuses
   TRADE_EVENT_ACCOUNT_COMISSION,                           // Additional commissions
   TRADE_EVENT_ACCOUNT_COMISSION_DAILY,                     // Commission charged at the end of a day
   TRADE_EVENT_ACCOUNT_COMISSION_MONTHLY,                   // Commission charged at the end of a month
   TRADE_EVENT_ACCOUNT_COMISSION_AGENT_DAILY,               // Agent commission charged at the end of a trading day
   TRADE_EVENT_ACCOUNT_COMISSION_AGENT_MONTHLY,             // Agent commission charged at the end of a month
   TRADE_EVENT_ACCOUNT_INTEREST,                            // Accrual of interest on free funds
   TRADE_EVENT_BUY_CANCELLED,                               // Canceled buy deal
   TRADE_EVENT_SELL_CANCELLED,                              // Canceled sell deal
   TRADE_EVENT_DIVIDENT,                                    // Accrual of dividends
   TRADE_EVENT_DIVIDENT_FRANKED,                            // Accrual of franked dividend
   TRADE_EVENT_TAX                        = DEAL_TAX,       // Tax accrual
//--- constants related to the DEAL_TYPE_BALANCE deal type from the DEAL_TYPE_BALANCE enumeration
   TRADE_EVENT_ACCOUNT_BALANCE_REFILL     = DEAL_TAX+1,     // Replenishing account balance
   TRADE_EVENT_ACCOUNT_BALANCE_WITHDRAWAL = DEAL_TAX+2,     // Withdrawing funds from an account
//--- Remaining possible trading events
//--- (constant order below can be changed, constants can be added/deleted)
   TRADE_EVENT_PENDING_ORDER_ACTIVATED    = DEAL_TAX+3,     // Pending order activated by price
   TRADE_EVENT_PENDING_ORDER_ACTIVATED_PARTIAL,             // Pending order partially activated by price
   TRADE_EVENT_POSITION_OPENED,                             // Position opened
   TRADE_EVENT_POSITION_OPENED_PARTIAL,                     // Position opened partially
   TRADE_EVENT_POSITION_CLOSED,                             // Position closed
   TRADE_EVENT_POSITION_CLOSED_BY_POS,                      // Position closed by an opposite one
   TRADE_EVENT_POSITION_CLOSED_BY_SL,                       // Position closed by StopLoss
   TRADE_EVENT_POSITION_CLOSED_BY_TP,                       // Position closed by TakeProfit
   TRADE_EVENT_POSITION_REVERSED_BY_MARKET,                 // Position reversal by a new deal (netting)
   TRADE_EVENT_POSITION_REVERSED_BY_PENDING,                // Position reversal by activating a pending order (netting)
   TRADE_EVENT_POSITION_REVERSED_BY_MARKET_PARTIAL,         // Position reversal by partial market order execution (netting)
   TRADE_EVENT_POSITION_REVERSED_BY_PENDING_PARTIAL,        // Position reversal by activating a pending order (netting)
   TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET,               // Added volume to a position by a new deal (netting)
   TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET_PARTIAL,       // Added volume to a position by partial execution of a market order (netting)
   TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING,              // Added volume to a position by activating a pending order (netting)
   TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING_PARTIAL,      // Added volume to a position by partial activation of a pending order (netting)
   TRADE_EVENT_POSITION_CLOSED_PARTIAL,                     // Position closed partially
   TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS,              // Position partially closed by an opposite one
   TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_SL,               // Position closed partially by StopLoss
   TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_TP,               // Position closed partially by TakeProfit
   TRADE_EVENT_TRIGGERED_STOP_LIMIT_ORDER,                  // StopLimit order activation
   TRADE_EVENT_MODIFY_ORDER_PRICE,                          // Changing order price
   TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS,                // Changing order and StopLoss price 
   TRADE_EVENT_MODIFY_ORDER_PRICE_TAKE_PROFIT,              // Changing order and TakeProfit price
   TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS_TAKE_PROFIT,    // Changing order, StopLoss and TakeProfit price
   TRADE_EVENT_MODIFY_ORDER_STOP_LOSS_TAKE_PROFIT,          // Changing order's StopLoss and TakeProfit price
   TRADE_EVENT_MODIFY_ORDER_STOP_LOSS,                      // Changing order's StopLoss
   TRADE_EVENT_MODIFY_ORDER_TAKE_PROFIT,                    // Changing order's TakeProfit
   TRADE_EVENT_MODIFY_POSITION_STOP_LOSS_TAKE_PROFIT,       // Changing position's StopLoss and TakeProfit
   TRADE_EVENT_MODIFY_POSITION_STOP_LOSS,                   // Changing position StopLoss
   TRADE_EVENT_MODIFY_POSITION_TAKE_PROFIT,                 // Changing position TakeProfit
  };
#define TRADE_EVENTS_NEXT_CODE      (TRADE_EVENT_MODIFY_POSITION_TAKE_PROFIT+1) // The code of the next event after the last trading event code
//+------------------------------------------------------------------+
//| Event status                                                     |
//+------------------------------------------------------------------+
enum ENUM_EVENT_STATUS
  {
   EVENT_STATUS_MARKET_POSITION,                            // Market position event (opening, partial opening, partial closing, adding volume, reversal)
   EVENT_STATUS_MARKET_PENDING,                             // Market pending order event (placing)
   EVENT_STATUS_HISTORY_PENDING,                            // Historical pending order event (removal)
   EVENT_STATUS_HISTORY_POSITION,                           // Historical position event (closing)
   EVENT_STATUS_BALANCE,                                    // Balance operation event (accruing balance, withdrawing funds and events from the ENUM_DEAL_TYPE enumeration)
   EVENT_STATUS_MODIFY                                      // Order/position modification event
  };
//+------------------------------------------------------------------+
//| Event reason                                                     |
//+------------------------------------------------------------------+
enum ENUM_EVENT_REASON
  {
   EVENT_REASON_REVERSE,                                    // Position reversal (netting)
   EVENT_REASON_REVERSE_PARTIALLY,                          // Position reversal by partial request execution (netting)
   EVENT_REASON_REVERSE_BY_PENDING,                         // Position reversal by pending order activation (netting)
   EVENT_REASON_REVERSE_BY_PENDING_PARTIALLY,               // Position reversal in case of a pending order partial execution (netting)
//--- All constants related to a position reversal should be located in the above list
   EVENT_REASON_ACTIVATED_PENDING,                          // Pending order activation
   EVENT_REASON_ACTIVATED_PENDING_PARTIALLY,                // Pending order partial activation
   EVENT_REASON_STOPLIMIT_TRIGGERED,                        // StopLimit order activation
   EVENT_REASON_MODIFY,                                     // Modification
   EVENT_REASON_CANCEL,                                     // Cancelation
   EVENT_REASON_EXPIRED,                                    // Order expiration
   EVENT_REASON_DONE,                                       // Request executed in full
   EVENT_REASON_DONE_PARTIALLY,                             // Request executed partially
   EVENT_REASON_VOLUME_ADD,                                 // Add volume to a position (netting)
   EVENT_REASON_VOLUME_ADD_PARTIALLY,                       // Add volume to a position by a partial request execution (netting)
   EVENT_REASON_VOLUME_ADD_BY_PENDING,                      // Add volume to a position when a pending order is activated (netting)
   EVENT_REASON_VOLUME_ADD_BY_PENDING_PARTIALLY,            // Add volume to a position when a pending order is partially executed (netting)
   EVENT_REASON_DONE_SL,                                    // Closing by StopLoss
   EVENT_REASON_DONE_SL_PARTIALLY,                          // Partial closing by StopLoss
   EVENT_REASON_DONE_TP,                                    // Closing by TakeProfit
   EVENT_REASON_DONE_TP_PARTIALLY,                          // Partial closing by TakeProfit
   EVENT_REASON_DONE_BY_POS,                                // Closing by an opposite position
   EVENT_REASON_DONE_PARTIALLY_BY_POS,                      // Partial closing by an opposite position
   EVENT_REASON_DONE_BY_POS_PARTIALLY,                      // Closing an opposite position by a partial volume
   EVENT_REASON_DONE_PARTIALLY_BY_POS_PARTIALLY,            // Partial closing of an opposite position by a partial volume
//--- Constants related to DEAL_TYPE_BALANCE deal type from the ENUM_DEAL_TYPE enumeration
   EVENT_REASON_BALANCE_REFILL,                             // Refilling the balance
   EVENT_REASON_BALANCE_WITHDRAWAL,                         // Withdrawing funds from the account
//--- List of constants is relevant to TRADE_EVENT_ACCOUNT_CREDIT from the ENUM_TRADE_EVENT enumeration and shifted to +13 relative to ENUM_DEAL_TYPE (EVENT_REASON_ACCOUNT_CREDIT-3)
   EVENT_REASON_ACCOUNT_CREDIT,                             // Accruing credit
   EVENT_REASON_ACCOUNT_CHARGE,                             // Additional charges
   EVENT_REASON_ACCOUNT_CORRECTION,                         // Correcting entry
   EVENT_REASON_ACCOUNT_BONUS,                              // Accruing bonuses
   EVENT_REASON_ACCOUNT_COMISSION,                          // Additional commissions
   EVENT_REASON_ACCOUNT_COMISSION_DAILY,                    // Commission charged at the end of a trading day
   EVENT_REASON_ACCOUNT_COMISSION_MONTHLY,                  // Commission charged at the end of a trading month
   EVENT_REASON_ACCOUNT_COMISSION_AGENT_DAILY,              // Agent commission charged at the end of a trading day
   EVENT_REASON_ACCOUNT_COMISSION_AGENT_MONTHLY,            // Agent commission charged at the end of a month
   EVENT_REASON_ACCOUNT_INTEREST,                           // Accruing interest on free funds
   EVENT_REASON_BUY_CANCELLED,                              // Canceled buy deal
   EVENT_REASON_SELL_CANCELLED,                             // Canceled sell deal
   EVENT_REASON_DIVIDENT,                                   // Accruing dividends
   EVENT_REASON_DIVIDENT_FRANKED,                           // Accruing franked dividends
   EVENT_REASON_TAX                                         // Tax
  };
#define REASON_EVENT_SHIFT    (EVENT_REASON_ACCOUNT_CREDIT-3)
//+------------------------------------------------------------------+
//| Event's integer properties                                       |
//+------------------------------------------------------------------+
enum ENUM_EVENT_PROP_INTEGER
  {
   EVENT_PROP_TYPE_EVENT = 0,                               // Account trading event type (from the ENUM_TRADE_EVENT enumeration)
   EVENT_PROP_TIME_EVENT,                                   // Event time in milliseconds
   EVENT_PROP_STATUS_EVENT,                                 // Event status (from the ENUM_EVENT_STATUS enumeration)
   EVENT_PROP_REASON_EVENT,                                 // Event reason (from the ENUM_EVENT_REASON enumeration)
   //---
   EVENT_PROP_TYPE_DEAL_EVENT,                              // Deal event type
   EVENT_PROP_TICKET_DEAL_EVENT,                            // Deal event ticket
   EVENT_PROP_TYPE_ORDER_EVENT,                             // Type of the order, based on which a deal event is opened (the last position order)
   EVENT_PROP_TICKET_ORDER_EVENT,                           // Ticket of the order, based on which a deal event is opened (the last position order)
   //---
   EVENT_PROP_TIME_ORDER_POSITION,                          // Time of the order, based on which the first position deal is opened (the first position order on a hedge account)
   EVENT_PROP_TYPE_ORDER_POSITION,                          // Type of the order, based on which the first position deal is opened (the first position order on a hedge account)
   EVENT_PROP_TICKET_ORDER_POSITION,                        // Ticket of the order, based on which the first position deal is opened (the first position order on a hedge account)
   EVENT_PROP_POSITION_ID,                                  // Position ID
   //---
   EVENT_PROP_POSITION_BY_ID,                               // Opposite position ID
   EVENT_PROP_MAGIC_ORDER,                                  // Order/deal/position magic number
   EVENT_PROP_MAGIC_BY_ID,                                  // Opposite position magic number
   //---
   EVENT_PROP_TYPE_ORD_POS_BEFORE,                          // Position type before changing the direction
   EVENT_PROP_TICKET_ORD_POS_BEFORE,                        // Position order ticket before changing direction
   EVENT_PROP_TYPE_ORD_POS_CURRENT,                         // Current position type
   EVENT_PROP_TICKET_ORD_POS_CURRENT,                       // Current position order ticket
  }; 
#define EVENT_PROP_INTEGER_TOTAL (19)                       // Total number of integer event properties
#define EVENT_PROP_INTEGER_SKIP  (4)                        // Number of order properties not used in sorting
//+------------------------------------------------------------------+
//| Event's real properties                                          |
//+------------------------------------------------------------------+
enum ENUM_EVENT_PROP_DOUBLE
  {
   EVENT_PROP_PRICE_EVENT = EVENT_PROP_INTEGER_TOTAL,       // Price an event occurred at
   EVENT_PROP_PRICE_OPEN,                                   // Order/deal/position open price
   EVENT_PROP_PRICE_CLOSE,                                  // Order/deal/position close price
   EVENT_PROP_PRICE_SL,                                     // StopLoss order/deal/position price
   EVENT_PROP_PRICE_TP,                                     // TakeProfit Order/deal/position
   EVENT_PROP_VOLUME_ORDER_INITIAL,                         // Requested order volume
   EVENT_PROP_VOLUME_ORDER_EXECUTED,                        // Executed order volume
   EVENT_PROP_VOLUME_ORDER_CURRENT,                         // Remaining order volume
   EVENT_PROP_VOLUME_POSITION_EXECUTED,                     // Current executed position volume after a deal
   EVENT_PROP_PROFIT,                                       // Profit
   //---
   EVENT_PROP_PRICE_OPEN_BEFORE,                            // Order price before modification
   EVENT_PROP_PRICE_SL_BEFORE,                              // StopLoss price before modification
   EVENT_PROP_PRICE_TP_BEFORE,                              // TakeProfit price before modification
   EVENT_PROP_PRICE_EVENT_ASK,                              // Ask price during an event
   EVENT_PROP_PRICE_EVENT_BID,                              // Bid price during an event
  };
#define EVENT_PROP_DOUBLE_TOTAL  (15)                       // Total number of event's real properties
#define EVENT_PROP_DOUBLE_SKIP   (5)                        // Number of order properties not used in sorting
//+------------------------------------------------------------------+
//| Event's string properties                                        |
//+------------------------------------------------------------------+
enum ENUM_EVENT_PROP_STRING
  {
   EVENT_PROP_SYMBOL = (EVENT_PROP_INTEGER_TOTAL+EVENT_PROP_DOUBLE_TOTAL), // Order symbol
   EVENT_PROP_SYMBOL_BY_ID                                  // Opposite position symbol
  };
#define EVENT_PROP_STRING_TOTAL     (2)                     // Total number of event's string properties
//+------------------------------------------------------------------+
//| Possible event sorting criteria                                  |
//+------------------------------------------------------------------+
#define FIRST_EVN_DBL_PROP       (EVENT_PROP_INTEGER_TOTAL-EVENT_PROP_INTEGER_SKIP)
#define FIRST_EVN_STR_PROP       (EVENT_PROP_INTEGER_TOTAL-EVENT_PROP_INTEGER_SKIP+EVENT_PROP_DOUBLE_TOTAL-EVENT_PROP_DOUBLE_SKIP)
enum ENUM_SORT_EVENTS_MODE
  {
//--- Sort by integer properties
   SORT_BY_EVENT_TYPE_EVENT = 0,                            // Sort by event type
   SORT_BY_EVENT_TIME_EVENT,                                // Sort by event time
   SORT_BY_EVENT_STATUS_EVENT,                              // Sort by event status (from the ENUM_EVENT_STATUS enumeration)
   SORT_BY_EVENT_REASON_EVENT,                              // Sort by event reason (from the ENUM_EVENT_REASON enumeration)
   SORT_BY_EVENT_TYPE_DEAL_EVENT,                           // Sort by deal event type
   SORT_BY_EVENT_TICKET_DEAL_EVENT,                         // Sort by deal event ticket
   SORT_BY_EVENT_TYPE_ORDER_EVENT,                          // Sort by type of an order, based on which a deal event is opened (the last position order)
   SORT_BY_EVENT_TICKET_ORDER_EVENT,                        // Sort by a ticket of an order, based on which a deal event is opened (the last position order)
   SORT_BY_EVENT_TIME_ORDER_POSITION,                       // Sort by time of an order, based on which a position deal is opened (the first position order)
   SORT_BY_EVENT_TYPE_ORDER_POSITION,                       // Sort by type of an order, based on which a position deal is opened (the first position order)
   SORT_BY_EVENT_TICKET_ORDER_POSITION,                     // Sort by a ticket of an order, based on which a position deal is opened (the first position order)
   SORT_BY_EVENT_POSITION_ID,                               // Sort by position ID
   SORT_BY_EVENT_POSITION_BY_ID,                            // Sort by opposite position ID
   SORT_BY_EVENT_MAGIC_ORDER,                               // Sort by order/deal/position magic number
   SORT_BY_EVENT_MAGIC_BY_ID,                               // Sort by an opposite position magic number
//--- Sort by real properties
   SORT_BY_EVENT_PRICE_EVENT = FIRST_EVN_DBL_PROP,          // Sort by a price an event occurred at
   SORT_BY_EVENT_PRICE_OPEN,                                // Sort by position open price
   SORT_BY_EVENT_PRICE_CLOSE,                               // Sort by position close price
   SORT_BY_EVENT_PRICE_SL,                                  // Sort by position StopLoss price
   SORT_BY_EVENT_PRICE_TP,                                  // Sort by position TakeProfit price
   SORT_BY_EVENT_VOLUME_ORDER_INITIAL,                      // Sort by initial volume
   SORT_BY_EVENT_VOLUME_ORDER_EXECUTED,                     // Sort by the current volume
   SORT_BY_EVENT_VOLUME_ORDER_CURRENT,                      // Sort by remaining volume
   SORT_BY_EVENT_VOLUME_POSITION_EXECUTED,                  // Sort by remaining volume
   SORT_BY_EVENT_PROFIT,   // Sort by profit
//--- Sort by string properties
   SORT_BY_EVENT_SYMBOL = FIRST_EVN_STR_PROP,               // Sort by order/position/deal symbol
   SORT_BY_EVENT_SYMBOL_BY_ID                               // Sort by an opposite position symbol
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Data for working with accounts                                   |
//+------------------------------------------------------------------+
#define ACCOUNT_EVENTS_NEXT_CODE       (TRADE_EVENTS_NEXT_CODE)   // The code of the next event after the last account event code
//+------------------------------------------------------------------+
//| Account integer properties                                       |
//+------------------------------------------------------------------+
enum ENUM_ACCOUNT_PROP_INTEGER
  {
   ACCOUNT_PROP_LOGIN,                                      // Account number
   ACCOUNT_PROP_TRADE_MODE,                                 // Trading account type
   ACCOUNT_PROP_LEVERAGE,                                   // Leverage
   ACCOUNT_PROP_LIMIT_ORDERS,                               // Maximum allowed number of active pending orders
   ACCOUNT_PROP_MARGIN_SO_MODE,                             // Mode of setting the minimum available margin level
   ACCOUNT_PROP_TRADE_ALLOWED,                              // Permission to trade for the current account from the server side
   ACCOUNT_PROP_TRADE_EXPERT,                               // Permission to trade for an EA from the server side
   ACCOUNT_PROP_MARGIN_MODE,                                // Margin calculation mode
   ACCOUNT_PROP_CURRENCY_DIGITS,                            // Number of digits for an account currency necessary for accurate display of trading results
   ACCOUNT_PROP_SERVER_TYPE,                                // Trade server type (MetaTrader 5, MetaTrader 4)
   ACCOUNT_PROP_FIFO_CLOSE                                  // Flag of a position closure by FIFO rule only
  };
#define ACCOUNT_PROP_INTEGER_TOTAL    (11)                  // Total number of integer properties
#define ACCOUNT_PROP_INTEGER_SKIP     (0)                   // Number of integer account properties not used in sorting
//+------------------------------------------------------------------+
//| Account real properties                                          |
//+------------------------------------------------------------------+
enum ENUM_ACCOUNT_PROP_DOUBLE
  {
   ACCOUNT_PROP_BALANCE = ACCOUNT_PROP_INTEGER_TOTAL,       // Account balance in a deposit currency
   ACCOUNT_PROP_CREDIT,                                     // Credit in a deposit currency
   ACCOUNT_PROP_PROFIT,                                     // Current profit on an account in the account currency
   ACCOUNT_PROP_EQUITY,                                     // Equity on an account in the deposit currency
   ACCOUNT_PROP_MARGIN,                                     // Reserved margin on an account in the deposit currency
   ACCOUNT_PROP_MARGIN_FREE,                                // Free funds available for opening a position on an account in the deposit currency
   ACCOUNT_PROP_MARGIN_LEVEL,                               // Margin level on an account in %
   ACCOUNT_PROP_MARGIN_SO_CALL,                             // Margin Call level
   ACCOUNT_PROP_MARGIN_SO_SO,                               // Stop Out level
   ACCOUNT_PROP_MARGIN_INITIAL,                             // Funds reserved on an account to ensure a guarantee amount for all pending orders 
   ACCOUNT_PROP_MARGIN_MAINTENANCE,                         // Funds reserved on an account to ensure a minimum amount for all open positions
   ACCOUNT_PROP_ASSETS,                                     // Current assets on an account
   ACCOUNT_PROP_LIABILITIES,                                // Current liabilities on an account
   ACCOUNT_PROP_COMMISSION_BLOCKED                          // Current sum of blocked commissions on an account
  };
#define ACCOUNT_PROP_DOUBLE_TOTAL     (14)                  // Total number of account real properties
#define ACCOUNT_PROP_DOUBLE_SKIP      (0)                   // Number of real account properties not used in sorting
//+------------------------------------------------------------------+
//| Account string properties                                        |
//+------------------------------------------------------------------+
enum ENUM_ACCOUNT_PROP_STRING
  {
   ACCOUNT_PROP_NAME = (ACCOUNT_PROP_INTEGER_TOTAL+ACCOUNT_PROP_DOUBLE_TOTAL), // Client name
   ACCOUNT_PROP_SERVER,                                     // Trade server name
   ACCOUNT_PROP_CURRENCY,                                   // Deposit currency
   ACCOUNT_PROP_COMPANY                                     // Name of a company serving an account
  };
#define ACCOUNT_PROP_STRING_TOTAL     (4)                   // Total number of account string properties
#define ACCOUNT_PROP_STRING_SKIP      (0)                   // Number of string account properties not used in sorting
//+------------------------------------------------------------------+
//| Possible account sorting criteria                                |
//+------------------------------------------------------------------+
#define FIRST_ACC_DBL_PROP            (ACCOUNT_PROP_INTEGER_TOTAL-ACCOUNT_PROP_INTEGER_SKIP)
#define FIRST_ACC_STR_PROP            (ACCOUNT_PROP_INTEGER_TOTAL-ACCOUNT_PROP_INTEGER_SKIP+ACCOUNT_PROP_DOUBLE_TOTAL-ACCOUNT_PROP_DOUBLE_SKIP)
enum ENUM_SORT_ACCOUNT_MODE
  {
//--- Sort by integer properties
   SORT_BY_ACCOUNT_LOGIN = 0,                               // Sort by account number
   SORT_BY_ACCOUNT_TRADE_MODE,                              // Sort by trading account type
   SORT_BY_ACCOUNT_LEVERAGE,                                // Sort by leverage
   SORT_BY_ACCOUNT_LIMIT_ORDERS,                            // Sort by maximum acceptable number of existing pending orders
   SORT_BY_ACCOUNT_MARGIN_SO_MODE,                          // Sort by mode for setting the minimum acceptable margin level
   SORT_BY_ACCOUNT_TRADE_ALLOWED,                           // Sort by permission to trade for the current account
   SORT_BY_ACCOUNT_TRADE_EXPERT,                            // Sort by permission to trade for an EA
   SORT_BY_ACCOUNT_MARGIN_MODE,                             // Sort by margin calculation mode
   SORT_BY_ACCOUNT_CURRENCY_DIGITS,                         // Sort by number of digits for an account currency
   SORT_BY_ACCOUNT_SERVER_TYPE,                             // Sort by trade server type (MetaTrader 5, MetaTrader 4)
   SORT_BY_ACCOUNT_FIFO_CLOSE,                              // Sort by the flag of a position closure by FIFO rule only
//--- Sort by real properties
   SORT_BY_ACCOUNT_BALANCE = FIRST_ACC_DBL_PROP,            // Sort by an account balance in the deposit currency
   SORT_BY_ACCOUNT_CREDIT,                                  // Sort by credit in a deposit currency
   SORT_BY_ACCOUNT_PROFIT,                                  // Sort by the current profit on an account in the deposit currency
   SORT_BY_ACCOUNT_EQUITY,                                  // Sort by an account equity in the deposit currency
   SORT_BY_ACCOUNT_MARGIN,                                  // Sort by an account reserved margin in the deposit currency
   SORT_BY_ACCOUNT_MARGIN_FREE,                             // Sort by account free funds available for opening a position in the deposit currency
   SORT_BY_ACCOUNT_MARGIN_LEVEL,                            // Sort by account margin level in %
   SORT_BY_ACCOUNT_MARGIN_SO_CALL,                          // Sort by margin level requiring depositing funds to an account (Margin Call)
   SORT_BY_ACCOUNT_MARGIN_SO_SO,                            // Sort by margin level, at which the most loss-making position is closed (Stop Out)
   SORT_BY_ACCOUNT_MARGIN_INITIAL,                          // Sort by funds reserved on an account to ensure a guarantee amount for all pending orders 
   SORT_BY_ACCOUNT_MARGIN_MAINTENANCE,                      // Sort by funds reserved on an account to ensure a minimum amount for all open positions
   SORT_BY_ACCOUNT_ASSETS,                                  // Sort by the amount of the current assets on an account
   SORT_BY_ACCOUNT_LIABILITIES,                             // Sort by the current liabilities on an account
   SORT_BY_ACCOUNT_COMMISSION_BLOCKED,                      // Sort by the current amount of blocked commissions on an account
//--- Sort by string properties
   SORT_BY_ACCOUNT_NAME = FIRST_ACC_STR_PROP,               // Sort by a client name
   SORT_BY_ACCOUNT_SERVER,                                  // Sort by a trade server name
   SORT_BY_ACCOUNT_CURRENCY,                                // Sort by a deposit currency
   SORT_BY_ACCOUNT_COMPANY                                  // Sort by a name of a company serving an account
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Data for working with symbols                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| List of possible symbol events in the Market Watch window        |
//+------------------------------------------------------------------+
enum ENUM_MW_EVENT
  {
   MARKET_WATCH_EVENT_NO_EVENT = ACCOUNT_EVENTS_NEXT_CODE,  // No event
   MARKET_WATCH_EVENT_SYMBOL_ADD,                           // Adding a symbol to the Market Watch window
   MARKET_WATCH_EVENT_SYMBOL_DEL,                           // Removing a symbol from the Market Watch window
   MARKET_WATCH_EVENT_SYMBOL_SORT,                          // Sorting symbols in the Market Watch window
  };
#define SYMBOL_EVENTS_NEXT_CODE  (MARKET_WATCH_EVENT_SYMBOL_SORT+1)  // The code of the next event after the last symbol event code
//+------------------------------------------------------------------+
//| Abstract symbol type (status)                                    |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_STATUS
  {
   SYMBOL_STATUS_FX,                                        // Forex symbol
   SYMBOL_STATUS_FX_MAJOR,                                  // Major Forex symbol
   SYMBOL_STATUS_FX_MINOR,                                  // Minor Forex symbol
   SYMBOL_STATUS_FX_EXOTIC,                                 // Exotic Forex symbol
   SYMBOL_STATUS_FX_RUB,                                    // Forex symbol/RUR
   SYMBOL_STATUS_METAL,                                     // Metal
   SYMBOL_STATUS_INDEX,                                     // Index
   SYMBOL_STATUS_INDICATIVE,                                // Indicative
   SYMBOL_STATUS_CRYPTO,                                    // Cryptocurrency symbol
   SYMBOL_STATUS_COMMODITY,                                 // Commodity symbol
   SYMBOL_STATUS_EXCHANGE,                                  // Exchange symbol
   SYMBOL_STATUS_FUTURES,                                   // Futures
   SYMBOL_STATUS_CFD,                                       // CFD
   SYMBOL_STATUS_STOCKS,                                    // Stock
   SYMBOL_STATUS_BONDS,                                     // Bond
   SYMBOL_STATUS_OPTION,                                    // Option
   SYMBOL_STATUS_COLLATERAL,                                // Non-tradable asset
   SYMBOL_STATUS_CUSTOM,                                    // Custom symbol
   SYMBOL_STATUS_COMMON                                     // General category
  };
//+------------------------------------------------------------------+
//| Symbol integer properties                                        |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_PROP_INTEGER
  {
   SYMBOL_PROP_STATUS = 0,                                  // Symbol status
   SYMBOL_PROP_INDEX_MW,                                    // Symbol index in the Market Watch window
   SYMBOL_PROP_CUSTOM,                                      // Custom symbol flag
   SYMBOL_PROP_CHART_MODE,                                  // The price type used for generating bars – Bid or Last (from the ENUM_SYMBOL_CHART_MODE enumeration)
   SYMBOL_PROP_EXIST,                                       // Flag indicating that the symbol under this name exists
   SYMBOL_PROP_SELECT,                                      // An indication that the symbol is selected in Market Watch
   SYMBOL_PROP_VISIBLE,                                     // An indication that the symbol is displayed in Market Watch
   SYMBOL_PROP_SESSION_DEALS,                               // The number of deals in the current session 
   SYMBOL_PROP_SESSION_BUY_ORDERS,                          // The total number of Buy orders at the moment
   SYMBOL_PROP_SESSION_SELL_ORDERS,                         // The total number of Sell orders at the moment
   SYMBOL_PROP_VOLUME,                                      // Last deal volume
   SYMBOL_PROP_VOLUMEHIGH,                                  // Maximum volume within a day
   SYMBOL_PROP_VOLUMELOW,                                   // Minimum volume within a day
   SYMBOL_PROP_TIME,                                        // Latest quote time
   SYMBOL_PROP_DIGITS,                                      // Number of decimal places
   SYMBOL_PROP_DIGITS_LOTS,                                 // Number of decimal places for a lot
   SYMBOL_PROP_SPREAD,                                      // Spread in points
   SYMBOL_PROP_SPREAD_FLOAT,                                // Floating spread flag
   SYMBOL_PROP_TICKS_BOOKDEPTH,                             // Maximum number of orders displayed in the Depth of Market
   SYMBOL_PROP_TRADE_CALC_MODE,                             // Contract price calculation method (from the ENUM_SYMBOL_CALC_MODE enumeration)
   SYMBOL_PROP_TRADE_MODE,                                  // Order execution type (from the ENUM_SYMBOL_TRADE_MODE enumeration)
   SYMBOL_PROP_START_TIME,                                  // Symbol trading start date (usually used for futures)
   SYMBOL_PROP_EXPIRATION_TIME,                             // Symbol trading end date (usually used for futures)
   SYMBOL_PROP_TRADE_STOPS_LEVEL,                           // Minimum distance in points from the current close price for setting Stop orders
   SYMBOL_PROP_TRADE_FREEZE_LEVEL,                          // Freeze distance for trading operations (in points)
   SYMBOL_PROP_TRADE_EXEMODE,                               // Deal execution mode (from the ENUM_SYMBOL_TRADE_EXECUTION enumeration)
   SYMBOL_PROP_SWAP_MODE,                                   // Swap calculation model (from the ENUM_SYMBOL_SWAP_MODE enumeration)
   SYMBOL_PROP_SWAP_ROLLOVER3DAYS,                          // Triple-day swap (from the ENUM_DAY_OF_WEEK enumeration)
   SYMBOL_PROP_MARGIN_HEDGED_USE_LEG,                       // Calculating hedging margin using the larger leg (Buy or Sell)
   SYMBOL_PROP_EXPIRATION_MODE,                             // Flags of allowed order expiration modes
   SYMBOL_PROP_FILLING_MODE,                                // Flags of allowed order filling modes
   SYMBOL_PROP_ORDER_MODE,                                  // The flags of allowed order types
   SYMBOL_PROP_ORDER_GTC_MODE,                              // Expiration of Stop Loss and Take Profit orders if SYMBOL_EXPIRATION_MODE=SYMBOL_EXPIRATION_GTC (from the ENUM_SYMBOL_ORDER_GTC_MODE enumeration)
   SYMBOL_PROP_OPTION_MODE,                                 // Option type (from the ENUM_SYMBOL_OPTION_MODE enumeration)
   SYMBOL_PROP_OPTION_RIGHT,                                // Option right (Call/Put) (from the ENUM_SYMBOL_OPTION_RIGHT enumeration)
   //--- skipped property
   SYMBOL_PROP_BACKGROUND_COLOR                             // The color of the background used for the symbol in Market Watch
  }; 
#define SYMBOL_PROP_INTEGER_TOTAL    (36)                   // Total number of integer properties
#define SYMBOL_PROP_INTEGER_SKIP     (1)                    // Number of symbol integer properties not used in sorting
//+------------------------------------------------------------------+
//| Symbol real properties                                           |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_PROP_DOUBLE
  {
   SYMBOL_PROP_BID = SYMBOL_PROP_INTEGER_TOTAL,             // Bid - the best price at which a symbol can be sold
   SYMBOL_PROP_BIDHIGH,                                     // The highest Bid price of the day
   SYMBOL_PROP_BIDLOW,                                      // The lowest Bid price of the day
   SYMBOL_PROP_ASK,                                         // Ask - best price, at which an instrument can be bought
   SYMBOL_PROP_ASKHIGH,                                     // The highest Ask price of the day
   SYMBOL_PROP_ASKLOW,                                      // The lowest Ask price of the day
   SYMBOL_PROP_LAST,                                        // The price at which the last deal was executed
   SYMBOL_PROP_LASTHIGH,                                    // The highest Last price of the day
   SYMBOL_PROP_LASTLOW,                                     // The lowest Last price of the day
   SYMBOL_PROP_VOLUME_REAL,                                 // Volume of the day
   SYMBOL_PROP_VOLUMEHIGH_REAL,                             // Maximum volume within a day
   SYMBOL_PROP_VOLUMELOW_REAL,                              // Minimum volume within a day
   SYMBOL_PROP_OPTION_STRIKE,                               // Option execution price
   SYMBOL_PROP_POINT,                                       // One point value
   SYMBOL_PROP_TRADE_TICK_VALUE,                            // SYMBOL_TRADE_TICK_VALUE_PROFIT value
   SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT,                     // Calculated tick value for a winning position
   SYMBOL_PROP_TRADE_TICK_VALUE_LOSS,                       // Calculated tick value for a losing position
   SYMBOL_PROP_TRADE_TICK_SIZE,                             // Minimal price change
   SYMBOL_PROP_TRADE_CONTRACT_SIZE,                         // Trade contract size
   SYMBOL_PROP_TRADE_ACCRUED_INTEREST,                      // Accrued interest
   SYMBOL_PROP_TRADE_FACE_VALUE,                            // Face value – initial bond value set by an issuer
   SYMBOL_PROP_TRADE_LIQUIDITY_RATE,                        // Liquidity rate – the share of an asset that can be used for a margin
   SYMBOL_PROP_VOLUME_MIN,                                  // Minimum volume for a deal
   SYMBOL_PROP_VOLUME_MAX,                                  // Maximum volume for a deal
   SYMBOL_PROP_VOLUME_STEP,                                 // Minimum volume change step for deal execution
   SYMBOL_PROP_VOLUME_LIMIT,                                // The maximum allowed total volume of an open position and pending orders in one direction (either buy or sell)
   SYMBOL_PROP_SWAP_LONG,                                   // Long swap value
   SYMBOL_PROP_SWAP_SHORT,                                  // Short swap value
   SYMBOL_PROP_MARGIN_INITIAL,                              // Initial margin
   SYMBOL_PROP_MARGIN_MAINTENANCE,                          // Maintenance margin for an instrument
   SYMBOL_PROP_MARGIN_LONG_INITIAL,                         // Initial margin requirement applicable to long positions
   SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL,                     // Initial margin requirement applicable to BuyStop orders
   SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL,                    // Initial margin requirement applicable to BuyLimit orders
   SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL,                // Initial margin requirement applicable to BuyStopLimit orders
   SYMBOL_PROP_MARGIN_LONG_MAINTENANCE,                     // Maintenance margin requirement applicable to long positions
   SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE,                 // Maintenance margin requirement applicable to BuyStop orders
   SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE,                // Maintenance margin requirement applicable to BuyLimit orders
   SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE,            // Maintenance margin requirement applicable to BuyStopLimit orders
   SYMBOL_PROP_MARGIN_SHORT_INITIAL,                        // Initial margin requirement applicable to short positions
   SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL,                    // Initial margin requirement applicable to SellStop orders
   SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL,                   // Initial margin requirement applicable to SellLimit orders
   SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL,               // Initial margin requirement applicable to SellStopLimit orders
   SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE,                    // Maintenance margin requirement applicable to short positions
   SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE,                // Maintenance margin requirement applicable to SellStop orders
   SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE,               // Maintenance margin requirement applicable to SellLimit orders
   SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE,           // Maintenance margin requirement applicable to SellStopLimit orders
   SYMBOL_PROP_SESSION_VOLUME,                              // The total volume of deals in the current session
   SYMBOL_PROP_SESSION_TURNOVER,                            // The total turnover in the current session
   SYMBOL_PROP_SESSION_INTEREST,                            // The total volume of open positions
   SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME,                   // The total volume of Buy orders at the moment
   SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME,                  // The total volume of Sell orders at the moment
   SYMBOL_PROP_SESSION_OPEN,                                // Open price of the session
   SYMBOL_PROP_SESSION_CLOSE,                               // Close price of the session
   SYMBOL_PROP_SESSION_AW,                                  // The average weighted price of the session
   SYMBOL_PROP_SESSION_PRICE_SETTLEMENT,                    // The settlement price of the current session
   SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN,                     // Minimum allowable price value for the session 
   SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX,                     // Maximum allowable price value for the session
   SYMBOL_PROP_MARGIN_HEDGED                                // Size of a contract or margin for one lot of hedged positions (oppositely directed positions at one symbol).
  };
#define SYMBOL_PROP_DOUBLE_TOTAL     (58)                   // Total number of real properties
#define SYMBOL_PROP_DOUBLE_SKIP      (0)                    // Number of real symbol properties not used in sorting
//+------------------------------------------------------------------+
//| Symbol string properties                                         |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_PROP_STRING
  {
   SYMBOL_PROP_NAME = (SYMBOL_PROP_INTEGER_TOTAL+SYMBOL_PROP_DOUBLE_TOTAL),   // Symbol name
   SYMBOL_PROP_BASIS,                                       // The name of the underlaying asset for a derivative symbol
   SYMBOL_PROP_CURRENCY_BASE,                               // Instrument base currency
   SYMBOL_PROP_CURRENCY_PROFIT,                             // Profit currency
   SYMBOL_PROP_CURRENCY_MARGIN,                             // Margin currency
   SYMBOL_PROP_BANK,                                        // The source of the current quote
   SYMBOL_PROP_DESCRIPTION,                                 // String description of a symbol
   SYMBOL_PROP_FORMULA,                                     // The formula used for custom symbol pricing
   SYMBOL_PROP_ISIN,                                        // The name of a trading symbol in the international system of securities identification numbers (ISIN)
   SYMBOL_PROP_PAGE,                                        // The web page containing symbol information
   SYMBOL_PROP_PATH,                                        // Location in the symbol tree
   SYMBOL_PROP_CATEGORY,                                    // Symbol category
   SYMBOL_PROP_EXCHANGE                                     // Name of an exchange a symbol is traded on
  };
#define SYMBOL_PROP_STRING_TOTAL     (13)                   // Total number of string properties
//+------------------------------------------------------------------+
//| Possible symbol sorting criteria                                 |
//+------------------------------------------------------------------+
#define FIRST_SYM_DBL_PROP          (SYMBOL_PROP_INTEGER_TOTAL-SYMBOL_PROP_INTEGER_SKIP)
#define FIRST_SYM_STR_PROP          (SYMBOL_PROP_INTEGER_TOTAL-SYMBOL_PROP_INTEGER_SKIP+SYMBOL_PROP_DOUBLE_TOTAL-SYMBOL_PROP_DOUBLE_SKIP)
enum ENUM_SORT_SYMBOLS_MODE
  {
//--- Sort by integer properties
   SORT_BY_SYMBOL_STATUS = 0,                               // Sort by symbol status
   SORT_BY_SYMBOL_INDEX_MW,                                 // Sort by index in the Market Watch window
   SORT_BY_SYMBOL_CUSTOM,                                   // Sort by custom symbol property
   SORT_BY_SYMBOL_CHART_MODE,                               // Sort by price type for constructing bars – Bid or Last (from the ENUM_SYMBOL_CHART_MODE enumeration)
   SORT_BY_SYMBOL_EXIST,                                    // Sort by the flag that a symbol with such a name exists
   SORT_BY_SYMBOL_SELECT,                                   // Sort by the flag indicating that a symbol is selected in Market Watch
   SORT_BY_SYMBOL_VISIBLE,                                  // Sort by the flag indicating that a selected symbol is displayed in Market Watch
   SORT_BY_SYMBOL_SESSION_DEALS,                            // Sort by the number of deals in the current session 
   SORT_BY_SYMBOL_SESSION_BUY_ORDERS,                       // Sort by the total number of current buy orders
   SORT_BY_SYMBOL_SESSION_SELL_ORDERS,                      // Sort by the total number of current sell orders
   SORT_BY_SYMBOL_VOLUME,                                   // Sort by last deal volume
   SORT_BY_SYMBOL_VOLUMEHIGH,                               // Sort by maximum volume for a day
   SORT_BY_SYMBOL_VOLUMELOW,                                // Sort by minimum volume for a day
   SORT_BY_SYMBOL_TIME,                                     // Sort by the last quote time
   SORT_BY_SYMBOL_DIGITS,                                   // Sort by a number of decimal places
   SORT_BY_SYMBOL_DIGITS_LOT,                               // Sort by a number of decimal places in a lot
   SORT_BY_SYMBOL_SPREAD,                                   // Sort by spread in points
   SORT_BY_SYMBOL_SPREAD_FLOAT,                             // Sort by floating spread
   SORT_BY_SYMBOL_TICKS_BOOKDEPTH,                          // Sort by a maximum number of requests displayed in the market depth
   SORT_BY_SYMBOL_TRADE_CALC_MODE,                          // Sort by contract price calculation method (from the ENUM_SYMBOL_CALC_MODE enumeration)
   SORT_BY_SYMBOL_TRADE_MODE,                               // Sort by order execution type (from the ENUM_SYMBOL_TRADE_MODE enumeration)
   SORT_BY_SYMBOL_START_TIME,                               // Sort by an instrument trading start date (usually used for futures)
   SORT_BY_SYMBOL_EXPIRATION_TIME,                          // Sort by an instrument trading end date (usually used for futures)
   SORT_BY_SYMBOL_TRADE_STOPS_LEVEL,                        // Sort by the minimum indent from the current close price (in points) for setting Stop orders
   SORT_BY_SYMBOL_TRADE_FREEZE_LEVEL,                       // Sort by trade operation freeze distance (in points)
   SORT_BY_SYMBOL_TRADE_EXEMODE,                            // Sort by trade execution mode (from the ENUM_SYMBOL_TRADE_EXECUTION enumeration)
   SORT_BY_SYMBOL_SWAP_MODE,                                // Sort by swap calculation model (from the ENUM_SYMBOL_SWAP_MODE enumeration)
   SORT_BY_SYMBOL_SWAP_ROLLOVER3DAYS,                       // Sort by week day for accruing a triple swap (from the ENUM_DAY_OF_WEEK enumeration)
   SORT_BY_SYMBOL_MARGIN_HEDGED_USE_LEG,                    // Sort by the calculation mode of a hedged margin using the larger leg (Buy or Sell)
   SORT_BY_SYMBOL_EXPIRATION_MODE,                          // Sort by flags of allowed order expiration modes
   SORT_BY_SYMBOL_FILLING_MODE,                             // Sort by flags of allowed order filling modes
   SORT_BY_SYMBOL_ORDER_MODE,                               // Sort by flags of allowed order types
   SORT_BY_SYMBOL_ORDER_GTC_MODE,                           // Sort by StopLoss and TakeProfit orders lifetime
   SORT_BY_SYMBOL_OPTION_MODE,                              // Sort by option type (from the ENUM_SYMBOL_OPTION_MODE enumeration)
   SORT_BY_SYMBOL_OPTION_RIGHT,                             // Sort by option right (Call/Put) (from the ENUM_SYMBOL_OPTION_RIGHT enumeration)
//--- Sort by real properties
   SORT_BY_SYMBOL_BID = FIRST_SYM_DBL_PROP,                 // Sort by Bid
   SORT_BY_SYMBOL_BIDHIGH,                                  // Sort by maximum Bid for a day
   SORT_BY_SYMBOL_BIDLOW,                                   // Sort by minimum Bid for a day
   SORT_BY_SYMBOL_ASK,                                      // Sort by Ask
   SORT_BY_SYMBOL_ASKHIGH,                                  // Sort by maximum Ask for a day
   SORT_BY_SYMBOL_ASKLOW,                                   // Sort by minimum Ask for a day
   SORT_BY_SYMBOL_LAST,                                     // Sort by the last deal price
   SORT_BY_SYMBOL_LASTHIGH,                                 // Sort by maximum Last for a day
   SORT_BY_SYMBOL_LASTLOW,                                  // Sort by minimum Last for a day
   SORT_BY_SYMBOL_VOLUME_REAL,                              // Sort by Volume for a day
   SORT_BY_SYMBOL_VOLUMEHIGH_REAL,                          // Sort by maximum Volume for a day
   SORT_BY_SYMBOL_VOLUMELOW_REAL,                           // Sort by minimum Volume for a day
   SORT_BY_SYMBOL_OPTION_STRIKE,                            // Sort by an option execution price
   SORT_BY_SYMBOL_POINT,                                    // Sort by a single point value
   SORT_BY_SYMBOL_TRADE_TICK_VALUE,                         // Sort by SYMBOL_TRADE_TICK_VALUE_PROFIT value
   SORT_BY_SYMBOL_TRADE_TICK_VALUE_PROFIT,                  // Sort by a calculated tick price for a profitable position
   SORT_BY_SYMBOL_TRADE_TICK_VALUE_LOSS,                    // Sort by a calculated tick price for a loss-making position
   SORT_BY_SYMBOL_TRADE_TICK_SIZE,                          // Sort by a minimum price change
   SORT_BY_SYMBOL_TRADE_CONTRACT_SIZE,                      // Sort by a trading contract size
   SORT_BY_SYMBOL_TRADE_ACCRUED_INTEREST,                   // Sort by accrued interest
   SORT_BY_SYMBOL_TRADE_FACE_VALUE,                         // Sort by face value
   SORT_BY_SYMBOL_TRADE_LIQUIDITY_RATE,                     // Sort by liquidity rate
   SORT_BY_SYMBOL_VOLUME_MIN,                               // Sort by a minimum volume for performing a deal
   SORT_BY_SYMBOL_VOLUME_MAX,                               // Sort by a maximum volume for performing a deal
   SORT_BY_SYMBOL_VOLUME_STEP,                              // Sort by a minimum volume change step for deal execution
   SORT_BY_SYMBOL_VOLUME_LIMIT,                             // Sort by a maximum allowed aggregate volume of an open position and pending orders in one direction
   SORT_BY_SYMBOL_SWAP_LONG,                                // Sort by a long swap value
   SORT_BY_SYMBOL_SWAP_SHORT,                               // Sort by a short swap value
   SORT_BY_SYMBOL_MARGIN_INITIAL,                           // Sort by an initial margin
   SORT_BY_SYMBOL_MARGIN_MAINTENANCE,                       // Sort by a maintenance margin for an instrument
   SORT_BY_SYMBOL_MARGIN_LONG_INITIAL,                      // Sort by initial margin requirement applicable to Long orders
   SORT_BY_SYMBOL_MARGIN_BUY_STOP_INITIAL,                  // Sort by initial margin requirement applicable to BuyStop orders
   SORT_BY_SYMBOL_MARGIN_BUY_LIMIT_INITIAL,                 // Sort by initial margin requirement applicable to BuyLimit orders
   SORT_BY_SYMBOL_MARGIN_BUY_STOPLIMIT_INITIAL,             // Sort by initial margin requirement applicable to BuyStopLimit orders
   SORT_BY_SYMBOL_MARGIN_LONG_MAINTENANCE,                  // Sort by maintenance margin requirement applicable to Long orders
   SORT_BY_SYMBOL_MARGIN_BUY_STOP_MAINTENANCE,              // Sort by maintenance margin requirement applicable to BuyStop orders
   SORT_BY_SYMBOL_MARGIN_BUY_LIMIT_MAINTENANCE,             // Sort by maintenance margin requirement applicable to BuyLimit orders
   SORT_BY_SYMBOL_MARGIN_BUY_STOPLIMIT_MAINTENANCE,         // Sort by maintenance margin requirement applicable to BuyStopLimit orders
   SORT_BY_SYMBOL_MARGIN_SHORT_INITIAL,                     // Sort by initial margin requirement applicable to Short orders
   SORT_BY_SYMBOL_MARGIN_SELL_STOP_INITIAL,                 // Sort by initial margin requirement applicable to SellStop orders
   SORT_BY_SYMBOL_MARGIN_SELL_LIMIT_INITIAL,                // Sort by initial margin requirement applicable to SellLimit orders
   SORT_BY_SYMBOL_MARGIN_SELL_STOPLIMIT_INITIAL,            // Sort by initial margin requirement applicable to SellStopLimit orders
   SORT_BY_SYMBOL_MARGIN_SHORT_MAINTENANCE,                 // Sort by maintenance margin requirement applicable to Short orders
   SORT_BY_SYMBOL_MARGIN_SELL_STOP_MAINTENANCE,             // Sort by maintenance margin requirement applicable to SellStop orders
   SORT_BY_SYMBOL_MARGIN_SELL_LIMIT_MAINTENANCE,            // Sort by maintenance margin requirement applicable to SellLimit orders
   SORT_BY_SYMBOL_MARGIN_SELL_STOPLIMIT_MAINTENANCE,        // Sort by maintenance margin requirement applicable to SellStopLimit orders
   SORT_BY_SYMBOL_SESSION_VOLUME,                           // Sort by summary volume of the current session deals
   SORT_BY_SYMBOL_SESSION_TURNOVER,                         // Sort by the summary turnover of the current session
   SORT_BY_SYMBOL_SESSION_INTEREST,                         // Sort by the summary open interest
   SORT_BY_SYMBOL_SESSION_BUY_ORDERS_VOLUME,                // Sort by the current volume of Buy orders
   SORT_BY_SYMBOL_SESSION_SELL_ORDERS_VOLUME,               // Sort by the current volume of Sell orders
   SORT_BY_SYMBOL_SESSION_OPEN,                             // Sort by an Open price of the current session
   SORT_BY_SYMBOL_SESSION_CLOSE,                            // Sort by a Close price of the current session
   SORT_BY_SYMBOL_SESSION_AW,                               // Sort by an average weighted price of the current session
   SORT_BY_SYMBOL_SESSION_PRICE_SETTLEMENT,                 // Sort by a settlement price of the current session
   SORT_BY_SYMBOL_SESSION_PRICE_LIMIT_MIN,                  // Sort by a minimum price of the current session 
   SORT_BY_SYMBOL_SESSION_PRICE_LIMIT_MAX,                  // Sort by a maximum price of the current session
   SORT_BY_SYMBOL_MARGIN_HEDGED,                            // Sort by a contract size or a margin value per one lot of hedged positions
//--- Sort by string properties
   SORT_BY_SYMBOL_NAME = FIRST_SYM_STR_PROP,                // Sort by a symbol name
   SORT_BY_SYMBOL_BASIS,                                    // Sort by an underlying asset of a derivative
   SORT_BY_SYMBOL_CURRENCY_BASE,                            // Sort by a base currency of a symbol
   SORT_BY_SYMBOL_CURRENCY_PROFIT,                          // Sort by a profit currency
   SORT_BY_SYMBOL_CURRENCY_MARGIN,                          // Sort by a margin currency
   SORT_BY_SYMBOL_BANK,                                     // Sort by a feeder of the current quote
   SORT_BY_SYMBOL_DESCRIPTION,                              // Sort by a symbol string description
   SORT_BY_SYMBOL_FORMULA,                                  // Sort by the formula used for custom symbol pricing
   SORT_BY_SYMBOL_ISIN,                                     // Sort by the name of a symbol in the ISIN system
   SORT_BY_SYMBOL_PAGE,                                     // Sort by an address of the web page containing symbol information
   SORT_BY_SYMBOL_PATH,                                     // Sort by a path in the symbol tree
   SORT_BY_SYMBOL_CATEGORY,                                 // Sort by a symbol category
   SORT_BY_SYMBOL_EXCHANGE                                  // Sort by a name of an exchange a symbol is traded on
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Data for working with program resource data                      |
//+------------------------------------------------------------------+
enum ENUM_FILE_TYPE
  {
   FILE_TYPE_WAV,                                           // wav file
   FILE_TYPE_BMP,                                           // bmp file
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Data for working with trading classes                            |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  Logging level                                                   |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVEL
  {
   LOG_LEVEL_NO_MSG,                                        // Trading logging disabled
   LOG_LEVEL_ERROR_MSG,                                     // Only trading errors
   LOG_LEVEL_ALL_MSG                                        // Full logging
  };
//+------------------------------------------------------------------+
//| EA behavior when handling errors                                 |
//+------------------------------------------------------------------+
enum ENUM_ERROR_HANDLING_BEHAVIOR
  {
   ERROR_HANDLING_BEHAVIOR_BREAK,                           // Abort trading attempt
   ERROR_HANDLING_BEHAVIOR_CORRECT,                         // Correct invalid parameters
   ERROR_HANDLING_BEHAVIOR_PENDING_REQUEST,                 // Create a pending request
  };
//+------------------------------------------------------------------+
//| Flags indicating the trading request error handling methods      |
//+------------------------------------------------------------------+
enum ENUM_TRADE_REQUEST_ERR_FLAGS
  {
   TRADE_REQUEST_ERR_FLAG_NO_ERROR                 =  0,    // No error
   TRADE_REQUEST_ERR_FLAG_FATAL_ERROR              =  1,    // Disable trading for an EA (critical error) - exit
   TRADE_REQUEST_ERR_FLAG_INTERNAL_ERR             =  2,    // Library internal error - exit
   TRADE_REQUEST_ERR_FLAG_ERROR_IN_LIST            =  4,    // Error in the list - handle (ENUM_ERROR_CODE_PROCESSING_METHOD)
   TRADE_REQUEST_ERR_FLAG_PRICE_ERROR              =  8,    // Placement price error
   TRADE_REQUEST_ERR_FLAG_LIMIT_ERROR              =  16,   // Limit order price error
  };
//+------------------------------------------------------------------+
//| The methods of handling errors and server return codes           |
//+------------------------------------------------------------------+
enum ENUM_ERROR_CODE_PROCESSING_METHOD
  {
   ERROR_CODE_PROCESSING_METHOD_OK,                         // No error
   ERROR_CODE_PROCESSING_METHOD_DISABLE,                    // Disable trading for the EA
   ERROR_CODE_PROCESSING_METHOD_EXIT,                       // Exit the trading method
   ERROR_CODE_PROCESSING_METHOD_CORRECT,                    // Correct trading request parameters and repeat
   ERROR_CODE_PROCESSING_METHOD_REFRESH,                    // Update data and repeat
   ERROR_CODE_PROCESSING_METHOD_PENDING,                    // Create a pending request
   ERROR_CODE_PROCESSING_METHOD_WAIT,                       // Wait and repeat
  };
//+------------------------------------------------------------------+
//| Types of performed operations                                    |
//+------------------------------------------------------------------+
enum ENUM_ACTION_TYPE
  {
   ACTION_TYPE_BUY               =  ORDER_TYPE_BUY,               // Open Buy
   ACTION_TYPE_SELL              =  ORDER_TYPE_SELL,              // Open Sell
   ACTION_TYPE_BUY_LIMIT         =  ORDER_TYPE_BUY_LIMIT,         // Place BuyLimit
   ACTION_TYPE_SELL_LIMIT        =  ORDER_TYPE_SELL_LIMIT,        // Place SellLimit
   ACTION_TYPE_BUY_STOP          =  ORDER_TYPE_BUY_STOP,          // Place BuyStop
   ACTION_TYPE_SELL_STOP         =  ORDER_TYPE_SELL_STOP,         // Place SellStop
   ACTION_TYPE_BUY_STOP_LIMIT    =  ORDER_TYPE_BUY_STOP_LIMIT,    // Place BuyStopLimit
   ACTION_TYPE_SELL_STOP_LIMIT   =  ORDER_TYPE_SELL_STOP_LIMIT,   // Place SellStopLimit
   ACTION_TYPE_CLOSE_BY          =  ORDER_TYPE_CLOSE_BY,          // Close a position by an opposite one
   ACTION_TYPE_CLOSE             =  ACTION_TYPE_CLOSE_BY+3,       // Close/remove
   ACTION_TYPE_MODIFY            =  ACTION_TYPE_CLOSE_BY+4,       // Modify
  };
//+------------------------------------------------------------------+
//| Sound setting mode                                               |
//+------------------------------------------------------------------+
enum ENUM_MODE_SET_SOUND
  {
   MODE_SET_SOUND_OPEN,                                     // Opening/placing sound setting mode
   MODE_SET_SOUND_CLOSE,                                    // Closing/removal sound setting mode
   MODE_SET_SOUND_MODIFY_SL,                                // StopLoss modification sound setting mode
   MODE_SET_SOUND_MODIFY_TP,                                // TakeProfit modification sound setting mode
   MODE_SET_SOUND_MODIFY_PRICE,                             // Placing price modification sound setting mode
   MODE_SET_SOUND_ERROR_OPEN,                               // Opening/placing error sound setting mode
   MODE_SET_SOUND_ERROR_CLOSE,                              // Closing/removal error sound setting mode
   MODE_SET_SOUND_ERROR_MODIFY_SL,                          // StopLoss modification error sound setting mode
   MODE_SET_SOUND_ERROR_MODIFY_TP,                          // TakeProfit modification error sound setting mode
   MODE_SET_SOUND_ERROR_MODIFY_PRICE,                       // Placing price modification error sound setting mode
  };
//+------------------------------------------------------------------+
