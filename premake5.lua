-- NOVERAOSS-Client premake5
-- Toolset: VS2010 (v100). CRT: mixed per original.
-- Configs: Debug, Release, Shipping*, Static variants, Profile, region Ship_*/Rel_*.

local DXSDK = os.getenv("DXSDK_DIR") or "C:\\Program Files (x86)\\Microsoft DirectX SDK (June 2010)\\"

local function Vpaths(projDir)
    vpaths {
        ["Source Files"]    = { projDir .. "/*.cpp" },
        ["Header Files"]    = { projDir .. "/*.h" },
        ["Resource Files"]   = { projDir .. "/*.rc" },
        ["*"]                = { projDir .. "/**.cpp", projDir .. "/**.h", projDir .. "/**.rc", projDir .. "/**.txt" },
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
    includedirs { "ThirdParty/Bullet", "ThirdParty", "ThirdParty/DevIL", "src/OggVorbis/include", DXSDK .. "Include" }
    libdirs { "lib", "lib/Bullet", "lib/Squish", "lib/Opcode", "lib/TinyXML", "lib/DevIL", "lib/OggVorbis", DXSDK .. "Lib\\x86" }
    files { "src/io3DEngine/**.h", "src/io3DEngine/**.cpp", "src/io3DEngine/**.rc" }
    Vpaths("src/io3DEngine")
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
    includedirs { "src/ioFreeType", "src/ioFreeType/include", "src/ioFreeType/FreeType/include" }
    libdirs { "lib", "src/ioFreeType/FreeType/Lib" }
    Vpaths("src/ioFreeType")
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
    includedirs { "src/FlashPlayerToDirectX", "src/FlashPlayerToDirectX/Include", "lib" }
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
    includedirs { DXSDK .. "Include" }
    libdirs { DXSDK .. "Lib\\x86" }
    files { "src/ErrorDlg/**.h", "src/ErrorDlg/**.cpp" }
    Vpaths("src/ErrorDlg")
    filter "configurations:Debug" runtime "Debug"; targetname "ErrorDlgD"
    filter "configurations:Release" runtime "Release"; targetname "ErrorDlg"
    filter {}

-- OggVorbis : static lib (build from source)
project "OggVorbis"
    kind "StaticLib"
    language "C++"
    location "build"
    targetdir "lib"
    objdir "build/obj/%{cfg.buildcfg}/%{prj.name}"
    staticruntime "On"
    files { "src/OggVorbis/**.h", "src/OggVorbis/**.c", "src/OggVorbis/**.cpp" }
    Vpaths("src/OggVorbis")
    filter "configurations:Debug" runtime "Debug"; targetname "OggVorbisD"
    filter "configurations:Release" runtime "Release"; targetname "OggVorbis"
    filter {}

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
    Vpaths("src/LSClient")
    includedirs { "src", "src/io3DEngine", "ThirdParty", "ThirdParty/HackShield", "ThirdParty/nProtect", "ThirdParty/Xtrap", "ThirdParty/XignCode", "ThirdParty/Themida", "ThirdParty/Bandicap", DXSDK .. "Include" }
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
    includedirs { "ThirdParty", "ThirdParty/Xtrap", "ThirdParty/Themida", DXSDK .. "Include" }
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
    includedirs { "ThirdParty", "ThirdParty/NMCrypt" }
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
