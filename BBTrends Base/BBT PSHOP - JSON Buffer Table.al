Table 50024 "PSHOP - JSON Buffer"
{
    Caption = 'JSON Buffer';

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Depth; Integer)
        {
            Caption = 'Depth';
        }
        field(3; "Token type"; Option)
        {
            Caption = 'Token type';
            OptionCaption = 'None,Start Object,Start Array,Start Constructor,Property Name,Comment,Raw,Integer,Decimal,String,Boolean,Null,Undefined,End Object,End Array,End Constructor,Date,Bytes';
            OptionMembers = "None","Start Object","Start Array","Start Constructor","Property Name",Comment,Raw,"Integer",Decimal,String,Boolean,Null,Undefined,"End Object","End Array","End Constructor",Date,Bytes;
        }
        field(4; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(5; "Value Type"; Text[50])
        {
            Caption = 'Value Type';
        }
        field(6; Path; Text[250])
        {
            Caption = 'Path';
        }
        field(7; "Value BLOB"; Blob)
        {
            Caption = 'Value BLOB';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    var
        DevMsgNotTemporaryErr: label 'This function can only be used when the record is temporary.';

    procedure FindArray(var TempJSONBuffer: Record "JSON Buffer" temporary; ArrayName: Text): Boolean
    begin
        TempJSONBuffer.Copy(Rec, true);
        TempJSONBuffer.Reset;
        TempJSONBuffer.SetRange(Path, AppendPathToCurrent(ArrayName));
        if not TempJSONBuffer.FindFirst then exit(false);
        TempJSONBuffer.SetFilter(Path, AppendPathToCurrent(ArrayName) + '[*');
        TempJSONBuffer.SetRange(Depth, TempJSONBuffer.Depth + 1);
        TempJSONBuffer.SetFilter("Token type", '<>%1', "token type"::"End Object");
        exit(TempJSONBuffer.FindSet);
    end;

    procedure GetPropertyValue(var PropertyValue: Text; PropertyName: Text): Boolean
    begin
        exit(GetPropertyValueAtPath(PropertyValue, PropertyName, Path + '*'));
    end;

    procedure GetPropertyValueAtPath(var PropertyValue: Text; PropertyName: Text; PropertyPath: Text): Boolean
    var
        TempJSONBuffer: Record "JSON Buffer" temporary;
    begin
        TempJSONBuffer.Copy(Rec, true);
        TempJSONBuffer.Reset;
        TempJSONBuffer.SetFilter(Path, PropertyPath);
        TempJSONBuffer.SetRange("Token type", "token type"::"Property Name");
        TempJSONBuffer.SetRange(Value, PropertyName);
        if not TempJSONBuffer.FindFirst then exit;
        if TempJSONBuffer.Get(TempJSONBuffer."Entry No." + 1) then begin
            PropertyValue := TempJSONBuffer.GetValue;
            exit(true);
        end;
    end;

    procedure GetBooleanPropertyValue(var BooleanValue: Boolean; PropertyName: Text): Boolean
    var
        PropertyValue: Text;
    begin
        if GetPropertyValue(PropertyValue, PropertyName) then exit(Evaluate(BooleanValue, PropertyValue));
    end;

    procedure GetIntegerPropertyValue(var IntegerValue: Integer; PropertyName: Text): Boolean
    var
        PropertyValue: Text;
    begin
        if GetPropertyValue(PropertyValue, PropertyName) then exit(Evaluate(IntegerValue, PropertyValue));
    end;

    procedure GetDatePropertyValue(var DateValue: Date; PropertyName: Text): Boolean
    var
        PropertyValue: Text;
    begin
        if GetPropertyValue(PropertyValue, PropertyName) then exit(Evaluate(DateValue, PropertyValue));
    end;

    procedure GetDecimalPropertyValue(var DecimalValue: Decimal; PropertyName: Text): Boolean
    var
        PropertyValue: Text;
    begin
        if GetPropertyValue(PropertyValue, PropertyName) then exit(Evaluate(DecimalValue, PropertyValue));
    end;

    local procedure AppendPathToCurrent(AppendPath: Text): Text
    begin
        if Path <> '' then exit(Path + '.' + AppendPath);
        exit(AppendPath)
    end;

    procedure GetValue(): Text
    var
        TempBlob: codeunit "Temp Blob"; //Record TempBlob;
        CR: Text[1];
    begin
        /*TODO
            CalcFields("Value BLOB");
            if not "Value BLOB".Hasvalue then
                exit(Value);
            CR[1] := 10;
            TempBlob.Blob := "Value BLOB";
            exit(TempBlob.ReadAsText(CR, Textencoding::Windows));
            */
    end;

    procedure SetValue(NewValue: Text)
    begin
        SetValueWithoutModifying(NewValue);
        Modify;
    end;

    procedure SetValueWithoutModifying(NewValue: Text)
    var
        TempBlob: codeunit "Temp Blob";
    begin
        /*TODO
            Clear("Value BLOB");
            Value := CopyStr(NewValue, 1, MaxStrLen(Value));
            if StrLen(NewValue) <= MaxStrLen(Value) then
                exit; // No need to store anything in the blob
            if NewValue = '' then
                exit;
            TempBlob.WriteAsText(NewValue, Textencoding::Windows);
            "Value BLOB" := TempBlob.Blob;
            */
    end;
}
