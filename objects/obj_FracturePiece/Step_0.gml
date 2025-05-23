if (!is_active) return;

current_life++;
if ((current_life >= cfg_piece_lifetime && !is_on_ground) || y > room_height + 200) 
{
    Deactivate();
    return;
}

// --- Apply Forces (Gravity & Friction) ---
if (is_on_ground) {
    if (cfg_stop_on_ground) 
    {
        h_speed *= (1 - cfg_ground_friction_factor); 
        if (abs(h_speed) < 0.05) h_speed = 0;         
        
        current_angular_velocity *= 0.95;
        if (abs(current_angular_velocity) < 0.1) current_angular_velocity = 0;
    }

    if (cfg_fade_on_ground && abs(h_speed) < 0.1 && abs(current_angular_velocity) < 0.1) 
    { 
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
        fade_on_ground_timer = 0;
        image_alpha = 1; 
    }
} 
else 
{
    v_speed += cfg_gravity; 

    h_speed *= (1 - cfg_air_friction);
    v_speed *= (1 - cfg_air_friction); 
}

// Update rotation
image_angle += current_angular_velocity;

// --- Perform Movement and Collision ---
var _collision_object = cfg_solid_object; 
var _collisions_array = move_and_collide(h_speed, v_speed, _collision_object);

// --- Process Collisions ---
var _num_collisions = array_length(_collisions_array);
if (_num_collisions > 0) {
    var _bounced_this_step = false; 
    var _landed_on_ground_this_step = false;

    for (var i = 0; i < _num_collisions; ++i) 
    {
        var _other_id = _collisions_array[i];
        
        if (!instance_exists(_other_id)) continue;
        
        var _impact_direction_x = 0;
        var _impact_direction_y = 0;
        var _landed_this_hit = false;
        
        
        if (h_speed != 0) 
        {
            if (bbox_right >= _other_id.bbox_left && bbox_left <= _other_id.bbox_right) 
            { 
                if (h_speed > 0 && x < _other_id.bbox_left) _impact_direction_x = -1; 
                else if (h_speed < 0 && x > _other_id.bbox_right) _impact_direction_x = 1;  
            }
        }
        
        if (v_speed != 0) 
        {
            if (bbox_bottom >= _other_id.bbox_top && bbox_top <= _other_id.bbox_bottom) 
            { 
                if (v_speed > 0 && y < _other_id.bbox_top) 
                {
                    _impact_direction_y = -1; 
                    _landed_this_hit = true; 
                } 
                else if (v_speed < 0 && y > _other_id.bbox_bottom) 
                { 
                    _impact_direction_y = 1;
                }
            }
        }
        
        // If we have a direction component, attempt a bounce
        if (_impact_direction_x != 0 || _impact_direction_y != 0) 
        {
            var _len = sqrt(_impact_direction_x * _impact_direction_x + _impact_direction_y * _impact_direction_y);
            var _normal_x = (_len > 0) ? _impact_direction_x / _len : 0;
            var _normal_y = (_len > 0) ? _impact_direction_y / _len : 0;
        
            if (_normal_x != 0 || _normal_y != 0) 
            { 
                var _dot_product = (h_speed * _normal_x) + (v_speed * _normal_y);
                
                h_speed = (h_speed - 2 * _dot_product * _normal_x) * cfg_bounce_factor;
                v_speed = (v_speed - 2 * _dot_product * _normal_y) * cfg_bounce_factor;
                
                current_angular_velocity *= 0.8;
                _bounced_this_step = true; // Use your flag if you keep it
            }
        }
        
        if (_landed_this_hit) 
        {
            is_on_ground = true; 
        }
    }
    
    // Update ground state after processing all collisions in this step
    if (_landed_on_ground_this_step) 
    {
        is_on_ground = true;
        if (cfg_stop_on_ground && v_speed < 0 && abs(v_speed) < 1.0) 
        {
            v_speed = 0;
        }
    } 
    else 
    {
        // If we collided but no collision was with the ground, we are not on the ground.
        // This handles cases like hitting a wall or ceiling without touching ground.
        // However, if `is_on_ground` was already true from a previous step,
        // we need to check if we're *still* on ground (e.g., by a small downward raycast or if v_speed becomes positive)
        // For simplicity, if move_and_collide reports no ground normal this step, assume not on ground unless very slow.
        
        // A more robust check might be needed if pieces can slide off edges.
        // if (is_on_ground && abs(v_speed) > 0.1) is_on_ground = false; // Simple check if we started moving vertically again
    }
} 
else 
{
    // No collisions this step. If we were on the ground, check if we are still on it
    // (e.g. if we walked off a ledge)
    if (is_on_ground) 
    {
        if (!place_meeting(x, y + 1, _collision_object)) 
        {
            is_on_ground = false; 
        }
    }
}
