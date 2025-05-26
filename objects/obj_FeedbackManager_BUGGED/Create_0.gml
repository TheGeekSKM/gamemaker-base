global.FeedbackManager = id;
persistent = true;

// --- Particle Pool ---
poolParticlesInactive = ds_list_create();
poolParticlesAll = ds_list_create(); 
maxParticles = 200; 

if (!layer_exists("Feedback"))
{
    layer_create(-50, "Feedback");
}

for (var i = 0; i < maxParticles; i++) {
    if (!layer_exists("Instances")) layer_create(-50, "Instances");
    
    var inst = instance_create_depth(0, 0, -5, obj_PooledParticle); 
    ds_list_add(poolParticlesAll, inst);
    ds_list_add(poolParticlesInactive, inst);
    instance_deactivate_object(inst); 
}

// --- Glyph Pool ---
poolGlyphsInactive = ds_list_create();
poolGlyphsAll = ds_list_create(); 
maxGlyphs = 50; 

for (var i = 0; i < maxGlyphs; i++) {
    if (!layer_exists("Instances")) layer_create(-50, "Instances");    
    
    var inst = instance_create_depth(0, 0, -5, obj_PooledGlyph); 
    ds_list_add(poolGlyphsAll, inst);
    ds_list_add(poolGlyphsInactive, inst);
    instance_deactivate_object(inst);
}

// --- Fracture Pool ---
poolFracturePiecesInactive = ds_list_create();
poolFracturePiecesAll = ds_list_create();
maxFracturePieces = 100; // Adjust as needed

for (var i = 0; i < maxFracturePieces; i++) {
    
    var inst = instance_create_depth(0, 0, -5, obj_FracturePiece); // Ensure obj_FracturePiece exists
    ds_list_add(poolFracturePiecesAll, inst);
    ds_list_add(poolFracturePiecesInactive, inst);
    instance_deactivate_object(inst);
}

show_debug_message("FeedbackManager initialized with pools.");






/// ----------- FUNCTIONS -----------

/// @function				SpawnParticleBurst(xPos, yPos, count, configStruct)
/// @description			Spawns a burst of particles.
/// @param {real} xPos		X position to spawn at.
/// @param {real} yPos		Y position to spawn at.
/// @param {real} count		Number of particles to spawn.
/// @param {struct} config Configuration for the particles (instance of ParticleConfig).
function SpawnParticleBurst(xPos, yPos, count, config) 
{
    var numToSpawn = count;
    for (var i = 0; i < numToSpawn; i++) 
    {
        var inst = undefined;
        
        if (ds_list_size(poolParticlesInactive) > 0) 
        {
            inst = ds_list_find_value(poolParticlesInactive, 0);
            ds_list_delete(poolParticlesInactive, 0);
        } 
        else 
        {
            inst = instance_create_depth(xPos, yPos, -5, obj_PooledParticle);
            ds_list_add(poolParticlesAll, inst); 
            
            show_debug_message("Particle pool empty, created new particle.");
        }

        instance_activate_object(inst); 
        inst.Activate(xPos, yPos, config);
        
    }
}


/// @function				SpawnGlyph(xPos, yPos, config_struct)
/// @description			Spawns an animated glyph (text and/or sprite).
/// @param {real} xPos		X position to spawn at.
/// @param {real} yPos		Y position to spawn at.
/// @param {struct} config Configuration for the glyph (instance of GlyphConfig).
function SpawnGlyph(xPos, yPos, config) 
{
    var inst = undefined;
    if (ds_list_size(poolGlyphsInactive) > 0) 
    {
        inst = ds_list_find_value(poolGlyphsInactive, 0);
        ds_list_delete(poolGlyphsInactive, 0);
    } 
    else 
    {
        inst = instance_create_depth(xPos, yPos, -5, obj_PooledGlyph);
        ds_list_add(poolGlyphsAll, inst); 
        show_debug_message("Glyph pool empty, created new glyph.");
    }

    instance_activate_object(inst);
    inst.Activate(xPos, yPos, config);
    
}


