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
   struct MqlMarginRate
     {
      double         Initial;                                  // initial margin rate
      double         Maintenance;                              // maintenance margin rate

     };
   struct MqlMarginRateMode
     {
      MqlMarginRate  Long;                                     // MarginRate of long positions
      MqlMarginRate  Short;                                    // MarginRate of short positions
      MqlMarginRate  BuyStop;                                  // MarginRate of BuyStop orders
      MqlMarginRate  BuyLimit;                                 // MarginRate of BuyLimit orders
      MqlMarginRate  BuyStopLimit;                             // MarginRate of BuyStopLimit orders
      MqlMarginRate  SellStop;                                 // MarginRate of SellStop orders
      MqlMarginRate  SellLimit;                                // MarginRate of SellLimit orders
      MqlMarginRate  SellStopLimit;                            // MarginRate of SellStopLimit orders
     };
   MqlMarginRateMode m_margin_rate;                            // Margin ratio structure

   MqlBookInfo       m_book_info_array[];                      // Array of the market depth data structures

   long              m_long_prop[SYMBOL_PROP_INTEGER_TOTAL];   // Integer properties
   double            m_double_prop[SYMBOL_PROP_DOUBLE_TOTAL];  // Real properties
   string            m_string_prop[SYMBOL_PROP_STRING_TOTAL];  // String properties
   bool              m_is_change_trade_mode;                   // Flag of changing trading mode for a symbol

//--- Initialize the variables of controlled symbol data
   virtual void      InitControlsParams(void);
//--- Check the list of symbol property changes and create an event
   void              CheckEvents(void);
   
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

//--- (1) Add, (2) remove a symbol from the Market Watch window, (3) return the data synchronization flag by a symbol
   bool              SetToMarketWatch(void)                       const { return ::SymbolSelect(this.m_name,true);      }
   bool              RemoveFromMarketWatch(void)                  const { return ::SymbolSelect(this.m_name,false);     }
   bool              IsSynchronized(void)                         const { return ::SymbolIsSynchronized(this.m_name);   }
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
//--- Set the change value of the controlled symbol property
   template<typename T> void  SetControlChangedValue(const int property,const T value);
//--- Set the value of the controlled symbol property (1) increase, (2) decrease and (3) control level
   template<typename T> void  SetControlPropertyINC(const int property,const T value);
   template<typename T> void  SetControlPropertyDEC(const int property,const T value);
   template<typename T> void  SetControlPropertyLEVEL(const int property,const T value);
//--- Set the flag of a symbol property change exceeding the (1) increase and (2) decrease values
   template<typename T> void  SetControlFlagINC(const int property,const T value);
   template<typename T> void  SetControlFlagDEC(const int property,const T value);
   
//--- Return the set value of the (1) integer and (2) real symbol property controlled increase
   long              GetControlParameterINC(const ENUM_SYMBOL_PROP_INTEGER property)   const { return this.GetControlledValueLongINC(property);             }
   double            GetControlParameterINC(const ENUM_SYMBOL_PROP_DOUBLE property)    const { return this.GetControlledValueDoubleINC(property);           }
//--- Return the set value of the (1) integer and (2) real symbol property controlled decrease
   long              GetControlParameterDEC(const ENUM_SYMBOL_PROP_INTEGER property)   const { return this.GetControlledValueLongDEC(property);             }
   double            GetControlParameterDEC(const ENUM_SYMBOL_PROP_DOUBLE property)    const { return this.GetControlledValueDoubleDEC(property);           }
//--- Return the flag of an (1) integer and (2) real symbol property value change exceeding the increase value
   long              GetControlFlagINC(const ENUM_SYMBOL_PROP_INTEGER property)        const { return this.GetControlledFlagLongINC(property);              }
   double            GetControlFlagINC(const ENUM_SYMBOL_PROP_DOUBLE property)         const { return this.GetControlledFlagDoubleINC(property);            }
//--- Return the flag of an (1) integer and (2) real symbol property value change exceeding the decrease value
   bool              GetControlFlagDEC(const ENUM_SYMBOL_PROP_INTEGER property)        const { return (bool)this.GetControlledFlagLongDEC(property);        }
   bool              GetControlFlagDEC(const ENUM_SYMBOL_PROP_DOUBLE property)         const { return (bool)this.GetControlledFlagDoubleDEC(property);      }
