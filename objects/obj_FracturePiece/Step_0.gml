if (!is_active) return;

current_life++;
if (current_life >= cfg_piece_lifetime && !is_on_ground) 
{ 
    // If not on ground, expire by lifetime
    Deactivate();
    return;
}

// --- Grounded Behavior ---
if (is_on_ground) 
{
    if (cfg_stop_on_ground) 
    {
        h_speed *= (1 - cfg_ground_friction_factor);
        
        if (abs(h_speed) < 0.1) h_speed = 0;
        
        v_speed = 0;
        current_angular_velocity *= 0.95; 
        
        if (abs(current_angular_velocity) < 0.1) current_angular_velocity = 0;
    }

    if (cfg_fade_on_ground && h_speed == 0 && current_angular_velocity == 0) 
    { 
        // Start fading if stopped
        fade_on_ground_timer++;
        image_alpha = 1 - (fade_on_ground_timer / cfg_fade_duration_ground);
        if (image_alpha <= 0) 
        {
            Deactivate();
            return;
        }
    } 
    else if (cfg_fade_on_ground) 
    { 
        // If moving on ground but fade is enabled, reset fade timer
        fade_on_ground_timer = 0;
        image_alpha = 1;
    }
} 
else 
{
    // --- In-Air Physics ---
    v_speed += cfg_gravity; // Apply gravity

    // Air friction (simple)
    h_speed *= (1 - cfg_air_friction);
    v_speed *= (1 - cfg_air_friction);
}

image_angle += current_angular_velocity;



// --- Collision Detection & Response (Manual AABB) ---
// Ensure sprite_width and sprite_height are available (use bbox if sprite is complex)
// For simplicity, using sprite dimensions directly. Mask index might be better.
var _bbox_w = sprite_get_width(sprite_index) * image_xscale;
var _bbox_h = sprite_get_height(sprite_index) * image_yscale;
var _col_obj = cfg_solid_object; // Use the configured solid object

// Horizontal Collision
x += h_speed;
if (place_meeting(x, y, _col_obj)) 
{
    x -= h_speed; // Revert move
    while (!place_meeting(x + sign(h_speed), y, _col_obj)) 
    { 
        x += sign(h_speed); 
    }
    h_speed *= -cfg_bounce_factor; // Bounce
    current_angular_velocity *= 0.8; // Dampen rotation on impact
}

// Vertical Collision
y += v_speed;
if (place_meeting(x, y, _col_obj)) 
{
    var _was_moving_down = (v_speed > 0);
    y -= v_speed; // Revert move
    while (!place_meeting(x, y + sign(v_speed), _col_obj)) 
    { 
        y += sign(v_speed); 
    }
    v_speed *= -cfg_bounce_factor; // Bounce

    if (_was_moving_down && abs(v_speed) < cfg_gravity * 2) 
    { 
        // Check if it has settled after moving down
        is_on_ground = true;
        v_speed = 0; // Stop vertical movement more firmly on ground
        if (cfg_stop_on_ground) h_speed *= (1 - cfg_ground_friction_factor); // Initial ground friction application
    }
    current_angular_velocity *= 0.8;
}

// Boundary checks (optional, destroy if goes too far off-screen)
if (y > room_height + 100) 
{ 
    Deactivate();
}

