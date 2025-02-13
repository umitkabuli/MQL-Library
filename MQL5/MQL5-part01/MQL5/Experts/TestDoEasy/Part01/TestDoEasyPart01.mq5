//+------------------------------------------------------------------+
//|                                             TestDoEasyPart01.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//--- includes
#include <DoEasy\Objects\Order.mqh>
#include <Arrays\ArrayObj.mqh>
//--- global variables
CArrayObj      list_all_orders;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   list_all_orders.Sort();
   list_all_orders.Clear();
   if(!HistorySelect(0,TimeCurrent()))
     {
      Print(DFUN,TextByLanguage(": Не удалось получить историю сделок и ордеров",": Failed to get history of deals and orders"));
      return INIT_FAILED;
     }
//--- Deals
   int total_deals=HistoryDealsTotal();
   for(int i=0; i<total_deals; i++)
     {
      ulong deal_ticket=::HistoryDealGetTicket(i);
      if(deal_ticket==0) continue;
      COrder *deal=new COrder(ORDER_STATUS_DEAL,deal_ticket);
      if(deal==NULL) continue;
      list_all_orders.InsertSort(deal);
     }
//--- Orders
   int total_orders=HistoryOrdersTotal();
   for(int i=0; i<total_orders; i++)
     {
      ulong order_ticket=::HistoryOrderGetTicket(i);
      if(order_ticket==0) continue;
      ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)::HistoryOrderGetInteger(order_ticket,ORDER_TYPE);
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_SELL)
        {
         COrder *order=new COrder(ORDER_STATUS_HISTORY_ORDER,order_ticket);
         if(order==NULL) continue;
         list_all_orders.InsertSort(order);
        }
      else
        {
         COrder *order=new COrder(ORDER_STATUS_HISTORY_PENDING,order_ticket);
         if(order==NULL) continue;
         list_all_orders.InsertSort(order);
        }
     }
   int total=list_all_orders.Total();
   for(int i=0;i<total;i++)
     {
      COrder *order=list_all_orders.At(i);
      if(order==NULL)
         continue;
      order.Print();
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
