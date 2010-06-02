package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import com.dynamic.servicetrax.service.JasperReportService;
import com.dynamic.servicetrax.support.LoginCrediantials;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.beans.PropertyEditorSupport;
import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 6:36:24 AM
 */
@SuppressWarnings("unused")
public class HotSheetController extends MultiActionController {

    private HotSheetService hotSheetService;
    private JasperReportService jasperReportService;

    private static final String HOT_SHEET = "hotSheet";
    private static final String HOTSHEET_VIEW = "hotsheet/hotsheet";

    public HotSheetController() {

        setValidators(new Validator[]{new Validator() {
            public boolean supports(Class clazz) {
                return clazz.isAssignableFrom(HotSheet.class);
            }

            public void validate(Object command, Errors errors) {
                ValidationUtils.rejectIfEmpty(errors, "originAddressId", "", "An origin address is required");
                ValidationUtils.rejectIfEmpty(errors, "jobLength", "", "Job length cannot be blank");

                Integer jobLength = ((HotSheet) command).getJobLength();
                if (jobLength != null && jobLength < 0) {
                    errors.rejectValue("jobLength", "jobLength.notNegative");
                }

                Map<String, HotSheetDetail> details = ((HotSheet) command).getDetails();
                Set<String> keys = details.keySet();
                for (String aKey : keys) {
                    HotSheetDetail aDetail = details.get(aKey);
                    Integer quantity = aDetail.getAttributeValue();
                    if (quantity != null && quantity < 0) {
                        errors.rejectValue("details",
                                           "quantity.notNegative",
                                           new Object[]{aDetail.getName()},
                                           "Quantity cannot be negative.");
                    }
                    else if (quantity == null) {
                        errors.rejectValue("details",
                                           "quantity.notBlank",
                                           new Object[]{aDetail.getName()},
                                           "Quantity cannot be blank.");
                    }

                }
            }
        }});
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView create(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map parameters = request.getParameterMap();
        String requestId = getParameter(parameters, "requestId");

        if (requestId == null) {
            String message = "No incoming requestId found";
            return new ModelAndView("error", "error", message);
        }

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);

        Long userId = (long) credentials.getUserId();
        HotSheet hotSheet = hotSheetService.buildHotSheet(requestId, userId);

        Map<String, HotSheetDetail> details = hotSheetService.getHotSheetDetails(userId);
        hotSheet.setDetails(details);

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        return view;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView save(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        //In either event, we need these
        hotSheetService.addOriginAddressInfo(hotSheet);

        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            view.getModel().put(HOT_SHEET, hotSheet);
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put("errors", errors);
            return view;
        }

        saveHotsheet(request, hotSheet);

        //Hot Sheet screen is saved into IMS_NEW.HOTSHEETS table.  Hot Sheet screen remains on browser.
        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        return view;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView show(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map parameters = request.getParameterMap();

        String hotSheetNumber = getParameter(parameters, "hotSheetNumber");
        if (hotSheetNumber == null) {
            String message = "No incoming hotsheet number found";
            return new ModelAndView("error", "error", message);
        }

        HotSheet hotSheet = hotSheetService.getHotSheet(hotSheetNumber);
        if (hotSheet == null) {
            String message = "No hotsheet found for number " + hotSheetNumber;
            return new ModelAndView("error", "error", message);
        }

        return new ModelAndView(HOTSHEET_VIEW, HOT_SHEET, hotSheet);
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView copy(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        hotSheetService.addOriginAddressInfo(hotSheet);

        // Validation and save logic from primary scenario is executed.
        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            hotSheetService.addOriginAddressInfo(hotSheet);
            view.getModel().put(HOT_SHEET, hotSheet);
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put("errors", errors);
            return view;
        }

        saveHotsheet(request, hotSheet);

        // A new Hot Sheet is then created with a Hot Sheet number greater than the one that was saved.
        // All of the fields from previous hot sheet are copied over.  The Created By and Date Created are set to the current user and today�s date.
        Integer nextNumber = hotSheetService.getNextHotSheetNumberForRequest(String.valueOf(hotSheet.getRequestId()));
        updateHotSheetIdentifier(hotSheet, nextNumber);

        hotSheet.setHotSheetId(null);
        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        hotSheet.setCreatedBy((long) credentials.getUserId());
        String createdByName = hotSheetService.getUserName((long) credentials.getUserId());

        hotSheet.setCreatedByName(createdByName);
        hotSheet.setDateCreated(new Date());

        hotSheet.setModifiedBy(null);
        hotSheet.setModifiedByName(null);
        hotSheet.setDateModified(null);

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        return view;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView printSave(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        hotSheetService.addOriginAddressInfo(hotSheet);

        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            hotSheetService.addOriginAddressInfo(hotSheet);
            view.getModel().put(HOT_SHEET, hotSheet);
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put("errors", errors);
            return view;
        }

        hotSheet.setShouldPrint(true);
        saveHotsheet(request, hotSheet);
        Long id = hotSheet.getHotSheetId();

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        return view;
    }

    public void print(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String hotSheetId = getParameter(request.getParameterMap(), "hotSheetId");

        String path = request.getSession().getServletContext().getRealPath("reports");
        ByteArrayOutputStream data = jasperReportService.generateReport(path, hotSheetId, request);
        if (data == null) {
            String message = "Could not generate a report for hotsheet id " + hotSheetId + ".";
            logger.error(message);
            return;
        }

        response.setHeader("Content-disposition", "attachment; filename=billOfLading.pdf");
        response.setContentType("application/pdf");
        ServletOutputStream output = response.getOutputStream();
        output.write(data.toByteArray());
        response.flushBuffer();
    }

    @SuppressWarnings("unchecked, unused")
    public void updateAddress(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String id = request.getParameter("jobLocationId");
            Address address = hotSheetService.getAddress(new BigDecimal(id));
            os = new OutputStreamWriter(response.getOutputStream());
            JSONObject jsonArray = JSONObject.fromObject(address);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            logger.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void addJobLocation(HttpServletRequest request, HttpServletResponse response, Address address) throws Exception {

        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        hotSheetService.addJobLocationAddress(address, (long) credentials.getUserId());

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            List<Address> addresses;
            if (address != null) {
                addresses = hotSheetService.getUpdatedOriginAddresses(address.getJobLocationCustomerId());
            }
            else {
                addresses = Collections.EMPTY_LIST;
            }

            os = new OutputStreamWriter(response.getOutputStream());
            JSONArray jsonArray = JSONArray.fromObject(addresses);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            logger.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    private void saveHotsheet(HttpServletRequest request, HotSheet hotSheet) {

        hotSheetService.convertStartTimesToMilitary(request, hotSheet);
        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        Long userId = (long) credentials.getUserId();
        hotSheet.setModifiedBy(userId);
        String modifiedByName = hotSheetService.getUserName(userId);
        hotSheet.setModifiedByName(modifiedByName);

        Date today = new Date();
        if (hotSheet.getDateCreated() == null) {

            hotSheet.setDateCreated(today);
        }
        hotSheet.setDateModified(today);
        hotSheetService.saveHotSheet(hotSheet);
    }

    private void updateHotSheetIdentifier(HotSheet hotSheet, Integer hotSheetNumber) {
        hotSheet.setHotSheetNumber(hotSheetNumber);
        String hotSheetIdentifier = hotSheet.getHotSheetIdentifier();
        int index = hotSheetIdentifier.lastIndexOf("HS");
        String substring = hotSheetIdentifier.substring(0, index + 2);
        hotSheet.setHotSheetIdentifier(substring + hotSheetNumber);
    }

    private BindingResult result;

    @Override
    protected void bind(HttpServletRequest request, Object command) throws Exception {

        if (command.getClass() == HotSheet.class) {
            String hotSheetId = request.getParameter("hotSheetId");
            Map<String, HotSheetDetail> details;
            if (hotSheetId == null || hotSheetId.trim().length() == 0) {
                details = hotSheetService.getNewHotSheetDetails();
            }
            else {
                details = hotSheetService.getExistingHotSheetDetails(hotSheetId);
            }

            ((HotSheet) command).setDetails(details);
        }

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
            object.setJobLocationAddress(new Address());
            object.setOriginAddress(new Address());
            object.setBillingAddress(new Address());
            return object;
        }
        return super.newCommandObject(clazz);
    }

    @SuppressWarnings("unused")
    public void setHotSheetService(HotSheetService hotSheetService) {
        this.hotSheetService = hotSheetService;
    }

    @SuppressWarnings("unused")
    public void setJasperReportService(JasperReportService jasperReportService) {
        this.jasperReportService = jasperReportService;
    }

    @Override
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder dataBinder) throws Exception {
        OmniCustomerDateEditor customDateEditor = new OmniCustomerDateEditor();

        // This is for the create/modify dates
        customDateEditor.addDateFormat("yyyy-MM-dd hh:mm:ss");

        // This is for the jobDate.
        customDateEditor.addDateFormat("MM/dd/yyyy");
        customDateEditor.addDateFormat("EEE MMM dd hh:mm:ss z yyyy");
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
