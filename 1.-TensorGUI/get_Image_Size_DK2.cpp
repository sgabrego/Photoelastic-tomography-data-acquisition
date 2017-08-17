#include "mex.h"
#include "uc480.h"
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray*prhs[] )
{     
	/* Check for proper number of arguments */
	if (nrhs != 1 ) { mexErrMsgTxt("One input requied!"); 
	}    
    
    	//Initialize Camera and get handle
	int error;
	HCAM *pcam;
    HCAM cam;
	pcam = (HCAM *)mxGetPr(prhs[0]); 
    cam = *pcam;
//    const mwSize dims[]={1,2};
    double *output;
    
    // DK code
    plhs[0]=mxCreateDoubleMatrix(1,2,mxREAL);
    output=mxGetPr(plhs[0]);
    error=is_SetImageSize(cam,IS_GET_IMAGE_SIZE_X,0);
    output[0]=error;
    error=is_SetImageSize(cam,IS_GET_IMAGE_SIZE_Y,0);
    output[1]=error;
     return;
    
 
}
