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
   struct SActionsFlags
     {
   private:
      bool                    m_use_sound_open;          // The flag of using the position opening/order placing sound
      bool                    m_use_sound_close;         // The flag of using the position closing/order removal sound
      bool                    m_use_sound_modify_sl;     // The flag of using the StopLoss position/order modification sound
      bool                    m_use_sound_modify_tp;     // The flag of using the TakeProfit position/order modification sound
      bool                    m_use_sound_modify_price;  // The flag of using the order placement price modification sound
      //---
      string                  m_sound_open;              // Position opening/order placing sound
      string                  m_sound_close;             // Position closing/order removal sound
      string                  m_sound_modify_sl;         // StopLoss position/order modification sound
      string                  m_sound_modify_tp;         // TakeProfit position/order modification sound
      string                  m_sound_modify_price;      // Order placement price modification sound
      //---
      string                  m_sound_open_err;          // Position opening/order placing error sound
      string                  m_sound_close_err;         // Position closing/order removal error sound
      string                  m_sound_modify_sl_err;     // StopLoss position/order modification error sound
      string                  m_sound_modify_tp_err;     // TakeProfit position/order modification error sound
      string                  m_sound_modify_price_err;  // Order placement price modification error sound
   public:
      //--- Method of placing/accessing flags and file names
      void                    UseSoundOpen(const bool flag)                      { this.m_use_sound_open=flag;             }
      void                    UseSoundClose(const bool flag)                     { this.m_use_sound_close=flag;            }
      void                    UseSoundModifySL(const bool flag)                  { this.m_use_sound_modify_sl=flag;        }
      void                    UseSoundModifyTP(const bool flag)                  { this.m_use_sound_modify_tp=flag;        }
      void                    UseSoundModifyPrice(const bool flag)               { this.m_use_sound_modify_price=flag;     }
      bool                    UseSoundOpen(void)                           const { return this.m_use_sound_open;           }
      bool                    UseSoundClose(void)                          const { return this.m_use_sound_close;          }
      bool                    UseSoundModifySL(void)                       const { return this.m_use_sound_modify_sl;      }
      bool                    UseSoundModifyTP(void)                       const { return this.m_use_sound_modify_tp;      }
      bool                    UseSoundModifyPrice(void)                    const { return this.m_use_sound_modify_price;   }
      //---
      void                    SoundOpen(const string sound)                      { this.m_sound_open=sound;                }
      void                    SoundClose(const string sound)                     { this.m_sound_close=sound;               }
      void                    SoundModifySL(const string sound)                  { this.m_sound_modify_sl=sound;           }
      void                    SoundModifyTP(const string sound)                  { this.m_sound_modify_tp=sound;           }
      void                    SoundModifyPrice(const string sound)               { this.m_sound_modify_price=sound;        }
      string                  SoundOpen(void)                              const { return this.m_sound_open;               }
      string                  SoundClose(void)                             const { return this.m_sound_close;              }
      string                  SoundModifySL(void)                          const { return this.m_sound_modify_sl;          }
      string                  SoundModifyTP(void)                          const { return this.m_sound_modify_tp;          }
      string                  SoundModifyPrice(void)                       const { return this.m_sound_modify_price;       }
      //---
      void                    SoundErrorOpen(const string sound)                 { this.m_sound_open_err=sound;            }
      void                    SoundErrorClose(const string sound)                { this.m_sound_close_err=sound;           }
      void                    SoundErrorModifySL(const string sound)             { this.m_sound_modify_sl_err=sound;       }
      void                    SoundErrorModifyTP(const string sound)             { this.m_sound_modify_tp_err=sound;       }
      void                    SoundErrorModifyPrice(const string sound)          { this.m_sound_modify_price_err=sound;    }
      string                  SoundErrorOpen(void)                         const { return this.m_sound_open_err;           }
      string                  SoundErrorClose(void)                        const { return this.m_sound_close_err;          }
      string                  SoundErrorModifySL(void)                     const { return this.m_sound_modify_sl_err;      }
      string                  SoundErrorModifyTP(void)                     const { return this.m_sound_modify_tp_err;      }
      string                  SoundErrorModifyPrice(void)                  const { return this.m_sound_modify_price_err;   }
     };
   struct SActions
     {
      SActionsFlags           Buy;
      SActionsFlags           BuyStop;
      SActionsFlags           BuyLimit;
      SActionsFlags           BuyStopLimit;
      SActionsFlags           Sell;
      SActionsFlags           SellStop;
      SActionsFlags           SellLimit;
      SActionsFlags           SellStopLimit;
     };
   SActions                   m_datas;
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
   bool                       m_use_sound;                                       // The flag of using sounds of the object trading events
//--- Play the sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   void                       PlaySoundOpen(const int action);
   void                       PlaySoundClose(const int action);
   void                       PlaySoundModifySL(const int action);
   void                       PlaySoundModifyTP(const int action);
   void                       PlaySoundModifyPrice(const int action);
//--- Play the error sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   void                       PlaySoundErrorOpen(const int action);
   void                       PlaySoundErrorClose(const int action);
   void                       PlaySoundErrorModifySL(const int action);
   void                       PlaySoundErrorModifyTP(const int action);
   void                       PlaySoundErrorModifyPrice(const int action);
public:
//--- Constructor
                              CTradeObj();

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
                                   
