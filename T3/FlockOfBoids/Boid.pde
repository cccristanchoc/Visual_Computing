class Boid {
  public Frame frame;
  PShape boidPs;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  float[] v0={3 * sc, 0, 0};
  float[] v1={-3 * sc, 2 * sc, 0};
  float[] v2={-3 * sc, -2 * sc, 0};
  float[] v3={-3 * sc, 0, 2 * sc};
  ArrayList<Integer[]> lfaces = new ArrayList<Integer[]>();
  ArrayList<PVector> lvertex= new ArrayList<PVector>();  
  ArrayList<ArrayList<float[]>> vectorList = new ArrayList<ArrayList<float[]>>();
  ArrayList<float[]> vectors = new ArrayList<float[]>();
  ArrayList<float[]> v0list = new ArrayList<float[]>();
  ArrayList<float[]> v1list = new ArrayList<float[]>();
  ArrayList<float[]> v2list = new ArrayList<float[]>();
  boolean representation=true;

  //vertex(v0[0],v0[1],v0[2]);      V0
  //vertex(-3 * sc, 2 * sc, 0);     V1
  //vertex(-3 * sc, -2 * sc, 0);    V2

  //vertex(3 * sc, 0, 0);           V0
  //vertex(-3 * sc, 2 * sc, 0);     V1
  //vertex(-3 * sc, 0, 2 * sc);     V3       

  //vertex(3 * sc, 0, 0);           V0
  //vertex(-3 * sc, 0, 2 * sc);     V3
  //vertex(-3 * sc, -2 * sc, 0);    V2

  //vertex(-3 * sc, 0, 2 * sc);     V3
  //vertex(-3 * sc, 2 * sc, 0);     V1
  //vertex(-3 * sc, -2 * sc, 0);    V2

  void VertexVertex()
  {
    vectors.add(v0);
    vectors.add(v1);
    vectors.add(v2);
    vectors.add(v3);
    v0list.add(v1);
    v0list.add(v2);
    v0list.add(v3);
    v1list.add(v2);
    v1list.add(v3);
    v2list.add(v3);
    vectorList.add(v0list);
    vectorList.add(v1list);
    vectorList.add(v2list);
  }

  void FaceVertex()
  {
    lfaces.add(new Integer[]{0, 1, 2});
    lfaces.add(new Integer[]{0, 1, 3});
    lfaces.add(new Integer[]{0, 3, 2});
    lfaces.add(new Integer[]{3, 1, 2});
    lvertex.add(new PVector(3, 0, 0));
    lvertex.add(new PVector(-3, 2, 0));
    lvertex.add(new PVector(-3, -2, 0));
    lvertex.add(new PVector(-3, 0, 2));
  }    

  Boid(Vector inPos, boolean mode, boolean rep) {
    representation=rep;

    if (rep)
    {
      VertexVertex();
    } else
    {
      FaceVertex();
    }

    boidPs = createShape();   

    boidPs.beginShape(LINES);    
    boidPs.strokeWeight(2);
    boidPs.stroke(color(40, 255, 40));
    boidPs.fill(color(0, 255, 0, 125));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      boidPs.stroke(color(0, 0, 255));
      boidPs.fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      boidPs.stroke(color(255, 0, 0));
      boidPs.fill(color(255, 0, 0));
    }
    if (representation) { // true for vertex  
      for (int i=0; i<vectors.size()-1; i++) {
        for (int y=0; y<vectorList.get(i).size(); y++) {
          boidPs.vertex(vectors.get(i)[0], vectors.get(i)[1], vectors.get(i)[2]);
          boidPs.vertex(vectorList.get(i).get(y)[0], vectorList.get(i).get(y)[1], vectorList.get(i).get(y)[2]);
        }
      }
    } else {
      for (int i=0; i<lfaces.size(); i++) {
        for (int j=0; j<=lfaces.get(i).length; j++) {
          PVector vertex = lvertex.get(lfaces.get(i)[j%3]);   
          boidPs.vertex(vertex.x*sc, vertex.y*sc, vertex.z*sc);
        }
      }
    }
    boidPs.endShape();

    position = new Vector();
    position.set(inPos);
    if (mode) {
      frame = new Frame(scene) {
        // Note that within visit() geometry is defined at the
        // frame local coordinate system.
        @Override
          public void visit() 
        {
          if (animate)
            run(flock);
          render();
        }
      };
    } else {
      frame = new Frame(scene) {
        @Override
          public void visit() {
          if (animate) run(flock);
          shape(boidPs);
          //PShape group = createShape(GROUP);
          //group.addChild(boidPs);
          //shape(group);
        }
      };
    }
    frame.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())), 
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {  
    pushStyle();

    strokeWeight(2);
    stroke(color(40, 255, 40));
    fill(color(0, 255, 0, 125));

    beginShape(LINES);    


    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 0, 255));
      fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }
    if (representation)
    {
      for (int i=0; i<vectors.size()-1; i++) {
        for (int y=0; y<vectorList.get(i).size(); y++) {
          vertex(vectors.get(i)[0], vectors.get(i)[1], vectors.get(i)[2]);
          vertex(vectorList.get(i).get(y)[0], vectorList.get(i).get(y)[1], vectorList.get(i).get(y)[2]);
        }
      }
    } else
    {      
      for (int i=0; i<lfaces.size(); i++) {
        for (int j=0; j<=lfaces.get(i).length; j++) {
          PVector vertex = lvertex.get(lfaces.get(i)[j%3]);   
          vertex(vertex.x*sc, vertex.y*sc, vertex.z*sc);
        }
      }
    }
    endShape();
    // uncomment to draw boid axes
    //scene.drawAxes(10);



    //draw boid
    //
    //beginShape(TRIANGLES);
    //vertex(v0[0],v0[1],v0[2]);
    //vertex(-3 * sc, 2 * sc, 0);
    //vertex(-3 * sc, -2 * sc, 0);

    //vertex(3 * sc, 0, 0);
    //vertex(-3 * sc, 2 * sc, 0);
    //vertex(-3 * sc, 0, 2 * sc);

    //vertex(3 * sc, 0, 0);
    //vertex(-3 * sc, 0, 2 * sc);
    //vertex(-3 * sc, -2 * sc, 0);

    //vertex(-3 * sc, 0, 2 * sc);
    //vertex(-3 * sc, 2 * sc, 0);
    //vertex(-3 * sc, -2 * sc, 0);
    //endShape();

    popStyle();
  }
}
