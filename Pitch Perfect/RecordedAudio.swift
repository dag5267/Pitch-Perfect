//
//  RecordedAudio.swift
//  Test
//
//  Created by Dwayne George on 3/10/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import Foundation

//create object that will be passed between views during suegue to pass file path and title information
class RecordedAudio: NSObject{
    var filePathUrl: NSURL! //file path to create file
    var title: String! //title of created file
    
    init(title: String, filePathUrl: NSURL)
    { //constructor
        self.filePathUrl = filePathUrl  //assign the data passed when the constructor is called
        self.title = title
    }
}