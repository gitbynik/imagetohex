CC       := gcc
CFLAGS   := -I src/include
LDFLAGS  :=
LIBS     :=
WINLIBS	 := -lole32 -loleaut32 -luuid -lpropsys -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lshell32 -lversion -lsetupapi -lcfgmgr32

BUILD ?= normal

TARGET   := imgtohex
SRCS     := imgtohex.c
OBJS     := $(SRCS:.c=.o)

ifeq ($(OS),Windows_NT)
	LIBS     += -lmingw32 -lSDL2main -lSDL2 -lSDL2_image
	LDFLAGS  += -mwindows -L src/lib

	RC 		 := windres
	RES		 := app.o
	RC_SRC	 := src/res/app.rc
	
	RM		 := del /Q
	NULL 	 := nul
	ifeq ($(BUILD),monolithic)
		LIBS 	+= $(WINLIBS)
		LDFLAGS += -static
	endif
else
	LIBS += -lSDL2main -lSDL2 -lSDL2_image

	RC 		:= 
	RES		:=
	RC_SRC	:=

	RM 		:= rm -f
	NULL 	:= /dev/null
endif

all: $(TARGET)

$(TARGET): $(OBJS) $(RES)
	$(CC) $(OBJS) $(RES) -o $@ $(LDFLAGS) $(LIBS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

$(RES): $(RC_SRC)
	$(RC) $< -O coff -o $@

clean:

	-$(RM) $(OBJS) $(RES) 2>$(NULL) || true
