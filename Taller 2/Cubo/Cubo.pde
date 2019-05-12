float rotx = PI/4;
float roty = PI/4;

void setup() {
  size(640, 360, P3D);
  textureMode(NORMAL);
}

void draw() {
  background(0);
  fill(255);
  ortho(-width/2, width/2, -height/2, height/2);
  lights();
  //noStroke();
  stroke(0);
  strokeWeight(0.01);
  translate(width/2.0, height/2.0, -100);
  scale(100);
  rotateX(rotx);
  rotateY(roty);
  Cube();
  Cube2();
  R();
  L();
  S();
}

void Cube() {
  beginShape(QUADS);
  
  fill(0, 255, 0);
  vertex( 0,  0,  0);
  vertex( 1,  0,  0);
  vertex( 1, -1,  0);
  vertex( 0, -1,  0);
  
  fill(0, 0, 255);
  vertex( 0,  0,  0);
  vertex( 1,  0,  0);
  vertex( 1,  0,  1);
  vertex( 0,  0,  1);
  
  fill(255, 255, 0);
  vertex( 0,  0,  0);
  vertex( 0,  0,  1);
  vertex( 0, -1,  1);
  vertex( 0, -1,  0);

  endShape();
}

void Cube2(){
  beginShape(QUADS);
  
  fill(0, 255, 0);
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  vertex( 1, -1, -1);
  vertex(-1, -1, -1);
  
  fill(0, 0, 255);
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);
  
  fill(255, 255, 0);
  vertex(-1,  1, -1);
  vertex(-1,  1,  1);
  vertex(-1, -1,  1);
  vertex(-1, -1, -1);

  endShape();
}

void R(){
  beginShape();
  
  vertex( 1, -1,  0);
  vertex( 1, -1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  vertex( 1,  0,  1);
  vertex( 1,  0,  0);
  vertex( 1, -1,  0);

  endShape();
}

void L(){
  beginShape();
  
  fill(0, 255, 0);
  vertex( 0, -1,  1);
  vertex( 0,  0,  1);
  vertex( 1,  0,  1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);
  vertex(-1, -1,  1);
  vertex( 0, -1,  1);

  endShape();
}

void S(){
  beginShape();
  
  fill(0, 0, 255);
  vertex(-1, -1,  1);
  vertex( 0, -1,  1);
  vertex( 0, -1,  0);
  vertex( 1, -1,  0);
  vertex( 1, -1, -1);
  vertex(-1, -1, -1);
  vertex(-1, -1,  1);

  endShape(CLOSE);
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}
