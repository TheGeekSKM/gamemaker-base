if (global.vars.pause) return;

var cX = camera_get_view_x(view_camera[CameraIndex]);
var cY = camera_get_view_y(view_camera[CameraIndex]);

switch (currentState)
{
    case CameraMode.FollowObject:
        if (!instance_exists(FollowingObject)) break; 
        cX = FollowingObject.x - (CamWidth / 2);
        cY = FollowingObject.y - (CamHeight / 2);
    break;
    
    case CameraMode.FollowMouseDrag: 
        var currentMousePos = new Vector2(display_mouse_get_x(), display_mouse_get_y());
        
        if (mouse_check_button(mb_left))
        {
            cX += (mousePrevious.x - currentMousePos.x) * 0.5;
            cY += (mousePrevious.y - currentMousePos.y) * 0.5;
        }
        
        mousePrevious.Set(currentMousePos.x, currentMousePos.y);
    break;
    
    case CameraMode.FollowMouseBorder: 
        if (!point_in_rectangle(mouse_x, mouse_y, 
            cX + (CamWidth * 0.1), cY + (CamHeight * 0.1), 
            cX + (CamWidth * 0.9), cY + (CamHeight * 0.9)))
        {
            cX = lerp(cX, mouse_x - (CamWidth / 2), 0.05);
            cY = lerp(cY, mouse_y - (CamHeight / 2), 0.05);
        }
    break;
    
    case CameraMode.FollowMousePeek:
        if (!instance_exists(FollowingObject)) break;  
        cX = lerp(FollowingObject.x, mouse_x, 0.15) - (CamWidth / 2);
        cY = lerp(FollowingObject.y, mouse_y, 0.15) - (CamHeight / 2);
    break;
    
    case CameraMode.MoveToTarget: 
        echo(target)
        cX = lerp(cX, target.x - (CamWidth / 2), 0.1);
        cY = lerp(cY, target.y - (CamHeight / 2), 0.1);
    break;
    
    case CameraMode.MoveToFollowTarget: 
        if (!instance_exists(FollowingObject)) break; 
        cX = lerp(cX, FollowingObject.x - (CamWidth / 2), 0.1);
        cY = lerp(cY, FollowingObject.y - (CamHeight / 2), 0.1);
        
        if (point_distance(cX, cY, FollowingObject.x - (CamWidth / 2), FollowingObject.y - (CamHeight / 2)) < 1)
        {
            currentState = CameraMode.FollowMousePeek;
        }
    
    break;
}

if (shakeStrength > 0.1) 
{
    shakeOffset.x = random_range(-shakeStrength, shakeStrength);
    shakeOffset.y = random_range(-shakeStrength, shakeStrength);
    
    shakeStrength *= shakeDecay;
}
else 
{
    shakeOffset = new Vector2(0, 0);
}

cX = clamp(cX, 0, room_width - CamWidth);
cY = clamp(cY, 0, room_height - CamHeight);

camera_set_view_pos(view_camera[CameraIndex], cX + shakeOffset.x, cY + shakeOffset.y);

if (keyboard_check_pressed(vk_control))
{
    debug = !debug;
    
    var inst = instance_find(obj_BASE_Entity, irandom(instance_number(obj_BASE_Entity) - 1));
    if (debug) SetCameraMode(CameraMode.MoveToFollowTarget, inst);
    else SetCameraMode(CameraMode.MoveToFollowTarget, obj_Player);
}