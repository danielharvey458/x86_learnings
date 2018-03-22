  section .text
  global mean_impl
  global std_impl

std_impl:
  push rbp
  mov  rbp, rsp
  ; rdi - address of std result
  ; rsi - address of mean value
  ; rdx - address of data
  ; rcx - number of elements

  ; ymm0 will accumulate the mean deviation
  vxorpd ymm0, ymm0

  ; ymm1 will store the mean
  vbroadcastsd ymm1, [rsi]

  xor r8, r8

.more:
  cmp r8, rcx
  je .done

  ; Load the next set of values
  vmovapd ymm2, [rdx + 8 * r8]
  ; Subtract the mean
  vsubpd ymm2, ymm1
  ; Square it
  vmulpd ymm2, ymm2
  ; Add to accumlated result
  vaddpd ymm0, ymm2

  add r8, 0x4
  jmp .more 

.done:
  vextractf128 xmm1, ymm0, 1
  vextractf128 xmm2, ymm0, 0
  vaddpd xmm1, xmm2
  vhaddpd xmm0, xmm1, xmm1
  cvtsi2sd xmm1, rcx
  vdivsd xmm0, xmm1
  vsqrtsd xmm0, xmm0
  vmovsd [rdi], xmm0

  leave
  ret

mean_impl:
  push rbp
  mov  rbp, rsp
  ; rdi - address of the mean result
  ; rsi - address of the data
  ; rdx - size of the data

  vxorpd ymm0,ymm0
  xor r8, r8

.more:
  cmp r8, rdx
  je .done
  vmovapd ymm1, [rsi + 8 * r8]
  vaddpd ymm0, ymm1
  add r8, 0x4
  jmp .more 

.done:
  vextractf128 xmm1, ymm0, 1
  vextractf128 xmm2, ymm0, 0
  vaddpd xmm1, xmm2
  vhaddpd xmm0, xmm1, xmm1
  cvtsi2sd xmm1, rdx
  vdivsd xmm0, xmm1
  vmovsd [rdi], xmm0

  leave
  ret
