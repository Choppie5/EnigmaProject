# EnigmaProject
Programming of a virtual enigma machine in Pascal.

This project uses the Lazarus IDE, with the Free Pascal Compiler.

ALPHA BRANCH
------------------------
Alpha 1.0.5

- Initial program upload. Includes basic (though not necessarily correct) functionality.

Alpha 1.0.7

- Found and corrected bug whereby plaintext characters weren't being detected as they were lowercase compared to uppercase characters.
- Found and corrected bug whereby characters were being assigned values of their position in the alphabet (eg, A = 1), instead of their ASCII equivalents (eg, A = 1+64 = 65).