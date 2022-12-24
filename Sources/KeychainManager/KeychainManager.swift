import UIKit
import SwiftKeychainWrapper

public enum ValueType: Int { case integer, bool, double, float, string, failed }

// Keychain entry container
public struct KeyDescriptor {
    
    var key: String
    var value: Any?
    var valueType: ValueType
    var writeSuccess: Bool?
}

public class KeyChainManager: NSObject {
    
    // MARK: - PROPERTIES
    var keyChainWrapper: KeychainWrapper?
    
    // MARK: - COMPUTED PROPERTIES FOR CREDENTIALS
    
    // Read and write a username from/to the keychain
    public var username: String? {
      
        get {
            
            let username = readString(withKey: "username")
            if username != nil { return username! } else { return nil }
        }
        
        set { writeData(data: newValue!, withKey: "username") }
    }
    
    // Read and write a password from/to the keychain
    public var password: String? {
        
        get {
            
            let password = readString(withKey: "password")
            if password != nil { return password! } else { return nil }
        }
        
        set { writeData(data: newValue!, withKey: "password") }
    }
    
    // MARK: - INITIALIZATION
    
    // Init class with an optional service name (the default is the bundle ID)
    public init (withServiceName: String? = nil) {
        
        super.init()
       
        if withServiceName != nil { keyChainWrapper = KeychainWrapper(serviceName: withServiceName!) }
    }
    
    // MARK: - METHODS
    
    // Read a set of keys with one call
    public func readKeys(withKeys: [KeyDescriptor]) -> [KeyDescriptor] {
        
        var theKeyValues = [KeyDescriptor]()
       
        for key in withKeys {
            
            switch key.valueType {
                
                case .integer:
                
                    let value = readInteger(withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: value, valueType: .integer))
                
                case .bool:
                
                    let value = readBool(withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: value, valueType: .bool))
                        
                case .double:
                
                    let value = readDouble(withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: value, valueType: .double))
                    
                case .float:
                
                    let value = readFloat(withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: value, valueType: .float))
                        
                case .string:
                    
                    let value = readString(withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: value, valueType: .string))
                
                default: break
            }
        }
        
        return theKeyValues
    }
    
    // Write a set of keys with one call
    public func writeKeys(withKeys: [KeyDescriptor]) -> [KeyDescriptor]  {
        
        var theKeyValues = [KeyDescriptor]()
       
        for key in withKeys {
            
            switch key.valueType {
                
                case .integer:
                
                    let writeSuccess = writeData(data: key.value as! Int, withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: key.value, valueType: .integer, writeSuccess: writeSuccess))
                
                case .bool:
                
                    let writeSuccess = writeData(data: key.value as! Bool, withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: key.value, valueType: .integer, writeSuccess: writeSuccess))
                        
                case .double:
                
                    let writeSuccess = writeData(data: key.value as! Double, withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: key.value, valueType: .integer, writeSuccess: writeSuccess))
                    
                case .float:
                
                    let writeSuccess = writeData(data: key.value as! Float, withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: key.value, valueType: .integer, writeSuccess: writeSuccess))
                        
                case .string:
                    
                    let writeSuccess = writeData(data: key.value as! String, withKey: key.key)
                    theKeyValues.append(KeyDescriptor(key: key.key, value: key.value, valueType: .integer, writeSuccess: writeSuccess))
                
                default: break
               
            }
        }
        
        return theKeyValues
    }
  
    // MARK: - METHODS TO READ AN INDIVIDUAL KEYCHAIN RECORD
    public func readBool (withKey: String) -> Bool? { return KeychainWrapper.standard.bool(forKey: withKey) }
    
    public func readDouble (withKey: String) -> Double? { return KeychainWrapper.standard.double(forKey: withKey) }
    
    public func readFloat (withKey: String) -> Float? { return KeychainWrapper.standard.float(forKey: withKey) }
    
    public func readInteger (withKey: String) -> Int? { return KeychainWrapper.standard.integer(forKey: withKey) }
    
    public func readString (withKey: String) -> String? { return KeychainWrapper.standard.string(forKey: withKey) }
    
    // MARK: - OVERLOADED METHODS TO WRITE AN INDIVIDUAL KEYCHAIN RECORD
    @discardableResult public func writeData (data: Bool, withKey: String ) -> Bool { return KeychainWrapper.standard.set(data, forKey: withKey)  }
    
    @discardableResult public func writeData (data: Double, withKey: String ) -> Bool { return KeychainWrapper.standard.set(data, forKey: withKey) }
    
    @discardableResult public func writeData (data: Float, withKey: String ) -> Bool { return KeychainWrapper.standard.set(data, forKey: withKey) }
    
    @discardableResult public func writeData (data: Int, withKey: String ) -> Bool { return KeychainWrapper.standard.set(data, forKey: withKey)  }
    
    @discardableResult public func writeData (data: String , withKey: String) -> Bool { return KeychainWrapper.standard.set(data, forKey: withKey)  }
    
    // MARK: - CLEAR KEYCHAIN ENTRIES
    func deleteKey (forKeys: [String]) {
        
        for key in forKeys { KeychainWrapper.standard.removeObject(forKey: key) }
    }
}

