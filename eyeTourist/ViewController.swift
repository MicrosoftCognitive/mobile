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

    
    // flags
    @IBOutlet weak var fromFlag: UIImageView!
    @IBOutlet weak var toFlag: UIImageView!
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var bgimg: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    
    var currentImage: UIImage!
    var helping: Bool = false
    
    // cognitive variables
    // global Language
    var language = "it"
    
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
        
        //toFlag.image = #imageLiteral(resourceName: "canadian")
        //fromFlag.image = #imageLiteral(resourceName: "canadian")
        
        //imageView.image = #imageLiteral(resourceName: "IMG_1364")
        //currentImage = #imageLiteral(resourceName: "IMG_1364")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        close.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        bgimg.image = #imageLiteral(resourceName: "bgp")
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
               // print("Error -> \(error)")
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
        bgimg.image = #imageLiteral(resourceName: "bgr")
        //let requestObject: OCRRequestObject = (resource: UIImagePNGRepresentation(UIImage(named: "ocrDemo")!)!, language: .Automatic, detectOrientation: true)
        try! recognizeCharactersWithRequestObject(completion: { (response) in
            
            let text = self.extractStringFromDictionary(response!)
            self.resultTextView.text = text
            
        })

    }
    @IBAction func close(_ sender: UIButton) {
        close.setBackgroundImage(#imageLiteral(resourceName: "close-off"), for: .normal)
        imageView.image = nil
        bgimg.image = #imageLiteral(resourceName: "bg")
    }
    
    
    /* FLAGS ACTIONS */
    
    /* From */
    @IBAction func fromSpanish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "spanish")
    }
    @IBAction func fromGerman(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "german")

    }
    @IBAction func fromFinnish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "finnish")

    }
    @IBAction func fromItalian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "italian")

    }
    @IBAction func fromJapanese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "japanese")

    }
    @IBAction func fromFrench(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "french")

    }
    @IBAction func fromGreek(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "greek")

    }
    @IBAction func fromDutch(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "dutch")

    }
    @IBAction func fromChinese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "chinese")

    }
    @IBAction func fromCanadian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "canadian")

    }
    
    /* TO */
    @IBAction func toSpanish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "spanish")
    }
    @IBAction func toGerman(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "german")
    }
    /*
    @IBAction func toFinnish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "finnish")
    }
    @IBAction func toItalian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "italian")
    }
    @IBAction func toJapanese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "japanese")
    }
     */
    @IBAction func toFinnish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "finnish")
    }
    
    @IBAction func toItalian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "italian")
    }
    
    @IBAction func toJapanese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "japanese")
    }
    
    @IBAction func toFrench(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "french")
    }
    
    @IBAction func toGreek(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "greek")
    }
    
    @IBAction func toDutch(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "dutch")
    }
    
    @IBAction func toChinese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "chinese")
    }
    
    @IBAction func toCanadian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "canadian")
    }
    
    @IBAction func helpbtn(_ sender: Any) {
        if (helping){
            helping = false
            bgimg.image = #imageLiteral(resourceName: "bgr")
            
        } else {
            helping = true
            bgimg.image = #imageLiteral(resourceName: "helpbg")
        }
        
    }

}

