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
#include <Arrays\ArrayInt.mqh>
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
   MqlDataAccount    m_struct_curr_account;              // Account current data
   MqlDataAccount    m_struct_prev_account;              // Account previous data
   
   MqlTick           m_tick;                             // Tick structure
   string            m_symbol;                           // Current symbol
   long              m_chart_id;                         // Control program chart ID
   CListObj          m_list_accounts;                    // Account object list
   CArrayInt         m_list_changes;                     // Account change list
   string            m_folder_name;                      // Name of a folder account objects are stored in
   int               m_index_current;                    // Index of an account object featuring the current account data
//--- Tracking account changes
   bool              m_is_account_event;                 // Account data event flag
   int               m_change_code;                      // Account change code
   //--- Leverage
   long              m_changed_leverage_value;           // Leverage change value
   bool              m_is_change_leverage_inc;           // Leverage increase flag
   bool              m_is_change_leverage_dec;           // Leverage decrease flag
   //--- Number of active pending orders
   int               m_changed_limit_orders_value;       // Change value of the maximum allowed number of active pending orders
   bool              m_is_change_limit_orders_inc;       // Increase flag of the maximum allowed number of active pending orders
   bool              m_is_change_limit_orders_dec;       // Decrease flag of the maximum allowed number of active pending orders
   //--- Trading on an account
   bool              m_is_change_trade_allowed_on;       // The flag allowing to trade for the current account from the server side
   bool              m_is_change_trade_allowed_off;      // The flag prohibiting trading for the current account from the server side
   //--- Auto trading on an account
   bool              m_is_change_trade_expert_on;        // The flag allowing to trade for an EA from the server side
   bool              m_is_change_trade_expert_off;       // The flag prohibiting trading for an EA from the server side
   //--- Balance
   double            m_control_balance_inc;              // Tracked balance growth value
   double            m_control_balance_dec;              // Tracked balance decrease value
   double            m_changed_balance_value;            // Balance change value
   bool              m_is_change_balance_inc;            // The flag of the balance change exceeding the growth value
   bool              m_is_change_balance_dec;            // The flag of the balance change exceeding the decrease value
   //--- Credit
   double            m_changed_credit_value;             // Credit change value
   bool              m_is_change_credit_inc;             // Credit increase flag
   bool              m_is_change_credit_dec;             // Credit decrease flag
   //--- Profit
   double            m_control_profit_inc;               // Tracked profit growth value
   double            m_control_profit_dec;               // Tracked profit decrease value
   double            m_changed_profit_value;             // Profit change value
   bool              m_is_change_profit_inc;             // The flag of the profit change exceeding the growth value
   bool              m_is_change_profit_dec;             // The flag of the profit change exceeding the decrease value
   //--- Funds (equity)
   double            m_control_equity_inc;               // Tracked funds growth value
   double            m_control_equity_dec;               // Tracked funds decrease value
   double            m_changed_equity_value;             // Funds change value
   bool              m_is_change_equity_inc;             // The flag of the funds change exceeding the growth value
   bool              m_is_change_equity_dec;             // The flag of the funds change exceeding the decrease value
   //--- Margin
   double            m_control_margin_inc;               // Tracked margin growth value
   double            m_control_margin_dec;               // Tracked margin decrease value
   double            m_changed_margin_value;             // Margin change value
   bool              m_is_change_margin_inc;             // The flag of the margin change exceeding the growth value
   bool              m_is_change_margin_dec;             // The flag of the margin change exceeding the decrease value
   //--- Free margin
   double            m_control_margin_free_inc;          // Tracked free margin growth value
   double            m_control_margin_free_dec;          // Tracked free margin decrease value
   double            m_changed_margin_free_value;        // Free margin change value
   bool              m_is_change_margin_free_inc;        // The flag of the free margin change exceeding the growth value
   bool              m_is_change_margin_free_dec;        // The flag of the free margin change exceeding the decrease value
   //--- Margin level
   double            m_control_margin_level_inc;         // Tracked margin level growth value
   double            m_control_margin_level_dec;         // Tracked margin level decrease value
   double            m_changed_margin_level_value;       // Margin level change value
   bool              m_is_change_margin_level_inc;       // The flag of the free margin change exceeding the growth value
   bool              m_is_change_margin_level_dec;       // The flag of the margin level change exceeding the decrease value
   //--- Margin Call
   double            m_changed_margin_so_call_value;     // Margin Call level change value
   bool              m_is_change_margin_so_call_inc;     // Margin Call level increase value
   bool              m_is_change_margin_so_call_dec;     // Margin Call level decrease value
   //--- MarginStopOut
   double            m_changed_margin_so_so_value;       // Margin StopOut level change value
   bool              m_is_change_margin_so_so_inc;       // Margin StopOut level increase flag
   bool              m_is_change_margin_so_so_dec;       // Margin StopOut level decrease flag
   //--- Guarantee sum for pending orders
   double            m_control_margin_initial_inc;       // Tracked growth value of the reserved funds for providing the guarantee sum for pending orders
   double            m_control_margin_initial_dec;       // Tracked decrease value of the reserved funds for providing the guarantee sum for pending orders
   double            m_changed_margin_initial_value;     // The change value of the reserved funds for providing the guarantee sum for pending orders
   bool              m_is_change_margin_initial_inc;     // The flag of the reserved funds for providing the guarantee sum for pending orders exceeding the growth value
   bool              m_is_change_margin_initial_dec;     // The flag of the reserved funds for providing the guarantee sum for pending orders exceeding the decrease value
   //--- Guarantee sum for open positions
   double            m_control_margin_maintenance_inc;   // The tracked increase value of the funds reserved on an account to ensure a minimum amount for all open positions
   double            m_control_margin_maintenance_dec;   // The tracked decrease value of the funds reserved on an account to ensure a minimum amount for all open positions
   double            m_changed_margin_maintenance_value; // The change value of the funds reserved on an account to ensure a minimum amount for all open positions
   bool              m_is_change_margin_maintenance_inc; // The flag of the funds reserved on an account to ensure a minimum amount for all open positions exceeding the growth value
   bool              m_is_change_margin_maintenance_dec; // The flag of the funds reserved on an account to ensure a minimum amount for all open positions exceeding the decrease value
   //--- Assets
   double            m_control_assets_inc;               // Tracked assets growth value
   double            m_control_assets_dec;               // Tracked assets decrease value
   double            m_changed_assets_value;             // Assets change value
   bool              m_is_change_assets_inc;             // The flag of the assets change exceeding the growth value
   bool              m_is_change_assets_dec;             // The flag of the assets change exceeding the decrease value
   //--- Liabilities
   double            m_control_liabilities_inc;          // Tracked liabilities growth value
   double            m_control_liabilities_dec;          // Tracked liabilities decrease value
   double            m_changed_liabilities_value;        // Liabilities change values
   bool              m_is_change_liabilities_inc;        // The flag of the liabilities change exceeding the growth value
   bool              m_is_change_liabilities_dec;        // The flag of the liabilities change exceeding the decrease value
   //--- Blocked commissions
   double            m_control_comission_blocked_inc;    // Tracked blocked commissions growth value
   double            m_control_comission_blocked_dec;    // Tracked blocked commissions decrease value
   double            m_changed_comission_blocked_value;  // Blocked commissions changed value
   bool              m_is_change_comission_blocked_inc;  // The flag of the tracked commissions change exceeding the growth value
   bool              m_is_change_comission_blocked_dec;  // The flag of the tracked commissions change exceeding the decrease value
   
//--- Initialize the variables of (1) tracked, (2) controlled account data
   void              InitChangesParams(void);
   void              InitControlsParams(void);
