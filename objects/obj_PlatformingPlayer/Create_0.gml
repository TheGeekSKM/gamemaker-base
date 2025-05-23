/// INFO
/// Requires obj_Solid
enum PlayerState { Normal, Dashing, Attacking }


// Movement Settings
moveSpeed = 4;
acceleration = 0.5;
deceleration = 0.8;
gravityForce = 0.6;
gravityForceFall = 0.9;
jumpForce = -12;
maxFallSpeed = 10;

// State & Flags
state = PlayerState.Normal;
onGround = false;
facing = 1;
onPlatform = noone;             // id of the moving platform the player is on
platformHorizontalMomentum = 0;     // horizontal momentum from the platform

// Velocities
hsp = 0;
vsp = 0;

// Coyote Time
coyoteTimeMax = 6;
coyoteTimer = 0;

// Input Buffering
jumpBufferMax = 6;
jumpBufferTimer = 0;
dashBufferMax = 6;
dashBufferTimer = 0;

// Chain Jumps
maxJumps = 2;
jumpsRemaining = maxJumps;

// Dashing
dashSpeed = 10;
dashTimeMax = 8;
dashCooldownMax = 20;
dashTimer = 0;
dashCooldownTimer = 0;
dashDirX = 0;
dashDirY = 0;
canDash = true;
dashedInAir = false;
hyperSpeedBoost = 6;
waveDashWindow = 4;
waveDashTimer = 0;

dash_adds_momentum = false;

// Attacks
attackPrimaryCooldownMax = 15;
attackPrimaryCooldown = 0;
attackSecondaryCooldownMax = 30;
attackSecondaryCooldown = 0;

// Assist Mode Options
assistInfiniteJumps = false;
assistInfiniteDashes = false;
assistLongerCoyoteTime = false;
assistLongerBufferTime = false;

// Trail Settings
trail_points = ds_list_create();
max_trail_length = 20;          // How many points define the trail's length (adjust)
trail_width = 2;                // Width of the trail ribbon in pixels (adjust)
trail_update_frequency = 1;
trail_update_timer = 0;

// Trail appearance
trail_start_color = c_white;    // Color at the player's current position
trail_end_color = c_white;      // Color at the oldest end of the trail (can be same as start)
trail_start_alpha = 0.8;        // Alpha at the player's current position (0 to 1)
trail_end_alpha = 0.0;          // Alpha at the oldest end of the trail (usually 0)


// Trail Settings (Duplicate? Keeping both for now based on input)
trailCooldown = 0;


// Placeholder/Helper Functions defined in Create Event
// Note: It's generally better practice to define these as script functions or methods
// outside the Create Event for better organization and potential reuse.
function CrushedDamage() {}

