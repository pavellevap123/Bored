//
//  ViewController.swift
//  Bored
//
//  Created by Pavel Paddubotski on 11.09.21.
//

import UIKit
import Alamofire
import SPAlert
import RealmSwift

class ViewController: UIViewController {
    
    var toolBar = UIToolbar()
    let picker  = UIPickerView()
    let requstTypes = ["education", "recreational", "social", "diy", "charity", "cooking", "relaxation", "music", "busywork"]
    let types = ["Education", "Recreational", "Social", "DIY", "Charity", "Cooking", "Relaxation", "Music", "Busywork"]
    var urlString = "https://www.boredapi.com/api/activity/"
    let realm = (UIApplication.shared.delegate as! AppDelegate).realm!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        configurePickerView()
        activityIndicator.isHidden = true
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(self.picker)
            self.view.addSubview(self.toolBar)
        })
    }
    
    @IBAction func addToLibraryPressed(_ sender: UIButton) {
        
        SPAlert.present(title: "Added to Library", preset: .done)
        let task = Tasks()
        task.title = label.text!
        do {
            try realm.write {
                realm.add(task)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func makeBasicRequest(_ sender: UIButton) {
        
        request(urlString: urlString)
    }
    
    private func configurePickerView() {
        
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.backgroundColor = UIColor(named: "MyColor")
        picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        
        toolBar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50)
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonPressed))
        toolBar.setItems([flexButton, doneButton], animated: true)
        toolBar.sizeToFit()
    }
    
    private func request(urlString: String) {
        showActivityIndicator()
        AF.request(urlString).responseJSON { response in
            if let data =  response.data {
                let decoder = JSONDecoder()
                do {
                    let boredObj = try decoder.decode(Bored.self, from: data)
                    self.label.text = boredObj.activity
                    self.hideActivityIndicator()
                } catch let error as NSError {
                    print(error)
                    self.hideActivityIndicator()
                    self.label.text = "Error occured. Please, try later."
                }
            }
        }
    }
    
    func showActivityIndicator() {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.label.isHidden = true
        }
    }
    
    func hideActivityIndicator() {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.label.isHidden = false
        }
    }
    
    @objc func onDoneButtonPressed() {
        
        let newUrlString = urlString + "?type=" + requstTypes[picker.selectedRow(inComponent: 0)]
        request(urlString: newUrlString)
        
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
        })
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
}

