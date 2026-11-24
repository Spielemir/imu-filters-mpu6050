% Похибки в положеннях і запізнення

% ADJUST: проміжки, де датчик лежав нерухомо: [початок, кінець (с), кут (град)].
% Підбираються по графіку свого запису
if strcmp(source, 'tilt.csv')
    pos = [7 11 -90; 23 27 90; 38 40.7 0];
else
    pos = [10 12.8 90; 16 18 0; 22 25.8 -90; 29.5 34.5 0];
end

ref0 = mean(acc(t < 2));
for i = 1:size(pos, 1)
    m = t >= pos(i,1) & t < pos(i,2);
    ref = pos(i,3);
    if ref == 0, ref = ref0; end
    fprintf('%g град:  похибка %s   СКВ %s\n', pos(i,3), ...
        mat2str(mean(M(m,:)) - ref, 2), mat2str(std(M(m,:)), 2));
end

% запізнення відносно акселерометра на поворотах
if strcmp(source, 'tilt.csv')
    for j = 1:5
        d1(j) = t(find(M(:,j) < -45, 1));
        d2(j) = t(find(t > 19 & M(:,j) > 45, 1));
    end
    delay = ((d1 - d1(1)) + (d2 - d2(1))) / 2
end