//--- Return the change value of the controlled (1) integer and (2) real object property
   long              GetControlChangedValue(const ENUM_SYMBOL_PROP_INTEGER property)   const { return this.GetControlledChangedValueLong(property);         }
   double            GetControlChangedValue(const ENUM_SYMBOL_PROP_DOUBLE property)    const { return this.GetControlledChangedValueDouble(property);       }
   
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
//| Get and set the parameters of tracked property changes           |
//+------------------------------------------------------------------+
   //--- Execution
   //--- Flag of changing the trading mode for a symbol
   bool              IsChangedTradeMode(void)                              const { return this.m_is_change_trade_mode;                                      } 
   //--- Current session deals
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the number of deals during the current session
   //--- getting (3) the number of deals change value during the current session,
   //--- getting the flag of the number of deals change during the current session exceeding the (4) increase, (5) decrease value
   void              SetControlSessionDealsInc(const long value)                 { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_DEALS,(long)::fabs(value));        }
   void              SetControlSessionDealsDec(const long value)                 { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_DEALS,(long)::fabs(value));        }
   void              SetControlSessionDealsLevel(const long value)               { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_DEALS,(long)::fabs(value));      }
   long              GetValueChangedSessionDeals(void)                     const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_DEALS);                    }
   bool              IsIncreasedSessionDeals(void)                         const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_DEALS);                   }
   bool              IsDecreasedSessionDeals(void)                         const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_DEALS);                   }
   //--- Buy orders of the current session
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the current number of Buy orders
   //--- getting (4) the current number of Buy orders change value,
   //--- getting the flag of the current Buy orders' number change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionBuyOrdInc(const long value)                { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_BUY_ORDERS,(long)::fabs(value));   }
   void              SetControlSessionBuyOrdDec(const long value)                { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_BUY_ORDERS,(long)::fabs(value));   }
   void              SetControlSessionBuyOrdLevel(const long value)              { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_BUY_ORDERS,(long)::fabs(value)); }
   long              GetValueChangedSessionBuyOrders(void)                 const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_BUY_ORDERS);               }
   bool              IsIncreasedSessionBuyOrders(void)                     const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_BUY_ORDERS);              }
   bool              IsDecreasedSessionBuyOrders(void)                     const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_BUY_ORDERS);              }
   //--- Sell orders of the current session
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the current number of Sell orders
   //--- getting (4) the current number of Sell orders change value,
   //--- getting the flag of the current Sell orders' number change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionSellOrdInc(const long value)               { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_SELL_ORDERS,(long)::fabs(value));  }
   void              SetControlSessionSellOrdDec(const long value)               { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_SELL_ORDERS,(long)::fabs(value));  }
   void              SetControlSessionSellOrdLevel(const long value)             { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_SELL_ORDERS,(long)::fabs(value));}
   long              GetValueChangedSessionSellOrders(void)                const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_SELL_ORDERS);              }
   bool              IsIncreasedSessionSellOrders(void)                    const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_SELL_ORDERS);             }
   bool              IsDecreasedSessionSellOrders(void)                    const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_SELL_ORDERS);             }
   //--- Volume of the last deal
   //--- setting the last deal volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) volume change values in the last deal,
   //--- getting the flag of the volume change in the last deal exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeInc(const long value)                       { this.SetControlPropertyINC(SYMBOL_PROP_VOLUME,(long)::fabs(value));               }
   void              SetControlVolumeDec(const long value)                       { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUME,(long)::fabs(value));               }
   void              SetControlVolumeLevel(const long value)                     { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUME,(long)::fabs(value));             }
   long              GetValueChangedVolume(void)                           const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUME);                           }
   bool              IsIncreasedVolume(void)                               const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUME);                          }
   bool              IsDecreasedVolume(void)                               const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUME);                          }
   //--- Maximum volume within a day
   //--- setting the maximum day volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the maximum volume change value within a day,
   //--- getting the flag of the maximum day volume change exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeHighInc(const long value)                   { this.SetControlPropertyINC(SYMBOL_PROP_VOLUMEHIGH,(long)::fabs(value));           }
   void              SetControlVolumeHighDec(const long value)                   { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUMEHIGH,(long)::fabs(value));           }
   void              SetControlVolumeHighLevel(const long value)                 { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUMEHIGH,(long)::fabs(value));         }
   long              GetValueChangedVolumeHigh(void)                       const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUMEHIGH);                       }
   bool              IsIncreasedVolumeHigh(void)                           const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUMEHIGH);                      }
   bool              IsDecreasedVolumeHigh(void)                           const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUMEHIGH);                      }
   //--- Minimum volume within a day
   //--- setting the minimum day volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the minimum volume change value within a day,
   //--- getting the flag of the minimum day volume change exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeLowInc(const long value)                    { this.SetControlPropertyINC(SYMBOL_PROP_VOLUMELOW,(long)::fabs(value));            }
   void              SetControlVolumeLowDec(const long value)                    { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUMELOW,(long)::fabs(value));            }
   void              SetControlVolumeLowLevel(const long value)                  { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUMELOW,(long)::fabs(value));          }
   long              GetValueChangedVolumeLow(void)                        const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUMELOW);                        }
   bool              IsIncreasedVolumeLow(void)                            const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUMELOW);                       }
   bool              IsDecreasedVolumeLow(void)                            const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUMELOW);                       }
   //--- Spread
   //--- setting the controlled spread (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) spread change value in points,
   //--- getting the flag of the spread change in points exceeding the (5) growth, (6) decrease value
   void              SetControlSpreadInc(const int value)                        { this.SetControlPropertyINC(SYMBOL_PROP_SPREAD,(long)::fabs(value));               }
   void              SetControlSpreadDec(const int value)                        { this.SetControlPropertyDEC(SYMBOL_PROP_SPREAD,(long)::fabs(value));               }
   void              SetControlSpreadLevel(const int value)                      { this.SetControlPropertyLEVEL(SYMBOL_PROP_SPREAD,(long)::fabs(value));             }
   int               GetValueChangedSpread(void)                           const { return (int)this.GetControlChangedValue(SYMBOL_PROP_SPREAD);                      }
   bool              IsIncreasedSpread(void)                               const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SPREAD);                          }
   bool              IsDecreasedSpread(void)                               const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SPREAD);                          }
   //--- StopLevel
   //--- setting the controlled StopLevel (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) StopLevel change value in points,
   //--- getting the flag of StopLevel change in points exceeding the (5) growth, (6) decrease value
   void              SetControlStopLevelInc(const int value)                     { this.SetControlPropertyINC(SYMBOL_PROP_TRADE_STOPS_LEVEL,(long)::fabs(value));    }
   void              SetControlStopLevelDec(const int value)                     { this.SetControlPropertyDEC(SYMBOL_PROP_TRADE_STOPS_LEVEL,(long)::fabs(value));    }
   void              SetControlStopLevelLevel(const int value)                   { this.SetControlPropertyLEVEL(SYMBOL_PROP_TRADE_STOPS_LEVEL,(long)::fabs(value));  }
   int               GetValueChangedStopLevel(void)                        const { return (int)this.GetControlChangedValue(SYMBOL_PROP_TRADE_STOPS_LEVEL);           }
   bool              IsIncreasedStopLevel(void)                            const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_TRADE_STOPS_LEVEL);               }
   bool              IsDecreasedStopLevel(void)                            const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_TRADE_STOPS_LEVEL);               }
   //--- Freeze distance
   //--- setting the controlled FreezeLevel (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) FreezeLevel change value in points,
   //--- getting the flag of FreezeLevel change in points exceeding the (5) growth, (6) decrease value
   void              SetControlFreezeLevelInc(const int value)                   { this.SetControlPropertyINC(SYMBOL_PROP_TRADE_FREEZE_LEVEL,(long)::fabs(value));   }
   void              SetControlFreezeLevelDec(const int value)                   { this.SetControlPropertyDEC(SYMBOL_PROP_TRADE_FREEZE_LEVEL,(long)::fabs(value));   }
   void              SetControlFreezeLevelLevel(const int value)                 { this.SetControlPropertyLEVEL(SYMBOL_PROP_TRADE_FREEZE_LEVEL,(long)::fabs(value)); }
   int               GetValueChangedFreezeLevel(void)                      const { return (int)this.GetControlChangedValue(SYMBOL_PROP_TRADE_FREEZE_LEVEL);          }
   bool              IsIncreasedFreezeLevel(void)                          const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_TRADE_FREEZE_LEVEL);              }
   bool              IsDecreasedFreezeLevel(void)                          const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_TRADE_FREEZE_LEVEL);              }
   
   //--- Bid
   //--- setting the controlled Bid price (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) Bid or Last price change value,
   //--- getting the flag of the Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidInc(const double value)                        { this.SetControlPropertyINC(SYMBOL_PROP_BID,::fabs(value));                        }
   void              SetControlBidDec(const double value)                        { this.SetControlPropertyDEC(SYMBOL_PROP_BID,::fabs(value));                        }
   void              SetControlBidLevel(const double value)                      { this.SetControlPropertyLEVEL(SYMBOL_PROP_BID,::fabs(value));                      }
   double            GetValueChangedBid(void)                              const { return this.GetControlChangedValue(SYMBOL_PROP_BID);                              }
   bool              IsIncreasedBid(void)                                  const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_BID);                             }
   bool              IsDecreasedBid(void)                                  const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_BID);                             }
   //--- The highest Bid price of the day
   //--- setting the controlled maximum Bid price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) maximum Bid or Last price change value,
   //--- getting the flag of the maximum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidHighInc(const double value)                    { this.SetControlPropertyINC(SYMBOL_PROP_BIDHIGH,::fabs(value));                    }
   void              SetControlBidHighDec(const double value)                    { this.SetControlPropertyDEC(SYMBOL_PROP_BIDHIGH,::fabs(value));                    }
   void              SetControlBidHighLevel(const double value)                  { this.SetControlPropertyLEVEL(SYMBOL_PROP_BIDHIGH,::fabs(value));                  }
   double            GetValueChangedBidHigh(void)                          const { return this.GetControlChangedValue(SYMBOL_PROP_BIDHIGH);                          }
   bool              IsIncreasedBidHigh(void)                              const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_BIDHIGH);                         }
   bool              IsDecreasedBidHigh(void)                              const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_BIDHIGH);                         }
   //--- The lowest Bid price of the day
   //--- setting the controlled minimum Bid price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) minimum Bid or Last price change value,
   //--- getting the flag of the minimum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidLowInc(const double value)                     { this.SetControlPropertyINC(SYMBOL_PROP_BIDLOW,::fabs(value));                     }
   void              SetControlBidLowDec(const double value)                     { this.SetControlPropertyDEC(SYMBOL_PROP_BIDLOW,::fabs(value));                     }
   void              SetControlBidLowLevel(const double value)                   { this.SetControlPropertyLEVEL(SYMBOL_PROP_BIDLOW,::fabs(value));                   }
   double            GetValueChangedBidLow(void)                           const { return this.GetControlChangedValue(SYMBOL_PROP_BIDLOW);                           }
   bool              IsIncreasedBidLow(void)                               const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_BIDLOW);                          }
   bool              IsDecreasedBidLow(void)                               const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_BIDLOW);                          }
   
   //--- Last
   //--- setting the controlled Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) Bid or Last price change value,
   //--- getting the flag of the Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlLastInc(const double value)                       { this.SetControlPropertyINC(SYMBOL_PROP_LAST,::fabs(value));                       }
   void              SetControlLastDec(const double value)                       { this.SetControlPropertyDEC(SYMBOL_PROP_LAST,::fabs(value));                       }
   void              SetControlLastLevel(const double value)                     { this.SetControlPropertyLEVEL(SYMBOL_PROP_LAST,::fabs(value));                     }
   double            GetValueChangedLast(void)                             const { return this.GetControlChangedValue(SYMBOL_PROP_LAST);                             }
   bool              IsIncreasedLast(void)                                 const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_LAST);                            }
   bool              IsDecreasedLast(void)                                 const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_LAST);                            }
   //--- The highest Last price of the day
   //--- setting the controlled maximum Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) maximum Bid or Last price change value,
   //--- getting the flag of the maximum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlLastHighInc(const double value)                   { this.SetControlPropertyINC(SYMBOL_PROP_LASTHIGH,::fabs(value));                   }
   void              SetControlLastHighDec(const double value)                   { this.SetControlPropertyDEC(SYMBOL_PROP_LASTHIGH,::fabs(value));                   }
   void              SetControlLastHighLevel(const double value)                 { this.SetControlPropertyLEVEL(SYMBOL_PROP_LASTHIGH,::fabs(value));                 }
   double            GetValueChangedLastHigh(void)                         const { return this.GetControlChangedValue(SYMBOL_PROP_LASTHIGH);                         }
   bool              IsIncreasedLastHigh(void)                             const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_LASTHIGH);                        }
   bool              IsDecreasedLastHigh(void)                             const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_LASTHIGH);                        }
   //--- The lowest Last price of the day
   //--- setting the controlled minimum Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) minimum Bid or Last price change value,
   //--- getting the flag of the minimum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlLastLowInc(const double value)                    { this.SetControlPropertyINC(SYMBOL_PROP_LASTLOW,::fabs(value));                    }
   void              SetControlLastLowDec(const double value)                    { this.SetControlPropertyDEC(SYMBOL_PROP_LASTLOW,::fabs(value));                    }
   void              SetControlLastLowLevel(const double value)                  { this.SetControlPropertyLEVEL(SYMBOL_PROP_LASTLOW,::fabs(value));                  }
   double            GetValueChangedLastLow(void)                          const { return this.GetControlChangedValue(SYMBOL_PROP_LASTLOW);                          }
   bool              IsIncreasedLastLow(void)                              const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_LASTLOW);                         }
   bool              IsDecreasedLastLow(void)                              const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_LASTLOW);                         }
   
   //--- Bid/Last
   //--- setting the controlled Bid or Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) Bid or Last price change value,
   //--- getting the flag of the Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidLastInc(const double value);
   void              SetControlBidLastDec(const double value);
   void              SetControlBidLastLevel(const double value);
   double            GetValueChangedBidLast(void)                          const;
   bool              IsIncreasedBidLast(void)                              const;
   bool              IsDecreasedBidLast(void)                              const;
   //--- Maximum Bid/Last of the day
   //--- setting the controlled maximum Bid or Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) maximum Bid or Last price change value,
   //--- getting the flag of the maximum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidLastHighInc(const double value);
   void              SetControlBidLastHighDec(const double value);
   void              SetControlBidLastHighLevel(const double value);
   double            GetValueChangedBidLastHigh(void)                      const;
   bool              IsIncreasedBidLastHigh(void)                          const;
   bool              IsDecreasedBidLastHigh(void)                          const;
   //--- Minimum Bid/Last of the day
   //--- setting the controlled minimum Bid or Last price (1) increase, (2) decrease value and (3) control level in points
   //--- getting the (4) minimum Bid or Last price change value,
   //--- getting the flag of the minimum Bid or Last price change exceeding the (5) growth, (6) decrease value
   void              SetControlBidLastLowInc(const double value);
   void              SetControlBidLastLowDec(const double value);
   void              SetControlBidLastLowLevev(const double value);
   double            GetValueChangedBidLastLow(void)                       const;
   bool              IsIncreasedBidLastLow(void)                           const;
   bool              IsDecreasedBidLastLow(void)                           const;
   
   //--- Ask
   //--- setting the controlled Ask price (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) Ask price change value,
   //--- getting the flag of the Ask price change exceeding the (5) growth, (6) decrease value
   void              SetControlAskInc(const double value)                        { this.SetControlPropertyINC(SYMBOL_PROP_ASK,::fabs(value));                        }
   void              SetControlAskDec(const double value)                        { this.SetControlPropertyDEC(SYMBOL_PROP_ASK,::fabs(value));                        }
   void              SetControlAskLevel(const double value)                      { this.SetControlPropertyLEVEL(SYMBOL_PROP_ASK,::fabs(value));                      }
   double            GetValueChangedAsk(void)                              const { return this.GetControlChangedValue(SYMBOL_PROP_ASK);                              }
   bool              IsIncreasedAsk(void)                                  const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_ASK);                             }
   bool              IsDecreasedAsk(void)                                  const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_ASK);                             }
   //--- Maximum Ask price for the day
   //--- setting the maximum day Ask controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the maximum Ask change value within a day,
   //--- getting the flag of the maximum day Ask change exceeding the (5) growth, (6) decrease value
   void              SetControlAskHighInc(const double value)                    { this.SetControlPropertyINC(SYMBOL_PROP_ASKHIGH,::fabs(value));                    }
   void              SetControlAskHighDec(const double value)                    { this.SetControlPropertyDEC(SYMBOL_PROP_ASKHIGH,::fabs(value));                    }
   void              SetControlAskHighLevel(const double value)                  { this.SetControlPropertyLEVEL(SYMBOL_PROP_ASKHIGH,::fabs(value));                  }
   double            GetValueChangedAskHigh(void)                          const { return this.GetControlChangedValue(SYMBOL_PROP_ASKHIGH);                          }
   bool              IsIncreasedAskHigh(void)                              const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_ASKHIGH);                         }
   bool              IsDecreasedAskHigh(void)                              const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_ASKHIGH);                         }
   //--- Minimum Ask price for the day
   //--- setting the minimum day Ask controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the minimum Ask change value within a day,
   //--- getting the flag of the minimum day Ask change exceeding the (5) growth, (6) decrease value
   void              SetControlAskLowInc(const double value)                     { this.SetControlPropertyINC(SYMBOL_PROP_ASKLOW,::fabs(value));                     }
   void              SetControlAskLowDec(const double value)                     { this.SetControlPropertyDEC(SYMBOL_PROP_ASKLOW,::fabs(value));                     }
   void              SetControlAskLowLevel(const double value)                   { this.SetControlPropertyLEVEL(SYMBOL_PROP_ASKLOW,::fabs(value));                   }
   double            GetValueChangedAskLow(void)                           const { return this.GetControlChangedValue(SYMBOL_PROP_ASKLOW);                           }
   bool              IsIncreasedAskLow(void)                               const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_ASKLOW);                          }
   bool              IsDecreasedAskLow(void)                               const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_ASKLOW);                          }
   //--- Real Volume for the day
   //--- setting the real day volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the change value of the real day volume,
   //--- getting the flag of the real day volume change exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeRealInc(const double value)                 { this.SetControlPropertyINC(SYMBOL_PROP_VOLUME_REAL,::fabs(value));                }
   void              SetControlVolumeRealDec(const double value)                 { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUME_REAL,::fabs(value));                }
   void              SetControlVolumeRealLevel(const double value)               { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUME_REAL,::fabs(value));              }
   double            GetValueChangedVolumeReal(void)                       const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUME_REAL);                      }
   bool              IsIncreasedVolumeReal(void)                           const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUME_REAL);                     }
   bool              IsDecreasedVolumeReal(void)                           const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUME_REAL);                     }
   //--- Maximum real volume for the day
   //--- setting the maximum real day volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the change value of the maximum real day volume,
   //--- getting the flag of the maximum real day volume change exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeHighRealInc(const double value)             { this.SetControlPropertyINC(SYMBOL_PROP_VOLUMEHIGH_REAL,::fabs(value));            }
   void              SetControlVolumeHighRealDec(const double value)             { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUMEHIGH_REAL,::fabs(value));            }
   void              SetControlVolumeHighRealLevel(const double value)           { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUMEHIGH_REAL,::fabs(value));          }
   double            GetValueChangedVolumeHighReal(void)                   const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUMEHIGH_REAL);                  }
   bool              IsIncreasedVolumeHighReal(void)                       const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUMEHIGH_REAL);                 }
   bool              IsDecreasedVolumeHighReal(void)                       const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUMEHIGH_REAL);                 }
   //--- Minimum real volume for the day
   //--- setting the minimum real day volume controlled (1) increase, (2) decrease and (3) control level
   //--- getting (4) the change value of the minimum real day volume,
   //--- getting the flag of the minimum real day volume change exceeding the (5) growth, (6) decrease value
   void              SetControlVolumeLowRealInc(const double value)              { this.SetControlPropertyINC(SYMBOL_PROP_VOLUMELOW_REAL,::fabs(value));             }
   void              SetControlVolumeLowRealDec(const double value)              { this.SetControlPropertyDEC(SYMBOL_PROP_VOLUMELOW_REAL,::fabs(value));             }
   void              SetControlVolumeLowRealLevel(const double value)            { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUMELOW_REAL,::fabs(value));           }
   double            GetValueChangedVolumeLowReal(void)                    const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUMELOW_REAL);                   }
   bool              IsIncreasedVolumeLowReal(void)                        const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUMELOW_REAL);                  }
   bool              IsDecreasedVolumeLowReal(void)                        const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUMELOW_REAL);                  }
   //--- Strike price
   //--- setting the controlled strike price (1) increase, (2) decrease value and (3) control level in points
   //--- getting (4) the change value of the strike price,
   //--- getting the flag of the strike price change exceeding the (5) growth, (6) decrease value
   void              SetControlOptionStrikeInc(const double value)               { this.SetControlPropertyINC(SYMBOL_PROP_OPTION_STRIKE,::fabs(value));              }
   void              SetControlOptionStrikeDec(const double value)               { this.SetControlPropertyDEC(SYMBOL_PROP_OPTION_STRIKE,::fabs(value));              }
   void              SetControlOptionStrikeLevel(const double value)             { this.SetControlPropertyLEVEL(SYMBOL_PROP_OPTION_STRIKE,::fabs(value));            }
   double            GetValueChangedOptionStrike(void)                     const { return this.GetControlChangedValue(SYMBOL_PROP_OPTION_STRIKE);                    } 
   bool              IsIncreasedOptionStrike(void)                         const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_OPTION_STRIKE);                   }
   bool              IsDecreasedOptionStrike(void)                         const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_OPTION_STRIKE);                   }
   //--- Maximum allowed total volume of unidirectional positions and orders
   //--- (1) Setting the control level
   //--- (2) getting the change value of the maximum allowed total volume of unidirectional positions and orders,
   //--- getting the flag of (3) increasing, (4) decreasing the maximum allowed total volume of unidirectional positions and orders
   void              SetControlVolumeLimitLevel(const double value)              { this.SetControlPropertyLEVEL(SYMBOL_PROP_VOLUME_LIMIT,::fabs(value));             }
   double            GetValueChangedVolumeLimit(void)                      const { return this.GetControlChangedValue(SYMBOL_PROP_VOLUME_LIMIT);                     }
   bool              IsIncreasedVolumeLimit(void)                          const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_VOLUME_LIMIT);                    }
   bool              IsDecreasedVolumeLimit(void)                          const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_VOLUME_LIMIT);                    }
   //---  Swap long
   //--- (1) Setting the control level
   //--- (2) getting the swap long change value,
   //--- getting the flag of (3) increasing, (4) decreasing the swap long
   void              SetControlSwapLongLevel(const double value)                 { this.SetControlPropertyLEVEL(SYMBOL_PROP_SWAP_LONG,::fabs(value));                }
   double            GetValueChangedSwapLong(void)                         const { return this.GetControlChangedValue(SYMBOL_PROP_SWAP_LONG);                        }
   bool              IsIncreasedSwapLong(void)                             const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SWAP_LONG);                       }
   bool              IsDecreasedSwapLong(void)                             const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SWAP_LONG);                       }
   //---  Swap short

   //--- (1) Setting the control level
   //--- (2) getting the swap short change value,
   //--- getting the flag of (3) increasing, (4) decreasing the swap short
   void              SetControlSwapShortLevel(const double value)                { this.SetControlPropertyLEVEL(SYMBOL_PROP_SWAP_SHORT,::fabs(value));               }
   double            GetValueChangedSwapShort(void)                        const { return this.GetControlChangedValue(SYMBOL_PROP_SWAP_SHORT);                       }
   bool              IsIncreasedSwapShort(void)                            const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SWAP_SHORT);                      }
   bool              IsDecreasedSwapShort(void)                            const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SWAP_SHORT);                      }
   //--- The total volume of deals in the current session
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the total volume of deals during the current session
   //--- getting (4) the total deal volume change value in the current session,
   //--- getting the flag of the total deal volume change during the current session exceeding the (5) growth, (6) decrease value
   void              SetControlSessionVolumeInc(const double value)              { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_VOLUME,::fabs(value));             }
   void              SetControlSessionVolumeDec(const double value)              { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_VOLUME,::fabs(value));             }
   void              SetControlSessionVolumeLevel(const double value)            { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_VOLUME,::fabs(value));           }
   double            GetValueChangedSessionVolume(void)                    const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_VOLUME);                   }
   bool              IsIncreasedSessionVolume(void)                        const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_VOLUME);                  }
   bool              IsDecreasedSessionVolume(void)                        const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_VOLUME);                  }
   //--- The total turnover in the current session
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the total turnover during the current session
   //--- getting (4) the total turnover change value in the current session,
   //--- getting the flag of the total turnover change during the current session exceeding the (5) growth, (6) decrease value
   void              SetControlSessionTurnoverInc(const double value)            { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_TURNOVER,::fabs(value));           }
   void              SetControlSessionTurnoverDec(const double value)            { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_TURNOVER,::fabs(value));           }
   void              SetControlSessionTurnoverLevel(const double value)          { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_TURNOVER,::fabs(value));         }
   double            GetValueChangedSessionTurnover(void)                  const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_TURNOVER);                 }
   bool              IsIncreasedSessionTurnover(void)                      const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_TURNOVER);                }
   bool              IsDecreasedSessionTurnover(void)                      const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_TURNOVER);                }
   //--- The total volume of open positions
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the total volume of open positions during the current session
   //--- getting (4) the change value of the open positions total volume in the current session,
   //--- getting the flag of the open positions total volume change during the current session exceeding the (5) growth, (6) decrease value
   void              SetControlSessionInterestInc(const double value)            { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_INTEREST,::fabs(value));           }
   void              SetControlSessionInterestDec(const double value)            { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_INTEREST,::fabs(value));           }
   void              SetControlSessionInterestLevel(const double value)          { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_INTEREST,::fabs(value));         }
   double            GetValueChangedSessionInterest(void)                  const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_INTEREST);                 }
   bool              IsIncreasedSessionInterest(void)                      const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_INTEREST);                }
   bool              IsDecreasedSessionInterest(void)                      const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_INTEREST);                }
   //--- The total volume of Buy orders at the moment
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the current total buy order volume
   //--- getting (4) the change value of the current total buy order volume,
   //--- getting the flag of the current total buy orders' volume change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionBuyOrdVolumeInc(const double value)        { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME,::fabs(value));  }
   void              SetControlSessionBuyOrdVolumeDec(const double value)        { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME,::fabs(value));  }
   void              SetControlSessionBuyOrdVolumeLevel(const double value)      { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME,::fabs(value));}
   double            GetValueChangedSessionBuyOrdVolume(void)              const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME);        }
   bool              IsIncreasedSessionBuyOrdVolume(void)                  const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME);       }
   bool              IsDecreasedSessionBuyOrdVolume(void)                  const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME);       }
   //--- The total volume of Sell orders at the moment
   //--- setting the controlled value of (1) growth, (2) decrease and (3) control level of the current total sell order volume
   //--- getting (4) the change value of the current total sell order volume,
   //--- getting the flag of the current total sell orders' volume change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionSellOrdVolumeInc(const double value)       { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME,::fabs(value)); }
   void              SetControlSessionSellOrdVolumeDec(const double value)       { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME,::fabs(value)); }
   void              SetControlSessionSellOrdVolumeLevel(const double value)     { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME,::fabs(value));}
   double            GetValueChangedSessionSellOrdVolume(void)             const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME);       }
   bool              IsIncreasedSessionSellOrdVolume(void)                 const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME);      }
   bool              IsDecreasedSessionSellOrdVolume(void)                 const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME);      }
   //--- Session open price
   //--- setting the controlled session open price (1) increase, (2) decrease and (3) control value
   //--- getting (4) the change value of the session open price,
   //--- getting the flag of the session open price change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionPriceOpenInc(const double value)           { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_OPEN,::fabs(value));               }
   void              SetControlSessionPriceOpenDec(const double value)           { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_OPEN,::fabs(value));               }
   void              SetControlSessionPriceOpenLevel(const double value)         { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_OPEN,::fabs(value));             }
   double            GetValueChangedSessionPriceOpen(void)                 const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_OPEN);                     }
   bool              IsIncreasedSessionPriceOpen(void)                     const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_OPEN);                    }
   bool              IsDecreasedSessionPriceOpen(void)                     const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_OPEN);                    }
   //--- Session close price
   //--- setting the controlled session close price (1) increase, (2) decrease and (3) control value
   //--- getting (4) the change value of the session close price,
   //--- getting the flag of the session close price change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionPriceCloseInc(const double value)          { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_CLOSE,::fabs(value));              }
   void              SetControlSessionPriceCloseDec(const double value)          { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_CLOSE,::fabs(value));              }
   void              SetControlSessionPriceCloseLevel(const double value)        { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_CLOSE,::fabs(value));            }
   double            GetValueChangedSessionPriceClose(void)                const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_CLOSE);                    }
   bool              IsIncreasedSessionPriceClose(void)                    const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_CLOSE);                   }
   bool              IsDecreasedSessionPriceClose(void)                    const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_CLOSE);                   }
   //--- The average weighted session price
   //--- setting the controlled session average weighted price (1) increase, (2) decrease and (3) control value
   //--- getting (4) the change value of the average weighted session price,
   //--- getting the flag of the average weighted session price change exceeding the (5) growth, (6) decrease value
   void              SetControlSessionPriceAWInc(const double value)             { this.SetControlPropertyINC(SYMBOL_PROP_SESSION_AW,::fabs(value));                 }
   void              SetControlSessionPriceAWDec(const double value)             { this.SetControlPropertyDEC(SYMBOL_PROP_SESSION_AW,::fabs(value));                 }
   void              SetControlSessionPriceAWLevel(const double value)           { this.SetControlPropertyLEVEL(SYMBOL_PROP_SESSION_AW,::fabs(value));               }
   double            GetValueChangedSessionPriceAW(void)                   const { return this.GetControlChangedValue(SYMBOL_PROP_SESSION_AW);                       }
   bool              IsIncreasedSessionPriceAW(void)                       const { return (bool)this.GetControlFlagINC(SYMBOL_PROP_SESSION_AW);                      }
   bool              IsDecreasedSessionPriceAW(void)                       const { return (bool)this.GetControlFlagDEC(SYMBOL_PROP_SESSION_AW);                      }
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
   this.m_type=COLLECTION_SYMBOLS_ID;
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
//--- Initialize control data
   this.SetControlDataArraySizeLong(SYMBOL_PROP_INTEGER_TOTAL);
   this.SetControlDataArraySizeDouble(SYMBOL_PROP_DOUBLE_TOTAL);
   this.ResetChangesParams();
   this.ResetControlsParams();
   
