package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
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

        HotSheet hotSheet = hotSheetService.configureHotSheetProjectInfo(requestId);
        Map<String, HotSheetDetail> details = hotSheetService.getHotSheetDetails();
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

    public void setHotSheetService(HotSheetService hotSheetService) {
        this.hotSheetService = hotSheetService;
    }
}
