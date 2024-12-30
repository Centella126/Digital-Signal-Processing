clear
close all
clc

[y1, Fs1] = audioread('LikeAPrayer_recortado.mp3'); 

% Contaminación de la señal con ruido de potencia limitada
ruido = 0.05 * randn(size(y1));
y_ruido = y1 + ruido;

% Preparación para graficar
l = length(y1);
LL = 1:l;

% FFT de la señal original
r(:,1) = fft(y1(:,1));
r(:,2) = fft(y1(:,2)); 

% Preparación del resultado para poder graficar
P2 = abs(r/l); 
P1 = P2(1:l/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Filtro pasa bajas Butterworth y Chebyshev 1 y 2
[bB,aB] = butter(4, 0.05, 'low');      % Butterworth
[bC1,aC1] = cheby1(4, 1, 0.05, 'low'); % Chebyshev 1
[bC2,aC2] = cheby2(4, 20, 0.05, 'low'); % Chebyshev 2

% Aplicación del filtro a la señal con ruido
y_filtro_B = filter(bB, aB, y_ruido);
y_filtro_C1 = filter(bC1, aC1, y_ruido);
y_filtro_C2 = filter(bC2, aC2, y_ruido);

% Filtro FIR para comparación
h_fir = fir1(4, 0.05, 'low');
y_filtro_FIR = filter(h_fir, 1, y_ruido);

% Comparación mediante FFT de las señales filtradas
rB = fft(y_filtro_B(:,1));
rC1 = fft(y_filtro_C1(:,1));
rC2 = fft(y_filtro_C2(:,1));
rFIR = fft(y_filtro_FIR(:,1));

% Magnitud de la FFT
PB = abs(rB/l); 
P1B = PB(1:l/2+1);
P1B(2:end-1) = 2*P1B(2:end-1);

PC1 = abs(rC1/l); 
P1C1 = PC1(1:l/2+1);
P1C1(2:end-1) = 2*P1C1(2:end-1);

PC2 = abs(rC2/l); 
P1C2 = PC2(1:l/2+1);
P1C2(2:end-1) = 2*P1C2(2:end-1);

PFIR = abs(rFIR/l); 
P1FIR = PFIR(1:l/2+1);
P1FIR(2:end-1) = 2*P1FIR(2:end-1);

% Graficar la señal original y la señal contaminada
figure
subplot(3,1,1)
plot(LL, y_ruido(:,1), 'DisplayName', 'Contaminada con ruido')
hold on
plot(LL, y1(:,1), 'DisplayName', 'Original')
legend

% Graficar FFT de la señal filtrada
subplot(3,1,2)
plot(P1, 'DisplayName', 'Original')
hold on
plot(P1FIR, 'DisplayName', 'FIR')
plot(P1B, 'DisplayName', 'Butterworth')
plot(P1C1, 'DisplayName', 'Chebyshev 1')
plot(P1C2, 'DisplayName', 'Chebyshev 2')
legend
title('Respuesta en Frecuencia')

% Graficar señales filtradas en el dominio del tiempo
subplot(3,1,3)
plot(LL, y_filtro_B(:,1), 'DisplayName', 'Butterworth')
hold on
plot(LL, y_filtro_FIR(:,1), 'DisplayName', 'FIR')
plot(LL, y_filtro_C1(:,1), 'DisplayName', 'Chebyshev 1')
plot(LL, y_filtro_C2(:,1), 'DisplayName', 'Chebyshev 2')
legend
title('Respuesta en el Dominio del Tiempo')

% Medición de correlación para determinar el desempeño de cada filtro
correlacion_orig_ruido = corr2(y1, y_ruido);
correlacion_orig_B = corr2(y1, y_filtro_B);
correlacion_orig_C1 = corr2(y1, y_filtro_C1);
correlacion_orig_C2 = corr2(y1, y_filtro_C2);
correlacion_orig_FIR = corr2(y1, y_filtro_FIR);



