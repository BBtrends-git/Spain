Page 50039 "Packaging Subform"
{
    Caption = 'Lineas Embalaje';
    PageType = ListPart;
    SourceTable = "Packaging Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; ItemNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Producto';
                    TableRelation = Item;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                        ItemCrossReference: Record "Item Reference";
                    begin
                        if ItemNo = '' then
                            Rec.Validate("Item No.", '')
                        else begin
                            Item.Reset;
                            if Item.Get(ItemNo) then
                                Rec.Validate("Item No.", Item."No.")
                            else begin
                                ItemCrossReference.Reset;
                                ItemCrossReference.SetFilter("Item No.", '<>%1', '');
                                ItemCrossReference.SetRange("Reference No.", ItemNo);
                                if ItemCrossReference.FindSet then
                                    Rec.Validate("Item No.", ItemCrossReference."Item No.")
                                else
                                    Error('No se ha encontrado información con la referencia ' + ItemNo);
                            end;
                        end;
                        CurrPage.Update;
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(OutstandingQty; OutstandingQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cdad. Pendiente';
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(SourceDocQty; SourceDocQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cdad. Documento orig.';
                    Editable = false;
                    Visible = not IsPosted;
                }
                field(PackedQty; PackedQty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cdad. Embalada';
                    Editable = false;
                    Visible = not IsPosted;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        PackagingLine: Record "Packaging Line";
    begin
        GetHeader;
        IsPosted := Packaging."Posted Source No." <> '';
        ItemNo := Rec."Item No.";
        if not IsPosted then begin
            SourceDocQty := Rec.CalcSourceDocQty;
            PackedQty := Rec.CalcPackedQty;
            OutstandingQty := SourceDocQty - PackedQty;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ItemNo := '';
    end;

    var
        ItemNo: Code[20];
        SourceDocQty: Decimal;
        Packaging: Record Packaging;
        OutstandingQty: Decimal;
        PackedQty: Decimal;
        IsPosted: Boolean;

    local procedure GetHeader()
    begin
        Packaging.Reset;
        if Rec."No." = '' then exit;
        Packaging.Get(Rec."No.");
    end;
}
