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
#include <Object.mqh>
#include "..\..\Services\DELib.mqh"
//+------------------------------------------------------------------+
//| Abstract symbol class                                            |
//+------------------------------------------------------------------+
class CSymbol : public CObject
  {
private:
   MqlTick           m_tick;                                         // Symbol tick structure
   MqlBookInfo       m_book_info_array[];                            // Array of the market depth data structures
   string            m_symbol_name;                                  // Symbol name
   long              m_long_prop[SYMBOL_PROP_INTEGER_TOTAL];         // Integer properties
   double            m_double_prop[SYMBOL_PROP_DOUBLE_TOTAL];        // Real properties
   string            m_string_prop[SYMBOL_PROP_STRING_TOTAL];        // String properties
   int               m_digits_currency;                              // Number of decimal places in an account currency
   int               m_global_error;                                 // Global error code
//--- Return the index of the array the symbol's (1) double and (2) string properties are located at
   int               IndexProp(ENUM_SYMBOL_PROP_DOUBLE property)  const { return(int)property-SYMBOL_PROP_INTEGER_TOTAL;                                    }
   int               IndexProp(ENUM_SYMBOL_PROP_STRING property)  const { return(int)property-SYMBOL_PROP_INTEGER_TOTAL-SYMBOL_PROP_DOUBLE_TOTAL;           }
//--- Reset all symbol object data
   void              Reset(void);
public:
//--- Default constructor
                     CSymbol(void){;}
protected:
//--- Protected parametric constructor
                     CSymbol(ENUM_SYMBOL_STATUS symbol_status,const string name);

//--- Get and return integer properties of a selected symbol from its parameters
   long              SymbolExists(void)                  const;
   long              SymbolCustom(void)                  const;
   long              SymbolChartMode(void)               const;
   long              SymbolMarginHedgedUseLEG(void)      const;
   long              SymbolOrderFillingMode(void)        const;
   long              SymbolOrderMode(void)               const;
   long              SymbolOrderGTCMode(void)            const;
   long              SymbolOptionMode(void)              const;
   long              SymbolOptionRight(void)             const;
   long              SymbolBackgroundColor(void)         const;
   long              SymbolCalcMode(void)                const;
   long              SymbolSwapMode(void)                const;
   long              SymbolExpirationMode(void)          const;
   long              SymbolDigitsLot(void);
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
//--- Get and return string properties of a selected symbol from its parameters
   string            SymbolBasis(void)                   const;
   string            SymbolBank(void)                    const;
   string            SymbolISIN(void)                    const;
   string            SymbolFormula(void)                 const;
   string            SymbolPage(void)                    const;
//--- Return the number of decimal places of the account currency
   int               DigitsCurrency(void)                const { return this.m_digits_currency; }
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
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_INTEGER property)    { return true; }
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_DOUBLE property)     { return true; }
   virtual bool      SupportProperty(ENUM_SYMBOL_PROP_STRING property)     { return true; }

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
   bool              IsExipirationModeGTC(void)             const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_GTC)==SYMBOL_EXPIRATION_GTC);    }
   bool              IsExipirationModeDAY(void)             const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_DAY)==SYMBOL_EXPIRATION_DAY);    }
   bool              IsExipirationModeSpecified(void)       const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED)==SYMBOL_EXPIRATION_SPECIFIED);          }
   bool              IsExipirationModeSpecifiedDay(void)    const { return((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED_DAY)==SYMBOL_EXPIRATION_SPECIFIED_DAY);  }

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
//--- Return symbol status name
   string            StatusDescription(void)    const;
//--- Send description of symbol properties to the journal (full_prop=true - all properties, false - only supported ones)
   void              Print(const bool full_prop=false);
   
//--- Compare CSymbol objects by all possible properties (for sorting lists by a specified symbol object property)
   virtual int       Compare(const CObject *node,const int mode=0) const;
//--- Compare CSymbol objects by all properties (for searching for equal event objects)
   bool              IsEqual(CSymbol* compared_symbol) const;