//--- Set default sounds and flags of using sounds,
   void                       InitSounds(const bool use_sound=false,
                                         const string sound_open=NULL,
                                         const string sound_close=NULL,
                                         const string sound_sl=NULL,
                                         const string sound_tp=NULL,
                                         const string sound_price=NULL,
                                         const string sound_error=NULL);
//--- Allow working with sounds and set standard sounds
   void                       SetSoundsStandart(void);
//--- Set the flag of using the sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   void                       UseSoundOpen(const int action,const bool flag);
   void                       UseSoundClose(const int action,const bool flag);
   void                       UseSoundModifySL(const int action,const bool flag);
   void                       UseSoundModifyTP(const int action,const bool flag);
   void                       UseSoundModifyPrice(const int action,const bool flag);
//--- Return the flag of using the sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   bool                       UseSoundOpen(const int action)            const;
   bool                       UseSoundClose(const int action)           const;
   bool                       UseSoundModifySL(const int action)        const;
   bool                       UseSoundModifyTP(const int action)        const;
   bool                       UseSoundModifyPrice(const int action)     const;

//--- Set the sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   void                       SetSoundOpen(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundClose(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundModifySL(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundModifyTP(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundModifyPrice(const ENUM_ORDER_TYPE action,const string sound);
//--- Set the error sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   void                       SetSoundErrorOpen(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundErrorClose(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundErrorModifySL(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundErrorModifyTP(const ENUM_ORDER_TYPE action,const string sound);
   void                       SetSoundErrorModifyPrice(const ENUM_ORDER_TYPE action,const string sound);

//--- Return the sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   string                     GetSoundOpen(const ENUM_ORDER_TYPE action)               const;
   string                     GetSoundClose(const ENUM_ORDER_TYPE action)              const;
   string                     GetSoundModifySL(const ENUM_ORDER_TYPE action)           const;
   string                     GetSoundModifyTP(const ENUM_ORDER_TYPE action)           const;
   string                     GetSoundModifyPrice(const ENUM_ORDER_TYPE action)        const;
//--- Return the error sound of (1) opening/placing a specified position/order type,
//--- (2) closing/removal of a specified position/order type, (3) StopLoss modification for a specified position/order type,
//--- (4) TakeProfit modification for a specified position/order type, (5) placement price modification for a specified order type
   string                     GetSoundErrorOpen(const ENUM_ORDER_TYPE action)          const;
   string                     GetSoundErrorClose(const ENUM_ORDER_TYPE action)         const;
   string                     GetSoundErrorModifySL(const ENUM_ORDER_TYPE action)      const;
   string                     GetSoundErrorModifyTP(const ENUM_ORDER_TYPE action)      const;
   string                     GetSoundErrorModifyPrice(const ENUM_ORDER_TYPE action)   const;

//--- Play a sound of a specified trading event for a set position/order type
   void                       PlaySoundSuccess(const ENUM_ACTION_TYPE action,const int order,bool sl=false,bool tp=false,bool pr=false);
//--- Play an error sound of a specified trading event for a set position/order type
   void                       PlaySoundError(const ENUM_ACTION_TYPE action,const int order,bool sl=false,bool tp=false,bool pr=false);

//--- Set/return the flag of using sounds
   void                       SetUseSound(const bool flag)                             { this.m_use_sound=flag;               }
   bool                       IsUseSound(void)                                   const { return this.m_use_sound;             }

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
                                           const string comment=NULL,
                                           const ulong deviation=ULONG_MAX);
//--- Close a position
   bool                       ClosePosition(const ulong ticket,
                                            const string comment=NULL,
                                            const ulong deviation=ULONG_MAX);
