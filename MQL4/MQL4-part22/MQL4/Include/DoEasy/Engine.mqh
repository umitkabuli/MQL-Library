//+------------------------------------------------------------------+
//|                                                       Engine.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "Services\TimerCounter.mqh"
#include "Collections\HistoryCollection.mqh"
#include "Collections\MarketCollection.mqh"
#include "Collections\EventsCollection.mqh"
#include "Collections\AccountsCollection.mqh"
#include "Collections\SymbolsCollection.mqh"
#include "Collections\ResourceCollection.mqh"
#include "Trading.mqh"
//+------------------------------------------------------------------+
//| Library basis class                                              |
//+------------------------------------------------------------------+
class CEngine
  {
private:
   CHistoryCollection   m_history;                       // Collection of historical orders and deals
   CMarketCollection    m_market;                        // Collection of market orders and deals
   CEventsCollection    m_events;                        // Collection of events
   CAccountsCollection  m_accounts;                      // Account collection
   CSymbolsCollection   m_symbols;                       // Symbol collection
   CResourceCollection  m_resource;                      // Resource list
   CTrading             m_trading;                       // Trading class object
   CArrayObj            m_list_counters;                 // List of timer counters
   int                  m_global_error;                  // Global error code
   bool                 m_first_start;                   // First launch flag
   bool                 m_is_hedge;                      // Hedge account flag
   bool                 m_is_tester;                     // Flag of working in the tester
   bool                 m_is_market_trade_event;         // Account trading event flag
   bool                 m_is_history_trade_event;        // Account history trading event flag
   bool                 m_is_account_event;              // Account change event flag
   bool                 m_is_symbol_event;               // Symbol change event flag
   ENUM_TRADE_EVENT     m_last_trade_event;              // Last account trading event
   int                  m_last_account_event;            // Last event in the account properties
   int                  m_last_symbol_event;             // Last event in the symbol properties
//--- Return the counter index by id
   int                  CounterIndex(const int id) const;
//--- Return the (1) first launch flag, (2) presence of the flag in the trading event
   bool                 IsFirstStart(void);
//--- Work with (1) order, deal and position, (2) account events
   void                 TradeEventsControl(void);
   void                 AccountEventsControl(void);
//--- (1) Working with a symbol collection and (2) symbol list events in the market watch window
   void                 SymbolEventsControl(void);
   void                 MarketWatchEventsControl(void);
//--- Return the last (1) market pending order, (2) market order, (3) last position, (4) position by ticket
   COrder              *GetLastMarketPending(void);
   COrder              *GetLastMarketOrder(void);
   COrder              *GetLastPosition(void);
   COrder              *GetPosition(const ulong ticket);
//--- Return the last (1) removed pending order, (2) historical market order, (3) historical order (market or pending one) by its ticket
   COrder              *GetLastHistoryPending(void);
   COrder              *GetLastHistoryOrder(void);
   COrder              *GetHistoryOrder(const ulong ticket);
//--- Return the (1) first and the (2) last historical market orders from the list of all position orders, (3) the last deal
   COrder              *GetFirstOrderPosition(const ulong position_id);
   COrder              *GetLastOrderPosition(const ulong position_id);
   COrder              *GetLastDeal(void);
//--- Retrieve a necessary 'ushort' number from the packed 'long' value
   ushort               LongToUshortFromByte(const long source_value,const uchar index) const;
   
public:
//--- Return the list of market (1) positions, (2) pending orders and (3) market orders
   CArrayObj           *GetListMarketPosition(void);
   CArrayObj           *GetListMarketPendings(void);
   CArrayObj           *GetListMarketOrders(void);
//--- Return the list of historical (1) orders, (2) removed pending orders, (3) deals,
//--- (4) all market orders of a position by its ID, (5) description of the last trading event
   CArrayObj           *GetListHistoryOrders(void);
   CArrayObj           *GetListHistoryPendings(void);
   CArrayObj           *GetListDeals(void);
   CArrayObj           *GetListAllOrdersByPosID(const ulong position_id);
   string               GetLastTradeEventDescription(void);

//--- Return the list of (1) accounts, (2) account events, (3) account change event by its index in the list
//--- (4) the current account, (5) event description
   CArrayObj           *GetListAllAccounts(void)                        { return this.m_accounts.GetList();                   }
   CArrayObj           *GetListAccountEvents(void)                      { return this.m_accounts.GetListEvents();             }
   int                  GetAccountEventByIndex(const int index=-1)      { return this.m_accounts.GetEventID(index);           }
   CAccount            *GetAccountCurrent(void);
   
//--- Return the list of (1) used symbols, (2) symbol events, (3) the last symbol change event
//--- (4) the current symbol, (5) symbol event description, (6) Market Watch event description
   CArrayObj           *GetListAllUsedSymbols(void)                     { return this.m_symbols.GetList();                    }
   CArrayObj           *GetListSymbolsEvents(void)                      { return this.m_symbols.GetListEvents();              }
   int                  GetLastSymbolsEvent()                           { return this.m_symbols.GetLastEvent();               }
   CSymbol             *GetSymbolCurrent(void)                          { return this.m_symbols.GetSymbolObjByName(::Symbol());}
   string               GetMWEventDescription(ENUM_MW_EVENT event)      { return this.m_symbols.EventMWDescription(event);    }
   string               ModeSymbolsListDescription(void)                { return this.m_symbols.ModeSymbolsListDescription(); }
   
//--- Return the list of order, deal and position events
   CArrayObj           *GetListAllOrdersEvents(void)                    { return this.m_events.GetList();                     }
//--- Reset the last trading event
   void                 ResetLastTradeEvent(void)                       { this.m_events.ResetLastTradeEvent(); }
//--- Return the (1) last trading event, (2) the last event in the account properties, (3) hedging account flag
   ENUM_TRADE_EVENT     LastTradeEvent(void)                      const { return this.m_last_trade_event;                     }
   int                  LastAccountEvent(void)                    const { return this.m_last_account_event;                   }
   int                  LastSymbolsEvent(void)                    const { return this.m_last_symbol_event;                    }
//--- Return the (1) hedge account, (2) working in the tester, (3) account event and (4) symbol event flag
   bool                 IsHedge(void)                             const { return this.m_is_hedge;                             }
   bool                 IsTester(void)                            const { return this.m_is_tester;                            }
   bool                 IsAccountsEvent(void)                     const { return this.m_accounts.IsEvent();                   }
   bool                 IsSymbolsEvent(void)                      const { return this.m_symbols.IsEvent();                    }
//--- Return the (1) symbol object by name, as well as the code of the last event of (2) an account and (3) a symbol

   CSymbol             *GetSymbolObjByName(const string name)           { return this.m_symbols.GetSymbolObjByName(name);     }
   int                  GetAccountEventsCode(void)                const { return this.m_accounts.GetEventCode();              }
   int                  GetSymbolsEventsCode(void)                const { return this.m_symbols.GetLastEventsCode();          }
//--- Return the number of (1) symbols, (2) events in the symbol collection
   int                  GetSymbolsCollectionTotal(void)           const { return this.m_symbols.GetSymbolsCollectionTotal();  }
   int                  GetSymbolsCollectionEventsTotal(void)     const { return this.m_symbols.GetEventsTotal();             }
//--- Return CEngine global error code
   int                  GetError(void)                            const { return this.m_global_error;                         }
//--- Create the timer counter
   void                 CreateCounter(const int id,const ulong frequency,const ulong pause);
//--- Timer
   void                 OnTimer(void);
//--- Set the list of (1) used symbols
   bool                 SetUsedSymbols(const string &array_symbols[])   { return this.m_symbols.SetUsedSymbols(array_symbols);}
//--- Create a resource file
   bool                 CreateFile(const ENUM_FILE_TYPE file_type,const string file_name,const string descript,const uchar &file_data_array[])
                          {
                           return this.m_resource.CreateFile(file_type,file_name,descript,file_data_array);
                          }
//--- Return (1) the list of references to resources, (2) resource object index by its description
   CArrayObj           *GetListResource(void)                                 { return this.m_resource.GetList();                               }
   int                  GetIndexResObjByDescription(const string file_name)   { return this.m_resource.GetIndexResObjByDescription(file_name);  }

//--- Set the following for the trading classes:
//--- (1) correct filling policy, (2) filling policy,
//--- (3) correct order expiration type, (4) order expiration type,
//--- (5) magic number, (6) comment, (7) slippage, (8) volume, (9) order expiration date,
//--- (10) the flag of asynchronous sending of a trading request, (11) logging level
   void                 TradingSetCorrectTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol_name=NULL);
   void                 TradingSetTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol_name=NULL);
   void                 TradingSetCorrectTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol_name=NULL);
   void                 TradingSetTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol_name=NULL);
   void                 TradingSetMagic(const ulong magic,const string symbol_name=NULL);
   void                 TradingSetComment(const string comment,const string symbol_name=NULL);
   void                 TradingSetDeviation(const ulong deviation,const string symbol_name=NULL);
   void                 TradingSetVolume(const double volume=0,const string symbol_name=NULL);
   void                 TradingSetExpiration(const datetime expiration=0,const string symbol_name=NULL);
   void                 TradingSetAsyncMode(const bool mode=false,const string symbol_name=NULL);
   void                 TradingSetLogLevel(const ENUM_LOG_LEVEL log_level=LOG_LEVEL_ERROR_MSG,const string symbol_name=NULL);
   
