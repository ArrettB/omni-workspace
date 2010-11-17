package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.service.HotSheetServiceUtils;
import com.dynamic.servicetrax.service.HotSheetAjaxService;
import com.dynamic.servicetrax.support.LoginCrediantials;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Nov 6, 2010
 * Time: 8:54:21 AM
 */
public class HotSheetAjaxController extends MultiActionController {

    private static final Logger LOGGER = Logger.getLogger(HotSheetAjaxController.class);

    private HotSheetAjaxService hotSheetAjaxService;

    @SuppressWarnings("unchecked, unused")
    public void addOriginAddress(HttpServletRequest request, HttpServletResponse response, Address address) throws Exception {

        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        hotSheetAjaxService.addAddress(address, (long) credentials.getUserId());

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            List<Address> addresses;
            if (address != null) {
                addresses = hotSheetAjaxService.getUpdatedAddresses(address.getJobLocationCustomerId());
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
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void updateOriginAddress(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String id = request.getParameter("jobLocationId");
            Address address = HotSheetServiceUtils.getInstance().getAddress(new BigDecimal(id));
            os = new OutputStreamWriter(response.getOutputStream());
            JSONObject jsonArray = JSONObject.fromObject(address);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void addOriginContact(HttpServletRequest request, HttpServletResponse response) throws Exception {

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);

        hotSheetAjaxService.addNewOriginContact(request.getParameterMap(),
                                                (long) credentials.getUserId(),
                                                (long) credentials.getOrganizationId());

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            List<Map> contacts = hotSheetAjaxService.getOriginContacts(request.getParameterMap());

            os = new OutputStreamWriter(response.getOutputStream());
            JSONArray jsonArray = JSONArray.fromObject(contacts);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }


    @SuppressWarnings("unchecked, unused")
    public void updateOriginContact(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String id = request.getParameter("originContactId");
            Map contact = hotSheetAjaxService.getContact(new BigDecimal(id));
            os = new OutputStreamWriter(response.getOutputStream());
            JSONObject jsonArray = JSONObject.fromObject(contact);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void addDestinationAddress(HttpServletRequest request, HttpServletResponse response, Address address) throws Exception {

        LoginCrediantials credentials = (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        address.setJobLocationCustomerId(address.getEndUserId());

        // Workaround for the way IE7 handles javascript. The name attributes of the state dropdowns can't be the same because
        // IE7 treats the name attribute the same as the id attribute in the document.getElementById() in stateProvince.js
        // handleChange(country) method
        String destinationState = request.getParameter("destinationState");
        address.setState(destinationState);
        hotSheetAjaxService.addAddress(address, (long) credentials.getUserId());

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            List<Address> addresses = hotSheetAjaxService.getUpdatedAddresses(address.getEndUserId());
            os = new OutputStreamWriter(response.getOutputStream());
            JSONArray jsonArray = JSONArray.fromObject(addresses);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void updateDestinationAddress(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String id = request.getParameter("jobLocationId");
            Address address = HotSheetServiceUtils.getInstance().getAddress(new BigDecimal(id));

            List<Map> contacts = hotSheetAjaxService.getDestinationContacts(id);
            os = new OutputStreamWriter(response.getOutputStream());
            JSONArray jsonContacts = JSONArray.fromObject(contacts);
            jsonContacts.add(address);
            os.write(jsonContacts.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }

    @SuppressWarnings("unchecked, unused")
    public void addDestinationContact(HttpServletRequest request, HttpServletResponse response) throws Exception {

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);

        hotSheetAjaxService.addNewDestinationContact(request.getParameterMap(),
                                                     (long) credentials.getUserId(),
                                                     (long) credentials.getOrganizationId());

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String jobLocationAddressId = HotSheetServiceUtils.getInstance().getValue(request.getParameterMap().get("newJobLocationAddressId"));
            List<Map> contacts = hotSheetAjaxService.getDestinationContacts(jobLocationAddressId);
            os = new OutputStreamWriter(response.getOutputStream());
            JSONArray jsonArray = JSONArray.fromObject(contacts);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }


    @SuppressWarnings("unchecked, unused")
    public void updateDestinationContact(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json");
        OutputStreamWriter os = null;

        try {
            String id = request.getParameter("jobLocationContactId");
            Map contact = hotSheetAjaxService.getContact(new BigDecimal(id));
            os = new OutputStreamWriter(response.getOutputStream());
            JSONObject jsonArray = JSONObject.fromObject(contact);
            os.write(jsonArray.toString());
            os.flush();
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (os != null) {
                os.close();
            }
        }
    }


    public void setHotSheetAjaxService(HotSheetAjaxService hotSheetAjaxService) {
        this.hotSheetAjaxService = hotSheetAjaxService;
    }
}
