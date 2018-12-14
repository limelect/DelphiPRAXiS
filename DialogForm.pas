unit DialogForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmDlg = class(TForm)
    Button1: TButton;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmDlg: TfrmDlg;

implementation

{$R *.fmx}

procedure TfrmDlg.Button1Click(Sender: TObject);
begin
Close;
end;



end.
