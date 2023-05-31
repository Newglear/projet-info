# projet-info
Le projet a plusieurs étapes de compilation donc pour lancer toute la chaine:
- Lancer ```make```, qui compile le yacc, lex et C.
- Puis ```./main out.asm < test.c``` qui utilise notre compilateur pour compiler le fichier test.c
- Finalement ```python3 parse.py out.asm``` qui transforme les labels en pointeurs d'instruction.

Ou plus simplement:
```make && ./main out.asm < test.c && python3 parse.py out.asm```