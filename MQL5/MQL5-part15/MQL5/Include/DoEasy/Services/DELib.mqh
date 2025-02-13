//+------------------------------------------------------------------+
//|                                                        DELib.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property strict  // Necessary for mql4
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\Defines.mqh"
#include "TimerCounter.mqh"
//+------------------------------------------------------------------+
//| Service functions                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Display all sorting enumeration constants in the journal         |
//+------------------------------------------------------------------+
void EnumNumbersTest()
  {
   string enm="ENUM_SORT_SYMBOLS_MODE";
   string t=StringSubstr(enm,5,5)+"";//"BY";
   Print("Search of the values of the enumaration ",enm,":");
   ENUM_SORT_SYMBOLS_MODE type=0;
   while(StringFind(EnumToString(type),t)==0)
     {
      Print(enm,"[",type,"]=",EnumToString(type));
      if(type>500) break;
      type++;
     }
   Print("\nNumber of members of the ",enm,"=",type);
  }
//+------------------------------------------------------------------+
//| Return the text in one of two languages                          |
//+------------------------------------------------------------------+
string TextByLanguage(const string text_country_lang,const string text_en)
  {
   return(TerminalInfoString(TERMINAL_LANGUAGE)==COUNTRY_LANG ? text_country_lang : text_en);
  }
//+------------------------------------------------------------------+
//| Return time with milliseconds                                    |
//+------------------------------------------------------------------+
string TimeMSCtoString(const long time_msc)
  {
   return TimeToString(time_msc/1000,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+"."+IntegerToString(time_msc%1000,3,'0');
  }
//+------------------------------------------------------------------+
//| Returns the number of decimal places in a symbol lot             |
//+------------------------------------------------------------------+
uint DigitsLots(const string symbol_name) 
  { 
   return (int)ceil(fabs(log10(SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_STEP))));
  }
//+------------------------------------------------------------------+
//| Return the minimum symbol lot                                    |
//+------------------------------------------------------------------+
double MinimumLots(const string symbol_name) 
  { 
   return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MIN);
  }
//+------------------------------------------------------------------+
//| Return the maximum symbol lot                                    |
//+------------------------------------------------------------------+
double MaximumLots(const string symbol_name) 
  { 
   return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MAX);
  }
//+------------------------------------------------------------------+
//| Return the symbol lot change step                                |
//+------------------------------------------------------------------+
double StepLots(const string symbol_name) 
  { 
   return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_STEP);
  }
//+------------------------------------------------------------------+
//| Return the normalized lot                                        |
//+------------------------------------------------------------------+
double NormalizeLot(const string symbol_name, double order_lots) 
  {
   double ml=SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MAX);
   double ln=NormalizeDouble(order_lots,DigitsLots(symbol_name));
   return(ln<ml ? ml : ln>mx ? mx : ln);
  }
