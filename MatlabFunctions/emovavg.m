function [emovingavg] = EMA(input,periods)
%Function calculates the EMA of the input array over the input number of
%periods and outputs an array with the results to be  used in further
%calculations

%create output array with zeros
emovingavg=zeros(1,length(input)); 
mult=2/(periods+1);


%prime the EMA of periods+1 engine with the first ema calculated from the simple average
%from the last periods.
a=1;
while a<=periods
emovingavg(a)=mean(input(1:a));
a=a+1;
end
startAvg=mean(input(1:periods-1));
EMA=((input(periods)-startAvg)*mult)+startAvg;

%start crawing along input data and outputing the moving average for
%specified number of periods.
a=periods+1;
while a<=length(input)
emovingavg(a)=((input(a)-EMA)*mult)+EMA;
EMA=emovingavg(a);
a=a+1;
end
%cleanup step
emovingavg=nonzeros(emovingavg);
end
