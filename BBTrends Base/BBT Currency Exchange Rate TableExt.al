TableExtension 51100 "BBT-IT Currency Exchange Rate" extends "Currency Exchange Rate"
{
    fields
    {
    }

    trigger OnInsert()
    begin
        //>> Fijamos por defecto que se permita modificar el cambio
        "Fix Exchange Rate Amount" := "Fix Exchange Rate Amount"::"Relational Currency";
        //<< 
    end;
}