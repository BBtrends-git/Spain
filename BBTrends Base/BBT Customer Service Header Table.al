Table 50037 "Customer Service Header"
{
    Caption = 'Customer Service Header', comment = 'ESP="Cab. Servicio cliente"';
    DrillDownPageID = "Customer Service List";
    LookupPageID = "Customer Service List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', comment = 'ESP="Nº"';
        }
        field(2; Status; Option)
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            OptionCaption = 'Started,In progress,Finished', comment = 'ESP="Iniciado,En proceso,Finalizado"';
            OptionMembers = Started,"In progress",Finished;
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID', comment = 'ESP="Id. usuario"';
            TableRelation = User."User Name";
        }
        field(4; "Service Type"; Option)
        {
            Caption = 'Service Type', comment = 'ESP="Resolución"';
            OptionCaption = ' ,Return,Sale,Replate,Coupon,Credit Freight', comment = 'ESP=" ,Devolución,Cambio,,Cupón,Abonar portes"';
            OptionMembers = " ",Return,Sale,Replate,Coupon,"Credit Freight";

            trigger OnValidate()
            var
                CustomerServiceLine: Record "Customer Service Line";
            begin
                CustomerServiceLine.Reset;
                CustomerServiceLine.SetRange("Document No.", "No.");
                if CustomerServiceLine.FindSet then
                    repeat
                        CustomerServiceLine.Validate("Service Type", "Service Type");
                        CustomerServiceLine.Modify;
                    until CustomerServiceLine.Next = 0;
            end;
        }
        field(5; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code', comment = 'ESP="Cód. causa"';
            TableRelation = "Reason Code";

            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
                CustomerServiceLine: Record "Customer Service Line";
            begin
                CustomerServiceLine.Reset;
                CustomerServiceLine.SetRange("Document No.", "No.");
                if CustomerServiceLine.FindSet then
                    repeat
                        CustomerServiceLine.Validate("Reason Code", "Reason Code");
                        CustomerServiceLine.Modify;
                    until CustomerServiceLine.Next = 0;
                if "Reason Code" <> '' then begin
                    ReasonCode.Reset;
                    ReasonCode.Get("Reason Code");
                    Validate("Service Type", ReasonCode."Service Type");
                end;
            end;
        }
        field(10; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', comment = 'ESP="Nº cliente"';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                GetCustInfo;
            end;
        }
        field(11; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name', comment = 'ESP="Nombre cliente"';
        }
        field(12; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2', comment = 'ESP="Nombre 2 cliente"';
        }
        field(13; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address', comment = 'ESP="Dirección"';
        }
        field(14; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2', comment = 'ESP="Dirección 2"';
        }
        field(15; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City', comment = 'ESP="Ciudad"';
        }
        field(16; "Sell-to Contact"; Text[50])
        {
            Caption = 'Sell-to Contact', comment = 'ESP="Contacto"';

            trigger OnValidate()
            begin
                GetContactInfo
            end;
        }
        field(17; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code', comment = 'ESP="Código postal"';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(18; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County', comment = 'ESP="Provincia"';
        }
        field(19; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code', comment = 'ESP="Cód. país/región"';
            TableRelation = "Country/Region";
        }
        field(20; "Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.', comment = 'ESP="Nº teléfono"';
        }
        field(21; "Sell-to E-Mail"; Text[80])
        {
            Caption = 'Sell-to E-Mail', comment = 'ESP="Correo-e"';
            ExtendedDatatype = EMail;
        }
        field(22; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.', comment = 'ESP="Nº contacto"';
            TableRelation = Contact;

            trigger OnValidate()
            begin
                GetContactInfo;
            end;
        }
        field(23; "Sell-to VAT Registration No."; Text[20])
        {
            Caption = 'Sell-to VAT Registration No.', comment = 'ESP="CIF/NIF"';

            trigger OnValidate()
            var
                Customer: Record Customer;
                CustomerList: Page "Customer List";
                Error001: label 'Customer with VAT Registration No. %1 not found.', comment = 'ESP="No se ha encontrado cliente con el CIF/NIF %1"';
                Error002: label 'You have to choose Customer to continue', comment = 'ESP="Debe seleccionar un cliente para continuar"';
            begin
                if "Sell-to VAT Registration No." = '' then exit;
                if "Sell-to Customer No." = '' then begin
                    Customer.Reset;
                    Customer.SetRange("VAT Registration No.", "Sell-to VAT Registration No.");
                    if not Customer.FindSet then
                        Error(Error001, "Sell-to VAT Registration No.")
                    else if Customer.Count > 1 then begin
                        Clear(CustomerList);
                        CustomerList.SetTableview(Customer);
                        if CustomerList.RunModal = Action::LookupOK then
                            Validate("Sell-to Customer No.", Customer."No.")
                        else
                            Error(Error002);
                    end
                    else
                        Validate("Sell-to Customer No.", Customer."No.");
                end;
            end;
        }
        field(24; "Sell-to Contact Phone No."; Code[30])
        {
            Caption = 'Sell-to Contact Phone No.', comment = 'ESP="Nº telf. contacto"';
        }
        field(25; "Sell-to Contact E-Mail"; Text[80])
        {
            Caption = 'Sell-to Contact E-Mail', comment = 'ESP="Correo-e contacto"';
            ExtendedDatatype = EMail;
        }
        field(30; "Service Datetime"; DateTime)
        {
            Caption = 'Service Datetime', comment = 'ESP="Fecha/hora"';
        }
        field(31; "Communication Method"; Option)
        {
            Caption = 'Vía llegada';
            Description = '//TC Si no es muy fija la lista, considerar hacerlo con una tabla relacionada';
            OptionMembers = Email,Transporte,"Teléfono",Prestashop;
        }
        field(32; "Store Code"; Code[20])
        {
            Caption = 'Cód. tienda';
        }
        field(33; "End Datetime"; DateTime)
        {
            Caption = 'Fecha/hora Fin';
        }
        field(34; Comment; Blob)
        {
            Caption = 'Comentarios';
        }
        field(35; "External Document No."; Code[35])
        {
            Caption = 'No. documento externo';
        }
        field(100; Posted; Boolean)
        {
            Caption = 'Registrado';
            Editable = false;

            trigger OnValidate()
            var
                CustomerServiceLine: Record "Customer Service Line";
            begin
                if Posted then begin
                    CustomerServiceLine.Reset;
                    CustomerServiceLine.SetRange("Document No.", "No.");
                    CustomerServiceLine.SetRange("Service Type", CustomerServiceLine."service type"::Sale);
                    if CustomerServiceLine.FindSet then
                        Validate(Status, Status::"In progress")
                    else
                        Validate(Status, Status::Finished);
                end;
            end;
        }
        field(101; "From NAV Doc. No."; Code[20])
        {
            Caption = 'De No. documento NAV';
            TableRelation = if ("From NAV Doc Type" = const(Order)) "Sales Header"."No." where("Document Type" = const(Order))
            else if ("From NAV Doc Type" = const("Posted Invoice")) "Sales Invoice Header"."No.";

            trigger OnValidate()
            begin
                GetFromNAVDocLines;
            end;
        }
        field(102; "From NAV Doc Type"; Option)
        {
            Caption = 'De tipo documento';
            OptionCaption = 'Pedido,Factura registrada';
            OptionMembers = "Order","Posted Invoice";

            trigger OnValidate()
            begin
                Validate("From NAV Doc. No.", '');
            end;
        }
        field(103; "Shipment No."; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Header"."No." where("Order No." = field("From NAV Doc. No.")));
            Caption = 'Shipment No.';
            FieldClass = FlowField;
        }
        field(104; "Warehose Ship No."; Code[20])
        {
            CalcFormula = lookup("Posted Whse. Shipment Line"."Whse. Shipment No." where("Posted Source Document" = const("Posted Shipment"), "Source No." = field("From NAV Doc. No.")));
            Caption = 'Warehouse Ship No.';
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Package Tracking No."; Text[50])
        {
            CalcFormula = lookup("Sales Shipment Header"."Package Tracking No." where("Order No." = field("From NAV Doc. No.")));
            Caption = 'Package Tracking No.';
            FieldClass = FlowField;

            //>> BBT 01/07/2025. No se usa PRESTA
            /*
            trigger OnValidate()
            var
                PSHOPOrderHeader: Record "PSHOP - Order Header";
            begin
            end;
            */
            //<<
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    var
        CustomerServiceLine: Record "Customer Service Line";
    begin
        CustomerServiceLine.Reset;
        CustomerServiceLine.SetRange("Document No.", "No.");
        if CustomerServiceLine.FindSet then CustomerServiceLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        //>> Obsoleto V27
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

    begin
        if IsTemporary then exit;
        if "No." = '' then begin
            SalesReceivablesSetup.Reset;
            SalesReceivablesSetup.Get;
            SalesReceivablesSetup.TestField("Customer Service Nos.");
            //>> V27
            //"No." := NoSeriesManagement.GetNextNo(SalesReceivablesSetup."Customer Service Nos.", Today, true);
            "No." := NoSeries.GetNextNo(SalesReceivablesSetup."Customer Service Nos.", Today);
            //<<
        end;
        "Service Datetime" := CurrentDatetime;
        "User ID" := UserId;
        //SetStore;
        //SetDefaultCustomer;
    end;

    var
        Store: Record "Sales Shipment Palet";
        SthToPost: Boolean;

    local procedure GetStore()
    begin
        TestField("Store Code");
        Store.Get("Store Code");
    end;

    local procedure GetCustInfo()
    var
        Customer: Record Customer;
    begin
        Clear(Customer);
        if "Sell-to Customer No." <> '' then Customer.Get("Sell-to Customer No.");
        "Sell-to Address" := Customer.Address;
        "Sell-to Address 2" := Customer."Address 2";
        "Sell-to City" := Customer.City;
        "Sell-to Contact" := Customer.Contact;
        //"Sell-to Contact No." := ;
        "Sell-to Country/Region Code" := Customer."Country/Region Code";
        "Sell-to County" := Customer.County;
        "Sell-to Customer Name" := Customer.Name;
        "Sell-to Customer Name 2" := Customer."Name 2";
        "Sell-to E-Mail" := Customer."E-Mail";
        "Sell-to Phone No." := Customer."Phone No.";
        "Sell-to Post Code" := Customer."Post Code";
        "Sell-to VAT Registration No." := Customer."VAT Registration No.";
    end;

    local procedure GetContactInfo()
    var
        Contact: Record Contact;
    begin
        Clear(Contact);
        if "Sell-to Contact No." <> '' then Contact.Get("Sell-to Contact No.");
        "Sell-to Contact" := Contact.Name;
        "Sell-to Contact E-Mail" := Contact."E-Mail";
        "Sell-to Contact Phone No." := Contact."Phone No.";
    end;

    procedure CreateDocuments()
    var
        CustomerServiceLine: Record "Customer Service Line";
    begin
        CustomerServiceLine.Reset;
        CustomerServiceLine.SetRange("Document No.", "No.");
        if not CustomerServiceLine.FindSet then Error('No existen líneas para este servicio');
        repeat
            CustomerServiceLine.CreateDocuments;
        until CustomerServiceLine.Next = 0;
    end;

    procedure PostService()
    begin
        if not Confirm('¿Desea registrar el servicio ' + "No." + '?') then Error('');
        CreateDocuments;
        PostItemReception;
        PostItemShipment;
        Validate(Posted, true);
        Modify;
    end;

    local procedure PostItemReception()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
        InvoiceFlag: Boolean;
        ReceiveFlag: Boolean;
    begin
        GetStore;
        // Devolución de venta o entrada en depósito para rechapar
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."document type"::"Return Order");
        //SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        SalesLine.SetRange("Customer Service No.", "No.");
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        if SalesLine.FindSet then begin
            SalesHeader.Reset;
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            if SalesHeader.Status <> SalesHeader.Status::Open then ReleaseSalesDocument.PerformManualReopen(SalesHeader);
            ReceiveFlag := false;
            InvoiceFlag := false;
            SalesLine.Reset;
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            //SalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::Item);
            SalesLine.SetFilter("Outstanding Quantity", '<>0');
            if SalesLine.FindSet then
                repeat
                    case SalesLine.Type of
                        SalesLine.Type::Item:
                            ReceiveFlag := true;
                        SalesLine.Type::"G/L Account":
                            begin
                                ReceiveFlag := true;
                                InvoiceFlag := true;
                            end;
                    end;
                    SalesLine.Validate("Return Qty. to Receive", SalesLine."Outstanding Quantity");
                    if SalesLine.Type = SalesLine.Type::Item then
                        SalesLine.Validate("Qty. to Invoice", 0)
                    else
                        SalesLine.Validate("Qty. to Invoice", SalesLine.Quantity - SalesLine."Quantity Invoiced");
                until SalesLine.Next = 0;
            SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
            SalesHeader.Receive := ReceiveFlag;
            SalesHeader.Invoice := InvoiceFlag;
            SalesPost.Run(SalesHeader); // Pendiente verificar que funcione ok
        end;
        PostItemJournalLines(0);
    end;

    local procedure PostItemShipment()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
    begin
        GetStore;
        // Entrega de material por venta o material que estaba en depósito
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("Customer Service No.", "No.");
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        if SalesLine.FindSet then begin
            SalesHeader.Reset;
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            if SalesHeader.Status <> SalesHeader.Status::Open then ReleaseSalesDocument.PerformManualReopen(SalesHeader);
            SalesLine.Reset;
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            //SalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::Item);
            SalesLine.SetFilter("Outstanding Quantity", '<>0');
            if SalesLine.FindSet then
                repeat
                    if SalesLine.Type = SalesLine.Type::Item then
                        SalesLine.Validate("Qty. to Ship", SalesLine."Outstanding Quantity")
                    else
                        SalesLine.Validate("Qty. to Ship", 0);
                until SalesLine.Next = 0;
            SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
            SalesHeader.Ship := true;
            SalesHeader.Invoice := false;
            SalesPost.Run(SalesHeader); // Pendiente verificar que funcione ok
        end;
        //PostItemJournalLines(1);
    end;

    local procedure PostItemJournalLines(WhichLines: Option Positive,Negative)
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        Error('Opción deshabilitada');
        /*
            Store.TESTFIELD("Deposit Item Journal Batch Nam");
            Store.TESTFIELD("Deposit Item Journal Tem. Name");

            ItemJournalLine.RESET;
            ItemJournalLine.SETRANGE("Journal Template Name",Store."Deposit Item Journal Tem. Name");
            ItemJournalLine.SETRANGE("Journal Batch Name",Store."Deposit Item Journal Batch Nam");
            ItemJournalLine.SETRANGE("Document No.","No.");

            CASE WhichLines OF
              WhichLines::Positive:
                ItemJournalLine.SETRANGE("Entry Type",ItemJournalLine."Entry Type"::"Positive Adjmt.");
              WhichLines::Negative:
                ItemJournalLine.SETRANGE("Entry Type",ItemJournalLine."Entry Type"::"Negative Adjmt.");
              ELSE
                ERROR('Opción no contemplada');
            END;

            IF ItemJournalLine.FINDSET THEN
              ItemJnlPostBatch.RUN(ItemJournalLine);
            */
    end;

    local procedure SetStore()
    var
        UserSetup: Record "User Setup";
    begin
        Error('Opción deshabilitada');
        /*
            UserSetup.RESET;
            IF UserSetup.GET(USERID) AND (UserSetup."Store ID"<>'') THEN
              VALIDATE("Store Code",UserSetup."Store ID");
            */
    end;

    local procedure SetDefaultCustomer()
    begin
        Error('Opción deshabilitada');
        /*
            IF "Store Code"<>'' THEN BEGIN
              Store.GET("Store Code");
              IF Store."Default Customer"<>'' THEN
                VALIDATE("Sell-to Customer No.",Store."Default Customer");
            END;
            */
    end;

    procedure PostReturnReplatedItems()
    var
        CustomerServiceLine: Record "Customer Service Line";
    begin
        Error('Opción deshabilitada');
        /*
            GetStore;
            SthToPost := FALSE;

            CustomerServiceLine.RESET;
            CustomerServiceLine.SETRANGE("Document No.","No.");
            CustomerServiceLine.SETRANGE("Service Type",CustomerServiceLine."Service Type"::Sale);
            CustomerServiceLine.FINDSET;
            REPEAT
              IF CustomerServiceLine.CalcQtyInDeposit>0 THEN BEGIN
                CustomerServiceLine.CreateCustomerDepositAdjmt(CustomerServiceLine."Item No.",CustomerServiceLine."Variant Code",-CustomerServiceLine.Quantity,Store."Customer Deposit Location Code");
                SthToPost := TRUE;
              END;
            UNTIL CustomerServiceLine.NEXT=0;

            IF SthToPost THEN
              PostItemJournalLines(1);

            VALIDATE(Status,Status::Finished);
            MODIFY;
            */
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetCustomerServiceNo("No.");
        NavigateForm.Run;
    end;

    procedure SetComment(CommentTxt: Text)
    var
        OStream: OutStream;
    begin
        Clear(Comment);
        Comment.CreateOutstream(OStream);
        OStream.WriteText(CommentTxt);
    end;

    procedure GetComment() CommentTxt: Text
    var
        IStream: InStream;
        DummyTxt: Text;
    begin
        CommentTxt := '';
        CalcFields(Comment);
        Comment.CreateInstream(IStream);
        while not IStream.eos do begin
            IStream.ReadText(DummyTxt);
            CommentTxt += DummyTxt;
        end;
    end;

    local procedure GetFromNAVDocLines()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if "From NAV Doc. No." = '' then exit;
        case "From NAV Doc Type" of
            "from nav doc type"::Order:
                begin
                    SalesHeader.Reset;
                    if SalesHeader.Get(SalesHeader."document type"::Order, "From NAV Doc. No.") then begin
                        Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                        Validate("Sell-to Contact No.", SalesHeader."Sell-to Contact No.");
                        "Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                        "Sell-to Customer Name 2" := SalesHeader."Sell-to Customer Name 2";
                        "Sell-to Address" := SalesHeader."Sell-to Address";
                        "Sell-to Address 2" := SalesHeader."Sell-to Address 2";
                        "Sell-to City" := SalesHeader."Sell-to City";
                        "Sell-to Contact" := SalesHeader."Sell-to Contact";
                        "Sell-to Post Code" := SalesHeader."Sell-to Post Code";
                        "Sell-to County" := SalesHeader."Sell-to County";
                        "Sell-to Country/Region Code" := SalesHeader."Sell-to Country/Region Code";
                        //"Sell-to Phone No." := '';
                        //"Sell-to E-Mail" := '';
                        //"Sell-to VAT Registration No." := '';
                        //"Sell-to Contact Phone No." := '';
                        //"Sell-to Contact E-Mail" := '';
                        Modify;
                    end;
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
                    SalesLine.SetRange("Document No.", "From NAV Doc. No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter(Quantity, '<>0');
                    if SalesLine.FindSet then
                        repeat
                            CreateCustomerServiceLine(SalesLine."No.", SalesLine.Description, SalesLine."Description 2", SalesLine."Variant Code", SalesLine.Quantity, SalesLine."Unit of Measure Code");
                        until SalesLine.Next = 0;
                end;
            "from nav doc type"::"Posted Invoice":
                begin
                    SalesInvoiceHeader.Reset;
                    if SalesInvoiceHeader.Get("From NAV Doc. No.") then begin
                        Validate("Sell-to Customer No.", SalesInvoiceHeader."Sell-to Customer No.");
                        Validate("Sell-to Contact No.", SalesInvoiceHeader."Sell-to Contact No.");
                        "Sell-to Customer Name" := SalesInvoiceHeader."Sell-to Customer Name";
                        "Sell-to Customer Name 2" := SalesInvoiceHeader."Sell-to Customer Name 2";
                        "Sell-to Address" := SalesInvoiceHeader."Sell-to Address";
                        "Sell-to Address 2" := SalesInvoiceHeader."Sell-to Address 2";
                        "Sell-to City" := SalesInvoiceHeader."Sell-to City";
                        "Sell-to Contact" := SalesInvoiceHeader."Sell-to Contact";
                        "Sell-to Post Code" := SalesInvoiceHeader."Sell-to Post Code";
                        "Sell-to County" := SalesInvoiceHeader."Sell-to County";
                        "Sell-to Country/Region Code" := SalesInvoiceHeader."Sell-to Country/Region Code";
                        //"Sell-to Phone No." := '';
                        //"Sell-to E-Mail" := '';
                        "Sell-to Contact No." := SalesInvoiceHeader."Sell-to Contact No.";
                        "Sell-to VAT Registration No." := SalesInvoiceHeader."VAT Registration No.";
                        //"Sell-to Contact Phone No." := '';
                        //"Sell-to Contact E-Mail" := '';
                        Modify;
                    end;
                    SalesInvoiceLine.Reset;
                    SalesInvoiceLine.SetRange("Document No.", "From NAV Doc. No.");
                    SalesInvoiceLine.SetRange(Type, SalesLine.Type::Item);
                    SalesInvoiceLine.SetFilter(Quantity, '<>0');
                    if SalesInvoiceLine.FindSet then
                        repeat
                            CreateCustomerServiceLine(SalesInvoiceLine."No.", SalesInvoiceLine.Description, SalesInvoiceLine."Description 2", SalesInvoiceLine."Variant Code", SalesInvoiceLine.Quantity, SalesInvoiceLine."Unit of Measure Code");
                        until SalesLine.Next = 0;
                end;
            else
                Error('Tipo de documento no soportado: ' + Format("From NAV Doc Type"));
        end;
    end;

    local procedure CreateCustomerServiceLine(ItemNo: Code[20]; Desc: Text; Desc2: Text; VariantCode: Code[20]; Qty: Decimal; UoMCode: Code[20])
    var
        CustomerServiceLine: Record "Customer Service Line";
        LineNo: Integer;
    begin
        CustomerServiceLine.Reset;
        CustomerServiceLine.SetRange("Document No.", "No.");
        if CustomerServiceLine.FindLast then;
        LineNo := CustomerServiceLine."Line No." + 10000;
        CustomerServiceLine.Validate("Document No.", "No.");
        CustomerServiceLine.Validate("Line No.", LineNo);
        CustomerServiceLine.Validate("Item No.", ItemNo);
        CustomerServiceLine.Description := Desc;
        CustomerServiceLine."Description 2" := Desc2;
        CustomerServiceLine.Validate("Variant Code", VariantCode);
        CustomerServiceLine.Validate(Quantity, Qty);
        CustomerServiceLine.Validate("Unit of Measure Code", UoMCode);
        CustomerServiceLine.Insert;
    end;
}
