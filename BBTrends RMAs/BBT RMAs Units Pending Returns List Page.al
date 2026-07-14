Page 51231 "RMAs Units Pending Returns"
{
    Caption = 'Units Pending of Sales Return', Comment = 'ESP="Unidades Pendientes de Devolución"';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "RMAs Package Line";
    SourceTableTemporary = true;
    ApplicationArea = All;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Analysis Date"; Rec."Analysis Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted Quantity"; Rec."Posted Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = 'Unfavorable';
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Reason"; Rec."Return Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Incident; Rec.Incident)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Incident Reason"; Rec."Incident Reason")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(ReturnInfoFaxbox; "RMAs Return Info Faxbox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = field("Return Order No.");
            }
            part(ReturnItemFaxbox; "RMAs Return Item Faxbox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Package No." = field("Package No."), "Item No." = field("Item No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DocReturn)
            {
                ApplicationArea = All;
                Caption = 'Document', Comment = 'ESP="Devolución"';
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');

                RunObject = Page "Sales Return Order";
                RunPageLink = "No." = field("Return Order No.");
                RunPageMode = View;
            }
            action(Posting)
            {
                ApplicationArea = All;
                Caption = 'Posting', comment = 'ESP="Registro"';
                Image = PostingEntries;
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec."Return Order No." <> '');

                trigger OnAction()
                var
                    cuRMASManagement: Codeunit "RMAs Management";
                    rRMAsPacKage: Record "RMAs Package";
                    Text01: Label 'Do you want to post the package lines?', Comment = 'ESP="¿Quiere registrar las líneas del bulto?"';
                    Text02: Label 'The package lines were successfully posted', Comment = 'ESP="Las líneas del bulto se registraron correctamente."';
                begin
                    if not Confirm(Text01, false) then exit;
                    rRMAsPacKage.Reset();
                    rRMAsPacKage.SetRange("Package No.", rec."Package No.");
                    if rRMAsPacKage.FindFirst() then begin
                        cuRMASManagement.ReturnAdjustment(rRMAsPacKage, Rec."Package Line");
                        //Message(Text02);
                    end;
                    CurrPage.Update();
                end;
            }
            action(Discard)
            {
                ApplicationArea = All;
                Caption = 'Discard', comment = 'ESP="Descartar"';
                Image = CancelLine;
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec."Return Order No." <> '');

                trigger OnAction()
                var
                    rRMAPackage: Record "RMAs Package";
                    Text01: Label 'Do you you want to discard the selected package?', Comment = 'ESP="¿Quiere descartar el bulto seleccionado?"';
                begin
                    if not Confirm(Text01, false) then exit;
                    rRMAPackage.Reset();
                    rRMAPackage.SetRange("Package No.", Rec."Package No.");
                    if rRMAPackage.FindFirst() then begin
                        rRMAPackage."Registered Package" := false;
                        rRMAPackage.Modify();
                    end;
                    Rec.CalcFields("Registered Package");
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        PackageLine: Integer;

    trigger OnOpenPage()
    begin
        /*
        Rec.FilterGroup(42); // Entra al grupo de filtros "oculto/bloqueado"
        Rec.CalcFields("Registered Package");
        Rec.SetFilter("Return Order No.", '<>%1', '');
        Rec.SetFilter(Quantity, '>%1', 0);
        Rec.SetFilter("Remaining Quantity", '>%1', 0);
        Rec.FilterGroup(0);
        */
    end;

    trigger OnInit()
    begin
        RecordSelection();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Posted Quantity", "Registered Package");
    end;

    local procedure RecordSelection()
    var
        rRMAPackageSel: record "RMAs Package";
        rRMAPackageLineSel: Record "RMAs Package Line";
    begin
        Rec.Reset();
        Rec.DeleteAll();

        rRMAPackageSel.Reset();
        rRMAPackageSel.SetRange("Package Status", rRMAPackageSel."Package Status"::Closed);
        rRMAPackageSel.SetRange("Registered Package", true);
        if rRMAPackageSel.FindSet() then
            repeat begin
                rRMAPackageLineSel.Reset();
                rRMAPackageLineSel.SetRange("Package No.", rRMAPackageSel."Package No.");
                rRMAPackageLineSel.SetFilter("Return Order No.", '<>%1', '');
                rRMAPackageLineSel.SetFilter(Quantity, '>%1', 0);
                if rRMAPackageLineSel.FindSet() then
                    repeat begin
                        rRMAPackageLineSel.GetRemainingQuantity(rRMAPackageLineSel);
                        if rRMAPackageLineSel."Remaining Quantity" > 0 then begin
                            Rec.Init();
                            Rec := rRMAPackageLineSel;
                            Rec.Insert();
                        end;
                    end;
                    until rRMAPackageLineSel.Next() = 0;
            end;
            until rRMAPackageSel.Next() = 0;
    end;
}
