PageExtension 51351 "SMG Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(General)
        {
            group(SRM)
            {
                Caption = 'Vendors Relationship', Comment = 'ESP="Relaciones con Proveedor"';
                Visible = SRMEnable;
                Enabled = SRMEnable;

                group(SRM_01)
                {
                    //    Caption = 'SRM Classification', Comment = 'ESP="Clasificacion RSM"';
                    ShowCaption = false;

                    field("SRM Evaluation Manager"; Rec."SRM Evaluation Manager")
                    {
                        ApplicationArea = All;
                        Visible = SRMTypeEnabled;
                        Enabled = SRMTypeEnabled;
                        DrillDownPageId = "SRM Evaluation Manager";

                        trigger OnValidate()
                        begin
                            if Rec."SRM Evaluation Manager" <> xRec."SRM Evaluation Manager" then begin
                                Rec."SRM Last Evaluation Date" := WorkDate();
                            end;
                        end;
                    }

                    field("SRM Vendor Type"; Rec."SRM Vendor Type")
                    {
                        ApplicationArea = All;
                        Visible = SRMTypeEnabled;
                        Enabled = SRMTypeEnabled;

                        trigger OnValidate()
                        begin
                            if Rec."SRM Vendor Type" <> xRec."SRM Vendor Type" then begin
                                Rec."SRM Last Evaluation Date" := WorkDate();
                            end;
                        end;
                    }
                    field("SRM Vendor Performance"; Rec."SRM Vendor Performance")
                    {
                        ApplicationArea = All;
                        Visible = SRMPerformanceEnabled;
                        Enabled = SRMPerformanceEnabled;

                        trigger OnValidate()
                        begin
                            if Rec."SRM Vendor Performance" <> xRec."SRM Vendor Performance" then begin
                                Rec."SRM Last Evaluation Date" := WorkDate();
                            end;
                        end;
                    }
                    field("SRM Vendor Classification"; Rec."SRM Vendor Classification")
                    {
                        ApplicationArea = All;
                        Visible = SRMClassificationEnabled;
                        Enabled = SRMClassificationEnabled;
                        DrillDownPageId = "SRM Vendor Classification";

                        trigger OnValidate()
                        begin
                            if Rec."SRM Vendor Classification" <> xRec."SRM Vendor Classification" then begin
                                Rec."SRM Last Evaluation Date" := WorkDate();
                            end;
                        end;
                    }
                }
                group(SRM_02)
                {
                    ShowCaption = false;

                    field(LastComment; LastComment)
                    {
                        Caption = 'Last Comment', Comment = 'ESP="Ultimo Comentario"';
                        ApplicationArea = All;
                        Visible = SRMClassificationEnabled;
                        Enabled = SRMClassificationEnabled;
                        Editable = false;
                        DrillDown = true;

                        trigger OnDrillDown()
                        var
                            rCommentLine: Record "Comment Line";
                        begin
                            rCommentLine.Reset();
                            rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::Vendor);
                            rCommentLine.SetRange("No.", rec."No.");
                            rCommentLine.SetCurrentKey(SystemCreatedAt, "Line No.");
                            rCommentLine.Ascending(true);
                            Page.RunModal(Page::"SRM Vendor Comments", rCommentLine);

                            LastComment := cuSRMManagement.FindLastComment(Rec);
                            CurrPage.Update();
                        end;
                    }
                    field(TextCategories; TextCategories)
                    {
                        Caption = 'Item Categories', Comment = 'ESP="Categorias de Producto"';

                        ApplicationArea = All;
                        Visible = SRMClassificationEnabled;
                        Enabled = SRMClassificationEnabled;
                        Editable = false;
                        DrillDown = true;

                        trigger OnDrillDown()
                        var
                            rSRMVendorItemCategories: Record "SRM Vendor Item Categories";
                        begin
                            rSRMVendorItemCategories.Reset();
                            rSRMVendorItemCategories.SetRange("Vendor No.", rec."No.");
                            Page.Run(Page::"SRM Vendor Item Categories", rSRMVendorItemCategories);

                            Categories := cuSRMManagement.CountCategories(Rec);
                            TextCategories := Format(Categories);
                            CurrPage.Update();
                        end;
                    }
                    field("SRM Last Evaluation Date"; Rec."SRM Last Evaluation Date")
                    {
                        ApplicationArea = All;
                        Visible = SRMClassificationEnabled;
                        Enabled = SRMClassificationEnabled;
                        Editable = false;
                    }
                }
                group(SRM_03)
                {
                    Caption = 'Contact', Comment = 'ESP="Contacto"';

                    field(SRMContactNo; Rec."Primary Contact No.")
                    {
                        ApplicationArea = All;
                        Visible = SRMClassificationEnabled;
                        Enabled = SRMClassificationEnabled;
                        Caption = 'Primary Contact Code', Comment = 'ESP="Contacto Principal"';
                    }
                }
            }
        }
        addafter(Control82)
        {
            part(SRMVendorComments; "SRM Vendor Comments")
            {
                ApplicationArea = All;
                Visible = SRMClassificationEnabled;
                SubPageLink = "Table Name" = const(Vendor), "No." = field("No.");
            }
        }
    }

    var
        cuSRMManagement: Codeunit "SRM Management";
        rSRMSetup: Record "SRM Setup";
        SRMEnable: Boolean;
        SRMTypeEnabled: Boolean;
        SRMPerformanceEnabled: Boolean;
        SRMClassificationEnabled: Boolean;
        LastComment: Text[80];
        Categories: Integer;
        TextCategories: Text[8];

    trigger OnOpenPage()
    begin
        SRMEnable := cuSRMManagement.IsSRMEnabled;
        cuSRMManagement.InitializeSRMConfiguration(rSRMSetup);
        SRMTypeEnabled := rSRMSetup."SRM Type Enabled";
        SRMPerformanceEnabled := rSRMSetup."SRM Performance Enabled";
        SRMClassificationEnabled := rSRMSetup."SRM Classification Enabled";
    end;

    trigger OnAfterGetRecord()
    begin
        LastComment := cuSRMManagement.FindLastComment(Rec);
        Categories := cuSRMManagement.CountCategories(Rec);
        TextCategories := Format(Categories);
    end;
}