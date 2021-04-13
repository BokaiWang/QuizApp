//
//  QuizModel.swift
//  QuizApp
//
//  Created by 王柏凱 on 2020/12/28.
//

import Foundation

protocol QuizProtocol {
    
    func questionRetrieved(_ questions:[Question])
    
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        // Fetch the questions
        getRemoteJsonFile()
        
    }
   
    
    // This is how you get questions from a local Json file
    func getLocalJsonFile(){
        
        // Get bundle path to json file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        // Double check that the path isn't nil
        guard path != nil else {
            print("Couldn't find the json data file")
            return
        }
        
        // Creat URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            // Get the data from the url
            let data = try Data(contentsOf: url)
            
            // Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Notify the delegate of the parsed objects
            delegate?.questionRetrieved(array)
        }
        catch {
            // Error: Couldn't download the data at that URL
            print("Couldn't download the data at that URL")
        }
    }
    
    func getRemoteJsonFile(){
        
        // Get a URL object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Couldn't create the URL object")
            return
        }
        
        
        // Get a data task object
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            // Check that there wasn't an error
            if error == nil && data != nil {
                
                do {
                    // Create a JSON Decoder object
                    let decoder = JSONDecoder()
                    
                    // Parse the JSON
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    // Use the main thread to notify the view controller for UI work
                    DispatchQueue.main.async {
                        
                        // Notify the view controller
                        self.delegate?.questionRetrieved(array)
                        
                    }
               
                }
                catch {
                    print("Couldn't parse JSON")
                }
                
            }
          
        }
        
        // Call resume on the data task, which is basically going to kick off that datatask to go to that URL and download the data and it's gonna call the code inside the above closure
        dataTask.resume()
    }
}
