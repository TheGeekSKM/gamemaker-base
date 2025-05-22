if (!is_active || !visible) 
{
    return;
}

if (cfg_internal.spriteIndex != -1 && sprite_exists(cfg_internal.spriteIndex)) 
{
    var draw_x = x; 
    var draw_y = y;
    
    draw_sprite_ext(
        cfg_internal.spriteIndex,
        floor(image_index), 
        draw_x,
        draw_y,
        current_sprite_scale,
        current_sprite_scale,
        current_sprite_angle,
        c_white, 
        current_sprite_alpha
    );
}

if (cfg_internal.text != "") 
{
    cfg_internal.scribble_element.transform(current_text_scale, current_text_scale, 0); 
    cfg_internal.scribble_element.blend(cfg_internal.textColor, current_text_alpha); 

    if (cfg_internal.sdfOutlineWidth > 0) 
    {
        cfg_internal.scribble_element.sdf_outline(cfg_internal.sdfOutlineColor, cfg_internal.sdfOutlineWidth);
    }
    
    cfg_internal.scribble_element.draw(x, y);
}