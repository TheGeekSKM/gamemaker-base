// sh_WhiteMultiply.frag
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_color; // this is your tint color

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);

    // Force the base to pure white but preserve alpha
    base.rgb = vec3(1.0, 1.0, 1.0);

    // Multiply your desired color
    gl_FragColor = base * u_color;
}

