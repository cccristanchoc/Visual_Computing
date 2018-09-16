import gifAnimation.*;
PImage[] allFrames;
PImage nt;
int cant_fram, rendija, calado;
boolean x=true;

void settings() {
  allFrames = Gif.getPImages(this, "day.gif");
  size(allFrames[0].width, allFrames[0].height);
}
//el void genera las imagenes planas que permiten la ilusion
void setup() { 
  //frame.setResizable(true);
  surface.setResizable(true);
  cant_fram = allFrames.length; //cantidad de frames  
  rendija = 1; // n cantidad de pixeles de la rendija con n pixles < calado pixls
  calado = rendija * cant_fram - 1 ;//  calado>=n*cantidad de frames de animacion  

  for (int x=0; x<cant_fram; x++)
  {
    for (int i=x; i<allFrames[0].width; i+=calado+rendija)
    {      
      image(allFrames[x].get(i, 0, rendija, allFrames[x].width), i, 0);
    }
  }    
  save("xt.jpg");
}

void mouseClicked() {
  if (x) {
    x = false;
  } else {
    x = true;
  }
}


//el draw genera la rejilla
void draw() {
  PImage tower = loadImage("xt.jpg");
  //tower.resize(2*tower.width, 2*tower.height);
  clear();    
  image(tower, 0, 0);
  //frame.setSize(tower.width, tower.height);
  surface.setSize(tower.width, tower.height);
  if (x) {
    stroke(255, 0);
    fill(0);  
    for (int i=0; i<2*tower.width; i+=calado+rendija) {
      rect(mouseX-width+i, 0, calado, height);
    }
  } else
  {    
    image(tower, 0, 0);
  }
}
