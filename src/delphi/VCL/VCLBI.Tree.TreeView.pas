{*********************************************}
{  TeeBI Software Library                     }
{  Plugin TBITree class for VCL TTreeView     }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit VCLBI.Tree.TreeView;

interface

uses
  System.Classes, VCL.Controls, VCL.ComCtrls,
  BI.Arrays, VCLBI.Tree;

type
  TBITreeViewPlugin=class(TBITreePlugin)
  private
    FAllowDelete : Boolean;
    FTree : TTreeView;
    FTreeOnChange : TNotifyEvent;
    FTreeOnCheck : TNotifyEvent;
    FTreeOnExpanding : TBITreeExpandingEvent;

    IClearing : Boolean;

    procedure ChangedTree(Sender: TObject; Node: TTreeNode);
    procedure ToggleChecked(const ANode:TBITreeNode);
    procedure TreeClick(Sender:TObject);
    procedure TreeExpanding(Sender: TObject; Node: TTreeNode;
                            var AllowExpansion: Boolean);
    procedure TreeKeyUp(Sender:TObject; var Key:Word; Shift:TShiftState);
    procedure TreeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    procedure BeginUpdating; override;
    procedure Clear(const ANode:TBITreeNode=nil); override;
    procedure ClearData(const ANode:TBITreeNode); override;
    procedure EndUpdating; override;
    function GetAllowDelete: Boolean; override;
    function GetControl:TControl; override;
    function GetCount:Integer; override;
    function GetNode(const AIndex:Integer):TBITreeNode; override;
    function GetOnChange: TNotifyEvent; override;
    function GetOnCheck: TNotifyEvent; override;
    function GetOnExpanding: TBITreeExpandingEvent; override;
    function GetSelected:TBITreeNode; override;
    function GetSelectedData: TBITreePlugin.TNodeData; override;
    function NodeAt(const X,Y:Integer):TBITreeNode; override;
    function SelectedText:String; override;
    procedure SetAllowDelete(const Value: Boolean); override;
    procedure SetData(const ANode: TBITreeNode; const AData: TObject); override;
    procedure SetOnChange(const Value: TNotifyEvent); override;
    procedure SetOnCheck(const Value: TNotifyEvent); override;
    procedure SetOnExpanding(const Value: TBITreeExpandingEvent); override;
    procedure SetSelected(const Value: TBITreeNode); override;
  public
    Constructor Create(const AOwner:TComponent); override;

    function Children(const ANode:TBITreeNode; const AIndex:Integer):TBITreeNode; override;
    function ChildrenCount(const ANode:TBITreeNode):Integer; override;

    function DataOf(const ANode:TBITreeNode):TObject; override;
    procedure Expand(const AIndex:Integer); override;
    procedure Expand(const ANode:TBITreeNode; const DoExpand:Boolean=True; const Recursive:Boolean=False); override;

    function Find(const ATag:TObject; const AIndex:Integer):TBITreeNode; override;
    function FirstNode:TBITreeNode; override;
    function IsChecked(const ANode:TBITreeNode):Boolean; override;
    function IsExpanded(const ANode:TBITreeNode):Boolean; override;
    function NewNode(const AParent:TBITreeNode; const AText:String;
              const ATag:TObject=nil; const AIndex:TInteger=-1):TBITreeNode; override;
    function NextNode(const ANode:TBITreeNode):TBITreeNode; override;
    function ParentOf(const ANode:TBITreeNode):TBITreeNode; override;
    procedure SetChecked(const ANode:TBITreeNode; const Value:Boolean); override;
    procedure SetText(const ANode:TBITreeNode; const Value:String); override;
    function SiblingIndex(const ANode:TBITreeNode):Integer; override;
    function TextOf(const ANode:TBITreeNode):String; override;
  end;

implementation
