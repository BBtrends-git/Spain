TableExtension 50114 "BBT Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "EAN Code"; Text[14])
        {
            Caption = 'EAN Code';
            Description = '001';
        }
        field(50001; "Pallet No."; Integer)
        {
            BlankZero = true;
            Caption = 'Pallet No.';
            Description = '002';
            MinValue = 0;
        }
        field(50002; "Packing Unit of Measure"; Code[10])
        {
            Caption = 'Packing Unit of Measure"';
            Description = '002';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(50003; "Packing Quantity"; Decimal)
        {
            Caption = 'Packing Quantity';
            DecimalPlaces = 0 : 6;
            Description = '002';
        }
        field(50004; "Discount 1 %"; Decimal)
        {
            Caption = 'Disc. 1 %';
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG. 
            ObsoleteState = Pending;
            /*
            CaptionClass = SalesDisc.GetDiscountCaption(1);

            trigger OnValidate()
            begin
                // - 003
                TestJobPlanningLine;
                Rec.TestStatusOpen;
                CalcSalesDiscounts;
                Rec.Validate(Rec."Discounts Total Amount");
                if CurrFieldNo = Rec.FieldNo(Rec."Discount 1 %") then Rec.Validate(Rec."Line Discount %");
                // + 003
            end;
            */
            //<<
        }
        field(50005; "Discount 2 %"; Decimal)
        {
            Caption = 'Disc. 2 %';
            Description = '003';
            MaxValue = 100;
            MinValue = 0;

            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*
            CaptionClass = SalesDisc.GetDiscountCaption(2);

            trigger OnValidate()
            begin
                // - 003
                TestJobPlanningLine;
                Rec.TestStatusOpen;
                CalcSalesDiscounts;
                Rec.Validate(Rec."Discounts Total Amount");
                if CurrFieldNo = Rec.FieldNo(Rec."Discount 2 %") then Rec.Validate(Rec."Line Discount %");
                // + 003
            end;
            */
            //<<
        }
        field(50006; "Discount 3 %"; Decimal)
        {
            Caption = 'Disc. 3 %';
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*                
            CaptionClass = SalesDisc.GetDiscountCaption(3);

            trigger OnValidate()
            begin
                // - 003
                TestJobPlanningLine;
                Rec.TestStatusOpen;
                CalcSalesDiscounts;
                Rec.Validate(Rec."Discounts Total Amount");
                if CurrFieldNo = Rec.FieldNo(Rec."Discount 3 %") then Rec.Validate(Rec."Line Discount %");
                // + 003
            end;
            */
            //<<
        }
        field(50007; "Discount 4 %"; Decimal)
        {
            Caption = 'Disc. 4 %';
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*               
            CaptionClass = SalesDisc.GetDiscountCaption(4);

            trigger OnValidate()
            begin
                // - 003
                TestJobPlanningLine;
                Rec.TestStatusOpen;
                CalcSalesDiscounts;
                Rec.Validate(Rec."Discounts Total Amount");
                if CurrFieldNo = Rec.FieldNo(Rec."Discount 4 %") then Rec.Validate(Rec."Line Discount %");
                // + 003
            end;
            */
            //<<
        }
        field(50009; "Discount 5 %"; Decimal)
        {
            Caption = 'Disc. 5 %';
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*                
            CaptionClass = SalesDisc.GetDiscountCaption(5);

            trigger OnValidate()
            begin
                // - 003
                TestJobPlanningLine;
                Rec.TestStatusOpen;
                CalcSalesDiscounts;
                Rec.Validate(Rec."Discounts Total Amount");
                if CurrFieldNo = Rec.FieldNo(Rec."Discount 5 %") then Rec.Validate(Rec."Line Discount %");
                // + 003
            end;
            */
            //<<
        }
        field(50010; "Discount 1 Amount"; Decimal)
        {
            Caption = 'Discount 1 Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(1);
            //<<

        }
        field(50011; "Discount 2 Amount"; Decimal)
        {
            Caption = 'Discount 2 Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(2);
            //<<
        }
        field(50012; "Discount 3 Amount"; Decimal)
        {
            Caption = 'Discount 3 Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(3);
            //<<
        }
        field(50013; "Discount 4 Amount"; Decimal)
        {
            Caption = 'Discount 4 Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(4);
            //<<
        }
        field(50014; "Discount 5 Amount"; Decimal)
        {
            Caption = 'Discount 5 Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(5);
            //<<
        }
        field(50015; "Discounts Total Amount"; Decimal)
        {
            Caption = 'Discounts Total Amount';
            Description = '003';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*
            trigger OnValidate()
            begin
                // - 003
                Rec."Discounts Total Amount" := Rec."Discount 1 Amount" + Rec."Discount 2 Amount" + Rec."Discount 3 Amount" + Rec."Discount 4 Amount" + Rec."Discount 5 Amount";
                // + 003
            end;
            */
            //<<
        }
        field(50016; "Unit Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 6;
            Description = '001';
        }
        field(50017; "Unit Net Weight"; Decimal)
        {
            Caption = 'Unit Net Weight';
            DecimalPlaces = 0 : 6;
            Description = '001';
        }
        field(50018; "Commission %"; Decimal)
        {
            Caption = 'Commission %';
            DecimalPlaces = 2 : 2;
            Description = '004';
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*                
            trigger OnValidate()
            begin
                // - 004
                Rec.Validate(Rec."Commission Amount");
                // + 004
            end;
            */
        }
        field(50019; "Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
            Description = '004';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*
            trigger OnValidate()
            begin
                // - 004
                Rec."Commission Amount" := ROUND(Rec."Line Amount" * Rec."Commission %" / 100, Currency."Amount Rounding Precision");
                // + 004
            end;
            */
        }
        field(50020; "Net Unit Price"; Decimal)
        {
            Caption = 'Net Unit Price';
            Description = '005';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            /*
            trigger OnValidate()
            begin
                // - 005
                if Rec.Quantity = 0 then
                    Rec."Net Unit Price" := 0
                else begin
                    Rec."Net Unit Price" := ROUND(Rec."Line Amount" / Rec.Quantity, 0.01);
                end;
                // + 005
            end;
            */
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
            /*
            trigger OnValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
            end;
            */
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
        field(50080; "Condiciones fuera fact. % APOS"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50081; "Condiciones fuera fact. % COLS"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50082; "Transporte ventas %"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50083; "Garantia %"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50084; "Importe RAEE"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50085; "Royalty %"; Decimal)
        {
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<
        }
        field(50086; "Blocked for Short Margin"; Boolean)
        {
            Caption = 'Bloqueado por margen insuficiente';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<              
        }
        field(50087; "DEVS  FIN %"; Decimal)
        {
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<  
        }
        field(50088; "Margin %"; Decimal)
        {
            Caption = '% Margen';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<  
        }
        field(50090; "Numeración Desde"; Code[20])
        {
            ObsoleteState = Pending;                //BBT 01/07/2025. PRECINTIA
        }
        field(50091; "Numeración hasta"; Code[20])
        {
            ObsoleteState = Pending;                //BBT 01/07/2025. PRECINTIA
        }
        field(50092; "Numeración manual"; Boolean)
        {
            ObsoleteState = Pending;                //BBT 01/07/2025. PRECINTIA
        }
        field(50093; "Num. incremento"; Integer)
        {
            ObsoleteState = Pending;                //BBT 01/07/2025. PRECINTIA
        }
        field(50094; "Act. num. serie"; Boolean)
        {
            ObsoleteState = Pending;                //BBT 01/07/2025. PRECINTIA
        }
        field(50100; "Exported to CSV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Exported to CSV Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Shipment Nr"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50103; "Shipoment Line Nr"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50104; "Shipment Comments"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Inventoy Location Code"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Location Code" = field("Location Code")));
            FieldClass = FlowField;
        }
        field(50106; "Qty to Ship All Sales Orders"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Qty. to Ship" where(Type = field(Type), "No." = field("No."), "Location Code" = field("Location Code")));
            FieldClass = FlowField;
        }
        field(50107; "Exported to Suus"; Boolean)
        {
        }
        field(50108; "Exported to Suus Datetime"; DateTime)
        {
        }
        field(50109; "Item Tracking Code"; Code[10])
        {
            CalcFormula = lookup(Item."Item Tracking Code" where("No." = field("No.")));
            Caption = 'Item Tracking Code';
            FieldClass = FlowField;
            TableRelation = "Item Tracking Code";
        }
        field(50110; "Lot Nos."; Code[20])
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item."Lot Nos." where("No." = field("No.")));
            //FieldClass = FlowField;
            //<<
            Caption = 'Lot Nos.';
            TableRelation = "No. Series" where("Serie Producto" = const(true));
        }
        field(50111; "Drawing Part No."; Text[50])
        {
            //>> BBT 01/07/2025. PRECINTIA            
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item."Drawing Part No." where("No." = field("No.")));
            //FieldClass = FlowField;
            //<<            
            Caption = 'Drawing Part No.';
            Description = 'PRP-001';
        }
        field(50112; Embolsado; Boolean)
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item.Embolsado where("No." = field("No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50113; "Unidades Bolsa"; Integer)
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item."Unidades Bolsa" where("No." = field("No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50114; "Num. Cintas"; Integer)
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item."Num. Cintas" where("No." = field("No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50115; Material; Text[100])
        {
            //>>BBT 01/07/2025. PRECINTIA  
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item.Material where("No." = field("No.")));
            //FieldClass = FlowField;
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Material));
            //<<
        }
        field(50116; Color; Text[100])
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;    //BBT 01/07/2025. PRECINTIA
            //CalcFormula = lookup(Item.Color where("No." = field("No.")));
            //FieldClass = FlowField;
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Color));
            //<<
        }
        field(50117; "Tecnología Impresión"; Text[100])
        {
            //>> BBT 01/07/2025. PRECINTIA
            ObsoleteState = Pending;
            //CalcFormula = lookup(Item."Tecnología Impresión" where("No." = field("No.")));
            //FieldClass = FlowField;
            //TableRelation = "Atributos basicos".Valor where(Atributo = const("Tecnología Impresión"));
            //<<    
        }
        field(50118; "Prod No."; Code[20])
        {
            Caption = 'Prod No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account"
            else if (Type = const(Item)) Item
            else if (Type = const(Resource)) Resource
            else if (Type = const("Fixed Asset")) "Fixed Asset"
            else if (Type = const("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            var
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
                temp: Code[20];
            begin
                temp := Rec."Prod No.";
                Rec.Validate("No.", Rec."Prod No.");
                Rec."Prod No." := temp;
            end;
        }
        field(50120; "Margin Amount"; Decimal)
        {
            Caption = 'Margin Amount', comment = 'ESP="Importe Margen"';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //<<                
        }
        field(50121; "Calculated Price"; Decimal)
        {
            Caption = 'Calculated Price', comment = 'ESP="Precio Calculado"';
        }
    }

    //var
    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    //SalesDisc: Record "Sales Discounts";
    //<<
    //Currency: Record Currency;
    //SalesSetup: Record "Sales & Receivables Setup";
    //SalesSetupRead: Boolean;

    procedure InitPalletNumber()
    begin
        // - 002
        if Rec."Document Type" = Rec."document type"::Order then Rec."Pallet No." := 0;
        //+ 002
    end;

    procedure TraerEan(): Text[14]
    var
        ItemIdentifier: Record "Item Identifier";
    begin
        ItemIdentifier.Reset;
        ItemIdentifier.SetCurrentkey("Item No.");
        ItemIdentifier.SetRange("Item No.", Rec."No.");
        ItemIdentifier.SetRange("Variant Code", Rec."Variant Code");
        ItemIdentifier.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        if ItemIdentifier.FindFirst then
            exit(ItemIdentifier.Code)
        else
            exit('');
    end;

    procedure ControlExported()
    begin
        if Rec."Exported to CSV" then Error('File sended');
    end;

    procedure EnviarSGA()
    var
        _CabVenta: Record "Sales Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        if _InfoCompany.SGA then begin
            if Rec."Document Type" = Rec."document type"::"Return Order" then begin
                _CabVenta.Get(Rec."Document Type", Rec."Document No.");
                if _CabVenta."Status SGA" <> _CabVenta."status sga"::" " then begin
                    _CabVenta.ModificadoSGA := true;
                    _CabVenta.Modify;
                end;
            end;
        end;
    end;

    //<<
    //procedure GetSalesSetup()
    //begin
    //    IF NOT SalesSetupRead THEN SalesSetup.GET;
    //    SalesSetupRead := TRUE;
    //end;
    //<<
}
