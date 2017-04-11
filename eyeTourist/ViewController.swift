//
//  ViewController.swift
//  eyeTourist
//
//  Created by A S on 4/10/17.
//  Copyright © 2017 com.ignitedcodes. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    
    var currentImage: UIImage!
    
    //cognitive variables
    var language = "unk"
    
    /// Request URL
    let url = "https://westus.api.cognitive.microsoft.com/vision/v1.0/ocr"
    
    /// API Key
    let key = "f2012cf6ac594d59866ba0d4442387c9"
    
    /// Detectable Languages
    enum Langunages: String {
        case Automatic = "unk"
        case ChineseSimplified = "zh-Hans"
        case ChineseTraditional = "zh-Hant"
        case Czech = "cs"
        case Danish = "da"
        case Dutch = "nl"
        case English = "en"
        case Finnish = "fi"
        case French = "fr"
        case German = "de"
        case Greek = "el"
        case Hungarian = "hu"
        case Italian = "it"
        case Japanese = "Ja"
        case Korean = "ko"
        case Norwegian = "nb"
        case Polish = "pl"
        case Portuguese = "pt"
        case Russian = "ru"
        case Spanish = "es"
        case Swedish = "sv"
        case Turkish = "tr"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "IMG_1364")
        currentImage = #imageLiteral(resourceName: "IMG_1364")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        currentImage = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.image = currentImage
       // imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func recognizeCharactersWithRequestObject( completion: @escaping (_ response: [String:AnyObject]? ) -> Void) throws {
        
        // Generate the url
        let requestUrlString = url + "?language=" + language + "&detectOrientation%20=true"
        let requestUrl = URL(string: requestUrlString)
        
        
        var request = URLRequest(url: requestUrl!)
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = UIImageJPEGRepresentation(currentImage, 1.0);
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(nil)
                return
            }else{
                let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                // Hand dict over
                DispatchQueue.main.async {
                    completion(results)
                }
               // print (results)
            }
            
        }
        task.resume()
        
        //print (result)
    }
    
    func extractStringsFromDictionary(_ dictionary: [String : AnyObject]) -> [String] {
        
        // Get Regions from the dictionary
        let regions = (dictionary["regions"] as! NSArray).firstObject as? [String:AnyObject]
        
        // Get lines from the regions dictionary
        let lines = regions!["lines"] as! NSArray
        
        
        // TODO: Check if this works
        
        // Get words from lines
        let inLine = lines.enumerated().map {($0.element as? NSDictionary)?["words"] as! [[String : AnyObject]] }
        
        // Get text from words
        let extractedText = inLine.enumerated().map { $0.element[0]["text"] as! String}
        
        return extractedText
    }
    
    func extractStringFromDictionary(_ dictionary: [String:AnyObject]) -> String {
        
        let stringArray = extractStringsFromDictionary(dictionary)
        
        let reducedArray = stringArray.enumerated().reduce("", {
            $0 + $1.element + ($1.offset < stringArray.endIndex-1 ? " " : "")
        }
        )
        return reducedArray
    }
    
    @IBAction func translatebtn(_ sender: UIButton) {
        
        //let requestObject: OCRRequestObject = (resource: UIImagePNGRepresentation(UIImage(named: "ocrDemo")!)!, language: .Automatic, detectOrientation: true)
        try! recognizeCharactersWithRequestObject(completion: { (response) in
            
            let text = self.extractStringFromDictionary(response!)
            self.resultTextView.text = text
            
        })

    }

}

