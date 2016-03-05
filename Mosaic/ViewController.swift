//
//  ViewController.swift
//  Mosaic
//
//  Created by Ashif Khan on 10/02/16.

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnMosaic: UIButton!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrView: UIScrollView!
    //// An array of images for creating mosaik patteren
    //var fromImages:Array<UIImage>=Array<UIImage>()
    var toggleImage:Bool=true
    var pattern:UIImage?
    var mainImage:UIImage?
    //var imageView:UIImageView?
    /*override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //// let us create an image view which will be
        //// used to show before and after effects
        imageView=UIImageView.init(frame:self.view.frame)
        
        
        /// setup a button which will work as a toggle
        let btnGenerate=UIButton(type: .Custom)
        btnGenerate.setTitle("Generate", forState: .Normal)
        btnGenerate.addTarget(self, action: "generate:", forControlEvents: .TouchUpInside)
        btnGenerate.frame = CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height-60, 150, 30)
        
        //// Here is the desired pattren for which mosaic will be created
        mainImage=UIImage(named: "sachinTwo.png")
        
        ///show the basic pattern on the imageview
        imageView?.image = mainImage
        
        
        //pattern = Mosaic.generateMosaik(fromImages, forImage: mainImage!)
        
        
        //// add the imageview as a subview to self.view
        self.view.addSubview(imageView!)
        self.view.addSubview(btnGenerate)
        //self.fromImages.removeAll()
        
    }
    func generate(sender:UIButton){
        if toggleImage {
            if pattern == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { // 1
                    for(var i=1;i<121;i++){
                        self.fromImages.append(UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("\(i).png", ofType: "")!)!)
                    }
                    ///generate mosaic on pattern with support images
                    self.pattern = Mosaic.generateMosaik(self.fromImages, forImage: self.mainImage!, forScaleSize: 1.0)
                    //// get the image data and save it inside document folder
                    //// the saved image can later be used to share
                    let imageData = NSData(data:UIImagePNGRepresentation(self.pattern!)!)
                    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let docs: String = paths[0]
                    let fullPath = docs + "/yourNameImg.png"
                    let result = imageData.writeToFile(fullPath, atomically: true)
                    print(fullPath)
                    print(result)
                    dispatch_async(dispatch_get_main_queue()) { // 2
                        //// set pattern as the image for the imageview
                        self.imageView?.image = self.pattern
                        self.fromImages.removeAll()
                    }
                }
            }else {
                imageView?.image = pattern
            }
        }else{
            imageView?.image = mainImage
        }
        toggleImage = !toggleImage
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { // 1
            Mosaic.getInstance().fillSourceImage()
        }
        
        self.imageView?.userInteractionEnabled = true
        
        //// Here is the desired pattren for which mosaic will be created
        mainImage=UIImage(named: "sachinTwo.png")
        
        ///show the basic pattern on the imageview
        self.imageView?.image = mainImage
        
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @IBAction func generatePattern(sender:AnyObject){
        if toggleImage {
            if pattern == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { // 1
                    
                    //Mosaic.getInstance().fillSourceImage()
                    
                    ///generate mosaic on pattern with support images
                    self.pattern = Mosaic.getInstance().generateMosaik(self.mainImage!, forScaleSize: 2.0)
                    //// get the image data and save it inside document folder
                    //// the saved image can later be used to share
                    let imageData = NSData(data:UIImagePNGRepresentation(self.pattern!)!)
                    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let docs: String = paths[0]
                    let fullPath = docs + "/yourNameImg.png"
                    let result = imageData.writeToFile(fullPath, atomically: true)
                    print(fullPath)
                    print(result)
                    dispatch_async(dispatch_get_main_queue()) { // 2
                        //// set pattern as the image for the imageview
                        self.imageView?.image = self.pattern
                    }
                }
            }else {
                imageView?.image = pattern
            }
        }else{
            imageView?.image = mainImage
        }
        toggleImage = !toggleImage
    }
    
    @IBAction func capture(sender:UIButton){
        let sheet:UIAlertController = UIAlertController(title: "Choose photo", message: "Source", preferredStyle: .ActionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            let pickerController:UIImagePickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Gallery", style: .Default, handler: {
            action in
            let pickerController:UIImagePickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
        }))
        sheet.popoverPresentationController?.sourceView = self.btnCapture
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.mainImage = image //editingInfo![UIImagePickerControllerOriginalImage] as? UIImage
        self.pattern = nil
        self.imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.pattern = nil
    }


}

