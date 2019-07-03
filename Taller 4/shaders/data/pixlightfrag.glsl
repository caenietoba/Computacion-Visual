#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform int useAmbiental;
uniform int useDiffuse;
uniform int useSpecular;
uniform float intensityAmbiental;
uniform int shinessSpecular;

varying vec4 vertColor;
varying vec4 vertTexCoord;

//  Luz difusa
varying vec3 ecNormal;
varying vec3 lightDir;

//  Luz especular
varying vec3 cameraDirection;
varying vec3 lightDirectionReflected;

vec4 ambientalLight(){
  return intensityAmbiental * useAmbiental;
}

vec4 diffuseLight(){
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.0, dot(direction, normal));
  return vec4(intensity, intensity, intensity, 1) * useDiffuse;
}

vec4 specularLight(){
  vec3 direction = normalize(lightDirectionReflected);
  vec3 camera = normalize(cameraDirection);
  float intensity = pow(max(0.0, dot(direction, camera)),shinessSpecular);
  return vec4(intensity, intensity, intensity, 1) * useSpecular;
}

void main() {
  vec4 tintColor = /*( ambientalLight() + diffuseLight() + specularLight() )*/1 * vertColor;
  gl_FragColor = texture2D(texture, vertTexCoord.st) * tintColor ;
}