//
//  ViewController.swift
//  FiO
//
//  Created by admin on 30.07.2022.
//

import UIKit

class CurrencyViewController: UIViewController{
    
    @IBOutlet weak var sourcePickerView: UIPickerView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var targetPickerView: UIPickerView!
    @IBOutlet weak var sourceStackView: UIStackView!
    
    let currencyManager = CurrencyManager()
    var sourcePickerIndex = 0
    var targetPickerIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.currencyDelegate = self
        sourcePickerView.dataSource = self
        sourcePickerView.delegate = self
        targetPickerView.dataSource = self
        targetPickerView.delegate = self
        
    
        let asdButton = UIButton(frame: .init(x: 0, y: 0, width: sourceStackView.frame.width, height: 50))
        asdButton.setTitle("Select Currency", for: .normal)
        asdButton.titleLabel?.textColor = .black
        
    }
    
    
    @IBAction func exchangeButtonPressed(_ sender: UIButton) {
        
        if let amount = Double(sourceTextField.text!){
            let source = currencyManager.currencies[sourcePickerIndex]
            let target = currencyManager.currencies[targetPickerIndex]
            currencyManager.performRequest(from: source, to: target, for: amount)
        }else{
            let search = sourceTextField.text!.uppercased()
            let newArray = currencyManager.currencies.filter({
                $0.contains(search)
            })
            print(newArray)
            sourceTextField.text = ""
            sourceTextField.placeholder = "Enter a valid number"
        }
    }
}

//MARK: - CurrencyDelegate 
extension CurrencyViewController: CurrencyDelegate{
    
    func updateCurrency(_ value: Double) {
            DispatchQueue.main.async {
                self.targetTextField.text = String(format: "%.2f", value)
            }
    }
}

    //MARK: - PickerView Methods
extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
           return .init(string: currencyManager.currencies[row], attributes: [.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sourcePickerView{
            sourcePickerIndex = row
        }
        targetPickerIndex = row
    }
}
