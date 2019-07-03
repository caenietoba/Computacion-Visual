uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform float time;
uniform float frequency;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

attribute vec3 tangent; //The inverse tangent to the geometry
attribute vec3 binormal; //The inverse binormal to the geometry

varying vec4 vertTexCoord;
varying vec4 vertColor;

//  Varying luz difusa
varying vec3 ecNormal;
varying vec3 lightDir;

//  Varying luz especular
varying vec3 cameraDirection;
varying vec3 lightDirectionReflected;

vec3 computeNormal( vec3 pos, 
                    vec3 tangent, 
                    vec3 binormal, 
                    float phase, 
                    float freq )
{
	mat3 J;
	
	float dist = sqrt(pos.x*pos.x + pos.z*pos.z);
	float jac_coef = cos(freq*dist + phase) / (dist+0.00001);
	
	// A matrix is an array of column vectors so J[2] is 
	// the third column of J.
	
	J[0][0] = 1.0;
	J[0][1] = jac_coef * pos.x;
	J[0][2] = 0.0;
	
	J[1][0] = 0.0;
	J[1][1] = 1.0;
	J[1][2] = 0.0;

	J[2][0] = 0.0;
	J[2][1] = jac_coef * pos.z;
	J[2][2] = 1.0;
	
	vec3 u = J * tangent;
	vec3 v = J * binormal;
	
	vec3 n = cross(v, u);
	return normalize(n);
}

vec4 displaceVertexFunc( vec4 pos, float phase, float frequency ) 
{
	vec4 new_pos;
	
	new_pos.x = pos.x;
	new_pos.z = pos.z;
	new_pos.w = pos.w;
	
	float dist = sqrt(pos.x*pos.x + pos.z*pos.z);
	new_pos.y = pos.y + 20.0 * sin( frequency * dist + phase );
	
	return new_pos;
}

void main() {

  /**/
  vec4 displacedVertex;
	vec3 displacedNormal;
	
	// 1 - Compute the diplaced position.
	//	
	vec4 displacedPosition = displaceVertexFunc(gl_Position, time*2.0, frequency );
   	
	gl_Position = modelViewProjectionMatrix * displacedPosition;	   	
	//texCoord = modelViewMatrix * displacedPosition;
	
	
	// 2 - Compute the displaced normal
	//
	
	// if the engine does not provide the tangent vector you 
	// can compute it with the following piece of of code:
	//
	vec3 tangent; 
	vec3 binormal; 
	
	vec3 c1 = cross(normal, vec3(0.0, 0.0, 1.0));
	vec3 c2 = cross(normal, vec3(0.0, 1.0, 0.0));
	
	if(length(c1)>length(c2))
	{
		tangent = c1;
	}
	else
	{
		tangent = c2;
	}
	
	tangent = normalize(tangent);

  binormal = cross(normal, tangent);
	binormal = normalize(binormal);

  displacedNormal = computeNormal( displacedPosition.xyz,
	                                 tangent.xyz,
	                                 binormal,
	                                 time*2.0,
	                                 frequency );
  /**/

  gl_Position = transform * position;    
  vec3 ecPosition = vec3(modelview * position);  
  
  vec3 normal2 = normal * 2.0 - 1.0; 

  //  Difusa
  ecNormal = normalize(normalMatrix * displacedNormal);
  lightDir = normalize(lightPosition.xyz - ecPosition);

  //Especular
  cameraDirection = normalize(0 - ecPosition);
  lightDirectionReflected = reflect(-lightDir, ecNormal);

  vertColor = color;  
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);    
  
}