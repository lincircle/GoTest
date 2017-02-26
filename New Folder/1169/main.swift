//
//  main.swift
//  1169
//
//  Created by Yuhsuan Lin on 2016/12/27.
//  Copyright © 2016年 cgua. All rights reserved.
//

import Foundation

while true {
    
    print("請輸入閃電數字 --> ")
    
    guard let typed = readLine() else {
        
        continue
        
    }
    
    guard let num = Int(typed) else {
        
        continue
        
    }
    
    var number = num
    
    print("number : \(number)")
    
    for i in 1...number {
        
        if number-i == 0 {
            
            continue
            
        }
        
        for j in 1...number-i {
            
            print("X", terminator: " ")
            
        }
        
        for k in 1...i {
            
            print("O", terminator: " ")
        }
        
        print("")
        
    }
    
    for p in 1...number*2 {
        
        print("O", terminator: " ")
        
    }
    
    print("")
    
    for i in 1...number {
        
        for j in 1...number {
        
            print("X", terminator: " ")
        
        }
        
        if number-i == 0 {
            
            continue
            
        }
        
        for k in 1...number-i {
            
            print("O", terminator: " ")
            
        }
        
        print("")
        
    }
    
    break
    
}

