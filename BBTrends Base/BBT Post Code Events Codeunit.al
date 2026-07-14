codeunit 50050 "Post Code Events"
{
    //- 151 Códigos Postales
    //Cuando escribes un código postal el sistema lo busca en la tabla y recupera los datos de población y provincia.
    //Eso está bien excepto si el país no es España.
    //Si en otro pais coincide que el CP es igual que uno de ES el sistema lo reescribe.
    [EventSubscriber(ObjectType::Table, Database::"Post Code", 'OnBeforeCheckClearPostCodeCityCounty', '', true, true)]
    local procedure "Post Code_OnBeforeCheckClearPostCodeCityCounty"(var CityTxt: Text; var PostCode: Code[20]; var CountyTxt: Text; var CountryCode: Code[10]; xCountryCode: Code[10]; var IsHandled: Boolean)
    begin
        IsHandled:=true;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Post Code", 'OnBeforeValidateCityProcedure', '', true, true)]
    local procedure "Post Code_OnBeforeValidateCityProcedure"(var CityTxt: Text[30]; var PostCode: Code[20]; var CountyTxt: Text[30]; var CountryCode: Code[10]; UseDialog: Boolean; var IsHandled: Boolean)
    begin
        IsHandled:=true;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Post Code", 'OnBeforeValidateCountryCode', '', true, true)]
    local procedure "Post Code_OnBeforeValidateCountryCode"(var CityTxt: Text[30]; var PostCode: Code[20]; var CountyTxt: Text[30]; var CountryCode: Code[10]; var IsHandled: Boolean)
    begin
        IsHandled:=true;
    end;
//+ 151 Códigos Postales
//Cuando escribes un código postal el sistema lo busca en la tabla y recupera los datos de población y provincia.
//Eso está bien excepto si el país no es España.
//Si en otro pais coincide que el CP es igual que uno de ES el sistema lo reescribe.
}
