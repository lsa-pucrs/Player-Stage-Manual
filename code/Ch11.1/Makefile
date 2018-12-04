# Desc: SoX driver makefile
# CVS: $Id$

all: soxplayer.so
CXX = g++

%.o: %.cc
	$(CXX) -Wall -fpic -g3 `pkg-config --cflags playercore` -c $<

soxplayer.so: soxplayer.o
	$(CXX) -shared -lsox  `pkg-config --libs playercore` -o $@ $^

clean:
	rm -f *.o *.so
