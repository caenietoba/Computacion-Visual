varying	vec3 g_lightVec;
varying	vec3 g_viewVec;
varying vec4 vertTexCoord;

//vec4 lightEye = vec4(0,0,2,1);

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;
uniform vec4 lightPosition;
uniform vec2 multiTexCoord;

attribute vec3 normal;
attribute vec2 texCoord;
attribute vec4 position;

void main()
{
    vec3 tangent = vec3(0,0,0);
    vec3 binormal = vec3(0,0,0);

	//gl_Position = ftransform();
    gl_Position = modelViewProjectionMatrix * position;
    
	
	mat3 TBN_Matrix = normalMatrix * mat3(tangent, binormal, normal);
	vec4 mv_Vertex = modelViewMatrix * position;
	g_viewVec = vec3(-mv_Vertex) * TBN_Matrix ;	
	//vec4 lightEye = gl_LightSource[0].position;
	//lightEye = gl_ProjectionMatrixInverse * lightEye;
	vec4 lightEye = modelViewMatrix *  lightPosition;
	vec3 lightVec =0.02* (lightEye.xyz - mv_Vertex.xyz);				
	g_lightVec = lightVec * TBN_Matrix; 
    vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0); 
}