//--- Initialize symbol data
   this.Reset();
   this.InitMarginRates();
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
//+----------------------------------------------------------------------+
//| Return the description of a session duration in the hh:mm:ss format  |
//+----------------------------------------------------------------------+
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
//+---------------------------------------------------------------------+
//| Return the description of allowing to close by an opposite position |
//+---------------------------------------------------------------------+
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
//+------------------------------------------------------------------+
//| Return a normalized price considering symbol properties          |
//+------------------------------------------------------------------+
double CSymbol::NormalizedPrice(const double price) const
  {
   double tsize=this.TradeTickSize();
   return(tsize!=0 ? ::NormalizeDouble(::round(price/tsize)*tsize,this.Digits()) : ::NormalizeDouble(price,this.Digits()));
  }
//+------------------------------------------------------------------+
//| Update all symbol data                                           |
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
//--- Initialize event data
   this.m_is_event=false;
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
   
//--- Fill in the symbol current data
   for(int i=0;i<SYMBOL_PROP_INTEGER_TOTAL;i++)
      this.m_long_prop_event[i][3]=this.m_long_prop[i];
   for(int i=0;i<SYMBOL_PROP_DOUBLE_TOTAL;i++)
      this.m_double_prop_event[i][3]=this.m_double_prop[i];
   
   CBaseObj::Refresh();
   this.CheckEvents();
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
//| Check the list of symbol property changes and create an event    |
//+------------------------------------------------------------------+
void CSymbol::CheckEvents(void)
  {
   int total=this.m_list_events_base.Total();
   if(total==0)
      return;
   
   for(int i=0;i<total;i++)
     {
      CBaseEvent *event=this.GetEventBase(i);
      if(event==NULL)
         continue;
      long lvalue=0;
      this.UshortToLong(this.MSCfromTime(this.TickTime()),0,lvalue);
      this.UshortToLong(event.Reason(),1,lvalue);
      this.UshortToLong(COLLECTION_SYMBOLS_ID,2,lvalue);
      if(this.EventAdd((ushort)event.ID(),lvalue,event.Value(),this.Name()))
         this.m_is_event=true;
     }
  }  
