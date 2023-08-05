Rate = 0.75;        % lambda   (Arrivals per unit time)
% Input 
NumPeople = 200;     % number of Arrivals to generate
% Input
NumCounters = 2;
x = 1:1:NumPeople;

nexttile
% modelling inter Arrival times as exponential rv
InterArrivalTimes = exprnd(1/Rate,NumPeople,1);
disp(InterArrivalTimes)
plot(x,InterArrivalTimes)
title('Inter-Arrival Times')
ylabel('Inter-Arrival Time')
xlabel('Arrival Number')

nexttile
plot(x, exppdf(x, 1/Rate));
title('PDF of Inter-Arrival Times')
ylabel('PDF')
xlabel('Arrival Number')

nexttile
plot(x, expcdf(x, 1/Rate));
title('CDF of Inter-Arrival Times')
ylabel('CDF')
xlabel('Arrival Number')

nexttile
% calculating Arrival times based on inter Arrival times
% Arrival times can be modelled as rayleigh
ArrivalTimes = cumsum(InterArrivalTimes);
disp(ArrivalTimes)
plot(x,ArrivalTimes)
title('Arrival Times')
ylabel('Arrival Time')
xlabel('Arrival Number')

B=raylfit(ArrivalTimes);
ray=makedist('Rayleigh','B',B);

nexttile
plot(x,pdf(ray,ArrivalTimes))
title('PDF of Arrival Times')
ylabel('PDF')
xlabel('Arrival Number')

nexttile
plot(x,cdf(ray,ArrivalTimes))
title('CDF of Arrival Times')
ylabel('CDF')
xlabel('Arrival Number')

nexttile
mu=4;
sigma=2;
% modelling processing times of both counters as gaussian distributions
pd = makedist('Normal','mu',mu,'sigma',sigma);
ProcessingTimes = random(pd,NumPeople,NumCounters);
disp(ProcessingTimes)
plot(x,ProcessingTimes)
title('Processing Times')
ylabel('Processing Time')
xlabel('Arrival Number')

nexttile
plot(x, normpdf(x, mu, sigma));
title('PDF of Processing Times')
ylabel('PDF')
xlabel('Arrival Number')

nexttile
plot(x, normcdf(x, mu, sigma));
title('CDF of Processing Times')
ylabel('CDF')
xlabel('Arrival Number')

counter1 = zeros(NumPeople,1); % Counter 1 Finish Time
counter2 = zeros(NumPeople,1); % Counter 2 Finish Time
count1=1; % Number of completions 
count2=1; % Number of completions 

IdleTime1 = zeros(NumPeople,1); % How long Counter 1 is Idle
IdleTime2 = zeros(NumPeople,1); % How long Counter 2 is Idle

WaitingTime = 0;

counter1(1) = ProcessingTimes(1)+ InterArrivalTimes(1);
counter2(1) = ProcessingTimes(2)+ InterArrivalTimes(2);

for i=3:NumPeople
    if counter1(count1) < counter2(count2)
        counter1(count1) = counter1(count1-1) + ProcessingTimes(i)+ InterArrivalTimes(i);
        count1=count1+1;
    else
        counter2(count2) = counter2(count2-1) + ProcessingTimes(i)+ InterArrivalTimes(i);
        count2=count2+1;
    end
end

disp(counter1)
disp(counter2)