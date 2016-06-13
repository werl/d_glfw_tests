import std.stdio;
import std.system;
import std.getopt;

import derelict.glfw3;
import derelict.opengl3.gl3;

import init.window;
import loading.shader;

OS oSystem;
GLfloat[] verts = [
     0.5f,  0.5f, 0.0f,  // Top Right
     0.5f, -0.5f, 0.0f,  // Bottom Right
    -0.5f, -0.5f, 0.0f,  // Bottom Left
    -0.5f,  0.5f, 0.0f   // Top Left 
];
GLuint[] indicies = [
    0, 1, 3,
    1, 2, 3
];

string vertShaderPath = "graphics/shaders/vertex/";
string fragShaderPath = "graphics/shaders/fragment/";
string libGLFWPath = "libs/";

void main(string[] args)
{
    getopt(args, 
          "vertex",   &vertShaderPath, 
          "fragment", &fragShaderPath,
          "glfw",     &libGLFWPath);

    oSystem = os;  

    GLFWwindow* window = Window(3, 3, 640, 480, "My Window", libGLFWPath ~ "libglfw.3.dylib", null).initialize();
    
    Shader vertex = new Shader(vertShaderPath ~ "vertex.glsl", GL_VERTEX_SHADER, true);
    vertex.compileShader;
    vertex.didShaderCompile();

    Shader fragment = new Shader(fragShaderPath ~ "shader.glsl", GL_FRAGMENT_SHADER, true);
    fragment.compileShader;
    fragment.didShaderCompile();

    GLuint program;
    program = glCreateProgram();
    glAttachShader(program, vertex.shaderRef);
    glAttachShader(program, fragment.shaderRef);
    glLinkProgram(program);

    GLint success;
    GLchar[512] infoLog;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(program, 512, null, infoLog.ptr);
        writeln("Program Error");
    }

    glDeleteShader(vertex.shaderRef);
    glDeleteShader(fragment.shaderRef);

    GLuint vbo, vao, ebo;
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);

    glBindVertexArray(vao);

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, verts.length * float.sizeof, verts.ptr, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indicies.length * int.sizeof, indicies.ptr, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * float.sizeof, cast(GLvoid*)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glBindVertexArray(0);
    
    while (!glfwWindowShouldClose (window)) {
        glfwPollEvents();
      
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glUseProgram(program);
        glBindVertexArray(vao);
        //glDrawArrays(GL_TRIANGLES, 0, 3);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(GLvoid*)0);
        glBindVertexArray(0);  

        glfwSwapBuffers(window);
    }
    

    glfwTerminate();
}
