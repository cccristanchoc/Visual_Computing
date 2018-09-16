import processing.video.*; 

Movie movie;
//PImage hst;
//int[] histo = new int[255];

void setup() {  
  
  size(320, 600);  
  
  movie = new Movie(this, "thor.mp4");

  movie.loop();
  
}

void draw() {  
  blWt(movie, 0, 400);
  nega(movie, 0, 0);
  image(movie, 0, 200, 320, 200);
  //histo(movie, 0, 600);
}

void nega(Movie movie, int w, int h){
  image(movie, w, h, 320, 200);
  loadPixels();
  for (int i=0; i<(width*height); i++) {
    float r = red(pixels[i]);
    float g = green(pixels[i]);
    float b = blue(pixels[i]);
    pixels[i] = color(255-r, 255-g, 255-b);
  }
  updatePixels();
}

void blWt(Movie movie, int w, int h){
  image(movie, w, h, 320, 200);
  loadPixels();
  for (int i=0; i<(width*height); i++) {
    float r = red(pixels[i]);
    float g = green(pixels[i]);
    float b = blue(pixels[i]);
    float lgt = (r + g + b)/3;
    pixels[i] = color(lgt, lgt, lgt);
  }
  updatePixels();
}

//void histo(Movie movie, int w, int h){
//  //image(movie, w, h, 320, 200);
//  hst = createImage(w, h, RGB);
//  for(int i=0; i<(width*height); i++){
//    int brg = int(brightness(movie.pixels[i]));
//    histo[brg]++;
//  }
//  int MxHis = max(histo);
//  stroke(255);
//  for(int i=0; i<hst.width; i+=2){
//    int which = int(map(i, 0, hst.width, 0, 256));
//    int y = int(map(histo[which], 0, MxHis, hst.height, 0));
//    line(i+hst.width, hst.height, i+hst.width, y);  
//  }
  
//}

void movieEvent(Movie movie) {  
  movie.read();
}
