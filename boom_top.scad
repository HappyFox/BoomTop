include  <lasercut.scad>;
$fn=60;

width = 350;
depth = 150;
height = 150;

thickness = 6.2;

speaker_grill_diam = 54;
speaker_grill_radius = speaker_grill_diam/2;


screen_width = 72;
screen_height = 72;
screen_corner = 5;
screen_v_inset = height /2 + screen_width/2 + thickness;


speaker_inset = 40;
speaker_v_inset = 40 + thickness; 


sp_slit_h = 1;
sp_slit_h_step = sp_slit_h * 2;
sp_slit_count = (speaker_grill_diam / sp_slit_h_step) + 1;





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
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(left_speaker_x(x) ,slit_y(x), x ),
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(right_speaker_x() ,slit_y(x), x),
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
            [screen_corner, screen_x() + screen_corner, screen_y() + screen_corner ], 
            [screen_corner, screen_x() + screen_corner, screen_top() - screen_corner ], 
            [screen_corner, screen_left() - screen_corner, screen_y() + screen_corner ], 
            [screen_corner, screen_left() - screen_corner, screen_top() - screen_corner ], 
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

