/*--------------------------
Universidad Nacional de Colombia
Computación visual

Titulo: Spinning dancer (OPTICAL ILLUSIONS (OTHERS))

--------------------------*/

PGraphics pg_original;
PGraphics pg_sombra;
PImage image;

int rot_ctr = 1;
int y = 0;

void setup(){
  size(600,500, P3D);
  
  image = loadImage("baila2.png");
  image.resize(400, 300);
  pg_original = createGraphics(600, 400, P3D);
  pg_sombra = createGraphics(600, 400, P3D);
}

void draw(){
  
  pg_original.beginDraw();
  pg_original.background(#BCBCBC);
  //asignamos el valor de giro
  pg_original.translate(width/2, 40 + y);
  pg_original.rotateY(-rot_ctr*TWO_PI/360);
  pg_original.translate(-image.width/2, 40 + y/2);
  pg_original.image(image, 0, 0);
  pg_original.endDraw();
  pg_original.loadPixels();
  
  pg_sombra.beginDraw();
  pg_sombra.loadPixels();
  copyPixels(pg_original, pg_sombra);
  pg_sombra.pixels = gray(pg_sombra.pixels);
  pg_sombra.updatePixels();  
  pg_sombra.endDraw();
  
  image(pg_original, 0, 0);
  image(pg_sombra, 0, 400);
  
  rot_ctr += 4;
}

void copyPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.width; i++){
    for(int j=0; j<in.height; j++){
      int out_pixel = (in.height - 1 - j)*in.width + i; 
      int loc = j*in.width + i;
      out.pixels[out_pixel] = in.pixels[loc];
    }
  }
}

//Conversión a escala de grises
color[] gray( color[] pixels_array ){
  for (int i = 0; i < pixels_array.length; i++) {
    color p = pixels_array[i]; // Guardamos el color del pixel
    float r = red(p); // Modificamos el valor del rojo
    float g = green(p); // Modificamos el valor del verde
    float b = blue(p); // Modificamos el valor del azul
    float luma240 = 0.212*r + 0.701*g + 0.087*b; //Método del Luma 240
    float promedyGray = (r + g + b) / 3.0; //Método del promedio
    pixels_array[i] = color(luma240);
  }
  return pixels_array;
}
