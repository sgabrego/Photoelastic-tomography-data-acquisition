// sample code borrowed from
// http://qwiki.stanford.edu/index.php/DCU_Camera_SDK

#include "mex.h"
#include "uc480.h"
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray*prhs[] )
{     
	/* Check for proper number of arguments */
	if (nrhs != 1) { mexErrMsgTxt("Eactly one input required"); 
	} else if (nlhs != 1) { mexErrMsgTxt("exactly one output required"); 
	} 

	//Get handle
	int error;
	HCAM *pcam;
    HCAM cam;
	pcam = (HCAM *)mxGetPr(prhs[0]); 
    cam = *pcam;

	//Get sensor info, principally for the CDD size 
	SENSORINFO sInfo;
	int nX,nY;
	error = is_GetSensorInfo( cam, &sInfo);     
	nX = sInfo.nMaxWidth;
	nY = sInfo.nMaxHeight;

	if (error != IS_SUCCESS) {
		mexErrMsgTxt("Error getting sensor info"); 
	}

	//Set the color depth to 8-bit greyscale
	int BitsPerPixel = 8,ColorMode = IS_SET_CM_Y8;
	error = is_SetColorMode(cam, ColorMode);

	if (error != IS_SUCCESS) { 
		mexErrMsgTxt("Error setting color mode"); 
	}

	//create matlab image structure with "image" field of uint8 data type,
	//"pointer" field with int-valued pointer to the image buffer,
	// and "ID" field with int-valued ID for this buffer.
	char *pimage; 

	const char *field_names[] = {"image", "pointer", "ID"};
	mwSize dims[2] = {1, 1 };
	plhs[0] = mxCreateStructArray(2, dims, 3, field_names);//Create image structure
	int image_field = mxGetFieldNumber(plhs[0],"image");
	int pointer_field = mxGetFieldNumber(plhs[0],"pointer");
	int ID_field = mxGetFieldNumber(plhs[0],"ID");

	mxArray *pimage_field;
	pimage_field = mxCreateNumericMatrix(nX,nY, mxUINT8_CLASS,mxREAL);
	mxSetFieldByNumber(plhs[0],0,image_field,pimage_field); 
	//image array 2nd output, 1st field
	pimage = (char *)mxGetPr(pimage_field);

	//set the camera memory to the matlab image array
	int *ID,*ppointer;

	mxArray *ppointer_field;
	ppointer_field = mxCreateNumericMatrix(1, 1, mxINT32_CLASS,mxREAL);
	mxSetFieldByNumber(plhs[0],0,pointer_field,ppointer_field); 
	//image memory pointer 2nd output, 2nd field
	ppointer = (int *)mxGetPr(ppointer_field);
	*ppointer = (int)pimage;

	mxArray *pID_field;
	pID_field = mxCreateNumericMatrix(1, 1, mxINT32_CLASS,mxREAL);
	mxSetFieldByNumber(plhs[0],0,ID_field,pID_field); 
	//image memory pointer 2nd output, 3rd field
	ID = (int *)mxGetPr(pID_field);

	//Set I.image to be memory buffer for camera, using its pointer, and 
	//creating the "ID" for this memory buffer
	error = is_SetAllocatedImageMem(cam,nX,nY,BitsPerPixel,pimage,ID);

	if (error != IS_SUCCESS) {
		mexErrMsgTxt("Error allocating image memory"); 
	}

	//Activate I.image memory
	error = is_SetImageMem(cam,pimage,*ID);

	if (error !=IS_SUCCESS){
		mexErrMsgTxt("Error activating image memory"); 
	}

	//I'm also supposed to set the camera image
	error = is_SetImageSize(cam, nX, nY );

	if (error !=IS_SUCCESS){   
		mexErrMsgTxt("Error setting image size");  
	}

	return;   
}
