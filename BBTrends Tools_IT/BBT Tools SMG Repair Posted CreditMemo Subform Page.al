page 59037 "Tools Posted CrMemo Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Line";
    ModifyAllowed = true;
    Permissions = tableData "Sales Cr.Memo Header" = rimd,
                    tabledata "Sales Cr.Memo Line" = rimd;
    ;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = ALL;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = ALL;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field(LineDiscountAmount; LineDiscountAmount)
                {
                    ApplicationArea = ALL;
                    AutoFormatType = 0;
                    DecimalPlaces = 2 : 5;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Rec."Line Discount Amount" := LineDiscountAmount;
                        clear(LineDiscountAmount);
                    end;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = ALL;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec.Amount := Rec."Line Amount";
                        Rec."VAT Base Amount" := Rec."Line Amount";
                        Rec."Amount Including VAT" := Round(Rec."Line Amount" + (Rec."Line Amount" * Rec."VAT %" / 100), 0.01);
                        Rec."SMG Net Unit Price" := Round(Rec."Line Amount" / Rec.Quantity, 0.001);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 5;
                    Editable = true;
                }
                // SMG
                field("SMG Net Unit Price"; Rec."SMG Net Unit Price")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 1 %"; Rec."SMG Discount 1 %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 1 Amount"; Rec."SMG Discount 1 Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec."SMG Discounts Total Amount" := Rec."SMG Discount 1 Amount" +
                                                            Rec."SMG Discount 2 Amount" +
                                                            Rec."SMG Discount 3 Amount" +
                                                            Rec."SMG Discount 4 Amount" +
                                                            Rec."SMG Discount 5 Amount";
                    end;
                }
                field("SMG Discount 2 %"; Rec."SMG Discount 2 %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 2 Amount"; Rec."SMG Discount 2 Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec."SMG Discounts Total Amount" := Rec."SMG Discount 1 Amount" +
                                                            Rec."SMG Discount 2 Amount" +
                                                            Rec."SMG Discount 3 Amount" +
                                                            Rec."SMG Discount 4 Amount" +
                                                            Rec."SMG Discount 5 Amount";
                    end;
                }
                field("SMG Discount 3 %"; Rec."SMG Discount 3 %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 3 Amount"; Rec."SMG Discount 3 Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec."SMG Discounts Total Amount" := Rec."SMG Discount 1 Amount" +
                                                            Rec."SMG Discount 2 Amount" +
                                                            Rec."SMG Discount 3 Amount" +
                                                            Rec."SMG Discount 4 Amount" +
                                                            Rec."SMG Discount 5 Amount";
                    end;
                }
                field("SMG Discount 4 %"; Rec."SMG Discount 4 %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 4 Amount"; Rec."SMG Discount 4 Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec."SMG Discounts Total Amount" := Rec."SMG Discount 1 Amount" +
                                                            Rec."SMG Discount 2 Amount" +
                                                            Rec."SMG Discount 3 Amount" +
                                                            Rec."SMG Discount 4 Amount" +
                                                            Rec."SMG Discount 5 Amount";
                    end;
                }
                field("SMG Discount 5 %"; Rec."SMG Discount 5 %")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                field("SMG Discount 5 Amount"; Rec."SMG Discount 5 Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        Rec."SMG Discounts Total Amount" := Rec."SMG Discount 1 Amount" +
                                                            Rec."SMG Discount 2 Amount" +
                                                            Rec."SMG Discount 3 Amount" +
                                                            Rec."SMG Discount 4 Amount" +
                                                            Rec."SMG Discount 5 Amount";
                    end;
                }
                field("SMG Discounts Total Amount"; Rec."SMG Discounts Total Amount")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                }
                //
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
            }
            group(Control28)
            {
                ShowCaption = false;
                group(Control23)
                {
                    ShowCaption = false;
                    field("Invoice Discount Amount"; TotalSalesCrMemoHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalSalesCrMemoHeader."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                        ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected.';
                    }
                }
                group(Control9)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesCrMemoHeader.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalSalesCrMemoHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalSalesCrMemoHeader."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesCrMemoHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesCrMemoHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalSalesCrMemoHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = true;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    { }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedSalesCreditMemoTotals(TotalSalesCrMemoHeader, VATAmount, Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled();
    end;

    trigger OnOpenPage()
    begin
        SetDimensionsVisibility();
    end;

    var
        DocumentTotals: Codeunit "Document Totals";
        IsFoundation: Boolean;
        LineDiscountAmount: Decimal;

    protected var
        TotalSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        VATAmount: Decimal;

    local procedure PageShowItemReturnRcptLines()
    begin
        if not (Rec.Type in [Rec.Type::Item, Rec.Type::"Charge (Item)"]) then
            Rec.TestField(Type);
        Rec.ShowItemReturnRcptLines();
    end;

    procedure ShowDocumentLineTracking()
    var
        DocumentLineTrackingPage: Page "Document Line Tracking";
    begin
        Clear(DocumentLineTrackingPage);
        DocumentLineTrackingPage.SetSourceDoc(
            "Document Line Source Type"::"Sales Credit Memo", Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", Rec."Order No.", Rec."Order Line No.");
        DocumentLineTrackingPage.RunModal();
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);

        OnAfterSetDimensionsVisibility();
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetDimensionsVisibility()
    begin
    end;
}

