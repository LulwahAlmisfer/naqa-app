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

        // ✅ Create a "Done" button above the keyboard
        func createToolbar() -> UIToolbar {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()

            let doneButton = UIBarButtonItem(title: "تم", style: .done, target: self, action: #selector(dismissKeyboard))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            toolbar.items = [flexibleSpace, doneButton] // Align "Done" to the right
            return toolbar
        }

        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
