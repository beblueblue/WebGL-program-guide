<template>
    <div>
        <canvas ref="myCanvas" width="300" height="300"></canvas>
    </div>
</template>

<script>
import { initShaders, getWebGLContext } from '@/utils/cuon-utils'
import { Matrix4 } from '@/utils/cuon-matrix'
import fGlsl from './MatrixF.glsl';
import vGlsl from './MatrixV.glsl';

export default {
    name: 'TranslatedAndRotated',
    mounted(){
        const canvas = this.$refs.myCanvas
        const gl = getWebGLContext(canvas)

        if(!gl) {
            console.log('获取webGL对象失败')
            return false
        }

        if(!initShaders(gl, vGlsl, fGlsl)) {
            console.log('初始化着色器失败')
            return false
        }

        // 设置顶点位置
        const n = this.initVertexBuffers(gl);
        if(n < 0){
            console.log('设置顶点位置失败')
            return false
        }

        const ANGLE = 60
        const Tx = 0.5

        // 注意WebGL中矩阵是列主序的
        const xformMatrix = new Matrix4()
        xformMatrix.setTranslate(Tx, 0, 0)
        xformMatrix.rotate(ANGLE, 0.0, 0.0, 1.0)
        // 将旋转矩阵传输给顶点着色器
        const u_ModelMatrix = gl.getUniformLocation(gl.program, 'u_ModelMatrix')
        if(!u_ModelMatrix) {
            console.log('获取“u_ModelMatrix”的存储位置失败')
            return false
        }
        gl.uniformMatrix4fv(u_ModelMatrix, false, xformMatrix.elements)
        
        // 设置背景色
        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT);


        // 绘制一个点
        // n为3，绘制需要3个点
        gl.drawArrays(gl.TRIANGLES, 0, n);
    },
    methods: {
        initVertexBuffers(gl) {
            // 顶点坐标
            const vertics = new Float32Array([
                0.0, 0.3,
                -0.3, -0.3,
                0.3, -0.3
            ])
            // 点的个数
            const n = 3

            // 创建缓冲区对象
            const vertextBuffer = gl.createBuffer()
            if(!vertextBuffer) {
                console.log('创建缓冲区对象失败')
                return -1
            }

            // 将缓冲区对象绑定到目标
            gl.bindBuffer(gl.ARRAY_BUFFER, vertextBuffer)

            // 想缓冲区对象写入数据
            // gl.STATIC_DRAW: 写入一次，绘制多次
            gl.bufferData(gl.ARRAY_BUFFER, vertics, gl.STATIC_DRAW)

            const a_Position = gl.getAttribLocation(gl.program, 'a_Position')
            if(a_Position < 0) {
                console.log('获取“a_Position”的存储位置失败')
                return false
            }

            // 将缓存区对象分配给attribute变量（a_Position）
            gl.vertexAttribPointer(a_Position, 2, gl.FLOAT, false, 0, 0)

            // 连接a_Position变量和分配给它的缓冲区对象
            gl.enableVertexAttribArray(a_Position)

            return n
        }
    }
}
</script>
        