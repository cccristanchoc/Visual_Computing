PImage img;
PImage nega;
PImage blWht;
PImage hst;
int[] histo = new int[256];

//Video sacar contraste 

void setup(){
  size(848,615);
  img = loadImage("2.png");
  img.loadPixels();
  //print(img.width/4+" - "+img.height/4);
  nega = createImage(img.width, img.height, RGB);
  blWht = createImage(img.width, img.height, RGB);
  hst = createImage(img.width, img.height, RGB);
  
  for(int i=0; i<(img.width*img.height); i++){
    
    float r = red(img.pixels[i]);
    float g = green(img.pixels[i]);
    float b = blue(img.pixels[i]);
    nega.pixels[i] = color(255-r, 255-g, 255-b);
    
    float lgt = (r + g + b)/3;
    blWht.pixels[i] = color(lgt, lgt, lgt);
    
    int brg = int(brightness(img.pixels[i]));
    histo[brg]++;
    
  }
  
  
}

void draw(){
  image(img, 0, 0, img.width/4, img.height/4);
  image(nega, 0, img.height/4, img.width/4, img.height/4);
  image(blWht, 0, 2*img.height/4, img.width/4, img.height/4);
  image(hst, img.width/4, 0, img.width/4, img.height/4);
  
  int MxHis = max(histo);
  stroke(255);
  for(int i=0; i<hst.width/4; i+=2){
    int which = int(map(i, 0, hst.width/4, 0, 256));
    int y = int(map(histo[which], 0, MxHis, hst.height/4, 0));
    line(i+hst.width/4, hst.height/4, i+hst.width/4, y);  
  }
}
