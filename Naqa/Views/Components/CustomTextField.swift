//
//  CustomTextField.swift
//  Naqa
//
//  Created by Lulwah almisfer on 05/03/2025.
//

import UIKit
import SwiftUI

struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString(placeholder, comment: "")
        
        if Helper.isCurrentLanguageArabic() {
            textField.textAlignment = .right
        } else {
            textField.textAlignment = .left
        }
        
        textField.keyboardType = .asciiCapableNumberPad
        textField.inputAccessoryView = context.coordinator.createToolbar() // Add Done button
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }


        func createToolbar() -> UIToolbar {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()


            let done = String(localized: "Done", comment: "Button title for dismissing keyboard")
            let doneButton = UIBarButtonItem(title: done, style: .done, target: self, action: #selector(dismissKeyboard))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            if Helper.isCurrentLanguageArabic() {
                toolbar.items = [doneButton, flexibleSpace]
            } else {
                toolbar.items = [flexibleSpace, doneButton]
            }
            return toolbar
        }

        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