//--- Close a position partially
   bool                       ClosePositionPartially(const ulong ticket,
                                                     const double volume,
                                                     const string comment=NULL,
                                                     const ulong deviation=ULONG_MAX);
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
                                       const string comment=NULL,
                                       const datetime expiration=0,
                                       const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC);
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
   //--- Set default sounds and flags of using sounds
   this.m_use_sound=false;
   this.InitSounds();
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
//| Set default sounds and flags of using sounds                     |
//+------------------------------------------------------------------+
void CTradeObj::InitSounds(const bool use_sound=false,
                           const string sound_open=NULL,
                           const string sound_close=NULL,
                           const string sound_sl=NULL,
                           const string sound_tp=NULL,
                           const string sound_price=NULL,
                           const string sound_error=NULL)
  {
   this.m_datas.Buy.UseSoundOpen(use_sound);
   this.m_datas.Buy.UseSoundClose(use_sound);
   this.m_datas.Buy.UseSoundModifySL(use_sound);
   this.m_datas.Buy.UseSoundModifyTP(use_sound);
   this.m_datas.Buy.UseSoundModifyPrice(use_sound);
   this.m_datas.Buy.SoundOpen(sound_open);
   this.m_datas.Buy.SoundClose(sound_close);
   this.m_datas.Buy.SoundModifySL(sound_sl);
   this.m_datas.Buy.SoundModifyTP(sound_tp);
   this.m_datas.Buy.SoundModifyPrice(sound_price);
   this.m_datas.Buy.SoundErrorClose(sound_error);
   this.m_datas.Buy.SoundErrorOpen(sound_error);
   this.m_datas.Buy.SoundErrorModifySL(sound_error);
   this.m_datas.Buy.SoundErrorModifyTP(sound_error);
   this.m_datas.Buy.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.BuyStop.UseSoundOpen(use_sound);
   this.m_datas.BuyStop.UseSoundClose(use_sound);
   this.m_datas.BuyStop.UseSoundModifySL(use_sound);
   this.m_datas.BuyStop.UseSoundModifyTP(use_sound);
   this.m_datas.BuyStop.UseSoundModifyPrice(use_sound);
   this.m_datas.BuyStop.SoundOpen(sound_open);
   this.m_datas.BuyStop.SoundClose(sound_close);
   this.m_datas.BuyStop.SoundModifySL(sound_sl);
   this.m_datas.BuyStop.SoundModifyTP(sound_tp);
   this.m_datas.BuyStop.SoundModifyPrice(sound_price);
   this.m_datas.BuyStop.SoundErrorClose(sound_error);
   this.m_datas.BuyStop.SoundErrorOpen(sound_error);
   this.m_datas.BuyStop.SoundErrorModifySL(sound_error);
   this.m_datas.BuyStop.SoundErrorModifyTP(sound_error);
   this.m_datas.BuyStop.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.BuyLimit.UseSoundOpen(use_sound);
   this.m_datas.BuyLimit.UseSoundClose(use_sound);
   this.m_datas.BuyLimit.UseSoundModifySL(use_sound);
   this.m_datas.BuyLimit.UseSoundModifyTP(use_sound);
   this.m_datas.BuyLimit.UseSoundModifyPrice(use_sound);
   this.m_datas.BuyLimit.SoundOpen(sound_open);
   this.m_datas.BuyLimit.SoundClose(sound_close);
   this.m_datas.BuyLimit.SoundModifySL(sound_sl);
   this.m_datas.BuyLimit.SoundModifyTP(sound_tp);
   this.m_datas.BuyLimit.SoundModifyPrice(sound_price);
   this.m_datas.BuyLimit.SoundErrorClose(sound_error);
   this.m_datas.BuyLimit.SoundErrorOpen(sound_error);
   this.m_datas.BuyLimit.SoundErrorModifySL(sound_error);
   this.m_datas.BuyLimit.SoundErrorModifyTP(sound_error);
   this.m_datas.BuyLimit.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.BuyStopLimit.UseSoundOpen(use_sound);
   this.m_datas.BuyStopLimit.UseSoundClose(use_sound);
   this.m_datas.BuyStopLimit.UseSoundModifySL(use_sound);
   this.m_datas.BuyStopLimit.UseSoundModifyTP(use_sound);
   this.m_datas.BuyStopLimit.UseSoundModifyPrice(use_sound);
   this.m_datas.BuyStopLimit.SoundOpen(sound_open);
   this.m_datas.BuyStopLimit.SoundClose(sound_close);
   this.m_datas.BuyStopLimit.SoundModifySL(sound_sl);
   this.m_datas.BuyStopLimit.SoundModifyTP(sound_tp);
   this.m_datas.BuyStopLimit.SoundModifyPrice(sound_price);
   this.m_datas.BuyStopLimit.SoundErrorClose(sound_error);
   this.m_datas.BuyStopLimit.SoundErrorOpen(sound_error);
   this.m_datas.BuyStopLimit.SoundErrorModifySL(sound_error);
   this.m_datas.BuyStopLimit.SoundErrorModifyTP(sound_error);
   this.m_datas.BuyStopLimit.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.Sell.UseSoundOpen(use_sound);
   this.m_datas.Sell.UseSoundClose(use_sound);
   this.m_datas.Sell.UseSoundModifySL(use_sound);
   this.m_datas.Sell.UseSoundModifyTP(use_sound);
   this.m_datas.Sell.UseSoundModifyPrice(use_sound);
   this.m_datas.Sell.SoundOpen(sound_open);
   this.m_datas.Sell.SoundClose(sound_close);
   this.m_datas.Sell.SoundModifySL(sound_sl);
   this.m_datas.Sell.SoundModifyTP(sound_tp);
   this.m_datas.Sell.SoundModifyPrice(sound_price);
   this.m_datas.Sell.SoundErrorClose(sound_error);
   this.m_datas.Sell.SoundErrorOpen(sound_error);
   this.m_datas.Sell.SoundErrorModifySL(sound_error);
   this.m_datas.Sell.SoundErrorModifyTP(sound_error);
   this.m_datas.Sell.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.SellStop.UseSoundOpen(use_sound);
   this.m_datas.SellStop.UseSoundClose(use_sound);
   this.m_datas.SellStop.UseSoundModifySL(use_sound);
   this.m_datas.SellStop.UseSoundModifyTP(use_sound);
   this.m_datas.SellStop.UseSoundModifyPrice(use_sound);
   this.m_datas.SellStop.SoundOpen(sound_open);
   this.m_datas.SellStop.SoundClose(sound_close);
   this.m_datas.SellStop.SoundModifySL(sound_sl);
   this.m_datas.SellStop.SoundModifyTP(sound_tp);
   this.m_datas.SellStop.SoundModifyPrice(sound_price);
   this.m_datas.SellStop.SoundErrorClose(sound_error);
   this.m_datas.SellStop.SoundErrorOpen(sound_error);
   this.m_datas.SellStop.SoundErrorModifySL(sound_error);
   this.m_datas.SellStop.SoundErrorModifyTP(sound_error);
   this.m_datas.SellStop.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.SellLimit.UseSoundOpen(use_sound);
   this.m_datas.SellLimit.UseSoundClose(use_sound);
   this.m_datas.SellLimit.UseSoundModifySL(use_sound);
   this.m_datas.SellLimit.UseSoundModifyTP(use_sound);
   this.m_datas.SellLimit.UseSoundModifyPrice(use_sound);
   this.m_datas.SellLimit.SoundOpen(sound_open);
   this.m_datas.SellLimit.SoundClose(sound_close);
   this.m_datas.SellLimit.SoundModifySL(sound_sl);
   this.m_datas.SellLimit.SoundModifyTP(sound_tp);
   this.m_datas.SellLimit.SoundModifyPrice(sound_price);
   this.m_datas.SellLimit.SoundErrorClose(sound_error);
   this.m_datas.SellLimit.SoundErrorOpen(sound_error);
   this.m_datas.SellLimit.SoundErrorModifySL(sound_error);
   this.m_datas.SellLimit.SoundErrorModifyTP(sound_error);
   this.m_datas.SellLimit.SoundErrorModifyPrice(sound_error);
   
   this.m_datas.SellStopLimit.UseSoundOpen(use_sound);
   this.m_datas.SellStopLimit.UseSoundClose(use_sound);
   this.m_datas.SellStopLimit.UseSoundModifySL(use_sound);
   this.m_datas.SellStopLimit.UseSoundModifyTP(use_sound);
   this.m_datas.SellStopLimit.UseSoundModifyPrice(use_sound);
   this.m_datas.SellStopLimit.SoundOpen(sound_open);
   this.m_datas.SellStopLimit.SoundClose(sound_close);
   this.m_datas.SellStopLimit.SoundModifySL(sound_sl);
   this.m_datas.SellStopLimit.SoundModifyTP(sound_tp);
   this.m_datas.SellStopLimit.SoundModifyPrice(sound_price);
   this.m_datas.SellStopLimit.SoundErrorClose(sound_error);
   this.m_datas.SellStopLimit.SoundErrorOpen(sound_error);
   this.m_datas.SellStopLimit.SoundErrorModifySL(sound_error);
   this.m_datas.SellStopLimit.SoundErrorModifyTP(sound_error);
   this.m_datas.SellStopLimit.SoundErrorModifyPrice(sound_error);
  }  
