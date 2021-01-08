%{
    #include <stdio.h>
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <unistd.h>
    #include <string.h>
    #include <sys/wait.h>
    #include "defs.h"
    #include "pila.h"

    int yylex();
    void yyerror( char * );
    void prompt();
    pid_t pid;
    struct pila rutasStack;
    char * parametros [PARAMLIMIT];
    char pcount = 0;
%}

%union{
    char *s;
}
%token MKDIR TOUCH LS PARAMETRO RMARCH PPARAMS RMDIR
%type<s> MKDIR TOUCH LS PARAMETRO RMARCH PPARAMS RMDIR
%type<s> param
%type<s> cmd
%%
    
    list: '\n' {prompt();}
        | cmd '&' list {prompt();}
        | cmd list {prompt();}
        ;
    
    plist: '\n'
        |  param plist { }
        ; 
    
    param: PARAMETRO {   parametros[pcount] = malloc(sizeof(char)* strlen($1)); strcpy(parametros[pcount++], $1); }
        ;

    cmd: '\n' {prompt();}
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
        | LS            {   $$ = $1; 
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
        | RMDIR PARAMETRO {
                            $$ = $1; 

                            pid = fork();

                            if( !pid ){
                                char *exec[4];
                                exec[0] = "rm";
                                exec[1] = "-r";
                                exec[2] = $2;
                                exec[3] = NULL;

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
    if( crear(&rutasStack) ){
        printf("Ok\n");
    }
    struct elemento a;
    strcpy(a.ruta, "Datos");
    if( push(&rutasStack, a) ){
        printf("Ok\n");
    }
    impPila(&rutasStack);
    prompt();
    return yyparse();
}

void prompt(){
    
    printf("\e[1;32m");
    printf("terminal:");
    printf("\e[0;94m");
    printf("/");
    printf("\e[1;32m");
    printf("$ ");
    printf("\e[0;97m");
}