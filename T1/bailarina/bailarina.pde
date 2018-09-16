PImage img, ren;

void setup()
{
  size(1024,800);
  img = loadImage("efecto.jpg"); 
  ren = loadImage("rendija.png"); 
  fill(0,250,0);
}

void draw()
{
  background(255);
  image(img, 250, 0);
  //ellipse(mouseX,200,200,200);
  image(ren, mouseX, 0);  
}