//+------------------------------------------------------------------+
//| Initialize the variables of controlled symbol data               |
//+------------------------------------------------------------------+
void CSymbol::InitControlsParams(void)
  {
   this.ResetControlsParams();
  }
//+------------------------------------------------------------------+
//| Set the value of the controlled property increase                |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlPropertyINC(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledValueINC(property,(long)value);
   else
      this.SetControlledValueINC(property,(double)value);
  }  
//+------------------------------------------------------------------+
//| Set the value of the controlled property decrease                |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlPropertyDEC(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledValueDEC(property,(long)value);
   else
      this.SetControlledValueDEC(property,(double)value);
  }
//+------------------------------------------------------------------+
//| Set the value of the controlled property level                   |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlPropertyLEVEL(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledValueLEVEL(property,(long)value);
   else
      this.SetControlledValueLEVEL(property,(double)value);
  }
//+------------------------------------------------------------------+
//| Set the flag of the symbol property value change                 |
//| exceeding the increase value                                     |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlFlagINC(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledFlagINC(property,(long)value);
   else
      this.SetControlledFlagINC(property,(double)value);
  }  
//+------------------------------------------------------------------+
//| Set the flag of the symbol property value change                 |
//| exceeding the decrease value                                     |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlFlagDEC(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledFlagDEC(property,(long)value);
   else
      this.SetControlledFlagDEC(property,(double)value);
  }
