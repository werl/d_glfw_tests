module shaders.test;

import dglsl;
import derelict.opengl3.gl3;

class VertShader : Shader!Vertex {
    @layout(location=0)
    @input vec3 position;

    void main() {
        gl_Position = vec4(position, 1.0);
    }
}

class FragShader : Shader!Fragment {
    @output vec4 color;

    void main() {
        color = vec4(1.0f, 0.4f, 0.0f, 1.0f);
    }
}
