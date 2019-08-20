//
//  ViewController.swift
//  TextField
//
//  Created by Marcello Chuahy on 19/08/19.
//  Copyright © 2019 Marcello Chuahy. All rights reserved.
//

// Step 1: Add a basic UITextField
// Step 2: Give it basic constraints (height: 44)
// Step 3: Connect the UITextField to its ViewController's IBOutlet
// Step 4: Add Icon (https://icons8.com/icon/set/user/ios) to Assets.xcassets and set Render As to Template Image in Atributtes inspector
// Step 5: Extend UITextField and create a new setIcon function
// Step 6: Set the icon and apply tint color in @IBOutlet -> didSet

import UIKit

class ViewController: UIViewController {
  
  //MARK: - Outlets
  
  // Constraints to View:
  // top 0, right 0, bottom 0, left 0
  @IBOutlet weak var scrollView: UIScrollView!
  
  // Constraints of contentView to -> superview scrollView -> superview View: "same width"
  // Constraints of contentView to -> superview scrollView: top 0, right 0, bottom 0, left 0
  // Constraints of contentView: height: (freedom, then set a height to room all your content)
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var outputLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField! {
    didSet {
      nameTextField.tintColor  = UIColor.lightGray
      nameTextField.setIcon(UIImage(imageLiteralResourceName: "icon-user"))
    }
  }
  @IBOutlet weak var phoneTextField: UITextField! {
    didSet {
      phoneTextField.tintColor  = UIColor.lightGray
      phoneTextField.setIcon(UIImage(imageLiteralResourceName: "icon-phone"))
    }
  }
  @IBOutlet weak var emailTextField: UITextField! {
    didSet {
      emailTextField.tintColor  = UIColor.lightGray
      emailTextField.setIcon(UIImage(imageLiteralResourceName: "icon-mail"))
    }
  }
  @IBOutlet weak var usernameTextField: UITextField! {
    didSet {
      usernameTextField.tintColor = UIColor.lightGray
      usernameTextField.setIcon(UIImage(imageLiteralResourceName: "icon-username"))
    }
  }
  @IBOutlet weak var passwordTextField: UITextField! {
    didSet {
      passwordTextField.tintColor = UIColor.lightGray
      passwordTextField.setIcon(UIImage(imageLiteralResourceName: "icon-password"))
    }
  }
  @IBOutlet weak var doSomethingButton: UIButton!
  
  
  //MARK: - Outlets for Accessory View
  @IBOutlet weak var btnPrev: UIButton!
  @IBOutlet weak var btnNext: UIButton!
  @IBOutlet weak var btnDone: UIButton!
  
  // MARK: - Properties
  var activeTextFieldTag:Int?
  
