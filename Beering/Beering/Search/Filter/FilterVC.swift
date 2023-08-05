//
//  FilterVC.swift
//  Beering
//
//  Created by YoonSub Lim on 2023/07/13.
//

import UIKit
import SwiftUI

class FilterVC: UIViewController {
    
    @IBOutlet var sortOptions: [UIButton]!
    @IBOutlet var liquorTypes: [UIButton]!
    
    @IBOutlet var filterOptionTitleViews: [UIView]!
    
    @IBOutlet weak var minimumPriceTextField: UITextField! {
        didSet { minimumPriceTextField?.addDoneButtonOnKeyboard() }
    }
    @IBOutlet weak var maximumPriceTextField: UITextField! {
        didSet { maximumPriceTextField?.addDoneButtonOnKeyboard() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for view in filterOptionTitleViews{
            view.titleViewInit()
        }
        
        for buttonView in sortOptions{
            buttonView.makeCircular()
        }
        
        for liquorBtn in liquorTypes{
            liquorBtn.addTarget(self, action: #selector(liquorTypeBtnTap), for: .touchUpInside)
        }
        
        minimumPriceTextField.delegate = self
        maximumPriceTextField.delegate = self
    }
    
    @IBAction func sortByBtnTapped(_ sender: UIButton) {
        print("sortByBtnTapped: \(sender.titleLabel?.text ?? "")")
        
        for sortBtn in sortOptions{
            sortBtn.backgroundColor = UIColor(named: "Gray03")
        }
        sender.backgroundColor = UIColor(named: "Beering_Black")
    }
    
    /// TODO index 방식 Refactoring
    @objc func liquorTypeBtnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        print("liquorTypeBtnTap")
        switch sender{
        case liquorTypes[0]:
            if sender.isSelected{
                sender.setImage(UIImage(named: "beer_filled"), for: .normal)
            }else{
                sender.setImage(UIImage(named: "beer_blank"), for: .normal)
            }
        case liquorTypes[1]:
            if sender.isSelected{
                sender.setImage(UIImage(named: "wine_filled"), for: .normal)
            }else{
                sender.setImage(UIImage(named: "wine_blank"), for: .normal)
            }
        case liquorTypes[2]:
            if sender.isSelected{
                sender.setImage(UIImage(named: "traditional_liquor_filled"), for: .normal)
            }else{
                sender.setImage(UIImage(named: "traditional_liquor_blank"), for: .normal)
            }
        default:
            print("default")
        }
    }
}

extension FilterVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 현재 입력된 문자열과 새로운 문자열을 합친 최종 문자열
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                
        if updatedString == "" {
            textField.text = updatedString
            return false
        }

        // 최종 문자열에서 숫자 부분만 추출 (콤마도 제거)
        let filteredString = updatedString.filter { "0123456789".contains($0) }
        
        if Int(filteredString) == 0{
            return false
        }
            
        // 숫자 포맷팅
        // 콤마를 추가하여 새로운 텍스트 설정
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3

        if let number = Int(filteredString), let formattedText = formatter.string(from: NSNumber(value: number)) {
            textField.text = formattedText
        }

        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //MARK: - minimum <= maximum ? Validation
        // minimum 입력시, minimum > maximum 이라면 maximum 을 99999+
        if textField == minimumPriceTextField{
            if var minimumPriceText = minimumPriceTextField.text, var maximumPriceText = maximumPriceTextField.text{
                
                minimumPriceText = minimumPriceText.filter { "0123456789".contains($0) }
                maximumPriceText = maximumPriceText.filter { "0123456789".contains($0) }
                
                if let minimumPrice = Int(minimumPriceText), let maximumPrice = Int(maximumPriceText) {
                    if minimumPrice > maximumPrice {
                        maximumPriceTextField.text = ""
                    }
                }
            }
        }
        // maximum 입력시, minimum > maximum 이라면 minimum 을 0
        else if textField == maximumPriceTextField{
            if var minimumPriceText = minimumPriceTextField.text, var maximumPriceText = textField.text {
                
                minimumPriceText = minimumPriceText.filter { "0123456789".contains($0) }
                maximumPriceText = maximumPriceText.filter { "0123456789".contains($0) }
                
                if let minimumPrice = Int(minimumPriceText), let maximumPrice = Int(maximumPriceText) {
                    if maximumPrice < minimumPrice {
                        minimumPriceTextField.text = ""
                    }
                }
            }
        }
        
    }
}

struct FilterSBPreView:PreviewProvider {
    static var previews: some View {
        UIStoryboard(name: "Filter", bundle: nil).instantiateInitialViewController()!.toPreview()
    }
}
