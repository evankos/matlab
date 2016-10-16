from matlab_local import engine_context

@engine_context
def test_engine(ctx):
    # ctx.matlab_engine.desktop(nargout=0)
    # print ctx.matlab_engine.sqrt(4.)
    print ctx.matlab_engine.linspace(0.,1.,100.)

if __name__=="__main__":
    test_engine()
