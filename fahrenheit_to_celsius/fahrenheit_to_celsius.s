  .data
input_prompt:  .asciiz "Enter the value in Fahrenheit: "
result_prompt: .asciiz "The value in Celsius: "
  .text
main:
  # print the intput_prompt
  li $v0, 4
  la $a0, input_prompt
  syscall

  # input the number (double)
  li $v0, 7
  syscall

  # convert form F to C
  li.d $f4, 32.0
  sub.d $f20, $f0, $f4
  li.d $f4, 1.8
  div.d $f20, $f20, $f4

  # print result_prompt
  li $v0, 4
  la $a0, result_prompt
  syscall

  # print double
  mov.d $f12, $f20
  li $v0, 3
  syscall

  # print new line
  li $v0, 11
  li $a0, '\n'
  syscall

  # exit
  li $v0, 10
  syscall 
