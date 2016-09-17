﻿SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

OPTION(BUILD_BASE_LIB 			"Build Base Library"						TRUE	)
OPTION(BUILD_OPENGL_LIB			"Build OpenGL Library"						FALSE	)
OPTION(BUILD_OPENAL_LIB			"Build OpenAL Library"						FALSE	)
OPTION(BUILD_NETWORK_LIB		"Build Network Library"						TRUE	)

OPTION(BUILD_SCRIPT_ANGEL       "Build Script AngelScript"                  FALSE   )
OPTION(BUILD_SCRIPT_DEVIL       "Build Script DevilScript"                  FALSE   )

OPTION(BUILD_NETWORK_SCTP		"Include SCTP Support"						FALSE	)
OPTION(BUILD_NETWORK_UDP_LITE   "Include UDP-Lite Support"                  FALSE   )
# OPTION(BUILD_QT4_SUPPORT_LIB	"Build QT4 Support Library"					FALSE	)
OPTION(BUILD_QT5_SUPPORT_LIB	"Build QT5 Support Library"					FALSE	)
OPTION(BUILD_EXAMPLES_PROJECT	"Build Examples Project"					FALSE	)
OPTION(BUILD_TEST_PROJECT		"Build Test Project"						FALSE	)
OPTION(BUILD_GUI_TOOLS			"Build GUI Tools"							FALSE	)

OPTION(BUILD_OpenCart           "Build OpenCart Tools"                      FALSE   )

OPTION(LOG_INFO					"Output Log info"							TRUE	)
OPTION(LOG_INFO_THREAD			"Output Log info include ThreadPID"			TRUE	)
OPTION(LOG_INFO_TIME			"Output Log info include time"				TRUE	)
OPTION(LOG_INFO_SOURCE			"Output Log info include source and line"	OFF		)
OPTION(LOG_FILE_ONLY_ERROR 		"Only log error to file"					TRUE	)
OPTION(LOG_THREAD_MUTEX			"Log Thread Mutex"							TRUE	)
OPTION(LOG_CDB_LOADER_LOG		"Output CDBLoader log"						FALSE	)

IF(BUILD_OPENAL_LIB)
    OPTION(AUDIO_VORBIS_USE_TREMOR  "Vorbis Decode use Tremor"                  FALSE   )
    OPTION(AUDIO_VORBIS_USE_TREMOLO "Vorbis Decode use Tremolo"                 FALSE   )
ENDIF()

IF(BUILD_OPENGL_LIB)

	IF(UNIX)
		OPTION(OPENGL_USE_EGL		"Use EGL"				FALSE)
		OPTION(OPENGL_USE_WAYLAND	"Use Wayland-EGL"		FALSE)
	ENDIF()

	IF(WIN32 OR UNIX)
		OPTION(OPENGL_PROFILE_CORE		"Use OpenGL Core"		TRUE)
	ELSE()
		#OPTION(OPENGL_PROFILE_CORE		"Use OpenGL Core")
	ENDIF()

		OPTION(OPENGL_PROFILE_ES1		"Use OpenGL ES1")
		OPTION(OPENGL_PROFILE_ES2		"Use OpenGL ES2")
		OPTION(OPENGL_PROFILE_ES3		"Use OpenGL ES3")

	IF(OPENGL_PROFILE_CORE)
		ADD_DEFINITIONS("-DGLFW_INCLUDE_GLCOREARB")
		ADD_DEFINITIONS("-D_GLFW_USE_OPENGL")

		message("Use OpenGL Core")

		find_package(OpenGL REQUIRED)

		IF(UNIX)
			SET(HGL_OpenGL_LIB GL)
		ELSE()
			SET(HGL_OpenGL_LIB OpenGL32)
		ENDIF()
	ELSE()
		IF(OPENGL_PROFILE_ES1)
			ADD_DEFINITIONS("-DGLFW_INCLUDE_ES1")
			ADD_DEFINITIONS("-D_GLFW_USE_GLESV1")
			message("Use OpenGL ES1")
			SET(HGL_OpenGL_LIB GLESv1_CM)
			find_package(GLESv1 REQUIRED)
		ELSE()
			IF(OPENGL_PROFILE_ES2)
				ADD_DEFINITIONS("-DGLFW_INCLUDE_ES2")
				ADD_DEFINITIONS("-D_GLFW_USE_GLESV2")
				message("Use OpenGL ES2")
				SET(HGL_OpenGL_LIB GLESv2)
				find_package(GLESv2 REQUIRED)
			ELSE()
				IF(OPENGL_PROFILE_ES3)
					ADD_DEFINITIONS("-DGLFW_INCLUDE_ES3")
					ADD_DEFINITIONS("-D_GLFW_USE_GLESV3")
					message("Use OpenGL ES3")
					find_package(GLESv3 REQUIRED)
				ENDIF(OPENGL_PROFILE_ES3)
			ENDIF(OPENGL_PROFILE_ES2)
		ENDIF(OPENGL_PROFILE_ES1)
	ENDIF(OPENGL_PROFILE_CORE)

	IF(OPENGL_USE_EGL)
		IF(OPENGL_USE_WAYLAND)
			SET(HGL_OpenGL_LIB ${HGL_OpenGL_LIB} wayland-egl)
		ELSE()
			SET(HGL_OpenGL_LIB ${HGL_OpenGL_LIB} egl)
		ENDIF()
	ENDIF(OPENGL_USE_EGL)
