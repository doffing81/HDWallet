//
//  SMP+Bitcoin.swift
//

import Foundation

extension BInt {
    init(hex: String) {
        self.init(number: hex.lowercased(), withBase: 16)!
    }
    
    func hex() -> String {
        return self.asString(withBase: 16)
    }
    
    // Used namely for HD wallet serialization
    func atLeast4ByteHex() -> String {
        let hex = self.asString(withBase: 16)
        if hex.count < 8 {
            var newHex = hex
            while newHex.count < 8 { newHex.insert("0", at: newHex.startIndex) }
            return newHex
        }
        return hex
    }
    
    var data: Data {
        let count = limbs.count
        var data = Data(count: count * 8)
        data.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<UInt8>) -> Void in
            var p = pointer
            for i in (0..<count).reversed() {
                for j in (0..<8).reversed() {
                    p.pointee = UInt8((limbs[i] >> UInt64(j * 8)) & 0xff)
                    p += 1
                }
            }
        }
        
        return data
    }
    
    init(data: Data) {
        let n = data.count
        guard n > 0 else {
            self.init(0)
            return
        }
        
        let m = (n + 7) / 8
        var limbs = Limbs(repeating: 0, count: m)
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> Void in
            var p = ptr
            let r = n % 8
            let k = r == 0 ? 8 : r
            for j in (0..<k).reversed() {
                limbs[m - 1] += UInt64(p.pointee) << UInt64(j * 8)
                p += 1
            }
            guard m > 1 else { return }
            for i in (0..<(m - 1)).reversed() {
                for j in (0..<8).reversed() {
                    limbs[i] += UInt64(p.pointee) << UInt64(j * 8)
                    p += 1
                }
            }
        }
        
        self.init(limbs: limbs)
    }
}