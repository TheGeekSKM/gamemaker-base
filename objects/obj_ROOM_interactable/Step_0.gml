// Inherit the parent event
event_inherited();
if (instance_exists(global.vars.Player) and PlayerIsWithinRange())
{
    InteractText = $"Left Click to Interact"
}