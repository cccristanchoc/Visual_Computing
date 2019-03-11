import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Shape shape, shape2;
Scene scene;
Interpolator inter;
float depth=800;
float min=0;
float max=800;

PVector lightDir = new PVector();
PShader defaultShader;
PGraphics shadowMap;
int landscape = 1;

ArrayList <Vector> vectors= new ArrayList <Vector>();
Frame avatar;
PShader lightShader;
void setup() {
  size(720, 600, P3D);

  rectMode(CENTER);
  scene = new Scene(this);
  scene.setRadius(1000);
  scene.fit(1);
  //scene.fitBallInterpolation();
  shape = new Shape(scene, loadShape("Lowpoly_City_Free_Pack.obj"));
  shape.setRotation(0, PI, PI, 0);
  shape.setPosition(-500, -500, 150);
  //shape.setTranslation(0,0,0);
  print(shape.position());
  shape.align();
  //(shape.orientation().axis().setX(PI/2));


  //lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
  //lightShader = loadShader("lightfrag1.glsl", "lightvert1.glsl");
  smooth();
  inter = new Interpolator(scene.eye());
  inter.setLoop();

  initShadowPass();
  initDefaultPass();
}

void draw() {
  //background(0);
  //lights();
  //shader(lightShader);
  //pointLight(255, 255, 255, width/2, height, 200);

  scene.traverse();

  pushStyle();
  stroke(255);
  // same as:scene.drawPath(interpolator, 5);
  scene.drawPath(inter);
  scene.drawAxes();
  popStyle();

  //pieta.rotateY(.01
  //render();
  shadowMapFunc();
}

void shadowMapFunc() {
  // Calculate the light direction (actually scaled by negative distance)
  float lightAngle = frameCount * 0.002;
  lightDir.set(sin(lightAngle) * 160, 160, cos(lightAngle) * 160);

  // Render shadow pass
  shadowMap.beginDraw();
  shadowMap.camera(lightDir.x, lightDir.y, lightDir.z, 0, 0, 0, 0, 1, 0);
  shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  renderLandscape(shadowMap);
  //shape.draw(shadowMap);
  shadowMap.endDraw();
  shadowMap.updatePixels();

  // Update the shadow transformation matrix and send it, the light
  // direction normal and the shadow map to the default shader.
  updateDefaultShader();

  // Render default pass
  background(0xff222222);
  renderLandscape(g);

  // Render light source
  pushMatrix();
  fill(0xffffffff);
  translate(lightDir.x, lightDir.y, lightDir.z);
  box(5);
  popMatrix();
}

void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate();
  else
    scene.scale(scene.mouseDX());
}


void mouseClicked() {
  Vector temp=scene.location(new Vector(mouseX, mouseY));
  //temp.setZ(depth);
  //vectors.add(scene.location(new Vector(mouseX,mouseY)));
  inter.addKeyFrame(new Frame(temp, (new Quaternion(new Vector(0, 0, 1), new Vector(0, 1, 0)))));
  println(scene.location(temp));
}

void keyPressed() {
  if (key == 'a')
    inter.start();
  inter.toggle();
  if (key == 'b') {
    inter.purge();
  }
  if (key == 's') {
    resetEye();
  }
  if (key == 't') {
    if (depth<max) {     
      depth+=100;
      println(depth);
    }
  } else if (key == 'r') {
    if (depth>min) {
      depth-=100;
    }
    println(depth);
  }
  if (key == 'd') {
    shadowMap.beginDraw(); 
    shadowMap.ortho(-200, 200, -200, 200, 10, 400); 
    shadowMap.endDraw();
  } else if (key == 'e') {
    shadowMap.beginDraw(); 
    shadowMap.perspective(60 * DEG_TO_RAD, 1, 10, 1000); 
    shadowMap.endDraw();
  }
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);
}

void render() {
  /*beginShape();
   for(int i=0; i<vectors.size();i++)
   {
   vertex(vectors.get(i).x(),vectors.get(i).y(),vectors.get(i).z());
   }
   
   endShape();*/
}

public void renderLandscape(PGraphics canvas) {
  //canvas.fill(0xff222222);
  //canvas.box(360, 5, 360);
  shape.draw();
}
