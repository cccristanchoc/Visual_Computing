PImage prs;
PImage zmb;
int vsbl;
void setup(){
  size(300, 390);
  prs= loadImage("person.png");
  zmb= loadImage("zombie.png");
  prs.resize(58, 144);
  zmb.resize(76,128);
}

void draw(){
  background(255);
  if (mousePressed != true) {
    Pasillo();
  }
  keyPressed(zmb, prs);
}

void Pasillo(){
  stroke(0);
  //point(200, 240);
  //point(245, 240);
  //point(200, 185);
  //point(245, 185);
  
  //line(200, 185, 0, 30);
  //line(200, 240, 0, 320);
  //line(245, 185, 300, 30);
  //line(245, 240, 300, 320);
  int x = 185;
  int y = 30;
  for(int i=0; i<6; i++){
    line(200, x, 0, y);
    line(245, x, 300, y);
    x += 11;
    y += 58;
  }
    
// Final Pasillo
  stroke(100);
  line(200, 240, 245, 240);
  line(200, 240, 200, 185);
  line(245, 240, 245, 185);
  line(245, 185, 200, 185);
  
  stroke(104, 102, 0);
  line(222, 240, 80, 390);
  line(0, 360, 300, 360);
  line(10, 317, 297, 317);
  line(83, 287, 277, 287);
  line(130, 268, 265, 268);
  line(166, 253, 255, 253);
}

void keyPressed(PImage zmb, PImage prs) {
  if (key == 'r'){
    image(zmb, 190, 130);
    image(zmb, 90, 230);
  }
  if (key == 't'){
    image(prs, 190, 130); 
    image(prs, 90, 220);
  }
  if (key == 'y'){
    image(zmb, 190, 130); 
    image(prs, 90, 220);
  }
  if (key == 'u'){
    image(prs, 190, 130); 
    image(zmb, 90, 230);
  }
}
