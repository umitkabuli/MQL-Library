//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "..\..\Services\DELib.mqh"
//+------------------------------------------------------------------+
//| Account class                                                    |
//+------------------------------------------------------------------+
class CAccount : public CObject
  {
private:
   struct SData
     {
      //--- Account integer properties
      long           login;                        // ACCOUNT_LOGIN (Account number)
      int            trade_mode;                   // ACCOUNT_TRADE_MODE (Trading account type)
      long           leverage;                     // ACCOUNT_LEVERAGE (Leverage)
      int            limit_orders;                 // ACCOUNT_LIMIT_ORDERS (Maximum allowed number of active pending orders)
      int            margin_so_mode;               // ACCOUNT_MARGIN_SO_MODE (Mode of setting the minimum available margin level)
      bool           trade_allowed;                // ACCOUNT_TRADE_ALLOWED (Permission to trade for the current account from the server side)
      bool           trade_expert;                 // ACCOUNT_TRADE_EXPERT (Permission to trade for an EA from the server side)
      int            margin_mode;                  // ACCOUNT_MARGIN_MODE (Margin calculation mode)
      int            currency_digits;              // ACCOUNT_CURRENCY_DIGITS (Number of decimal places for the account currency)
      int            server_type;                  // Trade server type (MetaTrader 5, MetaTrader 4)
      //--- Account real properties
      double         balance;                      // ACCOUNT_BALANCE (Account balance in a deposit currency)
      double         credit;                       // ACCOUNT_CREDIT (Credit in a deposit currency)
      double         profit;                       // ACCOUNT_PROFIT (Current profit on an account in the account currency)
      double         equity;                       // ACCOUNT_EQUITY (Equity on an account in the deposit currency)
      double         margin;                       // ACCOUNT_MARGIN (Reserved margin on an account in a deposit currency)
      double         margin_free;                  // ACCOUNT_MARGIN_FREE (Free funds available for opening a position in a deposit currency)
      double         margin_level;                 // ACCOUNT_MARGIN_LEVEL (Margin level on an account in %)
      double         margin_so_call;               // ACCOUNT_MARGIN_SO_CALL (MarginCall)
      double         margin_so_so;                 // ACCOUNT_MARGIN_SO_SO (StopOut)
      double         margin_initial;               // ACCOUNT_MARGIN_INITIAL (Funds reserved on an account to ensure a guarantee amount for all pending orders)
      double         margin_maintenance;           // ACCOUNT_MARGIN_MAINTENANCE (Funds reserved on an account to ensure a minimum amount for all open positions)
      double         assets;                       // ACCOUNT_ASSETS (Current assets on an account)
      double         liabilities;                  // ACCOUNT_LIABILITIES (Current liabilities on an account)
      double         comission_blocked;            // ACCOUNT_COMMISSION_BLOCKED (Current sum of blocked commissions on an account)
      //--- Account string properties
      uchar          name[128];                    // ACCOUNT_NAME (Client name)
      uchar          server[64];                   // ACCOUNT_SERVER (Trade server name)
      uchar          currency[32];                 // ACCOUNT_CURRENCY (Deposit currency)
      uchar          company[128];                 // ACCOUNT_COMPANY (Name of a company serving an account)
     };
   SData             m_struct_obj;                                      // Account object structure
   uchar             m_uchar_array[];                                   // uchar array of the account object structure
   
//--- Object properties
   long              m_long_prop[ACCOUNT_PROP_INTEGER_TOTAL];           // Integer properties
   double            m_double_prop[ACCOUNT_PROP_DOUBLE_TOTAL];          // Real properties
   string            m_string_prop[ACCOUNT_PROP_STRING_TOTAL];          // String properties

//--- Return the index of the array the account's (1) double and (2) string properties are located at
   int               IndexProp(ENUM_ACCOUNT_PROP_DOUBLE property) const { return(int)property-ACCOUNT_PROP_INTEGER_TOTAL;                                   }
   int               IndexProp(ENUM_ACCOUNT_PROP_STRING property) const { return(int)property-ACCOUNT_PROP_INTEGER_TOTAL-ACCOUNT_PROP_DOUBLE_TOTAL;         }
protected:
//--- Create (1) the account object structure and (2) the account object from the structure
   bool              ObjectToStruct(void);
   void              StructToObject(void);
public:
//--- Constructor
                     CAccount(void);
//--- Set account's (1) integer, (2) real and (3) string properties
   void              SetProperty(ENUM_ACCOUNT_PROP_INTEGER property,long value)        { this.m_long_prop[property]=value;                                  }
   void              SetProperty(ENUM_ACCOUNT_PROP_DOUBLE property,double value)       { this.m_double_prop[this.IndexProp(property)]=value;                }
   void              SetProperty(ENUM_ACCOUNT_PROP_STRING property,string value)       { this.m_string_prop[this.IndexProp(property)]=value;                }
//--- Return (1) integer, (2) real and (3) string order properties from the account string property
   long              GetProperty(ENUM_ACCOUNT_PROP_INTEGER property)             const { return this.m_long_prop[property];                                 }
   double            GetProperty(ENUM_ACCOUNT_PROP_DOUBLE property)              const { return this.m_double_prop[this.IndexProp(property)];               }
   string            GetProperty(ENUM_ACCOUNT_PROP_STRING property)              const { return this.m_string_prop[this.IndexProp(property)];               }

//--- Return the flag of calculating MarginCall and StopOut levels in %
   bool              IsPercentsForSOLevels(void)                                 const { return this.MarginSOMode()==ACCOUNT_STOPOUT_MODE_PERCENT;          }
//--- Return the flag of supporting the property by the account object
   virtual bool      SupportProperty(ENUM_ACCOUNT_PROP_INTEGER property)               { return true; }
   virtual bool      SupportProperty(ENUM_ACCOUNT_PROP_DOUBLE property)                { return true; }
   virtual bool      SupportProperty(ENUM_ACCOUNT_PROP_STRING property)                { return true; }

//--- Compare CAccount objects by all possible properties (for sorting the lists by a specified account object property)
   virtual int       Compare(const CObject *node,const int mode=0) const;
//--- Compare CAccount objects by account properties (to search for equal account objects)
   bool              IsEqual(CAccount* compared_account) const;
//--- (1) Save the account object to the file, (2), download the account object from the file
   virtual bool      Save(const int file_handle);
   virtual bool      Load(const int file_handle);
//+------------------------------------------------------------------+
//| Methods of a simplified access to the account object properties  |
//+------------------------------------------------------------------+
//--- Return the account's integer properties
   ENUM_ACCOUNT_TRADE_MODE    TradeMode(void)                     const { return (ENUM_ACCOUNT_TRADE_MODE)this.GetProperty(ACCOUNT_PROP_TRADE_MODE);        }
   ENUM_ACCOUNT_STOPOUT_MODE  MarginSOMode(void)                  const { return (ENUM_ACCOUNT_STOPOUT_MODE)this.GetProperty(ACCOUNT_PROP_MARGIN_SO_MODE);  }
   ENUM_ACCOUNT_MARGIN_MODE   MarginMode(void)                    const { return (ENUM_ACCOUNT_MARGIN_MODE)this.GetProperty(ACCOUNT_PROP_MARGIN_MODE);      }
   long              Login(void)                                  const { return this.GetProperty(ACCOUNT_PROP_LOGIN);                                      }
   long              Leverage(void)                               const { return this.GetProperty(ACCOUNT_PROP_LEVERAGE);                                   }
   long              LimitOrders(void)                            const { return this.GetProperty(ACCOUNT_PROP_LIMIT_ORDERS);                               }
   long              TradeAllowed(void)                           const { return this.GetProperty(ACCOUNT_PROP_TRADE_ALLOWED);                              }
   long              TradeExpert(void)                            const { return this.GetProperty(ACCOUNT_PROP_TRADE_EXPERT);                               }
   long              CurrencyDigits(void)                         const { return this.GetProperty(ACCOUNT_PROP_CURRENCY_DIGITS);                            }
   long              ServerType(void)                             const { return this.GetProperty(ACCOUNT_PROP_SERVER_TYPE);                                }
   
//--- Return the account's real properties
   double            Balance(void)                                const { return this.GetProperty(ACCOUNT_PROP_BALANCE);                                    }
   double            Credit(void)                                 const { return this.GetProperty(ACCOUNT_PROP_CREDIT);                                     }
   double            Profit(void)                                 const { return this.GetProperty(ACCOUNT_PROP_PROFIT);                                     }
   double            Equity(void)                                 const { return this.GetProperty(ACCOUNT_PROP_EQUITY);                                     }
   double            Margin(void)                                 const { return this.GetProperty(ACCOUNT_PROP_MARGIN);                                     }
   double            MarginFree(void)                             const { return this.GetProperty(ACCOUNT_PROP_MARGIN_FREE);                                }
   double            MarginLevel(void)                            const { return this.GetProperty(ACCOUNT_PROP_MARGIN_LEVEL);                               }
   double            MarginSOCall(void)                           const { return this.GetProperty(ACCOUNT_PROP_MARGIN_SO_CALL);                             }
   double            MarginSOSO(void)                             const { return this.GetProperty(ACCOUNT_PROP_MARGIN_SO_SO);                               }
   double            MarginInitial(void)                          const { return this.GetProperty(ACCOUNT_PROP_MARGIN_INITIAL);                             }
   double            MarginMaintenance(void)                      const { return this.GetProperty(ACCOUNT_PROP_MARGIN_MAINTENANCE);                         }
   double            Assets(void)                                 const { return this.GetProperty(ACCOUNT_PROP_ASSETS);                                     }
   double            Liabilities(void)                            const { return this.GetProperty(ACCOUNT_PROP_LIABILITIES);                                }
   double            ComissionBlocked(void)                       const { return this.GetProperty(ACCOUNT_PROP_COMMISSION_BLOCKED);                         }
   
//--- Return the account's string properties
   string            Name(void)                                   const { return this.GetProperty(ACCOUNT_PROP_NAME);                                       }
   string            Server(void)                                 const { return this.GetProperty(ACCOUNT_PROP_SERVER);                                     }
   string            Currency(void)                               const { return this.GetProperty(ACCOUNT_PROP_CURRENCY);                                   }
   string            Company(void)                                const { return this.GetProperty(ACCOUNT_PROP_COMPANY);                                    }

//+------------------------------------------------------------------+
//| Descriptions of the account object properties                    |
//+------------------------------------------------------------------+
//--- Return the description of the account's (1) integer, (2) real and (3) string properties
   string            GetPropertyDescription(ENUM_ACCOUNT_PROP_INTEGER property);
   string            GetPropertyDescription(ENUM_ACCOUNT_PROP_DOUBLE property);
   string            GetPropertyDescription(ENUM_ACCOUNT_PROP_STRING property);
//--- Return a name of a trading account type (demo, contest, real)
   string            TradeModeDescription(void)    const;
//--- Return a name of a trade server type (MetaTrader 5, MetaTrader 4)
   string            ServerTypeDescription(void)    const;
//--- Return the description of the mode for setting the minimum available margin level
   string            MarginSOModeDescription(void) const;
//--- Return the description of the margin calculation mode
   string            MarginModeDescription(void)   const;
//--- Display the description of the account properties in the journal (full_prop=true - all properties, false - supported ones only - implemented in descendant classes)
   void              Print(const bool full_prop=false);
//--- Display a short account description in the journal
   void              PrintShort(void);
//---
  };
