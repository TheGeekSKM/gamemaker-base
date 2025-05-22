if (!is_active) 
{
    return;
}

timer++;
if (timer >= duration) 
{ 
    // duration is set in Activate() from cfg_internal.durationFrames
    Deactivate();
    return;
}

progress = timer / duration; 
var eased_progress = progress; 

if (cfg_internal.fadeStyle == FadeStyle.EASE_OUT_QUAD) 
{
    eased_progress = 1 - power(1 - progress, 2); 
} 
else if (cfg_internal.fadeStyle == FadeStyle.EASE_IN_OUT_QUAD) 
{
    eased_progress = progress < 0.5 ? 2 * progress * progress : 1 - power(-2 * progress + 2, 2) / 2;
}

current_text_alpha = lerp(cfg_internal.textAlphaStart, cfg_internal.textAlphaEnd, eased_progress);
current_text_scale = lerp(cfg_internal.textScaleStart, cfg_internal.textScaleEnd, eased_progress);

current_sprite_alpha = lerp(cfg_internal.spriteAlphaStart, cfg_internal.spriteAlphaEnd, eased_progress);
current_sprite_scale = lerp(cfg_internal.spriteScaleStart, cfg_internal.spriteScaleEnd, eased_progress);
current_sprite_angle = lerp(cfg_internal.spriteAngleStart, cfg_internal.spriteAngleEnd, eased_progress);

switch (cfg_internal.movementStyle) 
{
    case MovementStyle.FLOAT_UP:
        current_offset_y = lerp(0, cfg_internal.targetYOffset, eased_progress);
        break;
    
    case MovementStyle.ARC_UP:
        var arc_bump = sin(progress * pi) * (cfg_internal.targetYOffset * cfg_internal.arcHeightFactor);
        current_offset_y = lerp(0, cfg_internal.targetYOffset, eased_progress) + arc_bump;
        break;
    
    case MovementStyle.OVERSHOOT_SCALE: 
        var overshoot_progress = sin(progress * pi); 
        var base_scale_text = lerp(cfg_internal.textScaleStart, cfg_internal.textScaleEnd, eased_progress);
        current_text_scale = base_scale_text + overshoot_progress * 0.5; 

        var base_scale_sprite = lerp(cfg_internal.spriteScaleStart, cfg_internal.spriteScaleEnd, eased_progress);
        current_sprite_scale = base_scale_sprite + overshoot_progress * 0.5;
        break;
    
    default:
        current_offset_y = 0;
        break;
}

x = base_x;
y = base_y + current_offset_y;

if (sprite_exists(cfg_internal.spriteIndex) && cfg_internal.spriteImageSpeed > 0) 
{
    image_index += cfg_internal.spriteImageSpeed;
    if (image_index >= sprite_get_number(cfg_internal.spriteIndex)) 
    {
        image_index = 0; 
    }
}