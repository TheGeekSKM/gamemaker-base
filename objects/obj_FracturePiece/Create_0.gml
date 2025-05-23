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
cfg_solid_object = obj_Solid; 

// --- Sprite Part Info (for draw_sprite_part_ext) --- << NEW
source_x_on_sprite = 0;
source_y_on_sprite = 0;
src_chunk_width = 0;
src_chunk_height = 0;

// --- Visuals ---
// image_xscale, image_yscale, image_angle, image_alpha, image_blend, sprite_index are set in activate
image_blend = c_white; // Default blend to white


/// @function Activate(px, py, config, src_x_spr, src_y_spr, src_w, src_h)
/// @description Activates a fracture piece with given settings and sprite part info.
/// @param {real} px Initial x world position for this piece.
/// @param {real} py Initial y world position for this piece.
/// @param {struct} config Instance of FracturePieceConfig.
/// @param {real} src_x_spr Source X on the original sprite sheet for this chunk.
/// @param {real} src_y_spr Source Y on the original sprite sheet for this chunk.
/// @param {real} src_w Width of this chunk on the sprite sheet.
/// @param {real} src_h Height of this chunk on the sprite sheet.
function Activate(px, py, config, src_x_spr, src_y_spr, src_w, src_h) 
{
    is_active = true;
    visible = true;
    x = px;
    y = py;

    // Store config values
    cfg_original_sprite = config.originalSprite;
    cfg_original_image_index = config.originalImageIndex;
    cfg_use_original_sprite = config.useOriginalSpritePerPiece;
    cfg_chunk_sprite = config.chunkSprite; // Fallback sprite
    cfg_piece_lifetime = config.pieceLifetimeFrames;
    cfg_gravity = config.gravityAmount;
    cfg_air_friction = config.airFrictionAmount;
    cfg_ground_friction_factor = config.groundFrictionFactor;
    cfg_bounce_factor = config.bounceFactor;
    cfg_stop_on_ground = config.stopOnGround;
    cfg_fade_on_ground = config.fadeOnGround;
    cfg_fade_duration_ground = config.fadeDurationOnGround;
    cfg_solid_object = config.solidObject; 

    // Store sprite part info << NEW
    source_x_on_sprite = src_x_spr;
    source_y_on_sprite = src_y_spr;
    src_chunk_width = src_w;
    src_chunk_height = src_h;

    // Initialize piece-specific physics properties
    var _initial_speed = random_range(config.speedMin, config.speedMax);
    var _initial_dir = random(360); 
    h_speed = lengthdir_x(_initial_speed, _initial_dir);
    v_speed = lengthdir_y(_initial_speed, _initial_dir);
    
    current_angular_velocity = random_range(config.angularVelocityMin, config.angularVelocityMax);
    image_angle = random(360);
    
    // Scale can still be randomized for the piece itself
    var _scale = random_range(config.scaleMin, config.scaleMax);
    image_xscale = _scale;
    image_yscale = _scale;
    
    image_alpha = 1;
    image_blend = c_white; // Default to no tint
    is_on_ground = false;
    current_life = 0;
    fade_on_ground_timer = 0;

    
    // --- Assign Collision Mask Sprite ---
    if (sprite_exists(spr_ChunkMask)) 
    { 
        self.sprite_index = spr_ChunkMask;
    } 
    else 
    {
        self.sprite_index = -1; 
        show_debug_message("Warning: spr_ChunkMask not found for obj_FracturePiece.");
    }
    self.image_speed = 0; // The mask sprite should not animate
    self.image_index = 0; 
}

/// @function Deactivate()
/// @description Deactivates the fracture piece.
function Deactivate() 
{
    if (!is_active) return;
    is_active = false;
    visible = false;
    
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
        instance_destroy(); 
    }
}