//--- Check account changes, return a change code
   int               SetChangeCode(void);
//--- Set an event type and fill in the event list
   void              SetTypeEvent(void);
//--- return the flag presence in the account event
   bool              IsPresentEventFlag(const int change_code)                                        const { return (this.m_change_code & change_code)==change_code;               }
//--- Write the current account data to the account object properties
   void              SetAccountsParams(CAccount* account);
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
//--- Return the (1) current account object index, (2) the flag of the event occurred in the account data, (3) event type
   int               IndexCurrentAccount(void)                                                        const { return this.m_index_current;                                          }
   bool              IsAccountEvent(void)                                                             const { return this.m_is_account_event;                                       }
//--- Return the (1) object account event code, (2) event list, (3) account event by its number in the list
   int               GetEventCode(void)                                                               const { return this.m_change_code;                                            }
   CArrayInt        *GetListChanges(void)                                                                   { return &this.m_list_changes;                           }
   ENUM_ACCOUNT_EVENT GetEvent(const int shift=WRONG_VALUE);
//--- (1) Set and (2) return the current symbol
   void              SetSymbol(const string symbol)                                                         { this.m_symbol=symbol;                                  }
   string            GetSymbol(void)                                                                  const { return this.m_symbol;                                  }
//--- Set the control program chart ID
   void              SetChartID(const long id)                                                              { this.m_chart_id=id;                                    }

//--- Constructor, destructor
                     CAccountsCollection();
                    ~CAccountsCollection();
//--- Add the account object to the list
   bool              AddToList(CAccount* account);
//--- (1) Save account objects from the list to the files
//--- (2) Save account objects from the files to the list
   bool              SaveObjects(void);
   bool              LoadObjects(void);
//--- Return the account event decription
   string            EventDescription(const ENUM_ACCOUNT_EVENT event);
//--- Update the current account data
   void              Refresh(void);
   
