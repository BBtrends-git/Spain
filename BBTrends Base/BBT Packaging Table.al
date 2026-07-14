Table 50019 "Packaging"
{
    Caption = 'Embalaje';
    DrillDownPageID = 50037;
    LookupPageID = 50037;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'Nº';
        }
        field(2; "Creation Date"; Date)
        {
            Caption = 'Fecha creación';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Fecha registro';
            Editable = false;
        }
        field(4; "Location Code"; Code[10])
        {
            Caption = 'Cód. Almacén';
            TableRelation = Location;
        }
        field(5; "Created by"; Code[50])
        {
            Caption = 'Creado por';
            Editable = false;
        }
        field(6; "Posted by"; Code[50])
        {
            Caption = 'Registrado por';
            Editable = false;
        }
        field(10; "Info Code"; Option)
        {
            Caption = 'Cód. Información';
            InitValue = "52";
            OptionCaption = ' ,Cód. Barras EAN-13 o EAN-8,Cód. Barras ITF-14 o ITF-6,Cód. Barras UCC o EAN-128';
            OptionMembers = " ","50","51","52";
        }
        field(11; "Terms and Conditions Code"; Option)
        {
            Caption = 'Cód. Términos y condiciones';
            InitValue = "1";
            OptionCaption = ' ,Pagado por el proveedor,Pagado por el receptor,No cobrado (retornable)';
            OptionMembers = " ","1","2","3";
        }
        field(12; "Type Code"; Option)
        {
            Caption = 'Cód. Tipo';
            InitValue = CT;
            OptionCaption = ' ,Caja de cartón,Caja rígida,Paquete,Placa de plástico,Retractilado,Enrollado,Pallet retornable,Pallet no retornable,Pallet ISO 1 - 1/1 EURO Pallet';
            OptionMembers = " ",CT,CS,PK,SL,SW,RO,"09","08","201";
        }
        field(13; "Shipping Payment Responsible"; Option)
        {
            Caption = 'Responsable pago transporte';
            InitValue = "3";
            OptionCaption = ' ,Pagado por el cliente,Gratis,Pagado por el proveedor';
            OptionMembers = " ","1","2","3";
        }
        field(14; "Type Text"; Text[35])
        {
            Caption = 'Descripción tipo embalaje';
        }
        field(15; "Net Weight 1 (AAC)"; Decimal)
        {
            Caption = 'Peso neto 1 (AAC)';
            InitValue = 5;
        }
        field(16; "Net Weight 2"; Decimal)
        {
            Caption = 'Peso neto 2';
        }
        field(17; "Net Weight Type"; Option)
        {
            Caption = 'Significación peso neto';
            InitValue = "3";
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(18; "Net Weight UOM"; Code[6])
        {
            Caption = 'Ud. Medida peso neto';
            InitValue = 'KGM';
        }
        field(19; "Gross Weight 1 (AAD)"; Decimal)
        {
            Caption = 'Peso bruto 1 (AAD)';
            InitValue = 5;
        }
        field(20; "Gross Weight 2"; Decimal)
        {
            Caption = 'Peso bruto 2';
        }
        field(21; "Gross Weight Type"; Option)
        {
            Caption = 'Significación peso bruto';
            InitValue = "3";
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(22; "Gross Weight UOM"; Code[6])
        {
            Caption = 'Ud. Medida peso bruto';
            InitValue = 'KGM';
        }
        field(23; "Height Dimension 1 (HT)"; Decimal)
        {
            Caption = 'Dimensión de altura 1 (HT)';
            InitValue = 50;
        }
        field(24; "Height Dimension 2"; Decimal)
        {
            Caption = 'Dimensión de altura 2';
        }
        field(25; "Height Type"; Option)
        {
            Caption = 'Significación altura';
            InitValue = "3";
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(26; "Height UOM"; Code[6])
        {
            Caption = 'Ud. Medida altura';
            InitValue = 'MMT';
        }
        field(27; "Width Dimension 1 (WD)"; Decimal)
        {
            Caption = 'Dimensión de ancho 1 (WD)';
            InitValue = 50;
        }
        field(28; "Width Dimension 2"; Decimal)
        {
            Caption = 'Dimensión de ancho 2';
        }
        field(29; "Width Type"; Option)
        {
            Caption = 'Significación ancho';
            InitValue = "3";
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(30; "Width UOM"; Code[6])
        {
            Caption = 'Ud. Medida ancho';
            InitValue = 'MMT';
        }
        field(31; "Length Dimension 1 (LN)"; Decimal)
        {
            Caption = 'Dimensión de longitud 1 (LN)';
            InitValue = 50;
        }
        field(32; "Length Dimension 2"; Decimal)
        {
            Caption = 'Dimensión de longitud 2';
        }
        field(33; "Length Type"; Option)
        {
            Caption = 'Significación longitud';
            InitValue = "3";
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(34; "Length UOM"; Code[6])
        {
            Caption = 'Ud. Medida longitud';
            InitValue = 'MMT';
        }
        field(35; "Temp Dimension 1 (TC)"; Decimal)
        {
            Caption = 'Dimensión de temperatura 1 (TC)';
        }
        field(36; "Temp Dimension 2"; Decimal)
        {
            Caption = 'Dimensión de temperatura 2';
        }
        field(37; "Temp Type"; Option)
        {
            Caption = 'Significación temperatura';
            OptionCaption = ' ,Aproximadamente,Igual a';
            OptionMembers = " ","3","4";
        }
        field(38; "Temp UOM"; Code[6])
        {
            Caption = 'Ud. Medida temperatura';
        }
        field(39; Quantity; Decimal)
        {
            CalcFormula = sum("Packaging Line".Quantity where("No." = field("No.")));
            Caption = 'Cantidad';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Handling Instructions Code"; Option)
        {
            Caption = 'Cód. Instrucciones manejo';
            InitValue = STR;
            OptionCaption = ' ,Comestibles,Control de plagas,Frágil,Tamaño especial,No se puede apilar,Manejar con cuidado,Apilación limitada';
            OptionMembers = " ",EAT,PSC,CRU,BIG,UST,HWC,STR;
        }
        field(41; "Handling Instructions Text"; Text[70])
        {
            Caption = 'Descripción instrucciones manejo';
        }
        field(42; "Shipment mark 1"; Text[35])
        {
            Caption = 'Marca de envío 1';
        }
        field(43; "Shipment mark 2"; Text[35])
        {
            Caption = 'Marca de envío 2';
        }
        field(44; "Shipment mark 3"; Text[35])
        {
            Caption = 'Marca de envío 3';
        }
        field(45; "Shipment mark 4"; Text[35])
        {
            Caption = 'Marca de envío 4';
        }
        field(46; "Lower SN or ID 1"; Text[35])
        {
            Caption = 'Nº Serie o Id. Inferior 1';
        }
        field(47; "Upper SN or ID 1"; Text[35])
        {
            Caption = 'Nº Serie o Id. Superior 1';
        }
        field(48; "Lower SN or ID 2"; Text[35])
        {
            Caption = 'Nº Serie o Id. Inferior 2';
        }
        field(49; "Upper SN or ID 2"; Text[35])
        {
            Caption = 'Nº Serie o Id. Superior 2';
        }
        field(50; "Lower SN or ID 3"; Text[35])
        {
            Caption = 'Nº Serie o Id. Inferior 3';
        }
        field(51; "Upper SN or ID 3"; Text[35])
        {
            Caption = 'Nº Serie o Id. Superior 3';
        }
        field(52; "Qty. (Base)"; Decimal)
        {
            CalcFormula = sum("Packaging Line"."Qty. (Base)" where("No." = field("No.")));
            Caption = 'Cdad. (Base)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Number of Boxes"; Integer)
        {
            Caption = 'Número paquetes';
            InitValue = 1;
        }
        field(70; "Source Type"; Integer)
        {
            Caption = 'Tipo origen';
            Editable = true;
        }
        field(71; "Source No."; Code[20])
        {
            Caption = 'Nº Origen';
            Editable = true;
        }
        field(72; "Source Line No."; Integer)
        {
            Caption = 'Nº Línea origen';
            Editable = true;
            Enabled = false;
        }
        field(73; "Posted Source Type"; Integer)
        {
            Caption = 'Tipo origen reg.';
            Editable = true;
        }
        field(74; "Posted Source No."; Code[20])
        {
            Caption = 'Nº Origen reg.';
            Editable = true;
        }
        field(75; "Posted Source Line No."; Integer)
        {
            Caption = 'Nº Línea origen reg.';
            Editable = true;
            Enabled = false;
        }
        field(76; "Caja Picking"; Code[20])
        {
        }
        field(77; Roadmap; Code[20])
        {
            Caption = 'Roadmap';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    var
        PackagingLine: Record "Packaging Line";
    begin
        // TESTFIELD("Posted Source No.",'');
        PackagingLine.Reset;
        PackagingLine.SetRange("No.", "No.");
        PackagingLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        Validate("Creation Date", Today);
        Validate("Created by", UserId);
    end;

    trigger OnModify()
    begin
        // TESTFIELD("Posted Source No.",'');
    end;

    trigger OnRename()
    begin
        // TESTFIELD("Posted Source No.",'');
    end;

    procedure GetNextPackagingNo(LocationCode: Code[10]): Code[18]
    var
        Location: Record Location;
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        PackagingNo: Code[20];
    begin
        if LocationCode = '' then begin
            TestField("Location Code");
            LocationCode := "Location Code";
        end;
        Location.Reset;
        Location.Get(LocationCode);
        Location.TestField("Packaging Nos.");
        //PackagingNo:=NoSeriesManagement.GetNextNo(Location."Packaging Nos.", Today, true);
        PackagingNo := NoSeries.GetNextNo(Location."Packaging Nos.", Today, true);
        AddControlDigit(PackagingNo);
        exit(PackagingNo);
    end;

    procedure AddControlDigit(var Number: Code[18])
    var
        CurrentPosition: Integer;
        Product: Integer;
        DummyInt: Integer;
        Factor: Integer;
        Ten: Integer;
        ControlDigit: Integer;
        Modulus: Integer;
    begin
        //IF STRLEN(Number)<>17 THEN
        //  ERROR('La longitud esperada del número de embalaje es 17. El código con el que se ha intentado trabajar es '+Number);
        CurrentPosition := 0;
        Product := 0;
        while CurrentPosition < StrLen(Number) do begin
            Evaluate(DummyInt, CopyStr(Number, StrLen(Number) - CurrentPosition, 1));
            Modulus := (CurrentPosition + 1) MOD 2;
            if Modulus = 0 then
                Factor := 1
            else
                Factor := 3;
            Product += DummyInt * Factor;
            CurrentPosition += 1;
        end;
        Ten := 10;
        while not (Ten >= Product) do begin
            Ten += 10;
        end;
        if not (Ten >= Product) then Error('Ha habido un error inesperado. Por favor póngase en contacto con el administrador del sistema');
        ControlDigit := Ten - Product;
        if ControlDigit > 9 then Error('Ha habido un error inesperado. Por favor póngase en contacto con el administrador del sistema');
        Number := Number + Format(ControlDigit);
    end;
}
