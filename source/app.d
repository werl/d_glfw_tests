import std.stdio;
import std.system;

import derelict.glfw3;
import derelict.opengl3.gl3;

import init.window;
import glslloading.shader;

OS oSystem;
GLfloat[] verts = [
    -0.5f, -0.5f, 0.0f,
     0.5f, -0.5f, 0.0f,
     0.0f,  0.5f, 0.0f
];

void main()
{
    oSystem = os;  

    GLFWwindow* window = Window(3, 3, 640, 480, "My Window", "libs/libglfw.3.dylib", null).initialize();
    
    Shader vertex = new Shader("graphics/shaders/vertex/vertex.glsl", GL_VERTEX_SHADER, true);
    vertex.compileShader;
    vertex.didShaderCompile();

    Shader fragment = new Shader("graphics/shaders/fragment/shader.glsl", GL_FRAGMENT_SHADER, true);
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

    GLuint vbo, vao;
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);

    glBindVertexArray(vao);

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, verts.length * float.sizeof, verts.ptr, GL_STATIC_DRAW);
    
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
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);  

        glfwSwapBuffers(window);
    }
    

    glfwTerminate();
}
