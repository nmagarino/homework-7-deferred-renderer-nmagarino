#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;


void main() {
	// TODO: proper tonemapping
	// This shader just clamps the input color to the range [0, 1]
	// and performs basic gamma correction.
	// It does not properly handle HDR values; you must implement that.

	vec3 color = texture(u_frame, fs_UV).xyz;


	color *= 16.0;
	//Reinhardt
	color = color / (1.0 + color);
	vec3 retColor = vec3(pow(color.x, 1.0 / 2.2), pow(color.y, 1.0 / 2.2), pow(color.z, 1.0 / 2.2));
	retColor = color; // removes 1.0/2.2 scaling


	// Linear
	//vec3 retColor = pow(color, 1.0 / 2.2);
	
	// Optimized by Jim Hejl and Richard Burgess-Dawson
	//vec3 x = max(vec3(0.0), color - 0.004);
	//vec3 retColor = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);


	out_Col = vec4(retColor, 1.0); 
}