//--- Get and set the parameters of tracked changes
   //--- Leverage:
   //--- (1) Leverage change value, (2) Leverage increase flag, (3) Leverage decrease flag
   long              GetValueChangedLeverage(void)                                                    const { return this.m_changed_leverage_value;                  }
   bool              IsIncreaseLeverage(void)                                                         const { return this.m_is_change_leverage_inc;                  }
   bool              IsDecreaseLeverage(void)                                                         const { return this.m_is_change_leverage_dec;                  }
   //--- Number of active pending orders:
   //--- (1) Change value, (2) Increase flag, (3) Decrease flag
   int               GetValueChangedLimitOrders(void)                                                 const { return this.m_changed_limit_orders_value;              }
   bool              IsIncreaseLimitOrders(void)                                                      const { return this.m_is_change_limit_orders_inc;              }
   bool              IsDecreaseLimitOrders(void)                                                      const { return this.m_is_change_limit_orders_dec;              }
   //--- Trading on an account:
   //--- (1) The flag allowing to trade for the current account, (2) The flag prohibiting trading for the current account from the server side
   bool              IsOnTradeAllowed(void)                                                           const { return this.m_is_change_trade_allowed_on;              }
   bool              IsOffTradeAllowed(void)                                                          const { return this.m_is_change_trade_allowed_off;             }
   //--- Auto trading on an account:
   //--- (1) The flag allowing to trade for an EA, (2) The flag prohibiting trading for an EA from the server side
   bool              IsOnTradeExpert(void)                                                            const { return this.m_is_change_trade_expert_on;               }
   bool              IsOffTradeExpert(void)                                                           const { return this.m_is_change_trade_expert_off;              }
   //--- Balance:
   //--- setting the tracked value of the balance (1) growth, (2) decrease
   //--- getting (3) the balance change value,
   //--- getting the flag of the balance change exceeding the (4) growth value, (5) decrease value
   void              SetControlBalanceInc(const double value)                                               { this.m_control_balance_inc=::fabs(value);              }
   void              SetControlBalanceDec(const double value)                                               { this.m_control_balance_dec=::fabs(value);              }
   double            GetValueChangedBalance(void)                                                     const { return this.m_changed_balance_value;                   }
   bool              IsIncreaseBalance(void)                                                          const { return this.m_is_change_balance_inc;                   }
   bool              IsDecreaseBalance(void)                                                          const { return this.m_is_change_balance_dec;                   }
   //--- Credit:
   //--- getting (1) the credit change value, (2) credit increase flag, (3) decrease flag
   double            GetValueChangedCredit(void)                                                      const { return this.m_changed_credit_value;                    }
   bool              IsIncreaseCredit(void)                                                           const { return this.m_is_change_credit_inc;                    }
   bool              IsDecreaseCredit(void)                                                           const { return this.m_is_change_credit_dec;                    }
   //--- Profit:
   //--- setting the tracked profit (1) growth, (2) decrease value
   //--- getting the (3) profit change value,
   //--- getting the flag of the profit change exceeding the (4) growth, (5) decrease value
   void              SetControlProfitInc(const double value)                                                { this.m_control_profit_inc=::fabs(value);               }
   void              SetControlProfitDec(const double value)                                                { this.m_control_profit_dec=::fabs(value);               }
   double            GetValueChangedProfit(void)                                                      const { return this.m_changed_profit_value;                    }
   bool              IsIncreaseProfit(void)                                                           const { return this.m_is_change_profit_inc;                    }
   bool              IsDecreaseProfit(void)                                                           const { return this.m_is_change_profit_dec;                    }
   //--- Equity:
   //--- setting the tracked equity (1) growth, (2) decrease value
   //--- getting the (3) equity change value,
   //--- getting the flag of the equity change exceeding the (4) growth, (5) decrease value
   void              SetControlEquityInc(const double value)                                                { this.m_control_equity_inc=::fabs(value);               }
   void              SetControlEquityDec(const double value)                                                { this.m_control_equity_dec=::fabs(value);               }
   double            GetValueChangedEquity(void)                                                      const { return this.m_changed_equity_value;                    }
   bool              IsIncreaseEquity(void)                                                           const { return this.m_is_change_equity_inc;                    }
   bool              IsDecreaseEquity(void)                                                           const { return this.m_is_change_equity_dec;                    }
   //--- Margin:
   //--- setting the tracked margin (1) growth, (2) decrease value
   //--- getting the (3) margin change value,
   //--- getting the flag of the margin change exceeding the (4) growth, (5) decrease value
   void              SetControlMarginInc(const double value)                                                { this.m_control_margin_inc=::fabs(value);               }
   void              SetControlMarginDec(const double value)                                                { this.m_control_margin_dec=::fabs(value);               }
   double            GetValueChangedMargin(void)                                                      const { return this.m_changed_margin_value;                    }
   bool              IsIncreaseMargin(void)                                                           const { return this.m_is_change_margin_inc;                    }
   bool              IsDecreaseMargin(void)                                                           const { return this.m_is_change_margin_dec;                    }
   //--- Free margin:
   //--- setting the tracked free margin (1) growth, (2) decrease value
   //--- getting the (3) free margin change value,
   //--- getting the flag of the free margin change exceeding the (4) growth, (5) decrease value
   void              SetControlMarginFreeInc(const double value)                                            { this.m_control_margin_free_inc=::fabs(value);          }
   void              SetControlMarginFreeDec(const double value)                                            { this.m_control_margin_free_dec=::fabs(value);          }
   double            GetValueChangedMarginFree(void)                                                  const { return this.m_changed_margin_free_value;               }
   bool              IsIncreaseMarginFree(void)                                                       const { return this.m_is_change_margin_free_inc;               }
   bool              IsDecreaseMarginFree(void)                                                       const { return this.m_is_change_margin_free_dec;               }
   //--- Margin level:
   //--- setting the tracked margin level (1) growth, (2) decrease value
   //--- getting the (3) margin level change value,
   //--- getting the flag of the margin level change exceeding the (4) growth, (5) decrease value
   void              SetControlMarginLevelInc(const double value)                                           { this.m_control_margin_level_inc=::fabs(value);         }
   void              SetControlMarginLevelDec(const double value)                                           { this.m_control_margin_level_dec=::fabs(value);         }
   double            GetValueChangedMarginLevel(void)                                                 const { return this.m_changed_margin_level_value;              }
   bool              IsIncreaseMarginLevel(void)                                                      const { return this.m_is_change_margin_level_inc;              }
   bool              IsDecreaseMarginLevel(void)                                                      const { return this.m_is_change_margin_level_dec;              }
   //--- Margin Call:
   //--- getting (1) Margin Call change value, (2) increase flag, (3) decrease flag
   double            GetValueChangedMarginCall(void)                                                  const { return this.m_changed_margin_so_call_value;            }
   bool              IsIncreaseMarginCall(void)                                                       const { return this.m_is_change_margin_so_call_inc;            }
   bool              IsDecreaseMarginCall(void)                                                       const { return this.m_is_change_margin_so_call_dec;            }
   //--- Margin StopOut:
   //--- getting (1) Margin StopOut change value, (2) increase flag, (3) decrease flag
   double            GetValueChangedMarginStopOut(void)                                               const { return this.m_changed_margin_so_so_value;              }
   bool              IsIncreaseMarginStopOut(void)                                                    const { return this.m_is_change_margin_so_so_inc;              }
   bool              IsDecreasMarginStopOute(void)                                                    const { return this.m_is_change_margin_so_so_dec;              }
   //--- Guarantee sum for pending orders:
   //--- setting the tracked value of the reserved funds for providing the guarantee sum for pending orders (1) growth, (2) decrease
   //--- getting the change value of the (3) reserved funds for providing the guarantee sum,
   //--- getting the flag of the reserved funds for providing the guarantee sum for pending orders exceeding the (4) growth, (5) decrease value
   void              SetControlMarginInitialInc(const double value)                                         { this.m_control_margin_initial_inc=::fabs(value);       }
   void              SetControlMarginInitialDec(const double value)                                         { this.m_control_margin_initial_dec=::fabs(value);       }
   double            GetValueChangedMarginInitial(void)                                               const { return this.m_changed_margin_initial_value;            }
   bool              IsIncreaseMarginInitial(void)                                                    const { return this.m_is_change_margin_initial_inc;            }
   bool              IsDecreaseMarginInitial(void)                                                    const { return this.m_is_change_margin_initial_dec;            }
   //--- Guarantee sum for open positions:
   //--- setting the tracked value of the funds reserved on an account to ensure a minimum amount for all open positions (1) growth, (2) decrease
   //--- getting the change value of the (3) reserved funds for providing the guarantee sum,
   //--- getting the flag of the reserved funds for providing the guarantee sum for pending orders exceeding the (4) growth, (5) decrease value
   void              SetControlMarginMaintenanceInc(const double value)                                     { this.m_control_margin_maintenance_inc=::fabs(value);   }
   void              SetControlMarginMaintenanceDec(const double value)                                     { this.m_control_margin_maintenance_dec=::fabs(value);   }
   double            GetValueChangedMarginMaintenance(void)                                           const { return this.m_changed_margin_maintenance_value;        }
   bool              IsIncreaseMarginMaintenance(void)                                                const { return this.m_is_change_margin_maintenance_inc;        }
   bool              IsDecreaseMarginMaintenance(void)                                                const { return this.m_is_change_margin_maintenance_dec;        }
   //--- Assets:
   //--- setting the tracked value of the assets (1) growth, (2) decrease
   //--- getting (3) the assets change value,
   //--- getting the flag of the change exceeding the (4) growth, (5) decrease value
   void              SetControlAssetsInc(const double value)                                                { this.m_control_assets_inc=::fabs(value);               }
   void              SetControlAssetsDec(const double value)                                                { this.m_control_assets_dec=::fabs(value);               }
   double            GetValueChangedAssets(void)                                                      const { return this.m_changed_assets_value;                    }
   bool              IsIncreaseAssets(void)                                                           const { return this.m_is_change_assets_inc;                    }
   bool              IsDecreaseAssets(void)                                                           const { return this.m_is_change_assets_dec;                    }
   //--- Liabilities:
   //--- setting the tracked value of the liabilities (1) growth, (2) decrease
   //--- getting (3) the liabilities change value,
   //--- getting the flag of the liabilities change exceeding the (4) growth, (5) decrease value
   void              SetControlLiabilitiesInc(const double value)                                           { this.m_control_liabilities_inc=::fabs(value);          }
   void              SetControlLiabilitiesDec(const double value)                                           { this.m_control_liabilities_dec=::fabs(value);          }
   double            GetValueChangedLiabilities(void)                                                 const { return this.m_changed_liabilities_value;               }
   bool              IsIncreaseLiabilities(void)                                                      const { return this.m_is_change_liabilities_inc;               }
   bool              IsDecreaseLiabilities(void)                                                      const { return this.m_is_change_liabilities_dec;               }
   //--- Blocked commissions:
   //--- setting the tracked blocked commissions (1) growth, (2) decrease value
   //--- getting (3) the blocked commissions change value,
   //--- getting the flag of the tracked commissions change exceeding the (4) growth, (5) decrease value
   void              SetControlComissionBlockedInc(const double value)                                      { this.m_control_comission_blocked_inc=::fabs(value);    }
   void              SetControlComissionBlockedDec(const double value)                                      { this.m_control_comission_blocked_dec=::fabs(value);    }
   double            GetValueChangedComissionBlocked(void)                                            const { return this.m_changed_comission_blocked_value;         }
   bool              IsIncreaseComissionBlocked(void)                                                 const { return this.m_is_change_comission_blocked_inc;         }
   bool              IsDecreaseComissionBlocked(void)                                                 const { return this.m_is_change_comission_blocked_dec;         }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccountsCollection::CAccountsCollection(void) : m_folder_name(DIRECTORY+"Accounts"),
                                                 m_is_account_event(false),
                                                 m_symbol(::Symbol()),
                                                 m_chart_id(::ChartID())
  {
   this.m_list_accounts.Clear();
   this.m_list_accounts.Sort(SORT_BY_ACCOUNT_LOGIN);
   this.m_list_accounts.Type(COLLECTION_ACCOUNT_ID);
   ::ZeroMemory(this.m_struct_prev_account);
   ::ZeroMemory(this.m_tick);
   this.InitChangesParams();
   this.InitControlsParams();
//--- Create the folder for storing account files
   ::ResetLastError();
   if(!::FolderCreate(this.m_folder_name,FILE_COMMON))
      ::Print(DFUN,TextByLanguage("Не удалось создать папку хранения файлов. Ошибка ","Could not create file storage folder. Error "),::GetLastError());
//--- Create the current account object and add it to the list
   CAccount* account=new CAccount();
   if(account!=NULL)
     {
      if(!this.AddToList(account))
        {
         ::Print(DFUN_ERR_LINE,TextByLanguage("Ошибка. Не удалось добавить текущий объект-аккаунт в список-коллекцию.","Error. Failed to add current account object to collection list."));
         delete account;
        }
      else
         account.PrintShort();
     }
   else
      ::Print(DFUN,TextByLanguage("Ошибка. Не удалось создать объект-аккаунт с данными текущего счёта.","Error. Failed to create an account object with current account data."));

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
   this.m_is_account_event=false;
   if(this.m_index_current==WRONG_VALUE)
      return;
   CAccount* account=this.m_list_accounts.At(this.m_index_current);
   if(account==NULL)
      return;
   ::ZeroMemory(this.m_struct_curr_account);
   this.SetAccountsParams(account);
   
//--- First launch
   if(!this.m_struct_prev_account.login)
     {
      this.m_struct_prev_account=this.m_struct_curr_account;
      return;
     }
//--- If the account hash sum changed
   if(this.m_struct_curr_account.hash_sum!=this.m_struct_prev_account.hash_sum)
     {
      this.m_change_code=this.SetChangeCode();
      this.SetTypeEvent();
      int total=this.m_list_changes.Total();
      if(total>0)
        {
         this.m_is_account_event=true;
         for(int i=0;i<total;i++)
           {
            ENUM_ACCOUNT_EVENT event=this.GetEvent(i);
            if(event==NULL || !::SymbolInfoTick(this.m_symbol,this.m_tick))
               continue;
            string sparam=TimeMSCtoString(this.m_tick.time_msc)+": "+this.EventDescription(event);
            Print(sparam);
            ::EventChartCustom(this.m_chart_id,(ushort)event,this.m_tick.time_msc,(double)i,sparam);
           }
        }
      this.m_struct_prev_account.hash_sum=this.m_struct_curr_account.hash_sum;
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
//| Check account changes, return a change code                      |
//+------------------------------------------------------------------+
int CAccountsCollection::SetChangeCode(void)
  {
   this.m_change_code=ACCOUNT_EVENT_FLAG_NO_EVENT;
   
   if(this.m_struct_curr_account.trade_allowed!=this.m_struct_prev_account.trade_allowed)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_TRADE_ALLOWED;
   if(this.m_struct_curr_account.trade_expert!=this.m_struct_prev_account.trade_expert)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_TRADE_EXPERT;
   if(this.m_struct_curr_account.leverage-this.m_struct_prev_account.leverage!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_LEVERAGE;
   if(this.m_struct_curr_account.limit_orders-this.m_struct_prev_account.limit_orders!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_LIMIT_ORDERS;
   if(this.m_struct_curr_account.balance-this.m_struct_prev_account.balance!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_BALANCE;
   if(this.m_struct_curr_account.credit-this.m_struct_prev_account.credit!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_CREDIT;
   if(this.m_struct_curr_account.profit-this.m_struct_prev_account.profit!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_PROFIT;
   if(this.m_struct_curr_account.equity-this.m_struct_prev_account.equity!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_EQUITY;
   if(this.m_struct_curr_account.margin-this.m_struct_prev_account.margin!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN;
   if(this.m_struct_curr_account.margin_free-this.m_struct_prev_account.margin_free!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_FREE;
   if(this.m_struct_curr_account.margin_level-this.m_struct_prev_account.margin_level!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_LEVEL;
   if(this.m_struct_curr_account.margin_so_call-this.m_struct_prev_account.margin_so_call!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_SO_CALL;
   if(this.m_struct_curr_account.margin_so_so-this.m_struct_prev_account.margin_so_so!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_SO_SO;
   if(this.m_struct_curr_account.margin_initial-this.m_struct_prev_account.margin_initial!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_INITIAL;
   if(this.m_struct_curr_account.margin_maintenance-this.m_struct_prev_account.margin_maintenance!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_MARGIN_MAINTENANCE;
   if(this.m_struct_curr_account.assets-this.m_struct_prev_account.assets!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_ASSETS;
   if(this.m_struct_curr_account.liabilities-this.m_struct_prev_account.liabilities!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_LIABILITIES;
   if(this.m_struct_curr_account.comission_blocked-this.m_struct_prev_account.comission_blocked!=0)
      this.m_change_code+=ACCOUNT_EVENT_FLAG_COMISSION_BLOCKED;
//---
   return this.m_change_code;
  }
//+------------------------------------------------------------------+
//| Set the account object event type                                |
//+------------------------------------------------------------------+
void CAccountsCollection::SetTypeEvent(void)
  {
   this.InitChangesParams();
   ENUM_ACCOUNT_EVENT event=ACCOUNT_EVENT_NO_EVENT;
//--- Changing permission to trade for the account
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_TRADE_ALLOWED))
     {
      if(!this.m_struct_curr_account.trade_allowed)
        {
         this.m_is_change_trade_allowed_off=true;
         event=ACCOUNT_EVENT_TRADE_ALLOWED_OFF;
         this.m_struct_prev_account.trade_allowed=this.m_struct_curr_account.trade_allowed;
        }
      else
        {
         this.m_is_change_trade_allowed_on=true;
         event=ACCOUNT_EVENT_TRADE_ALLOWED_ON;
         this.m_struct_prev_account.trade_allowed=this.m_struct_curr_account.trade_allowed;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE)
         this.m_list_changes.Add(event);
     }
//--- Changing permission for auto trading for the account
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_TRADE_EXPERT))
     {
      if(!this.m_struct_curr_account.trade_expert)
        {
         this.m_is_change_trade_expert_off=true;
         event=ACCOUNT_EVENT_TRADE_EXPERT_OFF;
         this.m_struct_prev_account.trade_expert=false;
        }
      else
        {
         this.m_is_change_trade_expert_on=true;
         event=ACCOUNT_EVENT_TRADE_EXPERT_ON;
         this.m_struct_prev_account.trade_expert=true;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE)
         this.m_list_changes.Add(event);
     }
//--- Change the leverage
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_LEVERAGE))
     {
      this.m_changed_leverage_value=this.m_struct_curr_account.leverage-this.m_struct_prev_account.leverage;
      if(this.m_changed_leverage_value>0)
        {
         this.m_is_change_leverage_inc=true;
         event=ACCOUNT_EVENT_LEVERAGE_INC;
        }
      else
        {
         this.m_is_change_leverage_dec=true;
         event=ACCOUNT_EVENT_LEVERAGE_DEC;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
         this.m_struct_prev_account.leverage=this.m_struct_curr_account.leverage;
     }
//--- Changing permission for auto trading for the account
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_LIMIT_ORDERS))
     {
      this.m_changed_limit_orders_value=this.m_struct_curr_account.limit_orders-this.m_struct_prev_account.limit_orders;
      if(this.m_changed_limit_orders_value>0)
        {
         this.m_is_change_limit_orders_inc=true;
         event=ACCOUNT_EVENT_LIMIT_ORDERS_INC;
        }
      else
        {
         this.m_is_change_limit_orders_dec=true;
         event=ACCOUNT_EVENT_LIMIT_ORDERS_DEC;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
         this.m_struct_prev_account.limit_orders=this.m_struct_curr_account.limit_orders;
     }
//--- Change a credit in a deposit currency
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_CREDIT))
     {
      this.m_changed_credit_value=this.m_struct_curr_account.credit-this.m_struct_prev_account.credit;
      if(this.m_changed_credit_value>0)
        {
         this.m_is_change_credit_inc=true;
         event=ACCOUNT_EVENT_CREDIT_INC;
        }
      else
        {
         this.m_is_change_credit_dec=true;
         event=ACCOUNT_EVENT_CREDIT_DEC;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
         this.m_struct_prev_account.credit=this.m_struct_curr_account.credit;
     }
//--- Changing the Margin Call level
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_SO_CALL))
     {
      this.m_changed_margin_so_call_value=this.m_struct_curr_account.margin_so_call-this.m_struct_prev_account.margin_so_call;
      if(this.m_changed_margin_so_call_value>0)
        {
         this.m_is_change_margin_so_call_inc=true;
         event=ACCOUNT_EVENT_MARGIN_SO_CALL_INC;
        }
      else
        {
         this.m_is_change_margin_so_call_dec=true;
         event=ACCOUNT_EVENT_MARGIN_SO_CALL_DEC;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
         this.m_struct_prev_account.margin_so_call=this.m_struct_curr_account.margin_so_call;
     }
//--- Changing the Stop Out level
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_SO_SO))
     {
      this.m_changed_margin_so_so_value=this.m_struct_curr_account.margin_so_so-this.m_struct_prev_account.margin_so_so;
      if(this.m_changed_margin_so_so_value>0)
        {
         this.m_is_change_margin_so_so_inc=true;
         event=ACCOUNT_EVENT_MARGIN_SO_SO_INC;
        }
      else
        {
         this.m_is_change_margin_so_so_dec=true;
         event=ACCOUNT_EVENT_MARGIN_SO_SO_DEC;
        }
      if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
         this.m_struct_prev_account.margin_so_so=this.m_struct_curr_account.margin_so_so;
     }
//--- The balance exceeds the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_BALANCE))
     {
      this.m_changed_balance_value=this.m_struct_curr_account.balance-this.m_struct_prev_account.balance;
      if(this.m_changed_balance_value>this.m_control_balance_inc)
        {
         this.m_is_change_balance_inc=true;
         event=ACCOUNT_EVENT_BALANCE_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.balance=this.m_struct_curr_account.balance;
        }
      else if(this.m_changed_balance_value<-this.m_control_balance_dec)
        {
         this.m_is_change_balance_dec=true;
         event=ACCOUNT_EVENT_BALANCE_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.balance=this.m_struct_curr_account.balance;
        }
     }
//--- The profit exceeds the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_PROFIT))
     {
      this.m_changed_profit_value=this.m_struct_curr_account.profit-this.m_struct_prev_account.profit;
      if(this.m_changed_profit_value>this.m_control_profit_inc)
        {
         this.m_is_change_profit_inc=true;
         event=ACCOUNT_EVENT_PROFIT_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.profit=this.m_struct_curr_account.profit;
        }
      else if(this.m_changed_profit_value<-this.m_control_profit_dec)
        {
         this.m_is_change_profit_dec=true;
         event=ACCOUNT_EVENT_PROFIT_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.profit=this.m_struct_curr_account.profit;
        }
     }
//--- The equity exceeds the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_EQUITY))
     {
      this.m_changed_equity_value=this.m_struct_curr_account.equity-this.m_struct_prev_account.equity;
      if(this.m_changed_equity_value>this.m_control_equity_inc)
        {
         this.m_is_change_equity_inc=true;
         event=ACCOUNT_EVENT_EQUITY_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.equity=this.m_struct_curr_account.equity;
        }
      else if(this.m_changed_equity_value<-this.m_control_equity_dec)
        {
         this.m_is_change_equity_dec=true;
         event=ACCOUNT_EVENT_EQUITY_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.equity=this.m_struct_curr_account.equity;
        }
     }
//--- The reserved margin on an account in the deposit currency change exceeds the specified value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN))
     {
      this.m_changed_margin_value=this.m_struct_curr_account.margin-this.m_struct_prev_account.margin;
      if(this.m_changed_margin_value>this.m_control_margin_inc)
        {
         this.m_is_change_margin_inc=true;
         event=ACCOUNT_EVENT_MARGIN_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin=this.m_struct_curr_account.margin;
        }
      else if(this.m_changed_margin_value<-this.m_control_margin_dec)
        {
         this.m_is_change_margin_dec=true;
         event=ACCOUNT_EVENT_MARGIN_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin=this.m_struct_curr_account.margin;
        }
     }
//--- The free funds available for opening a position in a deposit currency exceed the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_FREE))
     {
      this.m_changed_margin_free_value=this.m_struct_curr_account.margin_free-this.m_struct_prev_account.margin_free;
      if(this.m_changed_margin_free_value>this.m_control_margin_free_inc)
        {
         this.m_is_change_margin_free_inc=true;
         event=ACCOUNT_EVENT_MARGIN_FREE_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_free=this.m_struct_curr_account.margin_free;
        }
      else if(this.m_changed_margin_free_value<-this.m_control_margin_free_dec)
        {
         this.m_is_change_margin_free_dec=true;
         event=ACCOUNT_EVENT_MARGIN_FREE_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_free=this.m_struct_curr_account.margin_free;
        }
     }
//--- The margin level on an account in % exceeds the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_LEVEL))
     {
      this.m_changed_margin_level_value=this.m_struct_curr_account.margin_level-this.m_struct_prev_account.margin_level;
      if(this.m_changed_margin_level_value>this.m_control_margin_level_inc)
        {
         this.m_is_change_margin_level_inc=true;
         event=ACCOUNT_EVENT_MARGIN_LEVEL_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_level=this.m_struct_curr_account.margin_level;
        }
      else if(this.m_changed_margin_level_value<-this.m_control_margin_level_dec)
        {
         this.m_is_change_margin_level_dec=true;
         event=ACCOUNT_EVENT_MARGIN_LEVEL_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_level=this.m_struct_curr_account.margin_level;
        }
     }
//--- The funds reserved on an account to ensure a guarantee amount for all pending orders exceed the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_INITIAL))
     {
      this.m_changed_margin_initial_value=this.m_struct_curr_account.margin_initial-this.m_struct_prev_account.margin_initial;
      if(this.m_changed_margin_initial_value>this.m_control_margin_initial_inc)
        {
         this.m_is_change_margin_initial_inc=true;
         event=ACCOUNT_EVENT_MARGIN_INITIAL_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_initial=this.m_struct_curr_account.margin_initial;
        }
      else if(this.m_changed_margin_initial_value<-this.m_control_margin_initial_dec)
        {
         this.m_is_change_margin_initial_dec=true;
         event=ACCOUNT_EVENT_MARGIN_INITIAL_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_initial=this.m_struct_curr_account.margin_initial;
        }
     }
//--- The funds reserved on an account to ensure a minimum amount for all open positions exceed the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_MARGIN_MAINTENANCE))
     {
      this.m_changed_margin_maintenance_value=this.m_struct_curr_account.margin_maintenance-this.m_struct_prev_account.margin_maintenance;
      if(this.m_changed_margin_maintenance_value>this.m_control_margin_maintenance_inc)
        {
         this.m_is_change_margin_maintenance_inc=true;
         event=ACCOUNT_EVENT_MARGIN_MAINTENANCE_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_maintenance=this.m_struct_curr_account.margin_maintenance;
        }
      else if(this.m_changed_margin_maintenance_value<-this.m_control_margin_maintenance_dec)
        {
         this.m_is_change_margin_maintenance_dec=true;
         event=ACCOUNT_EVENT_MARGIN_MAINTENANCE_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.margin_maintenance=this.m_struct_curr_account.margin_maintenance;
        }
     }
//--- The current assets on an account exceed the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_ASSETS))
     {
      this.m_changed_assets_value=this.m_struct_curr_account.assets-this.m_struct_prev_account.assets;
      if(this.m_changed_assets_value>this.m_control_assets_inc)
        {
         this.m_is_change_assets_inc=true;
         event=ACCOUNT_EVENT_ASSETS_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.assets=this.m_struct_curr_account.assets;
        }
      else if(this.m_changed_assets_value<-this.m_control_assets_dec)
        {
         this.m_is_change_assets_dec=true;
         event=ACCOUNT_EVENT_ASSETS_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.assets=this.m_struct_curr_account.assets;
        }
     }
//--- The current liabilities on an account exceed the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_LIABILITIES))
     {
      this.m_changed_liabilities_value=this.m_struct_curr_account.liabilities-this.m_struct_prev_account.liabilities;
      if(this.m_changed_liabilities_value>this.m_control_liabilities_inc)
        {
         this.m_is_change_liabilities_inc=true;
         event=ACCOUNT_EVENT_LIABILITIES_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.liabilities=this.m_struct_curr_account.liabilities;
        }
      else if(this.m_changed_liabilities_value<-this.m_control_liabilities_dec)
        {
         this.m_is_change_liabilities_dec=true;
         event=ACCOUNT_EVENT_LIABILITIES_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.liabilities=this.m_struct_curr_account.liabilities;
        }
     }
//--- The current sum of blocked commissions on an account exceeds the specified change value +/-
   if(this.IsPresentEventFlag(ACCOUNT_EVENT_FLAG_COMISSION_BLOCKED))
     {
      this.m_changed_comission_blocked_value=this.m_struct_curr_account.comission_blocked-this.m_struct_prev_account.comission_blocked;
      if(this.m_changed_comission_blocked_value>this.m_control_comission_blocked_inc)
        {
         this.m_is_change_comission_blocked_inc=true;
         event=ACCOUNT_EVENT_COMISSION_BLOCKED_INC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.comission_blocked=this.m_struct_curr_account.comission_blocked;
        }
      else if(this.m_changed_comission_blocked_value<-this.m_control_comission_blocked_dec)
        {
         this.m_is_change_comission_blocked_dec=true;
         event=ACCOUNT_EVENT_COMISSION_BLOCKED_DEC;
         if(this.m_list_changes.Search(event)==WRONG_VALUE && this.m_list_changes.Add(event))
            this.m_struct_prev_account.comission_blocked=this.m_struct_curr_account.comission_blocked;
        }
     }
  }
//+------------------------------------------------------------------+
//| Return the account event by its number in the list               |
//+------------------------------------------------------------------+
ENUM_ACCOUNT_EVENT CAccountsCollection::GetEvent(const int shift=WRONG_VALUE)
  {
   int total=this.m_list_changes.Total();
   if(total==0)
      return ACCOUNT_EVENT_NO_EVENT;   
   int index=(shift<=0 ? total-1 : shift>total-1 ? 0 : total-shift-1);
   int event=this.m_list_changes.At(index);
   return ENUM_ACCOUNT_EVENT(event!=NULL ? event : ACCOUNT_EVENT_NO_EVENT);
  }
//+------------------------------------------------------------------+
//| Return the account event description                             |
//+------------------------------------------------------------------+
string CAccountsCollection::EventDescription(const ENUM_ACCOUNT_EVENT event)
  {
   int total=this.m_list_accounts.Total();
   if(total==0)
      return(DFUN+TextByLanguage("Ошибка. Список изменений пуст","Error. List of changes is empty"));
   CAccount* account=this.m_list_accounts.At(this.m_index_current);
   if(account==NULL)
      return(DFUN+TextByLanguage("Ошибка. Не удалось получить данные аккаунта","Error. Failed to get account data"));
   const int dg=(account.MarginSOMode()==ACCOUNT_STOPOUT_MODE_MONEY ? (int)account.CurrencyDigits() : 2);
   const string curency=" "+account.Currency();
   const string mode_lev=(account.IsPercentsForSOLevels() ? "%" : " "+curency);
   return
     (
      event==ACCOUNT_EVENT_NO_EVENT                ? TextByLanguage("Нет события","No event")                                                                                                                                                                     :
      event==ACCOUNT_EVENT_TRADE_ALLOWED_ON        ? TextByLanguage("Торговля на счёте разрешена","Trading on account allowed now")                                                                                                                        :
      event==ACCOUNT_EVENT_TRADE_ALLOWED_OFF       ? TextByLanguage("Торговля на счёте запрещена","Trading on account prohibited now")                                                                                                                     :
      event==ACCOUNT_EVENT_TRADE_EXPERT_ON         ? TextByLanguage("Автоторговля на счёте разрешена","Autotrading on account allowed now")                                                                                                                :
      event==ACCOUNT_EVENT_TRADE_EXPERT_OFF        ? TextByLanguage("Автоторговля на счёте запрещена","Autotrade on account prohibited now")                                                                                                               :
      event==ACCOUNT_EVENT_LEVERAGE_INC            ?
         TextByLanguage("Плечо увеличено на ","Leverage increased by ")+(string)this.GetValueChangedLeverage()+" (1:"+(string)account.Leverage()+")"                                                                                                              :
      event==ACCOUNT_EVENT_LEVERAGE_DEC            ?
         TextByLanguage("Плечо уменьшено на ","Leverage decreased by ")+(string)this.GetValueChangedLeverage()+" (1:"+(string)account.Leverage()+")"                                                                                                              :
      event==ACCOUNT_EVENT_LIMIT_ORDERS_INC        ?
         TextByLanguage("Максимально допустимое количество действующих отложенных ордеров увеличено на","Maximum allowable number of active pending orders increased by ")+(string)this.GetValueChangedLimitOrders()+" ("+(string)account.LimitOrders()+")"       :
      event==ACCOUNT_EVENT_LIMIT_ORDERS_DEC        ?
         TextByLanguage("Максимально допустимое количество действующих отложенных ордеров уменьшено на","Maximum allowable number of active pending orders decreased by ")+(string)this.GetValueChangedLimitOrders()+" ("+(string)account.LimitOrders()+")"       :
      event==ACCOUNT_EVENT_BALANCE_INC             ?
         TextByLanguage("Баланс счёта увеличен на ","Account balance increased by ")+::DoubleToString(this.GetValueChangedBalance(),dg)+curency+" ("+::DoubleToString(account.Balance(),dg)+curency+")"                                                           :
      event==ACCOUNT_EVENT_BALANCE_DEC             ?
         TextByLanguage("Баланс счёта уменьшен на ","Account balance decreased by ")+::DoubleToString(this.GetValueChangedBalance(),dg)+curency+" ("+::DoubleToString(account.Balance(),dg)+curency+")"                                                           :
      event==ACCOUNT_EVENT_EQUITY_INC              ?
         TextByLanguage("Средства увеличены на ","Equity increased by ")+::DoubleToString(this.GetValueChangedEquity(),dg)+curency+" ("+::DoubleToString(account.Equity(),dg)+curency+")"                                                                         :
      event==ACCOUNT_EVENT_EQUITY_DEC              ?
         TextByLanguage("Средства уменьшены на ","Equity decreased by ")+::DoubleToString(this.GetValueChangedEquity(),dg)+curency+" ("+::DoubleToString(account.Equity(),dg)+curency+")"                                                                         :
      event==ACCOUNT_EVENT_PROFIT_INC              ?
         TextByLanguage("Текущая прибыль счёта увеличена на ","Account current profit increased by ")+::DoubleToString(this.GetValueChangedProfit(),dg)+curency+" ("+::DoubleToString(account.Profit(),dg)+curency+")"                                            :
      event==ACCOUNT_EVENT_PROFIT_DEC              ?
         TextByLanguage("Текущая прибыль счёта уменьшена на ","Account current profit decreased by ")+::DoubleToString(this.GetValueChangedProfit(),dg)+curency+" ("+::DoubleToString(account.Profit(),dg)+curency+")"                                            :
      event==ACCOUNT_EVENT_CREDIT_INC              ?
         TextByLanguage("Предоставленный кредит увеличен на ","Credit increased by ")+::DoubleToString(this.GetValueChangedCredit(),dg)+curency+" ("+::DoubleToString(account.Credit(),dg)+curency+")"                                                            :
      event==ACCOUNT_EVENT_CREDIT_DEC              ?
         TextByLanguage("Предоставленный кредит уменьшен на ","Credit decreased by ")+::DoubleToString(this.GetValueChangedCredit(),dg)+curency+" ("+::DoubleToString(account.Credit(),dg)+curency+")"                                                            :
      event==ACCOUNT_EVENT_MARGIN_INC              ?
         TextByLanguage("Залоговые средства увеличены на ","Margin increased by ")+::DoubleToString(this.GetValueChangedMargin(),dg)+curency+" ("+::DoubleToString(account.Margin(),dg)+curency+")"                                                               :
      event==ACCOUNT_EVENT_MARGIN_DEC              ?
         TextByLanguage("Залоговые средства уменьшены на ","Margin decreased by ")+::DoubleToString(this.GetValueChangedMargin(),dg)+curency+" ("+::DoubleToString(account.Margin(),dg)+curency+")"                                                               :
      event==ACCOUNT_EVENT_MARGIN_FREE_INC         ?
         TextByLanguage("Свободные средства увеличены на ","Free margin increased by ")+::DoubleToString(this.GetValueChangedMarginFree(),dg)+curency+" ("+::DoubleToString(account.MarginFree(),dg)+curency+")"                                                  :
      event==ACCOUNT_EVENT_MARGIN_FREE_DEC         ?
         TextByLanguage("Свободные средства уменьшены на ","Free margin decreased by ")+::DoubleToString(this.GetValueChangedMarginFree(),dg)+curency+" ("+::DoubleToString(account.MarginFree(),dg)+curency+")"                                                  :
      event==ACCOUNT_EVENT_MARGIN_LEVEL_INC        ?
         TextByLanguage("Уровень залоговых средств увеличен на ","Margin level increased by ")+::DoubleToString(this.GetValueChangedMarginLevel(),dg)+"%"+" ("+::DoubleToString(account.MarginLevel(),dg)+"%)"                                                    :
      event==ACCOUNT_EVENT_MARGIN_LEVEL_DEC        ?
         TextByLanguage("Уровень залоговых средств уменьшен на ","Margin level decreased by ")+::DoubleToString(this.GetValueChangedMarginLevel(),dg)+"%"+" ("+::DoubleToString(account.MarginLevel(),dg)+"%)"                                                    :
      event==ACCOUNT_EVENT_MARGIN_INITIAL_INC      ?
         TextByLanguage("Гарантийная сумма по отложенным ордерам увеличена на ","Guarantee sum for pending orders increased by ")+::DoubleToString(this.GetValueChangedMarginInitial(),dg)+curency+" ("+::DoubleToString(account.MarginInitial(),dg)+curency+")" :
      event==ACCOUNT_EVENT_MARGIN_INITIAL_DEC      ?
         TextByLanguage("Гарантийная сумма по отложенным ордерам уменьшена на ","Guarantee sum for pending orders decreased by ")+::DoubleToString(this.GetValueChangedMarginInitial(),dg)+curency+" ("+::DoubleToString(account.MarginInitial(),dg)+curency+")" :
      event==ACCOUNT_EVENT_MARGIN_MAINTENANCE_INC  ?
         TextByLanguage("Гарантийная сумма по позициям увеличена на ","Guarantee sum for positions increased by ")+::DoubleToString(this.GetValueChangedMarginMaintenance(),dg)+curency+" ("+::DoubleToString(account.MarginMaintenance(),dg)+curency+")"        :
      event==ACCOUNT_EVENT_MARGIN_MAINTENANCE_DEC  ?
         TextByLanguage("Гарантийная сумма по позициям уменьшена на ","Guarantee sum for positions decreased by ")+::DoubleToString(this.GetValueChangedMarginMaintenance(),dg)+curency+" ("+::DoubleToString(account.MarginMaintenance(),dg)+curency+")"        :
      event==ACCOUNT_EVENT_MARGIN_SO_CALL_INC      ?
         TextByLanguage("Увеличен уровень Margin Call на ","Increased Margin Call level by ")+::DoubleToString(this.GetValueChangedMarginCall(),dg)+mode_lev+" ("+::DoubleToString(account.MarginSOCall(),dg)+mode_lev+")"                                        :
      event==ACCOUNT_EVENT_MARGIN_SO_CALL_DEC      ?
         TextByLanguage("Уменьшен уровень Margin Call на ","Decreased Margin Call level by ")+::DoubleToString(this.GetValueChangedMarginCall(),dg)+mode_lev+" ("+::DoubleToString(account.MarginSOCall(),dg)+mode_lev+")"                                        :
      event==ACCOUNT_EVENT_MARGIN_SO_SO_INC        ?
         TextByLanguage("Увеличен уровень Stop Out на ","Increased Margin Stop Out level by ")+::DoubleToString(this.GetValueChangedMarginStopOut(),dg)+mode_lev+" ("+::DoubleToString(account.MarginSOSO(),dg)+mode_lev+")"                                      :
      event==ACCOUNT_EVENT_MARGIN_SO_SO_DEC        ?
         TextByLanguage("Уменьшен уровень Stop Out на ","Decreased Margin Stop Out level by ")+::DoubleToString(this.GetValueChangedMarginStopOut(),dg)+mode_lev+" ("+::DoubleToString(account.MarginSOSO(),dg)+mode_lev+")"                                      :
      event==ACCOUNT_EVENT_ASSETS_INC              ?
         TextByLanguage("Размер активов увеличен на ","Assets increased by ")+::DoubleToString(this.GetValueChangedAssets(),dg)+" ("+::DoubleToString(account.Assets(),dg)+")"                                                                                    :
      event==ACCOUNT_EVENT_ASSETS_DEC              ?
         TextByLanguage("Размер активов уменьшен на ","Assets decreased by ")+::DoubleToString(this.GetValueChangedAssets(),dg)+" ("+::DoubleToString(account.Assets(),dg)+")"                                                                                    :
      event==ACCOUNT_EVENT_LIABILITIES_INC         ?
         TextByLanguage("Размер обязательств увеличен на ","Liabilities increased by ")+::DoubleToString(this.GetValueChangedLiabilities(),dg)+" ("+::DoubleToString(account.Liabilities(),dg)+")"                                                                :
      event==ACCOUNT_EVENT_LIABILITIES_DEC         ?
         TextByLanguage("Размер обязательств уменьшен на ","Liabilities decreased by ")+::DoubleToString(this.GetValueChangedLiabilities(),dg)+" ("+::DoubleToString(account.Liabilities(),dg)+")"                                                                :
      event==ACCOUNT_EVENT_COMISSION_BLOCKED_INC   ?
         TextByLanguage("Размер заблокированных комиссий увеличен на ","Blocked comissions increased by ")+::DoubleToString(this.GetValueChangedComissionBlocked(),dg)+" ("+::DoubleToString(account.ComissionBlocked(),dg)+")"                                   :
      event==ACCOUNT_EVENT_COMISSION_BLOCKED_DEC   ?
         TextByLanguage("Размер заблокированных комиссий уменьшен на ","Blocked comissions decreased by ")+::DoubleToString(this.GetValueChangedComissionBlocked(),dg)+" ("+::DoubleToString(account.ComissionBlocked(),dg)+")"                                   :
      ::EnumToString(event)
     );
  }
//+------------------------------------------------------------------+
//| Initialize the variables of tracked account data                 |
//+------------------------------------------------------------------+
void CAccountsCollection::InitChangesParams(void)
  {
//--- List and code of changes
   this.m_list_changes.Clear();                    // Clear the change list
   this.m_list_changes.Sort();                     // Sort the change list
//--- Leverage
   this.m_changed_leverage_value=0;                // Leverage change value
   this.m_is_change_leverage_inc=false;            // Leverage increase flag
   this.m_is_change_leverage_dec=false;            // Leverage decrease flag
//--- Number of active pending orders
   this.m_changed_limit_orders_value=0;            // Change value of the maximum allowed number of active pending orders
   this.m_is_change_limit_orders_inc=false;        // Increase flag of the maximum allowed number of active pending orders
   this.m_is_change_limit_orders_dec=false;        // Decrease flag of the maximum allowed number of active pending orders
//--- Trading on an account
   this.m_is_change_trade_allowed_on=false;        // The flag allowing to trade for the current account from the server side
   this.m_is_change_trade_allowed_off=false;       // The flag prohibiting trading for the current account from the server side
//--- Auto trading on an account
   this.m_is_change_trade_expert_on=false;         // The flag allowing to trade for an EA from the server side
   this.m_is_change_trade_expert_off=false;        // The flag prohibiting trading for an EA from the server side
//--- Balance
   this.m_changed_balance_value=0;                 // Balance change value
   this.m_is_change_balance_inc=false;             // The flag of the balance change exceeding the growth value
   this.m_is_change_balance_dec=false;             // The flag of the balance change exceeding the decrease value
//--- Credit
   this.m_changed_credit_value=0;                  // Credit change value
   this.m_is_change_credit_inc=false;              // Credit increase flag
   this.m_is_change_credit_dec=false;              // Credit decrease flag
//--- Profit
   this.m_changed_profit_value=0;                  // Profit change value
   this.m_is_change_profit_inc=false;              // The flag of the profit change exceeding the growth value
   this.m_is_change_profit_dec=false;              // The flag of the profit change exceeding the decrease value
//--- Funds (equity)
   this.m_changed_equity_value=0;                  // Funds change value
   this.m_is_change_equity_inc=false;              // The flag of the funds change exceeding the growth value
   this.m_is_change_equity_dec=false;              // The flag of the funds change exceeding the decrease value
//--- Margin
   this.m_changed_margin_value=0;                  // Margin change value
   this.m_is_change_margin_inc=false;              // The flag of the margin change exceeding the growth value
   this.m_is_change_margin_dec=false;              // The flag of the margin change exceeding the decrease value
//--- Free margin
   this.m_changed_margin_free_value=0;             // Free margin change value
   this.m_is_change_margin_free_inc=false;         // The flag of the free margin change exceeding the growth value
   this.m_is_change_margin_free_dec=false;         // The flag of the free margin change exceeding the decrease value
//--- Margin level
   this.m_changed_margin_level_value=0;            // Margin level change value
   this.m_is_change_margin_level_inc=false;        // The flag of the margin level change exceeding the growth value
   this.m_is_change_margin_level_dec=false;        // The flag of the margin level change exceeding the decrease value
//--- Margin Call level
   this.m_changed_margin_so_call_value=0;          // Margin Call level change value
   this.m_is_change_margin_so_call_inc=false;      // Margin Call level increase flag
   this.m_is_change_margin_so_call_dec=false;      // Margin Call level decrease flag
//--- Margin StopOut level
   this.m_changed_margin_so_so_value=0;            //  Margin StopOut level change value
   this.m_is_change_margin_so_so_inc=false;        // Margin StopOut level increase flag
   this.m_is_change_margin_so_so_dec=false;        // Margin StopOut level decrease flag
//--- Guarantee sum for pending orders
   this.m_changed_margin_initial_value=0;          // The change value of the reserved funds for providing the guarantee sum for pending orders
   this.m_is_change_margin_initial_inc=false;      // The flag of the reserved funds for providing the guarantee sum for pending orders exceeding the growth value
   this.m_is_change_margin_initial_dec=false;      // The flag of the reserved funds for providing the guarantee sum for pending orders exceeding the decrease value
//--- Guarantee sum for open positions
   this.m_changed_margin_maintenance_value=0;      // The change value of the funds reserved on an account to ensure a minimum amount for all open positions
   this.m_is_change_margin_maintenance_inc=false;  // The flag of the funds reserved on an account to ensure a minimum amount for all open positions exceeding the growth value
   this.m_is_change_margin_maintenance_dec=false;  // The flag of the funds reserved on an account to ensure a minimum amount for all open positions exceeding the decrease value
//--- Assets
   this.m_changed_assets_value=0;                  // Assets change value
   this.m_is_change_assets_inc=false;              // The flag of the assets change exceeding the growth value
   this.m_is_change_assets_dec=false;              // The flag of the assets change exceeding the decrease value
//--- Liabilities
   this.m_changed_liabilities_value=0;             // Liabilities change values
   this.m_is_change_liabilities_inc=false;         // The flag of the liabilities change exceeding the growth value
   this.m_is_change_liabilities_dec=false;         // The flag of the liabilities change exceeding the decrease value
//--- Blocked commissions
   this.m_changed_comission_blocked_value=0;       // Blocked commissions changed value
   this.m_is_change_comission_blocked_inc=false;   // The flag of the tracked commissions change exceeding the growth value
   this.m_is_change_comission_blocked_dec=false;   // The flag of the tracked commissions change exceeding the decrease value
  }
//+------------------------------------------------------------------+
//| Initialize the variables of the controlled account data          |
//+------------------------------------------------------------------+
void CAccountsCollection::InitControlsParams(void)
  {
//--- Balance
   this.m_control_balance_inc=50;                  // Tracked balance growth value
   this.m_control_balance_dec=50;                  // Tracked balance decrease value
//--- Profit
   this.m_control_profit_inc=20;                   // Tracked profit growth value
   this.m_control_profit_dec=20;                   // Tracked profit decrease value
//--- Funds (equity)
   this.m_control_equity_inc=15;                   // Tracked funds growth value
   this.m_control_equity_dec=15;                   // Tracked funds decrease value
//--- Margin
   this.m_control_margin_inc=1000;                 // Tracked margin growth value
   this.m_control_margin_dec=1000;                 // Tracked margin decrease value
//--- Free margin
   this.m_control_margin_free_inc=1000;            // Tracked free margin growth value
   this.m_control_margin_free_dec=1000;            // Tracked free margin decrease value
//--- Margin level
   this.m_control_margin_level_inc=10000;          // Tracked margin level growth value
   this.m_control_margin_level_dec=500;            // Tracked margin level decrease value
//--- Guarantee sum for pending orders
   this.m_control_margin_initial_inc=1000;         // Tracked growth value of the reserved funds for providing the guarantee sum for pending orders
   this.m_control_margin_initial_dec=1000;         // Tracked decrease value of the reserved funds for providing the guarantee sum for pending orders
//--- Guarantee sum for open positions
   this.m_control_margin_maintenance_inc=1000;     // The tracked increase value of the funds reserved on an account to ensure a minimum amount for all open positions
   this.m_control_margin_maintenance_dec=1000;     // The tracked decrease value of the funds reserved on an account to ensure a minimum amount for all open positions
//--- Assets
   this.m_control_assets_inc=1000;                 // Tracked assets growth value
   this.m_control_assets_dec=1000;                 // Tracked assets decrease value
//--- Liabilities
   this.m_control_liabilities_inc=1000;            // Tracked liabilities growth value
   this.m_control_liabilities_dec=1000;            // Tracked liabilities decrease value
//--- Blocked commissions
   this.m_control_comission_blocked_inc=1000;      // Tracked blocked commissions growth value
   this.m_control_comission_blocked_dec=1000;      // Tracked blocked commissions decrease value
  }
//+------------------------------------------------------------------+
