life--;
image_alpha = alphaStart * (life / 12);
if (life <= 0)
{
    instance_destroy();
}