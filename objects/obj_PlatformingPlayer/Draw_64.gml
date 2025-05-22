var secondsPlayed = round(timePlaying / game_get_speed(gamespeed_fps));
scribble($"{secondsPlayed}s")
    .align(fa_left, fa_top)
    .starting_format("VCR_OSD_Mono", c_white)
    .transform(2, 2, 0)
    .sdf_outline(c_black, 3)
    .draw(10, 5);