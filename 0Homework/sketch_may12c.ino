#define AD5 A5
#define LED 13
int intensity = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(A5));
  Serial.print("\n");
  delay(5);
}
