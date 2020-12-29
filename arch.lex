%{
    #include "y.tab.h"
%}

%%

"nuevaCarpeta" { return MKDIR;  }
"verArchivos"  { return LS;     }
"crearArchivo" { return TOUCH;  } 
"borraArchivo" { return RMARCH; }
[a-zA-Z]+    { yylval.s=yytext; return PARAMETRO; }
[ \t]   ; /*Ignora espacios en blanco y saltos de linea*/
.       printf("Erro de caracter");

%%

int yywrap(){
    return 1;
}