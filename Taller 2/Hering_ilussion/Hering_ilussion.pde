/*--------------------------
Universidad Nacional de Colombia
Computación visual

Titulo: Heiring Illsuion

--------------------------*/

PGraphics pg;
PGraphics other;

int h = 0;

void setup(){
  size(400,500);
  
  pg = createGraphics( width/2, height );
  other = createGraphics( width/2, height );
  h = height / 5;
}

void draw(){
  
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(1.5);
  for(int i=-3; i<10; i++){
    pg.line(0, i*h, pg.width, height/2);
  }
  pg.strokeWeight(10);
  pg.point(pg.width, pg.height/2);
  pg.stroke(#C42514);
  pg.strokeWeight(7);
  pg.line(pg.width-pg.width/5, 0, pg.width-pg.width/5, height);
  pg.endDraw();
  image(pg, 0, 0);
  
  other.beginDraw();
  other.loadPixels();
  copyPixels(pg, other);
  other.updatePixels();  
  other.endDraw();
  image(other, width/2, 0);
}

void copyPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.width; i++){
    for(int j=0; j<in.height; j++){
      int out_pixel = j*in.width + (in.width - 1 - i); 
      int loc = j*in.width + i;
      out.pixels[out_pixel] = in.pixels[loc];
    }
  }
}
