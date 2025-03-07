//
//  ItemModel.swift
//  Priority
//
//  Created by Alex on 2/26/25.
//

import Foundation

class Item: Identifiable, Codable{
    let id: UUID
    private var title: String
    private var content: String
    private var isCompleted: Bool
    
    
    // Initializes the item
    init(title: String, isCompleted: Bool = false, content: String = ""){
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.content = content
    }
    
    
    // Title functions
    func getTitle() -> String {         // Returns the title
        return self.title
    }
    func setTitle(input: String){       // Sets the title
        self.title = input
    }
    
    
    // Content functions
    func getContent() -> String {       // Returns the content
        return self.content
    }
    func setContent(input: String){     // Sets the content
        self.content = input
    }
    
    
    // isCompleted functions
    func completed() -> Bool {          // Returns whether the item is completed or not
        return self.isCompleted;
    }
    func setCompleted(input: Bool){     // Sets the completed status to a specifc value
        self.isCompleted = input        // (if you need it to be true, whether or not it already was)
    }
    func toggleCompleted(){             // Toggles the completed status
        if(self.isCompleted){
            self.isCompleted = false
        }
        else{
            self.isCompleted = true
        }
    }
}
