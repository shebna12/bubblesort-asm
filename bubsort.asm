%include "asm_io.inc"

segment .data
	numvalmsg dw "How many numbers would you like to sort?  ",0
	getmsg 		dw 		"Input your values:  ",0
	comma dw " , ",0

segment .bss
	arraySize resd 1
	array 			resd 		100
	counter resd 1
	size resd 1
	storer resd 1
	ecxStorer resd 1

;--------------------------------
;	void _asm_main(int n){
;		arr[x] = n;
;	}
;
segment .txt 
		global _asm_main
	_asm_main:
		enter 0,0
		pusha
		
		mov dword[counter],0
		
		mov eax, numvalmsg
		call print_string
		
		call read_int
		mov dword[arraySize],eax
		
		mov eax, getmsg
		call print_string
		
		mov ecx,0
		mov edi,dword[arraySize] ; edi is n
		

		storing: ;getting num
		
		call read_int
		mov [array + ecx],eax

		add ecx,4
		inc dword[counter]

		cmp dword[counter],edi ;edi is the arraysize
		jl storing
		mov ecx,0
		mov dword[counter],0
		jmp origprint

		origprint: ;printing
		mov eax,[array + ecx]
		call print_int
		mov eax,comma
		inc dword[counter]
		cmp dword[counter],edi
		je initX
		call print_string
		add ecx,4
		jmp origprint

		initX:
		call print_nl
		mov ebx,0 ; for the x

		loopx:
		mov ecx,0 ;for the array indices
		
		cmp ebx,edi 
		je ends

		mov esi,0	; for the y
		mov eax,edi

		sub eax,1
		mov dword[storer],eax ;para indi ma islan value  sang eax when printing


		loopy:
		mov eax,[storer]
		call print_nl
		;call print_int
		cmp esi,eax   ; eax is for n-1
		jl loopyIf 
		inc ebx
		jmp loopx

		loopyIf:
		 
		mov ebp,[array + ecx]
		cmp ebp,[array + ecx+4]
		jle loopyElse
		mov edx,[array +ecx+4] ; for the temp
		mov [array + ecx+4],ebp
		mov ebp,edx
		mov [array + ecx],ebp

		add ecx,4
		mov dword[ecxStorer],ecx
		inc esi

		init:
		call print_nl
		mov ecx,0
		mov dword[counter],0
		jmp printloopy

		printloopy:
		mov eax,[array + ecx]
		call print_int
		mov eax,comma
		inc dword[counter]
		cmp dword[counter],edi
		je preloopback
		call print_string
		add ecx,4
		jmp printloopy

		preloopback:
		mov ecx,[ecxStorer]
		jmp loopy

		loopyElse:
		add ecx,4
		mov dword[ecxStorer],ecx
		inc esi
		jmp init


		ends:
		popa
		leave
		ret