ENDIF(BUILD_OPENGL_LIB)

IF(LOG_INFO)
	MESSAGE("Output LogInfo")
ELSE(LOG_INFO)
	add_definitions("-DNO_LOGINFO")
	MESSAGE("Don't output LogInfo")
ENDIF(LOG_INFO)

IF(LOG_INFO_THREAD)
	add_definitions("-DLOG_INFO_THREAD")
ENDIF(LOG_INFO_THREAD)

IF(LOG_INFO_TIME)
	add_definitions("-DLOG_INFO_TIME")
ENDIF(LOG_INFO_TIME)

IF(LOG_INFO_SOURCE)
	add_definitions("-DLOG_INFO_SOURCE")
ENDIF(LOG_INFO_SOURCE)

IF(LOG_THREAD_MUTEX)
	add_definitions("-DLOGINFO_THREAD_MUTEX")
	MESSAGE("LogInfo use ThreadMutex")
ELSE(LOG_THREAD_MUTEX)
	MESSAGE("LogInfo don't use ThreadMutex")
ENDIF(LOG_THREAD_MUTEX)

if(LOG_FILE_ONLY_ERROR)
	add_definitions("-DONLY_LOG_FILE_ERROR")
	MESSAGE("File Log only record ERROR")
else(LOG_FILE_ONLY_ERROR)
	MESSAGE("File Log record all.")
endif(LOG_FILE_ONLY_ERROR)

if(LOG_CDB_LOADER_LOG)
	add_definitions("-DLOG_CDB_LOADER_LOG")
endif(LOG_CDB_LOADER_LOG)

INCLUDE_DIRECTORIES(${CMGDK_PATH}/inc)
INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty)

IF(WIN32)
INCLUDE_DIRECTORIES(${CMGDK_PATH}/inc/win)
ENDIF(WIN32)

OPTION(MATH_USE_GLM             "Use OpenGL Mathematics"                FALSE	)
OPTION(MATH_USE_CML             "Use Configurable Math Library"         FALSE   )
OPTION(MATH_USE_MGL             "Use Game Math and Geometry Library"    TRUE	)

IF(MATH_USE_GLM)
    add_definitions(-DMATH_USE_GLM)

    INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/glm)
ENDIF(MATH_USE_GLM)

IF(MATH_USE_CML)
    add_definitions(-DMATH_USE_CML)
ENDIF(MATH_USE_CML)

IF(MATH_USE_MGL)
    add_definitions(-DMATH_USE_MGL)
    ADD_DEFINITIONS("-DMATH_USE_OPENGL")
    ADD_DEFINITIONS("-DMATH_RIGHTHANDED_CAMERA")

    INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/MathGeoLib/src)

    IF(WIN32)
        link_directories(${CMGDK_PATH}/3rdpty/MathGeoLib/${CMGDK_BUILD_TYPE})
    ELSE(WIN32)
        link_directories(${CMGDK_PATH}/3rdpty/MathGeoLib)
    ENDIF(WIN32)
ENDIF(MATH_USE_MGL)

