import processing.serial.*; //<>//

Serial mySerial;

String myString = null;
int nl = 10;
float myVal;

void setup() {
  size(400, 400);

  String myPort = Serial.list() [1];
  mySerial = new Serial(this, myPort, 9600);
  smooth();
}

void draw() {

  while (mySerial.available() > 0) {
    myString = mySerial.readStringUntil(nl);

    if (myString != null) {
      background(0);
      myVal = float(myString);

      myVal = myVal/100 *height;


      rectMode(CENTER);
      rect(width/2, height-(myVal/2), 200, myVal);
      fill(myVal, myVal/2, myVal+100, myVal*2);
    }
  }
}
