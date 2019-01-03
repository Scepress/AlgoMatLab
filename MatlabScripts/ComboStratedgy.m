%************COMBO STRATEDGY SCRIPT DESCRIPTION******************%
%Script uses trading indicators to backtest trading behavior of an
%indicator bot on trading common cryptocurrency pairs USDT/BTC,ETH,LTC,XRP

%Universal non-changing constants%
%Simulation starting economics
usdtPrice=.997354;
cashStart=100;
usdt=cashStart/usdtPrice;
btc=0;
eth=0;
ltc=0;
xrp=0;

%Trade controls
buyMult=0.1;
sellMult=1;
channelMult=0.038;
binancefee=0.01;

%Bacltest data imported separately prior to running the model.
closeBTC=table2array(importBTC(:,5));
closeETH=table2array(importBTC(:,5));
closeLTC=table2array(importBTC(:,5));
closeXRP=table2array(importBTC(:,5));

%Check to make sure dates match. If true, create single date array,
%otherwise stop the script running with error
    date1=table2array(importBTC(:,1));
    date2=table2array(importETH(:,1));
    date3=table2array(importLTC(:,1));
    date4=table2array(importXRP(:,1));
    
    if isequal(date1,date2,date3,date4) == 1
        date=table2array(importBTC(:,1));
        vars = {'date1','date2','date3','date4','ans'};
        clear(vars{:})
        clear('vars')
    else
        error='DATES INCONSISTENT'
        return
    end
    

%------Keltner Channel Setup-----------%
%pair EMAs for Keltner Channels
ema14BTC=emovavg(closeBTC,14);
ema14ETH=emovavg(closeETH,14);
ema14LTC=emovavg(closeLTC,14);
ema14XRP=emovavg(closeXRP,14);

%Channels
upperChannelBTC=ema14BTC*(1+channelMult);
lowerChannelBTC=ema14BTC*(1-channelMult);

upperChannelETH=ema14ETH*(1+channelMult);
lowerChannelETH=ema14ETH*(1-channelMult);

upperChannelLTC=ema14LTC*(1+channelMult);
lowerChannelLTC=ema14LTC*(1-channelMult);

upperChannelXRP=ema14XRP*(1+channelMult);
lowerChannelXRP=ema14XRP*(1-channelMult);

%MACD indicator calculations%
%!!!!!!!!!!!! SECTION COMMENTED OUT!!!!!!!!!!!!!!!!!!!!%
%ema12=movavg(closeBTC,'exponential',12);
%ema26=movavg(closeBTC,'exponential',26);
%macd=ema12-ema26;
%signalLine=movavg(macd,'exponential',9);
%condiv=macd-signalLine;
%!!!!!!!!!!! END COMMENT OUT!!!!!!!!!!!!!!!!!!!!!!!!!!%


%Transaction log setup
names={'Date','BuySell','Pair','Price','USDT','BTC','ETH','LTC','XRP'};
tradeLog=table(datetime(0,0,0),{''},{''},0,0,0,0,0,0,'VariableNames',names);
clear names;
tradeLog=repmat(tradeLog,2000,1);
tradeCount=1; %tradeCount will be used as the index to log trades

