%{
    #include "y.tab.h"
%}

%%

"nuevaCarpeta" { return MKDIR;  }
"verArchivos"  { return LS;     }
"crearArchivo" { return TOUCH;  } 
"borrarArchivos" { return RMARCH; }
"borrarDirectorio" { return RMDIR; }
"borrarArchivo" { return RMARCH; }
[a-zA-Z0-9]+    { yylval.s=yytext; return PARAMETRO; }
&  {return '&';  }
\n { return '\n'; }
[ \t]   ; /*Ignora espacios en blanco y saltos de linea*/
.       printf("Erro de caracter");

%%

int yywrap(){
    return 1;
}