% Читання запису MPU-6050 (t_ms,ax,ay,az,gx,gy,gz) з папки CSV_Example
d = readmatrix(fullfile('CSV_Example', file));   % ADJUST: папка із записами
d = d(all(~isnan(d), 2), :);          % прибирає текстові рядки PuTTY
d = d(find(d(:,1) == 0, 1):end, :);   % бере дані після Reset

t  = (0:size(d,1)-1)' * dt;
ay = d(:,3) / 16384;
az = d(:,4) / 16384 - az0;

% ADJUST: модуль стоїть догори дном, тому мінуси.
% Якщо чипом догори - acc = atan2d(ay, az)
acc = atan2d(-ay, -az);

gx = d(:,5) / 131;                    % ADJUST: 131 для +-250 град/с, 65.5 для +-500
gx = gx - mean(gx(t < 2));            % калібрування: перші 2 с датчик нерухомий
theta = [];                           % справжній кут невідомий
