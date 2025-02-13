//+------------------------------------------------------------------+
//|                                                       Symbol.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
#property strict    // Necessary for mql4
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\BaseObj.mqh"
//+------------------------------------------------------------------+
//| Abstract symbol class                                            |
//+------------------------------------------------------------------+
class CSymbol : public CBaseObj
  {
private:
   struct MqlDataSymbol
     {
      //--- Symbol integer properties
      ENUM_SYMBOL_TRADE_MODE trade_mode;     // SYMBOL_TRADE_MODE Order filling modes
      long session_deals;                    // SYMBOL_SESSION_DEALS The number of deals in the current session 
      long session_buy_orders;               // SYMBOL_SESSION_BUY_ORDERS The total number of current buy orders
      long session_sell_orders;              // SYMBOL_SESSION_SELL_ORDERS The total number of current sell orders
      long volume;                           // SYMBOL_VOLUME Last deal volume
      long volume_high_day;                  // SYMBOL_VOLUMEHIGH Maximum volume within a day
      long volume_low_day;                   // SYMBOL_VOLUMELOW Minimum volume within a day
      int spread;                            // SYMBOL_SPREAD Spread in points
      int stops_level;                       // SYMBOL_TRADE_STOPS_LEVEL Minimum distance in points from the current close price for setting Stop orders
      int freeze_level;                      // SYMBOL_TRADE_FREEZE_LEVEL Freeze distance for trading operations (in points)
      
      //--- Symbol real properties
      double bid_last;                       // SYMBOL_BID/SYMBOL_LAST Bid - the best sell offer/Last deal price
      double bid_last_high;                  // SYMBOL_BIDHIGH/SYMBOL_LASTHIGH Maximum Bid within the day/Maximum Last per day
      double bid_last_low;                   // SYMBOL_BIDLOW/SYMBOL_LASTLOW Minimum Bid within the day/Minimum Last per day
      double ask;                            // SYMBOL_ASK Ask - nest buy offer
      double ask_high;                       // SYMBOL_ASKHIGH Maximum Ask of the day
      double ask_low;                        // SYMBOL_ASKLOW Minimum Ask of the day
      double volume_real_day;                // SYMBOL_VOLUME_REAL Real Volume of the day
      double volume_high_real_day;           // SYMBOL_VOLUMEHIGH_REAL Maximum real Volume of the day
      double volume_low_real_day;            // SYMBOL_VOLUMELOW_REAL Minimum real Volume of the day
      double option_strike;                  // SYMBOL_OPTION_STRIKE Strike price
      double volume_limit;                   // SYMBOL_VOLUME_LIMIT Maximum permissible total volume for a position and pending orders in one direction
      double swap_long;                      // SYMBOL_SWAP_LONG Long swap value
      double swap_short;                     // SYMBOL_SWAP_SHORT Short swap value
      double session_volume;                 // SYMBOL_SESSION_VOLUME The total volume of deals in the current session
      double session_turnover;               // SYMBOL_SESSION_TURNOVER The total turnover in the current session
      double session_interest;               // SYMBOL_SESSION_INTEREST The total volume of open positions
      double session_buy_ord_volume;         // SYMBOL_SESSION_BUY_ORDERS_VOLUME The total volume of Buy orders at the moment
      double session_sell_ord_volume;        // SYMBOL_SESSION_SELL_ORDERS_VOLUME The total volume of Sell orders at the moment
      double session_open;                   // SYMBOL_SESSION_OPEN Session open price
      double session_close;                  // SYMBOL_SESSION_CLOSE Session close price
      double session_aw;                     // SYMBOL_SESSION_AW Average weighted session price
     };
   MqlDataSymbol    m_struct_curr_symbol;    // Current symbol data
   MqlDataSymbol    m_struct_prev_symbol;    // Previous symbol data
//---
   struct MqlMarginRate
     {
      double         Initial;                // initial margin rate
      double         Maintenance;            // maintenance margin rate
     };
   struct MqlMarginRateMode
     {
      MqlMarginRate  Long;                   // MarginRate of long positions
      MqlMarginRate  Short;                  // MarginRate of short positions
      MqlMarginRate  BuyStop;                // MarginRate of BuyStop orders
      MqlMarginRate  BuyLimit;               // MarginRate of BuyLimit orders
      MqlMarginRate  BuyStopLimit;           // MarginRate of BuyStopLimit orders
      MqlMarginRate  SellStop;               // MarginRate of SellStop orders
      MqlMarginRate  SellLimit;              // MarginRate of SellLimit orders
      MqlMarginRate  SellStopLimit;          // MarginRate of SellStopLimit orders

     };
   MqlMarginRateMode m_margin_rate;                            // Margin ratio structure

   MqlBookInfo       m_book_info_array[];                      // Array of the market depth data structures
   long              m_long_prop[SYMBOL_PROP_INTEGER_TOTAL];   // Integer properties
   double            m_double_prop[SYMBOL_PROP_DOUBLE_TOTAL];  // Real properties
   string            m_string_prop[SYMBOL_PROP_STRING_TOTAL];  // String properties
   
   //--- Execution
   bool              m_is_change_trade_mode;                   // Flag of changing trading mode for a symbol
   //--- Current session deals
   long              m_control_session_deals_inc;              // Controlled value of the growth of the number of deals
   long              m_control_session_deals_dec;              // Controlled value of the decrease in the number of deals
   long              m_changed_session_deals_value;            // Value of change in the number of deals
   bool              m_is_change_session_deals_inc;            // Flag of a change in the number of deals exceeding the growth value
   bool              m_is_change_session_deals_dec;            // Flag of a change in the number of deals exceeding the decrease value
   //--- Buy orders of the current session
   long              m_control_session_buy_ord_inc;            // Controlled value of the growth of the number of Buy orders
   long              m_control_session_buy_ord_dec;            // Controlled value of the decrease in the number of Buy orders
   long              m_changed_session_buy_ord_value;          // Buy orders change value
   bool              m_is_change_session_buy_ord_inc;          // Flag of a change in the number of Buy orders exceeding the growth value
   bool              m_is_change_session_buy_ord_dec;          // Flag of a change in the number of Buy orders being less than the growth value
   //--- Sell orders of the current session
   long              m_control_session_sell_ord_inc;           // Controlled value of the growth of the number of Sell orders
   long              m_control_session_sell_ord_dec;           // Controlled value of the decrease in the number of Sell orders
   long              m_changed_session_sell_ord_value;         // Sell orders change value
   bool              m_is_change_session_sell_ord_inc;         // Flag of a change in the number of Sell orders exceeding the growth value
   bool              m_is_change_session_sell_ord_dec;         // Flag of a change in the number of Sell orders exceeding the decrease value
   //--- Volume of the last deal
   long              m_control_volume_inc;                     // Controlled value of the volume growth in the last deal
   long              m_control_volume_dec;                     // Controlled value of the volume decrease in the last deal
   long              m_changed_volume_value;                   // Value of the volume change in the last deal
   bool              m_is_change_volume_inc;                   // Flag of the volume change in the last deal exceeding the growth value
   bool              m_is_change_volume_dec;                   // Flag of the volume change in the last deal being less than the growth value
   //--- Maximum volume within a day
   long              m_control_volume_high_day_inc;            // Controlled value of the maximum volume growth for a day
   long              m_control_volume_high_day_dec;            // Controlled value of the maximum volume decrease for a day
   long              m_changed_volume_high_day_value;          // Maximum volume change value within a day
   bool              m_is_change_volume_high_day_inc;          // Flag of the maximum day volume exceeding the growth value
   bool              m_is_change_volume_high_day_dec;          // Flag of the maximum day volume exceeding the decrease value
   //--- Minimum volume within a day
   long              m_control_volume_low_day_inc;             // Controlled value of the minimum volume growth for a day
   long              m_control_volume_low_day_dec;             // Controlled value of the minimum volume decrease for a day
   long              m_changed_volume_low_day_value;           // Minimum volume change value within a day
   bool              m_is_change_volume_low_day_inc;           // Flag of the minimum day volume exceeding the growth value
   bool              m_is_change_volume_low_day_dec;           // Flag of the minimum day volume exceeding the decrease value
   //--- Spread
   int               m_control_spread_inc;                     // Controlled spread growth value in points
   int               m_control_spread_dec;                     // Controlled spread decrease value in points
   int               m_changed_spread_value;                   // Spread change value in points
   bool              m_is_change_spread_inc;                   // Flag of spread change in points exceeding the growth value
   bool              m_is_change_spread_dec;                   // Flag of spread change in points exceeding the decrease value
   //--- StopLevel
   int               m_control_stops_level_inc;                // Controlled StopLevel growth value in points
   int               m_control_stops_level_dec;                // Controlled StopLevel decrease value in points
   int               m_changed_stops_level_value;              // StopLevel change value in points
   bool              m_is_change_stops_level_inc;              // Flag of StopLevel change in points exceeding the growth value
   bool              m_is_change_stops_level_dec;              // Flag of StopLevel change in points exceeding the decrease value
   //--- Freeze distance
   int               m_control_freeze_level_inc;               // Controlled FreezeLevel growth value in points
   int               m_control_freeze_level_dec;               // Controlled FreezeLevel decrease value in points
   int               m_changed_freeze_level_value;             // FreezeLevel change value in points
   bool              m_is_change_freeze_level_inc;             // Flag of FreezeLevel change in points exceeding the growth value
   bool              m_is_change_freeze_level_dec;             // Flag of FreezeLevel change in points exceeding the decrease value
   
   //--- Bid/Last
   double            m_control_bid_last_inc;                   // Controlled value of Bid or Last price growth
   double            m_control_bid_last_dec;                   // Controlled value of Bid or Last price decrease
   double            m_changed_bid_last_value;                 // Bid or Last price change value
   bool              m_is_change_bid_last_inc;                 // Flag of Bid or Last price change exceeding the growth value
   bool              m_is_change_bid_last_dec;                 // Flag of Bid or Last price change exceeding the decrease value
   //--- Maximum Bid/Last of the day
   double            m_control_bid_last_high_inc;              // Controlled growth value of the maximum Bid or Last price of the day
   double            m_control_bid_last_high_dec;              // Controlled decrease value of the maximum Bid or Last price of the day
   double            m_changed_bid_last_high_value;            // Maximum Bid or Last change value for the day
   bool              m_is_change_bid_last_high_inc;            // Flag of the maximum Bid or Last price change for the day exceeding the growth value
   bool              m_is_change_bid_last_high_dec;            // Flag of the maximum Bid or Last price change for the day exceeding the decrease value
   //--- Minimum Bid/Last of the day
   double            m_control_bid_last_low_inc;               // Controlled growth value of the minimum Bid or Last price of the day
   double            m_control_bid_last_low_dec;               // Controlled decrease value of the minimum Bid or Last price of the day
   double            m_changed_bid_last_low_value;             // Minimum Bid or Last change value for the day
   bool              m_is_change_bid_last_low_inc;             // Flag of the minimum Bid or Last price change for the day exceeding the growth value
   bool              m_is_change_bid_last_low_dec;             // Flag of the minimum Bid or Last price change for the day exceeding the decrease value
   //--- Ask
   double            m_control_ask_inc;                        // Controlled value of the Ask price growth
   double            m_control_ask_dec;                        // Controlled value of the Ask price decrease
   double            m_changed_ask_value;                      // Ask price change value
   bool              m_is_change_ask_inc;                      // Flag of the Ask price change exceeding the growth value
   bool              m_is_change_ask_dec;                      // Flag of the Ask price change exceeding the decrease value
   //--- Maximum Ask price for the day
   double            m_control_ask_high_inc;                   // Controlled growth value of the maximum Ask price of the day
   double            m_control_ask_high_dec;                   // Controlled decrease value of the maximum Ask price of the day
   double            m_changed_ask_high_value;                 // Maximum Ask price change value for the day
   bool              m_is_change_ask_high_inc;                 // Flag of the maximum Ask price change for the day exceeding the growth value
   bool              m_is_change_ask_high_dec;                 // Flag of the maximum Ask price change for the day exceeding the decrease value
   //--- Minimum Ask price for the day
   double            m_control_ask_low_inc;                    // Controlled growth value of the minimum Ask price of the day
   double            m_control_ask_low_dec;                    // Controlled decrease value of the minimum Ask price of the day
   double            m_changed_ask_low_value;                  // Minimum Ask price change value for the day
   bool              m_is_change_ask_low_inc;                  // Flag of the minimum Ask price change for the day exceeding the growth value
   bool              m_is_change_ask_low_dec;                  // Flag of the minimum Ask price change for the day exceeding the decrease value
   //--- Real Volume for the day
   double            m_control_volume_real_inc;                // Controlled value of the real volume growth of the day
   double            m_control_volume_real_dec;                // Controlled value of the real volume decrease of the day
   double            m_changed_volume_real_value;              // Real volume change value of the day
   bool              m_is_change_volume_real_inc;              // Flag of the real volume change for the day exceeding the growth value
   bool              m_is_change_volume_real_dec;              // Flag of the real volume change for the day exceeding the decrease value
   //--- Maximum real volume for the day
   double            m_control_volume_high_real_day_inc;       // Controlled value of the maximum real volume growth of the day
   double            m_control_volume_high_real_day_dec;       // Controlled value of the maximum real volume decrease of the day
   double            m_changed_volume_high_real_day_value;     // Maximum real volume change value of the day
   bool              m_is_change_volume_high_real_day_inc;     // Flag of the maximum real volume change for the day exceeding the growth value
   bool              m_is_change_volume_high_real_day_dec;     // Flag of the maximum real volume change for the day exceeding the decrease value
   //--- Minimum real volume for the day
   double            m_control_volume_low_real_day_inc;        // Controlled value of the minimum real volume growth of the day
   double            m_control_volume_low_real_day_dec;        // Controlled value of the minimum real volume decrease of the day
   double            m_changed_volume_low_real_day_value;      // Minimum real volume change value of the day
   bool              m_is_change_volume_low_real_day_inc;      // Flag of the minimum real volume change for the day exceeding the growth value
   bool              m_is_change_volume_low_real_day_dec;      // Flag of the minimum real volume change for the day exceeding the decrease value
   //--- Strike price
   double            m_control_option_strike_inc;              // Controlled value of the strike price growth
   double            m_control_option_strike_dec;              // Controlled value of the strike price decrease
   double            m_changed_option_strike_value;            // Strike price change value
   bool              m_is_change_option_strike_inc;            // Flag of the strike price change exceeding the growth value
   bool              m_is_change_option_strike_dec;            // Flag of the strike price change exceeding the decrease value
   //--- Total volume of positions and orders
   double            m_changed_volume_limit_value;             // Minimum total volume change value
   bool              m_is_change_volume_limit_inc;             // Flag of the minimum total volume increase
   bool              m_is_change_volume_limit_dec;             // Flag of the minimum total volume decrease
   //---  Swap long
   double            m_changed_swap_long_value;                // Swap long change value
   bool              m_is_change_swap_long_inc;                // Flag of the swap long increase
   bool              m_is_change_swap_long_dec;                // Flag of the swap long decrease
   //---  Swap short

   double            m_changed_swap_short_value;               // Swap short change value
   bool              m_is_change_swap_short_inc;               // Flag of the swap short increase
   bool              m_is_change_swap_short_dec;               // Flag of the swap short decrease
   //--- The total volume of deals in the current session
   double            m_control_session_volume_inc;             // Controlled value of the total trade volume growth in the current session
   double            m_control_session_volume_dec;             // Controlled value of the total trade volume decrease in the current session
   double            m_changed_session_volume_value;           // The total deal volume change value in the current session
   bool              m_is_change_session_volume_inc;           // Flag of total trade volume change in the current session exceeding the growth value
   bool              m_is_change_session_volume_dec;           // Flag of total trade volume change in the current session exceeding the decrease value
   //--- The total turnover in the current session
   double            m_control_session_turnover_inc;           // Controlled value of the total turnover growth in the current session
   double            m_control_session_turnover_dec;           // Controlled value of the total turnover decrease in the current session
   double            m_changed_session_turnover_value;         // Total turnover change value in the current session
   bool              m_is_change_session_turnover_inc;         // Flag of total turnover change in the current session exceeding the growth value
   bool              m_is_change_session_turnover_dec;         // Flag of total turnover change in the current session exceeding the decrease value
   //--- The total volume of open positions
   double            m_control_session_interest_inc;           // Controlled value of the total open position volume growth in the current session
   double            m_control_session_interest_dec;           // Controlled value of the total open position volume decrease in the current session
   double            m_changed_session_interest_value;         // Change value of the open positions total volume in the current session
   bool              m_is_change_session_interest_inc;         // Flag of total open positions' volume change in the current session exceeding the growth value
   bool              m_is_change_session_interest_dec;         // Flag of total open positions' volume change in the current session exceeding the decrease value
   //--- The total volume of Buy orders at the moment
   double            m_control_session_buy_ord_volume_inc;     // Controlled value of the current total buy order volume growth
   double            m_control_session_buy_ord_volume_dec;     // Controlled value of the current total buy order volume decrease
   double            m_changed_session_buy_ord_volume_value;   // Change value of the current total buy order volume
   bool              m_is_change_session_buy_ord_volume_inc;   // Flag of changing the current total buy orders volume exceeding the growth value
   bool              m_is_change_session_buy_ord_volume_dec;   // Flag of changing the current total buy orders volume exceeding the decrease value
   //--- The total volume of Sell orders at the moment
   double            m_control_session_sell_ord_volume_inc;    // Controlled value of the current total sell order volume growth
   double            m_control_session_sell_ord_volume_dec;    // Controlled value of the current total sell order volume decrease
   double            m_changed_session_sell_ord_volume_value;  // Change value of the current total sell order volume
   bool              m_is_change_session_sell_ord_volume_inc;  // Flag of changing the current total sell orders volume exceeding the growth value
   bool              m_is_change_session_sell_ord_volume_dec;  // Flag of changing the current total sell orders volume exceeding the decrease value
   //--- Session open price
   double            m_control_session_open_inc;               // Controlled value of the session open price growth
   double            m_control_session_open_dec;               // Controlled value of the session open price decrease
   double            m_changed_session_open_value;             // Session open price change value
   bool              m_is_change_session_open_inc;             // Flag of the session open price change exceeding the growth value
   bool              m_is_change_session_open_dec;             // Flag of the session open price change exceeding the decrease value
   //--- Session close price
   double            m_control_session_close_inc;              // Controlled value of the session close price growth
   double            m_control_session_close_dec;              // Controlled value of the session close price decrease
   double            m_changed_session_close_value;            // Session close price change value
   bool              m_is_change_session_close_inc;            // Flag of the session close price change exceeding the growth value
   bool              m_is_change_session_close_dec;            // Flag of the session close price change exceeding the decrease value
   //--- The average weighted session price
   double            m_control_session_aw_inc;                 // Controlled value of the average weighted session price growth
   double            m_control_session_aw_dec;                 // Controlled value of the average weighted session price decrease
   double            m_changed_session_aw_value;               // The average weighted session price change value
   bool              m_is_change_session_aw_inc;               // Flag of the average weighted session price change value exceeding the growth value
   bool              m_is_change_session_aw_dec;               // Flag of the average weighted session price change value exceeding the decrease value
   
//--- Initialize the variables of (1) tracked, (2) controlled symbol data
   virtual void      InitChangesParams(void);
   virtual void      InitControlsParams(void);
//--- Check symbol changes, return a change code
   virtual int       SetEventCode(void);
//--- Set an event type and fill in the event list
   virtual void      SetTypeEvent(void);
   
//--- Return the index of the array the symbol's (1) double and (2) string properties are located at
   int               IndexProp(ENUM_SYMBOL_PROP_DOUBLE property)  const { return(int)property-SYMBOL_PROP_INTEGER_TOTAL;                                    }
   int               IndexProp(ENUM_SYMBOL_PROP_STRING property)  const { return(int)property-SYMBOL_PROP_INTEGER_TOTAL-SYMBOL_PROP_DOUBLE_TOTAL;           }
//--- (1) Fill in all the "margin ratio" symbol properties, (2) initialize the ratios
   bool              MarginRates(void);
   void              InitMarginRates(void);
//--- Reset all symbol object data
   void              Reset(void);
//--- Return the current day of the week
   ENUM_DAY_OF_WEEK  CurrentDayOfWeek(void)              const;

public:
//--- Default constructor
                     CSymbol(void){;}
protected:
//--- Protected parametric constructor
                     CSymbol(ENUM_SYMBOL_STATUS symbol_status,const string name,const int index);

//--- Get and return integer properties of a selected symbol from its parameters
   bool              SymbolExists(const string name)     const;
   long              SymbolExists(void)                  const;
   long              SymbolCustom(void)                  const;
   long              SymbolChartMode(void)               const;
   long              SymbolMarginHedgedUseLEG(void)      const;
   long              SymbolOrderFillingMode(void)        const;
   long              SymbolOrderMode(void)               const;
   long              SymbolExpirationMode(void)          const;
   long              SymbolOrderGTCMode(void)            const;
   long              SymbolOptionMode(void)              const;
   long              SymbolOptionRight(void)             const;
   long              SymbolBackgroundColor(void)         const;
   long              SymbolCalcMode(void)                const;
   long              SymbolSwapMode(void)                const;
   long              SymbolDigitsLot(void);
   int               SymbolDigitsBySwap(void);
//--- Get and return real properties of a selected symbol from its parameters
   double            SymbolBidHigh(void)                 const;
   double            SymbolBidLow(void)                  const;
   double            SymbolVolumeReal(void)              const;
   double            SymbolVolumeHighReal(void)          const;
   double            SymbolVolumeLowReal(void)           const;
   double            SymbolOptionStrike(void)            const;
   double            SymbolTradeAccruedInterest(void)    const;
   double            SymbolTradeFaceValue(void)          const;
   double            SymbolTradeLiquidityRate(void)      const;
   double            SymbolMarginHedged(void)            const;
   bool              SymbolMarginLong(void);
   bool              SymbolMarginShort(void);
   bool              SymbolMarginBuyStop(void);
   bool              SymbolMarginBuyLimit(void);
   bool              SymbolMarginBuyStopLimit(void);
   bool              SymbolMarginSellStop(void);
   bool              SymbolMarginSellLimit(void);
   bool              SymbolMarginSellStopLimit(void);
//--- Get and return string properties of a selected symbol from its parameters
   string            SymbolBasis(void)                   const;
   string            SymbolBank(void)                    const;
   string            SymbolISIN(void)                    const;
   string            SymbolFormula(void)                 const;
   string            SymbolPage(void)                    const;
//--- Search for a symbol and return the flag indicating its presence on the server
   bool              Exist(void)                         const;

public:
//--- Set (1) integer, (2) real and (3) string symbol properties
   void              SetProperty(ENUM_SYMBOL_PROP_INTEGER property,long value)   { this.m_long_prop[property]=value;                                        }
   void              SetProperty(ENUM_SYMBOL_PROP_DOUBLE property,double value)  { this.m_double_prop[this.IndexProp(property)]=value;                      }
   void              SetProperty(ENUM_SYMBOL_PROP_STRING property,string value)  { this.m_string_prop[this.IndexProp(property)]=value;                      }
//--- Return (1) integer, (2) real and (3) string symbol properties from the properties array
   long              GetProperty(ENUM_SYMBOL_PROP_INTEGER property)        const { return this.m_long_prop[property];                                       }
   double            GetProperty(ENUM_SYMBOL_PROP_DOUBLE property)         const { return this.m_double_prop[this.IndexProp(property)];                     }
   string            GetProperty(ENUM_SYMBOL_PROP_STRING property)         const { return this.m_string_prop[this.IndexProp(property)];                     }

//--- Return the flag of a symbol supporting the property
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_INTEGER property)          { return true; }
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_DOUBLE property)           { return true; }
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_STRING property)           { return true; }
   
//--- Return the flag of allowing (1) market, (2) limit, (3) stop (4) and stop limit orders,
//--- the flag of allowing setting (5) StopLoss and (6) TakeProfit orders, (7) as well as closing by an opposite order
   bool              IsMarketOrdersAllowed(void)            const { return((this.OrderModeFlags() & SYMBOL_ORDER_MARKET)==SYMBOL_ORDER_MARKET);             }
   bool              IsLimitOrdersAllowed(void)             const { return((this.OrderModeFlags() & SYMBOL_ORDER_LIMIT)==SYMBOL_ORDER_LIMIT);               }
   bool              IsStopOrdersAllowed(void)              const { return((this.OrderModeFlags() & SYMBOL_ORDER_STOP)==SYMBOL_ORDER_STOP);                 }
   bool              IsStopLimitOrdersAllowed(void)         const { return((this.OrderModeFlags() & SYMBOL_ORDER_STOP_LIMIT)==SYMBOL_ORDER_STOP_LIMIT);     }
   bool              IsStopLossOrdersAllowed(void)          const { return((this.OrderModeFlags() & SYMBOL_ORDER_SL)==SYMBOL_ORDER_SL);                     }
   bool              IsTakeProfitOrdersAllowed(void)        const { return((this.OrderModeFlags() & SYMBOL_ORDER_TP)==SYMBOL_ORDER_TP);                     }
   bool              IsCloseByOrdersAllowed(void)           const;

//--- Return the (1) FOK and (2) IOC filling flag
   bool              IsFillingModeFOK(void)                 const { return((this.FillingModeFlags() & SYMBOL_FILLING_FOK)==SYMBOL_FILLING_FOK);             }
   bool              IsFillingModeIOC(void)                 const { return((this.FillingModeFlags() & SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC);             }

//--- Return the flag of order expiration: (1) GTC, (2) DAY, (3) Specified and (4) Specified Day
   bool              IsExpirationModeGTC(void)              const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_GTC)==SYMBOL_EXPIRATION_GTC);    }
   bool              IsExpirationModeDAY(void)              const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_DAY)==SYMBOL_EXPIRATION_DAY);    }
   bool              IsExpirationModeSpecified(void)        const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED)==SYMBOL_EXPIRATION_SPECIFIED);          }
   bool              IsExpirationModeSpecifiedDay(void)     const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED_DAY)==SYMBOL_EXPIRATION_SPECIFIED_DAY);  }

//--- Return the description of allowing (1) market, (2) limit, (3) stop and (4) stop limit orders,
//--- the description of allowing (5) StopLoss and (6) TakeProfit orders, (7) as well as closing by an opposite order
   string            GetMarketOrdersAllowedDescription(void)      const;
   string            GetLimitOrdersAllowedDescription(void)       const;
   string            GetStopOrdersAllowedDescription(void)        const;
   string            GetStopLimitOrdersAllowedDescription(void)   const;
   string            GetStopLossOrdersAllowedDescription(void)    const;
   string            GetTakeProfitOrdersAllowedDescription(void)  const;
   string            GetCloseByOrdersAllowedDescription(void)     const;

