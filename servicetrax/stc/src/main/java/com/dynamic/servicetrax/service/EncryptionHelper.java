package com.dynamic.servicetrax.service;

import au.com.bytecode.opencsv.CSVReader;
import org.apache.commons.codec.digest.DigestUtils;

import java.io.FileReader;

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

    public static void main(String[] args) {
        EncryptionHelper instance = EncryptionHelper.getInstance();

        if(args.length == 1) {
            String fileName = args[0];

            CSVReader csvReader = null;
            try {
                csvReader = new CSVReader(new FileReader(fileName));
                String[] row = null;
                boolean header = true;
                while((row = csvReader.readNext()) != null) {
                    if(header) {
                        header = false;
                    } else {
                        String hash = instance.hash(row[2], row[1]);

                        System.out.println("UPDATE users SET PASSWORD = '" + hash + "' WHERE USER_ID = " + row[0] + ";");
                    }
                }
            } catch( Throwable t) {
                t.printStackTrace();
            } finally {
                if(csvReader != null) {
                    try {
                        csvReader.close();
                    } catch( Throwable whocares) {}
                }
            }
        } else if( args.length == 2 ) {
            String username = args[0];
            String password = args[1];

            String hash = instance.hash(username, password);

            System.out.println( username + "/" + hash);
        }
    }
}
