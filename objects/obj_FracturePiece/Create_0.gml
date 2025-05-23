is_active = false;
visible = false;
persistent = true; 

pool_type = InstanceType.FRACTURE_PIECE;

// --- Physics & State ---
h_speed = 0;
v_speed = 0;
current_angular_velocity = 0;
is_on_ground = false;
current_life = 0;
fade_on_ground_timer = 0;

// --- Config Storage (will be populated by activate method) ---
cfg_original_sprite = -1;
cfg_original_image_index = 0;
cfg_use_original_sprite = true;
cfg_chunk_sprite = -1; 
cfg_piece_lifetime = 120;
cfg_gravity = 0.2;
cfg_air_friction = 0.01;
cfg_ground_friction_factor = 0.2;
cfg_bounce_factor = 0.3;
cfg_stop_on_ground = true;
cfg_fade_on_ground = true;
cfg_fade_duration_ground = 30;
cfg_solid_object = obj_Solid; // IMPORTANT: Ensure obj_Solid is a parent for your solid objects

// --- Visuals ---
// image_xscale, image_yscale, image_angle, image_alpha, sprite_index are set in activate

/// @function Activate(px, py, config)
/// @description Activates a fracture piece with given settings.
/// @param {real} px Initial x position (center of original object).
/// @param {real} py Initial y position.
/// @param {struct} config Instance of FracturePieceConfig.
function Activate(px, py, config) 
{
    is_active = true;
    visible = true;
    x = px;
    y = py;

    // Store config values
    cfg_original_sprite = config.originalSprite;
    cfg_original_image_index = config.originalImageIndex;
    cfg_use_original_sprite = config.useOriginalSpritePerPiece;
    cfg_chunk_sprite = config.chunkSprite;
    cfg_piece_lifetime = config.pieceLifetimeFrames;
    cfg_gravity = config.gravityAmount;
    cfg_air_friction = config.airFrictionAmount;
    cfg_ground_friction_factor = config.groundFrictionFactor;
    cfg_bounce_factor = config.bounceFactor;
    cfg_stop_on_ground = config.stopOnGround;
    cfg_fade_on_ground = config.fadeOnGround;
    cfg_fade_duration_ground = config.fadeDurationOnGround;
    cfg_solid_object = config.solidObject; // Get the solid object from config

    // Initialize piece-specific properties
    var _initial_speed = random_range(config.speedMin, config.speedMax);
    var _initial_dir = random(360); // Eject in a random direction
    h_speed = lengthdir_x(_initial_speed, _initial_dir);
    v_speed = lengthdir_y(_initial_speed, _initial_dir);
    
    current_angular_velocity = random_range(config.angularVelocityMin, config.angularVelocityMax);
    image_angle = random(360);
    
    var _scale = random_range(config.scaleMin, config.scaleMax);
    image_xscale = _scale;
    image_yscale = _scale;
    
    image_alpha = 1;
    is_on_ground = false;
    current_life = 0;
    fade_on_ground_timer = 0;

    if (cfg_use_original_sprite && sprite_exists(cfg_original_sprite)) 
    {
        sprite_index = cfg_original_sprite;
        image_index = cfg_original_image_index; // Or could be randomized if original sprite has many sub-images for debris
    } 
    else if (sprite_exists(cfg_chunk_sprite)) 
    {
        sprite_index = cfg_chunk_sprite;
        image_index = irandom(image_number -1); // Random sub-image if chunk sprite is animated
    } 
    else 
    {
        sprite_index = spr_default; // Fallback
        image_index = 0;
    }
    
    image_speed = 0; 
}

/// @function Deactivate()
/// @description Deactivates the fracture piece.
function Deactivate() 
{
    if (!is_active) return;
    is_active = false;
    visible = false;
    
    // Reset physics state
    h_speed = 0;
    v_speed = 0;
    current_angular_velocity = 0;
    is_on_ground = false;

    if (instance_exists(global.FeedbackManager)) 
    {
        global.FeedbackManager.ReturnInstanceToPool(id, pool_type);
    } 
    else 
    {
        instance_destroy(); // Fallback
    }
}