PImage img;

void setup() {
  size(1000, 600, P3D);

  img = loadImage("persona_caminando.png");
}

void draw() {
  
  background(255);
  
  translate(width/2, height/2, 0); 
  noFill();
  stroke(0);
  box(500,350,350);
  
  textureMode(IMAGE);
  noStroke();
  beginShape();
  texture(img);
  vertex(100, 20, -2000, 0, 0);
  vertex(840, 20, -2000, img.width, 0);
  vertex(840, 550, -2000,img.width, img.width);
  vertex(100, 550, -2000, 0, img.width);
  endShape();
  
  textureMode(IMAGE);
  noStroke();
  beginShape();
  texture(img);
  vertex(-500, -50, -500, 0, 0);
  vertex(240, -50, -500, img.width, 0);
  vertex(240, 500, -500,img.width, img.width);
  vertex(-500, 500, -500, 0, img.width);
  endShape();
}