//--- Return the description of allowing the filling type (1) FOK and (2) IOC, (3) as well as allowed order expiration modes
   string            GetFillingModeFOKAllowedDescrioption(void)   const;
   string            GetFillingModeIOCAllowedDescrioption(void)   const;

//--- Return the description of order expiration: (1) GTC, (2) DAY, (3) Specified and (4) Specified Day
   string            GetExpirationModeGTCDescription(void)        const;
   string            GetExpirationModeDAYDescription(void)        const;
   string            GetExpirationModeSpecifiedDescription(void)  const;
   string            GetExpirationModeSpecDayDescription(void)    const;

//--- Return the description of the (1) status, (2) price type for constructing bars, 
//--- (3) method of calculating margin, (4) instrument trading mode,
//--- (5) deal execution mode for a symbol, (6) swap calculation mode,
//--- (7) StopLoss and TakeProfit lifetime, (8) option type, (9) option rights
//--- flags of (10) allowed order types, (11) allowed filling types,
//--- (12) allowed order expiration modes
   string            GetStatusDescription(void)                   const;
   string            GetChartModeDescription(void)                const;
   string            GetCalcModeDescription(void)                 const;
   string            GetTradeModeDescription(void)                const;
   string            GetTradeExecDescription(void)                const;
   string            GetSwapModeDescription(void)                 const;
   string            GetOrderGTCModeDescription(void)             const;
   string            GetOptionTypeDescription(void)               const;
   string            GetOptionRightDescription(void)              const;
   string            GetOrderModeFlagsDescription(void)           const;
   string            GetFillingModeFlagsDescription(void)         const;
   string            GetExpirationModeFlagsDescription(void)      const;
   
//+------------------------------------------------------------------+
//| Description of symbol object properties                          |
//+------------------------------------------------------------------+
//--- Get description of a symbol (1) integer, (2) real and (3) string properties
   string            GetPropertyDescription(ENUM_SYMBOL_PROP_INTEGER property);
   string            GetPropertyDescription(ENUM_SYMBOL_PROP_DOUBLE property);
   string            GetPropertyDescription(ENUM_SYMBOL_PROP_STRING property);

//--- Send description of symbol properties to the journal (full_prop=true - all properties, false - only supported ones)
   void              Print(const bool full_prop=false);
//--- Display a short symbol description in the journal (implementation in the descendants)
   virtual void      PrintShort(void) {;}

//--- Compare CSymbol objects by all possible properties (for sorting lists by a specified symbol object property)
   virtual int       Compare(const CObject *node,const int mode=0) const;
//--- Compare CSymbol objects by all properties (for searching for equal event objects)
   bool              IsEqual(CSymbol* compared_symbol) const;

//--- Update all symbol data
   virtual void      Refresh(void);
//--- Update quote data by a symbol
   bool              RefreshRates(void);
//--- Return description of symbol events
   string            EventDescription(const ENUM_SYMBOL_EVENT event);

//--- (1) Add, (2) remove a symbol from the Market Watch window, (3) return the data synchronization flag by a symbol
   bool              SetToMarketWatch(void)                       const { return ::SymbolSelect(this.m_name,true);                                   }
   bool              RemoveFromMarketWatch(void)                  const { return ::SymbolSelect(this.m_name,false);                                  }
   bool              IsSynchronized(void)                         const { return ::SymbolIsSynchronized(this.m_name);                                }
//--- Return the (1) start and (2) end time of the week day's quote session, (3) the start and end time of the required quote session
   long              SessionQuoteTimeFrom(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE)   const;
   long              SessionQuoteTimeTo(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE)     const;
   bool              GetSessionQuote(const uint session_index,ENUM_DAY_OF_WEEK day_of_week,datetime &from,datetime &to);
//--- Return the (1) start and (2) end time of the week day's trading session, (3) the start and end time of the required trading session
   long              SessionTradeTimeFrom(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE)   const;
   long              SessionTradeTimeTo(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE)     const;
   bool              GetSessionTrade(const uint session_index,ENUM_DAY_OF_WEEK day_of_week,datetime &from,datetime &to);
//--- (1) Arrange a (1) subscription to the market depth, (2) close the market depth, (3) fill in the market depth data to the structure array
   bool              BookAdd(void)                                const;
   bool              BookClose(void)                              const;
//--- Return (1) a session duration description in the hh:mm:ss format, number of (1) hours, (2) minutes and (3) seconds in the session duration time
   string            SessionDurationDescription(const ulong duration_sec) const;
private:
   int               SessionHours(const ulong duration_sec)       const;
   int               SessionMinutes(const ulong duration_sec)     const;
   int               SessionSeconds(const ulong duration_sec)     const;
public:
//+------------------------------------------------------------------+
//| Methods of a simplified access to the order object properties    |
//+------------------------------------------------------------------+
//--- Integer properties
   long              Status(void)                                 const { return this.GetProperty(SYMBOL_PROP_STATUS);                                      }
   int               IndexInMarketWatch(void)                     const { return (int)this.GetProperty(SYMBOL_PROP_INDEX_MW);                               }
   bool              IsCustom(void)                               const { return (bool)this.GetProperty(SYMBOL_PROP_CUSTOM);                                }
   color             ColorBackground(void)                        const { return (color)this.GetProperty(SYMBOL_PROP_BACKGROUND_COLOR);                     }
   ENUM_SYMBOL_CHART_MODE ChartMode(void)                         const { return (ENUM_SYMBOL_CHART_MODE)this.GetProperty(SYMBOL_PROP_CHART_MODE);          }
   bool              IsExist(void)                                const { return (bool)this.GetProperty(SYMBOL_PROP_EXIST);                                 }
   bool              IsExist(const string name)                   const { return this.SymbolExists(name);                                                   }
   bool              IsSelect(void)                               const { return (bool)this.GetProperty(SYMBOL_PROP_SELECT);                                }
   bool              IsVisible(void)                              const { return (bool)this.GetProperty(SYMBOL_PROP_VISIBLE);                               }
   long              SessionDeals(void)                           const { return this.GetProperty(SYMBOL_PROP_SESSION_DEALS);                               }
   long              SessionBuyOrders(void)                       const { return this.GetProperty(SYMBOL_PROP_SESSION_BUY_ORDERS);                          }
   long              SessionSellOrders(void)                      const { return this.GetProperty(SYMBOL_PROP_SESSION_SELL_ORDERS);                         }
   long              Volume(void)                                 const { return this.GetProperty(SYMBOL_PROP_VOLUME);                                      }
   long              VolumeHigh(void)                             const { return this.GetProperty(SYMBOL_PROP_VOLUMEHIGH);                                  }
   long              VolumeLow(void)                              const { return this.GetProperty(SYMBOL_PROP_VOLUMELOW);                                   }
   datetime          Time(void)                                   const { return (datetime)this.GetProperty(SYMBOL_PROP_TIME);                              }
   int               Digits(void)                                 const { return (int)this.GetProperty(SYMBOL_PROP_DIGITS);                                 }
   int               DigitsLot(void)                              const { return (int)this.GetProperty(SYMBOL_PROP_DIGITS_LOTS);                            }
   int               Spread(void)                                 const { return (int)this.GetProperty(SYMBOL_PROP_SPREAD);                                 }
   bool              IsSpreadFloat(void)                          const { return (bool)this.GetProperty(SYMBOL_PROP_SPREAD_FLOAT);                          }
   int               TicksBookdepth(void)                         const { return (int)this.GetProperty(SYMBOL_PROP_TICKS_BOOKDEPTH);                        }
   ENUM_SYMBOL_CALC_MODE TradeCalcMode(void)                      const { return (ENUM_SYMBOL_CALC_MODE)this.GetProperty(SYMBOL_PROP_TRADE_CALC_MODE);      }
   ENUM_SYMBOL_TRADE_MODE TradeMode(void)                         const { return (ENUM_SYMBOL_TRADE_MODE)this.GetProperty(SYMBOL_PROP_TRADE_MODE);          }
   datetime          StartTime(void)                              const { return (datetime)this.GetProperty(SYMBOL_PROP_START_TIME);                        }
   datetime          ExpirationTime(void)                         const { return (datetime)this.GetProperty(SYMBOL_PROP_EXPIRATION_TIME);                   }
   int               TradeStopLevel(void)                         const { return (int)this.GetProperty(SYMBOL_PROP_TRADE_STOPS_LEVEL);                      }
   int               TradeFreezeLevel(void)                       const { return (int)this.GetProperty(SYMBOL_PROP_TRADE_FREEZE_LEVEL);                     }
   ENUM_SYMBOL_TRADE_EXECUTION TradeExecutionMode(void)           const { return (ENUM_SYMBOL_TRADE_EXECUTION)this.GetProperty(SYMBOL_PROP_TRADE_EXEMODE);  }
   ENUM_SYMBOL_SWAP_MODE SwapMode(void)                           const { return (ENUM_SYMBOL_SWAP_MODE)this.GetProperty(SYMBOL_PROP_SWAP_MODE);            }
   ENUM_DAY_OF_WEEK  SwapRollover3Days(void)                      const { return (ENUM_DAY_OF_WEEK)this.GetProperty(SYMBOL_PROP_SWAP_ROLLOVER3DAYS);        }
   bool              IsMarginHedgedUseLeg(void)                   const { return (bool)this.GetProperty(SYMBOL_PROP_MARGIN_HEDGED_USE_LEG);                 }
   int               ExpirationModeFlags(void)                    const { return (int)this.GetProperty(SYMBOL_PROP_EXPIRATION_MODE);                        }
   int               FillingModeFlags(void)                       const { return (int)this.GetProperty(SYMBOL_PROP_FILLING_MODE);                           }
   int               OrderModeFlags(void)                         const { return (int)this.GetProperty(SYMBOL_PROP_ORDER_MODE);                             }
   ENUM_SYMBOL_ORDER_GTC_MODE OrderModeGTC(void)                  const { return (ENUM_SYMBOL_ORDER_GTC_MODE)this.GetProperty(SYMBOL_PROP_ORDER_GTC_MODE);  }
   ENUM_SYMBOL_OPTION_MODE OptionMode(void)                       const { return (ENUM_SYMBOL_OPTION_MODE)this.GetProperty(SYMBOL_PROP_OPTION_MODE);        }
   ENUM_SYMBOL_OPTION_RIGHT OptionRight(void)                     const { return (ENUM_SYMBOL_OPTION_RIGHT)this.GetProperty(SYMBOL_PROP_OPTION_RIGHT);      }
//--- Real properties
   double            Bid(void)                                    const { return this.GetProperty(SYMBOL_PROP_BID);                                         }
   double            BidHigh(void)                                const { return this.GetProperty(SYMBOL_PROP_BIDHIGH);                                     }
   double            BidLow(void)                                 const { return this.GetProperty(SYMBOL_PROP_BIDLOW);                                      }
   double            Ask(void)                                    const { return this.GetProperty(SYMBOL_PROP_ASK);                                         }
   double            AskHigh(void)                                const { return this.GetProperty(SYMBOL_PROP_ASKHIGH);                                     }
   double            AskLow(void)                                 const { return this.GetProperty(SYMBOL_PROP_ASKLOW);                                      }
   double            Last(void)                                   const { return this.GetProperty(SYMBOL_PROP_LAST);                                        }
   double            LastHigh(void)                               const { return this.GetProperty(SYMBOL_PROP_LASTHIGH);                                    }
   double            LastLow(void)                                const { return this.GetProperty(SYMBOL_PROP_LASTLOW);                                     }
   double            VolumeReal(void)                             const { return this.GetProperty(SYMBOL_PROP_VOLUME_REAL);                                 }
   double            VolumeHighReal(void)                         const { return this.GetProperty(SYMBOL_PROP_VOLUMEHIGH_REAL);                             }
   double            VolumeLowReal(void)                          const { return this.GetProperty(SYMBOL_PROP_VOLUMELOW_REAL);                              }
   double            OptionStrike(void)                           const { return this.GetProperty(SYMBOL_PROP_OPTION_STRIKE);                               }
   double            Point(void)                                  const { return this.GetProperty(SYMBOL_PROP_POINT);                                       }
   double            TradeTickValue(void)                         const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE);                            }
   double            TradeTickValueProfit(void)                   const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT);                     }
   double            TradeTickValueLoss(void)                     const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS);                       }
   double            TradeTickSize(void)                          const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_SIZE);                             }
   double            TradeContractSize(void)                      const { return this.GetProperty(SYMBOL_PROP_TRADE_CONTRACT_SIZE);                         }
   double            TradeAccuredInterest(void)                   const { return this.GetProperty(SYMBOL_PROP_TRADE_ACCRUED_INTEREST);                      }
   double            TradeFaceValue(void)                         const { return this.GetProperty(SYMBOL_PROP_TRADE_FACE_VALUE);                            }
   double            TradeLiquidityRate(void)                     const { return this.GetProperty(SYMBOL_PROP_TRADE_LIQUIDITY_RATE);                        }
   double            LotsMin(void)                                const { return this.GetProperty(SYMBOL_PROP_VOLUME_MIN);                                  }
   double            LotsMax(void)                                const { return this.GetProperty(SYMBOL_PROP_VOLUME_MAX);                                  }
   double            LotsStep(void)                               const { return this.GetProperty(SYMBOL_PROP_VOLUME_STEP);                                 }
   double            VolumeLimit(void)                            const { return this.GetProperty(SYMBOL_PROP_VOLUME_LIMIT);                                }
   double            SwapLong(void)                               const { return this.GetProperty(SYMBOL_PROP_SWAP_LONG);                                   }
   double            SwapShort(void)                              const { return this.GetProperty(SYMBOL_PROP_SWAP_SHORT);                                  }
   double            MarginInitial(void)                          const { return this.GetProperty(SYMBOL_PROP_MARGIN_INITIAL);                              }
   double            MarginMaintenance(void)                      const { return this.GetProperty(SYMBOL_PROP_MARGIN_MAINTENANCE);                          }
   double            MarginLongInitial(void)                      const { return this.GetProperty(SYMBOL_PROP_MARGIN_LONG_INITIAL);                         }
   double            MarginBuyStopInitial(void)                   const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL);                     }
   double            MarginBuyLimitInitial(void)                  const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL);                    }
   double            MarginBuyStopLimitInitial(void)              const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL);                }
   double            MarginLongMaintenance(void)                  const { return this.GetProperty(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE);                     }
   double            MarginBuyStopMaintenance(void)               const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE);                 }
   double            MarginBuyLimitMaintenance(void)              const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE);                }
   double            MarginBuyStopLimitMaintenance(void)          const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE);            }
   double            MarginShortInitial(void)                     const { return this.GetProperty(SYMBOL_PROP_MARGIN_SHORT_INITIAL);                        }
   double            MarginSellStopInitial(void)                  const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL);                    }
   double            MarginSellLimitInitial(void)                 const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL);                   }
   double            MarginSellStopLimitInitial(void)             const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL);               }
   double            MarginShortMaintenance(void)                 const { return this.GetProperty(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE);                    }
   double            MarginSellStopMaintenance(void)              const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE);                }
   double            MarginSellLimitMaintenance(void)             const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE);               }
   double            MarginSellStopLimitMaintenance(void)         const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE);           }
   double            SessionVolume(void)                          const { return this.GetProperty(SYMBOL_PROP_SESSION_VOLUME);                              }
   double            SessionTurnover(void)                        const { return this.GetProperty(SYMBOL_PROP_SESSION_TURNOVER);                            }
   double            SessionInterest(void)                        const { return this.GetProperty(SYMBOL_PROP_SESSION_INTEREST);                            }
   double            SessionBuyOrdersVolume(void)                 const { return this.GetProperty(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME);                   }
   double            SessionSellOrdersVolume(void)                const { return this.GetProperty(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME);                  }
   double            SessionOpen(void)                            const { return this.GetProperty(SYMBOL_PROP_SESSION_OPEN);                                }
   double            SessionClose(void)                           const { return this.GetProperty(SYMBOL_PROP_SESSION_CLOSE);                               }
   double            SessionAW(void)                              const { return this.GetProperty(SYMBOL_PROP_SESSION_AW);                                  }
   double            SessionPriceSettlement(void)                 const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT);                    }
   double            SessionPriceLimitMin(void)                   const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN);                     }
   double            SessionPriceLimitMax(void)                   const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX);                     }
   double            MarginHedged(void)                           const { return this.GetProperty(SYMBOL_PROP_MARGIN_HEDGED);                               }
   double            NormalizedPrice(const double price)          const;
   double            BidLast(void)                                const;
   double            BidLastHigh(void)                            const;
   double            BidLastLow(void)                             const;
//--- String properties
   string            Name(void)                                   const { return this.GetProperty(SYMBOL_PROP_NAME);                                        }
   string            Basis(void)                                  const { return this.GetProperty(SYMBOL_PROP_BASIS);                                       }
   string            CurrencyBase(void)                           const { return this.GetProperty(SYMBOL_PROP_CURRENCY_BASE);                               }
   string            CurrencyProfit(void)                         const { return this.GetProperty(SYMBOL_PROP_CURRENCY_PROFIT);                             }
   string            CurrencyMargin(void)                         const { return this.GetProperty(SYMBOL_PROP_CURRENCY_MARGIN);                             }
   string            Bank(void)                                   const { return this.GetProperty(SYMBOL_PROP_BANK);                                        }
   string            Description(void)                            const { return this.GetProperty(SYMBOL_PROP_DESCRIPTION);                                 }
   string            Formula(void)                                const { return this.GetProperty(SYMBOL_PROP_FORMULA);                                     }
   string            ISIN(void)                                   const { return this.GetProperty(SYMBOL_PROP_ISIN);                                        }
   string            Page(void)                                   const { return this.GetProperty(SYMBOL_PROP_PAGE);                                        }
   string            Path(void)                                   const { return this.GetProperty(SYMBOL_PROP_PATH);                                        }
   
