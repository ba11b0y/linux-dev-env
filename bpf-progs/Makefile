SOURCES := $(wildcard *.kern.c)
FILES := $(SOURCES:.c=.o)
MAP_FINE_SRC := $(wildcard map-fine/*.kern.c)
MAP_FINE_OBJ := $(MAP_FINE_SRC:.c=.o)
MAP_FINE_USER_SRC := $(wildcard map-fine/*.user.c)
MAP_FINE_USER_OBJ := $(MAP_FINE_USER_SRC:.c=)
USER_SRC := $(wildcard *.user.c)
USER := $(USER_SRC:.c=)
BPF-CLANG := clang
BPF_CLANG_CFLAGS := -target bpf -g -Wall -O2 -c
INCLUDE := -I../linux/usr/include/ -I../linux/tools/lib/
USER-CFLAGS := -g -I../linux/usr/include -I../linux/tools/lib/ -L../linux/tools/lib/bpf/
LDFLAGS := -Wl,--version-script=libbpf.map -fvisibility=default

all: $(FILES) $(USER)
	
test: test.c
	$(BPF-CLANG) $(INCLUDE) $(BPF_CLANG_CFLAGS) -o test test.c

$(FILES) : %.o : %.c
	$(BPF-CLANG) $(INCLUDE) $(BPF_CLANG_CFLAGS) -o $@ $<

$(USER) : % : %.c
	gcc $(USER-CFLAGS) $< -lbpf $(LDFLAGS) -o $@

.PHONY : clean

clean :
	rm $(FILES) $(USER)
