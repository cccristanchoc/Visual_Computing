import frames.timing.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;

// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

Point punto;

float[] colR = {1,0,0};
float[] colG = {0,1,0};
float[] colB = {0,0,1};


void setup() {
  //use 2^n to change the dimensions
  size(720, 480, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

float escena[][];
// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea
  
  noStroke();
  rectMode(CENTER);
  escena = new float[(int)pow(2, n)][(int)pow(2, n)];
  float[] rgb;
  
  //((2^n)/2)+0.5 formula del centro del pixel
  for(float i=(0.5-pow(2,n-1)); i<=(0.5+pow(2,n-1)); i++){
    for(float j=(0.5-pow(2,n-1)); j<=(0.5+pow(2,n-1)); j++){
      
      //rect(i,j,0.5,0.5);
      
      if(edgeValida(v1,v2,v3, i, j)){ //<>//
        rgb = edge(v1,v2,v3,i,j);
        //println(rgb);
        pushStyle();
        fill(rgb[0], rgb[1], rgb[2]);
        rect(i,j,1,1);
        popStyle();
      }
      
    }
  }
  
  //println(edge(v1,v2,v3,punto));
  
  
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(frame.location(v1).x()), round(frame.location(v1).y()));
    stroke(200, 100, 0, 125);
    point(round(frame.location(v2).x()), round(frame.location(v2).y()));
    stroke(255, 0, 255, 125);
    point(round(frame.location(v3).x()), round(frame.location(v3).y()));
    popStyle();
  }
}

boolean edgeValida(Vector v1, Vector v2, Vector v3, float pntX, float pntY){
  float A = ((pntX - frame.location(v1).x()) * (frame.location(v2).y() - frame.location(v1).y()) - (pntY - frame.location(v1).y()) * (frame.location(v2).x() - frame.location(v1).x()));
  float B = ((pntX - frame.location(v2).x()) * (frame.location(v3).y() - frame.location(v2).y()) - (pntY - frame.location(v2).y()) * (frame.location(v3).x() - frame.location(v2).x()));
  float C = ((pntX - frame.location(v3).x()) * (frame.location(v1).y() - frame.location(v3).y()) - (pntY - frame.location(v3).y()) * (frame.location(v1).x() - frame.location(v3).x()));
  /*
  if(A > 0) print("Right: ");
  if(A == 0) print("InLine: ");
  if(A < 0) print("Left: ");
  
  if(B > 0) print("Right: ");
  if(B == 0) print("InLine: ");
  if(B < 0) print("Left: ");
  
  if(B > 0) print("Right: ");
  if(B == 0) print("InLine: ");
  if(B < 0) print("Left: ");
  */
  //println(A);  println(B);  println(C);
  
  if(A >= 0 && B >= 0 && C >= 0 ||A <= 0 && B <= 0 && C <= 0 ){
    //println("_ Inside _");
    return true;
  }else{
    //println("_ Outside _"); 
    return false;
  }
}

float[] edge(Vector v1, Vector v2, Vector v3, float pntX, float pntY){
  float A = ((pntX - frame.location(v1).x()) * (frame.location(v2).y() - frame.location(v1).y()) - (pntY - frame.location(v1).y()) * (frame.location(v2).x() - frame.location(v1).x()));
  float B = ((pntX - frame.location(v2).x()) * (frame.location(v3).y() - frame.location(v2).y()) - (pntY - frame.location(v2).y()) * (frame.location(v3).x() - frame.location(v2).x()));
  float C = ((pntX - frame.location(v3).x()) * (frame.location(v1).y() - frame.location(v3).y()) - (pntY - frame.location(v3).y()) * (frame.location(v1).x() - frame.location(v3).x()));
  float area = ((frame.location(v3).x() - frame.location(v1).x()) * (frame.location(v2).y() - frame.location(v1).y()) - (frame.location(v3).y() - frame.location(v1).y()) * (frame.location(v2).x() - frame.location(v1).x()));

  //println(area);
  
  if(A >= 0 && B >= 0 && C >= 0 ||A <= 0 && B <= 0 && C <= 0 ){
    //println("Inside");
    float alph = (A/area);
    float bet = (B/area);
    float gam = (C/area);
    //println(alph+bet+gam);
    float r = (alph * colR[0]) + (bet * colG[0]) + (gam * colB[0]); 
    float g = (alph * colR[1]) + (bet * colG[1]) + (gam * colB[1]);
    float b = (alph * colR[2]) + (bet * colG[2]) + (gam * colB[2]);
    float[] result = {r*255,g*255,b*255};
    return result;
  }else{ 
    //println("Outside");
    float[] resneg = {0,0,0};
    return resneg;
  }  
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  //punto = new Point(random(low,high),random(low,high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  //point(punto.x(), punto.y());  
  //point((-width/2), (width/2)/pow(2,n));
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
