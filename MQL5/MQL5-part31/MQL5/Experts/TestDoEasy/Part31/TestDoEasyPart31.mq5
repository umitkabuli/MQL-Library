//+------------------------------------------------------------------+
//|                                             TestDoEasyPart31.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//--- includes
#include <DoEasy\Engine.mqh>
//--- enums
enum ENUM_BUTTONS
  {
   BUTT_BUY,
   BUTT_BUY_LIMIT,
   BUTT_BUY_STOP,
   BUTT_BUY_STOP_LIMIT,
   BUTT_CLOSE_BUY,
   BUTT_CLOSE_BUY2,
   BUTT_CLOSE_BUY_BY_SELL,
   BUTT_SELL,
   BUTT_SELL_LIMIT,
   BUTT_SELL_STOP,
   BUTT_SELL_STOP_LIMIT,
   BUTT_CLOSE_SELL,
   BUTT_CLOSE_SELL2,
   BUTT_CLOSE_SELL_BY_BUY,
   BUTT_DELETE_PENDING,
   BUTT_CLOSE_ALL,
   BUTT_PROFIT_WITHDRAWAL,
   BUTT_SET_STOP_LOSS,
   BUTT_SET_TAKE_PROFIT,
   BUTT_TRAILING_ALL
  };
#define TOTAL_BUTT   (20)
//--- structures
struct SDataButt
  {
   string      name;
   string      text;
  };
//--- input variables
input    ushort            InpMagic             =  123;  // Magic number
input    double            InpLots              =  0.1;  // Lots
input    uint              InpStopLoss          =  150;  // StopLoss in points
input    uint              InpTakeProfit        =  150;  // TakeProfit in points
input    uint              InpDistance          =  50;   // Pending orders distance (points)
input    uint              InpDistanceSL        =  50;   // StopLimit orders distance (points)
input    uint              InpDistancePReq      =  50;   // Distance for Pending Request's activate (points)
input    uint              InpBarsDelayPReq     =  5;    // Bars delay for Pending Request's activate (current timeframe)
input    uint              InpSlippage          =  5;    // Slippage in points
input    uint              InpSpreadMultiplier  =  1;    // Spread multiplier for adjusting stop-orders by StopLevel
input    uchar             InpTotalAttempts     =  5;    // Number of trading attempts
sinput   double            InpWithdrawal        =  10;   // Withdrawal funds (in tester)
sinput   uint              InpButtShiftX        =  0;    // Buttons X shift 
sinput   uint              InpButtShiftY        =  10;   // Buttons Y shift 
input    uint              InpTrailingStop      =  50;   // Trailing Stop (points)
input    uint              InpTrailingStep      =  20;   // Trailing Step (points)
input    uint              InpTrailingStart     =  0;    // Trailing Start (points)
input    uint              InpStopLossModify    =  20;   // StopLoss for modification (points)
input    uint              InpTakeProfitModify  =  60;   // TakeProfit for modification (points)
sinput   ENUM_SYMBOLS_MODE InpModeUsedSymbols   =  SYMBOLS_MODE_CURRENT;   // Mode of used symbols list
sinput   string            InpUsedSymbols       =  "EURUSD,AUDUSD,EURAUD,EURCAD,EURGBP,EURJPY,EURUSD,GBPUSD,NZDUSD,USDCAD,USDJPY";  // List of used symbols (comma - separator)
sinput   bool              InpUseSounds         =  true; // Use sounds
//--- global variables
CEngine        engine;
SDataButt      butt_data[TOTAL_BUTT];
string         prefix;
double         lot;
double         withdrawal=(InpWithdrawal<0.1 ? 0.1 : InpWithdrawal);
ushort         magic_number;
uint           stoploss;
uint           takeprofit;
uint           distance_pending;
uint           distance_stoplimit;
uint           distance_pending_request;
uint           bars_delay_pending_request;
uint           slippage;
bool           trailing_on;
bool           pending_buy;
bool           pending_buy_limit;
bool           pending_buy_stop;
bool           pending_buy_stoplimit;
bool           pending_close_buy;
bool           pending_close_buy2;
bool           pending_close_buy_by_sell;
bool           pending_sell;
bool           pending_sell_limit;
bool           pending_sell_stop;
bool           pending_sell_stoplimit;
bool           pending_close_sell;
bool           pending_close_sell2;
bool           pending_close_sell_by_buy;
double         trailing_stop;
double         trailing_step;
uint           trailing_start;
uint           stoploss_to_modify;
uint           takeprofit_to_modify;
int            used_symbols_mode;
string         used_symbols;
string         array_used_symbols[];
bool           testing;
uchar          group1;
uchar          group2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Calling the function displays the list of enumeration constants in the journal 
//--- (the list is set in the strings 22 and 25 of the DELib.mqh file) for checking the constants validity
   //EnumNumbersTest();

//--- Set EA global variables
   prefix=MQLInfoString(MQL_PROGRAM_NAME)+"_";
   testing=engine.IsTester();
   for(int i=0;i<TOTAL_BUTT;i++)
     {
      butt_data[i].name=prefix+EnumToString((ENUM_BUTTONS)i);
      butt_data[i].text=EnumToButtText((ENUM_BUTTONS)i);
     }
   lot=NormalizeLot(Symbol(),fmax(InpLots,MinimumLots(Symbol())*2.0));
   magic_number=InpMagic;
   stoploss=InpStopLoss;
   takeprofit=InpTakeProfit;
   distance_pending=InpDistance;
   distance_stoplimit=InpDistanceSL;
   slippage=InpSlippage;
   trailing_stop=InpTrailingStop*Point();
   trailing_step=InpTrailingStep*Point();
   trailing_start=InpTrailingStart;
   stoploss_to_modify=InpStopLossModify;
   takeprofit_to_modify=InpTakeProfitModify;
   distance_pending_request=(InpDistancePReq<5 ? 5 : InpDistancePReq);
   bars_delay_pending_request=(InpBarsDelayPReq<1 ? 1 : InpBarsDelayPReq);
//--- Initialize random group numbers
   group1=0;
   group2=0;
   srand(GetTickCount());
   
//--- Initialize DoEasy library
   OnInitDoEasy();
   
//--- Check and remove remaining EA graphical objects
   if(IsPresentObects(prefix))
      ObjectsDeleteAll(0,prefix);

//--- Create the button panel
   if(!CreateButtons(InpButtShiftX,InpButtShiftY))
      return INIT_FAILED;
//--- Set trailing activation button status
   ButtonState(butt_data[TOTAL_BUTT-1].name,trailing_on);
//--- Reset states of the buttons for working using pending requests
   for(int i=0;i<14;i++)
     {
      ButtonState(butt_data[i].name+"_PRICE",false);
      ButtonState(butt_data[i].name+"_TIME",false);
     }

//--- Check playing a standard sound by macro substitution and a custom sound by description
   engine.PlaySoundByDescription(SND_OK);
   Sleep(600);
   engine.PlaySoundByDescription(TextByLanguage("Звук упавшей монетки 2","Falling coin 2"));

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Remove EA graphical objects by an object name prefix
   ObjectsDeleteAll(0,prefix);
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- If working in the tester
   if(MQLInfoInteger(MQL_TESTER))
     {
      engine.OnTimer();       // Working in the timer
      PressButtonsControl();  // Button pressing control
      EventsHandling();       // Working with events
     }
//--- If the trailing flag is set
   if(trailing_on)
     {
      TrailingPositions();    // Trailing positions
      TrailingOrders();       // Trailing of pending orders
     }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//--- Launch the library timer (only not in the tester)
   if(!MQLInfoInteger(MQL_TESTER))
      engine.OnTimer();
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- If working in the tester, exit
   if(MQLInfoInteger(MQL_TESTER))
      return;
//--- Handling mouse events
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Handling pressing the buttons in the panel
      if(StringFind(sparam,"BUTT_")>0)
         PressButtonEvents(sparam);
     }
//--- Handling DoEasy library events
   if(id>CHARTEVENT_CUSTOM-1)
     {
      OnDoEasyEvent(id,lparam,dparam,sparam);
     } 
  }
