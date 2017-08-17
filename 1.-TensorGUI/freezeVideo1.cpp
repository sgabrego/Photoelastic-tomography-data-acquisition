#include "mex.h"
#include "uc480.h"
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray*prhs[] )
{     
	/* Check for proper number of arguments */
	if (nrhs != 1) { mexErrMsgTxt("One input requied!"); 
	} else if (nlhs != 0) { mexErrMsgTxt("no outputs will be generated"); 
	}     
    
	//Initialize Camera and get handle
	int error;
	HCAM *pcam;
    HCAM cam;
	pcam = (HCAM *)mxGetPr(prhs[0]); 
    cam = *pcam;
	// for some reason mxGetPr always returns double* despite matlab datatype

	error = is_FreezeVideo(cam, IS_WAIT);
	if (error != IS_SUCCESS) {mexErrMsgTxt("Error freezing video"); 
	}
    
    return;
    
    
 
}
