import matlab.engine
class context:
    def __init__(self):
        pass
ctx = context()
def engine_context(fun):
    def new_fun():
        with matlab.engine.start_matlab() as matlab_engine:
            ctx.matlab_engine = matlab_engine
            fun(ctx)  # the () after "original_function" causes original_function to be called
    return new_fun

if __name__=="__main__":
    print "context"