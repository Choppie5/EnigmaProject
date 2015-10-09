unit uDecrypt;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, uMain;

function decryptMessage(CipherTxt: String; ToFind : char) : char;

implementation

function decryptMessage(CipherTxt: String; ToFind : char) : char;
var
  i, a : Integer;
begin
       a := 0;

       //First Rotor
       repeat
         a := a + 1;
       until RotLeft[2,a] = ToFind;
       ToFind := RotLeft[1,a];
       a := 0;

       //Second Rotor
       repeat
         a := a + 1;
       until RotMid[2,a] = ToFind;
       ToFind := RotMid[1,a];
       a := 0;

       //Third Rotor
       repeat
         a := a + 1;
       until RotRight[2,a] = ToFind;
       ToFind := RotRight[1,a];

       //Reflector
       a := 27 - a;
       ToFind := chr(a+64);
       a := 0;         {

       //Fourth Rotor (third reversed)
       repeat
         a := a + 1;
       until RotRight[1,a] = ToFind;
       ToFind := RotRight[2,a];
       a := 0;

       //Fifth Rotor (second reversed)
       repeat
         a := a + 1;
       until RotMid[1,a] = ToFind;
       ToFind := RotMid[2,a];
       a := 0;

       //Sixth Rotor (first reversed)
       repeat
         a := a + 1;
       until RotLeft[1,a] = ToFind;
       ToFind := RotLeft[2,a];
       a := 0; }

       result := ToFind;
end;

end.

