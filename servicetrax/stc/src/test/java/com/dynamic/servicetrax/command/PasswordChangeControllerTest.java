package com.dynamic.servicetrax.command;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.controllers.PasswordChangeController;
import com.dynamic.servicetrax.dao.HibernateLookupsDao;
import com.dynamic.servicetrax.orm.Lookup;
import com.dynamic.servicetrax.orm.User;
import com.dynamic.servicetrax.service.EncryptionHelper;
import net.sf.json.JSONObject;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * User: pgarvie
 * Date: May 8, 2011
 * Time: 8:13:59 PM
 */
public class PasswordChangeControllerTest extends AbstractTransactionalDataSourceSpringContextTests {

    private PasswordChangeController passwordChangeController;
    private ResourceBundleMessageSource messageSource;
    private HibernateService hibernateService;
    private HibernateLookupsDao hibernateLookupsDao;

    public void testHandleChangePasswordHappyPath() throws Exception {

        String existingPassword = "thePassword";
        String newPassword = "newPassword";

        User user = createTestUser();
        user.setPassword(EncryptionHelper.getInstance().hash(user.getLogin(), existingPassword));
        hibernateService.save(user);

        PasswordChangeCommand command = new PasswordChangeCommand();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockHttpServletRequest request = new MockHttpServletRequest();
        command.setExistingPassword(existingPassword);
        command.setNewPassword(newPassword);
        command.setConfirmPassword(newPassword);
        command.setUserId(String.valueOf(user.getUserId()));

        passwordChangeController.handleChangePassword(request, response, command);
        String message = response.getContentAsString();
        JSONObject jsonObject = JSONObject.fromObject(message);
        assertTrue((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        String controlMessage = messageSource.getMessage("servicetrax.passwordChange.success", null, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        User saved = (User) hibernateService.get(User.class, user.getUserId());
        assertEquals(EncryptionHelper.getInstance().hash(user.getLogin(), newPassword), saved.getPassword());
    }

    public void testHandleChangePassword() throws Exception {

        PasswordChangeCommand command = new PasswordChangeCommand();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockHttpServletRequest request = new MockHttpServletRequest();

        //No nothing in command
        passwordChangeController.handleChangePassword(request, response, command);

        String message = response.getContentAsString();
        JSONObject jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        String controlMessage = messageSource.getMessage("servicetrax.passwordChange.newPassword.noMatch", null, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        String newPassword = "confirm";

        // No user at all
        command.setNewPassword(newPassword);
        command.setConfirmPassword(newPassword);
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.noUser", new Object[]{"null"}, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        // No user with this id
        command.setUserId("BarFakeMyUsernameFoo");
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.noUser", new Object[]{"BarFakeMyUsernameFoo"}, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        // No user with this id, either
        command.setUserId("98765433210");
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.noUser", new Object[]{"BarFakeMyUsernameFoo"}, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));


        User user = createTestUser();
        hibernateService.save(user);

        // no existing password
        command.setUserId(String.valueOf(user.getUserId()));
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.existingPassword.noMatch", null, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        // New and confirm don't match
        command.setNewPassword("Foo");
        command.setConfirmPassword("Bar");
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.newPassword.noMatch", null, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));

        // Existing password doesn't match
        command.setNewPassword(newPassword);
        command.setConfirmPassword(newPassword);
        command.setExistingPassword("FakePasswordThatBetterNotMatchAnything");
        response = new MockHttpServletResponse();
        passwordChangeController.handleChangePassword(request, response, command);
        message = response.getContentAsString();
        jsonObject = JSONObject.fromObject(message);
        assertFalse((Boolean) jsonObject.get(PasswordChangeController.SUCCESS));
        controlMessage = messageSource.getMessage("servicetrax.passwordChange.existingPassword.noMatch", null, Locale.getDefault());
        assertEquals(controlMessage, jsonObject.get(PasswordChangeController.MESSAGE));
    }

    public void setPasswordChangeController(PasswordChangeController passwordChangeController) {
        this.passwordChangeController = passwordChangeController;
    }

    public void setMessageSource(ResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void setHibernateService(HibernateService hibernateService) {
        this.hibernateService = hibernateService;
    }

    public void setHibernateLookupsDao(HibernateLookupsDao hibernateLookupsDao) {
        this.hibernateLookupsDao = hibernateLookupsDao;
    }

    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
    }

    public User createTestUser() {
        User user = new User();
        user.setActiveFlag("Y");
        user.setDateCreated(new Date());

        String[] paramNames = new String[]{"lookupTypeCode", "lookupCode"};
        Object[] paramValues = new Object[]{"employment_type", "full_time"};
        List result = hibernateLookupsDao.namedQueryForList("lookup", paramNames, paramValues);

        user.setLookupByEmploymentTypeId((Lookup) result.get(0));
        user.setExtDealerId("100");
        user.setFirstName("Test");
        user.setLastName("User");
        user.setLogin("login");
        user.setPassword("password");
        user.setUserByCreatedBy((User) hibernateLookupsDao.load(User.class, "1"));

        hibernateLookupsDao.saveOrUpdate(user);

        return user;
    }

}
