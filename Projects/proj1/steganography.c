/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				Gary Agasa - Fudan University
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	Color past = image -> image[row][col];
	Color *ret = (Color*)malloc(sizeof(Color));
	if(past.B % 2 == 0){
       ret -> R = 0;
	   ret -> G = 0;
	   ret -> B = 0;
	}
	else{
       ret -> R = 255;
	   ret -> G = 255;
	   ret -> B = 255;
	}
	return ret;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	Image *ret = (Image*)malloc(sizeof(Image));
	int numRow = image -> rows;
	int numCol = image -> cols;

    ret -> rows = numRow;
	ret -> cols = numCol;
	ret -> image = (Color**)malloc(numRow * numCol * sizeof(Color*));

	for(int i = 0; i < numRow; i++){
		for(int j = 0; j < numCol; j++){
			int index = j + i * numCol;
            ret -> image[index] = evaluateOnePixel(image, i, j);
		}
	}
	return ret;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	char* fileName = argv[1];
	Image *imagePast = readData(fileName);
	if(imagePast == NULL){
		//When we get trouble with the file input
		return -1;
	}
	Image *imageNew = steganography(imagePast);
	writeData(imageNew);
	freeImage(imagePast);
	freeImage(imageNew);
	return 0;
}