%Start stratedgy. Call trades at Keltner crosses, confirm with MACD%
a=2;
while a<=length(date)
    %--BTC--%
    %buy signal%
    if closeBTC(a)<lowerChannelBTC(a) & closeBTC(a-1) >= lowerChannelBTC(a-1)
        %Transaction calculations
        btc=btc+((usdt*buyMult*(1-binancefee))/closeBTC(a));
        usdt=usdt-(usdt*buyMult*(1-binancefee));
        %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Buy'};
        tradeLog.Pair(tradeCount)={'BTCUSDT'};
        tradeLog.Price(tradeCount)=closeBTC(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        %sell signal%
    else if closeBTC(a) >= upperChannelBTC(a) & closeBTC(a-1) < upperChannelBTC(a-1)
            %Transaction calculations
            usdt=usdt+(btc*sellMult*closeBTC(a))*(1-binancefee);
            btc=btc-(btc*sellMult);
            %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Sell'};
        tradeLog.Pair(tradeCount)={'BTCUSDT'};
        tradeLog.Price(tradeCount)=closeBTC(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        end
    end
    
       %--ETH--%
    %buy signal%
    if closeETH(a)<lowerChannelETH(a) & closeETH(a-1) >= lowerChannelETH(a-1)
        %Transaction calculations
        eth=eth+((usdt*buyMult*(1-binancefee))/closeETH(a));
        usdt=usdt-(usdt*buyMult*(1-binancefee));
        %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Buy'};
        tradeLog.Pair(tradeCount)={'ETHUSDT'};
        tradeLog.Price(tradeCount)=closeETH(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        %sell signal%
    else if closeETH(a) >= upperChannelETH(a) & closeETH(a-1) < upperChannelETH(a-1)
            %Transaction calculations
            usdt=usdt+(eth*sellMult*closeETH(a))*(1-binancefee);
            eth=eth-(eth*sellMult);
            %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Sell'};
        tradeLog.Pair(tradeCount)={'ETHUSDT'};
        tradeLog.Price(tradeCount)=closeETH(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        end
    end 
    
        %--LTC--%
    %buy signal%
    if closeLTC(a)<lowerChannelLTC(a) & closeLTC(a-1) >= lowerChannelLTC(a-1)
        %Transaction calculations
        ltc=ltc+((usdt*buyMult*(1-binancefee))/closeLTC(a));
        usdt=usdt-(usdt*buyMult*(1-binancefee));
        %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Buy'};
        tradeLog.Pair(tradeCount)={'LTCUSDT'};
        tradeLog.Price(tradeCount)=closeLTC(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        %sell signal%
    else if closeLTC(a) >= upperChannelLTC(a) & closeLTC(a-1) < upperChannelLTC(a-1)
            %Transaction calculations
            usdt=usdt+(ltc*sellMult*closeLTC(a))*(1-binancefee);
            ltc=ltc-(ltc*sellMult);
            %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Sell'};
        tradeLog.Pair(tradeCount)={'LTCUSDT'};
        tradeLog.Price(tradeCount)=closeETH(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        end
    end
    
            %--XRP--%
    %buy signal%
    if closeXRP(a)<lowerChannelXRP(a) & closeXRP(a-1) >= lowerChannelXRP(a-1)
        %Transaction calculations
        xrp=xrp+((usdt*buyMult*(1-binancefee))/closeXRP(a));
        usdt=usdt-(usdt*buyMult*(1-binancefee));
        %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Buy'};
        tradeLog.Pair(tradeCount)={'XRPUSDT'};
        tradeLog.Price(tradeCount)=closeXRP(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        %sell signal%
    else if closeXRP(a) >= upperChannelXRP(a) & closeXRP(a-1) < upperChannelXRP(a-1)
            %Transaction calculations
            usdt=usdt+(xrp*sellMult*closeXRP(a))*(1-binancefee);
            xrp=xrp-(xrp*sellMult);
            %logging of transactions
        tradeLog.Date(tradeCount)=date(a);
        tradeLog.BuySell(tradeCount)={'Sell'};
        tradeLog.Pair(tradeCount)={'XRPUSDT'};
        tradeLog.Price(tradeCount)=closeETH(a);
        tradeLog.USDT(tradeCount)=usdt;
        tradeLog.BTC(tradeCount)=btc;
        tradeLog.ETH(tradeCount)=eth;
        tradeLog.LTC(tradeCount)=ltc;
        tradeLog.XRP(tradeCount)=xrp;
        tradeCount=tradeCount+1;
        end
    end
    
    a=a+1;
end
%clean up excess rows iteratively in the trade log
extraRows=size(tradeLog(:,:));
extraRows=extraRows(1);
while extraRows>tradeCount
tradeLog(tradeCount,:)=[];
extraRows=size(tradeLog(:,:));
extraRows=extraRows(1);
end
clear extraRows;

net=usdt+(btc*closeBTC(length(closeBTC)))+(eth*closeETH(length(closeETH)));