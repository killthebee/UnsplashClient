import Foundation

protocol KeyChainManagerProtocol: AnyObject {
    func readToken(service: String, account: String) -> String?
    func save(_ data: Data, service: String, account: String)
}

final class KeyChainManager: KeyChainManagerProtocol {
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func readToken(service: String, account: String) -> String? {
        guard let data = read(service: service, account: account) else {
            return nil
        }
        let accessToken = String(data: data, encoding: .utf8)
        return accessToken
    }
    
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            update(
                data,
                service: service,
                account: account
            )
            
            return
        }
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    
    private func update(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        
        let status = SecItemUpdate(query, attributesToUpdate)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
}
