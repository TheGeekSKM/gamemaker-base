if (ds_stack_empty(loadStack))
{
    ds_stack_destroy(loadStack)
    if (FirstRoom != noone)
    {
        room_goto(FirstRoom);
    }
    else if (room_exists(room_next(room)))
    {
        room_goto_next();
    }
    
    instance_destroy(id);
}
else 
{
    var top = ds_stack_top(loadStack);
    if (top.Process(id)) ds_stack_pop(loadStack);    
}