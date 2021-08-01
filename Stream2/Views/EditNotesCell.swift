//
//  EditNotesCell.swift
//  Stream2
//
//  Created by Luke Gantar on 8/1/21.
//

import UIKit

class EditNotesCell: UITableViewCell {
    typealias NotesChangeAction = (String) -> Void

    @IBOutlet var notesTextField: UITextField!

    private var notesChangeAction: NotesChangeAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        notesTextField.delegate = self
    }

    func configure(notes: String, changeAction: @escaping NotesChangeAction) {
        notesTextField.text = notes
        self.notesChangeAction = changeAction
    }
}

extension EditNotesCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            notesChangeAction?(title)
        }
        return true
    }
}
