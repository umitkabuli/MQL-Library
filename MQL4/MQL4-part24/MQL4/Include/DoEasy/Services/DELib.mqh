//+------------------------------------------------------------------+
//|                                                        DELib.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property strict  // Necessary for mql4
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\Defines.mqh"
#include "Message.mqh"
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
            DFUN_ERR_LINE+CMessage::Text(MSG_LIB_SYS_ERROR_EMPTY_STRING)+Symbol() :
            DFUN_ERR_LINE+CMessage::Text(MSG_LIB_SYS_FAILED_PREPARING_SYMBOLS_ARRAY)+(string)GetLastError()
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
//+-------------------------------------------------------------------------------+
//| Search for a symbol and return the flag indicating its presence on the server |
//+-------------------------------------------------------------------------------+
bool Exist(const string name)
  {
   int total=SymbolsTotal(false);
   for(int i=0;i<total;i++)
      if(SymbolName(i,false)==name)
         return true;
   return false;
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
      default                          :  Print(DFUN,CMessage::Text(MSG_LIB_SYS_INVALID_ORDER_TYPE),EnumToString(order_type)); return 0;
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
      default                          :  Print(DFUN,CMessage::Text(MSG_LIB_SYS_INVALID_ORDER_TYPE),EnumToString(order_type)); return 0;
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
string OrderTypeDescription(const ENUM_ORDER_TYPE type,bool as_order=true,bool need_prefix=true)
  {
   string pref=
     (
      !need_prefix ? "" :
      #ifdef __MQL5__ CMessage::Text(MSG_ORD_MARKET) 
      #else/*__MQL4__*/(as_order ? CMessage::Text(MSG_ORD_MARKET) : CMessage::Text(MSG_ORD_POSITION)) #endif 
     );
   return
     (
      type==ORDER_TYPE_BUY_LIMIT       ?  CMessage::Text(MSG_ORD_PENDING)+" Buy Limit"       :
      type==ORDER_TYPE_BUY_STOP        ?  CMessage::Text(MSG_ORD_PENDING)+" Buy Stop"        :
      type==ORDER_TYPE_SELL_LIMIT      ?  CMessage::Text(MSG_ORD_PENDING)+" Sell Limit"      :
      type==ORDER_TYPE_SELL_STOP       ?  CMessage::Text(MSG_ORD_PENDING)+" Sell Stop"       :
   #ifdef __MQL5__
      type==ORDER_TYPE_BUY_STOP_LIMIT  ?  CMessage::Text(MSG_ORD_PENDING)+" Buy Stop Limit"  :
      type==ORDER_TYPE_SELL_STOP_LIMIT ?  CMessage::Text(MSG_ORD_PENDING)+" Sell Stop Limit" :
      type==ORDER_TYPE_CLOSE_BY        ?  CMessage::Text(MSG_ORD_CLOSE_BY)                   :  
   #else 
      type==ORDER_TYPE_BALANCE         ?  CMessage::Text(MSG_LIB_PROP_BALANCE)               :
      type==ORDER_TYPE_CREDIT          ?  CMessage::Text(MSG_LIB_PROP_CREDIT)                :
   #endif 
      type==ORDER_TYPE_BUY             ?  pref+" Buy"                                        :
      type==ORDER_TYPE_SELL            ?  pref+" Sell"                                       :  
      CMessage::Text(MSG_ORD_UNKNOWN_TYPE)
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
      CMessage::Text(MSG_POS_UNKNOWN_TYPE)
     );
  }
//+------------------------------------------------------------------+
//| Return the deal name                                             |
//+------------------------------------------------------------------+
string DealTypeDescription(const ENUM_DEAL_TYPE type)
  {
   return
     (
      type==DEAL_TYPE_BUY                       ?  CMessage::Text(MSG_DEAL_TO_BUY)                          :
      type==DEAL_TYPE_SELL                      ?  CMessage::Text(MSG_DEAL_TO_SELL)                         :
      type==DEAL_TYPE_BALANCE                   ?  CMessage::Text(MSG_LIB_PROP_BALANCE)                     :
      type==DEAL_TYPE_CREDIT                    ?  CMessage::Text(MSG_EVN_ACCOUNT_CREDIT)                   :
      type==DEAL_TYPE_CHARGE                    ?  CMessage::Text(MSG_EVN_ACCOUNT_CHARGE)                   :
      type==DEAL_TYPE_CORRECTION                ?  CMessage::Text(MSG_EVN_ACCOUNT_CORRECTION)               :
      type==DEAL_TYPE_BONUS                     ?  CMessage::Text(MSG_EVN_ACCOUNT_BONUS)                    :
      type==DEAL_TYPE_COMMISSION                ?  CMessage::Text(MSG_EVN_ACCOUNT_COMISSION)                :
      type==DEAL_TYPE_COMMISSION_DAILY          ?  CMessage::Text(MSG_EVN_ACCOUNT_COMISSION_DAILY)          :
      type==DEAL_TYPE_COMMISSION_MONTHLY        ?  CMessage::Text(MSG_EVN_ACCOUNT_COMISSION_MONTHLY)        :
      type==DEAL_TYPE_COMMISSION_AGENT_DAILY    ?  CMessage::Text(MSG_EVN_ACCOUNT_COMISSION_AGENT_DAILY)    :
      type==DEAL_TYPE_COMMISSION_AGENT_MONTHLY  ?  CMessage::Text(MSG_EVN_ACCOUNT_COMISSION_AGENT_MONTHLY)  :
      type==DEAL_TYPE_INTEREST                  ?  CMessage::Text(MSG_EVN_ACCOUNT_INTEREST)                 :
      type==DEAL_TYPE_BUY_CANCELED              ?  CMessage::Text(MSG_EVN_BUY_CANCELLED)                    :
      type==DEAL_TYPE_SELL_CANCELED             ?  CMessage::Text(MSG_EVN_SELL_CANCELLED)                   :
      type==DEAL_DIVIDEND                       ?  CMessage::Text(MSG_EVN_DIVIDENT)                         :
      type==DEAL_DIVIDEND_FRANKED               ?  CMessage::Text(MSG_EVN_DIVIDENT_FRANKED)                 :
      type==DEAL_TAX                            ?  CMessage::Text(MSG_EVN_TAX)                              : 
      CMessage::Text(MSG_POS_UNKNOWN_DEAL)
     );
  }
//+------------------------------------------------------------------+
//| Return position type by order type                               |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE PositionTypeByOrderType(ENUM_ORDER_TYPE type_order)
  {
   if(type_order==ORDER_TYPE_CLOSE_BY)
      return WRONG_VALUE;
   return ENUM_POSITION_TYPE(type_order%2);
  }
//+------------------------------------------------------------------+
//| Return an order type by a position type                          |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE OrderTypeByPositionType(ENUM_POSITION_TYPE type_position)
  {
   return (ENUM_ORDER_TYPE)type_position;
  }
//+------------------------------------------------------------------+
//| Return a reverse order type by a position type                   |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE OrderTypeOppositeByPositionType(ENUM_POSITION_TYPE type_position)
  {
   return(type_position==POSITION_TYPE_BUY ? ORDER_TYPE_SELL :  ORDER_TYPE_BUY);
  }
//+------------------------------------------------------------------+
//| Return week day names                                            |
//+------------------------------------------------------------------+
string DayOfWeekDescription(const ENUM_DAY_OF_WEEK day_of_week)
  {
   return
     (
      day_of_week==SUNDAY     ? CMessage::Text(MSG_LIB_TEXT_SUNDAY)     :
      day_of_week==MONDAY     ? CMessage::Text(MSG_LIB_TEXT_MONDAY)     :
      day_of_week==TUESDAY    ? CMessage::Text(MSG_LIB_TEXT_TUESDAY)    :
      day_of_week==WEDNESDAY  ? CMessage::Text(MSG_LIB_TEXT_WEDNESDAY)  :
      day_of_week==THURSDAY   ? CMessage::Text(MSG_LIB_TEXT_THURSDAY)   :
      day_of_week==FRIDAY     ? CMessage::Text(MSG_LIB_TEXT_FRIDAY)     :
      day_of_week==SATURDAY   ? CMessage::Text(MSG_LIB_TEXT_SATURDAY)   :
      EnumToString(day_of_week)
     );
  }
//+------------------------------------------------------------------+
