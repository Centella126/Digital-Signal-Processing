clear all
close all
clc

% Cargar audio
[y1, Fs1] = audioread ('LikeAPrayer.mp3');
y1 = y1(:,1);  %cambio el audio a un solo canal
%sound(y1,Fs1)
%clear sound    %detener el audio


%para el diezmado al 50% se hace 100 - (1/2)100
%para el diezmado al 75% se hace 100 - (1/4)100
%para el diezmado al 90% se hace 100 - (1/10)100

diezmado_50=y1(1:2:end, :); %si quisieramos cambiar la duración podemos poner por ejemplo end/6 indicará que solo se leerá 1/6 de la canción
diezmado_75=y1(1:4:end, :); 
diezmado_90=y1(1:10:end, :); 


t = (0:length(y1)-1) / Fs1;
t50 = (0:length(diezmado_50)-1) / (Fs1/2);
t75 = (0:length(diezmado_75)-1) / (Fs1/4);
t90 = (0:length(diezmado_90)-1) / (Fs1/10);

figure(1)
plot(t, y1);
title('Señal original');


figure(2)
subplot(1,2,1)
plot(t, y1); 
hold on;
plot(t50, diezmado_50); 
hold off;
title('Señal original y diezmada al 50%');
legend('Original', 'Diezmado 50%');  
grid on;  
subplot(1,2,2)
plot(t, y1); 
hold on;
plot(t50, diezmado_50); 
hold off;
title('Señal original y diezmada al 50%');
legend('Original', 'Diezmado 50%');  
grid on;  


figure(3)
subplot(1,2,1)
plot(t, y1); 
hold on;
plot(t75, diezmado_75); 
hold off;
title('Señal original y diezmada al 75%');
legend('Original', 'Diezmado 75%');  
grid on;        
subplot(1,2,2)
plot(t, y1); 
hold on;
plot(t75, diezmado_75); 
hold off;
title('Señal original y diezmada al 75%');
legend('Original', 'Diezmado 75%');  
grid on;   


figure(4)
subplot(1,2,1)
plot(t, y1); 
hold on;
plot(t90, diezmado_90); 
hold off;
title('Señal original y diezmada al 90%');
legend('Original', 'Diezmado 90%'); 
grid on;         
subplot(1,2,2)
plot(t, y1); 
hold on;
plot(t90, diezmado_90); 
hold off;
title('Señal original y diezmada al 90%');
legend('Original', 'Diezmado 90%'); 
grid on;  
