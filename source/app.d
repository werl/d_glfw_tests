import std.stdio;
import std.getopt;

import derelict.glfw3;
import derelict.opengl3.gl3;

import dglsl;

import init.window;
import loading.shader;
import shaders.test;
import helpers.camera;

GLfloat[] verts = [
     0.5f, 0.5f, 0.5f,  // Front Top Right
     0.5f,-0.5f, 0.5f,  // Front Bottom Right
    -0.5f,-0.5f, 0.5f,  // Front Bottom Left
    -0.5f, 0.5f, 0.5f,  // Front Top Left
     0.5f, 0.5f,-0.5f,  //  Back Top Right
     0.5f,-0.5f,-0.5f,  //  Back Bottom Right
    -0.5f,-0.5f,-0.5f,  //  Back Bottom Left
    -0.5f, 0.5f,-0.5f   //  Back Top Left

];
GLuint[] indicies = [
    0, 1, 3, //front top
    1, 2, 3, //front bottom
    0, 5, 1, //right bottom
    0, 4, 5, //right top
    4, 6, 5, //back bottom
    4, 7, 6, //back top
    3, 6, 2, //left bottom
    3, 7, 6  //left top
];

string libGLFWPath = "lib/";

static Camera cam = Camera;

void main(string[] args)
{
    getopt(args, 
          "glfw",     &libGLFWPath);

    GLFWwindow* window = Window(3, 3, 640, 480, "My Window", libGLFWPath ~ "libglfw.3.dylib", null).initialize();
    
    auto vert = new VertShader();
    vert.compile();

    auto frag = new FragShader();
    frag.compile();

    auto program1 = makeProgram(vert, frag);

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

        glUseProgram(program1.id);
        glBindVertexArray(vao);
        //glDrawArrays(GL_TRIANGLES, 0, 3);
        glDrawElements(GL_TRIANGLES, 24, GL_UNSIGNED_INT, cast(GLvoid*)0);
        glBindVertexArray(0);  

        glfwSwapBuffers(window);
    }


    glfwTerminate();
}
