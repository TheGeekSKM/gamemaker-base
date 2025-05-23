function FracturePieceConfig() constructor 
{
    originalSprite = -1;        
    originalImageIndex = 0;     
    
    useOriginalSpritePerPiece = true; 
    chunkSprite = spr_chunk;    
    chunkSize = 8;              

    numPiecesMin = 5; 
    numPiecesMax = 10;

    pieceLifetimeFrames = 180;
    
    speedMin = 1.5;
    speedMax = 5;

    gravityAmount = 0.25;
    airFrictionAmount = 0.01;
    groundFrictionFactor = 0.2;

    angularVelocityMin = -7;
    angularVelocityMax = 7;

    bounceFactor = 0.3;
    
    stopOnGround = true;
    fadeOnGround = true;
    fadeDurationOnGround = 60;

    scaleMin = 0.8; 
    scaleMax = 1.2; 
    
    solidObject = obj_Solid;

    static SetOriginalObjectVisuals = function(_sprite, _imageIndex = 0) 
    {
        originalSprite = _sprite;
        originalImageIndex = _imageIndex;
        return self;
    }
    static SetPieceAppearance = function(_useOriginal, _chunkSpr = spr_chunk, _sMin = 0.8, _sMax = 1.2) 
    {
        useOriginalSpritePerPiece = _useOriginal;
        chunkSprite = _chunkSpr; 
        scaleMin = _sMin;
        scaleMax = _sMax;
        return self;
    }
    
    static SetPieceCount = function(_min, _max) 
    { 
        numPiecesMin = _min;
        numPiecesMax = _max;
        return self;
    }
    
    static SetChunkSize = function(_size) 
    {
        chunkSize = max(1, _size); 
        return self;
    }
    
    static SetPieceLifetime = function(_frames) 
    {
        pieceLifetimeFrames = _frames;
        return self;
    }
    
    static SetPiecePhysics = function(_grav, _airFric, _groundFricFactor = 0.2, _bounce = 0.3) 
    {
        gravityAmount = _grav;
        airFrictionAmount = _airFric;
        groundFrictionFactor = _groundFricFactor;
        bounceFactor = _bounce;
        return self;
    }
    
    static SetPieceInitialSpeed = function(_min, _max) 
    {
        speedMin = _min;
        speedMax = _max;
        return self;
    }
    
    static SetPieceRotationSpeed = function(_minAngVel, _maxAngVel) 
    {
        angularVelocityMin = _minAngVel;
        angularVelocityMax = _maxAngVel;
        return self;
    }
    
    static SetGroundBehavior = function(_stop, _fade, _fadeDur = 60) 
    {
        stopOnGround = _stop;
        fadeOnGround = _fade;
        fadeDurationOnGround = _fadeDur;
        return self;
    }
    
    static SetSolidObject = function(_obj) 
    {
        solidObject = _obj; 
        return self;
    }
    
}