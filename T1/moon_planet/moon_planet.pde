void setup() {
  size(600, 600);
  //rectMode(ROUND);  
  ellipseMode(ROUND);
  noFill();
  smooth();
}

int n = 65;
float r = 250;
int b = 0;

void mouseClicked() {
  if (b==0) {
    b=255;
  } else {
    b=0;
  }
}



void draw() {
  background(0);
  float basicA = frameCount*0.01f;
  stroke(255);
  fill(100);
  ellipse(width/2, height/2, r, r);
  translate(width/2, height/2);
  for (int i=0; i < n; i++) {
    float angle = basicA+i*0.1f;
    float x = cos(angle)*r;
    float y = sin(angle)*r/4;
    //println(int(x) +" , "+ int(y));
    if (b==0 && y<=0) {
      stroke(255);
      noFill();
      ellipse(x, y, 40, 40);
    }
    if (b!=0 && y>=0) {
      stroke(255);
      noFill();
      ellipse(x, y, 40, 40);
    }
    if (keyPressed == true) {
      stroke(0);
      noFill();
      ellipse(x, y, 40, 40);
    } 
    
  }
}
