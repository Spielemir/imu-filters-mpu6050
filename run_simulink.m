% Фільтрація через Simulink (модель imu_filters.slx)
clear; clc; close all;
params;

% ADJUST: що фільтрувати і на якому інтервалі рахувати похибки
source = 'model';   % 'model', 'rest.csv', 'tilt.csv', 'vibration.csv', 'tilt_vibration.csv'
win = [2 inf];      % для vibration.csv: [5 67]

load_data;
acc_in = [t acc];   % для блоків From Workspace
gx_in  = [t gx];

out = sim('imu_filters', 'StopTime', num2str(t(end)));
gyro = out.gyro;  lpf = out.lpf;  comp = out.comp;
kal = out.kal;    bk = out.bk;

n = length(lpf);    % Simulink іноді віддає на 1 точку менше
t = t(1:n);  acc = acc(1:n);
if ~isempty(theta), theta = theta(1:n); end

filter_metrics;
