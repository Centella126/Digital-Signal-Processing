%para hacer un banda prohibida es necesario un arreglo en celosía
    % con condicion b>a


clear
close all
clc

[y1, Fs1] = audioread('LikeAPrayer.mp3'); 

l = length(y1);
LL = 1:l;

L = length(y1);
r(:,1) = fft(y1(:,1));
r(:,2) = fft(y1(:,2)); 

% Preparación del resultado para graficar
P2 = abs(r/L); 
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
subplot(2,1,1)
plot(LL, y1(:,1))
hold on

subplot(2,1,2)
plot(P1)
hold on

%% Diseño e implementación del filtro banda prohibida en celosía
[bb, ab] = butter(4, 0.01, "low");    % Pasabajas

[ba, aa] = butter(4, 0.02, "high");   % Pasaaltas

% 1. Implementación del filtro banda prohibida en configuración de celosía
% Se aplica el filtro pasaaltas y el filtro pasabajas en paralelo y se suman sus resultados
yf1 = filter(bb, ab, y1) + filter(ba, aa, y1);


% 2. Usando el filtro de banda prohibida directo para comparar
% banda prohibida con comando directo
[bs, as] = butter(2, [0.01 0.02], "stop");
yf2 = filter(bs, as, y1);

%% Análisis de los resultados
% Calcular FFT y graficar para cada enfoque

% Resultados del filtro en celosía
r1(:,1) = fft(yf1(:,1));
r1(:,2) = fft(yf1(:,2)); 
PQ2 = abs(r1/L); 
PQ1 = PQ2(1:L/2+1);
PQ1(2:end-1) = 2*PQ1(2:end-1);
subplot(2,1,2)
plot(PQ1)

% Resultados del filtro de banda prohibida directo
r2(:,1) = fft(yf2(:,1));
r2(:,2) = fft(yf2(:,2)); 
PR2 = abs(r2/L); 
PR1 = PR2(1:L/2+1);
PR1(2:end-1) = 2*PR1(2:end-1);
subplot(2,1,2)
plot(PR1)

%% Comparación de señales
error = yf1 - yf2;

figure
plot(error)
title('Error entre filtro en celosía y filtro directo de banda prohibida')

% Error cuadrático medio
ecm = sum(sqrt((yf1 - yf2).^2)) / l;

% Correlación entre señales
correlacion_yf1_yf2 = corr2(yf1, yf2)


