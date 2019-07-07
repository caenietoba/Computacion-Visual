import processing.video.*;
import processing.opengl.*;

Movie video;

float canSize = 120;
PShape can;
PShape cap;

PImage mandril;
PImage cat;
PImage label;
PImage _light;
PImage circle;
PImage wood_height;
PImage wood_normal;
PImage moon;
PImage moon2;

PShader lightShader;
PShader maskShader;

/** 
* Máscaras de convolución usadas en el software (Hasta la linea 104)
*/
float[][] edges_mask_soft = { 
  { -1, -1, -1 },
  { -1,  8, -1 },
  { -1, -1, -1 } 
}; 

float[][] sharpen_mask_soft = {
  { -1, -1, -1 },
  { -1,  9, -1 },
  {-1, -1, -1}
};

float[][] emboss_mask_soft =
{
  {-1, -1,  0},
  {-1,  0,  1},
  {0,  1,  1}
};

float[][] simple_blur_mask_soft = {
  {0.111, 0.111, 0.111}, 
  {0.111, 0.111, 0.111}, 
  {0.111, 0.111, 0.111}
};

float[][] gaussian3x3_mask_soft = {
  {0.077847, 0.123317, 0.077847},
  {0.123317, 0.195346, 0.123317},
  {0.077847, 0.123317, 0.077847},
};

float[][] gaussian5x5_mask_soft = {
  {1,  4,  6,  4,  1},
  {4, 16, 24, 16,  4},
  {6, 24, 36.0, 24, 6},
  {4, 16, 24, 16,  4},
  {1,  4,  6,  4,  1},
};
                            
float[][] laplacian_mask_soft = {
  {0,  0,  -1, 0,  0},
  {0,  -1, -2, -1, 0},
  {-1, -2, 16, -2, -1},
  {0,  -1, -2, -1, 0},
  {0,  0,  -1, 0,  0},
};
                        
float[][] mask1_soft = {
  {1, 1, 1}, 
  {1, 1, 1}, 
  {1, 1, 1}
};
                
float[][] matrix2_soft = { 
  {-1, 0, 1},
  {-1,  0, 1},
  {-1, 0, 1}
};
                    
float[][] motion_blur_mask_soft = {
  {1, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 1, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 1, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 1, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 1, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 1, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 1, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 1, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 1}
};

float[][] interpolation_mean_filter_soft = {
  {1/36.0,   1/36.0,   1/36.0,   1/36.0,   1/36.0},
  {1/36.0,   2/36.0,   2/36.0,   2/36.0,   1/36.0},
  {1/36.0,   2/36.0,   4/36.0,   2/36.0,   1/36.0},
  {1/36.0,   2/36.0,   2/36.0,   2/36.0,   1/36.0},
  {1/36.0,   1/36.0,   1/36.0,   1/36.0,   1/36.0}
};

/** 
* Máscaras de convolución usadas en el shader (Hasta la linea 185)
*/
float[] edges_mask = {
  -1, -1, -1, 
  -1,  8, -1, 
  -1, -1, -1
};
                     
float[] sharpen_mask = {
  -1, -1, -1,
  -1,  9, -1,
  -1, -1, -1
};

float[] emboss_mask =
{
  -1, -1,  0,
  -1,  0,  1,
   0,  1,  1
};

float[] simple_blur_mask = {
  0.111, 0.111, 0.111, 
  0.111, 0.111, 0.111, 
  0.111, 0.111, 0.111
};

float gaussian3x3_mask[] = {
  0.077847, 0.123317, 0.077847,
  0.123317, 0.195346, 0.123317,
  0.077847, 0.123317, 0.077847,
};

float gaussian5x5_mask[] = {
  1,  4,  6,  4,  1,
  4, 16, 24, 16,  4,
  6, 24, 36.0, 24,  6,
  4, 16, 24, 16,  4,
  1,  4,  6,  4,  1,
};
                            
float[] laplacian_mask = {
  0,  0,  -1, 0,  0,
  0,  -1, -2, -1, 0,
  -1, -2, 16, -2, -1,
  0,  -1, -2, -1, 0,
  0,  0,  -1, 0,  0,
};
                        