//--- Return the global error code
   int               GetError(void)                               const { return this.m_global_error;                                                       }
//--- Update all symbol data that can change
   void              Refresh(void);
//--- Update quote data by a symbol
   void              RefreshRates(void);

//--- (1) Add, (2) remove a symbol from the Market Watch window, (3) return the data synchronization flag by a symbol
   bool              SetToMarketWatch(void)                       const { return ::SymbolSelect(this.m_symbol_name,true);                                   }
   bool              RemoveFromMarketWatch(void)                  const { return ::SymbolSelect(this.m_symbol_name,false);                                  }
   bool              IsSynchronized(void)                         const { return ::SymbolIsSynchronized(this.m_symbol_name);                                }
//--- (1) Arrange a (1) subscription to the market depth, (2) close the market depth, (3) fill in the market depth data to the structure array
   bool              BookAdd(void)                                const;
   bool              BookClose(void)                              const;

//+------------------------------------------------------------------+
//| Methods of a simplified access to the order object properties    |
//+------------------------------------------------------------------+
//--- Integer properties
   long              Status(void)                                 const { return this.GetProperty(SYMBOL_PROP_STATUS);                                      }
   bool              IsCustom(void)                               const { return (bool)this.GetProperty(SYMBOL_PROP_CUSTOM);                                }
   color             ColorBackground(void)                        const { return (color)this.GetProperty(SYMBOL_PROP_BACKGROUND_COLOR);                     }
   ENUM_SYMBOL_CHART_MODE ChartMode(void)                         const { return (ENUM_SYMBOL_CHART_MODE)this.GetProperty(SYMBOL_PROP_CHART_MODE);          }
   bool              IsExist(void)                                const { return (bool)this.GetProperty(SYMBOL_PROP_EXIST);                                 }
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
   double            MarginLong(void)                             const { return this.GetProperty(SYMBOL_PROP_MARGIN_LONG);                                 }
   double            MarginShort(void)                            const { return this.GetProperty(SYMBOL_PROP_MARGIN_SHORT);                                }
   double            MarginStop(void)                             const { return this.GetProperty(SYMBOL_PROP_MARGIN_STOP);                                 }
   double            MarginLimit(void)                            const { return this.GetProperty(SYMBOL_PROP_MARGIN_LIMIT);                                }
   double            MarginStopLimit(void)                        const { return this.GetProperty(SYMBOL_PROP_MARGIN_STOPLIMIT);                            }
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
//---
  };
