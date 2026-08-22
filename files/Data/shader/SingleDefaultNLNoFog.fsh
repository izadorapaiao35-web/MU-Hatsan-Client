!!ARBfp1.0

#기본! Fragment 1과 2를 각각 계산, 알파 혼합
ATTRIB	FragColor = fragment.color.primary;
ATTRIB	TexCoord0 = fragment.texcoord[0];
OUTPUT	RST_COLOR = result.color;
TEMP	Temp;

TEX	Temp, TexCoord0, texture[0], 2D;
MUL	RST_COLOR, Temp, FragColor;
END
