package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import com.dynamic.servicetrax.support.LoginCrediantials;
import net.sf.json.JSONObject;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.beans.PropertyEditorSupport;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 6:36:24 AM
 */
public class HotSheetController extends MultiActionController {

    private HotSheetService hotSheetService;

    public HotSheetController() {

        setValidators(new Validator[]{new Validator() {
            public boolean supports(Class clazz) {
                return clazz.isAssignableFrom(HotSheet.class);
            }

            public void validate(Object command, Errors errors) {
                ValidationUtils.rejectIfEmpty(errors, "jobLength", "", "Job length cannot be blank");
            }
        }});

    }

    @SuppressWarnings("unchecked")
    public ModelAndView create(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map parameters = request.getParameterMap();
        String requestId = getParameter(parameters, "requestId");

        if (requestId == null) {
            String message = "No incoming requestId found";
            return new ModelAndView("error", "error", message);
        }

        HotSheet hotSheet = hotSheetService.buildHotSheet(requestId);

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);

        Long userId = (long) credentials.getUserId();
        hotSheet.setCreatedBy(userId);

        Map<String, HotSheetDetail> details = hotSheetService.getHotSheetDetails(userId);
        hotSheet.setDetails(details);

        ModelAndView view = new ModelAndView("hotsheet/hotsheet");
        view.getModel().put("hotSheet", hotSheet);
        return view;
    }

    @SuppressWarnings("unchecked")
    public ModelAndView save(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView("hotsheet/hotsheet");
            hotSheetService.addOriginAddressInfo(hotSheet);
            view.getModel().put("hotSheet", hotSheet);
            view.getModel().put("errors", result.getAllErrors());
            return view;
        }

        hotSheetService.initializeStartTimes(request, hotSheet);
        hotSheet.setDateCreated(new Date());
        hotSheetService.saveHotSheet(hotSheet);
        ModelAndView view = new ModelAndView("hotsheet/saved");
        view.getModel().put("hotSheetIdentifier", hotSheet.getHotSheetIdentifier());
        return view;
    }

    @SuppressWarnings("unchecked")
    public ModelAndView copy(HttpServletRequest request, HttpServletResponse response, HotSheet command) throws Exception {
        System.out.println("");
        return null;
    }

    @SuppressWarnings("unchecked")
    public ModelAndView report(HttpServletRequest request, HttpServletResponse response, HotSheet command) throws Exception {
        System.out.println("");
        return null;
    }

    @SuppressWarnings("unchecked")
    public void updateAddress(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        try {
            String id = request.getParameter("jobLocationId");
            Address address = hotSheetService.getAddress(new BigDecimal(id));
            OutputStreamWriter os = new OutputStreamWriter(response.getOutputStream());
            JSONObject jsonArray = JSONObject.fromObject(address);
            os.write(jsonArray.toString());
            os.flush();
            os.close();
        }
        catch (Exception e) {
            logger.error(e);
        }
    }

    @SuppressWarnings("unchecked")
    public void addJobLocation(HttpServletRequest request, HttpServletResponse response, Address address) throws Exception {
        System.out.println(address);
    }


    private BindingResult result;

    @Override
    protected void bind(HttpServletRequest request, Object command) throws Exception {
        ServletRequestDataBinder binder = createBinder(request, command);
        binder.bind(request);
        result = binder.getBindingResult();

        Validator[] validators = getValidators();
        if (validators != null) {
            for (Validator aValidator : validators) {
                if (aValidator.supports(command.getClass())) {
                    ValidationUtils.invokeValidator(aValidator, command, binder.getBindingResult());
                }
            }
        }
    }

    private String getParameter(Map parameters, String parameterName) {
        String[] parameter = (String[]) parameters.get(parameterName);
        if (parameter == null || parameter.length == 0) {
            return null;

        }
        return parameter[0];
    }

    @Override
    protected Object newCommandObject(Class clazz) throws Exception {
        if (clazz == HotSheet.class) {
            HotSheet object = (HotSheet) super.newCommandObject(clazz);
            Map<String, HotSheetDetail> details =
                    hotSheetService.getHotSheetDetails(null);
            object.setDetails(details);
            object.setJobLocationAddress(new Address());
            object.setOriginAddress(new Address());
            object.setBillingAddress(new Address());
            return object;
        }
        return super.newCommandObject(clazz);
    }

    @SuppressWarnings("unchecked")
    public void setHotSheetService(HotSheetService hotSheetService) {
        this.hotSheetService = hotSheetService;
    }

    @Override
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder dataBinder) throws Exception {
        OmniCustomerDateEditor customDateEditor = new OmniCustomerDateEditor();

        // This is for the create/modify dates
        customDateEditor.addDateFormat("yyyy-MM-dd hh:mm:ss");

        // This is for the jobDate.
        customDateEditor.addDateFormat("MM/dd/yyyy");
        dataBinder.registerCustomEditor(Date.class, customDateEditor);
        super.initBinder(request, dataBinder);
    }


    /**
     * Adapted from http://agileice.blogspot.com/2009_09_01_archive.html
     */
    private class OmniCustomerDateEditor extends PropertyEditorSupport {

        private final List<String> formats;

        public OmniCustomerDateEditor() {
            formats = new ArrayList<String>();
        }

        public void addDateFormat(String aFormat) {
            formats.add(aFormat);
        }

        public String getAsText() {
            return (String) getValue();
        }

        public void setAsText(String dateString) throws IllegalArgumentException {

            for (String aFormat : formats) {
                SimpleDateFormat formatter = new SimpleDateFormat(aFormat);
                try {
                    setValue(formatter.parse(dateString));
                }
                catch (ParseException ignore) {
                }
            }
        }
    }
}