//+------------------------------------------------------------------+
//| Get and set the parameters of tracked changes                    |
//+------------------------------------------------------------------+
   //--- Execution
   //--- Flag of changing the trading mode for a symbol
   bool              IsChangedTradeMode(void)                              const { return this.m_is_change_trade_mode;                       } 
   //--- Current session deals
   //--- setting the controlled value of (1) growth, (2) decrease in the number of deals during the current session
   //--- getting (3) the number of deals change value during the current session,
   //--- getting the flag of the number of deals change during the current session exceeding the (4) growth, (5) decrease value
   void              SetControlSessionDealsInc(const long value)                 { this.m_control_session_deals_inc=::fabs(value);           }
   void              SetControlSessionDealsDec(const long value)                 { this.m_control_session_deals_dec=::fabs(value);           }
   long              GetValueChangedSessionDeals(void)                     const { return this.m_changed_session_deals_value;                }
   bool              IsIncreaseSessionDeals(void)                          const { return this.m_is_change_session_deals_inc;                }
   bool              IsDecreaseSessionDeals(void)                          const { return this.m_is_change_session_deals_dec;                }
   //--- Buy orders of the current session
   //--- setting the controlled value of (1) growth, (2) decrease in the current number of Buy orders
   //--- getting (3) the current number of Buy orders change value,
   //--- getting the flag of the current Buy orders' number change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionBuyOrdInc(const long value)                { this.m_control_session_buy_ord_inc=::fabs(value);         }
   void              SetControlSessionBuyOrdDec(const long value)                { this.m_control_session_buy_ord_dec=::fabs(value);         }
   long              GetValueChangedSessionBuyOrders(void)                 const { return this.m_changed_session_buy_ord_value;              }
   bool              IsIncreaseSessionBuyOrders(void)                      const { return this.m_is_change_session_buy_ord_inc;              }
   bool              IsDecreaseSessionBuyOrders(void)                      const { return this.m_is_change_session_buy_ord_dec;              }
   //--- Sell orders of the current session
   //--- setting the controlled value of (1) growth, (2) decrease in the current number of Sell orders
   //--- getting (3) the current number of Sell orders change value,
   //--- getting the flag of the current Sell orders' number change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionSellOrdInc(const long value)               { this.m_control_session_sell_ord_inc=::fabs(value);        }
   void              SetControlSessionSellOrdDec(const long value)               { this.m_control_session_sell_ord_dec=::fabs(value);        }
   long              GetValueChangedSessionSellOrders(void)                const { return this.m_changed_session_sell_ord_value;             }
   bool              IsIncreaseSessionSellOrders(void)                     const { return this.m_is_change_session_sell_ord_inc;             }
   bool              IsDecreaseSessionSellOrders(void)                     const { return this.m_is_change_session_sell_ord_dec;             }
   //--- Volume of the last deal
   //--- setting the last deal volume controlled (1) growth, (2) decrease value
   //--- getting (3) volume change values in the last deal,
   //--- getting the flag of the volume change in the last deal exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeInc(const long value)                       { this.m_control_volume_inc=::fabs(value);                  }
   void              SetControlVolumeDec(const long value)                       { this.m_control_volume_dec=::fabs(value);                  }
   long              GetValueChangedVolume(void)                           const { return this.m_changed_volume_value;                       }
   bool              IsIncreaseVolume(void)                                const { return this.m_is_change_volume_inc;                       }
   bool              IsDecreaseVolume(void)                                const { return this.m_is_change_volume_dec;                       }
   //--- Maximum volume within a day
   //--- setting the maximum day volume controlled (1) growth, (2) decrease value
   //--- getting (3) the maximum volume change value within a day,
   //--- getting the flag of the maximum day volume change exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeHighInc(const long value)                   { this.m_control_volume_high_day_inc=::fabs(value);         }
   void              SetControlVolumeHighDec(const long value)                   { this.m_control_volume_high_day_dec=::fabs(value);         }
   long              GetValueChangedVolumeHigh(void)                       const { return this.m_changed_volume_high_day_value;              }
   bool              IsIncreaseVolumeHigh(void)                            const { return this.m_is_change_volume_high_day_inc;              }
   bool              IsDecreaseVolumeHigh(void)                            const { return this.m_is_change_volume_high_day_dec;              }
   //--- Minimum volume within a day
   //--- setting the minimum day volume controlled (1) growth, (2) decrease value
   //--- getting (3) the minimum volume change value within a day,
   //--- getting the flag of the minimum day volume change exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeLowInc(const long value)                    { this.m_control_volume_low_day_inc=::fabs(value);          }
   void              SetControlVolumeLowDec(const long value)                    { this.m_control_volume_low_day_dec=::fabs(value);          }
   long              GetValueChangedVolumeLow(void)                        const { return this.m_changed_volume_low_day_value;               }
   bool              IsIncreaseVolumeLow(void)                             const { return this.m_is_change_volume_low_day_inc;               }
   bool              IsDecreaseVolumeLow(void)                             const { return this.m_is_change_volume_low_day_dec;               }
   //--- Spread
   //--- setting the controlled spread decrease (1) growth, (2) decrease value in points
   //--- getting (3) spread change value in points,
   //--- getting the flag of the spread change in points exceeding the (4) growth, (5) decrease value
   void              SetControlSpreadInc(const int value)                        { this.m_control_spread_inc=::fabs(value);                  }
   void              SetControlSpreadDec(const int value)                        { this.m_control_spread_dec=::fabs(value);                  }
   int               GetValueChangedSpread(void)                           const { return this.m_changed_spread_value;                       }
   bool              IsIncreaseSpread(void)                                const { return this.m_is_change_spread_inc;                       }
   bool              IsDecreaseSpread(void)                                const { return this.m_is_change_spread_dec;                       }
   //--- StopLevel
   //--- setting the controlled StopLevel decrease (1) growth, (2) decrease value in points
   //--- getting (3) StopLevel change value in points,
   //--- getting the flag of StopLevel change in points exceeding the (4) growth, (5) decrease value
   void              SetControlStopLevelInc(const int value)                     { this.m_control_stops_level_inc=::fabs(value);             }
   void              SetControlStopLevelDec(const int value)                     { this.m_control_stops_level_dec=::fabs(value);             }
   int               GetValueChangedStopLevel(void)                        const { return this.m_changed_stops_level_value;                  }
   bool              IsIncreaseStopLevel(void)                             const { return this.m_is_change_stops_level_inc;                  }
   bool              IsDecreaseStopLevel(void)                             const { return this.m_is_change_stops_level_dec;                  }
   //--- Freeze distance
   //--- setting the controlled FreezeLevel decrease (1) growth, (2) decrease value in points
   //--- getting (3) FreezeLevel change value in points,
   //--- getting the flag of FreezeLevel change in points exceeding the (4) growth, (5) decrease value
   void              SetControlFreezeLevelInc(const int value)                   { this.m_control_freeze_level_inc=::fabs(value);            }
   void              SetControlFreezeLevelDec(const int value)                   { this.m_control_freeze_level_dec=::fabs(value);            }
   int               GetValueChangedFreezeLevel(void)                      const { return this.m_changed_freeze_level_value;                 }
   bool              IsIncreaseFreezeLevel(void)                           const { return this.m_is_change_freeze_level_inc;                 }
   bool              IsDecreaseFreezeLevel(void)                           const { return this.m_is_change_freeze_level_dec;                 }
   
   //--- Bid/Last
   //--- setting the Bid or Last price controlled (1) growth, (2) decrease value
   //--- getting (3) Bid or Last price change value,
   //--- getting the flag of the Bid or Last price change exceeding the (4) growth, (5) decrease value
   void              SetControlBidLastInc(const double value)                    { this.m_control_bid_last_inc=::fabs(value);                }
   void              SetControlBidLastDec(const double value)                    { this.m_control_bid_last_dec=::fabs(value);                }
   double            GetValueChangedBidLast(void)                          const { return this.m_changed_bid_last_value;                     }
   bool              IsIncreaseBidLast(void)                               const { return this.m_is_change_bid_last_inc;                     }
   bool              IsDecreaseBidLast(void)                               const { return this.m_is_change_bid_last_dec;                     }
   //--- Maximum Bid/Last of the day
   //--- setting the maximum Bid or Last price controlled (1) growth, (2) decrease value
   //--- getting the (3) maximum Bid or Last price change value,
   //--- getting the flag of the maximum Bid or Last price change exceeding the (4) growth, (5) decrease value
   void              SetControlBidLastHighInc(const double value)                { this.m_control_bid_last_high_inc=::fabs(value);           }
   void              SetControlBidLastHighDec(const double value)                { this.m_control_bid_last_high_dec=::fabs(value);           }
   double            GetValueChangedBidLastHigh(void)                      const { return this.m_changed_bid_last_high_value;                }
   bool              IsIncreaseBidLastHigh(void)                           const { return this.m_is_change_bid_last_high_inc;                }
   bool              IsDecreaseBidLastHigh(void)                           const { return this.m_is_change_bid_last_high_dec;                }
   //--- Minimum Bid/Last of the day
   //--- setting the minimum Bid or Last price controlled (1) growth, (2) decrease value
   //--- getting the (3) minimum Bid or Last price change value,
   //--- getting the flag of the minimum Bid or Last price change exceeding the (4) growth, (5) decrease value
   void              SetControlBidLastLowInc(const double value)                 { this.m_control_bid_last_low_inc=::fabs(value);            }
   void              SetControlBidLastLowDec(const double value)                 { this.m_control_bid_last_low_dec=::fabs(value);            }
   double            GetValueChangedBidLastLow(void)                       const { return this.m_changed_bid_last_low_value;                 }
   bool              IsIncreaseBidLastLow(void)                            const { return this.m_is_change_bid_last_low_inc;                 }
   bool              IsDecreaseBidLastLow(void)                            const { return this.m_is_change_bid_last_low_dec;                 }
   //--- Ask
   //--- setting the Ask price controlled (1) growth, (2) decrease value
   //--- getting (3) Ask price change value,
   //--- getting the flag of the Ask price change exceeding the (4) growth, (5) decrease value
   void              SetControlAskInc(const double value)                        { this.m_control_ask_inc=::fabs(value);                     }
   void              SetControlAskDec(const double value)                        { this.m_control_ask_dec=::fabs(value);                     }
   double            GetValueChangedAsk(void)                              const { return this.m_changed_ask_value;                          }
   bool              IsIncreaseAsk(void)                                   const { return this.m_is_change_ask_inc;                          }
   bool              IsDecreaseAsk(void)                                   const { return this.m_is_change_ask_dec;                          }
   //--- Maximum Ask price for the day
   //--- setting the maximum day Ask controlled (1) growth, (2) decrease value
   //--- getting (3) the maximum Ask change value within a day,
   //--- getting the flag of the maximum day Ask change exceeding the (4) growth, (5) decrease value
   void              SetControlAskHighInc(const double value)                    { this.m_control_ask_high_inc=::fabs(value);                }
   void              SetControlAskHighDec(const double value)                    { this.m_control_ask_high_dec=::fabs(value);                }
   double            GetValueChangedAskHigh(void)                          const { return this.m_changed_ask_high_value;                     }
   bool              IsIncreaseAskHigh(void)                               const { return this.m_is_change_ask_high_inc;                     }
   bool              IsDecreaseAskHigh(void)                               const { return this.m_is_change_ask_high_dec;                     }
   //--- Minimum Ask price for the day
   //--- setting the minimum day Ask controlled (1) growth, (2) decrease value
   //--- getting (3) the minimum Ask change value within a day,
   //--- getting the flag of the minimum day Ask change exceeding the (4) growth, (5) decrease value
   void              SetControlAskLowInc(const double value)                     { this.m_control_ask_low_inc=::fabs(value);                 }
   void              SetControlAskLowDec(const double value)                     { this.m_control_ask_low_dec=::fabs(value);                 }
   double            GetValueChangedAskLow(void)                           const { return this.m_changed_ask_low_value;                      }
   bool              IsIncreaseAskLow(void)                                const { return this.m_is_change_ask_low_inc;                      }
   bool              IsDecreaseAskLow(void)                                const { return this.m_is_change_ask_low_dec;                      }
   //--- Real Volume for the day
   //--- setting the real day volume controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the real day volume,
   //--- getting the flag of the real day volume change exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeRealInc(const double value)                 { this.m_control_volume_real_inc=::fabs(value);             }
   void              SetControlVolumeRealDec(const double value)                 { this.m_control_volume_real_dec=::fabs(value);             }
   double            GetValueChangedVolumeReal(void)                       const { return this.m_changed_volume_real_value;                  }
   bool              IsIncreaseVolumeReal(void)                            const { return this.m_is_change_volume_real_inc;                  }
   bool              IsDecreaseVolumeReal(void)                            const { return this.m_is_change_volume_real_dec;                  }
   //--- Maximum real volume for the day
   //--- setting the maximum real day volume controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the maximum real day volume,
   //--- getting the flag of the maximum real day volume change exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeHighRealInc(const double value)             { this.m_control_volume_high_real_day_inc=::fabs(value);    }
   void              SetControlVolumeHighRealDec(const double value)             { this.m_control_volume_high_real_day_dec=::fabs(value);    }
   double            GetValueChangedVolumeHighReal(void)                   const { return this.m_changed_volume_high_real_day_value;         }
   bool              IsIncreaseVolumeHighReal(void)                        const { return this.m_is_change_volume_high_real_day_inc;         }
   bool              IsDecreaseVolumeHighReal(void)                        const { return this.m_is_change_volume_high_real_day_dec;         }
   //--- Minimum real volume for the day
   //--- setting the minimum real day volume controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the minimum real day volume,
   //--- getting the flag of the minimum real day volume change exceeding the (4) growth, (5) decrease value
   void              SetControlVolumeLowRealInc(const double value)              { this.m_control_volume_low_real_day_inc=::fabs(value);     }
   void              SetControlVolumeLowRealDec(const double value)              { this.m_control_volume_low_real_day_dec=::fabs(value);     }
   double            GetValueChangedVolumeLowReal(void)                    const { return this.m_changed_volume_low_real_day_value;          }
   bool              IsIncreaseVolumeLowReal(void)                         const { return this.m_is_change_volume_low_real_day_inc;          }
   bool              IsDecreaseVolumeLowReal(void)                         const { return this.m_is_change_volume_low_real_day_dec;          }
   //--- Strike price
   //--- setting the strike price controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the strike price,
   //--- getting the flag of the strike price change exceeding the (4) growth, (5) decrease value
   void              SetControlOptionStrikeInc(const double value)               { this.m_control_option_strike_inc=::fabs(value);           }
   void              SetControlOptionStrikeDec(const double value)               { this.m_control_option_strike_dec=::fabs(value);           }
   double            GetValueChangedOptionStrike(void)                     const { return this.m_changed_option_strike_value;                } 
   bool              IsIncreaseOptionStrike(void)                          const { return this.m_is_change_option_strike_inc;                }
   bool              IsDecreaseOptionStrike(void)                          const { return this.m_is_change_option_strike_dec;                }
   //--- Maximum allowed total volume of unidirectional positions and orders
   //--- (1) getting the change value of the maximum allowed total volume of unidirectional positions and orders,
   //--- getting the flag of (2) increasing, (3) decreasing the maximum allowed total volume of unidirectional positions and orders
   double            GetValueChangedVolumeLimit(void)                      const { return this.m_changed_volume_limit_value;                 }
   bool              IsIncreaseVolumeLimit(void)                           const { return this.m_is_change_volume_limit_inc;                 }
   bool              IsDecreaseVolumeLimit(void)                           const { return this.m_is_change_volume_limit_dec;                 }
   //---  Swap long
   //--- (1) getting the swap long change value,
   //--- getting the flag of (2) increasing, (3) decreasing the swap long
   double            GetValueChangedSwapLong(void)                         const { return this.m_changed_swap_long_value;                    }
   bool              IsIncreaseSwapLong(void)                              const { return this.m_is_change_swap_long_inc;                    }
   bool              IsDecreaseSwapLong(void)                              const { return this.m_is_change_swap_long_dec;                    }
   //---  Swap short

   //--- (1) getting the swap short change value,
   //--- getting the flag of (2) increasing, (3) decreasing the swap short
   double            GetValueChangedSwapShort(void)                        const { return this.m_changed_swap_short_value;                   }
   bool              IsIncreaseSwapShort(void)                             const { return this.m_is_change_swap_short_inc;                   }
   bool              IsDecreaseSwapShort(void)                             const { return this.m_is_change_swap_short_dec;                   }
   //--- The total volume of deals in the current session
   //--- setting the controlled value of (1) growth, (2) decrease in the total volume of deals during the current session
   //--- getting (3) the total deal volume change value in the current session,
   //--- getting the flag of the total deal volume change during the current session exceeding the (4) growth, (5) decrease value
   void              SetControlSessionVolumeInc(const double value)              { this.m_control_session_volume_inc=::fabs(value);          }
   void              SetControlSessionVolumeDec(const double value)              { this.m_control_session_volume_dec=::fabs(value);          }
   double            GetValueChangedSessionVolume(void)                    const { return this.m_changed_session_volume_value;               }
   bool              IsIncreaseSessionVolume(void)                         const { return this.m_is_change_session_volume_inc;               }
   bool              IsDecreaseSessionVolume(void)                         const { return this.m_is_change_session_volume_dec;               }
   //--- The total turnover in the current session
   //--- setting the controlled value of the turnover (1) growth, (2) decrease during the current session
   //--- getting (3) the total turnover change value in the current session,
   //--- getting the flag of the total turnover change during the current session exceeding the (4) growth, (5) decrease value
   void              SetControlSessionTurnoverInc(const double value)            { this.m_control_session_turnover_inc=::fabs(value);        }
   void              SetControlSessionTurnoverDec(const double value)            { this.m_control_session_turnover_dec=::fabs(value);        }
   double            GetValueChangedSessionTurnover(void)                  const { return this.m_changed_session_turnover_value;             }
   bool              IsIncreaseSessionTurnover(void)                       const { return this.m_is_change_session_turnover_inc;             }
   bool              IsDecreaseSessionTurnover(void)                       const { return this.m_is_change_session_turnover_dec;             }
   //--- The total volume of open positions
   //--- setting the controlled value of (1) growth, (2) decrease in the total volume of open positions during the current session
   //--- getting (3) the change value of the open positions total volume in the current session,
   //--- getting the flag of the open positions total volume change during the current session exceeding the (4) growth, (5) decrease value
   void              SetControlSessionInterestInc(const double value)            { this.m_control_session_interest_inc=::fabs(value);        }
   void              SetControlSessionInterestDec(const double value)            { this.m_control_session_interest_dec=::fabs(value);        }
   double            GetValueChangedSessionInterest(void)                  const { return this.m_changed_session_interest_value;             }
   bool              IsIncreaseSessionInterest(void)                       const { return this.m_is_change_session_interest_inc;             }
   bool              IsDecreaseSessionInterest(void)                       const { return this.m_is_change_session_interest_dec;             }
   //--- The total volume of Buy orders at the moment
   //--- setting the controlled value of (1) growth, (2) decrease in the current total buy order volume
   //--- getting (3) the change value of the current total buy order volume,
   //--- getting the flag of the current total buy orders' volume change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionBuyOrdVolumeInc(const double value)        { this.m_control_session_buy_ord_volume_inc=::fabs(value);  }
   void              SetControlSessionBuyOrdVolumeDec(const double value)        { this.m_control_session_buy_ord_volume_dec=::fabs(value);  }
   double            GetValueChangedSessionBuyOrdVolume(void)              const { return this.m_changed_session_buy_ord_volume_value;       }
   bool              IsIncreaseSessionBuyOrdVolume(void)                   const { return this.m_is_change_session_buy_ord_volume_inc;       }
   bool              IsDecreaseSessionBuyOrdVolume(void)                   const { return this.m_is_change_session_buy_ord_volume_dec;       }
   //--- The total volume of Sell orders at the moment
   //--- setting the controlled value of (1) growth, (2) decrease in the current total sell order volume
   //--- getting (3) the change value of the current total sell order volume,
   //--- getting the flag of the current total sell orders' volume change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionSellOrdVolumeInc(const double value)       { this.m_control_session_sell_ord_volume_inc=::fabs(value); }
   void              SetControlSessionSellOrdVolumeDec(const double value)       { this.m_control_session_sell_ord_volume_dec=::fabs(value); }
   double            GetValueChangedSessionSellOrdVolume(void)             const { return this.m_changed_session_sell_ord_volume_value;      }
   bool              IsIncreaseSessionSellOrdVolume(void)                  const { return this.m_is_change_session_sell_ord_volume_inc;      }
   bool              IsDecreaseSessionSellOrdVolume(void)                  const { return this.m_is_change_session_sell_ord_volume_dec;      }
   //--- Session open price
   //--- setting the session open price controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the session open price,
   //--- getting the flag of the session open price change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionPriceOpenInc(const double value)           { this.m_control_session_open_inc=::fabs(value);            }
   void              SetControlSessionPriceOpenDec(const double value)           { this.m_control_session_open_dec=::fabs(value);            }
   double            GetValueChangedSessionPriceOpen(void)                 const { return this.m_changed_session_open_value;                 }
   bool              IsIncreaseSessionPriceOpen(void)                      const { return this.m_is_change_session_open_inc;                 }
   bool              IsDecreaseSessionPriceOpen(void)                      const { return this.m_is_change_session_open_dec;                 }
   //--- Session close price
   //--- setting the session close price controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the session close price,
   //--- getting the flag of the session close price change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionPriceCloseInc(const double value)          { this.m_control_session_close_inc=::fabs(value);           }
   void              SetControlSessionPriceCloseDec(const double value)          { this.m_control_session_close_dec=::fabs(value);           }
   double            GetValueChangedSessionPriceClose(void)                const { return this.m_changed_session_close_value;                }
   bool              IsIncreaseSessionPriceClose(void)                     const { return this.m_is_change_session_close_inc;                }
   bool              IsDecreaseSessionPriceClose(void)                     const { return this.m_is_change_session_close_dec;                }
   //--- The average weighted session price
   //--- setting the average weighted session price controlled (1) growth, (2) decrease value
   //--- getting (3) the change value of the average weighted session price,
   //--- getting the flag of the average weighted session price change exceeding the (4) growth, (5) decrease value
   void              SetControlSessionPriceAWInc(const double value)             { this.m_control_session_aw_inc=::fabs(value);              }
   void              SetControlSessionPriceAWDec(const double value)             { this.m_control_session_aw_dec=::fabs(value);              }
   double            GetValueChangedSessionPriceAW(void)                   const { return this.m_changed_session_aw_value;                   }
   bool              IsIncreaseSessionPriceAW(void)                        const { return this.m_is_change_session_aw_inc;                   }
   bool              IsDecreaseSessionPriceAW(void)                        const { return this.m_is_change_session_aw_dec;                   }
//---
  };
//+------------------------------------------------------------------+
//| Class methods                                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Closed parametric constructor                                    |
//+------------------------------------------------------------------+
CSymbol::CSymbol(ENUM_SYMBOL_STATUS symbol_status,const string name,const int index)
  {
   this.m_name=name;
   if(!this.Exist())
     {
      ::Print(DFUN_ERR_LINE,"\"",this.m_name,"\"",": ",TextByLanguage("Ошибка. Такого символа нет на сервере","Error. There is no such symbol on the server"));
      this.m_global_error=ERR_MARKET_UNKNOWN_SYMBOL;
     }
   bool select=::SymbolInfoInteger(this.m_name,SYMBOL_SELECT);
   ::ResetLastError();
   if(!select)
     {
      if(!this.SetToMarketWatch())
        {
         this.m_global_error=::GetLastError();
         ::Print(DFUN_ERR_LINE,"\"",this.m_name,"\": ",TextByLanguage("Не удалось поместить в обзор рынка. Ошибка: ","Failed to put in the market watch. Error: "),this.m_global_error);
        }
     }
   ::ResetLastError();
   if(!::SymbolInfoTick(this.m_name,this.m_tick))
     {
      this.m_global_error=::GetLastError();
      ::Print(DFUN_ERR_LINE,"\"",this.m_name,"\": ",TextByLanguage("Не удалось получить текущие цены. Ошибка: ","Could not get current prices. Error: "),this.m_global_error);
     }
//--- Initialize data
   this.Reset();
   this.InitMarginRates();
   ::ZeroMemory(this.m_struct_prev_symbol);
   this.m_struct_prev_symbol.trade_mode=WRONG_VALUE;
   this.InitChangesParams();
   this.InitControlsParams();
#ifdef __MQL5__
   ::ResetLastError();
   if(!this.MarginRates())
     {
      this.m_global_error=::GetLastError();
      ::Print(DFUN_ERR_LINE,this.Name(),": ",TextByLanguage("Не удалось получить коэффициенты взимания маржи. Ошибка: ","Failed to get margin rates. Error: "),this.m_global_error);
      return;
     }
#endif 
   
//--- Save integer properties
   this.m_long_prop[SYMBOL_PROP_STATUS]                                             = symbol_status;
   this.m_long_prop[SYMBOL_PROP_INDEX_MW]                                           = index;
   this.m_long_prop[SYMBOL_PROP_VOLUME]                                             = (long)this.m_tick.volume;
   this.m_long_prop[SYMBOL_PROP_SELECT]                                             = ::SymbolInfoInteger(this.m_name,SYMBOL_SELECT);
   this.m_long_prop[SYMBOL_PROP_VISIBLE]                                            = ::SymbolInfoInteger(this.m_name,SYMBOL_VISIBLE);
   this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                      = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_DEALS);
   this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                                 = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_BUY_ORDERS);
   this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                                = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_SELL_ORDERS);
   this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                         = ::SymbolInfoInteger(this.m_name,SYMBOL_VOLUMEHIGH);
   this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                          = ::SymbolInfoInteger(this.m_name,SYMBOL_VOLUMELOW);
   this.m_long_prop[SYMBOL_PROP_DIGITS]                                             = ::SymbolInfoInteger(this.m_name,SYMBOL_DIGITS);
   this.m_long_prop[SYMBOL_PROP_SPREAD]                                             = ::SymbolInfoInteger(this.m_name,SYMBOL_SPREAD);
   this.m_long_prop[SYMBOL_PROP_SPREAD_FLOAT]                                       = ::SymbolInfoInteger(this.m_name,SYMBOL_SPREAD_FLOAT);
   this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                                    = ::SymbolInfoInteger(this.m_name,SYMBOL_TICKS_BOOKDEPTH);
   this.m_long_prop[SYMBOL_PROP_TRADE_MODE]                                         = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_MODE);
   this.m_long_prop[SYMBOL_PROP_START_TIME]                                         = ::SymbolInfoInteger(this.m_name,SYMBOL_START_TIME);
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                                    = ::SymbolInfoInteger(this.m_name,SYMBOL_EXPIRATION_TIME);
   this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                                  = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_STOPS_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                                 = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_FREEZE_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_EXEMODE]                                      = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_EXEMODE);
   this.m_long_prop[SYMBOL_PROP_SWAP_ROLLOVER3DAYS]                                 = ::SymbolInfoInteger(this.m_name,SYMBOL_SWAP_ROLLOVER3DAYS);
   this.m_long_prop[SYMBOL_PROP_TIME]                                               = this.TickTime();
   this.m_long_prop[SYMBOL_PROP_EXIST]                                              = this.SymbolExists();
   this.m_long_prop[SYMBOL_PROP_CUSTOM]                                             = this.SymbolCustom();
   this.m_long_prop[SYMBOL_PROP_MARGIN_HEDGED_USE_LEG]                              = this.SymbolMarginHedgedUseLEG();
   this.m_long_prop[SYMBOL_PROP_ORDER_MODE]                                         = this.SymbolOrderMode();
   this.m_long_prop[SYMBOL_PROP_FILLING_MODE]                                       = this.SymbolOrderFillingMode();
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_MODE]                                    = this.SymbolExpirationMode();
   this.m_long_prop[SYMBOL_PROP_ORDER_GTC_MODE]                                     = this.SymbolOrderGTCMode();
   this.m_long_prop[SYMBOL_PROP_OPTION_MODE]                                        = this.SymbolOptionMode();
   this.m_long_prop[SYMBOL_PROP_OPTION_RIGHT]                                       = this.SymbolOptionRight();
   this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                                   = this.SymbolBackgroundColor();
   this.m_long_prop[SYMBOL_PROP_CHART_MODE]                                         = this.SymbolChartMode();
   this.m_long_prop[SYMBOL_PROP_TRADE_CALC_MODE]                                    = this.SymbolCalcMode();
   this.m_long_prop[SYMBOL_PROP_SWAP_MODE]                                          = this.SymbolSwapMode();
//--- Save real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                          = ::SymbolInfoDouble(this.m_name,SYMBOL_ASKHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                           = ::SymbolInfoDouble(this.m_name,SYMBOL_ASKLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                         = ::SymbolInfoDouble(this.m_name,SYMBOL_LASTHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                          = ::SymbolInfoDouble(this.m_name,SYMBOL_LASTLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_POINT)]                            = ::SymbolInfoDouble(this.m_name,SYMBOL_POINT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE_PROFIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]            = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE_LOSS);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]                  = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]              = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_CONTRACT_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                      = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_STEP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]                     = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                        = ::SymbolInfoDouble(this.m_name,SYMBOL_SWAP_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_SWAP_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]                   = ::SymbolInfoDouble(this.m_name,SYMBOL_MARGIN_INITIAL);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]               = ::SymbolInfoDouble(this.m_name,SYMBOL_MARGIN_MAINTENANCE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]                   = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_TURNOVER);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_INTEREST);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]        = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_BUY_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)]       = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_SELL_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]                     = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_OPEN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]                    = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_CLOSE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_AW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]         = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_SETTLEMENT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_LIMIT_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_LIMIT_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                              = this.m_tick.bid;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                              = this.m_tick.ask;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                             = this.m_tick.last;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                          = this.SymbolBidHigh();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                           = this.SymbolBidLow();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                      = this.SymbolVolumeReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]                  = this.SymbolVolumeHighReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]                   = this.SymbolVolumeLowReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]                    = this.SymbolOptionStrike();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]           = this.SymbolTradeAccruedInterest();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]                 = this.SymbolTradeFaceValue();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]             = this.SymbolTradeLiquidityRate();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]                    = this.SymbolMarginHedged();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_INITIAL)]              = this.m_margin_rate.Long.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL)]          = this.m_margin_rate.BuyStop.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL)]         = this.m_margin_rate.BuyLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL)]     = this.m_margin_rate.BuyStopLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE)]          = this.m_margin_rate.Long.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE)]      = this.m_margin_rate.BuyStop.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE)]     = this.m_margin_rate.BuyLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE)] = this.m_margin_rate.BuyStopLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_INITIAL)]             = this.m_margin_rate.Short.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL)]         = this.m_margin_rate.SellStop.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL)]        = this.m_margin_rate.SellLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL)]    = this.m_margin_rate.SellStopLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE)]         = this.m_margin_rate.Short.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE)]     = this.m_margin_rate.SellStop.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE)]    = this.m_margin_rate.SellLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE)]= this.m_margin_rate.SellStopLimit.Maintenance;
//--- Save string properties
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_NAME)]                             = this.m_name;
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_BASE)]                    = ::SymbolInfoString(this.m_name,SYMBOL_CURRENCY_BASE);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_PROFIT)]                  = ::SymbolInfoString(this.m_name,SYMBOL_CURRENCY_PROFIT);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_MARGIN)]                  = ::SymbolInfoString(this.m_name,SYMBOL_CURRENCY_MARGIN);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_DESCRIPTION)]                      = ::SymbolInfoString(this.m_name,SYMBOL_DESCRIPTION);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_PATH)]                             = ::SymbolInfoString(this.m_name,SYMBOL_PATH);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_BASIS)]                            = this.SymbolBasis();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_BANK)]                             = this.SymbolBank();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_ISIN)]                             = this.SymbolISIN();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_FORMULA)]                          = this.SymbolFormula();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_PAGE)]                             = this.SymbolPage();
//--- Save additional integer properties
   this.m_long_prop[SYMBOL_PROP_DIGITS_LOTS]                                        = this.SymbolDigitsLot();
//---
   if(!select)
      this.RemoveFromMarketWatch();
  }
//+------------------------------------------------------------------------------------------------------------+
//|Compare CSymbol objects by all possible properties (for sorting lists by a specified symbol object property)|
//+------------------------------------------------------------------------------------------------------------+
int CSymbol::Compare(const CObject *node,const int mode=0) const
  {
   const CSymbol *symbol_compared=node;
//--- compare integer properties of two symbols
   if(mode<SYMBOL_PROP_INTEGER_TOTAL)
     {
      long value_compared=symbol_compared.GetProperty((ENUM_SYMBOL_PROP_INTEGER)mode);
      long value_current=this.GetProperty((ENUM_SYMBOL_PROP_INTEGER)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
//--- compare real properties of two symbols
   else if(mode<SYMBOL_PROP_INTEGER_TOTAL+SYMBOL_PROP_DOUBLE_TOTAL)
     {
      double value_compared=symbol_compared.GetProperty((ENUM_SYMBOL_PROP_DOUBLE)mode);
      double value_current=this.GetProperty((ENUM_SYMBOL_PROP_DOUBLE)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
//--- compare string properties of two symbols
   else if(mode<SYMBOL_PROP_INTEGER_TOTAL+SYMBOL_PROP_DOUBLE_TOTAL+SYMBOL_PROP_STRING_TOTAL)
     {
      string value_compared=symbol_compared.GetProperty((ENUM_SYMBOL_PROP_STRING)mode);
      string value_current=this.GetProperty((ENUM_SYMBOL_PROP_STRING)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| Compare CSymbol objects by all properties                        |
//+------------------------------------------------------------------+
bool CSymbol::IsEqual(CSymbol *compared_symbol) const
  {
   int beg=0, end=SYMBOL_PROP_INTEGER_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_INTEGER prop=(ENUM_SYMBOL_PROP_INTEGER)i;
      if(this.GetProperty(prop)!=compared_symbol.GetProperty(prop)) return false; 
     }
   beg=end; end+=SYMBOL_PROP_DOUBLE_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_DOUBLE prop=(ENUM_SYMBOL_PROP_DOUBLE)i;
      if(this.GetProperty(prop)!=compared_symbol.GetProperty(prop)) return false; 
     }
   beg=end; end+=SYMBOL_PROP_STRING_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_STRING prop=(ENUM_SYMBOL_PROP_STRING)i;
      if(this.GetProperty(prop)!=compared_symbol.GetProperty(prop)) return false; 
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratio variables                               |
//+------------------------------------------------------------------+
bool CSymbol::MarginRates(void)
  {
   bool res=true;
   #ifdef __MQL5__
      res &=this.SymbolMarginLong();
      res &=this.SymbolMarginBuyStop();
      res &=this.SymbolMarginBuyLimit();
      res &=this.SymbolMarginBuyStopLimit();
      res &=this.SymbolMarginShort();
      res &=this.SymbolMarginSellStop();
      res &=this.SymbolMarginSellLimit();
      res &=this.SymbolMarginSellStopLimit();
   #else 
      this.InitMarginRates();
      res=false;
   #endif 
   return res;
  }
//+------------------------------------------------------------------+
//| Initialize margin ratios                                         |
//+------------------------------------------------------------------+
void CSymbol::InitMarginRates(void)
  {
   this.m_margin_rate.Long.Initial=0;           this.m_margin_rate.Long.Maintenance=0;
   this.m_margin_rate.BuyStop.Initial=0;        this.m_margin_rate.BuyStop.Maintenance=0;
   this.m_margin_rate.BuyLimit.Initial=0;       this.m_margin_rate.BuyLimit.Maintenance=0;
   this.m_margin_rate.BuyStopLimit.Initial=0;   this.m_margin_rate.BuyStopLimit.Maintenance=0;
   this.m_margin_rate.Short.Initial=0;          this.m_margin_rate.Short.Maintenance=0;
   this.m_margin_rate.SellStop.Initial=0;       this.m_margin_rate.SellStop.Maintenance=0;
   this.m_margin_rate.SellLimit.Initial=0;      this.m_margin_rate.SellLimit.Maintenance=0;
   this.m_margin_rate.SellStopLimit.Initial=0;  this.m_margin_rate.SellStopLimit.Maintenance=0;
  }
//+------------------------------------------------------------------+
//| Reset all symbol object data                                     |
//+------------------------------------------------------------------+
void CSymbol::Reset(void)
  {
   int beg=0, end=SYMBOL_PROP_INTEGER_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_INTEGER prop=(ENUM_SYMBOL_PROP_INTEGER)i;
      this.SetProperty(prop,0);
     }
   beg=end; end+=SYMBOL_PROP_DOUBLE_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_DOUBLE prop=(ENUM_SYMBOL_PROP_DOUBLE)i;
      this.SetProperty(prop,0);
     }
   beg=end; end+=SYMBOL_PROP_STRING_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_STRING prop=(ENUM_SYMBOL_PROP_STRING)i;
      this.SetProperty(prop,NULL);
     }
  }
//+------------------------------------------------------------------+
//| Integer properties                                               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return the symbol existence flag                                 |
//+------------------------------------------------------------------+
long CSymbol::SymbolExists(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_EXIST) #else this.Exist() #endif);
  }
//+------------------------------------------------------------------+
bool CSymbol::SymbolExists(const string name) const
  {
   return(#ifdef __MQL5__ (bool)::SymbolInfoInteger(name,SYMBOL_EXIST) #else Exist(name) #endif);
  }
//+------------------------------------------------------------------+
//| Return the custom symbol flag                                    |
//+------------------------------------------------------------------+
long CSymbol::SymbolCustom(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_CUSTOM) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Return the price type for building bars - Bid or Last            |
//+------------------------------------------------------------------+
long CSymbol::SymbolChartMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_CHART_MODE) #else SYMBOL_CHART_MODE_BID #endif);
  }
//+--------------------------------------------------------------------+
//|Return the calculation mode of a hedging margin using the larger leg|
//+--------------------------------------------------------------------+
long CSymbol::SymbolMarginHedgedUseLEG(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_MARGIN_HEDGED_USE_LEG) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Return the order filling policies flags                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderFillingMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_FILLING_MODE) #else 0 #endif );
  }
