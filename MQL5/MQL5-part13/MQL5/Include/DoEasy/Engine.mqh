//+------------------------------------------------------------------+
//|                                                       Engine.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "Collections\HistoryCollection.mqh"
#include "Collections\MarketCollection.mqh"
#include "Collections\EventsCollection.mqh"
#include "Collections\AccountsCollection.mqh"
#include "Services\TimerCounter.mqh"
//+------------------------------------------------------------------+
//| Library basis class                                              |
//+------------------------------------------------------------------+
class CEngine : public CObject
  {
private:
   CHistoryCollection   m_history;                       // Collection of historical orders and deals
   CMarketCollection    m_market;                        // Collection of market orders and deals
   CEventsCollection    m_events;                        // Collection of events
   CAccountsCollection  m_accounts;                      // Account collection
   CArrayObj            m_list_counters;                 // List of timer counters
   bool                 m_first_start;                   // First launch flag
   bool                 m_is_hedge;                      // Hedge account flag
   bool                 m_is_tester;                     // Flag of working in the tester
   bool                 m_is_market_trade_event;         // Account trading event flag
   bool                 m_is_history_trade_event;        // Account history trading event flag
   bool                 m_is_account_event;              // Account change event flag
   ENUM_TRADE_EVENT     m_last_trade_event;              // Last account trading event
   ENUM_ACCOUNT_EVENT   m_last_account_event;            // Last event in the account properties
//--- Return the counter index by id
   int                  CounterIndex(const int id) const;
//--- Return the (1) first launch flag, (2) presence of the flag in the trading event
   bool                 IsFirstStart(void);
//--- Work with (1) order, deal and position, (2) account events
   void                 TradeEventsControl(void);
   void                 AccountEventsControl(void);
//--- Return the last (1) market pending order, (2) market order, (3) last position, (4) position by ticket
   COrder*              GetLastMarketPending(void);
   COrder*              GetLastMarketOrder(void);
   COrder*              GetLastPosition(void);
   COrder*              GetPosition(const ulong ticket);
//--- Return the last (1) removed pending order, (2) historical market order, (3) historical order (market or pending one) by its ticket
   COrder*              GetLastHistoryPending(void);
   COrder*              GetLastHistoryOrder(void);
   COrder*              GetHistoryOrder(const ulong ticket);
//--- Return the (1) first and the (2) last historical market orders from the list of all position orders, (3) the last deal
   COrder*              GetFirstOrderPosition(const ulong position_id);
   COrder*              GetLastOrderPosition(const ulong position_id);
   COrder*              GetLastDeal(void);
public:
   //--- Return the list of market (1) positions, (2) pending orders and (3) market orders
   CArrayObj*           GetListMarketPosition(void);
   CArrayObj*           GetListMarketPendings(void);
   CArrayObj*           GetListMarketOrders(void);
   //--- Return the list of historical (1) orders, (2) removed pending orders, (3) deals, (4) all position market orders by its id
   CArrayObj*           GetListHistoryOrders(void);
   CArrayObj*           GetListHistoryPendings(void);
   CArrayObj*           GetListDeals(void);
   CArrayObj*           GetListAllOrdersByPosID(const ulong position_id);
//--- Return the list of (1) accounts, (2) account events, (3) account change event by its index in the list
//--- (4) the current account, (5) event description
   CArrayObj*           GetListAllAccounts(void)                        { return this.m_accounts.GetList();          }
   CArrayInt*           GetListAccountEvents(void)                      { return this.m_accounts.GetListChanges();   }
   ENUM_ACCOUNT_EVENT   GetAccountEventByIndex(const int index)         { return this.m_accounts.GetEvent(index);    }
   CAccount*            GetAccountCurrent(void);
   string               GetAccountEventDescription(ENUM_ACCOUNT_EVENT event);
   
//--- Return the list of order, deal and position events
   CArrayObj*           GetListAllOrdersEvents(void)                    { return this.m_events.GetList();            }
//--- Reset the last trading event
   void                 ResetLastTradeEvent(void)                       { this.m_events.ResetLastTradeEvent(); }
//--- Return the (1) last trading event, (2) the last event in the account properties, (3) hedging account flag, (4) flag of working in the tester
   ENUM_TRADE_EVENT     LastTradeEvent(void)                      const { return this.m_last_trade_event;            }
   ENUM_ACCOUNT_EVENT   LastAccountEvent(void)                    const { return this.m_last_account_event;          }
   bool                 IsHedge(void)                             const { return this.m_is_hedge;                    }
   bool                 IsTester(void)                            const { return this.m_is_tester;                   }
   bool                 IsAccountsEvent(void)                     const { return this.m_accounts.IsAccountEvent();   }
//--- Return an account event code
   int                  GetAccountEventsCode(void)                const { return this.m_accounts.GetEventCode();     }
//--- Create the timer counter
   void                 CreateCounter(const int id,const ulong frequency,const ulong pause);
//--- Timer
   void                 OnTimer(void);
//--- Constructor/destructor
                        CEngine();
                       ~CEngine();
  };
