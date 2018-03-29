#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;

// Interpolation between color and greyscale over time on left half of screen
void main() {
    float sigma = 4.0;
    float threshold = 0.3;

    vec4 sum;

    for(float i = -6.0; i <= 6.0; i++) {
        for(float j = -6.0; j <= 6.0; j++) {
            float guassian = (1.0 / (2.0 * 3.14159 * (sigma * sigma))) * pow(2.71828, -((i * i) + (j * j)) / (2.0 * (sigma * sigma)));
            vec4 diffColor = texture(u_frame, fs_UV + vec2(i / 1000.0, j / 700.0));
            vec4 value = diffColor * guassian;

            float grey = 0.21 * diffColor.x + 0.72 * diffColor.y + 0.07 * diffColor.z;
            if(grey > threshold) {
            sum += value;
            }
        }
    }

    vec4 originalColor = texture(u_frame, fs_UV);

    out_Col =  vec4(originalColor.xyz + sum.xyz, 1.0);
}