//+------------------------------------------------------------------+
//| Return the flag allowing the closure by an opposite position     |
//+------------------------------------------------------------------+
bool CSymbol::IsCloseByOrdersAllowed(void) const
  {
   return(#ifdef __MQL5__(this.OrderModeFlags() & SYMBOL_ORDER_CLOSEBY)==SYMBOL_ORDER_CLOSEBY #else (bool)::MarketInfo(this.m_name,MODE_CLOSEBY_ALLOWED)  #endif );
  }  
//| Return the option type                                           |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_OPTION_MODE) #else SYMBOL_OPTION_MODE_NONE #endif);
  }
//+------------------------------------------------------------------+
//| Return the option right                                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionRight(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_OPTION_RIGHT) #else SYMBOL_OPTION_RIGHT_NONE #endif);
  }
//+----------------------------------------------------------------------+
//|Return the background color used to highlight a symbol in Market Watch|
//+----------------------------------------------------------------------+
long CSymbol::SymbolBackgroundColor(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_BACKGROUND_COLOR) #else clrNONE #endif);
  }
//+------------------------------------------------------------------+
//| Return the margin calculation method                             |
//+------------------------------------------------------------------+
long CSymbol::SymbolCalcMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_CALC_MODE) #else (long)::MarketInfo(this.m_name,MODE_MARGINCALCMODE) #endif);
  }
//+------------------------------------------------------------------+
//| Return the swaps calculation method                              |
//+------------------------------------------------------------------+
long CSymbol::SymbolSwapMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_SWAP_MODE) #else (long)::MarketInfo(this.m_name,MODE_SWAPTYPE) #endif);
  }
//+------------------------------------------------------------------+
//| Return the flags of allowed order expiration modes               |
//+------------------------------------------------------------------+
long CSymbol::SymbolExpirationMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_name,SYMBOL_EXPIRATION_MODE) #else (long)SYMBOL_EXPIRATION_GTC #endif);
  }
//+------------------------------------------------------------------+
//| Return the lifetime of pending orders and                        |
//| placed StopLoss/TakeProfit levels                                |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderGTCMode(void) const
  {
   return
     (
     #ifdef __MQL5__ 
      this.IsExpirationModeGTC() ? ::SymbolInfoInteger(this.m_name,SYMBOL_ORDER_GTC_MODE) : WRONG_VALUE
     #else 
      SYMBOL_ORDERS_GTC 
     #endif
     );
  }
//+------------------------------------------------------------------+
//| Return the flags of allowed order types                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderMode(void) const
  {
   return
     (
      #ifdef __MQL5__
         ::SymbolInfoInteger(this.m_name,SYMBOL_ORDER_MODE)
      #else 
         (SYMBOL_ORDER_MARKET+SYMBOL_ORDER_LIMIT+SYMBOL_ORDER_STOP+SYMBOL_ORDER_SL+SYMBOL_ORDER_TP+(this.IsCloseByOrdersAllowed() ? SYMBOL_ORDER_CLOSEBY : 0))
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Calculate and return the number of decimal places                |
//| in a symbol lot                                                  |
//+------------------------------------------------------------------+
long CSymbol::SymbolDigitsLot(void)
  {
   if(this.LotsMax()==0 || this.LotsMin()==0 || this.LotsStep()==0)
     {
      ::Print(DFUN_ERR_LINE,TextByLanguage("Не удалось получить данные \"","Failed to get data of \""),this.Name(),"\"");
      this.m_global_error=ERR_MARKET_UNKNOWN_SYMBOL;
      return 2;
     }
   return long(fmax(this.GetDigits(this.LotsMin()),this.GetDigits(this.LotsStep())));
  }
//+------------------------------------------------------------------+
//| Return the number of decimal places                              |
//| depending on the swap calculation method                         |
//+------------------------------------------------------------------+
int CSymbol::SymbolDigitsBySwap(void)
  {
   return
     (
      this.SwapMode()==SYMBOL_SWAP_MODE_POINTS           || 
      this.SwapMode()==SYMBOL_SWAP_MODE_REOPEN_CURRENT   || 
      this.SwapMode()==SYMBOL_SWAP_MODE_REOPEN_BID       ?  this.Digits() :
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_SYMBOL  || 
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_MARGIN  || 
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT ?  this.DigitsCurrency():
      this.SwapMode()==SYMBOL_SWAP_MODE_INTEREST_CURRENT || 
      this.SwapMode()==SYMBOL_SWAP_MODE_INTEREST_OPEN    ?  1  :  0
     );
  }  
//+------------------------------------------------------------------+
//| Real properties                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return maximum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidHigh(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_BIDHIGH) #else ::MarketInfo(this.m_name,MODE_HIGH) #endif);
  }
//+------------------------------------------------------------------+
//| Return minimum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidLow(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_BIDLOW) #else ::MarketInfo(this.m_name,MODE_LOW) #endif);
  }
//+------------------------------------------------------------------+
//| Return real Volume for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return real maximum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeHighReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUMEHIGH_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return real minimum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeLowReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUMELOW_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return an option execution price                                 |
//+------------------------------------------------------------------+
double CSymbol::SymbolOptionStrike(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_OPTION_STRIKE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return accrued interest                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeAccruedInterest(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_ACCRUED_INTEREST) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a bond face value                                         |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeFaceValue(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_FACE_VALUE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a liquidity rate                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeLiquidityRate(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_LIQUIDITY_RATE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a contract or margin size                                 |
//| for a single lot of covered positions                            |
//+------------------------------------------------------------------+
double CSymbol::SymbolMarginHedged(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_name,SYMBOL_MARGIN_HEDGED) #else ::MarketInfo(this.m_name, MODE_MARGINHEDGED) #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for long positions                     |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginLong(void) 
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_BUY,this.m_margin_rate.Long.Initial,this.m_margin_rate.Long.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for short positions                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginShort(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_SELL,this.m_margin_rate.Short.Initial,this.m_margin_rate.Short.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyStop orders                     |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyStop(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_BUY_STOP,this.m_margin_rate.BuyStop.Initial,this.m_margin_rate.BuyStop.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyLimit orders                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyLimit(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_BUY_LIMIT,this.m_margin_rate.BuyLimit.Initial,this.m_margin_rate.BuyLimit.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyStopLimit orders                |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyStopLimit(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_BUY_STOP_LIMIT,this.m_margin_rate.BuyStopLimit.Initial,this.m_margin_rate.BuyStopLimit.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellStop orders                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellStop(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_SELL_STOP,this.m_margin_rate.SellStop.Initial,this.m_margin_rate.SellStop.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellLimit orders                   |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellLimit(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_SELL_LIMIT,this.m_margin_rate.SellLimit.Initial,this.m_margin_rate.SellLimit.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellStopLimit orders               |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellStopLimit(void)
  {
   return(#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_name,ORDER_TYPE_SELL_STOP_LIMIT,this.m_margin_rate.SellStopLimit.Initial,this.m_margin_rate.SellStopLimit.Maintenance) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Return Bid or Last price                                         |
//| depending on the chart construction method                       |
//+------------------------------------------------------------------+
double CSymbol::BidLast(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetProperty(SYMBOL_PROP_BID) : this.GetProperty(SYMBOL_PROP_LAST));
  }  
//+------------------------------------------------------------------+
//| Return maximum Bid or Last price for a day                       |
//| depending on the chart construction method                       |
//+------------------------------------------------------------------+
double CSymbol::BidLastHigh(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetProperty(SYMBOL_PROP_BIDHIGH) : this.GetProperty(SYMBOL_PROP_LASTHIGH));
  }  
//+------------------------------------------------------------------+
//| Return minimum Bid or Last price for a day                       |
//| depending on the chart construction method                       |
//+------------------------------------------------------------------+
double CSymbol::BidLastLow(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetProperty(SYMBOL_PROP_BIDLOW) : this.GetProperty(SYMBOL_PROP_LASTLOW));
  }
//+------------------------------------------------------------------+
//| String properties                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  Return a base asset name for a derivative instrument            |
//+------------------------------------------------------------------+
string CSymbol::SymbolBasis(void) const
  {
   return
     (
      #ifdef __MQL5__ 
         ::SymbolInfoString(this.m_name,SYMBOL_BASIS) 
      #else 
         ": "+TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") 
      #endif
     );
  }
//+------------------------------------------------------------------+
//| Return a quote source for a symbol                               |
//+------------------------------------------------------------------+
string CSymbol::SymbolBank(void) const
  {
   return
     (
      #ifdef __MQL5__ 
         ::SymbolInfoString(this.m_name,SYMBOL_BANK) 
      #else 
         ": "+TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") 
      #endif
     );
  }
//+------------------------------------------------------------------+
//| Return a symbol name to ISIN                                     |
//+------------------------------------------------------------------+
string CSymbol::SymbolISIN(void) const
  {
   return
     (
      #ifdef __MQL5__ 
         ::SymbolInfoString(this.m_name,SYMBOL_ISIN) 
      #else 
         ": "+TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") 
      #endif
     );
  }
//+------------------------------------------------------------------+
//| Return a formula for constructing a custom symbol price          |
//+------------------------------------------------------------------+
string CSymbol::SymbolFormula(void) const
  {
   return
     (
      #ifdef __MQL5__ 
         ::SymbolInfoString(this.m_name,SYMBOL_FORMULA) 
      #else 
         ": "+TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") 
      #endif
     );
  }
//+------------------------------------------------------------------+
//| Return an address of a web page with a symbol data               |
//+------------------------------------------------------------------+
string CSymbol::SymbolPage(void) const
  {
   return
     (
      #ifdef __MQL5__ 
         ::SymbolInfoString(this.m_name,SYMBOL_PAGE) 
      #else 
         ": "+TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") 
      #endif
     );
  }
//+------------------------------------------------------------------+
//| Send symbol properties to the journal                            |
//+------------------------------------------------------------------+
void CSymbol::Print(const bool full_prop=false)
  {
   ::Print("============= ",
           TextByLanguage("Начало списка параметров: \"","Beginning of the parameter list: \""),
           this.Name(),"\""," ",(this.Description()!= #ifdef __MQL5__ "" #else NULL #endif  ? "("+this.Description()+")" : ""),
           " =================="
          );
   int beg=0, end=SYMBOL_PROP_INTEGER_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_INTEGER prop=(ENUM_SYMBOL_PROP_INTEGER)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("------");
   beg=end; end+=SYMBOL_PROP_DOUBLE_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_DOUBLE prop=(ENUM_SYMBOL_PROP_DOUBLE)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("------");
   beg=end; end+=SYMBOL_PROP_STRING_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_SYMBOL_PROP_STRING prop=(ENUM_SYMBOL_PROP_STRING)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("================== ",
           TextByLanguage("Конец списка параметров: \"","End of parameter list: \""),
           this.Name(),"\""," ",(this.Description()!= #ifdef __MQL5__ "" #else NULL #endif  ? "("+this.Description()+")" : ""),
           " ==================\n"
          );
  }
//+------------------------------------------------------------------+
//| Return the description of the symbol integer property            |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_INTEGER property)
  {
   return
     (
      property==SYMBOL_PROP_STATUS              ?  TextByLanguage("Статус","Status")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_INDEX_MW            ?  TextByLanguage("Индекс в окне \"Обзор рынка\"","Index in \"Market Watch window\"")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetStatusDescription()
         )  :
      property==SYMBOL_PROP_CUSTOM              ?  TextByLanguage("Пользовательский символ","Custom symbol")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_CHART_MODE          ?  TextByLanguage("Тип цены для построения баров","Price type used for generating symbols bars")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetChartModeDescription()
         )  :
      property==SYMBOL_PROP_EXIST               ?  TextByLanguage("Символ с таким именем существует","Symbol with this name exists")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_SELECT  ?  TextByLanguage("Символ выбран в Market Watch","Symbol is selected in Market Watch")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_VISIBLE ?  TextByLanguage("Символ отображается в Market Watch","Symbol visible in Market Watch")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_SESSION_DEALS       ?  TextByLanguage("Количество сделок в текущей сессии","Number of deals in the current session")+
         (!this.SupportProperty(property)    ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_BUY_ORDERS  ?  TextByLanguage("Общее число ордеров на покупку в текущий момент","Number of Buy orders at the moment")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_SELL_ORDERS ?  TextByLanguage("Общее число ордеров на продажу в текущий момент","Number of Sell orders at the moment")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUME              ?  TextByLanguage("Объем в последней сделке","Volume of the last deal")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUMEHIGH          ?  TextByLanguage("Максимальный объём за день","Maximum day volume")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUMELOW           ?  TextByLanguage("Минимальный объём за день","Minimum day volume")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TIME                ?  TextByLanguage("Время последней котировки","Time of the last quote")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)==0 ? TextByLanguage("(Ещё не было тиков)","(No ticks yet)") : TimeMSCtoString(this.GetProperty(property)))
         )  :
      property==SYMBOL_PROP_DIGITS              ?  TextByLanguage("Количество знаков после запятой","Digits after decimal point")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_DIGITS_LOTS         ?  TextByLanguage("Количество знаков после запятой в значении лота","Digits after decimal point in value of the lot")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_SPREAD              ?  TextByLanguage("Размер спреда в пунктах","Spread value in points")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_SPREAD_FLOAT        ?  TextByLanguage("Плавающий спред","Floating spread")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_TICKS_BOOKDEPTH     ?  TextByLanguage("Максимальное количество показываемых заявок в стакане","Maximal number of requests shown in Depth of Market")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__(string)this.GetProperty(property) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TRADE_CALC_MODE     ?  TextByLanguage("Способ вычисления стоимости контракта","Contract price calculation mode")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetCalcModeDescription()
         )  :
      property==SYMBOL_PROP_TRADE_MODE ?  TextByLanguage("Тип исполнения ордеров","Order execution type")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetTradeModeDescription()
         )  :
      property==SYMBOL_PROP_START_TIME          ?  TextByLanguage("Дата начала торгов по инструменту","Date of symbol trade beginning")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)==0  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": "+TimeMSCtoString(this.GetProperty(property)*1000))
         )  :
      property==SYMBOL_PROP_EXPIRATION_TIME     ?  TextByLanguage("Дата окончания торгов по инструменту","Date of symbol trade end")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)==0  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": "+TimeMSCtoString(this.GetProperty(property)*1000))
         )  :
      property==SYMBOL_PROP_TRADE_STOPS_LEVEL   ?  TextByLanguage("Минимальный отступ от цены закрытия для установки Stop ордеров","Minimum indention from close price to place Stop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_TRADE_FREEZE_LEVEL  ?  TextByLanguage("Дистанция заморозки торговых операций","Distance to freeze trade operations in points")+
         (!this.SupportProperty(property)    ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_TRADE_EXEMODE       ?  TextByLanguage("Режим заключения сделок","Deal execution mode")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetTradeExecDescription()
         )  :
      property==SYMBOL_PROP_SWAP_MODE           ?  TextByLanguage("Модель расчета свопа","Swap calculation model")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetSwapModeDescription()
         )  :
      property==SYMBOL_PROP_SWAP_ROLLOVER3DAYS  ?  TextByLanguage("День недели для начисления тройного свопа","Day of week to charge 3 days swap rollover")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+DayOfWeekDescription(this.SwapRollover3Days())
         )  :
      property==SYMBOL_PROP_MARGIN_HEDGED_USE_LEG  ?  TextByLanguage("Расчет хеджированной маржи по наибольшей стороне","Calculating hedging margin using the larger leg")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)   ?  TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))
         )  :
      property==SYMBOL_PROP_EXPIRATION_MODE     ?  TextByLanguage("Флаги разрешенных режимов истечения ордера","Flags of allowed order expiration modes")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetExpirationModeFlagsDescription()
         )  :
      property==SYMBOL_PROP_FILLING_MODE        ?  TextByLanguage("Флаги разрешенных режимов заливки ордера","Flags of allowed order filling modes")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetFillingModeFlagsDescription()
         )  :
      property==SYMBOL_PROP_ORDER_MODE          ?  TextByLanguage("Флаги разрешённых типов ордеров","Flags of allowed order types")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetOrderModeFlagsDescription()
         )  :
      property==SYMBOL_PROP_ORDER_GTC_MODE      ?  TextByLanguage("Срок действия StopLoss и TakeProfit ордеров","Expiration of Stop Loss and Take Profit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetOrderGTCModeDescription()
         )  :
      property==SYMBOL_PROP_OPTION_MODE         ?  TextByLanguage("Тип опциона","Option type")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetOptionTypeDescription()
         )  :
      property==SYMBOL_PROP_OPTION_RIGHT        ?  TextByLanguage("Право опциона","Option right")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetOptionRightDescription()
         )  :
      property==SYMBOL_PROP_BACKGROUND_COLOR    ?  TextByLanguage("Цвет фона символа в Market Watch","Background color of symbol in Market Watch")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         #ifdef __MQL5__
         (this.GetProperty(property)==CLR_DEFAULT || this.GetProperty(property)==CLR_NONE ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": "+::ColorToString((color)this.GetProperty(property),true))
         #else TextByLanguage(": Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the symbol real property               |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_DOUBLE property)
  {
   int dg=this.Digits();
   int dgl=this.DigitsLot();
   int dgc=this.DigitsCurrency();
   return
     (
      property==SYMBOL_PROP_BID              ?  TextByLanguage("Цена Bid","Bid price")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)==0 ? TextByLanguage("(Ещё не было тиков)","(No ticks yet)") : ::DoubleToString(this.GetProperty(property),dg))
         )  :
      property==SYMBOL_PROP_BIDHIGH          ?  TextByLanguage("Максимальный Bid за день","Maximum Bid of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dg)
         )  :
      property==SYMBOL_PROP_BIDLOW           ?  TextByLanguage("Минимальный Bid за день","Minimum Bid of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dg)
         )  :
      property==SYMBOL_PROP_ASK              ?  TextByLanguage("Цена Ask","Ask price")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(this.GetProperty(property)==0 ? TextByLanguage("(Ещё не было тиков)","(No ticks yet)") : ::DoubleToString(this.GetProperty(property),dg))
         )  :
      property==SYMBOL_PROP_ASKHIGH          ?  TextByLanguage("Максимальный Ask за день","Maximum Ask of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_ASKLOW           ?  TextByLanguage("Минимальный Ask за день","Minimum Ask of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_LAST             ?  TextByLanguage("Цена последней сделки","Price of the last deal")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_LASTHIGH         ?  TextByLanguage("Максимальный Last за день","Maximum Last of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_LASTLOW          ?  TextByLanguage("Минимальный Last за день","Minimum Last of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUME_REAL      ?  TextByLanguage("Реальный объём за день","Real volume of the last deal")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUMEHIGH_REAL  ?  TextByLanguage("Максимальный реальный объём за день","Maximum real volume of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUMELOW_REAL   ?  TextByLanguage("Минимальный реальный объём за день","Minimum real volume of the day")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_OPTION_STRIKE    ?  TextByLanguage("Цена исполнения опциона","Option strike price")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_POINT            ?  TextByLanguage("Значение одного пункта","Symbol point value")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dg)
         )  :
      property==SYMBOL_PROP_TRADE_TICK_VALUE ?  TextByLanguage("Рассчитанная стоимость тика для позиции","Calculated tick price for position")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT   ?  TextByLanguage("Рассчитанная стоимость тика для прибыльной позиции","Calculated tick price for profitable position")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TRADE_TICK_VALUE_LOSS  ?  TextByLanguage("Рассчитанная стоимость тика для убыточной позиции","Calculated tick price for losing position")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TRADE_TICK_SIZE  ?  TextByLanguage("Минимальное изменение цены","Minimum price change")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dg)
         )  :
      property==SYMBOL_PROP_TRADE_CONTRACT_SIZE ?  TextByLanguage("Размер торгового контракта","Trade contract size")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_TRADE_ACCRUED_INTEREST ?  TextByLanguage("Накопленный купонный доход","Accumulated coupon interest")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TRADE_FACE_VALUE ?  TextByLanguage("Начальная стоимость облигации, установленная эмитентом","Initial bond value set by issuer")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_TRADE_LIQUIDITY_RATE   ?  TextByLanguage("Коэффициент ликвидности","Liquidity rate")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),2) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_VOLUME_MIN       ?  TextByLanguage("Минимальный объем для заключения сделки","Minimum volume for a deal")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgl)
         )  :
      property==SYMBOL_PROP_VOLUME_MAX       ?  TextByLanguage("Максимальный объем для заключения сделки","Maximum volume for a deal")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgl)
         )  :
      property==SYMBOL_PROP_VOLUME_STEP      ?  TextByLanguage("Минимальный шаг изменения объема для заключения сделки","Minimum volume change step for deal execution")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgl)
         )  :
      property==SYMBOL_PROP_VOLUME_LIMIT     ?  TextByLanguage("Максимально допустимый общий объем позиции и отложенных ордеров в одном направлении","Maximum allowed aggregate volume of open position and pending orders in one direction")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SWAP_LONG        ?  TextByLanguage("Значение свопа на покупку","Long swap value")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_SWAP_SHORT       ?  TextByLanguage("Значение свопа на продажу","Short swap value")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_MARGIN_INITIAL   ?  TextByLanguage("Начальная (инициирующая) маржа","Initial margin")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),8)
         )  :
      property==SYMBOL_PROP_MARGIN_MAINTENANCE  ?  TextByLanguage("Поддерживающая маржа по инструменту","Maintenance margin")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),8)
         )  :
