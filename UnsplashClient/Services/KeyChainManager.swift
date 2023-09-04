import Foundation

protocol KeyChainManagerProtocol: AnyObject {
    func readToken(service: String, account: String) -> String?
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
}
