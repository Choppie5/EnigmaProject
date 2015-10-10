unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, StrUtils;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    ebRotor1: TEdit;
    ebRotor2: TEdit;
    ebRotor3: TEdit;
    ebPlainText: TEdit;
    ebCipherText: TEdit;
    lbCipherText: TLabel;
    lbPlainText: TLabel;
    lbRotor1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnDecryptClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure ebRotor1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CipherRotors;
    procedure InitRotors;
    procedure MoveRotors(rWay : integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

  TRotor = array[1..2,1..26] of Char;
  //2D Array. Use [1,x] for Plaintext Alphabet and [2,x] for cipher. Use alphabetical characters only.

var
  frmMain: TfrmMain;
  RotLeft : TRotor;
  RotMid : TRotor;
  RotRight : TRotor;
implementation

uses uDecrypt, uRotors;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.ebRotor1Change(Sender: TObject);
begin
     //empty
end;

procedure TfrmMain.MoveRotors(rWay : Integer);
var
  LTemp, MTemp, RTemp : Char;
  i : Integer;
  LBeg, MBeg, RBeg : String;
begin
     if rWay = 0 then
        MoveRotorsForwards
     else
         MoveRotorsBackwards;

     LBeg := RotLeft[2,1];
     MBeg := RotMid[2,1];
     RBeg := RotRight[2,1];
     ebRotor3.Text := LBeg;
     ebRotor2.Text := MBeg;
     ebRotor1.Text := RBeg;
end;

procedure TfrmMain.InitRotors;
var
  i : Integer;
begin
     for i := 1 to 26 do
     begin
       RotLeft[1,i] := chr(64+i);
       RotMid[1,i] := chr(64+i);
       RotRight[1,i] := chr(64+i);
     end;
end;

procedure TfrmMain.CipherRotors;
var
  i, LRotASCII, MRotASCII, RRotASCII : Integer;
  LRotVal, MRotVal, RRotVal : String;
  OldChar : Integer;
begin

     //Set Cypher Alphabet
     RotLeft[2,1] := ebRotor3.Text[1];
     RotMid[2,1] := ebRotor2.Text[1];
     RotRight[2,1] := ebRotor1.Text[1];
     LRotASCII := ord(RotLeft[2,1]);
     MRotASCII := ord(RotMid[2,1]);
     RRotASCII := ord(RotRight[2,1]);
     for i := 2 to 26 do
     begin
       if ord(RotLeft[2,i-1]) < 90 then
          begin
            OldChar := ord(RotLeft[2,i-1]);
            RotLeft[2,i] := chr(OldChar+1);
          end
       else
           RotLeft[2,i] := 'A';
       if ord(RotMid[2,i-1]) < 90 then
          begin
            OldChar := ord(RotMid[2,i-1]);
            RotMid[2,i] := chr(OldChar+1);
          end
       else
           RotMid[2,i] := 'A';
       if ord(RotRight[2,i-1]) < 90 then
          begin
            OldChar := ord(RotRight[2,i-1]);
            RotRight[2,i] := chr(OldChar+1);
          end
       else
           RotRight[2,i] := 'A';
     end;
end;

procedure TfrmMain.btnEncryptClick(Sender: TObject);
var
  PlainTxtStr, CipherTxtStr : String;
  PlainTxtLength, i, a : Integer;
  ToFind : Char;
begin
     CipherRotors;
     ebRotor1.Enabled := False;
     ebRotor2.Enabled := False;
     ebRotor3.Enabled := False;
     ebPlainText.ReadOnly := True;
     PlainTxtStr := ebPlainText.Text;
     PlainTxtLength := Length(PlainTxtStr);
     for i := 1 to PlainTxtLength do
     begin
       ToFind := upcase(PlainTxtStr[i]);
       a := 0;

       //First Rotor
       repeat
         a := a + 1;
       until RotLeft[1,a] = ToFind;
       ToFind := RotLeft[2,a];
       a := 0;

       //Second Rotor
       repeat
         a := a + 1;
       until RotMid[1,a] = ToFind;
       ToFind := RotMid[2,a];
       a := 0;

       //Third Rotor
       repeat
         a := a + 1;
       until RotRight[1,a] = ToFind;
       ToFind := RotRight[2,a];

       //Reflector
       a := 27 - a;
       ToFind := chr(a+64);
       a := 0;

       //Fourth Rotor (third reversed)
       repeat
         a := a + 1;
       until RotRight[2,a] = ToFind;
       ToFind := RotRight[1,a];
       a := 0;

       //Fifth Rotor (second reversed)
       repeat
         a := a + 1;
       until RotMid[2,a] = ToFind;
       ToFind := RotMid[1,a];
       a := 0;

       //Sixth Rotor (first reversed)
       repeat
         a := a + 1;
       until RotLeft[2,a] = ToFind;
       ToFind := RotLeft[1,a];
       a := 0;

       CipherTxtStr := CipherTxtStr + ToFind;
       ebCipherText.Text := CipherTxtStr;
       if i <> length(PlainTxtStr) then
          MoveRotors(0);

       ebRotor1.Enabled := True;
       ebRotor2.Enabled := True;
       ebRotor3.Enabled := True;
       ebPlainText.ReadOnly := False;

     end;
end;

procedure TfrmMain.btnDecryptClick(Sender: TObject);
var
  PlainTxtStr, CipherTxtStr, TempStr : String;
  CipherTxtLength, i, a : Integer;
  ToFind : Char;
begin
     CipherRotors;
     ebRotor1.Enabled := False;
     ebRotor2.Enabled := False;
     ebRotor3.Enabled := False;
     ebPlainText.ReadOnly := True;
     TempStr := ebCipherText.Text;
     CipherTxtStr := ReverseString(TempStr);
     CipherTxtLength := Length(CipherTxtStr);
     for i := 1 to CipherTxtLength do
     begin
       ToFind := decryptMessage(CipherTxtStr, upcase(CipherTxtStr[i]));
       PlainTxtStr := PlainTxtStr + ToFind;
       ebPlainText.Text := ReverseString(PlainTxtStr);
       if i <> CipherTxtLength then
          MoveRotors(1);

       ebRotor1.Enabled := True;
       ebRotor2.Enabled := True;
       ebRotor3.Enabled := True;
       ebPlainText.ReadOnly := False;

     end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     InitRotors;
     //ebCipherText.ReadOnly := True;
end;

end.

