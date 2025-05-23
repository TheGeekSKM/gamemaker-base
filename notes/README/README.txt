# Basic Documentation

This is essentially how you'd use the System.

**NOTE:* Make sure you place the obj_FeedbackManager in the first Room of the Game!!!*

Also make sure that the **FONTS** and **SPRITES** that you are referencing via name DO EXIST! I have made this mistake before and because of this mistake, my wife left me, my kids hate me, I am homeless and am being hunted by the Lizard People...don't make the same mistake that I did...


```gml
// --- Particle Example ---

var particle_cfg_damage = new ParticleConfig()
    .SetSprite(spr_blood_particle, 0.5) // sprite index, image speed
    .SetColors(c_red, merge_color(c_red, c_black, 0.7))
    .SetAlphas(0.9, 0)
    .SetSizes(1.5, 0.3)
    .SetSpeeds(3, 6)
    .SetDirections(image_angle - 45, image_angle + 45)
    .SetPhysics(0.2, 0.05, 5) // gravity, friction, rotation speed
    .SetLifeTime(45)
    .SetBlendMode(bm_add);

global.FeedbackManager.SpawnParticleBurst(x, y, irandom_range(5, 10), particle_cfg_damage);


// --- Glyph Example ---

var glyph_cfg_damage_num = new GlyphConfig()
    .SetTextDetails("-" + string(25), "DefaultFont", c_red) // text, font, color
    .SetTextScale(1.5, 1.0)
    .SetTextAlpha(1,0)
    .SetMovement(MovementStyle.ARC_UP, -60, 0.3) // style, y_offset, arc_factor
    .SetDuration(70)
    .SetFadeStyle(FadeStyle.EASE_OUT_QUAD)
    .SetSDFOutline(c_white, 1);

global.FeedbackManager.SpawnGlyph(x, y - 20, glyph_cfg_damage_num);

// Another Glyph Example with a sprite

var glyph_cfg_coin = new GlyphConfig()
    .SetTextDetails("+10", "DefaultFont", c_yellow)
    .SetSpriteDetails(spr_coin_icon, 0.1) // sprite_index, image_speed
    .SetSpriteScale(0.8, 1.0)
    .SetMovement(MovementStyle.FLOAT_UP, -40)
    .SetDuration(60);

global.FeedbackManager.SpawnGlyph(x,y, glyph_cfg_coin);


// --- Fracture Effect Example (when an object 'obj_Target' is hit) ---
// In obj_Target's Destroy event or when it takes lethal damage:

var my_fracture_config = new FracturePieceConfig()
     .SetOriginalObjectVisuals(sprite_index, image_index) 
     .SetPieceAppearance(true, spr_chunk, 0.3, 0.7) 
     .SetPieceCount(8, 15)                          
     .SetPieceLifetime(150)                         
     .SetPiecePhysics(0.25, 0.01, 0.3, 0.25)        
     .SetPieceInitialSpeed(2, 6)                    
     .SetPieceRotationSpeed(-10, 10)                
     .SetGroundBehavior(true, true, 45)             
     .SetSolidObject(obj_Solid);                    

if (instance_exists(global.FeedbackManager)) 
{
    global.FeedbackManager.spawn_fracture_effect(x, y, my_fracture_config);
}
instance_destroy(); // Destroy the original obj_Target

```