unit Options;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit;

type
  TForm2 = class(TForm)
    ToolBar1: TToolBar;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Rectangle2: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
  uses Unit1;

procedure TForm2.FormCreate(Sender: TObject);
begin
 Edit2.Text:= MainForm.MemberKey;
  Edit1.Text:=MainForm.MemberNumber;
 end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 MainForm.MemberKey:=Edit2.Text;
  MainForm.MemberNumber:=Edit1.Text;

Close;
end;

end.
