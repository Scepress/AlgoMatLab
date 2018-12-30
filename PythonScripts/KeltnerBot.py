# -*- coding: utf-8 -*-
"""
Created on Sat Nov 17 21:26:15 2018

@author: Owner
"""
import time
from binance.client import Client

#Control Constants
average_Periods=3
symbol="XRPBTC"
channel_Multiplier=2

#initialize a client (no API key needed to pull market data) set symbol
client = Client("","")


def movingAverage(historic_Price):
    
    historic_Price_Sum=sum(historic_Price)
    
    return historic_Price_Sum/average_Periods

def EMA(price, ema, average_Periods):
    ema=((price-ema)/(2/(average_Periods+1))) + ema
    
    return ema

#initialize a matrix to hold last 15 calls for MA calcs
historic_Price=[]
i=0

#start recording market data. Record enough to start calculating indicators
while i<average_Periods:

    temp_data = client.get_ticker(symbol=symbol)
    price=float(temp_data['lastPrice'])
    historic_Price.append(price)
    
    print("Current XRPBTC Exchange Rate: ",price)
    print(historic_Price)
    time.sleep (3)
    i=i+1

#calculate the current value of the moving average (using user defined function) to start a EMA
ema= movingAverage(historic_Price)

#enough market data has been recorded. Can now calculate moving averages and start trading with the bot.
while i<10:
    #Call API to get current ticker price
    temp_data = client.get_ticker(symbol=symbol)
    price=float(temp_data['lastPrice'])
    #handle incoming price data so historic matrix doesnt grow past what is needed to calculate indicators
    historic_Price.append(price)
    historic_Price.pop(0)
    
    ema=EMA(price,ema,average_Periods)
    
    print("Current XRPBTC Exchange Rate: ",price)
    print(historic_Price)
    print(average_Periods," period moving average is: ",ema)
    
    upperChannel=ema + ema*channel_Multiplier
    lowerChannel=ema - ema*channel_Multiplier
    
    #check where price is related to the moving average
    
    
    time.sleep (3)
    i=i+1
    
    



    
    






    
    
    
    
    
    
    
    
    