//+------------------------------------------------------------------+
//| Class methods                                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccount::CAccount(void)
  {
//--- Save integer properties
   this.m_long_prop[ACCOUNT_PROP_LOGIN]                              = ::AccountInfoInteger(ACCOUNT_LOGIN);
   this.m_long_prop[ACCOUNT_PROP_TRADE_MODE]                         = ::AccountInfoInteger(ACCOUNT_TRADE_MODE);
   this.m_long_prop[ACCOUNT_PROP_LEVERAGE]                           = ::AccountInfoInteger(ACCOUNT_LEVERAGE);
   this.m_long_prop[ACCOUNT_PROP_LIMIT_ORDERS]                       = ::AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   this.m_long_prop[ACCOUNT_PROP_MARGIN_SO_MODE]                     = ::AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
   this.m_long_prop[ACCOUNT_PROP_TRADE_ALLOWED]                      = ::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);
   this.m_long_prop[ACCOUNT_PROP_TRADE_EXPERT]                       = ::AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
   this.m_long_prop[ACCOUNT_PROP_MARGIN_MODE]                        = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_MARGIN_MODE) #else ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif ;
   this.m_long_prop[ACCOUNT_PROP_CURRENCY_DIGITS]                    = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;
   this.m_long_prop[ACCOUNT_PROP_SERVER_TYPE]                        = (::TerminalInfoString(TERMINAL_NAME)=="MetaTrader 5" ? 5 : 4);
   