//+------------------------------------------------------------------+
//| Initializing DoEasy library                                      |
//+------------------------------------------------------------------+
void OnInitDoEasy()
  {
//--- Check if working with the full list is selected
   used_symbols_mode=InpModeUsedSymbols;
   if((ENUM_SYMBOLS_MODE)used_symbols_mode==SYMBOLS_MODE_ALL)
     {
      int total=SymbolsTotal(false);
      string ru_n="\nКоличество символов на сервере "+(string)total+".\nМаксимальное количество: "+(string)SYMBOLS_COMMON_TOTAL+" символов.";
      string en_n="\nNumber of symbols on server "+(string)total+".\nMaximum number: "+(string)SYMBOLS_COMMON_TOTAL+" symbols.";
      string caption=TextByLanguage("Внимание!","Attention!");
      string ru="Выбран режим работы с полным списком.\nВ этом режиме первичная подготовка списка коллекции символов может занять длительное время."+ru_n+"\nПродолжить?\n\"Нет\" - работа с текущим символом \""+Symbol()+"\"";
      string en="Full list mode selected.\nIn this mode, the initial preparation of the collection symbols list may take a long time."+en_n+"\nContinue?\n\"No\" - working with the current symbol \""+Symbol()+"\"";
      string message=TextByLanguage(ru,en);
      int flags=(MB_YESNO | MB_ICONWARNING | MB_DEFBUTTON2);
      int mb_res=MessageBox(message,caption,flags);
      switch(mb_res)
        {
         case IDNO : 
           used_symbols_mode=SYMBOLS_MODE_CURRENT; 
           break;
         default:
           break;
        }
     }
//--- Fill in the array of used symbols
   used_symbols=InpUsedSymbols;
   CreateUsedSymbolsArray((ENUM_SYMBOLS_MODE)used_symbols_mode,used_symbols,array_used_symbols);

//--- Set the type of the used symbol list in the symbol collection
   engine.SetUsedSymbols(array_used_symbols);
//--- Displaying the selected mode of working with the symbol object collection
   Print(engine.ModeSymbolsListDescription(),TextByLanguage(". Количество используемых символов: ",". Number of symbols used: "),engine.GetSymbolsCollectionTotal());
   
//--- Create resource text files
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_coin_01",TextByLanguage("Звук упавшей монетки 1","Falling coin 1"),sound_array_coin_01);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_coin_02",TextByLanguage("Звук упавших монеток","Falling coins"),sound_array_coin_02);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_coin_03",TextByLanguage("Звук монеток","Coins"),sound_array_coin_03);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_coin_04",TextByLanguage("Звук упавшей монетки 2","Falling coin 2"),sound_array_coin_04);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_click_01",TextByLanguage("Звук щелчка по кнопке 1","Button click 1"),sound_array_click_01);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_click_02",TextByLanguage("Звук щелчка по кнопке 2","Button click 2"),sound_array_click_02);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_click_03",TextByLanguage("Звук щелчка по кнопке 3","Button click 3"),sound_array_click_03);
   engine.CreateFile(FILE_TYPE_WAV,"sound_array_cash_machine_01",TextByLanguage("Звук кассового аппарата","Cash machine"),sound_array_cash_machine_01);
   engine.CreateFile(FILE_TYPE_BMP,"img_array_spot_green",TextByLanguage("Изображение \"Зелёный светодиод\"","Image \"Green Spot lamp\""),img_array_spot_green);
   engine.CreateFile(FILE_TYPE_BMP,"img_array_spot_red",TextByLanguage("Изображение \"Красный светодиод\"","Image \"Red Spot lamp\""),img_array_spot_red);

//--- Pass all existing collections to the trading class
   engine.TradingOnInit();

//--- Set the default magic number for all used symbols
   engine.TradingSetMagic(engine.SetCompositeMagicNumber(magic_number));
//--- Set synchronous passing of orders for all used symbols
   engine.TradingSetAsyncMode(false);
//--- Set the number of trading attempts in case of an error
   engine.TradingSetTotalTry(InpTotalAttempts);
//--- Set correct order expiration and filling types to all trading objects
   engine.TradingSetCorrectTypeExpiration();
   engine.TradingSetCorrectTypeFilling();

//--- Set standard sounds for trading objects of all used symbols
   engine.SetSoundsStandart();
//--- Set the general flag of using sounds
   engine.SetUseSounds(InpUseSounds);
//--- Set the spread multiplier for symbol trading objects in the symbol collection
   engine.SetSpreadMultiplier(InpSpreadMultiplier);
      
//--- Set controlled values for symbols
   //--- Get the list of all collection symbols
   CArrayObj *list=engine.GetListAllUsedSymbols();
   if(list!=NULL && list.Total()!=0)
     {
      //--- In a loop by the list, set the necessary values for tracked symbol properties
      //--- By default, the LONG_MAX value is set to all properties, which means "Do not track this property" 
      //--- It can be enabled or disabled (by setting the value less than LONG_MAX or vice versa - set the LONG_MAX value) at any time and anywhere in the program
      /*
      for(int i=0;i<list.Total();i++)
        {
         CSymbol* symbol=list.At(i);
         if(symbol==NULL)
            continue;
         //--- Set control of the symbol price increase by 100 points
         symbol.SetControlBidInc(100000*symbol.Point());
         //--- Set control of the symbol price decrease by 100 points
         symbol.SetControlBidDec(100000*symbol.Point());
         //--- Set control of the symbol spread increase by 40 points
         symbol.SetControlSpreadInc(400);
         //--- Set control of the symbol spread decrease by 40 points
         symbol.SetControlSpreadDec(400);
         //--- Set control of the current spread by the value of 40 points
         symbol.SetControlSpreadLevel(400);
        }
      */
     }
//--- Set controlled values for the current account
   CAccount* account=engine.GetAccountCurrent();
   if(account!=NULL)
     {
      //--- Set control of the profit increase to 10
      account.SetControlledValueINC(ACCOUNT_PROP_PROFIT,10.0);
      //--- Set control of the funds increase to 15
      account.SetControlledValueINC(ACCOUNT_PROP_EQUITY,15.0);
      //--- Set profit control level to 20
      account.SetControlledValueLEVEL(ACCOUNT_PROP_PROFIT,20.0);
     }
  }
