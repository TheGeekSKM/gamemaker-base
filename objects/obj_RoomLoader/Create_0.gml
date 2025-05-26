depth = -9999;
loadStack = [];

AssetLoader = function() : __loaderBase() constructor {
    static Process = function(_init) {
        // Load any Assets
        // or Call any functions that would load any assets (instantiation, etc)
        return true;
    }
}

DataLoader = function() : __loaderBase() constructor {
    static Process = function(_init) {
        // Load any Data you need to
        // Generally, if you have saved any Data in json or any other format, use this to load it into memory.
        
        return true;
    }
}

array_push(loadStack, new DataLoader());
array_push(loadStack, new AssetLoader());

loadTimeCounter = 0;

