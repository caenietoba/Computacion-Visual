import processing.video.*;
import processing.opengl.*;

Movie video;

float canSize = 120;
PImage label;
PImage moon;
PImage circle;
PShape can;
PShape cap;

PShader pixlightShader;
PShader maskShader;

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

PShape light;

void setup() {
  size(1200, 700, P3D);
  
  label = loadImage("lachoy.jpg");
  moon = loadImage("Flare.JPG");
  circle = loadImage("planet.png");
  video = new Movie(this, "video.mov");
  video.loop();
  
  can = createCan(canSize, 2 * canSize, 32, label);
  cap = createCap(canSize, 32);
  
  light = createMoon(moon);
  
  maskShader = loadShader("convolutionfrag.glsl");
  pixlightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {
  background(0);
  
  if(useLight){
    
    configureLights();
      
    shader(pixlightShader);

    pointLight(255, 255, 255, x_light, y_light, z_light);
    //pointLight(255, 255, 255, width/2, height/2, 200);
  } else if(useMask){
    //maskShader = loadShader("convolutionfrag.glsl"); //Evitar que un cambio de mascara dañe las otras
    maskShader.set("mask", mask);
    shader(maskShader);
  }
  
  drawPlanet();
  drawCan(x_figure, y_figure, z_figure);
  //resetShader();
  drawLight(x_light, y_light, z_light);
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
  light.setTexture(moon);
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

PShape createMoon(PImage tex){
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
    pixlightShader.set("useAmbiental", 1);
    pixlightShader.set("intensityAmbiental", 1.0);
  }
  if(!useAmbiental){
    pixlightShader.set("useAmbiental", 0);
    pixlightShader.set("intensityAmbiental", 0);
  }
  if(useDiffuse)
    pixlightShader.set("useDiffuse", 1);
  if(!useDiffuse)
    pixlightShader.set("useDiffuse", 0);
  if(useSpecular){
    pixlightShader.set("useSpecular", 1);
    pixlightShader.set("shinessSpecular", 8);
  }
  if(!useSpecular){
    pixlightShader.set("useSpecular", 0);
    pixlightShader.set("shinessSpecular", 0);
  }
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
  }
  if(key == 'l'){
    useLight = true;
    useMask = false;
  }
  if(key == 'ñ'){
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
  if(key == '1' && useMask){
    mask = edges_mask;
  }
  if(key == '2' && useMask){
    mask = sharpen_mask;
  }
  if(key == '3' && useMask){
    mask = emboss_mask;
  }
  if(key == '4' && useMask){
    mask = simple_blur_mask;
  }
  if(key == '5' && useMask){
    mask = gaussian3x3_mask;
  }
  if(key == '6' && useMask){
    mask = mask1;
  }
  if(key == '7' && useMask){
    mask = laplacian_mask;
  }
  if(key == '8' && useMask){
    mask = motion_blur_mask;
  }
  if(key == '9' && useMask){
    mask = interpolation_mean_filter;
  }
}
