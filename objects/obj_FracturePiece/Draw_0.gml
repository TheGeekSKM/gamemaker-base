if (cfg_use_original_sprite && sprite_exists(cfg_original_sprite) && src_chunk_width > 0 && src_chunk_height > 0) 
{
    draw_sprite_part_ext(
        cfg_original_sprite,        
        cfg_original_image_index,   
        source_x_on_sprite,         
        source_y_on_sprite,         
        src_chunk_width,            
        src_chunk_height,           
        x,                          
        y,                          
        image_xscale,               
        image_yscale,               
        image_blend,                
        image_alpha                 
    );
} 
else if (sprite_exists(cfg_chunk_sprite)) 
{ 
    // Fallback to drawing a generic chunk sprite
    var _prev_sprite = sprite_index;
    var _prev_image_index = image_index;
    
    sprite_index = cfg_chunk_sprite; 
    image_index = 0; 
    
    draw_self(); 
    
    sprite_index = _prev_sprite; // Restore original sprite_index if it was important
    image_index = _prev_image_index;
    
} 
else 
{
    // Optional: Draw a default colored rectangle if no valid sprite at all
    // This helps visualize pieces if sprites are missing.
    
    // draw_set_color(image_blend);
    // draw_set_alpha(image_alpha);
    // var half_size = 2 * image_xscale; // Simple size
    // draw_rectangle(x - half_size, y - half_size, x + half_size, y + half_size, false);
    // draw_set_alpha(1);
}
