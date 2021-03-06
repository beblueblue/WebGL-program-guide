attribute vec4 a_Position;
attribute vec2 a_TexCoord;
 
uniform mat4 u_Matrix;
 
varying vec2 v_Texcoord;
 
void main() {
   gl_Position = u_Matrix * a_Position;
   v_Texcoord = a_TexCoord;
}