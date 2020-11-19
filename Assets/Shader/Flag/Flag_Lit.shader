Shader "Custom/Flag_Lit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Amp ("Amplitude", Float )= 1.0
        _Speed ("Speed", Float) = 1.0
        _Frequency ("Frequency", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float _Amp;
        float _Speed;
        float _Frequency;
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
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
