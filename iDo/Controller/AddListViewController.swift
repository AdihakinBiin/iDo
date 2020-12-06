//
//  AddListViewController.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/26/20.
//

import UIKit
import ChameleonFramework

class AddListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet  var colorPalette: [UIView]!
    @IBOutlet  var textField: UITextField?
    
    
    public var completion : ((String, UIColor) -> Void)?
    
    @NSCopying var selectedColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.delegate = self
        textField?.becomeFirstResponder()
        textField?.textColor = .systemRed
        setUpColorPalette()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    @IBAction func didTabSave(_sender: UIButton){
        if let text = textField?.text, !text.isEmpty {
            completion?(text, selectedColor ?? .systemRed)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        /// handling code
        textField?.resignFirstResponder()
    }
    
    func setUpColorPalette() {
      colorPalette.forEach { view in
        
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        
        let gestureRecognizer = UITapGestureRecognizer(
          target: self, action: #selector(colorWasTapped(_:)))
        view.addGestureRecognizer(gestureRecognizer)
      }
    }

    @objc func colorWasTapped(_ sender: UITapGestureRecognizer) {
      guard let color = sender.view?.backgroundColor else { return }
        
        textField?.textColor = color
        selectedColor = color
    }
    @IBAction func didTabCancel(_sender: UIButton){
        if let text = textField?.text, !text.isEmpty{
            let alert = UIAlertController()
            let action = UIAlertAction(title: "Discard Changes", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
                
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}
