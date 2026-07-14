TableExtension 50107 "BBT Customer" extends Customer
{
    fields
    {
        /* BBT 01/07/2025. Se admiten todos los caracteres >>100<<
        modify(Name)
        {
            trigger OnBeforeValidate()
            var
                Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Nombre" no puede superar 50 caracteres."';
            begin
                if StrLen(Rec.Name) > 50 then Error(Text001Err);
            end;
        }
        modify(Address)
        {
            trigger OnBeforeValidate()
            var
                Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Dirección" no puede superar 50 caracteres."';
            begin
                if StrLen(Rec.Address) > 50 then Error(Text001Err);
            end;
        }
        modify("Address 2")
        {
            trigger OnBeforeValidate()
            var
                Text001Err: Label 'This field can not have more than 50 characters.', Comment = 'ESP="El campo "Dirección 2" no puede superar 50 caracteres."';
            begin
                if StrLen(Rec."Address 2") > 50 then Error(Text001Err);
            end;
        }
        */
        field(50000; "Purchase Group"; Code[10])
        {
            //>> BBT. SMG Extension. 
            ObsoleteState = Pending;
            //<<
            Caption = 'Purchase Group', Comment = 'ESP="Grupo Compra"';
            Description = '002';
            //TableRelation = "Purchase Group";
        }
        field(50001; Abbreviation; Text[30])
        {
            Caption = 'Abbreviation';
            Description = '001';
        }
        field(50002; "Invoice EDI"; Text[35])
        {
            Caption = 'Id. EDI Factura';
        }
        field(50003; "EDI ID"; Text[35])
        {
            Caption = 'Id. EDI';
            Description = 'EDI';
        }
        field(50004; "No EDI"; Boolean)
        {
            Description = 'EDI';
        }
        field(50005; "Risk Rating"; Option)
        {
            Caption = 'Risk Rating';
            Description = '001';
            OptionCaption = ' ,OK,NO OK,Bankruptcy,In Study,No Risk,Commercial Blockade,Reduction to zero,Risk Rating,Unpaid';
            OptionMembers = " ",OK,"NO OK",Concurso,"En estudio","Sin riesgo","Bloqueo comercial","Reduccion a cero","Calif. riesgo",Impagado;
        }
        field(50006; "Active CyC"; Boolean)
        {
            Caption = 'Active CyC';
            Description = '001';
        }
        field(50007; "CyC Policy"; Text[30])
        {
            Caption = 'CyC Policy';
            Description = '001';
        }
        field(50008; Reference; Text[20])
        {
            Caption = 'Reference';
            Description = '001';
        }
        field(50009; "Valued Shipment"; Boolean)
        {
            Caption = 'Valued Shipment', Comment = 'ESP="Mostrar albarán valorado"';
            Description = '001';
        }
        field(50010; "Customer Type"; Code[10])
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
            Description = '003';
            //TableRelation = "Customer Classification".Code where(Type = const("Customer Type"));
        }
        field(50011; Platform; Code[10])
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = 'Platform', Comment = 'ESP="Plataforma"';
            Description = '003';
            //TableRelation = "Customer Classification".Code where(Type = const(Platform));
        }
        field(50012; Credit; Decimal)
        {
            Caption = 'Credit';
            Description = '001';
        }
        field(50013; "National Group"; Code[10])
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = 'National Group', Comment = 'ESP="Grupo Nacional"';
            Description = '003';
            //TableRelation = "Customer Classification".Code where(Type = const("National Group"));
        }
        field(50014; "Collection Bank Account"; Code[20])
        {
            Caption = 'Collection Bank Account', Comment = 'ESP="Cuenta bancaria de cobro"';
            Description = '004';
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
            end;
        }
        field(50015; "Customer Pool"; Option)
        {
            //>>
            ObsoleteState = Pending;
            //<<
            Caption = 'Customer Pool';
            Description = 'SGA';
            OptionMembers = " ","Pool-1","Pool-2","Pool-3","Pool-4","Pool-5","Pool-6","Pool-7","Pool-8","Pool-9";
        }
        field(50016; "Cód. Departamento"; Code[20])
        {
            Description = 'EDI';
        }
        field(50017; "Cód. Sucursal"; Code[20])
        {
            Description = 'EDI';
        }
        field(50018; "Send EDI Documents"; Option)
        {
            Caption = 'Enviar documentos EDI';
            OptionCaption = 'Todos,Albaranes,Facturas';
            OptionMembers = All,Shipment,Invoice;
        }
        /*
        field(50019;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where ("Customer No."=field("No."));
        }
        */
        field(50021; "Condiciones fuera fact. % COLS"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            MaxValue = 100;
            MinValue = 0;
        }
        field(50022; "Transporte ventas %"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            MaxValue = 100;
            MinValue = 0;
        }
        field(50023; "DEVS  FIN %"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            MaxValue = 100;
            MinValue = 0;
        }
        field(50024; "Comission %"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = '% Comision';
        }
        field(50025; "PL VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(50026; "VAT PL"; Boolean)
        { }
        field(50027; "Contract No"; Text[30])
        {
            Caption = 'No contrato';
        }
        field(50028; "Cr Memo EDI"; Text[35])
        {
            Caption = 'Id. EDI Abono';
        }
        field(50029; "Dir Code"; Boolean)
        {
            ObsoleteState = Pending;                      //>> BBT. Precintia
            Caption = 'Dir Code';
        }
        field(50030; "Billing Period"; Option)
        {
            Caption = 'Billing Period';
            OptionCaption = ' ,Daily,Weekly,Biweekly,Monthly';
            OptionMembers = " ",Diario,Semanal,Quincenal,Mensual;
        }
        field(50031; "CRM ID"; Code[40])
        {
            ObsoleteState = Pending;         // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50032; "Últ. Actualización"; DateTime)
        {
            ObsoleteState = Pending;         // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50040; "Request delivery appointment"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request delivery appointment', comment = 'ESP="Pedir cita entrega"';
        }
        field(50041; "BBT Do Not Send Inv. To SII"; Boolean)
        {
            Caption = 'Do Not Send Inv. To SII', comment = 'ESP="No enviar facturas al SII"';
            DataClassification = ToBeClassified;
        }
        field(50042; "Rappel"; Boolean)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = 'Rappel', comment = 'ESP="Rappel"';
            CalcFormula = Exist("Cond APos" where(Code = Field("no.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(50043; "BBT PL Currency Exchange"; Boolean)
        {
            Caption = 'PL Currency Exchange', Comment = 'ESP="Cambio divisa PL"';
        }
        field(50044; "BBT EDI Invoice Sending Delay"; DateFormula)
        {
            Caption = 'EDI Invoice Sending Delay', Comment = 'ESP="Retraso envío factura EDI"';
        }
        field(50045; "BBT APOS Conditions"; Boolean)
        {
            Caption = 'APOS Conditions', Comment = 'ESP="Condiciones APOS"';
        }
        field(50046; "No Apply RAEE"; Boolean)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extension.
            Caption = 'NO Apply RAEE', Comment = 'ESP="No aplica RAEE"';
            Enabled = true;
            InitValue = false;
        }
        field(50099; "EDI Directory"; Code[20])
        {
            Caption = 'EDI Directory', Comment = 'ESP="Directorio EDI"';
            TableRelation = "EDI Directory Assignament";
        }
        field(50100; "Invoice Type"; Enum "SII Sales Invoice Type")
        {
            Caption = 'Invoice Type', Comment = 'ESP="Tipo de factura"';
        }
        field(50110; "Logistics conditions"; Text[250])
        {
            Caption = 'Logistics conditions', comment = 'ESP="Condiciones logísticas"';
        }
        field(51124; "Condiciones F.F. % COLs 2024"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extens
            Caption = 'Conditions F.F. % COLs 2024', Comment = 'ESP ="Cond. F.F. % COLs 2024"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51125; "Condiciones F.F. % APOs 2024"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extens
            Caption = 'Conditions F.F. % APOs 2024', Comment = 'ESP="Cond. F.F. % APOs 2024"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51173; "Condiciones F.F. % COLs 2025"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extens
            Caption = 'Conditions F.F. % COLs 2025', Comment = 'ESP ="Cond. F.F. % COLs 2025"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51174; "Condiciones F.F. % APOs 2025"; Decimal)
        {
            ObsoleteState = Pending;                      //>> BBT. SMG Extens
            Caption = 'Conditions F.F. % APOs 2025', Comment = 'ESP="Cond. F.F. % APOs 2025"';
            MaxValue = 100;
            MinValue = 0;
        }
    }
    trigger OnInsert()
    begin
        Rec."No EDI" := true;
    end;
}
