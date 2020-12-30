%{
    #include "y.tab.h"
%}

%%

"nuevaCarpeta" { return MKDIR;  }
"verArchivos"  { return LS;     }
"crearArchivo" { return TOUCH;  } 
"borrarArchivos" { return RMARCH; }
"lParams" { return PPARAMS; }
[a-zA-Z0-9]+    { yylval.s=yytext; return PARAMETRO; }
\n { return '\n'; }
[ \t]   ; /*Ignora espacios en blanco y saltos de linea*/
.       printf("Erro de caracter");

%%

int yywrap(){
    return 1;
}