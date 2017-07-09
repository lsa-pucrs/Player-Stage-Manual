# Desc: SoX driver makefile
# CVS: $Id$

all: libsoxplayer.so

%.o: %.cc
	$(CXX) -Wall -fpic -g3 `pkg-config --cflags playercore` -c $<

libsoxplayer.so: exampledriver.o
	$(CXX) -shared -nostartfiles -o $@ $^

clean:
	rm -f *.o *.so
