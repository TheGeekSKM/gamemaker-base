// replace this draw rectangle with a sprite if you want to
draw_rectangle_color(-5, -5, surface_get_width(application_surface) + 5, surface_get_height(application_surface) + 5, c_black, c_black, c_black, c_black, false);

scribble($"Loading...")
    .align(fa_center, fa_middle)
    .starting_format("VCR_OSD_Mono", c_white)
    .draw(surface_get_width(application_surface) / 2, surface_get_height(application_surface) / 2);