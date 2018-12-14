unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
    System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListView,
  FMX.Objects, System.IOUtils, FMX.ListBox;

type
  TMainForm = class(TForm)
    Button1: TButton;
    XMLDoc: TXMLDocument;
    LV: TListView;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    StyleBook1: TStyleBook;
    ToolBar1: TToolBar;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    LinkListControlToField1: TLinkListControlToField;
    URLLabel: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Memo1: TMemo;
    Splitter1: TSplitter;
    LinkControlToField1: TLinkControlToField;
    Button2: TButton;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure LVDblClick(Sender: TObject);
    procedure Memo1Paint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
    MemberKey, MemberNumber: string;
    procedure mDetailApplyStyleLookup(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  u_urlOpen, Options, DialogForm;

procedure TMainForm.mDetailApplyStyleLookup(Sender: TObject);
var
  Obj: TFmxObject;
  Rectangle1: TRectangle;
begin
  Obj := Memo1.FindStyleResource('background');
  if Obj <> nil then
  begin
    TControl(Obj).Margins := TBounds.Create(TRectF.Create(-1, -1, -1, -1));
    Rectangle1 := TRectangle.Create(Obj);
    Obj.AddObject(Rectangle1);
    Rectangle1.Align := TAlignLayout.Client;
    Rectangle1.Fill.Color := $2E346F99; //775188377; $18346F99;//
    Rectangle1.Stroke.Color := 0; // 4278190080;
    Rectangle1.HitTest := False;
    Rectangle1.SendToBack;
  end;
end;

function StripHTMLTags(const strHTML: string): string;
var
  P: PChar;
  InTag: Boolean;
  i, intResultLength: Integer;
begin
  P := PChar(strHTML);
  Result := '';

  InTag := False;
  repeat
    case P^ of
      '<': InTag := True;
      '>': InTag := False;
      #13, #10: ; {do nothing}
    else
      if not InTag then
      begin
        if (P^ in [#9, #32]) and ((P + 1)^ in [#10, #13, #32, #9, '<']) then
        else
          Result := Result + P^;
      end;
    end;
    Inc(P);
  until (P^ = #0);

  {convert system characters}
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
  {here you may add another symbols from RFC if you need}
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IniFileName: string;
  Reader: TBinaryReader;
begin
  SaveState.StoragePath := TPath.GetLibraryPath;
  //Rectangle2.fill.Color
  if SaveState.Stream.Size > 0 then
  begin
    Reader := TBinaryReader.Create(SaveState.Stream);
    try
      MemberKey := Reader.ReadString;
      MemberNumber := Reader.ReadString;
    finally
      Reader.Free;
    end;
  end
  else
  begin
    MemberKey := '';
    MemberNumber := '';
  end;
end;

const
  discover = 'https://en.delphipraxis.net/discover/';
  delphipraxis = 'https://en.delphipraxis.net/';

procedure TMainForm.Button1Click(Sender: TObject);
var
  StartItemNode: IXMLNode;
  ANode: IXMLNode;
  sTitle, sDesc, sLink: string;
  s: string;

begin
  LV.Items.Clear;
  FDMemTable1.BeginBatch;
  FDMemTable1.EmptyDataSet;
  Memo1.Lines.Clear;
  FDMemTable1.EndBatch;
  FDMemTable1.Refresh;

  if ComboBox1.ItemIndex > 2 then
  begin
    if (MemberKey = '') or (MemberNumber = '') then
    begin
      frmDlg.Label1.Text := 'No user Key or Number';
      frmDlg.ShowModal;

      Exit;
    end;
  end;
  case ComboBox1.ItemIndex of
    0: s := discover + 'all.xml';
    1: s := delphipraxis + 'rssalltopics.xml';
    2: s := delphipraxis + 'rss/1-new-topics.xml';
    3: s := discover + '1.xml/';
    4: s := discover + '2.xml/';
    5: s := discover + '3.xml/';
    6: s := discover + '4.xml/';
    7: s := discover + '5.xml/';
  end;
  if ComboBox1.ItemIndex > 2 then
    XMLDoc.FileName := s + '?member=' + MemberNumber + '&key=' + MemberKey
  else
    XMLDoc.FileName := s;
  XMLDoc.Active := True;
  StartItemNode :=
    XMLDoc.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item');
  if StartItemNode <> nil then
  begin
    ANode := StartItemNode;
    repeat
      sTitle := ANode.ChildNodes['title'].Text;
      sLink := ANode.ChildNodes['link'].Text;
      sDesc := ANode.ChildNodes['description'].Text;
      sDesc := StripHTMLTags(sDesc);
      FDMemTable1.AppendRecord([sTitle, sLink, sDesc]);

      ANode := ANode.NextSibling;
    until ANode = nil;

    LinkListControlToField1.Active := False;
    LinkListControlToField1.Active := True;
  end
  else
    Memo1.Lines.Add('There is no content to show');
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TMainForm.FormSaveState(Sender: TObject);
var
  Writer: TBinaryWriter;
begin
  SaveState.Stream.Clear;
  Writer := TBinaryWriter.Create(SaveState.Stream);
  try
    Writer.Write(MemberKey);
    Writer.Write(MemberNumber);
  finally
    Writer.Free;
  end;
end;

procedure TMainForm.LVDblClick(Sender: TObject);
begin
  tUrlOpen.Open(URLLabel.Text);
end;

procedure TMainForm.Memo1Paint(Sender: TObject; Canvas: TCanvas; const ARect:
  TRectF);
begin
  mDetailApplyStyleLookup(nil);
end;

end.

