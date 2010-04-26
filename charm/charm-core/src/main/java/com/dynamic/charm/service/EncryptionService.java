/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: EncryptionService.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class EncryptionService
{
    private static final String ENCRYPT_ALGORITHM_NAME = "DESede";
    private static String MD5_ALG_NAME = "MD5";

    private static final Logger logger = Logger.getLogger(EncryptionService.class);

    private Key key = null;
    private Cipher cipher = null;
    private File keyLocation;
    private boolean initialized;

    public EncryptionService()
    {
    }

    public EncryptionService(File keyLocation)
    {
        this.keyLocation = keyLocation;
    }

    public void init()
    {
        try
        {
            if (!keyLocation.exists())
            {
                logger.info("EncryptionService is creating a new key.");
                key = KeyGenerator.getInstance(ENCRYPT_ALGORITHM_NAME).generateKey();

                ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(keyLocation));
                oos.writeObject(key);
                IOUtils.closeQuietly(oos);
            }
            else
            {
                logger.info("EncryptionService initialized with existing key.");

                ObjectInputStream ois = new ObjectInputStream(new FileInputStream(keyLocation));
                key = (Key) ois.readObject();
                IOUtils.closeQuietly(ois);
            }

            cipher = Cipher.getInstance(ENCRYPT_ALGORITHM_NAME);
            initialized = true;
        }
        catch (NoSuchAlgorithmException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (FileNotFoundException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (ClassNotFoundException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (NoSuchPaddingException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public byte[] encrypt(String input) throws InvalidKeyException, BadPaddingException,
        IllegalBlockSizeException
    {
        checkInit();
        cipher.init(Cipher.ENCRYPT_MODE, key);

        byte[] inputBytes = input.getBytes();
        return cipher.doFinal(inputBytes);
    }

    public String decrypt(byte[] encryptionBytes) throws InvalidKeyException, BadPaddingException,
        IllegalBlockSizeException
    {
        checkInit();
        cipher.init(Cipher.DECRYPT_MODE, key);

        byte[] recoveredBytes = cipher.doFinal(encryptionBytes);
        String recovered = new String(recoveredBytes);
        return recovered;
    }

    public String decrypt(String encryptionBytes) throws InvalidKeyException, BadPaddingException,
        IllegalBlockSizeException
    {
        return decrypt(encryptionBytes.getBytes());
    }

    public void checkInit()
    {
        if (!initialized)
        {
            //TODO add code to throw exception
        }
    }

    public static void main(String[] args)
    {
        File key = new File("C:\\key.ser");
        String encryptMe = "The quick brown fox jumped over the lazy dog";

        System.out.println(bytesToEncoding(stringToDigest("gcase")));

        try
        {
            EncryptionService ct = new EncryptionService(key);
            ct.init();

            byte[] encrypted = ct.encrypt(encryptMe);
            String decrypted = ct.decrypt(encrypted);

            System.out.println("encrypted = " + encrypted);
            System.out.println("decrypted = " + decrypted);

            EncryptionService ct2 = new EncryptionService(key);
            ct2.init();

            String decrypted2 = ct2.decrypt(encrypted);

            System.out.println("decrypted2 = " + decrypted2);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    public File getKeyLocation()
    {
        return keyLocation;
    }

    public void setKeyLocation(File keyLocation)
    {
        this.keyLocation = keyLocation;
    }

    public static byte[] stringToDigest(String string)
    {
        byte[] result = null;
        try
        {
            MessageDigest md = MessageDigest.getInstance(MD5_ALG_NAME);
            result = md.digest(string.getBytes());

            //     md.d
            return result;
        }
        catch (NoSuchAlgorithmException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return result;
    }

    public static byte[] bytesToEncoding(byte[] bytes)
    {
        return Base64.encodeBase64(bytes);
    }

    public boolean passwordCheck(String password, String base64EncodedDigest)
    {
        byte[] digest = stringToDigest(password);
        byte[] encoded = bytesToEncoding(digest);
        byte[] stored = base64EncodedDigest.getBytes();
        return Arrays.equals(encoded, stored);
    }
}
