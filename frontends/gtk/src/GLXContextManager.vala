namespace glX {
    [CCode (has_target = false)]
    internal delegate glX.Context CreateContextAttribsARBProc(X.Display dpy, glX.FBConfig cfg, glX.Context share_context, bool direct, int[] attribs);
}

[CCode (cprefix = "X", lower_case_cprefix = "X")]
namespace X {
    [CCode (cname = "XScreenNumberOfScreen")]
    public extern int ScreenNumberOfScreen(X.Screen scr);
    
    [CCode (cname = "XFree")]
    public extern int Free(void* f);
}

class icCanvasGtk.GLXContextManager {
    public GLXContextManager(Gdk.X11Display? disp) {
        this._cm = null;
        
        if (disp != null) {
            this._disp = disp;
        } else {
            this._disp = (Gdk.X11Display)Gdk.Display.get_default();
        }
        
        this._create_context_attribs_ARB = (glX.CreateContextAttribsARBProc)glX.GetProcAddressARB("glXCreateContextAttribsARB");
    }
    
    private icCanvasManager.GL.ContextManager? _cm;
    private Gdk.X11Display _disp;
    
    public icCanvasManager.GL.ContextManager context_manager {
        get {
            if (this._cm == null) {
                icCanvasManager.GL.ContextManagerHooks hk = icCanvasManager.GL.ContextManagerHooks();
                
                hk.create_main_context = this.create_main_context;
                hk.create_sub_context = this.create_sub_context;
                hk.shutdown_sub_context = this.shutdown_sub_context;
                hk.make_current = this.make_current;
                hk.get_current = this.get_current;
                hk.get_proc_address = this.get_proc_address;
                
                this._cm = icCanvasManager.GL.ContextManager.construct_custom(hk);
            }
            
            return this._cm;
        }
    }
    
    private glX.CreateContextAttribsARBProc _create_context_attribs_ARB;
    private glX.Context main_ctxt = (glX.Context)0;
    
    icCanvasManager.GL.CONTEXT create_main_context(int major, int minor) {
        glX.Context nullCtxt = (glX.Context)0;
        if (this.main_ctxt != nullCtxt) {
            return (icCanvasManager.GL.CONTEXT)main_ctxt;
        }
        
        int[] visual_attribs = {
            glX.X_RENDERABLE, glX.True,
            glX.DRAWABLE_TYPE, glX.WINDOW_BIT | glX.PBUFFER_BIT,
            glX.RENDER_TYPE, glX.RGBA_BIT,
            glX.RED_SIZE, 8,
            glX.GREEN_SIZE, 8,
            glX.BLUE_SIZE, 8,
            glX.ALPHA_SIZE, 8,
            glX.None
        };
        
        unowned X.Display disp = Gdk.X11Display.get_xdisplay(this._disp);
        
        glX.FBConfig[] fb = glX.ChooseFBConfig(disp,
            X.ScreenNumberOfScreen(disp.default_screen()),
            visual_attribs);
        
        if (fb == null) {
            return (icCanvasManager.GL.CONTEXT)0; //Error out
        }
        
        glX.FBConfig fb_good = fb[0];
        X.Free(fb);
        
        int[] context_attribs = {
            glX.CONTEXT_MAJOR_VERSION_ARB, major,
            glX.CONTEXT_MINOR_VERSION_ARB, minor,
            glX.None
        };
        
        glX.Context c = this._create_context_attribs_ARB(disp, fb_good, nullCtxt, true, context_attribs);
        
        if (c == nullCtxt) {
            return (icCanvasManager.GL.CONTEXT)0; //Error out
        }
        
        this.main_ctxt = c;
        
        return (icCanvasManager.GL.CONTEXT)c;
    }
    
    icCanvasManager.GL.CONTEXT create_sub_context() {
        //TODO: Create sub contexts.
        return (icCanvasManager.GL.CONTEXT)0;
    }
    
    void shutdown_sub_context(icCanvasManager.GL.CONTEXT ctxt) {
        var c = (glX.Context)ctxt;
        
        if (c == this.main_ctxt) {
            //You CANNOT shutdown the main context.
            return;
        }
        
        unowned X.Display disp = Gdk.X11Display.get_xdisplay(this._disp);
        
        glX.DestroyContext(disp, c);
    }
    
    icCanvasManager.GL.CONTEXT make_current(icCanvasManager.GL.CONTEXT ctxt, icCanvasManager.GL.DRAWABLE draw) {
        //TODO: Bind the current context as active with a drawable.
        var c = (glX.Context)ctxt;
        var d = (glX.Drawable)draw;
        
        unowned X.Display disp = Gdk.X11Display.get_xdisplay(this._disp);
        
        var res = glX.MakeCurrent(disp, d, c);
        
        if (res) {
            return ctxt;
        }
        
        return (icCanvasManager.GL.CONTEXT)0;
    }
    
    icCanvasManager.GL.CONTEXT get_current() {
        return (icCanvasManager.GL.CONTEXT)glX.GetCurrentContext();
    }
    
    icCanvasManager.GL.Proc get_proc_address(string proc_name) {
        return (icCanvasManager.GL.Proc)glX.GetProcAddressARB(proc_name);
    }
}