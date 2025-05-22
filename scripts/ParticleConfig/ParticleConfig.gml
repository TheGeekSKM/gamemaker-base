function ParticleConfig() constructor {
    spriteIndex = spr_default;        
    spriteImageSpeed = 1;             
    colorStart = c_white;
    colorEnd = c_black;
    alphaStart = 1;
    alphaEnd = 0;
    sizeStart = 1;
    sizeEnd = 1;
    speedMin = 1;
    speedMax = 3;
    directionMin = 0;
    directionMax = 360;
    gravityAmount = 0.1;
    frictionAmount = 0.02;
    rotationSpeed = 0;                
    lifeFrames = 60;
    blendMode = bm_normal;

    // Fluent Setters
    static SetSprite = function(_spriteIndex, _spriteImageSpeed = 1) {
        spriteIndex = _spriteIndex;
        spriteImageSpeed = _spriteImageSpeed;
        return self;
    }
    
    static SetColors = function(_startColor, _endColor) {
        colorStart = _startColor;
        colorEnd = _endColor;
        return self;
    }
    
    static SetAlphas = function(_startAlpha, _endAlpha) {
        alphaStart = _startAlpha;
        alphaEnd = _endAlpha;
        return self;
    }
    
    static SetSizes = function(_startSize, _endSize) {
        sizeStart = _startSize;
        sizeEnd = _endSize;    
        return self;
    }
    
    static SetSpeeds = function(_minSpeed, _maxSpeed) {
        speedMin = _minSpeed;
        speedMax = _maxSpeed;
        return self;
    }
    
    static SetDirections = function(_minDirection, _maxDirection) {
        directionMin = _minDirection;
        directionMax = _maxDirection;
        return self;
    }
    
    static SetPhysics = function(_gravity, _friction, _rotSpeed = 0) {
        gravityAmount = _gravity;
        frictionAmount = _friction;
        rotationSpeed = _rotSpeed;
        return self;
    }
    
    static SetLifeTime = function(_lifeTimeInFrames) {
        lifeFrames = _lifeTimeInFrames;
        return self;
    }
    
    static SetBlendMode = function(_blendMode) {
        blendMode = _blendMode;
        return self;
    }
}