import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 10;

// 5. Colors vertex
color v1_color = color(255,0,0);
color v2_color = color(0,255,0);
color v3_color = color(0,0,255);

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);
  
  System.out.println(v1_color);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    noStroke();
    for(int i=-int(pow(2,n))/2; i<int(pow(2,n))/2; i+=1){
      for(int j=-int(pow(2,n))/2; j<int(pow(2,n))/2; j+=1){
        fill(raster(new Vector(i+0.5, j+0.5)));
        square(i,j,1);
      }
    }
    popStyle();
  }
}

float edgeFunction(Vector a, Vector b, Vector c){
  Vector a_node = node.location(a); 
  Vector b_node = node.location(b); 
  Vector c_node = c; 
  return ((c_node.x() - a_node.x()) * (b_node.y() - a_node.y()) - (c_node.y() - a_node.y()) * (b_node.x() - a_node.x()));
  //Si es mayor que 0 significa que el areá es mayor que 0 y por tanto el punto esta al lado positivo de la arista
}

color raster(Vector p){
  
  float total = edgeFunction(v1,v2,node.location(v3));
  float lambda1 = edgeFunction(v1, v2, p);
  float lambda2 = edgeFunction(v2, v3, p);
  float lambda3 = edgeFunction(v3, v1, p);
  
  boolean inside = lambda1 >= 0 && lambda2 >= 0 && lambda3 >= 0;
  
  if(inside){
    lambda1 /= total;
    lambda2 /= total;
    lambda3 /= total;
    color color_raster = floor(v1_color*lambda1/255 + v2_color*lambda2/255 + v3_color*lambda3/255);
    System.out.println(color_raster);
    return color(red(color_raster), green(color_raster), blue(color_raster));
  }
  return 0;
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
