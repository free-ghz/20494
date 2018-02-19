# 20494 image generator

it's supposed to generate images 204x94 pixels large, because it's a nice size,  
i'd like them to be monochrome in the end. 1-bit, black/white only, but it's not enforced in the code, it just happens to be so, i mean:

* this thing is a work in progress, but it has progressed quite a neat bit
	* it's written in processing, which basically means: it's a SKETCH
	* place all this in a folder called `tile_filters` or processing will be confused
* it's modular
	* the sketch is just a bunch of chained "filters"
	* the filters work on a wrapper of a PImage
	* you can start with a blank image or open it from a file
	* filters can be interactive or set to just run with default/random values
* currently i've these filters:
	* 1D cellular automata
	* "inkblob", a particle thing
	* positional dithering - to 1-bit
	* vignette
	* "spotscope" which is some kind of arc generator
	* "debugFilter" which **_must_** be placed last in the queue - or else it'll spam your harddrive! thanks

### controls
	
* mostly left click and drag to change parameters for current filter
* right click to progress to the next filter or save if it's on the last one

### thanks

some examples maybe on https://sixey.es/20494 although this site is for any image that size, not just by this sketch