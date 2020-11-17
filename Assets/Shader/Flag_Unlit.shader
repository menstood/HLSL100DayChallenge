// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Flag_Unlit"
{
	Properties
	{
		_Gradient("GradientMap",2D) = "white"{}
		_Amount("Amount",Float) = 0.0
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100
		Cull off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"



		float _Amount;
		sampler2D _Gradient;
		 struct appdata {
			float4 vertex : POSITION;
			float4 texcoord1 : TEXCOORD1;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
			float3 color : COLOR;
		};

		 v2f vert(appdata v) {
			 v2f o;
			 v.vertex.x += _Amount;
			 o.pos = UnityObjectToClipPos(v.vertex);
			 o.uv = float4(v.texcoord1.xy, 0, 0);
			 float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			 o.color = worldPos;
		
			 return o;
		 }

		 fixed4 frag(v2f i) : SV_Target {

			 half4 r = float4(i.color.x, i.color.y, i.color.z, 0);
			 fixed4 col = tex2D(_Gradient, i.uv);
			 return col;
		 }
			 ENDCG
		 }
	}
}