//+------------------------------------------------------------------+
//| Class methods                                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Closed parametric constructor                                    |
//+------------------------------------------------------------------+
CSymbol::CSymbol(ENUM_SYMBOL_STATUS symbol_status,const string name) : m_global_error(ERR_SUCCESS)
  {
   this.m_symbol_name=name;
   if(!this.Exist())
     {
      ::Print(DFUN_ERR_LINE,"\"",this.m_symbol_name,"\"",": ",TextByLanguage("Ошибка. Такого символа нет на сервере","Error. There is no such symbol on the server"));
      this.m_global_error=ERR_MARKET_UNKNOWN_SYMBOL;
     }
   ::ResetLastError();
   if(!::SymbolInfoTick(this.m_symbol_name,this.m_tick))
     {
      this.m_global_error=::GetLastError();
      ::Print(DFUN_ERR_LINE,"\"",this.m_symbol_name,"\": ",TextByLanguage("Не удалось получить текущие цены. Ошибка: ","Could not get current prices. Error: "),this.m_global_error);
     }
//--- Инициализация данных
   ::ZeroMemory(this.m_tick);
   this.Reset();
   this.m_digits_currency=(#ifdef __MQL5__ (int)::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif);
//--- Save integer properties
   this.m_long_prop[SYMBOL_PROP_STATUS]                                       = symbol_status;
   this.m_long_prop[SYMBOL_PROP_VOLUME]                                       = (long)this.m_tick.volume;
   this.m_long_prop[SYMBOL_PROP_TIME]                                         = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time*1000 #endif ;
   this.m_long_prop[SYMBOL_PROP_SELECT]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SELECT);
   this.m_long_prop[SYMBOL_PROP_VISIBLE]                                      = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VISIBLE);
   this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_DEALS);
   this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_BUY_ORDERS);
   this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                          = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_SELL_ORDERS);
   this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                   = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VOLUMEHIGH);
   this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                    = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VOLUMELOW);
   this.m_long_prop[SYMBOL_PROP_DIGITS]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_DIGITS);
   this.m_long_prop[SYMBOL_PROP_SPREAD]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SPREAD);
   this.m_long_prop[SYMBOL_PROP_SPREAD_FLOAT]                                 = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SPREAD_FLOAT);
   this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                              = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TICKS_BOOKDEPTH);
   this.m_long_prop[SYMBOL_PROP_TRADE_MODE]                                   = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_MODE);
   this.m_long_prop[SYMBOL_PROP_START_TIME]                                   = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_START_TIME);
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                              = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_EXPIRATION_TIME);
   this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                            = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_STOPS_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_FREEZE_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_EXEMODE]                                = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_EXEMODE);
   this.m_long_prop[SYMBOL_PROP_SWAP_ROLLOVER3DAYS]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SWAP_ROLLOVER3DAYS);
   this.m_long_prop[SYMBOL_PROP_EXIST]                                        = this.SymbolExists();
   this.m_long_prop[SYMBOL_PROP_CUSTOM]                                       = this.SymbolCustom();
   this.m_long_prop[SYMBOL_PROP_MARGIN_HEDGED_USE_LEG]                        = this.SymbolMarginHedgedUseLEG();
   this.m_long_prop[SYMBOL_PROP_ORDER_MODE]                                   = this.SymbolOrderMode();
   this.m_long_prop[SYMBOL_PROP_FILLING_MODE]                                 = this.SymbolOrderFillingMode();
   this.m_long_prop[SYMBOL_PROP_ORDER_GTC_MODE]                               = this.SymbolOrderGTCMode();
   this.m_long_prop[SYMBOL_PROP_OPTION_MODE]                                  = this.SymbolOptionMode();
   this.m_long_prop[SYMBOL_PROP_OPTION_RIGHT]                                 = this.SymbolOptionRight();
   this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                             = this.SymbolBackgroundColor();
   this.m_long_prop[SYMBOL_PROP_CHART_MODE]                                   = this.SymbolChartMode();
   this.m_long_prop[SYMBOL_PROP_TRADE_CALC_MODE]                              = this.SymbolCalcMode();
   this.m_long_prop[SYMBOL_PROP_SWAP_MODE]                                    = this.SymbolSwapMode();
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_MODE]                              = this.SymbolExpirationMode();
//--- Save real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                     = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                   = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_POINT)]                      = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_POINT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_PROFIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]      = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_LOSS);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]            = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]        = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_CONTRACT_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_STEP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                  = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SWAP_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SWAP_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]             = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_INITIAL);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]         = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_MAINTENANCE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_STOP)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_STOP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LIMIT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_STOPLIMIT)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_STOPLIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]             = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_TURNOVER);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_INTEREST);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]  = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_BUY_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)] = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_SELL_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_OPEN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]              = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_CLOSE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_AW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]   = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_SETTLEMENT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_LIMIT_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_LIMIT_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                        = this.m_tick.bid;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                        = this.m_tick.ask;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                       = this.m_tick.last;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                    = this.SymbolBidHigh();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                     = this.SymbolBidLow();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                = this.SymbolVolumeReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]            = this.SymbolVolumeHighReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]             = this.SymbolVolumeLowReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]              = this.SymbolOptionStrike();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]     = this.SymbolTradeAccruedInterest();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]           = this.SymbolTradeFaceValue();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]       = this.SymbolTradeLiquidityRate();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]              = this.SymbolMarginHedged();
//--- Save string properties
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_NAME)]                       = this.m_symbol_name;
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_BASE)]              = ::SymbolInfoString(this.m_symbol_name,SYMBOL_CURRENCY_BASE);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_PROFIT)]            = ::SymbolInfoString(this.m_symbol_name,SYMBOL_CURRENCY_PROFIT);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_MARGIN)]            = ::SymbolInfoString(this.m_symbol_name,SYMBOL_CURRENCY_MARGIN);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_DESCRIPTION)]                = ::SymbolInfoString(this.m_symbol_name,SYMBOL_DESCRIPTION);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_PATH)]                       = ::SymbolInfoString(this.m_symbol_name,SYMBOL_PATH);
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_BASIS)]                      = this.SymbolBasis();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_BANK)]                       = this.SymbolBank();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_ISIN)]                       = this.SymbolISIN();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_FORMULA)]                    = this.SymbolFormula();
   this.m_string_prop[this.IndexProp(SYMBOL_PROP_PAGE)]                       = this.SymbolPage();
