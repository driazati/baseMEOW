build:
	nasm -felf64 meow.nasm
	ld meow.o -o meow

run: build
	echo meow | ./meow

big_run: build
	echo meowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeowmeow | ./meow

clean:
	rm -f meow.o meow
