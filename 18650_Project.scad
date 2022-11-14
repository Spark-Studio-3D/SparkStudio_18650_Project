/*#################################################################################*\
   18650_Project.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            
   	

	Version:                1.0
	Creation Date:          
	Modification Date:      
	Email:                  richard+scad@milewski.org
	Copyright 				©2022 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

\*#################################################################################*/


/*#################################################################################*\
    
    Notes

\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/
include <BOSL2/std.scad>

$fn = 72;

part = "box";   // [box, lid]

battery_count = 3;
buffer = 5;
wall = 2;
corner = 8;


module hide_variables () {}  // variables below hidden from Customizer

2buffer = buffer*2;
battery = [18, 65, 18];
pcb = [31.5, 53.7, 11.5];

floor = wall;

icorner = corner - wall;

battery_space = [(battery_count * (battery.x + buffer))+ buffer, battery.y + 2 * buffer, battery.z + buffer];

ibox = [pcb.x + battery_space.x, battery_space.y, battery_space.z];
box = [ibox.x + wall * 2, ibox.y + wall * 2, ibox.z];
stacker = [box.x, box.y, buffer];

// Key Locations
pcb_lift = floor + box.z/2 - pcb.z/2; 
connectors = [-box.x/2, 0, box.z/2];
pcb_center = [-ibox.x/2 + pcb.x/2, 0, floor + pcb_lift];

battery_center = [ibox.x/2 - battery_space.x/2, 0, buffer + battery.z/2];


/*#################################################################################*\
    
    Main

\*#################################################################################*/
if (part == "box") {
    box();
    battery_bay();
    echo2([box.x, box.y, stacker.z]);
    up(floor + box.z) color_this("dodgerblue") stacker(true);
    if ($preview) {
        dummypcb();
        back(box.y/3) up(floor+battery_space.z) sphere(d = buffer, anchor = BOT);
    }
}

if (part == "lid") {
    floor();
    up(floor) stacker(false);

}
/*#################################################################################*\
    
    Modules

\*#################################################################################*/
module floor() {
    cuboid([box.x, box.y, floor], rounding = corner, edges = "Z", anchor = BOT);
}

module box() {
        floor();
        up(floor) rect_tube(h = box.z, size = [box.x, box.y], wall = wall, rounding = corner, irounding = icorner, anchor = BOT);

}

module battery() {
    ycyl(d = battery.x,  l = battery.y);
}

module battery_bay() {
    up(floor){
        difference() {
            union() {
                move([battery_center.x, battery_center.y, floor*2]) {
                    back(box.y/4) cuboid([battery_space.x, wall, battery_space.z/2]);
                    fwd(box.y/4)  cuboid([battery_space.x, wall, battery_space.z/2]);
                }
            }
            union() {
                echo2([battery_center]);
                move (battery_center) left(battery_space.x/2 + battery.x/2) {
                    for (i = [1 : battery_count]) {
                        right(buffer * i + battery.x * i-1)
                            #battery();  
                    }
                }
            }
        }
    }
}


module stacker(is_male) {	// Interface ring to stack box 

	A = [box.x - 2 * wall/4, box.y - 2 * wall/4];
	B = [box.x - 4 * wall/4, box.y - 4 * wall/4];
	C = [box.x - 2 * wall, box.y - 2 * wall];
	
	if (is_male) {
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner);
	} else {
        difference() {
            rect_tube(h = stacker.z, size = [stacker.x, stacker.y], wall = wall, 
                rounding = corner, irounding = icorner, anchor = BOT);				
            rect_tube(size1 = B, size2 = A, isize = C,
                h=stacker.z, rounding = corner, irounding = icorner);
        }
	}
}

module dummypcb() {
    move(pcb_center)
        color_this("lightgreen") cuboid(pcb, anchor = BOT);
}

module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}