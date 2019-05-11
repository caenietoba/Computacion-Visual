/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Motion Binding (OPTICAL ILLUSIONS (MOVEMENT))

--------------------------*/

//----------------------//
//Parametros del sistema//
int square_size = 80;
int screen_height = 700; 
int screen_width = 750;
//----------------------//

int actual1 = 0; //Movimiento actual de las lineas que van en la dirección 1
int actual2 = 10; //Movimiento actual de las lineas que van en la dirección 2
int direction1 = 1; //Dirección actual de las lineas que van en la dirección 1
int direction2 = 1; //Dirección actual de las lineas que van en la dirección 2

boolean clicked = false; //Pintara en caso de que no este clickeado el canvas

int move_range = square_size/2 - 20; //Rango de movimiento de las lineas

void setup(){
  size( 750, 700 );
  
}

void draw(){
  
  int x1,x2,y1,y2;
  
  //Creación de las lineas//
  background(255);
  stroke(#031DFC);
  strokeWeight(7);
  x1 = screen_width/2 + square_size/2 + actual1;
  y1 = 5*square_size/2 - actual1;
  x2 = screen_width/2 + 3*square_size/2 + actual1;
  y2 = 7*square_size/2 - actual1;
  line( x1, y1, x2, y2 );
  x1 = screen_width/2 - square_size/2 + actual2;
  y1 = 5*square_size/2 + actual2;
  x2 = screen_width/2 - 3*square_size/2 + actual2;
  y2 = 7*square_size/2 + actual2;
  line( x1, y1, x2, y2 );
  x1 = screen_width/2 - 3*square_size/2 + actual1;
  y1 = 9*square_size/2 - actual1;
  x2 = screen_width/2 - square_size/2 + actual1;
  y2 = 11*square_size/2 - actual1;
  line( x1, y1, x2, y2 );
  x1 = screen_width/2 + 3*square_size/2 + actual2;
  y1 = 9*square_size/2 + actual2;
  x2 = screen_width/2 + square_size/2 + actual2;
  y2 = 11*square_size/2 + actual2;
  line( x1, y1, x2, y2 );
  
  //Creación de los cuadrados
  if(clicked){
    strokeWeight(0);
    fill(#03FC57);
    stroke(#03FC57);
    quad(screen_width/2, square_size,
      screen_width/2 + square_size, square_size*2,
      screen_width/2, square_size*3,
      screen_width/2 - square_size, square_size*2
    );
    quad(screen_width/2 + square_size*2, square_size*3,
      screen_width/2 + square_size*3, square_size*4,
      screen_width/2 + square_size*2, square_size*5,
      screen_width/2 + square_size, square_size*4
    );
    quad(screen_width/2, square_size*5,
      screen_width/2 + square_size, square_size*6,
      screen_width/2, square_size*7,
      screen_width/2 - square_size, square_size*6
    );
    quad(screen_width/2 - square_size*2, square_size*3,
      screen_width/2 - square_size, square_size*4,
      screen_width/2  - square_size*2, square_size*5,
      screen_width/2 - square_size*3, square_size*4
    );
  }
  
  updateActual();
  
}

//Actualiza el pixel de movimiento de las lineas
void updateActual(){
  if(direction1 == 1){
    if( actual1 == move_range ){
      actual1--;
      direction1 = 0;
    }else
      actual1++;
  }else{
    if( actual1 == -move_range ){
      actual1++;
      direction1 = 1;
    }else
      actual1--;
  }
  if(direction2 == 1){
    if( actual2 == move_range ){
      actual2--;
      direction2 = 0;
    }else
      actual2++;
  }else{
    if( actual2 == -move_range ){
      actual2++;
      direction2 = 1;
    }else
      actual2--;
  }
  
}

void mousePressed(){
  clicked = true;
}
 
void mouseReleased(){
  clicked = false;
}
