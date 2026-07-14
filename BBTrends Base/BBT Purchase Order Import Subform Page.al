page 51114 "BBT Purch Import Subform"
{
    //Caption = 'Purchase Order Import Information', Comment = 'ESP"Información Importación"';
    Caption = ' ', Comment = 'ESP=" "';
    Editable = true;
    PageType = CardPart;
    SourceTable = "Purchase Header";
    ModifyAllowed = true;
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(info)
            {
                ShowCaption = false;
                group(planning)
                {
                    Caption = 'Planning', Comment = 'ESP"Planificación"';

                    field("No."; Rec."No.")
                    {
                        Editable = false;
                    }
                    //>> BBT 04/04/2025. Solo se utiliza el estatus de línea
                    //field("BBT Status"; Rec."BBT Status")
                    //{
                    //    Caption= 'Import Status', Comment='ESP"Estado Importación"';
                    //
                    //    trigger OnValidate()
                    //    begin
                    //        CurrPage.Update();
                    //    end;
                    //}
                    //<<
                    field("ETD PO"; Rec."ETD PO")
                    {
                        trigger OnValidate()
                        begin
                            //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                            rec.ReCalcDates(Rec);
                            //<<
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                    /*
                    field("Lead Time Calculation"; rec."Lead Time Calculation")
                    {
                        Caption = 'Lead Time Calculation', Comment = 'ESP"Plazo Entrega Proveedor"';
                        Editable = false;
                    }
                    */
                    //<<
                    //>> BBT 23/04/2025.  ETA PLANNING  pasa a ser por línea.
                    /*
                    field("BBT ETA Planning"; Rec."BBT ETA Planning")
                    {
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    } 
                    */
                    //<<
                    field("BBT Proforma"; Rec."BBT Proforma")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field("BBT ETD PI"; Rec."BBT ETD PI")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            Clear(Rec."BBT LC Opening Date");
                            if Rec."BBT ETD PI" <> 0D then begin
                                // Cálculo de la fecha para abrir la carta de credito
                                Rec."BBT LC Opening Date" := CalcDate('-2M', Rec."BBT ETD PI");
                            end;
                            //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                            CalcDateInspectTransportLastMile();
                            Rec.ReCalcDates(Rec);
                            //<<
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field(InspectTransportLastMile; InspectTransportLastMile)
                    {
                        Caption = 'Lead Time from ETD-PI', Comment = 'ESP"Plazo Entrega desde ETD-PI"';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("BBT Due Date ETD PI"; Rec."BBT Due Date ETD PI")
                    {
                        Caption = 'Date in Warehouse', Comment = 'ESP"En Almacén desde ETD-PI"';
                        Editable = false;
                    }
                }
                group(LetterCredit)
                {
                    Caption = 'Letter Credit', Comment = 'ESP"Carta de Crédito"';
                    field("BBT LC Opening Date"; Rec."BBT LC Opening Date")
                    {
                        Editable = false;
                    }
                    field("BBT LC Status"; Rec."BBT LC Status")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field("BBT LC Date Received"; Rec."BBT LC Date Received")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field("BBT LC No."; Rec."BBT LC No.")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field("BBT Bank"; Rec."BBT Bank")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                    field("BBT ETD LC"; Rec."BBT ETD LC")
                    {
                        trigger OnValidate()
                        begin
                            pgImportOrderPage.UpdateHeaderFields(Rec);
                            Rec.Modify();
                            Commit();
                        end;
                    }
                }
                group(General)
                {
                    Caption = 'General', Comment = 'ESP"General"';
                    field("BBT Situation"; Rec."BBT Situation")
                    {
                        Visible = false;
                    }
                    field("Purchaser Code"; Rec."Purchaser Code")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Product Manager"; Rec."Product Manager")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("DestinationCountry"; "CountryName")
                    {
                        Caption = 'Destination Country', Comment = 'ESP"País Destino"';
                        Editable = false;
                    }
                    field("Total Volume"; Rec."Total Container Volume")
                    {
                        Editable = false;
                    }
                }
            }
        }
    }
    var
        //rVendor: Record Vendor;
        rPurchaseLine: Record "Purchase Line";
        rItem: Record Item;
        rCountry: Record "Country/Region";
        pgImportOrderPage: Page "BBT Import Order Status";
        CountryName: Text[50];
        TotalDays: Integer;
        InspectTransportLastMile: DateFormula;

    trigger OnAfterGetRecord()
    begin
        Clear(CountryName);
        Clear(rCountry);
        if rCountry.get(rec."Destination Country") then
            CountryName := rCountry.Name;

        //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
        /*
        Clear(rVendor);
        if rVendor.get(rec."Buy-from Vendor No.") then
            rec.validate("Lead Time Calculation", rvendor."Lead Time Calculation");
        */
        CalcDateInspectTransportLastMile();
        //<<

        Rec.CalcFields("Total Container Volume");

    end;

    local procedure CalcDateInspectTransportLastMile()
    begin
        Clear(TotalDays);
        Clear(InspectTransportLastMile);
        rPurchaseLine.Reset();
        rPurchaseLine.SetRange("Document Type", Rec."Document Type");
        rPurchaseLine.SetRange("Document No.", Rec."No.");
        rPurchaseLine.SetRange(Type, rPurchaseLine.Type::Item);
        rPurchaseLine.SetFilter(Quantity, '<>%1', 0);
        If rPurchaseLine.FindFirst() then begin
            rItem.Reset();
            rItem.SetRange("No.", rPurchaseLine."No.");
            if rItem.FindFirst() then begin

                if Format(rItem."Inspection-Transit LeadTime") <> '' then
                    TotalDays += CalcDate(rItem."Inspection-Transit LeadTime", Today) - Today;
                if Format(rItem."Last Mile LeadTime") <> '' then
                    TotalDays += CalcDate(rItem."Last Mile LeadTime", Today) - Today;

                if TotalDays <> 0 then begin
                    Evaluate(InspectTransportLastMile, '<' + Format(TotalDays) + 'D>');
                    rec.validate("Lead Time Calculation", InspectTransportLastMile)
                end;
            end;
        end;
    end;
}