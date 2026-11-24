function th = complementary_filter(acc, gx, K, dt)
% Комплементарний фільтр: кут з гіроскопа + трохи кута з акселерометра
persistent y
if isempty(y)
    y = acc;
end
y = (1 - K)*(y + gx*dt) + K*acc;
th = y;
end
