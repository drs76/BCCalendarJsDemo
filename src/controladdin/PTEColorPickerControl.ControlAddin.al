/// <summary>
/// ControlAddIn "PTEColorPicker."
/// </summary>
controladdin PTEColorPickerControl
{
    Scripts = 'src/controladdin/colorpicker/scripts/jscolor.js', 'src/controladdin/colorpicker/scripts/colorpicker.js';

    StartupScript = 'src/controladdin/colorpicker/scripts/colorpickerstart.js';
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