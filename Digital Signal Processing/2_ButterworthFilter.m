clear
close all
clc

% Cargar audio
[y1, Fs1] = audioread('LikeAPrayer.mp3'); 

% Obtiene la longitud del vector de audio
l = length(y1);
LL = 1:l;
L = length(y1);

%TF
r(:,1) = fft(y1(:,1));
r(:,2) = fft(y1(:,2)); 

P2 = abs(r/L); %se obtiene la magnitud para tener toda la info del num complejo
P1 = P2(1:L/2+1); %para obtener freq tanto positivas como negativas
P1(2:end-1) = 2*P1(2:end-1);

% Grafica la señal de audio y su espectro de frecuencias
figure
subplot(2,1,1)
plot(LL, y1(:,1))
hold on
subplot(2,1,2)
plot(P1)
hold off

% Filtro Butterworth
[b, a] = butter(2, 0.025, 'low'); % Filtro pasa bajas de orden 2

% Aplica el filtro al audio original
yf1 = filter(b, a, y1);

% Realiza la FFT en la señal filtrada
rf(:,1) = fft(yf1(:,1));
rf(:,2) = fft(yf1(:,2)); 


Pf2 = abs(rf/L);
Pf1 = Pf2(1:L/2+1);
Pf1(2:end-1) = 2*Pf1(2:end-1);

yff1 = filtfilt(b, a, y1);


rff(:,1) = fft(yff1(:,1));
rff(:,2) = fft(yff1(:,2)); 

% Calcula la magnitud de la FFT de la señal sin desfase 
Pff2 = abs(rff/L);
Pff1 = Pff2(1:L/2+1);
Pff1(2:end-1) = 2*Pff1(2:end-1);

% Grafica el espectro de frecuencias para la señal filtrada
hold on
plot(Pf1)
plot(Pff1)

% Grafica la señal de audio filtrada en el primer subplot
subplot(2,1,1)
plot(LL, yf1(:,1))

% Muestra la respuesta en frecuencia del filtro Butterworth
figure
freqz(b, a, [], Fs1)




