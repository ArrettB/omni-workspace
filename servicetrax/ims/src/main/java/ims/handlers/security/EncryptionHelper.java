package ims.handlers.security;

import org.apache.commons.codec.digest.DigestUtils;

/**
 * User: pgarvie
 * Date: 3/21/16
 * Time: 9:22 AM
 */
public class EncryptionHelper {

    private static final EncryptionHelper INSTANCE = new EncryptionHelper();

    private String[] SALTS = {
            "BXCob9QnW0B64/zragEP9g==",
            "ROVRbFnrVz6VoCnsH+S1RQ==",
            "0UAW/1tU46EUiLqgYEtn0Q==",
            "4HlALlJIkzzGOG2ZSXAX7g==",
            "fT+TLctUl2s+mRn1V03dLg==",
            "syP5fy4dUQHPD7jZeC/oGQ==",
            "hvYN+zIiiPqi/lFVQWqmrQ==",
            "t/cd2UuMhUd/LqK1/Q6vEQ==",
            "hLDxEMEirJfm4wXXf8mWNQ==",
            "zK5Tye7XNHZ47kLvaCF67w=="
    };

    public String hash(String username, String password) {
        String salt = SALTS[Math.abs(username.hashCode() % 10)];
        return DigestUtils.sha256Hex(salt + password);
    }

    public static EncryptionHelper getInstance() {
        return INSTANCE;
    }

    private EncryptionHelper() {
    }
}
