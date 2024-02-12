# int main(int argc, char** argv) {
# 
#   std::cout << "Programa para repasar las tablas de multiplicar.\n";
#   int n; // numero del que quiero repasar la tabla
#   do {
#     std::cout<<"¿Qué tabla deseas repasar? Introduce un número (0 para salir): ";
#     std::cin >> n;
#     if (n == 0) break; // si introduce un 0 sale del bucle
#     int aciertos = 0; // incializamos el numero de aciertos
#     for (int i = 1; i <= 10; i++) {
#       std::cout << i << " x " << n << " ? ";
#       int resultado;
#       std::cin >> resultado;
#       if (resultado == (i * n)) {
#         aciertos++;
#       }
#     }
#     int porcentaje = aciertos * 10;
#     std::cout << "Tu porcenaje de aciertos es del " << porcentaje << "%\n";
#   } while (n != 0);
#   std::cout << "Termina el programa.\n";
# }

# number to check - $s0
# correct guesses - $s1
# i               - $s2

  .data
program_title:       .asciiz "Programa para repasar las tablas de multiplicar.\n"
input_prompt:        .asciiz "¿Qué tabla deseas repasar? Introduce un número (0 para salir): "
multiply_expression: .asciiz " x "
question_mark:       .asciiz " ? "
result_msg:          .asciiz "Tu porcenaje de aciertos es del " 
program_end:         .asciiz "Termina el programa.\n"
  .text
main:
  # print program_title
  li $v0, 4
  la $a0, program_title
  syscall

do_while:
  # print input_prompt
  li $v0, 4
  la $a0, input_prompt
  syscall

  # input number and save it in $s0
  li $v0, 5
  syscall

  # if $v0 == 0: exit()
  beqz $v0, exit
  
  # number to check
  move $s0, $v0
  # correct guesses
  move $s1, $zero
  # i
  li $s2, 1

for:
  bgt $s2, 10, for_end

  # print expression
  li $v0, 1
  move $a0, $s2
  syscall

  li $v0, 4
  la $a0, multiply_expression 
  syscall

  li $v0, 1
  move $a0, $s0
  syscall
  
  li $v0, 4
  la $a0, question_mark 
  syscall

  # input number
  li $v0, 5
  syscall

  # if i * number_to_check == guess: correct_guesses++ 
if_correct_guess:
  mul $t0, $s2, $s0
  bne $v0, $t0, if_correct_guess_end
  addi $s1, $s1, 1

if_correct_guess_end:  
  addi $s2, $s2, 1
  b for

for_end:
  # print result_msg and amount of guesses
  li $v0, 4
  la $a0, result_msg 
  syscall

  li $t0, 10
  li $v0, 1
  mul $a0, $s1, $t0
  syscall

  li $v0, 11
  li $a0, '%'
  syscall
  
  li $v0, 11
  li $a0, '\n'
  syscall
  b do_while  

exit:
  # print program_end
  li $v0, 4
  la $a0, program_end
  syscall

  # exit
  li $v0, 10
  syscall