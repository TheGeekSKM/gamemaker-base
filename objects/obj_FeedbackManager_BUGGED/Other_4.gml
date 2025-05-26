show_debug_message("ROOM START: " + room_get_name(room));
if (ds_list_size(poolFracturePiecesInactive) > 0) {
    var test_inst = ds_list_find_value(poolFracturePiecesInactive, 0);
    show_debug_message("ROOM START POOL CHECK - ID: " + string(test_inst) + 
                    ", Exists: " + string(instance_exists(test_inst)) +
                    ", Object: " + (instance_exists(test_inst) ? object_get_name(test_inst.object_index) : "N/A"));
}