//--- Save real properties
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_BALANCE)]          = ::AccountInfoDouble(ACCOUNT_BALANCE);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_CREDIT)]           = ::AccountInfoDouble(ACCOUNT_CREDIT);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_PROFIT)]           = ::AccountInfoDouble(ACCOUNT_PROFIT);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_EQUITY)]           = ::AccountInfoDouble(ACCOUNT_EQUITY);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN)]           = ::AccountInfoDouble(ACCOUNT_MARGIN);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_FREE)]      = ::AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_LEVEL)]     = ::AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_SO_CALL)]   = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_SO_SO)]     = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_INITIAL)]   = ::AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_MAINTENANCE)]=::AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_ASSETS)]           = ::AccountInfoDouble(ACCOUNT_ASSETS);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_LIABILITIES)]      = ::AccountInfoDouble(ACCOUNT_LIABILITIES);
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_COMMISSION_BLOCKED)]=::AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);
   
//--- Save string properties
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_NAME)]             = ::AccountInfoString(ACCOUNT_NAME);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_SERVER)]           = ::AccountInfoString(ACCOUNT_SERVER);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_CURRENCY)]         = ::AccountInfoString(ACCOUNT_CURRENCY);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_COMPANY)]          = ::AccountInfoString(ACCOUNT_COMPANY);
  }
