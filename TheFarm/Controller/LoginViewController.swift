//
//  LoginViewController.swift
//  TheFarm
//
//  Created by Nandan on 25/02/24.
//

import UIKit
import Alamofire
import Toast

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var showHidePassBtn: UIButton!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginUp: NSLayoutConstraint!
    @IBOutlet weak var rememberMeImgView: UIImageView!
    @IBOutlet weak var rememberMeLbl: UILabel!
    
    var rememberMe = false
    let loginURL = "https://phpstack-1098524-4123000.cloudwaysapps.com/public/api/auth/login"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginView.layer.cornerRadius = 20
        signInBtn.layer.cornerRadius = 13
        
        emailTextField.delegate = self
        passTextField.delegate = self
        emailTextField.attributedPlaceholder = addPlaceholder(image: "mail", text: "Email Address")
        passTextField.attributedPlaceholder = addPlaceholder(image: "lock", text: "Password")
        passTextField.isSecureTextEntry = true
        showHidePassBtn.tintColor = .lightGray
        showHidePassBtn.setImage(UIImage(named: "hidden"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        loginUp.constant = -100
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        loginUp.constant = 10
    }
    
    func addPlaceholder(image: String, text: String) -> NSMutableAttributedString {
        // Create a text attachment with the provided image
        guard var image = UIImage(named: image) else {
            fatalError("Image not found")
        }
        
        image = image.withRenderingMode(.alwaysTemplate).withTintColor(.lightGray)
        let attachment = NSTextAttachment()
        attachment.image = image
        
        attachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        // Create an attributed string with the attachment
        let attachmentString = NSAttributedString(attachment: attachment)
        
        // Create an attributed string with the provided text
        let textString = NSAttributedString(string: "  " + text) // Add space before text for spacing
        
        // Combine the attachment and text strings
        let attributedText = NSMutableAttributedString()
        attributedText.append(attachmentString)
        attributedText.append(textString)
        
        return attributedText
    }
    
    func performReqForSignIn() {
        
        let parameters = [
            
            "email": emailTextField.text ?? "",
            "password": passTextField.text ?? "",
            "devicetoken": "123"
            
        ] as [String : Any]
        
        print("parameters: \(parameters)")
        
        AF.request(loginURL, method: .post, parameters: parameters).responseData { response in
            
            if response.error != nil {
                
                print("LOGIN RESPONSE ERROR = \(String(describing: response.error?.localizedDescription))")
                
            } else {
                
                if let safeData = response.data {
                    let response = String(data: safeData, encoding: .utf8)
                    print("response.. : \(response!)")
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let decodedData = try decoder.decode(LoginData.self, from: safeData)
                        
                        DispatchQueue.main.async {
                            if decodedData.status == 200 {
                                self.defaults.set(decodedData.tokenType, forKey: Constants.tokenTypeKey)
                                self.defaults.set(decodedData.accessToken, forKey: Constants.accessTokenKey)
                                self.defaults.set(true, forKey: Constants.logInOrNotKey)
                                
                                if self.rememberMe {
                                    self.defaults.set(self.emailTextField.text, forKey: Constants.emailKey)
                                    self.defaults.set(self.passTextField.text, forKey: Constants.passwordKey)
                                }
                                
                                self.dismiss(animated: true)
                            } else {
                                self.view.makeToast(decodedData.error)
                            }
                        }
                        
                    } catch {
                        print("login data decode error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    @IBAction func signInBtnPressed(_ sender: UIButton) {
        performReqForSignIn()
    }
    
    @IBAction func showHidePassPressed(_ sender: UIButton) {
        if passTextField.isSecureTextEntry {
            showHidePassBtn.tintColor = .black
            showHidePassBtn.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            showHidePassBtn.tintColor = .lightGray
            showHidePassBtn.setImage(UIImage(named: "hidden"), for: .normal)
        }
        passTextField.isSecureTextEntry = !passTextField.isSecureTextEntry
    }
    
    @IBAction func rememberMeBtnPressed(_ sender: UIButton) {
        if rememberMe {
            rememberMeImgView.image = UIImage(named: "checkbox")
            rememberMeImgView.tintColor = .black
            rememberMeLbl.textColor = .black
        } else {
            rememberMeImgView.image = UIImage(named: "unchecked")
            rememberMeImgView.tintColor = .lightGray
            rememberMeLbl.textColor = .lightGray
        }
        rememberMe = !rememberMe
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
