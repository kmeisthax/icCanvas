#version 130 core
#extension all: warn

in vec4 vPos;

void main() {
    gl_Position = vPos;
};