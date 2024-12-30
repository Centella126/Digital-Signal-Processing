clear
close all
clc

% Cargar señal de audio
[x, Fs1] = audioread('LikeAPrayer.mp3'); % Leer archivo de audio

% Generación de ruido blanco y contaminación de la señal
ruido = 0.05 * randn(size(x));          % Generar ruido blanco de potencia limitada
y_contaminada = x + ruido;              % Señal contaminada con ruido

% Preparación de variables
L = length(x);                          % Longitud de la señal
t = (0:L-1) / Fs1;                      % Vector de tiempo asociado a la señal

% Diseño de un filtro pasa banda IIR (Butterworth)
Wn = [200 2000] / (Fs1 / 2);            % Frecuencias de corte normalizadas (Hz)
[bi, ai] = butter(6, Wn, 'bandpass');   % Filtro Butterworth de orden 6
X_banda_Butter = filtfilt(bi, ai, y_contaminada); % Filtrar la señal con el filtro IIR

% Diseño de un filtro FIR pasa banda
bf = fir1(50, Wn, 'bandpass');          % Filtro FIR de orden 50
X_banda_FIR = filtfilt(bf, 1, y_contaminada);     % Filtrar la señal con el filtro FIR

% Visualización de resultados
figure
% Señales filtradas y original
subplot(2,1,1)
plot(t, y_contaminada(:,1))        % Señal contaminada
hold on
plot(t, x(:,1))                   % Señal original
plot(t, X_banda_Butter(:,1))      % Señal filtrada con el filtro IIR
plot(t, X_banda_FIR(:,1))         % Señal filtrada con el filtro FIR
legend('Señal contaminada', 'Filtro IIR', 'Filtro FIR', 'Original') % Leyenda
title('Señales filtradas y contaminada')
xlabel('Tiempo (s)')
ylabel('Amplitud')

% Diferencias entre señales
dif_FIR = y_contaminada - X_banda_FIR;  % Diferencia entre señal contaminada y filtrada FIR
dif_IIR = y_contaminada - X_banda_Butter; % Diferencia entre señal contaminada y filtrada IIR
subplot(2,1,2)
plot(t, y_contaminada(:,1))
hold on
plot(t, dif_IIR(:,1))
plot(t, dif_FIR(:,1))             % Diferencia para el filtro IIR
plot(t, ruido(:,1))             % Diferencia para el filtro FIR
legend('señal contaminada', 'Diferencia IIR', 'Diferencia FIR', 'Ruido') % Leyenda
title('Diferencias entre señal contaminada y filtrada')
xlabel('Tiempo (s)')
ylabel('Amplitud')

% Correlación entre señal contaminada y señales filtradas
corr_IIR = corr2(x, X_banda_Butter);
corr_FIR = corr2(x, X_banda_FIR);

% Mostrar resultados en consola
fprintf('Correlación Filtro IIR: %.4f\n', corr_IIR);
fprintf('Correlación Filtro FIR: %.4f\n', corr_FIR);



