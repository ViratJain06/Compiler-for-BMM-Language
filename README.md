# Compiler-for-BMM-Language

The Following Instructions Should Be Followed While Running The Program :
    A. Open the terminal in the directory 2021CSB1220 and Enter the following commands to run the program :
        1. flex BMM_Scanner.l
        2. bison -d BMM_Parser.y
        3. gcc BMM_Parser.tab.c lex.yy.c -lfl -o BMM_Parser
        4. ./BMM_Parser

BMM_Scanner.l - Contains lex Code
BMM_Parser.y - Contains yacc code
  Input file must be change inside yacc main function

CorrectSample.txt - Contains the correct code
IncorrectSample.txt - Contains the incorrect code

Note-
1) There might be some error in Correct Sample due to checking so many conditions in BNF Grammer and having only one correct condition.But at the end if it shows the code is valid then ignore the errors as they are irrelevent and the code will run correctly.
2) Ignore the warnings while compiling the yacc file.
3) Our Code will break on the first error
4) Instead of bmm files for input we have used txt Files. Extension can be easily changed from txt to bmm if wanted.
