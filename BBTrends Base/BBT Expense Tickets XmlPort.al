XmlPort 50040 "Expense Tickets"
{
    // // BBT 01/02/2023. Importación de fichero de gastos a diario contable de la aplicación de CAPTIO.
    Caption = 'Expense Tickets';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Gen. Journal Line";
            "Gen. Journal Line")
            {
                XmlName = 'GenJournalLine';

                textelement("<numero_asiento>")
                {
                    XmlName = 'NUMERO_ASIENTO';
                }
                textelement(NUMERO_LINEA)
                { }
                textelement(INFORME_GASTOS)
                { }
                textelement(NOMBRE_INFORME_GASTOS)
                { }
                textelement(USUARIO)
                { }
                textelement(TIPO_LINEA)
                { }
                textelement(CUENTA_CONTABLE)
                { }
                textelement(FECHA_DOC)
                { }
                textelement(FECHA_TICKET_REPORT)
                { }
                textelement(IMPORTE)
                { }
                textelement(CONCEPTO)
                { }
                trigger OnAfterInsertRecord()
                begin
                    if RecordCounter = 1 then exit;
                    ProcessLine;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    RecordCounter += 1;
                    "Gen. Journal Line".Init;
                    "Gen. Journal Line"."Journal Template Name" := GJTemplate;
                    "Gen. Journal Line"."Journal Batch Name" := GJBatch;
                    "Gen. Journal Line"."Document No." := DocumentoNo;
                    "Gen. Journal Line"."Line No." := (RecordCounter - 1) * 10000;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    trigger OnPostXmlPort()
    begin
        "Gen. Journal Line".Init;
        "Gen. Journal Line".SetRange("Journal Template Name", GJTemplate);
        "Gen. Journal Line".SetRange("Journal Batch Name", GJBatch);
        "Gen. Journal Line".SetRange("Line No.", 0);
        "Gen. Journal Line".DeleteAll;
        Message('Proceso de importación terminado correctamente');
    end;

    trigger OnPreXmlPort()
    begin
        Clear(RecordCounter);
        GenJournalTemplate.Init;
        GenJournalBatch.Init;
        GJTemplate := 'GENERAL';
        GJBatch := 'GASTOS';
        GenJournalBatch.SetRange("Journal Template Name", GJTemplate);
        GenJournalBatch.SetRange(Name, GJBatch);
        if GenJournalBatch.FindFirst then "Gen. Journal Line".SetRange("Journal Template Name", GJTemplate);
        "Gen. Journal Line".SetRange("Journal Batch Name", GJBatch);
        "Gen. Journal Line".DeleteAll;
        //>> V27
        //DocumentoNo := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", WorkDate, true);
        DocumentoNo := NoSeries.GetNextNo(GenJournalBatch."No. Series", WorkDate);
        //<<
    end;

    var
        RecordCounter: Integer;
        //>> Obsoleto V27
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GJTemplate: Code[10];
        GJBatch: Code[10];
        DocumentoNo: Code[20];

    local procedure ProcessLine()
    var
        Dia: Integer;
        Mes: Integer;
        Anyo: Integer;
        Texto: Text;
        ImporteLinea: Decimal;
    begin
        //NUMERO_ASIENTO
        //NUMERO_LINEA
        //"Gen. Journal Line"."Document No." := COPYSTR(INFORME_GASTOS,10,20);
        //"Gen. Journal Line"."Line No." := ( RecordCounter - 1 ) * 10000;
        Evaluate(Dia, CopyStr(FECHA_DOC, 1, 2));
        Evaluate(Mes, CopyStr(FECHA_DOC, 4, 2));
        Evaluate(Anyo, CopyStr(FECHA_DOC, 7, 4));
        "Gen. Journal Line".Validate("Posting Date", Dmy2date(Dia, Mes, Anyo));
        Evaluate(Dia, CopyStr(FECHA_TICKET_REPORT, 1, 2));
        Evaluate(Mes, CopyStr(FECHA_TICKET_REPORT, 4, 2));
        Evaluate(Anyo, CopyStr(FECHA_TICKET_REPORT, 7, 4));
        "Gen. Journal Line".Validate("Document Date", Dmy2date(Dia, Mes, Anyo));
        "Gen. Journal Line".Validate("Account Type", "Gen. Journal Line"."account type"::"G/L Account");
        "Gen. Journal Line".Validate("Account No.", CUENTA_CONTABLE);
        "Gen. Journal Line".Validate("External Document No.", INFORME_GASTOS);
        Texto := USUARIO;
        if CONCEPTO <> '' then Texto := Texto + '-' + CONCEPTO;
        "Gen. Journal Line".Validate(Description, CopyStr(Texto, 1, 50));
        Evaluate(ImporteLinea, IMPORTE);
        if TIPO_LINEA = 'DEBE' then
            "Gen. Journal Line".Validate("Debit Amount", ImporteLinea)
        else
            "Gen. Journal Line".Validate("Credit Amount", ImporteLinea);
        "Gen. Journal Line".Modify;
    end;
}