//+------------------------------------------------------------------+
//| Set the change value of the controlled symbol property           |
//+------------------------------------------------------------------+
template<typename T> void CSymbol::SetControlChangedValue(const int property,const T value)
  {
   if(property<SYMBOL_PROP_INTEGER_TOTAL)
      this.SetControlledChangedValue(property,(long)value);
   else
      this.SetControlledChangedValue(property,(double)value);
  }
//+------------------------------------------------------------------+
//| Set the Bid or Last price controlled increase                    |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastInc(const double value)
  {
   this.SetControlPropertyINC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BID : SYMBOL_PROP_LAST),::fabs(value));
  }
//+------------------------------------------------------------------+
//|Set the Bid or Last price controlled decrease                     |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastDec(const double value)
  {
   this.SetControlPropertyDEC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BID : SYMBOL_PROP_LAST),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Set the Bid or Last price control level                          |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastLevel(const double value)
  {
   this.SetControlPropertyLEVEL((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BID : SYMBOL_PROP_LAST),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Return the Bid or Last price change value                        |
//+------------------------------------------------------------------+
double CSymbol::GetValueChangedBidLast(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetControlChangedValue(SYMBOL_PROP_BID) : this.GetControlChangedValue(SYMBOL_PROP_LAST));
  }
//+------------------------------------------------------------------+
//| Return the flag of the Bid or Last price change                  |
//| exceeding the increase value                                     |
//+------------------------------------------------------------------+
bool CSymbol::IsIncreasedBidLast(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagINC(SYMBOL_PROP_BID) : (bool)this.GetControlFlagINC(SYMBOL_PROP_LAST));
  }
