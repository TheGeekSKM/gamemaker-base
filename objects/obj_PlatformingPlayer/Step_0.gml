#region Moving Platform Collision
var platformLastFrame = onPlatform; // Remember platform from last frame's collision check
onPlatform = noone; 
var currentPlatformHorizontalMomentum = 0; 

if (platformLastFrame != noone)
{
    // check if the platform still exists
    if (instance_exists(platformLastFrame))
    {
        // Assumes platform stores prevX/Y in Begin Step and moves in Step
        var deltaX = platformLastFrame.x - platformLastFrame.prevX;
        var deltaY = platformLastFrame.y - platformLastFrame.prevY;

        // Crunch Prevention
        var crushedH = false;
        var crushedV = false;

        // Check Horizontal Crush
        if (deltaX != 0 && place_meeting(x + deltaX * facing, y, obj_Solid) && !place_meeting(x + deltaX, y, obj_MovingPlatform))
        {
            deltaX = 0;
            crushedH = true;

            CrushedDamage();
        }

        // Check Vertical Crush
        // Check Upwards Crush
        if (deltaY < 0 && place_meeting(x, y + deltaY, obj_Solid) && !place_meeting(x, y + deltaY, obj_MovingPlatform))
        {
            deltaY = 0;
            crushedV = true;

            CrushedDamage();
        }

        // Check Downwards Crush
        if (deltaY > 0 && place_meeting(x, y + deltaY, obj_Solid) && !place_meeting(x, y + deltaY, obj_MovingPlatform))
        {
            deltaY = 0;
            crushedV = true;

            CrushedDamage();
        }

        // Apply the calculated delta to the player
        x += deltaX;
        y += deltaY;

        currentPlatformHorizontalMomentum = deltaX;
    }
    else
    {
        // Platform no longer exists, so set to noone
        platformLastFrame = noone;
    }
}
platformHorizontalMomentum = currentPlatformHorizontalMomentum;
#endregion

#region Timer Updates
coyoteTimer = max(0, coyoteTimer - 1);
jumpBufferTimer = max(0, jumpBufferTimer - 1);
dashBufferTimer = max(0, dashBufferTimer - 1);
dashTimer = max(0, dashTimer - 1);
dashCooldownTimer = max(0, dashCooldownTimer - 1);
waveDashTimer = max(0, waveDashTimer - 1);
attackPrimaryCooldown = max(0, attackPrimaryCooldown - 1);
attackSecondaryCooldown = max(0, attackSecondaryCooldown - 1);
#endregion

#region Assist Mode Options
var coyoteMax = coyoteTimeMax;
if (assistLongerCoyoteTime) coyoteMax *= 2;

var _jumpBufferMax = jumpBufferMax;
var _dashBufferMax = dashBufferMax;
if (assistLongerBufferTime)
{
    _jumpBufferMax *= 2;
    _dashBufferMax *= 2;
}
#endregion

#region Ground Check
var footLeft = bbox_left + 1;
var footRight = bbox_right
var footY = bbox_bottom + 1;

var wasGrounded = onGround;

if (onGround)
{
    coyoteTimer = coyoteMax; 
}
else
{
    if (wasGrounded && coyoteTimer == coyoteMax)
    {
        // Just left the ground, coyote timer starts naturally counting down.
    }
}
onGround = false;
#endregion

#region State Machine
switch (state)
{
    case PlayerState.Normal:
        // Normal state logic here
        PlayerStateNormal(coyoteMax, _jumpBufferMax, _dashBufferMax);
        break;
    case PlayerState.Dashing:
        // Dashing state logic here
        PlayerStateDashing();
        break;
    case PlayerState.Attacking:
        // Attacking state logic here
        break;
    default:
        // Default state logic here
        break;
}
#endregion

#region Apply Movement and Collision
ApplyMovementAndCollision(obj_Solid);
#endregion

image_xscale = facing;
if (hsp != 0 || vsp != 0 || !onGround)
{
    image_index = 0;
}
else {
    image_index = 1;
}

trail_update_timer--;

if (trail_update_timer <= 0) {
    trail_update_timer = trail_update_frequency;

    // Add current position to the start of the list
    // Storing as an array [x, y] within the list
    ds_list_insert(trail_points, 0, [x, y]);
    

    // Remove the oldest point if the list exceeds the maximum length
    while (ds_list_size(trail_points) > max_trail_length) {
        ds_list_delete(trail_points, ds_list_size(trail_points) - 1);
    }
}

