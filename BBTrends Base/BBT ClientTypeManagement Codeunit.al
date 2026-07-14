Codeunit 50012 "ClientTypeManagement"
{
    trigger OnRun()
    begin
    end;
    procedure GetCurrentClientType()CurrClientType: ClientType begin
        CurrClientType:=CurrentClientType;
        OnAfterGetCurrentClientType(CurrClientType);
    end;
    procedure IsClientType(ExpectedClientType: ClientType): Boolean begin
        exit(ExpectedClientType = GetCurrentClientType);
    end;
    procedure IsCommonWebClientType(): Boolean begin
        exit(GetCurrentClientType in[Clienttype::Web, Clienttype::Tablet, Clienttype::Phone, Clienttype::Desktop]);
    end;
    procedure IsWindowsClientType(): Boolean begin
        exit(IsClientType(Clienttype::Windows));
    end;
    local procedure OnAfterGetCurrentClientType(var CurrClientType: ClientType)
    begin
    end;
}
