%covid1 AW(C)2020
%
%covid5europe2 GH skrypt dla GH z Polsk¹



clear all
%dane
%Conf260320a; %macierz potwierdzonych przypadków zaka¿enia

Conf110420;
%Conf160420;
%Conf250420;
%Conf020520;

%Conf070520;
%Conf230520;
%Conf270520;
Conf010620; %aktualne dany z CSSE JHU
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
mr=size(Rec); %inna, mniejsza liczba wierszy - 234
md=size(Dea); %248x65

%u?redniania wartosci komórek przy braku przyrostu z powodów administarcyjnych (np. nie przekazano danych) 

oo=0;  %liczba przypadków braku wzrostu liczby zaka¿eñ
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



%wyznaczanie najlepszego modelu dla Hubei
sumaCol=sum(Conf);%(ng,:); %tylko Hubei, gdy¿ ng=63
sumaColRec=sum(Rec);%(42,:); %54
sumaColDea=sum(Dea);%(ng,:);


%dla róznych pañstw

no=0; %numer okna w subplocie
n2=0;
n3=0;  %gdy n3=1 to wydruk 3 najwiêkszych w fig. 25  w=[63 138 226]; %Hubei, W³óchy, USA
N=75; %liczba dni w macierzach CSSE



ws=["Germany", "Hungary", "Italy","Latvia","Lithuania", "Norge", "Poland","Romania","Russia", "Slovakia"];



w=[17 23 24 31 88 92 95 103 107 117 ];%Austria, Belarus, Belgium, Croatia, Czech, Denmark, Eesti, Finland, France
w=[121 130 138 147 151 176 184 187 188 198];

for k=w;%54:79%151:166
    ng=k;
    ngk(k)=0; %nry pañstw nie spe³niajacych warunku ponizej beda równe 0
    if Conf(ng,N)>1000
        ngk(k)=k; %wektor numerów pañstw spe³niajacych pow. warunek
no=no+1;
marker=0;
thru(no)=0.04; %próg osiagniecia przez wskaznik Yp wyraznego wzrostu
%thru validation for different countries after downlod new data
if no==1
    thru(1)=0.030;
end
if no==3
    thru(3)=0.0200;
end
if no==7
    thru(7)=0.020;
end
if no==8
    thru(8)=0.020;
end
if no==9
    thru(9)=0.0200;
end

istu(no)=0;  %próg thru przekroczony?
thrd(no)=0.005;  %próg osiagniecia przez wskaznik Yp wyraznego spadku
istd(no)=0;  %próg thrd przekroczony?
istm(no)=0;
istuk(no)=0;
istum(no)=0;
istud(no)=0;
phase1(no)=0;
sumaCol=Conf(ng,:); % ng pañstwo

y=sumaCol; %uproszczona nazwa krzywej Conf;
nz=find(y>3); %wektor niezerowych wartosci y; lub wiêkszych od np. 3 po to, by znale¿æ poczatek wzrostu
pn=nz(1); %indeks pierwszego wyrazu niezerowego lub wyrazu, przy którym przekroczono zadany próg
%pnk(k)=pn;

%pb=pn+5; %poczatek badañ - powišzaæ z pn
Ym=y(end);%y(pb+10); %umowna warto?æ maksimum chwilowego Conf dla celów normalizacji
movingWindow=10;%10; %wielko?æ przesuwanego okna 
N=mc(2); %liczba dni w macierzach CSSE
for i=2:N
    currentDate=i;%pb+i;
    %Ym=max(y(2):y(i));
    
    yp(i)=y(currentDate)-y(currentDate-1); %przyrost dobowy Conf
    Yp(i)=yp(i)/Ym; %!!!!!! wzgledny przyrost
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
   
    Yk(no)=Yp(N);  
    end %N
    
    a=find(phase1==0);  %poszukiwanie pañstw ze zbyt wysokim progiem thru
        
        
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



if no<=10  && istuk(no)>0%do druku
    
    
    figure(31)
    t=sgtitle('Phases of the Epidemics for the different countries');
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
    title (['Phase is ', num2str(phase1(no)),' for ',num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Days', 'FontSize',7)
     ylabel('Yp Indicator','FontSize',7)
    
      figure(33)
    t=sgtitle('Confirmed cases in two points: after 80 days and today (after 132 days)');
    t.FontSize=10;
    subplot(5,2,no)
    plot(y,'-b', 'LineWidth',2)
    hold on
    
    title ([num2str(ws(no))],'FontSize',7) 
    %title(['Temperature is ',num2str(c),' C'])
     grid on
     xlabel('Days', 'FontSize',7)
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
    
    % grid on
end  %if no
   
    end %if Conf>1000
end %k=w

phase1;    %stan rozwoju koronowirusa w pañstwie w kolejnosci wg k
nn=find(ngk); %znajdz niezerowe numery pañstw wymienione w kolejnosci jak w  wektorze model
ph=[nn; phase1; Yk]' %numer pañstwa w macierzy CSSE; faza epidemii; koñcowa wartoœæ Yp



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


   
    end
end
