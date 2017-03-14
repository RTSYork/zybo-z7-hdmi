/**
 * Example of using the Digilent display drivers for Zybo VGA output
 * Russell Joyce, 16/02/2017
 */

#include <stdio.h>
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "zybo_vga/display_ctrl.h"

// Frame size (based on 1440x900 resolution, 32 bits per pixel)
#define MAX_FRAME (1440*900)
#define FRAME_STRIDE (1440*4)

DisplayCtrl dispCtrl; // Display driver struct
u32 frameBuf[DISPLAY_NUM_FRAMES][MAX_FRAME]; // Frame buffers for video data
void *pFrames[DISPLAY_NUM_FRAMES]; // Array of pointers to the frame buffers

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
	DisplaySetMode(&dispCtrl, &VMODE_1440x900);

	// Enable video output
	DisplayStart(&dispCtrl);

	printf("VGA output enabled\n\r");
	printf("Current Resolution: %s\n\r", dispCtrl.vMode.label);
	printf("Pixel Clock Freq. (MHz): %.3f\n\r", dispCtrl.pxlFreq);

	// Get parameters from display controller struct
	int x, y;
	u32 stride = dispCtrl.stride / 4;
	u32 width = dispCtrl.vMode.width;
	u32 height = dispCtrl.vMode.height;
	u32 *frame = dispCtrl.framePtr[dispCtrl.curFrame];
	u32 red, green, blue;

	// Fill the screen with a nice gradient
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			green = (x*0xFF) / width;
			blue = 0xFF - ((x*0xFF) / width);
			red = (y*0xFF) / height;
			frame[y*stride + x] = (red << BIT_DISPLAY_RED) | (blue << BIT_DISPLAY_BLUE) | (green << BIT_DISPLAY_GREEN);
		}
	}

	// Flush the cache, so the Video DMA core can pick up our frame buffer changes.
	// Flushing the whole cache (rather than a range) makes sense as our buffer is so big
	Xil_DCacheFlush();

	return 0;
}
