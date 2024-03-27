# Solución PR3 curso 23-24
# Manejo de matrices con funciones
# Autor: Kyrylo Chvanov
# Ultima modificacion: 27/03/2024

# typedef struct {
#   int nFil;
#   int nCol;
#   float elementos[];
# } structMat;

nFil = 0	# El desplazamiento al campo dentro de la estructura
nCol = 4	# El desplazamiento al campo dentro de la estructura
elementos = 8	# El desplazamiento al campo dentro de la estructura

sizeF = 4	# Numero de bytes de un float
LF = 10		# Caracter salto de línea

	.data
mat1:
  .word	6
	.word	6
	.float	11.11, 12.12, 13.13, 14.14, 15.15, 16.16,
	.float	21.21, 22.22, 23.23, 24.24, 25.25, 26.26,
	.float	31.31, 32.32, 33.33, 34.34, 35.35, 36.36,
	.float	41.41, 42.42, 43.43, 44.44, 45.45, 46.46,
	.float	51.51, 52.52, 53.53, 54.54, 55.55, 56.56,
	.float	61.61, 62.62, 63.63, 64.64, 65.65, 66.66

mat2:
  .word	7
	.word	10
	.float	-36.886, -58.201,  78.671,  19.092, -50.781,  33.961, -59.511, 12.347,  57.306,  -1.938,
	.float	-86.858, -81.852,  54.623, -22.574,  88.217,  64.374,  52.312, 47.918, -83.549,  19.041,
	.float	4.255, -36.842,  82.526,  27.394,  56.527,  39.448,  18.429, 97.057,  76.933,  14.583,
	.float	67.79 ,  -9.861, -96.191,  32.369, -18.494, -43.392,  39.857, 80.686, -36.87 , -17.786,
	.float	30.073,  89.938,  -6.889,  64.601, -85.018,  70.559, -48.853, -62.627, -60.147,  -5.524,
	.float	84.323, -51.718,  93.127, -10.757,  32.119,  98.214,  69.471, 73.814,   3.724,  57.208,
	.float	-41.528, -17.458, -64.226, -71.297, -98.745,   7.095, -79.112, 33.819,  63.531, -96.181

mat3:
  .word	1
	.word	8
	.float	-36.52,  35.3 ,  79.05, -58.69, -55.23, -19.44, -88.63, -93.61

mat4:
  .word	16
	.word	1
	.float	-90.57, -65.11, -58.21, -73.23, -89.38, -79.25,  16.82,  66.3
	.float	-96.14, -97.16, -24.66,   5.27, -33.5 , -13.09,  27.13, -74.83

mat5:
  .word	1
	.word	1
	.float	78.98

mat6:
  .word	0
	.word	0
	.float	0.0

# float infinito = INFINITY;
infinito:	.word	0x7F800000

# Cadenas de caracteres
str_titulo:     .asciiz	"\nComienza programa manejo matrices con funciones\n"
str_menu:       .ascii	"(0) Terminar el programa\n"
		            .ascii	"(1) Cambiar la matriz de trabajo\n"
		            .ascii	"(3) Cambiar el valor de un elemento\n"
		            .ascii	"(4) Intercambiar un elemento con su opuesto\n"
		            .ascii	"(7) Encontrar el minimo\n"
		            .asciiz	"\nIntroduce opción elegida: "
str_errorOpc:	  .asciiz	"Error: opcion incorrecta\n"
str_termina:	  .asciiz	"\nTermina el programa\n"
str_elijeMat:	  .asciiz	"\nElije la matriz de trabajo (1..6): "
str_numMatMal:	.asciiz	"Numero de matriz de trabajo incorrecto\n"
str_errorFil:	  .asciiz	"Error: dimension incorrecta.  Numero de fila incorrecto\n"
str_errorCol:	  .asciiz	"Error: dimension incorrecta.  Numero de columna incorrecto\n"
str_indFila:	  .asciiz	"\nIndice de fila: "
str_indCol:	    .asciiz	"Indice de columna: "
str_nuevoValor:	.asciiz	"Nuevo valor para el elemento: "
str_valMin:	    .asciiz	"\nEl valor minimo esta en ("
str_conValor:	  .asciiz	") con valor "
str_matTiene:	  .asciiz	"\n\nLa matriz tiene dimension "

  .text
# void print_mat(structMat* mat)
# $s0 = nFil
# $s1 = nCol
# $s2 = f
# $s3 = c
# $s4 = elem
# $s5 = mat
print_mat:
  # we will need to use these regs, so let's save the previous values
  addi $sp, $sp, -24
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $s2, 8($sp)
  sw $s3, 12($sp)
  sw $s4, 16($sp)
  sw $s5, 20($sp)
  
  move $s5, $a0
  # int nFil = mat->nFil;
  lw $s0, nFil($s5)
  # int nCol = mat->nCol;
  lw $s1, nCol($s5)
  # float* elem = mat->elementos;
  la $s4, elementos($s5)

  # std::cout << "\n\nLa matriz tiene dimension " << nFil << 'x' << nCol << '\n';
  li $v0, 4
  la $a0, str_matTiene
  syscall

  li $v0, 1
  move $a0, $s0
  syscall

  li $v0, 11
  li $a0, 'x'
  syscall
  
  li $v0, 1
  move $a0, $s1
  syscall
  
  li $v0, 11
  li $a0, LF
  syscall

  # for(int f = 0; f < nFil; f++)
  li $s2, 0
