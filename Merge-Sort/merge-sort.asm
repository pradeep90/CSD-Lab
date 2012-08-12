	      ;; Program to sort elements of an array using merge sort.
	      ;; The original array is now sorted.
	      ;; [2012-08-09 Thu]
	      ;; Author - S Pradeep Kumar

	      %include "io.mac"
	      .DATA
	      MAX_SIZE EQU 25
	      arr   dd 3, 1, 4, 5, 2
	      n	    dd 5
	      PROMPT_ENTER_ARR_LEN db	"Enter size of your Array : ", 0
	      PROMPT_ENTER_ELEMENTS db	"Please enter elements of your array : ", 0
	      prompt_print_array db	"Array ", 0
	      print_space db " ",0
	      merge_sort_debug_str db "Merge Sort Params: EAX, ECX: ", 0
	      merge_sort_end_debug_str db "End Merge Sort", 0
	      merge_debug_str db "Merge Params: EAX, EBX, ECX, EDX, EDI: ", 0
	      copy_debug_str db "Copy Params: EAX, EBX, ECX: ", 0
	      temp_array_debug_str db "Temp array: ", 0
	      merge_copy_back_temp_debug_str db "Merge Copy back temp array: ", 0
	      %define ARR_LEN dword [n]
	      .UDATA
	      ;; n	    resd 1
	      ;; arr   resd MAX_SIZE
	      temp_arr resd MAX_SIZE
	      .CODE
	      .STARTUP

;;; --------------------------------------------------
READ_ARR_LEN:			    ; Read the length
	      ;; PutStr PROMPT_ENTER_ARR_LEN
	      ;; nwln
	      ;; GetLInt [n]	    ; Size of input array
	      ;; PutLInt [n]
	      ;; nwln

;;; --------------------------------------------------
GET_ARRAY:
	      mov   EAX, arr
	      mov   ECX, ARR_LEN
	      ;; call  Read_Arr

	      mov   ECX, ARR_LEN
	      PutStr prompt_print_array
	      call  Print_Arr

	      PutStr temp_array_debug_str
	      PutLInt temp_arr
	      nwln

	      mov   EAX, arr
	      mov   EBX, temp_arr
	      mov   ECX, ARR_LEN
	      call  Merge_Sort
	      call Print_Orig_Arr
.EXIT

;;; --------------------------------------------------
Merge_Sort:
	      ;; EAX - Array start
	      ;; ECX - array length

	      ;; pushad
	      PutStr merge_sort_debug_str
	      nwln
	      PutLInt EAX
	      PutStr print_space
	      PutLInt ECX
	      nwln

	      cmp   ECX, 2
	      jl    Trivial_Merge_Sort

	      ;; Merge_Sort (first half)
	      ;; ECX /= 2
	      push  ECX
	      shr   ECX, 1
	      call  Merge_Sort
	      pop   ECX

	      ;; Merge_Sort (second half)
	      push  EAX
	      push  EBX
	      push  ECX

	      ;; ECX = ECX - ECX/2
	      mov   EDX, ECX
	      shr   EDX, 1
	      sub   ECX, EDX
	      imul  EDX, 4
	      ;; EAX = EAX + ECX/2
	      add   EAX, EDX
	      push  EDX
	      call  Merge_Sort
	      pop   EDX

	      pop   ECX
	      pop   EBX
	      pop   EAX

	      ;; Merge (first half, second half)
	      ;; Length of first half = ECX/2
	      ;; Length of second half = ECX - ECX/2
	      mov   EDX, ECX
	      shr   ECX, 1
	      sub   EDX, ECX

	      ;; Start of second half = EAX + (ECX/2) * 4
	      mov   EBX, EAX
	      mov   EDI, ECX
	      imul  EDI, 4
	      add   EBX, EDI
	      ;; Index of temp array = 0
	      sub   EDI, EDI
	      call Merge
	      call Merge_Copy_Back_Temp

	      ;; popad
	      nwln
	      call Print_Temp_Arr
	      PutStr merge_sort_end_debug_str
	      nwln
	      ret

;;; --------------------------------------------------
Trivial_Merge_Sort:
	      ret
	      
