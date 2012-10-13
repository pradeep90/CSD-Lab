	      ;; Hello World program
	      ;; [2012-08-07 Tue]

	      %include "io.mac"
	      %include "yo-boyz.asm"
	      .DATA
	      hello_world_str db	"Yo, boyz! I am sing song", 10, "Hello, world!", 0
	      yo_boyz_str db	"Yo, boyz!", 10, "Yo, boyz!", 0
	      arr   dd 1, 2, 3, 4, 5
	      .UDATA
	      .CODE
	      .STARTUP
HELLO_WORLD:
	      PutStr hello_world_str
	      nwln

	      mov   EAX, arr
	      mov   ECX, 5
	      sub   EDI, EDI
loop1:
	      ;; mov   DWORD  [arr + 4], 3
	      ;; mov   DWORD  [EAX + 4], 3
	      PutLInt [arr + EDI * 4]
	      PutLInt [EAX + EDI * 4]
	      inc EDI
	      loop loop1
	      ;; PutLInt [arr + 4]
	      ;; PutLInt [arr + 8]
	      ;; PutLInt [arr + 12]
	      ;; PutLInt [arr + 16]
	      call YO_BOYZ
	      .EXIT