/// @function           SpawnFractureEffect(xPos, yPos, config)
/// @description        Spawns a fracture effect, creating multiple pieces.
/// @param {real} xPos    X position of the original object.
/// @param {real} yPos    Y position of the original object.
/// @param {struct} config Configuration for the fracture (instance of FracturePieceConfig).
function SpawnFractureEffect(xPos, yPos, config) {
    if (!sprite_exists(config.originalSprite)) 
    {
        show_debug_message("Fracture Error: Original sprite " + string(config.originalSprite) + " does not exist in config.");
        return;
    }

    var _sprite_to_fracture = config.originalSprite;
    var _image_index_to_fracture = config.originalImageIndex;
    
    var spr_w = sprite_get_width(_sprite_to_fracture);
    var spr_h = sprite_get_height(_sprite_to_fracture);
    var _chunk_size = config.chunkSize ?? 8; // Default to 8 if not set in config

    // Calculate the visual top-left of the original sprite in the room
    var visual_origin_x = xPos - sprite_get_xoffset(_sprite_to_fracture);
    var visual_origin_y = yPos - sprite_get_yoffset(_sprite_to_fracture);

    for (var src_x = 0; src_x < spr_w; src_x += _chunk_size) {
        for (var src_y = 0; src_y < spr_h; src_y += _chunk_size) {
            
            var current_chunk_w = min(_chunk_size, spr_w - src_x);
            var current_chunk_h = min(_chunk_size, spr_h - src_y);

            if (current_chunk_w <= 0 || current_chunk_h <= 0) continue; 

            var inst = undefined;
            if (ds_list_size(poolFracturePiecesInactive) > 0) 
            {
                inst = ds_list_find_value(poolFracturePiecesInactive, 0);
                ds_list_delete(poolFracturePiecesInactive, 0);
            } 
            else 
            {
                inst = instance_create_depth(xPos, yPos, 0, obj_FracturePiece); 
                ds_list_add(poolFracturePiecesAll, inst);
                show_debug_message("Fracture piece pool empty, created new piece.");
            }
            
            instance_activate_object(inst); 
            
            // Calculate the center of the chunk relative to the visual origin
            var piece_start_x = visual_origin_x + src_x + (current_chunk_w / 2);
            var piece_start_y = visual_origin_y + src_y + (current_chunk_h / 2);
            
            // Activate the piece, passing chunk info
            inst.Activate(
                piece_start_x, 
                piece_start_y, 
                config,              // Pass the whole config struct
                src_x,               // Source X on sprite sheet
                src_y,               // Source Y on sprite sheet
                current_chunk_w,     // Width of this chunk
                current_chunk_h      // Height of this chunk
            );
        }
    }
}

function SpawnParticleExplosionEffect(_xPos, _yPos, _owner_object)
{
    var ww = sprite_get_width(_owner_object.sprite_index);  
    var hh = sprite_get_height(_owner_object.sprite_index); 
    
    
    // var chunk_size = irandom_range(2, 6); // For variable sized chunks each time
    var chunk_size = 4; 
    
    var original_sprite = _owner_object.sprite_index;      
    var original_image_index = _owner_object.image_index;  
    
    
    var sprite_origin_x = _xPos - sprite_get_xoffset(_owner_object.sprite_index);
    var sprite_origin_y = _yPos - sprite_get_yoffset(_owner_object.sprite_index);
    
    var _particle_layer = "Instances"; // Default layer
    if (layer_exists("Instances_Effects")) 
    {
        _particle_layer = "Instances_Effects";
    } 
    else if (!layer_exists(_particle_layer)) 
    {
        layer_create(-100, _particle_layer); 
    }
    
    show_debug_message("Exploding " + 
        object_get_name(_owner_object.object_index) + 
        " into " + 
        string(ceil(ww/chunk_size) * 
        ceil(hh/chunk_size)) + 
        " particles."
    );
    
    // Loop through the sprite by chunk_size
    for (var i = 0; i < ww; i += chunk_size) 
    {        
        // Loop horizontally
        for (var j = 0; j < hh; j += chunk_size) 
        {    
            var particle = instance_create_layer(sprite_origin_x + i, sprite_origin_y + j, _particle_layer, obj_ExplosionParticle);
            
            particle.spr = original_sprite;          
            particle.img_idx = original_image_index; 
            particle.size = chunk_size;              
            particle.xx = i;                         
            particle.yy = j;                         
        }
    }
}


// --- Methods for Returning Instances to Pool ---

/// @function				ReturnInstanceToPool(instance_id, pool_type)
/// @description			Returns an instance to its respective pool. Called by the instance itself.
/// @param {Id.Instance} instanceID ID of the instance to return.
/// @param {string} type "particle" or "glyph".
function ReturnInstanceToPool(instanceID, type) 
{
    if (!instance_exists(instanceID)) 
    {
        show_debug_message("Warning: Attempted to return a non-existent instance to pool. ID: " + string(instanceID));
        return;
    }
    instance_deactivate_object(instanceID);

    switch (type) 
    {
        case InstanceType.PARTICLE:
            ds_list_add(poolParticlesInactive, instanceID);
            break;
        
        case InstanceType.GLYPH:
            ds_list_add(poolGlyphsInactive, instanceID);
            break;
        
        case InstanceType.FRACTURE_PIECE:
            ds_list_add(poolFracturePiecesInactive, instanceID);
            break;
        
        default:
            show_debug_message("Warning: Unknown pool type for instance " + string(instanceID));
            break;
    }
}
