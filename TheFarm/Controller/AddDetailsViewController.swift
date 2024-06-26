//
//  ViewController.swift
//  TheFarm
//
//  Created by Nandan on 24/02/24.
//

import UIKit
import Alamofire
import Toast

class AddDetailsViewController: UIViewController {

    @IBOutlet weak var areaLbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var areaDropDownView: UIView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var fertilizerLbl: UILabel!
    @IBOutlet weak var fertilizerRadioImg: UIImageView!
    @IBOutlet weak var waterRadioImg: UIImageView!
    @IBOutlet weak var dropdownTblView: UITableView!
    @IBOutlet weak var waterLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    
    var defaults = UserDefaults.standard
    let items = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15"]
    var tableView = UITableView()
    let saveWaterURL = "https://phpstack-1098524-4123000.cloudwaysapps.com/public/api/land-parts/save-water"
    let saveFertilizerURL = "https://phpstack-1098524-4123000.cloudwaysapps.com/public/api/fertilizer-entries/save"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addShadow(viewHere: view1)
        addShadow(viewHere: view2)
        addShadow(viewHere: view3)
        
        areaDropDownView.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 20
        
        waterRadioImg.image = UIImage(named: "radioFilled")
        waterRadioImg.tintColor = .black
        waterLbl.textColor = .black
        
        fertilizerRadioImg.image = UIImage(named: "radioUnfilled")
        fertilizerRadioImg.tintColor = .lightGray
        fertilizerLbl.textColor = .lightGray
        
        transparentView.isHidden = true
        
        dropdownTblView.dataSource = self
        dropdownTblView.delegate = self
        dropdownTblView.register(UINib(nibName: Constants.DropDownTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.DropDownTableViewCellReuseId)
        dropdownTblView.layer.cornerRadius = 15
        dropdownTblView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let logInOrNot = defaults.bool(forKey: Constants.logInOrNotKey)
        if !logInOrNot {
            self.performSegue(withIdentifier: Constants.AdddetailsToLoginSegue, sender: self)
        }
    }
    
    func addShadow(viewHere: UIView) {
        viewHere.layer.cornerRadius = 15
        viewHere.layer.shadowColor = UIColor.lightGray.cgColor
        viewHere.layer.shadowOpacity = 0.4
        viewHere.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewHere.layer.shadowRadius = 5
    }
    
    func performReqForWater() {
        let tokenType = defaults.string(forKey: Constants.tokenTypeKey)
        let accessToken = defaults.string(forKey: Constants.accessTokenKey)
        
        let parameters = [
            
            "land_id": 1,
            "land_part_id[]": 7,
            "date": dateTxtField.text ?? "",
            "person": "",
            "notes": "",
            "volume": "",
            "time": timeTxtField.text ?? ""
            
        ] as [String : Any]
        
        let headers: HTTPHeaders = [
            
            "Authorization": "\(tokenType ?? "") \(accessToken ?? "")"
            
        ]
        
        AF.request(saveWaterURL, method: .post, parameters: parameters, headers: headers).responseData { response in
            
            if response.error != nil {
                
                print("WATER RESPONSE ERROR = \(String(describing: response.error?.localizedDescription))")
                
            } else {
                
                if let safeData = response.data {
                    let response = String(data: safeData, encoding: .utf8)
                    print("water response.. : \(response!)")
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let decodedData = try decoder.decode(WaterSaveData.self, from: safeData)
                        
                        if decodedData.status == 200 {
                            print("water decoded data: \(String(describing: decodedData.data))")
                        } else {
                            self.view.makeToast(decodedData.message)
                        }
                        
                    } catch {
                        print("water save data decode error: \(error)")
                    }
                }
            }
        }
    }
    
    func performReqForFertilizer() {
        let tokenType = defaults.string(forKey: Constants.tokenTypeKey)
        let accessToken = defaults.string(forKey: Constants.accessTokenKey)
        
        let parameters = [
            
            "land_id": 1,
            "land_part_id[]": 7,
            "date": dateTxtField.text ?? "",
            "person": "",
            "notes": "",
            "volume": "",
            "time": timeTxtField.text ?? ""
            
        ] as [String : Any]
        
        let headers: HTTPHeaders = [
            
            "Authorization": "\(tokenType ?? "") \(accessToken ?? "")"
            
        ]
        
        AF.request(saveFertilizerURL, method: .post, parameters: parameters, headers: headers).responseData { response in
            
            if response.error != nil {
                
                print("FERTILIZER RESPONSE ERROR = \(String(describing: response.error?.localizedDescription))")
                
            } else {
                
                if let safeData = response.data {
                    let response = String(data: safeData, encoding: .utf8)
                    print("fertilizer response.. : \(response!)")
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let decodedData = try decoder.decode(FertilizerSaveData.self, from: safeData)
                        
                        if decodedData.status == 200 {
                            print("fertilizer decoded data: \(String(describing: decodedData.data))")
                        } else {
                            self.view.makeToast(decodedData.message)
                        }
                        
                    } catch {
                        print("fertilizer save data decode error: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func dropdownBtnPressed(_ sender: UIButton) {
        dropdownTblView.isHidden = false
        transparentView.isHidden = false
    }
    
    @IBAction func waterBtnPressed(_ sender: UIButton) {
        waterRadioImg.image = UIImage(named: "radioFilled")
        waterRadioImg.tintColor = .black
        waterLbl.textColor = .black
        
        fertilizerRadioImg.image = UIImage(named: "radioUnfilled")
        fertilizerRadioImg.tintColor = .lightGray
        fertilizerLbl.textColor = .lightGray
    }
    
    @IBAction func fertilizerBtnPressed(_ sender: UIButton) {
        fertilizerRadioImg.image = UIImage(named: "radioFilled")
        fertilizerRadioImg.tintColor = .black
        fertilizerLbl.textColor = .black
        
        waterRadioImg.image = UIImage(named: "radioUnfilled")
        waterRadioImg.tintColor = .lightGray
        waterLbl.textColor = .lightGray
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if waterRadioImg.image == UIImage(named: "radioFilled") {
            print("water save")
            performReqForWater()
            
        } else if fertilizerRadioImg.image == UIImage(named: "radioFilled") {
            print("fertilizer save")
            performReqForFertilizer()
        }
    }
    
}

extension AddDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DropDownTableViewCellReuseId, for: indexPath) as! DropDownTableViewCell
        cell.dropDownLbl.text = items[indexPath.row]
        return cell
    }
    
    
}

extension AddDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        areaLbl.text = items[indexPath.row]
        dropdownTblView.isHidden = true
        transparentView.isHidden = true
    }
}
