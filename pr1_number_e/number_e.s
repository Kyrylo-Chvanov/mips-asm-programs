# PR1. PRINCIPIO DE COMPUTADORES.
# Autor: Kyrylo Chvanov
# Fecha ultima modificacion: 17-02-2024

# int main(int argc, char *argv[])
# {
#     double error = 0;
#     double e = 1; // 1/0!
#     double fact = 1; // 0!
#     double numterminos = 1;
#     double ultimo_termino = 1; ; // 1/0!

#     std::cout << "\nPR1: Principio de computadores.\n";
#     do {
#         std::cout << "\nIntroduzca maximo error permitido: ";
#         std::cin >> error;
#         if (!(error >= 0.00001 && error < 1))
#             std::cout << "\nError: el dato introducido debe cumplir 0.00001 <= dato < 1\n";
#         else break;
#     } while (true);
  
#     while (ultimo_termino >= error) {
#         fact *= numterminos;
#         ultimo_termino = 1/fact;
#         e += ultimo_termino;
#         numterminos++;
#     }
#     std::cout <<  "\nNumero e: ";
#     std::cout << std::fixed << std::setprecision(17) << e;
#     std::cout << "\nNumero de terminos: " << int(numterminos);
#     std::cout << "\nPR1: Fin del programa.\n";
#     return 0;
# }

# error          - $f20
# e              - $f22
# fact           - $f24
# numterminos    - $f26
# ultimo_termino - $f28

  .data

titulo:		.asciiz "\nPR1: Principio de computadores.\n"
pet:		.asciiz "\nIntroduzca maximo error permitido: "
caderr:		.asciiz "\nError: el dato introducido debe cumplir 0.00001 <= dato < 1\n"
cade:		.asciiz "\nNumero e: "
cadnt:		.asciiz "\nNumero de terminos: "
cadfin:		.asciiz "\nPR1: Fin del programa.\n"

  .text

main:
  # init variables
  li.d $f20, 0.0
  li.d $f22, 1.0
  li.d $f24, 1.0
  li.d $f26, 1.0
  li.d $f28, 1.0

  # print title
  li $v0, 4
  la $a0, titulo
  syscall

do_while:
  # print pet
  li $v0, 4
  la $a0, pet
  syscall

  # read precision
  li $v0, 7
  syscall

  # Check if error < 1
  li.d $f4, 1.0
  c.lt.d $f0, $f4
  bc1f if_bad_precision
  
  # Check if error >= 0.00001
  li.d $f4, 0.00001
  c.lt.d $f0, $f4
  bc1t if_bad_precision

  mov.d $f20, $f0
  b if_end

if_bad_precision:
  # print caderr
  li $v0, 4
  la $a0, caderr
  syscall
  b do_while

if_end:

while:
  # while (ultimo_termino >= error)
  c.lt.d $f28, $f20
  bc1t while_end

  # fact *= numterminos;
  mul.d $f24, $f24, $f26

  # ultimo_termino = 1/fact;
  li.d $f4, 1.0
  div.d $f28, $f4, $f24

  # e += ultimo_termino;
  add.d $f22, $f22, $f28

  # numterminos++;
  add.d $f26, $f26, $f4

  b while
while_end:

  # print cade
  li $v0, 4
  la $a0, cade
  syscall

  # print e
  li $v0, 3
  mov.d $f12, $f22
  syscall

  # print cadnt
  li $v0, 4
  la $a0, cadnt
  syscall

  # print numterminos
  li $v0, 3
  mov.d $f12, $f26
  syscall

  # print cadfin
  li $v0, 4
  la $a0, cadfin
  syscall

exit:
  li $v0, 10
  syscall