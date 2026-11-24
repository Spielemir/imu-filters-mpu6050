% Як коефіцієнт K комплементарного фільтра впливає на похибку (на моделі)
clear; clc; close all;
params;
sensor_model;
m = t > 2;
s = t > t(end) - 15;

Kv = [0.005 0.01 0.02 0.05 0.1];    % ADJUST: які K перебирати
figure; hold on; grid on;
for K = Kv
    clear complementary_filter
    comp = zeros(size(t));
    for k = 1:length(t)
        comp(k) = complementary_filter(acc(k), gx(k), K, dt);
    end
    e = comp - theta;
    tau = dt*(1-K)/K;
    fprintf('K=%.3f  tau=%.2f  b*tau=%.3f  rmse=%.3f  steady=%.3f  vib=%.3f\n', ...
        K, tau, b*tau, sqrt(mean(e(m).^2)), mean(e(s)), std(e(s)));
    plot(t, e);
end
xlabel('t, с'); ylabel('похибка, град');
legend(string(Kv));
