#include "mex.h"
#include "mat.h"
#include <thread>

using namespace std;

void read_X_Y (const char *fn);

struct mat_loader {
  thread worker;  
  mxArray *X, *Y;

  mat_loader () {
    X = mxCreateDoubleMatrix(0,0,mxREAL);
    Y = mxCreateDoubleMatrix(0,0,mxREAL);
  }

  void load (const char * fn) {
    if (worker.joinable()) { // wait until last loading finishes...
      worker.join(); 
      mexPrintf("wait until last reading done\n");
    }

    // begin a new thread to load the variables
    thread t(read_X_Y,  fn);

    // return immediately
    this->worker = move(t);
  }

  void pop_buf (mxArray* &X, mxArray* &Y) {
    if (worker.joinable()) 
      worker.join();

    // pop them: do nothing but return them to Matalb who takes the control
    X = this->X;
    Y = this->Y;
  }

  void clear_buf () {
    mexPrintf("destroy buffer X, Y\n");
    mxDestroyArray(X);
    mxDestroyArray(Y);
  }

};

static mat_loader the_loader;

void read_X_Y (const char *fn) {
  // TODO: need a lock here?

  // clean the buffer
  the_loader.clear_buf();

  mexPrintf("open mat\n");
  MATFile *h = matOpen(fn, "r");

  mexPrintf("read X, Y\n");
  the_loader.X = matGetVariable(h, "X"); // TODO: check 
  the_loader.Y = matGetVariable(h, "Y");

  mexPrintf("close mat\n");
  matClose(h);

  mexPrintf("make persistence buffer X, Y\n");
  mexMakeArrayPersistent(the_loader.X);
  mexMakeArrayPersistent(the_loader.Y);
}

void on_exit ()
{
  the_loader.clear_buf();
  the_loader.worker.~thread();
}


// load_xy_async(fn_mat); loads the the mat file with name fn_mat in a separate thread and returns immediately
// [X,Y] = load_xy_async(); loads the X, Y from buffer 
void mexFunction(int no, mxArray       *vo[],
                 int ni, mxArray const *vi[])
{
  // load_xy_async(fn_mat): load mat file and return immediately
  if (ni==1) {
    // get the file name 
    int buflen = mxGetN(vi[0])*sizeof(mxChar)+1;
    char *buf  = (char*)mxMalloc(buflen);
    mxGetString(vi[0], buf, buflen); // TODO: check status

    // begin loading and return 
    the_loader.load(buf);
    mexAtExit( on_exit );
    return;
  }

  // [X,Y] = load_xy_async():  loads the X, Y from buffer
  if (ni==0) {
    the_loader.pop_buf(vo[0], vo[1]);
    return;
  }

  mexErrMsgTxt("Incorrect calling arguments\n.");
  return;
}