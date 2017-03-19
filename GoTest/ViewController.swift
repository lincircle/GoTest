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

class ViewController: UIViewController, HBCentralDelegate, HBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var btn_go: UIButton!
    
    @IBOutlet var btn_back: UIButton!
    
    @IBOutlet var btn_left: UIButton!
    
    @IBOutlet var btn_right: UIButton!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var btn_connect: UIButton!
    
    @IBAction func go(_ sender: UIButton) {
        
        if _can_communicate {
        
            _write_data = "1"
        
            _ble.write(data: _write_data!.data(using: .ascii)!)
        
        }
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        if _can_communicate {
            
            _write_data = "2"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    @IBAction func right(_ sender: UIButton) {
        
        if _can_communicate {
            
            _write_data = "3"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    @IBAction func left(_ sender: UIButton) {
        
        if _can_communicate {
            
            _write_data = "4"
            
            _ble.write(data: _write_data!.data(using: .utf8)!)
            
        }
        
    }
    
    private var _address = ""
    
    private var _ble_central: HBCentral!
    
    private var _ble: HBPeripheral!
    
    private var _write_data: String?
    
    private var _can_communicate: Bool = false
    
    private var _ready_to_connect: [HBPeripheral] = []
    
    private var _timer: Timer?
    
    private var _connect_peripheral: HBPeripheral?
    
    var toolBar = UIToolbar()
    
    var myPickerView = UIPickerView()
    
    //start bluetooth connect
    
    @IBAction func startConnected(_ sender: UIButton) {
        
        chooseBT()
        
    }
    
    func chooseBT() {
        
        let fullScreenSize = UIScreen.main.bounds.size
        
        myPickerView = UIPickerView(frame: CGRect(x: 0, y: fullScreenSize.height * 0.7, width: fullScreenSize.width, height: 150))
        
        myPickerView.dataSource = self
        
        myPickerView.delegate = self
        
        self.view.addSubview(myPickerView)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: fullScreenSize.height * 0.7 - 50, width: fullScreenSize.width, height: 50))
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.isTranslucent = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.hideKeyboard))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        self.view.addSubview(toolBar)
        
    }
    
    override func viewDidLoad() {
        
        _ble_central = HBCentral(delegate: self, timeOutInterval: TimeInterval(5.0), autoConnect: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(sender:)))
        
        tapGesture.numberOfTapsRequired = 1
        
        btn_go.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(normalTap(sender:))))
        
        btn_go.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:))))
        
        btn_back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(normalTap(sender:))))
        
        btn_back.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:))))
        
        btn_left.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(normalTap(sender:))))
        
        btn_left.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:))))
        
        btn_right.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(normalTap(sender:))))
        
        btn_right.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:))))
        
        btn_connect.layer.cornerRadius = 15.0
        
        btn_connect.clipsToBounds = true
        
    }
    
    //MARK: - HBCentralDelegate
    
    func readyToScan() {
        
        _ble_central.scan()
        
    }
    
    func readyForConnect(peripheral: CBPeripheral, willAutoConnect will_auto_connect: Bool) {
        
        if will_auto_connect {
            
            return
            
        }
        
        _ready_to_connect.append(HBPeripheral(peripheral: peripheral, delegate: self))
        
    }
    
    func connected(peripheral: CBPeripheral) {
        
        _ble = HBPeripheral(peripheral: peripheral, delegate: self)
        
        _ble.setCommunicateCharacteristic(service: CBUUID(string: "FFE0"), characteristic: CBUUID(string: "FFE1"))
        
        label.text = "已連接上\(_connect_peripheral!.peripheral.name!)"
        
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
        
        _can_communicate = true
        
        print("readyForCommunicate")
        
    }
    
    func receive(peripheral: HBPeripheral, data: Data?, fromCharacteristic characteristic: CBCharacteristic) {
        
        print("data")
        
    }
    
    //手勢部分
    
    func normalTap(sender: UIGestureRecognizer) {
        
        print("normalTap")
        
        if _recognize(gusture: sender, isIn: btn_go) {
            
            _write_data = "1"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_back) {
            
            _write_data = "2"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_right) {
            
            _write_data = "3"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_left) {
            
            _write_data = "4"
            
            BTDate()
            
        }
        
    }
    
    func longPress(sender: UIGestureRecognizer) {
        
        if _recognize(gusture: sender, isIn: btn_go) {
            
            _write_data = "1"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_back) {
            
            _write_data = "2"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_right) {
            
            _write_data = "3"
            
            BTDate()
            
        }
        else if _recognize(gusture: sender, isIn: btn_left) {
            
            _write_data = "4"
            
            BTDate()
            
        }
        
        print("Long tap")
        
    }
    
    private func _recognize(gusture: UIGestureRecognizer, isIn view: UIView) -> Bool {
    
        let location = gusture.location(in: view)
        
        let frame = view.frame
        
        return (location.x <= frame.width) && (location.y <= frame.height)
    
    }
    
    // timer setting
    
    func BTDate() {
        
        print("傳送資料\(_write_data)")
        
        _ble.write(data: _write_data!.data(using: .ascii)!)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return _ready_to_connect.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return _ready_to_connect[row].peripheral.name!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        _connect_peripheral = _ready_to_connect[row]
        
    }
    
    func hideKeyboard() {
        
        self.view.endEditing(true)
        
        self.myPickerView.isHidden = true
        
        self.toolBar.isHidden = true
        
        if _connect_peripheral == nil {
            
            let alert = UIAlertController(title: "請選擇欲連接藍芽", message: nil, preferredStyle: .alert)
            
            let alert_btn = UIAlertAction(title: "關閉", style: .default) { _ in
                
                self.chooseBT()
                
            }
            
            alert.addAction(alert_btn)
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            return
            
        }
        
        _ble_central.connect(peripheral: _connect_peripheral!.peripheral)
        
    }

}

