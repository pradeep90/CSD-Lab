	      ;; Program to sort elements of an array using merge sort.
	      ;; The original array is modified.
	      ;; [2012-08-09 Thu]
	      ;; Author - S Pradeep Kumar

	      %include "io.mac"
	      .DATA
	      MAX_SIZE EQU 25
	      %define ARR_LEN dword [n]

	      ;; Strings to be printed
	      PROMPT_ENTER_ARR_LEN db	"Enter size of your Array : ", 0
	      PROMPT_ENTER_ELEMENTS db	"Please enter elements of your array : ", 0
	      print_orig_array db	"Original Array ", 0
	      print_final_array	db	"Sorted Array ", 0
	      print_space db " ",0
	      merge_sort_debug_str db "Merge Sort Params: EAX, ECX: ", 0
	      merge_sort_end_debug_str db "End Merge Sort", 0
	      merge_debug_str db "Merge Params: EAX, EBX, ECX, EDX, EDI: ", 0
	      copy_debug_str db "Copy Params: EAX, EBX, ECX: ", 0
	      temp_array_debug_str db "Temp array: ", 0
	      merge_copy_back_temp_debug_str db "Merge Copy back temp array: ", 0
	      .UDATA
	      ;; Length of the array
	      n	    resd 1
	      ;; Array to be sorted
	      arr   resd MAX_SIZE
	      ;; Temporary storage array
	      temp_arr resd MAX_SIZE
	      .CODE
	      .STARTUP

;;; --------------------------------------------------
READ_ARR_LEN:			    
	      ;; Read the length of the array
	      PutStr PROMPT_ENTER_ARR_LEN
	      nwln
	      GetLInt [n]	    ; Size of input array
	      PutLInt [n]
	      nwln

;;; --------------------------------------------------
GET_ARRAY:
	      ;; Get values in arr from the user
	      mov   EAX, arr
	      mov   ECX, ARR_LEN
	      call  Read_Arr

	      ;; Print the original array
	      mov   ECX, ARR_LEN
	      PutStr print_orig_array
	      call  Print_Arr

	      ;; Run Merge Sort on the array
	      mov   EAX, arr
	      mov   EBX, temp_arr
	      mov   ECX, ARR_LEN
	      call  Merge_Sort

	      ;; Print the final array
	      PutStr print_final_array
	      call  Print_Orig_Arr
	      .EXIT

;;; --------------------------------------------------
Merge_Sort:
	      ;; EAX - Array start
	      ;; ECX - array length

	      ;; Arrays of size 0 or 1 are already sorted
	      cmp   ECX, 2
	      jl    Trivial_Merge_Sort

	      ;; Merge_Sort (first half)
	      ;; Length of the first half
	      ;; ECX /= 2
	      push  ECX
	      shr   ECX, 1
	      call  Merge_Sort
	      pop   ECX

	      ;; Merge_Sort (second half)
	      push  EAX
	      push  EBX
	      push  ECX

	      ;; Length of the second half
	      ;; ECX = ECX - ECX/2
	      mov   EDX, ECX
	      shr   EDX, 1
	      sub   ECX, EDX
	      imul  EDX, 4
	      ;; Start index of the second half
	      ;; EAX = EAX + (ECX/2) * 4
	      add   EAX, EDX
	      push  EDX
	      call  Merge_Sort
	      pop   EDX

	      pop   ECX
	      pop   EBX
	      pop   EAX

	      pushad
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
	      call  Merge
	      popad

	      ;; Copy back the merged array from temp_arr to arr
	      call  Merge_Copy_Back_Temp

	      ret

;;; --------------------------------------------------
Trivial_Merge_Sort:
	      ;; In case of arrays of length 0 or 1
	      ret
	      
;;; --------------------------------------------------
Merge:
	      ;; Merge two arrays contents.
	      ;; The final merged array will be in temp_arr
	      ;; Merging is done recursively.

	      ;; Arguments:
	      ;; EAX - First array's start
	      ;; EBX - Second array's start
	      ;; ECX - Length of first array
	      ;; EDX - Length of second array
	      ;; EDI - Index in temp array
	      pushad

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

	      ;; Recursively call Merge on the updated array and the
	      ;; other array
	      call  Merge
	      popad
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

	      ;; Recursively call Merge on the updated array and the
	      ;; other array
	      call  Merge
	      popad
	      ret

;;; --------------------------------------
Merge_Copy_Back_Temp:
	      ;; Copy back the temp array into original array
	      ;; Arguments:
	      ;; EAX - original array address
	      ;; ECX - original array length
	      pushad

	      ;; For copying back, the destination array is EAX
	      mov   EBX, EAX
	      ;; Now, the source array is temp_arr
	      mov   EAX, temp_arr
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
	      ;; because the first array is empty
	      pushad
	      mov   EAX, EBX
	      mov   ECX, EDX
	      mov   EBX, temp_arr
	      imul  EDI, 4
	      add   EBX, EDI
	      call  Copy_Array
	      popad
	      popad
	      ret

;;; --------------------------------------------------
Second_Array_Over:
	      ;; Copy the rest of the first array to the temp arr
	      ;; because the second array is empty
	      pushad
	      mov   EBX, temp_arr
	      imul  EDI, 4
	      add   EBX, EDI
	      call  Copy_Array
	      popad
	      popad
	      ret

;;; --------------------------------------------------
Copy_Array:
	      ;; Copy array to destination array
	      ;; EAX - Array start
	      ;; EBX - Destination array
	      ;; ECX - Array length

	      ;; Trivial case
	      cmp   ECX, 0
	      jz    Copy_Empty_Array

	      push  ECX
	      sub   EDI, EDI
copy_loop:
	      ;; Copy each element
	      push  dword [EAX + EDI * 4]
	      pop   dword [EBX + EDI * 4]
	      inc   EDI
	      loop  copy_loop

	      pop   ECX
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
	      ;; Read each element
	      GetLInt [ESI + EDI * 4]
	      inc   EDI
	      loop  loop1
	      ret

;;; --------------------------------------------------
Print_Temp_Arr:
	      ;; Print contents of temp_arr (for debugging)
	      pushad
	      mov EAX, temp_arr
	      mov ECX, ARR_LEN
	      call Print_Arr
	      popad
	      ret

;;; --------------------------------------------------
Print_Orig_Arr:
	      ;; Print contents of arr (for debugging)
	      pushad
	      mov EAX, arr
	      mov ECX, ARR_LEN
	      call Print_Arr
	      popad
	      ret

;;; --------------------------------------------------
Print_Arr:
	      ;; Print contents of an array
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
