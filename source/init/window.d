module init.window;

import std.stdio;

import derelict.glfw3;
import derelict.opengl3.gl3;

struct Window {

  private:
    bool initialized;

    byte        oglMajor;
    byte        oglMinor;
    int         windowXSize;
    int         windowYSize;
    string      windowTitle;

    string      glfwPath;
    string      glPath;

    GLFWwindow* window;

  public:
    this(byte oglMajor, byte oglMinor, int windowXSize, int windowYSize, string windowTitle) {
        this(oglMajor, oglMinor, windowXSize, windowYSize, windowTitle, null, null);
    }

    this(byte oglMajor, byte oglMinor, int windowXSize, int windowYSize, string windowTitle, string glfwPath, string glPath) {
        this.oglMajor =     oglMajor;
        this.oglMinor =     oglMinor;
        this.windowXSize =  windowXSize;
        this.windowYSize =  windowYSize;
        this.windowTitle =  windowTitle;
        this.glfwPath =     glfwPath;
        this.glPath =       glPath;
    }

    GLFWwindow* initialize() {
        writeln("Loading OpenGL 1.x...");
        if (glPath == null)
            DerelictGL3.load();
        else
            DerelictGL3.load(glPath);
    
        writeln("Loading GLFW3...");
        if (glfwPath == null)
            DerelictGLFW3.load();
        else
            DerelictGLFW3.load(glfwPath);

        if(!glfwInit()) {
            throw new Exception("GLFW initialization exception");
        }
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, oglMajor); // We want OpenGL 3.3
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, oglMinor);
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // To make MacOS happy; should not be needed
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); //We don't want the old OpenGL 
    
        window = glfwCreateWindow(windowXSize, windowYSize, windowTitle.ptr, null, null);

        if (!window) {
            writeln("failed to create window");
            glfwTerminate();
            throw new Exception("GLFW window creation exception");
        }

        glfwMakeContextCurrent(window);
    
        writeln("Reloading OpenGL...");
        DerelictGL3.reload();

        int width, height;
        glfwGetFramebufferSize(window, &width, &height);  

        return window;
    }
}
