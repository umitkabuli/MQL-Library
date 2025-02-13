//+------------------------------------------------------------------+
//|                                           AccountsCollection.mqh |
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
#include "..\Objects\Accounts\Account.mqh"
//+------------------------------------------------------------------+
//| Account collection                                               |
//+------------------------------------------------------------------+
class CAccountsCollection : public CListObj
  {
private:
   struct MqlDataAccount
     {
      double         hash_sum;               // Account data hash sum
      //--- Account integer properties
      long           login;                  // ACCOUNT_LOGIN (Account number)
      long           leverage;               // ACCOUNT_LEVERAGE (Leverage)
      int            limit_orders;           // ACCOUNT_LIMIT_ORDERS (Maximum allowed number of active pending orders)
      bool           trade_allowed;          // ACCOUNT_TRADE_ALLOWED (Permission to trade for the current account from the server side)
      bool           trade_expert;           // ACCOUNT_TRADE_EXPERT (Permission to trade for an EA from the server side)
      //--- Account real properties
      double         balance;                // ACCOUNT_BALANCE (Account balance in a deposit currency)
      double         credit;                 // ACCOUNT_CREDIT (Credit in a deposit currency)
      double         profit;                 // ACCOUNT_PROFIT (Current profit on an account in the account currency)
      double         equity;                 // ACCOUNT_EQUITY (Equity on an account in the deposit currency)
      double         margin;                 // ACCOUNT_MARGIN (Reserved margin on an account in a deposit currency)
      double         margin_free;            // ACCOUNT_MARGIN_FREE (Free funds available for opening a position in a deposit currency)
      double         margin_level;           // ACCOUNT_MARGIN_LEVEL (Margin level on an account in %)
      double         margin_so_call;         // ACCOUNT_MARGIN_SO_CALL (MarginCall)
      double         margin_so_so;           // ACCOUNT_MARGIN_SO_SO (StopOut)
      double         margin_initial;         // ACCOUNT_MARGIN_INITIAL (Funds reserved on an account to ensure a guarantee amount for all pending orders)
      double         margin_maintenance;     // ACCOUNT_MARGIN_MAINTENANCE (Funds reserved on an account to ensure a minimum amount for all open positions)
      double         assets;                 // ACCOUNT_ASSETS (Current assets on an account)
      double         liabilities;            // ACCOUNT_LIABILITIES (Current liabilities on an account)
      double         comission_blocked;      // ACCOUNT_COMMISSION_BLOCKED (Current sum of blocked commissions on an account)
     };
   MqlDataAccount    m_struct_curr_account;  // Account current data
   MqlDataAccount    m_struct_prev_account;  // Account previous data
   
   CListObj          m_list_accounts;                                   // Account object list
   string            m_folder_name;                                     // Name of a folder account objects are stored in
   int               m_index_current;                                   // Index of an account object featuring the current account data
   bool              m_is_account_event;                                // Account data event flag

//--- Write the current account data to the account object properties
  void               SetAccountsParams(CAccount* account);
//--- Save the current data status values of the current account as previous ones
   void              SavePrevValues(void)                                                                   { this.m_struct_prev_account=this.m_struct_curr_account;                }
//--- Check the account object presence in the collection list
   bool              IsPresent(CAccount* account);
//--- Find and return the account object index with the current account data
   int               Index(void);
public:
//--- Return the full account collection list "as is"
   CArrayObj        *GetList(void)                                                                          { return &this.m_list_accounts;                                         }
//--- Return the list by selected (1) integer, (2) real and (3) string properties meeting the compared criterion
   CArrayObj        *GetList(ENUM_ACCOUNT_PROP_INTEGER property,long value,ENUM_COMPARER_TYPE mode=EQUAL)   { return CSelect::ByAccountProperty(this.GetList(),property,value,mode);}
   CArrayObj        *GetList(ENUM_ACCOUNT_PROP_DOUBLE property,double value,ENUM_COMPARER_TYPE mode=EQUAL)  { return CSelect::ByAccountProperty(this.GetList(),property,value,mode);}
   CArrayObj        *GetList(ENUM_ACCOUNT_PROP_STRING property,string value,ENUM_COMPARER_TYPE mode=EQUAL)  { return CSelect::ByAccountProperty(this.GetList(),property,value,mode);}
//--- Return the (1) current account object index, (2) occurred event flag in the account data
   int               IndexCurrentAccount(void)                                                        const { return this.m_index_current;                                          }
   bool              IsAccountEvent(void)                                                             const { return this.m_is_account_event;                                       }

//--- Constructor, destructor
                     CAccountsCollection();
                    ~CAccountsCollection();
//--- Add the account object to the list
   bool              AddToList(CAccount* account);
//--- (1) Save account objects from the list to the files
//--- (2) Save account objects from the files to the list
   bool              SaveObjects(void);
   bool              LoadObjects(void);
//--- Update the current account data
   void              Refresh(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccountsCollection::CAccountsCollection(void) : m_folder_name(DIRECTORY+"Accounts"),m_is_account_event(false)
  {
   this.m_list_accounts.Clear();
   this.m_list_accounts.Sort(SORT_BY_ACCOUNT_LOGIN);
   this.m_list_accounts.Type(COLLECTION_ACCOUNT_ID);
   ::ZeroMemory(this.m_struct_prev_account);

//--- Create the folder for storing account files
   ::ResetLastError();
   if(!::FolderCreate(this.m_folder_name,FILE_COMMON))
      Print(DFUN,TextByLanguage("Не удалось создать папку хранения файлов. Ошибка ","Could not create file storage folder. Error "),::GetLastError());
//--- Create the current account object and add it to the list
   CAccount* account=new CAccount();
   if(account!=NULL)
     {
      if(!this.AddToList(account))
        {
         Print(DFUN_ERR_LINE,TextByLanguage("Ошибка. Не удалось добавить текущий объект-аккаунт в список-коллекцию.","Error. Failed to add current account object to collection list."));
         delete account;
        }
      else
         account.PrintShort();
     }
   else
      Print(DFUN,TextByLanguage("Ошибка. Не удалось создать объект-аккаунт с данными текущего счёта.","Error. Failed to create an account object with current account data."));

//--- Download account objects from the files to the collection
   this.LoadObjects();
//--- Save the current account index
   this.m_index_current=this.Index();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAccountsCollection::~CAccountsCollection(void)
  {
//--- Save account objects from the list to the files
   this.SaveObjects();
  }
//+------------------------------------------------------------------+
//| Add the account object to the list                               |
//+------------------------------------------------------------------+
bool CAccountsCollection::AddToList(CAccount *account)
  {
   if(account==NULL)
      return false;
   if(!this.IsPresent(account))
      return this.m_list_accounts.Add(account);
   return false;
  }
//+------------------------------------------------------------------+
//| Check the account object presence in the collection list         |
//+------------------------------------------------------------------+
bool CAccountsCollection::IsPresent(CAccount *account)
  {
   int total=this.m_list_accounts.Total();
   if(total==0)
      return false;
   for(int i=0;i<total;i++)
     {
      CAccount* check=this.m_list_accounts.At(i);
      if(check==NULL)
         continue;
      if(check.IsEqual(account))
         return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Return the account object index with the current account data    |
//+------------------------------------------------------------------+
int CAccountsCollection::Index(void)
  {
   int total=this.m_list_accounts.Total();
   if(total==0)
      return WRONG_VALUE;
   for(int i=0;i<total;i++)
     {
      CAccount* account=this.m_list_accounts.At(i);
      if(account==NULL)
         continue;
      if(account.Login()==::AccountInfoInteger(ACCOUNT_LOGIN)    &&
         account.Company()==::AccountInfoString(ACCOUNT_COMPANY) &&
         account.Name()==::AccountInfoString(ACCOUNT_NAME)  
        ) return i;
     }
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Save account objects from the list to the files                  |
//+------------------------------------------------------------------+
bool CAccountsCollection::SaveObjects(void)
  {
   bool res=true;
   int total=this.m_list_accounts.Total();
   if(total==0)
      return false;
   for(int i=0;i<total;i++)
     {
      CAccount* account=this.m_list_accounts.At(i);
      if(account==NULL)
         continue;
      string file_name=this.m_folder_name+"\\"+account.Server()+" "+(string)account.Login()+".bin";
      if(::FileIsExist(file_name,FILE_COMMON))
         ::FileDelete(file_name,FILE_COMMON);
      ::ResetLastError();
      int handle=::FileOpen(file_name,FILE_WRITE|FILE_BIN|FILE_COMMON);
      if(handle==INVALID_HANDLE)
        {
         ::Print(DFUN,TextByLanguage("Не удалось открыть для записи файл ","Could not open file for writing: "),file_name,TextByLanguage(". Ошибка ",". Error "),(string)::GetLastError());
         return false;
        }
      res &=account.Save(handle);
      ::FileClose(handle);
     }
   return res;
  }
//+------------------------------------------------------------------+
//| Save account objects from the files to the list                  |
//+------------------------------------------------------------------+
bool CAccountsCollection::LoadObjects(void)
  {
   bool res=true;
   string name="";
   long handle_search=::FileFindFirst(this.m_folder_name+"\\*",name,FILE_COMMON);
   if(handle_search!=INVALID_HANDLE)
     {
      do
        {
         string file_name=this.m_folder_name+"\\"+name;
         ::ResetLastError();
         int handle_file=::FileOpen(m_folder_name+"\\"+name,FILE_BIN|FILE_READ|FILE_COMMON);
         if(handle_file!=INVALID_HANDLE)
           {
            CAccount* account=new CAccount();
            if(account!=NULL)
              {
               if(!account.Load(handle_file))
                 {
                  delete account;
                  ::FileClose(handle_file);
                  res &=false;
                  continue;
                 }
               if(this.IsPresent(account))
                 {
                  delete account;
                  ::FileClose(handle_file);
                  res &=false;
                  continue;
                 }
               if(!this.AddToList(account))
                 {
                  delete account;
                  res &=false;
                 }
              }
           }
         ::FileClose(handle_file);
        }
      while(::FileFindNext(handle_search,name));
      ::FileFindClose(handle_search);
     }
   return res;
  }
//+------------------------------------------------------------------+
//| Update the current account data                                  |
//+------------------------------------------------------------------+
void CAccountsCollection::Refresh(void)
  {
   if(this.m_index_current==WRONG_VALUE)
      return;
   CAccount* account=this.m_list_accounts.At(this.m_index_current);
   if(account==NULL)
      return;
   ::ZeroMemory(this.m_struct_curr_account);
   this.m_is_account_event=false;
   this.SetAccountsParams(account);
   
//--- First launch
   if(!this.m_struct_prev_account.login)
     {
      this.SavePrevValues();
     }
//--- If the account hash sum changed
   if(this.m_struct_curr_account.hash_sum!=this.m_struct_prev_account.hash_sum)
     {
      this.m_is_account_event=true;
      this.SavePrevValues();
     }
  }
//+------------------------------------------------------------------+
//| Write the current account data to the account object properties  |
//+------------------------------------------------------------------+
void CAccountsCollection::SetAccountsParams(CAccount *account)
  {
   if(account==NULL)
      return;
//--- Account number
   this.m_struct_curr_account.login=account.Login();
//--- Leverage
   account.SetProperty(ACCOUNT_PROP_LEVERAGE,::AccountInfoInteger(ACCOUNT_LEVERAGE));
   this.m_struct_curr_account.leverage=account.Leverage();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.leverage;
//--- Maximum allowed number of active pending orders
   account.SetProperty(ACCOUNT_PROP_LIMIT_ORDERS,::AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
   this.m_struct_curr_account.limit_orders=(int)account.LimitOrders();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.limit_orders;
//--- Permission to trade for the current account from the server side
   account.SetProperty(ACCOUNT_PROP_TRADE_ALLOWED,::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
   this.m_struct_curr_account.trade_allowed=account.TradeAllowed();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.trade_allowed;
//--- Permission to trade for an EA from the server side
   account.SetProperty(ACCOUNT_PROP_TRADE_EXPERT,::AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
   this.m_struct_curr_account.trade_expert=account.TradeExpert();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.trade_expert;
//--- Account balance in a deposit currency
   account.SetProperty(ACCOUNT_PROP_BALANCE,::AccountInfoDouble(ACCOUNT_BALANCE));
   this.m_struct_curr_account.balance=account.Balance();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.balance;
//--- Credit in a deposit currency
   account.SetProperty(ACCOUNT_PROP_CREDIT,::AccountInfoDouble(ACCOUNT_CREDIT));
   this.m_struct_curr_account.credit=account.Credit();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.credit;
//--- Current profit on an account in the account currency
   account.SetProperty(ACCOUNT_PROP_PROFIT,::AccountInfoDouble(ACCOUNT_PROFIT));
   this.m_struct_curr_account.profit=account.Profit();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.profit;
//--- Equity on an account in the deposit currency
   account.SetProperty(ACCOUNT_PROP_EQUITY,::AccountInfoDouble(ACCOUNT_EQUITY));
   this.m_struct_curr_account.equity=account.Equity();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.equity;
//--- Reserved margin on an account in the deposit currency
   account.SetProperty(ACCOUNT_PROP_MARGIN,::AccountInfoDouble(ACCOUNT_MARGIN));
   this.m_struct_curr_account.margin=account.Margin();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin;
//--- Free funds available for opening a position on an account in the deposit currency
   account.SetProperty(ACCOUNT_PROP_MARGIN_FREE,::AccountInfoDouble(ACCOUNT_MARGIN_FREE));
   this.m_struct_curr_account.margin_free=account.MarginFree();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_free;
//--- Margin level on an account in %
   account.SetProperty(ACCOUNT_PROP_MARGIN_LEVEL,::AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
   this.m_struct_curr_account.margin_level=account.MarginLevel();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_level;
//--- Margin Call level
   account.SetProperty(ACCOUNT_PROP_MARGIN_SO_CALL,::AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
   this.m_struct_curr_account.margin_so_call=account.MarginSOCall();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_so_call;
//--- Stop Out level
   account.SetProperty(ACCOUNT_PROP_MARGIN_SO_SO,::AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
   this.m_struct_curr_account.margin_so_so=account.MarginSOSO();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_so_so;
//--- Funds reserved on an account to ensure a guarantee amount for all pending orders
   account.SetProperty(ACCOUNT_PROP_MARGIN_INITIAL,::AccountInfoDouble(ACCOUNT_MARGIN_INITIAL));
   this.m_struct_curr_account.margin_initial=account.MarginInitial();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_initial;
//--- Funds reserved on an account to ensure a minimum amount for all open positions
   account.SetProperty(ACCOUNT_PROP_MARGIN_MAINTENANCE,::AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE));
   this.m_struct_curr_account.margin_maintenance=account.MarginMaintenance();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.margin_maintenance;
//--- Current assets on an account
   account.SetProperty(ACCOUNT_PROP_ASSETS,::AccountInfoDouble(ACCOUNT_ASSETS));
   this.m_struct_curr_account.assets=account.Assets();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.assets;
//--- Current liabilities on an account
   account.SetProperty(ACCOUNT_PROP_LIABILITIES,::AccountInfoDouble(ACCOUNT_LIABILITIES));
   this.m_struct_curr_account.liabilities=account.Liabilities();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.liabilities;
//--- Current sum of blocked commissions on an account
   account.SetProperty(ACCOUNT_PROP_COMMISSION_BLOCKED,::AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED));
   this.m_struct_curr_account.comission_blocked=account.ComissionBlocked();
   this.m_struct_curr_account.hash_sum+=(double)this.m_struct_curr_account.comission_blocked;
  }
//+------------------------------------------------------------------+