//--- Initial margin requirement of a Long position
      property==SYMBOL_PROP_MARGIN_LONG_INITIAL          ?  TextByLanguage("Коэффициент взимания начальной маржи по длинным позициям","Coefficient of margin initial charging for long positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Initial margin requirement of a Short position
      property==SYMBOL_PROP_MARGIN_SHORT_INITIAL     ?  TextByLanguage("Коэффициент взимания начальной маржи по коротким позициям","Coefficient of margin initial charging for short positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Maintenance margin requirement of a Long position
      property==SYMBOL_PROP_MARGIN_LONG_MAINTENANCE          ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по длинным позициям","Coefficient of margin maintenance charging for long positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Maintenance margin requirement of a Short position
      property==SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE          ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по коротким позициям","Coefficient of margin maintenance charging for short positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Initial margin requirements of Long orders
      property==SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL      ?  TextByLanguage("Коэффициент взимания начальной маржи по BuyStop ордерам","Coefficient of margin initial charging for BuyStop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL     ?  TextByLanguage("Коэффициент взимания начальной маржи по BuyLimit ордерам","Coefficient of margin initial charging for BuyLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL ?  TextByLanguage("Коэффициент взимания начальной маржи по BuyStopLimit ордерам","Coefficient of margin initial charging for BuyStopLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Initial margin requirements of Short orders
      property==SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL      ?  TextByLanguage("Коэффициент взимания начальной маржи по SellStop ордерам","Coefficient of margin initial charging for SellStop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL     ?  TextByLanguage("Коэффициент взимания начальной маржи по SellLimit ордерам","Coefficient of margin initial charging for SellLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL ?  TextByLanguage("Коэффициент взимания начальной маржи по SellStopLimit ордерам","Coefficient of margin initial charging for SellStopLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Maintenance margin requirements of Long orders
      property==SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE      ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по BuyStop ордерам","Coefficient of margin maintenance charging for BuyStop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE     ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по BuyLimit ордерам","Coefficient of margin maintenance charging for BuyLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по BuyStopLimit ордерам","Coefficient of margin maintenance charging for BuyStopLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
//--- Maintenance margin requirements of Short orders
      property==SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE      ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по SellStop ордерам","Coefficient of margin maintenance charging for SellStop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE     ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по SellLimit ордерам","Coefficient of margin maintenance charging for SellLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE ?  TextByLanguage("Коэффициент взимания поддерживающей маржи по SellStopLimit ордерам","Coefficient of margin maintenance charging for SellStopLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ 
          #ifdef __MQL5__ (this.GetProperty(property)==0  ?  TextByLanguage(": (Не задан)",": (Not set)") : (::DoubleToString(this.GetProperty(property),8)))
          #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
   //---
      property==SYMBOL_PROP_SESSION_VOLUME   ?  TextByLanguage("Cуммарный объём сделок в текущую сессию","Summary volume of the current session deals")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_TURNOVER ?  TextByLanguage("Cуммарный оборот в текущую сессию","Summary turnover of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_INTEREST ?  TextByLanguage("Cуммарный объём открытых позиций","Summary open interest")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME ?  TextByLanguage("Общий объём ордеров на покупку в текущий момент","Current volume of Buy orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME   ?  TextByLanguage("Общий объём ордеров на продажу в текущий момент","Current volume of Sell orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgl) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_OPEN     ?  TextByLanguage("Цена открытия сессии","Open price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_CLOSE    ?  TextByLanguage("Цена закрытия сессии","Close price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_AW       ?  TextByLanguage("Средневзвешенная цена сессии","Average weighted price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_PRICE_SETTLEMENT  ?  TextByLanguage("Цена поставки на текущую сессию","Settlement price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN   ?  TextByLanguage("Минимально допустимое значение цены на сессию","Minimum price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX   ?  TextByLanguage("Максимально допустимое значение цены на сессию","Maximum price of the current session")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_HEDGED    ?  TextByLanguage("Размер контракта или маржи для одного лота перекрытых позиций","Contract size or margin value per one lot of hedged positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the symbol string property             |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_STRING property)
  {
   return
     (
      property==SYMBOL_PROP_NAME             ?  TextByLanguage("Имя символа","Symbol name")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_BASIS            ?  TextByLanguage("Имя базового актива для производного инструмента","Underlying asset of derivative")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_BASE    ?  TextByLanguage("Базовая валюта инструмента","Basic currency of symbol")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_PROFIT  ?  TextByLanguage("Валюта прибыли","Profit currency")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_MARGIN  ?  TextByLanguage("Валюта залоговых средств","Margin currency")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_BANK             ?  TextByLanguage("Источник текущей котировки","Feeder of the current quote")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_DESCRIPTION      ?  TextByLanguage("Описание символа","Symbol description")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_FORMULA          ?  TextByLanguage("Формула для построения цены пользовательского символа","Formula used for custom symbol pricing")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_ISIN             ?  TextByLanguage("Имя торгового символа в системе международных идентификационных кодов","Symbol name in ISIN system")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_PAGE             ?  TextByLanguage("Адрес интернет страницы с информацией по символу","Address of web page containing symbol information")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_PATH             ?  TextByLanguage("Путь в дереве символов","Path in symbol tree")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         (this.GetProperty(property)=="" || this.GetProperty(property)==NULL  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      ""
     );
  }
//+-------------------------------------------------------------------------------+
//| Search for a symbol and return the flag indicating its presence on the server |
//+-------------------------------------------------------------------------------+
bool CSymbol::Exist(void) const
  {
   int total=::SymbolsTotal(false);
   for(int i=0;i<total;i++)
      if(::SymbolName(i,false)==this.m_name)
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Subscribe to the market depth                                    |
//+------------------------------------------------------------------+
bool CSymbol::BookAdd(void) const
  {
   return #ifdef __MQL5__ ::MarketBookAdd(this.m_name) #else false #endif ;
  }
//+------------------------------------------------------------------+
//| Close the market depth                                           |
//+------------------------------------------------------------------+
bool CSymbol::BookClose(void) const
  {
   return #ifdef __MQL5__ ::MarketBookRelease(this.m_name) #else false #endif ;
  }
//+------------------------------------------------------------------+
//| Return the quote session start time                              |
//| in seconds from the beginning of a day                           |
//+------------------------------------------------------------------+
long CSymbol::SessionQuoteTimeFrom(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE) const
  {
   MqlDateTime time={0};
   datetime from=0,to=0;
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return(::SymbolInfoSessionQuote(this.m_name,day,session_index,from,to) ? from : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Return the time in seconds since the day start                   |
//| up to the end of a quote session                                 |
//+------------------------------------------------------------------+
long CSymbol::SessionQuoteTimeTo(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE) const
  {
   MqlDateTime time={0};
   datetime from=0,to=0;
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return(::SymbolInfoSessionQuote(this.m_name,day,session_index,from,to) ? to : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Return the start and end time of a required quote session        |
//+------------------------------------------------------------------+
bool CSymbol::GetSessionQuote(const uint session_index,ENUM_DAY_OF_WEEK day_of_week,datetime &from,datetime &to)
  {
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return ::SymbolInfoSessionQuote(this.m_name,day,session_index,from,to);
  }
//+------------------------------------------------------------------+
//| Return the trading session start time                            |
//| in seconds from the beginning of a day                           |
//+------------------------------------------------------------------+
long CSymbol::SessionTradeTimeFrom(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE) const
  {
   MqlDateTime time={0};
   datetime from=0,to=0;
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return(::SymbolInfoSessionTrade(this.m_name,day,session_index,from,to) ? from : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Return the time in seconds since the day start                   |
//| up to the end of a trading session                               |
//+------------------------------------------------------------------+
long CSymbol::SessionTradeTimeTo(const uint session_index,ENUM_DAY_OF_WEEK day_of_week=WRONG_VALUE) const
  {
   MqlDateTime time={0};
   datetime from=0,to=0;
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return(::SymbolInfoSessionTrade(this.m_name,day,session_index,from,to) ? to : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Return the start and end time of a required trading session      |
//+------------------------------------------------------------------+
bool CSymbol::GetSessionTrade(const uint session_index,ENUM_DAY_OF_WEEK day_of_week,datetime &from,datetime &to)
  {
   ENUM_DAY_OF_WEEK day=(day_of_week<0 || day_of_week>SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
   return ::SymbolInfoSessionTrade(this.m_name,day,session_index,from,to);
  }
//+------------------------------------------------------------------+
//| Return the current day of the week                               |
//+------------------------------------------------------------------+
ENUM_DAY_OF_WEEK CSymbol::CurrentDayOfWeek(void) const
  {
   MqlDateTime time={0};
   ::TimeCurrent(time);
   return(ENUM_DAY_OF_WEEK)time.day_of_week;
  }
//+------------------------------------------------------------------+
//| Return the number of seconds in a session duration time          |
//+------------------------------------------------------------------+
int CSymbol::SessionSeconds(const ulong duration_sec) const
  {
   return int(duration_sec % 60);
  }
//+------------------------------------------------------------------+
//| Return the number of minutes in a session duration time          |
//+------------------------------------------------------------------+
int CSymbol::SessionMinutes(const ulong duration_sec) const
  {
   return int((duration_sec-this.SessionSeconds(duration_sec)) % 3600)/60;
  }
//+------------------------------------------------------------------+
//| Return the number of hours in a session duration time            |
//+------------------------------------------------------------------+
int CSymbol::SessionHours(const ulong duration_sec) const
  {
   return int(duration_sec-this.SessionSeconds(duration_sec)-this.SessionMinutes(duration_sec))/3600;
  }
//+--------------------------------------------------------------------+
//| Return the description of a session duration in the hh:mm:ss format|
//+--------------------------------------------------------------------+
string CSymbol::SessionDurationDescription(const ulong duration_sec) const
  {
   int sec=this.SessionSeconds(duration_sec);
   int min=this.SessionMinutes(duration_sec);
   int hour=this.SessionHours(duration_sec);
   return ::IntegerToString(hour,2,'0')+":"+::IntegerToString(min,2,'0')+":"+::IntegerToString(sec,2,'0');
  }
//+------------------------------------------------------------------+
//| Return the status description                                    |
//+------------------------------------------------------------------+
string CSymbol::GetStatusDescription() const
  {
   return
     (
      this.Status()==SYMBOL_STATUS_FX           ? TextByLanguage("Форекс символ","Forex symbol")                  :
      this.Status()==SYMBOL_STATUS_FX_MAJOR     ? TextByLanguage("Форекс символ-мажор","Forex major symbol")      :
      this.Status()==SYMBOL_STATUS_FX_MINOR     ? TextByLanguage("Форекс символ-минор","Forex minor symbol")      :
      this.Status()==SYMBOL_STATUS_FX_EXOTIC    ? TextByLanguage("Форекс символ-экзотик","Forex Exotic Symbol")   :
      this.Status()==SYMBOL_STATUS_FX_RUB       ? TextByLanguage("Форекс символ/рубль","Forex symbol RUB")        :
      this.Status()==SYMBOL_STATUS_METAL        ? TextByLanguage("Металл","Metal")                                :
      this.Status()==SYMBOL_STATUS_INDEX        ? TextByLanguage("Индекс","Index")                                :
      this.Status()==SYMBOL_STATUS_INDICATIVE   ? TextByLanguage("Индикатив","Indicative")                        :
      this.Status()==SYMBOL_STATUS_CRYPTO       ? TextByLanguage("Криптовалютный символ","Crypto symbol")         :
      this.Status()==SYMBOL_STATUS_COMMODITY    ? TextByLanguage("Товарный символ","Commodity symbol")            :
      this.Status()==SYMBOL_STATUS_EXCHANGE     ? TextByLanguage("Биржевой символ","Exchange symbol")             : 
      this.Status()==SYMBOL_STATUS_FUTURES      ? TextByLanguage("Фьючерс","Furures")                             : 
      this.Status()==SYMBOL_STATUS_CFD          ? TextByLanguage("Контракт на разницу","Contract For Difference") : 
      this.Status()==SYMBOL_STATUS_STOCKS       ? TextByLanguage("Ценная бумага","Stocks")                        : 
      this.Status()==SYMBOL_STATUS_BONDS        ? TextByLanguage("Облигация","Bonds")                             : 
      this.Status()==SYMBOL_STATUS_OPTION       ? TextByLanguage("Опцион","Option")                               : 
      this.Status()==SYMBOL_STATUS_COLLATERAL   ? TextByLanguage("Неторгуемый актив","Collateral")                : 
      this.Status()==SYMBOL_STATUS_CUSTOM       ? TextByLanguage("Пользовательский символ","Custom symbol")       :
      this.Status()==SYMBOL_STATUS_COMMON       ? TextByLanguage("Символ общей группы","Common group symbol")     :
      ::EnumToString((ENUM_SYMBOL_STATUS)this.Status())
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the price type for constructing bars   |
//+------------------------------------------------------------------+
string CSymbol::GetChartModeDescription(void) const
  {
   return
     (
      this.ChartMode()==SYMBOL_CHART_MODE_BID ? TextByLanguage("Бары строятся по ценам Bid","Bars are based on Bid prices") : 
      TextByLanguage("Бары строятся по ценам Last","Bars are based on Last prices")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the margin calculation method          |
//+------------------------------------------------------------------+
string CSymbol::GetCalcModeDescription(void) const
  {
   return
     (
      this.TradeCalcMode()==SYMBOL_CALC_MODE_FOREX                ? 
         TextByLanguage("Расчет прибыли и маржи для Форекс","Forex mode")                                               :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE    ? 
         TextByLanguage("Расчет прибыли и маржи для Форекс без учета плеча","Forex No Leverage mode")                   :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_FUTURES              ? 
         TextByLanguage("Расчет залога и прибыли для фьючерсов","Futures mode")                                         :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_CFD                  ? 
         TextByLanguage("Расчет залога и прибыли для CFD","CFD mode")                                                   :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_CFDINDEX             ? 
         TextByLanguage("Расчет залога и прибыли для CFD на индексы","CFD index mode")                                  :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_CFDLEVERAGE          ? 
         TextByLanguage("Расчет залога и прибыли для CFD при торговле с плечом","CFD Leverage mode")                    :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_STOCKS          ? 
         TextByLanguage("Расчет залога и прибыли для торговли ценными бумагами на бирже","Exchange mode")               :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_FUTURES         ? 
         TextByLanguage("Расчет залога и прибыли для торговли фьючерсными контрактами на бирже","Futures mode")         :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS   ? 
         TextByLanguage("Расчет залога и прибыли для торговли фьючерсными контрактами на FORTS","FORTS Futures mode")   :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_BONDS           ? 
         TextByLanguage("Расчет прибыли и маржи по торговым облигациям на бирже","Exchange Bonds mode")                 :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX     ? 
         TextByLanguage("Расчет прибыли и маржи при торговле ценными бумагами на MOEX","Exchange MOEX Stocks mode")     :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_EXCH_BONDS_MOEX      ? 
         TextByLanguage("Расчет прибыли и маржи по торговым облигациям на MOEX","Exchange MOEX Bonds mode")             :
      this.TradeCalcMode()==SYMBOL_CALC_MODE_SERV_COLLATERAL      ? 
         TextByLanguage("Используется в качестве неторгуемого актива на счете","Collateral mode")                       :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of a symbol trading mode                  |
//+------------------------------------------------------------------+
string CSymbol::GetTradeModeDescription(void) const
  {
   return
     (
      this.TradeMode()==SYMBOL_TRADE_MODE_DISABLED    ? TextByLanguage("Торговля по символу запрещена","Trade disabled for symbol")                     :
      this.TradeMode()==SYMBOL_TRADE_MODE_LONGONLY    ? TextByLanguage("Разрешены только покупки","Only long positions allowed")                               :
      this.TradeMode()==SYMBOL_TRADE_MODE_SHORTONLY   ? TextByLanguage("Разрешены только продажи","Only short positions allowed")                              :
      this.TradeMode()==SYMBOL_TRADE_MODE_CLOSEONLY   ? TextByLanguage("Разрешены только операции закрытия позиций","Only position close operations allowed")  :
      this.TradeMode()==SYMBOL_TRADE_MODE_FULL        ? TextByLanguage("Нет ограничений на торговые операции","No trade restrictions")                         :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of a symbol trade execution mode          |
//+------------------------------------------------------------------+
string CSymbol::GetTradeExecDescription(void) const
  {
   return
     (
      this.TradeExecutionMode()==SYMBOL_TRADE_EXECUTION_REQUEST   ? TextByLanguage("Торговля по запросу","Execution by request")       :
      this.TradeExecutionMode()==SYMBOL_TRADE_EXECUTION_INSTANT   ? TextByLanguage("Торговля по потоковым ценам","Instant execution")  :
      this.TradeExecutionMode()==SYMBOL_TRADE_EXECUTION_MARKET    ? TextByLanguage("Исполнение ордеров по рынку","Market execution")   :
      this.TradeExecutionMode()==SYMBOL_TRADE_EXECUTION_EXCHANGE  ? TextByLanguage("Биржевое исполнение","Exchange execution")         :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of a swap calculation model               |
//+------------------------------------------------------------------+
string CSymbol::GetSwapModeDescription(void) const
  {
   return
     (
      this.SwapMode()==SYMBOL_SWAP_MODE_DISABLED         ? 
         TextByLanguage("Нет свопов","Swaps disabled (no swaps)")                                                                                                                                                    :
      this.SwapMode()==SYMBOL_SWAP_MODE_POINTS           ? 
         TextByLanguage("Свопы начисляются в пунктах","Swaps charged in points")                                                                                                                                 :
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_SYMBOL  ? 
         TextByLanguage("Свопы начисляются в деньгах в базовой валюте символа","Swaps charged in money in base currency of the symbol")                                                                          :
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_MARGIN  ? 
         TextByLanguage("Свопы начисляются в деньгах в маржинальной валюте символа","Swaps charged in money in margin currency of the symbol")                                                                   :
      this.SwapMode()==SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT ? 
         TextByLanguage("Свопы начисляются в деньгах в валюте депозита клиента","Swaps charged in money, in client deposit currency")                                                                            :
      this.SwapMode()==SYMBOL_SWAP_MODE_INTEREST_CURRENT ? 
         TextByLanguage("Свопы начисляются в годовых процентах от цены инструмента на момент расчета свопа","Swaps charged as specified annual interest from instrument price at calculation of swap")   :
      this.SwapMode()==SYMBOL_SWAP_MODE_INTEREST_OPEN    ? 
         TextByLanguage("Свопы начисляются в годовых процентах от цены открытия позиции по символу","Swaps charged as specified annual interest from open price of position")                            :
      this.SwapMode()==SYMBOL_SWAP_MODE_REOPEN_CURRENT   ? 
         TextByLanguage("Свопы начисляются переоткрытием позиции по цене закрытия","Swaps charged by reopening positions by close price")                                                                    :
      this.SwapMode()==SYMBOL_SWAP_MODE_REOPEN_BID       ? 
         TextByLanguage("Свопы начисляются переоткрытием позиции по текущей цене Bid","Swaps charged by reopening positions by the current Bid price")                                                           :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of StopLoss and TakeProfit order lifetime |
//+------------------------------------------------------------------+
string CSymbol::GetOrderGTCModeDescription(void) const
  {
   return
     (
      this.OrderModeGTC()==SYMBOL_ORDERS_GTC                   ? 
         TextByLanguage("Отложенные ордеры и уровни Stop Loss/Take Profit действительны неограниченно по времени до явной отмены","Pending orders and Stop Loss/Take Profit levels valid for unlimited period until their explicit cancellation") :
      this.OrderModeGTC()==SYMBOL_ORDERS_DAILY                 ? 
         TextByLanguage("При смене торгового дня отложенные ордеры и все уровни StopLoss и TakeProfit удаляются","At the end of the day, all Stop Loss and Take Profit levels, as well as pending orders deleted")                                   :
      this.OrderModeGTC()==SYMBOL_ORDERS_DAILY_EXCLUDING_STOPS ? 
         TextByLanguage("При смене торгового дня удаляются только отложенные ордеры, уровни StopLoss и TakeProfit сохраняются","At the end of the day, only pending orders deleted, while Stop Loss and Take Profit levels preserved")           :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the option type description                               |
//+------------------------------------------------------------------+
string CSymbol::GetOptionTypeDescription(void) const
  {
   return
     (
      #ifdef __MQL4__ TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #else 
      this.OptionMode()==SYMBOL_OPTION_MODE_EUROPEAN ? 
         TextByLanguage("Европейский тип опциона – может быть погашен только в указанную дату","European option may only be exercised on specified date")                               :
      this.OptionMode()==SYMBOL_OPTION_MODE_AMERICAN ? 
         TextByLanguage("Американский тип опциона – может быть погашен в любой день до истечения срока опциона","American option may be exercised on any trading day or before expiry")   :
      ""
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Return the option right description                              |
//+------------------------------------------------------------------+
string CSymbol::GetOptionRightDescription(void) const
  {
   return
     (
      #ifdef __MQL4__ TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #else 
      this.OptionRight()==SYMBOL_OPTION_RIGHT_CALL ? 
         TextByLanguage("Опцион, дающий право купить актив по фиксированной цене","Call option gives you right to buy asset at specified price")    :
      this.OptionRight()==SYMBOL_OPTION_RIGHT_PUT  ? 
         TextByLanguage("Опцион, дающий право продать актив по фиксированной цене  ","Put option gives you right to sell asset at specified price") :
      ""
      #endif 
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the flags of allowed order types       |
//+------------------------------------------------------------------+
string CSymbol::GetOrderModeFlagsDescription(void) const
  {
   string first=#ifdef __MQL5__ "\n - " #else ""   #endif ;
   string next= #ifdef __MQL5__ "\n - " #else "; " #endif ;
   return
     (
      first+this.GetMarketOrdersAllowedDescription()+
      next+this.GetLimitOrdersAllowedDescription()+
      next+this.GetStopOrdersAllowedDescription()+
      next+this.GetStopLimitOrdersAllowedDescription()+
      next+this.GetStopLossOrdersAllowedDescription()+
      next+this.GetTakeProfitOrdersAllowedDescription()+
      next+this.GetCloseByOrdersAllowedDescription()
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the flags of allowed filling types     |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeFlagsDescription(void) const
  {
   string first=#ifdef __MQL5__ "\n - " #else ""   #endif ;
   string next= #ifdef __MQL5__ "\n - " #else "; " #endif ;
   return
     (
      first+TextByLanguage("Вернуть (Да)","Return (Yes)")+
      next+this.GetFillingModeFOKAllowedDescrioption()+
      next+this.GetFillingModeIOCAllowedDescrioption()
     );
  }
//+------------------------------------------------------------------------+
//| Return the description of the flags of allowed order expiration modes  |
//+------------------------------------------------------------------------+
string CSymbol::GetExpirationModeFlagsDescription(void) const
  {
   string first=#ifdef __MQL5__ "\n - " #else ""   #endif ;
   string next= #ifdef __MQL5__ "\n - " #else "; " #endif ;
   return
     (
      first+this.GetExpirationModeGTCDescription()+
      next+this.GetExpirationModeDAYDescription()+
      next+this.GetExpirationModeSpecifiedDescription()+
      next+this.GetExpirationModeSpecDayDescription()
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to use market orders          |
//+------------------------------------------------------------------+
string CSymbol::GetMarketOrdersAllowedDescription(void) const
  {
   return
     (this.IsMarketOrdersAllowed() ? 
      TextByLanguage("Рыночный ордер (Да)","Market order (Yes)") : 
      TextByLanguage("Рыночный ордер (Нет)","Market order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to use limit orders           |
//+------------------------------------------------------------------+
string CSymbol::GetLimitOrdersAllowedDescription(void) const
  {
   return
     (this.IsLimitOrdersAllowed() ? 
      TextByLanguage("Лимит ордер (Да)","Limit order (Yes)") : 
      TextByLanguage("Лимит ордер (Нет)","Limit order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to use stop orders            |
//+------------------------------------------------------------------+
string CSymbol::GetStopOrdersAllowedDescription(void) const
  {
   return
     (this.IsStopOrdersAllowed() ? 
      TextByLanguage("Стоп ордер (Да)","Stop order (Yes)") : 
      TextByLanguage("Стоп ордер (Нет)","Stop order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to use stop limit orders      |
//+------------------------------------------------------------------+
string CSymbol::GetStopLimitOrdersAllowedDescription(void) const
  {
   return
     (this.IsStopLimitOrdersAllowed() ? 
      TextByLanguage("Стоп-лимит ордер (Да)","StopLimit order (Yes)") : 
      TextByLanguage("Стоп-лимит ордер (Нет)","StopLimit order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to set StopLoss orders        |
//+------------------------------------------------------------------+
string CSymbol::GetStopLossOrdersAllowedDescription(void) const
  {
   return
     (this.IsStopLossOrdersAllowed() ? 
      TextByLanguage("StopLoss (Да)","StopLoss (Yes)") : 
      TextByLanguage("StopLoss (Нет)","StopLoss (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing to set TakeProfit orders      |
//+------------------------------------------------------------------+
string CSymbol::GetTakeProfitOrdersAllowedDescription(void) const
  {
   return
     (this.IsTakeProfitOrdersAllowed() ? 
      TextByLanguage("TakeProfit (Да)","TakeProfit (Yes)") : 
      TextByLanguage("TakeProfit (Нет)","TakeProfit (No)")
     );
  }
//+--------------------------------------------------------------------+
//| Return the description of allowing to close by an opposite position|
//+--------------------------------------------------------------------+
string CSymbol::GetCloseByOrdersAllowedDescription(void) const
  {
   return
     (this.IsCloseByOrdersAllowed() ? 
      TextByLanguage("Закрытие встречным (Да)","CloseBy order (Yes)") : 
      TextByLanguage("Закрытие встречным (Нет)","CloseBy order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing FOK filling type              |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeFOKAllowedDescrioption(void) const
  {
   return
     (this.IsFillingModeFOK() ? 
      TextByLanguage("Всё/Ничего (Да)","Fill or Kill (Yes)") : 
      TextByLanguage("Всё/Ничего (Нет)","Fill or Kill (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of allowing IOC filling type              |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeIOCAllowedDescrioption(void) const
  {
   return
     (this.IsFillingModeIOC() ? 
      TextByLanguage("Всё/Частично (Да)","Immediate or Cancel order (Yes)") : 
      TextByLanguage("Всё/Частично (Нет)","Immediate or Cancel (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of GTC order expiration                   |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeGTCDescription(void) const
  {
   return
     (this.IsExpirationModeGTC() ? 
      TextByLanguage("Неограниченно (Да)","Unlimited (Yes)") : 
      TextByLanguage("Неограниченно (Нет)","Unlimited (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of DAY order expiration                   |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeDAYDescription(void) const
  {
   return
     (this.IsExpirationModeDAY() ? 
      TextByLanguage("До конца дня (Да)","Valid till the end of the day (Yes)") : 
      TextByLanguage("До конца дня (Нет)","Valid till the end of the day (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of Specified order expiration             |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeSpecifiedDescription(void) const
  {
   return
     (this.IsExpirationModeSpecified() ? 
      TextByLanguage("Срок указывается в ордере (Да)","Time specified in order (Yes)") : 
      TextByLanguage("Срок указывается в ордере (Нет)","Time specified in order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of Specified Day order expiration         |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeSpecDayDescription(void) const
  {
   return
     (this.IsExpirationModeSpecifiedDay() ? 
      TextByLanguage("День указывается в ордере (Да)","Date specified in order (Yes)") : 
      TextByLanguage("День указывается в ордере (Нет)","Date specified in order (No)")
     );
  }
//+------------------------------------------------------------------+
//| Return a normalized price considering symbol properties          |
//+------------------------------------------------------------------+
double CSymbol::NormalizedPrice(const double price) const
  {
   double tsize=this.TradeTickSize();
   return(tsize!=0 ? ::NormalizeDouble(::round(price/tsize)*tsize,this.Digits()) : ::NormalizeDouble(price,this.Digits()));
  }
//+------------------------------------------------------------------+
//| Обновляет все данные символа                                     |
//+------------------------------------------------------------------+
void CSymbol::Refresh(void)
  {
//--- Update quote data
   if(!this.RefreshRates())
      return;
#ifdef __MQL5__
   ::ResetLastError();
   if(!this.MarginRates())
     {
      this.m_global_error=::GetLastError();
      return;
     }
#endif 
//--- Prepare event data
   this.m_is_event=false;
   ::ZeroMemory(this.m_struct_curr_symbol);
   this.m_hash_sum=0;
//--- Update integer properties
   this.m_long_prop[SYMBOL_PROP_SELECT]                                             = ::SymbolInfoInteger(this.m_name,SYMBOL_SELECT);
   this.m_long_prop[SYMBOL_PROP_VISIBLE]                                            = ::SymbolInfoInteger(this.m_name,SYMBOL_VISIBLE);
   this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                      = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_DEALS);
   this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                                 = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_BUY_ORDERS);
   this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                                = ::SymbolInfoInteger(this.m_name,SYMBOL_SESSION_SELL_ORDERS);
   this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                         = ::SymbolInfoInteger(this.m_name,SYMBOL_VOLUMEHIGH);
   this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                          = ::SymbolInfoInteger(this.m_name,SYMBOL_VOLUMELOW);
   this.m_long_prop[SYMBOL_PROP_SPREAD]                                             = ::SymbolInfoInteger(this.m_name,SYMBOL_SPREAD);
   this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                                    = ::SymbolInfoInteger(this.m_name,SYMBOL_TICKS_BOOKDEPTH);
   this.m_long_prop[SYMBOL_PROP_START_TIME]                                         = ::SymbolInfoInteger(this.m_name,SYMBOL_START_TIME);
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                                    = ::SymbolInfoInteger(this.m_name,SYMBOL_EXPIRATION_TIME);
   this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                                  = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_STOPS_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                                 = ::SymbolInfoInteger(this.m_name,SYMBOL_TRADE_FREEZE_LEVEL);
   this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                                   = this.SymbolBackgroundColor();
   
//--- Update real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE_PROFIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]            = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_VALUE_LOSS);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]                  = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_TICK_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]              = ::SymbolInfoDouble(this.m_name,SYMBOL_TRADE_CONTRACT_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                      = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_STEP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]                     = ::SymbolInfoDouble(this.m_name,SYMBOL_VOLUME_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                        = ::SymbolInfoDouble(this.m_name,SYMBOL_SWAP_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_SWAP_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]                   = ::SymbolInfoDouble(this.m_name,SYMBOL_MARGIN_INITIAL);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]               = ::SymbolInfoDouble(this.m_name,SYMBOL_MARGIN_MAINTENANCE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]                   = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_TURNOVER);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]                 = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_INTEREST);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]        = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_BUY_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)]       = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_SELL_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]                     = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_OPEN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]                    = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_CLOSE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                       = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_AW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]         = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_SETTLEMENT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_LIMIT_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]          = ::SymbolInfoDouble(this.m_name,SYMBOL_SESSION_PRICE_LIMIT_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                      = this.SymbolVolumeReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]                  = this.SymbolVolumeHighReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]                   = this.SymbolVolumeLowReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]                    = this.SymbolOptionStrike();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]           = this.SymbolTradeAccruedInterest();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]                 = this.SymbolTradeFaceValue();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]             = this.SymbolTradeLiquidityRate();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]                    = this.SymbolMarginHedged();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_INITIAL)]              = this.m_margin_rate.Long.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL)]          = this.m_margin_rate.BuyStop.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL)]         = this.m_margin_rate.BuyLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL)]     = this.m_margin_rate.BuyStopLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE)]          = this.m_margin_rate.Long.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE)]      = this.m_margin_rate.BuyStop.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE)]     = this.m_margin_rate.BuyLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE)] = this.m_margin_rate.BuyStopLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_INITIAL)]             = this.m_margin_rate.Short.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL)]         = this.m_margin_rate.SellStop.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL)]        = this.m_margin_rate.SellLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL)]    = this.m_margin_rate.SellStopLimit.Initial;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE)]         = this.m_margin_rate.Short.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE)]     = this.m_margin_rate.SellStop.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE)]    = this.m_margin_rate.SellLimit.Maintenance;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE)]= this.m_margin_rate.SellStopLimit.Maintenance;
   
//--- Fill in the current symbol data structure
   this.m_struct_curr_symbol.ask                                                    = this.Ask();
   this.m_struct_curr_symbol.ask_high                                               = this.AskHigh();
   this.m_struct_curr_symbol.ask_low                                                = this.AskLow();
   this.m_struct_curr_symbol.bid_last                                               = (this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.Bid() : this.Last());
   this.m_struct_curr_symbol.bid_last_high                                          = (this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.BidHigh() : this.LastHigh());
   this.m_struct_curr_symbol.bid_last_low                                           = (this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.BidLow() : this.LastLow());
   this.m_struct_curr_symbol.volume                                                 = this.Volume();
   this.m_struct_curr_symbol.session_deals                                          = this.SessionDeals();
   this.m_struct_curr_symbol.session_buy_orders                                     = this.SessionBuyOrders();
   this.m_struct_curr_symbol.session_sell_orders                                    = this.SessionSellOrders();
   this.m_struct_curr_symbol.volume_high_day                                        = this.VolumeHigh();
   this.m_struct_curr_symbol.volume_low_day                                         = this.VolumeLow();
   this.m_struct_curr_symbol.spread                                                 = this.Spread();
   this.m_struct_curr_symbol.stops_level                                            = this.TradeStopLevel();
   this.m_struct_curr_symbol.freeze_level                                           = this.TradeFreezeLevel();
   this.m_struct_curr_symbol.volume_limit                                           = this.VolumeLimit();
   this.m_struct_curr_symbol.swap_long                                              = this.SwapLong();
   this.m_struct_curr_symbol.swap_short                                             = this.SwapShort();
   this.m_struct_curr_symbol.session_volume                                         = this.SessionVolume();
   this.m_struct_curr_symbol.session_turnover                                       = this.SessionTurnover();
   this.m_struct_curr_symbol.session_interest                                       = this.SessionInterest();
   this.m_struct_curr_symbol.session_buy_ord_volume                                 = this.SessionBuyOrdersVolume();
   this.m_struct_curr_symbol.session_sell_ord_volume                                = this.SessionSellOrdersVolume();
   this.m_struct_curr_symbol.session_open                                           = this.SessionOpen();
   this.m_struct_curr_symbol.session_close                                          = this.SessionClose();
   this.m_struct_curr_symbol.session_aw                                             = this.SessionAW();
   this.m_struct_curr_symbol.volume_real_day                                        = this.VolumeReal();
   this.m_struct_curr_symbol.volume_high_real_day                                   = this.VolumeHighReal();
   this.m_struct_curr_symbol.volume_low_real_day                                    = this.VolumeLowReal();
   this.m_struct_curr_symbol.option_strike                                          = this.OptionStrike();
   this.m_struct_curr_symbol.trade_mode                                             = this.TradeMode();

//--- Hash sum calculation
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.volume;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.session_deals;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.session_buy_orders;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.session_sell_orders;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.volume_high_day;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.volume_low_day;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.spread;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.stops_level;
   this.m_hash_sum+=(double)this.m_struct_curr_symbol.freeze_level;
   this.m_hash_sum+=this.m_struct_curr_symbol.ask;
   this.m_hash_sum+=this.m_struct_curr_symbol.ask_high;
   this.m_hash_sum+=this.m_struct_curr_symbol.ask_low;
   this.m_hash_sum+=this.m_struct_curr_symbol.bid_last;
   this.m_hash_sum+=this.m_struct_curr_symbol.bid_last_high;
   this.m_hash_sum+=this.m_struct_curr_symbol.bid_last_low;
   this.m_hash_sum+=this.m_struct_curr_symbol.volume_limit;
   this.m_hash_sum+=this.m_struct_curr_symbol.swap_long;
   this.m_hash_sum+=this.m_struct_curr_symbol.swap_short;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_volume;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_turnover;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_interest;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_buy_ord_volume;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_sell_ord_volume;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_open;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_close;
   this.m_hash_sum+=this.m_struct_curr_symbol.session_aw;
   this.m_hash_sum+=this.m_struct_curr_symbol.volume_real_day;
   this.m_hash_sum+=this.m_struct_curr_symbol.volume_high_real_day;
   this.m_hash_sum+=this.m_struct_curr_symbol.volume_low_real_day;
   this.m_hash_sum+=this.m_struct_curr_symbol.option_strike;
   this.m_hash_sum+=this.m_struct_curr_symbol.trade_mode;

//--- First launch
   if(this.m_struct_prev_symbol.trade_mode==WRONG_VALUE)
     {
      this.m_struct_prev_symbol=this.m_struct_curr_symbol;
      this.m_hash_sum_prev=this.m_hash_sum;
      return;
     }
//--- If symbol's hash sum changed
   if(this.m_hash_sum!=this.m_hash_sum_prev)
     {
      this.m_event_code=this.SetEventCode();
      this.SetTypeEvent();
      CEventBaseObj *event=this.GetEvent(WRONG_VALUE,false);
      if(event!=NULL)
        {
         ENUM_SYMBOL_EVENT event_id=(ENUM_SYMBOL_EVENT)event.ID();
         if(event_id!=SYMBOL_EVENT_NO_EVENT)
           {
            this.m_is_event=true;
           }
        }
      this.m_hash_sum_prev=this.m_hash_sum;
     }
  }
//+------------------------------------------------------------------+
//| Update quote data by a symbol                                    |
//+------------------------------------------------------------------+
bool CSymbol::RefreshRates(void)
  {
//--- Get quote data
   ::ResetLastError();
   if(!::SymbolInfoTick(this.m_name,this.m_tick))
     {
      this.m_global_error=::GetLastError();
      return false;
     }
//--- Update integer properties
   this.m_long_prop[SYMBOL_PROP_VOLUME]                                             = (long)this.m_tick.volume;
   this.m_long_prop[SYMBOL_PROP_TIME]                                               = this.TickTime();
//--- Update real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                              = this.m_tick.ask;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                          = ::SymbolInfoDouble(this.m_name,SYMBOL_ASKHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                           = ::SymbolInfoDouble(this.m_name,SYMBOL_ASKLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                              = this.m_tick.bid;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                          = this.SymbolBidHigh();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                           = this.SymbolBidLow();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                             = this.m_tick.last;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                         = ::SymbolInfoDouble(this.m_name,SYMBOL_LASTHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                          = ::SymbolInfoDouble(this.m_name,SYMBOL_LASTLOW);
   return true;
  }  
//+------------------------------------------------------------------+
//| Initialize the variables of tracked symbol data                  |
//+------------------------------------------------------------------+
void CSymbol::InitChangesParams(void)
  {
//--- List and code of changes
   this.m_list_events.Clear();                           // Clear the change list
   this.m_list_events.Sort();                            // Sort the change list

//--- Execution
   this.m_is_change_trade_mode=false;                    // Flag of changing trading mode for a symbol
//--- Current session deals
   this.m_changed_session_deals_value=0;                 // Value of change in the number of deals
   this.m_is_change_session_deals_inc=false;             // Flag of a change in the number of deals exceeding the growth value
   this.m_is_change_session_deals_dec=false;             // Flag of a change in the number of deals exceeding the decrease value
//--- Buy orders of the current session
   this.m_changed_session_buy_ord_value=0;               // Buy orders change value
   this.m_is_change_session_buy_ord_inc=false;           // Flag of a change in the number of Buy orders exceeding the growth value
   this.m_is_change_session_buy_ord_dec=false;           // Flag of a change in the number of Buy orders exceeding the decrease value
//--- Sell orders of the current session
   this.m_changed_session_sell_ord_value=0;              // Sell orders change value
   this.m_is_change_session_sell_ord_inc=false;          // Flag of a change in the number of Sell orders exceeding the growth value
   this.m_is_change_session_sell_ord_dec=false;          // Flag of a change in the number of Sell orders exceeding the decrease value
//--- Volume of the last deal
   this.m_changed_volume_value=0;                        // Volume change value in the last deal
   this.m_is_change_volume_inc=false;                    // Flag of the volume change in the last deal exceeding the growth value
   this.m_is_change_volume_dec=false;                    // Flag of the volume change in the last deal exceeding the decrease value
//--- Maximum volume within a day
   this.m_changed_volume_high_day_value=0;               // Maximum volume change value within a day
   this.m_is_change_volume_high_day_inc=false;           // Flag of the maximum day volume exceeding the growth value
   this.m_is_change_volume_high_day_dec=false;           // Flag of the maximum day volume exceeding the decrease value
//--- Minimum volume within a day
   this.m_changed_volume_low_day_value=0;                // Minimum volume change value within a day
   this.m_is_change_volume_low_day_inc=false;            // Flag of the minimum day volume exceeding the growth value
   this.m_is_change_volume_low_day_dec=false;            // Flag of the minimum day volume exceeding the decrease value
//--- Spread
   this.m_changed_spread_value=0;                        // Spread change value in points
   this.m_is_change_spread_inc=false;                    // Flag of spread change in points exceeding the growth value
   this.m_is_change_spread_dec=false;                    // Flag of spread change in points exceeding the decrease value
//--- StopLevel
   this.m_changed_stops_level_value=0;                   // StopLevel change value in points
   this.m_is_change_stops_level_inc=false;               // Flag of StopLevel change in points exceeding the growth value
   this.m_is_change_stops_level_dec=false;               // Flag of StopLevel change in points exceeding the decrease value
//--- Freeze distance
   this.m_changed_freeze_level_value=0;                  // FreezeLevel change value in points
   this.m_is_change_freeze_level_inc=false;              // Flag of FreezeLevel change in points exceeding the growth value
   this.m_is_change_freeze_level_dec=false;              // Flag of FreezeLevel change in points exceeding the decrease value
   
//--- Bid/Last
   this.m_changed_bid_last_value=0;                      // Bid or Last price change value
   this.m_is_change_bid_last_inc=false;                  // Flag of Bid or Last price change exceeding the growth value
   this.m_is_change_bid_last_dec=false;                  // Flag of Bid or Last price change exceeding the decrease value
//--- Maximum Bid/Last of the day
   this.m_changed_bid_last_high_value=0;                 // Maximum Bid or Last change value for the day
   this.m_is_change_bid_last_high_inc=false;             // Flag of the maximum Bid or Last price change for the day exceeding the growth value
   this.m_is_change_bid_last_high_dec=false;             // Flag of the maximum Bid or Last price change for the day exceeding the decrease value
//--- Minimum Bid/Last of the day
   this.m_changed_bid_last_low_value=0;                  // Minimum Bid or Last change value for the day
   this.m_is_change_bid_last_low_inc=false;              // Flag of the minimum Bid or Last price change for the day exceeding the growth value
   this.m_is_change_bid_last_low_dec=false;              // Flag of the minimum Bid or Last price change for the day exceeding the decrease value
//--- Ask
   this.m_changed_ask_value=0;                           // Ask price change value
   this.m_is_change_ask_inc=false;                       // Flag of the Ask price change exceeding the growth value
   this.m_is_change_ask_dec=false;                       // Flag of the Ask price change exceeding the decrease value
//--- Maximum Ask price for the day
   this.m_changed_ask_high_value=0;                      // Maximum Ask change value within a day
   this.m_is_change_ask_high_inc=false;                  // Flag of the maximum day Ask exceeding the growth value
   this.m_is_change_ask_high_dec=false;                  // Flag of the maximum day Ask exceeding the decrease value
//--- Minimum Ask price for the day
   this.m_changed_ask_low_value=0;                       // Minimum Ask change value within a day
   this.m_is_change_ask_low_inc=false;                   // Flag of the minimum Ask volume exceeding the growth value
   this.m_is_change_ask_low_dec=false;                   // Flag of the minimum Ask volume exceeding the decrease value
//--- Real Volume for the day
   this.m_changed_volume_real_value=0;                   // Change value of the real day volume
   this.m_is_change_volume_real_inc=false;               // Flag of the real volume change for the day exceeding the growth value
   this.m_is_change_volume_real_dec=false;               // Flag of the real volume change for the day exceeding the decrease value
//--- Maximum real volume for the day
   this.m_changed_volume_high_real_day_value=0;          // Change value of the maximum real day volume
   this.m_is_change_volume_high_real_day_inc=false;      // Flag of the maximum real volume change for the day exceeding the growth value
   this.m_is_change_volume_high_real_day_dec=false;      // Flag of the maximum real volume change for the day exceeding the decrease value
//--- Minimum real volume for the day
   this.m_changed_volume_low_real_day_value=0;           // Change value of the minimum real day volume
   this.m_is_change_volume_low_real_day_inc=false;       // Flag of the minimum real volume change for the day exceeding the growth value
   this.m_is_change_volume_low_real_day_dec=false;       // Flag of the minimum real volume change for the day exceeding the decrease value
//--- Strike price
   this.m_changed_option_strike_value=0;                 // Change value of the strike price
   this.m_is_change_option_strike_inc=false;             // Flag of the strike price change exceeding the growth value
   this.m_is_change_option_strike_dec=false;             // Flag of the strike price change exceeding the decrease value
//--- Total volume of positions and orders
   this.m_changed_volume_limit_value=0;                  // Minimum total volume change value
   this.m_is_change_volume_limit_inc=false;              // Flag of the minimum total volume increase
   this.m_is_change_volume_limit_dec=false;              // Flag of the minimum total volume decrease
//---  Swap long
   this.m_changed_swap_long_value=0;                     // Swap long change value
   this.m_is_change_swap_long_inc=false;                 // Flag of the swap long increase
   this.m_is_change_swap_long_dec=false;                 // Flag of the swap long decrease
//---  Swap short

   this.m_changed_swap_short_value=0;                    // Swap short change value
   this.m_is_change_swap_short_inc=false;                // Flag of the swap short increase
   this.m_is_change_swap_short_dec=false;                // Flag of the swap short decrease
//--- The total volume of deals in the current session
   this.m_changed_session_volume_value=0;                // Total deal volume change value in the current session
   this.m_is_change_session_volume_inc=false;            // Flag of total trade volume change in the current session exceeding the growth value
   this.m_is_change_session_volume_dec=false;            // Flag of total trade volume change in the current session exceeding the decrease value
//--- The total turnover in the current session
   this.m_changed_session_turnover_value=0;              // Total turnover change value in the current session
   this.m_is_change_session_turnover_inc=false;          // Flag of total turnover change in the current session exceeding the growth value
   this.m_is_change_session_turnover_dec=false;          // Flag of total turnover change in the current session exceeding the decrease value
//--- The total volume of open positions
   this.m_changed_session_interest_value=0;              // Change value of the open positions total volume in the current session
   this.m_is_change_session_interest_inc=false;          // Flag of total open positions' volume change in the current session exceeding the growth value
   this.m_is_change_session_interest_dec=false;          // Flag of total open positions' volume change in the current session exceeding the decrease value
//--- The total volume of Buy orders at the moment
   this.m_changed_session_buy_ord_volume_value=0;        // Change value of the current total buy order volume
   this.m_is_change_session_buy_ord_volume_inc=false;    // Flag of changing the current total buy orders volume exceeding the growth value
   this.m_is_change_session_buy_ord_volume_dec=false;    // Flag of changing the current total buy orders volume exceeding the decrease value
//--- The total volume of Sell orders at the moment
   this.m_changed_session_sell_ord_volume_value=0;       // Change value of the current total sell order volume
   this.m_is_change_session_sell_ord_volume_inc=false;   // Flag of changing the current total sell orders volume exceeding the growth value
   this.m_is_change_session_sell_ord_volume_dec=false;   // Flag of changing the current total sell orders volume exceeding the decrease value
//--- Session open price
   this.m_changed_session_open_value=0;                  // Change value of the session open price
   this.m_is_change_session_open_inc=false;              // Flag of the session open price change exceeding the growth value
   this.m_is_change_session_open_dec=false;              // Flag of the session open price change exceeding the decrease value
//--- Session close price
   this.m_changed_session_close_value=0;                 // Change value of the session close price
   this.m_is_change_session_close_inc=false;             // Flag of the session close price change exceeding the growth value
   this.m_is_change_session_close_dec=false;             // Flag of the session close price change exceeding the decrease value
//--- The average weighted session price
   this.m_changed_session_aw_value=0;                    // Change value of the average weighted session price
   this.m_is_change_session_aw_inc=false;                // Flag of the average weighted session price change value exceeding the growth value
   this.m_is_change_session_aw_dec=false;                // Flag of the average weighted session price change value exceeding the decrease value
  }
//+------------------------------------------------------------------+
//| nitialize the variables of controlled symbol data                |
//+------------------------------------------------------------------+
void CSymbol::InitControlsParams(void)
  {
//--- Current session deals
   this.m_control_session_deals_inc=10;                  // Controlled value of the growth of the number of deals
   this.m_control_session_deals_dec=10;                  // Controlled value of the decrease in the number of deals
//--- Buy orders of the current session
   this.m_control_session_buy_ord_inc=10;                // Controlled value of the growth of the number of Buy orders
   this.m_control_session_buy_ord_dec=10;                // Controlled value of the decrease in the number of Buy orders
//--- Sell orders of the current session
   this.m_control_session_sell_ord_inc=10;               // Controlled value of the growth of the number of Sell orders
   this.m_control_session_sell_ord_dec=10;               // Controlled value of the decrease in the number of Sell orders
//--- Volume of the last deal
   this.m_control_volume_inc=10;                         // Controlled value of the volume growth in the last deal
   this.m_control_volume_dec=10;                         // Controlled value of the volume decrease in the last deal
//--- Maximum volume within a day
   this.m_control_volume_high_day_inc=50;                // Controlled value of the maximum volume growth for a day
   this.m_control_volume_high_day_dec=50;                // Controlled value of the maximum volume decrease for a day
//--- Minimum volume within a day
   this.m_control_volume_low_day_inc=50;                 // Controlled value of the minimum volume growth for a day

   this.m_control_volume_low_day_dec=50;                 // Controlled value of the minimum volume decrease for a day
//--- Spread
   this.m_control_spread_inc=2;                          // Controlled spread growth value in points
   this.m_control_spread_dec=2;                          // Controlled spread decrease value in points
//--- StopLevel
   this.m_control_stops_level_inc=2;                     // Controlled StopLevel growth value in points

   this.m_control_stops_level_dec=2;                     // Controlled StopLevel decrease value in points
//--- Freeze distance
   this.m_control_freeze_level_inc=2;                    // Controlled FreezeLevel growth value in points
   this.m_control_freeze_level_dec=2;                    // Controlled FreezeLevel decrease value in points
   
//--- Bid/Last
   this.m_control_bid_last_inc=DBL_MAX;                  // Controlled value of Bid or Last price growth
   this.m_control_bid_last_dec=DBL_MAX;                  // Controlled value of Bid or Last price decrease
//--- Maximum Bid/Last of the day
   this.m_control_bid_last_high_inc=DBL_MAX;             // Controlled growth value of the maximum Bid or Last price of the day
   this.m_control_bid_last_high_dec=DBL_MAX;             // Controlled decrease value of the maximum Bid or Last price of the day
//--- Minimum Bid/Last of the day
   this.m_control_bid_last_low_inc=DBL_MAX;              // Controlled growth value of the minimum Bid or Last price of the day
   this.m_control_bid_last_low_dec=DBL_MAX;              // Controlled decrease value of the minimum Bid or Last price of the day
//--- Ask
   this.m_control_ask_inc=DBL_MAX;                       // Controlled value of the Ask price growth
   this.m_control_ask_dec=DBL_MAX;                       // Controlled value of the Ask price decrease
//--- Maximum Ask price for the day
   this.m_control_ask_high_inc=DBL_MAX;                  // Controlled growth value of the maximum Ask price of the day
   this.m_control_ask_high_dec=DBL_MAX;                  // Controlled decrease value of the maximum Ask price of the day
//--- Minimum Ask price for the day
   this.m_control_ask_low_inc=DBL_MAX;                   // Controlled growth value of the minimum Ask price of the day
   this.m_control_ask_low_dec=DBL_MAX;                   // Controlled decrease value of the minimum Ask price of the day
//--- Real Volume for the day
   this.m_control_volume_real_inc=50;                    // Controlled value of the real volume growth of the day
   this.m_control_volume_real_dec=50;                    // Controlled value of the real volume decrease of the day
//--- Maximum real volume for the day
   this.m_control_volume_high_real_day_inc=20;           // Controlled value of the maximum real volume growth of the day
   this.m_control_volume_high_real_day_dec=20;           // Controlled value of the maximum real volume decrease of the day
//--- Minimum real volume for the day
   this.m_control_volume_low_real_day_inc=10;            // Controlled value of the minimum real volume growth of the day
   this.m_control_volume_low_real_day_dec=10;            // Controlled value of the minimum real volume decrease of the day
//--- Strike price
   this.m_control_option_strike_inc=0;                   // Controlled value of the strike price growth
   this.m_control_option_strike_dec=0;                   // Controlled value of the strike price decrease
//--- The total volume of deals in the current session
   this.m_control_session_volume_inc=10;                 // Controlled value of the total trade volume growth in the current session
   this.m_control_session_volume_dec=10;                 // Controlled value of the total trade volume decrease in the current session
//--- The total turnover in the current session
   this.m_control_session_turnover_inc=1000;             // Controlled value of the total turnover growth in the current session
   this.m_control_session_turnover_dec=500;              // Controlled value of the total turnover decrease in the current session
//--- The total volume of open positions
   this.m_control_session_interest_inc=50;               // Controlled value of the total open position volume growth in the current session
   this.m_control_session_interest_dec=20;               // Controlled value of the total open position volume decrease in the current session
//--- The total volume of Buy orders at the moment
   this.m_control_session_buy_ord_volume_inc=50;         // Controlled value of the current total buy order volume growth
   this.m_control_session_buy_ord_volume_dec=20;         // Controlled value of the current total buy order volume decrease
//--- The total volume of Sell orders at the moment
   this.m_control_session_sell_ord_volume_inc=50;        // Controlled value of the current total sell order volume growth
   this.m_control_session_sell_ord_volume_dec=20;        // Controlled value of the current total sell order volume decrease
//--- Session open price
   this.m_control_session_open_inc=0;                    // Controlled value of the session open price growth
   this.m_control_session_open_dec=0;                    // Controlled value of the session open price decrease
//--- Session close price
   this.m_control_session_close_inc=0;                   // Controlled value of the session close price growth
   this.m_control_session_close_dec=0;                   // Controlled value of the session close price decrease
//--- The average weighted session price
   this.m_control_session_aw_inc=0;                      // Controlled value of the average weighted session price growth
   this.m_control_session_aw_dec=0;                      // Controlled value of the average weighted session price decrease
  }
//+------------------------------------------------------------------+
//| Check symbol changes, return a change code                       |
//+------------------------------------------------------------------+
int CSymbol::SetEventCode(void)
  {
   this.m_event_code=SYMBOL_EVENT_FLAG_NO_EVENT;

   if(this.m_struct_curr_symbol.trade_mode!=this.m_struct_prev_symbol.trade_mode)
      this.m_event_code+=SYMBOL_EVENT_FLAG_TRADE_MODE;
   if(this.m_struct_curr_symbol.session_deals!=this.m_struct_prev_symbol.session_deals)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_DEALS;
   if(this.m_struct_curr_symbol.session_buy_orders!=this.m_struct_prev_symbol.session_buy_orders)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_BUY_ORDERS;
   if(this.m_struct_curr_symbol.session_sell_orders!=this.m_struct_prev_symbol.session_sell_orders)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_SELL_ORDERS;
   if(this.m_struct_curr_symbol.volume!=this.m_struct_prev_symbol.volume)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME;
   if(this.m_struct_curr_symbol.volume_high_day!=this.m_struct_prev_symbol.volume_high_day)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_HIGH_DAY;
   if(this.m_struct_curr_symbol.volume_low_day!=this.m_struct_prev_symbol.volume_low_day)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_LOW_DAY;
   if(this.m_struct_curr_symbol.spread!=this.m_struct_prev_symbol.spread)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SPREAD;
   if(this.m_struct_curr_symbol.stops_level!=this.m_struct_prev_symbol.stops_level)
      this.m_event_code+=SYMBOL_EVENT_FLAG_STOPLEVEL;
   if(this.m_struct_curr_symbol.freeze_level!=this.m_struct_prev_symbol.freeze_level)
      this.m_event_code+=SYMBOL_EVENT_FLAG_FREEZELEVEL;

   if(this.m_struct_curr_symbol.bid_last!=this.m_struct_prev_symbol.bid_last)
      this.m_event_code+=SYMBOL_EVENT_FLAG_BID_LAST;
   if(this.m_struct_curr_symbol.bid_last_high!=this.m_struct_prev_symbol.bid_last_high)
      this.m_event_code+=SYMBOL_EVENT_FLAG_BID_LAST_HIGH;
   if(this.m_struct_curr_symbol.bid_last_low!=this.m_struct_prev_symbol.bid_last_low)
      this.m_event_code+=SYMBOL_EVENT_FLAG_BID_LAST_LOW;
   if(this.m_struct_curr_symbol.ask!=this.m_struct_prev_symbol.ask)
      this.m_event_code+=SYMBOL_EVENT_FLAG_ASK;
   if(this.m_struct_curr_symbol.ask_high!=this.m_struct_prev_symbol.ask_high)
      this.m_event_code+=SYMBOL_EVENT_FLAG_ASK_HIGH;
   if(this.m_struct_curr_symbol.ask_low!=this.m_struct_prev_symbol.ask_low)
      this.m_event_code+=SYMBOL_EVENT_FLAG_ASK_LOW;
   if(this.m_struct_curr_symbol.volume_real_day!=this.m_struct_prev_symbol.volume_real_day)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_REAL_DAY;
   if(this.m_struct_curr_symbol.volume_high_real_day!=this.m_struct_prev_symbol.volume_high_real_day)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_HIGH_REAL_DAY;
   if(this.m_struct_curr_symbol.volume_low_real_day!=this.m_struct_prev_symbol.volume_low_real_day)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_LOW_REAL_DAY;
   if(this.m_struct_curr_symbol.option_strike!=this.m_struct_prev_symbol.option_strike)
      this.m_event_code+=SYMBOL_EVENT_FLAG_OPTION_STRIKE;
   if(this.m_struct_curr_symbol.volume_limit!=this.m_struct_prev_symbol.volume_limit)
      this.m_event_code+=SYMBOL_EVENT_FLAG_VOLUME_LIMIT;
   if(this.m_struct_curr_symbol.swap_long!=this.m_struct_prev_symbol.swap_long)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SWAP_LONG;
   if(this.m_struct_curr_symbol.swap_short!=this.m_struct_prev_symbol.swap_short)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SWAP_SHORT;
   if(this.m_struct_curr_symbol.session_volume!=this.m_struct_prev_symbol.session_volume)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_VOLUME;
   if(this.m_struct_curr_symbol.session_turnover!=this.m_struct_prev_symbol.session_turnover)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_TURNOVER;
   if(this.m_struct_curr_symbol.session_interest!=this.m_struct_prev_symbol.session_interest)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_INTEREST;
   if(this.m_struct_curr_symbol.session_buy_ord_volume!=this.m_struct_prev_symbol.session_buy_ord_volume)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_BUY_ORD_VOLUME;
   if(this.m_struct_curr_symbol.session_sell_ord_volume!=this.m_struct_prev_symbol.session_sell_ord_volume)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_SELL_ORD_VOLUME;
   if(this.m_struct_curr_symbol.session_open!=this.m_struct_prev_symbol.session_open)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_OPEN;
   if(this.m_struct_curr_symbol.session_close!=this.m_struct_prev_symbol.session_close)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_CLOSE;
   if(this.m_struct_curr_symbol.session_aw!=this.m_struct_prev_symbol.session_aw)
      this.m_event_code+=SYMBOL_EVENT_FLAG_SESSION_AW;
//---
   return this.m_event_code;
  }
//+------------------------------------------------------------------+
//| Set a symbol object event type                                   |
//+------------------------------------------------------------------+
void CSymbol::SetTypeEvent(void)
  {
   this.InitChangesParams();
   ENUM_SYMBOL_EVENT event_id=SYMBOL_EVENT_NO_EVENT;
//--- Change of trading modes on a symbol
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_TRADE_MODE))
     {
      event_id=
        (
         this.TradeMode()==SYMBOL_TRADE_MODE_DISABLED  ? SYMBOL_EVENT_TRADE_DISABLE    :
         this.TradeMode()==SYMBOL_TRADE_MODE_LONGONLY  ? SYMBOL_EVENT_TRADE_LONGONLY   :
         this.TradeMode()==SYMBOL_TRADE_MODE_SHORTONLY ? SYMBOL_EVENT_TRADE_SHORTONLY  :
         this.TradeMode()==SYMBOL_TRADE_MODE_CLOSEONLY ? SYMBOL_EVENT_TRADE_CLOSEONLY  :
         SYMBOL_EVENT_TRADE_FULL
        );
      this.m_is_change_trade_mode=true;
      if(this.EventAdd(event_id,this.TickTime(),this.TradeMode(),this.Name()))
         this.m_struct_prev_symbol.trade_mode=this.m_struct_curr_symbol.trade_mode;
     }
//--- Change of the number of deals in the current session
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_DEALS))
     {
      this.m_changed_session_deals_value=this.m_struct_curr_symbol.session_deals-this.m_struct_prev_symbol.session_deals;
      if(this.m_changed_session_deals_value>this.m_control_session_deals_inc)
        {
         this.m_is_change_session_deals_inc=true;
         event_id=SYMBOL_EVENT_SESSION_DEALS_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_deals_value,this.Name()))
            this.m_struct_prev_symbol.session_deals=this.m_struct_curr_symbol.session_deals;
        }
      else if(this.m_changed_session_deals_value<-this.m_control_session_deals_dec)
        {
         this.m_is_change_session_deals_dec=true;
         event_id=SYMBOL_EVENT_SESSION_DEALS_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_deals_value,this.Name()))
            this.m_struct_prev_symbol.session_deals=this.m_struct_curr_symbol.session_deals;
        }
     }
//--- Change of the total number of the current buy orders
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_BUY_ORDERS))
     {
      this.m_changed_session_buy_ord_value=this.m_struct_curr_symbol.session_buy_orders-this.m_struct_prev_symbol.session_buy_orders;
      if(this.m_changed_session_buy_ord_value>this.m_control_session_buy_ord_inc)
        {
         this.m_is_change_session_buy_ord_inc=true;
         event_id=SYMBOL_EVENT_SESSION_BUY_ORDERS_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_buy_ord_value,this.Name()))
            this.m_struct_prev_symbol.session_buy_orders=this.m_struct_curr_symbol.session_buy_orders;
        }
      else if(this.m_changed_session_buy_ord_value<-this.m_control_session_buy_ord_dec)
        {
         this.m_is_change_session_buy_ord_dec=true;
         event_id=SYMBOL_EVENT_SESSION_BUY_ORDERS_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_buy_ord_value,this.Name()))
            this.m_struct_prev_symbol.session_buy_orders=this.m_struct_curr_symbol.session_buy_orders;
        }
     }
//--- Change of the total number of the current sell orders
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_SELL_ORDERS))
     {
      this.m_changed_session_sell_ord_value=this.m_struct_curr_symbol.session_sell_orders-this.m_struct_prev_symbol.session_sell_orders;
      if(this.m_changed_session_sell_ord_value>this.m_control_session_sell_ord_inc)
        {
         this.m_is_change_session_sell_ord_inc=true;
         event_id=SYMBOL_EVENT_SESSION_SELL_ORDERS_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_sell_ord_value,this.Name()))
            this.m_struct_prev_symbol.session_sell_orders=this.m_struct_curr_symbol.session_sell_orders;
        }
      else if(this.m_changed_session_sell_ord_value<-this.m_control_session_sell_ord_dec)
        {
         this.m_is_change_session_sell_ord_dec=true;
         event_id=SYMBOL_EVENT_SESSION_SELL_ORDERS_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_sell_ord_value,this.Name()))
            this.m_struct_prev_symbol.session_sell_orders=this.m_struct_curr_symbol.session_sell_orders;
        }
     }
//--- Volume change in the last deal
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME))
     {
      this.m_changed_volume_value=this.m_struct_curr_symbol.volume-this.m_struct_prev_symbol.volume;
      if(this.m_changed_volume_value>this.m_control_volume_inc)
        {
         this.m_is_change_volume_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_value,this.Name()))
            this.m_struct_prev_symbol.volume=this.m_struct_curr_symbol.volume;
        }
      else if(this.m_changed_volume_value<-this.m_control_volume_dec)
        {
         this.m_is_change_volume_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_value,this.Name()))
            this.m_struct_prev_symbol.volume=this.m_struct_curr_symbol.volume;
        }
     }
//--- Maximum volume change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_HIGH_DAY))
     {
      this.m_changed_volume_high_day_value=this.m_struct_curr_symbol.volume_high_day-this.m_struct_prev_symbol.volume_high_day;
      if(this.m_changed_volume_high_day_value>this.m_control_volume_high_day_inc)
        {
         this.m_is_change_volume_high_day_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_HIGH_DAY_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_high_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_high_day=this.m_struct_curr_symbol.volume_high_day;
        }
      else if(this.m_changed_volume_high_day_value<-this.m_control_volume_high_day_dec)
        {
         this.m_is_change_volume_high_day_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_HIGH_DAY_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_high_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_high_day=this.m_struct_curr_symbol.volume_high_day;
        }
     }
//--- Minimum volume change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_LOW_DAY))
     {
      this.m_changed_volume_low_day_value=this.m_struct_curr_symbol.volume_low_day-this.m_struct_prev_symbol.volume_low_day;
      if(this.m_changed_volume_low_day_value>this.m_control_volume_low_day_inc)
        {
         this.m_is_change_volume_low_day_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_LOW_DAY_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_low_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_low_day=this.m_struct_curr_symbol.volume_low_day;
        }
      else if(this.m_changed_volume_low_day_value<-this.m_control_volume_low_day_dec)
        {
         this.m_is_change_volume_low_day_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_LOW_DAY_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_low_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_low_day=this.m_struct_curr_symbol.volume_low_day;
        }
     }
//--- Spread value change in points
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SPREAD))
     {
      this.m_changed_spread_value=this.m_struct_curr_symbol.spread-this.m_struct_prev_symbol.spread;
      if(this.m_changed_spread_value>this.m_control_spread_inc)
        {
         this.m_is_change_spread_inc=true;
         event_id=SYMBOL_EVENT_SPREAD_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_spread_value,this.Name()))
            this.m_struct_prev_symbol.spread=this.m_struct_curr_symbol.spread;
        }
      else if(this.m_changed_spread_value<-this.m_control_spread_dec)
        {
         this.m_is_change_spread_dec=true;
         event_id=SYMBOL_EVENT_SPREAD_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_spread_value,this.Name()))
            this.m_struct_prev_symbol.spread=this.m_struct_curr_symbol.spread;
        }
     }
//--- StopLevel change in points
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_STOPLEVEL))
     {
      this.m_changed_stops_level_value=this.m_struct_curr_symbol.stops_level-this.m_struct_prev_symbol.stops_level;
      if(this.m_changed_stops_level_value>this.m_control_stops_level_inc)
        {
         this.m_is_change_stops_level_inc=true;
         event_id=SYMBOL_EVENT_STOPLEVEL_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_stops_level_value,this.Name()))
            this.m_struct_prev_symbol.stops_level=this.m_struct_curr_symbol.stops_level;
        }
      else if(this.m_changed_stops_level_value<-this.m_control_stops_level_dec)
        {
         this.m_is_change_stops_level_dec=true;
         event_id=SYMBOL_EVENT_STOPLEVEL_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_stops_level_value,this.Name()))
            this.m_struct_prev_symbol.stops_level=this.m_struct_curr_symbol.stops_level;
        }
     }
//--- FreezeLevel change in points
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_FREEZELEVEL))
     {
      this.m_changed_freeze_level_value=this.m_struct_curr_symbol.freeze_level-this.m_struct_prev_symbol.freeze_level;
      if(this.m_changed_freeze_level_value>this.m_control_freeze_level_inc)
        {
         this.m_is_change_freeze_level_inc=true;
         event_id=SYMBOL_EVENT_FREEZELEVEL_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_freeze_level_value,this.Name()))
            this.m_struct_prev_symbol.freeze_level=this.m_struct_curr_symbol.freeze_level;
        }
      else if(this.m_changed_freeze_level_value<-this.m_control_freeze_level_dec)
        {
         this.m_is_change_freeze_level_dec=true;
         event_id=SYMBOL_EVENT_FREEZELEVEL_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_freeze_level_value,this.Name()))
            this.m_struct_prev_symbol.freeze_level=this.m_struct_curr_symbol.freeze_level;
        }
     }
//--- Bid/Last price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_BID_LAST))
     {
      this.m_changed_bid_last_value=this.m_struct_curr_symbol.bid_last-this.m_struct_prev_symbol.bid_last;
      if(this.m_changed_bid_last_value>this.m_control_bid_last_inc)
        {
         this.m_is_change_bid_last_inc=true;
         event_id=SYMBOL_EVENT_BID_LAST_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_value,this.Name()))
            this.m_struct_prev_symbol.bid_last=this.m_struct_curr_symbol.bid_last;
        }
      else if(this.m_changed_bid_last_value<-this.m_control_bid_last_dec)
        {
         this.m_is_change_bid_last_dec=true;
         event_id=SYMBOL_EVENT_BID_LAST_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_value,this.Name()))
            this.m_struct_prev_symbol.bid_last=this.m_struct_curr_symbol.bid_last;
        }
     }
//--- Maximum Bid/Last change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_BID_LAST_HIGH))
     {
      this.m_changed_bid_last_high_value=this.m_struct_curr_symbol.bid_last_high-this.m_struct_prev_symbol.bid_last_high;
      if(this.m_changed_bid_last_high_value>this.m_control_bid_last_high_inc)
        {
         this.m_is_change_bid_last_high_inc=true;
         event_id=SYMBOL_EVENT_BID_LAST_HIGH_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_high_value,this.Name()))
            this.m_struct_prev_symbol.bid_last_high=this.m_struct_curr_symbol.bid_last_high;
        }
      else if(this.m_changed_bid_last_high_value<-this.m_control_bid_last_high_dec)
        {
         this.m_is_change_bid_last_high_dec=true;
         event_id=SYMBOL_EVENT_BID_LAST_HIGH_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_high_value,this.Name()))
            this.m_struct_prev_symbol.bid_last_high=this.m_struct_curr_symbol.bid_last_high;
        }
     }
//--- Minimum Bid/Last change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_BID_LAST_LOW))
     {
      this.m_changed_bid_last_low_value=this.m_struct_curr_symbol.bid_last_low-this.m_struct_prev_symbol.bid_last_low;
      if(this.m_changed_bid_last_low_value>this.m_control_bid_last_low_inc)
        {
         this.m_is_change_bid_last_low_inc=true;
         event_id=SYMBOL_EVENT_BID_LAST_LOW_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_low_value,this.Name()))
            this.m_struct_prev_symbol.bid_last_low=this.m_struct_curr_symbol.bid_last_low;
        }
      else if(this.m_changed_bid_last_low_value<-this.m_control_bid_last_low_dec)
        {
         this.m_is_change_bid_last_low_dec=true;
         event_id=SYMBOL_EVENT_BID_LAST_LOW_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_bid_last_low_value,this.Name()))
            this.m_struct_prev_symbol.bid_last_low=this.m_struct_curr_symbol.bid_last_low;
        }
     }
//--- Ask price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_ASK))
     {
      this.m_changed_ask_value=this.m_struct_curr_symbol.ask-this.m_struct_prev_symbol.ask;
      if(this.m_changed_ask_value>this.m_control_ask_inc)
        {
         this.m_is_change_ask_inc=true;
         event_id=SYMBOL_EVENT_ASK_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_value,this.Name()))
            this.m_struct_prev_symbol.ask=this.m_struct_curr_symbol.ask;
        }
      else if(this.m_changed_ask_value<-this.m_control_ask_dec)
        {
         this.m_is_change_ask_dec=true;
         event_id=SYMBOL_EVENT_ASK_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_value,this.Name()))
            this.m_struct_prev_symbol.ask=this.m_struct_curr_symbol.ask;
        }
     }
//--- Maximum As change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_ASK_HIGH))
     {
      this.m_changed_ask_high_value=this.m_struct_curr_symbol.ask_high-this.m_struct_prev_symbol.ask_high;
      if(this.m_changed_ask_high_value>this.m_control_ask_high_inc)
        {
         this.m_is_change_ask_high_inc=true;
         event_id=SYMBOL_EVENT_ASK_HIGH_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_high_value,this.Name()))
            this.m_struct_prev_symbol.ask_high=this.m_struct_curr_symbol.ask_high;
        }
      else if(this.m_changed_ask_high_value<-this.m_control_ask_high_dec)
        {
         this.m_is_change_ask_high_dec=true;
         event_id=SYMBOL_EVENT_ASK_HIGH_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_high_value,this.Name()))
            this.m_struct_prev_symbol.ask_high=this.m_struct_curr_symbol.ask_high;
        }
     }
//--- Minimum Ask change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_ASK_LOW))
     {
      this.m_changed_ask_low_value=this.m_struct_curr_symbol.ask_low-this.m_struct_prev_symbol.ask_low;
      if(this.m_changed_ask_low_value>this.m_control_ask_low_inc)
        {
         this.m_is_change_ask_low_inc=true;
         event_id=SYMBOL_EVENT_ASK_LOW_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_low_value,this.Name()))
            this.m_struct_prev_symbol.ask_low=this.m_struct_curr_symbol.ask_low;
        }
      else if(this.m_changed_ask_low_value<-this.m_control_ask_low_dec)
        {
         this.m_is_change_ask_low_dec=true;
         event_id=SYMBOL_EVENT_ASK_LOW_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_ask_low_value,this.Name()))
            this.m_struct_prev_symbol.ask_low=this.m_struct_curr_symbol.ask_low;
        }
     }
//--- Real volume change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_REAL_DAY))
     {
      this.m_changed_volume_real_value=this.m_struct_curr_symbol.volume_real_day-this.m_struct_prev_symbol.volume_real_day;
      if(this.m_changed_volume_real_value>this.m_control_volume_real_inc)
        {
         this.m_is_change_volume_real_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_REAL_DAY_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_real_value,this.Name()))
            this.m_struct_prev_symbol.volume_real_day=this.m_struct_curr_symbol.volume_real_day;
        }
      else if(this.m_changed_volume_real_value<-this.m_control_volume_real_dec)
        {
         this.m_is_change_volume_real_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_REAL_DAY_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_real_value,this.Name()))
            this.m_struct_prev_symbol.volume_real_day=this.m_struct_curr_symbol.volume_real_day;
        }
     }
//--- Maximum real volume change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_HIGH_REAL_DAY))
     {
      this.m_changed_volume_high_real_day_value=this.m_struct_curr_symbol.volume_high_real_day-this.m_struct_prev_symbol.volume_high_real_day;
      if(this.m_changed_volume_high_real_day_value>this.m_control_volume_high_real_day_inc)
        {
         this.m_is_change_volume_high_real_day_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_HIGH_REAL_DAY_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_high_real_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_high_real_day=this.m_struct_curr_symbol.volume_high_real_day;
        }
      else if(this.m_changed_volume_high_real_day_value<-this.m_control_volume_high_real_day_dec)
        {
         this.m_is_change_volume_high_real_day_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_HIGH_REAL_DAY_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_high_real_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_high_real_day=this.m_struct_curr_symbol.volume_high_real_day;
        }
     }
//--- Minimum real volume change for a day
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_LOW_REAL_DAY))
     {
      this.m_changed_volume_low_real_day_value=this.m_struct_curr_symbol.volume_low_real_day-this.m_struct_prev_symbol.volume_low_real_day;
      if(this.m_changed_volume_low_real_day_value>this.m_control_volume_low_real_day_inc)
        {
         this.m_is_change_volume_low_real_day_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_LOW_REAL_DAY_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_low_real_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_low_real_day=this.m_struct_curr_symbol.volume_low_real_day;
        }
      else if(this.m_changed_volume_low_real_day_value<-this.m_control_volume_low_real_day_dec)
        {
         this.m_is_change_volume_low_real_day_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_LOW_REAL_DAY_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_low_real_day_value,this.Name()))
            this.m_struct_prev_symbol.volume_low_real_day=this.m_struct_curr_symbol.volume_low_real_day;
        }
     }
//--- Strike price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_OPTION_STRIKE))
     {
      this.m_changed_option_strike_value=this.m_struct_curr_symbol.option_strike-this.m_struct_prev_symbol.option_strike;
      if(this.m_changed_option_strike_value>this.m_control_option_strike_inc)
        {
         this.m_is_change_option_strike_inc=true;
         event_id=SYMBOL_EVENT_OPTION_STRIKE_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_option_strike_value,this.Name()))
            this.m_struct_prev_symbol.option_strike=this.m_struct_curr_symbol.option_strike;
        }
      else if(this.m_changed_option_strike_value<-this.m_control_option_strike_dec)
        {
         this.m_is_change_option_strike_dec=true;
         event_id=SYMBOL_EVENT_OPTION_STRIKE_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_option_strike_value,this.Name()))
            this.m_struct_prev_symbol.option_strike=this.m_struct_curr_symbol.option_strike;
        }
     }
