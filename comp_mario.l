%option noyywrap

%{
    /* CÓDIGO C */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}
/* DEFINIÇÕES REGULARES */

/* INICIO E FIM DO PROGRAMA */
INICIO "@INICIO"
FIM "@FIM"

/* TIPOS DE VARIÁVEIS */
TIPO_INT "int"
TIPO_FLOAT "float"
TIPO_STRING "string"

/* LEITURA E ESCRITA */
LEITURA "leia"
ESCRITA "escreva"

/* CONDICIONAL E REPETIÇÃO */
SE "se"
SENAO "senao"
ENQUANTO "enquanto"

/**/
LETRA [a-zA-Z]+
NUM_INT [0-9]+
NUM_REAL [0-9]*"."[0-9]+
VARIAVEL {LETRA}({LETRA}|{NUM_INT}|"_")*
STRING1 \"[^\"]*\"
STRING2 \'[^\']*\'
RAIZ "raiz"
INC "++"
DEC "--"

/* COMENTÁRIO, CARACTERES IGNORADOS E INVÁLIDOS */
COMENTARIO "#".*
IGNORAR [\ \n\t]
INVALIDO .

%%
 /* TOKENS */
{INICIO} { return INICIO; }
{FIM} { return FIM; }

{TIPO_INT} {
    yylval.inteiro = 'i';
    return TIPO_INT;
}
{TIPO_FLOAT} {
    yylval.inteiro = 'f';
    return TIPO_FLOAT;
}
{TIPO_STRING} {
    yylval.inteiro = 's';
    return TIPO_STRING;
}

{LEITURA} { return LEITURA; }
{ESCRITA} { return ESCRITA; }
{SE} { return SE; }
{SENAO} { return SENAO; }
{ENQUANTO} { return ENQUANTO; }
{RAIZ} { return RAIZ; }
{INC} { return INC; }
{DEC} { return DEC; }

{NUM_INT} {
    yylval.inteiro = atoi(yytext);
    return NUM_INT;
}

{NUM_REAL} {
    yylval.real = atof(yytext);
    return NUM_REAL;
}

{VARIAVEL} {
    strcpy(yylval.texto, yytext);
    return VARIAVEL;
}

{STRING1} {
    for(int x=0; x<strlen(yytext); x++) {
        yytext[x] = yytext[x+1];
    }
    yytext[strlen(yytext)-1] = '\0';
    strcpy(yylval.texto, yytext);
    return STRING1;
}

{STRING2} {
    for(int x=0; x<strlen(yytext); x++) {
        yytext[x] = yytext[x+1];
    }
    yytext[strlen(yytext)-1] = '\0';
    strcpy(yylval.texto, yytext);
    return STRING2;
}

[-+/*=^,(){}] { return *yytext; }

 /* OPERADORES LÓGICOS */
">" { yylval.fn = 1; return CMP; }
"<" { yylval.fn = 2; return CMP; }
"!=" { yylval.fn = 3; return CMP; }
"==" { yylval.fn = 4; return CMP; }
">=" { yylval.fn = 5; return CMP; }
"<=" { yylval.fn = 6; return CMP; }

{COMENTARIO} {;}
{IGNORAR} {;}
{INVALIDO} { printf("'%s' Caractere invalido!\n", yytext); }

%%