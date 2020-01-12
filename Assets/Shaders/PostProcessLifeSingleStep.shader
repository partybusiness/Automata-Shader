Shader "Unlit/PostProcessLifeSingleStep"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LiveColour("Live Colour", color) = (0,0,0,1)
		_DeadColour("Dead Colour", color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _LiveColour;
			float4 _DeadColour;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//fixed4 col = tex2D(_MainTex, i.uv).rrra>0.5;
				fixed2 dx = ddx(i.uv);
				fixed2 dy = ddy(i.uv);
				fixed4 neighbours =
					round(
						round(tex2D(_MainTex, i.uv + fixed2(dx.x, 0), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(-dx.x, 0), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(0, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(0, -dy.y), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(dx.x, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(-dx.x, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(dx.x, -dy.y), ddx(0), ddy(0))) +
						round(tex2D(_MainTex, i.uv + fixed2(-dx.x, -dy.y), ddx(0), ddy(0)))
					).rrra;
				fixed4 live = round(tex2D(_MainTex, i.uv, ddx(0), ddy(0)).rrra);
				fixed4 col = (neighbours == 3) || (live&&neighbours == 2);
				
				return lerp(_DeadColour, _LiveColour, col);
			}
			ENDCG
		}
	}
}
