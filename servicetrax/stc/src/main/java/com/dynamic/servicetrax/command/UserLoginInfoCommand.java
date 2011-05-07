package com.dynamic.servicetrax.command;

/**
 * User: pgarvie
 * Date: Apr 27, 2011
 * Time: 9:36:37 PM
 */
@SuppressWarnings("unused")
public class UserLoginInfoCommand {

    private String firstName;
    private String lastName;
    private String username;
    private String password;
    private String email;
    private String phone;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "First Name: " + firstName + "\n" +
                "Last Name: " + lastName + "\n" +
                "Login: " + username + "\n" +
                "Password: " + password + "\n" +
                "Email: " + email + "\n" +
                "Phone: " + phone;
    }
}
