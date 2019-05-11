/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Zollner ilussion (GEOMETRICAL-OPTICAL (OR DISTORTING) ILLUSION)(COGNITIVE)

--------------------------*/

import java.lang.*;

//----------------------//
//Parametros del sistema//
int gap_big = 100; //Espacio en tre lineas diagonales
int gap_small = 35; //Espacio entre lineas horizontales o verticales(pequeñas)
int stroke_weight = 17; //Ancho de las lineas
//Si se cambia el tamaño de size se debe cambiar el tamaño de estas variables
int screen_height = 450; 
int screen_width = 750;
//----------------------//

//Lineas antes del punto de origin a dibujar para ocupar toda la pantalla
int lines_before_origin = (int)Math.ceil(screen_height/gap_big);
//Lineas después del punto de origin a dibujar para ocupar toda la pantalla
int lines_after_origin = (int)Math.ceil(screen_width/gap_big) + 1;
int total_lines = lines_before_origin + lines_after_origin;
//Tamaño antes del origen, número de lineas a pintar por la brecha entre estas
int size_before_origin = lines_before_origin*gap_big;

PGraphics pg_lines, pg_small_lines;

boolean clicked = false; //Pintara en caso de que no este clickeado el canvas

void setup(){
  size( 750, 450 );
  
  //El ancho de la pantalla más la cantidad de lineas que quepan en la altura
  // por la distancia entre dichas lineas, esto para dibujar las que quedan a 
  // medias antes del pixel 0,0 de la pantalla
  int pg_width = screen_width+size_before_origin;
  pg_lines = createGraphics(pg_width, screen_height);
  pg_small_lines = createGraphics(pg_width, screen_height);
  
}

void draw(){
  
  //Contendra las lineas largas en diagonal que se mantenran siempre pintadas
  pg_lines.beginDraw();
  pg_lines.background(255);
  pg_lines.strokeWeight(stroke_weight);
  for( int i=0; i<total_lines; i++){
    //lineas en angulo de 45 grados
    int x1 = i*gap_big;
    int x2 = screen_height+i*gap_big;
    int y1 = 0;
    int y2 = screen_height;
    pg_lines.line( x1, y1, x2, y2 );
  }
  pg_lines.endDraw();
  image(pg_lines, -size_before_origin, 0);
  
  //Rutina que pintara las lineas pequeñas dependiendo de si se esta clickeando
  if( !clicked ){
    
    int middle_stroke = stroke_weight/2;
    fill(0);
    //Recorre el eje x en el rango de pg_width
    for(int k=-size_before_origin; k<=screen_width; k+=gap_big){
      //Recorre el eje y desde o hasta la altura del canvas
      for(int i=0; i <= screen_height+gap_small; i += gap_small){
        //if que revisa si se esta en una linea par o impar y dependiendo de esto
        // hace las lineas horizontales o verticales
        if(abs(k/gap_big) % 2 == 1){
          int x1 = i-35+k;
          int x2 = i+25+k;
          int x3 = i+35+k;
          int x4 = i-25+k;
          int y1 = i-middle_stroke;
          int y2 = i-middle_stroke;
          int y3 = i+middle_stroke;
          int y4 = i+middle_stroke;
          quad(x1,y1,x2,y2,x3,y3,x4,y4);
        }else{
          int x1 = i-middle_stroke+k;
          int x2 = i+middle_stroke+k;
          int x3 = i+middle_stroke+k;
          int x4 = i-middle_stroke+k;
          int y1 = i-35;
          int y2 = i-25;
          int y3 = i+35;
          int y4 = i+25;
          quad(x1,y1,x2,y2,x3,y3,x4,y4);
        }
      }
    }
  }
}

void mousePressed(){
  clicked = true;
}

void mouseReleased(){
  clicked = false;
}
