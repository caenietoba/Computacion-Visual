# Procesamiento de imagenes

A la hora de trabajar con imagenes, hay muchas transformaciones que pueden ser útiles en el proceso del análisis. Una imagen digital es un conjunto de datos que nos indican desde la ubicación de un determinado pixel hasta valores como su saturación, brillo, tendencia al rojo, etc. Manejando un poco estos pequeños pixeles podemos realizar diversas transformaciones como una escala de grises o aplicarles diversos filtros para, por ejemplo, ver con claridad los bordes de una imagen.
No solamente se aplica a las imagenes, pues los videos podemos decir que son un conjunto de ellas que van una detras de otra.

* ## Escala de Grises:

Las escalas de grises nos ayudan a observar la cantidad de luz en una imagen, la intensidad que carga cada uno de los pixeles en la imagen. Uno de los métodos más comunes para realizar esto es mediante el promedio de sus valores RGB, pero esto sería decir que cada color aporta la misma cantidad de información. Asi que se utilizan otros métodos para lograr una mejor imagen, en la que también se represente correctamente su brillo. En este taller se utiliza LUMA SMPTE 240M.

* ## Filtros y convoluciones:

En el procesamiento de imagenes, a veces se requiere que las imagenes nos muestren información detallada de su forma, trazos, o conjunto, y quitar algunas partes de la iamgen o resaltarlas puede ser de gran ayuda. Alli entran los filtros y las convoluciones. cuando trabajamos con el area alrededor de cada pixel podemos ver con mayor claridad ciertos detalles de la imagen. El uso de matrices aplicadas a cada pixel nos permiten desenfocar, afilar, estampar, detectar bordes y más. Esto se logra haciendo una convolución entre un kernel y una imagen.

* ## Histogramas:

Como hemos mencionado, en una imagen se encuentra mucha información y a veces sólo requerimos una parte de la imagen. Aparte de usar Filtros y convoluciones, podemos hacer uso de los histogramas y la segmentación. Con un histograma podemos observar por medio de un gráfico de barras, que partes del gráfico tienen una determinada cantidad de brillo, como se hizo en el taller, o analizar su espectro de rojos, verdes y azules, entre muchos otros análisis. Una vez obtenido el histograma, Se puede segmentar para que sólo se muestre una pequeña parte del espectro, como un cierto número de brillo por ejemplo. En el taller, a pesar de que se había recomendado el usoi de 2 algoritmos, se utilizó el método de Otsu

* ## Videos y FPS:

Los videos son un conjunto de imagenes sucesivas. Es por esto que también se le pueden realizar todos los análisis mencionados anteriormente. En el programa presentado se puede ver como el video es pasado a escala de grises o se le aplican diversos filtros. Se le puso un medidor de FPS para ver la eficacia computacional. No se notan grandes cambios en los FPS, en los videos intentados, pero si cuando se utilizan otras técnicas para observar el video como lo es el redimensionamiento.

## Taller 1

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Bibliografía

* https://processing.org/tutorials/pixels/
* https://en.wikipedia.org/wiki/Luma_(video)
* https://en.wikipedia.org/wiki/Kernel_(image_processing)
* https://bostjan-cigan.com/java-image-binarization-using-otsus-algorithm/
* 

