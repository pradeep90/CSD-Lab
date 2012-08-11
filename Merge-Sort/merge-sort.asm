	      ;; Program to sort elements of an array using merge sort
	      ;; [2012-08-09 Thu]
	      ;; Author - S Pradeep Kumar

	      %include "io.mac"
	      .DATA
	      MAX_SIZE EQU 25
	      PROMPT_ENTER_ARR_LEN db	"Enter size of your Array : ", 0
	      PROMPT_ENTER_ELEMENTS db	"Please enter elements of your array : ", 0
	      prompt_print_array db	"Array ", 0
	      print_space db " ",0
	      merge_sort_debug_str db "Merge Sort Params: EAX, ECX: ", 0
	      %define ARR_LEN dword [n]
	      .UDATA
	      n	    resd 1
	      arr   resd MAX_SIZE
	      .CODE
	      .STARTUP

;;; --------------------------------------------------
READ_ARR_LEN:			    ; Read the length
	      ;; PutStr PROMPT_ENTER_ARR_LEN
	      ;; nwln
	      GetLInt [n]	    ; Size of input array
	      PutLInt [n]
	      nwln

;;; --------------------------------------------------
GET_ARRAY:
	      mov   EAX, arr
	      mov   ECX, ARR_LEN
	      call  Read_Arr

	      mov   ECX, ARR_LEN
	      PutStr prompt_print_array
	      call  Print_Arr

	      mov   EAX, arr
	      mov   ECX, ARR_LEN
	      call  Merge_Sort
.EXIT

;;; --------------------------------------------------
Merge_Sort:
	      ;; EAX - Array start
	      ;; ECX - array length
	      
	      PutStr merge_sort_debug_str
	      nwln
	      PutLInt EAX
	      PutStr print_space
	      PutLInt ECX
	      nwln

	      cmp   ECX, 2
	      jl    Trivial_Merge_Sort

	      ;; Merge_Sort (first half)
	      push  ECX
	      shr   ECX, 1
	      call  Merge_Sort
	      pop   ECX

	      ;; Merge_Sort (second half)
	      push  ECX
	      push  EAX
	      push  EBX

	      mov   EBX, ECX
	      shr   EBX, 1
	      sub   ECX, EBX
	      imul  EBX, 4
	      add   EAX, EBX
	      call  Merge_Sort

	      pop   EBX
	      pop   EAX
	      pop   ECX

	      ;; Merge (first half, second half)

	      ret

;;; --------------------------------------------------
Trivial_Merge_Sort:
	      ret
	      
;;; --------------------------------------------------
Merge:

;;; --------------------------------------------------
;;; Macro to calculate current middle index of array 
	      %macro MIDDLE_INDEX 3
	      mov   %3, %1	    ;;; 
	      add   %3, %2	    ;;
	      shr   %3, 1	    ;;
	      %endmacro

;;; --------------------------------------------------
Read_Arr:
	      ;; EAX - array start
	      ;; ECX - array length
	      PutStr PROMPT_ENTER_ELEMENTS
	      nwln
	      mov   ESI, EAX
	      sub   EDI, EDI
loop1:
	      ;; Maybe make this use some more appropriate addressing
	      ;; mode. I guess ESI is the only register allowed in
	      ;; [R1 + R2] addressing mode
	      GetLInt [ESI + EDI * 4]
	      inc   EDI
	      loop  loop1
	      ret

;;; --------------------------------------------------
Print_Arr:
	      ;; EAX - Array start
	      ;; ECX - array length
	      nwln
	      mov   ESI, EAX
	      sub   EDI, EDI
new_loop1:
	      PutLInt [ESI + EDI * 4]
	      PutStr print_space
	      inc   EDI
	      loop  new_loop1
	      nwln
	      ret
