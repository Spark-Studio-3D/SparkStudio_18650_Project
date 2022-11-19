/*#################################################################################*\
   18650_Project.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            
   	

	Version:                1.0
	Creation Date:          10 Nov 2022
	Modification Date:      
	Email:                  richard+spark@milewski.org
	Copyright 				©2022 by Richard A. Milewski
    License                 Mozilla Public License v2.0

\*#################################################################################*/


/*#################################################################################*\
    
    Notes

\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/
include <BOSL2/std.scad>

$fn = 72;

part = "box";   // [box, lid, test]

battery_count = 6;
buffer = 5;
wall = 2;
corner = 8;


module hide_variables () {}  // variables below hidden from Customizer

2buffer = buffer*2;
battery = [18, 65, 18];
pcb = [30, 53.5, 1.25];
pcb_box = [30, 54, 11.4];


floor = wall;

icorner = corner - wall;
icorner2 = 1.5 * corner;      //Non std value to make fillet for screw post

battery_space = [(battery_count * (battery.x + buffer))+ buffer, battery.y + 2 * buffer, battery.z + buffer];

ibox = [pcb.x + wall + battery_space.x, battery_space.y, battery_space.z];
box = [ibox.x + wall * 2, ibox.y + wall * 2, ibox.z];
stacker = [box.x, box.y, buffer];

screw_post = [6, undef, stacker.z]; // post_dia, undef, post.z
screw_spacing = [ibox.x - wall - 5, ibox.y - wall - 5];
screw_hole = 2.5; //dia

// Key Locations
pcb_lift = floor + 6; 
internal_wall = [-ibox.x/2 + pcb.x + wall/2, 0, floor]; 
pcb_center = [-ibox.x/2 + pcb.x/2, 0, floor + pcb_lift + pcb.z/2];
pcb_ctr_left = pcb_center + [-pcb.x/2 , 0, 0];
pcb_back_left = pcb_ctr_left + [0, pcb.y/2, 0];
pcb_back_left_floor = pcb_back_left + [0, 0, -(pcb_lift + pcb.z/2)];
pcb_front_left = pcb_ctr_left + [0, -pcb.y/2, 0];
pcb_front_left_floor = pcb_front_left + [0, 0, -(pcb_lift + pcb.z/2)];
pcb_top = pcb_center + [0, 0, pcb.z/2];
pcb_bot = pcb_center + [0, 0, -pcb.z/2];

pcb_hole = 1.7;
pcb_post = [4, -5, pcb_lift]; // d, rounding, l
pcb_front_post_loc = pcb_front_left_floor + [11 + pcb_hole/2, 4.65 + pcb_hole/2, 0];
pcb_back_post_loc = pcb_back_left_floor + [13 + pcb_hole/2, -(9.25 + pcb_hole/2), 0];

pcb_support = [4, 4.5, pcb_lift];
pcb_front_support_loc = pcb_front_left_floor + [2,  1.5, 0];
pcb_back_support_loc  = pcb_back_left_floor  + [2, -1.5, 0];

pcb_stop = [8, 2, pcb_lift + 4];
pcb_front_stop_loc = pcb_front_left_floor + [2, -1.25, 0];
pcb_back_stop_loc  = pcb_back_left_floor  + [2,  1.25, 0];

battery_center = [ibox.x/2 - battery_space.x/2, 0, buffer + battery.z/2];


// Hole sizes and positions  
// usbC and lightning connectors centered under usbA connectors
led = [11, 6, 6];
led_loc = pcb_back_left + [0, -6.85, led.z/2];

usbA = [10.2, 13.5, 6];
usbAlift = 1.44; //connector height above pcb
usbA_loc1 =  pcb_back_left + [0, -12.75 - usbA.y/2, usbA.z/2 + usbAlift];
usbA_loc2 =  pcb_front_left + [0, 8.5 + usbA.y/2, usbA.z/2 + usbAlift];

usbC = [7.5, 9.2, 3.3];
usbC_loc =  [usbA_loc1.x, usbA_loc1.y , pcb_bot.z - usbC.z/2]; 

lightning = [8.73, 10, 3.5];
lightning_loc = [usbA_loc2.x, usbA_loc2.y, pcb_bot.z - lightning.z/2]; 

buttonhole = [4, 4, 4];
buttonhole_loc = [-ibox.x/2, ibox.y/2, pcb_center.z] + [17.5, wall/2, 0];

/*#################################################################################*\
    
    Main

\*#################################################################################*/
if (part == "box") {
    box();
}

if (part == "lid") {
   lid();
}

if (part == "test") {
    left_half(s = 200, x = -40)
    bottom_half(s = 200, z = box.z * .85)
    box();
}


/*#################################################################################*\
    
    Modules

\*#################################################################################*/


