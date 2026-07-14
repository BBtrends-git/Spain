Table 51101 "EDI - Temporary Documents"
{

    fields
    {
        field(51150; "Entry No."; Integer)
        { }
        field(51151; "Line No."; Integer)
        { }
        field(51152; "Identificador"; Text[40])
        { }
        field(51153; "Document Type"; Text[6])
        { }
        field(51154; "Record Type"; Text[6])
        { }
        field(51155; "Record Name"; Text[50])
        { }
        field(51156; "Value Type"; Option)
        {
            OptionMembers = " ","Text","Integer","Decimal","Date","DateTime";
            OptionCaption = ' ,Text,Integer,Decimal,Date,DateTime', Comment = 'ESP=" ,Texto,Entero,Decimal,Fecha,FechaHora"';
        }
        field(51157; "Text Value"; Text[100])
        { }
        field(51158; "Integer Value"; Integer)
        { }
        field(51159; "Decimal Value"; Decimal)
        { }
        field(51160; "Date Value"; Date)
        { }
        field(51161; "DateTime Value"; DateTime)
        { }
        field(51162; "Parent Line"; Integer)
        { }
    }
    keys
    {
        key(Key1; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }
    Procedure InsertValue(var pTempDocuments: Record "EDI - Temporary Documents";
                            pRecordName: Text[50]; pValueType: Text[10]; pStream: Text;
                            pStart: Integer; pLength: Integer; var pParentLine: Integer)
    var
        TextAux: Text;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        Hour: Integer;
        Minute: Integer;
        DummyDate: Date;
        DummyTime: Time;
    begin
        ClearRecord(pTempDocuments);
        pTempDocuments."Record Name" := pRecordName;
        case pValueType of
            'Text':
                begin
                    pTempDocuments."Text Value" := '';
                    pTempDocuments."Value Type" := pTempDocuments."Value Type"::Text;
                    if (pStart > 0) and (pLength > 0) then begin
                        pTempDocuments."Text Value" := CopyStr(pStream, pStart, pLength);
                        pTempDocuments."Text Value" := DelChr(pTempDocuments."Text Value", '<', ' ');
                        pTempDocuments."Text Value" := DelChr(pTempDocuments."Text Value", '>', ' ');
                    end;
                end;
            'Integer':
                begin
                    pTempDocuments."Integer Value" := 0;
                    pTempDocuments."Value Type" := pTempDocuments."Value Type"::Integer;
                    if (pStart > 0) and (pLength > 0) then begin
                        TextAux := CopyStr(pStream, pStart, pLength);
                        if IsNumeric(TextAux) then
                            Evaluate(pTempDocuments."Integer Value", TextAux);
                    end;
                end;
            'Decimal':
                begin
                    pTempDocuments."Decimal Value" := 0;
                    pTempDocuments."Value Type" := pTempDocuments."Value Type"::Decimal;
                    if (pStart > 0) and (pLength > 0) then begin

                        TextAux := CopyStr(pStream, pStart, pLength);
                        TextAux := ConvertStr(TextAux, '.', ',');
                        if IsNumeric(TextAux) then
                            Evaluate(pTempDocuments."Decimal Value", TextAux);
                    end;
                end;
            'Date':
                begin
                    pTempDocuments."Date Value" := 0D;
                    pTempDocuments."Value Type" := pTempDocuments."Value Type"::Date;
                    Clear(Year);
                    Clear(Month);
                    Clear(Day);
                    if (pStart > 0) and (pLength > 0) then begin
                        TextAux := CopyStr(pStream, pStart, pLength);       // Formato Valido : AAAAMMDD
                        if Evaluate(Year, CopyStr(TextAux, 1, 4)) then;
                        if Evaluate(Month, CopyStr(TextAux, 5, 2)) then;
                        if Evaluate(Day, CopyStr(TextAux, 7, 2)) then;
                        if (Year <> 0) and (Month <> 0) and (Day <> 0) then pTempDocuments."Date Value" := Dmy2date(Day, Month, Year);
                    end;
                end;
            'DateTime':
                begin
                    pTempDocuments."DateTime Value" := 0DT;
                    pTempDocuments."Value Type" := pTempDocuments."Value Type"::DateTime;
                    Clear(Year);
                    Clear(Month);
                    Clear(Day);
                    Clear(Hour);
                    clear(Minute);
                    if (pStart > 0) and (pLength > 0) then begin
                        TextAux := CopyStr(pStream, pStart, pLength);       // Formato Valido : AAAAMMDDHHMM
                        if Evaluate(Year, CopyStr(TextAux, 1, 4)) then;
                        if Evaluate(Month, CopyStr(TextAux, 5, 2)) then;
                        if Evaluate(Day, CopyStr(TextAux, 7, 2)) then;
                        if Evaluate(Hour, CopyStr(TextAux, 9, 2)) then;
                        if Evaluate(Minute, CopyStr(TextAux, 11, 2)) then;
                        if (Year <> 0) and (Month <> 0) and (Day <> 0) then begin
                            DummyDate := Dmy2date(Day, Month, Year);                                    // Creamos fecha
                            Evaluate(DummyTime, Format(Hour) + ':' + Format(Minute) + ':00');           // Creamos hora
                            pTempDocuments."DateTime Value" := CreateDatetime(DummyDate, DummyTime);    // Creamos fecha/hora
                        end
                    end;
                end;
        end;
        pTempDocuments."Line No." := pTempDocuments.Count + 1;
        if pParentLine = 0 then
            pParentLine := pTempDocuments."Line No.";
        pTempDocuments."Parent Line" := pParentLine;
        pTempDocuments.Insert;
    end;

    Procedure MoveText(pTempDocuments: Record "EDI - Temporary Documents"): Text[100]
    begin
        exit(pTempDocuments."Text Value");
    end;

    Procedure MoveInteger(pTempDocuments: Record "EDI - Temporary Documents"): Integer
    begin
        exit(pTempDocuments."Integer Value");
    end;

    Procedure MoveDecimal(pTempDocuments: Record "EDI - Temporary Documents"): Decimal
    begin
        exit(pTempDocuments."Decimal Value");
    end;

    Procedure MoveDate(pTempDocuments: Record "EDI - Temporary Documents"): Date
    begin
        exit(pTempDocuments."Date Value");
    end;

    Procedure MoveDateTime(pTempDocuments: Record "EDI - Temporary Documents"): DateTime
    begin
        exit(pTempDocuments."DateTime Value");
    end;

    local procedure ClearRecord(Var pTempDocs: Record "EDI - Temporary Documents")
    begin
        Clear(pTempDocs."Record Name");
        Clear(pTempDocs."Value Type");
        Clear(pTempDocs."Text Value");
        Clear(pTempDocs."Integer Value");
        Clear(pTempDocs."Decimal Value");
        Clear(pTempDocs."Date Value");
        Clear(pTempDocs."DateTime Value");
    end;

    local procedure IsNumeric(Value: Text): Boolean
    var
        i: Integer;
    begin
        for i := 1 to StrLen(Value) do  //Revisamos que exista algún valor númerico
            if (Format(Value[i]) in ['0' .. '9']) then
                exit(true);

        exit(false);
    end;
}