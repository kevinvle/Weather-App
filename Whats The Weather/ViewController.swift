//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Kevin Le on 2/22/17.
//  Copyright © 2017 Kevinvle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func getWeather(_ sender: AnyObject) {
        
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            // Force unwrapped url because I created the string myself and know it's going to work. To deal with the issue that the user may enter a city name that causes this url to be an invalid url (space or strange char). Because we used a force unwrap at the end, we told xcode that it'll be fine and if the user added a bad char, we'll get a crash. To fix this, we add a "if" at the beginning. We'll only run ALL of this code if we get a valid url. If we can't, then we'll give an error message "resultLabel.text = "the weather...""
        
        let request = NSMutableURLRequest(url: url) // Create a request using url of url
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { // Create our task and cast that as a URLRequest
            data, response, error in
            
            var message = ""
            
            if error != nil {
                
                print(error) // If there is an error, print the error
                
            } else {
                
                if let unwrappedData = data { // Else, create a variable named unwrappedData which is = to Data which means we got some data.
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Create a data string from it. NSString created from some data.
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    // Backslash \ before the " in our string to tell xcode that the " is part of the string and that it shouldn't end the string. CHANGED LET TO VAR
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 { // Count will always be greater than 0 because we'll at least have one item in the array
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator) // 1 is index out of range
                            
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "%deg", with: "°")
                                
                                print(message)
                                
                                
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
            
            if message == "" {
                
                message = "The weather there couldn't be found. Please try again."
            }
            
            DispatchQueue.main.sync(execute: { // Dispatch queue and display our text as soon as it's ready
                
                self.resultLabel.text = message // use "self" when you want to refer to something outside of that closure - in this case resultLabel. You use self to reference the view controller.
                
            })
            
        }
        
        task.resume()
        
    } else {
    
        resultLabel.text = "The weather there couldn't be found. Please try again." // No need for "self." because we're not inside the closure or task. We're outside of it.
    }
    
}


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

