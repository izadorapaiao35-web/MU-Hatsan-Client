!!ARBfp1.0

#기본! Fragment 1과 2를 각각 계산, 알파 혼합
ATTRIB	FragColor = fragment.color.primary;
ATTRIB	TexCoord0 = fragment.texcoord[0];
ATTRIB	TexCoord1 = fragment.texcoord[1];
PARAM	TexEnv	  = state.texenv[1].color;
OUTPUT	RST_COLOR = result.color;
TEMP	Temp, Temp1;

TEX	Temp, TexCoord1, texture[1], 2D;
MUL	RST_COLOR.rgb, TexEnv, Temp;
MUL	RST_COLOR.a, FragColor.a, Temp.w;
END