// Запис сирих даних MPU-6050 у CSV (Arduino Uno R3)
// Підключення: VCC - 5V, GND - GND, SCL - A5, SDA - A4
// Вихід: t_ms,ax,ay,az,gx,gy,gz (сирі числа з датчика), 100 Гц, 115200 бод

#include <Wire.h>

const int MPU = 0x68;               // адреса датчика (AD0 на GND)
const unsigned long DT = 10000;     // ADJUST: період опитування, мкс (10000 = 100 Гц), у MATLAB тоді dt = 0.01
unsigned long tStart, tNext;

void writeReg(byte reg, byte val) {
  Wire.beginTransmission(MPU);
  Wire.write(reg);
  Wire.write(val);
  Wire.endTransmission();
}

int16_t read16() {
  return (Wire.read() << 8) | Wire.read();
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
  Wire.setClock(400000);

  writeReg(0x6B, 0x00);   // розбудити датчик
  writeReg(0x1A, 0x03);   // ADJUST: вбудований ФНЧ датчика, 0x03 = 44 Гц
  writeReg(0x19, 0x09);   // частота даних 1000/(1+9) = 100 Гц
  writeReg(0x1B, 0x00);   // ADJUST: гіроскоп +-250 град/с (131 од.); 0x08 = +-500 (65.5 од.) - тоді змінити 131 в load_mpu6050.m
  writeReg(0x1C, 0x00);   // акселерометр +-2g
  delay(100);

  Serial.println("t_ms,ax,ay,az,gx,gy,gz");
  tStart = millis();
  tNext = micros();
}

void loop() {
  if ((long)(micros() - tNext) < 0) return;   // чекає наступний такт
  tNext += DT;

  Wire.beginTransmission(MPU);
  Wire.write(0x3B);
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 14);

  int16_t ax = read16(), ay = read16(), az = read16();
  read16();
  int16_t gx = read16(), gy = read16(), gz = read16();

  Serial.print(millis() - tStart);
  int16_t v[6] = {ax, ay, az, gx, gy, gz};
  for (int i = 0; i < 6; i++) {
    Serial.print(',');
    Serial.print(v[i]);
  }
  Serial.println();
}
