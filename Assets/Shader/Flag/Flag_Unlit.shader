// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Flag_Unlit"
{
	  Properties
    {
        _Amp ("Amplitude", Float )= 1.0
        _Speed ("Speed", Float) = 1.0
        _Frequency ("Frequency", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		Cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _Amp;
            float _Speed;
            float _Frequency;

            v2f vert (appdata v)
            {
                float xPos = v.vertex.x;
                xPos += _Time.y * _Speed;
                float sinX = sin(xPos *_Frequency)*_Amp *  (1-v.uv);
                v.vertex.y += sinX; 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 white = fixed4(1,1,1,1);
                return white;
            }
            ENDCG
        }
    }
}