//--- Save additional integer properties
   this.m_long_prop[SYMBOL_PROP_DIGITS_LOTS]                                  = this.SymbolDigitsLot();
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
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_EXIST) #else this.Exist() #endif);
  }
//+------------------------------------------------------------------+
//| Return the custom symbol flag                                    |
//+------------------------------------------------------------------+
long CSymbol::SymbolCustom(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_CUSTOM) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Return the price type for building bars - Bid or Last            |
//+------------------------------------------------------------------+
long CSymbol::SymbolChartMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_CHART_MODE) #else SYMBOL_CHART_MODE_BID #endif);
  }
//+--------------------------------------------------------------------+
//|Return the calculation mode of a hedging margin using the larger leg|
//+--------------------------------------------------------------------+
long CSymbol::SymbolMarginHedgedUseLEG(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_MARGIN_HEDGED_USE_LEG) #else false #endif);
  }
//+------------------------------------------------------------------+
//| Return the order filling policies flags                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderFillingMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_FILLING_MODE) #else 0 #endif );
  }
//+------------------------------------------------------------------+
//| Return the flag allowing the closure by an opposite position     |
//+------------------------------------------------------------------+
bool CSymbol::IsCloseByOrdersAllowed(void) const
  {
   return(#ifdef __MQL5__(this.OrderModeFlags() & SYMBOL_ORDER_CLOSEBY)==SYMBOL_ORDER_CLOSEBY #else (bool)::MarketInfo(this.m_symbol_name,MODE_CLOSEBY_ALLOWED)  #endif );
  }  
//+------------------------------------------------------------------+
//| Return the lifetime of pending orders and                        |
//| placed StopLoss/TakeProfit levels                                |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderGTCMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_ORDER_GTC_MODE) #else SYMBOL_ORDERS_GTC #endif);
  }
//+------------------------------------------------------------------+
//| Return the option type                                           |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_OPTION_MODE) #else SYMBOL_OPTION_MODE_NONE #endif);
  }
//+------------------------------------------------------------------+
//| Return the option right                                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionRight(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_OPTION_RIGHT) #else SYMBOL_OPTION_RIGHT_NONE #endif);
  }
//+----------------------------------------------------------------------+
//|Return the background color used to highlight a symbol in Market Watch|
//+----------------------------------------------------------------------+
long CSymbol::SymbolBackgroundColor(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_BACKGROUND_COLOR) #else clrNONE #endif);
  }
//+------------------------------------------------------------------+
//| Return the margin calculation method                             |
//+------------------------------------------------------------------+
long CSymbol::SymbolCalcMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_CALC_MODE) #else (long)::MarketInfo(this.m_symbol_name,MODE_MARGINCALCMODE) #endif);
  }
//+------------------------------------------------------------------+
//| Return the swaps calculation method                              |
//+------------------------------------------------------------------+
long CSymbol::SymbolSwapMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SWAP_MODE) #else (long)::MarketInfo(this.m_symbol_name,MODE_SWAPTYPE) #endif);
  }
//+------------------------------------------------------------------+
//| Return the flags of allowed order expiration modes               |
//+------------------------------------------------------------------+
long CSymbol::SymbolExpirationMode(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_EXPIRATION_MODE) #else (long)SYMBOL_EXPIRATION_GTC #endif);
  }
