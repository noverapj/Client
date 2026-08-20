-- NOVERAOSS-Client premake5
-- Toolset: VS2010 (v100). CRT: mixed per original.
-- Configs: Debug, Release, Shipping*, Static variants, Profile, region Ship_*/Rel_*.

local DXSDK = os.getenv("DXSDK_DIR") or "C:\\Program Files (x86)\\Microsoft DirectX SDK (June 2010)\\"

local function grp(dir, group, ...)
    local t = {}
    for _, name in ipairs({...}) do
        t[#t+1] = dir .. "/" .. name .. ".cpp"
        t[#t+1] = dir .. "/" .. name .. ".h"
    end
    vpaths { [group] = t }
end

local function Vpaths(projDir)
    vpaths {
        ["Source Files"]   = { projDir .. "/**.cpp" },
        ["Header Files"]   = { projDir .. "/**.h" },
        ["Resource Files"] = { projDir .. "/**.rc" },
    }
end

workspace "Client"
    configurations {
        "Debug", "Release",
        "Shipping", "Shipping_QA",
        "ShippingHackShield", "ShippingNProtect", "ShippingXigncode", "ShippingXtrap",
        "Profile",
        "Debug Static", "Release Static", "Debug Static Patch", "Release Static Patch",
        "ShippingMac", "ShippingNoXtrap", "Debug_KoR", "SRC_KOR",
        "Ship_BR", "Ship_EU", "Ship_ID", "Ship_NA", "Ship_PH", "Ship_SA", "Ship_SEA", "Ship_TH", "Ship_TW",
        "Rel_BR", "Rel_EU", "Rel_ID", "Rel_NA", "Rel_PH", "Rel_SA", "Rel_SEA", "Rel_TH", "Rel_TW",
    }
    platforms { "Win32" }
    toolset "v100"
    location "build"
    characterset "MBCS"
    multiprocessorcompile "On"
    defines { "_CRT_SECURE_NO_WARNINGS", "_CRT_NONSTDC_NO_WARNINGS", "_WINSOCK_DEPRECATED_NO_WARNINGS" }

    filter "configurations:Debug*"    defines { "_DEBUG" }
    filter "configurations:Release* or Shipping* or Ship_* or Rel_* or SRC_KOR or Profile"
        defines { "NDEBUG" }; optimize "Speed"
    filter {}

------------------------------------------------------------------ engine libs
group "Libs"

-- io3DEngine : DLL, /MD, configs Debug/Release/Shipping
project "io3DEngine"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    pchheader "stdafx.h"; pchsource "src/io3DEngine/StdAfx.cpp"
    defines { "_USRDLL", "IO3D_API" }
    includedirs { "ThirdParty/Bullet", "ThirdParty", "ThirdParty/OggVorbis", DXSDK .. "Include" }
    libdirs { "lib", "lib/Bullet", "lib/Squish", "lib/Opcode", "lib/TinyXML", "lib/DevIL", "lib/OggVorbis", DXSDK .. "Lib\\x86" }
    files { "src/io3DEngine/**.h", "src/io3DEngine/**.cpp", "src/io3DEngine/**.rc" }
    local D = "src/io3DEngine"
    vpaths { ["Resource Files"] = { D.."/resource.h", D.."/io3DEngine.rc" } }
    grp(D, "Source Files", "io3DEngine", "StdAfx")
    grp(D, "Header Files", "io3DCommon", "ioPrerequisites", "StdAfx", "Version")
    grp(D, "io3DEngine", "ErrorReport", "HelpFunc", "ioEntityGroupBuilder", "ioSingleton", "ioVertexFormat")
    grp(D, "io3DEngine/Resource Class", "ioRc2DImage", "ioRcAnimateFX", "ioRcAnimation", "ioRcAniTrack", "ioRcBiped", "ioRcFont", "ioRcSkeleton", "ioResource", "ioResourceLoader", "ioDataProcessor", "ioAnimationEvent")
    grp(D, "io3DEngine/Instance Class", "io2DImage", "ioAniController", "ioAniEventHandler", "ioAnimateFX", "ioAnimation", "ioAniTrack", "ioAutoShaderParamSource", "ioBiped", "ioEdgeRender", "ioFont", "ioFontWorkSpace", "ioLight", "ioMaterial", "ioMesh", "ioMeshControlPoint", "ioMeshTrailer", "ioPass", "ioRenderTexture", "ioShader", "ioShaderDefine", "ioShaderGroup", "ioShaderParameter", "ioSkeleton", "ioSubMesh", "ioTechnique", "ioTexture", "ioTextureUnitState")
    grp(D, "io3DEngine/Manager Class", "io2DImageManager", "ioAnimateFXManager", "ioAnimationManager", "ioFontManager", "ioGUIManager", "ioMaterialManager", "ioMaterialSerializer", "ioMeshManager", "ioMeshTrailDataManager", "ioOpcodeManager", "ioOpcodeManagerImpl", "ioResourceManager", "ioShaderManager", "ioSkeletonManager", "ioTextureEffectManager", "ioTextureManager", "ioThreadTaskManager", "ioAnimationEventManager")
    grp(D, "io3DEngine/Buffer Class", "ioMeshData")
    grp(D, "io3DEngine/Buffer Class/VertexBuffer", "ioVertexBufferBinder", "ioVertexBufferHeap", "ioVertexBufferInstance", "ioVertexBufferManager", "ioVertexDeclaration", "ioVtxBuffer")
    grp(D, "io3DEngine/Buffer Class/IndexBuffer", "ioIdxBuffer", "ioIndexBufferHeap", "ioIndexBufferInstance", "ioIndexBufferManager")
    grp(D, "io3DEngine/SceneManager Class", "ioEntity", "ioEntityGroup", "ioMovableObject", "ioNode", "ioSceneManager", "ioSceneNode", "ioSceneShadowBox", "ioSubEntity", "ioEntityParent", "ioMaterialModifier")
    grp(D, "io3DEngine/Collision Object", "ioAxisAlignBox", "ioCylinder", "ioOpcodeShapeImpl", "ioOrientBox", "ioPlane", "ioPolygonMesh", "ioRay", "ioSegment", "ioSphere", "ioOpcodeShape")
    grp(D, "io3DEngine/Camera", "ioCamera")
    grp(D, "io3DEngine/Camera/Controller", "ioCameraController", "ioFPSCameraController", "ioLookAtCameraController", "ioSlerpCameraController", "ioTargetLookAtCameraController")
    grp(D, "io3DEngine/LandScape", "ioLandScape", "ioPatch", "ioPatchDefault", "ioPatchMorphSW")
    grp(D, "io3DEngine/Util Class", "AxisXYZ", "Grid3D", "ioBulletHelper", "ioCurveGenerator", "ioDataChunk", "ioDecal", "ioDecalMaker", "ioFrameTimer", "ioHashString", "ioINILoader", "ioINIParser", "ioLineRender", "ioMath", "ioMemFile", "ioRandomCreator", "ioRopeSpringCurve", "ioSkyDome", "ioStream", "ioTimer", "ioTimeRateFactor", "QuaternionCompression", "ioListIterator", "ioMapIterator", "ioMemoryPool", "ioSharedPtr", "ioTPtrArray", "ioVectorIterator", "ioFileTokenDefine")
    grp(D, "io3DEngine/Util Class/Mesh", "ioDivisionMesh", "ioProgressiveMesh", "ioSubDivisionMesh")
    grp(D, "io3DEngine/Util Class/Other", "IntersectionUtility", "TriangleAndAABBTest", "FastQuaternionSlerp")
    grp(D, "io3DEngine/Effect Class", "ioEffect", "ioEffectFactory", "ioEmitPointGenerator", "ioLightSystem", "ioParticleColorTable")
    grp(D, "io3DEngine/Effect Class/Particle System", "ioEmitterCommands", "ioParticle", "ioParticleEmitter", "ioParticleIterator", "ioParticleSystem")
    grp(D, "io3DEngine/Effect Class/Particle System/Affector", "ioBipedTrailAffector", "ioEmitAffector", "ioLinearForceAffector", "ioParticleAffector", "ioRotationAffector", "ioScaleAffector", "ioTexRotationAffector")
    grp(D, "io3DEngine/Effect Class/Model Particle System", "ioModelEmitCommand", "ioModelEmitter", "ioModelParticle", "ioModelParticleIterator", "ioModelParticleSystem")
    grp(D, "io3DEngine/Effect Class/Model Particle System/Model Affector", "ioModelBipedTrailAffector", "ioModelEmitAffector", "ioModelLinearForceAffector", "ioModelParticleAffector", "ioModelRotateAffector", "ioModelScaleAffector")
    grp(D, "io3DEngine/Effect Class/EffectRendering", "ioEffectBufferManager", "ioParticleRenderable")
    grp(D, "io3DEngine/ioWnd3D", "ioButton", "ioDragItem", "ioEdit", "ioList", "ioMouse", "ioProgressBar", "ioScroll", "ioTabControl", "ioWnd", "ioWndType", "ioMovingWnd")
    grp(D, "io3DEngine/ioWnd3D/UIRender", "ioUIFrameManager", "ioUIImage", "ioUIImageSet", "ioUIImageSetManager", "ioUIRenderElement", "ioUIRenderer", "ioUIRenderFrame", "ioUIRenderImage", "ioUITitle", "ioUI3DEffectRender")
    grp(D, "io3DEngine/ioWnd3D/ioWndEX", "ioWndEXEventHandler", "ioCustomWnd", "ioCheckBoxEX", "ioPaperDoll", "ioLabelWndEX", "ioFrameWndEX", "ioWndEXEventType", "ioTabWndEX", "ioImageWndEX", "ioComplexStringPrinterBase", "ioWndEXType", "ioFlashPlayer", "ioRichLabel", "ioScrollBarEX", "ioButtonWndEX", "ioRadioButtonEX", "ioWndEX")
    grp(D, "io3DEngine/InputBox", "EditBox", "InputBox", "ioIME")
    grp(D, "io3DEngine/RenderSystem", "ioEnumDisplayMode", "ioRenderable", "ioRenderableList", "ioRenderOperation", "ioRenderQueue", "ioRenderQueueGroup", "ioRenderStateDesc", "ioRenderSystem")
    grp(D, "io3DEngine/String Processing", "ioLocalManagerParent", "ioStringConverter", "ioStringInterface", "ioStringManager", "Safesprintf")
    grp(D, "io3DEngine/Texture Effect", "ioTextureAnimationEffect", "ioTextureColorTransformEffect", "ioTextureEffect", "ioTextureRotateEffect", "ioTextureScrollEffect", "ioTextureTransformEffect")
    grp(D, "io3DEngine/Post Process", "ioGlowPostProcess", "ioPostFilter", "ioPostOveray")
    grp(D, "io3DEngine/CPU", "CPUSpeedCheck", "FastAssemFunc", "ioCPU", "ioSIMDGeneric", "ioSIMDSSE")
    grp(D, "io3DEngine/XML", "ioXMLDocument", "ioXMLElement")
    grp(D, "Sound", "ioOggCallBack", "ioOggSound", "ioSound", "ioSoundManager", "ioWaveFile")
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "io3DEngined"
    filter "configurations:Release" runtime "Release"; staticruntime "Off"; targetname "io3DEngine"
    filter "configurations:Shipping" runtime "Release"; staticruntime "Off"; targetname "io3DEngine"; defines { "SHIPPING" }; targetdir "lib/lib_Shipping"
    filter "configurations:Shipping*" runtime "Release"; staticruntime "Off"; targetname "io3DEngine"; targetdir "lib/lib_Shipping"
    filter {}
    links { "winmm", "imm32", "LSLog", "ioFreeType", "ioPac" }
    filter "configurations:Debug" links { "LSLogd", "ioFreeTypeD", "ioPacd" }
    filter "configurations:Release or Shipping" links { "LSLog", "ioFreeType", "ioPac" }
    filter {}
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\io3DEngine" Version.h' }

-- ioFreeType : DLL, /MD
project "ioFreeType"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    files { "src/ioFreeType/**.h", "src/ioFreeType/**.cpp", "src/ioFreeType/**.rc" }
    includedirs { "src/ioFreeType", "src/ioFreeType/include", "ThirdParty/FreeType" }
    libdirs { "lib", "lib/FreeType" }
    Vpaths("src/ioFreeType")
    links { "LSLog" }
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "ioFreeTypeD"
    filter "configurations:Release" runtime "Release"; staticruntime "Off"; targetname "ioFreeType"
    filter {}

-- ioPac : DLL, /MD (+ Static variants + Static Patch)
project "ioPac"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    files { "src/ioPac/**.h", "src/ioPac/**.cpp", "src/ioPac/**.rc" }
    includedirs { "ThirdParty" }
    libdirs { "lib", "lib/ZipArchive" }
    Vpaths("src/ioPac")
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\ioPac" Version.h' }
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "ioPacd"; defines { "EXPORT_PAC_API", "_USRDLL" }
    filter "configurations:Release or Shipping" runtime "Release"; staticruntime "Off"; targetname "ioPac"; defines { "EXPORT_PAC_API", "_USRDLL" }
    filter "configurations:*Static*" kind "StaticLib"; targetdir "lib"; staticruntime "On"; defines { "STATIC_PAC_API" }
    filter "configurations:Debug Static" runtime "Debug"; targetname "ioPacStaticd"
    filter "configurations:Release Static" runtime "Release"; targetname "ioPacStatic"
    filter "configurations:Debug Static Patch" runtime "Debug"; targetname "ioPacStaticPatchd"; defines { "PATCH_PAC_API" }
    filter "configurations:Release Static Patch" runtime "Release"; targetname "ioPacStaticPatch"; defines { "PATCH_PAC_API" }
    filter {}

-- LSLog : DLL, /MD (+ Static variants)
project "LSLog"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    includedirs { "ThirdParty" }
    defines { "EXPORT_LS_LOG", "_USRDLL" }
    files { "src/LSLog/**.h", "src/LSLog/**.cpp", "src/LSLog/**.rc" }
    Vpaths("src/LSLog")
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "LSLogD"
    filter "configurations:Release or Shipping" runtime "Release"; staticruntime "Off"; targetname "LSLog"
    filter "configurations:*Static*" kind "StaticLib"; targetdir "lib"; staticruntime "On"; defines { "LSLOG_STATIC" }
    filter "configurations:Debug Static" runtime "Debug"; targetname "LSLogStaticd"
    filter "configurations:Release Static" runtime "Release"; targetname "LSLogStatic"
    filter {}

-- TownPortal : DLL, /MD (+ Static variants)
project "TownPortal"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    includedirs { "ThirdParty", "src/TownPortal/include" }
    defines { "EXPORT_TOWN_PORTAL", "_USRDLL", "TOWNPORTAL_EXPORTS" }
    files { "src/TownPortal/**.h", "src/TownPortal/**.cpp", "src/TownPortal/**.rc" }
    Vpaths("src/TownPortal")
    links { "LSLog" }
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "TownPortalD"
    filter "configurations:Release or Shipping" runtime "Release"; staticruntime "Off"; targetname "TownPortal"
    filter "configurations:*Static*" kind "StaticLib"; targetdir "lib"; staticruntime "On"
    filter "configurations:Debug Static" runtime "Debug"; targetname "TownPortalStaticd"
    filter "configurations:Release Static" runtime "Release"; targetname "TownPortalStatic"
    filter {}

-- FlashPlayerToDirectX (FlashDX) : DLL, /MD (+ Profile)
project "FlashDX"
    kind "SharedLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    files { "src/FlashPlayerToDirectX/**.h", "src/FlashPlayerToDirectX/**.cpp", "src/FlashPlayerToDirectX/**.rc" }
    includedirs { "src/FlashPlayerToDirectX", "ThirdParty/FlashDX", "lib" }
    multiprocessorcompile "Off"
    links { "shlwapi" }
    Vpaths("src/FlashPlayerToDirectX")
    filter "configurations:Debug" runtime "Debug"; staticruntime "Off"; targetname "FlashDXD"
    filter "configurations:Release" runtime "Release"; staticruntime "Off"; targetname "FlashDX"
    filter "configurations:Profile" runtime "Release"; staticruntime "Off"; targetname "FlashDX"; defines { "PROFILE" }
    filter {}

-- ErrorDlg : static lib
project "ErrorDlg"
    kind "StaticLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    staticruntime "On"
    includedirs { "ThirdParty", DXSDK .. "Include" }
    libdirs { DXSDK .. "Lib\\x86" }
    files { "src/ErrorDlg/**.h", "src/ErrorDlg/**.cpp" }
    Vpaths("src/ErrorDlg")
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\ErrorDlg\\ErrorDlg" Version.h' }
    filter "configurations:Debug" runtime "Debug"; targetname "ErrorDlgD"
    filter "configurations:Release" runtime "Release"; targetname "ErrorDlg"
    filter {}

-- OggVorbis : prebuilt libs in lib/OggVorbis, headers in ThirdParty/OggVorbis

------------------------------------------------------------------ apps
group "Apps"

-- LSClient / SurvivalProject2 : Windows app, configs Debug/Release/Shipping*
project "SurvivalProject2"
    kind "WindowedApp"
    language "C++"
    location "build"
    targetdir "../build/zone_novera/client/%{cfg.buildcfg}/%{prj.name}"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    pchheader "stdafx.h"; pchsource "src/LSClient/stdafx.cpp"
    buildoptions { "/Zm200", "/Zc:forScope-" }
    files { "src/LSClient/**.h", "src/LSClient/**.cpp", "src/LSClient/**.rc" }
    removefiles { "src/LSClient/blowfish.cpp", "src/LSClient/Channeling/ioChannelingNodeHappyTuk.cpp", "src/LSClient/ioFlameDashWeapon.cpp", "src/LSClient/Local/ioLocalPhilippine.cpp" }
    local D = "src/LSClient"
    grp(D, "GUI", "GUI/**")
    grp(D, "GameStage", "GameStage/**")
    grp(D, "Channeling", "Channeling/**")
    grp(D, "Local", "Local/**")
    grp(D, "HackShield", "HackShield/**")
    grp(D, "Housing", "Housing/**")
    grp(D, "IoString", "IoString/**")
    grp(D, "ioVoiceChat", "ioVoiceChat/*")
    grp(D, "LuaState", "LuaState/**")
    grp(D, "MiniDump", "MiniDump/**")
    grp(D, "nProtect", "nProtect/**")
    grp(D, "Xtrap", "Xtrap/**")
    grp(D, "XignCode", "XignCode/**")
    grp(D, "DataHeaders", "DataHeaders/**")
    grp(D, "Encode", "Encode/**")
    grp(D, "StateClass", "StateClass/**")
    grp(D, "TownPortal", "TownPortal/**")
    grp(D, "LSLog", "LSLog/**")
    grp(D, "AreaWeapon", "ioAreaWeapon*")
    grp(D, "Weapon/AttackAttribute", "ioAttackAttribute*")
    grp(D, "Weapon", "ioWeapon*")
    grp(D, "Item/WeaponItem", "io*WeaponItem*")
    grp(D, "Item/ArmorItems", "io*Armor*")
    grp(D, "Item/CloakItem", "io*Cloak*")
    grp(D, "Item/HelmetItem", "io*Helmet*")
    grp(D, "Item/WearItem", "io*Wear*")
    grp(D, "Item/ObjectItem", "io*ObjectItem*")
    grp(D, "Item/ExtendDash", "io*ExtendDash*")
    grp(D, "Item/ExtendJump", "io*ExtendJump*")
    grp(D, "Item", "io*Item*")
    grp(D, "Skill/AttackSkill", "io*AttackSkill*")
    grp(D, "Skill/NormalSkill", "io*NormalSkill*")
    grp(D, "Skill/RangeSkill", "io*RangeSkill*")
    grp(D, "Skill/PassiveSkill", "io*PassiveSkill*")
    grp(D, "Skill/BuffSkill", "io*BuffSkill*")
    grp(D, "Skill/MultiSkill", "io*MultiSkill*")
    grp(D, "Skill", "io*Skill*")
    grp(D, "Buff/MovementBuff", "io*MovementBuff*")
    grp(D, "Buff/HPBuff", "io*HPBuff*")
    grp(D, "Buff/ProtectBuff", "io*ProtectBuff*")
    grp(D, "Buff/StateBuff", "io*StateBuff*")
    grp(D, "Buff/SizeBuff", "io*SizeBuff*")
    grp(D, "Buff/GaugeBuff", "io*GaugeBuff*")
    grp(D, "Buff", "io*Buff*")
    grp(D, "GameEntity/PlayEntity", "io*PlayEntity*")
    grp(D, "GameEntity/WorldEntity", "io*WorldEntity*")
    grp(D, "GameEntity/CollisionBoxGrp", "io*CollisionBox*")
    grp(D, "GameEntity", "io*Entity*")
    grp(D, "GameStage", "ioGameStage*")
    grp(D, "Application", "ioApplication*")
    grp(D, "Network/TCP", "io*TCP*")
    grp(D, "Network/UDP", "io*UDP*")
    grp(D, "Network", "io*Network*", "io*Packet*")
    grp(D, "CameraEvent", "ioCameraEvent*")
    grp(D, "RenderHelp", "io*RenderHelp*", "io*TargetMarker*")
    grp(D, "Talisman", "ioTalisman*")
    grp(D, "RaceConfig", "ioRace*")
    grp(D, "ioBrowser", "ioBrowser*")
    grp(D, "GA", "ioGA*")
    grp(D, "Text", "ioText*")
    grp(D, "System/Housing", "io*Housing*")
    grp(D, "System/Pet", "io*Pet*")
    grp(D, "System/Guild", "io*Guild*")
    grp(D, "System/Shop", "io*Shop*")
    grp(D, "System/Quest", "io*Quest*")
    grp(D, "System/Tournament", "io*Tournament*")
    grp(D, "System/Event", "io*Event*")
    grp(D, "System/Costume", "io*Costume*")
    grp(D, "System/Mission", "io*Mission*")
    grp(D, "System/Level", "io*Level*")
    grp(D, "System/TradeInfo", "io*Trade*")
    grp(D, "System", "io*System*", "io*Manager*", "io*Camp*", "io*Medal*", "io*PowerUp*", "io*Spirit*", "io*BonusCash*", "io*SubScription*")
    vpaths { ["Source Files"] = { D.."/*.cpp" } }
    vpaths { ["Header Files"] = { D.."/*.h" } }
    vpaths { ["Resource Files"] = { D.."/**.rc" } }
    links { "LSLog", "io3DEngine", "TownPortal", "ioPac" }
    includedirs { "src", "src/io3DEngine", "ThirdParty", DXSDK .. "Include" }
    libdirs { "lib", "lib/Bullet", "lib/Xtrap", "lib/ioVoiceChat", "lib/LuaState", "lib/Squish", "lib/Opcode", "lib/TinyXML", "lib/DevIL", "lib/OggVorbis", DXSDK .. "Lib\\x86" }
    links { "Psapi", "DbgHelp", "Imagehlp", "wininet", "Urlmon", "Iphlpapi", "Version",
            "dinput8", "d3d9", "dxguid", "d3dx9", "winmm", "odbc32", "odbccp32", "Xinput", "Iepmapi",
            "HShield", "HSUpChk", "NPGameLib", "CrashFind" }
    filter "configurations:Debug"
        runtime "Debug"; staticruntime "Off"; targetname "SurvivalProject2D"
        defines { "NEXON_IP", "LOCAL_DBG", "BALANCE_RENEWAL" }
    filter "configurations:Release"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "NEXON_IP", "BALANCE_RENEWAL", "ICEMAWANG_AI_MODE" }
        links { "LS_HTTP_Client" }
    filter "configurations:Shipping"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "NEXON_IP", "BALANCE_RENEWAL", "SHIPPING", "POPUPSTORE", "ICEMAWANG_AI_MODE", "USE_GA" }
        links { "LS_HTTP_Client" }
    filter "configurations:Shipping_QA"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "NEXON_IP", "BALANCE_RENEWAL", "SHIPPING", "POPUPSTORE", "ICEMAWANG_AI_MODE", "USE_GA", "DEVELOPER_MACRO_DISABLE" }
        links { "LS_HTTP_Client" }
    filter "configurations:ShippingNProtect"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "NEXON_IP", "NPROTECT_CSAUTH3", "NPROTECT", "BALANCE_RENEWAL", "SHIPPING", "POPUPSTORE", "ICEMAWANG_AI_MODE", "USE_GA" }
        links { "LS_HTTP_Client" }
    filter "configurations:ShippingXtrap"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "XTRAP", "BALANCE_RENEWAL", "SHIPPING", "POPUPSTORE", "ICEMAWANG_AI_MODE", "USE_GA" }
        links { "LS_HTTP_Client" }
    filter "configurations:ShippingXigncode"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "SHIPPING", "XIGNCODE" }
    filter "configurations:ShippingHackShield"
        runtime "Release"; staticruntime "Off"; targetname "SurvivalProject2"
        defines { "SHIPPING", "HACKSHIELD", "THAILAND_LONG_ID" }
    filter {}
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\LSClient" Version.h' }

-- LSAutoUpgrade : Windows app (MFC Static, /MT), region Ship_* configs
project "LSAutoUpgrade"
    kind "WindowedApp"
    language "C++"
    location "build"
    targetdir "../build/zone_novera/client/%{cfg.buildcfg}/%{prj.name}"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    staticruntime "On"
    mfc "Static"
    files { "src/LSAutoUpgrade/**.h", "src/LSAutoUpgrade/**.cpp", "src/LSAutoUpgrade/**.rc" }
    removefiles { "src/LSAutoUpgrade/NMClass/*.cpp", "src/LSAutoUpgrade/Util/ioHashString.cpp" }
    Vpaths("src/LSAutoUpgrade")
    includedirs { "ThirdParty", DXSDK .. "Include" }
    libdirs { "lib", "lib/Xtrap", "lib/FireWall", "lib/ZipArchive", DXSDK .. "Lib\\x86" }
    links { "ws2_32", "winmm", "version", "Iphlpapi" }
    linkoptions { "/FORCE:MULTIPLE" }
    filter "configurations:Debug" runtime "Debug"; targetname "AutoUpgradeD"; defines { "SHIPPING" }
    filter "configurations:Debug_KoR" runtime "Debug"; targetname "AutoUpgradeD"; defines { "KAMU_EAC", "SRC_TH", "SHIPPING" }
    filter "configurations:Release" runtime "Release"; targetname "AutoUpgrade"; defines { "_ADMIN_", "SHIPPING" }
    filter "configurations:Shipping" runtime "Release"; targetname "AutoUpgrade"; defines { "SRC_KR", "SHIPPING" }
    filter "configurations:ShippingMac" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "MAC_ADDRESS" }
    filter "configurations:ShippingNoXtrap" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING" }
    filter "configurations:Ship_NA" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_NA", "XTRAP", "STEAM_ATTACH" }
    filter "configurations:Ship_BR" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_BR", "XTRAP", "STEAM_ATTACH" }
    filter "configurations:Ship_TH" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_TH" }
    filter "configurations:Ship_SA" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_SA" }
    filter "configurations:Ship_EU" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_EU" }
    filter "configurations:Ship_TW" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "MAC_ADDRESS", "SRC_OVERSEAS", "SRC_TW" }
    filter "configurations:Ship_ID" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_ID", "MAC_ADDRESS" }
    filter "configurations:Ship_PH" runtime "Release"; targetname "AutoUpgrade"; defines { "XTRAP", "SHIPPING", "SRC_OVERSEAS", "SRC_PH", "MAC_ADDRESS" }
    filter "configurations:Ship_SEA" runtime "Release"; targetname "AutoUpgrade"; defines { "SHIPPING", "SRC_OVERSEAS", "SRC_SEA", "MAC_ADDRESS" }
    filter {}
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\LSAutoUpgrade" Version.h' }

-- LSWebBroker : Windows app (MFC Static, /MT), region Rel_* configs
project "LSWebBroker"
    kind "WindowedApp"
    language "C++"
    location "build"
    targetdir "../build/zone_novera/client/%{cfg.buildcfg}/%{prj.name}"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    staticruntime "On"
    mfc "Static"
    files { "src/LSWebBroker/**.h", "src/LSWebBroker/**.cpp", "src/LSWebBroker/**.rc" }
    Vpaths("src/LSWebBroker")
    removeconfigurations { "Shipping*", "Profile", "*Static*", "Ship_*", "Debug_KoR" }
    includedirs { "ThirdParty" }
    libdirs { "lib", "lib/Netmarble" }
    links { "version", "Winmm" }
    linkoptions { "/FORCE:MULTIPLE" }
    filter "configurations:Debug" runtime "Debug"; targetname "LSWebBrokerD"; defines { "SRC_KR" }
    filter "configurations:Release" runtime "Release"; targetname "LSWebBroker"; defines { "SRC_KR" }
    filter "configurations:SRC_KOR" runtime "Release"; targetname "LSWebBroker"; defines { "SRC_KR", "SRC_KOR" }
    filter { "configurations:Rel_*" } runtime "Release"; targetname "LSWebBroker"; defines { "SRC_OVERSEAS" }
    filter "configurations:Rel_NA" defines { "SRC_NA" }
    filter "configurations:Rel_BR" defines { "SRC_BR" }
    filter "configurations:Rel_TH" defines { "SRC_TH" }
    filter "configurations:Rel_SA" defines { "SRC_SA" }
    filter "configurations:Rel_EU" defines { "SRC_EU" }
    filter "configurations:Rel_TW" defines { "SRC_TW" }
    filter "configurations:Rel_ID" defines { "SRC_ID" }
    filter "configurations:Rel_PH" defines { "SRC_PH" }
    filter "configurations:Rel_SEA" defines { "SRC_SEA" }
    filter {}
    prebuildcommands { '"$(ProjectDir)..\\scripts\\gen_version.bat" "$(ProjectDir)..\\src\\LSWebBroker" Version.h' }
