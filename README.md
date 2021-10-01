# Execução

### Requisitos
- Flex
- Bison
- GCC

### Windows - Criar um arquivo <nome_arquivo>.bat com o seguinte código e executá-lo no terminal:
```
flex -i calc_mario.l
bison calc_mario.y
gcc calc_mario.tab.c -o compilador_mario -lfl
.\compilador_mario
```

### Linux - Criar um arquivo makefile com o seguinte código e executá-lo no terminal:
```
all: calc_mario.l calc_mario.y
  flex -i calc_mario.l
  bison calc_mario.y
  gcc calc_mario.tab.c -o compilador_mario -lfl
  ./compilador_mario
```

# Uso da linguagem

### Marcadores de início e fim do programa
```
#INICIO
  ...
#FIM
```

### Comentário de linha única
```
@@ Para comentar uma única linha, adicione dois arrobas antes da mesma.
```
### Comentário de múltiplas linhas
```
@* ... *@
Para comentar múltiplas linhas, adicione @* e *@ nos extremos da faixa de código que você deseja comentar.
```

### Atribuição de valores à variáveis
```
a = 8
b = 4.93
c = a + b
```

### Operação de leitura de variáveis
```
LEIA(a)
LEIA(b)
```

### Operação de escrita de variáveis
```
ESCREVA(a)
ESCREVA(b)
ESCREVA(c)
```

### Operações matemáticas
##### Adição
```
ESCREVA(3 + 7)
```
##### Subtração
```
ESCREVA(3 - 7)
```
##### Multiplicação
```
ESCREVA(8 * 2)
```
##### Divisão
```
ESCREVA(8 / 2)
```
##### Exponenciação
```
ESCREVA(2 ^ 4)
```
##### Radiciação
```
ESCREVA(RAIZ(9))
```