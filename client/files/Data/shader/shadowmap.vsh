!!ARBvp1.0

PARAM Mvp[4] = { state.matrix.mvp };
PARAM EnvParam[196] = { program.env[0..195] };
PARAM EtcConsts = { 1.0, 0.0, 0.5, 0.0 };
PARAM Consts = { 2000, 5, -4000, 0.0 };
PARAM BodyLight = program.local[0];
PARAM BodyOrigin = program.local[5];
TEMP Temp, Temp1, Temp2;
ADDRESS Addr;

#애니메이션 계산
#위치값의 w성분은 bone index
ARL Addr.x, vertex.color.w;

#애니메이션 행렬 계산
DP4 Temp1.x, vertex.position, EnvParam[Addr.x];
DP4 Temp1.y, vertex.position, EnvParam[Addr.x+1];
DP4 Temp1.z, vertex.position, EnvParam[Addr.x+2];
MOV Temp1.w, EtcConsts.x;

#투영
SUB Temp1, Temp1, BodyOrigin;
ADD Temp2, Temp1, Consts;
RCP Temp2.z, Temp2.z;
MUL Temp2.w, Temp2.x, Temp2.z;
MAD Temp1.x, Temp1.z, Temp2.w, Temp1.x;
MOV Temp1.z, Consts.y;
ADD Temp1, Temp1, BodyOrigin;

#MVP반영
DP4 result.position.x, Temp1, Mvp[0];
DP4 result.position.y, Temp1, Mvp[1];
DP4 result.position.z, Temp1, Mvp[2];
DP4 result.position.w, Temp1, Mvp[3];

#컬러 적용
MOV result.color, BodyLight;
END
