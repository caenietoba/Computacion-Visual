#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;

uniform float mask[];

varying vec4 vertColor;
varying vec4 vertTexCoord;

int main(){
    double n = sqrt(mask.length())
    double floor_n = floor(n/2);
    vec4 col[mask.length()];
    int cont = 0;
    for(double i=-floor_n; i<floor_n; i=i+1){
        for(double j=-floor_n; j<floor_n; j=j+1){
            vec2 tc = vertTexCoord.st + vec2(i*texOffset.s, j*texOffset.t);
            col[cont] = texture2D(texture, tc);
            cont++;
        }
    }

    vec4 sum = 0;

    for(int i=0; i<mask.length(); i++){
        sum = sum + mask[i] * col[i];
    }

    gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}