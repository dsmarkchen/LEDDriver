led-driver: led-driver.w
	ctangle $<
	cp $@.c $@.cpp
	gcc -x c++  -c -I ../cppunit/include $@.cpp
	gcc -L ../cppunit/lib  $@.o -o $@.bin -lcppunit -lstdc++
	cweave $<
	pdftex $@.tex
	
