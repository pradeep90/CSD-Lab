	      ;; Program to sort elements of an array using merge sort
	      ;; [2012-08-09 Thu]
	      ;; Author - S Pradeep Kumar

	      %include "io.mac"
	      .DATA
	      hello_world_str db	"Yo, boyz! I am sing song", 10, "Hello, world!", 0
	      .UDATA
	      .CODE
	      .STARTUP
HELLO_WORLD:
	      PutStr hello_world_str
	      nwln
.EXIT