//+------------------------------------------------------------------+
//| Handling DoEasy library events                                   |
//+------------------------------------------------------------------+
void OnDoEasyEvent(const int id,
                   const long &lparam,
                   const double &dparam,
                   const string &sparam)
  {
   int idx=id-CHARTEVENT_CUSTOM;
//--- Retrieve (1) event time milliseconds, (2) reason and (3) source from lparam, as well as (4) set the exact event time
   ushort msc=engine.EventMSC(lparam);
   ushort reason=engine.EventReason(lparam);
   ushort source=engine.EventSource(lparam);
   long time=TimeCurrent()*1000+msc;
   
//--- Handling symbol events
   if(source==COLLECTION_SYMBOLS_ID)
     {
      CSymbol *symbol=engine.GetSymbolObjByName(sparam);
      if(symbol==NULL)
         return;
      //--- Number of decimal places in the event value - in case of a 'long' event, it is 0, otherwise - Digits() of a symbol
      int digits=(idx<SYMBOL_PROP_INTEGER_TOTAL ? 0 : symbol.Digits());
      //--- Event text description
      string id_descr=(idx<SYMBOL_PROP_INTEGER_TOTAL ? symbol.GetPropertyDescription((ENUM_SYMBOL_PROP_INTEGER)idx) : symbol.GetPropertyDescription((ENUM_SYMBOL_PROP_DOUBLE)idx));
      //--- Property change text value
      string value=DoubleToString(dparam,digits);
      
      //--- Check event reasons and display its description in the journal
      if(reason==BASE_EVENT_REASON_INC)
        {
         Print(symbol.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_DEC)
        {
         Print(symbol.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_MORE_THEN)
        {
         Print(symbol.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_LESS_THEN)
        {
         Print(symbol.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_EQUALS)
        {
         Print(symbol.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
     }   
     
//--- Handling account events
   else if(source==COLLECTION_ACCOUNT_ID)
     {
      CAccount *account=engine.GetAccountCurrent();
      if(account==NULL)
         return;
      //--- Number of decimal places in the event value - in case of a 'long' event, it is 0, otherwise - Digits() of a symbol
      int digits=int(idx<ACCOUNT_PROP_INTEGER_TOTAL ? 0 : account.CurrencyDigits());
      //--- Event text description
      string id_descr=(idx<ACCOUNT_PROP_INTEGER_TOTAL ? account.GetPropertyDescription((ENUM_ACCOUNT_PROP_INTEGER)idx) : account.GetPropertyDescription((ENUM_ACCOUNT_PROP_DOUBLE)idx));
      //--- Property change text value
      string value=DoubleToString(dparam,digits);
      
      //--- Checking event reasons and handling the increase of funds by a specified value,
      
      //--- In case of a property value increase
      if(reason==BASE_EVENT_REASON_INC)
        {
         //--- Display an event in the journal
         Print(account.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
         //--- if this is an equity increase
         if(idx==ACCOUNT_PROP_EQUITY)
           {
            //--- Get the list of all open positions for the current symbol
            CArrayObj* list_positions=engine.GetListMarketPosition();
            list_positions=CSelect::ByOrderProperty(list_positions,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
            //--- Select positions with the profit exceeding zero
            list_positions=CSelect::ByOrderProperty(list_positions,ORDER_PROP_PROFIT_FULL,0,MORE);
            if(list_positions!=NULL)
              {
               //--- Sort the list by profit considering commission and swap
               list_positions.Sort(SORT_BY_ORDER_PROFIT_FULL);
               //--- Get the position index with the highest profit
               int index=CSelect::FindOrderMax(list_positions,ORDER_PROP_PROFIT_FULL);
               if(index>WRONG_VALUE)
                 {
                  COrder* position=list_positions.At(index);
                  if(position!=NULL)
                    {
                     //--- Get a ticket of a position with the highest profit and close the position by a ticket
                     engine.ClosePosition(position.Ticket());
                    }
                 }
              }
           }
        }
      //--- Other events are simply displayed in the journal
      if(reason==BASE_EVENT_REASON_DEC)
        {
         Print(account.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_MORE_THEN)
        {
         Print(account.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_LESS_THEN)
        {
         Print(account.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
      if(reason==BASE_EVENT_REASON_EQUALS)
        {
         Print(account.EventDescription(idx,(ENUM_BASE_EVENT_REASON)reason,source,value,id_descr,digits));
        }
     } 
     
//--- Handling market watch window events
   else if(idx>MARKET_WATCH_EVENT_NO_EVENT && idx<SYMBOL_EVENTS_NEXT_CODE)
     {
      //--- Market Watch window event
      string descr=engine.GetMWEventDescription((ENUM_MW_EVENT)idx);
      string name=(idx==MARKET_WATCH_EVENT_SYMBOL_SORT ? "" : ": "+sparam);
      Print(TimeMSCtoString(lparam)," ",descr,name);
     }
//--- Handling trading events
   else if(idx>TRADE_EVENT_NO_EVENT && idx<TRADE_EVENTS_NEXT_CODE)
     {
      //--- Get the list of trading events
      CArrayObj *list=engine.GetListAllOrdersEvents();
      if(list==NULL)
         return;
      //--- get the event index shift relative to the end of the list
      //--- in the tester, the shift is passed by the lparam parameter to the event handler
      //--- outside the tester, events are sent one by one and handled in OnChartEvent()
      int shift=(testing ? (int)lparam : 0);
      CEvent *event=list.At(list.Total()-1-shift);
      if(event==NULL)
      return;
      //--- Accrue the credit
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_CREDIT)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Additional charges
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_CHARGE)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Correction
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_CORRECTION)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Enumerate bonuses
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_BONUS)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Additional commissions
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_COMISSION)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Daily commission
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_COMISSION_DAILY)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Monthly commission
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_COMISSION_MONTHLY)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Daily agent commission
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_COMISSION_AGENT_DAILY)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Monthly agent commission
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_COMISSION_AGENT_MONTHLY)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Interest rate
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_INTEREST)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Canceled buy deal
      if(event.TypeEvent()==TRADE_EVENT_BUY_CANCELLED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Canceled sell deal
      if(event.TypeEvent()==TRADE_EVENT_SELL_CANCELLED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Dividend operations
      if(event.TypeEvent()==TRADE_EVENT_DIVIDENT)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Accrual of franked dividend
      if(event.TypeEvent()==TRADE_EVENT_DIVIDENT_FRANKED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Tax charges
      if(event.TypeEvent()==TRADE_EVENT_TAX)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Replenishing account balance
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_BALANCE_REFILL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Withdrawing funds from balance
      if(event.TypeEvent()==TRADE_EVENT_ACCOUNT_BALANCE_WITHDRAWAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      
      //--- Pending order placed
      if(event.TypeEvent()==TRADE_EVENT_PENDING_ORDER_PLASED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Pending order removed
      if(event.TypeEvent()==TRADE_EVENT_PENDING_ORDER_REMOVED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Pending order activated by price
      if(event.TypeEvent()==TRADE_EVENT_PENDING_ORDER_ACTIVATED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Pending order partially activated by price
      if(event.TypeEvent()==TRADE_EVENT_PENDING_ORDER_ACTIVATED_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position opened
      if(event.TypeEvent()==TRADE_EVENT_POSITION_OPENED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position opened partially
      if(event.TypeEvent()==TRADE_EVENT_POSITION_OPENED_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed by an opposite one
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_BY_POS)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed by StopLoss
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_BY_SL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed by TakeProfit
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_BY_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position reversal by a new deal (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_REVERSED_BY_MARKET)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position reversal by activating a pending order (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_REVERSED_BY_PENDING)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position reversal by partial market order execution (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_REVERSED_BY_MARKET_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position reversal by activating a pending order (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_REVERSED_BY_PENDING_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Added volume to a position by a new deal (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Added volume to a position by partial execution of a market order (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Added volume to a position by activating a pending order (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Added volume to a position by partial activation of a pending order (netting)
      if(event.TypeEvent()==TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed partially
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position partially closed by an opposite one
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed partially by StopLoss
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_SL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Position closed partially by TakeProfit
      if(event.TypeEvent()==TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- StopLimit order activation
      if(event.TypeEvent()==TRADE_EVENT_TRIGGERED_STOP_LIMIT_ORDER)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order price
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_PRICE)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order and StopLoss price
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_PRICE_SL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order and TakeProfit price
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_PRICE_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order, StopLoss and TakeProfit price
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_PRICE_SL_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order's StopLoss and TakeProfit price
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_SL_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order's StopLoss
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_SL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing order's TakeProfit
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_ORDER_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing position's StopLoss and TakeProfit
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_POSITION_SL_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing position StopLoss
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_POSITION_SL)
        {
         Print(DFUN,event.TypeEventDescription());
        }
      //--- Changing position TakeProfit
      if(event.TypeEvent()==TRADE_EVENT_MODIFY_POSITION_TP)
        {
         Print(DFUN,event.TypeEventDescription());
        }
     }
  }
//+------------------------------------------------------------------+
//| Working with events in the tester                                |
//+------------------------------------------------------------------+
void EventsHandling(void)
  {
//--- If a trading event is present
   if(engine.IsTradeEvent())
     {
      //--- Number of trading events occurred simultaneously
      int total=engine.GetTradeEventsTotal();
      for(int i=0;i<total;i++)
        {
         //--- Get the next event from the list of simultaneously occurred events by index
         CEventBaseObj *event=engine.GetTradeEventByIndex(i);
         if(event==NULL)
            continue;
         long   lparam=i;
         double dparam=event.DParam();
         string sparam=event.SParam();
         OnDoEasyEvent(CHARTEVENT_CUSTOM+event.ID(),lparam,dparam,sparam);
        }
     }
//--- If there is an account event
   if(engine.IsAccountsEvent())
     {
      //--- Get the list of all account events occurred simultaneously
      CArrayObj* list=engine.GetListAccountEvents();
      if(list!=NULL)
        {
         //--- Get the next event in a loop
         int total=list.Total();
         for(int i=0;i<total;i++)
           {
            //--- take an event from the list
            CEventBaseObj *event=list.At(i);
            if(event==NULL)
               continue;
            //--- Send an event to the event handler
            long lparam=event.LParam();
            double dparam=event.DParam();
            string sparam=event.SParam();
            OnDoEasyEvent(CHARTEVENT_CUSTOM+event.ID(),lparam,dparam,sparam);
           }
        }
     }
//--- If there is a symbol collection event
   if(engine.IsSymbolsEvent())
     {
      //--- Get the list of all symbol events occurred simultaneously
      CArrayObj* list=engine.GetListSymbolsEvents();
      if(list!=NULL)
        {
         //--- Get the next event in a loop
         int total=list.Total();
         for(int i=0;i<total;i++)
           {
            //--- take an event from the list
            CEventBaseObj *event=list.At(i);
            if(event==NULL)
               continue;
            //--- Send an event to the event handler
            long lparam=event.LParam();
            double dparam=event.DParam();
            string sparam=event.SParam();
            OnDoEasyEvent(CHARTEVENT_CUSTOM+event.ID(),lparam,dparam,sparam);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Return the flag of a prefixed object presence                    |
//+------------------------------------------------------------------+
bool IsPresentObects(const string object_prefix)
  {
   for(int i=ObjectsTotal(0,0)-1;i>=0;i--)
      if(StringFind(ObjectName(0,i,0),object_prefix)>WRONG_VALUE)
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Tracking the buttons' status                                     |
//+------------------------------------------------------------------+
void PressButtonsControl(void)
  {
   int total=ObjectsTotal(0,0);
   for(int i=0;i<total;i++)
     {
      string obj_name=ObjectName(0,i);
      if(StringFind(obj_name,prefix+"BUTT_")<0)
         continue;
      PressButtonEvents(obj_name);
     }
  }
//+------------------------------------------------------------------+
//| Create the buttons panel                                         |
//+------------------------------------------------------------------+
bool CreateButtons(const int shift_x=20,const int shift_y=0)
  {
   int h=18,w=82,offset=2,wpt=14;
   int cx=offset+shift_x+wpt*2+2,cy=offset+shift_y+(h+1)*(TOTAL_BUTT/2)+3*h+1;
   int x=cx,y=cy;
   int shift=0;
   for(int i=0;i<TOTAL_BUTT;i++)
     {
      x=x+(i==7 ? w+2 : 0);
      if(i==TOTAL_BUTT-6) x=cx;
      y=(cy-(i-(i>6 ? 7 : 0))*(h+1));
      if(!ButtonCreate(butt_data[i].name,x,y,(i<TOTAL_BUTT-6 ? w : w*2+2),h,butt_data[i].text,(i<4 ? clrGreen : i>6 && i<11 ? clrRed : clrBlue)))
        {
         Alert(TextByLanguage("Не удалось создать кнопку \"","Could not create button \""),butt_data[i].text);
         return false;
        }
     }
   
   h=18; offset=2;
   cx=offset+shift_x; cy=offset+shift_y+(h+1)*(TOTAL_BUTT/2)+3*h+1;
   x=cx; y=cy;
   shift=0;
   for(int i=0;i<14;i++)
     {
      y=(cy-(i-(i>6 ? 7 : 0))*(h+1));
      if(!ButtonCreate(butt_data[i].name+"_PRICE",((i>6 && i<11) || i>10 ? x+wpt*2+w*2+5 : x),y,wpt,h,"P",(i<4 ? clrGreen : i>6 && i<11 ? clrChocolate : clrBlue)))
        {
         Alert(TextByLanguage("Не удалось создать кнопку \"","Could not create button \""),butt_data[i].text+" \"P\"");
         return false;
        }
      if(!ButtonCreate(butt_data[i].name+"_TIME",((i>6 && i<11) || i>10 ? x+wpt*2+w*2+5+wpt+1 : x+wpt+1),y,wpt,h,"T",(i<4 ? clrGreen : i>6 && i<11 ? clrChocolate : clrBlue)))
        {
         Alert(TextByLanguage("Не удалось создать кнопку \"","Could not create button \""),butt_data[i].text+" \"T\"");
         return false;
        }
     }
   ChartRedraw(0);
   return true;
  }
//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
bool ButtonCreate(const string name,const int x,const int y,const int w,const int h,const string text,const color clr,const string font="Calibri",const int font_size=8)
  {
   if(ObjectFind(0,name)<0)
     {
      if(!ObjectCreate(0,name,OBJ_BUTTON,0,0,0)) 
        { 
         Print(DFUN,TextByLanguage("не удалось создать кнопку! Код ошибки=","Could not create button! Error code="),GetLastError()); 
         return false; 
        } 
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetString(0,name,OBJPROP_FONT,font);
      ObjectSetString(0,name,OBJPROP_TEXT,text);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,"\n");
      ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrGray);
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Return the button status                                         |
//+------------------------------------------------------------------+
bool ButtonState(const string name)
  {
   return (bool)ObjectGetInteger(0,name,OBJPROP_STATE);
  }
//+------------------------------------------------------------------+
//| Set the button status                                            |
//+------------------------------------------------------------------+
void ButtonState(const string name,const bool state)
  {
   ObjectSetInteger(0,name,OBJPROP_STATE,state);
//--- Trailing activation button
   if(name==butt_data[TOTAL_BUTT-1].name)
     {
      if(state)
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'220,255,240');
      else
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'240,240,240');
     }
//--- Buttons enabling pending requests
   if(StringFind(name,"_PRICE")>0 || StringFind(name,"_TIME")>0)
     {
      if(state)
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'255,220,90');
      else
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'240,240,240');
     }
  }
//+------------------------------------------------------------------+
//| Transform enumeration into the button text                       |
//+------------------------------------------------------------------+
string EnumToButtText(const ENUM_BUTTONS member)
  {
   string txt=StringSubstr(EnumToString(member),5);
   StringToLower(txt);
   StringReplace(txt,"set_take_profit","Set TakeProfit");
   StringReplace(txt,"set_stop_loss","Set StopLoss");
   StringReplace(txt,"trailing_all","Trailing All");
   StringReplace(txt,"buy","Buy");
   StringReplace(txt,"sell","Sell");
   StringReplace(txt,"_limit"," Limit");
   StringReplace(txt,"_stop"," Stop");
   StringReplace(txt,"close_","Close ");
   StringReplace(txt,"2"," 1/2");
   StringReplace(txt,"_by_"," by ");
   StringReplace(txt,"profit_","Profit ");
   StringReplace(txt,"delete_","Delete ");
   return txt;
  }
//+------------------------------------------------------------------+
//| Handle pressing the buttons                                      |
//+------------------------------------------------------------------+
void PressButtonEvents(const string button_name)
  {
   bool comp_magic=true;   // Temporary variable selecting the composite magic number with random group IDs
   string comment="";
   //--- Convert button name into its string ID
   string button=StringSubstr(button_name,StringLen(prefix));
   //--- Random group 1 and 2 numbers within the range of 0 - 15
   group1=(uchar)Rand();
   group2=(uchar)Rand();
   uint magic=(comp_magic ? engine.SetCompositeMagicNumber(magic_number,group1,group2) : magic_number);
   //--- If the button is pressed
   if(ButtonState(button_name))
     {
      //--- If the BUTT_BUY button is pressed: Open Buy position
      if(button==EnumToString(BUTT_BUY))
        {
         //--- If the pending request creation buttons are not pressed, open Buy 
         if(!pending_buy)
            engine.OpenBuy(lot,Symbol(),magic,stoploss,takeprofit);   // No comment - the default comment is to be set
         //--- Otherwise, create a pending request for opening a Buy position
         else
           {
            int id=engine.OpenBuyPending(lot,Symbol(),magic,stoploss,takeprofit);
            if(id>0)
              {
               //--- If the price criterion is selected
               if(ButtonState(prefix+EnumToString(BUTT_BUY)+"_PRICE"))
                 {
                  double ask=SymbolInfoDouble(NULL,SYMBOL_ASK);
                  double control_value=NormalizeDouble(ask-distance_pending_request*SymbolInfoDouble(NULL,SYMBOL_POINT),(int)SymbolInfoInteger(NULL,SYMBOL_DIGITS));
                  engine.SetNewActivationProperties((uchar)id,PEND_REQ_ACTIVATION_SOURCE_SYMBOL,PEND_REQ_ACTIVATE_BY_SYMBOL_ASK,control_value,EQUAL_OR_LESS,ask);
                 }
               //--- If the time criterion is selected
               if(ButtonState(prefix+EnumToString(BUTT_BUY)+"_TIME"))
                 {
                  ulong control_time=TimeCurrent()+bars_delay_pending_request*PeriodSeconds();
                  engine.SetNewActivationProperties((uchar)id,PEND_REQ_ACTIVATION_SOURCE_SYMBOL,PEND_REQ_ACTIVATE_BY_SYMBOL_TIME,control_time,EQUAL_OR_MORE,TimeCurrent());
                 }
              }
            CPendRequest *req_obj=engine.GetPendRequestByID((uchar)id);
            if(req_obj==NULL)
               return;
            if(engine.TradingGetLogLevel(Symbol())>LOG_LEVEL_NO_MSG)
              {
               ::Print(CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ADD_CRITERIONS)," #",req_obj.ID(),":");
               req_obj.PrintActivations();
              }
           }
        }
      //--- If the BUTT_BUY_LIMIT button is pressed: Place BuyLimit
      else if(button==EnumToString(BUTT_BUY_LIMIT))
        {
         //--- If the pending request creation buttons are not pressed, set BuyLimit
         if(!pending_buy_limit)
            engine.PlaceBuyLimit(lot,Symbol(),distance_pending,stoploss,takeprofit,magic,TextByLanguage("Отложенный BuyLimit","Pending BuyLimit order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_BUY_STOP button is pressed: Set BuyStop
      else if(button==EnumToString(BUTT_BUY_STOP))
        {
         //--- If the pending request creation buttons are not pressed, set BuyStop
         if(!pending_buy_stop)
            engine.PlaceBuyStop(lot,Symbol(),distance_pending,stoploss,takeprofit,magic,TextByLanguage("Отложенный BuyStop","Pending BuyStop order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_BUY_STOP_LIMIT button is pressed: Set BuyStopLimit
      else if(button==EnumToString(BUTT_BUY_STOP_LIMIT))
        {
         //--- If the pending request creation buttons are not pressed, set BuyStopLimit
         if(!pending_buy_stoplimit)
            engine.PlaceBuyStopLimit(lot,Symbol(),distance_pending,distance_stoplimit,stoploss,takeprofit,magic,TextByLanguage("Отложенный BuyStopLimit","Pending BuyStopLimit order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_SELL button is pressed: Open Sell position
      else if(button==EnumToString(BUTT_SELL))
        {
         //--- If the pending request creation buttons are not pressed, open Sell
         if(!pending_sell)
            engine.OpenSell(lot,Symbol(),magic,stoploss,takeprofit);  // No comment - the default comment is to be set
         //--- Otherwise, create a pending request for opening a Sell position
         else
           {
            int id=engine.OpenSellPending(lot,Symbol(),magic,stoploss,takeprofit);
            if(id>0)
              {
               //--- If the price criterion is selected
               if(ButtonState(prefix+EnumToString(BUTT_SELL)+"_PRICE"))
                 {
                  double bid=SymbolInfoDouble(NULL,SYMBOL_BID);
                  double control_value=NormalizeDouble(bid+distance_pending_request*SymbolInfoDouble(NULL,SYMBOL_POINT),(int)SymbolInfoInteger(NULL,SYMBOL_DIGITS));
                  engine.SetNewActivationProperties((uchar)id,PEND_REQ_ACTIVATION_SOURCE_SYMBOL,PEND_REQ_ACTIVATE_BY_SYMBOL_BID,control_value,EQUAL_OR_MORE,bid);
                 }
               //--- If the time criterion is selected
               if(ButtonState(prefix+EnumToString(BUTT_SELL)+"_TIME"))
                 {
                  ulong control_time=TimeCurrent()+bars_delay_pending_request*PeriodSeconds();
                  engine.SetNewActivationProperties((uchar)id,PEND_REQ_ACTIVATION_SOURCE_SYMBOL,PEND_REQ_ACTIVATE_BY_SYMBOL_TIME,control_time,EQUAL_OR_MORE,TimeCurrent());
                 }
              }
            CPendRequest *req_obj=engine.GetPendRequestByID((uchar)id);
            if(req_obj==NULL)
               return;
            if(engine.TradingGetLogLevel(Symbol())>LOG_LEVEL_NO_MSG)
              {
               ::Print(CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ADD_CRITERIONS)," #",req_obj.ID(),":");
               req_obj.PrintActivations();
              }
           }
        }
      //--- If the BUTT_SELL_LIMIT button is pressed: Set SellLimit
      else if(button==EnumToString(BUTT_SELL_LIMIT))
        {
         //--- If the pending request creation buttons are not pressed, set SellLimit
         if(!pending_sell_limit)
            engine.PlaceSellLimit(lot,Symbol(),distance_pending,stoploss,takeprofit,magic,TextByLanguage("Отложенный SellLimit","Pending SellLimit order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_SELL_STOP button is pressed: Set SellStop
      else if(button==EnumToString(BUTT_SELL_STOP))
        {
         //--- If the pending request creation buttons are not pressed, set SellStop
         if(!pending_sell_stop)
            engine.PlaceSellStop(lot,Symbol(),distance_pending,stoploss,takeprofit,magic,TextByLanguage("Отложенный SellStop","Pending SellStop order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_SELL_STOP_LIMIT button is pressed: Set SellStopLimit
      else if(button==EnumToString(BUTT_SELL_STOP_LIMIT))
        {
         //--- If the pending request creation buttons are not pressed, set SellStopLimit
         if(!pending_sell_stoplimit)
            engine.PlaceSellStopLimit(lot,Symbol(),distance_pending,distance_stoplimit,stoploss,takeprofit,magic,TextByLanguage("Отложенный SellStopLimit","Pending SellStopLimit order"));
         //--- Otherwise, do nothing in this version
         else
           {
            
           }
        }
      //--- If the BUTT_CLOSE_BUY button is pressed: Close Buy with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_BUY))
        {
         //--- Get the list of all open positions
         CArrayObj* list=engine.GetListMarketPosition();
         //--- Select only Buy positions from the list and for the current symbol only
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
         //--- Sort the list by profit considering commission and swap
         list.Sort(SORT_BY_ORDER_PROFIT_FULL);
         //--- Get the index of the Buy position with the maximum profit
         int index=CSelect::FindOrderMax(list,ORDER_PROP_PROFIT_FULL);
         if(index>WRONG_VALUE)
           {
            //--- Get the Buy position object and close a position by ticket
            COrder* position=list.At(index);
            if(position!=NULL)
               engine.ClosePosition((ulong)position.Ticket());
           }
        }
      //--- If the BUTT_CLOSE_BUY2 button is pressed: Close the half of the Buy with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_BUY2))
        {
         //--- Get the list of all open positions
         CArrayObj* list=engine.GetListMarketPosition();
         //--- Select only Buy positions from the list and for the current symbol only
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
         //--- Sort the list by profit considering commission and swap
         list.Sort(SORT_BY_ORDER_PROFIT_FULL);
         //--- Get the index of the Buy position with the maximum profit
         int index=CSelect::FindOrderMax(list,ORDER_PROP_PROFIT_FULL);
         if(index>WRONG_VALUE)
           {
            COrder* position=list.At(index);
            //--- Close the Buy position partially
            if(position!=NULL)
               engine.ClosePositionPartially((ulong)position.Ticket(),position.Volume()/2.0);
           }
        }
      //--- If the BUTT_CLOSE_BUY_BY_SELL button is pressed: Close Buy with the maximum profit by the opposite Sell with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_BUY_BY_SELL))
        {
         //--- In case of a hedging account
         if(engine.IsHedge())
           {
            CArrayObj *list_buy=NULL, *list_sell=NULL;
            //--- Get the list of all open positions
            CArrayObj* list=engine.GetListMarketPosition();
            if(list==NULL)
               return;
            //--- Select only current symbol positions from the list
            list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
            
            //--- Select only Buy positions from the list
            list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
            if(list_buy==NULL)
               return;
            //--- Sort the list by profit considering commission and swap
            list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_FULL);
            
            //--- Select only Sell positions from the list
            list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
            if(list_sell==NULL)
               return;
            //--- Sort the list by profit considering commission and swap
            list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_FULL);
            if(index_buy>WRONG_VALUE && index_sell>WRONG_VALUE)
              {
               //--- Select the Buy position with the maximum profit
               COrder* position_buy=list_buy.At(index_buy);
               //--- Select the Sell position with the maximum profit
               COrder* position_sell=list_sell.At(index_sell);
               //--- Close the Buy position by the opposite Sell one
               if(position_buy!=NULL && position_sell!=NULL)
                  engine.ClosePositionBy((ulong)position_buy.Ticket(),(ulong)position_sell.Ticket());
              }
           }
        }
        
      //--- If the BUTT_CLOSE_SELL button is pressed: Close Sell with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_SELL))
        {
         //--- Get the list of all open positions
         CArrayObj* list=engine.GetListMarketPosition();
         //--- Select only Sell positions from the list and for the current symbol only
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
         //--- Sort the list by profit considering commission and swap
         list.Sort(SORT_BY_ORDER_PROFIT_FULL);
         //--- Get the index of the Sell position with the maximum profit
         int index=CSelect::FindOrderMax(list,ORDER_PROP_PROFIT_FULL);
         if(index>WRONG_VALUE)
           {
            //--- Get the Sell position object and close a position by ticket
            COrder* position=list.At(index);
            if(position!=NULL)
               engine.ClosePosition((ulong)position.Ticket());
           }
        }
      //--- If the BUTT_CLOSE_SELL2 button is pressed: Close the half of the Sell with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_SELL2))
        {
         //--- Get the list of all open positions
         CArrayObj* list=engine.GetListMarketPosition();
         //--- Select only Sell positions from the list and for the current symbol only
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         list=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
         //--- Sort the list by profit considering commission and swap
         list.Sort(SORT_BY_ORDER_PROFIT_FULL);
         //--- Get the index of the Sell position with the maximum profit
         int index=CSelect::FindOrderMax(list,ORDER_PROP_PROFIT_FULL);
         if(index>WRONG_VALUE)
           {
            COrder* position=list.At(index);
            //--- Close the Sell position partially
            if(position!=NULL)
               engine.ClosePositionPartially((ulong)position.Ticket(),position.Volume()/2.0);
           }
        }
      //--- If the BUTT_CLOSE_SELL_BY_BUY button is pressed: Close Sell with the maximum profit by the opposite Buy with the maximum profit
      else if(button==EnumToString(BUTT_CLOSE_SELL_BY_BUY))
        {
         //--- In case of a hedging account
         if(engine.IsHedge())
           {
            CArrayObj *list_buy=NULL, *list_sell=NULL;
            //--- Get the list of all open positions
            CArrayObj* list=engine.GetListMarketPosition();
            if(list==NULL)
               return;
            //--- Select only current symbol positions from the list
            list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
            
            //--- Select only Sell positions from the list
            list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
            if(list_sell==NULL)
               return;
            //--- Sort the list by profit considering commission and swap
            list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_FULL);
            
            //--- Select only Buy positions from the list
            list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
            if(list_buy==NULL)
               return;
            //--- Sort the list by profit considering commission and swap
            list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_FULL);
            if(index_sell>WRONG_VALUE && index_buy>WRONG_VALUE)
              {
               //--- Select the Sell position with the maximum profit
               COrder* position_sell=list_sell.At(index_sell);
               //--- Select the Buy position with the maximum profit
               COrder* position_buy=list_buy.At(index_buy);
               //--- Close the Sell position by the opposite Buy one
               if(position_sell!=NULL && position_buy!=NULL)
                  engine.ClosePositionBy((ulong)position_sell.Ticket(),(ulong)position_buy.Ticket());
              }
           }
        }
      //--- If the BUTT_CLOSE_ALL is pressed: Close all positions starting with the one with the least profit
      else if(button==EnumToString(BUTT_CLOSE_ALL))
        {
         //--- Get the list of all open positions
         CArrayObj* list=engine.GetListMarketPosition();
         //--- Select only current symbol positions from the list
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         if(list!=NULL)
           {
            //--- Sort the list by profit considering commission and swap
            list.Sort(SORT_BY_ORDER_PROFIT_FULL);
            int total=list.Total();
            //--- In the loop from the position with the least profit
            for(int i=0;i<total;i++)
              {
               COrder* position=list.At(i);
               if(position==NULL)
                  continue;
               //--- close each position by its ticket
               engine.ClosePosition((ulong)position.Ticket());
              }
           }
        }
      //--- If the BUTT_DELETE_PENDING button is pressed: Remove pending orders starting from the oldest one
      else if(button==EnumToString(BUTT_DELETE_PENDING))
        {
         //--- Get the list of all orders
         CArrayObj* list=engine.GetListMarketPendings();
         //--- Select only current symbol orders from the list
         list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
         if(list!=NULL)
           {
            //--- Sort the list by placement time
            list.Sort(SORT_BY_ORDER_TIME_OPEN);
            int total=list.Total();
            //--- In a loop from an order with the longest time
            for(int i=total-1;i>=0;i--)
              {
               COrder* order=list.At(i);
               if(order==NULL)
                  continue;
               //--- delete the order by its ticket
               engine.DeleteOrder((ulong)order.Ticket());
              }
           }
        }
      //--- If the BUTT_PROFIT_WITHDRAWAL button is pressed: Withdraw funds from the account
      if(button==EnumToString(BUTT_PROFIT_WITHDRAWAL))
        {
         //--- If the program is launched in the tester
         if(MQLInfoInteger(MQL_TESTER))
           {
            //--- Emulate funds withdrawal
            TesterWithdrawal(withdrawal);
           }
        }
      //--- If the BUTT_SET_STOP_LOSS button is pressed: Place StopLoss to all orders and positions where it is not present
      if(button==EnumToString(BUTT_SET_STOP_LOSS))
        {
         SetStopLoss();
        }
      //--- If the BUTT_SET_TAKE_PROFIT button is pressed: Place TakeProfit to all orders and positions where it is not present
      if(button==EnumToString(BUTT_SET_TAKE_PROFIT))
        {
         SetTakeProfit();
        }
      //--- Wait for 1/10 of a second
      Sleep(100);
      //--- "Unpress" the button (if this is neither a trailing button, nor the buttons enabling pending requests)
      if(button!=EnumToString(BUTT_TRAILING_ALL) && StringFind(button,"_PRICE")<0 && StringFind(button,"_TIME")<0)
         ButtonState(button_name,false);
      //--- If the BUTT_TRAILING_ALL button or the buttons enabling pending requests are pressed
      else
        {
         //--- Set the active button color for the button enabling trailing
         if(button==EnumToString(BUTT_TRAILING_ALL))
           {
            ButtonState(button_name,true);
            trailing_on=true;
           }
         
         //--- Buying
         //--- Set the active button color for the button enabling pending requests for opening Buy by price or time
         if(button==EnumToString(BUTT_BUY)+"_PRICE" || button==EnumToString(BUTT_BUY)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_buy=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing BuyLimit by price or time
         if(button==EnumToString(BUTT_BUY_LIMIT)+"_PRICE" || button==EnumToString(BUTT_BUY_LIMIT)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_buy_limit=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing BuyStop by price or time
         if(button==EnumToString(BUTT_BUY_STOP)+"_PRICE" || button==EnumToString(BUTT_BUY_STOP)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_buy_stop=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing BuyStopLimit by price or time
         if(button==EnumToString(BUTT_BUY_STOP_LIMIT)+"_PRICE" || button==EnumToString(BUTT_BUY_STOP_LIMIT)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_buy_stoplimit=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing Buy by price or time
         if(button==EnumToString(BUTT_CLOSE_BUY)+"_PRICE" || button==EnumToString(BUTT_CLOSE_BUY)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_buy=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing 1/2 Buy by price or time
         if(button==EnumToString(BUTT_CLOSE_BUY2)+"_PRICE" || button==EnumToString(BUTT_CLOSE_BUY2)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_buy2=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing Buy by an opposite Sell by price or time
         if(button==EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_PRICE" || button==EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_buy_by_sell=true;
           }
         
         //--- Selling
         //--- Set the active button color for the button enabling pending requests for opening Sell by price or time
         if(button==EnumToString(BUTT_SELL)+"_PRICE" || button==EnumToString(BUTT_SELL)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_sell=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing SellLimit by price or time
         if(button==EnumToString(BUTT_SELL_LIMIT)+"_PRICE" || button==EnumToString(BUTT_SELL_LIMIT)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_sell_limit=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing SellStop by price or time
         if(button==EnumToString(BUTT_SELL_STOP)+"_PRICE" || button==EnumToString(BUTT_SELL_STOP)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_sell_stop=true;
           }
         //--- Set the active button color for the button enabling pending requests for placing SellStopLimit by price or time
         if(button==EnumToString(BUTT_SELL_STOP_LIMIT)+"_PRICE" || button==EnumToString(BUTT_SELL_STOP_LIMIT)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_sell_stoplimit=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing Sell by price or time
         if(button==EnumToString(BUTT_CLOSE_SELL)+"_PRICE" || button==EnumToString(BUTT_CLOSE_SELL)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_sell=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing 1/2 Sell by price or time
         if(button==EnumToString(BUTT_CLOSE_SELL2)+"_PRICE" || button==EnumToString(BUTT_CLOSE_SELL2)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_sell2=true;
           }
         //--- Set the active button color for the button enabling pending requests for closing Sell by an opposite Buy by price or time
         if(button==EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_PRICE" || button==EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_TIME")
           {
            ButtonState(button_name,true);
            pending_close_sell_by_buy=true;
           }
        }
      //--- re-draw the chart
      ChartRedraw();
     }
   //--- Return a color for the inactive buttons
   else 
     {
      //--- trailing button
      if(button==EnumToString(BUTT_TRAILING_ALL))
        {
         ButtonState(button_name,false);
         trailing_on=false;
        }
      
      //--- Buying
      //--- the button enabling pending requests for opening Buy by price
      if(button==EnumToString(BUTT_BUY)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY)+"_TIME"));
        }
      //--- the button enabling pending requests for opening Buy by time
      if(button==EnumToString(BUTT_BUY)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing BuyLimit by price
      if(button==EnumToString(BUTT_BUY_LIMIT)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_buy_limit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_LIMIT)+"_TIME"));
        }
      //--- the button enabling pending requests for placing BuyLimit by time
      if(button==EnumToString(BUTT_BUY_LIMIT)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_buy_limit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_LIMIT)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing BuyStop by price
      if(button==EnumToString(BUTT_BUY_STOP)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_buy_stop=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_STOP)+"_TIME"));
        }
      //--- the button enabling pending requests for placing BuyStop by time
      if(button==EnumToString(BUTT_BUY_STOP)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_buy_stop=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_STOP)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing BuyStopLimit by price
      if(button==EnumToString(BUTT_BUY_STOP_LIMIT)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_buy_stoplimit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_STOP_LIMIT)+"_TIME"));
        }
      //--- the button enabling pending requests for placing BuyStopLimit by time
      if(button==EnumToString(BUTT_BUY_STOP_LIMIT)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_buy_stoplimit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_BUY_STOP_LIMIT)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing Buy by price
      if(button==EnumToString(BUTT_CLOSE_BUY)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY)+"_TIME"));
        }
      //--- the button enabling pending requests for closing Buy by time
      if(button==EnumToString(BUTT_CLOSE_BUY)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing 1/2 Buy by price
      if(button==EnumToString(BUTT_CLOSE_BUY2)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_buy2=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY2)+"_TIME"));
        }
      //--- the button enabling pending requests for closing 1/2 Buy by time
      if(button==EnumToString(BUTT_CLOSE_BUY2)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_buy2=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY2)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing Buy by an opposite Sell by price
      if(button==EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_buy_by_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_TIME"));
        }
      //--- the button enabling pending requests for closing Buy by an opposite Sell by time
      if(button==EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_buy_by_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_BUY_BY_SELL)+"_PRICE"));
        }

      //--- Selling
      //--- the button enabling pending requests for opening Sell by price
      if(button==EnumToString(BUTT_SELL)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL)+"_TIME"));
        }
      //--- the button enabling pending requests for opening Sell by time
      if(button==EnumToString(BUTT_SELL)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing SellLimit by price
      if(button==EnumToString(BUTT_SELL_LIMIT)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_sell_limit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_LIMIT)+"_TIME"));
        }
      //--- the button enabling pending requests for placing SellLimit by time
      if(button==EnumToString(BUTT_SELL_LIMIT)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_sell_limit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_LIMIT)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing SellStop by price
      if(button==EnumToString(BUTT_SELL_STOP)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_sell_stop=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_STOP)+"_TIME"));
        }
      //--- the button enabling pending requests for placing SellStop by time
      if(button==EnumToString(BUTT_SELL_STOP)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_sell_stop=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_STOP)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for placing SellStopLimit by price
      if(button==EnumToString(BUTT_SELL_STOP_LIMIT)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_sell_stoplimit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_STOP_LIMIT)+"_TIME"));
        }
      //--- the button enabling pending requests for placing SellStopLimit by time
      if(button==EnumToString(BUTT_SELL_STOP_LIMIT)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_sell_stoplimit=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_SELL_STOP_LIMIT)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing Sell by price
      if(button==EnumToString(BUTT_CLOSE_SELL)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL)+"_TIME"));
        }
      //--- the button enabling pending requests for closing Sell by time
      if(button==EnumToString(BUTT_CLOSE_SELL)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_sell=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing 1/2 Sell by price
      if(button==EnumToString(BUTT_CLOSE_SELL2)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_sell2=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL2)+"_TIME"));
        }
      //--- the button enabling pending requests for closing 1/2 Sell by time
      if(button==EnumToString(BUTT_CLOSE_SELL2)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_sell2=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL2)+"_PRICE"));
        }
      
      //--- the button enabling pending requests for closing Sell by an opposite Buy by price
      if(button==EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_PRICE")
        {
         ButtonState(button_name,false);
         pending_close_sell_by_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_TIME"));
        }
      //--- the button enabling pending requests for closing Sell by an opposite Buy by time
      if(button==EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_TIME")
        {
         ButtonState(button_name,false);
         pending_close_sell_by_buy=(ButtonState(button_name) | ButtonState(prefix+EnumToString(BUTT_CLOSE_SELL_BY_BUY)+"_PRICE"));
        }
      //--- re-draw the chart
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+
//| Set StopLoss to all orders and positions                         |
//+------------------------------------------------------------------+
void SetStopLoss(void)
  {
   if(stoploss_to_modify==0)
      return;
//--- Set StopLoss to all positions where it is absent
   //--- Get the list of all positions
   CArrayObj* list=engine.GetListMarketPosition();
   //--- Select only current symbol positions from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
   //--- select positions with zero StopLoss from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SL,0,EQUAL);
   if(list==NULL)
      return;
   int total=list.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder* position=list.At(i);
      if(position==NULL)
         continue;
      double sl=CorrectStopLoss(position.Symbol(),position.TypeByDirection(),0,stoploss_to_modify);
      engine.ModifyPosition((ulong)position.Ticket(),sl,-1);
     }
//--- Set StopLoss to all pending orders where it is absent
   //--- Get the list of all orders
   list=engine.GetListMarketPendings();
   //--- Select only current symbol positions from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
   //--- select orders with zero StopLoss from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SL,0,EQUAL);
   if(list==NULL)
      return;
   total=list.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder* order=list.At(i);
      if(order==NULL)
         continue;
      double sl=CorrectStopLoss(order.Symbol(),(ENUM_ORDER_TYPE)order.TypeOrder(),order.PriceOpen(),stoploss_to_modify);
      engine.ModifyOrder((ulong)order.Ticket(),-1,sl,-1,-1);
     }
  }