IF(UNIX)
	FIND_PATH(ICONV_INCLUDE_DIR
		NAMES iconv.h
		HINTS
		/usr/include
		/usr/local/include)
	INCLUDE_DIRECTORIES(${ICONV_INCLUDE_DIR})

	IF(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
	FIND_PATH(ICONV_LIBRARY_DIR
		NAMES libiconv.so
		HINTS
		${LIB_3RD_FIND_HINT})
	LINK_DIRECTORIES(${ICONV_LIBRARY_DIR})
	ENDIF(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")

# 	FIND_PATH(MYSQL_INCLUDE_DIR
# 		NAMES mysql.h
# 		HINTS
# 		/usr/include
# 		/usr/include/mysql
# 		/usr/local/include
# 		/usr/local/include/mysql
# 		/usr/mysql/include/mysql)				#solaris 目录
# 	INCLUDE_DIRECTORIES(${MYSQL_INCLUDE_DIR})
#
# 	FIND_PATH(MYSQL_LIBRARY_DIR
# 		NAMES libmysqlclient.so
# 		HINTS
# 		${LIB_3RD_FIND_HINT}
# 		/usr/lib${HGL_BITS}/mysql
# 		/usr/local/lib${HGL_BITS}/mysql
# 		/usr/lib/mysql
# 		/usr/local/lib/mysql
#
# 		/usr/mysql/lib/${CMAKE_SYSTEM_PROCESSOR}/mysql	#solaris amd64 目录
# 		/usr/mysql/lib/mysql)
# 	LINK_DIRECTORIES(${MYSQL_LIBRARY_DIR})

# 	IF(BUILD_OPENAL_LIB)
# 		FIND_PATH(OPENAL_INCLUDE_DIR
# 			NAMES al.h
# 			HINTS
# 			/usr/include/AL
# 			/usr/local/include/AL)
# 		INCLUDE_DIRECTORIES(${OPENAL_INCLUDE_DIR})
#
# 		FIND_PATH(OPENAL_LIBRARY_DIR
# 			NAMES libopenal.so
# 			HINTS
# 			${LIB_3RD_FIND_HINT})
# 		LINK_DIRECTORIES(${OPENAL_LIBRARY_DIR})
# 	ENDIF(BUILD_OPENAL_LIB)
ENDIF(UNIX)

IF(WIN32)

# 	IF(BUILD_OPENAL_LIB)
# 		FIND_PATH(OPENAL_INCLUDE_DIR
# 			NAMES al.h
# 			HINTS
# 			${INC_3RD_FIND_HINT})
# 		INCLUDE_DIRECTORIES(${OPENAL_INCLUDE_DIR})
#
# 		FIND_PATH(OPENAL_LIBRARY_DIR
# 			NAMES libopenal.lib
# 			HINTS
# 			${LIB_3RD_FIND_HINT})
# 		LINK_DIRECTORIES(${OPENAL_LIBRARY_DIR})
# 	ENDIF(BUILD_OPENAL_LIB)
ENDIF(WIN32)

IF(BUILD_OPENGL_LIB)
	add_definitions("-DGLEW_STATIC")

	IF(WIN32)
		INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/opengl)
		#包含GLCoreARB.h wglext.h等文件
	ENDIF()

	INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/glew/include)
	SET(GLEW_SOURCE ${CMGDK_PATH}/3rdpty/glew/src/glew.c)

	INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/glfw/include/GLFW)
	LINK_DIRECTORIES(${CMGDK_PATH}/3rdpty/glfw/src)
ENDIF(BUILD_OPENGL_LIB)

SET(HGL_BASE_LIB CM.Base CM.UT CM.SceneGraph)

IF(MATH_USE_MGL)
    SET(HGL_BASE_LIB ${HGL_BASE_LIB} MathGeoLib)
ENDIF(MATH_USE_MGL)

IF(BUILD_OPENAL_LIB)
	SET(HGL_AUDIO_LIB CM.OpenALEE)
ENDIF(BUILD_OPENAL_LIB)

IF(BUILD_NETWORK_LIB)
	SET(HGL_NETWORK_LIB CM.Network)
ENDIF(BUILD_NETWORK_LIB)

# IF(BUILD_QT4_SUPPORT_LIB)
#
#     add_definitions("-DHGL_QT4")
#
# 	find_package(Qt4 REQUIRED)
#
# 	IF(WIN32)
# 		SET(HGL_QT_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/QT/PlatformQT4WinUTF16.cpp)
# 	ELSE()
# 		SET(HGL_QT_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/QT/PlatformQT4UnixUTF8.cpp)
# 	ENDIF()
#
# 	SET(HGL_QT_LIB CM.QT4Support)
# ENDIF()

IF(BUILD_QT5_SUPPORT_LIB)

    add_definitions("-DHGL_QT5")

    set(QT_MIN_VERSION "5.3.0")
    find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Core)

    include_directories(${Qt5Core_INCLUDES})
    add_definitions(${Qt5Core_DEFINITIONS})

	IF(WIN32)
		SET(HGL_QT_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/QT/PlatformQT5WinUTF16.cpp)
	ELSE()
		SET(HGL_QT_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/QT/PlatformQT5UnixUTF8.cpp)
	ENDIF()

	SET(HGL_QT_LIB CM.QT5Support)
ENDIF()