//+------------------------------------------------------------------+
//| Return the flags of allowed order types                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderMode(void) const
  {
   return
     (
      #ifdef __MQL5__
         ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_ORDER_MODE)
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
   double val=::round(this.LotsMin()/this.LotsStep())*this.LotsStep();
   string val_str=(string)val;
   int len=::StringLen(val_str);
   int n=len-::StringFind(val_str,".",0)-1;
   if(::StringSubstr(val_str,len-1,1)=="0")
      n--;
   return n;
  }
//+------------------------------------------------------------------+
//| Real properties                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return maximum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidHigh(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_BIDHIGH) #else ::MarketInfo(this.m_symbol_name,MODE_HIGH) #endif);
  }
//+------------------------------------------------------------------+
//| Return minimum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidLow(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_BIDLOW) #else ::MarketInfo(this.m_symbol_name,MODE_LOW) #endif);
  }
//+------------------------------------------------------------------+
//| Return real Volume for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return real maximum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeHighReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUMEHIGH_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return real minimum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeLowReal(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUMELOW_REAL) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return an option execution price                                 |
//+------------------------------------------------------------------+
double CSymbol::SymbolOptionStrike(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_OPTION_STRIKE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return accrued interest                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeAccruedInterest(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_ACCRUED_INTEREST) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a bond face value                                         |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeFaceValue(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_FACE_VALUE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a liquidity rate                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeLiquidityRate(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_LIQUIDITY_RATE) #else 0 #endif);
  }
//+------------------------------------------------------------------+
//| Return a contract or margin size                                 |
//| for a single lot of covered positions                            |
//+------------------------------------------------------------------+
double CSymbol::SymbolMarginHedged(void) const
  {
   return(#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_HEDGED) #else ::MarketInfo(this.m_symbol_name, MODE_MARGINHEDGED) #endif);
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
         ::SymbolInfoString(this.m_symbol_name,SYMBOL_BASIS) 
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
         ::SymbolInfoString(this.m_symbol_name,SYMBOL_BANK) 
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
         ::SymbolInfoString(this.m_symbol_name,SYMBOL_ISIN) 
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
         ::SymbolInfoString(this.m_symbol_name,SYMBOL_FORMULA) 
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
         ::SymbolInfoString(this.m_symbol_name,SYMBOL_PAGE) 
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
           TextByLanguage("Конец списка параметров: ","End of the parameter list: \""),
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
   //--- General properties
      property==SYMBOL_PROP_STATUS              ?  TextByLanguage("Статус","Status")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+(string)this.GetStatusDescription()
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
      property==SYMBOL_PROP_SPREAD_FLOAT        ?  TextByLanguage("Плавающий спред","Spread is floating")+
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
      property==SYMBOL_PROP_ORDER_MODE          ?  TextByLanguage("Флаги разрешенных типов ордера","Flags of allowed order types")+
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
      property==SYMBOL_PROP_BACKGROUND_COLOR    ?  TextByLanguage("Цвет фона символа в Market Watch","Background color of the symbol in Market Watch")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
         #ifdef __MQL5__
         (this.GetProperty(property)>clrWhite  ?  TextByLanguage(": (Отсутствует)",": (Not set)") : ": "+::ColorToString((color)this.GetProperty(property),true))
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
      property==SYMBOL_PROP_TRADE_LIQUIDITY_RATE   ?  TextByLanguage("Коэффициент ликвидности","Liquidity Rate")+
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
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_MARGIN_MAINTENANCE  ?  TextByLanguage("Поддерживающая маржа по инструменту","Maintenance margin")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+::DoubleToString(this.GetProperty(property),dgc)
         )  :
      property==SYMBOL_PROP_MARGIN_LONG      ?  TextByLanguage("Коэффициент взимания маржи по длинным позициям","Coefficient of margin charging for long positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_SHORT     ?  TextByLanguage("Коэффициент взимания маржи по коротким позициям","Coefficient of margin charging for short positions")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_STOP      ?  TextByLanguage("Коэффициент взимания маржи по Stop ордерам","Coefficient of margin charging for Stop orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_LIMIT     ?  TextByLanguage("Коэффициент взимания маржи по Limit ордерам","Coefficient of margin charging for Limit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
      property==SYMBOL_PROP_MARGIN_STOPLIMIT ?  TextByLanguage("Коэффициент взимания маржи по Stop Limit ордерам","Coefficient of margin charging for StopLimit orders")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Свойство не поддерживается",": Property not supported") :
          ": "+ #ifdef __MQL5__::DoubleToString(this.GetProperty(property),dgc) #else TextByLanguage("Свойство не поддерживается в MQL4","Property not supported in MQL4") #endif 
         )  :
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
      if(::SymbolName(i,false)==this.m_symbol_name)
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Subscribe to the market depth                                    |
//+------------------------------------------------------------------+
bool CSymbol::BookAdd(void) const
  {
   return #ifdef __MQL5__ ::MarketBookAdd(this.m_symbol_name) #else false #endif ;
  }
//+------------------------------------------------------------------+
//| Close the market depth                                           |
//+------------------------------------------------------------------+
bool CSymbol::BookClose(void) const
  {
   return #ifdef __MQL5__ ::MarketBookRelease(this.m_symbol_name) #else false #endif ;
  }
//+------------------------------------------------------------------+
//| Return the status description                                    |
//+------------------------------------------------------------------+
string CSymbol::GetStatusDescription() const
  {
   return
     (
      this.Status()==SYMBOL_STATUS_FX              ? TextByLanguage("Форекс символ","Forex symbol")                  :
      this.Status()==SYMBOL_STATUS_FX_MAJOR        ? TextByLanguage("Форекс символ-мажор","Forex major symbol")      :
      this.Status()==SYMBOL_STATUS_FX_MINOR        ? TextByLanguage("Форекс символ-минор","Forex minor symbol")      :
      this.Status()==SYMBOL_STATUS_FX_EXOTIC       ? TextByLanguage("Форекс символ-экзотик","Forex Exotic Symbol")   :
      this.Status()==SYMBOL_STATUS_FX_RUB          ? TextByLanguage("Форекс символ/рубль","Forex symbol RUB")        :
      this.Status()==SYMBOL_STATUS_FX_METAL        ? TextByLanguage("Металл","Metal")                                :
      this.Status()==SYMBOL_STATUS_INDEX           ? TextByLanguage("Индекс","Index")                                :
      this.Status()==SYMBOL_STATUS_INDICATIVE      ? TextByLanguage("Индикатив","Indicative")                        :
      this.Status()==SYMBOL_STATUS_CRYPTO          ? TextByLanguage("Криптовалютный символ","Crypto symbol")         :
      this.Status()==SYMBOL_STATUS_COMMODITY       ? TextByLanguage("Товарный символ","Commodity symbol")            :
      this.Status()==SYMBOL_STATUS_EXCHANGE        ? TextByLanguage("Биржевой символ","Exchange symbol")             : 
      this.Status()==SYMBOL_STATUS_BIN_OPTION      ? TextByLanguage("Бинарный опцион","Binary option")               : 
      this.Status()==SYMBOL_STATUS_CUSTOM          ? TextByLanguage("Пользовательский символ","Custom symbol")       :
      ""
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
     (this.IsExipirationModeGTC() ? 
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
     (this.IsExipirationModeDAY() ? 
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
     (this.IsExipirationModeSpecified() ? 
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
     (this.IsExipirationModeSpecifiedDay() ? 
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
//| Update all symbol data that can change                           |
//+------------------------------------------------------------------+
void CSymbol::Refresh(void)
  {
   ::ResetLastError();
   if(!::SymbolInfoTick(this.m_symbol_name,this.m_tick))
     {
      this.m_global_error=::GetLastError();
      ::Print(DFUN_ERR_LINE,this.Name(),": ",TextByLanguage("Не удалось получить текущие цены. Ошибка: ","Could not get current prices. Error: "),this.m_global_error);
      return;
     }
//--- Update integer properties
   this.m_long_prop[SYMBOL_PROP_VOLUME]                                       = (long)this.m_tick.volume;
   this.m_long_prop[SYMBOL_PROP_TIME]                                         = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time*1000 #endif ;
   this.m_long_prop[SYMBOL_PROP_SELECT]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SELECT);
   this.m_long_prop[SYMBOL_PROP_VISIBLE]                                      = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VISIBLE);
   this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_DEALS);
   this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_BUY_ORDERS);
   this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                          = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SESSION_SELL_ORDERS);
   this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                   = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VOLUMEHIGH);
   this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                    = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_VOLUMELOW);
   this.m_long_prop[SYMBOL_PROP_SPREAD]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SPREAD);
   this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                              = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TICKS_BOOKDEPTH);
   this.m_long_prop[SYMBOL_PROP_START_TIME]                                   = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_START_TIME);
   this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                              = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_EXPIRATION_TIME);
   this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                            = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_STOPS_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_FREEZE_LEVEL);
   this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                             = this.SymbolBackgroundColor();
