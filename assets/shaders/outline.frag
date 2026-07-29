#pragma header

uniform float outlineThreshold = 0.1;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 src = flixel_texture2D(bitmap, uv);

    if (src.a <= 0.0) {
        gl_FragColor = vec4(0.0);
        return;
    }

    float brightness = (src.r + src.g + src.b) / 3.0;

    float isOutline = 1.0 - smoothstep(0.0, outlineThreshold, brightness);

    vec3 bodyColor = vec3(0.0);

    vec3 outlineColor = vec3(1.0);

    vec3 finalRGB = mix(bodyColor, outlineColor, isOutline);

    gl_FragColor = vec4(finalRGB, src.a);
}