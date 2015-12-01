void setup() {
	Serial.begin(57600);
  	Serial.setTimeout(25);
	pinMode(d0, INPUT_PULLUP);
  	pinMode(d1, INPUT_PULLUP);
  	pinMode(d2, INPUT_PULLUP);
}

void loop() {
    ACC_READING_T accel = {0, 0, 0};

    accel = Bean.getAcceleration();
    uint16_t x = accel.xAxis;
    uint16_t y = accel.yAxis;
    uint16_t z = accel.zAxis;

    pinMode(d0, INPUT_PULLUP);
    pinMode(d1, INPUT_PULLUP);
    pinMode(d2, INPUT_PULLUP);

    d0 = x;
    d1 = y;
    d2 = z;

    Serial.write(d0);
    Serial.write(d1);
    Serial.write(d2);

    delay(10);
}