//+-------------------------------------------------------------------+
//|Compare CAccount objects by all possible properties                |
//+-------------------------------------------------------------------+
int CAccount::Compare(const CObject *node,const int mode=0) const
  {
   const CAccount *account_compared=node;
//--- compare integer properties of two accounts
   if(mode<ACCOUNT_PROP_INTEGER_TOTAL)
     {
      long value_compared=account_compared.GetProperty((ENUM_ACCOUNT_PROP_INTEGER)mode);
      long value_current=this.GetProperty((ENUM_ACCOUNT_PROP_INTEGER)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
//--- comparing real properties of two accounts
   else if(mode<ACCOUNT_PROP_DOUBLE_TOTAL+ACCOUNT_PROP_INTEGER_TOTAL)
     {
      double value_compared=account_compared.GetProperty((ENUM_ACCOUNT_PROP_DOUBLE)mode);
      double value_current=this.GetProperty((ENUM_ACCOUNT_PROP_DOUBLE)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
//--- compare string properties of two accounts
   else if(mode<ACCOUNT_PROP_DOUBLE_TOTAL+ACCOUNT_PROP_INTEGER_TOTAL+ACCOUNT_PROP_STRING_TOTAL)
     {
      string value_compared=account_compared.GetProperty((ENUM_ACCOUNT_PROP_STRING)mode);
      string value_current=this.GetProperty((ENUM_ACCOUNT_PROP_STRING)mode);
      return(value_current>value_compared ? 1 : value_current<value_compared ? -1 : 0);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| Compare CAccount objects by account properties                   |
//+------------------------------------------------------------------+
bool CAccount::IsEqual(CAccount *compared_account) const
  {
   if(this.GetProperty(ACCOUNT_PROP_COMPANY)!=compared_account.GetProperty(ACCOUNT_PROP_COMPANY) ||
      this.GetProperty(ACCOUNT_PROP_LOGIN)!=compared_account.GetProperty(ACCOUNT_PROP_LOGIN)     ||
      this.GetProperty(ACCOUNT_PROP_NAME)!=compared_account.GetProperty(ACCOUNT_PROP_NAME)
     ) return false;
   return true;
  }
//+------------------------------------------------------------------+
//| Save the account object to the file                              |
//+------------------------------------------------------------------+
bool CAccount::Save(const int file_handle)
  {
   if(!this.ObjectToStruct())
     {
      ::Print(DFUN,TextByLanguage("Не удалось создать структуру объекта.","Could not create object structure"));
      return false;
     }
   if(::FileWriteArray(file_handle,this.m_uchar_array)==0)
     {
      ::Print(DFUN,TextByLanguage("Не удалось записать uchar-массив в файл.","Could not write uchar array to file"));
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Download the account object from the file                        |
//+------------------------------------------------------------------+
bool CAccount::Load(const int file_handle)
  {
   if(::FileReadArray(file_handle,this.m_uchar_array)==0)
     {
      ::Print(DFUN,TextByLanguage("Не удалось загрузить uchar-массив из файла.","Could not load uchar array from file"));
      return false;
     }
   if(!::CharArrayToStruct(this.m_struct_obj,this.m_uchar_array))
     {
      ::Print(DFUN,TextByLanguage("Не удалось создать структуру объекта из uchar-массива.","Could not create object structure from uchar array"));
      return false;
     }
   this.StructToObject();
   return true;
  }
//+------------------------------------------------------------------+
//| Create the account object structure                              |
//+------------------------------------------------------------------+
bool CAccount::ObjectToStruct(void)
  {
//--- Save integer properties
   this.m_struct_obj.login=this.Login();
   this.m_struct_obj.trade_mode=this.TradeMode();
   this.m_struct_obj.leverage=this.Leverage();
   this.m_struct_obj.limit_orders=(int)this.LimitOrders();
   this.m_struct_obj.margin_so_mode=this.MarginSOMode();
   this.m_struct_obj.trade_allowed=this.TradeAllowed();
   this.m_struct_obj.trade_expert=this.TradeExpert();
   this.m_struct_obj.margin_mode=this.MarginMode();
   this.m_struct_obj.currency_digits=(int)this.CurrencyDigits();
   this.m_struct_obj.server_type=(int)this.ServerType();
//--- Save real properties
   this.m_struct_obj.balance=this.Balance();
   this.m_struct_obj.credit=this.Credit();
   this.m_struct_obj.profit=this.Profit();
   this.m_struct_obj.equity=this.Equity();
   this.m_struct_obj.margin=this.Margin();
   this.m_struct_obj.margin_free=this.MarginFree();
   this.m_struct_obj.margin_level=this.MarginLevel();
   this.m_struct_obj.margin_so_call=this.MarginSOCall();
   this.m_struct_obj.margin_so_so=this.MarginSOSO();
   this.m_struct_obj.margin_initial=this.MarginInitial();
   this.m_struct_obj.margin_maintenance=this.MarginMaintenance();
   this.m_struct_obj.assets=this.Assets();
   this.m_struct_obj.liabilities=this.Liabilities();
   this.m_struct_obj.comission_blocked=this.ComissionBlocked();
//--- Save string properties
   ::StringToCharArray(this.Name(),this.m_struct_obj.name);
   ::StringToCharArray(this.Server(),this.m_struct_obj.server);
   ::StringToCharArray(this.Currency(),this.m_struct_obj.currency);
   ::StringToCharArray(this.Company(),this.m_struct_obj.company);
   //--- Save the structure to the uchar array
   ::ResetLastError();
   if(!::StructToCharArray(this.m_struct_obj,this.m_uchar_array))
     {
      ::Print(DFUN,TextByLanguage("Не удалось сохранить структуру объекта в uchar-массив, ошибка ","Failed to save object structure to uchar array, error "),(string)::GetLastError());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Create the account object from the structure                     |
//+------------------------------------------------------------------+
void CAccount::StructToObject(void)
  {
//--- Save integer properties
   this.m_long_prop[ACCOUNT_PROP_LOGIN]                              = this.m_struct_obj.login;
   this.m_long_prop[ACCOUNT_PROP_TRADE_MODE]                         = this.m_struct_obj.trade_mode;
   this.m_long_prop[ACCOUNT_PROP_LEVERAGE]                           = this.m_struct_obj.leverage;
   this.m_long_prop[ACCOUNT_PROP_LIMIT_ORDERS]                       = this.m_struct_obj.limit_orders;
   this.m_long_prop[ACCOUNT_PROP_MARGIN_SO_MODE]                     = this.m_struct_obj.margin_so_mode;
   this.m_long_prop[ACCOUNT_PROP_TRADE_ALLOWED]                      = this.m_struct_obj.trade_allowed;
   this.m_long_prop[ACCOUNT_PROP_TRADE_EXPERT]                       = this.m_struct_obj.trade_expert;
   this.m_long_prop[ACCOUNT_PROP_MARGIN_MODE]                        = this.m_struct_obj.margin_mode;
   this.m_long_prop[ACCOUNT_PROP_CURRENCY_DIGITS]                    = this.m_struct_obj.currency_digits;
   this.m_long_prop[ACCOUNT_PROP_SERVER_TYPE]                        = this.m_struct_obj.server_type;
//--- Save real properties
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_BALANCE)]          = this.m_struct_obj.balance;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_CREDIT)]           = this.m_struct_obj.credit;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_PROFIT)]           = this.m_struct_obj.profit;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_EQUITY)]           = this.m_struct_obj.equity;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN)]           = this.m_struct_obj.margin;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_FREE)]      = this.m_struct_obj.margin_free;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_LEVEL)]     = this.m_struct_obj.margin_level;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_SO_CALL)]   = this.m_struct_obj.margin_so_call;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_SO_SO)]     = this.m_struct_obj.margin_so_so;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_INITIAL)]   = this.m_struct_obj.margin_initial;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_MARGIN_MAINTENANCE)]=this.m_struct_obj.margin_maintenance;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_ASSETS)]           = this.m_struct_obj.assets;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_LIABILITIES)]      = this.m_struct_obj.liabilities;
   this.m_double_prop[this.IndexProp(ACCOUNT_PROP_COMMISSION_BLOCKED)]=this.m_struct_obj.comission_blocked;
