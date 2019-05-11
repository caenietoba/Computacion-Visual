/*--------------------------
Camilo Esteban Nieto Barrera
Universidad Nacional de Colombia
Computación visual

Titulo: Rotate Square Motion (OPTICAL ILLUSIONS (OTHERS))

--------------------------*/


//----------------------//
//Parametros del sistema//
int square_width = 300;
int velocity_rot = 3;
int gap_squares = 15;
//Si se cambia el tamaño de size se debe cambiar el tamaño de estas variables
int screen_height = 450; 
int screen_width = 750;
//----------------------//

boolean clicked = false; //Pintara en caso de que no este clickeado el canvas

float grade = 0;

PGraphics pg; //Canvas que contendra el cuadrado que girara sobre su centro

void setup(){
  size( 750, 450 );
  
  pg = createGraphics(screen_width,screen_height);
}

void draw(){
  
  //Pinta el cuadrado que rota sobre su centro
  pg.beginDraw();
  pg.background(255);
  pg.rectMode(CENTER);
  pg.fill(#2941B7);
  pg.translate(width/2, height/2);
  pg.rotate(radians(grade));
  //square(225,50,square_width);
  pg.rect(0, 0, square_width, square_width); 
  increaseGrade();
  pg.endDraw();
  image(pg, 0, 0);
  
  //Pinta los rectangulos exteriores
  if(!clicked){
    noStroke();
    fill(#BC8328);
    int middle_width = screen_width/2;
    int middle_height = screen_height/2;
    rect(
        0, 0, 
        middle_width - gap_squares, middle_height - gap_squares
    );
    rect(
        middle_width + gap_squares, 0,
        screen_width, middle_height - gap_squares
    );
    rect(
        0, middle_height+gap_squares,
        middle_width - gap_squares, middle_height - gap_squares
    );
    rect(
        middle_width + gap_squares, middle_height + gap_squares,
        middle_width + gap_squares, middle_height - gap_squares
    );
  }
}

void increaseGrade(){
  grade += velocity_rot;
}

void mousePressed(){
  clicked = true;
}
 
void mouseReleased(){
  clicked = false;
}
