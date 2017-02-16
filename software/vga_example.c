/**
 * Example of using the Digilent display drivers for Zybo VGA output
 * Russell Joyce, 16/02/2017
 */

#include <stdio.h>
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "zybo_vga/display_ctrl.h"

// Frame size (based on 1680x1050 resolution, 3 bytes per pixel)
#define MAX_FRAME (1680*1050*3)
#define FRAME_STRIDE (1680*3)

DisplayCtrl dispCtrl; // Display driver struct
u8 frameBuf[DISPLAY_NUM_FRAMES][MAX_FRAME]; // Frame buffers for video data
u8 *pFrames[DISPLAY_NUM_FRAMES]; // Array of pointers to the frame buffers

int main(void) {
	// Initialise an array of pointers to the 2 frame buffers
	int i;
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
		pFrames[i] = frameBuf[i];

	// Initialise the display controller
	DisplayInitialize(&dispCtrl, XPAR_AXIVDMA_0_DEVICE_ID, XPAR_VTC_0_DEVICE_ID, XPAR_VGA_AXI_DYNCLK_0_BASEADDR, pFrames, FRAME_STRIDE);

	// Use first frame buffer (of two)
	DisplayChangeFrame(&dispCtrl, 0);

	// Set the display resolution
	DisplaySetMode(&dispCtrl, &VMODE_1680x1050);

	// Enable video output
	DisplayStart(&dispCtrl);

	printf("VGA output enabled\n\r");
	printf("Current Resolution: %s\n\r", dispCtrl.vMode.label);
	printf("Pixel Clock Freq. (MHz): %.3f\n\r", dispCtrl.pxlFreq);

	// Get parameters from display controller struct
	int x, y;
	u32 stride = dispCtrl.stride;
	u32 width = dispCtrl.vMode.width;
	u32 height = dispCtrl.vMode.height;
	u8 *frame = dispCtrl.framePtr[dispCtrl.curFrame];

	// Fill the screen with a nice gradient
	for (y = 0; y < height; y++) {
		for (x = 0; x < width*3; x+=3) {
			frame[y*stride + x + 0] = (x*0xFF) / (width*3);          // Green
			frame[y*stride + x + 1] = 0xFF - ((x*0xFF) / (width*3)); // Blue
			frame[y*stride + x + 2] = (y*0xFF) / height;             // Red
		}
	}

	// Flush the cache lines for our frame buffer, so the Video DMA core can pick up our changes
	Xil_DCacheFlushRange((INTPTR)frame, MAX_FRAME);

	return 0;
}
