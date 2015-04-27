#version 150
#extension all: warn

in vec4 vPos;

void main() {
    gl_Position = vPos;
}