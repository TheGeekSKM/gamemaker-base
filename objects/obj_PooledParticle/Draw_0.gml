if (!is_active || !visible) {
    return;
}

if (cfg_sprite_index != -1 && sprite_exists(cfg_sprite_index)) 
{
    var old_blend_mode = gpu_get_blendmode();
    if (cfg_blend_mode != bm_normal) 
    {
        gpu_set_blendmode(cfg_blend_mode);
    }
    
    draw_self(); 
    
    if (cfg_blend_mode != bm_normal) 
    {
        gpu_set_blendmode(old_blend_mode);
    }
} 
else 
{
    draw_set_alpha(current_alpha);
    draw_set_color(current_color);
    draw_circle(x, y, 3 * current_scale, false); 
    draw_set_alpha(1); 
}