//+------------------------------------------------------------------+
//| Allow working with sounds and set standard sounds                |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundsStandart(void)
  {
   this.SetUseSound(true);
   this.m_datas.Buy.UseSoundClose(true);
   this.m_datas.Buy.UseSoundOpen(true);
   this.m_datas.Buy.UseSoundModifySL(true);
   this.m_datas.Buy.UseSoundModifyTP(true);
   this.m_datas.Buy.UseSoundModifyPrice(true);
   this.m_datas.Buy.SoundOpen(SND_OK);
   this.m_datas.Buy.SoundClose(SND_OK);
   this.m_datas.Buy.SoundModifySL(SND_OK);
   this.m_datas.Buy.SoundModifyTP(SND_OK);
   this.m_datas.Buy.SoundModifyPrice(SND_OK);
   this.m_datas.Buy.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.Buy.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.Buy.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.Buy.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.Buy.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.BuyStop.UseSoundClose(true);
   this.m_datas.BuyStop.UseSoundOpen(true);
   this.m_datas.BuyStop.UseSoundModifySL(true);
   this.m_datas.BuyStop.UseSoundModifyTP(true);
   this.m_datas.BuyStop.UseSoundModifyPrice(true);
   this.m_datas.BuyStop.SoundOpen(SND_OK);
   this.m_datas.BuyStop.SoundClose(SND_OK);
   this.m_datas.BuyStop.SoundModifySL(SND_OK);
   this.m_datas.BuyStop.SoundModifyTP(SND_OK);
   this.m_datas.BuyStop.SoundModifyPrice(SND_OK);
   this.m_datas.BuyStop.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.BuyStop.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.BuyStop.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.BuyStop.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.BuyStop.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.BuyLimit.UseSoundClose(true);
   this.m_datas.BuyLimit.UseSoundOpen(true);
   this.m_datas.BuyLimit.UseSoundModifySL(true);
   this.m_datas.BuyLimit.UseSoundModifyTP(true);
   this.m_datas.BuyLimit.UseSoundModifyPrice(true);
   this.m_datas.BuyLimit.SoundOpen(SND_OK);
   this.m_datas.BuyLimit.SoundClose(SND_OK);
   this.m_datas.BuyLimit.SoundModifySL(SND_OK);
   this.m_datas.BuyLimit.SoundModifyTP(SND_OK);
   this.m_datas.BuyLimit.SoundModifyPrice(SND_OK);
   this.m_datas.BuyLimit.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.BuyLimit.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.BuyLimit.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.BuyLimit.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.BuyLimit.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.BuyStopLimit.UseSoundClose(true);
   this.m_datas.BuyStopLimit.UseSoundOpen(true);
   this.m_datas.BuyStopLimit.UseSoundModifySL(true);
   this.m_datas.BuyStopLimit.UseSoundModifyTP(true);
   this.m_datas.BuyStopLimit.UseSoundModifyPrice(true);
   this.m_datas.BuyStopLimit.SoundOpen(SND_OK);
   this.m_datas.BuyStopLimit.SoundClose(SND_OK);
   this.m_datas.BuyStopLimit.SoundModifySL(SND_OK);
   this.m_datas.BuyStopLimit.SoundModifyTP(SND_OK);
   this.m_datas.BuyStopLimit.SoundModifyPrice(SND_OK);
   this.m_datas.BuyStopLimit.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.BuyStopLimit.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.BuyStopLimit.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.BuyStopLimit.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.BuyStopLimit.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.Sell.UseSoundClose(true);
   this.m_datas.Sell.UseSoundOpen(true);
   this.m_datas.Sell.UseSoundModifySL(true);
   this.m_datas.Sell.UseSoundModifyTP(true);
   this.m_datas.Sell.UseSoundModifyPrice(true);
   this.m_datas.Sell.SoundOpen(SND_OK);
   this.m_datas.Sell.SoundClose(SND_OK);
   this.m_datas.Sell.SoundModifySL(SND_OK);
   this.m_datas.Sell.SoundModifyTP(SND_OK);
   this.m_datas.Sell.SoundModifyPrice(SND_OK);
   this.m_datas.Sell.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.Sell.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.Sell.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.Sell.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.Sell.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.SellStop.UseSoundClose(true);
   this.m_datas.SellStop.UseSoundOpen(true);
   this.m_datas.SellStop.UseSoundModifySL(true);
   this.m_datas.SellStop.UseSoundModifyTP(true);
   this.m_datas.SellStop.UseSoundModifyPrice(true);
   this.m_datas.SellStop.SoundOpen(SND_OK);
   this.m_datas.SellStop.SoundClose(SND_OK);
   this.m_datas.SellStop.SoundModifySL(SND_OK);
   this.m_datas.SellStop.SoundModifyTP(SND_OK);
   this.m_datas.SellStop.SoundModifyPrice(SND_OK);
   this.m_datas.SellStop.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.SellStop.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.SellStop.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.SellStop.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.SellStop.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.SellLimit.UseSoundClose(true);
   this.m_datas.SellLimit.UseSoundOpen(true);
   this.m_datas.SellLimit.UseSoundModifySL(true);
   this.m_datas.SellLimit.UseSoundModifyTP(true);
   this.m_datas.SellLimit.UseSoundModifyPrice(true);
   this.m_datas.SellLimit.SoundOpen(SND_OK);
   this.m_datas.SellLimit.SoundClose(SND_OK);
   this.m_datas.SellLimit.SoundModifySL(SND_OK);
   this.m_datas.SellLimit.SoundModifyTP(SND_OK);
   this.m_datas.SellLimit.SoundModifyPrice(SND_OK);
   this.m_datas.SellLimit.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.SellLimit.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.SellLimit.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.SellLimit.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.SellLimit.SoundErrorModifyPrice(SND_TIMEOUT);
   
   this.m_datas.SellStopLimit.UseSoundClose(true);
   this.m_datas.SellStopLimit.UseSoundOpen(true);
   this.m_datas.SellStopLimit.UseSoundModifySL(true);
   this.m_datas.SellStopLimit.UseSoundModifyTP(true);
   this.m_datas.SellStopLimit.UseSoundModifyPrice(true);
   this.m_datas.SellStopLimit.SoundOpen(SND_OK);
   this.m_datas.SellStopLimit.SoundClose(SND_OK);
   this.m_datas.SellStopLimit.SoundModifySL(SND_OK);
   this.m_datas.SellStopLimit.SoundModifyTP(SND_OK);
   this.m_datas.SellStopLimit.SoundModifyPrice(SND_OK);
   this.m_datas.SellStopLimit.SoundErrorClose(SND_TIMEOUT);
   this.m_datas.SellStopLimit.SoundErrorOpen(SND_TIMEOUT);
   this.m_datas.SellStopLimit.SoundErrorModifySL(SND_TIMEOUT);
   this.m_datas.SellStopLimit.SoundErrorModifyTP(SND_TIMEOUT);
   this.m_datas.SellStopLimit.SoundErrorModifyPrice(SND_TIMEOUT);
  }
