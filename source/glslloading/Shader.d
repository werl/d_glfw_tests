module glslloading.shader;

import derelict.opengl3.gl3;

import std.stdio;
import std.file;
import std.string;

class Shader {
    char[] code;
    const char* codep;
    
    uint type;
    GLuint shaderType;
    GLuint shaderRef;

  private:
    bool discardAfterCompile;
    
  public:
    this (string filePath, uint shaderType, bool discardAfterCompile) {
        code = cast(char[])read(filePath);
        codep = toStringz(code);

        this.shaderType = shaderType;
        this.discardAfterCompile = discardAfterCompile;
    }

    void compileShader() {
        
        shaderRef = glCreateShader(shaderType);
        glShaderSource(shaderRef, 1, &codep, null);
        glCompileShader(shaderRef);
    }

    bool didShaderCompile() {
        GLint success;
        GLchar[512] infoLog;
        
        glGetShaderiv(shaderRef, GL_COMPILE_STATUS, &success);
        
        if (!success) {
            glGetShaderInfoLog(shaderRef, 512, null, infoLog.ptr);
            writeln("ERROR: Vertex shader compilation failed\n", infoLog);
            return false;
        }
        return true;
    }
}