//--- Update real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                     = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                   = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_PROFIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]      = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_LOSS);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]            = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]        = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_CONTRACT_SIZE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_STEP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_VOLUME_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                  = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SWAP_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SWAP_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]             = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_INITIAL);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]         = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_MAINTENANCE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_LONG);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_SHORT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_STOP)]                = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_STOP);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LIMIT)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_LIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_STOPLIMIT)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_MARGIN_STOPLIMIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]             = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_TURNOVER);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_INTEREST);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]  = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_BUY_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)] = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_SELL_ORDERS_VOLUME);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]               = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_OPEN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]              = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_CLOSE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                 = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_AW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]   = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_SETTLEMENT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_LIMIT_MIN);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_SESSION_PRICE_LIMIT_MAX);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                        = this.m_tick.ask;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                        = this.m_tick.bid;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                       = this.m_tick.last;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                    = this.SymbolBidHigh();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                     = this.SymbolBidLow();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                = this.SymbolVolumeReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]            = this.SymbolVolumeHighReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]             = this.SymbolVolumeLowReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]              = this.SymbolOptionStrike();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]     = this.SymbolTradeAccruedInterest();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]           = this.SymbolTradeFaceValue();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]       = this.SymbolTradeLiquidityRate();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]              = this.SymbolMarginHedged();
  }
