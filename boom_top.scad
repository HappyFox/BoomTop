include  <lasercut.scad>;
$fn=60;


/* [Size] */
width = 350;
depth = 150;
height = 150;

thickness = 6.2;


/* [Speakers] */
speaker_grill_diam = 54;
speaker_grill_radius = speaker_grill_diam/2;

speaker_inset = 20;
speaker_v_inset = 20 + thickness; 

sp_slit_h = 1;
sp_slit_h_step = sp_slit_h * 2;
sp_slit_count = (speaker_grill_diam / sp_slit_h_step) + 1;


/* [Screen] */

screen_width = 84;
screen_height = 84;

// slider  the size of the rounded corners on the screen
screen_corner = 5; // [50]
screen_v_inset = height /2 + screen_width/2 + thickness;


/* [Usb port] */

usb_height = 18;
usb_width = 28;

usb_hole_height = 12.5;
usb_hole_width = 25;
 
// LEDS

led_rad = 5;

base_v_inset = 20 + thickness;



module main_box()
{
    //speaker
    function speaker_slit(x,y,i) = [
        x + slit_x_inset_at(i) ,y,slit_width_at(i),sp_slit_h];

    function left_speaker_x(i) = speaker_inset + thickness;
    function right_speaker_x() = width - ( speaker_inset + speaker_grill_diam + (thickness *2));

    function slit_y(i) = height - (speaker_v_inset +  slit_y_step(i));
    function slit_y_step(i) = (sp_slit_h_step * i);

    function slit_delta_center(i) = speaker_grill_radius - (slit_y_step(i) + (sp_slit_h/2));

    function slit_width_at(i) = 2 * sqrt(pow(speaker_grill_radius,2) - pow(slit_delta_center(i),2));
    function slit_x_inset_at(i) = speaker_grill_radius - (slit_width_at(i) /2); 

    //screen 

    function screen_x() = 
        (width /2) - (screen_width/2);

    function screen_y() = 
        height - (screen_v_inset); 

    function screen_top() =
        screen_y() + screen_height;

    function screen_left() = 
        screen_x() + screen_width;

    
    cutouts_a = [
        [], //Bottom
        [], //top
        [
            // left speaker
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(left_speaker_x(x) ,slit_y(x), x ),

            // right speaker
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(right_speaker_x() ,slit_y(x), x),

            // the 2 rectangles to cut the screen out
            [screen_x() + screen_corner, screen_y(), 
                screen_width - (2 * screen_corner), screen_height], 
            [screen_x(), screen_y() + screen_corner, 
                screen_width, screen_height - (2 * screen_corner)], 

            

        ], // front
        [], // back
        [], // left
        [],  // right
    ];
    circles_remove_a = [
        [], //Bottom
        [], //top
        [
            // screen rounded corners.
            [screen_corner, screen_x() + screen_corner, screen_y() + screen_corner ], 
            [screen_corner, screen_x() + screen_corner, screen_top() - screen_corner ], 
            [screen_corner, screen_left() - screen_corner, screen_y() + screen_corner ], 
            [screen_corner, screen_left() - screen_corner, screen_top() - screen_corner ], 

            //LEDS
            [led_rad, 20, base_v_inset],
        ], // front
        [], // back
        [], // left
        [],  // right
    ];
    lasercutoutBox(thickness = thickness, x=width, z=height, y=depth, 
            sides=6, num_fingers=4, circles_remove_a=circles_remove_a,
            cutouts_a=cutouts_a);

}


color("Gold", 0.75) main_box();

