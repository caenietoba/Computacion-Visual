/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Cafe Wall (GEOMETRICAL-OPTICAL (OR DISTORTING) ILLUSION)

--------------------------*/

import java.lang.*;

//----------------------//
//Parametros del sistema//
int w = 50; //Anchura de los recuadros

double movement_2 = 0.125; //Velocidad del PGraphics 2
double movement_3 = 0.25; //Velocidad del PGraphics 3

//No olvide que si cambia estos valores debe cambiar los valores del size también
int screen_width = 750;
int screen_height = 450;
//----------------------//

//PGraphics cada uno contendra una fila que se va a mover según la velocidad
PGraphics pg_1;
PGraphics pg_2;
PGraphics pg_3;

int mouse_x = 0; //Posición del mouse en el eje x
//int mouse_x = int(screen_width/2);

int rect_in_row = 0; //Número de rectangulos en el eje x
int rect_in_col = 0; //Número de rectangulos en el eje y

int start_pixel_x = -w/2; //Pixel de inicio

void setup(){
  size( 750, 450 );
  
  //Inicialización de las variables
  pg_1 = createGraphics(2000,w);
  pg_2 = createGraphics(2000,w);
  pg_3 = createGraphics(2000,w);
  
  rect_in_row = (int)Math.ceil( screen_width/w ) + (int)Math.ceil( screen_width*movement_3/w ) + 1;
  rect_in_col = (int)Math.ceil( screen_height/w );
  //start_pixel_x = (-(int)Math.ceil( screen_width*movement_3/w ))*w/2 - w/2;
}

void draw(){
  
  //Lineas estaticas
  pg_1.beginDraw();
  pg_1.background(255);
  pg_1.fill(0);
  for(int i = 0; i < rect_in_row; i += 2){
    pg_1.rect(start_pixel_x +i*w,0,w,w);
  }
  pg_1.endDraw();
  for(int i = 0; i < rect_in_col; i++){
    image(pg_1, 0, i*w*4);
  }
  
  //Lineas de movimiento medio
  pg_2.beginDraw();
  pg_2.background(255);
  pg_2.fill(0);
  float new_position_pg_2 = (float)((int)(mouse_x*movement_2));
  for(int i = 0; i < rect_in_row; i += 2){
    float x_rect = start_pixel_x + i*w + new_position_pg_2;
    pg_2.rect(x_rect,0,w,w);
  }
  pg_2.endDraw();
  for(int i = 0; i < rect_in_col; i++){
    image(pg_2, 0, w + i*w*2);
  }
  
  //Lineas de movimiento rápido
  pg_3.beginDraw();
  pg_3.background(255);
  pg_3.fill(0);
  float new_position_pg_3 = (float)((int)(mouse_x*movement_3));
  for(int i = 0; i < rect_in_row; i += 2){
    float x_rect = start_pixel_x + i*w + new_position_pg_3;
    pg_3.rect(x_rect,0,w,w);
  }
  pg_3.endDraw();
  for(int i = 0; i < rect_in_col; i++){
    image(pg_3, 0, w*2 + i*w*4);
  }
  
  //Se dibujan las lineas intermedias entre filas
  strokeWeight(2);
  stroke(#939393);
  for( int i=0; i < rect_in_col; i++ ){
    line(0, i*w, screen_width, i*w);
  }
  
}

void mouseMoved(){
  mouse_x = -mouseX;
}
/*
void mouseMoved(){
  int middle_screen = screen_width/2;
  if( mouseX <= middle_screen){
    mouse_x = (mouseX + middle_screen);
  }else if( mouseX > middle_screen ){
    mouse_x = (mouseX - middle_screen);
  }
}*/
