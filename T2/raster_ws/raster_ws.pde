import frames.timing.*; //<>//
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

float[] colR = {1, 0, 0};
float[] colG = {0, 1, 0};
float[] colB = {0, 0, 1};


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
//int cont=0;
float escena[][];
// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea
  //println(edgeValida(v1,v2,v3, 0, 0));
  noStroke();
  rectMode(CENTER);
  escena = new float[(int)pow(2, n)][(int)pow(2, n)];
  float[] rgb=new float[0];

  //((2^n)/2)+0.5 formula del centro del pixel
  for (float i=(0.5-pow(2, n)); i<=(0.5+pow(2, n)); i++) {
    for (float j=(0.5-pow(2, n)); j<=(0.5+pow(2, n)); j++) {

      //rect(-3.5,-3.5,1,1);
      //println(scene.screenLocation(v1).x());

      if (edgeValida(v1, v2, v3, i, j))
      {
        rgb = edge(v1, v2, v3, i, j);
        //println(rgb);
        pushStyle();
        fill(rgb[0], rgb[1], rgb[2]);
        rect(i, j, 1, 1);
        popStyle();
      } else {
        int sum=0;
        int index=0;
        float prom=0;      

        Vector A= new Vector(i-0.5, j-0.5);
        Vector B= new Vector(i+0.5, j-0.5);
        Vector C= new Vector(i-0.5, j+0.5);
        Vector D= new Vector(i+0.5, j+0.5);
        int b=0;

        if (i==-3.5&&j==-3.5) {

          line(i-0.5, j-0.5, 10, 10);          
          //ellipse(i-0.5,j-0.5,0.1,0.1);
          //ellipse(i-0.5,j+0.5,0.1,0.1);          
          //println(doIntersect(A,C,frame.location(v1),frame.location(v2)));
        }


        if (doIntersect(A, B, frame.location(v1), frame.location(v2))||doIntersect(B, D, frame.location(v1), frame.location(v2))||doIntersect(C, D, frame.location(v1), frame.location(v2))||doIntersect(A, C, frame.location(v1), frame.location(v2))||
          doIntersect(A, B, frame.location(v2), frame.location(v3))||doIntersect(B, D, frame.location(v2), frame.location(v3))||doIntersect(C, D, frame.location(v2), frame.location(v3))||doIntersect(A, C, frame.location(v2), frame.location(v3))||
          doIntersect(A, B, frame.location(v1), frame.location(v3))||doIntersect(B, D, frame.location(v1), frame.location(v3))||doIntersect(C, D, frame.location(v1), frame.location(v3))||doIntersect(A, C, frame.location(v1), frame.location(v3))        
          ) {
          //println("--");
          for (float x=i-0.5; x<=i+0.5; x+=0.09) {
            for (float y=j-0.5; y<=j+0.5; y+=0.09) {
              index++;
              if (edgeValida(v1, v2, v3, x, y))
              {
                sum++;
                if (b==0)
                {
                  b=1;
                  rgb = edge(v1, v2, v3, x, y);
                }
              }
            }
          }

          if (sum>0) {
            //println(sum);
            //println(sum);
            prom=float(sum)/float(index);                  
            //println(rgb);
            pushStyle();
            //println(prom);
            //fill(rgb[0], rgb[1], rgb[2]);
            fill(rgb[0]*prom, rgb[1]*prom, rgb[2]*prom);
            //fill(100, 0, 0);                  
            rect(i, j, 1, 1);                
            popStyle();
          }
        }


        /* 
         
         */
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

boolean onSegment(Vector p, Vector q, Vector r) {
  if (frame.location(p).x() <= max(frame.location(p).x(), frame.location(r).x()) && frame.location(q).x() >= min(frame.location(p).x(), frame.location(r).x()) &&
    frame.location(q).y() <= max(frame.location(p).y(), frame.location(r).y()) && frame.location(q).y() >= min(frame.location(p).y(), frame.location(r).y())) 
  {
    return true;
  }
  return false;
}

int orientation(Vector p, Vector q, Vector r) { 
  // See https://www.geeksforgeeks.org/orientation-3-ordered-points/ 
  // for details of below formula. 
  float val = (frame.location(q).y() - frame.location(p).y()) * (frame.location(r).x() - frame.location(q).x()) - 
    (frame.location(q).x() - frame.location(p).x()) * (frame.location(r).y() - frame.location(q).y()); 

  if (val == 0) return 0;  // colinear 

  return (val > 0)? 1: 2; // clock or counterclock wise
} 

boolean doIntersect(Vector p1, Vector q1, Vector p2, Vector q2) { 
  // Find the four orientations needed for general and 
  // special cases 
  int o1 = orientation(p1, q1, p2); 
  int o2 = orientation(p1, q1, q2); 
  int o3 = orientation(p2, q2, p1); 
  int o4 = orientation(p2, q2, q1); 

  // General case 
  if (o1 != o2 && o3 != o4) 
    return true; 

  // Special Cases 
  // p1, q1 and p2 are colinear and p2 lies on segment p1q1 
  if (o1 == 0 && onSegment(p1, p2, q1)) return true; 

  // p1, q1 and q2 are colinear and q2 lies on segment p1q1 
  if (o2 == 0 && onSegment(p1, q2, q1)) return true; 

  // p2, q2 and p1 are colinear and p1 lies on segment p2q2 
  if (o3 == 0 && onSegment(p2, p1, q2)) return true; 

  // p2, q2 and q1 are colinear and q1 lies on segment p2q2 
  if (o4 == 0 && onSegment(p2, q1, q2)) return true; 

  return false; // Doesn't fall in any of the above cases
} 

boolean edgeValida(Vector v1, Vector v2, Vector v3, float pntX, float pntY) {

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

  //if(ceil(A) >= 0 && ceil(B) >= 0 && ceil(C) >= 0 ||A <= 0 && B <= 0 && C <= 0 ){
  if (A >= 0 && B >= 0 && C >= 0 ||A <= 0 && B <= 0 && C <= 0 ) {      
    //println("_ Inside _");
    return true;
  } else {
    //println("_ Outside _"); 
    return false;
  }
}

float[] edge(Vector v1, Vector v2, Vector v3, float pntX, float pntY) {
  float A = ((pntX - frame.location(v1).x()) * (frame.location(v2).y() - frame.location(v1).y()) - (pntY - frame.location(v1).y()) * (frame.location(v2).x() - frame.location(v1).x()));
  float B = ((pntX - frame.location(v2).x()) * (frame.location(v3).y() - frame.location(v2).y()) - (pntY - frame.location(v2).y()) * (frame.location(v3).x() - frame.location(v2).x()));
  float C = ((pntX - frame.location(v3).x()) * (frame.location(v1).y() - frame.location(v3).y()) - (pntY - frame.location(v3).y()) * (frame.location(v1).x() - frame.location(v3).x()));
  float area = ((frame.location(v3).x() - frame.location(v1).x()) * (frame.location(v2).y() - frame.location(v1).y()) - (frame.location(v3).y() - frame.location(v1).y()) * (frame.location(v2).x() - frame.location(v1).x()));

  //println(area);

  if (A >= 0 && B >= 0 && C >= 0 ||A <= 0 && B <= 0 && C <= 0 ) {
    //println("Inside");
    float alph = (A/area);
    float bet = (B/area);
    float gam = (C/area);
    //println(alph+bet+gam);
    float r = (alph * colR[0]) + (bet * colG[0]) + (gam * colB[0]); 
    float g = (alph * colR[1]) + (bet * colG[1]) + (gam * colB[1]);
    float b = (alph * colR[2]) + (bet * colG[2]) + (gam * colB[2]);
    float[] result = {r*255, g*255, b*255};
    return result;
  } else { 
    //println(area);
    //println("Outside");
    float[] resneg = {0, 0, 0};
    return resneg;
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  //v1 = new Vector( 312.51947, -208.95105);
  //v2 = new Vector( -314.87387, -138.58603);
  //v2 = new Vector( 0, 0);
  //v3 = new Vector( 281.13574, -137.17499);
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));

  //println(v1+""+v2+" "+v3);
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
    //println(n);
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
