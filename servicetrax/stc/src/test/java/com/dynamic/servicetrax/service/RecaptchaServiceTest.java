package com.dynamic.servicetrax.service;

import org.springframework.test.AbstractDependencyInjectionSpringContextTests;

/**
 * User: pgarvie
 * Date: Apr 25, 2011
 * Time: 7:04:46 PM
 */
public class RecaptchaServiceTest extends AbstractDependencyInjectionSpringContextTests {

    private RecaptchaService recaptchaService;

    public void testGenerateCaptcha(){

        String captcha = recaptchaService.generateCaptcha();
        assertNotNull(captcha);
        assertTrue(captcha.startsWith("<script"));
        assertTrue(captcha.trim().endsWith("</script>"));
    }

    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
    }
    

    public void setRecaptchaService(RecaptchaService recaptchaService) {
        this.recaptchaService = recaptchaService;
    }
}
