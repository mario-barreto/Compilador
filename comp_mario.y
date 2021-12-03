%{
    /* CÓDIGO C */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    #include <ctype.h>
    #include <stdbool.h>

    #define name_size 50
    #define string_size 1000
    
    int yylex();
    void yyerror(const char *str) {
        fprintf(stderr, "Error: %s\n", str);
    }

    /* CONSTRUÇÃO DE UMA STRUCT PARA RECEBER O NOME E O VALOR PARA CADA VARIÁVEL DO TIPO INTEIRO */
    typedef struct varsi {
		char name[name_size];
		int v;
		struct varsi * prox;
	} VARS_I;
    /* ADICIONA UMA NOVA VARIÁVEL DO TIPO INTEIRO NA LISTA */
    VARS_I * ins_i(VARS_I *l, char n[]) {
		VARS_I *new = (VARS_I*)malloc(sizeof(VARS_I));
		strcpy(new->name, n);
		new->prox = l;
		return new;
	}
    /* BUSCA UMA VARIÁVEL DO TIPO INTEIRO NA LISTA DE VARIÁVEIS */
	VARS_I *srch_i(VARS_I *l, char n[]) {
		VARS_I *aux = l;
		while(aux != NULL) {
			if(strcmp(n, aux->name) == 0) {
				return aux;
			}
			aux = aux->prox;
		}
		return aux;
	}

    /* CONSTRUÇÃO DE UMA STRUCT PARA RECEBER O NOME E O VALOR PARA CADA VARIÁVEL DO TIPO FLOAT */
    typedef struct varsf {
		char name[name_size];
		float v;
		struct varsf * prox;
	} VARS_F;
    /* ADICIONA UMA NOVA VARIÁVEL DO TIPO FLOAT NA LISTA */
    VARS_F * ins_f(VARS_F *l, char n[]) {
		VARS_F *new = (VARS_F*)malloc(sizeof(VARS_F));
		strcpy(new->name, n);
		new->prox = l;
		return new;
	}
    /* BUSCA UMA VARIÁVEL DO TIPO REAL NA LISTA DE VARIÁVEIS */
	VARS_F *srch_f(VARS_F *l, char n[]) {
		VARS_F *aux = l;
		while(aux != NULL) {
			if(strcmp(n, aux->name) == 0) {
				return aux;
			}
			aux = aux->prox;
		}
		return aux;
	}
    
    /* CONSTRUÇÃO DE UMA STRUCT PARA RECEBER O NOME E O VALOR PARA CADA VARIÁVEL DO TIPO STRING */
    typedef struct varss {
		char name[name_size];
		char v[string_size];
		struct varss * prox;
	} VARS_S;
    /* ADICIONA UMA NOVA VARIÁVEL DO TIPO STRING NA LISTA */
    VARS_S * ins_s(VARS_S *l, char n[]) {
		VARS_S *new = (VARS_S*)malloc(sizeof(VARS_S));
		strcpy(new->name, n);
        strcpy(new->v, "");
		new->prox = l;
		return new;
	}
    /* BUSCA UMA VARIÁVEL DO TIPO STRING NA LISTA DE VARIÁVEIS */
    VARS_S *srch_s(VARS_S *l, char n[]) {
		VARS_S *aux = l;
		while(aux != NULL) {
			if(strcmp(n,aux->name) == 0) {
				return aux;
			}
			aux = aux->prox;
		}
		return aux;
	}

    VARS_I *ivar = NULL;
	VARS_F *fvar = NULL;
    VARS_S *svar = NULL;

    /* O "nodetype" SERVE PARA INDICAR O TIPO DE NÓ QUE ESTÁ NA ÁRVORE. ISSO SERVE PARA A FUNÇÃO "eval" ENTENDER O QUE REALIZAR NAQUELE NÓ */
    typedef struct ast {    /* ESTRUTURA DE UM NÓ */
        int nodetype;
        struct ast *l;      /* ESQUERDA */
        struct ast *r;      /* DIREITA */
    } Ast; 

    /* ESTRUTURA DE UMA VARIÁVEL INTEIRA */
    typedef struct intval {
        int nodetype;
        int v;
    } IntVal;

    /* ESTRUTURA DE UMA VARIÁVEL FLOAT */
    typedef struct floatval {
        int nodetype;
        double v;
    } FloatVal;

    /* ESTRUTURA DE UMA VARIÁVEL STRING */
    typedef struct stringval {
        int nodetype;
        char v[string_size];
    } StringVal;

    /* ESTRUTURA DE UM NOME DE VARIÁVEL */
    typedef struct varval {
        int nodetype;
        char var[name_size];
    } VarVal;

    /* ESTRUTURA DE UM DESVIO (IF/ELSE/WHILE) */
    typedef struct flow {
	    int nodetype;
	    Ast *cond;		/* CONDIÇÃO */
	    Ast *tl;		/* THEN (ENTÃO), OU SEJA, VERDADE */
	    Ast *el;		/* ELSE */
    } Flow;

    /* ESTRUTURA PARA UM NÓ DE ATRIBUIÇÃO. PARA ATRIBUIR O VALOR DE "v" EM "s" */
    typedef struct symasgn { 
        int nodetype;
        char s[name_size];
        Ast *v;
    } Symasgn;

    /* FUNÇÃO PARA CRIAR UM NÓ */
    Ast * newast(int nodetype, Ast *l, Ast *r) {
	    Ast *a = (Ast*)malloc(sizeof(Ast));

	    if(!a) {
		    printf("out of space");
		    exit(0);
	    }
	    a->nodetype = nodetype;
	    a->l = l;
	    a->r = r;
	    return a;
    }

    /* FUNÇÃO QUE CRIA UM NOVO NÚMERO INTEIRO */
    Ast * newint(int d) {	
        IntVal *a = (IntVal*)malloc(sizeof(IntVal));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = 'k';
        a->v = d;
        return (Ast*)a;
    }

    /* FUNÇÃO QUE CRIA UM NOVO NÚMERO REAL */
    Ast * newfloat(double d) {		
        FloatVal *a = (FloatVal*)malloc(sizeof(FloatVal));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = 'K';
        a->v = d;
        return (Ast*)a;
    }

    /* FUNÇÃO QUE CRIA UMA NOVA STRING */
    Ast * newstring(char d[]) {			
        StringVal *a = (StringVal*)malloc(sizeof(StringVal));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = 'm';
        strcpy(a->v, d);
        return (Ast*)a;
    }

    /* FUNÇÃO QUE CRIA UM NÓ DE IF/ELSE/WHILE */
    Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el) {
        Flow *a = (Flow*)malloc(sizeof(Flow));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = nodetype;
        a->cond = cond;
        a->tl = tl;
        a->el = el;
        return (Ast *)a;
    }

    /* FUNÇÃO QUE CRIA UM NÓ PARA TESTES LÓGICOS */
    Ast * newcmp(int cmptype, Ast *l, Ast *r) {
        Ast *a = (Ast*)malloc(sizeof(Ast));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = '0' + cmptype; /* PARA PEGAR O TIPO DE TESTE (DEFINIDO NO ARQUIVO .l) E UTILIZAR NA FUNÇÃO eval() */
        a->l = l;
        a->r = r;
        return a;
    }

    /* FUNÇÃO QUE CRIA UM NÓ PARA A VARIÁVEL DO TIPO INTEIRO, FLOAT OU STRING E ATRIBUI O VALOR */
    Ast * newvar(int t, char s[], Ast *v, Ast *n) {
        Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = t;    /* TIPO i, r ou t, CONFORME O ARQUIVO .l */
        strcpy(a->s, s);    /* SÍMBOLO/VARIÁVEL */
        a->v = v;           /* VALOR */
        return (Ast *)a;
    }

    /* FUNÇÃO PARA UM NÓ DE ATRIBUIÇÃO */
    Ast * newasgn(char s[], Ast *v) { 
        Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = '=';
        strcpy(a->s, s);    /* SÍMBOLO/VARIÁVEL */
        a->v = v;           /* VALOR */
        return (Ast *)a;
    }

    /* FUNÇÃO QUE RECUPERA O NOME/REFERÊNCIA DE UMA VARIÁVEL */
    Ast * newValorVal(char s[]) { 
        VarVal *a = (VarVal*)malloc(sizeof(VarVal));

        if(!a) {
            printf("out of space");
            exit(0);
        }
        a->nodetype = 'V';
        strcpy(a->var, s);
        return (Ast*)a;
    }

    /* VERIFICAR SE A VARIÁVEL EXISTE NA LISTA DE VARIÁVEIS */
    bool varexiste(char v[]) {
        VARS_I* xi = srch_i(ivar, v);
        VARS_F* xf = srch_f(fvar, v);
        VARS_S* xs = srch_s(svar, v);

        if(!xi && !xf && !xs) {     /* SE FOR TUDO "NULL", A VARIÁVEL NÃO EXISTE */
            return false;
        } else {                    /* SE FOR TUDO "TRUE", A VARIÁVEL EXISTE */
            return true;
        }  
    }

    /* FUNÇÃO QUE EXECUTA OPERAÇÕES A PARTIR DE UM NÓ */
    double eval(Ast *a) { 
        double v;

        if(!a) {
            printf("internal error, null eval\n");
            return 0.0;
        }

        switch(a->nodetype) {
            case 'k': v = ((IntVal *)a)->v; break;              /* RECUPERA UM NÚMERO INTEIRO */
            case 'K': v = ((FloatVal *)a)->v; break;            /* RECUPERA UM NÚMERO REAL */
            case 'm': v = atof(((StringVal *)a)->v); break;     /* RECUPERA UMA STRING */

            /* DECLARAÇÃO DE VARIÁVEL DO TIPO INTEIRO */
            case 'i':
                if(!varexiste(((Symasgn *)a)->s)) {
                    ivar = ins_i(ivar, ((Symasgn *)a)->s);
                    VARS_I * xi = (VARS_I*)malloc(sizeof(VARS_I));

                    if(!xi) {
                        printf("out of space");
                        exit(0);
                    }
                    xi = srch_i(ivar, ((Symasgn *)a)->s);

                    if(((Symasgn *)a)->v) {
                        xi->v = (int)eval(((Symasgn *)a)->v);   /* ATRIBUI À VARIÁVEL */
                    }
                } else {
                    printf("Erro! Variavel '%s' ja existe.\n", ((Symasgn *)a)->s);
                }
                break;

            /* DECLARAÇÃO DE VARIÁVEL DO TIPO FLOAT */
            case 'f':
                if(!varexiste(((Symasgn *)a)->s)) {
                    fvar = ins_f(fvar, ((Symasgn *)a)->s);
                    VARS_F * xf = (VARS_F*)malloc(sizeof(VARS_F));

                    if(!xf) {
                        printf("out of space");
                        exit(0);
                    }
                    xf = srch_f(fvar, ((Symasgn *)a)->s);

                    if(((Symasgn *)a)->v) {
                        xf->v = eval(((Symasgn *)a)->v);   /* ATRIBUI À VARIÁVEL */
                    }
                } else {
                    printf("Erro! Variavel '%s' ja existe.\n", ((Symasgn *)a)->s);
                }
                break;

            /* DECLARAÇÃO DE VARIÁVEL DO TIPO STRING */
            case 's':
                if(!varexiste(((Symasgn *)a)->s)) {
                    svar = ins_s(svar, ((Symasgn *)a)->s);
                    VARS_S * xs = (VARS_S*)malloc(sizeof(VARS_S));

                    if(!xs) {
                        printf("out of space");
                        exit(0);
                    }
                    xs = srch_s(svar, ((Symasgn *)a)->s);

                    if((((Symasgn *)a)->v)) {
                        strcpy(xs->v, ((StringVal*)((Symasgn*)a)->v)->v);   /* ATRIBUI À VARIÁVEL */
                    }
                } else {
                    printf("Erro! Variavel '%s' ja existe.\n", ((Symasgn *)a)->s);
                }                   
                break;
            
            /* VERIFICA SE A DECLARAÇÃO DA VARIÁVEL FOI REALIZADA CORRETAMENTE */
            case 'V':;
                VARS_F * aux = (VARS_F*)malloc(sizeof(VARS_F));
                aux = srch_f(fvar, ((VarVal*)a)->var);

                if (!aux) {
                    VARS_I * aux2 = (VARS_I*)malloc(sizeof(VARS_I));
                    aux2 = srch_i(ivar, ((VarVal*)a)->var);

                    if (!aux2) {
                        VARS_S * aux3 = (VARS_S*)malloc(sizeof(VARS_S));

                        if(!aux3) {
                            printf("out of space");
                            exit(0);
                        }
                        aux3 = srch_s(svar, ((VarVal*)a)->var);

                        if (!aux3) {
                            printf ("Erro! Variavel '%s' nao foi declarada.\n", ((VarVal*)a)->var);
                            v = 0.0;
                        }
                        else {
                            v = atof(aux3->v);
                        }
                    }
                    else {
                        v = (double)aux2->v;
                    }
                }
                else {
                    v = aux->v;
                }
                break;
            
            /* ATRIBUIÇÃO */
            case '=':
                v = eval(((Symasgn *)a)->v);    /* RECUPERA O VALOR*/
                VARS_F * xf = (VARS_F*)malloc(sizeof(VARS_F));

                if(!xf) {
                    printf("out of space");
                    exit(0);
                }
                xf = srch_f(fvar, ((Symasgn *)a)->s);

                if(!xf) {
                    VARS_I * xi = (VARS_I*)malloc(sizeof(VARS_I));
                    
                    if(!xi) {
                        printf("out of space");
                        exit(0);
                    }
                    xi = srch_i(ivar, ((Symasgn *)a)->s);

                    if(!xi) {
                        VARS_S * xs = (VARS_S*)malloc(sizeof(VARS_S));
                        
                        if(!xs) {
                            printf("out of space");
                            exit(0);
                        }
                        xs = srch_s(svar, ((Symasgn *)a)->s);

                        if(!xs) {
                            printf("Erro! Variavel '%s' nao declarada.\n", ((Symasgn *)a)->s);
                        } else {
                            strcpy(xs->v, ((StringVal*)((Symasgn*)a)->v)->v);   /* ATRIBUI À VARIÁVEL */
                        }
                    } else {
                        xi->v = (int)v;     /* ATRIBUI À VARIÁVEL */
                    }
                } else {
                    xf->v = v;   /* ATRIBUI À VARIÁVEL */
                }
                break;

            /* LEITURA DAS VARIÁVEIS */
            case 'c':;
                VARS_F * xcf = (VARS_F*)malloc(sizeof(VARS_F));

                if(!xcf) {
                    printf("out of space");
                    exit(0);
                }
                xcf = srch_f(fvar, ((VarVal *)a->l)->var);

                if(xcf) {
                    scanf("%f", &xcf->v);
                } else {
                    VARS_I * xci = (VARS_I*)malloc(sizeof(VARS_I));

                    if(!xci) {
                        printf("out of space");
                        exit(0);
                    }
                    xci = srch_i(ivar, ((VarVal *)a->l)->var);

                    if(xci) {
                        scanf("%d", &xci->v);
                    } else {
                        VARS_S * xcs = (VARS_S*)malloc(sizeof(VARS_S));

                        if(!xcs) {
                            printf("out of space");
                            exit(0);
                        }
                        xcs = srch_s(svar, ((VarVal *)a->l)->var);

                        if(xcs) {
                            scanf("%s", &xcs->v);
                        } else {
                            printf("Variavel invalida!\n");
                        }
                    }
                }
                break;
            
            /* COMANDO DE PRINT GERAL (MAS NÃO FAZ TODO O TRABALHO). O CASE 'p' AJUDA QUANDO PRECISAR IMPRIMIR VARIÁVEIS */
            case 'P':
                if(a->l==NULL) {
                    break;
                }

                if(a->l->nodetype == 'V') {
                    a->l->nodetype = 'p';
                    v = eval(a->l);
                } else {
                    v = eval(a->l);

                    if(a->l->nodetype != 'p' && a->l->nodetype != 'k' && a->l->nodetype != 'K' && a->l->nodetype != 'm') {
                        printf("%.2f", v);
                    }  
                }

                if(((IntVal*)a->l)->nodetype == 'k') {              /* RECUPERA UM VALOR INTEIRO */
                    printf("%d", ((IntVal*)a->l)->v);
                } else if(((FloatVal*)a->l)->nodetype == 'K') {     /* RECUPERA UM VALOR FLOAT */
                    printf("%.2f", ((FloatVal*)a->l)->v);
                } else if(((StringVal*)a->l)->nodetype == 'm') {
                    if(strcmp(((StringVal*)a->l)->v, "\\n") == 0) {
                        printf("\n");
                    } else if(strcmp(((StringVal*)a->l)->v, "\\n\\n") == 0) {
                        printf("\n\n");
                    } else if(strcmp(((StringVal*)a->l)->v, "\\t") == 0) {
                        printf("\t");
                    } else if(strcmp(((StringVal*)a->l)->v, "\\t\\t") == 0) {
                        printf("\t\t");
                    } else {                                        /* RECUPERA UM VALOR STRING */
                        printf("%s", ((StringVal*)a->l)->v);
                    }
                }

                if(a->r==NULL) {
                    break;
                } else {
                    v = eval(a->r);
                }
                break;
            
            /* IMPRIMIR VARIÁVEIS */
            case 'p':;
                VARS_F * auxn = (VARS_F*)malloc(sizeof(VARS_F));
                auxn = srch_f(fvar, ((VarVal*)a)->var);

                if(!auxn) {
                    VARS_I * auxn2 = srch_i(ivar, ((VarVal*)a)->var);

                    if(!auxn2) {
                        VARS_S * auxn3 = srch_s(svar, ((VarVal*)a)->var);

                        if(!auxn3) {
                            printf ("Erro! Variavel '%s' nao foi declarada.\n", ((VarVal*)a)->var);
                            v = 0.0;
                        } else {
                            Ast * auxnt = (Ast*)malloc(sizeof(Ast));

                            if(!auxnt) {
                                printf("out of space");
                                exit(0);
                            }
                            printf("%s", auxn3->v);
                            v = atof(auxn3->v);
                        }
                    }
                    else {
                        Ast * auxni = (Ast*)malloc(sizeof(Ast));

                        if(!auxni) {
                            printf("out of space");
                            exit(0);
                        }
                        printf("%d", auxn2->v);
                        v = (double)auxn2->v;
                    }
                } else {
                    Ast * auxnr = (Ast*)malloc(sizeof(Ast));

                    if(!auxnr) {
                        printf("out of space");
                        exit(0);
                    }
                    printf("%.2f", auxn->v);
                    v = auxn->v;
                }
                break;
            
            /* IF E IF/ELSE */
            case 'I':
                if(eval(((Flow *)a)->cond) != 0) {      /* EXECUTA A CONDIÇÃO/TESTE */
                    if(((Flow *)a)->tl) {               /* SE EXISTIR ÁRVORE */
                        v = eval(((Flow *)a)->tl);      /* VERDADE */
                    } else {
                        v = 0.0;
                    }
                } else {
                    if( ((Flow *)a)->el) {
                        v = eval(((Flow *)a)->el);      /* FALSO */
                    } else {
                        v = 0.0;
                    }
                }
                break;

            /* WHILE */
            case 'W':
                v = 0.0;
                if(((Flow *)a)->tl) {
                    while( eval(((Flow *)a)->cond) != 0) {
                        v = eval(((Flow *)a)->tl);
                    }
                }
                break;

            /* LISTA DE OPERAÇÕES EM UM BLOCO IF/ELSE/WHILE. ASSIM O ANALISADOR NÃO SE PERDE ENTRE OS BLOCOS */
            case 'L':
                eval(a->l); v = eval(a->r);
                break;

            case '+': v = eval(a->l) + eval(a->r); break;       /* OPERAÇÃO DE ADIÇÃO */
            case '-': v = eval(a->l) - eval(a->r); break;       /* OPERAÇÃO DE SUBSTRAÇÃO */
            case '*': v = eval(a->l) * eval(a->r); break;       /* OPERAÇÃO DE MULTIPLICAÇÃO */
            case '/': v = eval(a->l) / eval(a->r); break;       /* OPERAÇÃO DE DIVISÃO */
            case '^': v = pow(eval(a->l), eval(a->r)); break;   /* OPERAÇÃO DE POTENCIAÇÃO */
            case 'R': v = sqrt(eval(a->l)); break;              /* OPERAÇÃO DE RADICIAÇÃO */
            case 'N': v = -eval(a->l); break;                   /* NÚMERO NEGATIVO */

            /* OPERAÇÕES LÓGICAS */
            case '1': v = (eval(a->l) > eval(a->r))? 1 : 0; break;  
            case '2': v = (eval(a->l) < eval(a->r))? 1 : 0; break;
            case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
            case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
            case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
            case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;

            case 'z':
                free(ivar);
                ivar = NULL;
                free(fvar);
                fvar = NULL;
                free(svar);
                svar = NULL;
                exit(0);
                break;

            default:
                printf("internal error: bad node %c\n", a->nodetype);
                break;
        }
        return v;
    }

