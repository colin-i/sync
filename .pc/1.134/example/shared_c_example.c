
//a simple shape moving on the stage example

#include <stdio.h>
#include "../dev/actionswf.h"

#define width 640
#define height 480
#define shape_lat 40

#ifdef __cplusplus
    char* file_name_for_output_swf="shared_c++_example.swf";
#else
    char* file_name_for_output_swf="shared_c_example.swf";
#endif

int main(){
	swf_new(file_name_for_output_swf,width,height,0x434343,24);
	unsigned int shape=swf_shape_basic(shape_lat,shape_lat,0xffeeFEff,0x11FF22ff);
	unsigned int movie_preid=swf_sprite_new();

	swf_sprite_placeobject(movie_preid,shape,1);
	swf_sprite_showframe(movie_preid);

	char ac[512];
	actionf_sprite(movie_preid,ac,"var move=20;var width=%u;var height=%u;var lat=%u;var left=move;var top=move;var right=width-lat-move;var bottom=height-lat-move",width,height,shape_lat);

	action_sprite(movie_preid," \
		if(this._x>=right)_root.x_coef=_root.x_coef*-1;\n\
		else if(this._x<=left)_root.x_coef=_root.x_coef*-1;\n\
		this._x=move*_root.x_coef+this._x;\n\
		if(this._y>=bottom)_root.y_coef=_root.y_coef*-1;\n\
		else if(this._y<=top)_root.y_coef=_root.y_coef*-1;\n\
		this._y=move*_root.y_coef+this._y;\n\
	");

	swf_sprite_showframe(movie_preid);

	unsigned int movie=swf_sprite_done(movie_preid);
	swf_exports_add(movie,"movie");

	action("\
		var x_coef=1;\n\
		var y_coef=1;\n\
		this.attachMovie('movie','_movie',1);\n\
		_movie._x=100;\n\
		_movie._y=100;\n\
	");

	swf_exports_done();swf_showframe();swf_done();

	return 1;
}
