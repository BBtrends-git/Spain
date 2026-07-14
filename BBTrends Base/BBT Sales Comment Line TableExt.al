TableExtension 50117 "BBT Sales Comment Line" extends "Sales Comment Line"
{
    fields
    {
        field(50000; "Comment type"; Option)
        {
            Caption = 'Comment type';
            Description = 'SGA';
            OptionCaption = ' ,Ship';
            OptionMembers = " ", Ship;
        }
    }
}
