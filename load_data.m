% Вхідні дані: модель або запис з датчика (залежить від source)
if strcmp(source, 'model')
    sensor_model;
else
    file = source;
    load_mpu6050;
end
