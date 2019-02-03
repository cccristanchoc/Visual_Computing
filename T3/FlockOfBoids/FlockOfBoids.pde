/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
Interpolator interpolator;
//flock bounding box
int flockWidth = 640;
int flockHeight = 640;
int flockDepth = 600;
boolean avoidWalls = true;
boolean one = true;
boolean two = false;

int initBoidNum = 300; // amount of boids to start the program with
ArrayList<Boid> flock;
ArrayList<Boid> flockCurves=new ArrayList();
ArrayList<Vector> Curvas=new ArrayList();

Frame avatar;
boolean animate = true;
String CurveType="";

void setup() {

  size(800, 720, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
  interpolator =  new Interpolator(scene);
  randomFlocks();
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();
 

    
    pushStyle(); 
    strokeWeight(15); 
    //stroke(0,255,0);
    stroke(204,102,0);
    if(CurveType=="CB")
    {
      cubicBezier();
    }
    if(CurveType=="CH")
    {
      cubicHermite();
    }
    
      if(!Curvas.isEmpty()){
    for(int i=0;i<Curvas.size()-1;i++){
      line(Curvas.get(i).x(), Curvas.get(i).y(), Curvas.get(i).z() , Curvas.get(i+1).x(), Curvas.get(i+1).y(), Curvas.get(i+1).z()  );
    }
    //scene.drawPath(interpolator); 
    //DrawCurve(); 
    
    popStyle();
    
  }
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
}

void randomFlocks()
{
  flockCurves.clear();
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
  flockCurves.add(flock.get(int(random(0,initBoidNum))));
}

void cubicBezier(){
  Curvas.clear();
  println("CB");
  
  Curvas.add(new Vector(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(), flockCurves.get(0).position.z()));
  //println("----------------------");
  //println(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(), flockCurves.get(0).position.z());  
  //println(flockCurves.get(1).position.x(),flockCurves.get(1).position.y(),flockCurves.get(1).position.z());
  //println(flockCurves.get(2).position.x(),flockCurves.get(2).position.y(), flockCurves.get(2).position.z());
  //println(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z());  
  //println("----------------------");
 
  

  for(float u =0;u<1;u+=0.1)
  {
    //println("----- "+u);
    Matrix DuBc= new Matrix(  u*u*u, u*u, u, 1, 
                            0, 0 , 0, 0, 
                            0, 0, 0, 0, 
                            0, 0, 0, 0);
     Matrix BC= new Matrix(  -1, 3, -3, 1, 
                          3,  -6 , 3, 0, 
                          -3, 3,  0, 0, 
                          1,  0,  0, 0);                     
      
      BC.apply(DuBc);      
    
      Matrix PointsX =  new Matrix(   flockCurves.get(0).position.x()  , 0, 0, 0, 
                                flockCurves.get(1).position.x(), 0 , 0, 0, 
                                flockCurves.get(2).position.x(), 0, 0, 0, 
                                flockCurves.get(3).position.x(), 0, 0, 0);
      Matrix PointsY =  new Matrix(   flockCurves.get(0).position.y()  , 0, 0, 0, 
                                  flockCurves.get(1).position.y(), 0 , 0, 0, 
                                  flockCurves.get(2).position.y(), 0, 0, 0, 
                                  flockCurves.get(3).position.y(), 0, 0, 0);
      Matrix PointsZ =  new Matrix(   flockCurves.get(0).position.z()  , 0, 0, 0, 
                                  flockCurves.get(1).position.z(), 0 , 0, 0, 
                                  flockCurves.get(2).position.z(), 0, 0, 0, 
                                  flockCurves.get(3).position.z(), 0, 0, 0);  
      PointsX.apply(BC);
      PointsY.apply(BC);
      PointsZ.apply(BC);      
           
      Curvas.add(new Vector(PointsX.m00(),PointsY.m00(),PointsZ.m00()));
      //println(PointsX.m00(),PointsY.m00(),PointsZ.m00());
  }
  //println(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z());
  //println("----------------------");
  //Curvas.add(new Vector(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z()));
}



void cubicHermite(){
  println("CH");
  Curvas.clear();  
  Curvas.add(new Vector(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(), flockCurves.get(0).position.z()));
  //println("----------------------");
  //println(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(), flockCurves.get(0).position.z());  
  //println(flockCurves.get(1).position.x(),flockCurves.get(1).position.y(),flockCurves.get(1).position.z());
  //println(flockCurves.get(2).position.x(),flockCurves.get(2).position.y(), flockCurves.get(2).position.z());
  //println(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z());  
  //println("----------------------");
  
  for(float u =0;u<1;u+=0.1)
  {
    //println("----- "+u);
    Matrix DuBc= new Matrix(  u*u*u, u*u, u, 1, 
                            0, 0 , 0, 0, 
                            0, 0, 0, 0, 
                            0, 0, 0, 0);
     Matrix HM= new Matrix(  -1, 3, -3, 1, 
                          3,  -6 , 3, 0, 
                          -3, 3,  0, 0, 
                          1,  0,  0, 0);                     
      
      HM.apply(DuBc);      
    
      Matrix PointsX =  new Matrix(  flockCurves.get(0).position.x(), 0, 0, 0, 
                                     flockCurves.get(1).position.x(), 0, 0, 0, 
                                     flockCurves.get(2).position.x(), 0, 0, 0, 
                                     flockCurves.get(3).position.x(), 0, 0, 0);
                                     
      Matrix PointsY =  new Matrix(  flockCurves.get(0).position.y(), 0, 0, 0, 
                                     flockCurves.get(1).position.y(), 0, 0, 0, 
                                     flockCurves.get(2).position.y(), 0, 0, 0, 
                                     flockCurves.get(3).position.y(), 0, 0, 0);
                                     
      Matrix PointsZ =  new Matrix(  flockCurves.get(0).position.z(), 0, 0, 0, 
                                     flockCurves.get(1).position.z(), 0, 0, 0, 
                                     flockCurves.get(2).position.z(), 0, 0, 0, 
                                     flockCurves.get(3).position.z(), 0, 0, 0);  
      PointsX.apply(HM);
      PointsY.apply(HM);
      PointsZ.apply(HM);      
           
      Curvas.add(new Vector(PointsX.m00(),PointsY.m00(),PointsZ.m00()));
      //println(PointsX.m00(),PointsY.m00(),PointsZ.m00());
  }
  //println(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z());
  //println("----------------------");
  //Curvas.add(new Vector(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(), flockCurves.get(3).position.z()));
}

void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.interpolateTo(avatar);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fitBallInterpolation();
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.zoom(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
    
   case 'b':
    randomFlocks();
    CurveType = "CB";
    break;
    
   case 'h':
    randomFlocks();
    CurveType = "CH";
    break;
  
  case '+':    
    randomFlocks();
    //int index = int(random(0,initBoidNum));
    //Boid boid=flock.get(index);
    //println(flock.get(index).frame);
    //index = int(random(0,initBoidNum));
    //Boid boid2=flock.get(index);
    //interpolator.addKeyFrame(flock.get(index).frame);
    //println(flock.get(index).position.x());
    break;
  case '-':
    cubicHermite();
    /*
    if(interpolator.keyFrames().isEmpty()){
      println(" ¡No hay puntos para eliminar! ");
      break;
    }else{
      //interpolator.purge();
      println(interpolator.keyFrames());
      println(interpolator.keyFrame(0) + " pos: 0");
      interpolator.removeKeyFrame(0);
      println(interpolator.keyFrames());
    }
    */
    break;
  
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  case '1':
    one = !one;
    two = !two;
    break;
  }
}
