int buttonOn1 = 0;
int buttonOn2 = 0;

void setup() {
  pinMode(6, OUTPUT);
  pinMode(3, OUTPUT);
}

void loop() {
    buttonOn1 = digitalRead(6);
    if(buttonOn1 == HIGH) {
      digitalWrite(6, LOW);
    }else{
      digitalWrite(6, HIGH);   
    }

    buttonOn2 = digitalRead(3);
      if(buttonOn2 == HIGH) {
        digitalWrite(3, LOW);
      }else{
        digitalWrite(3, HIGH);   
      }
}
