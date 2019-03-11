/************************************************************************/
/*                                                                      */
/*  vga_modes.h -- VideoMode definitions                                */
/*                                                                      */
/************************************************************************/
/*  Author: Sam Bobrowicz                                               */
/*  Copyright 2014, Digilent Inc.                                       */
/************************************************************************/
/*  Module Description:                                                 */
/*                                                                      */
/*      This file contains the definition of the VideoMode type, and    */
/*      also defines several common video modes                         */
/*                                                                      */
/************************************************************************/
/*  Revision History:                                                   */
/*                                                                      */
/*      2/17/2014(SamB): Created                                        */
/*      16/02/2017(RussellJ): Removed 1920x1080, added 1680x1050        */
/*      14/03/2017(RussellJ): Added 1280x800, 1440x900                  */
/*                                                                      */
/************************************************************************/

#ifndef VGA_MODES_H_
#define VGA_MODES_H_

typedef struct {
	char label[64]; /* Label describing the resolution */
	u32 width;      /* Width of the active video frame */
	u32 height;     /* Height of the active video frame */
	u32 hps;        /* Start time of Horizontal sync pulse, in pixel clocks (active width + H. front porch) */
	u32 hpe;        /* End time of Horizontal sync pulse, in pixel clocks (active width + H. front porch + H. sync width) */
	u32 hmax;       /* Total number of pixel clocks per line (active width + H. front porch + H. sync width + H. back porch) */
	u32 hpol;       /* hsync pulse polarity */
	u32 vps;        /* Start time of Vertical sync pulse, in lines (active height + V. front porch) */
	u32 vpe;        /* End time of Vertical sync pulse, in lines (active height + V. front porch + V. sync width) */
	u32 vmax;       /* Total number of lines per frame (active height + V. front porch + V. sync width + V. back porch) */
	u32 vpol;       /* vsync pulse polarity */
	double freq;    /* Pixel Clock frequency */
} VideoMode;

static const VideoMode VMODE_640x480 = {
	/* label */  "640x480@60Hz",
	/* width */  640,
	/* height */ 480,
	/* hps */    656,
	/* hpe */    752,
	/* hmax */   799,
	/* hpol */   0,
	/* vps */    490,
	/* vpe */    492,
	/* vmax */   524,
	/* vpol */   0,
	/* freq */   25.0
};


static const VideoMode VMODE_800x600 = {
	/* label */  "800x600@60Hz",
	/* width */  800,
	/* height */ 600,
	/* hps */    840,
	/* hpe */    968,
	/* hmax */   1055,
	/* hpol */   1,
	/* vps */    601,
	/* vpe */    605,
	/* vmax */   627,
	/* vpol */   1,
	/* freq */   40.0
};

static const VideoMode VMODE_1280x1024 = {
	/* label */  "1280x1024@60Hz",
	/* width */  1280,
	/* height */ 1024,
	/* hps */    1328,
	/* hpe */    1440,
	/* hmax */   1687,
	/* hpol */   1,
	/* vps */    1025,
	/* vpe */    1028,
	/* vmax */   1065,
	/* vpol */   1,
	/* freq */   108.0
};

static const VideoMode VMODE_1280x720 = {
	/* label */  "1280x720@60Hz",
	/* width */  1280,
	/* height */ 720,
	/* hps */    1390,
	/* hpe */    1430,
	/* hmax */   1649,
	/* hpol */   1,
	/* vps */    725,
	/* vpe */    730,
	/* vmax */   749,
	/* vpol */   1,
	/* freq */   74.25, //74.2424 is close enough
};

// Taken from http://tinyvga.com/vga-timing/1280x800@60Hz
static const VideoMode VMODE_1280x800 = {
	/* label */  "1280x800@60Hz",
	/* width */  1280,
	/* height */ 800,
	/* hps */    1344,
	/* hpe */    1480,
	/* hmax */   1680,
	/* hpol */   0,
	/* vps */    801,
	/* vpe */    804,
	/* vmax */   828,
	/* vpol */   1,
	/* freq */   83.46
};

// Taken from http://tinyvga.com/vga-timing/1440x900@60Hz
static const VideoMode VMODE_1440x900 = {
	/* label */  "1440x900@60Hz",
	/* width */  1440,
	/* height */ 900,
	/* hps */    1520,
	/* hpe */    1672,
	/* hmax */   1904,
	/* hpol */   0,
	/* vps */    901,
	/* vpe */    904,
	/* vmax */   932,
	/* vpol */   1,
	/* freq */   106.47
};

// Taken from http://tinyvga.com/vga-timing/1680x1050@60Hz
static const VideoMode VMODE_1680x1050 = {
	/* label */  "1680x1050@60Hz",
	/* width */  1680,
	/* height */ 1050,
	/* hps */    1784,
	/* hpe */    1968,
	/* hmax */   2256,
	/* hpol */   0,
	/* vps */    1051,
	/* vpe */    1054,
	/* vmax */   1087,
	/* vpol */   1,
	/* freq */   147.14
};

#endif /* VGA_MODES_H_ */
