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
    
    @IBAction func go(_ sender: UIButton) {
        
        if _is_communicating {
        
            _write_data = "1"
        
            _ble.write(data: _write_data!.data(using: .ascii)!)
        
        }
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        if _is_communicating {
            
            _write_data = "2"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    @IBAction func right(_ sender: UIButton) {
        
        if _is_communicating {
            
            _write_data = "3"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    @IBAction func left(_ sender: UIButton) {
        
        if _is_communicating {
            
            _write_data = "4"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    private var _address = ""
    
    private var _ble_central: HBCentral!
    
    private var _ble: HBPeripheral!
    
    private var _write_data: String?
    
    private var _is_communicating: Bool = false
    
    //start bluetooth connect
    
    @IBAction func startConnected(_ sender: UIButton) {
        
        _address = "HC-08"
        
        _ble_central = HBCentral(delegate: self, timeOutInterval: TimeInterval(5.0), autoConnect: true)
        
        _ble_central.expect(name: _address)
        
        print("連接藍芽名稱：\(_address)")
        
    }
    
    //MARK: - HBCentralDelegate
    
    func readyToScan() {
        
        _ble_central.scan()
        
    }
    
    func readyForConnect(peripheral: CBPeripheral, willAutoConnect will_auto_connect: Bool) {
        
        if will_auto_connect {
            
            return
            
        }
        
    }
    
    func connected(peripheral: CBPeripheral) {
        
        _ble = HBPeripheral(peripheral: peripheral, delegate: self)
        
        _ble.setCommunicateCharacteristic(service: CBUUID(string: "FFE0"), characteristic: CBUUID(string: "FFE1"))
        
    }
    
    func scanningTimeOut(peripherals: Set<String>) {
        
        if peripherals.contains(_address) {
            
            let alert = UIAlertController(title: _address, message: NSLocalizedString("連線逾時", comment: "time out"), preferredStyle: .alert)
            
            let rescan = UIAlertAction(title: NSLocalizedString("重新連線", comment: "reconnect") , style: .default) { _ in
                
                self._ble_central.scan()
                
            }
            
            let cancel_action = UIAlertAction(title: NSLocalizedString("取消", comment: "cancel"), style: .cancel) { _ in
                
                self._address = ""
                
            }
            
            alert.addAction(rescan)
            
            alert.addAction(cancel_action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //MARK: - HBPeripheralDelegate
    
    func readyForCommunicate(peripheral: HBPeripheral) {
        
        _is_communicating = true
        
        print("readyForCommunicate")
        
    }
    
    func receive(peripheral: HBPeripheral, data: Data?, fromCharacteristic characteristic: CBCharacteristic) {
        
        print(data)
        
    }

}

