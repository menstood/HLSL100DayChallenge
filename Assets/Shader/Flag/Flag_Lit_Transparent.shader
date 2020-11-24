Shader "Custom/Flag_Lit_Transparent"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Normal ("Normal Map", 2D) = "bump" {}
        _NormalPower("Normal Power", Range(0,5)) = 1.0
        _Amp ("Amplitude", Float )= 1.0
        _Speed ("Speed", Float) = 1.0
        _Frequency ("Frequency", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "Queue"="Transparent" }
        LOD 200
        // Cull off
      ZWrite Off
Blend SrcAlpha OneMinusSrcAlpha
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow alpha


        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
        };

        float _Amp;
        float _Speed;
        float _Frequency;
        float _NormalPower;
        fixed4 _Color;

        void vert (inout appdata_full v)
            {
                float xPos = v.vertex.x;
                xPos -= _Time.y * _Speed;
                float sinX = sin(xPos *_Frequency)*_Amp *  (1-v.texcoord.x);
                v.vertex.y += sinX; 
            }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex) * _Color;
          o.Alpha = _Color.w;
            //o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            o.Normal = UnpackScaleNormal(tex2D(_Normal, IN.uv_Normal), _NormalPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
