package com.dynamic.servicetrax.service;

import net.tanesha.recaptcha.ReCaptcha;
import net.tanesha.recaptcha.ReCaptchaFactory;
import net.tanesha.recaptcha.ReCaptchaImpl;
import net.tanesha.recaptcha.ReCaptchaResponse;
import org.apache.log4j.Logger;

/**
 * User: pgarvie
 * Date: Apr 25, 2011
 * Time: 5:13:41 PM
 */
public class RecaptchaService {

    private String publicKey;
    private String privateKey;

    public static final Logger LOGGER = Logger.getLogger(RecaptchaService.class);


    public String generateCaptcha() {
        ReCaptcha factory = ReCaptchaFactory.newReCaptcha(publicKey, privateKey, false);
        return factory.createRecaptchaHtml(null, null);
    }

    public Boolean isCaptchaValid(String remoteAddress, String captchaChallenge, String captchaResponse) {

        ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
        reCaptcha.setPrivateKey(privateKey);
        ReCaptchaResponse reCaptchaResponse =
                reCaptcha.checkAnswer(remoteAddress, captchaChallenge, captchaResponse);

        if (reCaptchaResponse.isValid()) {
            LOGGER.info("Captcha correct");
            return Boolean.TRUE;
        }

        LOGGER.info("Captcha not correct");
        return Boolean.FALSE;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }
}
