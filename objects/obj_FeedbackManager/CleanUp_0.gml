show_debug_message("FeedbackManager cleaning up...");

var i = 0;
for (i = 0; i < ds_list_size(poolParticlesAll); i++) 
{
    var inst = ds_list_find_value(poolParticlesAll, i);
    if (instance_exists(inst)) 
    {
        instance_destroy(inst);
    }
}
ds_list_destroy(poolParticlesAll);
ds_list_destroy(poolParticlesInactive);

for (i = 0; i < ds_list_size(poolGlyphsAll); i++) 
{
    var inst = ds_list_find_value(poolGlyphsAll, i);
    if (instance_exists(inst)) 
    {
        instance_destroy(inst);
    }
}
ds_list_destroy(poolGlyphsAll);
ds_list_destroy(poolGlyphsInactive);


for (i = 0; i < ds_list_size(poolFracturePiecesAll); i++) 
{
    var inst = ds_list_find_value(poolFracturePiecesAll, i);
    if (instance_exists(inst)) instance_destroy(inst);
}
ds_list_destroy(poolFracturePiecesAll);
ds_list_destroy(poolFracturePiecesInactive);

show_debug_message("FeedbackManager cleanup complete.");