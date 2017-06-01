unit VCLBI.Editor.DataRank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  BI.DataItem, BI.Workflow;

type
  TDataRankEditor = class(TForm)
    CBAscending: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure CBAscendingClick(Sender: TObject);
  private
    { Private declarations }

    FRank : TDataRankItem;
  public
    { Public declarations }
  end;

implementation
