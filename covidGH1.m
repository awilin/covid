%covidGH1 Antoni Wilinski, Eryk Szwarc (C)2020 
%script based on covid5e10 prepared for ESWA publication
%



clear all

Conf110420;
%
Conf270520;
Rec110420;
Dea110420;
Conf180720;
Conf290720;
Conf050820; %confirmed cases matrix from CSSE from 05 Aug
Rec050820;  %Recovered matrix
Dea050820;  %deaths matrix
%Conf110420; %Confirmed cases data prepared in matrix with rows = countries/regions CSSE; 
%to be prepared from CSSE JHU data
i=63;  %Hubei
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
mr=size(Rec); %another rows number - 234
md=size(Dea); %248x65

% averaging cell values in the absence of an increment for 
%administrative reasons (e.g. no data provided)

oo=0;  %the number of lack of increases of Confirmed form day to day 
for i=1:mc(1)
    for j=2:mc(2)-1
        if Conf(i,j)-Conf(i,j-1)==0 && Conf(i,j)>100 && Conf(i,j+1)-Conf(i,j-1)>15
            oo=oo+1;
            Conf(i,j)=(Conf(i,j-1)+Conf(i,j+1))/2;
        end
    end
end

oo  %display oo to compare with the previous value

oo=0; 


for i=1:mc(1)
    for j=2:mc(2)-1
        if Conf(i,j)-Conf(i,j-1)==0 && Conf(i,j)>1000 && Conf(i,j+1)-Conf(i,j-1)>5
            oo=oo+1;
            %Conf(i,j)=(Conf(i,j-1)+Conf(i,j+1))/2;
            %[i j];
            %pause
            
        end
    end
end

oo

%moving average instead of Conf
MA=7;
for i=MA+1:mc(2)
    for j=1:mc(1)
    
        ConfMA(j,i)=mean(Conf(j,i-MA:i));
end
end
Conf=ConfMA;
%777777777777777777777777777777777777777777777777


wr=["Japan" , "Israel", "Spain", "Serbia", "Bosnia", "Makedonia", "Zambia", "Croatia", "Luxembourg", "Slovenia"];
nr=[140 137 202 195 28 175 230 88 152 199];
% printouts of countries suspected of having 4 phases of the epidemic
for i=1:8
figure(52)
    t=sgtitle('Phases of the Epidemics for some countries with fourth phase');
    t.FontSize=10;
    subplot(4,2,i)
    plot(Conf(nr(i),mc(2)-50:mc(2)),'-r', 'LineWidth',3)
    hold on
        title (['Conf for ',num2str(wr(i))],'FontSize',7) 

   
     grid on
     xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Confirmed Cases','FontSize',7)
     
     figure(53)
    t=sgtitle('Phases of the Epidemics for some countries with fourth phase');
    t.FontSize=10;
    subplot(4,2,i)
    plot(Conf(nr(i),mc(2)-150:mc(2)),'-r', 'LineWidth',3)
    hold on
        title (['Conf for ',num2str(wr(i))],'FontSize',7) 

   
     grid on
     xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Confirmed Cases','FontSize',7)
    end
    
     
    
    



sumaCol=sum(Conf);%(ng,:); %Hubei,  ng=63
sumaColRec=sum(Rec);%(42,:); %54
sumaColDea=sum(Dea);%(ng,:);


figure(4)

plot(sumaCol(1:80),'-r','LineWidth',3)
hold on
plot(81:mc(2),sumaCol(81:mc(2)),'--r','LineWidth',3)
hold on
plot(sumaColRec(1:80),'-g','LineWidth',3)
hold on
plot(81:mc(2),sumaColRec(81:mc(2)),'--g','LineWidth',3)
hold on
plot(sumaColDea,'-y', 'LineWidth',3)
line ([80 80],[0 18*10^6])
line([197 197], [0 18*10^6])
text(146,14000000,'Confirmed')
text(144,4000000,'Recovered')
text(140,1000000,'Deaths')
title(['Confirmed, Recovered and Deaths for the world'])
xlabel('Number of days since January 22')
ylabel('Number of Cases')
 grid on

 
ng=63; % Hubei 63; Niemcy 121; 138 Italy, 140 Japan

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
xlabel('Number of days since January 22')
ylabel('Number of Cases')
 grid on


%for different countries

no=0; %chart number in a subplot
n2=0;
n3=0;  %if n3=1 tthe printout the biggest ones in fig. 25  w=[63 138 226]; %Hubei, W³óchy, USA
N=75; %days number i matrices CSSE


