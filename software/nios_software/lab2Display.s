/* Lab 2 Display */



.global main
main:
	movia r4, 0x40
	movia r5, 0x11020
DONE: stwio r4, 0(r5)
end:
br end