float[] mask1 = {
  1, 1, 1, 
  1, 1, 1, 
  1, 1, 1
};
                
float[] matrix2 = { 
  -1, 0, 1,
  -1,  0, 1,
  -1, 0, 1
};
                    
float[] motion_blur_mask = {
  1, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 1, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 1, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 1, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 1, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 1, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 1,
};

float[] interpolation_mean_filter = {
  1/36.0,   1/36.0,   1/36.0,   1/36.0,   1/36.0,
  1/36.0,   2/36.0,   2/36.0,   2/36.0,   1/36.0,
  1/36.0,   2/36.0,   4/36.0,   2/36.0,   1/36.0,
  1/36.0,   2/36.0,   2/36.0,   2/36.0,   1/36.0,
  1/36.0,   1/36.0,   1/36.0,   1/36.0,   1/36.0
};

boolean useMaskSoft = false;

boolean useLight = false;
boolean useTexture = true;
boolean useAmbiental = false;
boolean useDiffuse = false;
boolean useSpecular = false;
boolean useMask = false;
boolean useVideo = false;
boolean useRotate = false;
float angle = 0.0;
float angle_planet;

float z_figure = 0.0;
float x_figure = 0.0;
float y_figure = 0.0;

float z_light = 0.0;
float x_light = 0;
float y_light = 0;

float[] mask = interpolation_mean_filter;
float[][] mask_soft = interpolation_mean_filter_soft; 

PShape light;

void setup() {
  size(1200, 700, P3D);
  
  label = loadImage("lachoy.jpg");
  _light = loadImage("Flare.JPG");
  circle = loadImage("planet.png");
  mandril = loadImage("mandril.jpg");
  moon = loadImage("moon.png");
  moon2 = loadImage("moon2.png");
  
  video = new Movie(this, "video.mov");
  video.loop();
  
  can = createCan(canSize, 2 * canSize, 32, label);
  cap = createCap(canSize, 32);
  
  light = create_light(_light);
  
  maskShader = loadShader("convolutionfrag.glsl");
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {
  background(0);
  
  if(useLight){
    
    configureLights();
    lightShader.set("normal_map", wood_normal);
    shader(lightShader);

    pointLight(135, 135, 135, x_light, y_light, z_light);
    //pointLight(255, 255, 255, width/2, height/2, 200);
  } else if(useMask){
    maskShader.set("mask", mask);
    shader(maskShader);
  }
  
  drawPlanet();
  drawCan(x_figure, y_figure, z_figure);
  //resetShader();
  drawLight(x_light, y_light, z_light);
  
  if(useMaskSoft){
      loadPixels();
      // Begin our loop for every pixel in the smaller image
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++ ) {
          color c = convolution(x, y, mask_soft, mask_soft.length);
          int loc = x + y*width;
          pixels[loc] = c;
        }
      }
      updatePixels();
  }
  
  fill(255);
  textSize(25);
  text("FPS: " + int(frameRate), 500, 600);  
}

void drawPlanet(){
  pushMatrix();
  translate(width/2,height/2);
  rotateY(angle_planet);
  angle_planet += 0.01;
  PShape box = createShape(SPHERE,100);
  box.setTexture(circle);
  shape(box);
  popMatrix();
}

float anglePlanet;

void drawLight(float x, float y, float z){
  pushMatrix();
  noStroke();
  translate(x, y, z);
  light.setTexture(_light);
  shape(light);
  popMatrix();
}

void drawCan(float x, float y, float z) {
  pushMatrix();

  translate(x, y, z);
  if(useRotate){
    rotateY(angle);
    angle += 0.01;
  }
  if (useTexture) {
    if(useVideo)
      can.setTexture(video);
    else
      can.setTexture(label);
  } else {
    can.setTexture(null);
  }
  shape(can);
    
  resetShader();
    
  pushMatrix();
  translate(0, canSize - 5, 0);
  shape(cap);
  popMatrix();

  pushMatrix();
  translate(0, -canSize + 5, 0);
  shape(cap);
  popMatrix();
  
  popMatrix();
}

