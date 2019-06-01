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

// 6. Variables to select the antialising
int antialising_number = 2;
int antialising_pixels = round(pow(2, antialising_number));
char last_key = '1';

// 7.1. Distributions of the antialising points 

Vector[] _1distri1 = {
  new Vector(0.5, 0.5)
};

Vector[] _2distri1 = {
  new Vector(0.95, 0.05),
  new Vector(0.4, 0.6)
};

Vector[] _4distri1 = {
  new Vector(0.1, 0.25),
  new Vector(0.8, 0.15),
  new Vector(0.83, 0.65),
  new Vector(0.35, 0.85)
};

Vector[] _8distri1 = {
  new Vector(0.12, 0.18),
  new Vector(0.5, 0.05),
  new Vector(0.95, 0.3),
  new Vector(0.7, 0.6),
  new Vector(0.4, 0.4),
  new Vector(0.04, 0.76),
  new Vector(0.25, 0.95),
  new Vector(0.87, 0.85)
};

Vector[] _16distri1 = {
  new Vector(0.18, 0.18),
  new Vector(0.5, 0.05),
  new Vector(0.95, 0.3),
  new Vector(0.7, 0.6),
  new Vector(0.4, 0.4),
  new Vector(0.04, 0.76),
  new Vector(0.25, 0.95),
  new Vector(0.87, 0.85),

  new Vector(0.04, 0.4),
  new Vector(0.5, 0.2),
  new Vector(0.78, 0.1),
  new Vector(0.9, 0.58),
  new Vector(0.25, 0.5),
  new Vector(0.1, 0.97),
  new Vector(0.43, 0.75),
  new Vector(0.58, 0.91)
};

Vector[][] distri1 = {
  _1distri1, _2distri1, _4distri1, _8distri1, _16distri1
};

// 7.2. Random distribution of the antialising points.
Vector[] random_distri = new Vector[antialising_pixels];

// 7.3. Uniform distribution of the antialising points.
Vector[] uniform_distri = new Vector[antialising_pixels];

// 8. Antialising Distribution used
Vector[] antialising = distri1[antialising_number];

void selectRandomDistribution(){
  
  random_distri = new Vector[antialising_pixels];
  
  for(int i = 0; i < antialising_pixels; i++){
    random_distri[i] = new Vector(random(0, 1), random(0, 1));
  }
  antialising = random_distri;
}

void selectUniformDistribution(){
  
  uniform_distri = new Vector[antialising_pixels];
  
  float sqrt_pixels = sqrt(antialising_pixels);
  
  float delta_pixel = 1/(sqrt_pixels);
  
  float actual_y = delta_pixel/2;
  float actual_x = delta_pixel/2;
  
  for(int i=0; i < antialising_pixels; i++){
    uniform_distri[i] = new Vector(actual_x, actual_y);
    
    if(actual_x + delta_pixel < 1){
      actual_x += delta_pixel;
    } else {
      actual_x = delta_pixel/2;
      actual_y += delta_pixel;
    }
  }

  antialising = uniform_distri;
}

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

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
        fill(raster(new Vector(i, j)));
        square(i,j,1);
      }
    }
    popStyle();
  }
}

float edgeFunction(Vector a, Vector b, Vector c, Vector p){
  Vector a_node = node.location(a); 
  Vector b_node = node.location(b); 
  Vector c_node = new Vector(c.x() + p.x(), c.y() + p.y()); 
  return ((c_node.x() - a_node.x()) * (b_node.y() - a_node.y()) - (c_node.y() - a_node.y()) * (b_node.x() - a_node.x()));
}

int MSAA(Vector p){
  int in = 0; //Number of poitns or sub pixels in the figure (Triangle)
  
  float lambda1; //Area of the triangle formed by the pixel and the vertex 1
  float lambda2; //Area of the triangle formed by the pixel and the vertex 2
  float lambda3; //Area of the triangle formed by the pixel and the vertex 3
  
  //The algorithm of the edge function depends on the vertex order so we should look both faces of the tirangle
  boolean inside = false; 
  boolean inside_reverse = false;
  
  // Looks all the sub pixels of the antialising algorithm
  for(int i=0; i<antialising_pixels; i++){
    
    lambda1 = edgeFunction(v1, v2, p, antialising[i]);
    lambda2 = edgeFunction(v2, v3, p, antialising[i]);
    lambda3 = edgeFunction(v3, v1, p, antialising[i]);
    
    inside = lambda1 >= 0 && lambda2 >= 0 && lambda3 >= 0;
    inside_reverse = lambda1 <= 0 && lambda2 <= 0 && lambda3 <= 0;
    
    if(inside || inside_reverse)
      in++;
    
  }
  
  return in;
}

color raster(Vector p){
  
  float total = edgeFunction(v1,v2,node.location(v3), new Vector(0,0)); //Total area of the triangle
  float lambda1; //Area of the triangle formed by the pixel and the vertex 1
  float lambda2; //Area of the triangle formed by the pixel and the vertex 2
  float lambda3; //Area of the triangle formed by the pixel and the vertex 3
  
  // Looks all the sub pixels of the antialising algorithm
  int in = MSAA(p);
  
  //if(n > 0){
    
    // Looks for the middle of the pixel and the area
    lambda1 = (edgeFunction(v1, v2, p, new Vector(0.5, 0.5))/total);
    lambda2 = (edgeFunction(v2, v3, p, new Vector(0.5, 0.5))/total);
    lambda3 = (edgeFunction(v3, v1, p, new Vector(0.5, 0.5))/total);
    
    // Select the color for the linear combination each one taking a a red, green or blue
    float color_v1 = (red(v1_color) * in/antialising_pixels + green(v1_color) + blue(v1_color)) * lambda1;
    float color_v2 = (red(v2_color) + green(v2_color) * in/antialising_pixels + blue(v2_color)) * lambda2;
    float color_v3 = (red(v3_color) + green(v3_color) + blue(v3_color) * in/antialising_pixels) * lambda3;
    
    return color(color_v1, color_v2, color_v3);
    
  //} 
  //return 0;
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

//Select the number of sub pixels and the distribution of them 
void changeNumSubPixels(){
  antialising_pixels = round(pow(2, antialising_number));
  
  System.out.println("Number of sub-pixels: " + antialising_pixels);
  
  if(last_key == '1')
    antialising = distri1[antialising_number];
  if(last_key == '2')
    selectRandomDistribution();
  if(last_key == '3')
    selectUniformDistribution();
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
  if (key == 'a'){
    antialising_number = antialising_number < 4 ? antialising_number + 1 : 0;
    changeNumSubPixels();
  }
  if (key == 's'){
    antialising_number = antialising_number > 0 ? antialising_number - 1 : 4;
    changeNumSubPixels();
  }
  if (key == '1'){
    last_key = key;
    antialising = distri1[antialising_number];
    System.out.println("Distribution used: Preselected");
  }
  if (key == '2'){
    last_key = key;
    selectRandomDistribution();
    System.out.println("Distribution used: Random");
  }
  if (key == '3'){
    last_key = key;
    selectUniformDistribution();
    System.out.println("Distribution used: Uniform");
  }
}