//+------------------------------------------------------------------+
//| Prepare the symbol array for a symbol collection                 |
//+------------------------------------------------------------------+
bool CreateUsedSymbolsArray(const ENUM_SYMBOLS_MODE mode_used_symbols,string defined_used_symbols,string &used_symbols_array[])
  {
   //--- When working with the current symbol
   if(mode_used_symbols==SYMBOLS_MODE_CURRENT)
     {
      //--- Write the name of the current symbol to the only array cell
      ArrayResize(used_symbols_array,1);
      used_symbols_array[0]=Symbol();
      return true;
     }
   //--- If working with a predefined symbol set (from the defined_used_symbols string)
   else if(mode_used_symbols==SYMBOLS_MODE_DEFINES)
     {
      //--- Set a comma as a separator
      string separator=",";
      //--- Replace erroneous separators with correct ones
      if(StringFind(defined_used_symbols,";")>WRONG_VALUE)  StringReplace(defined_used_symbols,";",separator);   
      if(StringFind(defined_used_symbols,":")>WRONG_VALUE)  StringReplace(defined_used_symbols,":",separator); 
      if(StringFind(defined_used_symbols,"|")>WRONG_VALUE)  StringReplace(defined_used_symbols,"|",separator);   
      if(StringFind(defined_used_symbols,"/")>WRONG_VALUE)  StringReplace(defined_used_symbols,"/",separator); 
      if(StringFind(defined_used_symbols,"\\")>WRONG_VALUE) StringReplace(defined_used_symbols,"\\",separator);  
      if(StringFind(defined_used_symbols,"'")>WRONG_VALUE)  StringReplace(defined_used_symbols,"'",separator); 
      if(StringFind(defined_used_symbols,"-")>WRONG_VALUE)  StringReplace(defined_used_symbols,"-",separator);   
      if(StringFind(defined_used_symbols,"`")>WRONG_VALUE)  StringReplace(defined_used_symbols,"`",separator);
      //--- Delete as long as there are spaces
      while(StringFind(defined_used_symbols," ")>WRONG_VALUE && !IsStopped()) 
         StringReplace(defined_used_symbols," ","");
      //--- As soon as there are double separators (after removing spaces between them), replace them with a separator
      while(StringFind(defined_used_symbols,separator+separator)>WRONG_VALUE && !IsStopped())
         StringReplace(defined_used_symbols,separator+separator,separator);
      //--- If a single separator remains before the first symbol in the string, replace it with a space
      if(StringFind(defined_used_symbols,separator)==0) 
         StringSetCharacter(defined_used_symbols,0,32);
      //--- If a single separator remains after the last symbol in the string, replace it with a space
      if(StringFind(defined_used_symbols,separator)==StringLen(defined_used_symbols)-1)
         StringSetCharacter(defined_used_symbols,StringLen(defined_used_symbols)-1,32);
      //--- Remove all redundant things to the left and right
      #ifdef __MQL5__
         StringTrimLeft(defined_used_symbols);
         StringTrimRight(defined_used_symbols);
      //---  __MQL4__
      #else 
         defined_used_symbols=StringTrimLeft(defined_used_symbols);
         defined_used_symbols=StringTrimRight(defined_used_symbols);
      #endif 
      //--- Prepare the array 
      ArrayResize(used_symbols_array,0);
      ResetLastError();
      //--- divide the string by separators (comma) and add all found substrings to the array
      int n=StringSplit(defined_used_symbols,StringGetCharacter(separator,0),used_symbols_array);
      //--- if nothing is found, display the appropriate message (working with the current symbol is selected automatically)
      if(n<1)
        {
         string err=
           (n==0  ?  
            DFUN_ERR_LINE+TextByLanguage("Ошибка. Строка предопределённых символов пустая, будет использоваться ","Error. String of predefined symbols is empty, the symbol will be used: ")+Symbol() :
            DFUN_ERR_LINE+TextByLanguage("Не удалось подготовить массив используемых символов. Ошибка ","Failed to create an array of used characters. Error ")+(string)GetLastError()
           );
         Print(err);
         return false;
        }
     }
   //--- If working with the Market Watch window or the full list
   else
     {
      //--- Add the (mode_used_symbols) working mode to the only array cell
      ArrayResize(used_symbols_array,1);
      used_symbols_array[0]=EnumToString(mode_used_symbols);
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Return correct StopLoss relative to StopLevel                    |
//+------------------------------------------------------------------+
double CorrectStopLoss(const string symbol_name,const ENUM_ORDER_TYPE order_type,const double price_set,const double stop_loss,const int spread_multiplier=2)
  {
   if(stop_loss==0) return 0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT);
   double price=(order_type==ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : order_type==ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price_set);
   return
     (order_type==ORDER_TYPE_BUY       || 
      order_type==ORDER_TYPE_BUY_LIMIT || 
      order_type==ORDER_TYPE_BUY_STOP
      #ifdef __MQL5__                  ||
      order_type==ORDER_TYPE_BUY_STOP_LIMIT
      #endif ? 
      NormalizeDouble(fmin(price-lv*pt,stop_loss),dg) :
      NormalizeDouble(fmax(price+lv*pt,stop_loss),dg)
     );
  }
//+------------------------------------------------------------------+
//| Return correct StopLoss relative to StopLevel                    |
//+------------------------------------------------------------------+
double CorrectStopLoss(const string symbol_name,const ENUM_ORDER_TYPE order_type,const double price_set,const int stop_loss,const int spread_multiplier=2)
  {
   if(stop_loss==0) return 0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT);
   double price=(order_type==ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : order_type==ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price_set);
   return
     (order_type==ORDER_TYPE_BUY       || 
      order_type==ORDER_TYPE_BUY_LIMIT || 
      order_type==ORDER_TYPE_BUY_STOP
      #ifdef __MQL5__                  ||
      order_type==ORDER_TYPE_BUY_STOP_LIMIT
      #endif ?
      NormalizeDouble(fmin(price-lv*pt,price-stop_loss*pt),dg) :
      NormalizeDouble(fmax(price+lv*pt,price+stop_loss*pt),dg)
     );
  }