//--- Save string properties
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_NAME)]             = ::CharArrayToString(this.m_struct_obj.name);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_SERVER)]           = ::CharArrayToString(this.m_struct_obj.server);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_CURRENCY)]         = ::CharArrayToString(this.m_struct_obj.currency);
   this.m_string_prop[this.IndexProp(ACCOUNT_PROP_COMPANY)]          = ::CharArrayToString(this.m_struct_obj.company);
  }
//+------------------------------------------------------------------+
//| Send account properties to the journal                           |
//+------------------------------------------------------------------+
void CAccount::Print(const bool full_prop=false)
  {
   ::Print("============= ",TextByLanguage("Начало списка параметров аккаунта","Beginning of the parameter list of Account")," ==================");
   int beg=0, end=ACCOUNT_PROP_INTEGER_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_ACCOUNT_PROP_INTEGER prop=(ENUM_ACCOUNT_PROP_INTEGER)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("------");
   beg=end; end+=ACCOUNT_PROP_DOUBLE_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_ACCOUNT_PROP_DOUBLE prop=(ENUM_ACCOUNT_PROP_DOUBLE)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("------");
   beg=end; end+=ACCOUNT_PROP_STRING_TOTAL;
   for(int i=beg; i<end; i++)
     {
      ENUM_ACCOUNT_PROP_STRING prop=(ENUM_ACCOUNT_PROP_STRING)i;
      if(!full_prop && !this.SupportProperty(prop)) continue;
      ::Print(this.GetPropertyDescription(prop));
     }
   ::Print("================== ",TextByLanguage("Конец списка параметров аккаунта","End of the parameter list of Account")," ==================\n");
  }