%}

%union {
    char texto[string_size];
    double real;
    int inteiro;
    int fn;
    Ast *ast;
}

/* DECLARAÇÃO DOS TOKENS (NÓS TERMINAIS) */
%token INICIO FIM LEITURA ESCRITA SE SENAO ENQUANTO RAIZ INC DEC
%token <inteiro> TIPO_INT TIPO_FLOAT TIPO_STRING NUM_INT
%token <real> NUM_REAL
%token <texto> VARIAVEL STRING1 STRING2
%token <fn> CMP

/* DECLARAÇÃO DOS NÓS NÃO-TERMINAIS */
%type <ast> ini prog stm decl_atrib escrever expressao valor list

/* DECLARAÇÃO DE PRECEDÊNCIA DOS OPERADORES */
%right '='
%left '+' '-'
%left '*' '/' 
%right '^'
%left ')'
%right '('
%right INC DEC
%left CMP

/* DEFINE A ORDEM DE PRECEDÊNCIA DO MAIS BAIXO AO MAIS ALTO */
%nonassoc SE_P NEG_P

%%
/* INÍCIO DO PROGRAMA */
ini: INICIO prog FIM { eval(newast('z', NULL, NULL)); }
    ;

/* INICIA A EXECUÇÃO DA ÁRVORE DE DERIVAÇÃO */
prog: stm { eval($1); }  
	| prog stm { eval($2); } 
	;

