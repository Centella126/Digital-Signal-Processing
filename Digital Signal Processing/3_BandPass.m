%para hacer un pasa banda se debe de hacer con un arreglo en cascada
    %no importa si es el altas antes o después, mientras a>b
    %a=wc del filtro pasa altas, b=wc del filtro pasa bajas

clear
close all
clc

[y1, Fs1] = audioread('LikeAPrayer.mp3'); 

l = length(y1);
LL = 1:l;

L = length(y1);
r(:,1) = fft(y1(:,1));
r(:,2) = fft(y1(:,2)); 

%preparación del resultado para poder graficar
P2 = abs(r/L); 
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
subplot(2,1,1)
plot(LL,y1(:,1))
hold on

subplot(2,1,2)
plot(P1)
hold on

%% Diseño e implementación del filtro pasabandas en cascada
[bb,ab]=butter(4,0.02,"low"); %pasabajas

[ba,aa]=butter(4,0.01,"high"); %pasaaltas

%pasabandas con comando directo 
[b,a]=butter(2,[0.01 0.02],"bandpass");
yf3=filter(b,a,y1);

%usando primero el pasaaltas y luego pasabajas
w1=filter(ba,aa,y1);
yf1=filter(bb,ab,w1);

%usando primero el pasabajas y luego pasaaltas
s1=filter(bb,ab,y1);
yf2=filter(ba,aa,s1);

%% Análisis de los resultados
% Resultados del filtro en cascada primero el pasaaltas
r1(:,1) = fft(yf1(:,1));
r1(:,2) = fft(yf1(:,2)); 
PQ2 = abs(r1/L); 
PQ1 = PQ2(1:L/2+1);
PQ1(2:end-1) = 2*PQ1(2:end-1);
subplot(2,1,2)
plot(PQ1)

% Resultados del filtro en cascada primero el pasabajas
r2(:,1) = fft(yf2(:,1));
r2(:,2) = fft(yf2(:,2)); 
PR2 = abs(r2/L); 
PR1 = PR2(1:L/2+1);
PR1(2:end-1) = 2*PR1(2:end-1);
subplot(2,1,2)
plot(PR1)

%solo se ven dos graficas, una señal queda oculta porque no importa el
%orden en que se están acomodados los filtros, saldrá una pasabanda

% Resultados del filtro pasabandas directo
r3(:,1) = fft(yf3(:,1));
r3(:,2) = fft(yf3(:,2)); 
PT2 = abs(r3/L); 
PT1 = PT2(1:L/2+1);
PT1(2:end-1) = 2*PT1(2:end-1);
subplot(2,1,2)
plot(PT1)

%% Comparando señales
error=yf1-yf2;

figure
plot(error)

%Error cuadrático medio
%ecm=mse(yf1,yf2) %no tengo la librería
ecm=sum(sqrt((yf1-yf2).^2))/l;

correlacion_yf1_yf2=corr2(yf1,yf2)
correlacion_yf1_yf3=corr2(yf1,yf3)
correlacion_yf2_yf3=corr2(yf2,yf3)


