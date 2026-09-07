// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

float random2 (in vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))* 43758.5453123);
}

vec2 myPattern(in vec2 uv){
	vec2 uv2 = uv;
    uv2.y = uv2.y + 1.0 * (random2(uv));
    //uv2.x = uv2.x + 1.0 * (random2(uv));
    return uv2 - uv;
}

void mainImage (out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  vec2 p = uv;
  for (int i = 0; i < 10; i ++) p -= myPattern(p) * 0.03;
  vec3 col = texture(iChannel0, p).rgb;
  fragColor = vec4(col, texture(iChannel0, p).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}