%covidGH Antoni Wilinski, Eryk Szwarc (C)2020
%script form covid5e5 to locate in GitHub repository


clear all

Conf110420; %Confirmed cases data prepared in matrix form rows = countries/regions CSSE; 
%to be prepared form CSSE JHU data

Rec110420;
Dea110420;

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
text(50,400000,'Confirmed')
text(55,110000,'Recovered')
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

no=0; %numer okna w subplocie
n3=0;  %gdy n3=1 to wydruk 3 najwiêkszych w fig. 25  w=[63 138 226]; %Hubei, W³óchy, USA
N=75; %liczba dni w macierzach CSSE


w=[24 51 61 63 82 117 121 138 176 184 226]; %wektor wybranych wierszy - pañstw
w=1:100;
w=[49 50 51 52 55 61 63 64 66 67 ];
w=[63 138 226]; %Hubei, W³ochy, USA
w=[24 51 63 82 117 121 138 140 144 226];
w=[24 51 63 82 117 121 134 138 140 144 226];
w=1:226;
w=[24 63 117 121 134 138 140 144 184 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States
w=[63 138 226]; %Hubei, W³ochy, USA
w=1:226;
w=[24 63 117 121 134 138 140 144 184 226]; %Belgium, Hubei, France, Germany, Iran, Italy, Japan, South Korea, Poland,United States


for k=w;%54:79%151:166
    ng=k;
    ngk(k)=0; %nry pañstw nie spe³niajacych warunku ponizej beda równe 0
    if Conf(ng,N)>1000
        ngk(k)=k; %wektor numerów pañstw spe³niajacych pow. warunek
no=no+1;
marker=0;
thru(no)=0.04; %próg osiagniecia przez wskaznik Yp wyraznego wzrostu
istu(no)=0;  %próg thru przekroczony?
thrd(no)=0.005;  %próg osiagniecia przez wskaznik Yp wyraznego spadku
istd(no)=0;  %próg thrd przekroczony?
istm(no)=0;
istuk(no)=0;
istum(no)=0;
istud(no)=0;
sumaCol=Conf(ng,:); % ng pañstwo

y=sumaCol; %uproszczona nazwa krzywej Conf;
nz=find(y>3); %wektor niezerowych wartosci y; lub wiêkszych od np. 3 po to, by znale¿æ poczatek wzrostu
pn=nz(1); %indeks pierwszego wyrazu niezerowego lub wyrazu, przy którym przekroczono zadany próg
%pnk(k)=pn;

%pb=pn+5; %poczatek badañ - powišzaæ z pn
Ym=y(end);%y(pb+10); %umowna warto?æ maksimum chwilowego Conf dla celów normalizacji
movingWindow=10;%10; %wielko?æ przesuwanego okna 
N=75; %liczba dni w macierzach CSSE
for i=2:N
    currentDate=i;%pb+i;
    %Ym=max(y(2):y(i));
    
    yp(i)=y(currentDate)-y(currentDate-1); %przyrost dobowy Conf
    Yp(i)=yp(i)/Ym; %!!!!!!!!!!!!! wzgledny przyrost
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; %dzien, w którym przekroczono próg thru
    end
    if Yp(i)<thru(no) && istu(no)==1 && istm(no)==0
        istm(no)=1;
        istum(no)=i; %dzien, w którym przekroczono próg thru
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0 && istm(no)==1
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; %dzien, w którym przekroczono próg thrd
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
    %nowy wskaznik - z przesuwanym oknem
    if i>movingWindow
    S(i)=std(y1(i-movingWindow:i));
    Sc=S(i);
    M(i)=mean(y1(i-movingWindow:i));
    
    Mc=M(i);
    if Mc~=0
    camInd(i)=Sc/Mc;  %wskaznik Camel Index
    else
    camInd(i)=0;    
    end
    end
    
    
end

if n3==1  %# najwiêksze przypadki
    figure(25)
    plot(Yp, 'LineWidth',3)
    hold on
    title('Hubei, Italy and USA')
     grid on
     text(12,0.10,'Hubei')
    text(47,0.03,'Italy')
    text(62,0.08,'USA')

    %wykresy "wyg³adzone"
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


if no<=10  && istuk(no)>0%do druku
    
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

phase;    %stan rozwoju koronowirusa w pañstwie w kolejnosci wg k
nn=find(ngk); %znajdz niezerowe numery pañstw wymienione w kolejnosci jak w  wektorze model
ph=[nn; phase]'



%dla jednego wybranego pañstwa
no=0; %numer okna w subplocie
w=63;  %nr pañstwa
hs=0; %horyzont symulacji
modelw=0;
for k=1:10;%54:79%151:166
    ng=w;
    sumaCol=Conf(ng,:); % ng pañstwo
    y=sumaCol; %uproszczona nazwa krzywej Conf;
   
    ngk(k)=0; %nry pañstw nie spe³niajacych warunku ponizej beda równe 0
    if Conf(ng,N)>1000
        ngk(k)=k; %wektor numerów pañstw spe³niajacych pow. warunek
    hs=k*5; 
    Ym=y(hs);
no=no+1;
marker=0;
thru(no)=0.04; %próg osiagniecia przez wskaznik Yp wyraznego wzrostu
istu(no)=0;  %próg thru przekroczony
thrd(no)=0.006;  %próg osiagniecia przez wskaznik Yp wyraznego spadku
istd(no)=0;  %próg thrd przekroczony
istuk(no)=0;
istud(no)=0;
sumaCol=Conf(ng,:); % ng pañstwo

%y=sumaCol; %uproszczona nazwa krzywej Conf;
nz=find(y>3); %wektor niezerowych wartosci y; lub wiêkszych od np. 3 po to, by znale¿æ poczatek wzrostu
pn=nz(1); %indeks pierwszego wyrazu niezerowego lub wyrazu, przy którym przekroczono zadany próg
%pnk(k)=pn;

%pb=pn+5; %poczatek badañ - powišzaæ z pn
Ym=y(end);%y(pb+10); %umowna warto?æ maksimum chw9ilowego Conf dla celów normalizacji
movingWindow=5;%10; %wielko?æ przesuwanego okna 
for i=2:hs
    currentDate=i;%pb+i;
    yp(i)=y(currentDate)-y(currentDate-1); %przyrost dobowy Conf
    Yp(i)=yp(i)/Ym;
    if Yp(i)>thru(no) && istu(no)==0
        istu(no)=1;
        istuk(no)=i; %dzien, w którym przekroczono próg thru
    end
    if Yp(i)<thrd(no) && istu(no)==1 && istd(no)==0
        %istu(no)=0;
        istd(no)=1;
        istud(no)=i; %dzien, w którym przekroczono próg thrd
    end
    if istud(no)==0
        modelw(no)=1;  %model z niezakoñzconym wzrostem
    else
        modelw(no)=2;  %model z maksimum 
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
