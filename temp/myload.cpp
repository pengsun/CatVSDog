#include "mex.h"
#include "mat.h"


static mxArray *X = 0;
static mxArray *Y = 0;
static char    filename[2048];

void read_X_Y (const char *fn);
void clear_buf();

void load_mat (const char * fn) 
{
  mexPrintf("In load_mat\n");

  // clean the buffer
  clear_buf();

  read_X_Y (fn);



  mexPrintf("Out load_mat\n");
}

void pop_buf (mxArray* &xx, mxArray* &yy) {
  mexPrintf("In pop_buf\n");

  // pop them
  mexPrintf("deep copy\n");

  mexPrintf("copy X\n");
  xx = mxDuplicateArray(X);

  mexPrintf("copy Y\n");
  yy = mxDuplicateArray(Y);


  mexPrintf("Out pop_buf\n");
}

void clear_buf () 
{
  mexPrintf("In clear_buf\n");

  if (X!=0) {
    mexPrintf("clear X\n");
    mxDestroyArray(X);
    X = 0;
  }

  if (Y!=0) {
    mexPrintf("clear Y\n");
    mxDestroyArray(Y);
    Y = 0;
  }

  mexPrintf("Out clear_buf\n");
}

void read_X_Y (const char *fn) {
  mexPrintf("In read_X_Y\n"); 

  // X
  mexPrintf("open mat %s\n", fn); 
  MATFile *h = matOpen(fn, "r");

  mexPrintf("loading X from mat\n"); 
  X = matGetVariable(h, "X"); // TODO: check 

  mexPrintf("close mat %s\n", fn); 
  matClose(h);

  mexPrintf("make persistence buffer X\n"); 
  mexMakeArrayPersistent(X);

  // Y
  mexPrintf("open mat %s\n", fn); 
  h = matOpen(fn, "r");

  mexPrintf("loading Y from mat\n"); 
  Y = matGetVariable(h, "Y");

  mexPrintf("close mat %s\n", fn); 
  matClose(h);

  mexPrintf("make persistence buffer Y\n"); 
  mexMakeArrayPersistent(Y);

  mexPrintf("Out read_X_Y\n"); 
}

void on_exit ()
{
  mexPrintf("In on_exit\n");

  clear_buf();

  mexPrintf("Out on_exit\n");
}


// load_xy_async(fn_mat); loads the the mat file with name fn_mat in a separate thread and returns immediately
// [X,Y] = load_xy_async(); loads the X, Y from buffer 
void mexFunction(int no, mxArray       *vo[],
                 int ni, mxArray const *vi[])
{
  // load_xy_async(fn_mat): load mat file and return immediately
  if (ni==1) {
    mexPrintf("In ni==1\n");


    // get the file name 
    int buflen = mxGetN(vi[0])*sizeof(mxChar)+1;
    //char *filename  = (char*)mxMalloc(buflen);

    mxGetString(vi[0], filename, buflen); // TODO: check status

    // begin loading and return 
    load_mat(filename);
    mexAtExit( on_exit );

    mexPrintf("Out ni==1\n");
    return;
  }

  // [X,Y] = load_xy_async():  loads the X, Y from buffer
  if (ni==0) {
    mexPrintf("In ni==0\n");

    pop_buf(vo[0], vo[1]);

    mexPrintf("Out ni==0\n");
    return;
  }

  mexErrMsgTxt("Incorrect calling arguments\n.");
  return;
}