//+------------------------------------------------------------------+
//| Return the flag of the Bid or Last price change                  |
//| exceeding the decrease value                                     |
//+------------------------------------------------------------------+
bool CSymbol::IsDecreasedBidLast(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagDEC(SYMBOL_PROP_BID) : (bool)this.GetControlFlagDEC(SYMBOL_PROP_LAST));
  }
//+------------------------------------------------------------------+
//| Set the controlled increase value                                |
//| of the maximum Bid or Last price                                 |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastHighInc(const double value)
  {
   this.SetControlPropertyINC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDHIGH : SYMBOL_PROP_LASTHIGH),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Set the controlled decrease value                                |
//| of the maximum Bid or Last price                                 |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastHighDec(const double value)
  {
   this.SetControlPropertyDEC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDHIGH : SYMBOL_PROP_LASTHIGH),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Set the maximum Bid or Last price control level                  |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastHighLevel(const double value)
  {
   this.SetControlPropertyLEVEL((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDHIGH : SYMBOL_PROP_LASTHIGH),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Return the maximum Bid or Last price change value                |
//+------------------------------------------------------------------+
double CSymbol::GetValueChangedBidLastHigh(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetControlChangedValue(SYMBOL_PROP_BIDHIGH) : this.GetControlChangedValue(SYMBOL_PROP_LASTHIGH));
  }
//+------------------------------------------------------------------+
//| Return the flag of a change of the maximum                       |
//| Bid or Last price exceeding the increase value                   |
//+------------------------------------------------------------------+
bool CSymbol::IsIncreasedBidLastHigh(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagINC(SYMBOL_PROP_BIDHIGH) : (bool)this.GetControlFlagINC(SYMBOL_PROP_LASTHIGH));
  }
