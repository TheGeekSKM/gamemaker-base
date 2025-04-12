enum IntVisType
{
    Room,
    GUI
}
// Inherit the parent event
event_inherited();
currentState = ButtonState.Idle;

mouseEnterCallbacks = [];

function AddMouseEnterCallback(callback) 
{
    array_push(mouseEnterCallbacks, callback);
}

function OnMouseEnter() {
    currentState = ButtonState.Hover;
    for (var i = 0; i < array_length(mouseEnterCallbacks); i++) {
        var callback = mouseEnterCallbacks[i];
        if (callback != undefined) {
            callback();
        }
    }
    
    return Type;
}
function OnMouseExit() {
    currentState = ButtonState.Idle;
}
function OnMouseLeftClick() {}
function OnMouseLeftHeld() {}
function OnMouseLeftClickRelease() {}
function OnMouseRightClick() {}
function OnMouseRightHeld() {}
function OnMouseRightClickRelease() {}

/// @pure
function PlayerIsWithinRange()
{
    return currentState == ButtonState.Hover;
    //if (instance_exists(global.vars.Player))
    //{
        //if (point_distance(global.vars.Player.x, global.vars.Player.y, x, y) < InteractionRange)
        //{
            //return true;
        //}
    //}
    //return false;
}