//--- Set standard sounds (symbol==NULL) for a symbol trading object, (symbol!=NULL) for trading objects of all symbols
   void                 SetSoundsStandart(const string symbol=NULL)
                          {
                           this.m_trading.SetSoundsStandart(symbol);
                          }

//--- Set a sound for a specified order/position type and symbol. 'mode' specifies an event a sound is set for
//--- (symbol=NULL) for trading objects of all symbols, (symbol!=NULL) for a trading object of a specified symbol
   void                 SetSound(const ENUM_MODE_SET_SOUND mode,const ENUM_ORDER_TYPE action,const string sound,const string symbol=NULL)
                          {
                           this.m_trading.SetSound(mode,action,sound,symbol);
                          }
//--- Play a sound by its description
   bool                 PlaySoundByDescription(const string sound_description);

//--- Pass the pointers to all the necessary collections to the trading class
   void                 TradingOnInit(void)
                          {
                           this.m_trading.OnInit(this.GetAccountCurrent(),m_symbols.GetObject(),m_market.GetObject(),m_history.GetObject());
                          }
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

//--- Return event (1) milliseconds, (2) reason and (3) source from its 'long' value
   ushort               EventMSC(const long lparam)               const { return this.LongToUshortFromByte(lparam,0);         }
   ushort               EventReason(const long lparam)            const { return this.LongToUshortFromByte(lparam,1);         }
   ushort               EventSource(const long lparam)            const { return this.LongToUshortFromByte(lparam,2);         }

