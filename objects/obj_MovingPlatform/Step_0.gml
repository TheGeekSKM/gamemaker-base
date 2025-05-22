if (waitTimer > 0)
{
    waitTimer--;
    exit;
}

var _dist = point_distance(x, y, targetX, targetY);
var _moveAmount = min(_dist, platformSpeed);

if (_dist > 0)
{
    // Use > 0 check to avoid potential issues with speed > dist
    var _dir = point_direction(x, y, targetX, targetY);
    x += lengthdir_x(_moveAmount, _dir);
    y += lengthdir_y(_moveAmount, _dir);
}

if (point_distance(x, y, targetX, targetY) < 0.5)
{
    x = targetX;
    y = targetY;

    var tempX = targetX;
    var tempY = targetY;
    targetX = startX;
    targetY = startY;
    startX = tempX;
    startY = tempY;

    waitTimer = waitTimeMax;
}