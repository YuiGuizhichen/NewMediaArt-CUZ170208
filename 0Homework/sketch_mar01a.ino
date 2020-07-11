const byte startPin = 1;
const byte endPin = 6;
byte lightPin = startPin;

void setup() {
  //设置输出端口

for(byte i = startPin; i<= endPin; i++ ) {
    pinMode(i, OUTPUT);
  }
}

void loop() {
  for(byte i = startPin; i<= endPin; i++ ) {
    digitalWrite(i, LOW);
    }

    digitalWrite(lightPin, HIGH);
    if(lightPin<endPin){
      lightPin++;
      }else{
       lightPin = startPin;
      }
      delay(100);
}
