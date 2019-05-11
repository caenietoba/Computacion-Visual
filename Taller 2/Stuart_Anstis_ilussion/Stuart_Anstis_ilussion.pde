/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Stuart Anstis ilussion (OPTICAL ILLUSIONS (MOVEMENT))

--------------------------*/

//----------------------//
//Parametros del sistema//
int screen_height = 450; 
int screen_width = 750;
int gap = 30;
int gap_bwn_rects = 80;
//----------------------//

PGraphics pg_base, pg_rect;

int stroke_weight = gap/2; //Grosor de las lineas verticales
int direction = 1; //Dirección de movimiento
int position = 0; //Posición en el eje x de los rectangulos en movimiento
int width_rects = gap*2; //Ancho de los rectangulos en movimiento

boolean clicked = false; //Pintara en caso de que no este clickeado el canvas

void setup(){
  size( 750, 450 );
  
  pg_base = createGraphics( screen_width, screen_height );
  pg_rect = createGraphics( width_rects, width_rects/2 );
  
}

void draw(){
  pg_base.beginDraw();
  pg_base.background(255);
  pg_base.strokeWeight(stroke_weight);
  pg_base.strokeCap(SQUARE);
  if( !clicked )
    for(int i = 10; i<screen_width; i+=gap){
      pg_base.line(i, 10, i, screen_height-10);
    }
  pg_base.endDraw();
  image(pg_base, 0, 0);
  
  int middle_screen = screen_height / 2;
  int middle_gap_rects = gap_bwn_rects / 2;
  image(newRect(#FCF103, pg_rect), position, middle_screen - middle_gap_rects);
  image(newRect(#0A1E7E, pg_rect), position, middle_screen + middle_gap_rects);
  
  movePosition();
}

//Función que mueve la posición de los rectangulos
void movePosition(){
  if( direction == 1 ){
    if( position == screen_width - width_rects ){
      position--;
      direction = 0;
    }else
      position++;
  }else
    if( position == 0 ){
      position++;
      direction = 1;
    }else
      position--;
}

//función que retorna un nuevo PGraphics de un color especifico
PGraphics newRect(color _color, PGraphics pg){
  pg.beginDraw();
  pg.background(_color);
  pg.endDraw();
  return pg;
}

void mousePressed(){
  clicked = true;
}
 
void mouseReleased(){
  clicked = false;
}
