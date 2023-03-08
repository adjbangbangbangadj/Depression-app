import QtQuick 2.15

import QtQuick.Controls 2.15

SpinBox {
    id: spinbox
    value: 0
    from: 0
    to: 1000 * 1000
    stepSize: scale

    property int scale: 1000
    property int decimals: 2

    validator: DoubleValidator {
        top: spinbox.from
        bottom:  spinbox.to
    }

    textFromValue: function(value, locale) {
        return Number(value / scale).toLocaleString(locale, 'f', spinbox.decimals)
    }

    valueFromText: function(text, locale) {
        return Number.fromLocaleString(locale, text) * scale
    }
}
