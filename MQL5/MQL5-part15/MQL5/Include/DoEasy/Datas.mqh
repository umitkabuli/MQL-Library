//+------------------------------------------------------------------+
//|                                                        Datas.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
//+------------------------------------------------------------------+
//| Data sets                                                        |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Major Forex symbols                                              |
//+------------------------------------------------------------------+
string DataSymbolsFXMajors[]=
  {
   "AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD",
   "EURUSD","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"
  };
//+------------------------------------------------------------------+
//| Minor Forex symbols                                              |
//+------------------------------------------------------------------+
string DataSymbolsFXMinors[]=
  {
   "EURCZK","EURDKK","EURHKD","EURNOK","EURPLN","EURSEK","EURSGD","EURTRY","EURZAR","GBPSEK","GBPSGD"
      ,"NZDSGD","USDCZK","USDDKK","USDHKD","USDNOK","USDPLN","USDSEK","USDSGD","USDTRY","USDZAR"
  };
//+------------------------------------------------------------------+
//| Exotic Forex symbols                                             |
//+------------------------------------------------------------------+
string DataSymbolsFXExotics[]=
  {
   "EURMXN","USDCNH","USDMXN","EURTRY","USDTRY"
  };
//+------------------------------------------------------------------+
//| Forex RUB symbols                                                |
//+------------------------------------------------------------------+
string DataSymbolsFXRub[]=
  {
   "EURRUB","USDRUB"
  };
//+------------------------------------------------------------------+
//| Indicative Forex symbols                                         |
//+------------------------------------------------------------------+
string DataSymbolsFXIndicatives[]=
  {
   "EUREUC","USDEUC","USDUSC"
  };
//+------------------------------------------------------------------+
//| Metal symbols                                                    |
//+------------------------------------------------------------------+
string DataSymbolsMetalls[]=
  {
   "XAGUSD","XAUUSD"
  };
//+------------------------------------------------------------------+
//| Commodity symbols                                                |
//+------------------------------------------------------------------+
string DataSymbolsCommodities[]=
  {
   "BRN","WTI","NG"
  };
//+------------------------------------------------------------------+
//| Indices                                                          |
//+------------------------------------------------------------------+
string DataSymbolsIndexes[]=
  {
   "CAC40","HSI50","ASX200","STOXX50","NQ100","FTSE100","DAX30","IBEX35","SPX500","NIKK225"
   "Volatility 10 Index","Volatility 25 Index","Volatility 50 Index","Volatility 75 Index","Volatility 100 Index",
   "HF Volatility 10 Index","HF Volatility 50 Index","Crash 1000 Index","Boom 1000 Index","Step Index"
  };
//+------------------------------------------------------------------+
//| Cryptocurrency symbols                                           |
//+------------------------------------------------------------------+
string DataSymbolsCrypto[]=
  {
   "BCHUSD","BTCEUR","BTCUSD","DSHUSD","EOSUSD","ETHEUR","ETHUSD","LTCUSD","XRPUSD"
  };
//+------------------------------------------------------------------+
//| Options                                                          |
//+------------------------------------------------------------------+
string DataSymbolsOptions[]=
  {
   "BO Volatility 10 Index","BO Volatility 25 Index","BO Volatility 50 Index","BO Volatility 75 Index","BO Volatility 100 Index"
  };
//+------------------------------------------------------------------+
