is_active = false; 
visible = false;
persistent = true; 

life_timer = 0;
life_duration = 60; 

vel_x = 0;
vel_y = 0;
spd = 0;
grav = 0.1;
fric = 0.01;

current_alpha = 1;
current_scale = 1;
current_angle = 0;
current_color = c_white;

// These cfg_ variables will store the specific configuration for this instance when active
cfg_sprite_index = spr_default; 
cfg_color_start = c_white;
cfg_color_end = c_black;
cfg_alpha_start = 1;
cfg_alpha_end = 0;
cfg_size_start = 1;
cfg_size_end = 1;
cfg_rotation_speed = 0; 
cfg_blend_mode = bm_normal;
cfg_sprite_image_speed = 1;


pool_type = InstanceType.PARTICLE;

function Activate(x_pos, y_pos, config) {
    is_active = true;
    visible = true;
    
    x = x_pos;
    y = y_pos;
    
    life_timer = 0;
    // Access properties directly from the config struct (which now uses the new naming)
    life_duration = config.lifeFrames;

    cfg_sprite_index = config.spriteIndex;
    cfg_color_start = config.colorStart;
    cfg_color_end = config.colorEnd;
    cfg_alpha_start = config.alphaStart;
    cfg_alpha_end = config.alphaEnd;
    cfg_size_start = config.sizeStart;
    cfg_size_end = config.sizeEnd;
    cfg_rotation_speed = config.rotationSpeed;
    cfg_blend_mode = config.blendMode;
    cfg_sprite_image_speed = config.spriteImageSpeed;
    
    grav = config.gravityAmount;
    fric = config.frictionAmount;

    var _dir = random_range(config.directionMin, config.directionMax);
    spd = random_range(config.speedMin, config.speedMax);
    
    vel_x = lengthdir_x(spd, _dir);
    vel_y = lengthdir_y(spd, _dir);
    
    current_alpha = cfg_alpha_start;
    current_scale = cfg_size_start;
    current_angle = random(360); 
    current_color = cfg_color_start;
    
    image_xscale = current_scale;
    image_yscale = current_scale;
    image_alpha = current_alpha;
    image_angle = current_angle;
    image_blend = current_color; 
    sprite_index = cfg_sprite_index;
    image_speed = (sprite_exists(sprite_index) && sprite_get_number(sprite_index) > 1) ? cfg_sprite_image_speed : 0;
    image_index = 0;
}

function Deactivate() {
    if (!is_active) return; 

    is_active = false;
    visible = false;
    
    vel_x = 0;
    vel_y = 0;
    
    if (instance_exists(global.FeedbackManager)) 
    {
        global.FeedbackManager.ReturnInstanceToPool(id, pool_type);
    } 
    else 
    {
        instance_destroy();
    }
}