module box() {
    shell();
    internal_wall();
    if (part != "test") battery_bay();
    color_this("dodgerblue") stacker_with_posts(true);
    if ($preview && part != "test") pcb(false);
    
}

module floor() {
    cuboid([box.x, box.y, floor], rounding = corner, edges = "Z", anchor = BOT);
}

module shell() {
    floor();
    difference() {
       up(floor) rect_tube(h = box.z, size = [box.x, box.y], wall = wall, rounding = corner, irounding = icorner2, anchor = BOT);
       //shell holes
        union() {
            color("red") {
                move(led_loc) xcyl(d = led.z, l = led.x);
                move(usbA_loc1) cuboid([usbA.x, usbA.y, usbA.z], rounding = 1, edges = "X");
                move(usbA_loc2) cuboid([usbA.x, usbA.y, usbA.z], rounding = 1, edges = "X");
                move(usbC_loc) cuboid([usbC.x, usbC.y, usbC.z], rounding = 0.5, edges = "X");
                move(lightning_loc) cuboid(lightning, rounding = 0.5, edges = "X");
                move(buttonhole_loc) cuboid(buttonhole, rounding = 1, edges = "Y");           
            }
        }
    }
    color("dodgerblue") {
        difference() {
            union () {
                move (pcb_front_post_loc) cyl(h = pcb_post.z, d = pcb_post.x, rounding1 = pcb_post.y, anchor = BOT);
                move (pcb_back_post_loc)  cyl(h = pcb_post.z, d = pcb_post.x, rounding1 = pcb_post.y, anchor = BOT);
                }
            union() {
                move(pcb_back_post_loc) cyl(h=pcb_post.z, d = pcb_hole, anchor = BOT);
                move(pcb_front_post_loc) cyl(h=pcb_post.z, d = pcb_hole, anchor = BOT);
            }
        }
        move (pcb_front_support_loc) cuboid(pcb_support, anchor = BOT);
        move (pcb_back_support_loc)  cuboid(pcb_support, anchor = BOT);
        move (pcb_front_stop_loc) cuboid(pcb_stop, anchor = BOT);
        move (pcb_back_stop_loc)  cuboid(pcb_stop, anchor = BOT);
    }
}

module lid() {
    difference () {
        floor();
        grid_copies(n = 2, spacing = screw_spacing)
             #cyl(h = screw_post.z, d = screw_hole, anchor = BOT);
    } 
    up(floor) stacker(false);
      
       
           
        

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

module internal_wall () {
     difference() {
        move(internal_wall) color("red") cuboid([wall, ibox.y, ibox.z + stacker.z], anchor = BOT);
        union() {
            move(pcb_center) {   // Wire pass-through holes
                move([pcb.x/2, pcb.y/2, 3]) xcyl(d = 2.5, h = 5);
                move([-pcb.x/2, -pcb.y/2, 3]) xcyl(d = 2.5, h = 5);
            }
        }
     }
}

module stacker_with_posts(is_male) { //stacker with screw posts
     
        up(box.z + floor){
            difference () {
                union() {
                    stacker(is_male);
                    grid_copies(n = 2, spacing = screw_spacing)
                    color("white") cyl(h = screw_post.z, d = screw_post.x, rounding1 = screw_post.x/2, anchor = BOT);
                }
                grid_copies(n = 2, spacing = screw_spacing)
                #cyl(h = screw_post.z, d = screw_hole, anchor = BOT);

            }
        }
}


module stacker(is_male) {	// Interface ring to stack box
     //note non-standard irounding (icorner2) to provide screw post fillet.

	A = [box.x - 2 * wall/4, box.y - 2 * wall/4];
	B = [box.x - 4 * wall/4, box.y - 4 * wall/4];
	C = [box.x - 2 * wall,   box.y - 2 * wall];
	
	if (is_male) {
		rect_tube ( size1 = A, size2 = B, isize = C,
			h=stacker.z, rounding = corner, irounding = icorner2);
	} else {
        difference() {
            rect_tube(h = stacker.z, size = [stacker.x, stacker.y], wall = wall, 
                rounding = corner, irounding = icorner, anchor = BOT);				
            rect_tube(size1 = B, size2 = A, isize = C,
                h=stacker.z, rounding = corner, irounding = icorner);
        }
	}
}

module pcb(showbox) {
    volume1 = showbox ? pcb_box : pcb;
    move(pcb_center) {
        if($preview) color_this("lightgreen") cuboid(volume1, anchor = BOT);
        // Associated holes in walls
        move([pcb.x/2, pcb.y/2, 3]) xcyl(d = 2.5, h = 5);
        move([-pcb.x/2, -pcb.y/2, 3]) xcyl(d = 2.5, h = 5);
         
    }
}

module echo2(arg) {
	echo(str("\n\n", arg, "\n\n" ));
}