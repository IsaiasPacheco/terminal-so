#define MKDIR 257
#define TOUCH 258
#define LS 259
#define PARAMETRO 260
#define RMARCH 261
#define PPARAMS 262
#define RMDIR 263
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union{
    char *s;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
