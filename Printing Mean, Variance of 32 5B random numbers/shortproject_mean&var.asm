include irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode: DWORD

.DATA
randarray BYTE 160 DUP(0)
sum	BYTE 6 DUP(0)
mean BYTE 5 DUP(0)


sumdev BYTE 11 DUP(0)
deviation BYTE 160 DUP(0)
variance BYTE 10 DUP(0)  



.CODE
main PROC

call Crlf


mov ecx, 160
mov esi, 0

L1: call random32
mov randarray[esi], al
inc esi
Loop L1

mov esi, 159
mov ecx, 32
L2: push ecx
	mov ecx, 5	
	call crlf;     
L3 : mov al, randarray[esi]
	mov ebx, 1
	call WriteHexB
	dec esi
	Loop L3
	pop ecx
	Loop L2


mov esi, 0
mov ecx, 32
L4: push ecx
	mov ecx, 5
	mov edi, 0
	clc

L5 :
	mov al, randarray[esi]
	adc sum[edi], al
	inc esi
	inc edi
	Loop L5
	pop ecx
	adc sum[edi], 0
	Loop L4

call crlf; 
call crlf; 


mov esi, 5
mov ecx, 6
L6:
	mov al, sum[esi]
	call WriteHexB
	dec esi
	Loop L6


call crlf; 
call crlf; 



mov esi, 0
mov ecx, 5
L7:
shr sum[esi + 5], 1
rcr sum[esi + 4], 1
rcr sum[esi + 3], 1
rcr sum[esi + 2], 1
rcr sum[esi + 1], 1
rcr sum[esi], 1
Loop L7
mov ecx, 5
L8: mov al, BYTE PTR sum[esi]
mov BYTE PTR mean[esi], al
	inc esi
	Loop L8


mov esi, 4
mov ecx, 5
L9:
mov al, sum[esi]
call WriteHexB
dec esi
Loop L9



call crlf
call crlf
call crlf
call crlf
call crlf
call crlf



; deviation
mov esi, 0
mov edi, 0
mov ebx, 0
mov ecx, 32
L10:clc
mov al, BYTE PTR mean[esi + 4]
cmp al, BYTE PTR randarray[edi + 4]
jb L11
ja L12
mov eax, DWORD PTR mean[esi + 4]
cmp eax, DWORD PTR randarray[edi + 4]
ja L12
L11 : mov eax, DWORD PTR randarray[edi]
sub eax, DWORD PTR mean[esi]
mov bl, BYTE PTR randarray[edi + 4]
sbb bl, BYTE PTR mean[esi + 4]
jmp L13
L12 : mov eax, DWORD PTR mean[esi]
sub eax, DWORD PTR randarray[edi]
mov bl, BYTE PTR mean[esi + 4]
sbb bl, BYTE PTR randarray[edi + 4]
L13 : mov DWORD PTR deviation[edi], eax
mov BYTE PTR deviation[edi + 4], bl
add edi, 5
loop L10




mov edi, 159
mov eax, 0
mov ecx, 32
L14: push ecx
mov ecx, 5
L15 : mov al, BYTE PTR deviation[edi]
dec edi
mov ebx, 1
call WriteHexB
loop L15
call Crlf

pop ecx
loop L14


mov eax, 0
mov edx, 0
mov edi, 0
mov esi, 0
mov ecx, 32
L16: pushfd
	mov eax, DWORD PTR deviation[edi]
	mul DWORD PTR deviation[edi]	
	popfd
	add DWORD PTR sumdev[esi], eax    
	adc DWORD PTR sumdev[esi + 4], edx
	adc BYTE PTR sumdev[esi + 8], 0
	pushfd
	mov eax, 0
	mov al, BYTE PTR deviation[edi + 4]
	shl al, 1
	mul DWORD PTR deviation[edi]     
	popfd
	add DWORD PTR sumdev[esi + 4], eax	
	adc BYTE PTR sumdev[esi + 8], dl
	adc BYTE PTR sumdev[esi + 9], 0
	pushfd
	mov eax, 0
	mov al, BYTE PTR deviation[edi + 4]
	mul BYTE PTR deviation[edi + 4]
	popfd
	add DWORD PTR sumdev[esi + 8], eax
	add edi, 5
	clc
	loop L16


call crlf
mov ecx, 11
mov edi, 10
mov ebx, 1
L17: mov al, sumdev[edi]
	call WriteHexB
	dec edi
	loop L17

	call crlf
	call crlf


;setting variance 
mov esi, 0
mov ecx, 5
L18:shr sumdev[esi + 10], 1
	rcr sumdev[esi + 9], 1
	rcr sumdev[esi + 8], 1
	rcr sumdev[esi + 7], 1
	rcr sumdev[esi + 6], 1
	rcr sumdev[esi + 5], 1
	rcr sumdev[esi + 4], 1
	rcr sumdev[esi + 3], 1
	rcr sumdev[esi + 2], 1
	rcr sumdev[esi + 1], 1
	rcr sumdev[esi], 1
	loop L18


	mov ecx, 10
	L19: mov al, BYTE PTR sumdev[esi]
	mov BYTE PTR variance[esi], al
	inc esi
	Loop L19

	mov esi, 9
	mov ecx, 10
	L20:
mov al, sumdev[esi]
call WriteHexB
dec esi
Loop L20


call crlf
call crlf


call crlf
INVOKE ExitProcess, 0
main ENDP
END main
