package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.command.PasswordRequestCommand;
import com.dynamic.servicetrax.command.UserLoginInfoCommand;
import com.dynamic.servicetrax.dao.LoginDao;
import com.dynamic.servicetrax.service.EmailService;
import com.dynamic.servicetrax.service.RecaptchaService;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Apr 22, 2011
 * Time: 8:18:51 PM
 */
public class LoginAdminController extends MultiActionController {

    private static final Logger LOGGER = Logger.getLogger(LoginAdminController.class);

    private EmailService emailService;
    private RecaptchaService recaptchaService;
    private MessageSource messageSource;
    private LoginDao loginDao;

    @SuppressWarnings("unchecked, unused")
    public ModelAndView sendPassword(HttpServletRequest request,
                                     HttpServletResponse response,
                                     ModelMap model) throws Exception {

        LOGGER.info("sendPassword");
        String captcha = recaptchaService.generateCaptcha();
        model.put("captcha", captcha);
        return new ModelAndView("admin/sendPassword", model);
    }

    @SuppressWarnings("unused")
    public void handleSendPassword(HttpServletRequest request,
                                   HttpServletResponse response,
                                   PasswordRequestCommand command) throws Exception {

        LOGGER.info("handleSendPassword");

        Boolean result;
        String message;

        Map userInfo = null;

        if (!recaptchaService.isCaptchaValid(request.getRemoteAddr(),
                                             command.getCaptchaChallenge(),
                                             command.getCaptchaResponse())) {
            result = Boolean.FALSE;
            message = messageSource.getMessage("servicetrax.loginAdmin.captcha.incorrect", null, Locale.getDefault());
        }
        else if ((userInfo = getUser(command.getUsername())) == null) {
            result = Boolean.FALSE;
            message = messageSource.getMessage("servicetrax.loginAdmin.noPasswordFound",
                                               new Object[]{command.getUsername()},
                                               Locale.getDefault());
        }
        else if (!emailService.send((String) userInfo.get("email"),
                                    "Your password is " + userInfo.get("password"))) {
            result = Boolean.FALSE;
            StringBuilder builder = new StringBuilder(messageSource.getMessage("servicetrax.loginAdmin.email.fail",
                                                                               new Object[]{command.getUsername()},
                                                                               Locale.getDefault()));
            builder.append(" ");
            builder.append(messageSource.getMessage("servicetrax.loginAdmin.passwordSent.contact", null, Locale.getDefault()));
            message = builder.toString();
        }
        else {
            result = Boolean.TRUE;
            message = messageSource.getMessage("servicetrax.loginAdmin.passwordSent.success", null, Locale.getDefault());
        }

        if (userInfo != null) {
            LOGGER.error("Sending password reset info to " + command.getUsername() + " at " + userInfo.get("password"));
        }

        Map<String, Object> json = new HashMap<String, Object>();
        json.put("success", result);
        json.put("message", message);
        JSONObject jsonArray = JSONObject.fromObject(json);

        OutputStreamWriter os = null;

        try {
            os = new OutputStreamWriter(response.getOutputStream());
            os.write(jsonArray.toString());
            os.flush();
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    private Map getUser(String username) {
        if (username == null || username.trim().length() == 0) {
            return null;
        }
        return loginDao.getUser(username);
    }

    @SuppressWarnings("unused")
    public ModelAndView openNewAccountRequest(HttpServletRequest request,
                                              HttpServletResponse response) throws Exception {
        LOGGER.info("openNewAccountRequest");
        return new ModelAndView("admin/openNewAccountRequest");
    }


    @SuppressWarnings("unused")
    public void requestNewAccount(HttpServletRequest request,
                                  HttpServletResponse response,
                                  UserLoginInfoCommand command) throws Exception {

        LOGGER.info("requestNewAccount");
        if (!emailService.send(emailService.getFromEmail(), command.toString())) {
            LOGGER.error("Sending new account info for " + command.toString() + " was unsuccessful.");
        }
        else {
            LOGGER.info("Sent new account info for " + command.toString());
        }
    }


    public void setEmailService(EmailService emailService) {
        this.emailService = emailService;
    }

    public void setRecaptchaService(RecaptchaService recaptchaService) {
        this.recaptchaService = recaptchaService;
    }

    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void setLoginDao(LoginDao loginDao) {
        this.loginDao = loginDao;
    }
}