//+------------------------------------------------------------------+
//| Display a short account description in the journal               |
//+------------------------------------------------------------------+
void CAccount::PrintShort(void)
  {
   string mode=(this.MarginMode()==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING ? ", Hedge" : this.MarginMode()==ACCOUNT_MARGIN_MODE_EXCHANGE ? ", Exhange" : "");
   string names=TextByLanguage("Счёт ","Account ")+(string)this.Login()+": "+this.Name()+" ("+this.Company()+" ";
   string values=::DoubleToString(this.Balance(),(int)this.CurrencyDigits())+" "+this.Currency()+", 1:"+(string)+this.Leverage()+mode+", "+this.TradeModeDescription()+" "+this.ServerTypeDescription()+")";
   ::Print(names,values);
  }
//+------------------------------------------------------------------+
//| Return the description of the account integer property           |
//+------------------------------------------------------------------+
string CAccount::GetPropertyDescription(ENUM_ACCOUNT_PROP_INTEGER property)
  {
   return
     (
      property==ACCOUNT_PROP_LOGIN           ?  TextByLanguage("Номер счёта","Account number")+": "+(string)this.GetProperty(property)                                                    :
      property==ACCOUNT_PROP_TRADE_MODE      ?  TextByLanguage("Тип торгового счета","Account trade mode")+": "+this.TradeModeDescription()                                               :
      property==ACCOUNT_PROP_LEVERAGE        ?  TextByLanguage("Размер предоставленного плеча","Account leverage")+": "+(string)this.GetProperty(property) :
      property==ACCOUNT_PROP_LIMIT_ORDERS    ?  TextByLanguage("Максимально допустимое количество действующих отложенных ордеров","Maximum allowed number of active pending orders")+": "+
                                                   (string)this.GetProperty(property)                                                                                                     :
      property==ACCOUNT_PROP_MARGIN_SO_MODE  ?  TextByLanguage("Режим задания минимально допустимого уровня залоговых средств","Mode for setting minimal allowed margin")+": "+
                                                   this.MarginSOModeDescription()                                                          :
      property==ACCOUNT_PROP_TRADE_ALLOWED   ?  TextByLanguage("Разрешенность торговли для текущего счета","Allowed trade for current account")+": "+
                                                   (this.GetProperty(property) ? TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))                                                 :
      property==ACCOUNT_PROP_TRADE_EXPERT    ?  TextByLanguage("Разрешенность торговли для эксперта","Allowed trade for Expert Advisor")+": "+
                                                   (this.GetProperty(property) ? TextByLanguage("Да","Yes") : TextByLanguage("Нет","No"))                                                 :
      property==ACCOUNT_PROP_MARGIN_MODE     ?  TextByLanguage("Режим расчета маржи","Margin calculation mode")+": "+
                                                   this.MarginModeDescription()                                                         :
      property==ACCOUNT_PROP_CURRENCY_DIGITS ?  TextByLanguage("Количество знаков после запятой для валюты счета","Number of decimal places in account currency")+": "+
                                                   (string)this.GetProperty(property)                                                                                                     :
      property==ACCOUNT_PROP_SERVER_TYPE     ?  TextByLanguage("Тип торгового сервера","Type of trading server")+": "+
                                                   (string)this.GetProperty(property)                                                                                                     :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the account real property              |
//+------------------------------------------------------------------+
string CAccount::GetPropertyDescription(ENUM_ACCOUNT_PROP_DOUBLE property)
  {
   return
     (
      property==ACCOUNT_PROP_BALANCE         ?  TextByLanguage("Баланс счета","Account balance")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())+" "+this.Currency()                                            :
      property==ACCOUNT_PROP_CREDIT          ?  TextByLanguage("Предоставленный кредит","Account credit")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())+" "+this.Currency()                                            :
      property==ACCOUNT_PROP_PROFIT          ?  TextByLanguage("Текущая прибыль на счете","Current profit of an account")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())+" "+this.Currency()                                            :
      property==ACCOUNT_PROP_EQUITY          ?  TextByLanguage("Собственные средства на счете","Account equity")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())+" "+this.Currency()                                            :
      property==ACCOUNT_PROP_MARGIN          ?  
         TextByLanguage("Зарезервированные залоговые средства на счете","Account margin used in deposit currency")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())+" "+this.Currency()                                            :
      property==ACCOUNT_PROP_MARGIN_FREE     ?  
         TextByLanguage("Свободные средства на счете, доступные для открытия позиции","Free margin of account")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      property==ACCOUNT_PROP_MARGIN_LEVEL    ?  TextByLanguage("Уровень залоговых средств на счете в процентах","Account margin level in percents")+": "+
                                                   ::DoubleToString(this.GetProperty(property),1)+"%"                                                                                     :
      property==ACCOUNT_PROP_MARGIN_SO_CALL  ?  TextByLanguage("Уровень залоговых средств для наступления Margin Call","Margin call level")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(this.IsPercentsForSOLevels() ? 1 : (int)this.CurrencyDigits()))+
                                                   (this.IsPercentsForSOLevels() ? "%" : this.Currency())                                                                                 :
      property==ACCOUNT_PROP_MARGIN_SO_SO    ?  TextByLanguage("Уровень залоговых средств для наступления Stop Out","Margin stop out level")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(this.IsPercentsForSOLevels() ? 1 : (int)this.CurrencyDigits()))+
                                                   (this.IsPercentsForSOLevels() ? "%" : this.Currency())                                                                                 :
      property==ACCOUNT_PROP_MARGIN_INITIAL  ? 
         TextByLanguage("Зарезервированные средства для обеспечения гарантийной суммы по всем отложенным ордерам","Amount reserved on account to cover margin of all pending orders ")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      property==ACCOUNT_PROP_MARGIN_MAINTENANCE  ? 
         TextByLanguage("Зарезервированные средства для обеспечения минимальной суммы по всем открытым позициям","Min equity reserved on account to cover min amount of all open positions")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      property==ACCOUNT_PROP_ASSETS          ?  TextByLanguage("Текущий размер активов на счёте","Current assets of account")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      property==ACCOUNT_PROP_LIABILITIES     ?  TextByLanguage("Текущий размер обязательств на счёте","Current liabilities on account")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      property==ACCOUNT_PROP_COMMISSION_BLOCKED ?  
         TextByLanguage("Сумма заблокированных комиссий по счёту","Current blocked commission amount on account")+": "+
                                                   ::DoubleToString(this.GetProperty(property),(int)this.CurrencyDigits())                                                                :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return description of the account string property                |
