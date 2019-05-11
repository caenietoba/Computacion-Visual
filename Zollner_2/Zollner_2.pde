/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Zollner ilussion (GEOMETRICAL-OPTICAL (OR DISTORTING) ILLUSION)(COGNITIVE)

--------------------------*/

int gap = 0;
boolean pressed = false;

void setup(){
  size(400, 500);
  gap = height/7;
}

void draw(){
  
  background(255);
  
  strokeWeight(2);
  
  if( !pressed )
    for( int i=0; i<6; i++){
      line(150, i*gap, 200, 100+i*gap);
      line(200, 100+i*gap, 250, i*gap);
    }
  
  line(175, 0, 175, height);
  line(225, 0, 225, height);
}

void mousePressed(){
  pressed = true;
}

void mouseReleased(){
  pressed = false;
}
