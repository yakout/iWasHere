//
//  Place.swift
//  iWasHere
//
//  Created by Ahmed Yakout on 8/14/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import Foundation


class Place {
    private var name: String
    private var memories: [Memory]
    
    init(name: String, memories: [Memory]) {
        self.name = name
        self.memories = memories
    }
    
    func getPlaceName() -> String {
        return self.name
    }
    
    func getPlaceMemories() -> [Memory] {
        return self.memories
    }
    
    func addMemory(memory: Memory) {
        self.memories.append(memory)
    }
    
    func deleteMemory(index: Int) {
        self.memories.removeAtIndex(index)
    }
}