IF(UNIX)
	MESSAGE("Host OS is UNIX")

	SET(HGL_CONSOLE_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/UNIX/UnixConsole.cpp)
	SET(HGL_GRAPHICS_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/UNIX/UnixOpenGL.cpp)

	SET(HGL_BASE_LIB ${HGL_BASE_LIB} pthread dl rt)

	IF(USE_ELECTRIC_FENCE)
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} efence)
	ENDIF()

	IF(USE_GPERF_TOOLS)
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} tcmalloc)
	ENDIF(USE_GPERF_TOOLS)

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*Linux.*")
		IF(ANDROID)
			MESSAGE("Set Android HGL_BASE_LIB")
		ELSE(ANDROID)
			MESSAGE("Set Linux HGL_BASE_LIB")
		ENDIF(ANDROID)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*MacOS.*")
		MESSAGE("Set MacOS HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} iconv)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*FreeBSD.*")
		MESSAGE("Set FreeBSD HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} iconv)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*SunOS")
		MESSAGE("Set Solaris HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} socket nsl)
	ENDIF()

	IF(BUILD_NETWORK_SCTP)
		SET(HGL_NETWORK_LIB ${HGL_NETWORK_LIB} sctp)
		add_definitions("-DHGL_NETWORK_SCTP_SUPPORT")
	ENDIF(BUILD_NETWORK_SCTP)

	SET(HGL_CONSOLE_LIB ${HGL_BASE_LIB} ${HGL_NETWORK_LIB} expat)
	SET(HGL_GRAPHICS_LIB ${HGL_CONSOLE_LIB} CM.SceneGraphRender CM.RenderDevice glfw ${HGL_OpenGL_LIB} X11 Xxf86vm Xrandr Xcursor Xinerama Xi)
ELSE(UNIX)
	MESSAGE("Host OS don't is UNIX")
ENDIF(UNIX)

IF(WIN32)
	MESSAGE("Host OS is Windows")

	SET(HGL_CONSOLE_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/Win/WinConsole.cpp)
	SET(HGL_GRAPHICS_MAIN_SOURCE ${CMGDK_PATH}/src/Platform/Win/WinOpenGL.cpp)
	SET(HGL_CONSOLE_LIB ${HGL_BASE_LIB} ${HGL_NETWORK_LIB} ws2_32.lib)
	SET(HGL_GRAPHICS_LIB ${HGL_CONSOLE_LIB} CM.SceneGraphRender CM.RenderDevice ${HGL_OpenGL_LIB} OpenGL32.lib)

	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:msvcrt.lib ")
	SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmtd.lib;libcmt.lib")

ENDIF(WIN32)

IF (APPLE)
        SET(HGL_GUI_TYPE MACOSX_BUNDLE)
ELSEIF(WIN32)
        SET(HGL_GUI_TYPE WIN32)
ELSEIF(UNIX)
        SET(HGL_GUI_TYPE)
ENDIF()

message("")
message("CMGDK_BUILD_TYPE: " ${CMGDK_BUILD_TYPE})
message("CMAKE_SIZEOF_VOID_P = ${CMAKE_SIZEOF_VOID_P}")
message("")
MESSAGE("HGL_BASE_LIB: " ${HGL_BASE_LIB})
MESSAGE("HGL_NETWORK_LIB: " ${HGL_NETWORK_LIB})
MESSAGE("HGL_CONSOLE_LIB: " ${HGL_CONSOLE_LIB})
MESSAGE("HGL_GRAPHICS_LIB: " ${HGL_GRAPHICS_LIB})
MESSAGE("HGL_CONSOLE_MAIN_SOURCE: " ${HGL_CONSOLE_MAIN_SOURCE})
MESSAGE("HGL_GRAPHICS_MAIN_SOURCE: " ${HGL_GRAPHICS_MAIN_SOURCE})
MESSAGE("HGL_GUI_MAIN_SOURCE: " ${HGL_GUI_MAIN_SOURCE})
message("")
MESSAGE("Sytem: " ${CMAKE_SYSTEM})
MESSAGE("System Name: " ${CMAKE_SYSTEM_NAME})
MESSAGE("System Version: " ${CMAKE_SYSTEM_VERSION})
MESSAGE("System Processor: " ${CMAKE_SYSTEM_PROCESSOR})
MESSAGE("Generator: " ${CMAKE_GENERATOR})
message("")
MESSAGE("C Compiler: " ${CMAKE_C_COMPILER})
MESSAGE("C++ Compiler: " ${CMAKE_CXX_COMPILER})
message("")
MESSAGE("C Flags: " ${CMAKE_C_FLAGS})
MESSAGE("C++ Flags: " ${CMAKE_CXX_FLAGS})
MESSAGE("C Debug Flags: " ${CMAKE_C_FLAGS_DEBUG})
MESSAGE("C++ Debug Flags: " ${CMAKE_CXX_FLAGS_DEBUG})
MESSAGE("C Release Flags: " ${CMAKE_C_FLAGS_RELEASE})
MESSAGE("C++ Release Flags: " ${CMAKE_CXX_FLAGS_RELEASE})

