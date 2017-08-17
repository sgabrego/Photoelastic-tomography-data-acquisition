#include "mex.h"
#include "uc480.h"
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray*prhs[] )
{     
	/* Check for proper number of arguments */
	if (nrhs < 1) { mexErrMsgTxt("At least one input requied!"); 
	} else if (nlhs != 0) { mexErrMsgTxt("no outputs will be generated"); 
	}

    // from mxmalloc.c [malab sample code]
    char *buf;
    mwSize buflen;
    int status;

    
    /* Check for proper input type */
    if (nrhs < 2 || !mxIsChar(prhs[1]) || (mxGetM(prhs[1]) != 1 ) )  {
        // otherwise use null to open dialog
        buf = 0;
    }
    else {
    
    
    buflen = mxGetN(prhs[1])*sizeof(mxChar)+1;
    buf = (char*) mxMalloc(buflen);
    
    /* Copy the string data into buf. */ 
    status = mxGetString(prhs[1], buf, buflen);  
    
     /* A status of 0 is good*/    
     mexPrintf("Status: %d\n", status);
     mexPrintf("Loading parameters from:  %s\n", buf);
    }
    
	int error;
	HCAM *pcam;
    HCAM cam;
	pcam = (HCAM *)mxGetPr(prhs[0]); 
    cam = *pcam;
	// for some reason mxGetPr always returns double* despite matlab datatype
	error = is_LoadParameters(cam, buf);
    mexPrintf("Error message from is_loadParameters is  %d\n If this is zero, you have nothing to worry about", error);
    if (error ==  IS_INVALID_CAMERA_TYPE) {mexErrMsgTxt("Invalid camera type in parameters file"); 
	}
	if (error != IS_SUCCESS) {mexErrMsgTxt("Error loading parameters"); 
	}

    /* When finished using the string, deallocate it. */
    mxFree(buf);

    
    
    return;
    
    
 
}