//--- Change of the maximum available total position volume and pending orders in one direction
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_VOLUME_LIMIT))
     {
      this.m_changed_volume_limit_value=this.m_struct_curr_symbol.volume_limit-this.m_struct_prev_symbol.volume_limit;
      if(this.m_changed_volume_limit_value>0)
        {
         this.m_is_change_volume_limit_inc=true;
         event_id=SYMBOL_EVENT_VOLUME_LIMIT_INC;
        }
      else
        {
         this.m_is_change_volume_limit_dec=true;
         event_id=SYMBOL_EVENT_VOLUME_LIMIT_DEC;
        }
      if(this.EventAdd(event_id,this.TickTime(),this.m_changed_volume_limit_value,this.Name()))
         this.m_struct_prev_symbol.volume_limit=this.m_struct_curr_symbol.volume_limit;
     }
//--- Swap long change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SWAP_LONG))
     {
      this.m_changed_swap_long_value=this.m_struct_curr_symbol.swap_long-this.m_struct_prev_symbol.swap_long;
      if(this.m_changed_swap_long_value>0)
        {
         this.m_is_change_swap_long_inc=true;
         event_id=SYMBOL_EVENT_SWAP_LONG_INC;
        }
      else
        {
         this.m_is_change_swap_long_dec=true;
         event_id=SYMBOL_EVENT_SWAP_LONG_DEC;
        }
      if(this.EventAdd(event_id,this.TickTime(),this.m_changed_swap_long_value,this.Name()))
         this.m_struct_prev_symbol.swap_long=this.m_struct_curr_symbol.swap_long;
     }
