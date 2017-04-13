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

    @IBOutlet weak var status: UILabel!
    
    // flags
    @IBOutlet weak var fromFlag: UIImageView!
    @IBOutlet weak var toFlag: UIImageView!
    @IBOutlet weak var mainfromflag: UIImageView!
    @IBOutlet weak var maintoflag: UIImageView!
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var bgimg: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    
    @IBOutlet weak var picframe: UIImageView!
    var currentImage: UIImage!
    var helping: Bool = false
    var saveLang: Bool = false
    
    // cognitive variables
    // global Language
    var language = "en"
    
    var toLanguage = "en"
    
    var tlanguage = "en"
    
    var ttoLanguage = "en"
    
    
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
        
        if (mainfromflag != nil) && (maintoflag != nil){
        
        switch language {
        case "en":
            mainfromflag.image = #imageLiteral(resourceName: "canadian")
        case "it":
            mainfromflag.image = #imageLiteral(resourceName: "italian")
        case "de":
            mainfromflag.image = #imageLiteral(resourceName: "german")
        case "nl":
            mainfromflag.image = #imageLiteral(resourceName: "dutch")
        case "fr":
            mainfromflag.image = #imageLiteral(resourceName: "french")
        case "es":
            mainfromflag.image = #imageLiteral(resourceName: "spanish")
        case "ko":
            mainfromflag.image = #imageLiteral(resourceName: "greek")
        case "fi":
            mainfromflag.image = #imageLiteral(resourceName: "finnish")
        case "zh-Hans":
            mainfromflag.image = #imageLiteral(resourceName: "chinese")
        case "ja":
            mainfromflag.image = #imageLiteral(resourceName: "japanese")
        default:
            language = "en"
            mainfromflag.image = #imageLiteral(resourceName: "canadian")
            }
        switch toLanguage {
        case "en":
            maintoflag.image = #imageLiteral(resourceName: "canadian")
        case "it":
            maintoflag.image = #imageLiteral(resourceName: "italian")
        case "de":
            maintoflag.image = #imageLiteral(resourceName: "german")
        case "nl":
            maintoflag.image = #imageLiteral(resourceName: "dutch")
        case "fr":
            maintoflag.image = #imageLiteral(resourceName: "french")
        case "es":
            maintoflag.image = #imageLiteral(resourceName: "spanish")
        case "ko":
            maintoflag.image = #imageLiteral(resourceName: "greek")
        case "fi":
            maintoflag.image = #imageLiteral(resourceName: "finnish")
        case "zh-Hans":
            maintoflag.image = #imageLiteral(resourceName: "chinese")
        case "ja":
            maintoflag.image = #imageLiteral(resourceName: "japanese")
        default:
            language = "en"
            maintoflag.image = #imageLiteral(resourceName: "canadian")
        }
            }
       // maintoflag.image =
       // mainfromflag.image =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        picframe.image = #imageLiteral(resourceName: "frame")
        close.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        bgimg.image = #imageLiteral(resourceName: "bg")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func choosePhoto(_ sender: Any) {
        picframe.image = #imageLiteral(resourceName: "frame")
        close.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        bgimg.image = #imageLiteral(resourceName: "bg")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //UIImagePickerControllerSourceTypePhotoLibrary
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
        
        if (dictionary["regions"] != nil) {
            // Get Regions from the dictionary
            let regions = (dictionary["regions"] as! NSArray).firstObject as? [String:AnyObject]
            if (regions?["lines"] != nil) {
                // Get lines from the regions dictionary
                let lines = regions!["lines"] as! NSArray
        
        
                // TODO: Check if this works
        
                // Get words from lines
                let inLine = lines.enumerated().map {($0.element as? NSDictionary)?["words"] as! [[String : AnyObject]] }
        
                // Get text from words
                let extractedText = inLine.enumerated().map { $0.element[0]["text"] as! String}
            
                return extractedText
            } else {
                var extractedText = [String]()
                extractedText.append("** No text found **")
                return extractedText
            }
        } else {
            var extractedText = [String]()
            extractedText.append("** No text found **")
            return extractedText
        }
        
    }
    
    func translate(textIn: String) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyAWAR4UOWU4xYz5VaFZPivfyLySx-QjDg4" // Add your API Key here
        
        var params = ROGoogleTranslateParams()
        params.source = language
        params.target = toLanguage
        params.text = textIn
        translator.translate(params: params) { (result) in
            
            print(result)
            DispatchQueue.main.async {
                self.resultTextView.text = result
            }
            //self.resultTextView.text = String(result)
        }
    }
    
    func extractStringFromDictionary(_ dictionary: [String:AnyObject]) -> String {
        //let stringArray = try! extractStringsFromDictionary(dictionary)
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
                
                if text != "** No text found **" {
                    self.translate(textIn: text)
                }
            
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
    @IBAction func saveLanguage(_ sender: Any) {
        language = tlanguage
        toLanguage = ttoLanguage
        //status.text = "from " + language + " to " + toLanguage
        status.text = "Save: from \(language) to \(toLanguage)"
    }
    
    
    /* FLAGS ACTIONS */
    
    /* From */
    @IBAction func fromSpanish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "spanish")
        tlanguage = "es"
    }
    @IBAction func fromGerman(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "german")
        tlanguage = "de"
    }
    @IBAction func fromFinnish(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "finnish")
        tlanguage = "fi"

    }
    @IBAction func fromItalian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "italian")
        tlanguage = "it"

    }
    @IBAction func fromJapanese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "japanese")
        tlanguage = "ja"

    }
    @IBAction func fromFrench(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "french")
        tlanguage = "fr"

    }
    @IBAction func fromGreek(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "greek")
        tlanguage = "ko"
    }
    @IBAction func fromDutch(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "dutch")
        tlanguage = "nl"

    }
    @IBAction func fromChinese(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "chinese")
        tlanguage = "zh-Hans"

    }
    @IBAction func fromCanadian(_ sender: Any) {
        fromFlag.image = #imageLiteral(resourceName: "canadian")
        tlanguage = "en"

    }
    
    /* TO */
    @IBAction func toSpanish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "spanish")
        ttoLanguage = "es"
    }
    @IBAction func toGerman(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "german")
        ttoLanguage = "de"
    }
    @IBAction func toFinnish(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "finnish")
        ttoLanguage = "fi"
    }
    
    @IBAction func toItalian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "italian")
        ttoLanguage = "it"
        
    }
    
    @IBAction func toJapanese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "japanese")
        ttoLanguage = "ja"
    }
    
    @IBAction func toFrench(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "french")
        ttoLanguage = "fr"
    }
    
    @IBAction func toGreek(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "greek")
        ttoLanguage = "ko"
    }
    
    @IBAction func toDutch(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "dutch")
        ttoLanguage = "nl"
    }
    
    @IBAction func toChinese(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "chinese")
        ttoLanguage = "zh-Hans"
    }
    
    @IBAction func toCanadian(_ sender: Any) {
        toFlag.image = #imageLiteral(resourceName: "canadian")
        ttoLanguage = "en"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue",
            let destination = segue.destination as? ViewController {
            destination.language = tlanguage
            destination.toLanguage = ttoLanguage
        }
    }

}

