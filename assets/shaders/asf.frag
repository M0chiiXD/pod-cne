// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform && !openfl_HasColorTransform)
		return color;

	if (color.a == 0.0)
		return vec4(0.0, 0.0, 0.0, 0.0);

	if (openfl_HasColorTransform || hasColorTransform) {
		color = vec4 (color.rgb / color.a, color.a);
		vec4 mult = vec4 (openfl_ColorMultiplierv.rgb, 1.0);
		color = clamp (openfl_ColorOffsetv + (color * mult), 0.0, 1.0);

		if (color.a == 0.0)
			return vec4 (0.0, 0.0, 0.0, 0.0);

		return vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}

	return color * openfl_Alphav;
}

// variables which are empty, they need just to avoid crashing shader
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))

// end of ShadertoyToFlixel header

vec4 BlurColor (in vec2 Coord, in sampler2D Tex, in float MipBias)
{
	vec2 TexelSize = MipBias/iChannelResolution[0].xy;
    
    vec4  Color = texture(Tex, Coord, MipBias);
    Color += texture(Tex, Coord + vec2(TexelSize.x,0.0), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,0.0), MipBias);    	
    Color += texture(Tex, Coord + vec2(0.0,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(0.0,-TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(TexelSize.x,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(TexelSize.x,-TexelSize.y), MipBias);    	
    Color += texture(Tex, Coord + vec2(-TexelSize.x,-TexelSize.y), MipBias);    

    return Color/9.0;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float Threshold = 0.6;
    float Intensity = 2.0;
    float BlurSize = 2;

	vec2 uv = (fragCoord.xy/iResolution.xy);
    
    vec4 Color = texture(iChannel0, uv);
    
    vec4 Highlight = clamp(BlurColor(uv, iChannel0, BlurSize)-Threshold,0.0,1.0)*1.0/(1.0-Threshold);
        
    fragColor = 1.0-(1.0-Color)*(1.0-Highlight*Intensity); //Screen Blend Mode
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}