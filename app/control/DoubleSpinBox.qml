import QtQuick 2.15

import QtQuick.Controls 2.15

SpinBox {
    id: spinbox
    value: 110
    from: 0
    to: 100 * 100
    stepSize: 100

    property int decimals: 2
    property double doubleValue: value / 100

    validator: DoubleValidator {
        bottom: Math.min(spinbox.from, spinbox.to)
        top:  Math.max(spinbox.from, spinbox.to)
    }

    textFromValue: function(value, locale) {
        return Number(value / 100).toLocaleString(locale, 'f', spinbox.decimals)
    }

    valueFromText: function(text, locale) {
        return Number.fromLocaleString(locale, text) * 100
    }
}
