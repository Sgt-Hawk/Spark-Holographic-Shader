// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sgt Hawk/Spark Holographic"
{
	Properties
	{
		[Toggle(_3DTEXTURESPACE_ON)] _3DTextureSpace("3D Texture Space", Float) = 0
		_Color1("Color", Color) = (1,1,1,1)
		[KeywordEnum(Local,WorldSpace)] _TextureMapping1("Texture Mapping", Float) = 0
		[NoScaleOffset]_NoiseMap1("Noise Map", 2D) = "white" {}
		_Tiling1("Tiling", Vector) = (1,1,1,0)
		_ScrollSpeed1("Scroll Speed", Vector) = (0,0,0,0)
		[Toggle(_INVERTNOISEMAP1_ON)] _InvertNoiseMap1("Invert Noise Map", Float) = 0
		_Opacity1("Opacity", Range( 0 , 1)) = 0.5
		_3DMappingBlending1("3D Mapping Blending", Range( 0 , 5)) = 0
		[Header(Fresnel)]_FresnelBias1("Fresnel Bias", Range( -1 , 1)) = 0
		_FresnelScale1("Fresnel Scale", Range( 0 , 10)) = 1
		_FresnelPower1("Fresnel Power", Range( 0 , 10)) = 1
		[Toggle(_INVERTFRESNEL1_ON)] _InvertFresnel1("Invert Fresnel", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _INVERTNOISEMAP1_ON
		#pragma shader_feature_local _3DTEXTURESPACE_ON
		#pragma shader_feature_local _TEXTUREMAPPING1_LOCAL _TEXTUREMAPPING1_WORLDSPACE
		#pragma shader_feature_local _INVERTFRESNEL1_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _Color1;
		uniform sampler2D _NoiseMap1;
		uniform float3 _ScrollSpeed1;
		uniform float3 _Tiling1;
		uniform float _3DMappingBlending1;
		uniform float _FresnelBias1;
		uniform float _FresnelScale1;
		uniform float _FresnelPower1;
		uniform float _Opacity1;


		inline float4 TriplanarSampling640( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			#if defined(_TEXTUREMAPPING1_LOCAL)
				float3 staticSwitch596 = float3( i.uv_texcoord ,  0.0 );
			#elif defined(_TEXTUREMAPPING1_WORLDSPACE)
				float3 staticSwitch596 = ase_worldPos;
			#else
				float3 staticSwitch596 = float3( i.uv_texcoord ,  0.0 );
			#endif
			float3 temp_output_612_0 = ( ( ( _Time.y * _ScrollSpeed1 ) + staticSwitch596 ) * _Tiling1 );
			float3 break617 = temp_output_612_0;
			float2 appendResult618 = (float2(break617.x , break617.y));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar640 = TriplanarSampling640( _NoiseMap1, temp_output_612_0, ase_worldNormal, _3DMappingBlending1, float2( 1,1 ), 1.0, 0 );
			#ifdef _3DTEXTURESPACE_ON
				float4 staticSwitch662 = triplanar640;
			#else
				float4 staticSwitch662 = tex2D( _NoiseMap1, appendResult618 );
			#endif
			#ifdef _INVERTNOISEMAP1_ON
				float4 staticSwitch687 = (float4( 1,1,1,1 ) + (staticSwitch662 - float4( 0,0,0,0 )) * (float4( 0,0,0,0 ) - float4( 1,1,1,1 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
			#else
				float4 staticSwitch687 = staticSwitch662;
			#endif
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV663 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode663 = ( _FresnelBias1 + _FresnelScale1 * pow( 1.0 - fresnelNdotV663, _FresnelPower1 ) );
			#ifdef _INVERTFRESNEL1_ON
				float staticSwitch690 = (1.0 + (fresnelNode663 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
			#else
				float staticSwitch690 = fresnelNode663;
			#endif
			float4 clampResult444 = clamp( ( _Color1 * staticSwitch687 * staticSwitch690 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Emission = clampResult444.rgb;
			float clampResult445 = clamp( ( fresnelNode663 + _Opacity1 ) , 0.0 , 1.0 );
			o.Alpha = clampResult445;
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xbox360 xboxone xboxseries ps4 playstation psp2 n3ds wiiu switch 
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18933
1920;0;1920;1059;2810.449;746.03;1.923859;True;False
Node;AmplifyShaderEditor.CommentaryNode;592;-1792,0;Inherit;False;1714.078;857.5959;Primary Shader Section;54;1051;1050;727;729;723;885;884;714;710;968;967;950;949;879;948;685;993;995;992;947;878;994;662;677;653;652;671;881;666;650;651;880;649;648;665;646;647;620;632;619;630;628;626;623;622;668;833;654;633;608;603;593;444;445;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;756;-2032,0;Inherit;False;194.9436;446.7136;Globals;3;605;450;285;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;603;-1792,32;Inherit;False;258.5672;238.3799;Texture Scrolling;2;609;606;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;593;-1792,272;Inherit;False;238.8581;157.0836;Worldspace Texture Toggle;1;596;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;285;-2016,304;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;606;-1792,128;Inherit;False;Property;_ScrollSpeed1;Scroll Speed;5;0;Create;False;0;0;0;False;0;False;0,0,0;0,-0.01,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;605;-2016,48;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;450;-2016,192;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;608;-1488,32;Inherit;False;372.585;254.8798;Texture Tiling;9;618;616;615;617;612;611;610;614;613;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;596;-1776,320;Inherit;False;Property;_TextureMapping1;Texture Mapping;2;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Local;WorldSpace;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;-1648,64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;610;-1488,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;611;-1488,144;Inherit;False;Property;_Tiling1;Tiling;4;0;Create;False;0;0;0;False;0;False;1,1,1;40,40,40;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;612;-1344,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;613;-1216,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;622;-1024,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;614;-1216,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;623;-1024,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;615;-1344,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;626;-1024,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;654;-1792,448;Inherit;False;478.9539;405.342;Fresnel Adjustments;10;663;690;684;681;659;661;657;683;882;883;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;661;-1792,656;Inherit;False;Property;_FresnelBias1;Fresnel Bias;9;1;[Header];Create;False;1;Fresnel;0;0;False;0;False;0;0.06;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;659;-1792,720;Inherit;False;Property;_FresnelScale1;Fresnel Scale;10;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;657;-1792,784;Inherit;False;Property;_FresnelPower1;Fresnel Power;11;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;616;-1344,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;628;-1024,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;617;-1344,176;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FresnelNode;663;-1536,656;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;630;-1072,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;633;-1280,336;Inherit;False;620.3584;403.5196;Noise Map Texture Slot;10;946;945;642;641;639;635;645;640;637;636;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;618;-1232,192;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;632;-1072,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;665;-1344,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;635;-1072,608;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;880;-1344,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;619;-1056,224;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;666;-1344,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;620;-1056,224;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;639;-1072,608;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;671;-1344,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;881;-1344,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;636;-1280,368;Inherit;True;Property;_NoiseMap1;Noise Map;3;1;[NoScaleOffset];Create;False;1;ZONE 1;0;0;False;0;False;None;49d382e00cbb0944f996da624ecd24ce;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;637;-1280,656;Inherit;False;Property;_3DMappingBlending1;3D Mapping Blending;8;0;Create;False;0;0;0;False;0;False;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;640;-1024,560;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;1;None;Bot Texture 2;_BotTexture2;white;0;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;641;-1056,432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;883;-1776,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;677;-1344,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;945;-704,528;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;882;-1776,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;681;-1600,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;642;-1056,432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;946;-704,528;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;645;-1024,368;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;683;-1760,480;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;684;-1600,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;690;-1568,480;Inherit;False;Property;_InvertFresnel1;Invert Fresnel;12;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;646;-752,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;647;-704,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;947;-1312,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;648;-704,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;649;-752,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;878;-1344,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;651;-992,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;948;-1312,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;879;-1344,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;650;-976,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;653;-976,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;652;-992,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;884;-640,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;949;-1312,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;885;-640,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;833;-640,352;Inherit;False;269.0352;182.5404;Opacity;6;847;840;887;886;888;889;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;950;-1312,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;685;-912,32;Inherit;False;Property;_Color1;Color;1;0;Create;False;0;0;0;False;0;False;1,1,1,1;0,0.1812606,0.9834351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;662;-944,208;Inherit;False;Property;_3DTextureSpace;3D Texture Space;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;992;-720,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;710;-368,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;967;-672,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;886;-640,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;968;-672,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;993;-720,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;714;-368,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;887;-640,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;668;-640,64;Inherit;False;226.8051;287.4847;Invert Noise Map;2;687;679;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;994;-720,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;995;-720,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1050;-368,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;889;-496,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;679;-592,192;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;1,1,1,1;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;723;-368,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;687;-640,96;Inherit;False;Property;_InvertNoiseMap1;Invert Noise Map;6;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;729;-368,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;888;-496,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;840;-624,464;Inherit;False;Property;_Opacity1;Opacity;7;0;Create;False;1;Zone 1 Opacity;0;0;False;0;False;0.5;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1051;-368,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;847;-480,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;727;-336,48;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StickyNoteNode;1002;-1792,-560;Inherit;False;767.3728;543.0582;;Spark Holographic Shader by Sgt. Hawk;0,0.6330502,1,1;MIT License$$Copyright (c) 2021 "Sgt. Hawk"$$Permission is hereby granted, free of charge, to any person obtaining a copy$of this software and associated documentation files (the "Software"), to deal$in the Software without restriction, including without limitation the rights$to use, copy, modify, merge, publish, distribute, sublicense, and/or sell$copies of the Software, and to permit persons to whom the Software is$furnished to do so, subject to the following conditions:$$The above copyright notice and this permission notice shall be included in all$copies or substantial portions of the Software.$$THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR$IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,$FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE$AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER$LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,$OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE$SOFTWARE.;0;0
Node;AmplifyShaderEditor.ClampOpNode;445;-208,192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;444;-208,48;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sgt Hawk/Spark Holographic;False;False;False;False;False;False;False;False;False;False;False;True;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;9;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;nomrt;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;1;False;-1;1;False;-1;0;False;1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;596;1;450;0
WireConnection;596;0;285;0
WireConnection;609;0;605;2
WireConnection;609;1;606;0
WireConnection;610;0;609;0
WireConnection;610;1;596;0
WireConnection;612;0;610;0
WireConnection;612;1;611;0
WireConnection;613;0;612;0
WireConnection;622;0;612;0
WireConnection;614;0;613;0
WireConnection;623;0;622;0
WireConnection;615;0;614;0
WireConnection;626;0;623;0
WireConnection;616;0;615;0
WireConnection;628;0;626;0
WireConnection;617;0;616;0
WireConnection;663;1;661;0
WireConnection;663;2;659;0
WireConnection;663;3;657;0
WireConnection;630;0;628;0
WireConnection;618;0;617;0
WireConnection;618;1;617;1
WireConnection;632;0;630;0
WireConnection;665;0;663;0
WireConnection;635;0;632;0
WireConnection;880;0;663;0
WireConnection;619;0;618;0
WireConnection;666;0;665;0
WireConnection;620;0;619;0
WireConnection;639;0;635;0
WireConnection;671;0;666;0
WireConnection;881;0;880;0
WireConnection;640;0;636;0
WireConnection;640;9;639;0
WireConnection;640;4;637;0
WireConnection;641;0;620;0
WireConnection;883;0;881;0
WireConnection;677;0;671;0
WireConnection;945;0;640;0
WireConnection;882;0;883;0
WireConnection;681;0;677;0
WireConnection;642;0;641;0
WireConnection;946;0;945;0
WireConnection;645;0;636;0
WireConnection;645;1;642;0
WireConnection;683;0;882;0
WireConnection;684;0;681;0
WireConnection;690;1;684;0
WireConnection;690;0;683;0
WireConnection;646;0;645;0
WireConnection;647;0;946;0
WireConnection;947;0;690;0
WireConnection;648;0;647;0
WireConnection;649;0;646;0
WireConnection;878;0;663;0
WireConnection;651;0;649;0
WireConnection;948;0;947;0
WireConnection;879;0;878;0
WireConnection;650;0;648;0
WireConnection;653;0;650;0
WireConnection;652;0;651;0
WireConnection;884;0;879;0
WireConnection;949;0;948;0
WireConnection;885;0;884;0
WireConnection;950;0;949;0
WireConnection;662;1;652;0
WireConnection;662;0;653;0
WireConnection;992;0;662;0
WireConnection;710;0;950;0
WireConnection;967;0;685;0
WireConnection;886;0;885;0
WireConnection;968;0;967;0
WireConnection;993;0;992;0
WireConnection;714;0;710;0
WireConnection;887;0;886;0
WireConnection;994;0;662;0
WireConnection;995;0;994;0
WireConnection;1050;0;968;0
WireConnection;889;0;887;0
WireConnection;679;0;993;0
WireConnection;723;0;714;0
WireConnection;687;1;995;0
WireConnection;687;0;679;0
WireConnection;729;0;723;0
WireConnection;888;0;889;0
WireConnection;1051;0;1050;0
WireConnection;847;0;888;0
WireConnection;847;1;840;0
WireConnection;727;0;1051;0
WireConnection;727;1;687;0
WireConnection;727;2;729;0
WireConnection;445;0;847;0
WireConnection;444;0;727;0
WireConnection;0;2;444;0
WireConnection;0;9;445;0
ASEEND*/
//CHKSM=9946065BE2C9FB6CC4C7723AEE87600F39165908