//--- Constructor/destructor
                        CEngine();
                       ~CEngine();
  };
//+------------------------------------------------------------------+
//| CEngine constructor                                              |
//+------------------------------------------------------------------+
CEngine::CEngine() : m_first_start(true),
                     m_last_trade_event(TRADE_EVENT_NO_EVENT),
                     m_last_account_event(WRONG_VALUE),
                     m_last_symbol_event(WRONG_VALUE),
                     m_global_error(ERR_SUCCESS)
  {
   this.m_is_hedge=#ifdef __MQL4__ true #else bool(::AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) #endif;
   this.m_is_tester=::MQLInfoInteger(MQL_TESTER);
   
   this.m_list_counters.Sort();
   this.m_list_counters.Clear();
   this.CreateCounter(COLLECTION_ORD_COUNTER_ID,COLLECTION_ORD_COUNTER_STEP,COLLECTION_ORD_PAUSE);
   this.CreateCounter(COLLECTION_ACC_COUNTER_ID,COLLECTION_ACC_COUNTER_STEP,COLLECTION_ACC_PAUSE);
   
   this.CreateCounter(COLLECTION_SYM_COUNTER_ID1,COLLECTION_SYM_COUNTER_STEP1,COLLECTION_SYM_PAUSE1);
   this.CreateCounter(COLLECTION_SYM_COUNTER_ID2,COLLECTION_SYM_COUNTER_STEP2,COLLECTION_SYM_PAUSE2);
   
   ::ResetLastError();
   #ifdef __MQL5__
      if(!::EventSetMillisecondTimer(TIMER_FREQUENCY))
        {
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_TIMER),(string)::GetLastError());
         this.m_global_error=::GetLastError();
        }
   //---__MQL4__
   #else 
      if(!this.IsTester() && !::EventSetMillisecondTimer(TIMER_FREQUENCY))
        {
         ::Print(DFUN_ERR_LINE,CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_TIMER),(string)::GetLastError());
         this.m_global_error=::GetLastError();
        }
   #endif 
   //---
  }