//--- Swap short change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SWAP_SHORT))
     {
      this.m_changed_swap_short_value=this.m_struct_curr_symbol.swap_short-this.m_struct_prev_symbol.swap_short;
      if(this.m_changed_swap_short_value>0)
        {
         this.m_is_change_swap_short_inc=true;
         event_id=SYMBOL_EVENT_SWAP_SHORT_INC;
        }
      else
        {
         this.m_is_change_swap_short_dec=true;
         event_id=SYMBOL_EVENT_SWAP_SHORT_DEC;
        }
      if(this.EventAdd(event_id,this.TickTime(),this.m_changed_swap_short_value,this.Name()))
         this.m_struct_prev_symbol.swap_short=this.m_struct_curr_symbol.swap_short;
     }
//--- Change of the total volume of deals during the current session
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_VOLUME))
     {
      this.m_changed_session_volume_value=this.m_struct_curr_symbol.session_volume-this.m_struct_prev_symbol.session_volume;
      if(this.m_changed_session_volume_value>this.m_control_session_volume_inc)
        {
         this.m_is_change_session_volume_inc=true;
         event_id=SYMBOL_EVENT_SESSION_VOLUME_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_volume=this.m_struct_curr_symbol.session_volume;
        }
      else if(this.m_changed_session_volume_value<-this.m_control_session_volume_dec)
        {
         this.m_is_change_session_volume_dec=true;
         event_id=SYMBOL_EVENT_SESSION_VOLUME_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_volume=this.m_struct_curr_symbol.session_volume;
        }
     }
//--- Change of the total turnover during the current session
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_TURNOVER))
     {
      this.m_changed_session_turnover_value=this.m_struct_curr_symbol.session_turnover-this.m_struct_prev_symbol.session_turnover;
      if(this.m_changed_session_turnover_value>this.m_control_session_turnover_inc)
        {
         this.m_is_change_session_turnover_inc=true;
         event_id=SYMBOL_EVENT_SESSION_TURNOVER_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_turnover_value,this.Name()))
            this.m_struct_prev_symbol.session_turnover=this.m_struct_curr_symbol.session_turnover;
        }
      else if(this.m_changed_session_turnover_value<-this.m_control_session_turnover_dec)
        {
         this.m_is_change_session_turnover_dec=true;
         event_id=SYMBOL_EVENT_SESSION_TURNOVER_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_turnover_value,this.Name()))
            this.m_struct_prev_symbol.session_turnover=this.m_struct_curr_symbol.session_turnover;
        }
     }
//--- Change of the total volume of open positions during the current session
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_INTEREST))
     {
      this.m_changed_session_interest_value=this.m_struct_curr_symbol.session_interest-this.m_struct_prev_symbol.session_interest;
      if(this.m_changed_session_interest_value>this.m_control_session_interest_inc)
        {
         this.m_is_change_session_interest_inc=true;
         event_id=SYMBOL_EVENT_SESSION_INTEREST_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_interest_value,this.Name()))
            this.m_struct_prev_symbol.session_interest=this.m_struct_curr_symbol.session_interest;
        }
      else if(this.m_changed_session_interest_value<-this.m_control_session_interest_dec)
        {
         this.m_is_change_session_interest_dec=true;
         event_id=SYMBOL_EVENT_SESSION_INTEREST_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_interest_value,this.Name()))
            this.m_struct_prev_symbol.session_interest=this.m_struct_curr_symbol.session_interest;
        }
     }