  //MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    doSomethingButton.isEnabled = false
    configureTextFields()
  }
  
  // MARK: - Methods
  // TextFields Methods
  private func configureTextFields() {

  // 1. Configure tag number
  nameTextField.tag     = 1 // must be initiate with 1, not zero!
  phoneTextField.tag    = 2
  emailTextField.tag    = 3
  usernameTextField.tag = 4
  passwordTextField.tag = 5
  
  // 2. Set this view controller as the delegate for the textfields
  nameTextField.delegate     = self
  phoneTextField.delegate    = self
  emailTextField.delegate    = self
  usernameTextField.delegate = self
  passwordTextField.delegate = self
  
  // 3. Configure textfields
  configureTextFieldStyles(nameTextField)
  configureTextFieldStyles(phoneTextField)
  configureTextFieldStyles(emailTextField)
  configureTextFieldStyles(usernameTextField)
  configureTextFieldStyles(passwordTextField)
  
  // 4. Configure input accessory view
  configureInputAccessoryView()
  
  // 5. Set NotificationCenter to listen to changes in keyboard state
  NotificationCenter.default.addObserver(self, selector: #selector(ViewController.animateUpWithKeyboard(notification:)),   name: UIResponder.keyboardWillShowNotification, object: nil)
  NotificationCenter.default.addObserver(self, selector: #selector(ViewController.animateDownWithKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification,  object: nil)
  
  // 6. Set UITapGestureRecognizer to listen to tap outside of text view
  let tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(ViewController.dismissKeyboard) // <- dismissKeyboard
    )
  tapGesture.cancelsTouchesInView = false // Important: allow didSelectRowAtIndexPath in table view
  view.addGestureRecognizer(tapGesture)
  
}
  private func configureTextFieldStyles(_ textField:UITextField!) {
    
    textField.enablesReturnKeyAutomatically = true // waits for at least 1 character
    textField.clearButtonMode = .whileEditing
    
    // 1. nameTextField
    if textField.tag == 1 {
      textField.autocapitalizationType = .words
      textField.placeholder            = "name"
      textField.returnKeyType          = .next
    }
    
    // 2. phoneTextField
    if textField.tag == 2 {
      textField.keyboardType           = .numberPad
      textField.placeholder            = "phone"
      textField.returnKeyType          = .next
    }
    
    // 3. emailTextField
    if textField.tag == 3 {
      textField.autocapitalizationType = .none
      textField.keyboardType           = .emailAddress
      textField.text                   = ""
      textField.placeholder            = "e-mail"
      textField.returnKeyType          = .next
    }
    
    // 4. usernameTextField
    if textField.tag == 4 {
      textField.autocapitalizationType = .none
      textField.placeholder            = "username"
      textField.returnKeyType          = .next
    }
    
    // 5. passwordTextField
    if textField.tag == 5 {
      textField.autocapitalizationType = .none
      textField.keyboardType           = .default
      textField.text                   = ""
      textField.placeholder            = "password (6 or +)"
      textField.returnKeyType          = .done
      textField.isSecureTextEntry      = true
    }
    
  }
  private func configureInputAccessoryView() {
    
    let customGrayColorBar     = UIColor(r: 174, g: 179, b: 190, a: 1.0) // UIColor(red: 174/255, green: 179/255, blue: 190/255, alpha: 1  )
    let customGrayColorButtons = UIColor(r: 210, g: 213, b: 219, a: 0.9) // UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 0.9)
    
    let accessoryViewBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
    accessoryViewBar.backgroundColor = customGrayColorBar
    
    let btnPrev = UIButton(type: .custom)
    btnPrev.frame = CGRect(x: 4, y: 4, width: 36, height: 36)
    btnPrev.layer.cornerRadius = 6
    btnPrev.setTitle("<", for: .normal)
    btnPrev.titleLabel!.textAlignment = .center
    btnPrev.backgroundColor = customGrayColorButtons
    btnPrev.setTitleColor(UIColor.black, for: .normal)
    btnPrev.setTitleColor(UIColor.white, for: .highlighted)
    btnPrev.addTarget(self, action: #selector(ViewController.btnPrevWasPressed(_:)), for: .touchUpInside)

    let btnNext = UIButton(type: .custom)
    btnNext.frame = CGRect(x: 44, y: 4, width: 36, height: 36)
    btnNext.layer.cornerRadius = 6
    btnNext.setTitle(">", for: .normal)
    btnNext.titleLabel!.textAlignment = .center
    btnNext.backgroundColor = customGrayColorButtons
    btnNext.setTitleColor(UIColor.black, for: .normal)
    btnNext.setTitleColor(UIColor.white, for: .highlighted)
    btnNext.addTarget(self, action: #selector(ViewController.btnNextWasPressed(_:)), for: .touchUpInside)
    
    let btnDone = UIButton(type: .custom)
    btnDone.frame = CGRect(x: (self.view.bounds.size.width - 40), y: 4, width: 36, height: 36)
    btnDone.layer.cornerRadius = 6
    btnDone.setTitle("OK", for: .normal)
    btnDone.titleLabel!.textAlignment = .center
    btnDone.backgroundColor = customGrayColorButtons
    btnDone.setTitleColor(UIColor.black, for: .normal)
    btnDone.setTitleColor(UIColor.white, for: .highlighted)
    btnDone.addTarget(self, action: #selector(ViewController.btnDoneWasPressed(_:)), for: .touchUpInside)
    
    accessoryViewBar.addSubview(btnPrev)
    accessoryViewBar.addSubview(btnNext)
    accessoryViewBar.addSubview(btnDone)
    
    nameTextField.inputAccessoryView     = accessoryViewBar
    phoneTextField.inputAccessoryView    = accessoryViewBar
    emailTextField.inputAccessoryView    = accessoryViewBar
    usernameTextField.inputAccessoryView = accessoryViewBar
    passwordTextField.inputAccessoryView = accessoryViewBar
 
  }
  
  // Input Accessory View Methods
  @objc func btnPrevWasPressed(_ sender: UIButton) {
    if let activeTextField = self.view.viewWithTag(activeTextFieldTag!) as? UITextField {
      // Try to find previous responder:
      if let previousTextField = self.view.viewWithTag(activeTextField.tag - 1) as? UITextField {
        previousTextField.becomeFirstResponder()
      }
    }
  }
  @objc func btnNextWasPressed(_ sender: UIButton) {
    if let activeTextField = self.view.viewWithTag(activeTextFieldTag!) as? UITextField {
      // Try to find next responder:
      if let nextTextField = self.view.viewWithTag(activeTextField.tag + 1) as? UITextField {
        nextTextField.becomeFirstResponder()
      } else {
        // If not found, remove the keyboard:
        activeTextField.resignFirstResponder()
      }
    }
  }
  @objc func btnDoneWasPressed(_ sender: UIButton) {
    dismissKeyboard()
  }

  // MARK: - Convenience methods
  @objc func animateUpWithKeyboard(notification: NSNotification) {
    
    if let activeTextFieldTag = activeTextFieldTag {
      
      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        
        let contentInsets                     = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height + 128), right: 0.0)
        self.scrollView.contentInset          = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.size.height
        
        if let activeTextField = self.view.viewWithTag(activeTextFieldTag) as? UITextField {
          if (!aRect.contains(activeTextField.frame.origin)) {
            self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
          }
        }
        
      }
  
    }
    
  }
  @objc func animateDownWithKeyboard(notification: NSNotification) {
    let contentInsets                     = UIEdgeInsets.zero
    self.scrollView.contentInset          = contentInsets
    self.scrollView.scrollIndicatorInsets = contentInsets
  }
  @objc func dismissKeyboard() {
    toggleButton()
    view.endEditing(true)
  }
  
  func toggleButton() {
    if let name = nameTextField.text {
      if name == "" {
        doSomethingButton.isEnabled = false
      } else {
        doSomethingButton.isEnabled = true
      }
    } else {
      doSomethingButton.isEnabled = false
    }
  }

  //MARK: - Actions
  @IBAction func nameTextFieldDidChanged(_ sender: UITextField) {
    print("value did changed")
    toggleButton()
  }
  @IBAction func loginTapped(_ sender: UIButton) {

    if let name = nameTextField.text {
      outputLabel.text = "Hello, " + name.trimmingCharacters(in: .whitespacesAndNewlines) + "!"
    }

    view.endEditing(true)
    print("login button was tapped")
  }
  
}

