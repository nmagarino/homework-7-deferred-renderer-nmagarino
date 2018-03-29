#version 300 es
precision highp float;

in vec2 fs_UV;
//in vec2 fs_depth;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;
uniform sampler2D u_gb0; //normals and depth
uniform sampler2D u_gb2;



void main() {

    vec4 gb0 = texture(u_gb0, fs_UV);
    vec4 gb2 = texture(u_gb2, fs_UV);

    // GUASSIAN BLUR //
    float sigma = .001;
     if(gb0.w > 0.995) {
         sigma = 7.0;
    }
   
    

    vec4 sum;
    float guasSum;

    for(float i = -8.0; i <= 8.0; i++) {
        for(float j = -8.0; j <= 8.0; j++) {
            float guassian = (1.0 / (2.0 * 3.14159 * (sigma * sigma))) * pow(2.71828, -((i * i) + (j * j)) / (2.0 * (sigma * sigma)));
            vec4 diffColor = texture(u_frame, fs_UV + vec2(i / 1000.0, j / 700.0));
            guasSum += guassian;
            vec4 value = diffColor * guassian;
            sum += value;
        }
    }

    vec3 blurCol = sum.xyz / guasSum;
    

	out_Col = vec4(blurCol, 1.0);
    //out_Col = vec4(vec3(gb0.w), 1.0);
    //out_Col = vec4(gb0.w, gb0.w, gb0.w, 1.0);
    //out_Col = vec4(gb2.z, gb2.x, gb2.y, 1.0);
    
}
