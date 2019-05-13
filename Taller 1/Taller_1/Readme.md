# Procesamiento de imagenes

A la hora de trabajar con imagenes, hay muchas transformaciones que pueden ser útiles en el proceso del análisis. Una imagen digital es un conjunto de datos que nos indican desde la ubicación de un determinado pixel hasta valores como su saturación, brillo, tendencia al rojo, etc. Manejando un poco estos pequeños pixeles podemos realizar diversas transformaciones como una escala de grises o aplicarles diversos filtros para, por ejemplo, ver con claridad los bordes de una imagen.
No solamente se aplica a las imagenes, pues los videos podemos decir que son un conjunto de ellas que van una detras de otra.

* ## Escala de Grises:

Las escalas de grises nos ayudan a observar la cantidad de luz en una imagen, la intensidad que carga cada uno de los pixeles en la imagen. Uno de los métodos más comunes para realizar esto es mediante el promedio de sus valores RGB, pero esto sería decir que cada color aporta la misma cantidad de información. Asi que se utilizan otros métodos para lograr una mejor imagen, en la que también se represente correctamente su brillo. En este taller se utiliza LUMA SMPTE 240M.

* ## Filtros y convoluciones:

P

* ## Histogramas:

S

* ## Videos y FPS:

U

## Taller 1

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Bibliografía

* 