PShape create_light(PImage tex){
  noStroke();
  PShape shape = createShape(SPHERE,35);
  shape.setTexture(tex);
  return shape;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape();
  return sh;
}

PShape createCap(float r, int detail) {
  PShape sh = createShape();
  sh.beginShape(TRIANGLE_FAN);
  sh.noStroke();
  sh.fill(128);
  sh.vertex(0, 0, 0);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    sh.vertex(x * r, 0, z * r);
  }  
  sh.endShape();
  return sh;
}

void configureLights(){
  if(useAmbiental){
    lightShader.set("useAmbiental", 1);
    lightShader.set("intensityAmbiental", 0.1);
  }
  if(!useAmbiental){
    lightShader.set("useAmbiental", 0);
    lightShader.set("intensityAmbiental", 0);
  }
  if(useDiffuse)
    lightShader.set("useDiffuse", 1);
  if(!useDiffuse)
    lightShader.set("useDiffuse", 0);
  if(useSpecular){
    lightShader.set("useSpecular", 1);
    lightShader.set("shinessSpecular", 8);
  }
  if(!useSpecular){
    lightShader.set("useSpecular", 0);
    lightShader.set("shinessSpecular", 0);
  }
}

color convolution(int x, int y, float[][] matrix, int matrixsize)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,pixels.length-1);
      // Calculate the convolution
      rtotal += (red(pixels[loc]) * matrix[i][j]);
      gtotal += (green(pixels[loc]) * matrix[i][j]);
      btotal += (blue(pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

void movieEvent(Movie m) {
  m.read();
}

void mouseMoved(MouseEvent event){
    x_figure = event.getX();
    y_figure = event.getY();
}

void mouseDragged(MouseEvent event){
    x_light = event.getX();
    y_light = event.getY();
}

   
void mouseWheel(MouseEvent event){
  if(mousePressed)
    z_light += event.getCount()*10;
  else
    z_figure += event.getCount()*10;
}

void keyPressed(){
  maskShader = loadShader("convolutionfrag.glsl"); //Evitar que un cambio de mascara dañe las otras
  if(key == 'b'){
    useTexture = !useTexture;
  }
  if(key == 'v'){
    useVideo = !useVideo;
  }
  if(key == 'r'){
    useRotate = !useRotate;
  }
  if(key == 'k'){
    useMask = true;
    useLight = false;
    useMaskSoft = false;
  }
  if(key == 'l'){
    useLight = true;
    useMask = false;
    useMaskSoft = false;
  }
  if(key == 'ñ'){
    useLight = false;
    useMask = false;
    useMaskSoft = false;
  }
  if(key == 'j'){
    useMaskSoft = true;
    useLight = false;
    useMask = false;
  }
  if(key == '1' && useLight){
    useAmbiental = !useAmbiental;
  }
  if(key == '2' && useLight){
    useDiffuse = !useDiffuse;
  }
  if(key == '3' && useLight){
    useSpecular = !useSpecular;
  }
  if(key == '1' && (useMask || useMaskSoft)){
    mask = edges_mask;
    mask_soft = edges_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '2' && (useMask || useMaskSoft)){
    mask = sharpen_mask;
    mask_soft = sharpen_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '3' && (useMask || useMaskSoft)){
    mask = emboss_mask;
    mask_soft = emboss_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '4' && (useMask || useMaskSoft)){
    mask = simple_blur_mask;
    mask_soft = simple_blur_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '5' && (useMask || useMaskSoft)){
    mask = gaussian3x3_mask;
    mask_soft = gaussian3x3_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '6' && (useMask || useMaskSoft)){
    mask = mask1;
    mask_soft = mask1_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '7' && (useMask || useMaskSoft)){
    mask = laplacian_mask;
    mask_soft = laplacian_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '8' && (useMask || useMaskSoft)){
    mask = motion_blur_mask;
    mask_soft = motion_blur_mask_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
  if(key == '9' && (useMask || useMaskSoft)){
    mask = interpolation_mean_filter;
    mask_soft = interpolation_mean_filter_soft;

    maskShader = loadShader("convolutionfrag.glsl");
  }
}
