global.EventManager = {
    
// The eventStruct is basically a struct pretending to be a dictionary.
// It carries many key/value pairs where the key is the eventName.
    
// The values are essentially arrays, 
//    which contain other arrays, 
//        which contain the object's id and the callback function. 

/*
    eventStruct = {
        "eventName" = [
            [id, func],
            ... ,
            [id, func]
        ],
        ... ,
        "eventName" = [
            [id, func],
            ... ,
            [id, func]
        ],
    }
*/
    eventStruct : {},
    
    // returns the index if the object is subscribed and returns -1 if its not subscribed
    _isSubscribed : function(_id, _event) 
    {
        var length = array_length(eventStruct[$ _event]);
            
        for (var i = 0; i < length; i++) 
        {
            var subArray = eventStruct[$ _event][i];
            if (subArray[subscribeParams.instanceID] == _id)
            {
                return i;
            }
        }
        return -1;
    },
    
    _subscribe : function(_id, _event, _func)
    {
        // if the event doesn't exist in eventStruct,
        if (is_undefined(eventStruct[$ _event]))            
        {   
            // then create the key of _event and the value of an array.
            eventStruct[$ _event] = [];                     
        }
        else if (_isSubscribed(_id, _event) != -1)          
        {
            // if object is subscribed, get out
            return;                                         
        }
        
        array_push(eventStruct[$ _event], [_id, _func]);
    },
    
    _raise : function(_event, _data)
    {
        
        if (is_undefined(eventStruct[$ _event])) return; 
            
        // IMPORTANT: We loop backwards so that if any subscriber is removed, there is no OutOfIndex error!
        var lastIndex = array_length(eventStruct[$ _event]) - 1;
        for (var i = lastIndex; i >= 0; i--) 
        {
            var currentSubArray = eventStruct[$ _event][i];
            if (instance_exists(currentSubArray[subscribeParams.instanceID]))
            {
                // apparently we can directly call method variables as function ONLY IF they are created inside the function call!
                currentSubArray[subscribeParams.instanceFunc](_data);
            }
            else
            {
                array_delete(eventStruct[$ _event], i, 1);
            }
        }
    },
    
    _unsubscribe : function(_id, _event)
    {
        
        if (is_undefined(eventStruct[$ _event])) return;
        
        var pos = _isSubscribed(_id, _event);
        if (pos != -1)
        {
            array_delete(eventStruct[$ _event], pos, 1)
        }
    },
    
    _unsubscribeAll : function(_id)
    {
        var keysArray = variable_struct_get_names(eventStruct);
        for (var i = (array_length(keysArray) - 1); i >= 0; i--) {
            _unsubscribe(_id, keysArray[i]);
        }
    },
    
    RemoveEvent : function(_event)
    {
        if (variable_struct_exists(eventStruct, _event))
        {
            variable_struct_remove(eventStruct, _event);
        }
    },
    
    RemoveAllEvents : function()
    {
        delete eventStruct;
        eventStruct = {};
    },
    
    RemoveDeadInstances : function()
    {
        var keysArray = variable_struct_get_names(eventStruct);
        for (var i = 0; i < array_length(keysArray); i++) 
        {
            var keysArraySub = eventStruct[$ keysArray[i]];
            for (var j = (array_length(keysArraySub) - 1); j >= 0; j--) 
            {
                if (!instance_exists(keysArraySub[j][subscribeParams.instanceID]))
                {
                    array_delete(eventStruct[$ keysArray[i]], j, 1);
                }
            }
        }
    }
    
};

enum subscribeParams
{
    instanceID = 0,
    instanceFunc = 1
}


function Subscribe(_event, _func) 
{
    with (global.EventManager) 
    {
        _subscribe(other.id, _event, _func);
        return true;
    }
    return false;
}

function Unsubscribe(_event) 
{
    with (global.EventManager) 
    {
        _unsubscribe(other.id, _event);
        return true;
    }
    return false;
}

function UnsubscribeAll()
{
    with (global.EventManager)
    {
        _unsubscribeAll(other.id);
        return true;
    }
    return false;
}

function Raise(_event, _data)
{
    with (global.EventManager)
    {
        _raise(_event, _data);
        return true;
    }
    return false;
}

function RestartEventSystem() { global.EventManager.RemoveAllEvents(); }