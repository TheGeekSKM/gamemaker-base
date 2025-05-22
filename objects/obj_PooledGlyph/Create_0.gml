is_active = false;
visible = false;
persistent = true;

timer = 0;
duration = 60; 
progress = 0; 

base_x = 0;
base_y = 0;

current_text_alpha = 1;
current_text_scale = 1;
current_sprite_alpha = 1;
current_sprite_scale = 1;
current_sprite_angle = 0;
current_offset_y = 0; 

// Internal cfg struct to store active configuration values.
// This will be populated from the GlyphConfig instance passed to Activate().
// I...uh...was experimenting with a way to have "private" variables...

cfg_internal = {
    text: "",
    textColor: c_white,
    textFont: "VCR_OSD_Mono", 
    textScaleStart: 1,
    textScaleEnd: 1,
    textAlphaStart: 1,
    textAlphaEnd: 0,
    
    spriteIndex: -1,
    spriteImageSpeed: 0,
    spriteScaleStart: 1,
    spriteScaleEnd: 1,
    spriteAngleStart: 0,
    spriteAngleEnd: 0,
    spriteAlphaStart: 1,
    spriteAlphaEnd: 0,
    
    movementStyle: MovementStyle.FLOAT_UP, 
    targetYOffset: -50, 
    arcHeightFactor: 0.5, 
    
    durationFrames: 90,
    fadeStyle: FadeStyle.LINEAR, 
    
    scribble_element: scribble(), 
    sdfOutlineColor: c_black,
    sdfOutlineWidth: 0 
};

pool_type = InstanceType.GLYPH;



function Activate(x_pos, y_pos, config_struct) {
    is_active = true;
    visible = true;
    
    x = x_pos; 
    y = y_pos;
    base_x = x_pos;
    base_y = y_pos;
    
    timer = 0;
    progress = 0;
    
    // Copy values from the passed GlyphConfig instance to the internal cfg_internal struct
    cfg_internal.text = config_struct.text;
    cfg_internal.textColor = config_struct.textColor;
    cfg_internal.textFont = config_struct.textFont;
    cfg_internal.textScaleStart = config_struct.textScaleStart;
    cfg_internal.textScaleEnd = config_struct.textScaleEnd;
    cfg_internal.textAlphaStart = config_struct.textAlphaStart;
    cfg_internal.textAlphaEnd = config_struct.textAlphaEnd;

    cfg_internal.spriteIndex = config_struct.spriteIndex;
    cfg_internal.spriteImageSpeed = config_struct.spriteImageSpeed;
    cfg_internal.spriteScaleStart = config_struct.spriteScaleStart;
    cfg_internal.spriteScaleEnd = config_struct.spriteScaleEnd;
    cfg_internal.spriteAngleStart = config_struct.spriteAngleStart;
    cfg_internal.spriteAngleEnd = config_struct.spriteAngleEnd;
    cfg_internal.spriteAlphaStart = config_struct.spriteAlphaStart;
    cfg_internal.spriteAlphaEnd = config_struct.spriteAlphaEnd;

    cfg_internal.movementStyle = config_struct.movementStyle;
    cfg_internal.targetYOffset = config_struct.targetYOffset;
    cfg_internal.arcHeightFactor = config_struct.arcHeightFactor;
    
    cfg_internal.durationFrames = config_struct.durationFrames;
    duration = cfg_internal.durationFrames; 
    
    cfg_internal.fadeStyle = config_struct.fadeStyle; 
    
    cfg_internal.sdfOutlineColor = config_struct.sdfOutlineColor;
    cfg_internal.sdfOutlineWidth = config_struct.sdfOutlineWidth;

    current_text_alpha = cfg_internal.textAlphaStart;
    current_text_scale = cfg_internal.textScaleStart;
    current_sprite_alpha = cfg_internal.spriteAlphaStart;
    current_sprite_scale = cfg_internal.spriteScaleStart;
    current_sprite_angle = cfg_internal.spriteAngleStart;
    current_offset_y = 0;
    
    if (sprite_exists(cfg_internal.spriteIndex)) {
        sprite_index = cfg_internal.spriteIndex;
        image_index = 0;
        image_speed = cfg_internal.spriteImageSpeed;
    } else {
        sprite_index = -1; 
    }
    
    cfg_internal.scribble_element = scribble(cfg_internal.text)
        .starting_format(cfg_internal.textFont, cfg_internal.textColor) 
        .align(fa_center, fa_middle); 
}

function Deactivate() 
{
    if (!is_active) return;

    is_active = false;
    visible = false;
    
    current_offset_y = 0;
    x = base_x; 
    y = base_y;

    if (instance_exists(global.FeedbackManager)) 
    {
        global.FeedbackManager.ReturnInstanceToPool(id, pool_type);
    } 
    else 
    {
        instance_destroy();
    }
}