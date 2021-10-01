%{
    /* CÓDIGO C*/
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    float var[26];

    int yylex();
    void yyerror (char *s) {
        printf("%s\n", s);
    }
%}

%union {
    int inteiro;
    float real;
}

/* DECLARAÇÃO DOS TOKENS (NÓS TERMINAIS) */
%token INICIO
%token FIM
%token LEITURA
%token ESCRITA
%token RAIZ
%token <inteiro> VARIAVEL
%token <real> NUM

/* DECLARAÇÃO DOS NÓS NÃO-TERMINAIS */
%type <real> expre
%type <real> valor

/* DECLARAÇÃO DE PRECEDÊNCIA DOS OPERADORES */
%left '+' '-'
%left '*' '/'
%right '^'
%left ')'
%right '('

%%

prog: INICIO cod FIM 
    ;

cod: cod comandos
    |
    ;

comandos: LEITURA '(' VARIAVEL ')' {
        scanf ("%f", &var[$3]);
    }
    |
    ESCRITA '(' expre ')' {
        printf ("%.2f\n", $3);
    }
    |
    VARIAVEL '=' expre {
       var[$1] = $3;
    }
    ;

expre: expre '+' expre {
        $$ = $1 + $3;
    }
    | expre '-' expre {
        $$ = $1 - $3;
    }
    | expre '*' expre {
        $$ = $1 * $3;
    }
    | expre '/' expre {
        $$ = $1 / $3;
    }
    | expre '^' expre {
        $$ = pow($1, $3);
    }
    | RAIZ '(' expre ')' {
        $$ = sqrt($3);
    }
    | '(' expre ')' {
        $$ = $2;
    }
    | valor {
        $$ = $1;
    }
    | VARIAVEL {
        $$ = var[$1];
    }
    ;

valor: NUM {
        $$ = $1;
    }
    ;

%%

#include "lex.yy.c"
int main(){
    yyin=fopen("exemplo.mario", "r");
    yyparse();
    yylex();
    fclose(yyin);
    return 0;
}