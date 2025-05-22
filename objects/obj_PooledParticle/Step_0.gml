if (!is_active) {
    return; 
}

life_timer++;
if (life_timer >= life_duration) 
{
    Deactivate();
    return; 
}

vel_y += grav; 
spd = point_distance(0, 0, vel_x, vel_y);
if (spd > 0) 
{ 
    spd = max(0, spd - fric);
    var _dir = point_direction(0, 0, vel_x, vel_y);
    vel_x = lengthdir_x(spd, _dir);
    vel_y = lengthdir_y(spd, _dir);
}
x += vel_x;
y += vel_y;

var progress = life_timer / life_duration; 

current_alpha = lerp(cfg_alpha_start, cfg_alpha_end, progress);
current_scale = lerp(cfg_size_start, cfg_size_end, progress);
current_color = merge_color(cfg_color_start, cfg_color_end, progress);
current_angle += cfg_rotation_speed;

image_alpha = current_alpha;
image_xscale = current_scale;
image_yscale = current_scale;
image_angle = current_angle;
image_blend = current_color; 
