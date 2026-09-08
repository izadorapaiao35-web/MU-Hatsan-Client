!!ARBfp1.0

#기본! Fragment 1과 2를 각각 계산, 알파 혼합
OPTION	ARB_fog_linear;
ATTRIB	FragColor = fragment.color.primary;
ATTRIB	FragColorSec = fragment.color.secondary;
ATTRIB	TexCoord0 = fragment.texcoord[0];
OUTPUT	RST_COLOR = result.color;

TEMP	Temp, Temp1;

TEX	Temp, TexCoord0, texture[0], 2D;
ADD	Temp1.xyz, FragColor, FragColorSec.r;
ADD	Temp1.w, FragColorSec.g, 0.4;
MUL	Temp1.xyz, Temp1, Temp1.w;
MUL RST_COLOR.rgb, Temp, Temp1;
MUL RST_COLOR.a, FragColor.a, Temp.w;

END
