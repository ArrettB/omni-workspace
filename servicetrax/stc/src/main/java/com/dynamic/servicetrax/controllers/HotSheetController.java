package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.interceptors.LoginInterceptor;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import com.dynamic.servicetrax.support.LoginCrediantials;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 6:36:24 AM
 */
public class HotSheetController implements Controller, InitializingBean {

    private HotSheetService hotSheetService;


    @SuppressWarnings("unchecked")
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Map parameters = request.getParameterMap();
        String requestId = getParameter(parameters, "requestId");

        if (requestId == null) {
            String message = "No incoming requestId found";
            return new ModelAndView("error", "error", message);
        }

        HotSheet hotSheet = hotSheetService.buildHotSheet(requestId);

        LoginCrediantials credentials =
                (LoginCrediantials) request.getSession().getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
        Map<String, HotSheetDetail> details =
                hotSheetService.getHotSheetDetails((long) credentials.getUserId());
        hotSheet.setDetails(details);

        ModelAndView view = new ModelAndView("hotsheet/hotsheet");
        view.getModel().put("hotSheet", hotSheet);
        return view;
    }

    private String getParameter(Map parameters, String parameterName) {
        String[] parameter = (String[]) parameters.get(parameterName);
        if (parameter == null || parameter.length == 0) {
            return null;

        }
        return parameter[0];
    }

    public void afterPropertiesSet() throws Exception {
    }

    @SuppressWarnings("unchecked")
    public void setHotSheetService(HotSheetService hotSheetService) {
        this.hotSheetService = hotSheetService;
    }
}
