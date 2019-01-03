%%Charting Tool. Used to import price data and generate a series of
%%technical indicators to identify useful market trading strategies.

%Data Import Statement
%May to mid-Sep data
importData = import('Binance_XRPUSDT_15m_1525132800000-1536969600000.csv', 1, 12742);

date=table2array(importData(:,1));
close=table2array(importData(:,5));

%Moving Averages
ema5=movavg(close,'exponential',5);
ema28=movavg(close,'exponential',28);
ema50=movavg(close,'exponential',50);
ema200=movavg(close,'exponential',200);

%MACD indicator
ema12=movavg(close,'exponential',12);
ema26=movavg(close,'exponential',26);
macdDiff=ema26-ema12;
macd9=movavg(macdDiff,'exponential',9);


%MACD Crossover%
uphit=zeros(1,200000);
downhit=zeros(1,200000);
update=[];
downdate=[];
a=2;
while a<=length(close)
    %move from - to +%
    if macd9(a-1)<= 0 & macd9(a)>0
        uphit(a)=close(a);
        update=[update;date(a)];
        %move from + to -%
    else if macd9(a-1) > 0 & macd9(a)<=0
            downhit(a)=close(a);
            downdate=[downdate;date(a)];
        end
    end
    a=a+1;
end
%MACD Crossover cleanup step%
uphit=nonzeros(uphit);
downhit=nonzeros(downhit);


%Plots%
subplot(2,1,1)
plot(date,close,update,uphit,'go',downdate,downhit,'ro')
subplot(2,1,2)
plot(date,macd9)
