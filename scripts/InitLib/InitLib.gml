function __loaderBase() constructor 
{
    static Process = function(_init) { return true; }
}

function LoaderSystem() : __loaderBase() constructor 
{
    static Process = function(_init) 
    {
        // create gamestate object
        // load system data
        // load persistent camera

        randomize();
        //instance_create_depth(0, 0, -1600, display_manager);
        instance_create_depth(0, 0, -1600, obj_FeedbackManager);

        return true;
    }    
}

function LoaderAssets() : __loaderBase() constructor 
{
    static Process = function(_init) 
    {
        // load assets
        // load fonts
        // load sprites
        // load sounds
        // load shaders

        get_perlin_noise_buffer();
        return true;
    }    
}

function LoaderGameData() : __loaderBase() constructor 
{
    static Process = function(_init) 
    {
        // load game data
        // load levels
        // load objects

        return true;
    }    
}