#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;

uniform sampler2D u_gb0; //normals and depth
uniform sampler2D u_gb2;


void main() {
    vec3 col = texture(u_frame, fs_UV).xyz;
    float luminence = (0.21 * col[0]) + (0.72 * col[1]) + (0.07 * col[2]);

    vec4 color = vec4(1.0,1.0,1.0,1.0);

    if (luminence < 1.0) {
        if(mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0) {
            color = vec4(0.0,0.0,0.0,1.0);
        }
    }

    if (luminence < .75) {
        if(mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0) {
            color = vec4(0.0,0.0,0.0,1.0);
        }
    }

    if (luminence < .50) {
        if(mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0) {
            color = vec4(0.0,0.0,0.0,1.0);
        }
    }

    if (luminence < 0.30) {
        if(mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0) {
            color = vec4(0.0,0.0,0.0,1.0);
        }
    }
 
    
    // Sobel edge detection
     vec3 gradientX = vec3(0, 0 ,0);
     vec3 gradientY = vec3(0, 0, 0);

     mat3 horiz = mat3(vec3(3, 10, 3), vec3(0, 0 , 0), vec3(-3, -10, -3));
     mat3 verti = mat3(vec3(3, 0, -3), vec3(10, 0, -10), vec3(3, 0, -3));



     for(float i = -1.0; i <= 1.0; i++) {
         for(float j = -1.0; j <= 1.0; j++) {
             vec4 diffColor = texture(u_frame, fs_UV + vec2(i / 1000.0, j / 700.0));
             highp int iF = int(i);
             highp int jF = int(j);
             gradientX += diffColor.xyz * horiz[iF + 1][jF + 1];
             gradientY += diffColor.xyz * verti[iF + 1][jF + 1];
         }
     }

     float gradR = sqrt(pow(gradientX.x, 2.0) + pow(gradientY.x, 2.0));
     float gradG = sqrt(pow(gradientX.y, 2.0) + pow(gradientY.y, 2.0));
     float gradB = sqrt(pow(gradientX.z, 2.0) + pow(gradientY.z, 2.0));

     vec3 gradCol = vec3(gradR, gradG, gradB);
     float l = length(gradCol);
     if(l > 7.0) {
         out_Col = vec4(vec3(0.0), 1.0);
     }
     else {
         out_Col = color;
     }



   
    
}
