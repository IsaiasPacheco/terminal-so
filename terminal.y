%{
    #include <stdio.h>
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <unistd.h>
    #include <string.h>
    #include <sys/wait.h>
    #include "defs.h"

    int yylex();
    void yyerror( char * );
    pid_t pid;

    char * parametros [PARAMLIMIT];
    char pcount = 0;
%}

%union{
    char *s;
}
%token MKDIR TOUCH LS PARAMETRO RMARCH PPARAMS
%type<s> MKDIR TOUCH LS PARAMETRO RMARCH PPARAMS
%type<s> param
%type<s> cmd
%%
    
    list: '\n'
        | list cmd
        ;
    
    plist: '\n'
        |  param plist { }
        ; 
    
    param: PARAMETRO {   parametros[pcount] = malloc(sizeof(char)* strlen($1)); strcpy(parametros[pcount++], $1); }
        ;

    cmd: '\n'
        |MKDIR PARAMETRO {  $$ = $1; 

                            pid = fork();

                            if( !pid ){
                                char *exec[3];
                                exec[0] = "mkdir";
                                exec[1] = $2;
                                exec[2] = NULL;

                                if( execvp(exec[0], exec) < 0){
                                    printf("Eror al ejecutar el comando");
                                }
                                exit(0);
                            }
                            pid = wait(NULL);
                        }
        | LS    '\n'        {   $$ = $1; 
                            pid = fork();

                            if( !pid ){
                                char *name[] = {"ls",NULL};
                                execvp(name[0], name);
                                exit(0);
                            }
                            
                            pid = wait(NULL);
                        } 
        | TOUCH PARAMETRO {
                            $$ = $1; 

                            pid = fork();

                            if( !pid ){
                                char *exec[3];
                                exec[0] = "touch";
                                exec[1] = $2;
                                exec[2] = NULL;

                                if( execvp(exec[0], exec) < 0){
                                    printf("Eror al ejecutar el comando");
                                }
                                exit(0);
                            }
                            pid = wait(NULL);
                            
                        }
        | RMARCH plist  {
                                $$ = $1;
                                
                                pid = fork();

                                if( !pid ){
                                    
                                    char *exec[2+pcount];
                                    char i = 0;
                                    exec[0] = "rm";
                                    //exec[1] = $2;
                                    //exec[2] = NULL;
                                    
                                    for( i=1; i<pcount+1; i++){
                                        exec[i] = parametros[i-1];
                                    }

                                    exec[pcount+1] = NULL;

                                    if( execvp(exec[0], exec) < 0){
                                        printf("Eror al ejecutar el comando");
                                    }

                                    exit(0);
                                }
                                pid = wait(NULL);
                           }

%%

void yyerror( char *s ){
    fprintf(stderr, "%s\n", s);
}

int main(){
    return yyparse();
}