function PlayerStateNormal(coyoteMax, _jumpBufferMax, _dashBufferMax)
{
    // Gather Input
    var moveInput = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
    var jumpPressed = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
    var jumpHeld = keyboard_check(vk_space) || keyboard_check(ord("W"));
    var dashPressed = keyboard_check_pressed(ord("J")) || keyboard_check_pressed(vk_shift);
    var attackPrimaryPressed = keyboard_check_pressed(ord("K"));
    var attackSecondaryPressed = false;

    // Input Buffering
    if (jumpPressed) jumpBufferTimer = _jumpBufferMax;
    if (dashPressed) dashBufferTimer = _dashBufferMax;

    // Horizontal Movement
    if (moveInput != 0)
    {
        facing = moveInput;
        hsp += moveInput * acceleration;
        hsp = clamp(hsp, -moveSpeed, moveSpeed);

        // image_index = 0; // Setting image_index directly can interfere with animations
    }
    else
    {
        hsp = lerp(hsp, 0, deceleration);
        if (abs(hsp) < 0.1) hsp = 0;

        // image_index = 1; // Setting image_index directly can interfere with animations
    }

    // Vertical Movement
    // Note: 'onGround' used here refers to the state from the *end* of the previous frame.
    // Collision code later this frame determines the definitive state.
    var isAirborne = !onGround; // Simplified check based on last frame's state for gravity application
    if (isAirborne)
    {
        if (vsp < 0) vsp += gravityForce; // Ascending
        else vsp += gravityForceFall; // Descending

        vsp = min(vsp, maxFallSpeed);
    }

    // Jumping
    var touchingGroundNow = collision_rectangle(bbox_left+1, bbox_bottom+1, bbox_right-1, bbox_bottom+1, obj_Solid, false, true);
    var canInitiateGroundJump = touchingGroundNow || coyoteTimer > 0;
    var hasAirJumps = jumpsRemaining > (assistInfiniteJumps ? 0 : 1);

    if (jumpBufferTimer > 0)
    {
        var jumped = false;
        if (canInitiateGroundJump)
        {
            vsp = jumpForce;
            jumpsRemaining = maxJumps - 1;
            coyoteTimer = 0;
            jumpBufferTimer = 0;
            jumped = true;
        }
        else if (hasAirJumps)
        {
            vsp = jumpForce;
            jumpsRemaining--;
            jumpBufferTimer = 0;
            jumped = true;
        }

        if (jumped)
        {
            hsp += platformHorizontalMomentum;
            onPlatform = noone;
        }
    }

    // Variable Jump Height
    if (vsp < 0 && !jumpHeld)
    {
        vsp = max(vsp, jumpForce * 0.5);
    }

    // Dashing
    var canDashNow = (dashCooldownTimer <= 0 || assistInfiniteDashes);
    if (dashBufferTimer > 0 && canDashNow)
    {
        StartDash(); // Call the function defined below
        dashBufferTimer = 0;
    }

    // Attacking
    if (attackPrimaryPressed && attackPrimaryCooldown <= 0)
    {
        var attackSuccess = AttackPrimary();
        if (attackSuccess) 
        {
            attackPrimaryCooldown = attackPrimaryCooldownMax;
            vsp = jumpForce; 
        } 
        else 
        {
            attackPrimaryCooldown = 5;
        }
        attackPrimaryCooldown = attackPrimaryCooldownMax;
    }
    if (attackSecondaryPressed && attackSecondaryCooldown <= 0)
    {
        AttackSecondary(); // Call the function defined below
        attackSecondaryCooldown = attackSecondaryCooldownMax;
    }

}

function PlayerStateDashing()
{
    // If dash adds momentum, the movement is handled by the normal physics + initial boost
    // If dash replaces momentum, we need to set hsp/vsp directly here
    if (!dash_adds_momentum) {
        hsp = dashDirX * dashSpeed;
        vsp = dashDirY * dashSpeed;
    }
    // Note: If dash_adds_momentum is true, this state might need more refinement
    // depending on desired behavior (e.g., apply friction during dash?)
    // For now, it relies on the initial boost from StartDash and normal physics.

    onPlatform = noone; // Ensure not attached to platform during dash

    if (dashTimer <= 0)
    {
        state = PlayerState.Normal;
        var _postDashGroundCheck = collision_rectangle(bbox_left+1, bbox_bottom+1, bbox_right-1, bbox_bottom+1, obj_Solid, false, true);
        var _postDashPlatformInst = instance_place(x, y + 1, obj_MovingPlatform);

        // Apply post-dash speed reduction only if dash *replaced* momentum
        if (!dash_adds_momentum) {
            hsp *= 0.5;
            vsp *= 0.3;
        } // Else, let normal deceleration handle the speed after the boost

        if (dashDirY > 0.5 && dashDirX != 0 && _postDashGroundCheck) {
            // Hyper Dash boost applies regardless of dash type
            hsp = sign(dashDirX) * (moveSpeed + hyperSpeedBoost);
        }
        if (dashDirY >= 0 && _postDashGroundCheck && !dashedInAir) {
            waveDashTimer = waveDashWindow;
        }

        if (_postDashGroundCheck)
        {
            onGround = true;
            vsp = 0; // Stop vertical speed on landing
            jumpsRemaining = maxJumps;
            dashedInAir = false;

            if (instance_exists(_postDashPlatformInst)) // Check instance_exists for safety
            {
                onPlatform = _postDashPlatformInst;
                y = _postDashPlatformInst.bbox_top - (bbox_bottom - y);
            }
            else
            {
                onPlatform = noone;
            }
        }
        else
        {
            onGround = false;
            onPlatform = noone;
        }
    }
}

