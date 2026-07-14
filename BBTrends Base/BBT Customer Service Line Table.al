Table 50038 "Customer Service Line"
{
    Caption = 'Lín. Servicio cliente';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Nº documento';
            TableRelation = "Customer Service Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Nº línea';
        }
        field(10; "Service Type"; Option)
        {
            Caption = 'Tipo servicio';
            OptionCaption = ' ,Devolución,Cambio,,Cupón,Abonar portes';
            OptionMembers = " ", Return, Sale, Replate, Coupon, "Credit Freight";

            trigger OnValidate()
            begin
                //IF ("Service Type"="Service Type"::Replate) AND ("Item No."<>'') AND ("Replace for Item No."='') THEN
                //  VALIDATE("Replace for Item No.","Item No.");
                Validate("Credit Amount", 0);
            end;
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Nº producto';
            TableRelation = Item;

            trigger OnValidate()
            begin
                "Variant Code":='';
                GetItem("Item No.", "Variant Code");
                if "Variant Code" = '' then begin
                    Description:=Item.Description;
                    "Description 2":=Item."Description 2";
                end
                else
                begin
                    Description:=ItemVariant.Description;
                    "Description 2":=ItemVariant."Description 2";
                end;
                if("Item No." <> '') and (Quantity = 0)then Validate(Quantity, 1);
            end;
        }
        field(12; "Reason Code"; Code[20])
        {
            Caption = 'Cód. razón';
            TableRelation = "Reason Code";

            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                if "Reason Code" <> '' then begin
                    ReasonCode.Reset;
                    ReasonCode.Get("Reason Code");
                    //IF ReasonCode.FINDFIRST THEN
                    Validate("Service Type", ReasonCode."Service Type");
                //  VALIDATE("CS - Create Sales Return Order",ReasonCode."CS - Create Sales Return Order");
                //  VALIDATE("CS - Create Sales Order",ReasonCode."CS - Create Sales Return Order");
                //  VALIDATE("CS - Create Transfer Order",ReasonCode."CS - Create Transfer Orders");
                //  VALIDATE("CS - In Deposit",ReasonCode."CS - In Deposit");
                end;
            end;
        }
        field(13; Description; Text[80])
        {
            Caption = 'Descripción';
        }
        field(14; "Description 2"; Text[80])
        {
            Caption = 'Descripción 2';
        }
        field(15; "Variant Code"; Code[10])
        {
            Caption = 'Cód. Variante';
            TableRelation = "Item Variant".Code where("Item No."=field("Item No."));

            trigger OnValidate()
            begin
                GetItem("Item No.", "Variant Code");
                if "Variant Code" = '' then begin
                    Description:=Item.Description;
                    "Description 2":=Item."Description 2";
                end
                else
                begin
                    Description:=ItemVariant.Description;
                    "Description 2":=ItemVariant."Description 2";
                end;
            end;
        }
        field(16; Quantity; Decimal)
        {
            Caption = 'Cantidad';
        }
        field(17; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Ud. Medida';
            TableRelation = "Item Unit of Measure".Code where("Item No."=field("Item No."));
        }
        field(20; "Replace for Item No."; Code[20])
        {
            Caption = 'Reemplazar producto por';
            TableRelation = Item;

            trigger OnValidate()
            begin
                "Replace for Item Variant Code":='';
                GetItem("Replace for Item No.", "Replace for Item Variant Code");
                if "Variant Code" = '' then begin
                    "Replace for Item Description":=Item.Description;
                    "Replace for Item Description 2":=Item."Description 2";
                end
                else
                begin
                    "Replace for Item Description":=ItemVariant.Description;
                    "Replace for Item Description 2":=ItemVariant."Description 2";
                end;
            end;
        }
        field(21; "Replace for Item Description"; Text[80])
        {
            Caption = 'Reemplazar con descripción';
        }
        field(22; "Replace for Item Description 2"; Text[80])
        {
            Caption = 'Reemplazar con descripción 2';
        }
        field(23; "Replace for Item Variant Code"; Code[10])
        {
            Caption = 'Reemplazar con cód. variante';
            TableRelation = "Item Variant".Code where("Item No."=field("Replace for Item No."));

            trigger OnValidate()
            begin
                GetItem("Replace for Item No.", "Replace for Item Variant Code");
                if "Replace for Item Variant Code" = '' then begin
                    "Replace for Item Description":=Item.Description;
                    "Replace for Item Description 2":=Item."Description 2";
                end
                else
                begin
                    "Replace for Item Description":=ItemVariant.Description;
                    "Replace for Item Description 2":=ItemVariant."Description 2";
                end;
            end;
        }
        field(40; "From Sales Invoice No."; Code[20])
        {
            Caption = 'De nº pedido';
            TableRelation = "Sales Invoice Header";
        }
        field(50; "New Sales Order No."; Code[20])
        {
            Caption = 'Nuevo nº pedido venta';
        }
        field(52; "New Outgoing Transfer No."; Code[10])
        {
            Caption = 'Nuevo nº pedido transferencia salida';
            TableRelation = "Transfer Header";
        }
        field(53; "New Sales Return No."; Code[20])
        {
            Caption = 'Nuevo nº devolución venta';
        }
        field(55; "New Incoming Transfer No."; Code[10])
        {
            Caption = 'Nuevo nº pedido transferencia entrada';
            TableRelation = "Transfer Header";
        }
        field(60; "CS - Create Sales Return Order"; Boolean)
        {
            Caption = 'SC - Crear devolución venta';
        }
        field(61; "CS - Create Sales Order"; Boolean)
        {
            Caption = 'SC - Crear pedido venta';
        }
        field(62; "CS - Create Transfer Order"; Boolean)
        {
            Caption = 'SC - Crear pedido transfer';
        }
        field(63; "CS - In Deposit"; Boolean)
        {
            Caption = 'SC - En depósito';

            trigger OnValidate()
            begin
                if "CS - In Deposit" then begin
                    TestField("CS - Create Sales Return Order", false);
                    TestField("CS - Create Sales Order", false);
                    TestField("Service Type", "service type"::Sale);
                end;
                GetHeader;
            end;
        }
        field(64; "Credit Amount"; Decimal)
        {
            Caption = 'Importe abono';
        }
        field(65; "No stock"; Boolean)
        {
            Caption = 'Sin entrada en stock';

            trigger OnValidate()
            begin
                if "No stock" then TestField("Service Type", "service type"::Return);
            end;
        }
    }
    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    var
        CustomerServiceLine: Record "Customer Service Line";
    begin
        CustomerServiceLine.Reset;
        CustomerServiceLine.SetRange("Document No.", "Document No.");
        if CustomerServiceLine.FindLast then;
        "Line No.":=CustomerServiceLine."Line No." + 10000;
    end;
    var Item: Record Item;
    CustomerServiceHeader: Record "Customer Service Header";
    ItemVariant: Record "Item Variant";
    local procedure GetItem(ItemNo: Code[20]; VarCode: Code[20])
    begin
        if VarCode = '' then begin
            Clear(Item);
            if ItemNo <> '' then Item.Get(ItemNo);
        end
        else
        begin
            Clear(ItemVariant);
            ItemVariant.Get(ItemNo, VarCode);
        end;
    end;
    local procedure GetHeader()
    begin
        CustomerServiceHeader.Reset;
        CustomerServiceHeader.Get("Document No.");
        CustomerServiceHeader.TestField("Store Code");
    //Store.GET(CustomerServiceHeader."Store Code");
    end;
    procedure CreateDocuments()
    var
        DummySalesHeader: Record "Sales Header";
        DummySalesLine: Record "Sales Line";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        GetHeader;
        //Store.TESTFIELD("Customer Deposit Location Code");
        case "Service Type" of "service type"::Replate: begin
            Error('Opción no habilitada');
        /*TESTFIELD("CS - Create Transfer Order");
                    // Doble ped transfer, de ida y vuelta. Esto se utiliza para la gestión de rechapazo, y requiere dejar el material en depósito
                    TESTFIELD("CS - In Deposit");
                    Store.TESTFIELD("Customer Deposit Location Code");
                    Store.TESTFIELD("Replate Location Code");
                    CreateCustomerDepositAdjmt("Item No.","Variant Code",Quantity,Store."Customer Deposit Location Code"); // Aj positivo
                    CreateTransferLine("Item No.","Variant Code",Quantity,Store."Customer Deposit Location Code",Store."Replate Location Code",CustomerServiceHeader."Sell-to Contact No.",''); // Transfer de ida
                    CreateTransferLine("Item No.","Variant Code",Quantity,Store."Replate Location Code",Store."Customer Deposit Location Code",'',CustomerServiceHeader."Sell-to Contact No."); // Transfer de vuelta*/
        end;
        "service type"::Return: // Reemplazo
 begin
            if not "No stock" then begin
                if "CS - Create Sales Return Order" then CreateSalesLine(DummySalesHeader."document type"::"Return Order".AsInteger(), DummySalesLine.Type::Item.AsInteger(), "Item No.", "Variant Code", Quantity);
                if("CS - Create Sales Order") and ("Replace for Item No." <> '')then CreateSalesLine(DummySalesHeader."document type"::Order.AsInteger(), DummySalesLine.Type::Item.AsInteger(), "Replace for Item No.", "Replace for Item Variant Code", Quantity);
            end
            else
                CreateSalesLine(DummySalesHeader."document type"::"Return Order".AsInteger(), DummySalesLine.Type::"G/L Account".AsInteger(), "Item No.", "Variant Code", Quantity);
        end;
        "service type"::Sale: begin
            TestField("CS - Create Sales Return Order", false); // Si esto tiene que ocurrir, aclararlo conjuntamente
            TestField("CS - Create Transfer Order", false); // Si esto tiene que ocurrir, aclararlo conjuntamente
            //IF "CS - Create Sales Return Order" THEN
            //  CreateSalesRetOrder(SalesOrderNo);
            //IF "CS - Create Production Order" THEN
            //  CreateProductionOrder(ProductionOrderNo);
            //IF ("CS - Create Sales Order") AND ("Replace for Item No."<>'') THEN
            TestField("CS - Create Sales Order", true);
            CreateSalesLine(DummySalesHeader."document type"::Order.AsInteger(), DummySalesLine.Type::Item.AsInteger(), "Item No.", "Variant Code", Quantity);
        end;
        "service type"::Coupon: // Pendiente de terminar
 begin
        end;
        "service type"::"Credit Freight": begin
            TestField("Credit Amount");
            SalesReceivablesSetup.Reset;
            SalesReceivablesSetup.Get;
            SalesReceivablesSetup.TestField("Customer Service Freight G/L A");
            CreateSalesLine(DummySalesHeader."document type"::"Return Order".AsInteger(), DummySalesLine.Type::"G/L Account".AsInteger(), SalesReceivablesSetup."Customer Service Freight G/L A", '', "Credit Amount");
        end;
        else
            Error('Opción no contemplada: ' + Format("Service Type") + '. Póngase en contacto con el administrador del sistema');
        end;
    end;
    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; DocType: Integer)
    begin
        GetHeader;
        CustomerServiceHeader.TestField("No.");
        CustomerServiceHeader.TestField("Sell-to Customer No.");
        CustomerServiceHeader.TestField("Sell-to Contact");
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", DocType);
        SalesHeader.SetRange("Customer Service No.", "Document No.");
        if not SalesHeader.FindSet then begin
            SalesHeader.Init;
            SalesHeader.Validate("Document Type", DocType);
            SalesHeader.Insert(true);
            SalesHeader.TestField("No.");
            SalesHeader.Validate("Customer Service No.", "Document No.");
            SalesHeader.Validate("Sell-to Customer No.", CustomerServiceHeader."Sell-to Customer No.");
            SalesHeader.Validate("Sell-to Customer No.");
            SalesHeader.Validate("Sell-to Contact No.", CustomerServiceHeader."Sell-to Contact No.");
            SalesHeader.Validate("Sell-to Contact", CustomerServiceHeader."Sell-to Contact");
            SalesHeader.Modify(true);
        end;
    end;
    local procedure CreateSalesLine(DocType: Integer; LineType: Integer; No: Code[20]; VariantCode: Code[20]; Qty: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        case DocType of SalesHeader."document type"::"Return Order".AsInteger(): if "New Sales Return No." <> '' then exit;
        SalesHeader."document type"::Order.AsInteger(): if "New Sales Order No." <> '' then exit;
        end;
        CreateSalesHeader(SalesHeader, DocType);
        if LineType = SalesLine.Type::"G/L Account".AsInteger()then GetGLAccount(No, SalesHeader."Gen. Bus. Posting Group", SalesHeader."Document Type".AsInteger());
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast then;
        LineNo:=SalesLine."Line No." + 10000;
        SalesLine.Init;
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", LineNo);
        SalesLine.Insert(true);
        SalesLine.Validate(Type, LineType);
        SalesLine.Validate("No.", No);
        case SalesLine.Type of SalesLine.Type::Item: begin
            SalesLine.Validate("Variant Code", VariantCode);
            //SalesLine.VALIDATE("Location Code",LocationCode);
            SalesLine.Validate(Quantity, Qty);
        end;
        SalesLine.Type::"G/L Account": begin
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", Qty);
        end;
        end;
        SalesLine."Customer Service No.":="Document No.";
        SalesLine."Customer Service Line No.":="Line No.";
        SalesLine.Modify(true);
    end;
    local procedure CreateTransferHeader(var TransferHeader: Record "Transfer Header"; TransferFromCode: Code[20]; TransferToCode: Code[20]; TransferFromContact: Text; TransferToContact: Text)
    begin
        TransferHeader.Reset;
        TransferHeader.SetRange("Customer Service No.", "Document No.");
        TransferHeader.SetRange("Transfer-from Code", TransferFromCode);
        TransferHeader.SetRange("Transfer-to Code", TransferToCode);
        if not TransferHeader.FindSet then begin
            TransferHeader.Init;
            TransferHeader.Insert(true);
            TransferHeader.TestField("No.");
            TransferHeader.Validate("Customer Service No.", "Document No.");
            TransferHeader.Validate("Transfer-from Code", TransferFromCode);
            TransferHeader.Validate("Transfer-to Code", TransferToCode);
            TransferHeader."Transfer-from Contact":=TransferFromContact;
            TransferHeader."Transfer-to Contact":=TransferToContact;
            TransferHeader.Modify(true);
        end;
    end;
    local procedure CreateTransferLine(No: Code[20]; VariantCode: Code[20]; Qty: Decimal; TransferFromCode: Code[20]; TransferToCode: Code[20]; TransferFromContact: Text; TransferToContact: Text)
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Item: Record Item;
        LineNo: Integer;
    begin
        CreateTransferHeader(TransferHeader, TransferFromCode, TransferToCode, TransferFromContact, TransferToContact);
        TransferHeader.TestField("No.");
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast then;
        LineNo:=TransferLine."Line No." + 10000;
        TransferLine.Init;
        TransferLine.Validate("Document No.", TransferHeader."No.");
        TransferLine.Validate("Line No.", LineNo);
        TransferLine.Insert(true);
        TransferLine.Validate("Item No.", No);
        TransferLine.Validate("Variant Code", VariantCode);
        TransferLine.Validate(Quantity, Qty);
        TransferLine.Modify(true);
    end;
    procedure CreateCustomerDepositAdjmt(No: Code[20]; VariantCode: Code[20]; Qty: Decimal; LocationCode: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        LineNo: Integer;
    begin
        Error('Opción deshabilitada');
    /*GetHeader;
        IF Qty=0 THEN
          ERROR('La cantidad no puede ser 0');
        
        //Store.TESTFIELD("Deposit Item Journal Batch Nam");
        //Store.TESTFIELD("Deposit Item Journal Tem. Name");
        
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name",Store."Deposit Item Journal Tem. Name");
        ItemJournalLine.SETRANGE("Journal Batch Name",Store."Deposit Item Journal Batch Nam");
        IF ItemJournalLine.FINDLAST THEN;
        
        LineNo := ItemJournalLine."Line No."+10000;
        
        ItemJournalLine.INIT;
        ItemJournalLine.VALIDATE("Journal Template Name",Store."Deposit Item Journal Tem. Name");
        ItemJournalLine.VALIDATE("Journal Batch Name",Store."Deposit Item Journal Batch Nam");
        ItemJournalLine.VALIDATE("Line No.",LineNo);
        ItemJournalLine.INSERT(TRUE);
        ItemJournalLine.VALIDATE("Document No.","Document No.");
        ItemJournalLine.VALIDATE("Posting Date",TODAY);
        
        IF Qty>0 THEN
          ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::"Positive Adjmt.")
        ELSE
          ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::"Negative Adjmt.");
        ItemJournalLine.VALIDATE("Item No.",No);
        ItemJournalLine.VALIDATE("Variant Code");
        ItemJournalLine.VALIDATE(Quantity,ABS(Qty));
        ItemJournalLine.VALIDATE("Location Code",LocationCode);
        ItemJournalLine.Description := Description;
        ItemJournalLine.VALIDATE("Reason Code","Reason Code");
        ItemJournalLine.MODIFY(TRUE);
        */
    end;
    procedure CalcQtyInDeposit()QtyInDeposit: Decimal var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Error('Opción deshabilitada');
    /*
        IF "Service Type"<>"Service Type"::Sale THEN
          QtyInDeposit := 0
        ELSE BEGIN
          GetHeaderAndStore;
          ItemLedgerEntry.RESET;
          ItemLedgerEntry.SETRANGE("Item No.","Item No.");
          ItemLedgerEntry.SETRANGE("Location Code",Store."Customer Deposit Location Code");
          ItemLedgerEntry.SETRANGE("Document No.","Document No.");
          ItemLedgerEntry.CALCSUMS(Quantity);
          QtyInDeposit := ItemLedgerEntry.Quantity;
        END;
        */
    end;
    local procedure GetGLAccount(var No: Code[20]; GenBusPostingGroup: Code[20]; DocType: Integer)
    var
        Item: Record Item;
        GeneralPostingSetup: Record "General Posting Setup";
        DummySalesHeader: Record "Sales Header";
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Reset;
        if GLAccount.Get(No)then exit;
        Item.Reset;
        Item.Get(No);
        Item.TestField("Gen. Prod. Posting Group");
        if GenBusPostingGroup = '' then Error('El grupo registro negocio debe estar informado');
        GeneralPostingSetup.Reset;
        GeneralPostingSetup.Get(GenBusPostingGroup, Item."Gen. Prod. Posting Group");
        DummySalesHeader."Document Type":=Enum::"Sales Document Type".FromInteger(DocType);
        if DummySalesHeader."Document Type" in[DummySalesHeader."document type"::"Credit Memo", DummySalesHeader."document type"::"Return Order"]then begin
            if GeneralPostingSetup."Sales Credit Memo Account" = '' then No:=GeneralPostingSetup."Sales Account"
            else
                No:=GeneralPostingSetup."Sales Credit Memo Account";
        end
        else
            No:=GeneralPostingSetup."Sales Account";
    end;
}
