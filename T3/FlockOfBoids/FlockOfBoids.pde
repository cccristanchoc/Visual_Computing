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
boolean mode=true;
boolean representation=true;
Frame avatar;
boolean animate = true;
int controlPoints = 4;
String CurveType="";

void setup() {

  size(800, 720, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  //flock = new ArrayList();
  //for (int i = 0; i < initBoidNum; i++)
  //  flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2),mode));
  //interpolator =  new Interpolator(scene);
  //randomFlocks();
}

void resetflocks(){

    flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2),mode,representation));
  //interpolator =  new Interpolator(scene);
  randomFlocks();
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();  
    pushStyle(); 
    strokeWeight(3); 
    //stroke(0,255,0);
    //stroke(204,102,0);
    if(CurveType=="CB")
    {
      if(controlPoints==4)
      {
        cubicBezier();
        stroke(204,102,0);
      }
      else
      {
        bez7();
        //sevenBezier();
        //println("----- n puntos: "+Curvas.size() );
      }
    }
    if(CurveType=="CH")
    {
      cubicHermite();
      stroke(40,55,200);
    }
     if(CurveType=="N")
    {
      SplineCubicaNatural();
    }
    
      if(!Curvas.isEmpty()){        
        for(int i=0;i<Curvas.size()-1;i++){
          strokeWeight(10); 
          line(Curvas.get(i).x(), Curvas.get(i).y(), Curvas.get(i).z() , Curvas.get(i+1).x(), Curvas.get(i+1).y(), Curvas.get(i+1).z());
        }}
       

  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
}

void randomFlocks(){
  flockCurves.clear();
  flockCurves.add(flock.get(0));  
  flockCurves.add(flock.get(1));
  flockCurves.add(flock.get(2));
  flockCurves.add(flock.get(3));
  flockCurves.add(flock.get(4));
  flockCurves.add(flock.get(5));
  flockCurves.add(flock.get(6));
  flockCurves.add(flock.get(7));  
  
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
  //flockCurves.add(flock.get(int(random(0,initBoidNum))));
}