//+------------------------------------------------------------------+
//| Open a position                                                  |
//+------------------------------------------------------------------+
bool CTradeObj::OpenPosition(const ENUM_POSITION_TYPE type,
                             const double volume,
                             const double sl=0,
                             const double tp=0,
                             const ulong magic=ULONG_MAX,
                             const string comment=NULL,
                             const ulong deviation=ULONG_MAX)
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
                              const string comment=NULL,
                              const ulong deviation=ULONG_MAX)
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
                                       const string comment=NULL,
                                       const ulong deviation=ULONG_MAX)
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
                         const string comment=NULL,
                         const datetime expiration=0,
                         const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
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
//| Set the flag of using sounds                                     |
//| of opening/placing a specified position/order type               |
//+------------------------------------------------------------------+
void CTradeObj::UseSoundOpen(const int action,const bool flag)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.UseSoundOpen(flag);           break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.UseSoundOpen(flag);       break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.UseSoundOpen(flag);      break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.UseSoundOpen(flag);          break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.UseSoundOpen(flag);      break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.UseSoundOpen(flag);     break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.UseSoundOpen(flag);  break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.UseSoundOpen(flag); break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the flag of using a sound                                    |
//| of closing/removal of a specified position/order type            |
//+------------------------------------------------------------------+
void CTradeObj::UseSoundClose(const int action,const bool flag)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.UseSoundClose(flag);             break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.UseSoundClose(flag);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.UseSoundClose(flag);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.UseSoundClose(flag);    break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.UseSoundClose(flag);            break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.UseSoundClose(flag);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.UseSoundClose(flag);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.UseSoundClose(flag);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the flag of using a sound                                    |
//| of StopLoss modification for a specified position/order type     |
//+------------------------------------------------------------------+
void CTradeObj::UseSoundModifySL(const int action,const bool flag)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.UseSoundModifySL(flag);             break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.UseSoundModifySL(flag);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.UseSoundModifySL(flag);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.UseSoundModifySL(flag);    break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.UseSoundModifySL(flag);            break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.UseSoundModifySL(flag);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.UseSoundModifySL(flag);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.UseSoundModifySL(flag);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the flag of using a sound                                    |
//| of TakeProfit modification for a specified position/order type   |
//+------------------------------------------------------------------+
void CTradeObj::UseSoundModifyTP(const int action,const bool flag)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.UseSoundModifyTP(flag);             break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.UseSoundModifyTP(flag);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.UseSoundModifyTP(flag);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.UseSoundModifyTP(flag);    break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.UseSoundModifyTP(flag);            break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.UseSoundModifyTP(flag);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.UseSoundModifyTP(flag);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.UseSoundModifyTP(flag);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the flag of using a modification sound                       |
//| of the placement price for a specified order type                |
//+------------------------------------------------------------------+
void CTradeObj::UseSoundModifyPrice(const int action,const bool flag)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.UseSoundModifyPrice(flag);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.UseSoundModifyPrice(flag);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.UseSoundModifyPrice(flag);    break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.UseSoundModifyPrice(flag);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.UseSoundModifyPrice(flag);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.UseSoundModifyPrice(flag);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of using the sound of opening/placing            |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
bool CTradeObj::UseSoundOpen(const int action) const
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.UseSoundOpen();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.UseSoundOpen();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.UseSoundOpen();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.UseSoundOpen();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.UseSoundOpen();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.UseSoundOpen();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.UseSoundOpen();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.UseSoundOpen();
      default: return false;
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of using the sound of closing/removal of         |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
bool CTradeObj::UseSoundClose(const int action) const
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.UseSoundClose();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.UseSoundClose();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.UseSoundClose();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.UseSoundClose();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.UseSoundClose();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.UseSoundClose();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.UseSoundClose();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.UseSoundClose();
      default: return false;
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of using a sound                                 |
//| of StopLoss modification for a specified position/order type     |
//+------------------------------------------------------------------+
bool CTradeObj::UseSoundModifySL(const int action) const
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.UseSoundModifySL();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.UseSoundModifySL();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.UseSoundModifySL();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.UseSoundModifySL();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.UseSoundModifySL();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.UseSoundModifySL();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.UseSoundModifySL();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.UseSoundModifySL();
      default: return false;
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of using a sound                                 |
//| of TakeProfit modification for a specified position/order type   |
//+------------------------------------------------------------------+
bool CTradeObj::UseSoundModifyTP(const int action) const
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.UseSoundModifyTP();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.UseSoundModifyTP();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.UseSoundModifyTP();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.UseSoundModifyTP();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.UseSoundModifyTP();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.UseSoundModifyTP();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.UseSoundModifyTP();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.UseSoundModifyTP();
      default: return false;
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of using a modification sound                    |
//| of the placement price for a specified order type                |
//+------------------------------------------------------------------+
bool CTradeObj::UseSoundModifyPrice(const int action) const
  {
   switch(action)
     {
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.UseSoundModifyPrice();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.UseSoundModifyPrice();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.UseSoundModifyPrice();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.UseSoundModifyPrice();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.UseSoundModifyPrice();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.UseSoundModifyPrice();
      default: return false;
     }
  }
