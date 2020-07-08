%covidBulletinGH Antoni Wilinski(C)2020
%script to locate at GH
%goal - calculation of Yk indicator for Poland and neighbour countries



clear all


%Conf110420;  %old data
%Conf160420;
%Conf250420;
%Conf020520;

%Conf070520;
%Conf230520;
%Conf270520;
Conf010620;
Conf100620;
%Conf230620;

Conf030720;  %confirmed cases data from 3 July 2020



mc=size(Conf); %248x65


% averaging of cell values in the absence of an increase for administrative reasons (e.g. no data provided)

oo=0;  % number of cases of no increase in the number of infections
for i=1:mc(1)
    for j=2:mc(2)-1
        if Conf(i,j)-Conf(i,j-1)==0 && Conf(i,j)>100 && Conf(i,j+1)-Conf(i,j-1)>15
            oo=oo+1;
            Conf(i,j)=(Conf(i,j-1)+Conf(i,j+1))/2;
        end
    end
end

oo
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

MA=7;
for i=MA+1:mc(2)
    for j=1:mc(1)
    
        ConfMA(j,i)=mean(Conf(j,i-MA:i));  %moving averages m=7
end
end
Conf=ConfMA;

%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%wyznaczanie najlepszego modelu dla Hubei
sumaCol=sum(Conf);%(ng,:); %tylko Hubei, gdy¿ ng=63


%dla róznych pañstw

no=0; %numer okna w subplocie
n2=0;
n3=0;  %gdy n3=1 to wydruk 3 najwiêkszych w fig. 25  w=[63 138 226]; %Hubei, W³óchy, USA
N=75; %liczba dni w macierzach CSSE


%vector of selected countries
ws=["Belarus", "Czechia","Germany", "Latvia","Lithuania", "Poland","Russia", "Slovakia", "Sweden", "Ukraine"];

%vector of number of rows in CSSE matrix for the aove metioned countries
w=[23 92 121 147 151 184 188 198 206 216];

for k=w;%
    ng=k;
    ngk(k)=0; %nr of country; if dont meet the below condition then  0
    if Conf(ng,N)>100 %100 is number of confirmed cases at the end of the row (N - current day)
        ngk(k)=k; %vectror of the coutries which met the condition
no=no+1;
marker=0;
thru(no)=0.03; %threshold of rapidly growth of Yk
%thru - should be validated for different countries after download new data
if no==1
    thru(1)=0.0150; %setting manually afetr new data loading
end
if no==2
    thru(2)=0.0200;
end
if no==3
    thru(3)=0.0200;
end
if no==4
    thru(4)=0.0200;
end
if no==5
    thru(5)=0.0200;
end
if no==6
    thru(6)=0.0120;
end
if no==7
    thru(7)=0.0120;
end
if no==8
    thru(8)=0.0150;
end
if no==9
    thru(9)=0.0150;
end
if no==10
    thru(10)=0.0150;
end

istu(no)=0;  %the threshold thru is crossing?
thrd(no)=0.005;  %thershold thrd (down) for clear decreasing of Yk
istd(no)=0; %the threshold thrd is crossing? 
istm(no)=0;
istuk(no)=0;
istum(no)=0; %middle threshold
istud(no)=0;
istp(no)=0;
istup(no)=0; %new next Yk growing
phase1(no)=0;
sumaCol=Conf(ng,:); % ng - country

y=sumaCol; %simply the same - Conf;
nz=find(y>3); % vector of non-zero y value; or larger than e.g. 3 in order to find the beginning of growth
pn=nz(1); % index of the first non-zero word or word at which the threshold was exceeded

Ym=y(end);%y(pb+10);conventional value of the instantaneous maximum Conf for normalization purposes
movingWindow=10;%10; % 
N=mc(2); %days number in CSSE matrices
for i=2:N
    currentDate=i;%pb+i;
    %Ym=max(y(2):y(i));
    
    yp(i)=y(currentDate)-y(currentDate-1); %daily increase odf Conf
    Yp(i)=yp(i)/Ym; %!!!!!! daily relative increase - important variable
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; %the day when thru was crossed by Yp 
        YpKr(no)=Yp(i); %relative critical value for a given country
        ykr(no)=YpKr(no)*Ym; %absolute value at which thru was exceeded
    end
    if Yp(i)<thru(no) && istu(no)==1 && istm(no)==0
        istm(no)=1;
        istum(no)=i; %the day when the thru threshold was exceeded
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0 && istm(no)==1
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; %the day when the thrd threshold was exceeded
    end
     if Yp(i)>2*thrd(no) && istu(no)==1 && istd(no)==1 && istm(no)==1 && istp(no)==0
        %istu(no)=0;
        istp(no)=1;
        istup(no)=i; %the day when the 2*thrd threshold was exceeded form bottom
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
     if istp(no)==1 && istm(no)==1 && istd(no)==1
        phase1(no)=4;
    end
   
    Yk(no)=Yp(N);  
    end %N
    
    
   
    
    
end



if no<=10  && istuk(no)>0%
    if n2==1
    figure(32)
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
     xlabel('Days', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
    end
    
    figure(31)
    t=sgtitle('Phases of the Epidemics for Poland and neighboring countries');
    t.FontSize=10;
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
    if istup(no)>0
    plot(istup(no), Yp(istup(no)), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'm')
    end
    title (['Phase is ', num2str(phase1(no)),' for ',num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Days', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
    
      figure(33)
    t=sgtitle('Confirmed cases in two points: after 80 days and today (after 132 days)'); %it's example
    t.FontSize=10;
    subplot(5,2,no)
    plot(y,'-b', 'LineWidth',2)
    hold on
    
    title ([num2str(ws(no))],'FontSize',7) 
     grid on
     xlabel('Days', 'FontSize',7)
     ylabel('Conf','FontSize',7)
    
     
  
end  %if no
   
    end %if Conf>1000
end %k=w

phase1;    %state of coronovirus development in the country in order according to k
nn=find(ngk); %find non-zero country numbers listed in the order as in the model vector
ph=[nn; phase1; Yk]' % country number in the CSSE matrix; epidemic phase; final Yp value
T1=table(nn', ws', phase1', round(Yk,4)')

figure(1)
bar(Yk)
title('Yk for considered countries')
xlabel('Countries')
ylabel('Yk')
text(0.7,0.006,'Bel')
text(1.6,0.016, 'Cze')
text(2.7,0.0027,'Ger')
text(3.7,0.002,'Lat')
text(4.7,0.0022,'Lit')
text(5.7,0.009,'Pol')
text(6.6,0.011,'Rus')
text(7.6,0.0075,'Slk')
text(8.6,0.0145,'Swe')
text(9.6,0.0196,'Ukr')