// --- Start Dash --- <<<< MODIFIED FUNCTION >>>>
function StartDash()
{
    state = PlayerState.Dashing;
    dashTimer = dashTimeMax;

    if (!assistInfiniteDashes) {
        dashCooldownTimer = dashCooldownMax;
    }
    // Check ground state accurately at the moment dash starts
    var _am_i_grounded = collision_rectangle(bbox_left+1, bbox_bottom+1, bbox_right-1, bbox_bottom+1, obj_Solid, false, true);
    dashedInAir = !_am_i_grounded; // Set dashedInAir based on current ground state

    // Determine dash direction
    var inputH = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
    var inputV = (keyboard_check(vk_down) || keyboard_check(ord("S"))) - (keyboard_check(vk_up) || keyboard_check(ord("W")));
    if (inputH == 0 && inputV == 0)
    {
        dashDirX = facing;
        dashDirY = 0;
    }
    else
    {
        var len = point_distance(0, 0, inputH, inputV);
        if (len > 0)
        {
            dashDirX = inputH / len;
            dashDirY = inputV / len;
        }
        else
        {
            dashDirX = facing;
            dashDirY = 0;
        }
    }

    // Additive vs Replace Momentum Logic
    if (dash_adds_momentum) {
        // Add dash velocity to current velocity
        hsp += dashDirX * dashSpeed;
        vsp += dashDirY * dashSpeed;
        // Optional: Clamp total speed?
        // var current_speed = point_distance(0,0,hsp,vsp);
        // var max_speed = moveSpeed + dashSpeed; // Example max clamp
        // if (current_speed > max_speed) {
        //     var ratio = max_speed / current_speed;
        //     hsp *= ratio;
        //     vsp *= ratio;
        // }
    } else {
        // Replace current velocity (original behavior)
        hsp = 0;
        vsp = 0;
        // The PlayerStateDashing function will set the hsp/vsp directly in this case
    }

    onPlatform = noone; // Detach from platform
    // image_index = 0; // Setting image_index directly can interfere with animations
}


function ApplyMovementAndCollision(_solidObject)
{
    // Horizontal Collision
    if (place_meeting(x + hsp, y, _solidObject))
    {
        var moveDirH = sign(hsp);
        while (!place_meeting(x + moveDirH, y, _solidObject))
        {
            x += moveDirH;
        }
        hsp = 0;
    }
    x += hsp;

    // Vertical Collision
    // Reset definitive ground/platform state before checking
    onGround = false;
    onPlatform = noone;
    var landedThisFrame = false;

    // Check for collision at the intended vertical position
    if (place_meeting(x, y + vsp, _solidObject))
    {
        var moveDirV = sign(vsp);

        // Only perform pixel-by-pixel movement and snapping if moving downwards or perfectly still
        if (moveDirV >= 0)
        {
            var instCollidedV = instance_place(x, y + vsp, _solidObject);

            // Move pixel by pixel downwards until collision
            while (!place_meeting(x, y + moveDirV, _solidObject)) {
                y += moveDirV;
            }

            // --- Landing Logic ---
            if (instCollidedV != noone) {
                landedThisFrame = true;
                onGround = true; // Set definitive ground state for end of frame

                var instBelowFinal = instance_place(x, y + 1, _solidObject);
                if (instance_exists(instBelowFinal)) // Check instance exists before accessing properties
                {
                    y = instBelowFinal.bbox_top - (bbox_bottom - y); // Adjust y based on origin

                    if (object_get_parent(instBelowFinal.object_index) == obj_MovingPlatform || instBelowFinal.object_index == obj_MovingPlatform) {
                        onPlatform = instBelowFinal; // Store platform ID
                    }
                }

                jumpsRemaining = maxJumps;
                dashedInAir = false;
            }
        }
        // --- End of Downwards Collision ---

        // Regardless of direction, stop vertical speed upon collision
        vsp = 0;

    } // End if place_meeting vertical

    // Apply final vertical movement
    y += vsp;

    // If we didn't land this frame, ensure flags are false
    if (!landedThisFrame) {
        onGround = false;
        onPlatform = noone;
    }

    // Wave Dash Execution
    if (waveDashTimer > 0 && jumpBufferTimer > 0 && onGround)
    {
        vsp = jumpForce;
        hsp = sign(hsp) * (moveSpeed + hyperSpeedBoost * 0.8);
        waveDashTimer = 0;
        jumpBufferTimer = 0;
        onGround = false;
        coyoteTimer = 0;
        jumpsRemaining = maxJumps - 1;
        onPlatform = noone;
    }
}



function AttackPrimary()
{
    show_debug_message("Player used Primary Attack!");
}
function AttackSecondary()
{
    show_debug_message("Player used Secondary Attack!");
}


