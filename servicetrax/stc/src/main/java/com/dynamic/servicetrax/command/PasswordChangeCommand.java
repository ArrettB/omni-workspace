package com.dynamic.servicetrax.command;

/**
 * User: pgarvie
 * Date: May 8, 2011
 * Time: 2:26:45 PM
 */
@SuppressWarnings("unused")
public class PasswordChangeCommand {

    private String userId;
    private String existingPassword;
    private String newPassword;
    private String confirmPassword;


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getExistingPassword() {
        return existingPassword;
    }

    public void setExistingPassword(String existingPassword) {
        this.existingPassword = existingPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}
