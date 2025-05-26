while (array_length(loadStack) > 0)
{
    loadTimeCounter++;
    var top = array_last(loadStack);
    if (top.Process(id)) array_pop(loadStack);
}

if (loadTimeCounter < (MinimumLoadTime * game_get_speed(gamespeed_fps)))
{
    loadTimeCounter++;
}
else 
{
    instance_destroy();
}