/* VARIAÇÕES DOS CÓDIGOS QUE A LINGUAGEM POSSUI */
stm: decl_atrib {      /* DECLARAÇÃO E ATRIBUIÇÃO */
        $$ = $1 ;
    }
    
    | LEITURA '(' VARIAVEL ')' {    /* LEITURA E ESCRITA */
        $$ = newast('c', newValorVal($3), NULL);
    }
    | ESCRITA '(' escrever ')' {
        $$ = $3;
    }

    | SE '(' expressao ')' '{' list '}' %prec SE_P {      /* CONDICIONAL E REPETIÇÃO */
        $$ = newflow('I', $3, $6, NULL);
    }
    | SE '(' expressao ')' '{' list '}' SENAO '{' list '}' {
        $$ = newflow('I', $3, $6, $10);
    }
    | ENQUANTO '(' expressao ')' '{' list '}' {
        $$ = newflow('W', $3, $6, NULL);
    }

    | VARIAVEL INC %prec INC {      /* INCREMENTO E DECREMENTO */
        $$ = newasgn($1, newast('+', newValorVal($1), newint(1)));
    }
    | VARIAVEL DEC %prec DEC {
        $$ = newasgn($1, newast('-', newValorVal($1), newint(1)));
    }
    ;

decl_atrib: TIPO_INT VARIAVEL {         /* DECLARAÇÃO + DECLARAÇÃO E ATRIBUIÇÃO DE VARIÁVEIS DO TIPO INTEIRO */
        $$ = newvar($1, $2, NULL, NULL);
    }
    | TIPO_INT VARIAVEL '=' expressao {
        $$ = newvar($1, $2, $4, NULL);
    }

    | TIPO_FLOAT VARIAVEL {             /* DECLARAÇÃO + DECLARAÇÃO E ATRIBUIÇÃO DE VARIÁVEIS DO TIPO FLOAT */
        $$ = newvar($1, $2, NULL, NULL);
    }
    | TIPO_FLOAT VARIAVEL '=' expressao {
        $$ = newvar($1, $2, $4, NULL);
    }

    | TIPO_STRING VARIAVEL {            /* DECLARAÇÃO + DECLARAÇÃO E ATRIBUIÇÃO DE VARIÁVEIS DO TIPO STRING */
        $$ = newvar($1, $2, NULL, NULL);
    } 
    | TIPO_STRING VARIAVEL '=' STRING1 {
        $$ = newvar($1, $2, newstring($4), NULL);
    }
    | TIPO_STRING VARIAVEL '=' STRING2 {
        $$ = newvar($1, $2, newstring($4), NULL);
    }

    | VARIAVEL '=' expressao {    /* ATRIBUIÇÃO SIMPLES */
        $$ = newasgn($1, $3);
    } 
    | VARIAVEL '=' STRING1 {
        $$ = newasgn($1, newstring($3));
    }
    | VARIAVEL '=' STRING2 {
        $$ = newasgn($1, newstring($3));
    }
    ;

