% Передаточні функції, частотні характеристики і стійкість фільтрів
clear; clc; close all;
addpath('filters', 'input', 'analysis');   % папки з функціями
params;
Tf  = dt*(1 - alpha)/alpha      % стала часу ФНЧ, с
tau = dt*(1 - K)/K              % стала часу комплементарного, с

% усталений коефіцієнт Калмана (ітерації рівняння Ріккаті)
F = [1 -dt; 0 1];  H = [1 0];
Q = [0.001 0; 0 0.003]*dt;  R = 10;   % ADJUST: мають бути такі самі, як у kalman_filter.m
P = eye(2);
for i = 1:100000                % ітерацій з запасом, щоб точно зійшлось
    P = F*P*F' + Q;
    G = P*H' / (H*P*H' + R);
    P = (eye(2) - G*H)*P;
end
k1 = G(1)/dt                    % коефіцієнти неперервного еквівалента
k2 = -G(2)/dt

% стійкість: полюси дискретних фільтрів (мають бути |z| < 1)
pole_lpf  = 1 - alpha
pole_comp = 1 - K
pole_kal  = abs(eig((eye(2) - G*H)*F))
% Калман у неперервному вигляді: p^2 + k1*p + k2 = 0
roots_kal = roots([1 k1 k2])

% частотні характеристики (гілка акселерометра)
w = logspace(-2, 3, 2000);
p = 1i*w;
W_lpf  = 1 ./ (Tf*p + 1);
W_comp = 1 ./ (tau*p + 1);
W_kal  = (k1*p + k2) ./ (p.^2 + k1*p + k2);

figure;
subplot(2,1,1);
semilogx(w, 20*log10(abs([W_lpf; W_comp; W_kal]))); grid on;
ylabel('L, дБ'); legend('ФНЧ', 'комплементарний', 'Калман');
subplot(2,1,2);
semilogx(w, angle([W_lpf; W_comp; W_kal])*180/pi); grid on;
ylabel('\phi, град'); xlabel('\omega, рад/с');

% Найквіст: розімкнутий контур корекції Калмана W = (k1*p + k2)/p^2
W_open = (k1*p + k2) ./ p.^2;
figure;
plot(real(W_open), imag(W_open), -1, 0, 'r+'); grid on;
axis([-3 1 -3 1]); xlabel('Re'); ylabel('Im');
[~, i] = min(abs(abs(W_open) - 1));
w_cut = w(i)
phase_margin = 180 + angle(W_open(i))*180/pi

% запізнення ФНЧ на 0,5, 1 і 2 Гц
f = [0.5 1 2];
lag_deg = -atan(Tf*2*pi*f)*180/pi
