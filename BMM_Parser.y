%{
    #include<stdio.h>
    #include<stdlib.h>
    int yylex();
    int flag = 0;
    int flag2 = 0;
    int flag3 = 0;
    int current_line = 0;
    int previous_line = 0;
    int max_line = 0;
    int forstartcount = 0;
    int yyerror(char *text);
    extern FILE* yyin;
%}

%token STR DATASTMT DEFSTMT DIMSTMT INTNUMBER SINGLEPRECISION DOUBLEPRECISION STRINGS OPENPARENTHESIS CLOSEPARENTHESIS EQUAL NOTEQUAL LESSTHAN LESSTHANEQUAL GREATERTHAN GREATERTHANEQUAL ADD SUB MUL DIV EXP LOGICALNOT LOGICALAND LOGICALOR LOGICALXOR ENDSTMT FORSTMT IFSTMT GOSUBSTMT LETSTMT INPUTSTMT PRINTSTMT REMSTMT RETURNSTMT STOPSTMT COMMA FUNCTION TOSTMT STEPSTMT GOTOSTMT THENSTMT DOTSTMT NEXTSTMT SEMICOLON

%union{
    int num;
    char* str;
}

%token <num> NUM
%token <str> VARNAME

%left ADD SUB
%left MUL DIV
%left OPENPARENTHESIS CLOSEPARENTHESIS
%%

PROGRAM : PROG_BODY ;

PROG_BODY : STATEMENTS ;

STATEMENTS : FULLSTATEMENT | FULLSTATEMENT STATEMENTS

FULLSTATEMENT : NUM STATEMENT {
        current_line = $1; 
        if(current_line < previous_line)
        {   
            {printf("ERROR DUE TO WRONG ORDER OF LINE NUMBER on LINE NUMBER %d \n\n" , current_line);};  
            flag = 1;
        }
        if(flag3 == 1 && current_line != -1)
        {
            {printf("ERROR DUE TO LINES AFTER END OF PROGRAM on LINE NUMBER %d \n\n" , current_line);};  
            flag = 1;
        }
        if(flag2 == 1&& flag3 == 0)
        {
            flag3 = 1;
        }
        previous_line = current_line;
    };

STATEMENT : DATASTMT DATA 
    | 
    DEFSTMT DEF 
    |
    DIMSTMT DIM 
    | 
    ENDSTMT { 
        flag2 = 1;
        if(forstartcount < 0 || forstartcount > 0)
        {
            {printf("FOR_NEXT_ERROR on LINE NUMBER %d \n\n" , current_line);}; 
            flag = 1;
        }
    }
    |
    FORSTMT FOR {
        forstartcount++;
    }
    |
    GOSUBSTMT GOSUB 
    |
    GOTOSTMT GOTO 
    |
    IFSTMT IF 
    |
    LETSTMT LET 
    |
    INPUTSTMT INPUT 
    |
    PRINTSTMT PRINT 
    |
    REMSTMT 
    |
    RETURNSTMT 
    |
    STOPSTMT 
    |
    NEXTSTMT NEXT{
        forstartcount--;
        if(forstartcount < 0)
        {
            {printf("FOR_NEXT_ERROR on LINE NUMBER %d \n\n" , current_line);}; 
            flag = 1;
        }
    }
    |
    {printf("ERROR Invalid STATEMENT on LINE NUMBER %d \n\n" , current_line);}; 
    ;

VARIABLETYPE : INTNUMBER  
    | 
    SINGLEPRECISION 
    |
    DOUBLEPRECISION 
    |
    STRINGS 
    |
    {printf("ERROR IN DATA TYPE on LINE NUMBER %d \n\n" , current_line);}; 
    ;

DATA : NUM COMMA DATA
    |   
    STR COMMA DATA 
    |
    NUM 
    |
    STR 
    |
    {printf("ERROR IN DATA on LINE NUMBER %d \n\n" , current_line);}; 
    ;

