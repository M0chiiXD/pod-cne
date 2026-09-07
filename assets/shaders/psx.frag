#pragma header

float to15bit(float col, float low) {
    float lower = floor(col * 32.0) / 32.0;
    return lower * low + (ceil(col * 32.0) / 32.0) * (1.0 - low);
}

vec3 Saturation(vec3 color, float amount) {
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(vec3(luma), color, amount);
}

void main() {
    vec2 pixel = vec2(1.0) / openfl_TextureSize;
    vec2 p = openfl_TextureCoordv;
    vec4 source = flixel_texture2D(bitmap, p);

    source.rgb = Saturation(source.rgb, 1.4);

    float checker = mod(mod(floor(p.x / pixel.x), 2.0) + mod(floor(p.y / pixel.y), 2.0), 2.0);

    vec4 col = vec4(to15bit(source.r, checker), to15bit(source.g, checker), to15bit(source.b, checker), source.a);

    gl_FragColor = col;
}