//
//  ViewController.swift
//  GoTest
//
//  Created by Yuhsuan Lin on 2017/2/25.
//  Copyright © 2017年 Yuhsuan Lin. All rights reserved.
//

import UIKit
import CoreBluetooth
import HBFramework

class ViewController: UIViewController, HBCentralDelegate, HBPeripheralDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - HBCentralDelegate
    
    func readyToScan() {
        
        
    }
    
    func readyForConnect(peripheral: CBPeripheral, willAutoConnect will_auto_connect: Bool) {
        
        
    }
    
    func connected(peripheral: CBPeripheral) {
        
        
    }
    
    func scanningTimeOut(peripherals: Set<String>) {
        
        
    }

    //MARK: - HBPeripheralDelegate
    
    func readyForCommunicate(peripheral: HBPeripheral) {
        
        
    }
    
    func receive(peripheral: HBPeripheral, data: Data?, fromCharacteristic characteristic: CBCharacteristic) {
        
        
    }

}

