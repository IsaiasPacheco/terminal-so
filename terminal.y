%{
    #include <stdio.h>
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <unistd.h>
    #include <string.h>
    #include <sys/wait.h>

    int yylex();
    void yyerror( char * );
    pid_t pid;
%}

%union{
    char *s;
}
%token MKDIR TOUCH LS PARAMETRO RMARCH
%type<s> MKDIR TOUCH LS PARAMETRO RMARCH 
%type<s> cmd
%%
    
    list: 
        | list cmd
        ;
    
    plist: 
        |  PARAMETRO
        |  PARAMETRO plist
        ; 

    cmd: MKDIR PARAMETRO {  $$ = $1; 

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
        | RMARCH PARAMETRO {
                                $$ = $1;
                                
                                pid = fork();

                                if( !pid ){
                                    
                                    char *exec[3];
                                    exec[0] = "rm";
                                    exec[1] = $2;
                                    exec[2] = NULL;

                                    if( execvp(exec[0], exec) < 0){
                                        printf("Eror al ejecutar el comando");
                                    }

                                    exit(0);
                                }
                                pid = wait(NULL);
                           }          
        ;
%%

void yyerror( char *s ){
    fprintf(stderr, "%s\n", s);
}

int main(){
    return yyparse();
}