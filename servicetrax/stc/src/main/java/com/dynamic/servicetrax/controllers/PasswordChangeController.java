package com.dynamic.servicetrax.controllers;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.command.PasswordChangeCommand;
import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.User;
import com.dynamic.servicetrax.support.LoginCrediantials;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.context.support.ResourceBundleMessageSource;
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
 * Date: May 8, 2011
 * Time: 1:12:16 PM
 */
public class PasswordChangeController extends MultiActionController {

    public static final String SUCCESS = "success";
    public static final String MESSAGE = "message";

    private static final Logger LOGGER = Logger.getLogger(PasswordChangeController.class);

    private ResourceBundleMessageSource messageSource;
    private HibernateService hibernateService;


    @SuppressWarnings("unchecked, unused")
    public ModelAndView changePassword(HttpServletRequest request,
                                       HttpServletResponse response,
                                       ModelMap model) throws Exception {

        LOGGER.info("changePassword");
        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        Long userId = (long) credentials.getUserId();
        model.put("userId", userId);
        return new ModelAndView("admin/changePassword", model);
    }

    @SuppressWarnings("unused")
    public void handleChangePassword(HttpServletRequest request,
                                     HttpServletResponse response,
                                     PasswordChangeCommand command) throws Exception {

        LOGGER.info("handleChangePassword");

        Boolean result;
        String message;
        User user;

        if (!newPasswordsMatch(command)) {
            result = Boolean.FALSE;
            message = messageSource.getMessage("servicetrax.passwordChange.newPassword.noMatch",
                                               new Object[]{command.getUserId()},
                                               Locale.getDefault());
        }
        else if (isInvalidUserId(command) || (user = (User) hibernateService.get(User.class, command.getUserId())) == null) {
            result = Boolean.FALSE;
            message = messageSource.getMessage("servicetrax.passwordChange.noUser",
                                               new Object[]{command.getUserId()},
                                               Locale.getDefault());
        }
        else if (!existingPasswordMatches(command, user)) {
            result = Boolean.FALSE;
            message = messageSource.getMessage("servicetrax.passwordChange.existingPassword.noMatch",
                                               new Object[]{command.getUserId()},
                                               Locale.getDefault());
        }
        else {
            user.setPassword(command.getNewPassword());
            hibernateService.saveOrUpdate(user);
            result = Boolean.TRUE;
            message = messageSource.getMessage("servicetrax.passwordChange.success", null, Locale.getDefault());
        }

        Map<String, Object> json = new HashMap<String, Object>();
        json.put(SUCCESS, result);
        json.put(MESSAGE, message);
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

    private boolean isInvalidUserId(PasswordChangeCommand command) {

        if (command.getUserId() == null || command.getUserId().trim().length() == 0) {
            return true;
        }

        try {
            Long.parseLong(command.getUserId());
        }
        catch (NumberFormatException e) {
            logger.warn(e);
            return true;
        }
        return false;
    }

    private boolean existingPasswordMatches(PasswordChangeCommand command, User user) {
        return user.getPassword() != null && command.getExistingPassword() != null && user.getPassword().equals(command.getExistingPassword());
    }

    private boolean newPasswordsMatch(PasswordChangeCommand command) {
        return command.getConfirmPassword() != null && command.getNewPassword() != null && command.getConfirmPassword().equals(command.getNewPassword());
    }

    public void setMessageSource(ResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void setHibernateService(HibernateService hibernateService) {
        this.hibernateService = hibernateService;
    }
}