INTEGERARITHMETICEXPRESSION : INTEGERARITHMETICEXPRESSION ARITHMETICOPERATOR INTEGERARITHMETICEXPRESSION 
    |
    NUM 
    |
    VARNAME
    |
    {printf("ERROR IN INTEGERARITHMETICEXPRESSION  on LINE NUMBER %d \n\n" , current_line);};
;

DEF : FUNCTION VARNAME OPENPARENTHESIS VARNAME CLOSEPARENTHESIS EQUAL INTEGERARITHMETICEXPRESSION
    |
    FUNCTION VARNAME EQUAL INTEGERARITHMETICEXPRESSION
    |
    {printf("ERROR IN DEF on LINE NUMBER %d \n\n" , current_line);};
    ;

DIM : VARNAME OPENPARENTHESIS VARNAME CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS VARNAME COMMA VARNAME CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS VARNAME CLOSEPARENTHESIS
    |
    VARNAME OPENPARENTHESIS NUM CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS NUM COMMA VARNAME CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS NUM COMMA NUM CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS VARNAME COMMA NUM CLOSEPARENTHESIS COMMA DIM
    |
    VARNAME OPENPARENTHESIS NUM CLOSEPARENTHESIS
    |
    {printf("ERROR IN DIM on LINE NUMBER %d \n\n" , current_line);};
    ;

RELATIONALOPERATOR : EQUAL 
    |
    NOTEQUAL 
    |
    LESSTHAN 
    |
    LESSTHANEQUAL 
    |
    GREATERTHAN 
    |
    GREATERTHANEQUAL 
    |
    {printf("ERROR IN RELATIONALOPERATOR on LINE NUMBER %d \n\n" , current_line);};
    ;

ARITHMETICOPERATOR : ADD 
    |
    SUB 
    |
    MUL 
    |
    DIV 
    |
    EXP 
    |
    {printf("ERROR IN ARITHMETICOPERATOR on LINE NUMBER %d \n\n" , current_line);};
    ;

FOR : VARNAME EQUAL NUM TOSTMT NUM STEPSTMT NUM
    |   
    VARNAME EQUAL NUM TOSTMT NUM 
    |   
    VARNAME EQUAL NUM TOSTMT VARNAME ARITHMETICOPERATOR VARNAME  
    |  
    VARNAME EQUAL NUM TOSTMT VARNAME ARITHMETICOPERATOR NUM  
    |  
    VARNAME EQUAL NUM TOSTMT NUM ARITHMETICOPERATOR VARNAME 
    | 
    {printf("ERROR IN FOR on LINE NUMBER %d \n\n" , current_line);};
    ;

NEXT : VARNAME
    |
    {printf("ERROR IN NEXT on LINE NUMBER %d \n\n" , current_line);};
    ;

GOSUB : NUM 
    |
    {printf("ERROR IN GOSUB on LINE NUMBER %d \n\n" , current_line);};
    ;

GOTO : NUM 
    |
    {printf("ERROR IN GOTO on LINE NUMBER %d \n\n" , current_line);};
    ;

INTEGERRELATIONALEXPRESSION : NUM RELATIONALOPERATOR  VARNAME VARIABLETYPE 
    |
    NUM RELATIONALOPERATOR NUM
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR NUM
    |
    VARNAME RELATIONALOPERATOR NUM
    |
    VARNAME RELATIONALOPERATOR VARNAME VARIABLETYPE
    |
    VARNAME RELATIONALOPERATOR VARNAME
    |
    NUM RELATIONALOPERATOR VARNAME
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR VARNAME VARIABLETYPE
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR VARNAME
    |
    {printf("ERROR IN INTEGERRELATIONALEXPRESSION on LINE NUMBER %d \n\n" , current_line);};
    ;

