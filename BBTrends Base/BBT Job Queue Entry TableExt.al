TableExtension 50150 "BBT Job Queue Entry" extends "Job Queue Entry"
{
    fields
    {
        //Unsupported feature: Property Modification (Editable) on ""User ID"(Field 2)".
        field(50000; "Retry on Error"; Boolean)
        {
            Caption = 'Reintentar en error';
        }
    }
//Unsupported feature: Code Modification on "Restart(PROCEDURE 5)".
//procedure Restart();
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
    TESTFIELD("User ID",USERID);
    LOCKTABLE;
    GET(ID);
    SetStatusValue(Status::Ready);
    ClearServiceValues;
    IF "Run in User Session" THEN
      STARTSESSION("User Session ID",CODEUNIT::"Job Queue User Session",COMPANYNAME,Rec);
    MODIFY;
    */
//end;
//>>>> MODIFIED CODE:
//begin
/*
    //TESTFIELD("User ID",USERID);
    #2..8
    */
//end;
}
