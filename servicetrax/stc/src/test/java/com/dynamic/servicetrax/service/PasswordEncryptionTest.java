package com.dynamic.servicetrax.service;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.junit.Ignore;
import org.junit.Test;
import sun.misc.BASE64Encoder;

import static org.junit.Assert.assertEquals;

/**
 * User: pgarvie
 * Date: 3/21/16
 * Time: 9:16 AM
 */
public class PasswordEncryptionTest {

    @Ignore
    @Test
    public void testSecureRandom() throws NoSuchAlgorithmException {
        SecureRandom sr = new SecureRandom();
        for (int i = 0; i < 10; i++) {
            byte[] salt = new byte[16];
            sr.nextBytes(salt);
            String a = new BASE64Encoder().encode(salt);
            System.out.println(a);
        }
    }

    @Test
    public void testPasswordEncryption() {
        String encrypted = EncryptionHelper.getInstance().hash("username", "password");
        assertEquals("0a01a2b7645139919e378286c02dbd4377295aad5f7e7bff30c1e18f011384b3",
                     encrypted);
    }

    @Test
    public void testSql() throws ClassNotFoundException, SQLException {
        final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
        final String DB_URL = "jdbc:jtds:sqlserver://rolla.kettleriverconsulting.com:1433/omni_ims";

        //  Database credentials
        final String USER = "ims";
        final String PASS = "ims";

        Connection conn = null;
        Statement stmt = null;
        Class.forName("net.sourceforge.jtds.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, USER, PASS);
        stmt = conn.createStatement();
        String sql;
        sql = "select * from users";
        ResultSet rs = stmt.executeQuery(sql);

        int i = 0;
        while (rs.next()) {
            int userId = rs.getInt("user_id");
            String username = rs.getString("login");
            String password = rs.getString("password");
            String encrypted = EncryptionHelper.getInstance().hash(username, password);
            System.out.println(userId + "," + username + "," + password + "," + encrypted);

        }
    }
}
