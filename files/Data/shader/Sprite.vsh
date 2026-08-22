!!ARBvp1.0

PARAM Mvp[4] = { state.matrix.mvp };

#MVP반영
DP4 result.position.x, vertex.position, Mvp[0];
DP4 result.position.y, vertex.position, Mvp[1];
DP4 result.position.z, vertex.position, Mvp[2];
DP4 result.position.w, vertex.position, Mvp[3];

#컬러, 텍스쳐 적용
MOV result.texcoord, vertex.texcoord;
MOV result.color, vertex.color;
END
