%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    #include "BMM_Parser.tab.h"
%}

%%
[A-Z][0-9]? {
    yylval.str = strdup(yytext);
    return VARNAME;
} 
[0-9]+ {
    yylval.num = atoi(yytext);
    return NUM;
}
(\"[^\"]*\") {
    return STR;
}
"%" {
        return INTNUMBER;
    }
"!" {
        return SINGLEPRECISION;
    }
"#" {
        return DOUBLEPRECISION;
    }
"$" {
        return STRINGS;
    }
"(" {
        return OPENPARENTHESIS;
    }       
")" {
        return CLOSEPARENTHESIS;
    }                    
"=" {
        return EQUAL;
    } 
"<>" {
        return NOTEQUAL;
    }
"<" {
        return LESSTHAN;
    }                  
"<=" {
        return LESSTHANEQUAL;
    }                 
">" {
        return GREATERTHAN;
    } 
">=" {
        return GREATERTHANEQUAL;
    }                        
"+" {
        return ADD;
    }                  
"-" {
        return SUB;
    }                
"*" {
        return MUL;
    }                  
"/" {
        return DIV;
    }
"^" {
        return EXP;
    }
"NOT" { 
        return LOGICALNOT;
    }
"AND" {
        return LOGICALAND;
    }
"OR" {
        return LOGICALOR;
    }
"XOR" {
        return LOGICALXOR;
    }
"DATA" {
        return DATASTMT;
    } 
"DEF" {
        return DEFSTMT;
    } 
"DIM" {
        return DIMSTMT;
    }    
"END" {
        return ENDSTMT;
    }
"FOR" {
        return FORSTMT;
    }
"IF" {
        return IFSTMT;
    }   
"GOSUB" {
        return GOSUBSTMT;
    }
"GOTO" {
        return GOTOSTMT;
    }
"LET" {
        return LETSTMT;
    }
"INPUT" {
        return INPUTSTMT;
    }
"PRINT" { 
        return PRINTSTMT;
    }
("REM"[^\n]*) {
        return REMSTMT;
    }
"RETURN" {
        return RETURNSTMT;
    }
"STOP" {
        return STOPSTMT;
    }
","  {
        return COMMA;
    }
"FN"  {
    return FUNCTION;
}
"TO"  {
    return TOSTMT;
}
"STEP"  {
    return STEPSTMT;
}
"THEN"  {
    return THENSTMT;
}
"DOT"  {
    return DOTSTMT;
}
"NEXT"  {
    return NEXTSTMT;
}
";"  {
    return SEMICOLON;
}

\/\*[^*]*[*]+([^\/][^*]*[*]+)*\/ {}
\/\/(.*) {}
[ \t\n] {}
.     {}                  

%%

int yywrap()
{
    return 1;
}