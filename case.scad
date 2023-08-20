$fn=16;
use <cube_round.scad>;

case(render="all");

module case(render="all",
            dim_inside=[50,20,20],
            dia_screws=3.3,
            wall=2,
            height_top=10,
            gap=0.3,
            mki=5)
{
    dia_screw_head=2*dia_screws+gap;
    height_screw_head=dia_screws+gap;
    off_screw=dia_screw_head/2+wall/2;
    
    off_inside=dia_screw_head+wall;
    mki_inside=2/3*mki;
    
    dim_outside=dim_inside+[2*off_inside,
                            2*off_inside,
                            2*(wall+gap)];
    
    height_bottom=dim_outside[2]-height_top;
    
    if(render=="top" || render=="all")
    {
        //translate([0,-10,dim_outside[2]])
        //{
        //    rotate([180,0,0])
        //    {
                // cut away lower part from case
                difference()
                {
                    cube_round(dim_outside,mki=mki);
                    cutout_top();
                    cutout_screws();
                }
                difference()
                {
                    addon_screws();
                    cube([dim_outside[0],
                    dim_outside[1],
                    height_bottom-wall+gap]);
                }
        //   }
        //}
    }
    
    if(render=="bottom" || render=="all")
    {
        // cut away upper part from case
        difference()
        {
            cube_round(dim_outside,mki=mki);
            cutout_bottom();
            cutout_screws();
        }
        // add screw hull
        difference()
        {
            addon_screws();
            translate([0,0,height_bottom-wall])
            {
                cube([dim_outside[0],
                      dim_outside[1],
                      height_top+wall]);
            }
        }
    }
    
    module cutout_top()
    {
        translate([wall,wall,wall])
        {
            cube_round([dim_outside[0]-2*wall,
                        dim_outside[1]-2*wall,
                        dim_outside[2]-2*wall],mki_inside);
        }
        difference()
        {
            cube_round(dim_outside,mki=mki);
            cutout_bottom(gap=-gap);
        }
    }
    
    module cutout_bottom(gap=0)
    {
        translate([wall,wall,wall])
        {
            cube_round([dim_outside[0]-2*wall,
                  dim_outside[1]-2*wall,
                  dim_outside[2]-2*wall],mki_inside);
        }
        translate([wall/2-gap,wall/2-gap,height_bottom-wall-gap])
        {
            cube_round([dim_outside[0]-wall+2*gap,
                        dim_outside[1]-wall+2*gap,
                        wall+gap],mki_inside);
        }
        translate([0,0,height_bottom])
        {
            cube_round([dim_outside[0],
                        dim_outside[1],
                        height_top]);
        }
    }
    
    module cutout_screws()
    {
        place_screws(dim_x=dim_outside[0],
                     dim_y=dim_outside[1],
                     off_x=off_screw,
                     off_y=off_screw)
        {
            cylinder(h=dim_outside[2],d=dia_screws);
            cylinder(h=height_screw_head,d=dia_screw_head,$fn=6);
            translate([0,0,dim_outside[2]-height_screw_head])
            {
                cylinder(h=height_screw_head,d=dia_screw_head);
            }
        }
        
    }

    module addon_screws(gap=0)
    {
        intersection()
        {
            difference()
            {
                place_screws(dim_x=dim_outside[0],
                             dim_y=dim_outside[1],
                             off_x=off_screw,
                             off_y=off_screw)
                {
                    cylinder(h=dim_outside[2],d=dia_screws+2*wall);
                    cylinder(h=height_screw_head+wall,d=dia_screw_head+wall);
                    translate([0,0,dim_outside[2]-(height_screw_head+wall)])
                    {
                        cylinder(h=height_screw_head+wall,d=dia_screw_head+wall);
                    }
                }
                cutout_screws();
            }
            translate([wall-gap,wall-gap,0])
            {
                cube_round([dim_outside[0]-2*wall+2*gap,
                            dim_outside[1]-2*wall+2*gap,
                            dim_outside[2]],mki_inside);
            }
        }
    }
}

module place_screws(dim_x,dim_y,off_x,off_y)
{
    loc=[[off_x,off_y],
         [off_x,dim_y-off_y],
         [dim_x-off_x,off_y],
         [dim_x-off_x,dim_y-off_y]];
    
    for(i=loc)
    {
        translate(i)
        {
            children();
        }
    }
}

