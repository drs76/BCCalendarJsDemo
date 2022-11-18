var picker;

'use strict';

function Init() {
    setTimeout(function() {
        let iframe = window.frameElement;
        let addinContainer = iframe.parentNode;
        addinContainer.style.display = "None";
        let fieldContainer = addinContainer.previousElementSibling;
        let input = fieldContainer.querySelector("input");
        if (input) {
            if (!input.value || input.value === '')
                input.value = "#FFFFFF";

            console.log(input.value);
            picker = new JSColor(input);

            let event = new Event('change');
            input.dispatchEvent(event);
        }
    }, 100);
}

function SetColour(colour) {
    console.log(colour);
    let iframe = window.frameElement;
    let addinContainer = iframe.parentNode;
    let fieldContainer = addinContainer.previousElementSibling;
    fieldContainer.querySelector('input').jscolor.fromString(colour)
    console.log(picker);
}