STRINGRELATIONALEXPRESSION : STR RELATIONALOPERATOR  VARNAME VARIABLETYPE 
    |
    STR RELATIONALOPERATOR STR
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR STR
    |
    VARNAME RELATIONALOPERATOR STR
    |
    VARNAME RELATIONALOPERATOR VARNAME VARIABLETYPE
    |
    VARNAME RELATIONALOPERATOR VARNAME
    |
    STR RELATIONALOPERATOR VARNAME
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR VARNAME VARIABLETYPE
    |
    VARNAME VARIABLETYPE RELATIONALOPERATOR VARNAME
    |
    {printf("ERROR IN STRINGRELATIONALEXPRESSION on LINE NUMBER %d \n\n" , current_line);};
    ;

ARRAY : VARNAME OPENPARENTHESIS VARNAME CLOSEPARENTHESIS
    |
    VARNAME OPENPARENTHESIS NUM CLOSEPARENTHESIS
    |
    {printf("ERROR IN ARRAY on LINE NUMBER %d \n\n" , current_line);};
    ;

IF : ARRAY RELATIONALOPERATOR VARNAME THENSTMT NUM 
    |
    STRINGRELATIONALEXPRESSION THENSTMT NUM 
    |   
    INTEGERRELATIONALEXPRESSION THENSTMT NUM
    |
    {printf("ERROR IN IF on LINE NUMBER %d \n\n" , current_line);};
    ;

SINGLEPRECISIONARITHMETICEXPRESSION : SINGLEPRECISIONARITHMETICEXPRESSION ARITHMETICOPERATOR SINGLEPRECISIONARITHMETICEXPRESSION 
    |
    NUM DOTSTMT NUM 
    |
    {printf("ERROR IN SINGLEPRECISIONARITHMETICEXPRESSION on LINE NUMBER %d \n\n" , current_line);};
;

DOUBLEPRECISIONARITHMETICEXPRESSION : DOUBLEPRECISIONARITHMETICEXPRESSION ARITHMETICOPERATOR DOUBLEPRECISIONARITHMETICEXPRESSION 
    |
    NUM DOTSTMT NUM 
    |
    {printf("ERROR IN DOUBLEPRECISIONARITHMETICEXPRESSION on LINE NUMBER %d \n\n" , current_line);};
;

LET : VARNAME INTNUMBER EQUAL INTEGERARITHMETICEXPRESSION
    | 
    VARNAME INTNUMBER EQUAL NUM
    | 
    VARNAME SINGLEPRECISION EQUAL SINGLEPRECISIONARITHMETICEXPRESSION 
    | 
    VARNAME DOUBLEPRECISION EQUAL DOUBLEPRECISIONARITHMETICEXPRESSION 
    | 
    VARNAME STRINGS EQUAL STR 
    |
    VARNAME EQUAL STR 
    |
    VARNAME EQUAL NUM 
    |
    {printf("ERROR IN LET on LINE NUMBER %d \n\n" , current_line);};
    ;

INPUT : VARNAME OPENPARENTHESIS STR CLOSEPARENTHESIS COMMA INPUT 
    |
    VARNAME VARIABLETYPE COMMA INPUT 
    |
    VARNAME COMMA INPUT 
    |
    VARNAME OPENPARENTHESIS STR CLOSEPARENTHESIS
    |
    VARNAME VARIABLETYPE
    |
    VARNAME
    |
    ARRAY
    |
    {printf("ERROR IN INPUT on LINE NUMBER %d \n\n" , current_line);};
    ;

PRINT : VARNAME SEMICOLON PRINT    
    |
    STR SEMICOLON PRINT
    |
    ARRAY SEMICOLON PRINT
    |
    VARNAME 
    |
    STR 
    |
    ARRAY
    |
    VARNAME VARIABLETYPE
    |
    VARNAME VARIABLETYPE SEMICOLON PRINT  
    |
    {printf("ERROR IN PRINT on LINE NUMBER %d \n\n" , current_line);};
;

%%

int yyerror(char *text)
{
    flag = 1;
    printf("The given Code is Invalid\n");
}

int main(int argc, char *argv[])
{
    yyin = fopen("CorrectSample.txt","r");
    yyparse();
    if(flag == 0)
    {
        printf("The given Code is Valid\n");
    }
    return 0;
}
