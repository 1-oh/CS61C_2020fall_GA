/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Gary Agasa - Fudan University
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.

int move(int numRow, int numCol, int posRow, int posCol, int direction){
	//We use this to determine the coordinate after moving, considering the edge situation
	//FOR DIRECTION: 0->up | 1->down | 2->left | 3->right
	int ret = -1;
	switch(direction){
	case 0:
	    if(posRow == 0){
			ret = numRow - 1;
		}
		else ret = posRow - 1;
		break;
	case 1:
	    if(posRow == numRow - 1){
			ret = 0;
		}
		else ret = posRow + 1;
		break;
	case 2:
	    if(posCol == 0){
			ret = numCol - 1;
		}
		else ret = posCol - 1;
		break;
	case 3:
	    if(posCol == numCol - 1){
			ret = 0;
		}
		else ret = posCol + 1;
		break;
	default:
	    printf("Illegal parameter for the function 'move'\n");
		break;
	}
	return ret;
}

void bitCountUpdate(int *bitCount, Image* image, int row, int col){
	//0-7:RED,8-15:GREEN,16-23:BLUE(each from low bit to high bit)
	Color* colorP = image -> image[col + row * (image -> cols)];
	//Update the bitCount of the RED
	int denominator = 1;
	for(int i = 0; i < 8; i++){
       int sign = (colorP -> R) / denominator % 2;
	   if(sign == 1){
		bitCount[i] += 1;
	   }
	   denominator *= 2; 
	}
	//Update the bitCount of the GREEN
	denominator = 1;
	for(int i = 8; i < 16; i++){
       int sign = (colorP -> G) / denominator % 2;
	   if(sign == 1){
		bitCount[i] += 1;
	   }
	   denominator *= 2; 
	}
	//Update the bitCount of the BLUE
	denominator = 1;
	for(int i = 16; i < 24; i++){
       int sign = (colorP -> B) / denominator % 2;
	   if(sign == 1){
		bitCount[i] += 1;
	   }
	   denominator *= 2; 
	}
}

Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
    Color *oldColor = image -> image[col + row * image -> cols];
	Color *ret = (Color*)malloc(sizeof(Color));

	int bitCount[24]; //0-7:RED,8-15:GREEN,16-23:BLUE(each from low bit to high bit)
	int upRow = move(image -> rows, image -> cols, row, col, 0);
	int downRow = move(image -> rows, image -> cols, row, col, 1);
	int leftCol = move(image -> rows, image -> cols, row, col, 2);
	int rightCol = move(image -> rows, image -> cols, row, col, 3);
    //Update the bitCount
	bitCountUpdate(bitCount, image, upRow, col);
	bitCountUpdate(bitCount, image, upRow, leftCol);
	bitCountUpdate(bitCount, image, upRow, rightCol);
	bitCountUpdate(bitCount, image, row, leftCol);
	bitCountUpdate(bitCount, image, row, rightCol);
    bitCountUpdate(bitCount, image, downRow, col);
	bitCountUpdate(bitCount, image, downRow, leftCol);
	bitCountUpdate(bitCount, image, downRow, rightCol);
	//Update the color
	/*Update red*/
    int red = oldColor -> R;
	for(int i = 0; i < 8; i++){
		int live = (red >> i) % 2;
		//judge whether a bit should "live" or "die" according to the number on some bit of the rule
		int standard = 0;
		if(live == 0){
            standard = (rule >> bitCount[i]) % 2; 
		}
		else{
            standard = (rule >> (bitCount[i] + 9)) % 2;
		}
       
		if(standard == 1){
			//use the mask(掩码) to achieve the effect that we set the specific bit to be 1
			uint32_t mask = 1u << i;
            red = (red & ~mask) | mask;
		}
        else{
            uint32_t mask = 1u << i;
            red = (red | mask) & ~mask;
		}
	}
	ret -> R = red;
	/*Update Green*/
    int green = oldColor -> G;
	for(int i = 8; i < 16; i++){
		int live = (green >> (i - 8)) % 2;
		//judge whether a bit should "live" or "die" according to the number on some bit of the rule
		int standard = 0;
		if(live == 0){
            standard = (rule >> bitCount[i]) % 2; 
		}
		else{
            standard = (rule >> (bitCount[i] + 9)) % 2;
		}
       
		if(standard == 1){
			//use the mask(掩码) to achieve the effect that we set the specific bit to be 1
			uint32_t mask = 1u << i;
            green = (green & ~mask) | mask;
		}
        else{
            uint32_t mask = 1u << i;
            green = (green | mask) & ~mask;
		}
	}
	ret -> G = green;
	/*Update Blue*/
    int blue = oldColor -> B;
	for(int i = 16; i < 24; i++){
		int live = (blue >> (i - 16)) % 2;
		//judge whether a bit should "live" or "die" according to the number on some bit of the rule
		int standard = 0;
		if(live == 0){
            standard = (rule >> bitCount[i]) % 2; 
		}
		else{
            standard = (rule >> (bitCount[i] + 9)) % 2;
		}
       
		if(standard == 1){
			//use the mask(掩码) to achieve the effect that we set the specific bit to be 1
			uint32_t mask = 1u << i;
            blue = (blue & ~mask) | mask;
		}
        else{
            uint32_t mask = 1u << i;
            blue = (blue | mask) & ~mask;
		}
	}
	ret -> B = blue;
	return ret;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
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
            ret -> image[index] = evaluateOneCell(image, i, j, rule);
		}
	}
	return ret;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if(argc != 3){
		printf("$ ./gameOfLife\nusage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.\n");
		return -1;
	}
	char *fileName = argv[1];
	char *endp;
	int rule = strtol(argv[2], &endp, 16);
	Image *oldImage = readData(fileName);
	if(oldImage == NULL){
		printf("here\n");
		return -1;
	}

	Image *newImage = life(oldImage, rule);
	writeData(newImage);
	freeImage(oldImage);
	freeImage(newImage);
	return 0;
}
