//
//  Bluno.swift
//  GoTest
//
//  Created by Yuhsuan Lin on 2017/2/26.
//  Copyright © 2017年 Yuhsuan Lin. All rights reserved.
//

import Foundation
import HBFramework
import CoreBluetooth

class Bluno: HBPeripheral {
    
    override init(peripheral: CBPeripheral, delegate: HBPeripheralDelegate) {
        
        super.init(peripheral: peripheral, delegate: delegate)
        
        self.setCommunicateCharacteristic(service: CBUUID(string: "DFB0"), characteristic: CBUUID(string: "DFB1"))
        
    }
}