//+------------------------------------------------------------------+
//| Set TakeProfit to all orders and positions                       |
//+------------------------------------------------------------------+
void SetTakeProfit(void)
  {
   if(takeprofit_to_modify==0)
      return;
//--- Set TakeProfit to all positions where it is absent
   //--- Get the list of all positions
   CArrayObj* list=engine.GetListMarketPosition();
   //--- Select only current symbol positions from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
   //--- select positions with zero TakeProfit from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TP,0,EQUAL);
   if(list==NULL)
      return;
   int total=list.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder* position=list.At(i);
      if(position==NULL)
         continue;
      double tp=CorrectTakeProfit(position.Symbol(),position.TypeByDirection(),0,takeprofit_to_modify);
      engine.ModifyPosition((ulong)position.Ticket(),-1,tp);
     }
//--- Set TakeProfit to all pending orders where it is absent
   //--- Get the list of all orders
   list=engine.GetListMarketPendings();
   //--- Select only current symbol orders from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
   //--- select orders with zero TakeProfit from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TP,0,EQUAL);
   if(list==NULL)
      return;
   total=list.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder* order=list.At(i);
      if(order==NULL)
         continue;
      double tp=CorrectTakeProfit(order.Symbol(),(ENUM_ORDER_TYPE)order.TypeOrder(),order.PriceOpen(),takeprofit_to_modify);
      engine.ModifyOrder((ulong)order.Ticket(),-1,-1,tp,-1);
     }
  }
