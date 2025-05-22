global.FeedbackManager = id;

// --- Particle Pool ---
poolParticlesInactive = ds_list_create();
poolParticlesAll = ds_list_create(); 
maxParticles = 200; 

if (!layer_exists("Feedback"))
{
    layer_create(-50, "Feedback");   
}

for (var i = 0; i < maxParticles; i++) {
    var inst = instance_create_layer(0, 0, "Instances", obj_PooledParticle); 
    ds_list_add(poolParticlesAll, inst);
    ds_list_add(poolParticlesInactive, inst);
    instance_deactivate_object(inst); 
}

// --- Glyph Pool ---
poolGlyphsInactive = ds_list_create();
poolGlyphsAll = ds_list_create(); 
maxGlyphs = 50; 

for (var i = 0; i < maxGlyphs; i++) {
    var inst = instance_create_layer(0, 0, "Instances", obj_PooledGlyph); 
    ds_list_add(poolGlyphsAll, inst);
    ds_list_add(poolGlyphsInactive, inst);
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
            inst = instance_create_layer(xPos, yPos, "Instances", obj_PooledParticle);
            ds_list_add(poolParticlesAll, inst); 
            
            show_debug_message("Particle pool empty, created new particle.");
        }

        if (inst.object_index == obj_PooledParticle) 
        { 
            instance_activate_object(inst); 
            inst.Activate(xPos, yPos, config);
        } 
        else if (inst != undefined) 
        {
            show_debug_message("Error: Pooled instance is not obj_PooledParticle. ID: " + string(inst));
            if (instance_exists(inst)) instance_destroy(inst);
        }
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
        inst = instance_create_layer(xPos, yPos, "Instances", obj_PooledGlyph);
        ds_list_add(poolGlyphsAll, inst); 
        show_debug_message("Glyph pool empty, created new glyph.");
    }

    if (inst.object_index == obj_PooledGlyph) 
    {
        instance_activate_object(inst);
        inst.activate(xPos, yPos, config);
    } 
    else if (inst != undefined) 
    {
        show_debug_message("Error: Pooled instance is not obj_PooledGlyph. ID: " + string(inst));
        if (instance_exists(inst)) instance_destroy(inst);
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
        
        default:
            show_debug_message("Warning: Unknown pool type for instance " + string(instanceID));
            break;
    }
}
