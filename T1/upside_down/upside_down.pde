PImage up, down,img;

void settings(){
  up = loadImage("face_up.png"); 
  down = loadImage("face_down.png");   
  img=down;
  size(img.width,img.height);
}

void setup()
{
  fill(0,250,0);
}

int value = 0;

void draw() {
  background(255);
  image(img, 0, 0);   
}

void mouseClicked() {
  if (img == down ) {
    img = up;
  } else {
    img = down;
  }
}