//+------------------------------------------------------------------+
string CAccount::GetPropertyDescription(ENUM_ACCOUNT_PROP_STRING property)
  {
   return
     (
      property==ACCOUNT_PROP_NAME      ?  TextByLanguage("Имя клиента","Client name")+": \""+this.GetProperty(property)+"\""                                                     :
      property==ACCOUNT_PROP_SERVER    ?  TextByLanguage("Имя торгового сервера","Trade server name")+": \""+this.GetProperty(property)+"\""                                     :
      property==ACCOUNT_PROP_CURRENCY  ?  TextByLanguage("Валюта депозита","Account currency")+": \""+this.GetProperty(property)+"\""                                            :
      property==ACCOUNT_PROP_COMPANY   ?  TextByLanguage("Имя компании, обслуживающей счет","Name of company that serves account")+": \""+this.GetProperty(property)+"\""  :
      ""
     );
  }
//+------------------------------------------------------------------+
//| Return a name of a trading account type                          |
//+------------------------------------------------------------------+
string CAccount::TradeModeDescription(void) const
  {
   return
     (
      this.TradeMode()==ACCOUNT_TRADE_MODE_DEMO    ? TextByLanguage("Демонстрационный счёт","Demo account") :
      this.TradeMode()==ACCOUNT_TRADE_MODE_CONTEST ? TextByLanguage("Конкурсный счёт","Contest account")    :
      this.TradeMode()==ACCOUNT_TRADE_MODE_REAL    ? TextByLanguage("Реальный счёт","Real account")         :
      TextByLanguage("Неизвестный тип счёта","Unknown account type")
     );
  }
