EXAMPLES = syntax
OS=$(shell uname)

CFLAGS = -fPIC -g3 -Wall -std=gnu99
all : $(EXAMPLES)

syntax : .FORCE
	mkdir -p bin
	leg -o src/syntax.leg.c src/syntax.leg
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/syntax.leg.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/stack.c
	$(CC) $(CFLAGS) -c src/content.c
	$(CC) $(CFLAGS) -c src/io.c
ifeq ($(OS), Darwin)
	$(CC) $(CFLAGS) -dynamiclib -shared -o libyapwtp.so syntax.leg.o bstrlib.o list.o content.o io.o stack.o
else
	$(CC) $(CFLAGS) -shared -o libyapwtp.so syntax.leg.o bstrlib.o list.o content.o io.o stack.o
endif
	$(CC) $(CFLAGS) -c src/main.c
	$(CC) $(CFLAGS) -o bin/parser main.o syntax.leg.o bstrlib.o list.o content.o io.o stack.o

testlist: .FORCE
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/stack.c
	$(CC) $(CFLAGS) -c src/testlist.c
	$(CC) $(CFLAGS) -o bin/testlist testlist.o bstrlib.o list.o

memtest: .FORCE
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/syntax.leg.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/stack.c
	$(CC) $(CFLAGS) -c src/content.c
	$(CC) $(CFLAGS) -c src/io.c
	$(CC) $(CFLAGS) -c src/memtest.c
	$(CC) $(CFLAGS) -o bin/memtest memtest.o syntax.leg.o bstrlib.o list.o content.o io.o stack.o


clean : .FORCE
	rm -rf bin/* *~ *.o *.[pl]eg.[cd] *.so *.a $(EXAMPLES)

.FORCE :
