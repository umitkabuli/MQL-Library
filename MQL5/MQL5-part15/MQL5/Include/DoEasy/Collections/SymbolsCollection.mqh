//+------------------------------------------------------------------+
//|                                            SymbolsCollection.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "ListObj.mqh"
#include "..\Services\Select.mqh"
#include "..\Objects\Symbols\Symbol.mqh"
#include "..\Objects\Symbols\SymbolFX.mqh"
#include "..\Objects\Symbols\SymbolFXMajor.mqh"
#include "..\Objects\Symbols\SymbolFXMinor.mqh"
#include "..\Objects\Symbols\SymbolFXExotic.mqh"
#include "..\Objects\Symbols\SymbolFXRub.mqh"
#include "..\Objects\Symbols\SymbolMetall.mqh"
#include "..\Objects\Symbols\SymbolIndex.mqh"
#include "..\Objects\Symbols\SymbolIndicative.mqh"
#include "..\Objects\Symbols\SymbolCrypto.mqh"
#include "..\Objects\Symbols\SymbolCommodity.mqh"
#include "..\Objects\Symbols\SymbolExchange.mqh"
#include "..\Objects\Symbols\SymbolFutures.mqh"
#include "..\Objects\Symbols\SymbolCFD.mqh"
#include "..\Objects\Symbols\SymbolStocks.mqh"
#include "..\Objects\Symbols\SymbolBonds.mqh"
#include "..\Objects\Symbols\SymbolOption.mqh"
#include "..\Objects\Symbols\SymbolCollateral.mqh"
#include "..\Objects\Symbols\SymbolCustom.mqh"
#include "..\Objects\Symbols\SymbolCommon.mqh"
//+------------------------------------------------------------------+
//| Collection of historical orders and deals                        |
//+------------------------------------------------------------------+
class CSymbolsCollection : public CObject
  {
private:
   CListObj          m_list_all_symbols;     // The list of all symbol objects
   ENUM_SYMBOLS_MODE m_mode_list;            // Mode of working with symbol lists
   int               m_delta_symbol;         // Difference in the number of symbols compared to the previous check
   int               m_last_num_symbol;      // Number of symbols in the Market Watch window during the previous check
   int               m_global_error;         // Global error code
//--- Return the flag of a symbol object presence by its name in the list of all symbols
   bool              IsPresentSymbolInList(const string symbol_name);
//--- Create the symbol object and place it to the list
   bool              CreateNewSymbol(const ENUM_SYMBOL_STATUS symbol_status,const string name);
//--- Return the type of a used symbol list (Market watch/Server)
   ENUM_SYMBOLS_MODE TypeSymbolsList(const string &symbol_used_array[]);

//--- Define a symbol affiliation with a group by name and return it
   ENUM_SYMBOL_STATUS SymbolStatus(const string symbol_name)      const;
//--- Return a symbol affiliation with a category by custom criteria
   ENUM_SYMBOL_STATUS StatusByCustomPredefined(const string symbol_name)  const;
//--- Return a symbol affiliation with categories by margin calculation
   ENUM_SYMBOL_STATUS StatusByCalcMode(const string symbol_name)  const;
//--- Return a symbol affiliation with pre-defined (1) majors, (2) minors, (3) exotics, (4) RUB,
//--- (5) indicatives, (6) metals, (7) commodities, (8) indices, (9) cryptocurrency, (10) options
   bool              IsPredefinedFXMajor(const string name)       const;
   bool              IsPredefinedFXMinor(const string name)       const;
   bool              IsPredefinedFXExotic(const string name)      const;
   bool              IsPredefinedFXRUB(const string name)         const;
   bool              IsPredefinedIndicative(const string name)    const;
   bool              IsPredefinedMetall(const string name)        const;
   bool              IsPredefinedCommodity(const string name)     const;
   bool              IsPredefinedIndex(const string name)         const;
   bool              IsPredefinedCrypto(const string name)        const;
   bool              IsPredefinedOption(const string name)        const;

//--- Search for a symbol and return the flag indicating its presence on the server
   bool              Exist(const string name)                     const;
   
public:
//--- Return the full collection list 'as is'
   CArrayObj        *GetList(void)                                                                          { return &this.m_list_all_symbols;                                      }
//--- Return the list by selected (1) integer, (2) real and (3) string properties meeting the compared criterion
   CArrayObj        *GetList(ENUM_SYMBOL_PROP_INTEGER property,long value,ENUM_COMPARER_TYPE mode=EQUAL)    { return CSelect::BySymbolProperty(this.GetList(),property,value,mode); }
   CArrayObj        *GetList(ENUM_SYMBOL_PROP_DOUBLE property,double value,ENUM_COMPARER_TYPE mode=EQUAL)   { return CSelect::BySymbolProperty(this.GetList(),property,value,mode); }
   CArrayObj        *GetList(ENUM_SYMBOL_PROP_STRING property,string value,ENUM_COMPARER_TYPE mode=EQUAL)   { return CSelect::BySymbolProperty(this.GetList(),property,value,mode); }
//--- Return the number of new symbols in the Market Watch window
   int               NewSymbols(void)    const                                                              { return this.m_delta_symbol;                                           }
//--- Return the mode of working with symbol lists
   ENUM_SYMBOLS_MODE ModeSymbolsList(void)                        const                                     { return this.m_mode_list;                                              }
//--- Constructor
                     CSymbolsCollection();
   
//--- Set the list of used symbols
   bool              SetUsedSymbol(const string &symbol_used_array[]);
//--- Update (1) all, (2) quote data of the collection symbols
   void              Refresh(void);
   void              RefreshRates(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSymbolsCollection::CSymbolsCollection(void) : m_last_num_symbol(0),m_delta_symbol(0),m_mode_list(SYMBOLS_MODE_CURRENT)
  {
   this.m_list_all_symbols.Sort(SORT_BY_SYMBOL_NAME);
   this.m_list_all_symbols.Clear();
   this.m_list_all_symbols.Type(COLLECTION_SYMBOLS_ID);
  }
//+------------------------------------------------------------------+
//| Update all collection symbol data                                |
//+------------------------------------------------------------------+
void CSymbolsCollection::Refresh(void)
  {
   int total=this.m_list_all_symbols.Total();
   if(total==0)
      return;
   for(int i=0;i<total;i++)
     {
      CSymbol *symbol=this.m_list_all_symbols.At(i);
      if(symbol==NULL)
         continue;
      symbol.Refresh();
     }
  }
//+------------------------------------------------------------------+
//| Update quote data of the collection symbols                      |
//+------------------------------------------------------------------+
void CSymbolsCollection::RefreshRates(void)
  {
   int total=this.m_list_all_symbols.Total();
   if(total==0)
      return;
   for(int i=0;i<total;i++)
     {
      CSymbol *symbol=this.m_list_all_symbols.At(i);
      if(symbol==NULL)
         continue;
      symbol.RefreshRates();
     }
  }
//+------------------------------------------------------------------+
//| Create a symbol object and place it to the list                  |
//+------------------------------------------------------------------+
bool CSymbolsCollection::CreateNewSymbol(const ENUM_SYMBOL_STATUS symbol_status,const string name)
  {
   if(this.IsPresentSymbolInList(name))
     {
      return true;
     }
   if(#ifdef __MQL5__ !::SymbolInfoInteger(name,SYMBOL_EXIST) #else !this.Exist(name) #endif )
     {
      string t1=TextByLanguage("Ошибка входных данных: нет символа ","Input error: no ");
      string t2=TextByLanguage(" на сервере"," symbol on the server");
      ::Print(DFUN,t1,name,t2);
      this.m_global_error=ERR_MARKET_UNKNOWN_SYMBOL;
      return false;
     }
   CSymbol *symbol=NULL;
   switch(symbol_status)
     {
      case SYMBOL_STATUS_FX         :  symbol=new CSymbolFX(name);         break;   // Forex symbol
      case SYMBOL_STATUS_FX_MAJOR   :  symbol=new CSymbolFXMajor(name);    break;   // Major Forex symbol
      case SYMBOL_STATUS_FX_MINOR   :  symbol=new CSymbolFXMinor(name);    break;   // Minor Forex symbol
      case SYMBOL_STATUS_FX_EXOTIC  :  symbol=new CSymbolFXExotic(name);   break;   // Exotic Forex symbol
      case SYMBOL_STATUS_FX_RUB     :  symbol=new CSymbolFXRub(name);      break;   // Forex symbol/RUR
      case SYMBOL_STATUS_METAL      :  symbol=new CSymbolMetall(name);     break;   // Metal
      case SYMBOL_STATUS_INDEX      :  symbol=new CSymbolIndex(name);      break;   // Index
      case SYMBOL_STATUS_INDICATIVE :  symbol=new CSymbolIndicative(name); break;   // Indicative
      case SYMBOL_STATUS_CRYPTO     :  symbol=new CSymbolCrypto(name);     break;   // Cryptocurrency symbol
      case SYMBOL_STATUS_COMMODITY  :  symbol=new CSymbolCommodity(name);  break;   // Commodity
      case SYMBOL_STATUS_EXCHANGE   :  symbol=new CSymbolExchange(name);   break;   // Exchange symbol
      case SYMBOL_STATUS_FUTURES    :  symbol=new CSymbolFutures(name);    break;   // Futures
      case SYMBOL_STATUS_CFD        :  symbol=new CSymbolCFD(name);        break;   // CFD
      case SYMBOL_STATUS_STOCKS     :  symbol=new CSymbolStocks(name);     break;   // Stock
      case SYMBOL_STATUS_BONDS      :  symbol=new CSymbolBonds(name);      break;   // Bond
      case SYMBOL_STATUS_OPTION     :  symbol=new CSymbolOption(name);     break;   // Option
      case SYMBOL_STATUS_COLLATERAL :  symbol=new CSymbolCollateral(name); break;   // Non-tradable asset
      case SYMBOL_STATUS_CUSTOM     :  symbol=new CSymbolCustom(name);     break;   // Custom symbol
      default                       :  symbol=new CSymbolCommon(name);     break;   // The rest
     }
   if(symbol==NULL)
     {
      ::Print(DFUN,TextByLanguage("Не удалось создать объект-символ ","Failed to create symbol object "),name);
      return false;
     }
   if(!this.m_list_all_symbols.Add(symbol))
     {
      string t1=TextByLanguage("Не удалось добавить символ ","Failed to add ");
      string t2=TextByLanguage(" в список"," symbol to the list");
      ::Print(DFUN,t1,name,t2);
      delete symbol;
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Return the symbol object presence flag                           |
//| by its name in the list of all symbols                           |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPresentSymbolInList(const string symbol_name)
  {
   CArrayObj *list=dynamic_cast<CListObj*>(&this.m_list_all_symbols);
   list.Sort(SORT_BY_SYMBOL_NAME);
   list=CSelect::BySymbolProperty(list,SYMBOL_PROP_NAME,symbol_name,EQUAL);
   return(list==NULL || list.Total()==0 ? false : true);
  }
//+------------------------------------------------------------------+
//| Set the list of used symbols                                     |
//+------------------------------------------------------------------+
bool CSymbolsCollection::SetUsedSymbol(const string &symbol_used_array[])
  {
   this.m_mode_list=this.TypeSymbolsList(symbol_used_array);
   this.m_list_all_symbols.Clear();
   this.m_list_all_symbols.Sort(SORT_BY_SYMBOL_NAME);
   //--- Use only the current symbol
   if(this.m_mode_list==SYMBOLS_MODE_CURRENT)
     {
      string name=::Symbol();
      ENUM_SYMBOL_STATUS status=this.SymbolStatus(name);
      return this.CreateNewSymbol(status,name);
     }
   else
     {
      bool res=true;
      //--- Use the pre-defined symbol list
      if(this.m_mode_list==SYMBOLS_MODE_DEFINES)
        {
         int total=::ArraySize(symbol_used_array);
         for(int i=0;i<total;i++)
           {
            string name=symbol_used_array[i];
            ENUM_SYMBOL_STATUS status=this.SymbolStatus(name);
            bool add=this.CreateNewSymbol(status,name);
            res &=add;
            if(!add) 
               continue;
           }
         return res;
        }
      //--- Use the full list of the server symbols
      else if(this.m_mode_list==SYMBOLS_MODE_ALL)
        {
         int total=::SymbolsTotal(false);
         for(int i=0;i<total;i++)
           {
            string name=::SymbolName(i,false);
            ENUM_SYMBOL_STATUS status=this.SymbolStatus(name);
            bool add=this.CreateNewSymbol(status,name);
            res &=add;
            if(!add) 
               continue;
           }
         return res;
        }
      //--- Use the symbol list from the Market Watch window
      else if(this.m_mode_list==SYMBOLS_MODE_MARKET_WATCH)
        {
         int total=::SymbolsTotal(true);
         for(int i=0;i<total;i++)
           {
            string name=::SymbolName(i,true);
            ENUM_SYMBOL_STATUS status=this.SymbolStatus(name);
            bool add=this.CreateNewSymbol(status,name);
            res &=add;
            if(!add) 
               continue;
           }
         return res;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|Return the type of a used symbol list (Market watch/Server)       |
//+------------------------------------------------------------------+
ENUM_SYMBOLS_MODE CSymbolsCollection::TypeSymbolsList(const string &symbol_used_array[])
  {
   int total=::ArraySize(symbol_used_array);
   if(total<1)
      return SYMBOLS_MODE_CURRENT;
   string type=::StringSubstr(symbol_used_array[0],13);
   return
     (
      type=="MARKET_WATCH" ? SYMBOLS_MODE_MARKET_WATCH   :
      type=="ALL"          ? SYMBOLS_MODE_ALL            :
      (total==1 && symbol_used_array[0]==::Symbol() ? SYMBOLS_MODE_CURRENT : SYMBOLS_MODE_DEFINES)
     );
  }
//+------------------------------------------------------------------+
//| Define a symbol affiliation with a group by name and return it   |
//+------------------------------------------------------------------+
ENUM_SYMBOL_STATUS CSymbolsCollection::SymbolStatus(const string symbol_name) const
  {
   ENUM_SYMBOL_STATUS status=this.StatusByCustomPredefined(symbol_name);
   return(status==SYMBOL_STATUS_COMMON ? this.StatusByCalcMode(symbol_name) : status);
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with majors                          |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedFXMajor(const string name) const
  {
   int total=::ArraySize(DataSymbolsFXMajors);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsFXMajors[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with minors                          |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedFXMinor(const string name) const
  {
   int total=::ArraySize(DataSymbolsFXMinors);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsFXMinors[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with exotic symbols                  |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedFXExotic(const string name) const
  {
   int total=::ArraySize(DataSymbolsFXExotics);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsFXExotics[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with RUB symbols                     |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedFXRUB(const string name) const
  {
   int total=::ArraySize(DataSymbolsFXRub);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsFXRub[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with indicative symbols              |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedIndicative(const string name) const
  {
   int total=::ArraySize(DataSymbolsFXIndicatives);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsFXIndicatives[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with metals                          |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedMetall(const string name) const
  {
   int total=::ArraySize(DataSymbolsMetalls);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsMetalls[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with commodities                     |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedCommodity(const string name) const
  {
   int total=::ArraySize(DataSymbolsCommodities);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsCommodities[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with indices                         |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedIndex(const string name) const
  {
   int total=::ArraySize(DataSymbolsIndexes);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsIndexes[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with a cryptocurrency                |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedCrypto(const string name) const
  {
   int total=::ArraySize(DataSymbolsCrypto);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsCrypto[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a symbol affiliation with options                         |
//+------------------------------------------------------------------+
bool CSymbolsCollection::IsPredefinedOption(const string name) const
  {
   int total=::ArraySize(DataSymbolsOptions);
   for(int i=0;i<total;i++)
      if(name==DataSymbolsOptions[i])
         return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Return a category by custom criteria                             |
//+------------------------------------------------------------------+
ENUM_SYMBOL_STATUS CSymbolsCollection::StatusByCustomPredefined(const string symbol_name) const
  {
   return
     (
      this.IsPredefinedFXMajor(symbol_name)     ?  SYMBOL_STATUS_FX_MAJOR     :
      this.IsPredefinedFXMinor(symbol_name)     ?  SYMBOL_STATUS_FX_MINOR     :
      this.IsPredefinedFXExotic(symbol_name)    ?  SYMBOL_STATUS_FX_EXOTIC    :
      this.IsPredefinedFXRUB(symbol_name)       ?  SYMBOL_STATUS_FX_RUB       :
      this.IsPredefinedOption(symbol_name)      ?  SYMBOL_STATUS_OPTION       :
      this.IsPredefinedCommodity(symbol_name)   ?  SYMBOL_STATUS_COMMODITY    :
      this.IsPredefinedCrypto(symbol_name)      ?  SYMBOL_STATUS_CRYPTO       :
      this.IsPredefinedMetall(symbol_name)      ?  SYMBOL_STATUS_METAL        :
      this.IsPredefinedIndex(symbol_name)       ?  SYMBOL_STATUS_INDEX        :
      this.IsPredefinedIndicative(symbol_name)  ?  SYMBOL_STATUS_INDICATIVE   :
      SYMBOL_STATUS_COMMON
     );
  }  
//+------------------------------------------------------------------+
//|Return affiliation with a margin calculation category             |
//+------------------------------------------------------------------+
ENUM_SYMBOL_STATUS CSymbolsCollection::StatusByCalcMode(const string symbol_name) const
  {
   ENUM_SYMBOL_CALC_MODE calc_mode=(ENUM_SYMBOL_CALC_MODE)::SymbolInfoInteger(symbol_name,SYMBOL_TRADE_CALC_MODE);
   return
     (
      calc_mode==SYMBOL_CALC_MODE_EXCH_OPTIONS_MARGIN                                                                               ?  SYMBOL_STATUS_OPTION       :
      calc_mode==SYMBOL_CALC_MODE_SERV_COLLATERAL                                                                                   ?  SYMBOL_STATUS_COLLATERAL   :
      calc_mode==SYMBOL_CALC_MODE_FUTURES                                                                                           ?  SYMBOL_STATUS_FUTURES      :
      calc_mode==SYMBOL_CALC_MODE_CFD           || calc_mode==SYMBOL_CALC_MODE_CFDINDEX || calc_mode==SYMBOL_CALC_MODE_CFDLEVERAGE  ?  SYMBOL_STATUS_CFD          :
      calc_mode==SYMBOL_CALC_MODE_FOREX         || calc_mode==SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE                                    ?  SYMBOL_STATUS_FX           :
      calc_mode==SYMBOL_CALC_MODE_EXCH_STOCKS   || calc_mode==SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX                                     ?  SYMBOL_STATUS_STOCKS       :
      calc_mode==SYMBOL_CALC_MODE_EXCH_BONDS    || calc_mode==SYMBOL_CALC_MODE_EXCH_BONDS_MOEX                                      ?  SYMBOL_STATUS_BONDS        :
      calc_mode==SYMBOL_CALC_MODE_EXCH_FUTURES  || calc_mode==SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS                                   ?  SYMBOL_STATUS_FUTURES      :
      SYMBOL_STATUS_COMMON
     );
  }
//+-------------------------------------------------------------------------------+
//| Search for a symbol and return the flag indicating its presence on the server |
//+-------------------------------------------------------------------------------+
bool CSymbolsCollection::Exist(const string name) const
  {
   int total=::SymbolsTotal(false);
   for(int i=0;i<total;i++)
      if(::SymbolName(i,false)==name)
         return true;
   return false;
  }
//+------------------------------------------------------------------+
