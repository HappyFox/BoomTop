include  <lasercut.scad>;
$fn=60;

thickness = 6.2;

speaker_width = 54;
speaker_height = 54;
speaker_grill_diam = 54;
speaker_grill_radius = speaker_grill_diam/2;

screen_width = 72;
screen_height = 72;
screen_corner = 2;


speaker_inset = 40;
speaker_v_inset = 40 + thickness; 


sp_slit_h = 2;
sp_slit_h_step = sp_slit_h * 2;
sp_slit_count = speaker_height / sp_slit_h_step;


width = 500;
depth = 150;
height = 250;


module main_box()
{
    function speaker_slit(x,y,i) = [
        x + slit_x_inset_at(i) ,y,slit_width_at(i),sp_slit_h];

    function left_speaker_x(i) = speaker_inset + thickness;
    function right_speaker_x() = width - ( speaker_inset + speaker_width + (thickness *2));

    function slit_y(i) = height - (speaker_v_inset +  slit_y_step(i));
    function slit_y_step(i) = (sp_slit_h_step * i);

    function slit_delta_center(i) = speaker_grill_radius - slit_y_step(i);

    function slit_width_at(i) = 2 * sqrt(pow(speaker_grill_radius,2) - pow(slit_delta_center(i),2));
    function slit_x_inset_at(i) = speaker_grill_radius - (slit_width_at(i) /2); 

    echo(slit_y(0));
    echo(slit_y(1));
    echo(slit_y(2));

    cutouts_a = [
        [], //Bottom
        [], //top
        [
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(left_speaker_x(x) ,slit_y(x), x ),
            for(x=[0:sp_slit_count-1]) 
                speaker_slit(right_speaker_x() ,slit_y(x), x),
        ], // front
        [], // back
        [], // left
        [],  // right
    ];
    circles_remove_a = [
        [], //Bottom
        [], //top
        [], // front
        [], // back
        [], // left
        [],  // right
    ];
    lasercutoutBox(thickness = thickness, x=width, z=height, y=depth, 
            sides=6, num_fingers=4, circles_remove_a=circles_remove_a,
            cutouts_a=cutouts_a);

    echo(sqrt(pow(speaker_grill_radius,2) - pow(-26.5,2)));
    echo(slit_width_at(2));
}


color("Gold", 0.75) main_box();

