import processing.serial.*;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;


import processing.core.*;
import processing.opengl.PGraphics2D;

DwFluid2D fluid;
PGraphics2D pg_fluid;

ArrayList<Boid> boids = new ArrayList<Boid>(); //To store all boids in.
ArrayList<Predator> preds = new ArrayList<Predator>(); //To store all predators in.
int boidNum = 150; //Initial number of boids created.
int predNum = 10; //Initial number of predators created.
PVector mouse; //Mouse-vector to use as obstacle.
float obstRad = 60; //Radius of mouse-obstacle.
int boolT = 0; //Keeps track of time to improve user-input.

boolean flocking = true; //Toggle flocking.
boolean arrow = true; //Toggle arrows.
boolean circle = false; //Toggle circles.
boolean predBool = true; //Toggle predators.
boolean obsBool = false; //Toggle obstacles.

Serial myPort;
float inByte;
boolean newData = false;

public void settings() {
  size(1280, 720, P2D);
}

public void setup() {
  myPort = new Serial(this, "COM3", 9600);  
  myPort.bufferUntil('\n');

  for (int i=0; i<boidNum; i++) { //Make boidNum boids.
    boids.add(new Boid(new PVector(random(0, width), random(0, height))));
  }
  for (int j=0; j<predNum; j++) { //Make predNum predators.
    preds.add(new Predator(new PVector(random(0, width), random(0, height)), 50));
  }

  // library context
  DwPixelFlow context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // fluid simulation
  fluid = new DwFluid2D(context, width, height, 1);

  // some fluid parameters
  fluid.param.dissipation_velocity = 0.40f;
  fluid.param.dissipation_density  = 0.29f;

  //// adding data to the fluid simulation
  //fluid.addCallback_FluiData(new  DwFluid2D.FluidData() {
  //  public void update(DwFluid2D fluid) {
  //    for (Boid boid : boids) {
  //      float px     = boid.loc.x;
  //      float py     = height - boid.loc.y;
  //      float vx     = (boid.vel.x) * +15;
  //      float vy     = (boid.vel.y) * -15;
  //      fluid.addVelocity(px, py, 14, vx, vy);
  //      fluid.addDensity (px, py, 10, 0.3f, 0.3f, 0.3f, 0.8f);
  //      //boid.display(circle, arrow);
  //    }
  //    for (Predator pred : preds) {
  //      float px     = pred.loc.x;
  //      float py     = height - pred.loc.y;
  //      float vx     = (pred.vel.x) * +15;
  //      float vy     = (pred.vel.y) * -15;
  //      fluid.addVelocity(px, py, 14, vx, vy);
  //      fluid.addDensity (px, py, 20, 0.5f, 0.0f, 0.0f, 1.0f);
  //      //boid.display(circle, arrow);
  //    }
  //  }
  //}
  //);

  // render-target
  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);

  frameRate(60);
}


public void draw() {
  println(inByte);
  // adding data to the fluid simulation
  if (newData) {
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData() {
      public void update(DwFluid2D fluid) {
        for (Boid boid : boids) {
          float px     = boid.loc.x;
          float py     = height - boid.loc.y;
          float vx     = (boid.vel.x) * +15;
          float vy     = (boid.vel.y) * -15;
          fluid.addVelocity(px, py, 14, vx, vy);
          fluid.addDensity (px, py, 10, 0.3f, 0.3f, 0.3f, 0.8f);
          //boid.display(circle, arrow);
        }
        for (Predator pred : preds) {
          float px     = pred.loc.x;
          float py     = height - pred.loc.y;
          float vx     = (inByte);
          float vy     = (-inByte);
          fluid.addVelocity(px, py, 14, vx, vy);
          fluid.addDensity (px, py, 20, 0.5f, 0.0f, 0.0f, 1.0f);
          //boid.display(circle, arrow);
        }
      }
    }
    );
  }

  for (Boid boid : boids) { //Cycle through all the boids and to the following for each:

    if (predBool) { //Flee from each predator.
      for (Predator pred : preds) { 
        PVector predBoid = pred.getLoc();
        boid.repelForce(predBoid, obstRad);
      }
    }
    if (obsBool) { //Flee from mouse.
      mouse = new PVector(mouseX, mouseY);
      boid.repelForce(mouse, obstRad);
    }
    if (flocking) { //Execute flocking rules.
      boid.flockForce(boids);
    }

    boid.display(circle, arrow); //Draw to screen.
  }

  for (Predator pred : preds) {
    //Predators use the same flocking behaviour as boids, but they use it to chase rather than flock.
    if (flocking) { 
      pred.flockForce(boids);
      for (Predator otherpred : preds) { //Predators should not run into other predators.
        if (otherpred.getLoc() != pred.getLoc()) {
          pred.repelForce(otherpred.getLoc(), 30.0);
        }
      }
    }
    pred.display();
  }
  // update simulation
  fluid.update();

  // clear render target
  pg_fluid.beginDraw();
  pg_fluid.background(255);
  pg_fluid.endDraw();

  // render fluid stuff
  fluid.renderFluidTextures(pg_fluid, 0);

  // display
  image(pg_fluid, 0, 0);
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);                // trim off whitespaces.
    inByte = float(inString);           // convert to a number.
    inByte = map(inByte, 20, 60, 30, inByte); //map to the screen height.
    newData = true;
  }
}
