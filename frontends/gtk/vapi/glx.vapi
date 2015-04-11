[CCode (lower_case_cprefix = "GLX_",
        cheader_filename="GL/glx.h")]
namespace glX {
    [CCode (cname = "GLXContext")]
    [SimpleType]
    public struct Context {}
    
    [CCode (cname = "GLXDrawable")]
    [SimpleType]
    public struct Drawable {}
    
    [CCode (cname = "GLXFBConfig")]
    [SimpleType]
    public struct FBConfig {}
    
    public const int CONTEXT_MAJOR_VERSION_ARB;
    public const int CONTEXT_MINOR_VERSION_ARB;
    
    [CCode (cheader_filename = "GL/glxext.h",
            has_target = false,
            has_type_id = false,
            cname = "__GLXextFuncPtr")]
    public delegate void FuncPtr();
    
    [CCode (cheader_filename="GL/glx.h",
            cname = "glXGetProcAddressARB")]
    public static FuncPtr GetProcAddressARB(string procname);
}
