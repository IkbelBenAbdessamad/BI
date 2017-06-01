{*********************************************}
{  TeeBI Software Library                     }
{  Importing data from VCL Controls           }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit FMXBI.Component;
{$DEFINE FMX}

interface

{
  This unit contains a TControlImporter component for VCL and FMX.

  Its purpose is to obtain data from any supported TControl.

  Like for example, using Memo.Lines text to import (in JSON, CSV, XML format),
  or using the Data property of a BI control (Grid, Chart, Tree, etc).

  Usage example:

   var tmp : TControlImporter;
   tmp:=TControlImporter.Create(Self);
   tmp.Source:=Memo1;

   BIGrid1.Data:=tmp.Data;

  Simpler usage:

   BIGrid1.Data:=TControlImporter.From(Self,Memo1);


  Supported TControl classes (and derived classes):

  VCL and Firemonkey:

  - TCustomEdit
  - TCustomGrid
  - TCustomTreeView
  - TCustomListView
  - TBIDataControl ( TBIGrid, TBIChart, TBITree, etc )
  - TDataProvider ( many TeeBI classes: TBIWorkflow etc etc etc )

  Firemonkey only:

  - TCustomComboEdit
  - TPopupBox
  - TPopupColumn
  - TCustomListBox
  - TCustomComboBox
  - TCustomMemo

  When a control is not supported, TControlImporter calls its parent class
  to try to obtain data from it.

  See BI.Store.Component unit :  TComponentImporter class

}

uses
  System.Classes, BI.DataItem, BI.Store.Component;

type
  {$IFNDEF FPC}
  {$IF CompilerVersion>=23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
              {$IF CompilerVersion>=25}or pidiOSSimulator or pidiOSDevice{$ENDIF}
              {$IF CompilerVersion>=26}or pidAndroid{$ENDIF}
              {$IF CompilerVersion>=29}or pidiOSDevice64{$ENDIF}
              )]
  {$ENDIF}
  {$ENDIF}
  TControlImporter=class(TComponentImporter)
  protected
    function DoImport(const AComponent: TComponent):TDataItem; override;
  public
    class function DataOf(const AComponent:TComponent):TDataItem; override;
    class function HasDataProperty(const AComponent:TComponent):Boolean; static;
    class function HasTextProperty(const AComponent:TComponent):Boolean; static;
    class function StringsOf(const ASource:TComponent):TStrings; override;
    class function Supports(const AComponent:TComponent):Boolean; override;
    class function TextOf(const AComponent:TComponent):String; overload; static;
  end;

implementation