;;; --------------------------------------------------
Merge:
	      ;; EAX - First array's start
	      ;; EBX - Second array's start
	      ;; ECX - Length of first array
	      ;; EDX - Length of second array
	      ;; EDI - Index in temp array
	      pushad

	      PutStr merge_debug_str
	      nwln
	      PutLInt EAX
	      PutStr print_space
	      PutLInt EBX
	      PutStr print_space
	      PutLInt ECX
	      PutStr print_space
	      PutLInt EDX
	      PutStr print_space
	      PutLInt EDI
	      call  Print_Temp_Arr
	      PutStr prompt_print_array
	      call  Print_Orig_Arr

	      ;; Handle the cases where one array is empty
	      cmp   ECX, 0
	      jz    First_Array_Over
	      cmp   EDX, 0
	      jz    Second_Array_Over

	      ;; Compare first elements of both the arrays
	      push  EDX
	      push  EDI
	      mov   EDX, [EAX]
	      mov   EDI, [EBX]
	      cmp   EDX, EDI
	      pop   EDI
	      pop   EDX
	      ;; Pick which ever is the least and update that array
	      jl    Update_First_Array
	      jmp   Update_Second_Array

;;; --------------------------------------------------
Update_First_Array:
	      ;; min_elem = min (first elements of first array and second array)
	      ;; Put min_elem into the temp array
	      push  dword [EAX]
	      pop   dword [temp_arr + EDI * 4]
	      add   EAX, 4
	      dec   ECX
	      inc   EDI
	      call  Merge
	      popad

	      ;; TODO: Copy it all back to the original array
	      ;; call Merge_Copy_Back_Temp
	      ret

;;; --------------------------------------------------
Update_Second_Array:
	      ;; min_elem = min (first elements of first array and second array)
	      ;; Put min_elem into the temp array
	      push  dword [EBX]
	      pop   dword [temp_arr + EDI * 4]
	      add   EBX, 4
	      dec   EDX
	      inc   EDI
	      call  Merge
	      popad
	      ;; TODO: Copy it all back to the original array
	      ;; call Merge_Copy_Back_Temp
	      ret

;; ;;; --------------------------------------------------
Merge_Copy_Back_Temp:
	      ;; Copy back the temp array into original array
	      ;; EAX - First array's start
	      ;; EBX - Second array's start
	      ;; ECX - Length of first array
	      ;; EDX - Length of second array
	      ;; EDI - Index in temp array
	      pushad
	      nwln
	      PutStr merge_copy_back_temp_debug_str
	      add   ECX, EDX
	      mov   EBX, EAX
	      mov   EAX, temp_arr
	      imul  EDI, 4
	      add   EAX, EDI
	      call  Copy_Array
	      popad
	      ret

;;; --------------------------------------------------
Trivial_Merge:
	      ;; Note: One array is empty means no need to merge.
	      popad
	      ret

;;; --------------------------------------------------
First_Array_Over:
	      ;; Copy the rest of the second array to the temp arr
	      pushad
	      mov   EAX, EBX
	      mov   ECX, EDX
	      mov   EBX, temp_arr
	      imul  EDI, 4
	      add   EBX, EDI
	      call  Copy_Array
	      popad
	      popad
	      ;; call Merge_Copy_Back_Temp
	      ret

;;; --------------------------------------------------
Second_Array_Over:
	      ;; Copy the rest of the first array to the temp arr
	      pushad
	      mov   EBX, temp_arr
	      imul  EDI, 4
	      add   EBX, EDI
	      call  Copy_Array
	      popad
	      popad
	      ;; call Merge_Copy_Back_Temp
	      ret

;;; --------------------------------------------------
Copy_Array:
	      ;; Copy array to destination array
	      ;; EAX - Array start
	      ;; EBX - Destination array
	      ;; ECX - Array length
	      PutStr copy_debug_str
	      nwln
	      PutLInt EAX
	      PutStr print_space
	      PutLInt EBX
	      PutStr print_space
	      PutLInt ECX
	      nwln

	      cmp   ECX, 0
	      jz    Copy_Empty_Array

	      push  ECX
	      sub   EDI, EDI
copy_loop:
	      push  dword [EAX + EDI * 4]
	      pop   dword [EBX + EDI * 4]
	      ;; mov   EDX, [EAX + EDI * 4]
	      ;; mov   [EBX + EDI * 4], EDX
	      inc   EDI
	      loop  copy_loop

	      pop   ECX
	      sub   EDI, EDI
copy_print_loop:
	      PutLInt [EBX + EDI * 4]
	      inc   EDI
	      loop  copy_print_loop

	      ;; PutStr copy_debug_str
	      ;; nwln
	      ret

Copy_Empty_Array:
	      ret

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
Print_Temp_Arr:
	      pushad
	      mov EAX, temp_arr
	      mov ECX, ARR_LEN
	      call Print_Arr
	      popad
	      ret

;;; --------------------------------------------------
Print_Orig_Arr:
	      pushad
	      mov EAX, arr
	      mov ECX, ARR_LEN
	      call Print_Arr
	      popad
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
