/// <summary>
/// ControlAddIn PTEColorPicker.
/// </summary>
controladdin PTEColorPicker
{
    Scripts = 'src/controladdins/colorpicker/scripts/jscolor.js', 'src/controladdins/colorpicker/scripts/colorpicker.js';

    StartupScript = 'src/controladdins/colorpicker/scripts/colorpickerstart.js';
    RequestedHeight = 1;

    /// <summary>
    /// ControlReady.
    /// </summary>
    event ControlReady();

    /// <summary>
    /// Init.
    /// </summary>
    procedure Init();

    /// <summary>
    /// SetColour.
    /// </summary>
    /// <param name="Color">Text.</param>
    procedure SetColour(Color: Text);

}