!!ARBfp1.0

#기본! Fragment 1과 2를 각각 계산, 알파 혼합
ATTRIB	FragColor = fragment.color.primary;
ATTRIB	FragColorSec = fragment.color.secondary;
ATTRIB	TexCoord0 = fragment.texcoord[0];
ATTRIB	TexCoord1 = fragment.texcoord[1];
PARAM	TexEnv	  = state.texenv[1].color;
OUTPUT	RST_COLOR = result.color;
TEMP	Temp, Temp1, Temp2;

TEX	Temp, TexCoord0, texture[0], 2D;
TEX	Temp1, TexCoord1, texture[1], 2D;
ADD	Temp2.xyz, FragColor, FragColorSec.r;
ADD	Temp2.w, FragColorSec.g, 0.5;
MUL	Temp2.xyz, Temp2, Temp2.w;
MUL	Temp.xyz, Temp, Temp2;
MUL	Temp1.xyz, Temp1, TexEnv;

MUL	RST_COLOR.rgb, Temp, Temp1;
MUL	RST_COLOR.a, FragColor.w, Temp.w;

END