//--- Change of the current total volume of buy orders
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_BUY_ORD_VOLUME))
     {
      this.m_changed_session_buy_ord_volume_value=this.m_struct_curr_symbol.session_buy_ord_volume-this.m_struct_prev_symbol.session_buy_ord_volume;
      if(this.m_changed_session_buy_ord_volume_value>this.m_control_session_buy_ord_volume_inc)
        {
         this.m_is_change_session_buy_ord_volume_inc=true;
         event_id=SYMBOL_EVENT_SESSION_BUY_ORD_VOLUME_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_buy_ord_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_buy_ord_volume=this.m_struct_curr_symbol.session_buy_ord_volume;
        }
      else if(this.m_changed_session_buy_ord_volume_value<-this.m_control_session_buy_ord_volume_dec)
        {
         this.m_is_change_session_buy_ord_volume_dec=true;
         event_id=SYMBOL_EVENT_SESSION_BUY_ORD_VOLUME_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_buy_ord_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_buy_ord_volume=this.m_struct_curr_symbol.session_buy_ord_volume;
        }
     }
//--- Change of the current total volume of sell orders
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_SELL_ORD_VOLUME))
     {
      this.m_changed_session_sell_ord_volume_value=this.m_struct_curr_symbol.session_sell_ord_volume-this.m_struct_prev_symbol.session_sell_ord_volume;
      if(this.m_changed_session_sell_ord_volume_value>this.m_control_session_sell_ord_volume_inc)
        {
         this.m_is_change_session_sell_ord_volume_inc=true;
         event_id=SYMBOL_EVENT_SESSION_SELL_ORD_VOLUME_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_sell_ord_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_sell_ord_volume=this.m_struct_curr_symbol.session_sell_ord_volume;
        }
      else if(this.m_changed_session_sell_ord_volume_value<-this.m_control_session_sell_ord_volume_dec)
        {
         this.m_is_change_session_sell_ord_volume_dec=true;
         event_id=SYMBOL_EVENT_SESSION_SELL_ORD_VOLUME_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_sell_ord_volume_value,this.Name()))
            this.m_struct_prev_symbol.session_sell_ord_volume=this.m_struct_curr_symbol.session_sell_ord_volume;
        }
     }
//--- Session open price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_OPEN))
     {
      this.m_changed_session_open_value=this.m_struct_curr_symbol.session_open-this.m_struct_prev_symbol.session_open;
      if(this.m_changed_session_open_value>this.m_control_session_open_inc)
        {
         this.m_is_change_session_open_inc=true;
         event_id=SYMBOL_EVENT_SESSION_OPEN_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_open_value,this.Name()))
            this.m_struct_prev_symbol.session_open=this.m_struct_curr_symbol.session_open;
        }
      else if(this.m_changed_session_open_value<-this.m_control_session_open_dec)
        {
         this.m_is_change_session_open_dec=true;
         event_id=SYMBOL_EVENT_SESSION_OPEN_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_open_value,this.Name()))
            this.m_struct_prev_symbol.session_open=this.m_struct_curr_symbol.session_open;
        }
     }
//--- Session close price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_CLOSE))
     {
      this.m_changed_session_close_value=this.m_struct_curr_symbol.session_close-this.m_struct_prev_symbol.session_close;
      if(this.m_changed_session_close_value>this.m_control_session_close_inc)
        {
         this.m_is_change_session_close_inc=true;
         event_id=SYMBOL_EVENT_SESSION_CLOSE_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_close_value,this.Name()))
            this.m_struct_prev_symbol.session_close=this.m_struct_curr_symbol.session_close;
        }
      else if(this.m_changed_session_close_value<-this.m_control_session_close_dec)
        {
         this.m_is_change_session_close_dec=true;
         event_id=SYMBOL_EVENT_SESSION_CLOSE_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_close_value,this.Name()))
            this.m_struct_prev_symbol.session_close=this.m_struct_curr_symbol.session_close;
        }
     }
//--- Average weighted session price change
   if(this.IsPresentEventFlag(SYMBOL_EVENT_FLAG_SESSION_AW))
     {
      this.m_changed_session_aw_value=this.m_struct_curr_symbol.session_aw-this.m_struct_prev_symbol.session_aw;
      if(this.m_changed_session_aw_value>this.m_control_session_aw_inc)
        {
         this.m_is_change_session_aw_inc=true;
         event_id=SYMBOL_EVENT_SESSION_AW_INC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_aw_value,this.Name()))
            this.m_struct_prev_symbol.session_aw=this.m_struct_curr_symbol.session_aw;
        }
      else if(this.m_changed_session_aw_value<-this.m_control_session_aw_dec)
        {
         this.m_is_change_session_aw_dec=true;
         event_id=SYMBOL_EVENT_SESSION_AW_DEC;
         if(this.EventAdd(event_id,this.TickTime(),this.m_changed_session_aw_value,this.Name()))
            this.m_struct_prev_symbol.session_aw=this.m_struct_curr_symbol.session_aw;
        }
     }
  }
//+------------------------------------------------------------------+
//| Return the symbol event description                              |
//+------------------------------------------------------------------+
string CSymbol::EventDescription(const ENUM_SYMBOL_EVENT event)
  {
   string price_bid_last=(this.ChartMode()==SYMBOL_CHART_MODE_BID ? TextByLanguage("Цена Bid","Price Bid") : TextByLanguage("Цена Last","Price Last"));
   string price_bid_last_high=(this.ChartMode()==SYMBOL_CHART_MODE_BID ? TextByLanguage("Максимальная цена Bid за день","Maximal Bid price per day") : TextByLanguage("Максимальная цена Last за день","Maximal Last price per day"));
   string price_bid_last_low=(this.ChartMode()==SYMBOL_CHART_MODE_BID ? TextByLanguage("Минимальная цена Bid за день","Minimal Bid price per day") : TextByLanguage("Минимальная цена Last за день","Minimal Last price per day"));
   return
     (
      event==SYMBOL_EVENT_NO_EVENT                    ?  TextByLanguage("Нет события","No event")  :
      event==SYMBOL_EVENT_TRADE_DISABLE               ?  TextByLanguage("Торговля на символе отключена","Trading on the symbol is disabled")                :
      event==SYMBOL_EVENT_TRADE_LONGONLY              ?  TextByLanguage("Разрешены только длинные позиции","Only long positions allowed")                   :
      event==SYMBOL_EVENT_TRADE_SHORTONLY             ?  TextByLanguage("Разрешены только короткие позиции","Only short positions allowed")                 :
      event==SYMBOL_EVENT_TRADE_CLOSEONLY             ?  TextByLanguage("Разрешены только операции закрытия позиций","Only closing positions allowed")  :
      event==SYMBOL_EVENT_TRADE_FULL                  ?  TextByLanguage("Все торговые операции разрешены","All trading operations allowed")             :
      event==SYMBOL_EVENT_SESSION_DEALS_INC           ?
         TextByLanguage("Количество сделок в текущей сессии увеличено на ","Number of deals in the current session increased by ")+(string)this.GetValueChangedSessionDeals()+" ("+(string)this.SessionDeals()+")"                                                                        :
      event==SYMBOL_EVENT_SESSION_DEALS_DEC           ?
         TextByLanguage("Количество сделок в текущей сессии уменьшено на ","Number of deals in the current session decreased by ")+(string)this.GetValueChangedSessionDeals()+" ("+(string)this.SessionDeals()+")"                                                                        :

      event==SYMBOL_EVENT_SESSION_BUY_ORDERS_INC      ?
         TextByLanguage("Общее числа ордеров на покупку в текущий момент увеличено на ","Number of Buy orders at the moment increased by ")+(string)this.GetValueChangedSessionBuyOrders()+" ("+(string)this.SessionBuyOrders()+")"                                                       :
      event==SYMBOL_EVENT_SESSION_BUY_ORDERS_DEC      ?
         TextByLanguage("Общее числа ордеров на покупку в текущий момент уменьшено на ","Number of Buy orders at the moment decreased by ")+(string)this.GetValueChangedSessionBuyOrders()+" ("+(string)this.SessionBuyOrders()+")"                                                       :

      event==SYMBOL_EVENT_SESSION_SELL_ORDERS_INC     ?
         TextByLanguage("Общее числа ордеров на продажу в текущий момент увеличено на ","Number of Sell orders at the moment increased by ")+(string)this.GetValueChangedSessionSellOrders()+" ("+(string)this.SessionSellOrders()+")"                                                    :
      event==SYMBOL_EVENT_SESSION_SELL_ORDERS_DEC     ?
         TextByLanguage("Общее числа ордеров на продажу в текущий момент уменьшено на ","Number of Sell orders at the moment decreased by ")+(string)this.GetValueChangedSessionSellOrders()+" ("+(string)this.SessionSellOrders()+")"                                                    :

      event==SYMBOL_EVENT_VOLUME_INC                  ?
         TextByLanguage("Объём в последней сделке увеличен на ","Volume of the last deal increased by ")+(string)this.GetValueChangedVolume()+" ("+(string)this.Volume()+")"                                                                                                              :
      event==SYMBOL_EVENT_VOLUME_DEC                  ?
         TextByLanguage("Объём в последней сделке уменьшен на ","Volume of the last deal decreased by ")+(string)this.GetValueChangedVolume()+" ("+(string)this.Volume()+")"                                                                                                              :

      event==SYMBOL_EVENT_VOLUME_HIGH_DAY_INC         ?
         TextByLanguage("Максимальный объём за день увеличен на ","Maximal day volume increased by ")+(string)this.GetValueChangedVolumeHigh()+" ("+(string)this.VolumeHigh()+")"                                                                                                         :
      event==SYMBOL_EVENT_VOLUME_HIGH_DAY_DEC         ?
         TextByLanguage("Максимальный объём за день уменьшен на ","Maximal day volume decreased by ")+(string)this.GetValueChangedVolumeHigh()+" ("+(string)this.VolumeHigh()+")"                                                                                                         :

      event==SYMBOL_EVENT_VOLUME_LOW_DAY_INC          ?
         TextByLanguage("Минимальный объём за день увеличен на ","Minimal day volume increased by ")+(string)this.GetValueChangedVolumeLow()+" ("+(string)this.VolumeLow()+")"                                                                                                            :
      event==SYMBOL_EVENT_VOLUME_LOW_DAY_DEC          ?
         TextByLanguage("Минимальный объём за день уменьшен на ","Minimal day volume decreased by ")+(string)this.GetValueChangedVolumeLow()+" ("+(string)this.VolumeLow()+")"                                                                                                            :

      event==SYMBOL_EVENT_SPREAD_INC                  ?
         TextByLanguage("Спред увеличен на ","Spread value in points increased by ")+(string)this.GetValueChangedSpread()+" ("+(string)this.Spread()+")"                                                                                                                                  :
      event==SYMBOL_EVENT_SPREAD_DEC                  ?
         TextByLanguage("Спред уменьшен на ","Spread value in points decreased by ")+(string)this.GetValueChangedSpread()+" ("+(string)this.Spread()+")"                                                                                                                                  :

      event==SYMBOL_EVENT_STOPLEVEL_INC               ?
         TextByLanguage("Уровень установки Stop-ордеров увеличен на ","Minimal indention in points from the current close price to place Stop orders increased by ")+(string)this.GetValueChangedStopLevel()+" ("+(string)this.TradeStopLevel()+")"                                       :
      event==SYMBOL_EVENT_STOPLEVEL_DEC               ?
         TextByLanguage("Уровень установки Stop-ордеров уменьшен на ","Minimal indention in points from the current close price to place Stop orders decreased by ")+(string)this.GetValueChangedStopLevel()+" ("+(string)this.TradeStopLevel()+")"                                       :

      event==SYMBOL_EVENT_FREEZELEVEL_INC             ?
         TextByLanguage("Уровень заморозки торговых операций увеличен на ","Distance to freeze trade operations in points increased by ")+(string)this.GetValueChangedFreezeLevel()+" ("+(string)this.TradeFreezeLevel()+")"                                                              :
      event==SYMBOL_EVENT_FREEZELEVEL_DEC             ?
         TextByLanguage("Уровень заморозки торговых операций уменьшен на ","Distance to freeze trade operations in points decreased by ")+(string)this.GetValueChangedFreezeLevel()+" ("+(string)this.TradeFreezeLevel()+")"                                                              :

      event==SYMBOL_EVENT_BID_LAST_INC                ?
         price_bid_last+TextByLanguage(" увеличена на "," increased by ")+::DoubleToString(this.GetValueChangedBidLast(),this.Digits())+" ("+::DoubleToString(this.BidLast(),this.Digits())+")"                                                                                           :
      event==SYMBOL_EVENT_BID_LAST_DEC                ?
         price_bid_last+TextByLanguage(" уменьшена на "," decreased by ")+::DoubleToString(this.GetValueChangedBidLast(),this.Digits())+" ("+::DoubleToString(this.BidLast(),this.Digits())+")"                                                                                           :

      event==SYMBOL_EVENT_BID_LAST_HIGH_INC           ?
         price_bid_last_high+TextByLanguage(" увеличена на "," increased by ")+::DoubleToString(this.GetValueChangedBidLastHigh(),this.Digits())+" ("+::DoubleToString(this.BidLastHigh(),this.Digits())+")"                                                                              :
      event==SYMBOL_EVENT_BID_LAST_HIGH_DEC           ?
         price_bid_last_high+TextByLanguage(" уменьшена на "," decreased by ")+::DoubleToString(this.GetValueChangedBidLastHigh(),this.Digits())+" ("+::DoubleToString(this.BidLastHigh(),this.Digits())+")"                                                                              :

      event==SYMBOL_EVENT_BID_LAST_LOW_INC            ?
         price_bid_last_low+TextByLanguage(" увеличена на "," increased by ")+::DoubleToString(this.GetValueChangedBidLastLow(),this.Digits())+" ("+::DoubleToString(this.BidLastLow(),this.Digits())+")"                                                                                 :
      event==SYMBOL_EVENT_BID_LAST_LOW_DEC            ?
         price_bid_last_low+TextByLanguage(" уменьшена на "," decreased by ")+::DoubleToString(this.GetValueChangedBidLastLow(),this.Digits())+" ("+::DoubleToString(this.BidLastLow(),this.Digits())+")"                                                                                 :

      event==SYMBOL_EVENT_ASK_INC                     ?
         TextByLanguage("Цена Ask увеличена на ","Ask price increased by ")+::DoubleToString(this.GetValueChangedAsk(),this.Digits())+" ("+::DoubleToString(this.Ask(),this.Digits())+")"                                                                                                 :
      event==SYMBOL_EVENT_ASK_DEC                     ?
         TextByLanguage("Цена Ask уменьшена на ","Ask price decreased by ")+::DoubleToString(this.GetValueChangedAsk(),this.Digits())+" ("+::DoubleToString(this.Ask(),this.Digits())+")"                                                                                                 :

      event==SYMBOL_EVENT_ASK_HIGH_INC                ?
         TextByLanguage("Максимальная цена Ask за день увеличена на ","Maximal Ask of the day increased by ")+::DoubleToString(this.GetValueChangedAskHigh(),this.Digits())+" ("+::DoubleToString(this.AskHigh(),this.Digits())+")"                                                       :
      event==SYMBOL_EVENT_ASK_HIGH_DEC                ?
         TextByLanguage("Максимальная цена Ask за день уменьшена на ","Maximal Ask of the day decreased by ")+::DoubleToString(this.GetValueChangedAskHigh(),this.Digits())+" ("+::DoubleToString(this.AskHigh(),this.Digits())+")"                                                       :

      event==SYMBOL_EVENT_ASK_LOW_INC                 ?
         TextByLanguage("Минимальная цена Ask за день увеличена на ","Minimal Ask of the day increased by ")+::DoubleToString(this.GetValueChangedAskLow(),this.Digits())+" ("+::DoubleToString(this.AskLow(),this.Digits())+")"                                                          :
      event==SYMBOL_EVENT_ASK_LOW_DEC                 ?
         TextByLanguage("Минимальная цена Ask за день уменьшена на ","Minimal Ask of the day decreased by ")+::DoubleToString(this.GetValueChangedAskLow(),this.Digits())+" ("+::DoubleToString(this.AskLow(),this.Digits())+")"                                                          :

      event==SYMBOL_EVENT_VOLUME_REAL_DAY_INC         ?
         TextByLanguage("Реальный объём последней сделки увеличен на ","Real volume of the last deal increased by ")+::DoubleToString(this.GetValueChangedVolumeReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeReal(),this.DigitsLot())+")"                                    :
      event==SYMBOL_EVENT_VOLUME_REAL_DAY_DEC         ?
         TextByLanguage("Реальный объём последней сделки уменьшен на ","Real volume of the last deal decreased by ")+::DoubleToString(this.GetValueChangedVolumeReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeReal(),this.DigitsLot())+")"                                    :

      event==SYMBOL_EVENT_VOLUME_HIGH_REAL_DAY_INC    ?
         TextByLanguage("Максимальный реальный объём за день увеличен на ","Maximal real volume of the day increased by ")+::DoubleToString(this.GetValueChangedVolumeHighReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeHighReal(),this.DigitsLot())+")"                      :
      event==SYMBOL_EVENT_VOLUME_HIGH_REAL_DAY_DEC    ?
         TextByLanguage("Максимальный реальный объём за день уменьшен на ","Maximal real volume of the day decreased by ")+::DoubleToString(this.GetValueChangedVolumeHighReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeHighReal(),this.DigitsLot())+")"                      :

      event==SYMBOL_EVENT_VOLUME_LOW_REAL_DAY_INC     ?
         TextByLanguage("Минимальный реальный объём за день увеличен на ","Minimal real volume of the day increased by ")+::DoubleToString(this.GetValueChangedVolumeLowReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeLowReal(),this.DigitsLot())+")"                         :
      event==SYMBOL_EVENT_VOLUME_LOW_REAL_DAY_DEC     ?
         TextByLanguage("Минимальный реальный объём за день уменьшен на ","Minimal real volume of the day decreased by ")+::DoubleToString(this.GetValueChangedVolumeLowReal(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeLowReal(),this.DigitsLot())+")"                         :

      event==SYMBOL_EVENT_OPTION_STRIKE_INC           ?
         TextByLanguage("Цена исполнения опциона увеличена на ","Strike price of an option increased by ")+::DoubleToString(this.GetValueChangedOptionStrike(),this.DigitsCurrency())+" ("+::DoubleToString(this.OptionStrike(),this.DigitsCurrency())+")"                            :
      event==SYMBOL_EVENT_OPTION_STRIKE_DEC           ?
         TextByLanguage("Цена исполнения опциона уменьшена на ","Strike price of an option decreased by ")+::DoubleToString(this.GetValueChangedOptionStrike(),this.DigitsCurrency())+" ("+::DoubleToString(this.OptionStrike(),this.DigitsCurrency())+")"                            :

      event==SYMBOL_EVENT_VOLUME_LIMIT_INC            ?
         TextByLanguage("Максимально допустимый совокупный объем позиций и ордеров увеличен на ","Maximum allowed aggregate volume of open position and pending orders in one direction increased by ")+::DoubleToString(this.GetValueChangedVolumeLimit(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeLimit(),this.DigitsLot())+")"  :
      event==SYMBOL_EVENT_VOLUME_LIMIT_DEC            ?
         TextByLanguage("Максимально допустимый совокупный объем позиций и ордеров уменьшен на ","Maximum allowed aggregate volume of open position and pending orders in one direction decreased by ")+::DoubleToString(this.GetValueChangedVolumeLimit(),this.DigitsLot())+" ("+::DoubleToString(this.VolumeLimit(),this.DigitsLot())+")"  :

      event==SYMBOL_EVENT_SWAP_LONG_INC               ?
         TextByLanguage("Своп длинных позиций увеличен на ","Long swap value increased by ")+::DoubleToString(this.GetValueChangedSwapLong(),this.SymbolDigitsBySwap())+" ("+::DoubleToString(this.SwapLong(),this.SymbolDigitsBySwap())+")"                                              :
      event==SYMBOL_EVENT_SWAP_LONG_DEC               ?
         TextByLanguage("Своп длинных позиций уменьшен на ","Long swap value decreased by ")+::DoubleToString(this.GetValueChangedSwapLong(),this.SymbolDigitsBySwap())+" ("+::DoubleToString(this.SwapLong(),this.SymbolDigitsBySwap())+")"                                              :

      event==SYMBOL_EVENT_SWAP_SHORT_INC              ?
         TextByLanguage("Своп коротких позиций увеличен на ","Short swap value increased by ")+::DoubleToString(this.GetValueChangedSwapShort(),this.SymbolDigitsBySwap())+" ("+::DoubleToString(this.SwapShort(),this.SymbolDigitsBySwap())+")"                                          :
      event==SYMBOL_EVENT_SWAP_SHORT_DEC              ?
         TextByLanguage("Своп коротких позиций уменьшен на ","Short swap value decreased by ")+::DoubleToString(this.GetValueChangedSwapShort(),this.SymbolDigitsBySwap())+" ("+::DoubleToString(this.SwapShort(),this.SymbolDigitsBySwap())+")"                                          :

      event==SYMBOL_EVENT_SESSION_VOLUME_INC          ?
         TextByLanguage("Суммарный объём сделок в текущую сессию увеличен на ","Summary volume of current session deals increased by ")+::DoubleToString(this.GetValueChangedSessionVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionVolume(),this.DigitsLot())+")"           :
      event==SYMBOL_EVENT_SESSION_VOLUME_DEC          ?
         TextByLanguage("Суммарный объём сделок в текущую сессию уменьшен на ","Summary volume of current session deals decreased by ")+::DoubleToString(this.GetValueChangedSessionVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionVolume(),this.DigitsLot())+")"           :

      event==SYMBOL_EVENT_SESSION_TURNOVER_INC        ?
         TextByLanguage("Суммарный оборот в текущую сессию увеличен на ","Summary turnover of the current session increased by ")+::DoubleToString(this.GetValueChangedSessionTurnover(),this.DigitsCurrency())+" ("+::DoubleToString(this.SessionTurnover(),this.DigitsCurrency())+")"   :
      event==SYMBOL_EVENT_SESSION_TURNOVER_DEC        ?
         TextByLanguage("Суммарный оборот в текущую сессию уменьшен на ","Summary turnover of the current session decreased by ")+::DoubleToString(this.GetValueChangedSessionTurnover(),this.DigitsCurrency())+" ("+::DoubleToString(this.SessionTurnover(),this.DigitsCurrency())+")"   :

      event==SYMBOL_EVENT_SESSION_INTEREST_INC        ?
         TextByLanguage("Суммарный объём открытых позиций в текущую сессию увеличен на ","Summary open interest increased by ")+::DoubleToString(this.GetValueChangedSessionInterest(),this.DigitsLot())+" ("+::DoubleToString(this.SessionInterest(),this.DigitsLot())+")"               :
      event==SYMBOL_EVENT_SESSION_INTEREST_DEC        ?
         TextByLanguage("Суммарный объём открытых позиций в текущую сессию уменьшен на ","Summary open interest decreased by ")+::DoubleToString(this.GetValueChangedSessionInterest(),this.DigitsLot())+" ("+::DoubleToString(this.SessionInterest(),this.DigitsLot())+")"               :

      event==SYMBOL_EVENT_SESSION_BUY_ORD_VOLUME_INC  ?
         TextByLanguage("Общий объём ордеров на покупку увеличен на ","Current volume of Buy orders increased by ")+::DoubleToString(this.GetValueChangedSessionBuyOrdVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionBuyOrdersVolume(),this.DigitsLot())+")"                :
      event==SYMBOL_EVENT_SESSION_BUY_ORD_VOLUME_DEC  ?
         TextByLanguage("Общий объём ордеров на покупку уменьшен на ","Current volume of Buy orders decreased by ")+::DoubleToString(this.GetValueChangedSessionBuyOrdVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionBuyOrdersVolume(),this.DigitsLot())+")"                :

      event==SYMBOL_EVENT_SESSION_SELL_ORD_VOLUME_INC ?
         TextByLanguage("Общий объём ордеров на продажу увеличен на ","Current volume of Sell orders increased by ")+::DoubleToString(this.GetValueChangedSessionSellOrdVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionSellOrdersVolume(),this.DigitsLot())+")"             :
      event==SYMBOL_EVENT_SESSION_SELL_ORD_VOLUME_DEC ?
         TextByLanguage("Общий объём ордеров на продажу уменьшен на ","Current volume of Sell orders decreased by ")+::DoubleToString(this.GetValueChangedSessionSellOrdVolume(),this.DigitsLot())+" ("+::DoubleToString(this.SessionSellOrdersVolume(),this.DigitsLot())+")"             :

      event==SYMBOL_EVENT_SESSION_OPEN_INC            ?
         TextByLanguage("Цена открытия сессии больше на ","Open price of the current session increased by ")+::DoubleToString(this.GetValueChangedSessionPriceOpen(),this.Digits())+" ("+::DoubleToString(this.SessionOpen(),this.Digits())+")"                                           :
      event==SYMBOL_EVENT_SESSION_OPEN_DEC            ?
         TextByLanguage("Цена открытия сессии меньше на ","Open price of the current session decreased by ")+::DoubleToString(this.GetValueChangedSessionPriceOpen(),this.Digits())+" ("+::DoubleToString(this.SessionOpen(),this.Digits())+")"                                           :

      event==SYMBOL_EVENT_SESSION_CLOSE_INC           ?
         TextByLanguage("Цена закрытия сессии больше на ","Close price of the current session increased by ")+::DoubleToString(this.GetValueChangedSessionPriceClose(),this.Digits())+" ("+::DoubleToString(this.SessionClose(),this.Digits())+")"                                        :
      event==SYMBOL_EVENT_SESSION_CLOSE_DEC           ?
         TextByLanguage("Цена закрытия сессии меньше на ","Close price of the current session decreased by ")+::DoubleToString(this.GetValueChangedSessionPriceClose(),this.Digits())+" ("+::DoubleToString(this.SessionClose(),this.Digits())+")"                                        :

      event==SYMBOL_EVENT_SESSION_AW_INC              ?
         TextByLanguage("Средневзвешенная цена сессии увеличилась на ","Average weighted price of the current session increased by ")+::DoubleToString(this.GetValueChangedSessionPriceAW(),this.Digits())+" ("+::DoubleToString(this.SessionAW(),this.Digits())+")"                      :
      event==SYMBOL_EVENT_SESSION_AW_DEC              ?
         TextByLanguage("Средневзвешенная цена сессии уменьшилась на ","Average weighted price of the current session decreased by ")+::DoubleToString(this.GetValueChangedSessionPriceAW(),this.Digits())+" ("+::DoubleToString(this.SessionAW(),this.Digits())+")"                      :
      ::EnumToString(event)
     );
  }
//+------------------------------------------------------------------+
