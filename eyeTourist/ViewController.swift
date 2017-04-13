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
    
    @IBOutlet weak var picframe: UIImageView!
    var currentImage: UIImage!
    var helping: Bool = false
    
    // cognitive variables
    // global Language
    var language = "en"
    
    var toLanguage = "en"
    
    
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
        picframe.image = #imageLiteral(resourceName: "frame")
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
        if (currentImage != nil){
            try! recognizeCharactersWithRequestObject(completion: { (response) in
            
                let text = self.extractStringFromDictionary(response!)
                self.resultTextView.text = text
            
            })
        } else {
            resultTextView.text = "** No image detected **"
        }

    }
    @IBAction func close(_ sender: UIButton) {
        close.setBackgroundImage(#imageLiteral(resourceName: "close-off"), for: .normal)
        imageView.image = nil
        bgimg.image = #imageLiteral(resourceName: "bg")
        resultTextView.text = ""
        if helping {
            helping = false
        }
        currentImage = nil
        picframe.image = nil
    }
    
    
    /* FLAGS ACTIONS */
    
    /* From */
    @IBAction func fromSpanish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "spanish")
        language = "es"
    }
    @IBAction func fromGerman(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "german")
        language = "de"
    }
    @IBAction func fromFinnish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "finnish")
        language = "fi"

    }
    @IBAction func fromItalian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "italian")
        language = "it"

    }
    @IBAction func fromJapanese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "japanese")
        language = "ja"

    }
    @IBAction func fromFrench(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "french")
        language = "fr"

    }
    @IBAction func fromGreek(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "greek")
        language = "el"
    }
    @IBAction func fromDutch(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "dutch")
        language = "da"

    }
    @IBAction func fromChinese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "chinese")
        language = "zh-Hans"

    }
    @IBAction func fromCanadian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "canadian")
        language = "en"

    }
    
    /* TO */
    @IBAction func toSpanish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "spanish")
        toLanguage = "es"
    }
    @IBAction func toGerman(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "german")
        toLanguage = "de"
    }
    @IBAction func toFinnish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "finnish")
        toLanguage = "fi"
    }
    
    @IBAction func toItalian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "italian")
        toLanguage = "it"
        
    }
    
    @IBAction func toJapanese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "japanese")
        toLanguage = "ja"
    }
    
    @IBAction func toFrench(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "french")
        toLanguage = "fr"
    }
    
    @IBAction func toGreek(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "greek")
        toLanguage = "el"
    }
    
    @IBAction func toDutch(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "dutch")
        toLanguage = "da"
    }
    
    @IBAction func toChinese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "chinese")
        toLanguage = "zh-Hans"
    }
    
    @IBAction func toCanadian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "canadian")
        toLanguage = "en"
    }
    
    @IBAction func helpbtn(_ sender: Any) {
        if (helping){
            helping = false
            bgimg.image = #imageLiteral(resourceName: "bg")
            
        } else {
            helping = true
            bgimg.image = #imageLiteral(resourceName: "helpbg")
        }
        
    }

}

