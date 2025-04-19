#macro guiMouseX device_mouse_x_to_gui(0)
#macro guiMouseY device_mouse_y_to_gui(0)

enum InteractableType
{
    Normal = 0,
    Point = 1,
    Attack = 2,
    Mine = 3,
    Talk = 4,
    Null = 5,
}

enum ButtonState
{
    Idle,
    Hover,
    Click
}

currentInteractable = noone;
oldInteractable = currentInteractable;
interactableList = ds_list_create();
currentMouseState = InteractableType.Normal;


depth = -10000;

///@pure
function FindLowestDepthElement()
{
    var count = ds_list_size(interactableList);
    if (count == 0) return noone;
    
    var dep = 10000;
    var elem = noone;
    for (var i = 0; i < count; i++)
    {
        if (interactableList[| i].depth < dep)
        {
            dep = interactableList[| i].depth;
            elem = interactableList[| i];
        }
    }
    return elem;
}

function ResetCurrentInteractable() { 
    currentInteractable.OnMouseExit();
    currentInteractable = noone;
    currentMouseState = InteractableType.Normal;
}