% Графік і показники точності
figure;
plot(t, acc, t, gyro, t, lpf, t, comp, t, kal); grid on;
xlabel('t, с'); ylabel('\theta, град');
legend('акселерометр', 'гіроскоп', 'ФНЧ', 'комплементарний', 'Калман');

M = [acc gyro lpf comp kal];    % стовпці: акс, гіро, ФНЧ, компл, Калман
m = t >= win(1) & t < win(2);

if ~isempty(theta)              % модель: є справжній кут
    e = M - theta;
    s = t > t(end) - 15;        % висіння в кінці
    rmse    = sqrt(mean(e(m,:).^2))
    max_err = max(abs(e(m,:)))
    steady  = mean(e(s,:))
    b_est   = bk(end)
else                            % запис з датчика
    ref     = mean(acc(t < 2)); % кут у спокої на початку
    std_dev = std(M(m,:))
    max_dev = max(abs(M(m,:) - ref))
    drift   = mean(M(t > t(end)-2, :)) - mean(M(t >= 2 & t < 4, :))
end
