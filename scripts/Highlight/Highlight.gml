function Highlight(_sprite, _subImg, _x, _y, _scaleX, _scaleY, _angle, _color) {
    shader_set(sh_WhiteMultiply);
    
    var _r = color_get_red(_color) / 255;
    var _g = color_get_green(_color) / 255;
    var _b = color_get_blue(_color) / 255;
    
    shader_set_uniform_f(shader_get_uniform(sh_WhiteMultiply, "u_color"), _r, _g, _b, 1);
    draw_sprite_ext(_sprite, _subImg, _x, _y, _scaleX, _scaleY, _angle, c_white, 1);
    
    shader_reset();
}