//+------------------------------------------------------------------+
//| CEngine destructor                                               |
//+------------------------------------------------------------------+
CEngine::~CEngine()
  {
   ::EventKillTimer();
  }
//+------------------------------------------------------------------+
//| CEngine timer                                                    |
//+------------------------------------------------------------------+
void CEngine::OnTimer(void)
  {
//--- Timer of the collections of historical orders and deals, as well as of market orders and positions
   int index=this.CounterIndex(COLLECTION_ORD_COUNTER_ID);
   if(index>WRONG_VALUE)
     {
      CTimerCounter* counter=this.m_list_counters.At(index);
      if(counter!=NULL)
        {
         //--- If this is not a tester
         if(!this.IsTester())
           {
            //--- If unpaused, work with the order, deal and position collections events
            if(counter.IsTimeDone())
               this.TradeEventsControl();
           }
         //--- If this is a tester, work with collection events by tick
         else
            this.TradeEventsControl();
        }
     }
//--- Account collection timer
   index=this.CounterIndex(COLLECTION_ACC_COUNTER_ID);
   if(index>WRONG_VALUE)
     {
      CTimerCounter* counter=this.m_list_counters.At(index);
      if(counter!=NULL)
        {
         //--- If this is not a tester
         if(!this.IsTester())
           {
            //--- If unpaused, work with the account collection events
            if(counter.IsTimeDone())
               this.AccountEventsControl();
           }
         //--- If this is a tester, work with collection events by tick
         else
            this.AccountEventsControl();
        }
     }
     
//--- Timer 1 of the symbol collection (updating symbol quote data in the collection)
   index=this.CounterIndex(COLLECTION_SYM_COUNTER_ID1);
   if(index>WRONG_VALUE)
     {
      CTimerCounter* counter=this.m_list_counters.At(index);
      if(counter!=NULL)
        {
         //--- If this is not a tester
         if(!this.IsTester())
           {
            //--- If the pause is over, update quote data of all symbols in the collection
            if(counter.IsTimeDone())
               this.m_symbols.RefreshRates();
           }
         //--- In case of a tester, update quote data of all collection symbols by tick
         else
            this.m_symbols.RefreshRates();
        }
     }
//--- Timer 2 of the symbol collection (updating all data of all symbols in the collection and tracking symbl and symbol search events in the market watch window)
   index=this.CounterIndex(COLLECTION_SYM_COUNTER_ID2);
   if(index>WRONG_VALUE)
     {
      CTimerCounter* counter=this.m_list_counters.At(index);
      if(counter!=NULL)
        {
         //--- If this is not a tester
         if(!this.IsTester())
           {
            //--- If the pause is over
            if(counter.IsTimeDone())
              {
               //--- update data and work with events of all symbols in the collection
               this.SymbolEventsControl();
               //--- When working with the market watch list, check the market watch window events
               if(this.m_symbols.ModeSymbolsList()==SYMBOLS_MODE_MARKET_WATCH)
                  this.MarketWatchEventsControl();
              }
           }
         //--- If this is a tester, work with events of all symbols in the collection by tick
         else
            this.SymbolEventsControl();
        }
     }
  }
//+------------------------------------------------------------------+
//| Create the timer counter                                         |
//+------------------------------------------------------------------+
void CEngine::CreateCounter(const int id,const ulong step,const ulong pause)
  {
   if(this.CounterIndex(id)>WRONG_VALUE)
     {
      ::Print(CMessage::Text(MSG_LIB_SYS_ERROR_ALREADY_CREATED_COUNTER),(string)id);
      return;
     }
   m_list_counters.Sort();
   CTimerCounter* counter=new CTimerCounter(id);
   if(counter==NULL)
      ::Print(CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_COUNTER),(string)id);
   counter.SetParams(step,pause);
   if(this.m_list_counters.Search(counter)==WRONG_VALUE)
      this.m_list_counters.Add(counter);
   else
     {
      string t1=CMessage::Text(MSG_LIB_TEXT_ERROR_COUNTER_WITN_ID)+(string)id;
      string t2=CMessage::Text(MSG_LIB_TEXT_STEP)+(string)step;
      string t3=CMessage::Text(MSG_LIB_TEXT_AND_PAUSE)+(string)pause;
      ::Print(t1+t2+t3+CMessage::Text(MSG_LIB_TEXT_ALREADY_EXISTS));
      delete counter;
     }
  }
