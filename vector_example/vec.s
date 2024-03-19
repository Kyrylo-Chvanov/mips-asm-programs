  .data
vec: .word 1, 2, 3, 4, 5
  .text
main:
  la $s1, vec
  addi $s1, 16
  li $s0, 0

loop:
  beq $s0, 5, exit
  li $v0, 1
  lw $a0, 0($s1)
  syscall
  li $v0, 11
  li $a0, ' '
  syscall
  li $t0, 4
  sub $s1, $s1, $t0
  addi $s0, 1
  b loop

exit:
  li $v0, 10
  syscall
