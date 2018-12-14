program DelphiPraxis;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  u_urlOpen in 'u_urlOpen.pas',
  Options in 'Options.pas' {Form2},
  DialogForm in 'DialogForm.pas' {frmDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmDlg, frmDlg);
  Application.Run;
end.
