enum MovementStyle 
{
    FLOAT_UP,
    ARC_UP,
    STATIC,
    OVERSHOOT_SCALE
}

enum FadeStyle
{
    LINEAR,
    EASE_OUT_QUAD,
    EASE_IN_OUT_QUAD
}

enum InstanceType
{
    PARTICLE,
    GLYPH,
    FRACTURE_PIECE
}

function GlyphConfig() constructor {
    // Default values
    text = "";
    textColor = c_white;
    textFont = "DefaultFont";         
    textScaleStart = 1;
    textScaleEnd = 1;
    textAlphaStart = 1;
    textAlphaEnd = 0;
    
    spriteIndex = -1;
    spriteImageSpeed = 0;             // Default to 0, set to e.g. 0.2 for animation
    spriteScaleStart = 1;
    spriteScaleEnd = 1;
    spriteAngleStart = 0;
    spriteAngleEnd = 0;
    spriteAlphaStart = 1;
    spriteAlphaEnd = 0;
    
    movementStyle = "float_up";       // "float_up", "arc_up", "static", "overshoot_scale"
    targetYOffset = -50;              // For float_up and arc_up
    arcHeightFactor = 0.5;            // For arc_up
    
    durationFrames = 90;
    fadeStyle = "linear";             // "linear", "ease_out_quad", "ease_in_out_quad"
    
    sdfOutlineColor = c_black;
    sdfOutlineWidth = 0;              // 0 for no outline

    // Fluent Setters
    static SetTextDetails = function(_text, _font, _color) {
        text = _text;
        textFont = _font;
        textColor = _color;
        return self;
    }

    static SetTextScale = function(_startScale, _endScale) {
        textScaleStart = _startScale;
        textScaleEnd = _endScale;
        return self;
    }

    static SetTextAlpha = function(_startAlpha, _endAlpha) {
        textAlphaStart = _startAlpha;
        textAlphaEnd = _endAlpha;
        return self;
    }

    static SetSpriteDetails = function(_spriteIndex, _imageSpeed = 0) {
        spriteIndex = _spriteIndex;
        spriteImageSpeed = _imageSpeed;
        return self;
    }

    static SetSpriteScale = function(_startScale, _endScale) {
        spriteScaleStart = _startScale;
        spriteScaleEnd = _endScale;
        return self;
    }

    static SetSpriteAngle = function(_startAngle, _endAngle) {
        spriteAngleStart = _startAngle;
        spriteAngleEnd = _endAngle;
        return self;
    }

    static SetSpriteAlpha = function(_startAlpha, _endAlpha) {
        spriteAlphaStart = _startAlpha;
        spriteAlphaEnd = _endAlpha;
        return self;
    }

    static SetMovement = function(_style, _yOffset, _arcFactor = 0.5) {
        movementStyle = _style;
        targetYOffset = _yOffset;
        arcHeightFactor = _arcFactor;
        return self;
    }

    static SetDuration = function(_frames) {
        durationFrames = _frames;
        return self;
    }

    static SetFadeStyle = function(_style) {
        fadeStyle = _style;
        return self;
    }

    static SetSDFOutline = function(_color, _width) {
        sdfOutlineColor = _color;
        sdfOutlineWidth = _width;
        return self;
    }
}