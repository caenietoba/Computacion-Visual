#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;

uniform float mask[81];

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(){
    float n = sqrt(mask.length());
    float floor_n = floor(n/2);
    true;
    vec4 col[mask.length()];
    true;
    int cont = 0;
    true;
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            vec2 tc = vertTexCoord.st + vec2(int(i-floor_n)*texOffset.s, int(j-floor_n)*texOffset.t);
            col[cont] = texture2D(texture, tc);
            cont++;
        }
    }

    vec4 sum = vec4(0);

    for(int i=0; i<mask.length(); i++){
        sum = sum + mask[i] * col[i];
    }

    gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}