package com.dynamic.servicetrax.command;

/**
 * User: pgarvie
 * Date: Apr 26, 2011
 * Time: 10:20:36 AM
 */
@SuppressWarnings("unused")
public class PasswordRequestCommand {

    private String username;
    private String captchaChallenge;
    private String captchaResponse;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCaptchaChallenge() {
        return captchaChallenge;
    }

    public void setCaptchaChallenge(String captchaChallenge) {
        this.captchaChallenge = captchaChallenge;
    }

    public String getCaptchaResponse() {
        return captchaResponse;
    }

    public void setCaptchaResponse(String captchaResponse) {
        this.captchaResponse = captchaResponse;
    }
}
