PageExtension 51465 "SGA Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        modify("No.")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Customer No.")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Contact No.")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Customer Name")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Address")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Address 2")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Post Code")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to City")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to Contact")
        {
            Editable = SGADocEditable;
        }
        modify("Sell-to County")
        {
            Editable = SGADocEditable;
        }
        modify("No. of Archived Versions")
        {
            Editable = SGADocEditable;
        }
        modify("Campaign No.")
        {
            Editable = SGADocEditable;
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Editable = SGADocEditable;
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Editable = SGADocEditable;
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Editable = SGADocEditable;
        }
        modify("Corrected Invoice No.")
        {
            Editable = SGADocEditable;
        }
        modify("Foreign Trade")
        {
            Editable = SGADocEditable;
        }
        addafter("Corrected Invoice No.")
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SGAEnabled;
            }
            field("SGA Inserted"; Rec."SGA Inserted")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SGAEnabled;
            }
            field("SGA Readed"; Rec."SGA Readed")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SGAEnabled;
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action(SendToSGA)
            {
                ApplicationArea = Basic;
                Caption = 'Send to SGA', Comment = 'Enviar SGA';
                Enabled = SGAEnabled;
                Visible = SGAEnabled;
                Image = SKU;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."SGA Status" <> Rec."SGA Status"::" " then Error(Error01);
                    cuSGAInterfaces.GestionDevolucionVenta(Rec."No.");
                    Clear(cuSGAInterfaces);
                end;
            }
        }
    }
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        SGADocEditable: Boolean;
        SGAEnabled: Boolean;
        Error01: Label 'Return sent to the SGA', Comment = 'ESP="Devolución enviada a SGA"';

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
        SetSGADocEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        SetSGADocEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord();
        if cuSGAManagement.IsSGAEnabled() then begin
            if (rec."SGA Status" <> Rec."SGA Status"::" ") then
                error(Error01);
        end;
        exit(rec.ConfirmDeletion);
    end;

    local procedure SetSGADocEditable()
    begin
        SGADocEditable := true;
        if SGAEnabled then
            SGADocEditable := (Rec."SGA Status" = Rec."SGA Status"::" ");
    end;

    trigger OnClosePage()
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            CurrPage.Update(false);
            if rec."SGA Modified" then
                if (Rec."SGA Status" <> Rec."SGA Status"::" ") then
                    cuSGAInterfaces.GestionDevolucionVenta(rec."No.");
        END;
    end;
}