//+------------------------------------------------------------------+
//| Return the flag of a change of the maximum                       |
//| Bid or Last price exceeding the decrease value                   |
//+------------------------------------------------------------------+
bool CSymbol::IsDecreasedBidLastHigh(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagDEC(SYMBOL_PROP_BIDHIGH) : (bool)this.GetControlFlagDEC(SYMBOL_PROP_LASTHIGH));
  }
//+------------------------------------------------------------------+
//| Set the controlled increase value                                |
//| of the minimum Bid or Last price                                 |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastLowInc(const double value)
  {
   this.SetControlPropertyINC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDLOW : SYMBOL_PROP_LASTLOW),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Set the controlled decrease value                                |
//| of the minimum Bid or Last price                                 |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastLowDec(const double value)
  {
   this.SetControlPropertyDEC((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDLOW : SYMBOL_PROP_LASTLOW),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Set the minimum Bid or Last price control level                  |
//+------------------------------------------------------------------+
void CSymbol::SetControlBidLastLowLevev(const double value)
  {
   this.SetControlPropertyLEVEL((this.ChartMode()==SYMBOL_CHART_MODE_BID ? SYMBOL_PROP_BIDLOW : SYMBOL_PROP_LASTLOW),::fabs(value));
  }
//+------------------------------------------------------------------+
//| Return the minimum Bid or Last price change value                |
//+------------------------------------------------------------------+
double CSymbol::GetValueChangedBidLastLow(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? this.GetControlChangedValue(SYMBOL_PROP_BIDLOW) : this.GetControlChangedValue(SYMBOL_PROP_LASTLOW));
  }
//+------------------------------------------------------------------+
//| Return the flag of a change of the minimum                       |
//| Bid or Last price exceeding the increase value                   |
//+------------------------------------------------------------------+
bool CSymbol::IsIncreasedBidLastLow(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagINC(SYMBOL_PROP_BIDLOW) : (bool)this.GetControlFlagINC(SYMBOL_PROP_LASTLOW));
  }
//+------------------------------------------------------------------+
//| Return the flag of a change of the minimum                       |
//| Bid or Last price exceeding the decrease value                   |
//+------------------------------------------------------------------+
bool CSymbol::IsDecreasedBidLastLow(void) const
  {
   return(this.ChartMode()==SYMBOL_CHART_MODE_BID ? (bool)this.GetControlFlagDEC(SYMBOL_PROP_BIDLOW) : (bool)this.GetControlFlagDEC(SYMBOL_PROP_LASTLOW));
  }
//+------------------------------------------------------------------+
