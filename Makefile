CFLAGS = -std=c11 -fprofile-arcs -ftest-coverage  -fPIC -D_GNU_SOURCE -fvisibility=hidden -Wall -Wextra
LDFLAGS = -Wl,--as-needed
LDLIBS = -lpthread
OBJECTS = alloc.o bump.o chunk.o extent.o huge.o memory.o mutex.o purge.o
BINARIES = alloc.so test_main
#BINARIES = alloc.so test_small test_large test_huge
#g++ -fprofile-arcs -ftest-coverage -fPIC -O0 example1.cpp -o program
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CFLAGS += -Og -g
else
	CFLAGS += -flto -O2 -DNDEBUG
	LDFLAGS += -flto -O2
endif

all: $(BINARIES)

alloc.so: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -shared $^ $(LDLIBS) -o $@

test_main: test_main.c $(OBJECTS)
#test_small: test_small.c $(OBJECTS)
#test_large: test_large.c $(OBJECTS)
#test_huge: test_huge.c $(OBJECTS)

alloc.o: alloc.c arena.h bump.h chunk.h chunk.h huge.h memory.h mutex.h purge.h util.h
bump.o: bump.c bump.h chunk.h memory.h mutex.h
chunk.o: chunk.c chunk.h extent.h memory.h mutex.h
extent.o: extent.c bump.h extent.h mutex.h
huge.o: huge.c arena.h chunk.h huge.h memory.h purge.h mutex.h util.h
memory.o: memory.c memory.h
mutex.o: mutex.c mutex.h util.h
purge.o: purge.c purge.h

clean:
	rm -f $(OBJECTS) $(BINARIES)
	rm -rf *.gcno
	rm -rf *.gcda
	rm -rf *.html

.PHONY: all clean
