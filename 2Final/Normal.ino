#define Do 262
#define Re 294
#define Mi 330
#define Fa 349
#define Sol 392
#define La 440
#define Si 494
#define pu_length 500

String comdata = "";
int pu[pu_length] = {0};
int flag = 0;


int pin = 12; //自行选择作为输出的接口
int scale[] = {Do, Re, Mi, Fa, Sol, La, Si};
void setup() {
  pinMode(pin, OUTPUT);
  Serial.begin(9600);
}
void loop() {
  int j  = 0;

  while (Serial.available() > 0)
  {
    comdata += char(Serial.read());
    delay(2);
    flag = 1;
  }

  if (flag == 1) {
    for (int i = 0; i < comdata.length(); i++) {
      if (comdata[i] == ',') {
        j++;
      } else {
        pu[j] = pu[j] * 10 + (comdata[i] - '0');
      }
    }

    comdata = String("");
    flag = 0;
    for (int i = 0; i < pu_length; i++) {
      Serial.println(pu[i]);
      pu[i] = 0;
    }

  }

  for (int i = 0; i < 61; i++) {
    if (pu[i] != 100){
      tone(pin, scale[pu[i] - 1]);
    }else
    noTone(pin);
    delay(200);
    noTone(pin);
    delay(100);
  }
  delay(5000);
}
