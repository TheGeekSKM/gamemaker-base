var mouseHover = collision_point(mouse_x, mouse_y, id, true, false);

if (mouseHover) {
	image_blend = merge_color(image_blend, cHover, 0.1);
}
else {
	image_blend = merge_color(image_blend, cDefault, 0.1);
}