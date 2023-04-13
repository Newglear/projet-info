%option noyywrap
%option noinput
%option nounput

%{
#include "bison.tab.h"
%}
%%
"//".*                  /* skip everything in a line comment */
"/\*"(.|\n)*"\*/"       /* skip everything in a block comment */

 /* keywords */
"void"                  {return tVOID;}
"int"                   {return tINT;}
"if"                    {return tIF;}
"print"                 {return tPRINT;}
"else"                  {return tELSE;}
"while"                 {return tWHILE;} 
"return"                {return tRETURN;}

 /* operations with 2 symbols */
"=="                    {return tEQ;}
"<="                    {return tLE;}
">="                    {return tGE;}
"!="                    {return tNE;}
"&&"                    {return tAND;}
"||"                    {return tOR;}

 /* operations with 1 symbols */
"="                     {return tASSIGN;}
"+"                     {return tADD;}
"-"                     {return tSUB;}
"*"                     {return tMUL;}       
"/"                     {return tDIV;}
">"                     {return tGT;}
"<"                     {return tLT;}
"!"                     {return tNOT;}

 /* syntax */
"("                     {return tLPAR;}
")"                     {return tRPAR;}
"{"                     {return tLBRACE;}
"}"                     {return tRBRACE;}
";"                     {return tSEMI;}
","                     {return tCOMMA;}


 /* Hexadecimal numbers and Integers */
"0x"[0-9]+              {return tNB;}

[0-9]+                  {return tNB;}

 /* keywords not clearly mentionned */
[A-Za-z][A-Za-z0-9]*    {return tID;}

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