print_for_f:
  bge $s2, $s0, for_f_end

  # for(int c = 0; c < nCol; c++) {
  li $s3, 0
print_for_c:
  bge $s3, $s1, for_c_end
  # std::cout << elem[f*nCol + c] << ' ';
  l.s $f12, 0($s4)
  li $v0, 2
  syscall

  li $v0, 11
  li $a0, ' '
  syscall

  # get next element
  addi $s4, sizeF

  addi $s3, 1
  b for_c

print_for_c_end:
  # std::cout << '\n';
  li $v0, 11
  li $a0, LF
  syscall
  
  addi $s2, 1
  b for_f

print_for_f_end:
  # std::cout << '\n';
  li $v0, 11
  li $a0, LF
  syscall
  # restore the values
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $s2, 8($sp)
  lw $s3, 12($sp)
  lw $s4, 16($sp)
  lw $s5, 20($sp)
  addi $sp, $sp, 24
  jr $ra
print_mat_fin:

# void change_elto(structMat* mat, int indF, int indC, float valor) {
# $a0  - mat
# $a1  - indF
# $a2  - indC
# $f12 - valor
change_elto:
  # int numCol = mat->nCol;
  lw $t0, nCol($a0)
  # mat->elementos[indF * numCol + indC] = valor;
  la $t1, elementos($a0)
  mul $a1, $a1, $t0
  add $a1, $a1, $a2
  li $t2, sizeF
  mul $a1, $a1, $t2
  add $t1, $t1, $a1
  s.s $f12, 0($t1)
  jr $ra
change_elto_fin:

# void swap(float* e1, float* e2) {
# $a0 - e1
# $a1 - e2
swap:
  # float temp1 = *e1;
  l.s $f4, 0($a0)
  # float temp2 = *e2;
  l.s $f5, 0($a1)
  # *e1 = temp2;
  s.s $f5, 0($a0)
  # *e2 = temp1;
  s.s $f4, 0($a1)
  jr $ra
swap_fin:

# void intercambia(structMat* mat, int indF, int indC) {
# $a0 - mat
# $a1 - indF
# $a2 - indC
intecambia:
  # int numFil = mat->nFil;
  lw $t0, nFil($a0)
  # int numCol = mat->nCol;
  lw $t1, nCol($a0)
  # float* datos = mat->elementos;
  la $t2, elementos($a0)
  # float* e1 = &datos[indF * numCol + indC]; // $t3 = e1
  # indF * numCol 
  mul $t3, $a1, $t1
  # + indC
  add $t3, $t3, $a2

  li $t4, sizeF
  mul $t3, $t3, $t4
  add $t3, $t3, $t2
  # float* e2 = &datos[(numFil - indF - 1) * numCol + (numCol - indC - 1)]; // $t5 = e2
  # (numFil - indF - 1)
  sub $t5, $t0, $a1
  addi $t5, $t5, -1
  # * numCol
  mul $t5, $t5, $t1
  # + (numCol - indC - 1)
  add $t5, $t5, $t1
  sub $t5, $t5, $a2
  addi $t5, $t5, -1

  mul $t5, $t5, $t4
  add $t5, $t5, $t2

  # save return addr
  addi $sp, -4
  sw $ra, 0($sp)

  # swap(e1, e1)
  move $a0, $t3
  move $a1, $t5
  jal swap

  # load the return addr
  lw $ra, 0($sp)
  addi $sp, 4

  jr $ra
intecambia_fin:

# std::tuple<float, int, int> find_min(structMat* mat) {
# $a0 - mat
# return:
#   $f0 - value
#   $v0 - index_fil
#   $v1 - index_col
find_min:
  # int numFil = mat->nFil;
  lw $t0, nFil($a0)
  # int numCol = mat->nCol;
  lw $t1, nCol($a0)
  # float* datos = mat->elementos;
  la $t2, elementos($a0)
  # float min = infinito;
  l.s $f0, infinito
  # for(int f = 0; f < numFil; f++) {
  li $t3, 0
find_for_f:
  bge $t3, $t0, find_for_f_end
  # for(int c = 0; c < numCol; c++) {
  li $t4, 0;
find_for_c:
  bge $t4, $t1, find_for_c_end

  # float valor = datos[f * numCol + c];
  l.s $f5, 0($t2)
  # if (valor < min) {
  c.lt.s $f5, $f0
  bc1f if_end
if:  
  # min = valor;
  mov.s $f0, $f5
  # fmin = f;
  move $v0, $t3
  # cmin = c;
  move $v1, $t4
if_end:
  addi $t2, sizeF
  addi $t4, 1
  b find_for_c
find_for_c_end:
  addi $t3, 1
  b find_for_f
find_for_f_end:
  jr $ra
find_min_fin:

main:
  la $a0, mat1
  jal find_min
  
  mov.s $f4, $f0
  move $t0, $v0
  move $t1, $v1

  li $v0, 2
  mov.s $f12, $f4
  syscall
exit:
  li $v0, 10
  syscall