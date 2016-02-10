//
//  ViewController.swift
//  Mosaic
//
//  Created by Ashif Khan on 10/02/16.

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageView:UIImageView=UIImageView.init(frame:self.view.frame)
        var fromImages:Array<UIImage>=Array<UIImage>()
        for(var i=1;i<121;i++){
            fromImages.append(UIImage(named: "\(i).png")!)
        }
        let forImage=UIImage(named: "sachinTwo.png")
        imageView.image = Mosaic.generateMosaik(fromImages, forImage: forImage!)
        self.view.addSubview(imageView)
        let imageData = NSData(data:UIImagePNGRepresentation(imageView.image!)!)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docs: String = paths[0]
        let fullPath = docs + "/yourNameImg.png"
        let result = imageData.writeToFile(fullPath, atomically: true)
        print(fullPath)
        print(result)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

