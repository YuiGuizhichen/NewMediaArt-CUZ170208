#define AD5 A5
#define LED 13
int intensity = 0;

void setup() {
  pinMode(LED, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  intensity = analogRead(AD5);
//  Serial.write(intensity/4);
  int passInt = intensity/4;
  Serial.println(passInt);
  delay(1000);
}
