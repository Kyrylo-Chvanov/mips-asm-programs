# a - $f20
# b - $f21
# c - $f22
# d - $f23
# f - $f24
# r - $s0
# s - $s1
# x - $s2

  .data
title:   .asciiz "\nEvaluacion polinomio f(x) = a x^3  + b x^2 + c x + d  en un intervalo [r,s]\n"
prompt1: .asciiz "\nIntroduzca los valores de a,b,c y d (separados por retorno de carro):\n"
prompt2: .asciiz "Introduzca [r,s] (r y s enteros, r <= s)  (separados por retorno de carro):\n"
func1:   .asciiz "\nf("
func2:   .asciiz ") = "
endmsg:  .asciiz "\n\nTermina el programa\n"
  .text
main:
  # print the title
  li $v0, 4
  la $a0, title
  syscall
  
  # print the first prompt
  li $v0, 4
  la $a0, prompt1
  syscall

  # get a
  li $v0, 6
  syscall
  mov.s $f20, $f0

  # get b
  li $v0, 6
  syscall
  mov.s $f21, $f0

  # get c
  li $v0, 6
  syscall
  mov.s $f22, $f0

  # get d
  li $v0, 6
  syscall
  mov.s $f23, $f0

do_while:
  # print the second prompt
  li $v0, 4
  la $a0, prompt2
  syscall

  # get r
  li $v0, 5
  syscall
  move $s0, $v0

  # get s
  li $v0, 5
  syscall
  move $s1, $v0

  bgt $s0, $s1, do_while

  # prepare the for loop: x = r
  move $s2, $s0
for:
  # break if x <= s
  bgt $s2, $s1, for_end

  # now x ($f4) can be used as a float
  mtc1 $s2, $f4
  cvt.s.w $f4, $f4

  # $f5 = a*x*x*x
  mul.s $f24, $f20, $f4
  mul.s $f24, $f24, $f4
  mul.s $f24, $f24, $f4

  # $f5 += b*x*x
  mul.s $f6, $f21, $f4
  mul.s $f6, $f6, $f4
  add.s $f24, $f24, $f6
  
  # $f5 += c*x
  mul.s $f6, $f22, $f4
  add.s $f24, $f24, $f6

  # $f5 += d
  add.s $f24, $f24, $f23

if:
  # f >= 2.1
  li.s $f6, 2.1
  c.lt.s $f24, $f6
  bc1t if_end

  # print f(x) = $f5
  li $v0, 4
  la $a0, func1
  syscall
  
  li $v0, 1
  move $a0, $s2
  syscall

  li $v0, 4
  la $a0, func2
  syscall

  li $v0, 2
  mov.s $f12, $f24
  syscall

if_end:
  # loop
  addi $s2, $s2, 1
  b for

for_end:
  # print endmsg
  li $v0, 4
  la $a0, endmsg
  syscall

  #exit
  li $v0, 10
  syscall
