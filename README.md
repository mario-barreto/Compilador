# Execução

### Requisitos
- Flex
- Bison
- GCC

### Windows - Criar um arquivo <nome_arquivo>.bat com o seguinte código e executá-lo no terminal:
```
flex -i comp_mario.l
bison comp_mario.y
gcc comp_mario.tab.c -o compilador -lfl -lm
.\compilador
```

### Linux - Criar um arquivo makefile com o seguinte código e executá-lo no terminal:
```
all: comp_mario.l comp_mario.y
  flex -i comp_mario.l
  bison comp_mario.y
  gcc comp_mario.tab.c -o compilador -lfl -lm
  ./compilador
```

# Uso da linguagem

### Marcadores de início e fim do programa
```
@INICIO
  ...
@FIM
```

### Comentário
```
# Para comentar uma linha do código, adicione # antes da mesma.
```

### Tipos de variáveis
```
- int: números inteiros. Exemplo: 10
- float: números reais. Exemplo: 10.58
- string: texto. Exemplo: "Olá, mundo!" ou 'Olá, mundo!'
```

### Declaração de variáveis
```
int a
float b
float c
string d
```

### Atribuição de valores às variáveis
```
a = 8
b = 4.93
c = a + b
d = "Olá, mundo!"
#ou
d = 'Olá, mundo!'
```

### Declaração + Atribuição de valores às variáveis
```
int a = 8
float b = 4.93
float c = a + b
string d = "Olá, mundo!"
#ou
string d = 'Olá, mundo!'
```

### Operação de leitura de variáveis
```
leia(a)
leia(b)
```

### Operação de escrita de texto e de variáveis
```
escreva("Olá, mundo!")
int a = 5
int b = 10
escreva("A = ", a, "\n\n", "B = ", b, "\n")
```

### Estrutura condicional "se" e "senao"
```
escreva("A: ")
leia(a)
se(a == 1) {
  escreva("Oi!", "\n")
} senao {
  escreva("Tchau!", "\n")
}
```

### Estrutura de repetição "enquanto"
```
int a = 0
enquanto(a < 10) {
  escreva("A = ", a, "\n")
  a++
}
```

### Operações aritméticas
##### Adição
```
escreva(3 + 7)
```

##### Subtração
```
escreva(3 - 7)
```

##### Multiplicação
```
escreva(8 * 2)
```

##### Divisão
```
escreva(8 / 2)
```

##### Potenciação
```
escreva(2 ^ 4)
```

##### Radiciação
```
escreva(raiz(9))
```

##### Incremento
```
int x = 1
x++
escreva(x)
```

##### Decremento
```
int x = 1
x--
escreva(x)
```

##### Números negativos
```
int x = -1
escreva(x)
```

### Operações lógicas
##### Maior que
```
se(x > y) {
  escreva("Olá")
}
```

##### Menor que
```
se(x < y) {
  escreva("Olá")
}
```

##### Diferente de
```
se(x != y) {
  escreva("Olá")
}
```

##### Igual a
```
se(x == y) {
  escreva("Olá")
}
```

##### Maior ou igual que
```
se(x >= y) {
  escreva("Olá")
}
```

##### Menor ou igual que
```
se(x <= y) {
  escreva("Olá")
}
```