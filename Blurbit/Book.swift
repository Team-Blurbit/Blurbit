//
//  Book.swift
//  Blurbit
//
//  Created by user163612 on 4/29/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//
import Parse

class Book:PFObject,PFSubclassing{
    @NSManaged var author:String
    @NSManaged var title:String

    @NSManaged var isbn:String
    
    static func parseClassName() -> String {
        return "Book"
    }
    
    
}
