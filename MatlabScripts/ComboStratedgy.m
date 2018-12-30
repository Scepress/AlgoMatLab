%Data Import Statement
%May to mid-Sep data
importData = importBinance('Binance_XRPUSDT_15m_1525132800000-1541030400000.csv', 1, 17190);

date=table2array(importData(:,1));
close=table2array(importData(:,5));

%Universal non-changing constants%
%Starting economics
usdtPrice=.997354;
cashStart=100;
usdt=cashStart/usdtPrice;
xrp=0;
%Trade controls
%profit at channelMult 0.045,buymult at 1
buyMult=0.1;
sellMult=1;
channelMult=0.038;
binancefee=0.01;


%Keltner Channel calculations%
ema14=movavg(close,'exponential',14);
upperChannel=ema14*(1+channelMult);
lowerChannel=ema14*(1-channelMult);

%MACD indicator calculations%
ema12=movavg(close,'exponential',12);
ema26=movavg(close,'exponential',26);
macd=ema12-ema26;
signalLine=movavg(macd,'exponential',9);
condiv=macd-signalLine;

%Transaction log setup
buyCall=zeros(1,200000);
sellCall=zeros(1,200000);
buyDate=[];
sellDate=[];

%Start stratedgy. Call trades at Keltner crosses, confirm with MACD%
a=2;
while a<=length(close)
   %buy signal%
    if close(a)<lowerChannel(a) & close(a-1) >= lowerChannel(a-1)
        %buy confirmaton check
        if condiv(a)<0
           xrp=xrp+((usdt*buyMult*(1-binancefee))/close(a));
            usdt=usdt-(usdt*buyMult*(1-binancefee));
            buyCall(a)=close(a);
            buyDate=[buyDate;date(a)];
        end
    %sell signal%
    else if close(a) >= upperChannel(a) & close(a-1) < upperChannel(a-1)
            %sell confirmation
            if condiv(a)>0
            %%%%%%NO SELL CONFIRMATION%%%%%%
            usdt=usdt+(xrp*sellMult*close(a))*(1-binancefee);
            xrp=xrp-(xrp*sellMult);
            sellCall(a)=close(a);
            sellDate=[sellDate;date(a)];
            end
        end
    end
        a=a+1;
            
end

%Array cleanup steps%
buyCall=nonzeros(buyCall);
sellCall=nonzeros(sellCall);

net=usdt+(xrp*close(length(close)));

%Plots%
%subplot(2,1,1)
%plot(date,close,update,uphit,'go',downdate,downhit,'ro')
%subplot(2,1,2)
%plot(date,signalLine)