//+------------------------------------------------------------------+
//| Return correct TakeProfit relative to StopLevel                  |
//+------------------------------------------------------------------+
double CorrectTakeProfit(const string symbol_name,const ENUM_ORDER_TYPE order_type,const double price_set,const double take_profit,const int spread_multiplier=2)
  {
   if(take_profit==0) return 0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT);
   double price=(order_type==ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : order_type==ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price_set);
   return
     (order_type==ORDER_TYPE_BUY       || 
      order_type==ORDER_TYPE_BUY_LIMIT || 
      order_type==ORDER_TYPE_BUY_STOP
      #ifdef __MQL5__                  ||
      order_type==ORDER_TYPE_BUY_STOP_LIMIT
      #endif ?
      NormalizeDouble(fmax(price+lv*pt,take_profit),dg) :
      NormalizeDouble(fmin(price-lv*pt,take_profit),dg)
     );
  }
//+------------------------------------------------------------------+
//| Return correct TakeProfit relative to StopLevel                  |
//+------------------------------------------------------------------+
double CorrectTakeProfit(const string symbol_name,const ENUM_ORDER_TYPE order_type,const double price_set,const int take_profit,const int spread_multiplier=2)
  {
   if(take_profit==0) return 0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT);
   double price=(order_type==ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : order_type==ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price_set);
   return
     (order_type==ORDER_TYPE_BUY       || 
      order_type==ORDER_TYPE_BUY_LIMIT || 
      order_type==ORDER_TYPE_BUY_STOP
      #ifdef __MQL5__                  ||
      order_type==ORDER_TYPE_BUY_STOP_LIMIT
      #endif ?
      ::NormalizeDouble(::fmax(price+lv*pt,price+take_profit*pt),dg) :
      ::NormalizeDouble(::fmin(price-lv*pt,price-take_profit*pt),dg)
     );
  }
//+------------------------------------------------------------------+
//| Return the correct order placement price                         |
//| relative to StopLevel                                            |
//+------------------------------------------------------------------+
double CorrectPricePending(const string symbol_name,const ENUM_ORDER_TYPE order_type,const double price_set,const double price=0,const int spread_multiplier=2)
  {
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT),pp=0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   switch((int)order_type)
     {
      case ORDER_TYPE_BUY_LIMIT        :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price); return NormalizeDouble(fmin(pp-lv*pt,price_set),dg);
      case ORDER_TYPE_BUY_STOP         :  
      case ORDER_TYPE_BUY_STOP_LIMIT   :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price); return NormalizeDouble(fmax(pp+lv*pt,price_set),dg);
      case ORDER_TYPE_SELL_LIMIT       :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : price); return NormalizeDouble(fmax(pp+lv*pt,price_set),dg);
      case ORDER_TYPE_SELL_STOP        :  
      case ORDER_TYPE_SELL_STOP_LIMIT  :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : price); return NormalizeDouble(fmin(pp-lv*pt,price_set),dg);
      default                          :  Print(DFUN,TextByLanguage("Неправильный тип ордера: ","Invalid order type: "),EnumToString(order_type)); return 0;
     }
  }
//+------------------------------------------------------------------+
//| Return the correct order placement price                         |
//| relative to StopLevel                                            |
//+------------------------------------------------------------------+
double CorrectPricePending(const string symbol_name,const ENUM_ORDER_TYPE order_type,const int distance_set,const double price=0,const int spread_multiplier=2)
  {
   double pt=SymbolInfoDouble(symbol_name,SYMBOL_POINT),pp=0;
   int lv=StopLevel(symbol_name,spread_multiplier), dg=(int)SymbolInfoInteger(symbol_name,SYMBOL_DIGITS);
   switch((int)order_type)
     {
      case ORDER_TYPE_BUY_LIMIT        :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price); return NormalizeDouble(fmin(pp-lv*pt,pp-distance_set*pt),dg);
      case ORDER_TYPE_BUY_STOP         :  
      case ORDER_TYPE_BUY_STOP_LIMIT   :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_ASK) : price); return NormalizeDouble(fmax(pp+lv*pt,pp+distance_set*pt),dg);
      case ORDER_TYPE_SELL_LIMIT       :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : price); return NormalizeDouble(fmax(pp+lv*pt,pp+distance_set*pt),dg);
      case ORDER_TYPE_SELL_STOP        :  
      case ORDER_TYPE_SELL_STOP_LIMIT  :  pp=(price==0 ? SymbolInfoDouble(symbol_name,SYMBOL_BID) : price); return NormalizeDouble(fmin(pp-lv*pt,pp-distance_set*pt),dg);
      default                          :  Print(DFUN,TextByLanguage("Неправильный тип ордера: ","Invalid order type: "),EnumToString(order_type)); return 0;
     }
  }
