%option noyywrap
%option noinput
%option nounput


%{
#include "bison.tab.h"
#include <string.h>
#include "ast.h"
%}
%%
"//".*                  /* skip everything in a line comment */
"/\*"(.|\n)*"\*/"       /* skip everything in a block comment */

 /* keywords */
"void"                  {strcpy(yylval.id,yytext); return tVOID;}
"int"                   {strcpy(yylval.id,yytext); return tINT;}
"if"                    {strcpy(yylval.id,yytext); return tIF;}
"print"                 {strcpy(yylval.id,yytext); return tPRINT;}
"else"                  {strcpy(yylval.id,yytext); return tELSE;}
"while"                 {strcpy(yylval.id,yytext); return tWHILE;} 
"return"                {strcpy(yylval.id,yytext); return tRETURN;}

 /* operations with 2 symbols */
"=="                    {strcpy(yylval.id,yytext); return tEQ;}
"<="                    {strcpy(yylval.id,yytext); return tLE;}
">="                    {strcpy(yylval.id,yytext); return tGE;}
"!="                    {strcpy(yylval.id,yytext); return tNE;}
"&&"                    {strcpy(yylval.id,yytext); return tAND;}
"||"                    {strcpy(yylval.id,yytext); return tOR;}

 /* operations with 1 symbols */
"="                     {strcpy(yylval.id,yytext); return tASSIGN;}
"+"                     {strcpy(yylval.id,yytext); return tADD;}
"-"                     {strcpy(yylval.id,yytext); return tSUB;}
"*"                     {strcpy(yylval.id,yytext); return tMUL;}       
"/"                     {strcpy(yylval.id,yytext); return tDIV;}
">"                     {strcpy(yylval.id,yytext); return tGT;}
"<"                     {strcpy(yylval.id,yytext); return tLT;}
"!"                     {strcpy(yylval.id,yytext); return tNOT;}

 /* syntax */
"("                     {strcpy(yylval.id,yytext); return tLPAR;}
")"                     {strcpy(yylval.id,yytext); return tRPAR;}
"{"                     {strcpy(yylval.id,yytext); return tLBRACE;}
"}"                     {strcpy(yylval.id,yytext); return tRBRACE;}
";"                     {strcpy(yylval.id,yytext); return tSEMI;}
","                     {strcpy(yylval.id,yytext); return tCOMMA;}


 /* Hexadecimal numbers and Integers */
"0x"[0-9]+              {yylval.val = atoi(yytext); return tNB;} // TODO

[0-9]+                  {yylval.val = atoi(yytext); return tNB;}

 /* keywords not clearly mentionned */
[A-Za-z][A-Za-z0-9]*    {/*printf("%s\n",yytext);*/strcpy(yylval.id,yytext);return tID;}

[ \t\n]+                /* skip blankspace and tab */

 /* the rest is considered as errors */
.                       {return tERROR;}
%%
  
/*** Code Section ***/
/* int main(int argc, char **argv){
    yyin = fopen( argv[1], "r" );
    yylex();
    return 0;
} */