void cubicBezier(){
  Curvas.clear();
  //println("CB");
  
  for(float u =0;u<=1;u+=0.1){
    //println("----- "+u);
    Matrix DuBc= new Matrix(  u*u*u, u*u, u, 1, 
                              0, 0, 0, 0, 
                              0, 0, 0, 0, 
                              0, 0, 0, 0 );
                            
    Matrix BC= new Matrix(  -1, 3,-3, 1, 
                             3,-6, 3, 0, 
                            -3, 3, 0, 0, 
                             1, 0, 0, 0 );                     
      
    BC.apply(DuBc);      
    
    Matrix PointsX =  new Matrix(   flockCurves.get(0).position.x(), 0, 0, 0, 
                                    flockCurves.get(1).position.x(), 0, 0, 0, 
                                    flockCurves.get(2).position.x(), 0, 0, 0, 
                                    flockCurves.get(3).position.x(), 0, 0, 0 );
    
    Matrix PointsY =  new Matrix(   flockCurves.get(0).position.y(), 0, 0, 0, 
                                    flockCurves.get(1).position.y(), 0, 0, 0, 
                                    flockCurves.get(2).position.y(), 0, 0, 0, 
                                    flockCurves.get(3).position.y(), 0, 0, 0 );
                                  
    Matrix PointsZ =  new Matrix(   flockCurves.get(0).position.z(), 0, 0, 0, 
                                    flockCurves.get(1).position.z(), 0, 0, 0, 
                                    flockCurves.get(2).position.z(), 0, 0, 0, 
                                    flockCurves.get(3).position.z(), 0, 0, 0 );  
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
  for(float u =0;u<=1;u+=0.1)
  {
    //println("----- "+u);
    Matrix DuBc= new Matrix(  u*u*u, u*u, u, 1, 
                              0, 0, 0, 0, 
                              0, 0, 0, 0, 
                              0, 0, 0, 0 );
                            
     Matrix HM= new Matrix(  2,-2, 1, 1, 
                            -3, 3,-2,-1, 
                             0, 0, 1, 0, 
                             1, 0, 0, 0 );                     
      
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

 public static float[][] multiplyMatrices(float[][] firstMatrix, float[][] secondMatrix, int r1, int c1, int c2) {
        float[][] product = new float[r1][c2];
        for(int i = 0; i < r1; i++) {
            for (int j = 0; j < c2; j++) {
                for (int k = 0; k < c1; k++) {
                    product[i][j] += firstMatrix[i][k] * secondMatrix[k][j];
                }
            }
        }
        return product;
    }

public static void displayProduct(float[][] product) {
        System.out.println("Product of two matrices is: ");
        for(float[] row : product) {
            for (float column : row) {
                System.out.print(column + "    ");
            }
            System.out.println();
        }
    }
 
void sevenBezier(){
  Curvas.clear();
  
  for(float u =0;u<=1;u+=0.5)
  {
    
     float [][] du= { 
                    {pow(u,7),pow(u,6),pow(u,5),pow(u,4),pow(u,3),pow(u,2),pow(u,1),pow(u,0)}, 
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }
                };
       float [][] bc= { 
                    {  -1  ,     7  ,   -21  ,    35  ,   -35  ,   21  ,  -7  ,  1}, 
                    {   7  ,   -42  ,   105  ,  -140  ,   105  ,  -42  ,  7 ,  0  },
                    {  -21 ,   105  ,  -210  ,   210  ,  -105  ,   21  ,  0 ,  0  },
                    {   35 ,   105  ,   105  ,    35  ,     0  ,    0  ,  0 ,  0  },
                    {  -35 ,  -140  ,  -210  ,  -140  ,   -35  ,    0  ,  0 ,  0  },
                    {   21 ,   105  ,   210  ,   210  ,   105  ,   21  ,  0 ,  0  },
                    {  -7  ,     7  ,     0  ,     0  ,     0  ,    0  ,  0 ,  0  },
                    {   1  ,     0  ,     0  ,     0  ,     0  ,    0  ,  0 ,  0  }
                };               
    
         float[][] duBc = multiplyMatrices(du, bc, 8, 8, 8);
        
         
         float [][] PointsX= { 
                    {flockCurves.get(0).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }, 
                    {flockCurves.get(1).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(2).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(3).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(4).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(5).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(6).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(7).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }
         };    
         
         
         float [][] PointsY= { 
                    {flockCurves.get(0).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }, 
                    {flockCurves.get(1).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(2).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(3).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(4).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(5).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(6).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(7).position.y()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }
         };
         float [][] PointsZ= { 
                    {flockCurves.get(0).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }, 
                    {flockCurves.get(1).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(2).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(3).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(4).position.x()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(5).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(6).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  },
                    {flockCurves.get(7).position.z()  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0 ,  0  }
         };
    
      float[][] pX= multiplyMatrices(duBc, PointsX, 8, 8, 8);
      //println("---PPP---");      
      float[][] pY= multiplyMatrices(duBc, PointsY, 8, 8, 8);
      float[][] pZ= multiplyMatrices(duBc, PointsZ, 8, 8, 8);
      /*displayProduct(pX);
      displayProduct(pY);
      displayProduct(pZ);*/
      

      if(pX[0][0]>=999)
      {
        if (pX[0][0]/1000 >=100)
        {
          pX[0][0]=pX[0][0]/1000;
        }
        else
        {
          pX[0][0]=pX[0][0]/100;
        }
      }
      
             if (pY[0][0]/1000 >=100)
        {
          pY[0][0]=pY[0][0]/1000;
        }
        else
        {
          pY[0][0]=pY[0][0]/100;
        }
             if (pZ[0][0]/1000 >=100)
        {
          pZ[0][0]=pZ[0][0]/1000;
        }
        else
        {
          pZ[0][0]=pZ[0][0]/100;
        }
      //println(pX[0][0]);
      //println(pY[0][0]);
      //println(pZ[0][0]);
      Curvas.add(new Vector(pX[0][0],pY[0][0],pZ[0][0]));      
  }

}

void bez7(){
  Curvas.clear();
  //println("CB");
  
  for(float t =0;t<=1;t+=0.1){
      PVector P1= new PVector(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(),flockCurves.get(0).position.z());
      PVector P2= new PVector(flockCurves.get(1).position.x(),flockCurves.get(1).position.y(),flockCurves.get(1).position.z());
      PVector P3= new PVector(flockCurves.get(2).position.x(),flockCurves.get(2).position.y(),flockCurves.get(2).position.z());
      PVector P4= new PVector(flockCurves.get(3).position.x(),flockCurves.get(3).position.y(),flockCurves.get(3).position.z());
      PVector P5= new PVector(flockCurves.get(4).position.x(),flockCurves.get(4).position.y(),flockCurves.get(4).position.z());
      PVector P6= new PVector(flockCurves.get(5).position.x(),flockCurves.get(5).position.y(),flockCurves.get(5).position.z());
      PVector P7= new PVector(flockCurves.get(6).position.x(),flockCurves.get(6).position.y(),flockCurves.get(6).position.z());
      PVector P8= new PVector(flockCurves.get(7).position.x(),flockCurves.get(7).position.y(),flockCurves.get(7).position.z());

      // compute first tree points along main segments P1-P2, P2-P3 and P3-P4
      PVector P12 = (P1.mult(1-t)).add(P2.mult(t)); 
      PVector P23 = (P2.mult(1-t)).add(P3.mult(t)); 
      PVector P34 = (P3.mult(1-t)).add(P4.mult(t));    
       
      PVector P56 = (P5.mult(1-t)).add(P6.mult(t));
      PVector P67 = (P6.mult(1-t)).add(P7.mult(t));
      PVector P78 = (P7.mult(1-t)).add(P8.mult(t));
      // compute two points along segments P1P2-P2P3 and P2P3-P3P4
      PVector P1223 = (P12.mult(1-t)).add(P23.mult(t));       
      PVector P2334 = (P23.mult(1-t)).add(P34.mult(t));   
      PVector P5667 = (P56.mult(1-t)).add(P67.mult(t)); 
      PVector P6778 = (P67.mult(1-t)).add(P78.mult(t)); 
   
      // finally compute P
      PVector res= P1223.mult(pow(1-t,3)).add(P2334.mult(pow(1-t,2)*t).add(P5667.mult(pow(t,2)*(1-t)).add(P6778.mult(pow(t,3)))));
      Curvas.add(new Vector(res.x,res.y,res.z));     
  }
}

void SplineCubicaNatural ()
{
  Curvas.clear();
  int n=4;
    int MAX_PTOS=20;
    int i, j, m, xp, yp , zp;
    double [] ax = new double [MAX_PTOS], bx= new double [MAX_PTOS], 
    cx = new double [MAX_PTOS], dx = new double [MAX_PTOS], ay = new double [MAX_PTOS], 
    by = new double [MAX_PTOS], cy = new double [MAX_PTOS], az= new double [MAX_PTOS],
    bz= new double [MAX_PTOS], cz= new double [MAX_PTOS], dy= new double [MAX_PTOS], 
    dz= new double [MAX_PTOS], der= new double [MAX_PTOS], gam= new double [MAX_PTOS], ome = new double [MAX_PTOS];    
    double t, dt;
    m = n-1; /* m es el numero de intervalos que tendremos */
    /* Calculamos el valor de gamma (sera el mismo en X y en Y) */
    gam[0] = .5;
    for (i=1; i<m; i++) 
    {
      gam[i] = 1./(4.-gam[i-1]);
    }
    gam[m] = 1./(2.-gam[m-1]);
    
    
    /* Calculamos el valor de omega para X */
    ome[0] = 3.*(flockCurves.get(1).position.x()-flockCurves.get(0).position.x())*gam[0];
    for (i=1; i<m; i++) 
    {
      ome[i] = (3.*(flockCurves.get(i+1).position.x()-flockCurves.get(i-1).position.x())-ome[i-1])*gam[i];
    }
    ome[m] = (3.*(flockCurves.get(m).position.x()-flockCurves.get(m-1).position.x())-ome[m-1])*gam[m];
    /* Valor de la primera derivada en los puntos (eje X) */
    der[m]=ome[m];
    for (i=m-1; i>=0; i=i-1) 
    {
      der[i] = ome[i]-gam[i]*der[i+1];
    }
    /* Sustituimos los valores de gamma, omega y la primera derivada
    para calcular los coeficientes a, b, c y d */
    for (i=0; i<m; i++) {
      ax[i] = flockCurves.get(i).position.x();
      bx[i] = der[i];
      cx[i] = 3.*(flockCurves.get(i+1).position.x()-flockCurves.get(i).position.x())-2.*der[i]-der[i+1];
      dx[i] = 2.*(flockCurves.get(i).position.x()-flockCurves.get(i+1).position.x())+der[i]+der[i+1];
    }
    
/* Calculamos omega para el eje Y */
    ome[0] = 3.*(flockCurves.get(1).position.y()-flockCurves.get(0).position.y())*gam[0];
    for (i=1; i<m; i++) {
      ome[i] = (3.*(flockCurves.get(i+1).position.y()-flockCurves.get(i-1).position.y())-ome[i-1])*gam[i];
    }
    ome[m] = (3.*(flockCurves.get(m).position.y()-flockCurves.get(m-1).position.y())-ome[m-1])*gam[m];
 /* Hallamos el valor de la primera derivada... */
    der[m]=ome[m];
    for (i=m-1; i>=0; i=i-1) 
    {der[i] = ome[i]-gam[i]*der[i+1];}
/* Valor de los coeficientes a, b, c y d en el eje Y */
    for (i=0; i<m; i++) {
    ay[i] = flockCurves.get(i).position.y();
    by[i] = der[i];
    cy[i] = 3.*(flockCurves.get(i+1).position.y()-flockCurves.get(i).position.y())-2.*der[i]-der[i+1];
    dy[i] = 2.*(flockCurves.get(i).position.y()-flockCurves.get(i+1).position.y())+der[i]+der[i+1];
    }
    
/* Calculamos omega para el eje Z */
    ome[0] = 3.*(flockCurves.get(1).position.z()-flockCurves.get(0).position.z())*gam[0];
    for (i=1; i<m; i++) {
      ome[i] = (3.*(flockCurves.get(i+1).position.z()-flockCurves.get(i-1).position.z())-ome[i-1])*gam[i];
    }
    ome[m] = (3.*(flockCurves.get(m).position.z()-flockCurves.get(m-1).position.z())-ome[m-1])*gam[m];
 /* Hallamos el valor de la primera derivada... */
    der[m]=ome[m];
    for (i=m-1; i>=0; i=i-1) 
    {der[i] = ome[i]-gam[i]*der[i+1];}
/* Valor de los coeficientes a, b, c y d en el eje Y */
    for (i=0; i<m; i++) {
      az[i] = flockCurves.get(i).position.z();
      bz[i] = der[i];
      cz[i] = 3.*(flockCurves.get(i+1).position.z()-flockCurves.get(i).position.z())-2.*der[i]-der[i+1];
      dz[i] = 2.*(flockCurves.get(i).position.z()-flockCurves.get(i+1).position.z())+der[i]+der[i+1];
    }   
    
/* En esta parte, se dibujara la curva por segmentos de lineas
rectas; si NUM_SEG es un valor alto, la grafica se dibujara
con mayor precision. */
    int NUM_SEG=20;
    dt = 1./(double) NUM_SEG;
    Curvas.add(new Vector(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(),flockCurves.get(0).position.z()));  
    //moveto((int) x[0], (int) y[0]);
    for (i=0; i<m; i++) {
      for (j=1, t=dt; j<NUM_SEG; j++, t+=dt) {
        xp = (int) (ax[i]+bx[i]*t+cx[i]*t*t+dx[i]*t*t*t);
        yp = (int) (ay[i]+by[i]*t+cy[i]*t*t+dy[i]*t*t*t);
        zp = (int) (az[i]+bz[i]*t+cz[i]*t*t+dz[i]*t*t*t);
        Curvas.add(new Vector(xp,yp,zp));
        //lineto (xp, yp);
}
}
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
  case 'w':
    avoidWalls = !avoidWalls;
    break;
    
   case 'b':
    randomFlocks();
    CurveType = "CB";
    break;
    
    case '7':    
    controlPoints = 7;
    break;   
    
    case '4':    
    controlPoints = 4;
    break;
    
    case 'n':
    randomFlocks();
    CurveType = "N";
    break;
        
   case 'h':
    randomFlocks();
    CurveType = "CH";
    break;
    
    case 'v':
    representation=true;
    break;
    
    case 'f':
    representation=false;
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
  case 'r':
    mode=false; 
    resetflocks();
    break;
  case 'i':
    mode=true;    
    resetflocks();
    break;
  case '1':
    one = !one;
    two = !two;
    break;
  }
}