//+------------------------------------------------------------------+
//| Return the counter index by id                                   |
//+------------------------------------------------------------------+
int CEngine::CounterIndex(const int id) const
  {
   int total=this.m_list_counters.Total();
   for(int i=0;i<total;i++)
     {
      CTimerCounter* counter=this.m_list_counters.At(i);
      if(counter==NULL) continue;
      if(counter.Type()==id) 
         return i;
     }
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Return the first launch flag, reset the flag                     |
//+------------------------------------------------------------------+
bool CEngine::IsFirstStart(void)
  {
   if(this.m_first_start)
     {
      this.m_first_start=false;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Check trading events                                             |
//+------------------------------------------------------------------+
void CEngine::TradeEventsControl(void)
  {
//--- Initialize trading events' flags
   this.m_is_market_trade_event=false;
   this.m_is_history_trade_event=false;
//--- Update the lists 
   this.m_market.Refresh();
   this.m_history.Refresh();
//--- First launch actions
   if(this.IsFirstStart())
     {
      this.m_last_trade_event=TRADE_EVENT_NO_EVENT;
      return;
     }
//--- Check the changes in the market status and account history 
   this.m_is_market_trade_event=this.m_market.IsTradeEvent();
   this.m_is_history_trade_event=this.m_history.IsTradeEvent();

//--- If there is any event, send the lists, the flags and the number of new orders and deals to the event collection, and update it
   int change_total=0;
   CArrayObj* list_changes=this.m_market.GetListChanges();
   if(list_changes!=NULL)
      change_total=list_changes.Total();
   if(this.m_is_history_trade_event || this.m_is_market_trade_event || change_total>0)
     {
      this.m_events.Refresh(this.m_history.GetList(),this.m_market.GetList(),list_changes,this.m_market.GetListControl(),
                            this.m_is_history_trade_event,this.m_is_market_trade_event,
                            this.m_history.NewOrders(),this.m_market.NewPendingOrders(),
                            this.m_market.NewPositions(),this.m_history.NewDeals(),
                            this.m_market.ChangedVolumeValue());
      //--- Receive the last account trading event
      this.m_last_trade_event=this.m_events.GetLastTradeEvent();
     }
  }
//+------------------------------------------------------------------+
//| Check account events                                             |
//+------------------------------------------------------------------+
void CEngine::AccountEventsControl(void)
  {
//--- Check account property changes and set the flag of the account change events
   this.m_accounts.RefreshAndEventsControl();
   this.m_is_account_event=this.m_accounts.IsEvent();
//--- If there are account property changes
   if(this.m_is_account_event)
     {
      //--- Get the last event of the account property change
      this.m_last_account_event=this.m_accounts.GetEventID();
     }
  }
//+------------------------------------------------------------------+
//| Working with symbol collection events                            |
//+------------------------------------------------------------------+
void CEngine::SymbolEventsControl(void)
  {
   this.m_symbols.RefreshAndEventsControl();
   this.m_is_symbol_event=this.m_symbols.IsEvent();
//--- If there are changes in symbol properties
   if(this.m_is_symbol_event)
     {
      //--- Get the last event of the symbol property change
      this.m_last_symbol_event=this.m_symbols.GetLastEvent();
     }
  }
//+------------------------------------------------------------------+
//| Working with symbol list events in the market watch window       |
//+------------------------------------------------------------------+
void CEngine::MarketWatchEventsControl(void)
  {
   if(this.IsTester())
      return;
   this.m_symbols.MarketWatchEventsControl();
  }
//+------------------------------------------------------------------+
//| Return the list of market positions                              |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListMarketPosition(void)
  {
   CArrayObj* list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_POSITION,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the list of market pending orders                         |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListMarketPendings(void)
  {
   CArrayObj* list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_PENDING,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the list of market orders                                 |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListMarketOrders(void)
  {
   CArrayObj* list=this.m_market.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_MARKET_ORDER,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the list of historical orders                             |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListHistoryOrders(void)
  {
   CArrayObj* list=this.m_history.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_HISTORY_ORDER,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the list of removed pending orders                        |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListHistoryPendings(void)
  {
   CArrayObj* list=this.m_history.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_HISTORY_PENDING,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the list of deals                                         |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListDeals(void)
  {
   CArrayObj* list=this.m_history.GetList();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_STATUS,ORDER_STATUS_DEAL,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//|  Return the list of all position orders                          |
//+------------------------------------------------------------------+
CArrayObj* CEngine::GetListAllOrdersByPosID(const ulong position_id)
  {
   CArrayObj* list=this.GetListHistoryOrders();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_POSITION_ID,position_id,EQUAL);
   return list;
  }
//+------------------------------------------------------------------+
//| Return the last position                                         |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastPosition(void)
  {
   CArrayObj* list=this.GetListMarketPosition();
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return position by ticket                                        |
//+------------------------------------------------------------------+
COrder* CEngine::GetPosition(const ulong ticket)
  {
   CArrayObj* list=this.GetListMarketPosition();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,ticket,EQUAL);
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TICKET);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last deal                                             |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastDeal(void)
  {
   CArrayObj* list=this.GetListDeals();
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last market pending order                             |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastMarketPending(void)
  {
   CArrayObj* list=this.GetListMarketPendings();
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last historical pending order                         |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastHistoryPending(void)
  {
   CArrayObj* list=this.GetListHistoryPendings();
   if(list==NULL) return NULL;
   list.Sort(#ifdef __MQL5__ SORT_BY_ORDER_TIME_OPEN #else SORT_BY_ORDER_TIME_CLOSE #endif);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last market order                                     |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastMarketOrder(void)
  {
   CArrayObj* list=this.GetListMarketOrders();
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last historical market order                          |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastHistoryOrder(void)
  {
   CArrayObj* list=this.GetListHistoryOrders();
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return historical order by its ticket                            |
//+------------------------------------------------------------------+
COrder* CEngine::GetHistoryOrder(const ulong ticket)
  {
   CArrayObj* list=this.GetListHistoryOrders();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,(long)ticket,EQUAL);
   if(list==NULL || list.Total()==0)
     {
      list=this.GetListHistoryPendings();
      list=CSelect::ByOrderProperty(list,ORDER_PROP_TICKET,(long)ticket,EQUAL);
      if(list==NULL) return NULL;
     }
   COrder* order=list.At(0);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the first historical market order                         |
//| from the list of all position orders                             |
//+------------------------------------------------------------------+
COrder* CEngine::GetFirstOrderPosition(const ulong position_id)
  {
   CArrayObj* list=this.GetListAllOrdersByPosID(position_id);
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(0);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the last historical market order                          |
//| from the list of all position orders                             |
//+------------------------------------------------------------------+
COrder* CEngine::GetLastOrderPosition(const ulong position_id)
  {
   CArrayObj* list=this.GetListAllOrdersByPosID(position_id);
   if(list==NULL) return NULL;
   list.Sort(SORT_BY_ORDER_TIME_OPEN);
   COrder* order=list.At(list.Total()-1);
   return(order!=NULL ? order : NULL);
  }
//+------------------------------------------------------------------+
//| Return the current account                                       |
//+------------------------------------------------------------------+
CAccount* CEngine::GetAccountCurrent(void)
  {
   int index=this.m_accounts.IndexCurrentAccount();
   if(index==WRONG_VALUE)
      return NULL;
   CArrayObj* list=this.m_accounts.GetList();
   return(list!=NULL ? (list.At(index)!=NULL ? list.At(index) : NULL) : NULL);
  }
//+------------------------------------------------------------------+
//| Return the description of the last trading event                 |
//+------------------------------------------------------------------+
string CEngine::GetLastTradeEventDescription(void)
  {
   CArrayObj *list=this.m_events.GetList();
   if(list!=NULL)
     {
      if(list.Total()==0)
         return CMessage::Text(MSG_ENG_NO_TRADE_EVENTS);
      CEvent *event=list.At(list.Total()-1);
      if(event!=NULL)
         return event.TypeEventDescription();
     }
   return DFUN_ERR_LINE+CMessage::Text(MSG_ENG_FAILED_GET_LAST_TRADE_EVENT_DESCR);
  }
//+------------------------------------------------------------------+
//| Retrieve a necessary 'ushort' number from the packed 'long' value|
//+------------------------------------------------------------------+
ushort CEngine::LongToUshortFromByte(const long source_value,const uchar index) const
  {
   if(index>3)
     {
      ::Print(DFUN,CMessage::Text(MSG_LIB_SYS_ERROR_INDEX));
      return 0;
     }
   long res=source_value>>(16*index);
   return ushort(res &=0xFFFF);
  }
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
bool CEngine::OpenBuy(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL)
  {
   return this.m_trading.OpenBuy(volume,symbol,magic,sl,tp,comment);
  }
//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
bool CEngine::OpenSell(const double volume,const string symbol,const ulong magic=ULONG_MAX,double sl=0,double tp=0,const string comment=NULL)
  {
   return this.m_trading.OpenSell(volume,symbol,magic,sl,tp,comment);
  }
//+------------------------------------------------------------------+
//| Modify a position                                                |
//+------------------------------------------------------------------+
bool CEngine::ModifyPosition(const ulong ticket,const double sl=WRONG_VALUE,const double tp=WRONG_VALUE)
  {
   return this.m_trading.ModifyPosition(ticket,sl,tp);
  }
//+------------------------------------------------------------------+
//| Close a position in full                                         |
//+------------------------------------------------------------------+
bool CEngine::ClosePosition(const ulong ticket)
  {
   return this.m_trading.ClosePosition(ticket);
  }
//+------------------------------------------------------------------+
//| Close a position partially                                       |
//+------------------------------------------------------------------+
bool CEngine::ClosePositionPartially(const ulong ticket,const double volume)
  {
   return this.m_trading.ClosePositionPartially(ticket,volume);
  }
//+------------------------------------------------------------------+
//| Close a position by an opposite one                              |
//+------------------------------------------------------------------+
bool CEngine::ClosePositionBy(const ulong ticket,const ulong ticket_by)
  {
   return this.m_trading.ClosePositionBy(ticket,ticket_by);
  }
//+------------------------------------------------------------------+
//| Place BuyStop pending order                                      |
//+------------------------------------------------------------------+
bool CEngine::PlaceBuyStop(const double volume,
                           const string symbol,
                           const double price,
                           const double sl=0,
                           const double tp=0,
                           const ulong magic=WRONG_VALUE,
                           const string comment=NULL,
                           const datetime expiration=0,
                           const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
   return this.m_trading.PlaceBuyStop(volume,symbol,price,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Place BuyLimit pending order                                     |
//+------------------------------------------------------------------+
bool CEngine::PlaceBuyLimit(const double volume,
                            const string symbol,
                            const double price,
                            const double sl=0,
                            const double tp=0,
                            const ulong magic=WRONG_VALUE,
                            const string comment=NULL,
                            const datetime expiration=0,
                            const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
   return this.m_trading.PlaceBuyLimit(volume,symbol,price,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Place BuyStopLimit pending order                                 |
//+------------------------------------------------------------------+
bool CEngine::PlaceBuyStopLimit(const double volume,
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
   return this.m_trading.PlaceBuyStopLimit(volume,symbol,price_stop,price_limit,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Place SellStop pending order                                     |
//+------------------------------------------------------------------+
bool CEngine::PlaceSellStop(const double volume,
                            const string symbol,
                            const double price,
                            const double sl=0,
                            const double tp=0,
                            const ulong magic=WRONG_VALUE,
                            const string comment=NULL,
                            const datetime expiration=0,
                            const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
   return this.m_trading.PlaceSellStop(volume,symbol,price,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Place SellLimit pending order                                    |
//+------------------------------------------------------------------+
bool CEngine::PlaceSellLimit(const double volume,
                             const string symbol,
                             const double price,
                             const double sl=0,
                             const double tp=0,
                             const ulong magic=WRONG_VALUE,
                             const string comment=NULL,
                             const datetime expiration=0,
                             const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC)
  {
   return this.m_trading.PlaceSellLimit(volume,symbol,price,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Place SellStopLimit pending order                                |
//+------------------------------------------------------------------+
bool CEngine::PlaceSellStopLimit(const double volume,
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
   return this.m_trading.PlaceSellStopLimit(volume,symbol,price_stop,price_limit,sl,tp,magic,comment,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Modify a pending order                                           |
//+------------------------------------------------------------------+
bool CEngine::ModifyOrder(const ulong ticket,
                          const double price=WRONG_VALUE,
                          const double sl=WRONG_VALUE,
                          const double tp=WRONG_VALUE,
                          const double stoplimit=WRONG_VALUE,
                          datetime expiration=WRONG_VALUE,
                          ENUM_ORDER_TYPE_TIME type_time=WRONG_VALUE)
  {
   return this.m_trading.ModifyOrder(ticket,price,sl,tp,stoplimit,expiration,type_time);
  }
//+------------------------------------------------------------------+
//| Remove a pending order                                           |
//+------------------------------------------------------------------+
bool CEngine::DeleteOrder(const ulong ticket)
  {
   return this.m_trading.DeleteOrder(ticket);
  }
//+------------------------------------------------------------------+
//| Set the valid filling policy                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetCorrectTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol_name=NULL)
  {
   this.m_trading.SetCorrectTypeFilling(type,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set the filling policy                                           |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetTypeFilling(const ENUM_ORDER_TYPE_FILLING type=ORDER_FILLING_FOK,const string symbol_name=NULL)
  {
   this.m_trading.SetTypeFilling(type,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a correct order expiration type                              |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetCorrectTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol_name=NULL)
  {
   this.m_trading.SetCorrectTypeExpiration(type,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set an order expiration type                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetTypeExpiration(const ENUM_ORDER_TYPE_TIME type=ORDER_TIME_GTC,const string symbol_name=NULL)
  {
   this.m_trading.SetTypeExpiration(type,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a magic number for trading objects of all symbols            |
//+------------------------------------------------------------------+
void CEngine::TradingSetMagic(const ulong magic,const string symbol_name=NULL)
  {
   this.m_trading.SetMagic(magic,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a comment for trading objects of all symbols                 |
//+------------------------------------------------------------------+
void CEngine::TradingSetComment(const string comment,const string symbol_name=NULL)
  {
   this.m_trading.SetComment(comment,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a slippage                                                   |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetDeviation(const ulong deviation,const string symbol_name=NULL)
  {
   this.m_trading.SetDeviation(deviation,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a volume for trading objects of all symbols                  |
//+------------------------------------------------------------------+
void CEngine::TradingSetVolume(const double volume=0,const string symbol_name=NULL)
  {
   this.m_trading.SetVolume(volume,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set an order expiration date                                     |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetExpiration(const datetime expiration=0,const string symbol_name=NULL)
  {
   this.m_trading.SetExpiration(expiration,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set the flag of asynchronous sending of trading requests         |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetAsyncMode(const bool mode=false,const string symbol_name=NULL)
  {
   this.m_trading.SetAsyncMode(mode,symbol_name);
  }
//+------------------------------------------------------------------+
//| Set a logging level of trading requests                          |
//| for trading objects of all symbols                               |
//+------------------------------------------------------------------+
void CEngine::TradingSetLogLevel(const ENUM_LOG_LEVEL log_level=LOG_LEVEL_ERROR_MSG,const string symbol_name=NULL)
  {
   this.m_trading.SetLogLevel(log_level,symbol_name);
  }
//+------------------------------------------------------------------+
//| Play a sound by its description                                  |
//+------------------------------------------------------------------+
bool CEngine::PlaySoundByDescription(const string sound_description)
  {
   string file_name=NULL;
   //--- Get the list of resources
   CArrayObj* list=this.GetListResource();
   if(list==NULL)
      return false;
   //--- Get an index of a resource object by its description
   int index=this.m_resource.GetIndexResObjByDescription(sound_description);
   //--- If a resource object with a specified description is found in the list
   if(index>WRONG_VALUE)
     {
      //--- Get a resource object by its index in the list
      CResObj *res_obj=list.At(index);
      if(res_obj==NULL)
         return false;
      //--- Get a resource object file name
      file_name=res_obj.FileName();
     }
   //--- If there is no resource object with a specified description in the list, attempt to play the file by the name written in its description
   //--- To do this, make sure that either a standard audio file (macro substitution of its name),
   //--- or a name of a new *.wav audio file is passed as a description
   else if(::StringFind(sound_description,"SND_")==0 || StringSubstr(sound_description,StringLen(sound_description)-4)==".wav")
      file_name=sound_description;
   //--- Return the file playing result
   return(file_name!=NULL ? CMessage::PlaySound(file_name) : false);
  }
//+------------------------------------------------------------------+