//+------------------------------------------------------------------+
//| CEngine constructor                                              |
//+------------------------------------------------------------------+
CEngine::CEngine() : m_first_start(true),m_last_trade_event(TRADE_EVENT_NO_EVENT),m_last_account_event(ACCOUNT_EVENT_NO_EVENT)
  {
   this.m_list_counters.Sort();
   this.m_list_counters.Clear();
   this.CreateCounter(COLLECTION_ORD_COUNTER_ID,COLLECTION_ORD_COUNTER_STEP,COLLECTION_ORD_PAUSE);
   this.CreateCounter(COLLECTION_ACC_COUNTER_ID,COLLECTION_ACC_COUNTER_STEP,COLLECTION_ACC_PAUSE);
   
   this.m_is_hedge=#ifdef __MQL4__ true #else bool(::AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) #endif;
   this.m_is_tester=::MQLInfoInteger(MQL_TESTER);
   ::ResetLastError();
   #ifdef __MQL5__
      if(!::EventSetMillisecondTimer(TIMER_FREQUENCY))
        {
         ::Print(DFUN_ERR_LINE,"Не удалось создать таймер. Ошибка: ","Could not create timer. Error: ",(string)::GetLastError());
        }
   //---__MQL4__
   #else 
      if(!this.IsTester() && !::EventSetMillisecondTimer(TIMER_FREQUENCY))
        {
         ::Print(DFUN_ERR_LINE,"Не удалось создать таймер. Ошибка: ","Could not create timer. Error: ",(string)::GetLastError());
        }
   #endif 
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
  }
//+------------------------------------------------------------------+
//| Create the timer counter                                         |
//+------------------------------------------------------------------+
void CEngine::CreateCounter(const int id,const ulong step,const ulong pause)
  {
   if(this.CounterIndex(id)>WRONG_VALUE)
     {
      ::Print(TextByLanguage("Ошибка. Уже создан счётчик с идентификатором ","Error. Already created counter with id "),(string)id);
      return;
     }
   m_list_counters.Sort();
   CTimerCounter* counter=new CTimerCounter(id);
   if(counter==NULL)
      ::Print(TextByLanguage("Не удалось создать счётчик таймера ","Failed to create timer counter "),(string)id);
   counter.SetParams(step,pause);
   if(this.m_list_counters.Search(counter)==WRONG_VALUE)
      this.m_list_counters.Add(counter);
   else
     {
      string t1=TextByLanguage("Ошибка. Счётчик с идентификатором ","Error. Counter with ID ")+(string)id;
      string t2=TextByLanguage(", шагом ",", step ")+(string)step;
      string t3=TextByLanguage(" и паузой "," and pause ")+(string)pause;
      ::Print(t1+t2+t3+TextByLanguage(" уже существует"," already exists"));
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
//--- Инициализация флагов торговых событий
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
   this.m_accounts.Refresh();
   this.m_is_account_event=this.m_accounts.IsAccountEvent();
//--- If there are account property changes
   if(this.m_is_account_event)
     {
      //--- Get the last event of the account property change
      this.m_last_account_event=this.m_accounts.GetEvent();
     }
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
//| Return the account event description                             |
//+------------------------------------------------------------------+
string CEngine::GetAccountEventDescription(ENUM_ACCOUNT_EVENT event)
  {
   return this.m_accounts.EventDescription(event);
  }
//+------------------------------------------------------------------+
