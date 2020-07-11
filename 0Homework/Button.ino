/*
  Button

  Turns on and off a light emitting diode(LED) connected to digital pin 13,
  when pressing a pushbutton attached to pin 2.

  The circuit:
  - LED attached from pin 13 to ground
  - pushbutton attached to pin 2 from +5V
  - 10K resistor attached to pin 2 from ground

  - Note: on most Arduinos there is already an LED on the board
    attached to pin 13.

  created 2005
  by DojoDave <http://www.0j0.org>
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/Button
*/
int buttonOn = 0;         // variable for reading the pushbutton status

void setup() {
  // initialize the LED pin as an output:
  pinMode(6, OUTPUT);
  pinMode(7, INPUT);

  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);


}

void loop() {
  // read the state of the pushbutton value:
  buttonOn = digitalRead(7);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonOn == HIGH) {
    // turn LED on:
    digitalWrite(6, HIGH);
  } else {
    // turn LED off:
    digitalWrite(6, LOW);
  }

  buttonOn = digitalRead(9);
  
    // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
    if (buttonOn == HIGH) {
      // turn LED on:
      digitalWrite(8, HIGH);
    } else {
      // turn LED off:
      digitalWrite(8, LOW);
  }
}
