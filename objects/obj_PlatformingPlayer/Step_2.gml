var speedThreshold = 4;

if (abs(hsp) + abs(vsp) > speedThreshold)
{
    // spawn every N frames for performance
    trailCooldown--;
    if (trailCooldown <= 0)
    {
        trailCooldown = 1;
        var t = instance_create_depth(x, y, depth + 1, obj_TrailSegment);
        
        t.xPrev = x - hsp;
        t.yPrev = y - vsp;
    }
}
else {
    trailCooldown = 0;
}