//+------------------------------------------------------------------+
//| Trailing stop of a position with the maximum profit              |
//+------------------------------------------------------------------+
void TrailingPositions(void)
  {
   MqlTick tick;
   if(!SymbolInfoTick(Symbol(),tick))
      return;
   double stop_level=StopLevel(Symbol(),2)*Point();
   //--- Get the list of all open positions
   CArrayObj* list=engine.GetListMarketPosition();
   //--- Select only current symbol positions from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
   //--- Select only Buy positions from the list
   CArrayObj* list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
   //--- Sort the list by profit considering commission and swap
   list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
   //--- Get the index of the Buy position with the maximum profit
   int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_FULL);
   if(index_buy>WRONG_VALUE)
     {
      COrder* buy=list_buy.At(index_buy);
      if(buy!=NULL)
        {
         //--- Calculate the new StopLoss
         double sl=NormalizeDouble(tick.bid-trailing_stop,Digits());
         //--- If the price and the StopLevel based on it are higher than the new StopLoss (the distance by StopLevel is maintained)
         if(tick.bid-stop_level>sl) 
           {
            //--- If the new StopLoss level exceeds the trailing step based on the current StopLoss
            if(buy.StopLoss()+trailing_step<sl)
              {
               //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
               if(trailing_start==0 || buy.ProfitInPoints()>(int)trailing_start)
                 {
                  engine.ModifyPosition((ulong)buy.Ticket(),sl,-1);
                 }
              }
           }
        }
     }
   //--- Select only Sell positions from the list
   CArrayObj* list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
   //--- Sort the list by profit considering commission and swap
   list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
   //--- Get the index of the Sell position with the maximum profit
   int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_FULL);
   if(index_sell>WRONG_VALUE)
     {
      COrder* sell=list_sell.At(index_sell);
      if(sell!=NULL)
        {
         //--- Calculate the new StopLoss
         double sl=NormalizeDouble(tick.ask+trailing_stop,Digits());
         //--- If the price and StopLevel based on it are below the new StopLoss (the distance by StopLevel is maintained)
         if(tick.ask+stop_level<sl) 
           {
            //--- If the new StopLoss level is below the trailing step based on the current StopLoss or a position has no StopLoss
            if(sell.StopLoss()-trailing_step>sl || sell.StopLoss()==0)
              {
               //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
               if(trailing_start==0 || sell.ProfitInPoints()>(int)trailing_start)
                 {
                  engine.ModifyPosition((ulong)sell.Ticket(),sl,-1);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Trailing the farthest pending orders                             |
//+------------------------------------------------------------------+
void TrailingOrders(void)
  {
   MqlTick tick;
   if(!SymbolInfoTick(Symbol(),tick))
      return;
   double stop_level=StopLevel(Symbol(),2)*Point();
//--- Get the list of all placed orders
   CArrayObj* list=engine.GetListMarketPendings();
   //--- Select only current symbol orders from the list
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SYMBOL,Symbol(),EQUAL);
//--- Select only Buy orders from the list
   CArrayObj* list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_BUY,EQUAL);
   //--- Sort the list by distance from the price in points (by profit in points)
   list_buy.Sort(SORT_BY_ORDER_PROFIT_PT);
   //--- Get the index of the Buy order with the greatest distance
   int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_PT);
   if(index_buy>WRONG_VALUE)
     {
      COrder* buy=list_buy.At(index_buy);
      if(buy!=NULL)
        {
         //--- If the order is below the price (BuyLimit) and it should be "elevated" following the price
         if(buy.TypeOrder()==ORDER_TYPE_BUY_LIMIT)
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.ask-trailing_stop,Digits());
            double sl=(buy.StopLoss()>0 ? NormalizeDouble(price-(buy.PriceOpen()-buy.StopLoss()),Digits()) : 0);
            double tp=(buy.TakeProfit()>0 ? NormalizeDouble(price+(buy.TakeProfit()-buy.PriceOpen()),Digits()) : 0);
            //--- If the calculated price is below the StopLevel distance based on Ask order price (the distance by StopLevel is maintained)
            if(price<tick.ask-stop_level) 
              {
               //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
               if(price>buy.PriceOpen()+trailing_step)
                 {
                  engine.ModifyOrder((ulong)buy.Ticket(),price,sl,tp,-1);
                 }
              }
           }
         //--- If the order exceeds the price (BuyStop and BuyStopLimit), and it should be "decreased" following the price
         else
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.ask+trailing_stop,Digits());
            double sl=(buy.StopLoss()>0 ? NormalizeDouble(price-(buy.PriceOpen()-buy.StopLoss()),Digits()) : 0);
            double tp=(buy.TakeProfit()>0 ? NormalizeDouble(price+(buy.TakeProfit()-buy.PriceOpen()),Digits()) : 0);
            //--- If the calculated price exceeds the StopLevel based on Ask order price (the distance by StopLevel is maintained)
            if(price>tick.ask+stop_level) 
              {
               //--- If the calculated price is lower than the trailing step based on order price, modify the order price
               if(price<buy.PriceOpen()-trailing_step)
                 {
                  engine.ModifyOrder((ulong)buy.Ticket(),price,sl,tp,-1);
                 }
              }
           }
        }
     }
