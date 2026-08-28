/*
    Author: Niklas Dougherty <nd@abas.se>
    Date: 2026-08-19
    Description: Extend Sales Lines with additional fields.
*/
tableextension 50101 "Sales Line Finder Ext" extends "Sales Line"
{
    fields
    {
        field(50100; "Custom Finder Doc Type"; Enum "Item Doc Type Find")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50101; "Customer Project Code"; Enum "Item Proj Code Find")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50102; "Custom Finder Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Variant Filter Buffer"."Variant Code";
        }
    }
}