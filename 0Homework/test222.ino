char val;
int ledPin = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available()) {
    val = Serial.read();
  }

  if (val == '1') {
     digitalWrite(ledPin, HIGH);
  } else {
     digitalWrite(ledPin, LOW);  
  }
}
