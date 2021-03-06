package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import com.dynamic.servicetrax.service.JasperReportService;
import com.dynamic.servicetrax.support.LoginCrediantials;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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
    private static final String EQUIPMENT_LIST = "EquipmentList";

    public HotSheetController() {

        setValidators(new Validator[]{new Validator() {
            public boolean supports(Class clazz) {
                return clazz.isAssignableFrom(HotSheet.class);
            }

            public void validate(Object command, Errors errors) {
                ValidationUtils.rejectIfEmpty(errors, "originAddressId", "", "An origin address is required");
                ValidationUtils.rejectIfEmpty(errors, "jobLocationContactId", "", "A Destination Contact is required.");
                ValidationUtils.rejectIfEmpty(errors, "originContactId", "", "An Origin Contact is required.");

                Integer jobLength = ((HotSheet) command).getJobLength();
                if (jobLength == null) {
                    errors.rejectValue("jobLength", "jobLength.required");
                }
                else if (jobLength < 0) {
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
        Long organizationId = (long) credentials.getOrganizationId();
        HotSheet hotSheet = hotSheetService.buildHotSheet(requestId, userId, organizationId);

        Map<String, HotSheetDetail> details = hotSheetService.getHotSheetDetails(userId);
        hotSheet.setDetails(details);
        hotSheet.setShouldPrint(false);

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
        return view;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView save(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        //In either event, we need these
        hotSheetService.addOriginAddressInfo(hotSheet);
        hotSheetService.addDestinationAddressInfo(hotSheet);
        hotSheetService.addOriginContactInfo(hotSheet);
        hotSheetService.addDestinationContactInfo(hotSheet);

        if (result != null && result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            view.getModel().put(HOT_SHEET, hotSheet);
            view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put("errors", errors);
            return view;
        }

        saveHotsheet(request, hotSheet);
        hotSheet.setShouldPrint(false);

        //Hot Sheet screen is saved into IMS_NEW.HOTSHEETS table.  Hot Sheet screen remains on browser.
        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
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

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);

        Long userId = (long) credentials.getUserId();
        Long organizationId = (long) credentials.getOrganizationId();
        HotSheet hotSheet = hotSheetService.getHotSheet(hotSheetNumber, userId, organizationId);
        if (hotSheet == null) {
            String message = "No hotsheet found for number " + hotSheetNumber;
            return new ModelAndView("error", "error", message);
        }

        hotSheet.setShouldPrint(false);
        ModelAndView modelAndView = new ModelAndView(HOTSHEET_VIEW, HOT_SHEET, hotSheet);
        modelAndView.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
        return modelAndView;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView copy(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        hotSheetService.addOriginAddressInfo(hotSheet);
        hotSheetService.addDestinationAddressInfo(hotSheet);
        hotSheetService.addOriginContactInfo(hotSheet);
        hotSheetService.addDestinationContactInfo(hotSheet);

        // Validation and save logic from primary scenario is executed.
        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            view.getModel().put(HOT_SHEET, hotSheet);
            view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put("errors", errors);
            return view;
        }

        saveHotsheet(request, hotSheet);

        // A new Hot Sheet is then created with a Hot Sheet number greater than the one that was saved.
        // All of the fields from previous hot sheet are copied over.  The Created By and Date Created are set to the current user and today�s date.
        Integer nextNumber = hotSheetService.getNextHotSheetNumberForRequest(String.valueOf(hotSheet.getRequestId()));
        logger.info("Next hotsheet number for " + hotSheet.getRequestId() + " should be " + nextNumber);
        hotSheetService.updateHotSheetIdentifier(hotSheet, nextNumber);

        hotSheet.setHotSheetId(null);
        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        hotSheet.setCreatedBy((long) credentials.getUserId());
        String createdByName = hotSheetService.getUserName((long) credentials.getUserId());

        hotSheet.setCreatedByName(createdByName);
        hotSheet.setDateCreated(new Date());

        hotSheet.setModifiedBy(null);
        hotSheet.setModifiedByName(null);
        hotSheet.setShouldPrint(false);
        hotSheet.setDateModified(null);

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
        return view;
    }

    @SuppressWarnings("unchecked, unused")
    public ModelAndView printSave(HttpServletRequest request, HttpServletResponse response, HotSheet hotSheet) throws Exception {

        hotSheetService.addOriginAddressInfo(hotSheet);
        hotSheetService.addDestinationAddressInfo(hotSheet);
        hotSheetService.addOriginContactInfo(hotSheet);
        hotSheetService.addDestinationContactInfo(hotSheet);

        if (result.hasErrors()) {
            ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
            view.getModel().put(HOT_SHEET, hotSheet);
            List errors = hotSheetService.buildErrors(result.getAllErrors());
            view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
            view.getModel().put("errors", errors);
            return view;
        }

        hotSheet.setShouldPrint(true);
        saveHotsheet(request, hotSheet);
        Long id = hotSheet.getHotSheetId();

        ModelAndView view = new ModelAndView(HOTSHEET_VIEW);
        view.getModel().put(HOT_SHEET, hotSheet);
        view.getModel().put(EQUIPMENT_LIST, hotSheetService.getEquipmentList());
        return view;
    }

    public void print(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String hotSheetId = getParameter(request.getParameterMap(), "hotSheetId");
        String extCustomerId = getParameter(request.getParameterMap(), "extCustomerId");

        String path = request.getSession().getServletContext().getRealPath("reports");
        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        Long organizationId = (long) credentials.getOrganizationId();
        String prefix = hotSheetService.getDbPrefixForOrganization(organizationId);
        ByteArrayOutputStream data = jasperReportService.generateReport(path, hotSheetId, extCustomerId, prefix);
        if (data == null) {
            StringBuilder message = new StringBuilder("Could not generate a report for hotsheet id ");
            message.append(hotSheetId);
            message.append(". Please check the error log. ");
            message.append(new Date());
            logger.error(message.toString());
            response.setContentType("text/plain");
            data = new ByteArrayOutputStream();
            data.write(message.toString().getBytes());
        }
        else {
            response.setHeader("Content-disposition", "attachment; filename=billOfLading.pdf");
            response.setContentType("application/pdf");
        }

        ServletOutputStream output = response.getOutputStream();
        output.write(data.toByteArray());
        response.flushBuffer();
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
