int width_size = 350;
int height_size = 150;

void setup(){
  size(800, 500, P3D);
}

void draw(){
  background(255);
  strokeWeight(4);
  noFill();
  beginShape();
    vertex(50, 20);
    vertex(height_size+100, 20);
    vertex(height_size+60, width_size+20);
    vertex(10, width_size+20);
  endShape(CLOSE);
  
  beginShape();
    vertex(300, 50, -100);
    vertex(width_size+300, 50, -100);
    vertex(width_size+300, height_size+50, 0);
    vertex(350, height_size+50, 0);
  endShape(CLOSE);
}
