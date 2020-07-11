import processing.serial.*;  //<>// //<>// //<>//

Serial myPort;

float dampLow = 0.65;
float dampHigh = 0.9;
float wallDamp = 0.99;

int maxVel = 100;
int maxGroundTime = 300;
int[] scale = {0, 2, 3, 7, 14, 15 }; 
int scaleOct = 4;
float windLevelH = 4;
float windLevelV = 0.2 * 1.3;

boolean applyWind = true; 

PVector gravity, wind, acc;
color c;
float t = 0;
ArrayList<Ball> balls;


void setup() {

  myPort = new Serial(this, Serial.list()[1], 9600);

  frameRate(60);
  println("frame rate: " + frameRate);
  size(600, 1000);

  gravity = new PVector(0, 0.2);
  wind = new PVector(random(-0.1, 0.1), 0);
  println("wind level: " + wind.x);

  balls = new ArrayList<Ball>();
}

void draw() {

  background(255);

  float noiseX = map(noise(t * 0.5), 0, 1, -windLevelH, windLevelH);
  float noiseY = map(noise(t + 1), 0, 1, -windLevelV, windLevelV);
  wind = new PVector(noiseX, noiseY);
  pushMatrix();

  colorMode(HSB);
  fill(150, 180, 180, map(abs(noiseX), 0, windLevelH, 0, 180));
  noStroke();
  rect(width/2, 20, map(wind.x, -windLevelH, windLevelH, -width / 2, width / 2), 10);
  fill(150, 180, 180, map(abs(noiseY), -windLevelV, windLevelV, 0, 180));
  rect(20, height /2, 10, map(wind.y, -windLevelV, windLevelV, -height / 2, height / 2));

  popMatrix();
  if (balls.size() > 0) {
    for (int i = 0; i < balls.size(); i++) {

      Ball ball = balls.get(i);
      ball.applyForce(gravity);
      if (applyWind)
        ball.applyForceWeighted(wind);

      if (ball.update()) {
        ball.show();
        if (ball.location.y >= height) {
          if (ball.vel > 10) {
            myPort.write(ball.vel);
            println("current vel is: " + ball.vel);
          }
        }
      } else {  
        balls.remove(i);
        i = 1 - 1;
        //println("ball removed, total " + balls.size());
      }
    }
  }
  t += 0.01 * 0.5;
}

void mousePressed() {
  balls.add(new Ball());
  //println("ball added, total " + balls.size());
}


class Ball {

  PVector location;
  PVector velocity;
  color col;
  int note;
  public int vel;
  float mass;
  int groundTime = 0;
  Ball() {
    location = new PVector(mouseX, mouseY);
    mass = map(mouseY, height, 0 + 40, 0, random(0.95, 1));
    velocity = new PVector(random(-2, 2), random(0, 1) * 1);
    note = mapNote(map(location.x, 0, width, 0, 1));
    vel = floor(map(abs(velocity.y), 0, 10, 0, maxVel));
    colorMode(HSB);
    //int alpha = round(map(velocity.y,0,2,0,255));
    col = color(random(255), 255, 255, 255);
  }
  void applyForce(PVector force) {
    velocity.add(force);
  }
  void applyForceWeighted(PVector force) {
    velocity.add(PVector.mult(force, 1 - mass));
  }
  boolean update() {
    location.add(velocity);
    if (location.x < 0 ) {
      velocity.x = velocity.x * -1 * wallDamp;
      location.x = 0;
    }
    if (location.x > width ) {
      velocity.x = velocity.x *  -1 * wallDamp;
      location.x = width;
    }

    if (location.y < 0) {
      velocity.y = velocity.y * -1 * wallDamp;
      location.y = 0;
    }
    if (location.y >= height) bounce();

    if (velocity.y < 0.5 && location.y >= height) {
      groundTime++;
    }

    if (groundTime > maxGroundTime) return false;
    else return true;
  }
  int bounce() {
    velocity.y *=  -0.99 * map(location.x, 0, width, dampLow, dampHigh);
    if (abs(velocity.y) >= 0.4) {
      note = mapNote(map(location.x, 0, width, 0, 1));
      vel = floor(map(abs(velocity.y), 0, 10, 0, maxVel));

      colorMode(HSB);
      int alpha = round(map(vel, 0, maxVel, 0, 255));
      col = color(hue(col), saturation(col), brightness(col), alpha);
      //print("bounce==="+vel+",");
      //myPort.write(vel+",");
    }

    location.y = height;
    return vel;
  }
  void show() { 
    fill(col);
    noStroke();
    int size = floor(map(mass, 0, 1, 10, 40));
    ellipse(location.x, location.y, size, size);
  }
  public int vels = vel;
}

int mapNote(float in) {
  int root = 36;
  int noteCount = scale.length * scaleOct;
  in = constrain(in, 0, 1);
  int x = round(map(in, 0, 1, 0, noteCount));
  int i = x % scale.length;
  int iOct = x / scale.length;
  int note = scale[i] + 12 * iOct + root;
  return note;
}
