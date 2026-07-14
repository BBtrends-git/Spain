TableExtension 50127 "BBT Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "EAN Code"; Text[14])
        {
            Caption = 'EAN Code';
            Description = '001';
        }
        field(50004; "Discount 1 %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscountCaption(1);
            //<<
            Caption = 'Disc. 1 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50005; "Discount 2 %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscountCaption(2);
            //<<
            Caption = 'Disc. 2 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50006; "Discount 3 %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscountCaption(3);
            //<<
            Caption = 'Disc. 3 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50007; "Discount 4 %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscountCaption(4);
            //<<
            Caption = 'Disc. 4 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50009; "Discount 5 %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscountCaption(5);
            //<<
            Caption = 'Disc. 5 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50010; "Discount 1 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(1);
            //<<
            Caption = 'Discount 1 Amount';
            Description = '002';
        }
        field(50011; "Discount 2 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(2);
            //<<
            Caption = 'Discount 2 Amount';
            Description = '002';
        }
        field(50012; "Discount 3 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(3);
            //<<
            Caption = 'Discount 3 Amount';
            Description = '002';
        }
        field(50013; "Discount 4 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(4);
            //<<
            Caption = 'Discount 4 Amount';
            Description = '002';
        }
        field(50014; "Discount 5 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(5);
            //<<
            Caption = 'Discount 5 Amount';
            Description = '002';
        }
        field(50015; "Discounts Total Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
            Caption = 'Discounts Total Amount';
            Description = '002';
        }
        field(50018; "Commission %"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
            Caption = 'Commission %';
            DecimalPlaces = 2 : 2;
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50019; "Commission Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
            Caption = 'Commission Amount';
            Description = '003';
        }
        field(50020; "Net Unit Price"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
            Caption = 'Net Unit Price';
            Description = '004';
        }
        field(50022; "EDI - Item code type"; Code[3])
        {
            Caption = 'EDI - Tipo código artículo';
            Description = 'EDI';
        }
        field(50023; "EDI - Promotion variable"; Text[35])
        {
            Caption = 'EDI - Variable promocional';
            Description = 'EDI';
        }
        field(50024; "EDI - Extra item EAN"; Code[35])
        {
            Caption = 'EDI - EAN Artículo adicional';
            Description = 'EDI';
        }
        field(50025; "EDI - Reimbursed Qty."; Decimal)
        {
            Caption = 'EDI - Cdad. Bonificada';
            Description = 'EDI';
        }
        field(50026; "EDI - Line Amount"; Decimal)
        {
            Caption = 'EDI - Importe neto línea';
            Description = 'EDI';
        }
        field(50027; "EDI - Gross unit price"; Decimal)
        {
            Caption = 'EDI - Precio bruto unitario';
            Description = 'EDI';
        }
        field(50028; "EDI - Net unit price"; Decimal)
        {
            Caption = 'EDI - Precio neto unitario';
            Description = 'EDI';
        }
        field(50029; "EDI - Price UOM"; Code[6])
        {
            Caption = 'EDI - Ud. Medida Precio';
            Description = 'EDI';
        }
        field(50030; "EDI - Tax type"; Code[6])
        {
            Caption = 'EDI - Tipo impuesto';
            Description = 'EDI';
        }
        field(50031; "EDI - Tax %"; Decimal)
        {
            Caption = 'EDI - % Impuesto';
            Description = 'EDI';
        }
        field(50032; "EDI - Tax Amt."; Decimal)
        {
            Caption = 'EDI - Importe impuesto';
            Description = 'EDI';
        }
        field(50033; "EDI - RE %"; Decimal)
        {
            Caption = 'EDI - % RE';
            Description = 'EDI';
        }
        field(50034; "EDI - RE Amt."; Decimal)
        {
            Caption = 'EDI - Importe RE';
            Description = 'EDI';
        }
        field(50035; "EDI - Other tax type"; Code[6])
        {
            Caption = 'EDI - Otro tipo impuesto';
            Description = 'EDI';
        }
        field(50036; "EDI - Other tax %"; Decimal)
        {
            Caption = 'EDI - % Otro impuesto';
            Description = 'EDI';
        }
        field(50037; "EDI - Other tax amt."; Decimal)
        {
            Caption = 'EDI - Importe otro impuesto';
            Description = 'EDI';
        }
        field(50038; "EDI - Net weight"; Decimal)
        {
            Caption = 'EDI - Peso neto';
            Description = 'EDI';
        }
        field(50039; "EDI - Weight UOM"; Code[6])
        {
            Caption = 'EDI - Ud. Medida peso';
            Description = 'EDI';
        }
        field(50040; "EDI - Model description"; Text[25])
        {
            Caption = 'EDI - Descripción modelo';
            Description = 'EDI';
        }
        field(50041; "EDI - Color"; Text[25])
        {
            Caption = 'EDI - Color';
            Description = 'EDI';
        }
        field(50042; "EDI - Width or size"; Text[25])
        {
            Caption = 'EDI - Anchura o talla';
            Description = 'EDI';
        }
        field(50043; "EDI - Item SN"; Code[35])
        {
            Caption = 'EDI - Nº Serie artículo';
            Description = 'EDI';
        }
        field(50044; "EDI - Item Lot"; Code[35])
        {
            Caption = 'EDI - Nº Lote artículo';
            Description = 'EDI';
        }
        field(50045; "EDI - Manufacturer Item No."; Code[35])
        {
            Caption = 'EDI - Nº Art. Fabricante';
            Description = 'EDI';
        }
        field(50046; "EDI - Line Amt. Tax incl."; Decimal)
        {
            Caption = 'EDI - Importe línea impuestos incl.';
            Description = 'EDI';
        }
        field(50047; "EDI - Net unit price base"; Decimal)
        {
            Caption = 'EDI - Base precio neto unitario';
            Description = 'EDI';
        }
        field(50048; "EDI - Item price taxes incl."; Decimal)
        {
            Caption = 'EDI - Precio art. Impuestos incl.';
            Description = 'EDI';
        }
        field(50049; "EDI - Shipment No."; Code[17])
        {
            Caption = 'EDI - Nº Albarán';
            Description = 'EDI';
        }
        field(50050; "EDI - Shipment date"; Date)
        {
            Caption = 'EDI - Fecha albarán';
            Description = 'EDI';
        }
        field(50051; "EDI - End customer code"; Code[17])
        {
            Caption = 'EDI - Cód. Cliente final';
            Description = 'EDI';
        }
        field(50052; "EDI - End customer name"; Text[70])
        {
            Caption = 'EDI - Nombre cliente final';
            Description = 'EDI';
        }
        field(50053; "EDI - End customer address"; Text[70])
        {
            Caption = 'EDI - Dirección cliente final';
            Description = 'EDI';
        }
        field(50054; "EDI - End customer city"; Text[35])
        {
            Caption = 'EDI - Población cliente final';
            Description = 'EDI';
        }
        field(50055; "EDI - End customer post code"; Code[9])
        {
            Caption = 'EDI - CP cliente final';
            Description = 'EDI';
        }
        field(50056; "EDI - Item ID/Order Line"; Code[15])
        {
            Caption = 'EDI - Id. Producto/Línea pedido';
            Description = 'EDI';
        }
        field(50057; "EDI - EAN13/DUN14"; Code[15])
        {
            Caption = 'EDI - EAN13/DUN14';
            Description = 'EDI';
        }
        field(50058; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Description = 'EDI';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
            end;
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
        field(50060; "Customer Service Line No."; Integer)
        {
            Caption = 'No. línea servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Line"."Line No." where("Document No." = field("Customer Service No."));
        }
        field(50061; "BBT Shipping Charge"; Boolean)
        {
            Caption = 'Shipping Charge', comment = 'ESP="Cargo portes"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50101; "Service Zone Code"; Code[10])
        {
            CalcFormula = lookup("Sales Invoice Header"."Service Zone Code" where("No." = field("Document No.")));
            Caption = 'Service Zone Code';
            Description = '005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "Salesperson Code"; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Header"."Salesperson Code" where("No." = field("Document No.")));
            Caption = 'Salesperson Code';
            Description = '005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50150; "Purchase Group"; Code[10])
        {
            Caption = 'Purchase Group';
            Description = '002';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CalcFormula = lookup(Customer."Purchase Group" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50151; "Customer Type"; Code[10])
        {
            Caption = 'Customer Type';
            Description = '003';
            Editable = false;
            //>> BBT. SMG Extension. 
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer."Customer Type" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50152; Platform; Code[10])
        {
            Caption = 'Platform';
            Description = '003';
            Editable = false;
            //>> BBT. SMG Extension. 
            //ObsoleteState = Removed;
            //CalcFormula = lookup(Customer.Platform where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50153; "National Group"; Code[10])
        {
            Caption = 'National Group';
            Description = '003';
            Editable = false;
            //>> BBT. SMG Extension. 
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer."National Group" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50154; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Description = '200916';
            Editable = false;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50155; "Tariff Code"; Code[20])
        {
            Caption = 'Tariff Code';
            Description = 'Cód. arencelario';
            CalcFormula = lookup(Item."Tariff No." where("No." = field("No.")));
            FieldClass = FlowField;
        }
    }
    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    //var
    //    SalesDisc: Record "Sales Discounts";
    //<<
}
