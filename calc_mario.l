%option noyywrap

%{
/* DEFINIÇÕES EM C */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
/* DEFINIÇÕES REGULARES */

/* INICIO E FIM DO PROGRAMA */
INICIO "#INICIO"
FIM "#FIM"

/* COMENTÁRIOS */
COMENTARIO1 "@@".*
COMENTARIO2 "@""*"(.|\n)*"*""@"

/* CARACTERES IGNORADOS E INVÁLIDOS */
IGNORAR [\ \n\t]
INVALIDO .

/* LEITURA E ESCRITA */
LEITURA "LEIA"
ESCRITA "ESCREVA"

/* LETRAS, NÚMEROS E VARIÁVEIS */
LETRAS [a-zA-Z]+
NUM_INT [0-9]+
VARIAVEL {LETRAS}({LETRAS}|{NUM_INT}|"_")*
NUM [0-­9]+\.?[0-9]*

/* RAIZ QUADRADA */
RAIZ "RAIZ"

%%
 /* TOKENS */
 /* CARACTERES ARITMÉTICOS */
[-+/*^=()] {
    return *yytext;
}

{INICIO} {
    return INICIO;
}

{FIM} {
    return FIM;
}

{LEITURA} {
    return LEITURA;
}

{ESCRITA} {
    return ESCRITA;
}

{RAIZ} {
    return RAIZ;
}

{VARIAVEL} {
    yylval.inteiro = *yytext - 'a';
    return VARIAVEL;
}

{NUM} {
    yylval.real = atof(yytext);
    return NUM;
}

{COMENTARIO1} {;}
{COMENTARIO2} {;}
{IGNORAR} {;}
{INVALIDO} {;}

%%