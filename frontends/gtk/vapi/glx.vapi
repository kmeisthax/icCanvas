[CCode (cprefix = "GLX_", lower_case_cprefix = "glX_",
        cheader_filename="GL/glx.h")]
namespace glX {
    [CCode (cname = "GLXContext")]
    [SimpleType]
    public struct Context {}
    
    [CCode (cname = "GLXDrawable")]
    [SimpleType]
    public struct Drawable {}
    
    [CCode (cname = "GLXFBConfig",
            free_function = "XFree")]
    [SimpleType]
    public struct FBConfig {}
    
    //glX enumerants
    public const int USE_GL;
    public const int BUFFER_SIZE;
    public const int LEVEL;
    public const int RGBA;
    public const int DOUBLEBUFFER;
    public const int STEREO;
    public const int AUX_BUFFERS;
    public const int RED_SIZE;
    public const int GREEN_SIZE;
    public const int BLUE_SIZE;
    public const int ALPHA_SIZE;
    public const int DEPTH_SIZE;
    public const int STENCIL_SIZE;
    public const int ACCUM_RED_SIZE;
    public const int ACCUM_GREEN_SIZE;
    public const int ACCUM_BLUE_SIZE;
    public const int ACCUM_ALPHA_SIZE;
    public const int BAD_SCREEN;
    public const int BAD_ATTRIBUTE;
    public const int NO_EXTENSION;
    public const int BAD_VISUAL;
    public const int BAD_CONTEXT;
    public const int BAD_VALUE;
    public const int BAD_ENUM;
    public const int VENDOR;
    public const int VERSION;
    public const int EXTENSIONS;
    public const int CONFIG_CAVEAT;
    public const int DONT_CARE;
    public const int X_VISUAL_TYPE;
    public const int TRANSPARENT_TYPE;
    public const int TRANSPARENT_INDEX_VALUE;
    public const int TRANSPARENT_RED_VALUE;
    public const int TRANSPARENT_GREEN_VALUE;
    public const int TRANSPARENT_BLUE_VALUE;
    public const int TRANSPARENT_ALPHA_VALUE;
    public const int WINDOW_BIT;
    public const int PIXMAP_BIT;
    public const int PBUFFER_BIT;
    public const int AUX_BUFFERS_BIT;
    public const int FRONT_LEFT_BUFFER_BIT;
    public const int FRONT_RIGHT_BUFFER_BIT;
    public const int BACK_LEFT_BUFFER_BIT;
    public const int BACK_RIGHT_BUFFER_BIT;
    public const int DEPTH_BUFFER_BIT;
    public const int STENCIL_BUFFER_BIT;
    public const int ACCUM_BUFFER_BIT;
    public const int NONE;
    public const int SLOW_CONFIG;
    public const int TRUE_COLOR;
    public const int DIRECT_COLOR;
    public const int PSEUDO_COLOR;
    public const int STATIC_COLOR;
    public const int GRAY_SCALE;
    public const int STATIC_GRAY;
    public const int TRANSPARENT_RGB;
    public const int TRANSPARENT_INDEX;
    public const int VISUAL_ID;
    public const int SCREEN;
    public const int NON_CONFORMANT_CONFIG;
    public const int DRAWABLE_TYPE;
    public const int RENDER_TYPE;
    public const int X_RENDERABLE;
    public const int FBCONFIG_ID;
    public const int RGBA_TYPE;
    public const int COLOR_INDEX_TYPE;
    public const int MAX_PBUFFER_WIDTH;
    public const int MAX_PBUFFER_HEIGHT;
    public const int MAX_PBUFFER_PIXELS;
    public const int PRESERVED_CONTENTS;
    public const int LARGEST_PBUFFER;
    public const int WIDTH;
    public const int HEIGHT;
    public const int EVENT_MASK;
    public const int DAMAGED;
    public const int SAVED;
    public const int WINDOW;
    public const int PBUFFER;
    public const int PBUFFER_HEIGHT;
    public const int PBUFFER_WIDTH;
    public const int RGBA_BIT;
    public const int COLOR_INDEX_BIT;
    public const int PBUFFER_CLOBBER_MASK;
    public const int SAMPLE_BUFFERS;
    public const int SAMPLES;
    public const int CONTEXT_MAJOR_VERSION_ARB;
    public const int CONTEXT_MINOR_VERSION_ARB;
    
    //These are technically Xlib's but whatevs
    [CCode (cname = "None")]
    public const int None;
    [CCode (cname = "True")]
    public const int True;
    [CCode (cname = "False")]
    public const int False;
    
    [CCode (cheader_filename = "GL/glxext.h",
            has_target = false,
            has_type_id = false,
            cname = "__GLXextFuncPtr")]
    public delegate void FuncPtr();
    
    [CCode (cname = "glXGetProcAddressARB")]
    public FuncPtr GetProcAddressARB(string procname);
    
    [CCode (cname = "glXChooseFBConfig")]
    public FBConfig[] ChooseFBConfig(X.Display dpy, int screen, [CCode (array_length = false)] int[] attrib_list);
    
    [CCode (cname = "glXGetVisualFromFBConfig")]
    public X.VisualInfo? GetVisualFromFBConfig(X.Display dpy, FBConfig fb);
    
    [CCode (cname = "glXMakeCurrent")]
    public bool MakeCurrent(X.Display dpy, Drawable d, Context c);
    
    [CCode (cname = "glXGetCurrentContext")]
    public Context GetCurrentContext();
    
    [CCode (cname = "glXDestroyContext")]
    public void DestroyContext(X.Display dpy, Context c);
}
