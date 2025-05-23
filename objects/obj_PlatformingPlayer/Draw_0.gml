var _list_size = ds_list_size(trail_points);

// Need at least 2 points to draw a line segment
if (_list_size > 1) {

    draw_primitive_begin(pr_trianglestrip); // Use a triangle strip for the ribbon

    // Iterate through the points to create segments
    for (var i = 0; i < _list_size; i++) {
        var _point_current = trail_points[| i];
        var _x = _point_current[0];
        var _y = _point_current[1];

        // Calculate the normalized position along the trail (0 = newest, 1 = oldest)
        var _progress = i / max(_list_size - 1, 1); // Avoid division by zero if size is 1

        // Interpolate color and alpha based on progress
        var _current_color = merge_color(trail_start_color, trail_end_color, _progress);
        var _current_alpha = lerp(trail_start_alpha, trail_end_alpha, _progress);

        // Calculate the direction vector for this segment
        var _dx = 0;
        var _dy = 0;
        if (i < _list_size - 1) { // Direction towards the next point
            var _point_next = trail_points[| i + 1];
            _dx = _point_next[0] - _x;
            _dy = _point_next[1] - _y;
        } else if (i > 0) { // For the last point, use the direction from the previous point
            var _point_prev = trail_points[| i - 1];
            _dx = _x - _point_prev[0];
            _dy = _y - _point_prev[1];
        }

        // Calculate the perpendicular vector (rotated 90 degrees)
        // Normalize the direction vector first to get consistent width
        var _len = sqrt(_dx * _dx + _dy * _dy);
        if (_len == 0) { // Avoid division by zero if points are identical
            // If no length, use the previous perpendicular, or default upwards
            // This part needs refinement for perfectly stationary points
            _len = 1;
            _dy = -1; // Default perpendicular upwards if points overlap
        }

        var _nx = _dx / _len; // Normalized direction x
        var _ny = _dy / _len; // Normalized direction y

        var _px = -_ny; // Perpendicular x
        var _py = _nx;  // Perpendicular y

        // Calculate the two vertices for this point in the strip
        var _half_width = trail_width / 2;
        var _x1 = _x + _px * _half_width;
        var _y1 = _y + _py * _half_width;
        var _x2 = _x - _px * _half_width;
        var _y2 = _y - _py * _half_width;

        // Add the two vertices to the triangle strip
        draw_vertex_color(_x1, _y1, _current_color, _current_alpha);
        draw_vertex_color(_x2, _y2, _current_color, _current_alpha);
    }

    draw_primitive_end();
}

if (attackPrimaryCooldown > 0)
{
    // placeholder attack art
    //draw_sprite_ext(spr_attackCircle, 0, x, y, 1, 1, 0, c_white, attackPrimaryCooldown / attackPrimaryCooldownMax);
}

draw_self();


