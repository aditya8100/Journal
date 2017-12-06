//
//  EditViewController.swift
//  Journal
//
//  Created by Aditya Deepak on 11/30/17.
//  Copyright © 2017 Aditya Deepak. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    var userDescription = ""
    var place: Place!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = userDescription
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let placeData: [String: Any] = ["userDescription": textView.text]
        DataService.instance.savePlace(placeData: placeData, place: place)
        dismiss(animated: true, completion: nil)
    }
}
