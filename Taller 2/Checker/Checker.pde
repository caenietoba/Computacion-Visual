/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Checker (OPTICAL ILLUSIONS (OTHERS))

--------------------------*/

//----------------------//
//Parametros del sistema//
int screen_height = 450; 
int screen_width = 750;
int square_width = 60;
//----------------------//

boolean clicked = false; //Pintara en caso de que no este clickeado el canvas

color color1, color2;

int w = square_width/5;

void setup(){
  size( 750, 450 );
  
}

void draw(){
  background(#CBFAFF);
  
  //Pintar los cuadrados
  fill(#36FF4F);
  stroke(#36FF4F);
  for(int i=0; i<screen_width; i+=square_width*2){
    for(int j=0; j<screen_height; j+=square_width*2){
      //Pinta dos filas al tiempo
      square(i, j, square_width);
      square(i+square_width, j+square_width, square_width);
    }
  }
  
  //Pintar rombos
  if( !clicked ){
    strokeWeight(0);
    for(int i=0; i<=screen_width; i+=square_width){
      for(int j=0; j<=screen_height; j+=square_width){       
        
        findActualColor( i, j );
        
        //Pinta los rombos de arriba y de abajo
        fill(color1);
        stroke(color1);
        quad( i, j-w, i+w/2, j-w/2, i, j, i-w/2, j-w/2);
        quad( i, j, i+w/2, j+w/2, i, j+w, i-w/2, j+w/2);
        
        //Pinta los rombos de la izquierda y la derecha
        fill(color2);
        stroke(color2);
        quad( i-w/2, j-w/2, i, j, i-w/2, j+w/2, i-w, j);
        quad( i+w/2, j-w/2, i+w, j, i+w/2, j+w/2, i, j);
        
      }
    }
  }
}

//cambia los colores dependiendo de los indices que se esten recorriendo
void findActualColor( int i, int j ){
  if((i+j)/square_width % 5 == 0 || (i+j)/square_width % 5 == 3){
    color1 = 0;
    color2 = 255;
  }else{
    color1 = 255;
    color2 = 0;
  }
}

void mousePressed(){
  clicked = true;
}
 
void mouseReleased(){
  clicked = false;
}
