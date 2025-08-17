ifndef EMSCRIPTEN
	CFLAGS = -g -O3
	SDL2_CONFIG = sdl2-config
	RISC_CFLAGS = $(CFLAGS) -std=c99 `$(SDL2_CONFIG) --cflags --libs`
	TARGET=xremu
	CC = clang
else
	CFLAGS = -g -O3 -sUSE_SDL=2 -sINITIAL_MEMORY=33554432 -sALLOW_MEMORY_GROWTH=1
	RISC_CFLAGS = $(CFLAGS) -std=c99 --preload-file bin
	CC = emcc
	TARGET=xremu.html
endif

ifdef PROFCPU
	CFLAGS += -DPROFCPU
endif

ifdef FASTMEMORY
	CFLAGS += -DFASTMEMORY
endif

ifdef DBG
	CFLAGS += -DDBG
endif

CFILES = src/main.c \
	src/fastmutex.h src/queue.h \
	src/xr17032fast.c src/xr.h \
	src/ebus.c src/ebus.h \
	src/ram256.c src/ram256.h \
	src/lsic.c src/lsic.h \
	src/serial.c src/serial.h \
	src/pboard.c src/pboard.h \
	src/kinnowfb.c src/kinnowfb.h src/kinnowpal.h \
	src/amtsu.c src/amtsu.h \
	src/keybd.c src/keybd.h \
	src/dks.c src/dks.h \
	src/rtc.c src/rtc.h \
	src/mouse.c src/mouse.h \
	src/screen.c src/screen.h \
	src/text.c src/text.h \
	src/tty.c src/tty.h \
	src/dbg.c

$(TARGET): $(CFILES)
ifdef EMSCRIPTEN
	rm -f bin/.DS_Store
	rm -f bin/nvram
endif

	$(CC) -o $@ $(filter %.c, $^) $(RISC_CFLAGS)

clean:
	rm -rf xremu*