//+------------------------------------------------------------------+
//| Check the stop level in points relative to StopLevel             |
//+------------------------------------------------------------------+
bool CheckStopLevel(const string symbol_name,const int stop_in_points,const int spread_multiplier)
  {
   return(stop_in_points>=StopLevel(symbol_name,spread_multiplier));
  }
//+------------------------------------------------------------------+
//| Return StopLevel in points                                       |
//+------------------------------------------------------------------+
int StopLevel(const string symbol_name,const int spread_multiplier)
  {
   int spread=(int)SymbolInfoInteger(symbol_name,SYMBOL_SPREAD);
   int stop_level=(int)SymbolInfoInteger(symbol_name,SYMBOL_TRADE_STOPS_LEVEL);
   return(stop_level==0 ? spread*spread_multiplier : stop_level);
  }
//+------------------------------------------------------------------+
//| Return the order name                                            |
//+------------------------------------------------------------------+
string OrderTypeDescription(const ENUM_ORDER_TYPE type,bool as_order=true)
  {
   string pref=(#ifdef __MQL5__ "Market order" #else (as_order ? "Market order" : "Position") #endif );
   return
     (
      type==ORDER_TYPE_BUY_LIMIT       ?  "Buy Limit"                                                 :
      type==ORDER_TYPE_BUY_STOP        ?  "Buy Stop"                                                  :
      type==ORDER_TYPE_SELL_LIMIT      ?  "Sell Limit"                                                :
      type==ORDER_TYPE_SELL_STOP       ?  "Sell Stop"                                                 :
   #ifdef __MQL5__
      type==ORDER_TYPE_BUY_STOP_LIMIT  ?  "Buy Stop Limit"                                            :
      type==ORDER_TYPE_SELL_STOP_LIMIT ?  "Sell Stop Limit"                                           :
      type==ORDER_TYPE_CLOSE_BY        ?  TextByLanguage("Закрывающий ордер","Order for closing by")  :  
   #else 
      type==ORDER_TYPE_BALANCE         ?  TextByLanguage("Балансовая операция","Balance operation")   :
      type==ORDER_TYPE_CREDIT          ?  TextByLanguage("Кредитная операция","Credit operation")     :
   #endif 
      type==ORDER_TYPE_BUY             ?  pref+" Buy"                                                 :
      type==ORDER_TYPE_SELL            ?  pref+" Sell"                                                :  
      TextByLanguage("Неизвестный тип ордера","Unknown order type")
     );
  }
//+------------------------------------------------------------------+
//| Return the position name                                         |
//+------------------------------------------------------------------+
string PositionTypeDescription(const ENUM_POSITION_TYPE type)
  {
   return
     (
      type==POSITION_TYPE_BUY    ? "Buy"  :
      type==POSITION_TYPE_SELL   ? "Sell" :  
      TextByLanguage("Неизвестный тип позиции","Unknown position type")
     );
  }
//+------------------------------------------------------------------+
//| Return the deal name                                             |
//+------------------------------------------------------------------+
string DealTypeDescription(const ENUM_DEAL_TYPE type)
  {
   return
     (
      type==DEAL_TYPE_BUY                       ?  TextByLanguage("Сделка на покупку","Buy deal") :
      type==DEAL_TYPE_SELL                      ?  TextByLanguage("Сделка на продажу","Sell deal") :
      type==DEAL_TYPE_BALANCE                   ?  TextByLanguage("Балансовая операция","Balance operation") :
      type==DEAL_TYPE_CREDIT                    ?  TextByLanguage("Начисление кредита","Credit") :
      type==DEAL_TYPE_CHARGE                    ?  TextByLanguage("Дополнительные сборы","Additional charge") :
      type==DEAL_TYPE_CORRECTION                ?  TextByLanguage("Корректирующая запись","Correction") :
      type==DEAL_TYPE_BONUS                     ?  TextByLanguage("Перечисление бонусов","Bonus") :
      type==DEAL_TYPE_COMMISSION                ?  TextByLanguage("Дополнительные комиссии","Additional comissions") :
      type==DEAL_TYPE_COMMISSION_DAILY          ?  TextByLanguage("Комиссия, начисляемая в конце торгового дня","Daily commission") :
      type==DEAL_TYPE_COMMISSION_MONTHLY        ?  TextByLanguage("Комиссия, начисляемая в конце месяца","Monthly commission") :
      type==DEAL_TYPE_COMMISSION_AGENT_DAILY    ?  TextByLanguage("Агентская комиссия, начисляемая в конце торгового дня","Daily agent commission") :
      type==DEAL_TYPE_COMMISSION_AGENT_MONTHLY  ?  TextByLanguage("Агентская комиссия, начисляемая в конце месяца","Monthly agent commission") :
      type==DEAL_TYPE_INTEREST                  ?  TextByLanguage("Начисления процентов на свободные средства","Accrued interest on free funds") :
      type==DEAL_TYPE_BUY_CANCELED              ?  TextByLanguage("Отмененная сделка покупки","Canceled buy transaction") :
      type==DEAL_TYPE_SELL_CANCELED             ?  TextByLanguage("Отмененная сделка продажи","Canceled sell transaction") :
      type==DEAL_DIVIDEND                       ?  TextByLanguage("Начисление дивиденда","Dividend operations") :
      type==DEAL_DIVIDEND_FRANKED               ?  TextByLanguage("Начисление франкированного дивиденда","Franked (non-taxable) dividend operations") :
      type==DEAL_TAX                            ?  TextByLanguage("Начисление налога","Tax charges") : 
      TextByLanguage("Неизвестный тип сделки","Unknown deal type")
     );
  }
//+------------------------------------------------------------------+
//| Return position type by order type                               |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE PositionTypeByOrderType(ENUM_ORDER_TYPE type_order)
  {
   if(
      type_order==ORDER_TYPE_BUY             ||
      type_order==ORDER_TYPE_BUY_LIMIT       ||
      type_order==ORDER_TYPE_BUY_STOP
   #ifdef __MQL5__                           ||
      type_order==ORDER_TYPE_BUY_STOP_LIMIT
   #endif 
     ) return POSITION_TYPE_BUY;
   else if(
      type_order==ORDER_TYPE_SELL            ||
      type_order==ORDER_TYPE_SELL_LIMIT      ||
      type_order==ORDER_TYPE_SELL_STOP
   #ifdef __MQL5__                           ||
      type_order==ORDER_TYPE_SELL_STOP_LIMIT
   #endif 
     ) return POSITION_TYPE_SELL;
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Return week day names                                            |
//+------------------------------------------------------------------+
string DayOfWeekDescription(const ENUM_DAY_OF_WEEK day_of_week)
  {
   return
     (
      day_of_week==SUNDAY     ? TextByLanguage("Воскресение","Sunday")  :
      day_of_week==MONDAY     ? TextByLanguage("Понедельник","Monday")  :
      day_of_week==TUESDAY    ? TextByLanguage("Вторник","Tuesday")     :
      day_of_week==WEDNESDAY  ? TextByLanguage("Среда","Wednesday")     :
      day_of_week==THURSDAY   ? TextByLanguage("Четверг","Thursday")    :
      day_of_week==FRIDAY     ? TextByLanguage("Пятница","Friday") :
      day_of_week==SATURDAY   ? TextByLanguage("Суббота","Saturday")    :
      EnumToString(day_of_week)
     );
  }
//+------------------------------------------------------------------+
#ifdef __MQL4__
//+------------------------------------------------------------------+
//| Temporary MQL4 functions for the tester                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
bool Buy(const double volume,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   double price=0;
   ResetLastError();
   if(!SymbolInfoDouble(sym,SYMBOL_ASK,price))
     {
      Print(DFUN,TextByLanguage("Не удалось получить цену Ask. Ошибка ","Could not get Ask price. Error "),(string)GetLastError());
      return false;
     }
   if(OrderSend(sym,ORDER_TYPE_BUY,volume,price,deviation,sl,tp,comment,(int)magic,0,clrBlue)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось открыть позицию Buy. Ошибка ","Failed to open a Buy position. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Place a BuyLimit pending order                                   |
//+------------------------------------------------------------------+
bool BuyLimit(const double volume,const double price_set,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   ResetLastError();
   if(OrderSend(sym,ORDER_TYPE_BUY_LIMIT,volume,price_set,deviation,sl,tp,comment,(int)magic,0,clrBlue)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось установить ордер BuyLimit. Ошибка ","Could not place order BuyLimit. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Place a pending BuyStop order                                    |
//+------------------------------------------------------------------+
bool BuyStop(const double volume,const double price_set,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   ResetLastError();
   if(OrderSend(sym,ORDER_TYPE_BUY_STOP,volume,price_set,deviation,sl,tp,comment,(int)magic,0,clrBlue)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось установить ордер BuyStop. Ошибка ","Could not place order BuyStop. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
bool Sell(const double volume,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   double price=0;
   ResetLastError();
   if(!SymbolInfoDouble(sym,SYMBOL_BID,price))
     {
      Print(DFUN,TextByLanguage("Не удалось получить цену Bid. Ошибка ","Could not get Bid price. Error "),(string)GetLastError());
      return false;
     }
   if(OrderSend(sym,ORDER_TYPE_SELL,volume,price,deviation,sl,tp,comment,(int)magic,0,clrRed)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось открыть позицию Sell. Ошибка ","Failed to open a Sell position. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Place a pending SellLimit order                                  |
//+------------------------------------------------------------------+
bool SellLimit(const double volume,const double price_set,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   ResetLastError();
   if(OrderSend(sym,ORDER_TYPE_SELL_LIMIT,volume,price_set,deviation,sl,tp,comment,(int)magic,0,clrRed)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось установить ордер SellLimit. Ошибка ","Could not place order SellLimit. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Place a pending SellStop order                                   |
//+------------------------------------------------------------------+
bool SellStop(const double volume,const double price_set,const string symbol=NULL,const ulong magic=0,const double sl=0,const double tp=0,const string comment=NULL,const int deviation=2)
  {
   string sym=(symbol==NULL ? Symbol() : symbol);
   ResetLastError();
   if(OrderSend(sym,ORDER_TYPE_SELL_STOP,volume,price_set,deviation,sl,tp,comment,(int)magic,0,clrRed)==WRONG_VALUE)
     {
      Print(DFUN,TextByLanguage("Не удалось установить ордер SellStop. Ошибка ","Could not place order SellStop. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Close a position by ticket                                       |
//+------------------------------------------------------------------+
bool PositionClose(const ulong ticket,const double volume=0,const int deviation=2)
  {
   ResetLastError();
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать позицию. Ошибка ","Could not select position. Error "),(string)GetLastError());
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Позиция уже закрыта","Position already closed"));
      return false;
     }
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)OrderType();
   if(type>ORDER_TYPE_SELL)
     {
      Print(DFUN,TextByLanguage("Ошибка. Не позиция: ","Error. Not position: "),OrderTypeDescription(type)," #",ticket);
      return false;
     }
   double price=0;
   color  clr=clrNONE;
   if(type==ORDER_TYPE_BUY)
     {
      price=SymbolInfoDouble(OrderSymbol(),SYMBOL_BID);
      clr=clrBlue;
     }
   else
     {
      price=SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
      clr=clrRed;
     }
   double vol=(volume==0 || volume>OrderLots() ? OrderLots() : volume);
   ResetLastError();
   if(!OrderClose((int)ticket,vol,price,deviation,clr))
     {
      Print(DFUN,TextByLanguage("Не удалось закрыть позицию. Ошибка ","Could not close position. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Close a position by an opposite one                              |
//+------------------------------------------------------------------+
bool PositionCloseBy(const ulong ticket,const ulong ticket_by)
  {
   ResetLastError();
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать позицию. Ошибка ","Could not select position. Error "),(string)GetLastError());
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Позиция уже закрыта","Position already closed"));
      return false;
     }
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)OrderType();
   if(type>ORDER_TYPE_SELL)
     {
      Print(DFUN,TextByLanguage("Ошибка. Не позиция: ","Error. Not position: "),OrderTypeDescription(type)," #",ticket);
      return false;
     }
   ResetLastError();
   if(!OrderSelect((int)ticket_by,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать встречную позицию. Ошибка ","Could not select the opposite position. Error "),(string)GetLastError());
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Встречная позиция уже закрыта","Opposite position already closed"));
      return false;
     }
   ENUM_ORDER_TYPE type_by=(ENUM_ORDER_TYPE)OrderType();
   if(type_by>ORDER_TYPE_SELL)
     {
      Print(DFUN,TextByLanguage("Ошибка. Встречная позиция не является позицией: ","Error. Opposite position is not a position: "),OrderTypeDescription(type_by)," #",ticket_by);
      return false;
     }
   color clr=(type==ORDER_TYPE_BUY ? clrBlue : clrRed);
   ResetLastError();
   if(!OrderCloseBy((int)ticket,(int)ticket_by,clr))
     {
      Print(DFUN,TextByLanguage("Не удалось закрыть позицию встречной. Ошибка ","Could not close position by opposite position. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Remove a pending order by ticket                                 |
//+------------------------------------------------------------------+
bool PendingOrderDelete(const ulong ticket)
  {
   ResetLastError();
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать ордер. Ошибка ","Could not select order. Error "),(string)GetLastError());
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Ордер уже удалён","Order already deleted"));
      return false;
     }
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)OrderType();
   if(type<ORDER_TYPE_SELL || type>ORDER_TYPE_SELL_STOP)
     {
      Print(DFUN,TextByLanguage("Ошибка. Не ордер: ","Error. Not order: "),PositionTypeDescription((ENUM_POSITION_TYPE)type)," #",ticket);
      return false;
     }
   color clr=(type<ORDER_TYPE_SELL_LIMIT ? clrBlue : clrRed);
   ResetLastError();
   if(!OrderDelete((int)ticket,clr))
     {
      Print(DFUN,TextByLanguage("Не удалось удалить ордер. Ошибка ","Could not delete order. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Modify a position by ticket                                      |
//+------------------------------------------------------------------+
bool PositionModify(const ulong ticket,const double sl,const double tp)
  {
   ResetLastError();
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать позицию. Ошибка ","Could not select position. Error "),(string)GetLastError());
      return false;
     }
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)OrderType();
   if(type>ORDER_TYPE_SELL)
     {
      Print(DFUN,TextByLanguage("Ошибка. Не позиция: ","Error. Not position: "),OrderTypeDescription(type)," #",ticket);
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Ошибка. Для модификации выбрана закрытая позиция: ","Error. Closed position selected for modification: "),PositionTypeDescription((ENUM_POSITION_TYPE)type)," #",ticket);
      return false;
     }
   color clr=(type==ORDER_TYPE_BUY ? clrBlue : clrRed);
   ResetLastError();
   if(!OrderModify((int)ticket,OrderOpenPrice(),sl,tp,0,clr))
     {
      Print(DFUN,TextByLanguage("Не удалось модифицировать позицию. Ошибка ","Failed to modify position. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Modify a pending order by ticket                                 |
//+------------------------------------------------------------------+
bool PendingOrderModify(const ulong ticket,const double price_set,const double sl,const double tp)
  {
   ResetLastError();
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      Print(DFUN,TextByLanguage("Не удалось выбрать ордер. Ошибка ","Could not select order. Error "),(string)GetLastError());
      return false;
     }
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)OrderType();
   if(type<ORDER_TYPE_BUY_LIMIT || type>ORDER_TYPE_SELL_STOP)
     {
      Print(DFUN,TextByLanguage("Ошибка. Не ордер: ","Error. Not order: "),PositionTypeDescription((ENUM_POSITION_TYPE)type)," #",ticket);
      return false;
     }
   if(OrderCloseTime()>0)
     {
      Print(DFUN,TextByLanguage("Ошибка. Для модификации выбран удалённый ордер: ","Error. Deleted order selected for modification: "),OrderTypeDescription(type)," #",ticket);
      return false;
     }
   color clr=(TypeByPendingDirection(type)==ORDER_TYPE_BUY ? clrBlue : clrRed);
   ResetLastError();
   if(!OrderModify((int)ticket,price_set,sl,tp,0,clr))
     {
      Print(DFUN,TextByLanguage("Не удалось модифицировать ордер. Ошибка ","Failed to order modify. Error "),(string)GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Return a type by a pending order direction                       |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE TypeByPendingDirection(const ENUM_ORDER_TYPE type)
  {
   if(type==ORDER_TYPE_BUY_LIMIT  || type==ORDER_TYPE_BUY_STOP)  return ORDER_TYPE_BUY;
   if(type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP) return ORDER_TYPE_SELL;
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
#endif 
