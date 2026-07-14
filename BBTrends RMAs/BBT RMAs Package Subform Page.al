page 51203 "RMAs Package Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESP="Líneas"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "RMAs Package Line";


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = Basic, Suite;
                    /*
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ResourceList: Page "RMAs Return Resource List";
                    begin
                        ResourceList.LookupMode(true);
                        if ResourceList.RunModal() = Action::LookupOK then begin
                            Text := ResourceList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                    */
                }
                field("Analysis Date"; Rec."Analysis Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    AssistEdit = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesReturnLookup: Page "RMAs Sales Return Lookup";
                    begin
                        SalesReturnLookup.LookupMode(true);
                        if SalesReturnLookup.RunModal() = Action::LookupOK then begin
                            Text := SalesReturnLookup.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        GetItemIdentifier();
                        CurrPage.Update();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = ItemStyle;

                    trigger OnValidate()

                    begin
                        GetItem();
                        CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = ItemStyle;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                /*
                field("Transferred Quantity"; Rec."Transferred Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = SetVisible;
                }
                */
                field("Posted Quantity"; Rec."Posted Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Reason"; Rec."Return Reason")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Lot Number"; Rec."Lot Number")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Incident; Rec.Incident)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incident Reason"; Rec."Incident Reason")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = Rec.Incident;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Document)
            {
                ApplicationArea = All;
                Caption = 'Document', Comment = 'ESP="Devolución"';
                Ellipsis = false;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');

                RunObject = Page "Sales Return Order";
                RunPageLink = "No." = field("Return Order No.");
                RunPageMode = View;

                //>> Esta llamada es para cambiar de la DV (DeVolución) al RDEV (Recepción de la DEVolución)
                // Se tendria de comentar los RunObject.....
                /*
                trigger OnAction()
                var
                    rSalesReturn: Record "Sales Header";
                    rReturnReceipt: Record "Return Receipt Header";
                begin
                    rSalesReturn.Reset();
                    rSalesReturn.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                    rSalesReturn.SetRange("No.", rec."Return Order No.");
                    if rSalesReturn.FindFirst() then
                        Page.Run(6630, rSalesReturn)
                    else begin
                        rReturnReceipt.Reset();
                        rReturnReceipt.SetRange("Return Order No.", rec."Return Order No.");
                        if rReturnReceipt.FindFirst() then
                            Page.Run(6630, rSalesReturn);
                    end;
                end;
                */
                //<<
            }
        }
    }

    var
        rItem: Record Item;
        rItemIdentifier: Record "Item Identifier";
        rSalesReturn: Record "Sales Header";
        SetVisible: Boolean;
        ItemStyle: Text[20];

    trigger OnInit()
    begin
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        Clear(rSalesReturn);
        rSalesReturn.Setrange("Document Type", rSalesReturn."Document Type"::"Return Order");
        rSalesReturn.SetRange("No.", rec."Return Order No.");
        if rSalesReturn.FindFirst() then;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Posted Quantity");
        Rec.GetRemainingQuantity(Rec);

        Clear(rItem);
        ItemStyle := 'Standard';
        if rItem.Get(Rec."Item No.") then begin
            rItem.CalcFields(Comment);
            if rItem.Comment then
                ItemStyle := 'StrongAccent';
        end;
    end;

    local procedure GetItem()
    var
        rRMASetup: Record "RMAs Setup";
        ERROR01: Label 'EAN13 does not exist for product: %1 and unit of measure: %2',
                Comment = 'ESP="No existe el ENA13 para el producto: %1 y la unidad de medida: %2"';
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        Clear(rec."EAN of Unit");
        rItem.Reset();
        if ritem.Get(Rec."Item No.") then begin
            Rec.Validate(Description, rItem.Description);

            if rec."EAN of Unit" = '' then begin
                rItemIdentifier.Reset();
                rItemIdentifier.SetRange("Item No.", Rec."Item No.");
                rItemIdentifier.SetRange("Unit of Measure Code", rRMASetup."EAN13 Unit");
                if rItemIdentifier.FindFirst() then
                    Rec.Validate("EAN of Unit", rItemIdentifier.Code)
                else
                    Error(ERROR01, Rec."Item No.", rRMASetup."EAN13 Unit");
            end;
        end;

        ItemStyle := 'Standard';
        rItem.CalcFields(Comment);
        if rItem.Comment then
            ItemStyle := 'StrongAccent';
    end;

    local procedure GetItemIdentifier()
    var
        rRMASetup: Record "RMAs Setup";
        ERROR01: Label 'The product does not exist for EAN13: %1 and unit of measure: %2',
                Comment = 'ESP="No existe el producto para el EAN13: %1 y la unidad de medida: %2"';
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        Clear(Rec."Item No.");
        rItemIdentifier.Reset();
        rItemIdentifier.SetRange(Code, Rec."EAN of Unit");
        rItemIdentifier.SetRange("Unit of Measure Code", rRMASetup."EAN13 Unit");
        if rItemIdentifier.FindFirst() then begin
            if Rec."Item No." = '' then begin
                Rec.Validate("Item No.", rItemIdentifier."Item No.");
                GetItem();
            end;
        end else
            Error(ERROR01, Rec."EAN of Unit", rRMASetup."EAN13 Unit");
    end;
}