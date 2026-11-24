% Для перевірки даниз без Simulink ()
clear; clc; close all;
clear complementary_filter kalman_filter    % скидаю стан фільтрів
params;

% ADJUST: що фільтрувати і на якому інтервалі рахувати похибки
source = 'model';   % 'model', 'rest.csv', 'tilt.csv', 'vibration.csv', 'tilt_vibration.csv'
win = [2 inf];      % для vibration.csv: [5 67]

load_data;
N = length(t);
gyro = [0; cumsum(gx(1:end-1))*dt];         % тільки гіроскоп
lpf = filter(alpha, [1 alpha-1], acc);       % ФНЧ
comp = zeros(N,1);  kal = zeros(N,1);  bk = zeros(N,1);
for k = 1:N
    comp(k) = complementary_filter(acc(k), gx(k), K, dt);
    [kal(k), bk(k)] = kalman_filter(acc(k), gx(k), dt);
end

filter_metrics;
