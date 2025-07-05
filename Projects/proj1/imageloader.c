/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				Gary Agasa  - Fudan University
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE * fp = fopen(filename, "r");
	if(fp == NULL){
    //When we get trouble with the file input
	return NULL;
	}

	char type[3];
	int row, col, colorscale;
	fscanf(fp, "%2s %d %d %d", type, &col, &row, &colorscale);

	Image* ret = (Image*)malloc(sizeof(Image));
	ret -> rows = row;
	ret -> cols = col;
	ret -> image = (Color**)malloc(row * col * sizeof(Color*));

	for(int i = 0; i < row; i++){
		for(int j = 0; j < col; j++){
			int index = i * col + j;
			ret -> image[index] = (Color*)malloc(sizeof(Color));
			int r, g, b;
			fscanf(fp, "%d %d %d", &r, &g, &b);
			ret -> image[index]->R = r;
			ret -> image[index]->G = g;
			ret -> image[index]->B = b;
		} 
	}

	fclose(fp);
	return ret;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	int row = image -> rows;
	int col = image -> cols;
	Color ** picture= image -> image;
    
	printf("P3\n");
	printf("%d %d\n255\n", row, col);

	for(int i = 0; i < row; i++){
		for(int j = 0; j < col; j++){
			int index = i * col + j;
			if(j != 0){
              printf("   ");
			}
            Color *pixel = picture[index];
			printf("%3d %3d %3d", pixel -> R, pixel -> G, pixel -> B);
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	int row = image -> rows;
	int col = image -> cols;
	Color ** picture= image -> image;
    
	for(int i = 0; i < row; i++){
		for(int j = 0; j < col; j++){
			int index = i * col + j;
            free(picture[index]);
		}
	}

	free(picture);
}

// /*Testing for PartA1*/
// void main(){
// 	Image* image = readData("testInputs/blinkerH.ppm");
// 	writeData(image);
// 	free(image);
// }