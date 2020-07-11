int sensor = A0;
int sensorRead = 0;
int newdata = 0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  sensorRead = analogRead(sensor);
  newdata = map(sensorRead, 0, 1023, 0, 255);
  Serial.println(sensorRead);
  analogWrite(3, newdata);
  delay(200);

}