//+------------------------------------------------------------------+
//| Set the sound of opening/placing                                 |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundOpen(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundOpen(sound);             break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundOpen(sound);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundOpen(sound);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundOpen(sound);    break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundOpen(sound);            break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundOpen(sound);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundOpen(sound);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundOpen(sound);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the sound of closing/removal of                              |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundClose(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundClose(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundClose(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundClose(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundClose(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundClose(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundClose(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundClose(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundClose(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set StopLoss modification sound of                               |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundModifySL(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundModifySL(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundModifySL(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundModifySL(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundModifySL(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundModifySL(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundModifySL(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundModifySL(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundModifySL(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set TakeProfit modification sound of                             |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundModifyTP(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundModifyTP(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundModifyTP(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundModifyTP(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundModifyTP(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundModifyTP(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundModifyTP(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundModifyTP(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundModifyTP(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set price modification sound                                     |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundModifyPrice(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundModifyPrice(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundModifyPrice(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundModifyPrice(sound);   break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundModifyPrice(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundModifyPrice(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundModifyPrice(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the error sound of opening/placing                           |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundErrorOpen(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundErrorOpen(sound);             break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundErrorOpen(sound);         break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundErrorOpen(sound);        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundErrorOpen(sound);    break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundErrorOpen(sound);            break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundErrorOpen(sound);        break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundErrorOpen(sound);       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundErrorOpen(sound);   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set the error sound of closing/removal of                        |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundErrorClose(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundErrorClose(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundErrorClose(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundErrorClose(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundErrorClose(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundErrorClose(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundErrorClose(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundErrorClose(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundErrorClose(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set StopLoss modification error sound of                         |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundErrorModifySL(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundErrorModifySL(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundErrorModifySL(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundErrorModifySL(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundErrorModifySL(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundErrorModifySL(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundErrorModifySL(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundErrorModifySL(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundErrorModifySL(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set TakeProfit modification error sound of                       |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundErrorModifyTP(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   this.m_datas.Buy.SoundErrorModifyTP(sound);            break;
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundErrorModifyTP(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundErrorModifyTP(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundErrorModifyTP(sound);   break;
      case ORDER_TYPE_SELL             :   this.m_datas.Sell.SoundErrorModifyTP(sound);           break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundErrorModifyTP(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundErrorModifyTP(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundErrorModifyTP(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Set price modification error sound                               |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
void CTradeObj::SetSoundErrorModifyPrice(const ENUM_ORDER_TYPE action,const string sound)
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY_STOP         :   this.m_datas.BuyStop.SoundErrorModifyPrice(sound);        break;
      case ORDER_TYPE_BUY_LIMIT        :   this.m_datas.BuyLimit.SoundErrorModifyPrice(sound);       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   this.m_datas.BuyStopLimit.SoundErrorModifyPrice(sound);   break;
      case ORDER_TYPE_SELL_STOP        :   this.m_datas.SellStop.SoundErrorModifyPrice(sound);       break;
      case ORDER_TYPE_SELL_LIMIT       :   this.m_datas.SellLimit.SoundErrorModifyPrice(sound);      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   this.m_datas.SellStopLimit.SoundErrorModifyPrice(sound);  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Return the sound of opening/placing                              |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundOpen(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundOpen();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundOpen();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundOpen();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundOpen();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundOpen();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundOpen();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundOpen();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundOpen();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return the sound of closing/removal of                           |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundClose(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundClose();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundClose();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundClose();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundClose();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundClose();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundClose();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundClose();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundClose();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return StopLoss modification sound of                            |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundModifySL(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundModifySL();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundModifySL();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundModifySL();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundModifySL();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundModifySL();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundModifySL();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundModifySL();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundModifySL();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return TakeProfit modification sound of                          |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundModifyTP(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundModifyTP();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundModifyTP();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundModifyTP();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundModifyTP();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundModifyTP();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundModifyTP();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundModifyTP();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundModifyTP();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return price modification sound                                  |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundModifyPrice(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundModifyPrice();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundModifyPrice();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundModifyPrice();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundModifyPrice();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundModifyPrice();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundModifyPrice();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return the error sound of opening/placing                        |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundErrorOpen(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundErrorOpen();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundErrorOpen();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundErrorOpen();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundErrorOpen();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundErrorOpen();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundErrorOpen();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundErrorOpen();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundErrorOpen();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return the error sound of closing/removal of                     |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundErrorClose(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundErrorClose();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundErrorClose();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundErrorClose();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundErrorClose();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundErrorClose();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundErrorClose();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundErrorClose();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundErrorClose();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return StopLoss modification error sound of                      |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundErrorModifySL(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundErrorModifySL();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundErrorModifySL();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundErrorModifySL();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundErrorModifySL();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundErrorModifySL();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundErrorModifySL();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundErrorModifySL();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundErrorModifySL();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return TakeProfit modification error sound of                    |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundErrorModifyTP(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY              :   return this.m_datas.Buy.SoundErrorModifyTP();
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundErrorModifyTP();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundErrorModifyTP();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundErrorModifyTP();
      case ORDER_TYPE_SELL             :   return this.m_datas.Sell.SoundErrorModifyTP();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundErrorModifyTP();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundErrorModifyTP();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundErrorModifyTP();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Return price modification error sound                            |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
string CTradeObj::GetSoundErrorModifyPrice(const ENUM_ORDER_TYPE action) const
  {
   int index=action;
   switch(index)
     {
      case ORDER_TYPE_BUY_STOP         :   return this.m_datas.BuyStop.SoundErrorModifyPrice();
      case ORDER_TYPE_BUY_LIMIT        :   return this.m_datas.BuyLimit.SoundErrorModifyPrice();
      case ORDER_TYPE_BUY_STOP_LIMIT   :   return this.m_datas.BuyStopLimit.SoundErrorModifyPrice();
      case ORDER_TYPE_SELL_STOP        :   return this.m_datas.SellStop.SoundErrorModifyPrice();
      case ORDER_TYPE_SELL_LIMIT       :   return this.m_datas.SellLimit.SoundErrorModifyPrice();
      case ORDER_TYPE_SELL_STOP_LIMIT  :   return this.m_datas.SellStopLimit.SoundErrorModifyPrice();
      default: return NULL;
     }
  }
//+------------------------------------------------------------------+
//| Play the sound of opening/placing                                |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundOpen(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.Buy.SoundOpen());             break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyStop.SoundOpen());         break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyLimit.SoundOpen());        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundOpen());    break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.Sell.SoundOpen());            break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellStop.SoundOpen());        break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellLimit.SoundOpen());       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellStopLimit.SoundOpen());   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play the sound of closing/removal of                             |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundClose(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.Buy.SoundClose());            break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundClose());        break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundClose());       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundClose());   break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.Sell.SoundClose());           break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundClose());       break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundClose());      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundClose());  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play StopLoss modification sound of                              |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundModifySL(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.Buy.SoundModifySL());            break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundModifySL());        break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundModifySL());       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundModifySL());   break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.Sell.SoundModifySL());           break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundModifySL());       break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundModifySL());      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundModifySL());  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play TakeProfit modification sound of                            |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundModifyTP(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.Buy.SoundModifyTP());            break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundModifyTP());        break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundModifyTP());       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundModifyTP());   break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.Sell.SoundModifyTP());           break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundModifyTP());       break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundModifyTP());      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundModifyTP());  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play price modification sound                                    |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundModifyPrice(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundModifyPrice());        break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundModifyPrice());       break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundModifyPrice());   break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundModifyPrice());       break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundModifyPrice());      break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundModifyPrice());  break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play the error sound of opening/placing                          |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundErrorOpen(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.Buy.SoundErrorOpen());              break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyStop.SoundErrorOpen());          break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyLimit.SoundErrorOpen());         break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundErrorOpen());     break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.Sell.SoundErrorOpen());             break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellStop.SoundErrorOpen());         break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellLimit.SoundErrorOpen());        break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundOpen(action))   CMessage::PlaySound(this.m_datas.SellStopLimit.SoundErrorOpen());    break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play the error sound of closing/removal of                       |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundErrorClose(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.Buy.SoundErrorClose());             break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundErrorClose());         break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundErrorClose());        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundErrorClose());    break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.Sell.SoundErrorClose());            break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundErrorClose());        break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundErrorClose());       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundClose(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundErrorClose());   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play StopLoss modification error sound of                        |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundErrorModifySL(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.Buy.SoundErrorModifySL());             break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundErrorModifySL());         break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundErrorModifySL());        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundErrorModifySL());    break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.Sell.SoundErrorModifySL());            break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundErrorModifySL());        break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundErrorModifySL());       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifySL(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundErrorModifySL());   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play TakeProfit modification error sound of                      |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundErrorModifyTP(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY              :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.Buy.SoundErrorModifyTP());             break;
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundErrorModifyTP());         break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundErrorModifyTP());        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundErrorModifyTP());    break;
      case ORDER_TYPE_SELL             :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.Sell.SoundErrorModifyTP());            break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundErrorModifyTP());        break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundErrorModifyTP());       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifyTP(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundErrorModifyTP());   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play price modification error sound                              |
//| for a specified order type                                       |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundErrorModifyPrice(const int action)
  {
   switch(action)
     {
      case ORDER_TYPE_BUY_STOP         :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyStop.SoundErrorModifyPrice());         break;
      case ORDER_TYPE_BUY_LIMIT        :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyLimit.SoundErrorModifyPrice());        break;
      case ORDER_TYPE_BUY_STOP_LIMIT   :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.BuyStopLimit.SoundErrorModifyPrice());    break;
      case ORDER_TYPE_SELL_STOP        :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellStop.SoundErrorModifyPrice());        break;
      case ORDER_TYPE_SELL_LIMIT       :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellLimit.SoundErrorModifyPrice());       break;
      case ORDER_TYPE_SELL_STOP_LIMIT  :   if(this.UseSoundModifyPrice(action))  CMessage::PlaySound(this.m_datas.SellStopLimit.SoundErrorModifyPrice());   break;
      default: break;
     }
  }
//+------------------------------------------------------------------+
//| Play a sound of a specified trading event                        |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundSuccess(const ENUM_ACTION_TYPE action,const int order,bool sl=false,bool tp=false,bool pr=false)
  {
   if(!this.m_use_sound)
      return;
   switch((int)action)
     {
      //--- Open/set
      case ACTION_TYPE_BUY             :
      case ACTION_TYPE_BUY_LIMIT       :
      case ACTION_TYPE_BUY_STOP        :
      case ACTION_TYPE_BUY_STOP_LIMIT  :
      case ACTION_TYPE_SELL            :
      case ACTION_TYPE_SELL_LIMIT      :
      case ACTION_TYPE_SELL_STOP       :
      case ACTION_TYPE_SELL_STOP_LIMIT :
        this.PlaySoundOpen(order);  
        break;
      //--- Close/remove
      case ACTION_TYPE_CLOSE           :
      case ACTION_TYPE_CLOSE_BY        :
        this.PlaySoundClose(order); 
        break;
      //--- Modification
      case ACTION_TYPE_MODIFY          :
        if(sl) { this.PlaySoundModifySL(order);    return; }
        if(tp) { this.PlaySoundModifyTP(order);    return; }
        if(pr) { this.PlaySoundModifyPrice(order); return; }
        break;
      default:
        break;
     }
  }
//+------------------------------------------------------------------+
//| Play an error sound of a specified trading event                 |
//| a specified position/order type                                  |
//+------------------------------------------------------------------+
void CTradeObj::PlaySoundError(const ENUM_ACTION_TYPE action,const int order,bool sl=false,bool tp=false,bool pr=false)
  {
   if(!this.m_use_sound)
      return;
   switch((int)action)
     {
      //--- Open/set
      case ACTION_TYPE_BUY             :
      case ACTION_TYPE_BUY_LIMIT       :
      case ACTION_TYPE_BUY_STOP        :
      case ACTION_TYPE_BUY_STOP_LIMIT  :
      case ACTION_TYPE_SELL            :
      case ACTION_TYPE_SELL_LIMIT      :
      case ACTION_TYPE_SELL_STOP       :
      case ACTION_TYPE_SELL_STOP_LIMIT :
        this.PlaySoundErrorOpen(order);
        break;
      //--- Close/remove
      case ACTION_TYPE_CLOSE           :
      case ACTION_TYPE_CLOSE_BY        :
        this.PlaySoundErrorClose(order);
        break;
      //--- Modification
      case ACTION_TYPE_MODIFY          :
        if(sl) { this.PlaySoundErrorModifySL(order);    return; }
        if(tp) { this.PlaySoundErrorModifyTP(order);    return; }
        if(pr) { this.PlaySoundErrorModifyPrice(order); return; }
        break;
      default:
        break;
     }
  }
//+------------------------------------------------------------------+
