package com.dynamic.charm.examples.orm;
// Generated Nov 27, 2006 11:54:35 AM by Hibernate Tools 3.2.0.beta8



/**
 * User generated by hbm2java
 */
public class User  implements java.io.Serializable {

    // Fields    

     private Integer userId;
     private String login;
     private String password;
     private String firstName;
     private String lastName;
     private String email;

     // Constructors

    /** default constructor */
    public User() {
    }

    /** full constructor */
    public User(String login, String password, String firstName, String lastName, String email) {
       this.login = login;
       this.password = password;
       this.firstName = firstName;
       this.lastName = lastName;
       this.email = email;
    }
   
    // Property accessors
    public Integer getUserId() {
        return this.userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    public String getLogin() {
        return this.login;
    }
    
    public void setLogin(String login) {
        this.login = login;
    }
    public String getPassword() {
        return this.password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    public String getFirstName() {
        return this.firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return this.lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getEmail() {
        return this.email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }




}


