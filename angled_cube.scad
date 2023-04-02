module angled_cube(a_len_inner=30,
                   a_width=10,
                   b_len_inner=20,
                   b_width=10,
                   height=10,
                   angle=75)
{
    c_len_outer=sqrt(pow(a_width,2)+pow(b_width,2));
    offset_x_b_outer=sin(angle)*b_width;
    offset_y_b_outer=a_width-tan(90-angle)*offset_x_b_outer;
    echo(offset_x_b_outer);
    echo(offset_y_b_outer);

    cube([a_len_inner,a_width,height]);
    translate([a_len_inner,a_width,0])
        rotate(angle)
            translate([0,-b_width,0])
                cube([b_len_inner,b_width,height]);
            
    translate([a_len_inner,0,0])    
    linear_extrude(height)
        polygon(points=[[0,0],[0,a_width],[offset_x_b_outer,offset_y_b_outer]],
                paths=[[0,1,2]]);
}

angled_cube(a_width=20);