//--- Select only Sell order from the list
   CArrayObj* list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_SELL,EQUAL);
   //--- Sort the list by distance from the price in points (by profit in points)
   list_sell.Sort(SORT_BY_ORDER_PROFIT_PT);
   //--- Get the index of the Sell order having the greatest distance
   int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_PT);
   if(index_sell>WRONG_VALUE)
     {
      COrder* sell=list_sell.At(index_sell);
      if(sell!=NULL)
        {
         //--- If the order exceeds the price (SellLimit), and it needs to be "decreased" following the price
         if(sell.TypeOrder()==ORDER_TYPE_SELL_LIMIT)
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.bid+trailing_stop,Digits());
            double sl=(sell.StopLoss()>0 ? NormalizeDouble(price+(sell.StopLoss()-sell.PriceOpen()),Digits()) : 0);
            double tp=(sell.TakeProfit()>0 ? NormalizeDouble(price-(sell.PriceOpen()-sell.TakeProfit()),Digits()) : 0);
            //--- If the calculated price exceeds the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
            if(price>tick.bid+stop_level) 
              {
               //--- If the calculated price is lower than the trailing step based on order price, modify the order price
               if(price<sell.PriceOpen()-trailing_step)
                 {
                  engine.ModifyOrder((ulong)sell.Ticket(),price,sl,tp,-1);
                 }
              }
           }
         //--- If the order is below the price (SellStop and SellStopLimit), and it should be "elevated" following the price
         else
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.bid-trailing_stop,Digits());
            double sl=(sell.StopLoss()>0 ? NormalizeDouble(price+(sell.StopLoss()-sell.PriceOpen()),Digits()) : 0);
            double tp=(sell.TakeProfit()>0 ? NormalizeDouble(price-(sell.PriceOpen()-sell.TakeProfit()),Digits()) : 0);
            //--- If the calculated price is below the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
            if(price<tick.bid-stop_level) 
              {
               //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
               if(price>sell.PriceOpen()+trailing_step)
                 {
                  engine.ModifyOrder((ulong)sell.Ticket(),price,sl,tp,-1);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| A random value within the range                                  |
//+------------------------------------------------------------------+
uint Rand(const uint min=0, const uint max=15)
  {
   return (rand() % (max+1-min))+min;
  }
//+------------------------------------------------------------------+
