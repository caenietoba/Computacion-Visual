# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](http://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Integrantes

Complete la tabla:

|  Integrante  | github nick |
|--------------|-------------|
| Camilo Nieto | caenietoba  |
| Esteban Peña | phoenixest  |

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

-------------------------------------------------------------------------------------------------------------

# Solución

Los 3 puntos han sido desarrollados en el mismo código, cada uno de ellos usando su propia técnica.

## Rasterización

La rasterización se ha desarrollado usado la función borde (edge function) para saber si un pixel en específico de la grilla esta dentro o fuera del triangulo. Se debe tener cuidado al momento de aplicar la función borde con el orden de los vertices del triangulo, para evitar inconvenientes con esto se evalua ambos lados del triangulo viendo que todos los resultados de las funciones edge sean o mayores que 0 o menores que 0.

En un principio se consdera que el pixel esta adentro si el punto medio del pixel pertenece a la figura.

En esta fase nos damos cuenta del problema de alising y de como la figura puede no verse bien dependiendo de su posición en la grilla y en cada pixel.

## Sombrear en superficie cada pixel

Una vez se ha hecho el proceso de rasterización es posible pintar cada pixel dentro de la figura, para este ejercicio se ha pintado cada pixel dependiendo de los colores de los vertices por medio de una ecuacion lineal haciendo una especie de degrade entre los 3 vertices.

Esta forma de pintar el triangulo en particular se ha realizado usando la misma función edge que se uso en la rasterización pero aplicado bajo otro concepto. La función edge aparte de decir si el punto esta al lado derecho de un lado del triangulo (o aplicado a los 3 triangulos decir si esta adentro al ser todos positivos) también dice el areá del triangulo formado por los 3 vertices, al aplicar la función edge a cada uno de los lados y el pixel mirado se puede normalizar este resultado para saber en que punto especifico del triangulo esta dicho pixel y por tanto hallar la distancia a la que se encuentra de cada vertice. Con estas 3 distancias se puede generar una combinación lineal multiplicando cada distancia normalizada por el color y sumnado estos resultados.

Hay que tener en cuenta el manejo de colores en processing y como los colores RGB se representan en estos lenguajes así que generar el color con la representación matematica de la combinación lineal no puede ser de todo conveniente, por eso para esta implementación se ha generado la combinacion lineal operando directamente con cada color en los 3 RGB y así generando un degrade directamente en el color.

## Anti-aliasing

El ejercicio de anti-aliasing se ha llevado a cabo usando el algortimo de SSAA o de supersampling el cual para cada pixel los divide en una cantidad especifica de sub pixeles y dependiendo de cuantos de estos sub pixeles esten dentro de la figura entonces el color del borde va a ser:

                                color * sub_pixeles_dentro / sub_pixeles_total

Se ha implementado la opción de cambiar el número de sub pixeles a 1, 2, 4, 8 y 16 al igual que la distribución aplicada para la generación de estos sub pixeles donde la posibles distribuciones son una distribución predeterminada, una distribución estocastica y la uniforme.

Para el ejercicio del anti-aliasing se debe tener 3 aspectos en concreto a la hora de aplicar un algortimo, estos son el tipo de anti-alising (pre o post dibujado) algunos algoritmos usan mascaras para degradar los bordes de las figuras por otra parte hay otros que ppor cada pixel realizan un anti-aliasing, otro punto es la cantidad de puntos que se miran dentro de cada pixel a la hora revisar y por último la distribución de los puntos dentro de cada pixel.

Cuantos sub pixeles usar por cada pixel por lo cual entre más puntos sean usados mas preciso sera el anti-aliasing pero más costoso el procesamiento.

Como se distribuyen estos puntos o sub pixeles dentro de los pixeles, para responder a esto se deben revisar los diferentes algoritmos de espaciado como el de la distribución Poisson, el estocastico (aleatorio), uniforme, Jitter, Quasi-Monte Carlo, entre muchos otras formas de organizar los puntos en el espacio del pixel.

Se han revisado otros algoritmos de anti-aliasing como el MSAA el cual no aplica el algoritmo del anti-aliasing a toda laa grilla si no soló a los bordes de la figura.

## Opciones programa

El programa cuenta con ciertas opciones para cambiar el comportamiento en tiempo de ejecución y revisar su funcionamiento, a estas opciones se accede con las teclas del teclado que son:

    - g: Muestra u/o oculta la grilla que representan los pixeles.
    - t: Muestra u/o oculta el borde del triangulo.
    - d: Muestra u/o oculta los colores de cada pixel dentro del triangulo.
    - +: Aumenta la escala de la grilla colocando más pixeles en la grilla.
    - -: Disminuye la escala de la grilla colocando menos pixeles en la grilla.
    - r: Genera un triangulo aleatorio.
    - espacio: Gira la grilla en la dirección establecida.
    - y: Cambia la dirección el la cual la grilla va a girar con el espacio.
    - a: Aumenta el número de sub pixles por cada pixel. 
    - s: Disminuye el número de sub pixles por cada pixel. 
    - 1. Cambia la distribución usada para poner los puntos por una distribución predefinida. 
    - 2. Cambia la distribución usada para poner los puntos de forma aleatoria.
    - 3. Cambia la distribución usada para poner los puntos de forma uniforme.