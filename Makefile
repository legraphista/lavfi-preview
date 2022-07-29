#
# Cross Platform Makefile
# Compatible with MSYS2/MINGW, Ubuntu 14.04.1 and Mac OS X
#
# You will need GLFW (http://www.glfw.org):
# Linux:
#   apt-get install libglfw-dev
# Mac OS X:
#   brew install glfw
# MSYS2:
#   pacman -S --noconfirm --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-glfw
#

#CXX = g++
#CXX = clang++

PKG_CONFIG_PATH = /usr/local/lib/pkgconfig
EXE = lavfi-preview
IMGUI_DIR = imgui
IMNODES_DIR = imnodes
SOURCES = main.cpp
SOURCES += $(IMGUI_DIR)/imgui.cpp $(IMGUI_DIR)/imgui_draw.cpp $(IMGUI_DIR)/imgui_tables.cpp $(IMGUI_DIR)/imgui_widgets.cpp
SOURCES += $(IMGUI_DIR)/backends/imgui_impl_glfw.cpp $(IMGUI_DIR)/backends/imgui_impl_opengl3.cpp
SOURCES += $(IMNODES_DIR)/imnodes.cpp
OBJS = $(addsuffix .o, $(basename $(notdir $(SOURCES))))
UNAME_S := $(shell uname -s)
LINUX_GL_LIBS = -lGL

CXXFLAGS = -ldl -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends -I$(IMNODES_DIR)
CXXFLAGS += -std=gnu++17 -lpthread -g -Wall -Wformat
LIBS =

##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------
# pkg-config  glfw3 --print-requires-private

ifeq ($(UNAME_S), Linux) #LINUX
	LIBS += $(LINUX_GL_LIBS) `pkg-config --libs glfw3`
	LIBS += `pkg-config --libs libavutil`
	LIBS += `pkg-config --libs libavcodec`
	LIBS += `pkg-config --libs libavformat`
	LIBS += `pkg-config --libs libswresample`
	LIBS += `pkg-config --libs libswscale`
	LIBS += `pkg-config --libs libavfilter`
	LIBS += `pkg-config --libs openal`
	LIBS += `pkg-config --libs x11`
	LIBS += `pkg-config --libs xrandr`
	LIBS += `pkg-config --libs xinerama`
	LIBS += `pkg-config --libs xxf86vm`
	LIBS += `pkg-config --libs xcursor`

	CXXFLAGS += `pkg-config --cflags glfw3`
	CXXFLAGS += `pkg-config --cflags libavutil`
	CXXFLAGS += `pkg-config --cflags libavcodec`
	CXXFLAGS += `pkg-config --cflags libavformat`
	CXXFLAGS += `pkg-config --cflags libswresample`
	CXXFLAGS += `pkg-config --cflags libswscale`
	CXXFLAGS += `pkg-config --cflags libavfilter`
	CXXFLAGS += `pkg-config --cflags openal`
	CXXFLAGS += `pkg-config --cflags x11`
	CXXFLAGS += `pkg-config --cflags xrandr`
	CXXFLAGS += `pkg-config --cflags xinerama`
	CXXFLAGS += `pkg-config --cflags xxf86vm`
	CXXFLAGS += `pkg-config --cflags xcursor`
	
	CFLAGS = $(CXXFLAGS)
endif

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(IMGUI_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(IMGUI_DIR)/backends/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(IMNODES_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo Build complete for lavfi-preview

$(EXE): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

clean:
	rm -f $(EXE) $(OBJS)