// MARK: - Extensions

extension ViewController: UITextFieldDelegate {
  
  // 1. DidBegin - This method is called when user has started editing the textfield
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("Textfield delegate methods 01 -> textFieldDidBeginEditing()")
    activeTextFieldTag = textField.tag
  }
  
  // 2. DidEnd - This method is called when user has finished editing the textfield
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("Textfield delegate methods 02 -> textFieldDidEndEditing()")
    toggleButton()
    activeTextFieldTag = nil
  }
  
  // 3. ShouldReturn - This method is called when user has tapped return button
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    print("Textfield delegate methods 03 -> textFieldShouldReturn()")
    
    // Try to find next responder:
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
      nextField.becomeFirstResponder()
    } else {
      // If not found, remove the keyboard:
      textField.resignFirstResponder()
    }
    
    return false
  }
 
}

extension UIColor {
  convenience init(r: Int, g: Int, b: Int, a: Double) {
    let red   = CGFloat(r)/255
    let green = CGFloat(g)/255
    let blue  = CGFloat(b)/255
    let alpha = CGFloat(a)
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UITextField {
  
  func setIcon(_ image: UIImage) {
    
    let iconContainerView: UIView = UIView     (frame: CGRect(x: 20, y: 0, width: 30, height: 30)) // a square of 30 points
    let iconView                  = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20)) // a square of 20 points
    
    iconView.image = image
    
    iconContainerView.addSubview(iconView)
    
    // The overlay view displayed on the left (or leading) side of the text field.
    leftView = iconContainerView
    
    // Controls when the left overlay view appears in the text field.
    leftViewMode = .always
    
  }
  
}
