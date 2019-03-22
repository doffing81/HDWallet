// BIP47.swift

import Foundation

/// Singleton
class BIP47 {
    
    static let shared = BIP47()
    
    /// Creates a keychain from acquired payment code to derive keys and addresses for tunnels/channels.
    func keychain(forPaymentCode paymentCode: String, network: BTCNetwork = .main) -> BTCKeychain {
        let payCodeData: [UInt8] = paymentCode.base58CheckDecode()!
        let pubkey = [UInt8](payCodeData[6..<72])
        let chainCode = [UInt8](payCodeData[72..<136])
        let depth = UInt8(3)
        #warning("TODO: determine if the initial fingerprint should be zero, or if it even matters.")
        let fingerprint: UInt32 = 0x00000000
        let index: UInt32 = 0x80000000
        let xPub = ExtendedPublicKey(pubkey.data, chainCode.data, depth, fingerprint, index.bigEndian)
        return BTCKeychain(withExtendedPublicKey: xPub)
    }
    
    func paymentCode(forBIP47Keychain keychain: BTCKeychain, _ version: UInt8 = 0x01) -> String {
        // TODO: verify BIP47 keychain?
        var paymentCode = Data()
        paymentCode += UInt8(0x47)
        paymentCode += version
        paymentCode += UInt8(0x00) // Features bit field. Bit 0: Bitmessage notification, Bits 1-7: reserved.
        paymentCode += keychain.extendedPublicKey!.publicKey
        paymentCode += keychain.extendedPublicKey!.chainCode
        paymentCode += Data(repeating: 0x00, count: 13) // Bytes 67 - 79: reserved for future expansion, zero-filled unless otherwise noted
        return paymentCode.base58CheckEncodedString
    }
}