escrever: expressao {       /* ESCRITA SIMPLES */
        $$ = newast('P', $1, NULL);
    }
    | STRING1 {
        $$ = newast('P', newstring($1), NULL);
    }
    | STRING2 {
        $$ = newast('P', newstring($1), NULL);
    }

    | expressao ',' escrever {      /* POSSIBILITA A ESCRITA DE VÁRIOS ELEMENTOS */
        $$ = newast('P', $1, $3);
    }
    | STRING1 ',' escrever {
        $$ = newast('P', newstring($1), $3);
    }
    | STRING2 ',' escrever {
        $$ = newast('P', newstring($1), $3);
    }
    ;

expressao: expressao '+' expressao {
        $$ = newast('+', $1, $3);
    }
    | expressao '-' expressao {
        $$ = newast('-', $1, $3);
    }
    | expressao '*' expressao {
        $$ = newast('*', $1, $3);
    }
    | expressao '/' expressao {
        $$ = newast('/', $1, $3);
    }
    | expressao '^' expressao {
        $$ = newast('^', $1, $3);
    }
    | RAIZ '(' expressao ')' { 
        {$$ = newast('R', $3, NULL);}
    }
    | '-' expressao %prec NEG_P {
        $$ = newast('N', $2, NULL); 
    }
    | expressao CMP expressao {     /* OPERADORES LÓGICOS */
        $$ = newcmp($2, $1, $3);
    }
    | '(' expressao ')' {
        $$ = $2;
    }
    | valor { 
        $$ = $1; 
    }
    ; 

/* VALORES BÁSICOS */
valor: NUM_INT {
        $$ = newint($1);
    } 
    | NUM_REAL {
        $$ = newfloat($1);
    } 
    | VARIAVEL {
        $$ = newValorVal($1);
    }
    ;

/* ESTRUTURA PARA MÚLTIPLAS LINHAS DE CÓDIGO NAS ESTRUTURAS DE DECISÃO/LOOP */
list: stm {
        $$ = $1;
    }
    | list stm {
        $$ = newast('L', $1, $2);
    }
    ;

%%

#include "lex.yy.c"

int main() {
    yyin=fopen("entrada1.txt", "r");
    yyparse();
    yylex();
    fclose(yyin);
    
    return 0;
}