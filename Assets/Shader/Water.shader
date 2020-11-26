Shader "Custom/Water"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_DeepColor("Deep Color",Color) = (1,1,1,1)

		_Normal("Normal Map", 2D) = "bump" {}
		_NormalPower("Normal Power", Range(0,5)) = 1.0

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_NormalSpeedX("Speed NM X" , float) = 0.0
		_NormalSpeedY("Speed NM Y", float) = 0.0
		_Amp("Amplitude", Float) = 1.0
		_Speed("Speed", Float) = 1.0
		_Frequency("Frequency", Float) = 1.0

		_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		_Power("Fresnel Power", Range(0, 4)) = 1

			}
			SubShader
		{
			Tags { "RenderType" = "Transparent" "Queue"= "Transparent"}
			LOD 200
			Blend  SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows  vertex:vert addshadow alpha

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _Normal;
			struct Input
			{
				float2 uv_Normal;
				float3 worldNormal;
				float3 viewDir;
				INTERNAL_DATA
			};



			fixed4 _Color;
			fixed4 _DeepColor;
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

			float3 _FresnelColor;
			float _Power;



			void vert(inout appdata_full v )
			{
				float xPos = v.vertex.x;
				xPos -= _Time.y * _Speed;
				float sinX = sin(xPos * _Frequency) * _Amp;// *(1 - v.texcoord.x);
				v.vertex.y += sinX;

			}


			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				float2 uvNormal = IN.uv_Normal;
				float2 uvNormal2 = IN.uv_Normal/2;
				float xValNormal = _Time * _NormalSpeedX;
				float yValNormal = _Time * _NormalSpeedY;
				float xvalNormal2 = _Time * _NormalSpeedX  ;
				float yvalNormal2 = _Time * _NormalSpeedY  ;
				uvNormal += float2(xValNormal, yValNormal);
				uvNormal2 -= float2(xvalNormal2, yvalNormal2);
				
				float3 nm = UnpackScaleNormal(tex2D(_Normal,uvNormal), _NormalPower);
				float3 nm2 = UnpackScaleNormal(tex2D(_Normal,uvNormal2), _NormalPower);
				o.Normal = normalize(float3(nm.rg + nm2.rg, nm.b * nm2.b));


				float fresnel = dot(normalize(IN.viewDir), o.Normal);
				fresnel = saturate(1 - fresnel);
				fresnel = pow(fresnel, _Power);
				float3 fresnelColor = fresnel * _FresnelColor;
				float4 waterColor = lerp(_DeepColor, _Color, fresnel);
				o.Albedo = waterColor;
				//o.Albedo = fresnel;
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = 1 - fresnel;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