//+------------------------------------------------------------------+
//| Update quote data by a symbol                                    |
//+------------------------------------------------------------------+
void CSymbol::RefreshRates(void)
  {
   ::ResetLastError();
   if(!::SymbolInfoTick(this.m_symbol_name,this.m_tick))
     {
      this.m_global_error=::GetLastError();
      ::Print(DFUN_ERR_LINE,this.Name(),": ",TextByLanguage("Не удалось получить текущие цены. Ошибка: ","Could not get current prices. Error: "),this.m_global_error);
      return;
     }
//--- Update integer properties
   this.m_long_prop[SYMBOL_PROP_VOLUME]                                       = (long)this.m_tick.volume;
   this.m_long_prop[SYMBOL_PROP_TIME]                                         = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time*1000 #endif ;
   this.m_long_prop[SYMBOL_PROP_SPREAD]                                       = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_SPREAD);
   this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                            = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_STOPS_LEVEL);
   this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                           = ::SymbolInfoInteger(this.m_symbol_name,SYMBOL_TRADE_FREEZE_LEVEL);
//--- Update real properties
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                     = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_ASKLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                   = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTHIGH);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_LASTLOW);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]           = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]    = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_PROFIT);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]      = ::SymbolInfoDouble(this.m_symbol_name,SYMBOL_TRADE_TICK_VALUE_LOSS);
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                        = this.m_tick.ask;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                        = this.m_tick.bid;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                       = this.m_tick.last;
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                    = this.SymbolBidHigh();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                     = this.SymbolBidLow();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                = this.SymbolVolumeReal();
   this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]              = this.SymbolOptionStrike();
  }  
//+------------------------------------------------------------------+
