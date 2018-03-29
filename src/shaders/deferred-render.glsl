#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962

in vec2 fs_UV;
//in vec4 fs_Pos;
out vec4 out_Col;

uniform sampler2D u_gb0; //normals and depth
uniform sampler2D u_gb1;
uniform sampler2D u_gb2; // basic color

uniform float u_Time;

uniform mat4 u_View;
uniform vec4 u_CamPos;   


void main() { 
	// read from GBuffers

	// Base color (albedo)
	vec4 gb0 = texture(u_gb0, fs_UV);
	vec4 gb2 = texture(u_gb2, fs_UV);

	vec3 col = gb2.xyz;
	// Is this redundant?
	col = gb2.xyz;



	vec4 lightVec = vec4(2.0, 2.0, 0.0, 0.0);


	 // Calculate the diffuse term for Lambert shading
	float diffuseTerm = dot(normalize(vec4(gb0.xyz, 0.0)), normalize(lightVec));
	diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);
	
	float ambientTerm = 0.2;

	float lightIntensity = diffuseTerm + ambientTerm;

	//out_Col = vec4(gb2.xyz, 1.0); // albedo
	if(gb0.w > .999999) {
		// Draw background a diff color

		// Do worley noise

		float numCells = 10.0;
		float minimum = 1.f;
    	vec2 minPoint;

    	vec2 cellUV = fs_UV * numCells;
    	vec2 cellID = floor(cellUV);
    	vec2 localCellUV = fract(cellUV);

    	for(float i = -1.0; i <= 1.0; i++) {
        	for(float j = -1.0; j <= 1.0; j++) {

            	vec2 random = fract(sin(vec2(dot(cellID + vec2(i, j), vec2(127.1, 311.7)),
                                	dot(cellID + vec2(i, j), vec2(269.5, 183.3))))
                                	* 43758.5453);

            	random = 0.5 + 0.5 * sin((u_Time / 3.0) + 6.2831 * random);

            	float dist = length(vec2(i, j) + random - localCellUV);

            	if(dist < minimum) {
                	minimum = dist;
                	minPoint = vec2(i, j);
            	}
        	}
    	}

		

		vec4 finalCol = vec4((cellID +  minPoint) / numCells, 0.1, 1.0);
		out_Col = normalize(finalCol);
		
	}
	else {
		out_Col = vec4(col.rgb * lightIntensity, 1.0); // lambert
	}
}