// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sgt Hawk/Spark Holographic Masked"
{
	Properties
	{
		[KeywordEnum(MaskingTexture,VertexColors)] _MaskingMethod("Masking Method", Float) = 0
		[Toggle(_3DTEXTURESPACE_ON)] _3DTextureSpace("3D Texture Space", Float) = 0
		[Header(Masking Textures are ignored if Vertex Colors are used)][Header(If masking is not needed then select Texture as masking method leaving)][Header(the mask field empty and then use Zone 1)][Header(ZONE 1)]_Color1("Color", Color) = (1,1,1,1)
		[KeywordEnum(Local,WorldSpace)] _TextureMapping1("Texture Mapping", Float) = 0
		[NoScaleOffset]_NoiseMap1("Noise Map", 2D) = "white" {}
		_Tiling1("Tiling", Vector) = (1,1,1,0)
		_ScrollSpeed1("Scroll Speed", Vector) = (0,0,0,0)
		[Toggle(_INVERTNOISEMAP1_ON)] _InvertNoiseMap1("Invert Noise Map", Float) = 0
		[NoScaleOffset]_Mask1("Mask", 2D) = "white" {}
		_Opacity1("Opacity", Range( 0 , 1)) = 0.5
		_3DMappingBlending1("3D Mapping Blending", Range( 0 , 5)) = 0
		[Header(Fresnel)]_FresnelBias1("Fresnel Bias", Range( -1 , 1)) = 0
		_FresnelScale1("Fresnel Scale", Range( 0 , 10)) = 1
		_FresnelPower1("Fresnel Power", Range( 0 , 10)) = 1
		[Toggle(_INVERTFRESNEL1_ON)] _InvertFresnel1("Invert Fresnel", Float) = 0
		[Header(ZONE 2)]_Color2("Color", Color) = (1,1,1,1)
		[KeywordEnum(Local,WorldSpace)] _TextureMapping2("Texture Mapping", Float) = 0
		[NoScaleOffset]_Texture2("Noise Map", 2D) = "white" {}
		_Tiling2("Tiling", Vector) = (1,1,1,0)
		_Scrolling2("Scroll Speed", Vector) = (0,0,0,0)
		[Toggle(_INVERTNOISEMAP2_ON)] _InvertNoiseMap2("Invert Noise Map", Float) = 0
		[Header(ZONE 2)][NoScaleOffset]_Mask2("Mask", 2D) = "black" {}
		_Opacity2("Opacity", Range( 0 , 1)) = 0
		_3DMappingFalloff2("3D Mapping Blending", Range( 0 , 5)) = 0
		[Header(Fresnel)]_FresnelBias2("Fresnel Bias", Range( -1 , 1)) = 0
		_FresnelScale2("Fresnel Scale", Range( 0 , 10)) = 1
		_FresnelPower2("Fresnel Power", Range( 0 , 10)) = 1
		[Toggle(_INVERTFRESNEL2_ON)] _InvertFresnel2("Invert Fresnel", Float) = 0
		[Header(ZONE 3)]_Color3("Color", Color) = (1,1,1,1)
		[KeywordEnum(Local,WorldSpace)] _TextureMapping3("Texture Mapping", Float) = 0
		[NoScaleOffset]_Texture3("Noise Map", 2D) = "white" {}
		_Tiling3("Tiling", Vector) = (1,1,1,0)
		_ScrollSpeed3("Scroll Speed", Vector) = (0,0,0,0)
		[Toggle(INVERTNOISEMAP3_ON)] InvertNoiseMap3("Invert Noise Map", Float) = 0
		[NoScaleOffset]_Mask3("Mask", 2D) = "black" {}
		_Opacity3("Opacity", Range( 0 , 1)) = 0
		_3DTextureFalloff3("3D Mapping Blending", Range( 0 , 5)) = 0
		[Header(Fresnel)]_FresnelBias3("Fresnel Bias", Range( -1 , 1)) = 0
		_FresnelScale3("Fresnel Scale", Range( 0 , 10)) = 1
		_FresnelPower3("Fresnel Power", Range( 0 , 10)) = 1
		[Toggle(_INVERTFRESNEL3_ON)] _InvertFresnel3("Invert Fresnel", Float) = 0
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
		#pragma shader_feature_local _MASKINGMETHOD_MASKINGTEXTURE _MASKINGMETHOD_VERTEXCOLORS
		#pragma shader_feature_local _INVERTNOISEMAP2_ON
		#pragma shader_feature_local _TEXTUREMAPPING2_LOCAL _TEXTUREMAPPING2_WORLDSPACE
		#pragma shader_feature_local _INVERTFRESNEL2_ON
		#pragma shader_feature_local INVERTNOISEMAP3_ON
		#pragma shader_feature_local _TEXTUREMAPPING3_LOCAL _TEXTUREMAPPING3_WORLDSPACE
		#pragma shader_feature_local _INVERTFRESNEL3_ON
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
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color1;
		uniform sampler2D _NoiseMap1;
		uniform float3 _ScrollSpeed1;
		uniform float3 _Tiling1;
		uniform float _3DMappingBlending1;
		uniform float _FresnelBias1;
		uniform float _FresnelScale1;
		uniform float _FresnelPower1;
		uniform sampler2D _Mask1;
		uniform float4 _Color2;
		uniform sampler2D _Texture2;
		uniform float3 _Scrolling2;
		uniform float3 _Tiling2;
		uniform float _3DMappingFalloff2;
		uniform float _FresnelBias2;
		uniform float _FresnelScale2;
		uniform float _FresnelPower2;
		uniform sampler2D _Mask2;
		uniform float4 _Color3;
		uniform sampler2D _Texture3;
		uniform float3 _ScrollSpeed3;
		uniform float3 _Tiling3;
		uniform float _3DTextureFalloff3;
		uniform sampler2D _Mask3;
		uniform float _FresnelBias3;
		uniform float _FresnelScale3;
		uniform float _FresnelPower3;
		uniform float _Opacity1;
		uniform float _Opacity2;
		uniform float _Opacity3;


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


		inline float4 TriplanarSampling495( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling281( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float Time750 = _Time.y;
			float2 VertexCoord751 = i.uv_texcoord;
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos752 = ase_worldPos;
			#if defined(_TEXTUREMAPPING1_LOCAL)
				float3 staticSwitch596 = float3( VertexCoord751 ,  0.0 );
			#elif defined(_TEXTUREMAPPING1_WORLDSPACE)
				float3 staticSwitch596 = WorldPos752;
			#else
				float3 staticSwitch596 = float3( VertexCoord751 ,  0.0 );
			#endif
			float3 temp_output_612_0 = ( ( ( Time750 * _ScrollSpeed1 ) + staticSwitch596 ) * _Tiling1 );
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
			float2 uv_Mask1674 = i.uv_texcoord;
			float VtxColR753 = i.vertexColor.r;
			float4 temp_cast_3 = (VtxColR753).xxxx;
			#if defined(_MASKINGMETHOD_MASKINGTEXTURE)
				float4 staticSwitch703 = tex2D( _Mask1, uv_Mask1674 );
			#elif defined(_MASKINGMETHOD_VERTEXCOLORS)
				float4 staticSwitch703 = temp_cast_3;
			#else
				float4 staticSwitch703 = tex2D( _Mask1, uv_Mask1674 );
			#endif
			#if defined(_TEXTUREMAPPING2_LOCAL)
				float3 staticSwitch451 = float3( VertexCoord751 ,  0.0 );
			#elif defined(_TEXTUREMAPPING2_WORLDSPACE)
				float3 staticSwitch451 = WorldPos752;
			#else
				float3 staticSwitch451 = float3( VertexCoord751 ,  0.0 );
			#endif
			float3 temp_output_467_0 = ( ( ( Time750 * _Scrolling2 ) + staticSwitch451 ) * _Tiling2 );
			float3 break472 = temp_output_467_0;
			float2 appendResult473 = (float2(break472.x , break472.y));
			float4 triplanar495 = TriplanarSampling495( _Texture2, temp_output_467_0, ase_worldNormal, _3DMappingFalloff2, float2( 1,1 ), 1.0, 0 );
			#ifdef _3DTEXTURESPACE_ON
				float4 staticSwitch517 = triplanar495;
			#else
				float4 staticSwitch517 = tex2D( _Texture2, appendResult473 );
			#endif
			#ifdef _INVERTNOISEMAP2_ON
				float4 staticSwitch542 = (float4( 1,1,1,1 ) + (staticSwitch517 - float4( 0,0,0,0 )) * (float4( 0,0,0,0 ) - float4( 1,1,1,1 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
			#else
				float4 staticSwitch542 = staticSwitch517;
			#endif
			float fresnelNdotV518 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode518 = ( _FresnelBias2 + _FresnelScale2 * pow( 1.0 - fresnelNdotV518, _FresnelPower2 ) );
			#ifdef _INVERTFRESNEL2_ON
				float staticSwitch545 = (1.0 + (fresnelNode518 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
			#else
				float staticSwitch545 = fresnelNode518;
			#endif
			float2 uv_Mask2529 = i.uv_texcoord;
			float VtxColG754 = i.vertexColor.g;
			float4 temp_cast_7 = (VtxColG754).xxxx;
			#if defined(_MASKINGMETHOD_MASKINGTEXTURE)
				float4 staticSwitch558 = tex2D( _Mask2, uv_Mask2529 );
			#elif defined(_MASKINGMETHOD_VERTEXCOLORS)
				float4 staticSwitch558 = temp_cast_7;
			#else
				float4 staticSwitch558 = tex2D( _Mask2, uv_Mask2529 );
			#endif
			#if defined(_TEXTUREMAPPING3_LOCAL)
				float3 staticSwitch286 = float3( VertexCoord751 ,  0.0 );
			#elif defined(_TEXTUREMAPPING3_WORLDSPACE)
				float3 staticSwitch286 = WorldPos752;
			#else
				float3 staticSwitch286 = float3( VertexCoord751 ,  0.0 );
			#endif
			float3 temp_output_276_0 = ( ( ( Time750 * _ScrollSpeed3 ) + staticSwitch286 ) * _Tiling3 );
			float3 break277 = temp_output_276_0;
			float2 appendResult279 = (float2(break277.x , break277.y));
			float4 triplanar281 = TriplanarSampling281( _Texture3, temp_output_276_0, ase_worldNormal, _3DTextureFalloff3, float2( 1,1 ), 1.0, 0 );
			#ifdef _3DTEXTURESPACE_ON
				float4 staticSwitch283 = triplanar281;
			#else
				float4 staticSwitch283 = tex2D( _Texture3, appendResult279 );
			#endif
			#ifdef INVERTNOISEMAP3_ON
				float4 staticSwitch225 = (float4( 1,1,1,1 ) + (staticSwitch283 - float4( 0,0,0,0 )) * (float4( 0,0,0,0 ) - float4( 1,1,1,1 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
			#else
				float4 staticSwitch225 = staticSwitch283;
			#endif
			float2 uv_Mask3224 = i.uv_texcoord;
			float VtxColB755 = i.vertexColor.b;
			float4 temp_cast_11 = (VtxColB755).xxxx;
			#if defined(_MASKINGMETHOD_MASKINGTEXTURE)
				float4 staticSwitch395 = tex2D( _Mask3, uv_Mask3224 );
			#elif defined(_MASKINGMETHOD_VERTEXCOLORS)
				float4 staticSwitch395 = temp_cast_11;
			#else
				float4 staticSwitch395 = tex2D( _Mask3, uv_Mask3224 );
			#endif
			float fresnelNdotV213 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode213 = ( _FresnelBias3 + _FresnelScale3 * pow( 1.0 - fresnelNdotV213, _FresnelPower3 ) );
			#ifdef _INVERTFRESNEL3_ON
				float staticSwitch234 = (1.0 + (fresnelNode213 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
			#else
				float staticSwitch234 = fresnelNode213;
			#endif
			float4 clampResult444 = clamp( ( ( _Color1 * staticSwitch687 * staticSwitch690 * staticSwitch703 ) + ( _Color2 * staticSwitch542 * staticSwitch545 * staticSwitch558 ) + ( _Color3 * staticSwitch225 * staticSwitch395 * staticSwitch234 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Emission = clampResult444.rgb;
			float4 clampResult895 = clamp( ( staticSwitch703 * ( _Opacity1 + fresnelNode663 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 clampResult890 = clamp( ( staticSwitch558 * ( _Opacity2 + fresnelNode518 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 clampResult896 = clamp( ( staticSwitch395 * ( _Opacity3 + fresnelNode213 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 clampResult445 = clamp( ( clampResult895 + clampResult890 + clampResult896 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Alpha = clampResult445.r;
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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
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
1921;2;995;1055;3795.21;1752.393;3.490252;True;False
Node;AmplifyShaderEditor.CommentaryNode;756;-128,-768;Inherit;False;383.8232;637.7136;Globals;10;753;755;754;551;750;605;752;751;450;285;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;285;-112,-464;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;447;-2688,0;Inherit;False;1918.277;862.3271;Zone Specific Noisemap Settings;66;989;988;987;986;985;984;964;963;903;904;540;517;505;508;515;511;502;503;831;832;906;905;582;571;579;578;584;506;507;513;510;481;483;477;478;475;474;459;462;958;957;956;955;560;556;487;485;501;504;913;912;918;917;589;523;568;522;509;488;463;458;448;812;810;1044;1045;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;450;-112,-576;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;592;-2688,-896;Inherit;False;1918.699;862.7114;Zone Specific Noisemap Settings;74;995;994;993;992;991;990;648;647;662;968;967;942;941;685;651;652;655;658;660;656;653;650;710;714;885;884;724;716;729;723;887;886;727;944;943;619;620;628;626;623;622;950;671;677;665;666;880;881;879;878;607;604;962;961;960;959;649;646;632;630;949;948;947;732;833;668;667;654;633;608;603;593;1022;1020;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;312;-2688,896;Inherit;False;1918.32;863.6728;Zone Specific Noisemap Settings;68;1001;1000;999;998;997;996;972;971;875;874;974;973;219;435;436;434;432;981;980;413;414;976;978;977;975;220;283;347;344;345;346;352;349;348;354;440;439;438;437;365;366;340;339;353;341;368;367;325;326;324;323;336;335;327;328;321;322;378;849;309;397;304;310;294;288;287;1027;1024;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;287;-2688,1168;Inherit;False;386.9167;164.2441;Worldspace Texture Toggle;5;314;313;286;765;764;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;593;-2688,-624;Inherit;False;392.6386;165.1773;Worldspace Texture Toggle;5;597;598;596;760;761;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;448;-2688,272;Inherit;False;390.5234;163.1754;Worldspace Texture Toggle;5;452;453;451;758;759;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;751;64,-576;Inherit;False;VertexCoord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;752;64,-464;Inherit;False;WorldPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;764;-2688,1200;Inherit;False;751;VertexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;765;-2688,1264;Inherit;False;752;WorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;760;-2688,-528;Inherit;False;752;WorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;759;-2688,304;Inherit;False;751;VertexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;758;-2688,368;Inherit;False;752;WorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;761;-2688,-592;Inherit;False;751;VertexCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;451;-2512,336;Inherit;False;Property;_TextureMapping2;Texture Mapping;16;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Local;WorldSpace;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;286;-2512,1232;Inherit;False;Property;_TextureMapping3;Texture Mapping;29;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Local;WorldSpace;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;596;-2512,-560;Inherit;False;Property;_TextureMapping1;Texture Mapping;3;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Local;WorldSpace;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;597;-2336,-576;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;452;-2336,320;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;314;-2336,1216;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TimeNode;605;-112,-720;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;603;-2688,-864;Inherit;False;273.5983;238.3799;Texture Scrolling;3;609;762;606;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;288;-2688,928;Inherit;False;274.0263;238.0098;Texture Scrolling;3;272;270;763;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;453;-2336,320;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;750;64,-720;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;598;-2336,-576;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;458;-2688,32;Inherit;False;274.287;237.6112;Texture Scrolling;3;464;461;757;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;313;-2336,1216;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;322;-2336,1024;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;757;-2688,64;Inherit;False;750;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;270;-2688,1024;Inherit;False;Property;_ScrollSpeed3;Scroll Speed;32;0;Create;False;0;0;0;False;0;False;0,0,0;0,-0.01,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;604;-2336,-768;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;763;-2688,960;Inherit;False;750;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;606;-2688,-768;Inherit;False;Property;_ScrollSpeed1;Scroll Speed;6;0;Create;False;0;0;0;False;0;False;0,0,0;0,-0.01,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;459;-2336,128;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;461;-2688,128;Inherit;False;Property;_Scrolling2;Scroll Speed;19;0;Create;False;0;0;0;False;0;False;0,0,0;0,-0.01,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;762;-2688,-832;Inherit;False;750;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;272;-2528,960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;607;-2336,-768;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;608;-2288,-864;Inherit;False;372.585;254.8798;Texture Tiling;9;618;616;615;617;612;611;610;614;613;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;-2528,-832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;464;-2528,64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;321;-2336,1024;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;463;-2288,32;Inherit;False;371.1199;255.2641;Texture Tiling;9;467;473;472;471;470;469;468;466;465;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;294;-2288,928;Inherit;False;369.0977;258.4469;Texture Tiling;9;279;292;293;277;276;274;275;291;290;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;462;-2336,128;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;611;-2288,-752;Inherit;False;Property;_Tiling1;Tiling;5;0;Create;False;0;0;0;False;0;False;1,1,1;40,40,40;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;274;-2288,1040;Inherit;False;Property;_Tiling3;Tiling;31;0;Create;False;0;0;0;False;0;False;1,1,1;40,40,40;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;610;-2288,-832;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;466;-2288,144;Inherit;False;Property;_Tiling2;Tiling;18;0;Create;False;0;0;0;False;0;False;1,1,1;40,40,40;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;465;-2288,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;275;-2288,960;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-2144,960;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;612;-2144,-832;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;-2144,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;290;-2016,1040;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;613;-2016,-752;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;468;-2032,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;614;-2016,-752;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;469;-2032,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;291;-2016,1040;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;293;-2144,1040;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;477;-1920,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;622;-1920,-800;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;615;-2144,-752;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;323;-1920,992;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;470;-2144,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;478;-1920,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;623;-1920,-800;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;292;-2144,1040;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;471;-2144,144;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;616;-2144,-752;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;324;-1920,992;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;326;-1920,1200;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;472;-2144,176;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;277;-2144,1072;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;617;-2144,-720;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;481;-1920,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;626;-1920,-592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;628;-1920,-592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;483;-1920,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;618;-2032,-704;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;325;-1920,1200;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;279;-2032,1088;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;473;-2032,192;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;474;-1952,272;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;630;-1968,-592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;335;-1968,1200;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;485;-1968,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;619;-1952,-624;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;327;-1952,1168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;328;-1952,1168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;488;-2176,336;Inherit;False;618.7012;385.9157;Noise Map Texture Slot;12;499;498;491;500;910;492;495;494;490;497;496;909;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;487;-1968,304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;620;-1952,-624;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;310;-2176,1232;Inherit;False;620.1904;402.6613;Noise Map Texture Slot;12;343;342;970;969;281;278;280;338;337;282;355;302;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;475;-1952,272;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;632;-1968,-592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;633;-2176,-560;Inherit;False;620.3584;403.5196;Noise Map Texture Slot;12;946;945;642;641;639;635;645;640;637;636;953;954;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;336;-1968,1200;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;302;-1952,1328;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;490;-1968,592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;641;-1952,-464;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;635;-1968,-288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;496;-1952,432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;337;-1968,1520;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;492;-2176,640;Inherit;False;Property;_3DMappingFalloff2;3D Mapping Blending;23;0;Create;False;0;0;0;False;0;False;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;636;-2176,-528;Inherit;True;Property;_NoiseMap1;Noise Map;4;1;[NoScaleOffset];Create;False;1;ZONE 1;0;0;False;0;False;None;49d382e00cbb0944f996da624ecd24ce;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;637;-2176,-240;Inherit;False;Property;_3DMappingBlending1;3D Mapping Blending;10;0;Create;False;0;0;0;False;0;False;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;494;-1968,592;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;280;-2176,1264;Inherit;True;Property;_Texture3;Noise Map;30;1;[NoScaleOffset];Create;False;1;ZONE 3;0;0;False;0;False;None;49d382e00cbb0944f996da624ecd24ce;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;639;-1968,-288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;491;-2176,368;Inherit;True;Property;_Texture2;Noise Map;17;1;[NoScaleOffset];Create;False;1;ZONE 2;0;0;False;0;False;None;49d382e00cbb0944f996da624ecd24ce;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;497;-1952,432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;355;-1952,1328;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;642;-1952,-464;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;338;-1968,1520;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-2176,1568;Inherit;False;Property;_3DTextureFalloff3;3D Mapping Blending;36;0;Create;False;0;0;0;False;0;False;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;640;-1920,-336;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;1;None;Bot Texture 2;_BotTexture2;white;0;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;645;-1920,-528;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;282;-1920,1264;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;281;-1920,1456;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;1;None;Bot Texture 0;_BotTexture0;white;0;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;495;-1920,544;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;1;None;Bot Texture 1;_BotTexture1;white;0;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;500;-1920,368;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;509;-2688,448;Inherit;False;480.2628;405.6633;Fresnel Adjustments;20;512;526;532;521;824;520;823;539;536;545;518;516;514;825;826;828;827;538;932;933;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;909;-1648,400;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;514;-2688,720;Inherit;False;Property;_FresnelScale2;Fresnel Scale;25;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;953;-1648,-496;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;498;-1600,496;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;342;-1600,1424;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;304;-2688,1344;Inherit;False;481.1219;411.628;Fresnel Adjustments;18;234;363;364;362;361;866;867;869;360;868;359;213;239;221;222;232;870;871;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;654;-2688,-448;Inherit;False;478.9539;405.342;Fresnel Adjustments;10;663;690;684;681;659;661;657;683;882;883;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;516;-2688,656;Inherit;False;Property;_FresnelBias2;Fresnel Bias;24;1;[Header];Create;False;1;Fresnel;0;0;False;0;False;0;0.06;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;969;-1648,1296;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;945;-1600,-368;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;512;-2688,784;Inherit;False;Property;_FresnelPower2;Fresnel Power;26;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;343;-1600,1424;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;659;-2688,-176;Inherit;False;Property;_FresnelScale1;Fresnel Scale;12;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;946;-1600,-368;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-2688,1680;Inherit;False;Property;_FresnelPower3;Fresnel Power;39;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-2688,1616;Inherit;False;Property;_FresnelScale3;Fresnel Scale;38;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;657;-2688,-112;Inherit;False;Property;_FresnelPower1;Fresnel Power;13;0;Create;False;0;0;0;False;0;False;1;4.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;661;-2688,-240;Inherit;False;Property;_FresnelBias1;Fresnel Bias;11;1;[Header];Create;False;1;Fresnel;0;0;False;0;False;0;0.06;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-2688,1552;Inherit;False;Property;_FresnelBias3;Fresnel Bias;37;1;[Header];Create;False;1;Fresnel;0;0;False;0;False;0;0.06;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;970;-1648,1296;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;910;-1648,400;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;499;-1600,496;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;954;-1648,-496;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;518;-2432,656;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;646;-1648,-592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;663;-2432,-240;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;502;-1598.808,288.6835;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;501;-1648,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;339;-1600,1184;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FresnelNode;213;-2432,1552;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;647;-1600,-608;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;823;-2240,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;341;-1648,1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;503;-1598.808,288.6835;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;340;-1600,1184;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;359;-2240,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;649;-1648,-592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;520;-2240,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;504;-1648,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;648;-1600,-608;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;665;-2240,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;353;-1648,1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;824;-2240,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;506;-1888,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;666;-2240,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;868;-2240,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;360;-2240,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;354;-1872,1184;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;650;-1872,-608;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;826;-2688,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;348;-1888,1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;651;-1888,-592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;880;-2240,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;505;-1872,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;521;-2240,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;352;-1872,1184;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;653;-1872,-608;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;507;-1888,304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;522;-1552,368;Inherit;False;448.3002;336.1337;Masking;13;566;562;558;768;1032;1031;1033;1034;1036;1035;529;1042;1043;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;361;-2240,1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;667;-1552,-512;Inherit;False;449.107;337.2034;Masking;13;680;676;691;686;699;695;703;674;767;707;711;1021;1023;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;652;-1888,-592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;349;-1888,1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;825;-2688,624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;508;-1872,288;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;526;-2240,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;671;-2240,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;881;-2240,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;397;-1552,1280;Inherit;False;444.4533;333.0861;Masking;11;400;401;395;769;224;399;398;403;402;1025;1026;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;869;-2240,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;883;-2672,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;511;-1872,272;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;532;-2240,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;346;-1872,1168;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;871;-2672,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;674;-1552,-480;Inherit;True;Property;_Mask1;Mask;8;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;656;-1872,-624;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;827;-2688,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;529;-1552,400;Inherit;True;Property;_Mask2;Mask;21;2;[Header];[NoScaleOffset];Create;False;1;ZONE 2;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;345;-1888,1136;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;655;-1888,-656;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;224;-1552,1312;Inherit;True;Property;_Mask3;Mask;34;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;677;-2240,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;362;-2240,1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;510;-1888,256;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;402;-1280,1360;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;515;-1872,272;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;676;-1280,-448;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;658;-1888,-656;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;513;-1888,256;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;882;-2672,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1035;-1280,432;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;660;-1872,-624;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;364;-2496,1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;870;-2672,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;347;-1872,1168;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;344;-1888,1136;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;536;-2496,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;828;-2688,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;681;-2496,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;662;-1840,-688;Inherit;False;Property;_3DTextureSpace;3D Texture Space;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;363;-2496,1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;683;-2656,-416;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;283;-1840,1104;Inherit;False;Property;_3DTextureSpace;3D Texture Space;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;662;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;538;-2656,480;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;539;-2496,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;232;-2656,1376;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;849;-1072,1072;Inherit;False;279.3651;342.7185;Opacity;14;864;863;876;861;862;877;859;860;853;852;855;854;856;896;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;403;-1280,1360;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;568;-1072,176;Inherit;False;278.2471;340.3676;Opacity;14;817;815;575;819;816;818;814;820;813;808;890;821;822;581;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;1036;-1280,432;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;680;-1280,-448;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;517;-1840,208;Inherit;False;Property;_3DTextureSpace;3D Texture Space;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;662;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;833;-1072,-720;Inherit;False;280.2081;344.2301;Opacity;14;840;848;847;845;888;889;846;843;844;837;836;839;838;895;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;684;-2496,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;840;-1072,-448;Inherit;False;Property;_Opacity1;Opacity;9;0;Create;False;1;Zone 1 Opacity;0;0;False;0;False;0.5;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1034;-1280,576;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;575;-1072,448;Inherit;False;Property;_Opacity2;Opacity;22;0;Create;False;1;Zone 2 Opacity;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;985;-1616,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;998;-1616,1120;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;994;-1616,-672;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;234;-2464,1376;Inherit;False;Property;_InvertFresnel3;Invert Fresnel;40;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;545;-2464,480;Inherit;False;Property;_InvertFresnel2;Invert Fresnel;27;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;686;-1280,-304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;690;-2464,-416;Inherit;False;Property;_InvertFresnel1;Invert Fresnel;14;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;856;-1072,1344;Inherit;False;Property;_Opacity3;Opacity;35;0;Create;False;1;Zone 3 Opacity;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;398;-1280,1488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;986;-1616,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;995;-1616,-672;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;365;-2208,1408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;992;-1616,-672;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;399;-1280,1488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1001;-1616,1120;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;947;-2208,-384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;866;-2240,1648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;551;-112,-304;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;878;-2240,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;999;-1616,1120;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;838;-832,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;691;-1280,-304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;984;-1616,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;932;-2240,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;854;-832,1376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1033;-1280,576;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;815;-832,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;913;-2208,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;839;-832,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1031;-1408,576;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;309;-1536,960;Inherit;False;226.0222;285.5552;Invert Noise Map;2;225;233;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;867;-2240,1648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;933;-2240,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;989;-1616,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;817;-832,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;879;-2240,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;754;64,-272;Inherit;False;VtxColG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;912;-2208,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;753;64,-336;Inherit;False;VtxColR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;401;-1408,1488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;987;-1616,224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;948;-2208,-384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;523;-1520,64;Inherit;False;230.6887;289.1178;Invert Noise Map;2;534;542;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;991;-1616,-768;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1000;-1616,1120;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;855;-832,1376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;366;-2208,1408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;695;-1408,-304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;540;-1808,32;Inherit;False;Property;_Color2;Color;15;1;[Header];Create;False;1;ZONE 2;0;0;False;0;False;1,1,1,1;0,0.1812606,0.9834351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;997;-1616,1024;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;220;-1808,928;Inherit;False;Property;_Color3;Color;28;1;[Header];Create;False;1;ZONE 3;0;0;False;0;False;1,1,1,1;0,0.1812606,0.9834351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;993;-1616,-672;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;685;-1808,-864;Inherit;False;Property;_Color1;Color;2;1;[Header];Create;False;4;Masking Textures are ignored if Vertex Colors are used;If masking is not needed then select Texture as masking method leaving;the mask field empty and then use Zone 1;ZONE 1;0;0;False;0;False;1,1,1,1;0,0.1812606,0.9834351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;755;64,-208;Inherit;False;VtxColB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;668;-1536,-832;Inherit;False;226.8051;287.4847;Invert Noise Map;2;687;679;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;884;-816,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;768;-1552,624;Inherit;False;754;VtxColG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;917;-2208,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;975;-1568,960;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;990;-1616,-768;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;831;-816,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;818;-832,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;941;-1568,-832;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;679;-1488,-704;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;1,1,1,1;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;699;-1408,-304;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;836;-832,-480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;233;-1488,1088;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;1,1,1,1;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;400;-1408,1488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;769;-1552,1536;Inherit;False;755;VtxColB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;534;-1472,192;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;1,1,1,1;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;903;-1568,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;996;-1616,1024;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;767;-1552,-256;Inherit;False;753;VtxColR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;988;-1616,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;972;-816,1648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;949;-2208,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1032;-1408,576;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;367;-2208,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;852;-832,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;703;-1392,-272;Inherit;False;Property;_MaskingMethod;Masking Method;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;MaskingTexture;VertexColors;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;687;-1536,-800;Inherit;False;Property;_InvertNoiseMap1;Invert Noise Map;7;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;976;-1568,960;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;885;-816,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;950;-2208,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;225;-1536,992;Inherit;False;Property;InvertNoiseMap3;Invert Noise Map;33;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;904;-1568,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;832;-816,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;558;-1392,608;Inherit;False;Property;_MaskingMethod2;Masking Method2;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;MaskingTexture;VertexColorGreen;Reference;703;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;542;-1520,96;Inherit;False;Property;_InvertNoiseMap2;Invert Noise Map;20;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;918;-2208,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;368;-2208,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;819;-832,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;942;-1568,-832;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;837;-832,-480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;395;-1392,1520;Inherit;False;Property;_MaskingMethod3;Masking Method3;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;MaskingTexture;VertexColorBlue;Reference;703;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;853;-832,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;971;-816,1648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;820;-1072,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;710;-1104,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;874;-816,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;413;-1312,1024;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;562;-1136,592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;556;-1104,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;959;-1312,-768;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;977;-1568,928;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;812;-816,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;886;-816,-496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;967;-1568,-864;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;707;-1136,-288;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;860;-1072,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;963;-1568,33.88849;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;957;-1296,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;432;-1104,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;437;-1136,1504;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;844;-1072,-480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;414;-1312,1024;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;843;-1072,-480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;560;-1104,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;814;-1072,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;810;-816,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;960;-1312,-768;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;875;-816,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;964;-1568,33.88849;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;438;-1136,1504;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1042;-1136,592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1021;-1136,-288;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;968;-1568,-864;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;859;-1072,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1025;-1136,1504;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;887;-816,-496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;714;-1104,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;434;-1104,1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;711;-1136,-288;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;978;-1568,928;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;958;-1296,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;566;-1136,592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;961;-1312,-816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;889;-1056,-496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;816;-1056,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1043;-1136,592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;723;-1104,-784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1023;-1136,-288;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;436;-1104,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;578;-1104,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;980;-1312,976;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;571;-1136,144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;877;-1056,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;862;-1072,1248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;906;-1104,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1026;-1136,1502.954;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;846;-1072,-544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;974;-1104,928;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;822;-1072,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;716;-1136,-752;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;955;-1296,80;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;944;-1120,-864;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;440;-1136,1008;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;956;-1296,80;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;981;-1312,976;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;861;-1072,1248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;724;-1136,-752;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1022;-1136,-656;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;973;-1104,928;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;584;-1104,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;435;-1104,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;729;-1104,-784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1044;-1136,240;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;813;-1056,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;439;-1136,1008;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;876;-1056,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1027;-1136,1136;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;579;-1136,144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;962;-1312,-816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;821;-1072,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;845;-1072,-544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;888;-1056,-496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;943;-1120,-864;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;905;-1104,32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1024;-1136,1136;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;727;-1072,-864;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;378;-880,928;Inherit;False;107;100;Emission;2;773;394;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;582;-1072,32;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;847;-1040,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1045;-1136,240;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1020;-1136,-656;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;808;-1040,320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-1072,928;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;863;-1040,1216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;864;-1040,1104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;848;-1040,-688;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;774;-800,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;581;-1040,208;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;773;-800,960;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;746;-800,-832;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;890;-928,208;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;394;-800,960;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;747;-800,-832;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;734;-800,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;895;-928,-688;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;896;-928,1104;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1018;-416,240;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1019;-416,208;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;736;-416,96;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;806;-416,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1017;-416,272;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;745;-416,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;735;-416,96;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;742;-416,208;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;737;-416,240;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;254;-416,272;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;744;-416,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;262;-416,128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-256,48;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-256,192;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;444;-128,48;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;445;-128,192;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StickyNoteNode;1002;-2688,-1536;Inherit;False;767.3728;543.0582;;Spark Holographic Shader by Sgt. Hawk;0,0.6330502,1,1;MIT License$$Copyright (c) 2021 "Sgt. Hawk"$$Permission is hereby granted, free of charge, to any person obtaining a copy$of this software and associated documentation files (the "Software"), to deal$in the Software without restriction, including without limitation the rights$to use, copy, modify, merge, publish, distribute, sublicense, and/or sell$copies of the Software, and to permit persons to whom the Software is$furnished to do so, subject to the following conditions:$$The above copyright notice and this permission notice shall be included in all$copies or substantial portions of the Software.$$THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR$IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,$FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE$AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER$LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,$OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE$SOFTWARE.;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sgt Hawk/Spark Holographic Masked;False;False;False;False;False;False;False;False;False;False;False;True;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;9;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;nomrt;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;1;False;-1;1;False;-1;0;False;1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;589;-880,16;Inherit;False;107.438;100;Emission;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;732;-880,-864;Inherit;False;109.8123;100;Emission;0;;1,1,1,1;0;0
WireConnection;751;0;450;0
WireConnection;752;0;285;0
WireConnection;451;1;759;0
WireConnection;451;0;758;0
WireConnection;286;1;764;0
WireConnection;286;0;765;0
WireConnection;596;1;761;0
WireConnection;596;0;760;0
WireConnection;597;0;596;0
WireConnection;452;0;451;0
WireConnection;314;0;286;0
WireConnection;453;0;452;0
WireConnection;750;0;605;2
WireConnection;598;0;597;0
WireConnection;313;0;314;0
WireConnection;322;0;313;0
WireConnection;604;0;598;0
WireConnection;459;0;453;0
WireConnection;272;0;763;0
WireConnection;272;1;270;0
WireConnection;607;0;604;0
WireConnection;609;0;762;0
WireConnection;609;1;606;0
WireConnection;464;0;757;0
WireConnection;464;1;461;0
WireConnection;321;0;322;0
WireConnection;462;0;459;0
WireConnection;610;0;609;0
WireConnection;610;1;607;0
WireConnection;465;0;464;0
WireConnection;465;1;462;0
WireConnection;275;0;272;0
WireConnection;275;1;321;0
WireConnection;276;0;275;0
WireConnection;276;1;274;0
WireConnection;612;0;610;0
WireConnection;612;1;611;0
WireConnection;467;0;465;0
WireConnection;467;1;466;0
WireConnection;290;0;276;0
WireConnection;613;0;612;0
WireConnection;468;0;467;0
WireConnection;614;0;613;0
WireConnection;469;0;468;0
WireConnection;291;0;290;0
WireConnection;293;0;291;0
WireConnection;477;0;467;0
WireConnection;622;0;612;0
WireConnection;615;0;614;0
WireConnection;323;0;276;0
WireConnection;470;0;469;0
WireConnection;478;0;477;0
WireConnection;623;0;622;0
WireConnection;292;0;293;0
WireConnection;471;0;470;0
WireConnection;616;0;615;0
WireConnection;324;0;323;0
WireConnection;326;0;324;0
WireConnection;472;0;471;0
WireConnection;277;0;292;0
WireConnection;617;0;616;0
WireConnection;481;0;478;0
WireConnection;626;0;623;0
WireConnection;628;0;626;0
WireConnection;483;0;481;0
WireConnection;618;0;617;0
WireConnection;618;1;617;1
WireConnection;325;0;326;0
WireConnection;279;0;277;0
WireConnection;279;1;277;1
WireConnection;473;0;472;0
WireConnection;473;1;472;1
WireConnection;474;0;473;0
WireConnection;630;0;628;0
WireConnection;335;0;325;0
WireConnection;485;0;483;0
WireConnection;619;0;618;0
WireConnection;327;0;279;0
WireConnection;328;0;327;0
WireConnection;487;0;485;0
WireConnection;620;0;619;0
WireConnection;475;0;474;0
WireConnection;632;0;630;0
WireConnection;336;0;335;0
WireConnection;302;0;328;0
WireConnection;490;0;487;0
WireConnection;641;0;620;0
WireConnection;635;0;632;0
WireConnection;496;0;475;0
WireConnection;337;0;336;0
WireConnection;494;0;490;0
WireConnection;639;0;635;0
WireConnection;497;0;496;0
WireConnection;355;0;302;0
WireConnection;642;0;641;0
WireConnection;338;0;337;0
WireConnection;640;0;636;0
WireConnection;640;9;639;0
WireConnection;640;4;637;0
WireConnection;645;0;636;0
WireConnection;645;1;642;0
WireConnection;282;0;280;0
WireConnection;282;1;355;0
WireConnection;281;0;280;0
WireConnection;281;9;338;0
WireConnection;281;4;278;0
WireConnection;495;0;491;0
WireConnection;495;9;494;0
WireConnection;495;4;492;0
WireConnection;500;0;491;0
WireConnection;500;1;497;0
WireConnection;909;0;500;0
WireConnection;953;0;645;0
WireConnection;498;0;495;0
WireConnection;342;0;281;0
WireConnection;969;0;282;0
WireConnection;945;0;640;0
WireConnection;343;0;342;0
WireConnection;946;0;945;0
WireConnection;970;0;969;0
WireConnection;910;0;909;0
WireConnection;499;0;498;0
WireConnection;954;0;953;0
WireConnection;518;1;516;0
WireConnection;518;2;514;0
WireConnection;518;3;512;0
WireConnection;646;0;954;0
WireConnection;663;1;661;0
WireConnection;663;2;659;0
WireConnection;663;3;657;0
WireConnection;502;0;499;0
WireConnection;501;0;910;0
WireConnection;339;0;343;0
WireConnection;213;1;222;0
WireConnection;213;2;221;0
WireConnection;213;3;239;0
WireConnection;647;0;946;0
WireConnection;823;0;518;0
WireConnection;341;0;970;0
WireConnection;503;0;502;0
WireConnection;340;0;339;0
WireConnection;359;0;213;0
WireConnection;649;0;646;0
WireConnection;520;0;518;0
WireConnection;504;0;501;0
WireConnection;648;0;647;0
WireConnection;665;0;663;0
WireConnection;353;0;341;0
WireConnection;824;0;823;0
WireConnection;506;0;504;0
WireConnection;666;0;665;0
WireConnection;868;0;213;0
WireConnection;360;0;359;0
WireConnection;354;0;340;0
WireConnection;650;0;648;0
WireConnection;826;0;824;0
WireConnection;348;0;353;0
WireConnection;651;0;649;0
WireConnection;880;0;663;0
WireConnection;505;0;503;0
WireConnection;521;0;520;0
WireConnection;352;0;354;0
WireConnection;653;0;650;0
WireConnection;507;0;506;0
WireConnection;361;0;360;0
WireConnection;652;0;651;0
WireConnection;349;0;348;0
WireConnection;825;0;826;0
WireConnection;508;0;505;0
WireConnection;526;0;521;0
WireConnection;671;0;666;0
WireConnection;881;0;880;0
WireConnection;869;0;868;0
WireConnection;883;0;881;0
WireConnection;511;0;508;0
WireConnection;532;0;526;0
WireConnection;346;0;352;0
WireConnection;871;0;869;0
WireConnection;656;0;653;0
WireConnection;827;0;825;0
WireConnection;345;0;349;0
WireConnection;655;0;652;0
WireConnection;677;0;671;0
WireConnection;362;0;361;0
WireConnection;510;0;507;0
WireConnection;402;0;224;0
WireConnection;515;0;511;0
WireConnection;676;0;674;0
WireConnection;658;0;655;0
WireConnection;513;0;510;0
WireConnection;882;0;883;0
WireConnection;1035;0;529;0
WireConnection;660;0;656;0
WireConnection;364;0;362;0
WireConnection;870;0;871;0
WireConnection;347;0;346;0
WireConnection;344;0;345;0
WireConnection;536;0;532;0
WireConnection;828;0;827;0
WireConnection;681;0;677;0
WireConnection;662;1;658;0
WireConnection;662;0;660;0
WireConnection;363;0;364;0
WireConnection;683;0;882;0
WireConnection;283;1;344;0
WireConnection;283;0;347;0
WireConnection;538;0;828;0
WireConnection;539;0;536;0
WireConnection;232;0;870;0
WireConnection;403;0;402;0
WireConnection;1036;0;1035;0
WireConnection;680;0;676;0
WireConnection;517;1;513;0
WireConnection;517;0;515;0
WireConnection;684;0;681;0
WireConnection;1034;0;1036;0
WireConnection;985;0;517;0
WireConnection;998;0;283;0
WireConnection;994;0;662;0
WireConnection;234;1;363;0
WireConnection;234;0;232;0
WireConnection;545;1;539;0
WireConnection;545;0;538;0
WireConnection;686;0;680;0
WireConnection;690;1;684;0
WireConnection;690;0;683;0
WireConnection;398;0;403;0
WireConnection;986;0;985;0
WireConnection;995;0;994;0
WireConnection;365;0;234;0
WireConnection;992;0;662;0
WireConnection;399;0;398;0
WireConnection;1001;0;998;0
WireConnection;947;0;690;0
WireConnection;866;0;213;0
WireConnection;878;0;663;0
WireConnection;999;0;283;0
WireConnection;838;0;840;0
WireConnection;691;0;686;0
WireConnection;984;0;517;0
WireConnection;932;0;518;0
WireConnection;854;0;856;0
WireConnection;1033;0;1034;0
WireConnection;815;0;575;0
WireConnection;913;0;545;0
WireConnection;839;0;838;0
WireConnection;1031;0;1033;0
WireConnection;867;0;866;0
WireConnection;933;0;932;0
WireConnection;989;0;986;0
WireConnection;817;0;815;0
WireConnection;879;0;878;0
WireConnection;754;0;551;2
WireConnection;912;0;913;0
WireConnection;753;0;551;1
WireConnection;401;0;399;0
WireConnection;987;0;984;0
WireConnection;948;0;947;0
WireConnection;991;0;995;0
WireConnection;1000;0;999;0
WireConnection;855;0;854;0
WireConnection;366;0;365;0
WireConnection;695;0;691;0
WireConnection;997;0;1001;0
WireConnection;993;0;992;0
WireConnection;755;0;551;3
WireConnection;884;0;879;0
WireConnection;917;0;912;0
WireConnection;975;0;220;0
WireConnection;990;0;991;0
WireConnection;831;0;933;0
WireConnection;818;0;817;0
WireConnection;941;0;685;0
WireConnection;679;0;993;0
WireConnection;699;0;695;0
WireConnection;836;0;839;0
WireConnection;233;0;1000;0
WireConnection;400;0;401;0
WireConnection;534;0;987;0
WireConnection;903;0;540;0
WireConnection;996;0;997;0
WireConnection;988;0;989;0
WireConnection;972;0;867;0
WireConnection;949;0;948;0
WireConnection;1032;0;1031;0
WireConnection;367;0;366;0
WireConnection;852;0;855;0
WireConnection;703;1;699;0
WireConnection;703;0;767;0
WireConnection;687;1;990;0
WireConnection;687;0;679;0
WireConnection;976;0;975;0
WireConnection;885;0;884;0
WireConnection;950;0;949;0
WireConnection;225;1;996;0
WireConnection;225;0;233;0
WireConnection;904;0;903;0
WireConnection;832;0;831;0
WireConnection;558;1;1032;0
WireConnection;558;0;768;0
WireConnection;542;1;988;0
WireConnection;542;0;534;0
WireConnection;918;0;917;0
WireConnection;368;0;367;0
WireConnection;819;0;818;0
WireConnection;942;0;941;0
WireConnection;837;0;836;0
WireConnection;395;1;400;0
WireConnection;395;0;769;0
WireConnection;853;0;852;0
WireConnection;971;0;972;0
WireConnection;820;0;819;0
WireConnection;710;0;950;0
WireConnection;874;0;971;0
WireConnection;413;0;225;0
WireConnection;562;0;558;0
WireConnection;556;0;918;0
WireConnection;959;0;687;0
WireConnection;977;0;976;0
WireConnection;812;0;832;0
WireConnection;886;0;885;0
WireConnection;967;0;942;0
WireConnection;707;0;703;0
WireConnection;860;0;853;0
WireConnection;963;0;904;0
WireConnection;957;0;542;0
WireConnection;432;0;368;0
WireConnection;437;0;395;0
WireConnection;844;0;837;0
WireConnection;414;0;413;0
WireConnection;843;0;844;0
WireConnection;560;0;556;0
WireConnection;814;0;820;0
WireConnection;810;0;812;0
WireConnection;960;0;959;0
WireConnection;875;0;874;0
WireConnection;964;0;963;0
WireConnection;438;0;437;0
WireConnection;1042;0;558;0
WireConnection;1021;0;703;0
WireConnection;968;0;967;0
WireConnection;859;0;860;0
WireConnection;1025;0;395;0
WireConnection;887;0;886;0
WireConnection;714;0;710;0
WireConnection;434;0;432;0
WireConnection;711;0;707;0
WireConnection;978;0;977;0
WireConnection;958;0;957;0
WireConnection;566;0;562;0
WireConnection;961;0;960;0
WireConnection;889;0;887;0
WireConnection;816;0;810;0
WireConnection;1043;0;1042;0
WireConnection;723;0;714;0
WireConnection;1023;0;1021;0
WireConnection;436;0;434;0
WireConnection;578;0;560;0
WireConnection;980;0;414;0
WireConnection;571;0;566;0
WireConnection;877;0;875;0
WireConnection;862;0;859;0
WireConnection;906;0;964;0
WireConnection;1026;0;1025;0
WireConnection;846;0;843;0
WireConnection;974;0;978;0
WireConnection;822;0;814;0
WireConnection;716;0;711;0
WireConnection;955;0;958;0
WireConnection;944;0;968;0
WireConnection;440;0;438;0
WireConnection;956;0;955;0
WireConnection;981;0;980;0
WireConnection;861;0;862;0
WireConnection;724;0;716;0
WireConnection;1022;0;1023;0
WireConnection;973;0;974;0
WireConnection;584;0;578;0
WireConnection;435;0;436;0
WireConnection;729;0;723;0
WireConnection;1044;0;1043;0
WireConnection;813;0;816;0
WireConnection;439;0;440;0
WireConnection;876;0;877;0
WireConnection;1027;0;1026;0
WireConnection;579;0;571;0
WireConnection;962;0;961;0
WireConnection;821;0;822;0
WireConnection;845;0;846;0
WireConnection;888;0;889;0
WireConnection;943;0;944;0
WireConnection;905;0;906;0
WireConnection;1024;0;1027;0
WireConnection;727;0;943;0
WireConnection;727;1;962;0
WireConnection;727;2;729;0
WireConnection;727;3;724;0
WireConnection;582;0;905;0
WireConnection;582;1;956;0
WireConnection;582;2;584;0
WireConnection;582;3;579;0
WireConnection;847;0;845;0
WireConnection;847;1;888;0
WireConnection;1045;0;1044;0
WireConnection;1020;0;1022;0
WireConnection;808;0;821;0
WireConnection;808;1;813;0
WireConnection;219;0;973;0
WireConnection;219;1;981;0
WireConnection;219;2;439;0
WireConnection;219;3;435;0
WireConnection;863;0;861;0
WireConnection;863;1;876;0
WireConnection;864;0;1024;0
WireConnection;864;1;863;0
WireConnection;848;0;1020;0
WireConnection;848;1;847;0
WireConnection;774;0;582;0
WireConnection;581;0;1045;0
WireConnection;581;1;808;0
WireConnection;773;0;219;0
WireConnection;746;0;727;0
WireConnection;890;0;581;0
WireConnection;394;0;773;0
WireConnection;747;0;746;0
WireConnection;734;0;774;0
WireConnection;895;0;848;0
WireConnection;896;0;864;0
WireConnection;1018;0;890;0
WireConnection;1019;0;895;0
WireConnection;736;0;734;0
WireConnection;806;0;394;0
WireConnection;1017;0;896;0
WireConnection;745;0;747;0
WireConnection;735;0;736;0
WireConnection;742;0;1019;0
WireConnection;737;0;1018;0
WireConnection;254;0;1017;0
WireConnection;744;0;745;0
WireConnection;262;0;806;0
WireConnection;24;0;744;0
WireConnection;24;1;735;0
WireConnection;24;2;262;0
WireConnection;32;0;742;0
WireConnection;32;1;737;0
WireConnection;32;2;254;0
WireConnection;444;0;24;0
WireConnection;445;0;32;0
WireConnection;0;2;444;0
WireConnection;0;9;445;0
ASEEND*/
//CHKSM=A455C6F8DE742149FB52556B9D57FFDB59D17E25