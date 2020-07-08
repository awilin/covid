%covidGH Antoni Wilinski, Eryk Szwarc (C)2020
%script from covid5e5 to place in GitHub repository
%Details in the article written by above mentioned authors:
%A classification of countries and regions in terms of the degree ...
%of coronavirus spread based on statistical criteria


clear all

Conf230520; %Confirmed cases data prepared in matrix with rows = countries/regions CSSE; 
%to be prepared from CSSE JHU data
Conf270520;
Conf010620;
Conf100620;
Conf030720;

Rec160420;
Dea160420;

i=63;
for j=1:50
    if Conf(i,j)>0
        D=Dea(i,j);
        C=Conf(i,j);
        MFact(j)=D/C;
    else
        MFact(j)=0;
    end
end


mc=size(Conf); %248x65
mr=size(Rec); %from time to time the matrix has another size
md=size(Dea); %248x65


oo=0;  %the number of lack of increases of Confirmed form day to day 
for i=1:mc(1)
    for j=2:mc(2)-1
        if Conf(i,j)-Conf(i,j-1)==0 && Conf(i,j)>100 && Conf(i,j+1)-Conf(i,j-1)>15
            oo=oo+1;
            Conf(i,j)=(Conf(i,j-1)+Conf(i,j+1))/2;
        end
    end
end

oo  %display oo
oo=0;

for i=1:mc(1)
    for j=2:mc(2)-1
        if Conf(i,j)-Conf(i,j-1)==0 && Conf(i,j)>1000 && Conf(i,j+1)-Conf(i,j-1)>5
            oo=oo+1;
           
            
        end
    end
end

oo  %display oo to compare with the previous value



%model for Hubei
sumaCol=sum(Conf);%(ng,:); %Hubei, ng=63
sumaColRec=sum(Rec);%(42,:); %54
sumaColDea=sum(Dea);%(ng,:);


figure(4)
plot(sumaCol,'-r','LineWidth',4)
hold on
plot(sumaColRec,'-g','LineWidth',4)
hold on
plot(sumaColDea,'-y', 'LineWidth',4)
text(60,1000000,'Confirmed')
text(70,250000,'Recovered')
text(60,55000,'Deaths')
title(['Confirmed, Recovered and Deaths for the whole world'])
 grid on

ng=63; % Hubei 63; Germany 121; 138 Italy, 140 Japan

sumaCol=Conf(ng,:);
sumaColRec=Rec(54,:);
sumaColDea=Dea(ng,:);

figure(5)
plot(sumaCol,'-r','LineWidth',4)
hold on
plot(sumaColRec,'-g','LineWidth',4)
hold on
plot(sumaColDea,'-y', 'LineWidth',4)
text(12,50000,'Confirmed')
text(31,40000,'Recovered')
text(40,7000,'Deaths')
title(['Confirmed, Recovered and Deaths for Hubei '])
 grid on

%for different countries

no=0; %subplot number (from 1 to 10)
n3=1;  %if n3=1 you can print in fig. 25  w=[63 138 226]; %Hubei, Italy, USA
N=86; %number of cols in CSSE matrix


