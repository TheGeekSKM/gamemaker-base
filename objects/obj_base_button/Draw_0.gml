draw_self();

if (sprIcon != noone)
{
	draw_sprite(sprIcon, 0, x, y);
}

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x, y, text);


draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);