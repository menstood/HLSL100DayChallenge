Shader "Custom/Water"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal Map", 2D) = "bump" {}
		_NormalPower("Normal Power", Range(0,5)) = 1.0

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_SpeedX("Speed X" , float) = 0.0
		_SpeedY("Speed Y", float) = 0.0

		_NormalSpeedX("Speed NM X" , float) = 0.0
		_NormalSpeedY("Speed NM Y", float) = 0.0
		_Amp("Amplitude", Float) = 1.0
		_Speed("Speed", Float) = 1.0
		_Frequency("Frequency", Float) = 1.0

	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows  vertex:vert addshadow

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _Normal;

			struct Input
			{
				float2 uv_MainTex;
				float2 uv_Normal;
			};



			fixed4 _Color;
			half _Glossiness;
			half _Metallic;
			float _SpeedX;
			float _SpeedY;

			float _NormalSpeedX;
			float _NormalSpeedY;


			float _Amp;
			float _Speed;
			float _Frequency;
			float _NormalPower;

			void vert(inout appdata_full v)
			{
				float xPos = v.vertex.x;
				xPos -= _Time.y * _Speed;
				float sinX = sin(xPos * _Frequency) * _Amp;// *(1 - v.texcoord.x);
				v.vertex.y += sinX;

			}


			void surf(Input IN, inout SurfaceOutputStandard o)
			{
	
				float2 uv = IN.uv_MainTex;
				float xVal = _Time * _SpeedX;
				float yVal = _Time * _SpeedY;
				uv += float2(xVal, yVal);
				float2 uvNormal = IN.uv_Normal;
				float2 uvNormal2 = IN.uv_Normal;
				float xValNormal = _Time * _NormalSpeedX;
				float yValNormal = _Time * _NormalSpeedY;
				float xvalNormal2 = _Time * _NormalSpeedX * 0.9;
				float yvalNormal2 = _Time * _NormalSpeedY * 0.;
				uvNormal += float2(xValNormal, yValNormal);
				uvNormal2 -= float2(xvalNormal2, yvalNormal2);
				fixed4 c = tex2D(_MainTex, uv) * _Color;
				o.Albedo = c.rgb;
				float3 nm =  UnpackScaleNormal(tex2D(_Normal,uvNormal), _NormalPower);
				float3 nm2 =  UnpackScaleNormal(tex2D(_Normal,uvNormal2), _NormalPower);

				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Normal = normalize(float3(nm.rg + nm2.rg, nm.b * nm2.b));
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