//+------------------------------------------------------------------+
//| Return a name of a trade server type                             |
//+------------------------------------------------------------------+
string CAccount::ServerTypeDescription(void) const
  {
   return(this.ServerType()==5 ? "MetaTrader 5" : "MetaTrader 4");
  }
//+------------------------------------------------------------------+
//| Return the description of the mode for setting                   |
//| the minimum available margin level                               |
//+------------------------------------------------------------------+
string CAccount::MarginSOModeDescription(void) const
  {
   return
     (
      this.MarginSOMode()==ACCOUNT_STOPOUT_MODE_PERCENT  ? TextByLanguage("Уровень задается в процентах","Account StopOut mode in percents") : 
      TextByLanguage("Уровень задается в деньгах","Account StopOut mode in money")
     );
  }
//+------------------------------------------------------------------+
//| Return the description of the margin calculation mode            |
//+------------------------------------------------------------------+
string CAccount::MarginModeDescription(void) const
  {
   return
     (
      this.MarginMode()==ACCOUNT_MARGIN_MODE_RETAIL_NETTING ? TextByLanguage("Внебиржевой рынок в режиме \"Неттинг\"","Netting mode") :
      this.MarginMode()==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING ? TextByLanguage("Внебиржевой рынок в режиме \"Хеджинг\"","Hedging mode") :
      TextByLanguage("Биржевой рынок","Exchange markets mode")
     );
  }
//+------------------------------------------------------------------+