w=[24 51 61 63 82 117 121 138 176 184 226]; %a vector of choosen countries
w=1:100;
w=[49 50 51 52 55 61 63 64 66 67 ];
w=1:226;
w=[29 63 117 121 134 138 140 144 184 226]; %Brasil, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
w=1:226;
w=[63 138 226]; %Hubei, Italy, USA
w=[24 63 117 121 134 138 140 144 184 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
%as the last w-vector should be placed a vector with numbers of countries
%you want to observe. It can be even a single number

w=[63 138 226]; %Hubei, Italy, USA
w=[24 63 117 121 134 138 140 144 184 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States


for k=w;%54:79%151:166
    ng=k;
    ngk(k)=0; %country numbers not fulfilling the condition below will be equal to 0
    if Conf(ng,N)>1000
        ngk(k)=k; %vector of numbers of countries meeting the above condition
no=no+1;
marker=0;
thru(no)=0.02; %threshold for achieving clear increase by Yp indicator; this is data-driven variable; 
%thru validation for different countries after downlod new data
if no==6
    thru(6)=0.020;
end
if no==5
    thru(5)=0.0150;
end
if no==10
    thru(10)=0.0150;
end
if no==9
    thru(9)=0.020;
end
if no==4
    thru(4)=0.030;
end
if no==9
    thru(9)=0.0150;
end

%you can change thru(no) a little bit if some countries with big Conf have 0-phase
istu(no)=0;  %Threshold thru exceeded? 
thrd(no)=0.002;  % threshold for achieving a clear drop by the Yp indicator
istd(no)=0;  %threshold thrd exceeded?
istm(no)=0;
istuk(no)=0;
istum(no)=0;
istud(no)=0;
sumaCol=Conf(ng,:); % ng country

y=sumaCol; %simplified name of the Conf curve;
nz=find(y>3); %vector of non-zero y values; or larger than e.g. 3 in order to find the beginning of growth
pn=nz(1); %index of the first non-zero element or element at which the threshold was exceeded

Ym=y(end);%  conventional value of the instantaneous maximum Conf for normalization purposes
movingWindow=10;%moving window lenght 
N=mc(2); %number od columns (days) in CSSE matrices
for i=2:N
    currentDate=i;
  
    yp(i)=y(currentDate)-y(currentDate-1); %daily increase of Conf
    Yp(i)=yp(i)/Ym; %relative increase
        
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; %the day when the thru threshold was exceeded
    end
    if Yp(i)<thru(no) && istu(no)==1 && istm(no)==0
        istm(no)=1;
        istum(no)=i; %the day when the middle threshold was exceeded
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0 && istm(no)==1
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; %the day when the thrd threshold was exceeded
    end
    
    if i==N
    if istu(no)==0 
        phase(no)=0;
    end
    if istu(no)==1 && istm(no)==0
        phase(no)=1;
    end
    if istu(no)==1 && istm(no)==1 && istd(no)==0
        phase(no)=2;
    end
    if istu(no)==1 && istm(no)==1 && istd(no)==1
        phase(no)=3;
    end
    end %N
    
        
        
    y1=Dea(ng,:);
    y1=y;
    
    %new indicator - with moving window
    if i>movingWindow
    S(i)=std(y1(i-movingWindow:i));
    Sc=S(i);
    M(i)=mean(y1(i-movingWindow:i));
    
    Mc=M(i);
    if Mc~=0
    camInd(i)=Sc/Mc;  %indicator Camel Index
    else
    camInd(i)=0;    
    end
    end
    
    
end

if n3==0  %# biggest cases - Hubei, Italy, USA
    figure(25)
    plot(Yp, 'LineWidth',3)
    hold on
    title('Hubei, Italy and USA')
     grid on
     text(12,0.10,'Hubei')
    text(50,0.03,'Italy')
    text(70,0.06,'USA')

    %smoothed charts
    for i=11:mc(2)-5
        YpMA(i)=mean(Yp(i-8:i));
    end
    
        figure(26)
        plot(YpMA,'LineWidth',3)
        hold on
    title('Moving averages of Yp')
    text(12,0.04,'Hubei')
    text(54,0.03,'Italy')
    text(60,0.02,'USA')
    grid on
end


if no<=10  && istuk(no)>0
    
    figure(21)
    subplot(5,2,no)
    plot(Yp,'-r', 'LineWidth',3)
    hold on
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    plot(istuk(no), Yp(istuk(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    hold on
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    title (['Conf for ng = ', num2str(ng),' (phase ', num2str(phase(no)),')']) 
     grid on
    
    figure(23)
    subplot(5,2,no)
    plot(camInd, 'LineWidth',3)
    title(['ng = ',num2str(ng)])
     grid on
end  %if no
   
    end %if Conf>1000
end %k=w
%
phase;    %phase of Civid spread in this country  
nn=find(ngk); %find non-zero country numbers listed in the order as in the model vector
ph=[nn; phase]'



%for one choosen country
no=0; %subplot window number
w=63;  %nr of a country
hs=0; %simulation horizon
modelw=0;
for k=1:10;%54:79%151:166
    ng=w;
    sumaCol=Conf(ng,:); % ng country
    y=sumaCol; %%simplified name of the Conf curve;
   
    ngk(k)=0; %the number of countries not meeting the condition below will be equal to 0
    if Conf(ng,N)>1000
        ngk(k)=k; %Vector numbers of countries meeting the above condition
    hs=k*5; 
    Ym=y(hs);
no=no+1;
marker=0;
thru(no)=0.04; %threshold for the clear increase Yp
istu(no)=0;  %tnereshold thru exceeded
thrd(no)=0.006;  %threshold for achieving a clear drop through the Yp indicator
istd(no)=0;  %tnereshold thrd exceeded
istuk(no)=0;
istud(no)=0;
sumaCol=Conf(ng,:); % ng country

nz=find(y>3); %%vector of non-zero y values; or larger than e.g. 3 in order to find the beginning of growth
pn=nz(1); %%index of the first non-zero element or element at which the threshold was exceeded

Ym=y(end); %conventional value of the instantaneous maximum Conf for normalization purposes
movingWindow=5;%10; %moving window lenght 
for i=2:hs
    currentDate=i;%pb+i;
    yp(i)=y(currentDate)-y(currentDate-1); %daily increase of Conf
    Yp(i)=yp(i)/Ym;
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; % %the day when the thru threshold was exceeded
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; % %the day when the thrd threshold was exceeded
    end
    if istud(no)==0
        modelw(no)=1;  %model with dynamic growth
    else
        modelw(no)=2;  %model in transition phase 
    end    
    
end

if no<=10  %do druku
    
    figure(24)
    subplot(5,2,no)
    plot(Yp(1:hs),'-r', 'LineWidth',3)
    hold on
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    if istuk(no)>0
    plot(istuk(no), Yp(istuk(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    end
    hold on
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    hold on
    title (['Relative increases of Conf for Hubei'])%ng = ', num2str(ng)]) 
     grid on
    
    
end
   
    end
end
