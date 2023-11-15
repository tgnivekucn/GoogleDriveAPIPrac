//
//  ViewController.swift
//  GoogleDriveAPIPrac
//
//  Created by 粘光裕 on 2023/11/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let data = UIImage(named: "testImage2")?.jpegData(compressionQuality: 1) {
            GoogleDriveAPIManager.shared.testUploadFile(imageData: data)
        }
    }


}