w=[24 51 61 63 82 117 121 138 176 184 226]; %vestor of the selected countries (rows)
w=1:100;
w=[49 50 51 52 55 61 63 64 66 67 ];
w=[63 138 226]; %Hubei, W³ochy, USA
w=[24 51 63 82 117 121 138 140 144 226];
w=[24 51 63 82 117 121 134 138 140 144 226];
w=1:226;
ws=["Belgium",  "France", "Germany", "Brazil", "Italy", "Japan", "South Korea", "Poland","Russia", "United States"];
ws1=["Brasil","Russia"];
w=[24 63 117 121 134 138 140 144 184 188 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
w=[63 138 226]; %Hubei, W³ochy, USA;  %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
%as the last w-vector should be placed a vector with numbers of countries
%you want to observe. It can be even a single number of your country

w=1:226;
w=[29 188];%Brazylia i Rosja
w=[24  117 121 29 138 140 144 184 188 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
%ws=wr;
%w=nr;

for k=w;%54:79%151:166
    ng=k;
    ngk(k)=0; %The numbers of countries not meeting the condition below will be 0

    if Conf(ng,N)>1000
        ngk(k)=k; %the vector of countries numbers that met the condition above
no=no+1;
marker=0;
thru(no)=0.010; %the first experiment - the threshold thru when Yp reaches fast growth 
%thru validation for different countries after downlod new data
thrus(no)=1.0; %% threshold to start the 1st phase related to the reference order
if no==1
    %thru(1)=0.0150;
end
if no==2
   % thru(2)=0.0090; 
end
if no==3
   % thru(3)=0.020;
end
if no==6
   % thru(6)=0.01;
end
if no==7
   % thru(7)=0.020;
end
if no==5
   % thru(5)=0.0100;
end
if no==8
    thru(8)=0.0080;
end
if no==10
   % thru(10)=0.0100;
end
if no==9
  %  thru(9)=0.0100;
end
if no==4
  %  thru(4)=0.010;
end

istu(no)=0;  %thru threshold exceeded?
thrd(no)=0.005;  %% the threshold when the Yp indicator reaches a marked decrease
istd(no)=0;  %thrd threshold exceeded?
istm(no)=0;
istuk(no)=0;
istum(no)=0;
istud(no)=0;
istur(no)=0;
istuks(no)=0;
istus(no)=0;
istr(no)=0;
thr(no)=2*thrd(no);

phase1(no)=0;
sumaCol=Conf(ng,:); % ng pañstwo

y=sumaCol; %new simple name for Conf time series;
nz=find(y>3); %a vector of non-zero y values; 
              %or greater than, for example, 3 to find the beginning of the growth
pn=nz(1); % index of the first non-zero word or word that exceeds the specified threshold
%pnk(k)=pn;
pno(no)=pn;
Ym=y(end);% % conventional value of the instantaneous maximum Conf for normalization purposes
iref=14; %% reference day after the first non-zero day
Yms=y(pno(no)+iref); %maximum, always constant
Ybm(no)=Yms;
movingWindow=10;
N=mc(2); %number of columns (days from 22 Jan) in CSSE matrices
for i=2:N
    currentDate=i;%pb+i;
   
    
    yp(i)=y(currentDate)-y(currentDate-1); %daily increase of  Conf
    Yp(i)=yp(i)/Ym; %!!!!!!!!relative increase of the daily one
    Yps(i)=yp(i)/Yms;
    
    if i==pno(no)+iref
        yDr(no)=yp(i);
    end
    
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; %the day when threshold thru was crossed
        ypB(no)=yp(i);
    end
    if Yps(i)>thrus(no) && istus(no)==0
        istus(no)=1;
        istuks(no)=i; %the day when threshold thrus was crossed
        ymsNo(no)=Yps(i);
    end
    if no==1
        yss(i)=Yps(i);
        ys(i)=Yp(i);
        Ss=Yms;
        S1=Ym;
    end
     if no==8
        yspol(i)=Yps(i);
        ypol(i)=Yp(i);
        Sspol=Yms;
        Spol=Ym;
     end
    if no==10
        ysus(i)=Yps(i);
        
    end
    
    if Yp(i)<thru(no) && istu(no)==1 && istm(no)==0
        istm(no)=1;
        istum(no)=i; %The day when thru threshold was exceeded from top to down
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0 && istm(no)==1
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; %the day when thrd threshold was exceeded
    end
    if Yp(i)>thr(no) && istd(no)==1 && istr(no)==0
        istr(no)=1;
        istur(no)=i;
    end
    
    if i==N
    if istu(no)==0 
        phase1(no)=0;
    end
    if istu(no)==1 && istm(no)==0
        phase1(no)=1;
    end
    if istu(no)==1 && istm(no)==1 && istd(no)==0
        phase1(no)=2;
    end
    if istu(no)==1 && istm(no)==1 && istd(no)==1
        phase1(no)=3;
    end
     if istr(no)==1  && istm(no)==1 && istd(no)==1
        phase1(no)=4;
    end
   
    
    end %N
    
    a=find(phase1==0);  
        
        
    y1=Dea(ng,:);
    y1=y;
    %new indicator with moving window
    if i>movingWindow
    S(i)=std(y1(i-movingWindow:i));
    Sc=S(i);
    M(i)=mean(y1(i-movingWindow:i));
    
    Mc=M(i);
    if Mc~=0
    camInd(i)=Sc/Mc;  %Camel Index
    else
    camInd(i)=0;    
    end
    end
    
    
end

if n3==1  %biggest cases - Hubei, Italy, USA - Apr 2020
    figure(25)
    plot(Yp, 'LineWidth',3)
    hold on
    title('Hubei, Italy and USA')
     grid on
     text(12,0.10,'Hubei')
    text(47,0.03,'Italy')
    text(62,0.08,'USA')

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
    text(58,0.02,'USA')
    grid on
end


if no<=10  && istuk(no)>0
    if n2==1  %the graph is for Brazil and Russia
    figure(62)
    t=sgtitle('Phases of the Epidemics for Brasil and Russia');
    t.FontSize=10;
    subplot(1,2,no)
    plot(Yp,'-r', 'LineWidth',3)
    hold on
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    plot(istuk(no), Yp(istuk(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    hold on
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    title (['Phase is ', num2str(phase1(no)),' for ',num2str(ws1(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
    end
    
    figure(31)
    t=sgtitle('Phases of the Epidemics for the different countries');
    t.FontSize=10;
    
    subplot(5,2,no)
    plot(Yp,'-r', 'LineWidth',3)
    hold on
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    if istuks(no)>0
    plot(istuks(no), Yp(istuks(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    hold on
    end
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    if istur(no)>0
    plot(istur(no), Yp(istur(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'm')
    end
    title (['Phase is ', num2str(phase1(no)),' for ',num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
     
     figure(131)
    t=sgtitle('Phases of the Epidemics for the different countries');
    t.FontSize=10;
    
    subplot(5,2,no)
    plot(Yp,'-r', 'LineWidth',3)
    hold on
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    if istuks(no)>0
    plot(istuks(no), Yp(istuks(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    hold on
    end
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    if istur(no)>0
    plot(istur(no), Yp(istur(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'm')
    end
    title ([num2str(no)],'FontSize',5) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     %xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
     
     if no==6
          figure(32)
    t=sgtitle('Phases of the Epidemic for Japan');
    t.FontSize=12;
    %ConfWJap=Conf(140,:)/Conf(140,end)*0.035;
    plot(Yp,'-k', 'LineWidth',2)
    hold on
    %plot(ConfWJap)
    plot(pn, Yp(pn), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r')
    hold on
    if istuks(no)>0
    plot(istuks(no), Yp(istuks(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'b')
    hold on
    end
    if istud(no)>0
    plot(istud(no), Yp(istud(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'g')
    end
    if istur(no)>0
    plot(istur(no), Yp(istur(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'm')
    end
    %title (['Phase is ', num2str(phase1(no)),' for ',num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Number of days since January 22', 'FontSize',10)
     ylabel('Yp Indicator','FontSize',10)
     %text(40,0.01,'Phase 1', FontSize,5)
     text(15,0.003,'Phase 0','Color','red','FontSize',14)
      text(40,0.01,'Phase 1','Color','blue','FontSize',14)
              text(100,0.01,'Phase 2','Color','blue','FontSize',14)

       text(120,0.004,'Phase 3','Color','green','FontSize',14)
        text(155,0.025,'Phase 4','Color','magenta','FontSize',14)

     end
         
    
      figure(33)
    t=sgtitle('Confirmed cases in two points: after 80 days and today (after 197 days)');
    t.FontSize=10;
    subplot(5,2,no)
    plot(y,'-b', 'LineWidth',2)  %you can change color here b/r
    hold on
    
    title ([num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Number of days since January 22', 'FontSize',7)
     ylabel('Conf','FontSize',7)
    
     
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
    title (['Conf for ng = ', num2str(ng),' (phase ', num2str(phase1(no)),')']) 
     grid on
   
end  %if no
   
    end %if Conf>1000
end %k=w

phase1;    %stan rozwoju koronowirusa w pañstwie w kolejnosci wg k
nn=find(ngk); %% find non-zero country numbers listed in the order of the model vector
ph=[nn; phase1]'

ri= istuks-pno-iref
rthu=istuk;



