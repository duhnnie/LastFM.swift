import Foundation
import CryptoKit
import CommonCrypto

internal struct Crypto {

    /**
     * Example MD5 Has using CommonCrypto
     * CC_MD5 API exposed from CommonCrypto-60118.50.1:
     * https://opensource.apple.com/source/CommonCrypto/CommonCrypto-60118.50.1/include/CommonDigest.h.auto.html
     **/
    internal static func md5Hash (data: Data) -> String {
        if #available(iOS 13, *) {
            return Insecure.MD5.hash(data: data)
                .map{String(format: "%02x", $0)}
                .joined()
        } else {
            // Run iOS 12 and lower code.

            /// #define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
            /// Creates an array of unsigned 8 bit integers that contains 16 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))

            /// CC_MD5 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Calls the given closure with a pointer to the underlying unsafe bytes of the strData’s contiguous storage.
            _ = data.withUnsafeBytes {
                // CommonCrypto
                // extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md) --|
                // OpenSSL                                                                          |
                // unsigned char *MD5(const unsigned char *d, size_t n, unsigned char *md)        <-|
                CC_MD5($0.baseAddress, UInt32(data.count), &digest)
            }

            var md5String = ""
            /// Unpack each byte in the digest array and add them to the md5String
            for byte in digest {
                md5String += String(format:"%02x", UInt8(byte))
            }

            return md5String
        }
    }

}
