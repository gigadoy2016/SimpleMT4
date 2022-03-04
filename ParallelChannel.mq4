//+------------------------------------------------------------------+
//|                                              ParallelChannel.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int Obj1_BuyCount = 1;
int Obj1_BuyStatus;


int OnInit()
  {
//---         
      Obj1_BuyStatus =0;
   
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      ParallelChannel myTrendLine1;
      myTrendLine1.percentagePrice = 5;
      myTrendLine1.lineID = "Trendline01";
      myTrendLine1.setReceived(1);
      myTrendLine1.setResistant(1);
      myTrendLine1.statusBuy = Obj1_BuyStatus;
      
      myTrendLine1.openBuyPosition();
      Print("-----status Buy--------"+myTrendLine1.getStatusBuy());
      Obj1_BuyStatus = myTrendLine1.getStatusBuy();
  }
//+------------------------------------------------------------------+

// Class
//--------------------------------------------------------------------
class ParallelChannel{
   private:
      //string name[10];           // Trend Line Maximun support 10 objects.
      int m_received_line_shift;      
      int m_resistant_line_shift;
      int buyCount;

   public:      
      double percentagePrice;      
      string lineID;
      double received_val;
      int statusSell;
      int statusBuy;
      
   
   public:
      void setResistant(int shift){
         m_resistant_line_shift = shift;
      } 
      
      void setReceived(int shift){
         m_received_line_shift = shift;
      }
      
      int getStatusBuy(){
         return statusBuy;
      }
      
      bool openBuyPosition(){
         Print("------------ Start ParallelChannel.openBuy()");
         double trendReceived_val = ObjectGetValueByShift(lineID,m_received_line_shift);
         //Comment(ChartSymbol()+" ",MarketInfo( "BTCUSD",MODE_ASK), "\n "+lineID+": ",trendReceived_val , "  Opened : ",Close[m_received_line_shift]);
         
         double price = Close[m_received_line_shift];
         double _trendReceived_val = trendReceived_val*(100+percentagePrice)/100;                  
         
         //Print(ChartSymbol()+" trend :("+_trendReceived_val+" - "+trendReceived_val+")   Price:"+price+"  ="+(_trendReceived_val > price  && price > trendReceived_val && statusBuy < 1));
         if(_trendReceived_val > price  && price > trendReceived_val && statusBuy < 1){
            int result = MessageBox("Do you want open position BUY?","Question", MB_OKCANCEL);      
            if(result == 1){
               int msg = MessageBox("Open Buy completed,Ticket is:",IntegerToString( 1 ));
               statusBuy = 1;
               buyCount++;
               return true;
            }
          }else{
            Print("openBuyPosition is not condition!!");
          }
         return false;
      }
      
      bool closeBuyPosition(){
         
      }
};
