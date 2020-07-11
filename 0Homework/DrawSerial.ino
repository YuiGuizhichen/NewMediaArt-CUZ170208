void setup() {
  Serial.begin(9600);

}

void loop() {
  int variabel1 = int(random(255));

  Serial.print(variabel1);

  delay(100);

}
