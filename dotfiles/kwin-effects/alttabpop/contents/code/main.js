"use strict";

// A tapped Alt+Tab never shows the switcher, so tabBoxAdded only fires when it's
// held. tabBoxClosed fires either way, just before the chosen window is activated
var switcherShown = false;
var tappedAt = 0;
var previous = effects.activeWindow;

effects.tabBoxAdded.connect(function () {
    switcherShown = true;
});

effects.tabBoxClosed.connect(function () {
    tappedAt = switcherShown ? 0 : Date.now();
    switcherShown = false;
});

effects.windowActivated.connect(function (window) {
    var from = previous;
    previous = window;
    // Alt+Tab onto the already active window activates nothing; don't let a
    // later click inherit the tap
    if (!window || Date.now() - tappedAt > 250) {
        return;
    }
    tappedAt = 0;

    // Slide in from the side the window sits on relative to the one we left;
    // overlapping (e.g. both maximized) windows come in from the right
    var direction = 1;
    if (from && window.frameGeometry.x < from.frameGeometry.x) {
        direction = -1;
    }
    animate({
        window: window,
        curve: QEasingCurve.OutCubic,
        duration: animationTime(200),
        animations: [
            {
                type: Effect.Translation,
                from: { value1: 40 * direction, value2: 0 },
                to: { value1: 0, value2: 0 },
            },
            { type: Effect.Opacity, from: 0.6 },
        ],
    });
});
